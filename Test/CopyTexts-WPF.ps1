<#
.SYNOPSIS
    A defensive and robust PowerShell 5 script to display a simple GUI using WPF.
#>
param(
    [int]$Count = 10,
    [string]$BaseLabel = 'Item',
    [string[]]$Texts = @()
)

# --- Setup & Pre-checks ---
$logPath = Join-Path $env:TEMP "CopyTextGui-WPF.log"
function Log($s) {
    $line = ("[{0:u}] {1}" -f (Get-Date), $s)
    try { Add-Content -Path $logPath -Value $line -ErrorAction SilentlyContinue } catch {}
}

if ([System.Threading.Thread]::CurrentThread.ApartmentState -ne 'STA') {
    Log "Not in STA. Relaunching..."
    $psPath = (Get-Command powershell).Source
    $args = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-STA', '-File', $MyInvocation.MyCommand.Path) + $PSBoundParameters.GetEnumerator().ForEach({ "-$($_.Key)", "$($_.Value)" })
    Start-Process $psPath -ArgumentList $args -WindowStyle Normal
    exit
}

Log "Script started in STA mode. PID=$pid Host=$($Host.Name)"

# --- Main Script ---
try {
    Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Xaml
    Log "WPF assemblies loaded."
} catch {
    Log "Failed to load WPF assemblies: $($_.Exception.Message)"
    [System.Windows.MessageBox]::Show("Fatal Error: Could not load WPF assemblies.`,n$($_.Exception.Message)", "Startup Error", 'OK', 'Error') | Out-Null
    exit 1
}

# --- GUI Construction ---
$window = New-Object System.Windows.Window
$window.Title = 'Copy Texts (WPF)'
$window.Width = 620
$window.Height = 580
$window.WindowStartupLocation = 'CenterScreen'

$scroll = New-Object System.Windows.Controls.ScrollViewer
$scroll.VerticalScrollBarVisibility = 'Auto'
$window.Content = $scroll

$mainStack = New-Object System.Windows.Controls.StackPanel
$mainStack.Margin = [System.Windows.Thickness]::new(15)
$scroll.Content = $mainStack

$allTextBoxes = [System.Collections.Generic.List[System.Windows.Controls.TextBox]]::new()

# Create rows
for ($i = 0; $i -lt $Count; $i++) {
    $idx = $i + 1
    $labelText = if ($BaseLabel) { "$BaseLabel ${idx}:" } else { "Item ${idx}:" }
    $initialText = if ($Texts.Count -gt $i) { $Texts[$i] } else { "Contoh teks $idx" }

    $lbl = New-Object System.Windows.Controls.TextBlock
    $lbl.Text = $labelText
    $lbl.FontWeight = 'SemiBold'
    $lbl.Margin = [System.Windows.Thickness]::new(0, 10, 0, 2)
    $mainStack.Children.Add($lbl) | Out-Null

    $grid = New-Object System.Windows.Controls.Grid
    $grid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition -Property @{ Width = [System.Windows.GridLength]::new(1, 'Star') }))
    $grid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition -Property @{ Width = [System.Windows.GridLength]::new(1, 'Auto') }))
    $mainStack.Children.Add($grid) | Out-Null

    $textbox = New-Object System.Windows.Controls.TextBox
    $textbox.Text = $initialText
    $textbox.IsReadOnly = $true
    $textbox.FontFamily = "Consolas"
    $textbox.FontSize = 14
    $textbox.Padding = [System.Windows.Thickness]::new(5)
    $textbox.VerticalContentAlignment = 'Center'
    [System.Windows.Controls.Grid]::SetColumn($textbox, 0)
    $grid.Children.Add($textbox) | Out-Null
    $allTextBoxes.Add($textbox)

    $button = New-Object System.Windows.Controls.Button
    $button.Content = 'Copy'
    $button.Width = 80
    $button.Height = 32
    $button.Margin = [System.Windows.Thickness]::new(8, 0, 0, 0)
    [System.Windows.Controls.Grid]::SetColumn($button, 1)
    $grid.Children.Add($button) | Out-Null

    # --- Event Handlers ---
    $feedbackTimer = New-Object System.Windows.Threading.DispatcherTimer
    $feedbackTimer.Interval = [TimeSpan]::FromSeconds(1.2)
    $feedbackTimer.Add_Tick({
        $button.Content = 'Copy'
        $feedbackTimer.Stop()
    })

    $button.Add_Click({
        param($sender, $e)
        try {
            if ($textbox.Text) {
                [System.Windows.Clipboard]::SetText($textbox.Text)
                Log "Copied: $($textbox.Text)"
                $sender.Content = '✓ Copied'
                $feedbackTimer.Start()
            }
        } catch {
            Log "Clipboard error: $($_.Exception.Message)"
            [System.Windows.MessageBox]::Show("Gagal menyalin: $($_.Exception.Message)", "Error", 'OK', 'Error') | Out-Null
        }
    })
}

# --- 'Copy All' Button ---
$copyAllBtn = New-Object System.Windows.Controls.Button
$copyAllBtn.Content = 'Copy All to Clipboard'
$copyAllBtn.FontWeight = 'Bold'
$copyAllBtn.Margin = [System.Windows.Thickness]::new(0, 20, 0, 0)
$copyAllBtn.Padding = [System.Windows.Thickness]::new(10)
$mainStack.Children.Add($copyAllBtn) | Out-Null

$copyAllTimer = New-Object System.Windows.Threading.DispatcherTimer; $copyAllTimer.Interval = [TimeSpan]::FromSeconds(1.5)
$copyAllTimer.Add_Tick({ $copyAllBtn.Content = 'Copy All to Clipboard'; $copyAllTimer.Stop() })

$copyAllBtn.Add_Click({
    try {
        $allText = $allTextBoxes.Text -join [Environment]::NewLine
        if ($allText) {
            [System.Windows.Clipboard]::SetText($allText)
            Log "Copied all text."
            $copyAllBtn.Content = '✓ All Copied!'
            $copyAllTimer.Start()
        }
    } catch {
        Log "Clipboard error (Copy All): $($_.Exception.Message)"
        [System.Windows.MessageBox]::Show("Gagal menyalin semua teks: $($_.Exception.Message)", "Error", 'OK', 'Error') | Out-Null
    }
})

# --- Show Window (Defensive Logic) ---
$app = [System.Windows.Application]::Current
if ($null -eq $app) {
    Log "No existing Application found. Creating one and calling Run()."
    $app = New-Object System.Windows.Application
    # Run() is blocking and is the standard for a primary application window.
    $app.Run($window) | Out-Null
    Log "Application Run() returned. Script finished."
} else {
    Log "Existing Application found (likely in ISE/VSCode). Calling ShowDialog()."
    # ShowDialog() is also blocking, perfect for hosted environments.
    # This is more stable than Show() + a manual message loop.
    $window.ShowDialog() | Out-Null
    Log "Dialog closed. Script finished."
}
