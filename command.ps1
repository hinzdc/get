<#
.SYNOPSIS
    Displays a GUI built with WPF and XAML with a predefined list of commands.
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
    Add-Type -AssemblyName PresentationCore, PresentationFramework, WindowsBase
    Log "WPF assemblies loaded."
} catch {
    Log "Failed to load WPF assemblies: $($_.Exception.Message)"
    exit 1
}

# --- Predefined Data ---
$Commands = @(
    [pscustomobject]@{ Label = 'Menampilkan semua list ini'; Texts = @('iex(irm command.indojava.online)') },
    [pscustomobject]@{ Label = 'Activator Otomatis Windows & Office 2013, 2016, 2019, 2021, 2024, 365 Permanent'; Texts = @('iex(irm activeauto.indojava.online') },
    [pscustomobject]@{ Label = 'Activator Office 2013, 2016, 2019, 2021, 2024, 365 - Permanent'; Texts = @('iex(irm activeoffice.indojava.online)') },
    [pscustomobject]@{ Label = 'Activator Windows Permanent Digital License'; Texts = @('iex(irm activewindows.indojava.online)') },
    [pscustomobject]@{ Label = 'Activator Office 2010, 2013, 2016, 2019, 2021 - KMS Online'; Texts = @('iex(irm kms.indojava.online)') },
    [pscustomobject]@{ Label = 'Activator Windows sampai tahun 2038 - KMS38'; Texts = @('iex(irm kms38.indojava.online)') },
    [pscustomobject]@{ Label = 'Install Office 2013, 2016, 2019, 2021, 2024, 365'; Texts = @('iex(irm office.indojava.online)') },
    [pscustomobject]@{ Label = 'Office Scrub / Uninstal dan Force Remove'; Texts = @('iex(irm officescrub.indojava.online)', 'iex(irm officescrubber.indojava.online)') },
    [pscustomobject]@{ Label = 'Windows Update Contol - Disable/Enable, Pause And Reset Windows Update'; Texts = @('iex(irm windowsupdate.indojava.online)') },
    [pscustomobject]@{ Label = 'Remove or Disable Windows Defender (Turn off readltime Protection before execute)'; Texts = @('iex(irm defender.indojava.online)', 'iex(irm defender2.indojava.online)') },
    [pscustomobject]@{ Label = 'Fix corrupted file system & restore health'; Texts = @('iex(irm fixos.indojava.online)') },
    [pscustomobject]@{ Label = 'Virus Removal Tool - Remove viruses, malware, and other threats from your PC'; Texts = @('iex(irm indojava.online)') },
    [pscustomobject]@{ Label = 'Tweaks Registry'; Texts = @('iex(irm tweaks.indojava.online)') },
    [pscustomobject]@{ Label = 'Debloater - Remove Default App'; Texts = @('iex(irm debloat.indojava.online)') },
    [pscustomobject]@{ Label = 'AMD Support - Driver AMD Installer'; Texts = @('iex(irm amdsupport.indojava.online)') },
    [pscustomobject]@{ Label = 'Block Host - Disable Internet From Activation Detection adobe, autocad, corel etc.'; Texts = @('iex(irm blockhost.indojava.online)') },
    [pscustomobject]@{ Label = 'Reset Network - Reset seluruh konfigurasi untuk internet, LAN atau wifi bermasalah'; Texts = @('iex(irm resetnetwork.indojava.online)') },
    #[pscustomobject]@{ Label = 'Infector Check - cek kerusakan system kana antivirus'; Texts = @('iex(irm indojava.online/get/infectorcheck)') },
    [pscustomobject]@{ Label = 'Winget - Force Install Winget'; Texts = @('iex(irm winget.indojava.online)') }
    #[pscustomobject]@{ Label = 'Force Remove - Hapus Paksa File Dan Folder Yang Sulit Di Hapus'; Texts = @('iex(irm indojava.online/get/ForeceRemove)') }
)

# --- GUI Construction ---

