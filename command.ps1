# STA Relaunch Check (Crucial for any GUI)
if ([System.Threading.Thread]::CurrentThread.ApartmentState -ne 'STA') {
    $psPath = (Get-Command powershell).Source
    $args = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-STA', '-File', $MyInvocation.MyCommand.Path) +
        $PSBoundParameters.GetEnumerator().ForEach({ "-$($_.Key)", "$($_.Value)" })
    Start-Process $psPath -ArgumentList $args -WindowStyle Normal
    exit
}


# --- Main Script ---
try {
    Add-Type -AssemblyName PresentationCore, PresentationFramework, WindowsBase
} catch {
    exit 1
}

# --- Predefined Data ---
# Texts sekarang berisi object: { Text, WindowStyle }
# WindowStyle yang didukung di sini: Normal / Minimized / Maximized
$Commands = @(
    [pscustomobject]@{
        Label = 'Menampilkan semua list ini'
        Texts = @(
            [pscustomobject]@{ Text = 'iex(irm command.indojava.online)'; WindowStyle = 'Minimized' }
        )
    },

    [pscustomobject]@{
        Label = 'Activator Otomatis Windows & Office 2013, 2016, 2019, 2021, 2024, 365 Permanent'
        Texts = @(
            [pscustomobject]@{ Text = 'iex(irm activeauto.indojava.online)'; WindowStyle = 'minimized' }
        )
    },

    [pscustomobject]@{
        Label = 'Activator Office 2013, 2016, 2019, 2021, 2024, 365 - Permanent'
        Texts = @(
            [pscustomobject]@{ Text = 'iex(irm activeoffice.indojava.online)'; WindowStyle = 'Minimized' }
        )
    },

    [pscustomobject]@{
        Label = 'Activator Windows Permanent Digital License'
        Texts = @(
            [pscustomobject]@{ Text = 'iex(irm activewindows.indojava.online)'; WindowStyle = 'Minimized' }
        )
    },

    [pscustomobject]@{
        Label = 'Activator Office 2010, 2013, 2016, 2019, 2021 - KMS Online'
        Texts = @(
            [pscustomobject]@{ Text = 'iex(irm kms.indojava.online)'; WindowStyle = 'Minimized' }
        )
    },

    [pscustomobject]@{
        Label = 'Activator Windows sampai tahun 2038 - KMS38'
        Texts = @(
            [pscustomobject]@{ Text = 'iex(irm kms38.indojava.online)'; WindowStyle = 'Minimized' }
        )
    },

    [pscustomobject]@{
        Label = 'Install Office 2013, 2016, 2019, 2021, 2024, 365'
        Texts = @(
            [pscustomobject]@{ Text = 'iex(irm office.indojava.online)'; WindowStyle = 'Minimized' }
        )
    },

    [pscustomobject]@{
        Label = 'Office Scrub / Uninstal dan Force Remove'
        Texts = @(
            [pscustomobject]@{ Text = 'iex(irm officescrub.indojava.online)';    WindowStyle = 'Normal' }
            [pscustomobject]@{ Text = 'iex(irm officescrubber.indojava.online)'; WindowStyle = 'Normal' }
        )
    },

    [pscustomobject]@{
        Label = 'Windows Update Contol - Disable/Enable, Pause And Reset Windows Update'
        Texts = @(
            [pscustomobject]@{ Text = 'iex(irm windowsupdate.indojava.online)'; WindowStyle = 'Normal' }
        )
    },

    [pscustomobject]@{
        Label = 'Remove or Disable Windows Defender (Turn off realtime Protection before execute)'
        Texts = @(
            [pscustomobject]@{ Text = 'iex(irm defender.indojava.online)';  WindowStyle = 'Normal' }
            [pscustomobject]@{ Text = 'iex(irm defender2.indojava.online)'; WindowStyle = 'Normal' }
        )
    },

    [pscustomobject]@{
        Label = 'Fix corrupted file system & restore health'
        Texts = @(
            [pscustomobject]@{ Text = 'iex(irm fixos.indojava.online)'; WindowStyle = 'Normal' }
        )
    },

    [pscustomobject]@{
        Label = 'Virus Removal Tool - Remove viruses, malware, and other threats from your PC'
        Texts = @(
            [pscustomobject]@{ Text = 'iex(irm indojava.online)'; WindowStyle = 'Normal' }
        )
    },

    [pscustomobject]@{
        Label = 'Tweaks Registry'
        Texts = @(
            [pscustomobject]@{ Text = 'iex(irm tweaks.indojava.online)'; WindowStyle = 'Minimized' }
        )
    },

    [pscustomobject]@{
        Label = 'Debloater - Remove Default App'
        Texts = @(
            [pscustomobject]@{ Text = 'iex(irm debloat.indojava.online)'; WindowStyle = 'Normal' }
        )
    },

    [pscustomobject]@{
        Label = 'AMD Support - Driver AMD Installer'
        Texts = @(
            [pscustomobject]@{ Text = 'iex(irm amdsupport.indojava.online)'; WindowStyle = 'Normal' }
        )
    },

    [pscustomobject]@{
        Label = 'Driver Store Explorer - Restore and Backup Driver'
        Texts = @(
            [pscustomobject]@{ Text = 'iex(irm driverstore.indojava.online)'; WindowStyle = 'Normal' }
        )
    },

    [pscustomobject]@{
        Label = 'Block Host - Disable Internet From Activation Detection adobe, autocad, corel etc.'
        Texts = @(
            [pscustomobject]@{ Text = 'iex(irm blockhost.indojava.online)'; WindowStyle = 'Normal' }
        )
    },

    [pscustomobject]@{
        Label = 'Reset Network - Reset seluruh konfigurasi untuk internet, LAN atau wifi bermasalah'
        Texts = @(
            [pscustomobject]@{ Text = 'iex(irm resetnetwork.indojava.online)'; WindowStyle = 'Normal' }
        )
    },

    [pscustomobject]@{
        Label = 'Winget - Force Install Winget'
        Texts = @(
            [pscustomobject]@{ Text = 'iex(irm winget.indojava.online)'; WindowStyle = 'Normal' }
        )
    }
)

