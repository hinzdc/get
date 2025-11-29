# Complete Network Reset for Windows 11
# Requires running as Administrator

Write-Host "=== AURORA Network Reset Utility ===" -ForegroundColor Cyan
Write-Host "Resetting all network settings, please wait..." -ForegroundColor Yellow

# 1. Stop critical services
Write-Host "Stopping network-related services..."
Stop-Service -Name Dhcp -Force -ErrorAction SilentlyContinue
Stop-Service -Name Dnscache -Force -ErrorAction SilentlyContinue
Stop-Service -Name Netman -Force -ErrorAction SilentlyContinue
Stop-Service -Name NlaSvc -Force -ErrorAction SilentlyContinue

# 2. Reset Winsock
Write-Host "Resetting Winsock..."
netsh winsock reset

# 3. Reset TCP/IP stack
Write-Host "Resetting TCP/IP stack..."
netsh int ip reset

# 4. Clear DNS cache
Write-Host "Flushing DNS cache..."
ipconfig /flushdns

# 5. Release/Renew DHCP
Write-Host "Renewing IP configuration..."
ipconfig /release
ipconfig /renew

# 6. Remove proxy configuration
Write-Host "Clearing proxy settings..."
netsh winhttp reset proxy

# 7. Disable all network adapters temporarily (Wi-Fi & Ethernet)
Write-Host "Disabling all network adapters..."
Get-NetAdapter | Where-Object { $_.Status -eq 'Up' } | Disable-NetAdapter -Confirm:$false

Start-Sleep -Seconds 3

# 8. Re-enable adapters
Write-Host "Re-enabling all network adapters..."
Get-NetAdapter | Enable-NetAdapter -Confirm:$false

# 9. (Optional) Force reinstall drivers
#    This step uninstalls and reinstalls Wi-Fi/LAN drivers automatically
#    Use carefully: Windows will redetect and reinstall on reboot
Write-Host "Forcing driver reinstallation (Wi-Fi & LAN)..."
$adapters = Get-NetAdapter | Where-Object { $_.Status -ne 'Disabled' }
foreach ($adapter in $adapters) {
    Write-Host "Removing device: $($adapter.Name)"
    pnputil /remove-device *$($adapter.PNPDeviceID)* | Out-Null
}

# 10. Restart services
Write-Host "Restarting network services..."
Start-Service -Name Dhcp -ErrorAction SilentlyContinue
Start-Service -Name Dnscache -ErrorAction SilentlyContinue
Start-Service -Name Netman -ErrorAction SilentlyContinue
Start-Service -Name NlaSvc -ErrorAction SilentlyContinue

# 11. Optional cleanup: reset firewall
Write-Host "Resetting Windows Firewall rules..."
netsh advfirewall reset

Write-Host "`nAll network components have been reset."
Write-Host "Please restart your computer to complete the reset." -ForegroundColor Green
# Uncomment to auto reboot:
# Restart-Computer -Force
