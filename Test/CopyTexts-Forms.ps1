<#
.SYNOPSIS
    Displays a GUI with a predefined list of commands and copy buttons.
#>

# --- Setup & Pre-checks ---

# 1. Logging Utility
$logPath = Join-Path $env:TEMP "CopyTextGui.log"
function Log($s) {
    $line = ("[{0:u}] {1}" -f (Get-Date), $s)
    try { Add-Content -Path $logPath -Value $line -ErrorAction SilentlyContinue } catch {}
}

# 2. STA Relaunch Check (Crucial for any GUI)
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
    Add-Type -AssemblyName System.Windows.Forms
    Log "System.Windows.Forms assembly loaded."
} catch {
    Log "Failed to load WinForms assembly: $($_.Exception.Message)"
    exit 1
}

# --- Predefined Data ---
# Each object has one Label and a list of one or more Texts.
$Commands = @(
    [pscustomobject]@{ Label = 'Menampilkan semua list ini'; Texts = @('iex(irm indojava.online/get/command)') },
    [pscustomobject]@{ Label = 'Activator Windows & Office Otomatis Active Permanent'; Texts = @('iex(irm indojava.online/get/activeauto)') },
    [pscustomobject]@{ Label = 'Activator Office 2013, 2016, 2019, 2021 - Permanent'; Texts = @('iex(irm indojava.online/get/activeoffice)') },
    [pscustomobject]@{ Label = 'Activator Windows Permanent Digital License'; Texts = @('iex(irm indojava.online/get/activewindows)') },
    [pscustomobject]@{ Label = 'Activator Office 2010, 2013, 2016, 2019, 2021 - KMS Online'; Texts = @('iex(irm indojava.online/get/activeofficekms)') },
    [pscustomobject]@{ Label = 'Activator Windows sampai tahun 2038 - KMS38'; Texts = @('iex(irm indojava.online/get/activewindowskms38)') },
    [pscustomobject]@{ Label = 'Install Office 2013, 2016, 2019, 2021, 2024, 365'; Texts = @('iex(irm indojava.online/get/installoffice)') },
    [pscustomobject]@{ Label = 'Office Scrub / Uninstal dan Force Remove'; Texts = @('iex(irm indojava.online/get/officescrub)', 'iex(irm indojava.online/get/officesrubber)') },
    [pscustomobject]@{ Label = 'Windows Update Contol - Disable/Enable, Pause And Reset Windows Update'; Texts = @('iex(irm indojava.online/get/windowsupdate)') },
    [pscustomobject]@{ Label = 'Remove or Disable Windows Defender (Disable dulu defender sebelum memasukan perintah ini)'; Texts = @('iex(irm indojava.online/get/def)', 'iex(irm indojava.online/get/def2)') },
    [pscustomobject]@{ Label = 'Fix corrupted file system & restore health'; Texts = @('iex(irm indojava.online/get/fixos)') },
    [pscustomobject]@{ Label = 'Virus Removal Tool'; Texts = @('iex(irm indojava.online/get/virusremoval)') },
    [pscustomobject]@{ Label = 'Tweaks Registry'; Texts = @('iex(irm indojava.online/get/tweaks)') },
    [pscustomobject]@{ Label = 'Debloater - Remove Default App'; Texts = @('iex(irm indojava.online/get/removeappx)') },
    [pscustomobject]@{ Label = 'AMD Support - Driver AMD Installer'; Texts = @('iex(irm indojava.online/get/amdsupport)') },
    [pscustomobject]@{ Label = 'Block Host - Disable Internet From Activation Detection adobe, autocad, corel etc.'; Texts = @('iex(irm indojava.online/get/blockhost)') },
    [pscustomobject]@{ Label = 'Reset Network - Reset seluruh konfigurasi untuk internet, LAN atau wifi bermasalah'; Texts = @('iex(irm indojava.online/get/resetnetwork)') },
    [pscustomobject]@{ Label = 'Infector Check - cek kerusakan system kana antivirus'; Texts = @('iex(irm indojava.online/get/infectorcheck)') },
    [pscustomobject]@{ Label = 'Winget - Force Install Winget'; Texts = @('iex(irm indojava.online/get/fixos)') },
    [pscustomobject]@{ Label = 'Force Remove - Hapus Paksa File Dan Folder Yang Sulit Di Hapus'; Texts = @('iex(irm indojava.online/get/ForeceRemove)') }
)

