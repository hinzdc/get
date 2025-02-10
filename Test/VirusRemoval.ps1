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

Clear-Host
# Pastikan encoding terminal PowerShell menggunakan UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::utf8

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
                           --- VIRUS REMOVAL TOOLS ---
"@

Write-Host $text -ForegroundColor Cyan

# URL resmi antivirus portable
$antivirusList = @(
    @{ Name = "Kaspersky Virus Removal Tool (KVRT)"; URL = "https://devbuilds.s.kaspersky-labs.com/devbuilds/KVRT/latest/full/KVRT.exe"; Description = "KVRT is a stand-alone utility developed by Kaspersky Lab to detect and remove nasty viruses, Trojans, worms, spyware, adware, and rootkits."; Tip = "Untuk hasil yang lebih optimal. Klik Settings lalu pilih sesuai kebutuhan.`n - Quick Scan: Cek apakah adanya ancaman.`n - Full System Scan: Membersihkan system secara menyeluruh." },
    @{ Name = "ESET Online Scanner"; URL = "https://download.eset.com/com/eset/tools/online_scanner/latest/esetonlinescanner.exe"; Description = "ESET Online Scanner is a one-time use tool to remove malware from your device but does not provide real-time continuous protection."; Tip = "Aktifkan 'Detect potentially unwanted applications' di pengaturan." },
    @{ Name = "Norton Power Eraser"; URL = "https://www.norton.com/npe_latest"; Description = "Norton Power Eraser uses aggressive scanning technology to eliminate threats that traditional virus scanning might miss."; Tip = "Untuk hasil lebih optimal, klik 'Settings' Scan and Log setting aktifkan 'Include Rootkit Scan'." },
    @{ Name = "Trend Micro HouseCall"; URL = "https://ti-res.trendmicro.com/ti-res/hc/HousecallLauncher64.exe?utm_source=TMpt"; Description = "Trend Micro HouseCall is a free scanner that detects and cleans viruses, worms, malware, spyware, and other malicious threats."; Tip = "Tips: Pastikan koneksi internet stabil untuk mendapatkan definisi virus terbaru." },
    @{ Name = "Malwarebytes AdwCleaner"; URL = "https://adwcleaner.malwarebytes.com/adwcleaner?channel=release&_gl=1*i2yntc*_gcl_au*NDkzNzA0OC4xNzM5MTgwNTY0*_ga*MjAxNDA1NjU2Ni4xNzM5MTgwNTY0*_ga_K8KCHE3KSC*MTczOTE4MDU2NC4xLjEuMTczOTE4MDcwMC41MC4wLjA."; Description = "Aggressively targets adware, spyware, potentially unwanted programs (PUPs), and browser hijackers with technology specially engineered to remove these threats."; Tip = "Pastikan koneksi internet stabil untuk mendapatkan Database virus terbaru." },
    @{ Name = "Trellix Stinger by McAfee"; URL = "https://downloadcenter.trellix.com/products/mcafee-avert/Stinger/stinger64.exe"; Description = "Trellix Stinger detects and removes specific viruses, rootkits, and malware threats efficiently."; Tip = "Gunakan fitur 'Boot Sector Scan' untuk mendeteksi malware yang sulit dihapus.`nUbah GTI Settings - Sensitivity ke High atau Very High" },
    @{ Name = "Emsisoft Emergency Kit"; URL = "https://dl.emsisoft.com/EmsisoftEmergencyKit.exe"; Description = "Emsisoft Emergency Kit is the ultimate free anti-malware and antivirus tool to scan, detect, and remove viruses, keyloggers, and other malware threats."; Tip = "Tips: Gunakan mode 'Deep Scan' untuk deteksi lebih mendalam." },
    @{ Name = "Microsoft Safety Scanner"; URL = "https://go.microsoft.com/fwlink/?LinkId=212732"; Description = "Microsoft Safety Scanner is a scan tool designed to find and remove malware from Windows computers."; Tip = "Unduh ulang sebelum digunakan karena memiliki masa berlaku 10 hari." },
    @{ Name = "RKill by bleepingcomputer"; URL = "https://download.bleepingcomputer.com/dl/25865177774cf1415b30a76642872df3c5b3255d3a6cf1a077dcf6c0a673b9fc/67a9cf46/windows/security/security-utilities/r/rkill/rkill.exe"; Description = "RKill is a program that was developed at BleepingComputer.com that attempts to terminate known malware processes so that your normal security software can then run and clean your computer of infections. When RKill runs it will kill malware processes and then removes incorrect executable associations and fixes policies that stop us from using certain tools. When finished it will display a log file that shows the processes that were terminated while the program was running."; Tip = "-" },
    @{ Name = "F-Secure Online Scanner"; URL = "https://download.sp.f-secure.com/tools/F-SecureOnlineScanner.exe"; Description = "Online Scanner finds and removes viruses, malware and spyware on your Windows PC."; Tip = "Tetap Online saat Proses scan." },
    @{ Name = "Junkware Removal Tool"; URL = "https://download.bleepingcomputer.com/dl/83e65a9d647ec4cc405fbb0594fc92d95f800f65db15a05e073157ee9092468f/67a9e11c/windows/security/security-utilities/j/junkware-removal-tool/JRT.exe"; Description = "Junkware Removal Tool is a security utility that searches for and removes common adware, toolbars, and potentially unwanted programs (PUPs) from your computer.  A common tactics among freeware publishers is to offer their products for free, but bundle them with PUPs in order to earn revenue.  This tool will help you remove these types of programs."; Tip = "-" },
    @{ Name = "Dr.Web CureIt!"; URL = "https://cdn-download.drweb.com/pub/drweb/cureit/1739182011.825/5kacxonk.exe"; Description = "Dr.Web CureIt! is an indispensable emergency tool for scanning PCs and removing all sorts of malware."; Tip = "Tips: Setelah scan, restart PC untuk memastikan malware benar-benar dihapus." },
    @{ Name = "Adlice Protect RogueKiller"; URL = "https://download.adlice.com/api?action=download&app=roguekiller&type=x64"; Description = "The next-generation virus killer. Remove unknown malware, stay protected. Free virus cleaner for everyone."; Tip = "Ubah scan setting lalu aktifkan Full scan Performance." }
)

