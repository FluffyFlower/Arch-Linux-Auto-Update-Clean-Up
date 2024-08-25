#!/usr/bin/env bash

# update-launcher.sh
#
# Author: FluffyFlower (Martin C. Wylde)
# Date: 2024-08-25
# Version: 1.1.1
#
# This script automates the process of checking for updates and running an update script.
# It contains two main functions: auto-check and on-login.
# - auto-check: Runs the update script every 36 hours in an infinite loop.
# - on-login: Runs the update script once upon login.
#
# Licensed under the MIT License. See LICENSE file for details.
#
# Usage: ./update-launcher.sh

# Paths to required scripts
SCRIPTS_PATH=$(realpath "$HOME/.helper-scripts/auto-update/Resources/Scripts")
UPDATE_SCRIPT=$(realpath "$SCRIPTS_PATH/update-and-cleanup.sh")
NOTIFY_SCRIPT=$(realpath "$SCRIPTS_PATH/notify-desktop.sh")

# Pause execution to allow other programs to finish starting
sleep 30s

# auto-check function
# This function continuously checks for updates by running the update script every 36 hours.
# It also notifies the user when the auto-check process starts.
auto-check() {
    # Notify user that it has auto-started and is running
    $NOTIFY_SCRIPT "auto-update-checker-start"

    # Pause to ensure the notification is visible
    sleep 30s

    # Infinite loop to run the update script every 36 hours
    while true; do
        # Run the update script
        bash "$UPDATE_SCRIPT"
        # Wait for 36 hours before the next update check
        sleep 36h
    done
}

# on-login function
# This function checks for updates once immediately after login.
# It also notifies the user when the process starts.
on-login() {
    # Notify user that the login update checker has started
    $NOTIFY_SCRIPT "login-update-checker-start"

    # Pause to ensure the notification is visible
    sleep 30s

    # Run the update script once
    bash "$UPDATE_SCRIPT"
}

# Start the auto-check process by default
auto-check

# To use the on-login function instead, comment out auto-check and uncomment the following line:
#on-login