# --- GUI Construction ---

$form = New-Object System.Windows.Forms.Form
$form.Text = 'PowerShell Command Runner'
$form.Width = 680
$form.Height = 720
$form.MinimumSize = [System.Drawing.Size]::new(450, 400)
$form.StartPosition = 'CenterScreen'
$form.Padding = [System.Windows.Forms.Padding]::new(10)
$form.KeyPreview = $true # Allow form to capture key presses like ESC

# Use a FlowLayoutPanel to automatically stack controls vertically.
$mainPanel = New-Object System.Windows.Forms.FlowLayoutPanel
$mainPanel.Dock = 'Fill'
$mainPanel.AutoScroll = $true
$form.Controls.Add($mainPanel)

# Create rows of controls from the predefined data
foreach ($command in $Commands) {
    # Add the main label for the group.
    $label = New-Object System.Windows.Forms.Label
    $label.Text = $command.Label
    $label.Font = [System.Drawing.Font]::new($label.Font, 'Bold')
    $label.AutoSize = $true
    $label.Margin = [System.Windows.Forms.Padding]::new(0, 2, 0, 0)
    $mainPanel.Controls.Add($label)

    # Loop through each text command for the current label.
    foreach ($text in $command.Texts) {
        # Create a panel for this specific textbox and button.
        $entryPanel = New-Object System.Windows.Forms.Panel
        $entryPanel.Width = $mainPanel.ClientSize.Width - 25
        $entryPanel.Height = 28
        $entryPanel.Anchor = 'Top', 'Left', 'Right'
        $entryPanel.Margin = [System.Windows.Forms.Padding]::new(0, 2, 0, 5)
        $mainPanel.Controls.Add($entryPanel)

        $buttonWidth = 80

        $button = New-Object System.Windows.Forms.Button
        $button.Text = 'Copy'
        $button.Size = [System.Drawing.Size]::new($buttonWidth, 25)
        $button.Location = [System.Drawing.Point]::new($entryPanel.Width - $buttonWidth, 0)
        $button.Anchor = 'Top', 'Right'
        $entryPanel.Controls.Add($button)

        $textbox = New-Object System.Windows.Forms.TextBox
        $textbox.Text = $text
        $textbox.ReadOnly = $true
        $textbox.Font = [System.Drawing.Font]::new("Consolas", 10)
        $textbox.Size = [System.Drawing.Size]::new($entryPanel.Width - $buttonWidth - 5, 25)
        $textbox.Location = [System.Drawing.Point]::new(0, 0)
        $textbox.Anchor = 'Top', 'Left', 'Right'
        $textbox.BorderStyle = 'FixedSingle'
        $entryPanel.Controls.Add($textbox)

        # --- Event Handlers ---
        $feedbackTimer = New-Object System.Windows.Forms.Timer
        $feedbackTimer.Interval = 1200
        $feedbackTimer.Add_Tick({
            $button.Text = 'Copy'
            $feedbackTimer.Stop()
        })

        $button.Add_Click({
            param($sender, $e)
            try {
                if ($textbox.Text) {
                    [System.Windows.Forms.Clipboard]::SetText($textbox.Text)
                    Log "Copied: $($textbox.Text)"
                    $sender.Text = '✓ Copied'
                    $feedbackTimer.Start()
                }
            } catch {
                Log "Clipboard error: $($_.Exception.Message)"
                [System.Windows.Forms.MessageBox]::Show("Gagal menyalin: $($_.Exception.Message)", "Error", "OK", "Error") | Out-Null
            }
        })
    }
}

# Close on ESC
$form.Add_KeyDown({
    if ($_.KeyCode -eq 'Escape') { $form.Close() }
})

# --- Show Window ---
Log "Showing WinForms dialog."
$form.ShowDialog() | Out-Null
Log "Dialog closed. Script finished."

# --- Cleanup ---
$form.Dispose()
