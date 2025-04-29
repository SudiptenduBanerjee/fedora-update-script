# Fedora Update & Cleaner Script

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A simple yet effective Bash script to automate routine system maintenance tasks on Fedora Linux, helping you keep your system up-to-date and clean with minimal effort.

## Description

This script streamlines the process of updating your Fedora system packages and cleaning up unnecessary files left behind by package management operations. It bundles common `dnf` commands into a single, easy-to-run script, perfect for users who prefer automation or want a quick way to perform regular maintenance.

## Features

*   **System Update:** Refreshes package repositories and upgrades all installed packages to their latest versions using `dnf upgrade -y`.
*   **Orphaned Dependency Removal:** Removes packages that were installed as dependencies but are no longer required by any installed package using `dnf autoremove -y`.
*   **Package Cache Cleaning:** Cleans up cached package files, metadata, and transaction history using `dnf clean all`.
*   **Flatpak Updates:** Updates installed Flatpak applications using `flatpak update -y`.
*   **Basic Output:** Provides informative messages about the steps being performed.
*   **Non-Interactive:** Uses `-y` flags to automatically confirm actions, suitable for automated execution (use with caution).

## Prerequisites

*   **Operating System:** Fedora Linux (tested on Fedora 40, 41, 42, .......)
*   **Shell:** Bash
*   **Package Manager:** `dnf`
*   **Permissions:** `sudo` privileges are required to run system updates and cleanup commands.

## Installation

1.  **Clone the repository:**
    *OR*
2.  **Download the script:**
    Download the `fedora-update-cleaner.sh` file directly from the repository.

3.  **Make the script executable:**
    ```bash
    chmod +x fedora-update-cleaner.sh
    ```
    <!-- Make sure 'fedora-update-cleaner.sh' matches your actual script filename -->

## Usage

Run the script with `sudo` privileges:

```bash
sudo ./fedora-update-cleaner.sh
