# aaa-progress.ps1
# Progress bar animasi "AA A loading" untuk PowerShell (Windows Terminal / PS7+)
# Features:
# - 24-bit ANSI colors (gradient fill)
# - Shimmer / gloss effect berjalan di atas bar
# - Smooth incremental animation, percent, ETA, spinner
# - Graceful cleanup & cursor restore

$esc = [char]27
$reset = "$esc[0m"

function RGB($r, $g, $b) { return "$esc[38;2;${r};${g};${b}m" }
function BG($r, $g, $b)  { return "$esc[48;2;${r};${g};${b}m" }

function Lerp($a, $b, $t) { return [math]::Round($a + ($b - $a) * $t) }

function Write-ColoredChar($char, $r, $g, $b) {
    [Console]::Write((RGB $r $g $b) + $char + $reset)
}

# Render satu bar frame
function Render-ProgressBar {
    param(
        [double] $progress,       # 0..1
        [int] $width = 50,        # total chars
        [int[]] $startRGB = @(30,30,90),
        [int[]] $endRGB   = @(90,200,255),
        [int[]] $bgRGB    = @(15,15,20),
        [int] $shimmerPos = 0,    # shimmer center index
        [int] $shimmerWidth = 6   # shimmer spread
    )

    # clamp
    if ($progress -lt 0) { $progress = 0 }
    if ($progress -gt 1) { $progress = 1 }

    $filled = [math]::Floor($progress * $width)
    $bar = ""

    for ($i=0; $i -lt $width; $i++) {
        # background base color
        $baseR = $bgRGB[0]; $baseG = $bgRGB[1]; $baseB = $bgRGB[2]

        if ($i -lt $filled) {
            # compute gradient t across filled portion
            $t = if ($filled -le 1) { 0 } else { $i / ([math]::Max(1, $filled - 1)) }
            $r = Lerp $startRGB[0] $endRGB[0] $t
            $g = Lerp $startRGB[1] $endRGB[1] $t
            $b = Lerp $startRGB[2] $endRGB[2] $t
        } else {
            $r = $baseR; $g = $baseG; $b = $baseB
        }

        # shimmer effect weighting (gaussian-like)
        $dist = [math]::Abs($i - $shimmerPos)
        if ($dist -lt $shimmerWidth) {
            $factor = 1 - ($dist / $shimmerWidth)            # 1..0
            # Add a bright layer to RGB (clamp to 255)
            $r = [math]::Min(255, [math]::Round($r + 120 * $factor))
            $g = [math]::Min(255, [math]::Round($g + 120 * $factor))
            $b = [math]::Min(255, [math]::Round($b + 120 * $factor))
        }

        # choose char: block for filled else small shade
        if ($i -lt $filled) { $ch = "$([char]0x2588)" } else { $ch = "$([char]0x2591)" }

        [Console]::Write((RGB $r $g $b) + $ch + $reset)
    }

    # end with thin border spacing
}

# Spinner sequence
$spinnerFrames = @('|','/','-','\')

# Helper: format time seconds to mm:ss
function Format-Time($seconds) {
    $seconds = [int]$seconds
    $m = [math]::Floor($seconds / 60)
    $s = $seconds % 60
    return ("{0:00}:{1:00}" -f $m, $s)
}


# Main demo function: simulate load for given seconds
function Start-AAALoading {
    param(
        [int] $totalSeconds = 12,
        [int] $width = 48
    )

    $start = Get-Date
    $endTime = $start.AddSeconds($totalSeconds)

    $origCursor = $null
    try {
        $origCursor = [Console]::CursorVisible
    } catch { $origCursor = $true }

    [Console]::CursorVisible = $false

    $frame = 0
    $lastPercent = -1
    while ((Get-Date) -lt $endTime) {
        $now = Get-Date
        $elapsed = ($now - $start).TotalSeconds
        $progress = [math]::Min(1.0, $elapsed / $totalSeconds)

        # shimmer sweeps from left to right with easing
        $shimmerRange = $width + 10
        $cyclePos = ($frame % $shimmerRange)
        $shimmerPos = [math]::Max(0, [math]::Min($width-1, $cyclePos - 5))

        # render bar label + percent + spinner + ETA
        $percentInt = [math]::Floor($progress * 100)
        $spinner = $spinnerFrames[$frame % $spinnerFrames.Length]

        # ETA simple linear estimate
        $remaining = [math]::Max(0, $totalSeconds - $elapsed)
        $etaText = Format-Time $remaining

        # carriage return to redraw same line(s)
        [Console]::Write("`r") # reset to line start

        # left label
        $label = "LOADING"
        [Console]::Write((RGB 180 220 255) + $label + $reset + " ")

        # draw progress bar
        Render-ProgressBar -progress $progress -width $width -startRGB @(30,120,255) -endRGB @(90,220,150) -bgRGB @(18,18,28) -shimmerPos $shimmerPos -shimmerWidth 6

        # spacer
        [Console]::Write("  ")

        # percent (bright)
        [Console]::Write((RGB 230 230 230) + ("{0,3}%%" -f $percentInt) + $reset + " ")

        # spinner (accent)
        [Console]::Write((RGB 140 240 200) + $spinner + $reset + " ")

        # ETA (dim)
        [Console]::Write((RGB 160 160 170) + "ETA " + $etaText + $reset)

        $frame++
        Start-Sleep -Milliseconds 60
    }

    # finish: set to 100% and print newline + success
    [Console]::Write("`r")
    $label = "COMPLETE"
    [Console]::Write((RGB 160 255 200) + $label + $reset + " ")
    Render-ProgressBar -progress 1 -width $width -startRGB @(20,200,120) -endRGB @(90,255,200) -bgRGB @(10,10,12) -shimmerPos ($width+2) -shimmerWidth 0
    [Console]::Write("  ")
    [Console]::Write((RGB 220 220 220) + "100% " + $reset)
    [Console]::Write("  ")
    [Console]::Write((RGB 200 200 210) + "Elapsed " + (Format-Time (New-TimeSpan -Start $start -End (Get-Date)).TotalSeconds) + $reset)
    [Console]::WriteLine("`n")

    # restore cursor visibility
    [Console]::CursorVisible = $origCursor
}

# Example run: simulate 12 seconds (ubah parameter sesuai kebutuhan)
Start-AAALoading -totalSeconds 3 -width 56
