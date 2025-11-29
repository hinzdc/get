$url = "https://github.com/abbodi1406/WHD/raw/refs/heads/master/scripts/OfficeScrubber_14_AIO.zip"
$outputZip = "C:\Windows\Temp\OfficeScrubber_14_AIO.zip"
$outputFolder = "C:\Windows\Temp\OfficeScrubber"

Invoke-WebRequest -Uri $url -OutFile $outputZip

Expand-Archive -Path $outputZip -DestinationPath $outputFolder

$batFile = Join-Path -Path $outputFolder -ChildPath "OfficeScrubberAIO.cmd"

if (Test-Path $batFile) {
    # Jalankan file OfficeScrubberAIO.cmd
    Start-Process -FilePath $batFile
} else {
    Write-Host "File OfficeScrubberAIO.cmd tidak ditemukan."
}
