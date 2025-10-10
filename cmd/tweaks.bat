<# ::
@echo off
title // TWEAKS - AuroraTOOLKIT - HINZDC X SARGA
mode con cols=90 lines=30
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

reg add "HKCU\Console" /v QuickEdit /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Console\%SystemRoot%_system32_cmd.exe" /v QuickEdit /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Console\%SystemRoot%_SysWOW64_cmd.exe" /v QuickEdit /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Console\%SystemRoot%_Sysnative_cmd.exe" /v QuickEdit /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe" /v QuickEdit /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Console\%SystemRoot%_system32_conhost.exe" /v QuickEdit /t REG_DWORD /d 0 /f >nul 2>&1

powershell -c "iex ((Get-Content '%~f0') -join [Environment]::Newline); iex 'main %*'"
goto :eof

#>

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
# Ambil handle jendela aktif (foreground window)
Add-Type -Name Win32 -Namespace Win32Functions -MemberDefinition @"
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll")]
    public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

    [DllImport("user32.dll")]
    public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);

    public struct RECT {
        public int Left;
        public int Top;
        public int Right;
        public int Bottom;
    }
"@

$hwnd = [Win32Functions.Win32]::GetForegroundWindow()

if ($hwnd -eq [IntPtr]::Zero) {
    return
}

# Ambil ukuran jendela
$rect = New-Object Win32Functions.Win32+RECT
[Win32Functions.Win32]::GetWindowRect($hwnd, [ref]$rect) | Out-Null
$w = $rect.Right - $rect.Left
$h = $rect.Bottom - $rect.Top

# Pindahkan jendela ke posisi baru tanpa mengubah ukuran
[Win32Functions.Win32]::MoveWindow($hwnd, 50, 10, $w, $h, $true)

#-----------------------------------------------------------------------------------------
$Host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size(90, 30)
$Host.UI.RawUI.WindowTitle = '> TWEAKS - AuroraTOOLKIT - HINZDC X SARGA'

cls
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
Write-Host $text -ForegroundColor $randomColor
Write-Host "                               ----- REGISTRY TWEAKS -----" -ForegroundColor $randomColor2
Write-Host
Write-Host "------------------------------------------------------------------------------------------"
Write-Host "   SERVICE - SPAREPART - UPGRADE - MAINTENANCE - INSTALL ULANG - JUAL - TROUBLESHOOTING   " -ForegroundColor Red
Write-Host "------------------------------------------------------------------------------------------"

