<# ::
@echo off
title // WINDOWS UNLOCK 2.0 - INDOJAVA ONLINE - HINZDC X SARGA
mode con cols=90 lines=29
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
rem powershell "write-host -fore 'Red' '                        -- ACTIVATOR WINDOWS & OFFICE PERMANENT --'
echo.
echo ------------------------------------------------------------------------------------------
echo    SERVICE - SPAREPART - UPGRADE - MAINTENANCE - INSTALL ULANG - JUAL - TROUBLESHOOTING
echo ------------------------------------------------------------------------------------------
timeout /t 7 >NUL 2>&1
powershell -c "iex ((Get-Content '%~f0') -join [Environment]::Newline); iex 'main %*'"
goto :eof

#>


# Membuat folder C:\temp jika belum ada
$folderPath = "C:\temp"
if (!(Test-Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath | Out-Null
    Write-Host "Folder berhasil dibuat."
} else {
    Write-Host "Folder sudah ada."
}

# Hapus file lama jika ada
$filesToDelete = @("C:\temp\TBWinPE.exe", "C:\temp\boot.wim")
foreach ($file in $filesToDelete) {
    if (Test-Path $file) {
        Remove-Item -Path $file -Force
    }
}

# Download file dari URL
$url1 = "https://github.com/hinzdc/hinzdc.github.io/raw/main/dl/TBWinPE.exe"
$url2 = "https://download1648.mediafire.com/ky6y0x2eshrgaC29IsHWZ1hbXmJ-tmsImavSPVhnBTn0rDsD4wj62XRehfis5JIbs0IWE0oWJj3_5ZXCi5VXieCdcaXevKhCMcFge2LVlYgz-l0EKKUXSWqzhEKlTre5Jh5ASWs-D22i2V718bMFTEjC4pLl4yEoQT_nEwAVRaKWsyE/4gxpjexyswwmldy/boot.wim"
$output1 = "C:\temp\TBWinPE.exe"
$output2 = "C:\temp\boot.wim"

Write-Host "Downloading Files Required..."
Invoke-WebRequest -Uri $url1 -OutFile $output1
Invoke-WebRequest -Uri $url2 -OutFile $output2

# Membuat folder backup BCD jika belum ada
$bcdBackupPath = "C:\temp\bcd_backup"
if (!(Test-Path $bcdBackupPath)) {
    New-Item -ItemType Directory -Path $bcdBackupPath | Out-Null
    Write-Host "Folder bcd_backup berhasil dibuat."
} else {
    Write-Host "Folder bcd_backup sudah ada."
}

# Backup BCD
$bcdFile = "$bcdBackupPath\BCD"
if (Test-Path $bcdFile) {
    Remove-Item -Path $bcdFile -Force
}
cmd.exe /c "bcdedit /export $bcdFile"

# Menjalankan TBWinPE.exe dengan boot.wim
Start-Process -FilePath "C:\temp\TBWinPE.exe" -ArgumentList "/bootwim C:\temp\boot.wim /quiet /force" -Wait

Exit