# --- GUI Construction ---

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
            <Setter Property="ToolTipService.InitialShowDelay" Value="150"/>
            <Setter Property="ToolTipService.ShowDuration" Value="5000"/>
            <Setter Property="ToolTip" Value="{x:Null}"/>
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

                <DataTrigger Binding="{Binding RelativeSource={RelativeSource Self}, Path=Tag}" Value="Copy">
                    <Setter Property="ToolTip">
                        <Setter.Value>
                            <ToolTip Placement="Top" Background="#FF232427" Foreground="White" Padding="8" HasDropShadow="True">
                                <TextBlock Text="Copy command lalu paste di powershell/terminal. Dengan akses admin" TextWrapping="Wrap" Width="260"/>
                            </ToolTip>
                        </Setter.Value>
                    </Setter>
                </DataTrigger>

                <DataTrigger Binding="{Binding RelativeSource={RelativeSource Self}, Path=Tag}" Value="Execute">
                    <Setter Property="ToolTip">
                        <Setter.Value>
                            <ToolTip Placement="Top" Background="#FF232427" Foreground="White" Padding="8" HasDropShadow="True">
                                <TextBlock Text="Eksekusi langsung command di samping." TextWrapping="Wrap" Width="220"/>
                            </ToolTip>
                        </Setter.Value>
                    </Setter>
                </DataTrigger>
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

                                            <!-- Texts item now has .Text -->
                                            <TextBox Grid.Column="0" Text="{Binding Text, Mode=OneWay}" IsReadOnly="True" />

                                            <Button Grid.Column="1" Tag="Copy" Content="Copy" />
                                            <Button Grid.Column="2" Tag="Execute" Content="Execute" />
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
} catch {
    if ($_.Exception.InnerException) { Log "Inner Exception: $($_.Exception.InnerException.Message)" }
    exit 1
}
[Console]::OutputEncoding = [System.Text.Encoding]::utf8
# --- Connect Data and Logic ---
$commandsItemsControl = $window.FindName("CommandsItemsControl")
if (-not $commandsItemsControl) {
    exit 1
}

# Copy feedback timer
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

# Routed click handler (uses Tag: Copy/Execute)
$handler = [System.Windows.RoutedEventHandler]{
    param($sender, $e)

    $clickedButton = $e.OriginalSource -as [System.Windows.Controls.Button]
    if (-not $clickedButton) { return }

    $cmdObj = $clickedButton.DataContext
    if (-not $cmdObj) { return }

    $commandText = [string]$cmdObj.Text
    if ([string]::IsNullOrWhiteSpace($commandText)) { return }

    # Normalize WindowStyle (no Hidden here)
    $ws = ([string]$cmdObj.WindowStyle).Trim()
    if ($ws -notin @('Normal','Minimized','Maximized')) { $ws = 'Normal' }

    if ($clickedButton.Tag -eq "Copy") {
        try {
            [System.Windows.Clipboard]::SetText($commandText)

            $clickedButton.Content = '✓ Copied'   # encoding-safe
            $feedbackTimer.Stop()
            $feedbackTimer.Tag = $clickedButton
            $feedbackTimer.Start()
        } catch {
        }
    }
    elseif ($clickedButton.Tag -eq "Execute") {
        try {
            Start-Process powershell -Verb RunAs -WindowStyle $ws -ArgumentList "-Command", "& { $commandText }"
        } catch {
        }
    }
}
$commandsItemsControl.AddHandler([System.Windows.Controls.Button]::ClickEvent, $handler)

# Close on ESC
$window.Add_KeyDown({
    if ($_.Key -eq 'Escape') { $window.Close() }
})

# --- Show Window ---
$commandsItemsControl.ItemsSource = $Commands
$window.ShowDialog() | Out-Null