$url = "https://download.explorerplusplus.com/stable/1.4.0/explorerpp_x64.zip"
$outputZip = "C:\Windows\Temp\explorerpp_x64.zip"
$outputFolder = "C:\Windows\Temp\explorer++"

Invoke-WebRequest -Uri $url -OutFile $outputZip

Expand-Archive -Path $outputZip -DestinationPath $outputFolder -Force

$exeFile = Join-Path $outputFolder "Explorer++.exe"

if (Test-Path $exeFile) {
    Write-Host "Tunggu Explorer++ akan segera terbuka..."
    Start-Process -FilePath $exeFile
} else {
    Write-Host "File Explorer++.exe tidak ditemukan."
}