#region Embedded Tweak Data
$embeddedTweaks = @{
    "Main" = @(
        @{ Name = 'Align Taskbar Left'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"TaskbarAl"=dword:00000000
"@ },
        @{ Name = 'Combine MMTaskbar Always'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"MMTaskbarGlomLevel"=dword:00000000
"@ },
        @{ Name = 'Combine MMTaskbar Never'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"MMTaskbarGlomLevel"=dword:00000002
"@ },
        @{ Name = 'Combine MMTaskbar When Full'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"MMTaskbarGlomLevel"=dword:00000001
"@ },
        @{ Name = 'Combine Taskbar Always'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"TaskbarGlomLevel"=dword:00000000
"@ },
        @{ Name = 'Combine Taskbar Never'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"TaskbarGlomLevel"=dword:00000002
"@ },
        @{ Name = 'Combine Taskbar When Full'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"TaskbarGlomLevel"=dword:00000001
"@ },
        @{ Name = 'Disable AI Recall'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\WindowsAI]
"DisableAIDataAnalysis"=dword:00000001

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsAI]
"DisableAIDataAnalysis"=dword:00000001

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsAI]
"AllowRecallEnablement"=dword:00000000

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsAI]
"TurnOffSavingSnapshots"=dword:00000001
"@ },
        @{ Name = 'Disable Animations'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Control Panel\Desktop]
"UserPreferencesMask"=hex:90,12,07,80,10,00,00,00

[HKEY_CURRENT_USER\Control Panel\Desktop]
"AnimationDuration"=dword:00000000

[HKEY_CURRENT_USER\Control Panel\Desktop]
"MinAnimate"="0"

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\AnimateMinMax]
"DefaultApplied"=dword:00000000

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Dwm]
"ForceDisableModeChangeAnimation"=dword:00000001
"@ },
        @{ Name = 'Disable Bing Cortana In Search'; Content = @"
Windows Registry Editor Version 5.00

; Disable Bing in search
[HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer]
"DisableSearchBoxSuggestions"=dword:00000001

; Disable Cortana in search
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search]
"AllowCortana"=dword:00000000
"CortanaConsent"=dword:00000000
"@ },
        @{ Name = 'Disable Chat Taskbar'; Content = @"
Windows Registry Editor Version 5.00

; Windows 11
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"TaskbarMn"=dword:00000000

; Windows 10
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer]
"HideSCAMeetNow"=dword:00000001
"@ },
        @{ Name = 'Disable Click to Do'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\WindowsAI]
"DisableClickToDo"=dword:00000001

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsAI]
"DisableClickToDo"=dword:00000001
"@ },
        @{ Name = 'Disable Copilot'; Content = @"
Windows Registry Editor Version 5.00

; Disable Copilot button on taskbar
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"ShowCopilotButton"=dword:00000000

; Disable Copilot service for current user
[HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\WindowsCopilot]
"TurnOffWindowsCopilot"=dword:00000001

; Disable Copilot service for all users
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot]
"TurnOffWindowsCopilot"=dword:00000001
"@ },
        @{ Name = 'Disable Desktop Spotlight'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\CloudContent]
"DisableSpotlightCollectionOnDesktop"=dword:00000001
"@ },
        @{ Name = 'Disable DVR'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\System\GameConfigStore]
"GameDVR_Enabled"=dword:00000000

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\GameDVR]
"AllowGameDVR"=dword:00000000
"@ },
        @{ Name = 'Disable Edge Ads And Suggestions'; Content = @"
Windows Registry Editor Version 5.00

; Disable Microsoft Edge MSN news feed, sponsored links, shopping assistant and more.
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge]
"NewTabPageContentEnabled"=dword:00000000
"NewTabPageHideDefaultTopSites"=dword:00000001
"EdgeShoppingAssistantEnabled"=dword:00000000
"TabServicesEnabled"=dword:00000000
"AlternateErrorPagesEnabled"=dword:00000000
"@ },
        @{ Name = 'Disable Edge AI Features'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge]
"CopilotCDPPageContext"=dword:00000000
"CopilotPageContext"=dword:00000000
"HubsSidebarEnabled"=dword:00000000
"EdgeEntraCopilotPageContext"=dword:00000000
"EdgeHistoryAISearchEnabled"=dword:00000000
"ComposeInlineEnabled"=dword:00000000
"GenAILocalFoundationalModelSettings"=dword:00000001
"NewTabPageBingChatEnabled"=dword:00000000
"@ },
        @{ Name = 'Disable Enhance Pointer Precision'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Control Panel\Mouse]
"MouseSpeed"="0"
"MouseThreshold1"="0"
"MouseThreshold2"="0"
"@ },
        @{ Name = 'Disable Fast Startup'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power]
"HiberbootEnabled"=dword:00000000
"@ },
        @{ Name = 'Disable Give access to context menu'; Content = @"
Windows Registry Editor Version 5.00

[-HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers\Sharing]

[-HKEY_CLASSES_ROOT\Directory\Background\shellex\ContextMenuHandlers\Sharing]

[-HKEY_CLASSES_ROOT\Directory\shellex\ContextMenuHandlers\Sharing]

[-HKEY_CLASSES_ROOT\Directory\shellex\CopyHookHandlers\Sharing]

[-HKEY_CLASSES_ROOT\Directory\shellex\PropertySheetHandlers\Sharing]

[-HKEY_CLASSES_ROOT\Drive\shellex\ContextMenuHandlers\Sharing]

[-HKEY_CLASSES_ROOT\Drive\shellex\PropertySheetHandlers\Sharing]

[-HKEY_CLASSES_ROOT\LibraryFolder\background\shellex\ContextMenuHandlers\Sharing]

[-HKEY_CLASSES_ROOT\UserLibraryFolder\shellex\ContextMenuHandlers\Sharing]
"@ },
        @{ Name = 'Disable Include in library from context menu'; Content = @"
Windows Registry Editor Version 5.00

[-HKEY_CLASSES_ROOT\Folder\ShellEx\ContextMenuHandlers\Library Location]

[-HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Folder\ShellEx\ContextMenuHandlers\Library Location]
"@ },
        @{ Name = 'Disable Lockscreen Tips'; Content = @"
Windows Registry Editor Version 5.00

; Get fun facts, tips and more from Windows and Cortana on your lock screen
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager]
"SubscribedContent-338387Enabled"=dword:00000000
"RotatingLockScreenOverlayEnabled"=dword:00000000
"@ },
        @{ Name = 'Disable Modern Standby Networking'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9]
"ACSettingIndex"=dword:00000000
"DCSettingIndex"=dword:00000000
"@ },
        @{ Name = 'Disable Notepad AI Features'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\WindowsNotepad]
"DisableAIFeatures"=dword:00000001
"@ },
        @{ Name = 'Disable Paint AI Features'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Paint]
"DisableCocreator"=dword:00000001
"DisableGenerativeFill"=dword:00000001
"DisableImageCreator"=dword:00000001
"DisableGenerativeErase"=dword:00000001
"DisableRemoveBackground"=dword:00000001
"@ },
        @{ Name = 'Disable Phone Link In Start'; Content = @"
Windows Registry Editor Version 5.00

; Disable Show mobile device in Start
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Start\Companions\Microsoft.YourPhone_8wekyb3d8bbwe]
"IsEnabled"=dword:00000000
"@ },
        @{ Name = 'Disable Settings 365 Ads'; Content = @"
Windows Registry Editor Version 5.00

; Disable MS 365 Ads in Settings Home
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CloudContent]
"DisableConsumerAccountStateContent"=dword:00000001
"@ },
        @{ Name = 'Disable Settings Home'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer]
"SettingsPageVisibility"="hide:home"
"@ },
        @{ Name = 'Disable Share from context menu'; Content = @"
Windows Registry Editor Version 5.00

[-HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers\ModernSharing]
"@ },
        @{ Name = 'Disable Show More Options Context Menu'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32]
@=""
"@ },
        @{ Name = 'Disable Start Recommended'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Explorer]
"HideRecommendedSection"=dword:00000001

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\current\device\Start]
"HideRecommendedSection"=dword:00000001

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\current\device\Education]
"IsEducationEnvironment"=dword:00000001

; Change start menu layout to show more pins
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"Start_Layout"=dword:00000001
"@ },
        @{ Name = 'Disable Sticky Keys Shortcut'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Control Panel\Accessibility\StickyKeys]
"Flags"="506"
"@ },
        @{ Name = 'Disable Telemetry'; Content = @"
Windows Registry Editor Version 5.00

; Let Apps use Advertising ID for Relevant Ads in Windows 10
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo]
"Enabled"=dword:00000000

; Tailored experiences with diagnostic data for Current User
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Privacy]
"TailoredExperiencesWithDiagnosticDataEnabled"=dword:00000000

; Online Speech Recognition
[HKEY_CURRENT_USER\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy]
"HasAccepted"=dword:00000000

; Improve Inking & Typing Recognition
[HKEY_CURRENT_USER\Software\Microsoft\Input\TIPC]
"Enabled"=dword:00000000

; Inking & Typing Personalization
[HKEY_CURRENT_USER\Software\Microsoft\InputPersonalization]
"RestrictImplicitInkCollection"=dword:00000001
"RestrictImplicitTextCollection"=dword:00000001

[HKEY_CURRENT_USER\Software\Microsoft\InputPersonalization\TrainedDataStore]
"HarvestContacts"=dword:00000000

[HKEY_CURRENT_USER\Software\Microsoft\Personalization\Settings]
"AcceptedPrivacyPolicy"=dword:00000000

; Send only Required Diagnostic and Usage Data
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection]
"AllowTelemetry"=dword:00000000

; Disable Let Windows improve Start and search results by tracking app launches
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"Start_TrackProgs"=dword:00000000

; Disable Activity History
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System]
"PublishUserActivities"=dword:00000000

; Set Feedback Frequency to Never
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Siuf\Rules]
"NumberOfSIUFInPeriod"=dword:00000000
"PeriodInNanoSeconds"=-

; Disable personalization of ads, Microsoft Edge, search, news and other Microsoft services by sending browsing history, favorites and collections, usage and other browsing data to Microsoft
; Disable required and optional diagnostic data about browser usage
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge]
"PersonalizationReportingEnabled"=dword:00000000
"DiagnosticData"=dword:00000000
"@ },
        @{ Name = 'Disable Transparency'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize]
"EnableTransparency"=dword:00000000
"@ },
        @{ Name = 'Disable Widgets Service'; Content = @"
Windows Registry Editor Version 5.00

; Disable widgets service
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\default\NewsAndInterests\AllowNewsAndInterests]
"value"=dword:00000000

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Dsh]
"AllowNewsAndInterests"=dword:00000000
"@ },
        @{ Name = 'Disable Windows Suggestions'; Content = @"
Windows Registry Editor Version 5.00

; Show me the Windows welcome experience after updates and occasionally when I sign in to highlight what's new and suggested
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager]
"SubscribedContent-310093Enabled"=dword:00000000

; Occasionally show suggestions in Start
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager]
"SubscribedContent-338388Enabled"=dword:00000000
"SystemPaneSuggestionsEnabled"=dword:00000000