# Define the XAML for the UI, embedded in the script
[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="PowerShell Command Runner" Height="720" Width="680"
    WindowStartupLocation="CenterScreen"
    Background="#FF2D2D30">
    <Window.Resources>
        <Style TargetType="Button">
            <Setter Property="MinWidth" Value="85"/>
            <Setter Property="Background" Value="#FF3E3E42"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Padding" Value="12,6"/>
            <Setter Property="Margin" Value="5,0,0,0"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" CornerRadius="3">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#FF505055"/>
                </Trigger>
            </Style.Triggers>
        </Style>
        <Style TargetType="TextBox">
            <Setter Property="Background" Value="#FF3E3E42"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="BorderBrush" Value="#FF505055"/>
            <Setter Property="Padding" Value="5"/>
            <Setter Property="VerticalContentAlignment" Value="Center"/>
            <Setter Property="FontFamily" Value="Consolas"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="TextBox">
                        <Border Name="border" 
                                Background="{TemplateBinding Background}" 
                                BorderBrush="{TemplateBinding BorderBrush}" 
                                BorderThickness="{TemplateBinding BorderThickness}" 
                                SnapsToDevicePixels="True">
                            <ScrollViewer Name="PART_ContentHost" 
                                          Focusable="false" 
                                          HorizontalScrollBarVisibility="Hidden" 
                                          VerticalScrollBarVisibility="Hidden"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        <Style TargetType="TextBlock">
            <Setter Property="Foreground" Value="#FFE1E1E1"/>
        </Style>
    </Window.Resources>
    <Grid Margin="10">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
        </Grid.RowDefinitions>

        <TextBlock Grid.Row="0" Text="PowerShell Command Runner - AuroraTOOLKIT" 
                   FontSize="24" 
                   FontWeight="Bold" 
                   Foreground="White" 
                   Margin="0,0,0,5"/>

        <TextBlock Grid.Row="1" Text="Kumpulan PowerShell Script untuk berbagai keperluan administrasi, aktivasi, tweaks dan sebagainya." 
                   FontSize="14" 
                   Foreground="#FFCCCCCC" 
                   TextWrapping="Wrap"
                   Margin="0,0,0,20"/>

        <ScrollViewer Grid.Row="2" VerticalScrollBarVisibility="Auto" Padding="0,0,20,0">
            <ItemsControl Name="CommandsItemsControl">
                <ItemsControl.ItemTemplate>
                    <DataTemplate>
                        <StackPanel Margin="0,0,0,15">
                            <TextBlock Text="{Binding Label}" FontWeight="Bold" FontSize="14" Margin="0,0,0,5" Foreground="#FFFFFFFF"/>
                            <ItemsControl ItemsSource="{Binding Texts}">
                                <ItemsControl.ItemTemplate>
                                    <DataTemplate>
                                        <Grid Margin="0,2">
                                            <Grid.ColumnDefinitions>
                                                <ColumnDefinition Width="*"/>
                                                <ColumnDefinition Width="Auto"/>
                                                <ColumnDefinition Width="Auto"/>
                                            </Grid.ColumnDefinitions>
                                            <TextBox Grid.Column="0" Text="{Binding Mode=OneWay}" IsReadOnly="True" />
                                            <Button Grid.Column="1" Name="CopyButton" Content="Copy" />
                                            <Button Grid.Column="2" Name="ExecuteButton" Content="Execute" />
                                        </Grid>
                                    </DataTemplate>
                                </ItemsControl.ItemTemplate>
                            </ItemsControl>
                        </StackPanel>
                    </DataTemplate>
                </ItemsControl.ItemTemplate>
            </ItemsControl>
        </ScrollViewer>
    </Grid>
</Window>
"@

# Create the UI from XAML
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
try {
    $window = [System.Windows.Markup.XamlReader]::Load($reader)
    Log "XAML loaded successfully."
} catch {
    Log "Error loading XAML: $($_.Exception.Message)"
    # Provide detailed error info for debugging XAML issues
    if ($_.Exception.InnerException) {
        Log "Inner Exception: $($_.Exception.InnerException.Message)"
    }
    exit 1
}

# --- Connect Data and Logic ---

# Get the main ItemsControl from the XAML
$commandsItemsControl = $window.FindName("CommandsItemsControl")
if (-not $commandsItemsControl) {
    Log "Could not find 'CommandsItemsControl' in XAML."
    exit 1
}

# Create a single timer for copy feedback
$feedbackTimer = New-Object System.Windows.Threading.DispatcherTimer
$feedbackTimer.Interval = [TimeSpan]::FromSeconds(1.2)
$feedbackTimer.Add_Tick({
    param($s, $e)
    $timer = $s
    if ($timer.Tag -is [System.Windows.Controls.Button]) {
        $timer.Tag.Content = 'Copy'
        $timer.Tag = $null
    }
    $timer.Stop()
})

# Add a single routed event handler for all button clicks within the ItemsControl
$handler = [System.Windows.RoutedEventHandler]{
    param($sender, $e)
    
    # Determine which button was clicked
    $clickedButton = $e.OriginalSource -as [System.Windows.Controls.Button]
    if (-not $clickedButton) { return }

    # The DataContext of the button is the command text string
    $commandText = $clickedButton.DataContext
    if (-not [string]::IsNullOrWhiteSpace($commandText)) {
        
        if ($clickedButton.Name -eq "CopyButton") {
            try {
                [System.Windows.Clipboard]::SetText($commandText)
                Log "Copied: $commandText"
                
                # Visual feedback
                $clickedButton.Content = '✓ Copied'
                $feedbackTimer.Stop()
                $feedbackTimer.Tag = $clickedButton
                $feedbackTimer.Start()
            } catch {
                Log "Clipboard error: $($_.Exception.Message)"
            }
        }
        elseif ($clickedButton.Name -eq "ExecuteButton") {
            try {
                Log "Executing with admin: $commandText"
                Start-Process powershell -Verb RunAs -ArgumentList "-NoExit", "-Command", "& { $commandText }"
            } catch {
                Log "Failed to start process: $($_.Exception.Message)"
            }
        }
    }
}
$commandsItemsControl.AddHandler([System.Windows.Controls.Button]::ClickEvent, $handler)

# Close on ESC
$window.Add_KeyDown({
    if ($_.Key -eq 'Escape') { $window.Close() }
})

# --- Show Window ---

# Bind the data to the ItemsControl
$commandsItemsControl.ItemsSource = $Commands
Log "Data bound and showing WPF dialog."
$window.ShowDialog() | Out-Null
Log "Dialog closed. Script finished."