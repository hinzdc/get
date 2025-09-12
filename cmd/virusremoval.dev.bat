<# ::
@echo off
title // ACTIVATOR WINDOWS + OFFICE PERMANENT - INDOJAVA ONLINE - HINZDC X SARGA
mode con cols=90 lines=40
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
.SYNOPSIS
    Virus Removal Tools - Remove viruses, malware, and other threats from your PC.

.DESCRIPTION
    This script provides a menu to choose from a selection of popular antivirus tools for removing viruses, malware, and other threats from your PC. The script downloads the selected antivirus tool and runs it to scan and remove any detected threats.

.NOTES
    File Name      : VirusRemovalTools.ps1
    Author         : hinzdc x sarga
    Prerequisite   : PowerShell v3.0

.LINK
    
#>

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

Clear-Host
# Pastikan encoding terminal PowerShell menggunakan UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::utf8

# ASCII Art dalam Unicode [char]
$colors = @("Cyan", "Blue", "Red", "White", "DarkRed", "DarkCyan")
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
# URL resmi antivirus portable
$antivirusList = @(
    @{ Name = "Kaspersky Virus Removal Tool (KVRT)"; URL = "https://devbuilds.s.kaspersky-labs.com/devbuilds/KVRT/latest/full/KVRT.exe"; Description = "KVRT is a stand-alone utility developed by Kaspersky Lab to detect and remove nasty viruses, Trojans, worms, spyware, adware, and rootkits."; Tip = "Untuk hasil yang lebih optimal. Klik Change Parameters lalu ceklis`n - System Driver: Scan menyeluruh pada system drive C: dimana Windows terinstall.`n - All Volumes: Membersihkan system secara menyeluruh di semua partisi namun memakan waktu lebih lama." },
    @{ Name = "ESET Online Scanner"; URL = "https://download.eset.com/com/eset/tools/online_scanner/latest/esetonlinescanner.exe"; Description = "ESET Online Scanner is a one-time use tool to remove malware from your device but does not provide real-time continuous protection."; Tip = "Aktifkan 'Detect potentially unwanted applications' di pengaturan.`n Enable ESET to detect and quarantine potentially unwanted applications" },
    @{ Name = "Norton Power Eraser"; URL = "https://www.norton.com/npe_latest"; Description = "Norton Power Eraser uses aggressive scanning technology to eliminate threats that traditional virus scanning might miss."; Tip = "Untuk hasil lebih optimal, klik 'Settings' Scan and Log setting aktifkan 'Include Rootkit Scan'." },
    @{ Name = "Trend Micro HouseCall"; URL = "https://ti-res.trendmicro.com/ti-res/hc/HousecallLauncher64.exe?utm_source=TMpt"; Description = "Trend Micro HouseCall is a free scanner that detects and cleans viruses, worms, malware, spyware, and other malicious threats."; Tip = "Untuk hasil yang lebih optimal. Klik Settings lalu pilih sesuai kebutuhan.`n - Quick Scan: Cek apakah adanya ancaman.`n - Full System Scan: Membersihkan system secara menyeluruh." },
    @{ Name = "Malwarebytes AdwCleaner"; URL = "https://adwcleaner.malwarebytes.com/adwcleaner?channel=release&_gl=1*i2yntc*_gcl_au*NDkzNzA0OC4xNzM5MTgwNTY0*_ga*MjAxNDA1NjU2Ni4xNzM5MTgwNTY0*_ga_K8KCHE3KSC*MTczOTE4MDU2NC4xLjEuMTczOTE4MDcwMC41MC4wLjA."; Description = "Aggressively targets adware, spyware, potentially unwanted programs (PUPs), and browser hijackers with technology specially engineered to remove these threats."; Tip = "Pastikan koneksi internet stabil untuk mendapatkan Database virus terbaru." },
    @{ Name = "Trellix Stinger by McAfee"; URL = "https://downloadcenter.trellix.com/products/mcafee-avert/Stinger/stinger64.exe"; Description = "Trellix Stinger detects and removes specific viruses, rootkits, and malware threats efficiently."; Tip = "Gunakan fitur 'Boot Sector Scan' untuk mendeteksi malware yang sulit dihapus.`nPada Menu Advanced -> Setting -> Ubah GTI Settings - Sensitivity ke High atau Very High" },
    @{ Name = "Emsisoft Emergency Kit"; URL = "https://dl.emsisoft.com/EmsisoftEmergencyKit.exe"; Description = "Emsisoft Emergency Kit is the ultimate free anti-malware and antivirus tool to scan, detect, and remove viruses, keyloggers, and other malware threats."; Tip = "Tips: Gunakan mode 'Custom Scan' untuk deteksi lebih mendalam." },
    @{ Name = "Microsoft Safety Scanner"; URL = "https://go.microsoft.com/fwlink/?LinkId=212732"; Description = "Microsoft Safety Scanner is a scan tool designed to find and remove malware from Windows computers."; Tip = "Unduh ulang sebelum digunakan karena memiliki masa berlaku 10 hari." },
    @{ Name = "F-Secure Online Scanner"; URL = "https://download.sp.f-secure.com/tools/F-SecureOnlineScanner.exe"; Description = "Online Scanner finds and removes viruses, malware and spyware on your Windows PC."; Tip = "Tetap Online saat Proses scan." },
    @{ Name = "Adlice Protect RogueKiller"; URL = "https://download.adlice.com/api?action=download&app=roguekiller&type=x64"; Description = "The next-generation virus killer. Remove unknown malware, stay protected. Free virus cleaner for everyone."; Tip = "Ubah scan setting lalu aktifkan Full scan Performance." },
    @{ Name = "RKill by bleepingcomputer - Discontinued"; URL = "https://download.bleepingcomputer.com/dl/d02b7b12016a48b6c808169b0c1168a2cab7bc509c46f5af183427fb7b038029/68b0b131/windows/security/security-utilities/r/rkill/rkill-unsigned.exe"; Description = "RKill is a program that was developed at BleepingComputer.com that attempts to terminate known malware processes so that your normal security software can then run and clean your computer of infections. When RKill runs it will kill malware processes and then removes incorrect executable associations and fixes policies that stop us from using certain tools. When finished it will display a log file that shows the processes that were terminated while the program was running."; Tip = "-" },
    @{ Name = "Junkware Removal Tool by Malwarebytes - Discontinued"; URL = "https://cyfuture.dl.sourceforge.net/project/junkware-removal-tool-jrt/JRT.exe?viasf=1"; Description = "Junkware Removal Tool is a security utility that searches for and removes common adware, toolbars, and potentially unwanted programs (PUPs) from your computer.  A common tactics among freeware publishers is to offer their products for free, but bundle them with PUPs in order to earn revenue.  This tool will help you remove these types of programs."; Tip = "-" }
)

