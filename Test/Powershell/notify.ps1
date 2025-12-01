
# Requires: Windows Terminal or PowerShell 7+ (ANSI 24-bit color)

$esc = [char]27
$reset = "$esc[0m"

function RGB {
    param($r, $g, $b)
    return "$esc[38;2;${r};${g};${b}m"
}
function BG {
    param($r, $g, $b)
    return "$esc[48;2;${r};${g};${b}m"
}

# Linear interpolation helper
function Lerp($a, $b, $t) { return [math]::Round($a + ($b - $a) * $t) }

# Tulis teks dengan gradient per karakter (foreground)
function Write-GradientText {
    param(
        [string] $Text,
        [int[]] $StartRGB = @(255,140,0),
        [int[]] $EndRGB   = @(255,80,160),
        [switch] $NewLine
    )
    $len = [math]::Max(1, $Text.Length)
    for ($i=0; $i -lt $Text.Length; $i++) {
        $t = if ($len -le 1) { 0 } else { $i / ($len - 1) }
        $r = Lerp $StartRGB[0] $EndRGB[0] $t
        $g = Lerp $StartRGB[1] $EndRGB[1] $t
        $b = Lerp $StartRGB[2] $EndRGB[2] $t
        [Console]::Write((RGB $r $g $b) + $Text[$i])
    }
    [Console]::Write($reset)
    if ($NewLine) { [Console]::WriteLine() }
}

function Header {
  param($Label=" // A U R O R A  T O O L K I T // ", $Center=" ")
  $w=[Console]::WindowWidth; $Lw=3; $Rw=3
  $lab=" $Label "; $mid=$w-($Lw+$lab.Length+$Rw); if($mid -lt 1){$mid=1}
  try{ $curL=[Console]::CursorLeft; $curT=[Console]::CursorTop } catch { $curL=0; $curT=1 }
  try{ [Console]::SetCursorPosition(0,0) } catch {}
  Write-Host (" " * $Lw) -NoNewline -ForegroundColor DarkBlue -BackgroundColor white
  Write-Host $lab -NoNewline -ForegroundColor White -BackgroundColor darkblue
  Write-Host ($Center.PadRight($mid)) -NoNewline -ForegroundColor Black -BackgroundColor white
  if($Rw -gt 0){ Write-Host (" " * $Rw) -NoNewline -ForegroundColor White -BackgroundColor darkblue }
  try{ [Console]::SetCursorPosition($curL,$curT) } catch {}
}

# Draw header (simulate wide background by filling spaces)
$termWidth = [Console]::WindowWidth
if ($termWidth -lt 60) { $termWidth = 60 }

# Create gradient background line function
function Write-GradientBGLine {
    param([int]$height = 1, [int[]]$startRGB=@(50,30,120), [int[]]$endRGB=@(255,140,0))
    for ($h=0; $h -lt $height; $h++) {
        for ($x=0; $x -lt $termWidth; $x++) {
            $t = if ($termWidth -le 1) { 0 } else { $x / ($termWidth - 1) }
            $r = Lerp $startRGB[0] $endRGB[0] $t
            $g = Lerp $startRGB[1] $endRGB[1] $t
            $b = Lerp $startRGB[2] $endRGB[2] $t
            [Console]::Write((BG $r $g $b) + " ")
        }
        [Console]::Write($reset + "`n")
    }
}

# Print a header block: top fill, centered gradient title, description
# top fill (1 line)
clear-host
Header -Label "// A U R O R A  T O O L K I T //" -Center " "
# Top padding
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host " PERINGATAN:" -background darkred -foreground white -nonewline
Write-Host " URL ini telah dipindahkan." -ForegroundColor red
Write-Host " Gunakan perintah baru dibawah yang lebih pendek."
Write-Host ""
Write-Host " > iex (irm office.indojava.online)" -foreground Cyan
Write-Host ""
write-Host " URL lama akan segera di hapus. jadi mulai gunakan yang baru."
write-Host " Gunakan" -ForegroundColor Blue -nonewline
write-Host " iex(irm command.indojava.online)" -ForegroundColor red -nonewline
write-Host " untuk melihat daftar perintah" -ForegroundColor Blue
write-Host ""
Write-Host ""
#Write-GradientBGLine -height 1 -startRGB @(80,30,120) -endRGB @(255,140,0)
Write-Host "------------------------------------------------------------------------" -ForegroundColor cyan
Write-Host ""
Start-Sleep -Seconds 4
Write-Host " EXECUTE " -ForegroundColor blue -nonewline
Write-Host " CODE " -ForegroundColor Red -nonewline
Start-Sleep -Milliseconds 100
Write-Host " >> " -ForegroundColor white -nonewline
Start-Sleep -Milliseconds 300
Write-Host " iex(irm command.indojava.online) " -ForegroundColor Green
Write-Host ""
for ($i = 0; $i -lt 50; $i++) { Write-Host -NoNewline ">"; Start-Sleep -Milliseconds 100 }
Write-Host ""

# bottom fill line

[Console]::WriteLine("")