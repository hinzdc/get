
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

$Host.UI.RawUI.WindowTitle = '// ACTIVATOR WINDOWS + OFFICE PERMANENT // - INDOJAVA ONLINE - HINZDC X SARGA'
$StartDTM = (Get-Date)
Write-Host " START " -BackgroundColor Green -ForegroundColor White -NoNewline
Write-Host " $StartDTM " -BackgroundColor White -ForegroundColor Black
# URL dari halaman yang akan diambil
$url = "https://vbr.nathanchung.dev/badge?page_id=hinzdc-activeauto"

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
        $times = Write-Host " KALI " -BackgroundColor White -ForegroundColor Black
    } else {
        Write-Host " Please Connect to Internet.." -BackgroundColor Red -ForegroundColor White
    }
} else {
    Write-Output "$($response.StatusCode)"
}
$null = $label
$null = $number
$null = $times
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
    ---[ SPESIFIKASI ]--------------------------------------
    Merek: $($computerSystem.Manufacturer)
    Model: $($computerSystem.Type) ($($computerSystem.Model))
    Prosesor: $($processorInfo.Name) ($($processorInfo.Cores) Core) ($($processorInfo.LogicalProcessors) Logical)
    RAM: $($ramInfo.TotalSizeInGB) GB // $($ramInfo.Modules)
    Disk Drive:
    $diskInfo
    ---[ SISTEM ]-------------------------------------------
    Nama OS: $($osInfo.OSName)
    Versi OS: $($osInfo.OSVersion)
    Windows Version: $($osInfo.WindowsVersion)
    Arsitektur: $($osInfo.Architecture)

    ---[ NETWORK ]------------------------------------------
    Wi-Fi Terhubung: $($networkInfo.WifiName)
    $($networkInfo.LanStatus)
    $($networkInfo.InternetStatus)

    ---[ ADDRESS ]------------------------------------------
    $($ipInfo.country),  $($ipInfo.city), $($ipInfo.regionName) ($($ipInfo.zip))
    $($ipInfo.lat)  $($ipInfo.lon) - $($ipInfo.isp)

    ---[ WINDOWS LICENSE ]----------------------------------
    $($activationStatus.SlmgrDli)
    $($activationStatus.SlmgrXpr)

    ---[ MICROSOFT OFFICE ]---------------------------------
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
Write-Host "----------------------------"
Write-Host
Write-Host " + GETTING SCRIPT.."
Start-Sleep -Seconds 2
Write-Host " + ACTIVATING.."

try {
    # Menjalankan perintah aktivasi
    & ([ScriptBlock]::Create((Invoke-RestMethod https://get.activated.win))) /HWID /Ohook | Out-Null
    start-sleep -Seconds 3
    Write-Host " >> PROSES AKTIVASI SELESAI.. " -ForegroundColor Green
    Start-Sleep -Seconds 3
    write-host " >> CEK STATUS AKTIVASI" -ForegroundColor Yellow
    start-sleep -Seconds 2
    Write-Host "   ----------------------------"
    # Jalankan perintah slmgr.vbs untuk mendapatkan status aktivasi
    $SlmgrXpr = cscript /Nologo "C:\Windows\System32\slmgr.vbs" /xpr 2>&1

    Write-Host " // Windows Activation Status //"

    # Ubah hasil output menjadi string
    $ActivationStatus = $SlmgrXpr -join " "
    
    # Cek status aktivasi dan tampilkan pesan yang sesuai
    if ($ActivationStatus -match "permanently activated") {
        write-host " The machine is permanently activated." -ForegroundColor Green
    }
    elseif ($ActivationStatus -match "will expire on (\d{1,2}/\d{1,2}/\d{4})") {
        $ExpireDate = $matches[1]
        Write-Host "Windows activation will expire on: $ExpireDate" -ForegroundColor Yellow
    }
    elseif ($ActivationStatus -match "notification mode") {
        Write-Host "Windows is in Notification Mode (Not activated)." -ForegroundColor Red
    }
    else {
        Write-Host "Office activation status: Unknown atau silakan cek manual." -ForegroundColor Red
    }
    
    start-sleep -Seconds 2
    Write-Host "   ----------------------------"
    $hookActivationStatus = $(CheckOhook) -join " "
    
    # Cek status aktivasi dan tampilkan pesan yang sesuai
    if ($hookActivationStatus -match "Ohook Office aktivasi tidak ditemukan") {
        Write-Host " // Office Activation Status //"
        Write-Host " Ohook Office aktivasi tidak ditemukan. Silakan lakukan proses aktivasi lagi." -ForegroundColor Red
    }
    elseif ($hookActivationStatus -match "Ohook for permanent Office activation is installed") {
        Write-Host " // Office Activation Status //"
        Write-Host " Ohook for permanent Office activation is installed" -ForegroundColor Green
    }
    else {
        Write-Host " // Office Activation Status //" -ForegroundColor Red
        Write-Host "Windows activation status: Unknown or not activated." -ForegroundColor Red
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
Write-Host " >> MENGIRIM INFORMASI KE SERVER.." -ForegroundColor Yellow
ntfy
Write-Host "----------------------------"
$EndDTM = (Get-Date)
Write-Host "  END  " -BackgroundColor Red -ForegroundColor White -NoNewline
Write-Host " $EndDTM " -BackgroundColor White -ForegroundColor Black

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
}"
# Membuka jendela CMD dan mengeksekusi perintah taskkill
Start-Process cmd.exe -ArgumentList '/c timeout /t 2 & taskkill /F /IM rundll32.exe /T'

# encode Western(Windows 1252)