# Lokasi penyimpanan sementara
$randomguid = (New-GUID).ToString().ToUpper()
$downloadPath = "$env:TEMP\AntivirusScanner-$randomguid.exe"

# Fungsi untuk mengunduh dan menjalankan antivirus
function DownloadAndRun {
    param ($url, $description, $tip)

    Write-Host "--------------------------------------------------------------------------------"
    Write-Host "$description`n"
    Write-Host " WARNING: " -BackgroundColor Red -ForegroundColor White
    Write-Host "Harap matikan Real-time Protection pada Windows Defender sebelum melakukan scan.`nAgar tidak bentrok dan mengganggu proses scan.`n" -ForegroundColor Red
    Write-Host " TIPS: " -BackgroundColor Green -ForegroundColor White
    Write-Host "$tip" -ForegroundColor Blue
    Write-Host "--------------------------------------------------------------------------------"

    Write-Host "`n + Mengunduh antivirus..."
    Invoke-WebRequest -Uri $url -OutFile $downloadPath
    Write-Host " + Menjalankan antivirus..."
    Start-Process -FilePath $downloadPath -Wait

    Write-Host " + Pemindaian selesai. Silakan periksa hasilnya.`n" -ForegroundColor Green
    Remove-Item $downloadPath -Force | Out-Null

    # Menunggu input user untuk kembali atau keluar
    do {
        Write-Host "--------------------------------------------------------------------------------"
        Write-Host "Tekan [A] untuk kembali ke menu utama atau [ENTER] untuk keluar."
        Write-Host "--------------------------------------------------------------------------------"
        $response = Read-Host "Masukkan pilihan"
        if ($response -eq "A" -or $response -eq "a") {
            return  # Kembali ke menu utama
        } elseif ($response -eq "") {
            exitScript  # Keluar dari skrip
        }
    } while ($true)
}

# Fungsi untuk keluar dan menghapus file sisa
function exitScript {
    if (Test-Path $downloadPath) {
        Remove-Item $downloadPath -Force | Out-Null
    }
    Write-Host "`n + Semua file sementara telah dihapus.`n" -ForegroundColor Green
    exit
}

# Looping menu utama
while ($true) {
    Clear-Host
    Write-Host $text -ForegroundColor Cyan
    Write-Host "--------------------------------------------------------------------------------"
    Write-Host " Virus Removal Tools - Remove viruses, malware, and other threats from your PC"
    Write-Host "--------------------------------------------------------------------------------"
    Write-Host "Pilih Antivirus yang ingin dijalankan:`n"

    # Menampilkan menu pilihan
    for ($i = 0; $i -lt $antivirusList.Count; $i++) {
        Write-Host " $($i+1). $($antivirusList[$i].Name)"
    }
    Write-Host "--------------------------------------------------------------------------------"
    $choice = Read-Host "Masukkan pilihan (1-$($antivirusList.Count)) atau tekan ENTER untuk keluar"

    # Jika user tekan Enter, keluar dari skrip
    if ($choice -eq "") { exitScript }

    # Memvalidasi input
    if ($choice -match "^\d+$" -and [int]$choice -ge 1 -and [int]$choice -le $antivirusList.Count) {
        $index = [int]$choice - 1
        DownloadAndRun -url $antivirusList[$index].URL -description $antivirusList[$index].Description -tip $antivirusList[$index].Tip
    } else {
        Write-Host "`nPilihan tidak valid. Silakan coba lagi.`n" -ForegroundColor Red
        Start-Sleep -Seconds 2
    }
}




# msert.exe 201,434,752 bytes
# KVRT.exe 112,851,304 bytes
# esetonlinescanner.exe 8,415,088 bytes
# tg8y095d.exe 297,017,416 bytes
# npe.exe 16,995,528 bytes
# stinger64.exe 49,166,568 bytes
# C:\Users\AURORA\AppData\Local\ESET\ESETOnlineScanner
#Remove-Item -Path "C:\Users\AURORA\AppData\Local\ESET\ESETOnlineScanner" -Recurse -Force
#Remove-Item -Path "C:\Program Files\Trend Micro" -Recurse -Force