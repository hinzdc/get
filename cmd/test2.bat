<# ::
@echo off
title // ACTIVATOR WINDOWS + OFFICE PERMANENT - INDOJAVA ONLINE - HINZDC X SARGA
mode con cols=90 lines=36
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
echo                                                   ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
echo          ÉÏÏÏÏÏÏÏÏÏÏÏÏÏÏÏÏÏÏÏÏÏÏÏÏÏÏÏÏÏÏÏÏÏÏÏÏÏÏÏÏ¹ ISTANA BEC LANTAI 1 BLOK D7 º
echo          º                                        ÈÑÑÑÑÑÑÑÑÑÑÑÑÑÑÑÑÑÑÑÑÑÑÑÑÑÑÑÑÑ¹
echo          º   ÛÛ                                ÛÛ                               º
echo          º   °° ÛÛÛÛÛÛ±± ÛÛÛÛÛÛÜß ÛÛÛÛÛÛÛ      °° ÛÛÛÛÛÛÛÛ ÛÛ     ÛÛ ÛÛÛÛÛÛÛÛ   º
echo          º   ÛÛ       ÛÛ ÛÛ   ßÛÛ ÛÛ   ÛÛ      ÛÛ ÛÛ    ÛÛ ÛÛ     ÛÛ ÛÛ    ÛÛ   º
echo          º   ÛÛ ÛÛ    ÛÛ ÛÛ   ÜÛÛ ÛÛ   ÛÛ ÛÛ   ÛÛ ÛÛÛÛÛÛÛÛ ßÛÛ   ÛÛß ÛÛÛÛÛÛÛÛ   º
echo          º   ÛÛ ÛÛ    ÛÛ ÛÛÛÛÛÛßÜ ±±ÛÛÛÛÛ ÛÛÛÛÛÛÛ ÛÛ    ÛÛ    ßÛß    ÛÛ    ÛÛ   º
echo          º                                                                      º
echo          ÈÑÑÑÑÑÑÑÑÑÑÑÑÑÑÑÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÑÑÑÑÑÑÑÑÑÑÑÑÑÑÑ¼
rem echo                         -- ACTIVATOR WINDOWS ^& OFFICE PERMANENT --
powershell "write-host -fore 'Red' '                        -- ACTIVATOR WINDOWS & OFFICE PERMANENT --'
echo.
echo ------------------------------------------------------------------------------------------
echo    SERVICE - SPAREPART - UPGRADE - MAINTENANCE - INSTALL ULANG - JUAL - TROUBLESHOOTING
echo ------------------------------------------------------------------------------------------
timeout /t 7 >NUL 2>&1
powershell -c "iex ((Get-Content '%~f0') -join [Environment]::Newline); iex 'main %*'"
goto :eof
#>
function ntfy {
    # URL untuk ntfy.sh
    $ntfyUrl = "https://ntfy.sh/eu9QDaPa1mExQPwp"


    # Fungsi untuk memeriksa Ohook
    function CheckOhook {
        $ohook = 0
        $paths = @("${env:ProgramFiles}", "${env:ProgramW6432}", "${env:ProgramFiles(x86)}")

        # Loop untuk memeriksa Office versi 15 dan 16
        foreach ($version in 15, 16) {
            foreach ($path in $paths) {
                if (Test-Path "$path\Microsoft Office\Office$version\sppc*.dll") {
                    $ohook = 1
                }
            }
        }

        # Loop untuk memeriksa System dan SystemX86 pada Office 15 dan Office (tanpa versi)
        foreach ($systemFolder in "System", "SystemX86") {
            foreach ($officeFolder in "Office 15", "Office") {
                foreach ($path in $paths) {
                    if (Test-Path "$path\Microsoft $officeFolder\root\vfs\$systemFolder\sppc*.dll") {
                        $ohook = 1
                    }
                }
            }
        }

        # Jika tidak ada Ohook yang ditemukan
        if ($ohook -eq 0) {
            return "Ohook tidak ditemukan."
        }

        # Jika Ohook ditemukan
        return @"
    -----------------------------------------------------
    ---------------- Office Ohook Status ----------------
    -----------------------------------------------------
    
    Ohook for permanent Office activation is installed.
    You can ignore the below mentioned Office activation status.
"@
    }

    # Gabungkan informasi perangkat dan Office ke dalam satu pesan
    $message = @"

    /// MICROSOFT OFFICE ///
    $(CheckOhook)

"@

    # Kirim pesan ke ntfy.sh
    $response = Invoke-RestMethod -Uri $ntfyUrl -Method POST -Body $message -Headers @{
        "Title" = "Aktivasi Windows dan Office"
        "Priority" = "default"
        "Tags" = "computer"
    }

    # Tampilkan hasil pengiriman
    if ($response) {
        Write-host -NoNewLine
    } else {
        Write-Host " failed sending log.." -ForegroundColor Red
    }
}

# Menjalankan fungsi ntfy
ntfy

# Tunggu input dari pengguna sebelum keluar
Read-Host "Press enter to exit"
