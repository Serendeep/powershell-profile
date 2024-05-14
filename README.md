# PowerShell Profile

This PowerShell profile script enhances your PowerShell experience by integrating useful modules, configuring key bindings, and adding custom functions for daily tasks.

## Features

### Modules

- **posh-git**: Loaded if the themes path environment variable is set, enhancing the prompt with Git status information.
- **oh-my-posh**: Provides theme capabilities for the PowerShell prompt based on a specified configuration.
- **Terminal-Icons**: Displays file and folder icons in the terminal if the module is available.
- **Chocolatey Profile**: Integrates Chocolatey's command-line package manager if it is installed.

### PSReadLine Configurations

Configures predictive text and custom keybindings for efficient command line navigation and editing.

### Custom Functions

- **Refresh-Profile**: Reloads the PowerShell profile.
- **Get-PublicIP**: Displays your public IP address.
- **Get-NetworkInfo**: Shows detailed network configuration.
- **Test-NetworkConnectivity**: Pings a target host to test internet connectivity.
- **Get-ListeningPorts**: Lists all listening TCP ports.
- **Get-SystemUptime**: Reports how long the system has been running since last boot.
- **Get-CpuLoad**: Monitors CPU load in real time.
- **Clear-TempFiles**: Clears temporary files to free up space.
- **Export-InstalledPrograms**: Exports a list of installed programs to a CSV file.
- **Get-DiskUsage**: Provides a detailed view of disk usage.

### Aliases

Shortcuts for frequently used commands are set up for quick access, such as `ci` for `code-insiders`.

## Usage

1. **Loading Modules**: Modules will load automatically based on the conditions specified in the script. For example, `posh-git` will load if the `POSH_THEMES_PATH` environment variable is set.
2. **Using Functions**: You can call any of the custom functions directly in the PowerShell terminal. For example, type `Get-PublicIP` to display your public IP address.
3. **Configuration Changes**: If you need to modify key bindings or add new functions, edit the script and reload your profile by typing `refreshprofile`.

## Installation

To use this script, place it in your PowerShell profile file, typically located at

`C:\Users\<YourUsername>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`

You may need to create the file if it does not already exist.

## Contribution

Feel free to fork this repository and contribute by adding new features or improving existing ones. Please ensure all changes are well documented and tested.

