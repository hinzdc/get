<# ::
@echo off
title // ACTIVATOR WINDOWS + OFFICE PERMANENT - INDOJAVA ONLINE - HINZDC X SARGA
mode con cols=90 lines=27
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
echo.
echo                                                   �����������������������������ͻ
echo          ����������������������������������������Ϲ ISTANA BEC LANTAI 1 BLOK D7 �
echo          �                                        �����������������������������ѹ
echo          �   ��                                ��                               �
echo          �   �� �����۱� �������� �������      �� �������� ��     �� ��������   �
echo          �   ��       �� ��   ��� ��   ��      �� ��    �� ��     �� ��    ��   �
echo          �   �� ��    �� ��   ��� ��   �� ��   �� �������� ���   ��� ��������   �
echo          �   �� ��    �� �������� ������� ������� ��    ��    ���    ��    ��   �
echo          �                                                                      �
echo          ����������������������������������������������������������������������Ѽ
rem echo                         -- ACTIVATOR WINDOWS ^& OFFICE PERMANENT --
powershell "write-host -fore 'Red' '                        -- ACTIVATOR WINDOWS & OFFICE PERMANENT --'
echo.
echo ------------------------------------------------------------------------------------------
timeout /t 7 >NUL 2>&1
powershell -c "iex ((Get-Content '%~f0') -join [Environment]::Newline); iex 'main %*'"
goto :eof

.SYNOPSIS
This script demonstrate how to embed PowerShell in a BAT file and allow
command-line arguments.

.DESCRIPTION
The top of the script begins with <#:: which is a batch redirection direcctive
meaning that <#: will be parsed as :<# which looks like a label in a batch script
but <# is also a valid powershell comment opener.

The next line turns off echo for batch scripts but remember we're now in a PowerShell
comment block so this is meaningless when the script is loaded by PowerShell.

And the last important line is the third line which invokes powershell.exe, loading
the current script. Note also that it invokes the 'main' function in the content
so we must implement a 'main' function below. Finally, we pass %* into the main
function which is the command-line argument collection for the batch script.


#>

#-----------------------------------------------------------------------------------------
$code = @'
using System;
using System.Runtime.InteropServices;

namespace CloseButtonToggle {

 internal static class WinAPI {
   [DllImport("kernel32.dll")]
   internal static extern IntPtr GetConsoleWindow();

   [DllImport("user32.dll")]
   [return: MarshalAs(UnmanagedType.Bool)]
   internal static extern bool DeleteMenu(IntPtr hMenu,
                          uint uPosition, uint uFlags);

   [DllImport("user32.dll")]
   [return: MarshalAs(UnmanagedType.Bool)]
   internal static extern bool DrawMenuBar(IntPtr hWnd);

   [DllImport("user32.dll")]
   internal static extern IntPtr GetSystemMenu(IntPtr hWnd,
              [MarshalAs(UnmanagedType.Bool)]bool bRevert);

   const uint SC_CLOSE     = 0xf060;
   const uint MF_BYCOMMAND = 0;

   internal static void ChangeCurrentState(bool state) {
     IntPtr hMenu = GetSystemMenu(GetConsoleWindow(), state);
     DeleteMenu(hMenu, SC_CLOSE, MF_BYCOMMAND);
     DrawMenuBar(GetConsoleWindow());
   }
 }

 public static class Status {
   public static void Disable() {
     WinAPI.ChangeCurrentState(false); //its 'true' if need to enable
   }
 }
}
'@

Add-Type $code
[CloseButtonToggle.Status]::Disable()

#-----------------------------------------------------------------------------------------

$Host.UI.RawUI.WindowTitle = '// ACTIVATOR WINDOWS + OFFICE PERMANENT - INDOJAVA ONLINE - HINZDC X SARGA'
function main {
    param (
        [string[]]$Arguments
    )

    # Define valid arguments
    $validArgs = @("/HWID", "/Ohook")
    $urlArgs = @()

    foreach ($arg in $Arguments) {
        if ($validArgs -contains $arg) {
            $urlArgs += $arg
        } else {
            Write-Warning "Invalid argument: '$arg'. Valid arguments: $($validArgs -join ', ')"
        }
    }

    if ($urlArgs.Count -eq 0) {
        $url = "/HWID /Ohook"
    }

        # Combine arguments into a single string
        #    $url = $urlArgs -join " "

    $startdate = Get-Date
    Write-Host " START $startdate " -BackgroundColor White -ForegroundColor Black
    # URL dari halaman yang akan diambil
    $url = "https://vbr.nathanchung.dev/badge?page_id=hinzdc-activeauto"

    # Mengambil konten halaman web
    $response = Invoke-WebRequest -Uri $url

    # Memeriksa apakah respons berhasil
    if ($response.StatusCode -eq 200) {
        # Mengambil konten HTML dari respons
        $htmlContent = $response.Content

        # Parsing konten SVG untuk mendapatkan nilai "Visitors"
        if ($htmlContent -match '<text[^>]*>\s*(\d+)\s*<\/text>') {
            $visitorCount = $matches[1]

            # Mencetak nilai ke terminal
            $label = Write-Host " Executed " -BackgroundColor Blue -ForegroundColor White -NoNewline
            $number = Write-Host " $visitorCount " -BackgroundColor Red -ForegroundColor White -NoNewline
            $times = Write-Host " TIMES " -BackgroundColor White -ForegroundColor Black
        } else {
            Write-Output " Please Connect to Internet.."
        }
    } else {
        Write-Output "$($response.StatusCode)"
    }

    $null = $label, $number, $times

    try {
        # Retrieve script content from URL
        $scriptContent = (Invoke-WebRequest https://get.activated.win -UseBasicParsing).Content

        # Execute script block with combined arguments
        & ([ScriptBlock]::Create($scriptContent)) $url | Out-Null
        Write-Host "----------------------------"
        Write-Host
        Write-Host ">> PROSES AKTIVASI SELESAI.. SELAMAT MENGGUNAKAN.." -ForegroundColor Green
        Write-Host "     // JANGAN LUPA BAHAGIA. //" -ForegroundColor Red
        Write-Host
        Write-Host "----------------------------"
        $enddate = Get-Date
        Write-Host " END $enddate " -BackgroundColor White -ForegroundColor Black
        Write-Host "------------------------------------------------------------------------------------------"
        Write-Host " PRESS ENTER TO EXIT:" -NoNewLine
        $shell = New-Object -ComObject WScript.Shell
        # Menampilkan pesan popup
        $shell.Popup("ACTIVASI WINDOWS DAN OFFICE PERMANEN SUDAH SELESAI..", 30, "OLIH X SARGA ~// -- INDOJAVA ONLINE") | Out-Null
    } catch {
        Write-Error "An error occurred: $($_.Exception.Message)"
    } finally {
        Read-Host "PRESS ENTER TO EXIT:"
    }
}

# Membuka jendela CMD dan mengeksekusi perintah taskkill
Start-Process cmd.exe -ArgumentList '/c taskkill /F /IM rundll32.exe /T'