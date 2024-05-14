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
function Refresh-Profile {
    . $PROFILE
    Write-Host "PowerShell profile reloaded successfully."
}

function Get-PublicIP {
    $response = Invoke-RestMethod -Uri 'http://ipinfo.io/json'
    Write-Output "Your public IP is: $($response.ip)"
}

function Get-NetworkInfo {
    Get-NetIPConfiguration | Select-Object InterfaceIndex, InterfaceAlias, IPv4Address, IPv6Address, DNSClientServerAddress
}

function Test-NetworkConnectivity {
    param (
        [string]$TargetHost = "8.8.8.8"
    )
    Test-Connection -ComputerName $TargetHost -Count 3 | Format-Table -AutoSize
}

function Get-ListeningPorts {
    Get-NetTCPConnection | Where-Object { $_.State -eq "Listen" } | Select-Object LocalAddress, LocalPort | Sort-Object LocalPort | Format-Table -AutoSize
}

function Get-SystemUptime {
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    $lastBootUpTime = $os.LastBootUpTime
    $uptime = (Get-Date) - $lastBootUpTime
    Write-Output "System has been up for: $($uptime.Days) days, $($uptime.Hours) hours, $($uptime.Minutes) minutes."
}

function Get-CpuLoad {
    $cpuLoad = Get-Counter '\Processor(_Total)\% Processor Time'
    Write-Output "CPU Load: $($cpuLoad.CounterSamples.CookedValue.ToString('F2'))%"
}

function Clear-TempFiles {
    $tempPath = [System.IO.Path]::GetTempPath()
    Remove-Item "$tempPath\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Output "Temporary files cleared."
}

function Export-InstalledPrograms {
    $installedApps = Get-WmiObject -Class Win32_Product | Select-Object Name, Version, Vendor
    $installedApps | Export-Csv -Path "$env:USERPROFILE\Desktop\InstalledPrograms.csv" -NoTypeInformation
    Write-Output "Installed programs list exported to Desktop."
}

function Get-DiskUsage {
    Get-PSDrive -PSProvider 'FileSystem' |
    Select-Object Name, @{Name="Used (GB)"; Expression={"{0:N2}" -f (($_.Used / 1GB))}},
                  @{Name="Free (GB)"; Expression={"{0:N2}" -f (($_.Free / 1GB))}},
                  @{Name="Total (GB)"; Expression={"{0:N2}" -f (($_.Used + $_.Free) / 1GB)}} |
    Format-Table -AutoSize
}


# Alias
Set-Alias -Name ci -Value code-insiders
Set-Alias -Name refreshprofile -Value Refresh-Profile

# On Load
Get-SystemUptime
