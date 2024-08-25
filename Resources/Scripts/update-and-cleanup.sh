#!/usr/bin/env bash

# update-and-cleanup.sh
#
# Author: FluffyFlower (Martin C. Wylde)
# Date: 2024-08-25
# Version: 1.3.2
#
# This script performs system updates and cleanup tasks for an Arch Linux system.
# It updates the keyring, system packages, AUR packages, clears the package cache,
# and removes orphaned packages. Notifications are sent at different stages of the process.
# If an update has been performed within the last 24 hours, the script exits early.
#
# Licensed under the MIT License. See LICENSE file for details.
#
# Usage: ./update-and-cleanup.sh

# Date variable for log file naming
DATE=$(date +"%Y-%m-%d")

# Paths to scripts
SCRIPTS_PATH=$(realpath "$HOME/.helper-scripts/auto-update/Resources/Scripts")
NOTIFY_SCRIPT=$(realpath "$SCRIPTS_PATH/notify-desktop.sh")

# Paths to logs
LOGS_PATH=$(realpath "$HOME/.helper-scripts/auto-update/Logs")
UPDATE_LOG=$(realpath "$LOGS_PATH/update-log.txt")
KEYRING_LOG=$(realpath "$LOGS_PATH/Keyring/update-$DATE.txt")
SYSTEM_LOG=$(realpath "$LOGS_PATH/System/update-$DATE.txt")
CACHE_LOG=$(realpath "$LOGS_PATH/Cache/update-$DATE.txt")
ORPHAN_LOG=$(realpath "$LOGS_PATH/Orphans/update-$DATE.txt")

# Check if the log file exists and if the last update was within the last 24 hours
if [[ -f "$UPDATE_LOG" ]]; then
    LAST_UPDATE=$(tail -n 1 "$UPDATE_LOG" | cut -d' ' -f1,2)
    LAST_UPDATE_TIMESTAMP=$(date -d "$LAST_UPDATE" +%s)
    CURRENT_TIMESTAMP=$(date +%s)
    TIME_DIFF=$(( (CURRENT_TIMESTAMP - LAST_UPDATE_TIMESTAMP) / 3600 ))

    # If the last update was less than 24 hours ago, skip this update
    if [[ $TIME_DIFF -lt 24 ]]; then
        "$NOTIFY_SCRIPT" "overall-skip"
        exit 0
    fi
fi

# Notify the user that the update process has started
$NOTIFY_SCRIPT "overall-start"

# Update keyring with automatic confirmation
$NOTIFY_SCRIPT "keyring-update-started"
echo "***Beginning keyring update***" | tee $KEYRING_LOG
sudo pacman -Sy --needed --noconfirm archlinux-keyring 2>&1 | tee -a $KEYRING_LOG
if [[ $? -ne 0 ]]; then
    $NOTIFY_SCRIPT "keyring-update-failed"
    echo "***Keyring update failure, review errors!***" | tee -a $KEYRING_LOG
    exit 1
fi
echo "***Keyring update complete***" | tee -a $KEYRING_LOG
$NOTIFY_SCRIPT "keyring-update-completed"

# Update system packages with automatic confirmation
$NOTIFY_SCRIPT "system-update-started"
echo "***Beginning system update***" | tee $SYSTEM_LOG
echo ">>>Pacman update:" | tee -a $SYSTEM_LOG
sudo pacman -Syyu --needed --noconfirm 2>&1 | tee -a $SYSTEM_LOG
if [[ $? -ne 0 ]]; then
    $NOTIFY_SCRIPT "system-update-failed"
    echo "***System packages update failure, review errors!***" | tee -a $SYSTEM_LOG
    exit 1
fi
echo "<<<End" | tee -a $SYSTEM_LOG
echo ">>>Yay AUR Update:" | tee -a $SYSTEM_LOG
paru -Sua --needed --noconfirm 2>&1 | tee -a $SYSTEM_LOG
if [[ $? -ne 0 ]]; then
    $NOTIFY_SCRIPT "system-update-failed-aur"
    echo "***AUR packages update failure, review errors!***" | tee -a $SYSTEM_LOG
    exit 1
fi
echo "<<<End" | tee -a $SYSTEM_LOG
echo "***System update complete***" | tee -a $SYSTEM_LOG
$NOTIFY_SCRIPT "system-update-completed"

# Clear package cache (keep only the latest version)
$NOTIFY_SCRIPT "cache-cleanup-started"
echo "***Begin package cache clean-up***" | tee $CACHE_LOG
sudo paccache -rk1 2>&1 | tee -a $CACHE_LOG
echo "***Package cache clean-up complete***" | tee -a $CACHE_LOG
$NOTIFY_SCRIPT "cache-cleanup-completed"

# Remove orphaned packages
$NOTIFY_SCRIPT "orphan-removal-started"
echo "***Orphaned packages removal started***" | tee $ORPHAN_LOG
if sudo pacman -Qtdq &> /dev/null; then
    sudo pacman -Rns $(pacman -Qtdq) 2>&1 | tee -a $ORPHAN_LOG
    echo "***Orphaned packages removal complete***" | tee -a $ORPHAN_LOG
else
    echo "***No orphaned packages to remove***" | tee -a $ORPHAN_LOG
fi
$NOTIFY_SCRIPT "orphan-removal-completed"

# Notify that the update and clean-up process is complete
$NOTIFY_SCRIPT "overall-completion"

# Check if the log file exists, delete it if it does, then log the update
if [[ -f "$UPDATE_LOG" ]]; then
    rm "$UPDATE_LOG"
fi
echo "$(date +"%Y-%m-%d %H:%M:%S") - System updated and cleaned." | tee $UPDATE_LOG

# Send warning about the pending restart
kdialog --title "Update Complete" --msgbox "Update completed. The system will restart in 10 minutes!"

# Pause execution for 5 minutes
sleep 5m

# Send warning about the pending restart (5 minutes left)
$NOTIFY_SCRIPT "restart-5min"

# Pause execution for 4 minutes
sleep 4m

# Send warning about the pending restart (1 minute left)
$NOTIFY_SCRIPT "restart-1min"

# Pause execution for 1 minute
sleep 1m

# Reboot system to complete update
reboot
