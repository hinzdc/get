<# ::
@echo off
title // ACTIVATOR WINDOWS + OFFICE PERMANENT - INDOJAVA ONLINE - HINZDC X SARGA
mode con cols=92 lines=32
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

function ntfy {
    # URL untuk ntfy.sh
    $ntfyUrl = "https://ntfy.sh/eu9QDaPa1mExQPwp"

    # Mendapatkan merek dan tipe/model perangkat dan spesifikasi perangkat
    $computerSystem = Get-CimInstance -ClassName Win32_ComputerSystemProduct
    $manufacturer = $computerSystem.Vendor
    $tipe = $computerSystem.Version
    $systemmodel = $computerSystem.Name
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    $winversion = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" | Select-Object -ExpandProperty DisplayVersion
    $processor = Get-CimInstance -ClassName Win32_Processor
    $ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB
    $disks = Get-CimInstance -ClassName Win32_DiskDrive
    # Menyusun informasi disk
    $diskall = ""
    foreach ($disk in $disks) {
        $modeldisk = $disk.Model
        $sizeInGB = [math]::round($disk.Size / 1GB, 2)  # Mengonversi size ke GB dan membulatkan ke 2 desimal
        $diskall += "- $modeldisk - $sizeInGB GB`n"
    }

    # Mendapatkan nama Wi-Fi yang terhubung
    $wifi = Get-NetAdapter | Where-Object { $_.InterfaceDescription -match 'Wireless' -and $_.Status -eq 'Up' }
    if ($wifi) {
        $wifiName = (Get-NetConnectionProfile -InterfaceAlias $wifi.Name).Name
    } else {
        $wifiName = "Tidak ada Wi-Fi yang terhubung."
    }

    # Mengecek koneksi internet melalui LAN
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

    # get activation status
    $SlmgrDli = cscript /Nologo "C:\Windows\System32\slmgr.vbs" /dli 2>&1
    $SlmgrXpr = cscript /Nologo "C:\Windows\System32\slmgr.vbs" /xpr 2>&1

    # Jalankan perintah OSPP
    $output = cscript "C:\Program Files\Microsoft Office\Office16\OSPP.VBS" /dstatus | Out-String

    # Pisahkan output ke dalam array berdasarkan baris
    $outputLines = $output -split "`n"

    # Variabel untuk menyimpan informasi Office
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

    # Loop untuk mengumpulkan informasi Office
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

    # Gabungkan informasi perangkat dan Office ke dalam satu pesan
    $message = @"
    ////////// Spesifikasi Perangkat //////////
    Merek: $manufacturer
    Model: $tipe ($systemmodel)
    Prosesor: $($processor.Name) ($($processor.NumberOfCores) Core) ($($processor.NumberOfLogicalProcessors) Logical)
    RAM: $([math]::Round($ram, 2)) GB
    Disk Drive:
    $diskall
    ////////// Sistem Operasi //////////
    Nama OS: $($os.Caption)
    Versi OS: $($os.Version)
    Windows Version: $winversion
    Arsitektur: $($os.OSArchitecture)

    ////////// Network //////////
    Wi-Fi Terhubung: $wifiName
    $lanStatus
    $internetStatus

    ////////// Windows License //////////
    $SlmgrDli
    $SlmgrXpr

    ////////// Microsoft Office //////////

"@

    foreach ($entry in $entries) {
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
    
    # Kirim pesan ke ntfy.sh
    $response = Invoke-RestMethod -Uri $ntfyUrl -Method POST -Body $message -Headers @{
        "Title" = "Aktivasi Windows dan Office"
        "Priority" = "default"
        "Tags" = "computer"
    }

    # Tampilkan hasil pengiriman
    if ($response) {
        Write-host
    } else {
        Write-Host " failed sending log.." -ForegroundColor Red
    }
}

Write-Host "----------------------------"
Write-Host
Write-Host " + GETING SCRIPT.."
Write-Host " + ACTIVATING.."
& ([ScriptBlock]::Create((irm https://get.activated.win))) /HWID /Ohook | Out-Null
Write-Host " >> PROSES AKTIVASI SELESAI.. SELAMAT MENGGUNAKAN.." -ForegroundColor Green
Write-Host
Write-Host " // $kataAcak //" -ForegroundColor Red
Write-Host
Write-Host " >> MENGIRIM INFORMASI KE ADMIN.." -ForegroundColor Yellow
ntfy
Write-Host "----------------------------"
$EndDTM = (Get-Date)
Write-Host " END " -BackgroundColor Red -ForegroundColor White -NoNewline
Write-Host " $EndDTM " -BackgroundColor White -ForegroundColor Black

# Hitung total detik dan menit
$TotalSeconds = ($EndDTM - $StartDTM).TotalSeconds
$TotalMinutes = [math]::Floor($TotalSeconds / 60)  # Hitung menit tanpa desimal
$RemainingSeconds = [math]::Floor($TotalSeconds % 60)  # Hitung sisa detik tanpa desimal
Write-Host " TOTAL PROSES: " -BackgroundColor blue -ForegroundColor white -NoNewLine
Write-Host " $TotalMinutes Menit $RemainingSeconds Detik " -BackgroundColor red -ForegroundColor white
Write-Host "------------------------------------------------------------------------------------------"
Write-Host " PRESS ENTER TO EXIT:" -NoNewLine
$shell = New-Object -ComObject WScript.Shell
# Menampilkan pesan popup
$shell.Popup("AKTIVASI WINDOWS DAN OFFICE PERMANEN SUDAH SELESAI..", 30, "OLIH X SARGA ~// -- INDOJAVA ONLINE") | Out-Null
Read-Host

# Membuka jendela CMD dan mengeksekusi perintah taskkill
Start-Process cmd.exe -ArgumentList '/c taskkill /F /IM rundll32.exe /T'

# encode Western(Windows 1252)