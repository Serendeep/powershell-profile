# Ensure posh-git and oh-my-posh are loaded only if they are going to be used
if ($env:POSH_THEMES_PATH) {
    Import-Module posh-git
    oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\1_shell.omp.json" | Invoke-Expression
}

# Import Terminal-Icons if available
if (Get-Module -ListAvailable -Name Terminal-Icons) {
    Import-Module -Name Terminal-Icons
}


# Chocolatey profile helper, load only if Chocolatey is installed
if (Test-Path "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1") {
    Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
}

# PSReadLine configurations
Set-PSReadLineOption -PredictionSource History -HistorySearchCursorMovesToEnd -Colors @{ InlinePrediction = '#898c5b' }
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key RightArrow -ScriptBlock {
    param($key, $arg)
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    if ($cursor -lt $line.Length) {
        [Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar($key, $arg)
    } else {
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptNextSuggestionWord($key, $arg)
    }
}
Set-PSReadLineKeyHandler -Key End -ScriptBlock {
    param($key, $arg)
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    if ($cursor -lt $line.Length) {
        [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine($key, $arg)
    } else {
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion($key, $arg)
    }
}

# Functions

<#
.SYNOPSIS
Reloads the current PowerShell profile.

.DESCRIPTION
This function reloads the current PowerShell profile script without needing to restart the shell. It is useful when you make changes to the profile and want them to take effect immediately.

.EXAMPLE
Refresh-Profile

# This will reload the profile script and apply any changes.
#>

function Refresh-Profile {
    . $PROFILE
    Write-Host "PowerShell profile reloaded successfully."
}

<#
.SYNOPSIS
Fetches your public IP address.

.DESCRIPTION
This function sends a request to an external service (ipinfo.io) and retrieves the current public IP address of the system.

.EXAMPLE
Get-PublicIP

# This will display your public IP address.
#>

function Get-PublicIP {
    $response = Invoke-RestMethod -Uri 'http://ipinfo.io/json'
    Write-Output "Your public IP is: $($response.ip)"
}

<#
.SYNOPSIS
Displays network interface information.

.DESCRIPTION
This function retrieves information about all network interfaces on the system, including their IP addresses and DNS servers.

.EXAMPLE
Get-NetworkInfo

# This will display details about network interfaces.
#>

function Get-NetworkInfo {
    Get-NetIPConfiguration | Select-Object InterfaceIndex, InterfaceAlias, IPv4Address, IPv6Address, DNSClientServerAddress
}

<#
.SYNOPSIS
Tests network connectivity to a specified target host.
.DESCRIPTION
This function uses the Test-Connection cmdlet to ping a target host (default: 8.8.8.8) three times.
.PARAMETER TargetHost
The host or IP address to test network connectivity to. Defaults to 8.8.8.8 (Google DNS).
.EXAMPLE
Test-NetworkConnectivity -TargetHost "example.com"

    # This will ping example.com three times and display the results.
#>

function Test-NetworkConnectivity {
    param (
        [string]$TargetHost = "8.8.8.8"
    )
    Test-Connection -ComputerName $TargetHost -Count 3 | Format-Table -AutoSize
}

<#
.SYNOPSIS
Lists all listening TCP ports on the system.

.DESCRIPTION
This function retrieves all TCP connections in the "Listen" state and displays the local address and port in a sorted table.

.EXAMPLE
Get-ListeningPorts

# This will display a table of all listening TCP ports.
#>

function Get-ListeningPorts {
    Get-NetTCPConnection | Where-Object { $_.State -eq "Listen" } | Select-Object LocalAddress, LocalPort | Sort-Object LocalPort | Format-Table -AutoSize
}

<#
.SYNOPSIS
Displays the system uptime.

.DESCRIPTION
This function calculates the time the system has been up since its last boot by retrieving the last boot-up time from the operating system.

.EXAMPLE
Get-SystemUptime

# This will display the uptime in days, hours, and minutes.
#>

function Get-SystemUptime {
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    $lastBootUpTime = $os.LastBootUpTime
    $uptime = (Get-Date) - $lastBootUpTime
    Write-Output "System has been up for: $($uptime.Days) days, $($uptime.Hours) hours, $($uptime.Minutes) minutes."
}

<#
.SYNOPSIS
Displays the current CPU usage.

.DESCRIPTION
This function retrieves the total percentage of CPU usage using performance counters.

.EXAMPLE
Get-CpuLoad

# This will display the CPU load as a percentage.
#>

function Get-CpuLoad {
    $cpuLoad = Get-Counter '\Processor(_Total)\% Processor Time'
    Write-Output "CPU Load: $($cpuLoad.CounterSamples.CookedValue.ToString('F2'))%"
}

<#
.SYNOPSIS
Clears all temporary files.

.DESCRIPTION
This function clears all files in the system's temporary directory. Useful for freeing up space and cleaning up the environment.

.EXAMPLE
Clear-TempFiles

# This will delete all temporary files and display a confirmation message.
#>

function Clear-TempFiles {
    $tempPath = [System.IO.Path]::GetTempPath()
    Remove-Item "$tempPath\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Output "Temporary files cleared."
}

<#
.SYNOPSIS
Exports a list of installed programs to a CSV file.

.DESCRIPTION
This function retrieves all installed programs on the system and exports the name, version, and vendor information to a CSV file on the Desktop.

.EXAMPLE
Export-InstalledPrograms

# This will create a CSV file on the Desktop with a list of installed programs.
#>


function Export-InstalledPrograms {
    $installedApps = Get-WmiObject -Class Win32_Product | Select-Object Name, Version, Vendor
    $installedApps | Export-Csv -Path "$env:USERPROFILE\Desktop\InstalledPrograms.csv" -NoTypeInformation
    Write-Output "Installed programs list exported to Desktop."
}

<#
.SYNOPSIS
Displays disk usage for all file system drives.

.DESCRIPTION
This function retrieves information about the used and free space on all file system drives and displays it in a formatted table.

.EXAMPLE
Get-DiskUsage

# This will display a table with used, free, and total space for each drive.
#>

function Get-DiskUsage {
    Get-PSDrive -PSProvider 'FileSystem' |
    Select-Object Name, @{Name="Used (GB)"; Expression={"{0:N2}" -f (($_.Used / 1GB))}},
                  @{Name="Free (GB)"; Expression={"{0:N2}" -f (($_.Free / 1GB))}},
                  @{Name="Total (GB)"; Expression={"{0:N2}" -f (($_.Used + $_.Free) / 1GB)}} |
    Format-Table -AutoSize
}

<#
.SYNOPSIS
Displays basic system information.

.DESCRIPTION
This function retrieves and displays key system information such as the computer name, operating system, and architecture in a formatted list.

.EXAMPLE
Show-SystemInfo

# This will display a detailed list of system information.
#>

function Show-SystemInfo {
    $info = Get-ComputerInfo | Select-Object CsName, OsName, OsArchitecture, OsHardwareAbstractionLayer, WindowsProductName, WindowsEditionId, WindowsVersion, OsBuildType
    $info | Format-List
}

<#
.SYNOPSIS
Repairs network connectivity by resetting the IP stack.

.DESCRIPTION
This function resets the IP stack, renews the IP address, and flushes the DNS cache. It is useful for troubleshooting network issues.

.EXAMPLE
Repair-Network

# This will reset the IP stack and flush DNS.
#>

function Repair-Network {
    Write-Output "Resetting IP Stack..."
    ipconfig /release
    ipconfig /renew
    ipconfig /flushdns
    Write-Output "Network reset commands executed. Please check your connectivity."
}

<#
.SYNOPSIS
Restarts the current PowerShell session.

.DESCRIPTION
This function starts a new PowerShell session and terminates the current one. It's useful when changes to the profile or environment variables require a fresh session.

.EXAMPLE
Restart-PowerShell

# This will close the current window and open a new PowerShell session.
#>
function Restart-PowerShell {
    Write-Output "Restarting PowerShell..."
    Start-Process "pwsh" -ArgumentList "-NoExit" # For PowerShell Core (pwsh)
    # Uncomment the following line for Windows PowerShell
    # Start-Process "powershell" -ArgumentList "-NoExit"
    Stop-Process -Id $PID
}


function Show-Help {
    $helpText = @"
Available Commands:

1. `Restart-PowerShell` - Restarts the PowerShell session.
2. `Refresh-Profile` - Reloads the current PowerShell profile.
3. `Get-PublicIP` - Fetches your public IP address.
4. `Get-NetworkInfo` - Displays detailed network information.
5. `Test-NetworkConnectivity` - Tests network connectivity to a specified target (default: 8.8.8.8).
6. `Get-ListeningPorts` - Shows currently listening TCP ports.
7. `Get-SystemUptime` - Displays system uptime.
8. `Get-CpuLoad` - Displays CPU usage.
9. `Clear-TempFiles` - Clears temporary files.
10. `Export-InstalledPrograms` - Exports a list of installed programs to a CSV file on the Desktop.
11. `Get-DiskUsage` - Shows disk usage for all available file system drives.
12. `Show-SystemInfo` - Shows basic system information.
13. `Repair-Network` - Resets the IP stack and flushes DNS.
14. `Restart-PowerShell` - Restarts the PowerShell session.
15. `Show-Help` - Displays this help menu.

Use `Get-Help` followed by a function name for more details on any function.
"@
    Write-Output $helpText
}


# Alias
Set-Alias -Name ci -Value code-insiders
Set-Alias -Name refreshprofile -Value Refresh-Profile

# On Load
Get-SystemUptime
Write-Output "Enter Show-Help to get a list of available functions"