; Show recommendations for tips, shortcuts, new apps, and more in start
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"Start_IrisRecommendations"=dword:00000000

; Get tips, tricks, and suggestions as you use Windows
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager]
"SubscribedContent-338389Enabled"=dword:00000000
"SoftLandingEnabled"=dword:00000000

; Show me suggested content in the Settings app
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager]
"SubscribedContent-338393Enabled"=dword:00000000
"SubscribedContent-353694Enabled"=dword:00000000
"SubscribedContent-353696Enabled"=dword:00000000
"SubscribedContent-353698Enabled"=dword:00000000

; Disable Show me notifications in the Settings app
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\SystemSettings\AccountNotifications]
"EnableAccountNotifications"=dword:00000000

; Suggest ways I can finish setting up my device to get the most out of Windows
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement]
"ScoobeSystemSettingEnabled"=dword:00000000

; Sync provider ads
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"ShowSyncProviderNotifications"=dword:00000000

; Automatic Installation of Suggested Apps
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager]
"SilentInstalledAppsEnabled"=dword:00000000

; Disable "Suggested" app notifications (Ads for MS services)
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.Suggested]
"Enabled"=dword:00000000

; Disable Show me suggestions for using my mobile device with Windows (Phone Link suggestions)
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Mobility]
"OptedIn"=dword:00000000

; Disable Show account-related notifications
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"Start_AccountNotifications"=dword:00000000

; Disable Windows Backup reminder notifications
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.BackupReminder]
"Enabled"=dword:00000000
"@ },
        @{ Name = 'Enable Dark Mode'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize]
"AppsUseLightTheme"=dword:00000000
"SystemUsesLightTheme"=dword:00000000
"@ },
        @{ Name = 'Enable End Task'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings]
"TaskbarEndTask"=dword:00000001
"@ },
        @{ Name = 'Enable Last Active Click'; Content = @"
Windows Registry Editor Version 5.00

; When clicking the icon of a a running application in the taskbar (that
; currently has multiple windows open), typically a pop-up will appear showing
; the multiple windows, and you'll have to click a second time to select the
; window you want to focus on.
;
; This registry hack instead turns the icon click into a "focus on the last
; active window" action. You can click it repeatedly to cycle focus through all
; the windows open for that application.
;
; With this enabled, the pop-up window display will still show if you hover
; your mouse over the taskbar icon.

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"LastActiveClick"=dword:00000001
"@ },
        @{ Name = 'Hide 3D Objects Folder'; Content = @"
Windows Registry Editor Version 5.00

[-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}]

[-HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}]
"@ },
        @{ Name = 'Hide duplicate removable drives from navigation pane of File Explorer'; Content = @"
Windows Registry Editor Version 5.00

[-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}]
"@ },
        @{ Name = 'Hide Gallery from Explorer'; Content = @"
Windows Registry Editor Version 5.00

; Hide Gallery on Navigation Pane for current user
[HKEY_CURRENT_USER\Software\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}]
"System.IsPinnedToNameSpaceTree"=dword:00000000

; Add `Show Gallery` option to File Explorer folder options, with default set to disabled
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\NavPane\ShowGallery]
"CheckedValue"=dword:00000001
"DefaultValue"=dword:00000000
"HKeyRoot"=dword:80000001
"Id"=dword:0000000d
"RegPath"="Software\\Classes\\CLSID\\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}"
"Text"="Show Gallery"
"Type"="checkbox"
"UncheckedValue"=dword:00000000
"ValueName"="System.IsPinnedToNameSpaceTree"
"@ },
        @{ Name = 'Hide Home from Explorer'; Content = @"
Windows Registry Editor Version 5.00

; Hide Home on Navigation Pane for current user
[HKEY_CURRENT_USER\Software\Classes\CLSID\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}]
@="CLSID_MSGraphHomeFolder"
"System.IsPinnedToNameSpaceTree"=dword:00000000

; Add `Show Home` option to File Explorer folder options, with default set to disabled
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\NavPane\ShowHome]
"CheckedValue"=dword:00000001
"DefaultValue"=dword:00000000
"HKeyRoot"=dword:80000001
"Id"=dword:0000000d
"RegPath"="Software\\Classes\\CLSID\\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}"
"Text"="Show Home"
"Type"="checkbox"
"UncheckedValue"=dword:00000000
"ValueName"="System.IsPinnedToNameSpaceTree"
"@ },
        @{ Name = 'Hide Music Folder'; Content = @"
Windows Registry Editor Version 5.00

[-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}]

[-HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}]
"@ },
        @{ Name = 'Hide Onedrive Folder'; Content = @"
Windows Registry Editor Version 5.00

[-HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}]
"System.IsPinnedToNameSpaceTree"=dword:0

[-HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}]
"System.IsPinnedToNameSpaceTree"=dword:0
"@ },
        @{ Name = 'Hide Search Taskbar'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search]
