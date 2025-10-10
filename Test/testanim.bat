<# ::
@echo off
title // REMOVE APPX - AuroraTOOLKIT - HINZDC X SARGA
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

cls && color 08
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (set "DEL=%%a")
<nul set /p=""
echo.
call :PainText 0D "                              A"
call :PainText 0D " U"
call :PainText 0D " R"
call :PainText 0D " O"
call :PainText 0D " R"
call :PainText 0D " A"
call :PainText 03 "    T"
call :PainText 03 " O"
call :PainText 03 " O"
call :PainText 03 " L"
call :PainText 0C " K"
call :PainText 0C " I"
call :PainText 0C " T"
timeout /t 5 >nul
rem cls
echo.
echo.
call :PainText 03 "                  P"
call :PainText 03 " o"
call :PainText 03 " w"
call :PainText 03 " e"
call :PainText 03 " r"
call :PainText 03 " e"
call :PainText 03 " d"
call :PainText 0f "   b"
call :PainText 0f " y"
call :PainText 0C "   S"
call :PainText 0C " A"
call :PainText 0C " R"
call :PainText 0C " G"
call :PainText 0C " A"
call :PainText 0f "   X"
call :PainText 02 "   H"
call :PainText 02 " I"
call :PainText 02 " N"
call :PainText 02 " Z"
call :PainText 02 " D"
call :PainText 02 " C"
timeout /t 1 >nul
rem cls
echo.
echo.
call :PainText 0c "                S"
call :PainText 0c " A"
call :PainText 0c " L"
call :PainText 0c " A"
call :PainText 0c " M"
call :PainText 0c "  S"
call :PainText 0c " U"
call :PainText 0c " K"
call :PainText 0c " S"
call :PainText 0c " E"
call :PainText 0c " S"
call :PainText 02 "  D"
call :PainText 02 " A"
call :PainText 02 " N"
call :PainText 09 "  S"
call :PainText 09 " E"
call :PainText 09 " H"
call :PainText 09 " A"
call :PainText 09 " T"
call :PainText 09 "  S"
call :PainText 09 " E"
call :PainText 09 " L"
call :PainText 09 " A"
call :PainText 09 " L"
call :PainText 09 " U"
timeout /t 3 >nul
echo.
echo.
call :PainText 03 "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
timeout /t 1 >nul
echo.
echo.
call :PainText 02 "   E"
call :PainText 02 " X"
call :PainText 02 " E"
call :PainText 02 " C"
call :PainText 02 " U"
call :PainText 02 " T"
call :PainText 02 " E"
call :PainText 09 "   C"
call :PainText 09 " O"
call :PainText 09 " D"
call :PainText 09 " E"
echo  ^> ^>^>
echo.
echo.
echo    ^> powershell -c iex ((Get-Content '% ~f0') -join [Environment]::Newline); iex 'main %*'
timeout /t 2 >nul
echo.
goto :end
:PainText
<nul set /p "=%DEL%" > "%~2"
findstr /v /a:%1 /R "+" "%~2" nul
del "%~2" > nul
goto :eof
:end

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
$Host.UI.RawUI.WindowTitle = '> REMOVE APPX - AuroraTOOLKIT - HINZDC X SARGA'

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
Write-Host "                             ----- REMOVE DEFAULT APPX  -----" -ForegroundColor $randomColor2
Write-Host
Write-Host "------------------------------------------------------------------------------------------"
Write-Host "   SERVICE - SPAREPART - UPGRADE - MAINTENANCE - INSTALL ULANG - JUAL - TROUBLESHOOTING   " -ForegroundColor Red
Write-Host "------------------------------------------------------------------------------------------"


Write-Host " PRESS " -NoNewLine
Write-Host " ENTER " -NoNewLine -BackgroundColor red -ForegroundColor white
Write-Host " TO EXIT:" -NoNewLine
Read-Host
#-----------------------------------------------------------------------------------------


# Membuka jendela CMD dan mengeksekusi perintah taskkill
Start-Process cmd.exe -ArgumentList '/c timeout /t 1 & taskkill /F /IM rundll32.exe /T'