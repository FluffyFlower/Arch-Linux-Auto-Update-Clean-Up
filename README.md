# Arch-Linux-Auto-Update-Clean-Up
This project provides a suite of scripts to automate system updates and maintenance on Arch Linux. The scripts included in this repository streamline the update process and ensure your system remains up-to-date with minimal manual intervention.

## Components

- **`update-launcher.sh`**: Manages the execution of update checks, either on a schedule or upon login.
- **`notify-desktop.sh`**: Sends desktop notifications to inform users about the status of system updates and other related actions.
- **`update-and-cleanup.sh`**: Performs system updates, keyring updates, package cache cleanup, and orphaned package removal. It also schedules a system reboot after the update process is complete.

## Features

- Automated updates and maintenance.
- Desktop notifications for various stages of the update process.
- Cleanup of package cache and orphaned packages.
- Scheduled reboot after updates.

## Installation
Download and Unzip:

1. Download the **[release.zip](https://github.com/FluffyFlower/Arch-Linux-Auto-Update-Clean-Up/releases/tag/Maintenance)** file.

2. Unzip the file into your home directory. This will create a .helper-scripts folder at /home/your-username/.helper-scripts.

### Configure Paths:

1. Open the .desktop file located in /home/your-username/.helper-scripts/auto-update/Resources/ with a text editor.
2. Verify and adjust the paths in the .desktop file to ensure they correctly point to the location of your scripts and icons. Ensure that the Exec path is correct and points to update-launcher.sh.

### Add to Autostart:

1. Open your system settings.
2. Navigate to the “Autostart” section.
3. Add the .desktop file to the list of startup applications. This ensures that update-launcher.sh will run automatically when you log in.

### *Optional Configuration:*

If you prefer to run the update script only at login rather than on a regular schedule, edit update-launcher.sh:
1. Open update-launcher.sh in a text editor.
2. Comment out or remove the auto-check function call if you do not want periodic updates.
3. Uncomment or add the on-login function call if you want to perform updates only when you log in.

### Set Executable Permissions:

Ensure all scripts have executable permissions. Run the following commands in your terminal:
```
chmod +x /home/your-username/.helper-scripts/auto-update/update-launcher.sh
chmod +x /home/your-username/.helper-scripts/auto-update/Resources/Scripts/update-and-cleanup.sh
```

Optionally, you can run the update-launcher.sh script manually to verify it functions as expected:
Either double click the .desktop file, or run the following in a terminal:
```
/home/your-username/.helper-scripts/auto-update/Resources/Scripts/update-launcher.sh
```
## Notes:

- You will need to edit the `sudoers` file in `/etc/`, instructions below:
  1. Open a terminal
  ```
  cd /etc
  sudo nano
  ```
  2. Open the sudoers file using ctrl + R, and typing in **sudoers**
  3. Add the following to the end of your sudoers file:
  ```
  yourusername ALL=(ALL) NOPASSWD: /usr/bin/pacman, /usr/bin/paccache, /usr/bin/paru
  ```
- Ensure you have the required permissions and dependencies installed on your system for the scripts to function correctly.
- Review and edit any script configurations as needed to tailor the setup to your specific environment and preferences.
- This project uses kdialog, due to this it is KDE focused.

License
This project is licensed under the MIT License. See the LICENSE file for details.