"SearchboxTaskbarMode"=dword:00000000
"@ },
        @{ Name = 'Hide Taskview Taskbar'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"ShowTaskViewButton"=dword:00000000
"@ },
        @{ Name = 'Launch File Explorer To Downloads'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"LaunchTo"=dword:00000003
"@ },
        @{ Name = 'Launch File Explorer To Home'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"LaunchTo"=dword:00000002
"@ },
        @{ Name = 'Launch File Explorer To OneDrive'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"LaunchTo"=dword:00000004
"@ },
        @{ Name = 'Launch File Explorer To This PC'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"LaunchTo"=dword:00000001
"@ },
        @{ Name = 'MMTaskbarMode Active'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"MMTaskbarMode"=dword:00000002
"@ },
        @{ Name = 'MMTaskbarMode All'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"MMTaskbarMode"=dword:00000000
"@ },
        @{ Name = 'MMTaskbarMode Main Active'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"MMTaskbarMode"=dword:00000001
"@ },
        @{ Name = 'Show Extensions For Known File Types'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"HideFileExt"=dword:00000000
"@ },
        @{ Name = 'Show Hidden Folders'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"Hidden"=dword:00000001
"@ },
        @{ Name = 'Show Search Box'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search]
"SearchboxTaskbarMode"=dword:00000002
"@ },
        @{ Name = 'Show Search Icon'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search]
"SearchboxTaskbarMode"=dword:00000001
"@ },
        @{ Name = 'Show Search Icon And Label'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search]
"SearchboxTaskbarMode"=dword:00000003
"@ },
        @{ Name = 'Enable Long Path Support'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem]
"LongPathsEnabled"=dword:00000001
"@ },
        @{ Name = 'Disable Post-Update Setup Screen'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement]
"ScoobeSystemSettingEnabled"=dword:00000000
"@ }
    );
    "Sysprep" = @(
        @{ Name = 'Align Taskbar Left'; Content = @"
Windows Registry Editor Version 5.00

[hkey_users\default\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"TaskbarAl"=dword:00000000

"@ },
        @{ Name = 'Combine Taskbar Always'; Content = @"
Windows Registry Editor Version 5.00

[hkey_users\default\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"TaskbarGlomLevel"=dword:00000000
"@ },
        @{ Name = 'Combine Taskbar Never'; Content = @"
Windows Registry Editor Version 5.00

[hkey_users\default\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"TaskbarGlomLevel"=dword:00000002
"@ },
        @{ Name = 'Combine Taskbar When Full'; Content = @"
Windows Registry Editor Version 5.00

[hkey_users\default\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"TaskbarGlomLevel"=dword:00000001
"@ },
        @{ Name = 'Disable AI Recall'; Content = @"
Windows Registry Editor Version 5.00

[hkey_users\default\Software\Policies\Microsoft\Windows\WindowsAI]
"DisableAIDataAnalysis"=dword:00000001

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsAI]
"DisableAIDataAnalysis"=dword:00000001

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsAI]
"AllowRecallEnablement"=dword:00000000
"@ },
        @{ Name = 'Disable Animations'; Content = @"
Windows Registry Editor Version 5.00

[hkey_users\default\Control Panel\Desktop]
"UserPreferencesMask"=hex:90,12,07,80,10,00,00,00
"@ },
        @{ Name = 'Disable Bing Cortana In Search'; Content = @"
Windows Registry Editor Version 5.00

; Disable Bing in search
[hkey_users\default\Software\Policies\Microsoft\Windows\Explorer]
"DisableSearchBoxSuggestions"=dword:00000001

; Disable Cortana in search
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search]
"AllowCortana"=dword:00000000
"CortanaConsent"=dword:00000000
"@ },
        @{ Name = 'Disable Chat Taskbar'; Content = @"
Windows Registry Editor Version 5.00

; Windows 11
[hkey_users\default\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"TaskbarMn"=dword:00000000

; Windows 10
[hkey_users\default\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer]
"HideSCAMeetNow"=dword:00000001
"@ },
        @{ Name = 'Disable Click to Do'; Content = @"
Windows Registry Editor Version 5.00

[hkey_users\default\Software\Policies\Microsoft\Windows\WindowsAI]
"DisableClickToDo"=dword:00000001

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsAI]
"DisableClickToDo"=dword:00000001
"@ },
        @{ Name = 'Disable Copilot'; Content = @"
Windows Registry Editor Version 5.00

; Disable Copilot button on taskbar
[hkey_users\default\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"ShowCopilotButton"=dword:00000000

; Disable Copilot service for current user
[hkey_users\default\Software\Policies\Microsoft\Windows\WindowsCopilot]
"TurnOffWindowsCopilot"=dword:00000001

; Disable Copilot service for all users
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot]
"TurnOffWindowsCopilot"=dword:00000001
"@ },
        @{ Name = 'Disable Desktop Spotlight'; Content = @"
Windows Registry Editor Version 5.00

[hkey_users\default\Software\Policies\Microsoft\Windows\CloudContent]
"DisableSpotlightCollectionOnDesktop"=dword:00000001
"@ },
        @{ Name = 'Disable DVR'; Content = @"
Windows Registry Editor Version 5.00

[hkey_users\default\System\GameConfigStore]
"GameDVR_Enabled"=dword:00000000

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\GameDVR]
"AllowGameDVR"=dword:00000000
"@ },
        @{ Name = 'Disable Edge Ads And Suggestions'; Content = @"
Windows Registry Editor Version 5.00

; Disable Microsoft Edge MSN news feed, sponsored links, shopping assistant and more.
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge]
"NewTabPageContentEnabled"=dword:00000000
"NewTabPageHideDefaultTopSites"=dword:00000001
"EdgeShoppingAssistantEnabled"=dword:00000000
"TabServicesEnabled"=dword:00000000
"AlternateErrorPagesEnabled"=dword:00000000
"@ },
        @{ Name = 'Disable Edge AI Features'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge]
"CopilotCDPPageContext"=dword:00000000
"CopilotPageContext"=dword:00000000
"HubsSidebarEnabled"=dword:00000000
"EdgeEntraCopilotPageContext"=dword:00000000
"EdgeHistoryAISearchEnabled"=dword:00000000
"ComposeInlineEnabled"=dword:00000000
"GenAILocalFoundationalModelSettings"=dword:00000001
"NewTabPageBingChatEnabled"=dword:00000000
"@ },
        @{ Name = 'Disable Enhance Pointer Precision'; Content = @"
Windows Registry Editor Version 5.00

[hkey_users\default\Control Panel\Mouse]
"MouseSpeed"="0"
"MouseThreshold1"="0"
"MouseThreshold2"="0"
"@ },
        @{ Name = 'Disable Fast Startup'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power]
"HiberbootEnabled"=dword:00000000
"@ },
        @{ Name = 'Disable Give access to context menu'; Content = @"
Windows Registry Editor Version 5.00

[-HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers\Sharing]

[-HKEY_CLASSES_ROOT\Directory\Background\shellex\ContextMenuHandlers\Sharing]

[-HKEY_CLASSES_ROOT\Directory\shellex\ContextMenuHandlers\Sharing]

[-HKEY_CLASSES_ROOT\Directory\shellex\CopyHookHandlers\Sharing]

[-HKEY_CLASSES_ROOT\Directory\shellex\PropertySheetHandlers\Sharing]

[-HKEY_CLASSES_ROOT\Drive\shellex\ContextMenuHandlers\Sharing]

[-HKEY_CLASSES_ROOT\Drive\shellex\PropertySheetHandlers\Sharing]

[-HKEY_CLASSES_ROOT\LibraryFolder\background\shellex\ContextMenuHandlers\Sharing]

[-HKEY_CLASSES_ROOT\UserLibraryFolder\shellex\ContextMenuHandlers\Sharing]
"@ },
        @{ Name = 'Disable Include in library from context menu'; Content = @"
Windows Registry Editor Version 5.00

[-HKEY_CLASSES_ROOT\Folder\ShellEx\ContextMenuHandlers\Library Location]

[-HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Folder\ShellEx\ContextMenuHandlers\Library Location]
"@ },
        @{ Name = 'Disable Lockscreen Tips'; Content = @"
Windows Registry Editor Version 5.00

; Get fun facts, tips and more from Windows and Cortana on your lock screen
[hkey_users\default\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager]
"SubscribedContent-338387Enabled"=dword:00000000
"RotatingLockScreenOverlayEnabled"=dword:00000000
"@ },
        @{ Name = 'Disable Modern Standby Networking'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9]
"ACSettingIndex"=dword:00000000
"DCSettingIndex"=dword:00000000
"@ },
        @{ Name = 'Disable Notepad AI Features'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\WindowsNotepad]
"DisableAIFeatures"=dword:00000001
"@ },
        @{ Name = 'Disable Paint AI Features'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Paint]
"DisableCocreator"=dword:00000001
"DisableGenerativeFill"=dword:00000001
"DisableImageCreator"=dword:00000001
"DisableGenerativeErase"=dword:00000001
"DisableRemoveBackground"=dword:00000001
"@ },
        @{ Name = 'Disable Phone Link In Start'; Content = @"
Windows Registry Editor Version 5.00

; Disable Show mobile device in Start
[hkey_users\default\Software\Microsoft\Windows\CurrentVersion\Start\Companions\Microsoft.YourPhone_8wekyb3d8bbwe]
"IsEnabled"=dword:00000000
"@ },
        @{ Name = 'Disable Settings 365 Ads'; Content = @"
Windows Registry Editor Version 5.00

; Disable MS 365 Ads in Settings Home
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CloudContent]
"DisableConsumerAccountStateContent"=dword:00000001
"@ },
        @{ Name = 'Disable Settings Home'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer]
"SettingsPageVisibility"="hide:home"
"@ },
        @{ Name = 'Disable Share from context menu'; Content = @"
Windows Registry Editor Version 5.00

[-HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers\ModernSharing]
"@ },
        @{ Name = 'Disable Show More Options Context Menu'; Content = @"
Windows Registry Editor Version 5.00

[hkey_users\default\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce]
"RestoreWin10ContextMenu"="reg add HKCU\\Software\\Classes\\CLSID\\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\\InprocServer32 /f /ve"

[hkey_users\default\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32]
@=""
"@ },
        @{ Name = 'Disable Start Recommended'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Explorer]
"HideRecommendedSection"=dword:00000001

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\current\device\Start]
"HideRecommendedSection"=dword:00000001

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\current\device\Education]
"IsEducationEnvironment"=dword:00000001

; Change start menu layout to show more pins
[hkey_users\default\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"Start_Layout"=dword:00000001
"@ },
        @{ Name = 'Disable Sticky Keys Shortcut'; Content = @"
Windows Registry Editor Version 5.00

[hkey_users\default\Control Panel\Accessibility\StickyKeys]
"Flags"="506"
"@ },
        @{ Name = 'Disable Telemetry'; Content = @"
Windows Registry Editor Version 5.00

; Let Apps use Advertising ID for Relevant Ads in Windows 10
[hkey_users\default\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo]
"Enabled"=dword:00000000

; Tailored experiences with diagnostic data for Current User
[hkey_users\default\Software\Microsoft\Windows\CurrentVersion\Privacy]
"TailoredExperiencesWithDiagnosticDataEnabled"=dword:00000000

; Online Speech Recognition
[hkey_users\default\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy]
"HasAccepted"=dword:00000000

; Improve Inking & Typing Recognition
[hkey_users\default\Software\Microsoft\Input\TIPC]
"Enabled"=dword:00000000

; Inking & Typing Personalization
[hkey_users\default\Software\Microsoft\InputPersonalization]
"RestrictImplicitInkCollection"=dword:00000001
"RestrictImplicitTextCollection"=dword:00000001

[hkey_users\default\Software\Microsoft\InputPersonalization\TrainedDataStore]
"HarvestContacts"=dword:00000000

[hkey_users\default\Software\Microsoft\Personalization\Settings]
"AcceptedPrivacyPolicy"=dword:00000000

; Send only Required Diagnostic and Usage Data
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection]
"AllowTelemetry"=dword:00000000

; Disable Let Windows improve Start and search results by tracking app launches
[hkey_users\default\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"Start_TrackProgs"=dword:00000000

; Disable Activity History
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System]
"PublishUserActivities"=dword:00000000

; Set Feedback Frequency to Never
[hkey_users\default\SOFTWARE\Microsoft\Siuf\Rules]
"NumberOfSIUFInPeriod"=dword:00000000
"PeriodInNanoSeconds"=-

; Disable personalization of ads, Microsoft Edge, search, news and other Microsoft services by sending browsing history, favorites and collections, usage and other browsing data to Microsoft
; Disable required and optional diagnostic data about browser usage
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge]
"PersonalizationReportingEnabled"=dword:00000000
"DiagnosticData"=dword:00000000
"@ },
        @{ Name = 'Disable Post-Update Setup Screen'; Content = @"
Windows Registry Editor Version 5.00

[hkey_users\default\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement]
"ScoobeSystemSettingEnabled"=dword:00000000
"@ }
    );
    "Undo" = @(
        @{ Name = 'Align Taskbar Center'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"TaskbarAl"=-
"@ },
        @{ Name = 'Allow Edge Telemetry'; Content = @"
Windows Registry Editor Version 5.00

; Allow personalization of ads, Microsoft Edge, search, news and other Microsoft services by sending browsing history, favorites and collections, usage and other browsing data to Microsoft
; Allow sending required and optional diagnostic data about browser usage
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge]
"PersonalizationReportingEnabled"=-
"DiagnosticData"=-
"@ },
        @{ Name = 'Disable End Task'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings]
"TaskbarEndTask"=dword:00000000
"@ },
        @{ Name = 'Disable Last Active Click'; Content = @"
Windows Registry Editor Version 5.00

; This disables the last-active-click action for the taskbar.
; (Please see the `Enable_Last_Active_Click.reg` file for an
; explanation of what this undoes.)

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"LastActiveClick"=-
"@ },
        @{ Name = 'Enable Activity History'; Content = @"
Windows Registry Editor Version 5.00

; Enable Activity History
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System]
"PublishUserActivities"=-
"@ },
        @{ Name = 'Enable AI Recall'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\default\WindowsAI\DisableAIDataAnalysis]
"value"=dword:00000000

[HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\WindowsAI]
"DisableAIDataAnalysis"=-

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsAI]
"DisableAIDataAnalysis"=-

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsAI]
"AllowRecallEnablement"=-
"@ },
        @{ Name = 'Enable Animations'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Control Panel\Desktop]
"UserPreferencesMask"=hex:9e,1e,07,80,12,00,00,00
"@ },
        @{ Name = 'Enable Bing Cortana In Search'; Content = @"
Windows Registry Editor Version 5.00

; Enable Bing in search
[HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer]
"DisableSearchBoxSuggestions"=dword:00000000

; Enable Cortana in search
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search]
"AllowCortana"=-
"CortanaConsent"=-
"@ },
        @{ Name = 'Enable Chat Taskbar'; Content = @"
Windows Registry Editor Version 5.00

; Windows 11
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"TaskbarMn"=dword:00000001

; Windows 10
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer]
"HideSCAMeetNow"=dword:00000000
"@ },
        @{ Name = 'Enable Click to Do'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\WindowsAI]
"DisableClickToDo"=-

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsAI]
"DisableClickToDo"=-
"@ },
        @{ Name = 'Enable Copilot'; Content = @"
Windows Registry Editor Version 5.00

; Enable Copilot button on taskbar
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"ShowCopilotButton"=dword:00000001

; Enable Copilot service for current user
[HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\WindowsCopilot]
"TurnOffWindowsCopilot"=-

; Enable Copilot service for all users
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot]
"TurnOffWindowsCopilot"=-
"@ },
        @{ Name = 'Enable Desktop Spotlight'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\CloudContent]
"DisableSpotlightCollectionOnDesktop"=-
"@ },
        @{ Name = 'Enable DVR'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\System\GameConfigStore]
"GameDVR_Enabled"=dword:00000001

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\GameDVR]
"AllowGameDVR"=dword:00000001
"@ },
        @{ Name = 'Enable Edge Ads And Suggestions'; Content = @"
Windows Registry Editor Version 5.00

; Enable Microsoft Edge MSN news feed, sponsored links, shopping assistant and more.
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge]
"NewTabPageContentEnabled"=-
"NewTabPageHideDefaultTopSites"=-
"EdgeShoppingAssistantEnabled"=-
"TabServicesEnabled"=-
"AlternateErrorPagesEnabled"=-
"@ },
        @{ Name = 'Enable Edge AI Features'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge]
"CopilotCDPPageContext"=-
"CopilotPageContext"=-
"HubsSidebarEnabled"=-
"EdgeEntraCopilotPageContext"=-
"EdgeHistoryAISearchEnabled"=-
"ComposeInlineEnabled"=-
"GenAILocalFoundationalModelSettings"=-
"NewTabPageBingChatEnabled"=-
"@ },
        @{ Name = 'Enable Enhance Pointer Precision'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Control Panel\Mouse]
"MouseSpeed"="1"
"MouseThreshold1"="6"
"MouseThreshold2"="10"
"@ },
        @{ Name = 'Enable Fast Startup'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power]
"HiberbootEnabled"=dword:00000001
"@ },
        @{ Name = 'Enable Give access to context menu'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers\Sharing]
@="{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"

[HKEY_CLASSES_ROOT\Directory\Background\shellex\ContextMenuHandlers\Sharing]
@="{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"

[HKEY_CLASSES_ROOT\Directory\shellex\ContextMenuHandlers\Sharing]
@="{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"

[HKEY_CLASSES_ROOT\Directory\shellex\CopyHookHandlers\Sharing]
@="{40dd6e20-7c17-11ce-a804-00aa003ca9f6}"

[HKEY_CLASSES_ROOT\Directory\shellex\PropertySheetHandlers\Sharing]
@="{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"

[HKEY_CLASSES_ROOT\Drive\shellex\ContextMenuHandlers\Sharing]
@="{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"

[HKEY_CLASSES_ROOT\Drive\shellex\PropertySheetHandlers\Sharing]
@="{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"

[HKEY_CLASSES_ROOT\LibraryFolder\background\shellex\ContextMenuHandlers\Sharing]
@="{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"

[HKEY_CLASSES_ROOT\UserLibraryFolder\shellex\ContextMenuHandlers\Sharing]
@="{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer]
"NoInplaceSharing"=-

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked]
"{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"=-

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa]
"forceguest"=dword:00000000
"@ },
        @{ Name = 'Enable Include in library to context menu'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\Folder\ShellEx\ContextMenuHandlers\Library Location]
@="{3dad6c5d-2167-4cae-9914-f99e41c12cfa}"

[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Folder\ShellEx\ContextMenuHandlers\Library Location]
@="{3dad6c5d-2167-4cae-9914-f99e41c12cfa}"
"@ },
        @{ Name = 'Enable Light Mode'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize]
"AppsUseLightTheme"=dword:00000001
"SystemUsesLightTheme"=dword:00000001
"@ },
        @{ Name = 'Enable Lockscreen Tips'; Content = @"
Windows Registry Editor Version 5.00

; Get fun facts, tips and more from Windows and Cortana on your lock screen
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager]
"SubscribedContent-338387Enabled"=dword:00000001
"RotatingLockScreenOverlayEnabled"=dword:00000001
 
"@ },
        @{ Name = 'Enable Modern Standby Networking'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9]
"ACSettingIndex"=dword:00000001
"DCSettingIndex"=dword:00000001
"@ },
        @{ Name = 'Enable Notepad AI Features'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\WindowsNotepad]
"DisableAIFeatures"=-
"@ },
        @{ Name = 'Enable Paint AI Features'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Paint]
"DisableCocreator"=-
"DisableGenerativeFill"=-
"DisableImageCreator"=-
"DisableGenerativeErase"=-
"DisableRemoveBackground"=-
"@ },
        @{ Name = 'Enable Phone Link In Start'; Content = @"
Windows Registry Editor Version 5.00

; Enable Show mobile device in Start
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Start\Companions\Microsoft.YourPhone_8wekyb3d8bbwe]
"IsEnabled"=dword:00000001
"@ },
        @{ Name = 'Enable Settings 365 Ads'; Content = @"
Windows Registry Editor Version 5.00

; Enable MS 365 Ads in Settings Home
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CloudContent]
"DisableConsumerAccountStateContent"=-
"@ },
        @{ Name = 'Enable Settings Home'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer]
"SettingsPageVisibility"=-
"@ },
        @{ Name = 'Enable Share to context menu'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers\ModernSharing]
@="{e2bf9676-5f8f-435c-97eb-11607a5bedf7}"
"@ },
        @{ Name = 'Enable Start Recommended'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Explorer]
"HideRecommendedSection"=dword:00000000

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\current\device\Start]
"HideRecommendedSection"=dword:00000000

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\current\device\Education]
"IsEducationEnvironment"=dword:00000000

; Set start menu layout to default
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"Start_Layout"=dword:00000000
"@ },
        @{ Name = 'Enable Sticky Keys Shortcut'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Control Panel\Accessibility\StickyKeys]
"Flags"="510"
"@ },
        @{ Name = 'Enable Telemetry'; Content = @"
Windows Registry Editor Version 5.00

; Let Apps use Advertising ID for Relevant Ads in Windows
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo]
"Enabled"=dword:00000001

; Tailored experiences with diagnostic data
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Privacy]
"TailoredExperiencesWithDiagnosticDataEnabled"=dword:00000001

; Online Speech Recognition
[HKEY_CURRENT_USER\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy]
"HasAccepted"=dword:00000001

; Improve Inking & Typing Recognition
[HKEY_CURRENT_USER\Software\Microsoft\Input\TIPC]
"Enabled"=dword:00000001

; Inking & Typing Personalization
[HKEY_CURRENT_USER\Software\Microsoft\InputPersonalization]
"RestrictImplicitInkCollection"=-
"RestrictImplicitTextCollection"=-

[HKEY_CURRENT_USER\Software\Microsoft\InputPersonalization\TrainedDataStore]
"HarvestContacts"=dword:00000001

[HKEY_CURRENT_USER\Software\Microsoft\Personalization\Settings]
"AcceptedPrivacyPolicy"=dword:00000001

; Send Optional & Required Diagnostic and Usage Data
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack]
"ShowedToastAtLevel"=dword:00000003

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection]
"AllowTelemetry"=dword:00000003
"MaxTelemetryAllowed"=dword:00000003

; Enable Let Windows improve Start and search results by tracking app launches
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"Start_TrackProgs"=dword:00000001

; Enable Activity History
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System]
"PublishUserActivities"=-

; Set Feedback Frequency to Auto (default)
[HKEY_CURRENT_USER\Software\Microsoft\Siuf\Rules]
"NumberOfSIUFInPeriod"=-
"PeriodInNanoSeconds"=-

; Allow personalization of ads, Microsoft Edge, search, news and other Microsoft services by sending browsing history, favorites and collections, usage and other browsing data to Microsoft
; Allow sending required and optional diagnostic data about browser usage
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge]
"PersonalizationReportingEnabled"=-
"DiagnosticData"=-
"@ },
        @{ Name = 'Enable Transparency'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize]
"EnableTransparency"=dword:00000001
"@ },
        @{ Name = 'Enable W11 Style Context Menu'; Content = @"
Windows Registry Editor Version 5.00

[-HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}]

"@ },
        @{ Name = 'Enable Widgets Service'; Content = @"
Windows Registry Editor Version 5.00

; Enable widgets service
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\default\NewsAndInterests\AllowNewsAndInterests]
"value"=dword:00000001

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Dsh]
"AllowNewsAndInterests"=-
"@ },
        @{ Name = 'Enable Windows Suggestions'; Content = @"
Windows Registry Editor Version 5.00

; Show me the Windows welcome experience after updates and occasionally when I sign in to highlight what's new and suggested
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager]
"SubscribedContent-310093Enabled"=dword:00000001

; Occasionally show suggestions in Start
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager]
"SubscribedContent-338388Enabled"=dword:00000001
"SystemPaneSuggestionsEnabled"=dword:00000001

; Show recommendations for tips, shortcuts, new apps, and more in start
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"Start_IrisRecommendations"=dword:00000001

; Get tips, tricks, and suggestions as you use Windows
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager]
"SubscribedContent-338389Enabled"=dword:00000001
"SoftLandingEnabled"=dword:00000001

; Show me suggested content in the Settings app
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager]
"SubscribedContent-338393Enabled"=dword:00000001
"SubscribedContent-353694Enabled"=dword:00000001
"SubscribedContent-353696Enabled"=dword:00000001
"SubscribedContent-353698Enabled"=dword:00000001

; Enable Show me notifications in the Settings app
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\SystemSettings\AccountNotifications]
"EnableAccountNotifications"=dword:00000001

; Suggest ways I can finish setting up my device to get the most out of Windows
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement]
"ScoobeSystemSettingEnabled"=dword:00000001

; Sync provider ads
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"ShowSyncProviderNotifications"=dword:00000001

; Automatic Installation of Suggested Apps
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager]
"SilentInstalledAppsEnabled"=dword:00000001

; Enable "Suggested" app notifications (Ads for MS services)
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.Suggested]
"Enabled"=dword:00000001

; Enable Show me suggestions for using my mobile device with Windows (Phone Link suggestions)
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Mobility]
"OptedIn"=dword:00000001

; Enable Show account-related notifications
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"Start_AccountNotifications"=dword:00000001

; Enable Windows Backup reminder notifications
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.BackupReminder]
"Enabled"=dword:00000001

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsBackup]
"DisableMonitoring"=dword:00000000
"@ },
        @{ Name = 'Hide Extensions For Known File Types'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"HideFileExt"=dword:00000001
"@ },
        @{ Name = 'Hide Hidden Folders'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"Hidden"=dword:00000002
"@ },
        @{ Name = 'Show 3D Objects Folder'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}]

[HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace]
"@ },
        @{ Name = 'Show duplicate removable drives from navigation pane of File Explorer'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}]
@="Removable Drives"
"@ },
        @{ Name = 'Show Gallery in Explorer'; Content = @"
Windows Registry Editor Version 5.00

; Show Gallery on Navigation Pane for current user
[HKEY_CURRENT_USER\Software\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}]
"System.IsPinnedToNameSpaceTree"=dword:00000001

; Add `Show Gallery` option to File Explorer folder options, with default set to enabled
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\NavPane\ShowGallery]
"CheckedValue"=dword:00000001
"DefaultValue"=dword:00000001
"HKeyRoot"=dword:80000001
"Id"=dword:0000000d
"RegPath"="Software\\Classes\\CLSID\\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}"
"Text"="Show Gallery"
"Type"="checkbox"
"UncheckedValue"=dword:00000000
"ValueName"="System.IsPinnedToNameSpaceTree"
"@ },
        @{ Name = 'Show Home from Explorer'; Content = @"
Windows Registry Editor Version 5.00

; Show Home on Navigation Pane for current user
[HKEY_CURRENT_USER\Software\Classes\CLSID\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}]
@="CLSID_MSGraphHomeFolder"
"System.IsPinnedToNameSpaceTree"=dword:00000001

; Add `Show Home` option to File Explorer folder options, with default set to enabled
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\NavPane\ShowHome]
"CheckedValue"=dword:00000001
"DefaultValue"=dword:00000001
"HKeyRoot"=dword:80000001
"Id"=dword:0000000d
"RegPath"="Software\\Classes\\CLSID\\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}"
"Text"="Show Home"
"Type"="checkbox"
"UncheckedValue"=dword:00000000
"ValueName"="System.IsPinnedToNameSpaceTree"
"@ },
        @{ Name = 'Show Music Folder'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}]

[HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}]
"@ },
        @{ Name = 'Show Onedrive folder'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}]
"System.IsPinnedToNameSpaceTree"=dword:1

[HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}]
"System.IsPinnedToNameSpaceTree"=dword:1
"@ },
        @{ Name = 'Show Taskview Taskbar'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"ShowTaskViewButton"=dword:00000001
"@ },
        @{ Name = 'Disable Long Path Support'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem]
"LongPathsEnabled"=dword:00000000
"@ },
        @{ Name = 'Enable Post-Update Setup Screen'; Content = @"
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement]
"ScoobeSystemSettingEnabled"=dword:00000001
"@ }
    )
}
#endregion