# Lokasi penyimpanan sementara
$randomguid = (New-GUID).ToString().ToUpper()
$downloadPath = "$env:TEMP\VirusRemovalTool-$randomguid.exe"

# ==== SMART DOWNLOADER v2: BITS → IWR → curl, plus anti-HTML check ====
function Invoke-SmartDownload {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Url,
        [Parameter(Mandatory)][string]$OutFile,
        [int]$TimeoutSec = 1800,
        [int]$Retries = 2,
        [int]$MinBytes = 1024            # cegah file 0B/HTML nyasar
    )

    try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch {}

    $destDir = Split-Path $OutFile -ea SilentlyContinue
    if ($destDir -and !(Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }

    function Test-DownloadOkay([string]$path){
        if (!(Test-Path $path)) { return $false }
        $len = (Get-Item $path).Length
        if ($len -lt $MinBytes) { return $false }
        # baca beberapa byte pertama; kalau HTML/teks, anggap gagal
        try {
            $fs = [System.IO.File]::Open($path, 'Open', 'Read', 'ReadWrite')
            $buf = New-Object byte[] 512
            $read = $fs.Read($buf,0,$buf.Length)
            $fs.Close()
            $head = [System.Text.Encoding]::ASCII.GetString($buf,0,$read).ToLowerInvariant()
            if ($head.StartsWith('<!doctype html') -or $head.StartsWith('<html') -or $head.Contains('<title>') -or $head.Contains('</html>')) { return $false }
        } catch { return $false }
        return $true
    }

    $ok = $false
    $used = $null

    # ---------- 1) BITS ----------
    try {
        $bitsCmd = Get-Command Start-BitsTransfer -ErrorAction SilentlyContinue
        $svc = Get-Service BITS -ErrorAction SilentlyContinue
        if ($bitsCmd -and $svc) {
            if ($svc.Status -ne 'Running') { Start-Service BITS -ErrorAction Stop }
            for ($i=1; $i -le $Retries -and -not $ok; $i++) {
                Write-Host " + [BITS] Download (percobaan $i/$Retries)..." -ForegroundColor Cyan
                try {
                    if (Test-Path $OutFile) { Remove-Item $OutFile -Force -ea SilentlyContinue }
                    # catatan: beberapa CDN memblok UA BITS → biarkan gagal, nanti fallback
                    Start-BitsTransfer -Source $Url -Destination $OutFile -DisplayName "VirusRemovalTool-Downloader" -Description $name -ErrorAction Stop
                    if (Test-DownloadOkay $OutFile) { $ok=$true; $used='BITS' } else { Remove-Item $OutFile -Force -ea SilentlyContinue }
                } catch {
                    Remove-Item $OutFile -Force -ea SilentlyContinue
                    Start-Sleep -Seconds ([Math]::Min(5*$i,15))
                }
            }
        }
    } catch {}

    # ---------- 2) Invoke-WebRequest ----------
    if (-not $ok) {
        for ($i=1; $i -le $Retries -and -not $ok; $i++) {
            Write-Host " + [IWR] Download (percobaan $i/$Retries)..." -ForegroundColor Yellow
            try {
                if (Test-Path $OutFile) { Remove-Item $OutFile -Force -ea SilentlyContinue }
                $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
                $headers = @{
                    'User-Agent'      = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) VirusRemovalTool-Downloader'
                    'Accept'          = 'application/octet-stream,application/x-msdownload,*/*'
                    'Accept-Encoding' = 'identity'
                }
                Invoke-WebRequest -Uri $Url -OutFile $OutFile -WebSession $session -Headers $headers `
                    -MaximumRedirection 10 -TimeoutSec $TimeoutSec -ErrorAction Stop
                if (Test-DownloadOkay $OutFile) { $ok=$true; $used='Invoke-WebRequest' } else { Remove-Item $OutFile -Force -ea SilentlyContinue }
            } catch {
                Remove-Item $OutFile -Force -ea SilentlyContinue
                Start-Sleep -Seconds ([Math]::Min(5*$i,15))
            }
        }
    }

    # ---------- 3) Fallback terakhir: curl.exe ----------
    if (-not $ok) {
        $curl = (Get-Command curl.exe -ErrorAction SilentlyContinue).Source
        if ($curl) {
            Write-Host " + [curl] Download (plan-C)..." -ForegroundColor DarkCyan
            try {
                if (Test-Path $OutFile) { Remove-Item $OutFile -Force -ea SilentlyContinue }
                $args = @('--fail','--location','--max-redirs','10','--connect-timeout','30','--retry','3','--retry-delay','2',
                          '--user-agent','Mozilla/5.0 (Windows NT 10.0; Win64; x64) VirusRemovalTool-Downloader',
                          '--output', $OutFile, $Url)
                $p = Start-Process -FilePath $curl -ArgumentList $args -PassThru -NoNewWindow -Wait
                if ($p.ExitCode -eq 0 -and (Test-DownloadOkay $OutFile)) { $ok=$true; $used='curl.exe' } else { Remove-Item $OutFile -Force -ea SilentlyContinue }
            } catch {
                Remove-Item $OutFile -Force -ea SilentlyContinue
            }
        }
    }

    if (-not $ok) { throw "Gagal download dari: $Url (semua metode gagal atau file tidak valid)." }
    Write-Host " + Unduhan selesai via $used" -ForegroundColor Green
}

function DownloadAndRun {
    param ($name, $url, $description, $tip)

    Write-Host "------------------------------------------------------------------------------------------"
    Write-Host "$description`n"
    Write-Host " WARNING: " -BackgroundColor Red -ForegroundColor White
    Write-Host "Harap matikan Real-time Protection pada Windows Defender sebelum melakukan scan.`nAgar tidak bentrok dan mengganggu proses scan.`n" -ForegroundColor Red
    Write-Host " TIPS: " -BackgroundColor Green -ForegroundColor White
    Write-Host "$tip" -ForegroundColor Blue
    Write-Host "------------------------------------------------------------------------------------------"

    Write-Host "`n + Download antivirus..."
    try {
        Invoke-SmartDownload -Url $url -OutFile $downloadPath -TimeoutSec 3600 -Retries 3
    } catch {
        Write-Host " ! Gagal download: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "   Cek koneksi internet / proxy / firewall, lalu coba lagi." -ForegroundColor DarkYellow
        return
    }

    Write-Host " + Menjalankan antivirus..."
    Start-Process -FilePath $downloadPath -Wait

    Write-Host " + Pemindaian selesai. Silakan periksa hasilnya.`n" -ForegroundColor Green
    Remove-Item $downloadPath -Force -ErrorAction SilentlyContinue | Out-Null

    do {
        Write-Host "------------------------------------------------------------------------------------------"
        Write-Host "Tekan [A] untuk kembali ke menu utama atau [ENTER] untuk keluar."
        Write-Host "------------------------------------------------------------------------------------------"
        $response = Read-Host "Masukkan pilihan"
        if ($response -eq "A" -or $response -eq "a") {
            return
        } elseif ($response -eq "") {
            exitScript
        }
    } while ($true)
}



# Fungsi untuk keluar dan menghapus file sisa
function exitScript {
    if (Test-Path $downloadPath) {
        Remove-Item $downloadPath -Force | Out-Null
    }
    Start-Sleep -Seconds 3
    Write-Host "`n + Hapus file sementara.`n" -ForegroundColor Green
    Remove-Item -Path $downloadPath -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item -Path "$env:LOCALAPPDATA\ESET\ESETOnlineScanner" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\ESET Online Scanner.lnk" -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item -Path "$env:USERPROFILE\Desktop\ESET Online Scanner.lnk" -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item -Path "$env:LOCALAPPDATA\ESET\ESETOnlineScanner" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item -Path "C:\Program Files\Trend Micro" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Remove-Item -Path "C:\EEK" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    Write-Host "`n + Semua file sementara telah dihapus.`n" -ForegroundColor Green
    exit
}

# Looping menu utama
while ($true) {
    Clear-Host
    Write-Host $text -ForegroundColor $randomColor
    Write-Host "                                 -- VIRUS REMOVAL TOOLS --" -foreground red
    Write-Host "------------------------------------------------------------------------------------------"
    Write-Host " Virus Removal Tools - Remove viruses, malware, and other threats from your PC"
    Write-Host "------------------------------------------------------------------------------------------"
    Write-Host "Pilih Antivirus yang ingin dijalankan:`n"

    # Menampilkan menu pilihan
    for ($i = 0; $i -lt $antivirusList.Count; $i++) {
        Write-Host " $($i+1). $($antivirusList[$i].Name)"
    }
    Write-Host "------------------------------------------------------------------------------------------"
    $choice = Read-Host "Masukkan pilihan (1-$($antivirusList.Count)) Lalu tekan ENTER"

    # Jika user tekan Enter, keluar dari skrip
    if ($choice -eq "") { exitScript }

    # Memvalidasi input
    if ($choice -match "^\d+$" -and [int]$choice -ge 1 -and [int]$choice -le $antivirusList.Count) {
        $index = [int]$choice - 1
        DownloadAndRun -name $antivirusList[$index].Name -url $antivirusList[$index].URL -description $antivirusList[$index].Description -tip $antivirusList[$index].Tip
    } else {
        Write-Host "`nPilihan tidak valid. Silakan coba lagi.`n" -ForegroundColor Red
        Start-Sleep -Seconds 2
    }
}



<#
# msert.exe 201,434,752 bytes
# KVRT.exe 112,851,304 bytes
# esetonlinescanner.exe 8,415,088 bytes
# tg8y095d.exe 297,017,416 bytes
# npe.exe 16,995,528 bytes
# stinger64.exe 49,166,568 bytes
# C:\Users\AURORA\AppData\Local\ESET\ESETOnlineScanner
#Remove-Item -Path "C:\Users\AURORA\AppData\Local\ESET\ESETOnlineScanner" -Recurse -Force
#Remove-Item -Path "C:\Program Files\Trend Micro" -Recurse -Force
"C:\Users\AURORA\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\ESET Online Scanner.lnk"
#>