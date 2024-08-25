#!/usr/bin/env bash

# notify-desktop.sh
#
# Author: FluffyFlower (Martin C. Wylde)
# Date: 2024-08-25
# Version: 1.1.1
#
# This script sends a custom desktop notification using kdialog based on the provided notification type.
# It uses predefined titles, messages, and durations for different update-related events.
#
# Licensed under the MIT License. See LICENSE file for details.
#
# Usage: ./notify-desktop.sh "notification_type" ["time"]

# Script variables
NOTIFICATION_TYPE="$1"  # The type of notification to display (e.g., "overall-start")
TIME="$2"               # Optional: Custom duration for the notification display (overrides default)

# Paths to the icon file used in notifications
ICON_PATH=$(realpath "$HOME/.helper-scripts/auto-update/Resources/Icon")
ICON_FILE=$(realpath "$ICON_PATH/auto-update-icon.png")

# Send desktop dialog based on notification type
case $NOTIFICATION_TYPE in
    "auto-update-checker-start")
        TITLE="Automatic Update Service Started"
        MESSAGE="Your system will now be checked for updates, and checks will be performed every 36 hours..."
        TIME=10
        ;;
    "login-update-checker-start")
        TITLE="Automatic Update Service Started"
        MESSAGE="Your system will now be checked for updates..."
        TIME=10
        ;;
    "overall-start")
        TITLE="Update and Clean-Up Started"
        MESSAGE="Your system is currently being updated...\n<b>DO NOT</b> power off!\nPlease ensure you are connected to mains power!"
        TIME=30
        ;;
    "keyring-update-started")
        TITLE="Keyring Update"
        MESSAGE="The Arch Linux Keyring is currently being updated..."
        TIME=5
        ;;
    "keyring-update-completed")
        TITLE="Keyring Update"
        MESSAGE="The Arch Linux Keyring has been updated!"
        TIME=5
        ;;
    "keyring-update-failed")
        TITLE="Keyring Update"
        MESSAGE="The Arch Linux Keyring failed to update, please check the log files."
        TIME=10
        ;;
    "system-update-started")
        TITLE="System Update"
        MESSAGE="Arch Linux system packages are currently being updated..."
        TIME=5
        ;;
    "system-update-completed")
        TITLE="System Update"
        MESSAGE="Arch Linux system packages have been updated!"
        TIME=5
        ;;
    "system-update-failed")
        TITLE="System Update"
        MESSAGE="Arch Linux system packages failed to be updated, please check the log files."
        TIME=10
        ;;
    "system-update-failed-aur")
        TITLE="System Update"
        MESSAGE="Arch User Repository packages failed to be updated, please check the log files."
        TIME=10
        ;;
    "cache-cleanup-started")
        TITLE="Cache Clean-Up"
        MESSAGE="Update cache is currently being purged..."
        TIME=5
        ;;
    "cache-cleanup-completed")
        TITLE="Cache Clean-Up"
        MESSAGE="Update cache has been purged!"
        TIME=5
        ;;
    "orphan-removal-started")
        TITLE="Orphan Removal"
        MESSAGE="Orphaned packages are currently being removed..."
        TIME=5
        ;;
    "orphan-removal-completed")
        TITLE="Orphan Removal"
        MESSAGE="Orphaned packages have been removed..."
        TIME=5
        ;;
    "overall-completion")
        TITLE="Update and Clean-Up Complete"
        MESSAGE="Your system has been successfully updated, and will reboot in <b>10 mins</b>..."
        TIME=30
        ;;
    "overall-skip")
        TITLE="Update and Clean-Up Skipped"
        MESSAGE="Your system was recently updated, therefore no update is necessary."
        TIME=5
        ;;
    "restart-5min")
        TITLE="Restart Upcoming"
        MESSAGE="Your system will restart in 5 minutes..."
        TIME=5
        ;;
    "restart-1min")
        TITLE="Restart Upcoming"
        MESSAGE="Your system will restart in 1 minute..."
        TIME=5
        ;;
    *)
        TITLE="An Error may have Occurred!!"
        MESSAGE="Please check the update logs!"
        TIME=5
        ;;
esac

# Construct the final command for kdialog to show the notification
FINAL_CMD="kdialog --title \"$TITLE\" --icon $ICON_FILE --passivepopup \"$MESSAGE\" $TIME"

# Execute the constructed command
eval "$FINAL_CMD"