# Show error if current powershell environment is limited by security policies
if ($ExecutionContext.SessionState.LanguageMode -ne "FullLanguage") {
    Write-Host "Error: This script is unable to run on your system, powershell execution is restricted by security policies" -ForegroundColor Red
    Write-Output "Press any key to exit..."
    $null = [System.Console]::ReadKey()
    Exit
}

# Function to apply a registry content
function Import-RegContent {
    param (
        [parameter(Mandatory=$true)]
        [string]$Content,
        [parameter(Mandatory=$true)]
        [string]$TweakName
    )
    
    $tempFile = New-Item -Path $env:TEMP -Name "temp_tweak.reg" -ItemType File -Force
    # Set content with Unicode encoding, which is robust for .reg files
    Set-Content -Path $tempFile.FullName -Value $Content -Encoding Unicode

    try {
        # Use Start-Process for better control and error checking
        $process = Start-Process reg -ArgumentList "import `"$($tempFile.FullName)`"" -Wait -PassThru -WindowStyle Hidden
        
        if ($process.ExitCode -eq 0) {
            Write-Host "Successfully applied tweak: $TweakName" -ForegroundColor Green
        } else {
            Write-Host "Error applying tweak '$TweakName'. Exit code: $($process.ExitCode)" -ForegroundColor Red
        }
    } catch {
        Write-Host "A script error occurred while applying '$TweakName': $_" -ForegroundColor Red
    } finally {
        Remove-Item -Path $tempFile.FullName -Force
    }
}

# Main GUI Function
function Show-TweakSelectionForm {
    [reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
    [reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null

    # Form Objects
    $form = New-Object System.Windows.Forms.Form
    $label = New-Object System.Windows.Forms.Label
    $confirmButton = New-Object System.Windows.Forms.Button
    $cancelButton = New-Object System.Windows.Forms.Button
    $selectionBox = New-Object System.Windows.Forms.CheckedListBox
    $checkUncheckAll = New-Object System.Windows.Forms.CheckBox
    $categoryComboBox = New-Object System.Windows.Forms.ComboBox

    # This will store the tweaks currently visible in the listbox
    $script:displayedTweaks = @()

    # Function to load tweaks based on selected category
    $load_Tweaks = {
        $selectedCategory = $categoryComboBox.SelectedItem
        $selectionBox.Items.Clear()
        $checkUncheckAll.Checked = $false
        $script:displayedTweaks = @()

        $tweaksToProcess = @()
        if ($selectedCategory -eq 'All') {
            # Flatten all tweaks from all categories, adding category prefix
            $embeddedTweaks.GetEnumerator() | ForEach-Object {
                $categoryName = $_.Name
                $_.Value | ForEach-Object {
                    $tweaksToProcess += [pscustomobject]@{ 
                        DisplayName = "[$categoryName] $($_.Name)"; 
                        Content = $_.Content 
                    }
                }
            }
        } else {
            # Get tweaks for a specific category
            $embeddedTweaks[$selectedCategory] | ForEach-Object {
                $tweaksToProcess += [pscustomobject]@{ 
                    DisplayName = $_.Name; 
                    Content = $_.Content 
                }
            }
        }

        # Sort and add to the displayed list and the selection box
        $script:displayedTweaks = $tweaksToProcess | Sort-Object DisplayName
        foreach ($tweak in $script:displayedTweaks) {
            $selectionBox.Items.Add($tweak.DisplayName, $false) | Out-Null
        }
    }

    # Event Handlers
    $confirmButton.Add_Click({
        $checkedItems = $selectionBox.CheckedItems
        if ($checkedItems.Count -eq 0) {
            [System.Windows.Forms.MessageBox]::Show("No tweaks selected.", "Info", "OK", "Information")
            return
        }

        $confirmation = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to apply the $($checkedItems.Count) selected tweaks? This will modify the registry.", "Confirm Changes", "YesNo", "Warning")
        if ($confirmation -eq 'Yes') {
            $form.Hide()
            Write-Host "Applying selected tweaks..." -ForegroundColor Green
            
            foreach ($item in $checkedItems) {
                # Look up the selected item in the list of currently displayed tweaks
                $tweakToApply = $script:displayedTweaks | Where-Object { $_.DisplayName -eq $item } | Select-Object -First 1
                if ($tweakToApply) {
                    Import-RegContent -Content $tweakToApply.Content -TweakName $tweakToApply.DisplayName
                }
            }

            [System.Windows.Forms.MessageBox]::Show("Finished applying tweaks. A restart may be required for all changes to take effect.", "Finished", "OK", "Information")
            $form.Close()
        }
    })

    $cancelButton.Add_Click({ $form.Close() })
    $checkUncheckAll.Add_Click({
        for ($i = 0; $i -lt $selectionBox.Items.Count; $i++) {
            $selectionBox.SetItemChecked($i, $checkUncheckAll.Checked)
        }
    })
    $categoryComboBox.add_SelectedIndexChanged($load_Tweaks)

    # Form Setup
    $form.Text = "Tweak GUI (Self-Contained)"
    $form.ClientSize = '450,450'
    $form.FormBorderStyle = 'FixedDialog'
    $form.MaximizeBox = $false
    $form.StartPosition = 'CenterScreen'

    # Controls Setup
    $label.Text = "Select a category and check the tweaks to apply:"
    $label.Location = '10,10'
    $label.AutoSize = $true
    $form.Controls.Add($label)

    $categoryComboBox.Location = '10,30'
    $categoryComboBox.Size = '180,25'
    $categoryComboBox.DropDownStyle = 'DropDownList'
    $form.Controls.Add($categoryComboBox)

    $checkUncheckAll.Text = "Check/Uncheck All"
    $checkUncheckAll.Location = '250,35'
    $checkUncheckAll.AutoSize = $true
    $form.Controls.Add($checkUncheckAll)

    $selectionBox.Location = '10,60'
    $selectionBox.Size = '430,340'
    $form.Controls.Add($selectionBox)

    $confirmButton.Text = "Apply Selected Tweaks"
    $confirmButton.Location = '10,410'
    $confirmButton.Size = '150,30'
    $form.Controls.Add($confirmButton)

    $cancelButton.Text = "Cancel"
    $cancelButton.Location = '170,410'
    $cancelButton.Size = '100,30'
    $form.Controls.Add($cancelButton)

    # Populate Categories
    $categoryComboBox.Items.Add('All') | Out-Null
    $embeddedTweaks.Keys | Sort-Object | ForEach-Object { $categoryComboBox.Items.Add($_) | Out-Null }
    $categoryComboBox.SelectedIndex = 0

    # Initial Load and Show Form
    $load_Tweaks.Invoke()
    $form.ShowDialog() | Out-Null
}

# --- Script Entry Point ---
Show-TweakSelectionForm
Write-Host " PRESS " -NoNewLine
Write-Host " ENTER " -NoNewLine -BackgroundColor red -ForegroundColor white
Write-Host " TO EXIT:" -NoNewLine
Read-Host
#-----------------------------------------------------------------------------------------

# Membuka jendela CMD dan mengeksekusi perintah taskkill
Start-Process cmd.exe -ArgumentList '/c timeout /t 1 & taskkill /F /IM rundll32.exe /T'

# encode Western(Windows 1252)
