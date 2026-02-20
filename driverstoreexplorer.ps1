# === DriverStoreExplorer Auto Download & Run ===

$repo = "lostindark/DriverStoreExplorer"
$apiUrl = "https://api.github.com/repos/$repo/releases/latest"

$extractPath = "C:\Windows\Temp\DriverStoreExplorer"
$tempZip = Join-Path $env:TEMP "DriverStoreExplorer_latest.zip"

Write-Host "Fetching latest release info..."

$response = Invoke-RestMethod -Uri $apiUrl -Headers @{
    "User-Agent" = "PowerShell"
}

$asset = $response.assets | Where-Object {
    $_.name -like "*.zip"
} | Select-Object -First 1

if (-not $asset) {
    Write-Host "ZIP asset not found!"
    exit
}

Write-Host "Downloading $($asset.name)..."
Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $tempZip

# Hapus folder lama jika ada
if (Test-Path $extractPath) {
    Remove-Item $extractPath -Recurse -Force
}

Write-Host "Extracting to $extractPath ..."
Expand-Archive -Path $tempZip -DestinationPath $extractPath -Force

Remove-Item $tempZip -Force

# Cari Rapr.exe (karena kadang ada subfolder versi)
$rapr = Get-ChildItem -Path $extractPath -Recurse -Filter "Rapr.exe" | Select-Object -First 1

if ($rapr) {
    Write-Host "Running DriverStoreExplorer..."
    Start-Process -FilePath $rapr.FullName -Verb RunAs
} else {
    Write-Host "Rapr.exe not found!"
}