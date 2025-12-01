# Skrip PowerShell untuk mendownload dan menginstal driver AMD terbaru
clear-host
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
                           --- DRIVER INSTALLER ---

"@

Write-Host $text -ForegroundColor Cyan
write-host "----------------------------------------------------------------------------------------"
write-host "Auto-Detect and Install Driver Updates for AMD Radeon Series Graphics and Ryzen Chipsets"
write-host "----------------------------------------------------------------------------------------"
# URL halaman unduhan driver AMD
$pageURL = "https://www.amd.com/en/support/download/drivers.html"

# Lokasi penyimpanan sementara untuk file driver
$tempDir = "$env:TEMP\AMDDriver"
$driverFile = "$tempDir\AMDDriver.exe"

# Membuat folder sementara
if (-Not (Test-Path -Path $tempDir)) {
    New-Item -ItemType Directory -Path $tempDir | Out-Null
}

# Mendapatkan URL file terbaru dari halaman AMD
Write-Output " + Mengakses halaman unduhan driver AMD..."
try {
    # Mengambil konten halaman AMD
    $pageContent = Invoke-WebRequest -Uri $pageURL -UseBasicParsing

    # Mencari URL file driver dari konten halaman (menggunakan filter .exe yang mengandung "drivers/installer")
    $driverURL = ($pageContent.Links | Where-Object { $_.href -match "\.exe$" -and $_.href -match "drivers/installer" }).href

    if (-Not $driverURL) {
        Write-Error "Tidak dapat menemukan URL driver di halaman tersebut."
        exit 1
    }

    # Menambahkan domain jika URL relatif
    if ($driverURL -notmatch "^https?://") {
        $driverURL = "https://drivers.amd.com" + $driverURL
    }

    Write-Host " + URL file driver terbaru ditemukan" -foreground Green
} catch {
    Write-Host "Gagal mengakses atau memproses halaman unduhan. Periksa koneksi internet atau URL halaman." -foreground Red
    exit 1
}

$driverFilename = [System.IO.Path]::GetFileName($driverURL)

# Mendownload file driver
Write-Output " + Mengunduh driver $driverFilename..."
try {
    # Mengunduh file driver dengan menambahkan header untuk referer
    Invoke-WebRequest -Uri $driverURL -OutFile $driverFile -UseBasicParsing -Headers @{ "Referer" = $pageURL }
    Write-Output " + Driver berhasil diunduh: $driverFile"
} catch {
    Write-Host "Gagal mengunduh file driver. Periksa URL atau koneksi internet Anda." -foreground Red
    exit 1
}

# Menjalankan instalasi driver
Write-Output " + Menjalankan instalasi driver..."
try {
    sc.exe config wuauserv start= disabled
    sc.exe config usosvc start= disabled
    sc.exe config bits start= disabled
    Stop-Service wuauserv -Force
    Stop-Service usosvc -Force
    Stop-Service bits -Force
    Stop-Process -Name "MoUsoCoreWorker" -Force -ErrorAction SilentlyContinue

    Start-Process -FilePath $driverFile -ArgumentList "/silent" -Wait
    Write-Output " + Driver berhasil diinstal."

    sc.exe config wuauserv start= demand
    sc.exe config usosvc start= demand
    sc.exe config bits start= demand
    Start-Service wuauserv
} catch {
    Write-Error "Gagal menginstal driver."
    exit 1
}

# Membersihkan file sementara
Write-Output " + Membersihkan file sementara..."
Remove-Item -Path $tempDir -Recurse -Force
Write-Output "Proses selesai."
