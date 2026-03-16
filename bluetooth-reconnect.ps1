# Requires Run as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script requires Administrator privileges to enable/disable devices."
    Write-Warning "Please restart PowerShell as Administrator and try again."
    Pause
    exit
}

# Default device name if none provided
$DefaultDeviceName = "ULT FIELD 1"

# Use the provided argument or the default
$DeviceName = if ($args.Count -gt 0) { $args[0] } else { $DefaultDeviceName }

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " Bluetooth Reconnect Utility (Windows) " -ForegroundColor Cyan
Write-Host " Target Device: '$DeviceName'" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# 1. Find the Bluetooth device by its Friendly Name
Write-Host "Looking for '$DeviceName'..."
$Device = Get-PnpDevice -FriendlyName "*$DeviceName*" -Class "Bluetooth" -ErrorAction SilentlyContinue

if (-not $Device) {
    Write-Error "Error: Device '$DeviceName' not found. Make sure it is paired."
    exit
}

# If multiple devices match, take the first one (usually the main controller)
if ($Device.Count -gt 1) {
    Write-Host "Multiple matches found, selecting the first one." -ForegroundColor Yellow
    $Device = $Device[0]
}

Write-Host "Found '$($Device.FriendlyName)' (Status: $($Device.Status))" -ForegroundColor Green

# 2. Disconnect the device by disabling its PnP interface
Write-Host "Disconnecting (Disabling PnP Device)..." -ForegroundColor Yellow
$Device | Disable-PnpDevice -Confirm:$false

# 3. Wait to ensure the device fully processes the disconnection
Write-Host "Waiting to ensure disconnection is processed..."
Start-Sleep -Seconds 5

# 4. Reconnect the device by enabling its PnP interface
Write-Host "Reconnecting (Enabling PnP Device)..." -ForegroundColor Yellow
$Device | Enable-PnpDevice -Confirm:$false

# Wait a moment for Windows to re-establish the Bluetooth link
Start-Sleep -Seconds 3

# Verify final status
$UpdatedDevice = Get-PnpDevice -InstanceId $Device.InstanceId
Write-Host "Done! Current Status: $($UpdatedDevice.Status)" -ForegroundColor Green
