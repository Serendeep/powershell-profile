# PowerShell Profile

This PowerShell profile script enhances your PowerShell experience by integrating useful modules, configuring key bindings, and adding custom functions for daily tasks. It is designed to streamline your workflow by incorporating helpful utilities, command aliases, and system diagnostics tools.

## Features

### Modules

- **posh-git**: posh-git is a PowerShell module that integrates Git and PowerShell by providing Git status summary information that can be displayed in the PowerShell prompt.
- **oh-my-posh**: Provides theme capabilities for the PowerShell prompt based on a specified configuration file.
- **Terminal-Icons**: Displays file and folder icons in the terminal.
- **Chocolatey Profile**: Integrates Chocolatey's command-line package manager.

### PSReadLine Configurations

Customizes command line behavior by enabling predictive text, history search, and defining custom keybindings for more efficient navigation and editing.

- **Tab Completion**: Set to `MenuComplete`.
- **Up/Down Arrow Search**: Allows searching through command history.
- **Custom Arrow Key Behavior**: Enhances cursor and suggestion handling with right and end arrows.

### Custom Functions

#### System Utilities

- **Restart-PowerShell**: Restarts the current PowerShell session. Useful after making profile changes.
- **Refresh-Profile**: Reloads the PowerShell profile, applying any recent changes without restarting the session.
- **Get-SystemUptime**: Reports how long the system has been running since the last boot.
- **Get-CpuLoad**: Monitors CPU usage in real time.
- **Clear-TempFiles**: Clears temporary files from the system to free up disk space.
- **Get-DiskUsage**: Provides detailed information on used, free, and total space for all mounted file system drives.
- **Show-SystemInfo**: Displays basic system information such as OS details, architecture, and computer name.

#### Network Tools

- **Get-PublicIP**: Retrieves and displays your public IP address using an external service.
- **Get-NetworkInfo**: Shows detailed network configuration, including IP addresses and DNS settings.
- **Test-NetworkConnectivity**: Pings a specified host to test network connectivity (default: 8.8.8.8, Google DNS).
- **Get-ListeningPorts**: Lists all TCP ports currently in a "Listen" state, useful for diagnosing network services.
- **Repair-Network**: Resets the IP stack, renews the IP address, and flushes the DNS cache to troubleshoot network connectivity issues.

#### System Maintenance

- **Export-InstalledPrograms**: Exports a list of installed programs (name, version, vendor) to a CSV file saved on your Desktop.
- **Clear-TempFiles**: Deletes temporary files from the system, freeing up storage space.

### Aliases

Shortcuts for frequently used commands are set up for quick access:

- `ci`: Shortcut for opening Visual Studio Code Insiders (`code-insiders`).
- `refreshprofile`: Shortcut for reloading the PowerShell profile (`Refresh-Profile`).

### Custom Key Bindings

- **Tab**: Set to `MenuComplete` for enhanced auto-completion.
- **Up/Down Arrows**: Use `HistorySearchBackward` and `HistorySearchForward` for fast command search from history.
- **Right Arrow**: Accepts suggestions or moves the cursor forward depending on the position.
- **End**: Moves to the end of the line or accepts the current suggestion.

## Usage

- **Loading Modules**: Modules such as `posh-git` and `Terminal-Icons` are loaded conditionally. For example, `posh-git` will only load if the `POSH_THEMES_PATH` environment variable is set.
- **Using Functions**: Custom functions are available as soon as you start PowerShell. Simply type the function name, such as `Get-PublicIP`, to use it.
- **Profile Reload**: If you make changes to the profile, reload it without restarting PowerShell by running `refreshprofile`.
- **Restarting PowerShell**: If needed, restart PowerShell with the `Restart-PowerShell` function to apply more extensive changes.

## Installation

To use this profile script, save it in your PowerShell profile file, which is typically located at:

`C:\Users\<YourUsername>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`

If the profile file does not already exist, you can create it manually in the specified location.

## Contribution

You are welcome to fork this script, contribute new features, or improve existing ones. Please ensure that any changes are properly documented and tested for consistency.
