#!/bin/bash

# Enhanced Fedora System Update, Upgrade, and Clean Script
# =========================================================
# Author: Sudiptendu Banerjee
# Description: Updates Fedora system via DNF and Flatpak, cleans cache, logs actions,
# and optionally prompts for reboot if a kernel update occurred.

set -euo pipefail

# --- Configuration ---
LOG_FILE="/var/log/fedora-update-clean.log"
exec > >(tee -a "$LOG_FILE") 2>&1

# --- Color Definitions ---
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

# --- Signal Handling ---
trap 'echo -e "${RED}✗ Script interrupted. Exiting.${NC}"; exit 1' INT TERM

# --- Root Privilege Check ---
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}✗ This script must be run as root or with sudo.${NC}"
   exit 1
fi

# --- Functions ---

print_header() {
  echo -e "${BLUE}\n=== $1 ===${NC}"
}

disk_usage() {
  echo -e "${YELLOW}Disk usage:${NC}"
  df -h /
  echo ""
}

update_metadata() {
  print_header "Updating Package Metadata"
  dnf check-update || true
}

upgrade_system() {
  print_header "Upgrading System Packages"
  dnf upgrade -y
}

cleanup_orphans() {
  print_header "Removing Orphaned Packages"
  dnf autoremove -y
}

clean_cache() {
  print_header "Cleaning DNF Cache"
  dnf clean all
}

update_flatpak() {
  if command -v flatpak &>/dev/null; then
    print_header "Updating Flatpak Packages"
    flatpak update -y
  else
    echo -e "${YELLOW}Flatpak is not installed. Skipping Flatpak updates.${NC}"
  fi
}

check_kernel_update() {
  CURRENT_KERNEL=$(uname -r)
  LATEST_KERNEL=$(rpm -q --last kernel | head -n 1 | awk '{print $1}' | sed 's/kernel-//')
  if [[ "$CURRENT_KERNEL" != "$LATEST_KERNEL" ]]; then
    echo -e "${YELLOW}A new kernel was installed (Current: $CURRENT_KERNEL, Latest: $LATEST_KERNEL).${NC}"
    return 0
  fi
  return 1
}

prompt_reboot() {
  echo ""
  read -p "Would you like to reboot now? (y/N): " REBOOT
  if [[ "$REBOOT" =~ ^[Yy]$ ]]; then
    reboot
  fi
}

# --- Main Script Execution ---

echo -e "${GREEN}✓ Starting Fedora System Update and Clean - $(date '+%Y-%m-%d %H:%M:%S')${NC}"

disk_usage
update_metadata
upgrade_system
update_flatpak
cleanup_orphans
clean_cache
disk_usage

if check_kernel_update; then
  echo -e "${YELLOW}It is recommended to reboot the system for the new kernel to take effect.${NC}"
  prompt_reboot
fi

echo -e "${GREEN}✓ System update and cleanup complete!${NC}"
echo -e "${BLUE}Log saved to: $LOG_FILE${NC}"

