# Header bar (PS5-safe) - paste & jalankan
function Draw-TopBarPS5 {
    param(
        [string]$Title = " A U R O R A  Info Panel ",
        [ConsoleColor]$LeftColor = 'White',
        [ConsoleColor]$BgColor = 'DarkBlue'
    )

    $w = [Console]::WindowWidth
    # compose padded title (center-ish)
    $inner = " $Title "
    $padLeft = [math]::Floor(($w - $inner.Length) / 2)
    if ($padLeft -lt 0) { $padLeft = 0 }

    # save colors
    $origF = [Console]::ForegroundColor
    $origB = [Console]::BackgroundColor
    try {
        [Console]::ForegroundColor = $LeftColor
        [Console]::BackgroundColor = $BgColor
    } catch {}
    # draw full top line as background
    try {
        [Console]::SetCursorPosition(0,0)
        [Console]::Write((" " * $w))
        [Console]::SetCursorPosition(0,0)
    } catch {
        # fallback: Write-Host
        Write-Host (" " * $w)
    }

    # print title centered-ish
    try { [Console]::SetCursorPosition($padLeft,0) } catch {}
    [Console]::Write($inner)

    # print clock at far right
    $clock = (Get-Date).ToString("HH:mm:ss")
    $clockPos = $w - $clock.Length - 1
    if ($clockPos -gt ($padLeft + $inner.Length)) {
        try { [Console]::SetCursorPosition($clockPos,0) } catch {}
        [Console]::Write($clock)
    } else {
        # if collision, put clock after title
        try { [Console]::SetCursorPosition($padLeft + $inner.Length + 1,0) } catch {}
        [Console]::Write($clock)
    }

    # restore colors
    try { [Console]::ForegroundColor = $origF; [Console]::BackgroundColor = $origB } catch {}
}

# Contoh loop update clock (CTRL+C untuk stop)
for ($i=0; $i -lt 200; $i++) {
    Draw-TopBarPS5 -Title "  A U R O R A  Info Panel  "
    Start-Sleep -Milliseconds 700
}
