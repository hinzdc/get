# --- 1. Definisikan Namespace WPF yang Dibutuhkan ---
Add-Type -AssemblyName PresentationCore, PresentationFramework, WindowsBase, System.Windows.Forms, System.Xml, System.Drawing

# --- 2. Definisikan XAML untuk Welcome Screen ---
$welcomeXaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="AuroraTOOLKIT - WhatsApp: 085759217063"
    Height="300" Width="600"
    WindowStartupLocation="CenterScreen"
    ResizeMode="NoResize"
    WindowStyle="None"
    AllowsTransparency="True"
    Background="Transparent">

    <!-- Outer Border with rounded corners -->
    <Border Background="#2D2D30" CornerRadius="10">
        <Grid>
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="30"/>
                <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>

            <!-- Left-side border, also with rounded corners on the left side -->
            <Border Grid.Column="0" Background="#007ACC" CornerRadius="10 0 0 10"/>
            <Viewbox Grid.Column="0" Stretch="None" Margin="0">
            </Viewbox>

            <StackPanel Grid.Column="1" Margin="20">
                <StackPanel Orientation="Horizontal" VerticalAlignment="Top">
                    <Viewbox Stretch="Uniform" Width="64" Height="64" Margin="0,0,10,0">
                        <Image x:Name="LogoImage" Height="500" Stretch="Fill" Width="500"/>
                    </Viewbox>
                    <StackPanel>
                        <TextBlock Text="AuroraTOOLKIT"
                                   FontSize="24"
                                   FontWeight="SemiBold"
                                   Foreground="White"/>
                        <TextBlock Text="OLIH X SARGA - Managed App Installer"
                                   FontSize="12"
                                   Foreground="LightGray"/>
                    </StackPanel>
                </StackPanel>

                <!-- Inner Border, also rounded -->
                <Border BorderBrush="#4A4A4A" BorderThickness="1" CornerRadius="10" Margin="0,20,0,0" Padding="10" Background="#3D3D3D">
                    <StackPanel>
                        <TextBlock Text="Welcome to the App installer for Windows."
                                   Foreground="White"
                                   TextAlignment="Center"
                                   FontSize="16"
                                   Margin="0,0,0,10"/>
                        <TextBlock Text="The installation will start automatically in"
                                   Foreground="LightGray"
                                   TextAlignment="Center"
                                   FontSize="12"
                                   Margin="0,0,0,10"/>
                        <TextBlock Name="CountdownTextBlock"
                                   Text="10"
                                   Foreground="#007ACC"
                                   FontSize="48"
                                   FontWeight="Bold"
                                   HorizontalAlignment="Center"/>
                        <TextBlock Text="This window will close automatically when the installation is complete."
                                   TextAlignment="Center"
                                   Foreground="LightGray"
                                   FontSize="12"
                                   Margin="0,10,0,0"/>
                    </StackPanel>
                </Border>
            </StackPanel>
        </Grid>
    </Border>
</Window>

"@

# --- 3. Definisikan XAML untuk Installation Screen ---
$installationXaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="AuroraTOOLKIT - WhatsApp: 085759217063"
    Height="250" Width="600"
    WindowStartupLocation="CenterScreen"
    ResizeMode="NoResize"
    WindowStyle="None"
    AllowsTransparency="True"
    Background="Transparent">

    <!-- Outer Border with rounded corners and main background color -->
    <Border Background="#2D2D30" CornerRadius="10">
        <Grid>
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="30"/>
                <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>

            <!-- Left-side border, with rounded corners on the left side -->
            <Border Grid.Column="0" Background="#007ACC" CornerRadius="10 0 0 10"/>

            <!-- Main content area -->
            <StackPanel Grid.Column="1" Margin="20">
                <StackPanel Orientation="Horizontal" VerticalAlignment="Top">
                    <!-- Logo Section -->
                    <Viewbox Stretch="Uniform" Width="64" Height="64" Margin="0,0,10,0">
                        <Image x:Name="InstallationLogoImage" Height="500" Stretch="Fill" Width="500"/>
                    </Viewbox>

                    <!-- Title and Subtitle Section -->
                    <StackPanel>
                        <TextBlock Text="AuroraTOOLKIT"
                                   FontSize="24"
                                   FontWeight="SemiBold"
                                   Foreground="White"/>
                        <TextBlock Text="OLIH X SARGA - Managed App Installer"
                                   FontSize="12"
                                   Foreground="LightGray"/>
                    </StackPanel>
                </StackPanel>

                <!-- Inner Border with installation details -->
                <Border BorderBrush="#4A4A4A" BorderThickness="1" CornerRadius="10" Margin="0,20,0,0" Padding="20" Background="#3D3D3D">
                    <StackPanel>
                        <!-- Status text -->
                        <TextBlock Name="StatusTextBlock"
                                   Text="Installation in progress. Please wait..."
                                   Foreground="White"
                                   FontSize="16"
                                   Margin="0,0,0,20"/>

                        <!-- Closing message -->
                        <TextBlock Text="This window will close automatically when the installation is complete."
                                   Foreground="LightGray"
                                   TextAlignment="Center"
                                   FontSize="12"/>

                        <!-- Progress bar -->
                        <ProgressBar Name="InstallationProgressBar"
                                     Height="12"
                                     Margin="0,10,0,0"
                                     Foreground="#3dabff"
                                     Background="#2d3137"
                                     Value="0"/>
                    </StackPanel>
                </Border>
            </StackPanel>
        </Grid>
    </Border>
</Window>

"@

# banner terminal
# ASCII Art dalam Unicode [char]
$text = @"

                                                  $([char]0x2554)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2557)
         $([char]0x2554)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2567)$([char]0x2563) ISTANA BEC LANTAI 1 BLOK D7 $([char]0x2551)
         $([char]0x2551)                                        $([char]0x255A)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2563)
         $([char]0x2551)   $([char]0x2588)$([char]0x2588)                                $([char]0x2588)$([char]0x2588)                               $([char]0x2551)
         $([char]0x2551)   $([char]0x2591)$([char]0x2591) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2592)$([char]0x2592) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2584)$([char]0x2580) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)      $([char]0x2591)$([char]0x2591) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)     $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)   $([char]0x2551)
         $([char]0x2551)   $([char]0x2588)$([char]0x2588)       $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588)      $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)     $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588)   $([char]0x2551)
         $([char]0x2551)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588) $([char]0x2580)$([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588)$([char]0x2580) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)   $([char]0x2551)
         $([char]0x2551)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2580)$([char]0x2584) $([char]0x2592)$([char]0x2592)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588)    $([char]0x2580)$([char]0x2588)$([char]0x2580)    $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588)   $([char]0x2551)
         $([char]0x2551)                                                                      $([char]0x2551)
         $([char]0x255A)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x255D)
"@
Clear-Host
Write-Host
Write-Host $text -ForegroundColor Cyan
Write-Host "                               -- INSTALLER APPS STANDARD --" -ForegroundColor Red
Write-Host "------------------------------------------------------------------------------------------"
Write-Host "   SERVICE - SPAREPART - UPGRADE - MAINTENANCE - INSTALL ULANG - JUAL - TROUBLESHOOTING   " -foregroundColor White
Write-Host "------------------------------------------------------------------------------------------"
# --- Fungsi untuk memuat XAML ---

function Load-Xaml {
    param($xamlContent)
    try {
        $xml = New-Object System.Xml.XmlDocument
        $xml.LoadXml($xamlContent)
        $reader = New-Object System.Xml.XmlNodeReader $xml
        [System.Windows.Markup.XamlReader]::Load($reader)
    } catch {
        Write-Host "Error: Gagal mem-parsing XAML."
        Write-Host $_.Exception.Message
        throw
    }
}

# --- 4. Tampilkan Welcome Screen dan Jalankan Hitungan Mundur ---
$welcomeWindow = Load-Xaml -xamlContent $welcomeXaml

# Icon
$welcomeWindow.Icon = [System.Windows.Media.Imaging.BitmapFrame]::Create(
    (New-Object System.Uri "$PSScriptRoot\logo.png")
)

# Muat logo secara dinamis
try {
    $logoImage = $welcomeWindow.FindName("LogoImage")
    if ($logoImage) {
        $logoPath = Join-Path $PSScriptRoot "logo.png"
        if (Test-Path $logoPath) {
            $bitmap = [System.Windows.Media.Imaging.BitmapImage]::new()
            $bitmap.BeginInit()
            $bitmap.UriSource = [System.Uri]::new($logoPath, [System.UriKind]::Absolute)
            $bitmap.EndInit()
            $logoImage.Source = $bitmap
        } else {
            Write-Warning "logo.png tidak ditemukan di $PSScriptRoot"
        }
    }
} catch {
    Write-Warning "Gagal memuat logo: $_"
}

$countdownTextBlock = $welcomeWindow.FindName("CountdownTextBlock")
$dispatcher = $welcomeWindow.Dispatcher

$welcomeWindow.Show() | Out-Null

for ($i = 10; $i -ge 1; $i--) {
    $dispatcher.Invoke([Action[int]]{
        param($countdownValue)
        $countdownTextBlock.Text = "$countdownValue"
    }, $i)

    # Mempercepat pemrosesan pesan UI agar tidak membeku
    [System.Windows.Threading.Dispatcher]::CurrentDispatcher.Invoke([Action]{}, [System.Windows.Threading.DispatcherPriority]::Background)

    Start-Sleep -Seconds 1
}

# Tutup welcome screen sebelum beralih ke layar instalasi
$welcomeWindow.Close()

# --- 5. Tampilkan Installation Screen dan Jalankan Instalasi ---
$installationWindow = Load-Xaml -xamlContent $installationXaml

# icon
$installationWindow.Icon = [System.Windows.Media.Imaging.BitmapFrame]::Create(
    (New-Object System.Uri "$PSScriptRoot\logo.png")
)

# Muat logo untuk jendela instalasi
try {
    $logoImage = $installationWindow.FindName("InstallationLogoImage")
    if ($logoImage) {
        $logoPath = Join-Path $PSScriptRoot "logo.png"
        if (Test-Path $logoPath) {
            $bitmap = [System.Windows.Media.Imaging.BitmapImage]::new()
            $bitmap.BeginInit()
            $bitmap.UriSource = [System.Uri]::new($logoPath, [System.UriKind]::Absolute)
            $bitmap.EndInit()
            $logoImage.Source = $bitmap
        } else {
            Write-Warning "logo.png tidak ditemukan di $PSScriptRoot"
        }
    }
} catch {
    Write-Warning "Gagal memuat logo untuk jendela instalasi: $_"
}

$statusTextBlock = $installationWindow.FindName("StatusTextBlock")
$progressBar = $installationWindow.FindName("InstallationProgressBar")
$dispatcher = $installationWindow.Dispatcher

$installationWindow.Show() | Out-Null


# --- 6. Jalankan logika instalasi ---
# Fungsi pembantu untuk memproses antrian pesan UI dan menjaga agar jendela tidak membeku.
function Process-UIEvents {
    param($Dispatcher)
    # Jalankan operasi kosong pada prioritas Latar Belakang untuk memproses pesan UI.
    $Dispatcher.Invoke([Action]{}, [System.Windows.Threading.DispatcherPriority]::Background) | Out-Null
}

$appList = @(
    @{ 
        Name = "WinRAR"
        Path = "$PSScriptRoot\Files\winrar-x64-711.exe"
        Args = "/S"
        Check = { $checkPath = "$env:ProgramFiles\WinRAR\WinRAR.exe"; $result = Test-Path $checkPath; Write-Host "DEBUG: Checking WinRAR at '$checkPath'. Result: $result"; return $result }
    },
    @{ 
        Name = "AIMP"
        Path = "$PSScriptRoot\Files\aimp_5.40.2689_w64.exe"
        Args = "/AUTO /SILENT"
        Check = { $checkPath = "C:\Program Files\AIMP\AIMP.exe"; $result = Test-Path $checkPath; Write-Host "DEBUG: Checking AIMP at '$checkPath'. Result: $result"; return $result }
    },
    @{ 
        Name = "Google Chrome"
        Path = "$PSScriptRoot\Files\ChromeStandaloneSetup64.exe"
        Args = "/silent /install"
        Check = { $checkPath = "$env:ProgramFiles\Google\Chrome\Application\chrome.exe"; $result = Test-Path $checkPath; Write-Host "DEBUG: Checking Google Chrome at '$checkPath'. Result: $result"; return $result }
    },
    @{ 
        Name = "Mircosoft Visual C++ 2015-2022 Redistributable (x64)"
        Path = "$PSScriptRoot\Files\VC_redist.x64.exe"
        Args = "/install /passive /norestart"
        Check = { 
            $regPath = "HKLM:\SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64"
            if (Test-Path $regPath) {
                $installed = (Get-ItemProperty $regPath).Installed
                $result = ($installed -eq 1)
                Write-Host "DEBUG: Checking Visual C++ 2015-2022 Redist (x64). Installed flag: $installed. Result: $result"
            }
            else {
                $result = $false
                Write-Host "DEBUG: Registry path Visual C++ 2015-2022 Redist (x64) not found. Result: $result"
            }
            return $result
        }
    },
    @{
        Name = "Microsoft Visual C++ 2015-2022 Redistributable (x86)"
        Path = "$PSScriptRoot\Files\VC_redist.x86.exe"
        Args = "/install /passive /norestart"
        Check = { 
            $regPath = "HKLM:\SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x86"
            if (Test-Path $regPath) {
                $installed = (Get-ItemProperty $regPath).Installed
                $result = ($installed -eq 1)
                Write-Host "DEBUG: Checking Visual C++ 2015-2022 Redist (x86). Installed flag: $installed. Result: $result"
            }
            else {
                $result = $false
                Write-Host "DEBUG: Registry path Visual C++ 2015-2022 Redist (x86) not found. Result: $result"
            }
            return $result
        }
    },
    @{ 
        Name = "Zoom Workplace"
        Path = "$PSScriptRoot\Files\ZoomInstallerFull.msi"
        Args = "/quiet /qn /norestart /log install.log ZoomAutoUpdate=true ZNoDesktopShortCut=false ZoomAutoStart=false"
        Check = { $checkPath = "$env:ProgramFiles\Zoom\bin\Zoom.exe"; $result = Test-Path $checkPath; Write-Host "DEBUG: Checking Zoom Workplace at '$checkPath'. Result: $result"; return $result }
    },
    @{ 
        Name = "Canva"
        Path = "$PSScriptRoot\Files\CanvaSetup.exe"
        Args = "/s"
        Check = { $checkPath = "$env:UserProfile\AppData\Local\Programs\Canva\canva.exe"; $result = Test-Path $checkPath; Write-Host "DEBUG: Checking Canva at '$checkPath'. Result: $result"; return $result }
    },
    @{ 
        Name = "Mozilla Firefox"
        Path = "$PSScriptRoot\Files\Firefox Setup 141.0.3.exe"
        Args = "/s"
        Check = { $checkPath = "$env:ProgramFiles\Mozilla Firefox\firefox.exe"; $result = Test-Path $checkPath; Write-Host "DEBUG: Checking Mozilla Firefox at '$checkPath'. Result: $result"; return $result }
    },
    @{ 
        Name = "VLC Media Player"
        Path = "$PSScriptRoot\Files\vlc-3.0.9.2-win64.exe"
        Args = "/L=1033 /S"
        Check = { $checkPath = "$env:ProgramFiles\VideoLAN\VLC\vlc.exe"; $result = Test-Path $checkPath; Write-Host "DEBUG: Checking VLC Media Player at '$checkPath'. Result: $result"; return $result }
    },
    @{ 
        Name = "Microsoft Edge WebView2 Runtime (x64)"
        Path = "$PSScriptRoot\Files\MicrosoftEdgeWebView2RuntimeInstallerX64.exe"
        Args = "/silent /install"
        Check = { $checkPath = "C:\Program Files (x86)\Microsoft\EdgeWebView\Application\139.0.3405.86\msedgewebview2.exe"; $result = Test-Path $checkPath; Write-Host "DEBUG: Checking Microsoft WebView2 Runtime (x64) at '$checkPath'. Result: $result"; return $result }
    },
    @{ 
        Name = "Nitro PDF Pro"
        Path = "$PSScriptRoot\Files\NitroPDF.msi"
        Args = "/qb /norestart"
        Check = { $checkPath = "$env:ProgramFiles\Nitro\PDF Pro\14\NitroPDF.exe"; $result = Test-Path $checkPath; Write-Host "DEBUG: Checking Nitro PDF Pro at '$checkPath'. Result: $result"; return $result }
    }
)

$totalApps = $appList.Count
$appsCompleted = 0

foreach ($app in $appList) {
    if (& $app.Check) {
        $status = "$($app.Name) Already Installed - Skipped."
        $dispatcher.Invoke([Action]{
            $statusTextBlock.Text = $status
            # Mengatur warna foreground menjadi warna hijau untuk menunjukkan status "terlewat"
            $progressBar.Foreground = [System.Windows.Media.Brushes]::DodgerBlue
        })
        Process-UIEvents -Dispatcher $dispatcher
        Start-Sleep -Seconds 3 # Jeda agar teks dapat dibaca
    } else {
    # Check if installer file exists before attempting to run
    if (-not (Test-Path $app.Path)) {
        $status = "Failed: Installer $($app.Name) not found in $($app.Path)."
        $dispatcher.Invoke([Action]{
            $statusTextBlock.Text = $status
            $progressBar.IsIndeterminate = $false # Ensure progress bar is not indeterminate
            # Mengatur warna foreground menjadi warna merah untuk menunjukkan error
            $progressBar.Foreground = [System.Windows.Media.Brushes]::Red
        })
        Process-UIEvents -Dispatcher $dispatcher
        Start-Sleep -Seconds 5 # Pause longer for critical error
        $appsCompleted++
        $progressValue = [math]::Floor(($appsCompleted / $totalApps) * 100)
        $dispatcher.Invoke([Action]{
            $progressBar.Value = $progressValue
            # Mengembalikan warna default setelah jeda
            $progressBar.Foreground = [System.Windows.Media.Brushes]::DodgerBlue
        })
        continue # Skip to next app
    }

    $status = "Installing $($app.Name)..."
    $dispatcher.Invoke([Action]{
        $statusTextBlock.Text = $status
        $progressBar.IsIndeterminate = $true
    })
    Process-UIEvents -Dispatcher $dispatcher

    Write-Host "DEBUG: Before Start-Job for $($app.Name). \$app.Path: '$($app.Path)', \$app.Args: '$($app.Args)'"
    # Jalankan instalasi di background job agar UI tidak membeku
    $installJob = Start-Job -ScriptBlock {
        param($AppObject) # Pass the entire app object
        $Path = $AppObject.Path
        $Args = $AppObject.Args
        $AppName = $AppObject.Name

        Write-Host "DEBUG: Inside Job for $AppName. Path: '$Path', Args: '$Args'"
        try {
            # Conditionally add ArgumentList if $Args is not empty
            if (-not [string]::IsNullOrEmpty($Args)) {
                $process = Start-Process -FilePath $Path -ArgumentList $Args -Wait -PassThru -WindowStyle Hidden -ErrorAction Stop
            } else {
                $process = Start-Process -FilePath $Path -Wait -PassThru -WindowStyle Hidden -ErrorAction Stop
            }
            Write-Host "DEBUG: $AppName installer finished. Exit Code: $($process.ExitCode)"
            if ($process.ExitCode -eq 0) {
                return "Success"
            } else {
                return "Failed with exit code: $($process.ExitCode)"
            }
        } catch {
            Write-Host "DEBUG: Error during $AppName installation: $($_.Exception.Message)"
            return "Failed: $($_.Exception.Message)"
        }
    } -ArgumentList $app # Pass the entire app object

    # Tunggu job selesai sambil menjaga UI tetap responsif
    while ($installJob.State -eq 'Running') {
        Process-UIEvents -Dispatcher $dispatcher
        Start-Sleep -Milliseconds 100
    }

    # Check job state for errors before receiving output
    if ($installJob.State -eq 'Failed') {
        $errorDetails = $installJob.ChildJobs[0].JobStateInfo.Reason.Message
        $result = "Failed: Job PowerShell failed. Detail: $errorDetails"
    } else {
        $result = Receive-Job -Job $installJob
    }
    Remove-Job -Job $installJob # Bersihkan job setelah selesai

    # Perbarui UI dengan hasil instalasi
    $dispatcher.Invoke([Action]{
        $progressBar.IsIndeterminate = $false
        if ($result -eq "Success") {
            $statusTextBlock.Text = "$($app.Name) installed successfully."
            $progressBar.Foreground = [System.Windows.Media.Brushes]::MediumSeaGreen
        } else {
            $statusTextBlock.Text = "Failed to install $($app.Name). Detail: $result"
            $progressBar.Foreground = [System.Windows.Media.Brushes]::Red
        }
    })
    Process-UIEvents -Dispatcher $dispatcher
    Start-Sleep -Seconds 2 # Jeda lebih lama setelah instalasi (sukses atau gagal)
    }
        
    $appsCompleted++
    $progressValue = [math]::Floor(($appsCompleted / $totalApps) * 100)
    $dispatcher.Invoke([Action]{
        $progressBar.Value = $progressValue
    })
}

# GPT fix - start
# Daftar semua proses yang akan dihentikan
$processesToStop = "PowerToys.Settings", "canva"

foreach ($processName in $processesToStop) {
    # Perbarui status UI
    $status = "Menutup aplikasi: $processName..."
    $dispatcher.Invoke([Action]{
        $statusTextBlock.Text = $status
        $progressBar.IsIndeterminate = $true
        # Warna progress bar bisa diubah sementara
        $progressBar.Foreground = [System.Windows.Media.Brushes]::Orange
    })
    Process-UIEvents -Dispatcher $dispatcher
    
    # Hentikan proses, jika ada
    Stop-Process -name $processName -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1
    
    # Beri jeda kecil untuk memastikan UI terupdate dan proses berhenti
    Start-Sleep -Milliseconds 500
}

# Mengembalikan progress bar ke mode normal setelah menutup proses
$dispatcher.Invoke([Action]{
    $progressBar.IsIndeterminate = $true
    # Kembalikan warna default atau warna lain yang diinginkan
    $progressBar.Foreground = [System.Windows.Media.Brushes]::DodgerBlue
})
Process-UIEvents -Dispatcher $dispatcher

# Definisi Tweak Registry
$registryTweaks = @(
    @{
        Name = "Disable All Suggestions"
        Description = "Disable saran pencarian dan iklan di Windows."
        Actions = @(
            @{ Description = "Disable saran pencarian di Start Menu & Cortana"; 
                Action = { 
                    $regPath = "HKCU:\Software\Policies\Microsoft\Windows\Explorer"
                    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
                    Set-ItemProperty -Path $regPath -Name "DisableSearchBoxSuggestions" -Value 1 -Type DWord
                }
            },
            @{ Description = "Disable pencarian Bing & Cortana";
                Action = {
                    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
                    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
                    Set-ItemProperty -Path $regPath -Name "BingSearchEnabled" -Value 0 -Type DWord
                    Set-ItemProperty -Path $regPath -Name "CortanaConsent" -Value 0 -Type DWord
                }
            },
            @{ Description = "Disable saran di File Explorer";
                Action = {
                    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete"
                    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
                    Set-ItemProperty -Path $regPath -Name "AutoSuggest" -Value "no" -Type String
                }
            },
            @{ Description = "Disable aplikasi yang disarankan di Start Menu";
                Action = {
                    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
                    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
                    $values = "SubscribedContent-338389Enabled", "SubscribedContent-353694Enabled", "SubscribedContent-353696Enabled", "SubscribedContent-338393Enabled"
                    foreach ($name in $values) { Set-ItemProperty -Path $regPath -Name $name -Value 0 -Type DWord }
                }
            },
            @{ Description = "Disable saran di Settings App";
                Action = {
                    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
                    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
                    $values = "SubscribedContent-338394Enabled", "SubscribedContent-353698Enabled"
                    foreach ($name in $values) { Set-ItemProperty -Path $regPath -Name $name -Value 0 -Type DWord }
                }
            },
            @{ Description = "Disable saran di Lock Screen";
                Action = {
                    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
                    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
                    Set-ItemProperty -Path $regPath -Name "RotatingLockScreenEnabled" -Value 0 -Type DWord
                    Set-ItemProperty -Path $regPath -Name "RotatingLockScreenOverlayEnabled" -Value 0 -Type DWord
                }
            }
        )
    },
    @{
        Name = "Disable Tips dan Saran Tambahan"
        Description = "Disable tips, trik, dan saran dari Windows di berbagai lokasi, termasuk notifikasi."
        Actions = @(
            @{
                Description = "Disable tips dan saran saat menggunakan Windows"
                Action = {
                    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
                    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
                    Set-ItemProperty -Path $regPath -Name "SubscribedContent-338393Enabled" -Value 0 -Type DWord -ErrorAction SilentlyContinue
                }
            },
            @{
                Description = "Disable saran untuk menyelesaikan penyiapan perangkat"
                Action = {
                    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
                    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
                    Set-ItemProperty -Path $regPath -Name "SubscribedContent-310093Enabled" -Value 0 -Type DWord -ErrorAction SilentlyContinue
                }
            },
            @{
                Description = "Disable saran dalam notifikasi (Toast Enabled)"
                Action = {
                    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications"
                    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
                    Set-ItemProperty -Path $regPath -Name "ToastEnabled" -Value 0 -Type DWord -ErrorAction SilentlyContinue
                }
            },
            @{
                Description = "Disable iklan dan tips di layar kunci"
                Action = {
                    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
                    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
                    Set-ItemProperty -Path $regPath -Name "RotatingLockScreenEnabled" -Value 0 -Type DWord -ErrorAction SilentlyContinue
                    Set-ItemProperty -Path $regPath -Name "RotatingLockScreenOverlayEnabled" -Value 0 -Type DWord -ErrorAction SilentlyContinue
                }
            }
        )
    }
)


# Hitung total tweak untuk progress bar
$totalTweakActions = 0
foreach ($tweak in $registryTweaks) {
    if ($tweak.Actions) {
        $totalTweakActions += $tweak.Actions.Count
    }
}

# Jalankan semua tweak
$tweakCount = 0
foreach ($tweak in $registryTweaks) {
    # Perbarui status UI untuk tweak utama
    $dispatcher.Invoke([Action]{
        $statusTextBlock.Text = "Apply Tweaks: $($tweak.Name)..."
        $progressBar.IsIndeterminate = $true
        $progressBar.Foreground = [System.Windows.Media.Brushes]::DodgerBlue
    })
    Process-UIEvents -Dispatcher $dispatcher
    
    if ($tweak.Actions) {
        foreach ($action in $tweak.Actions) {
            $tweakCount++
            
            # Perbarui status UI untuk setiap aksi tweak
            $dispatcher.Invoke([Action]{
                $statusTextBlock.Text = "Tweak: $($action.Description)"
                $progressBar.Value = [math]::Round(($tweakCount / $totalTweakActions) * 100)
            })
            if ($totalTweakActions -gt 0) {
                # Baris ini diperbaiki
                $progressBar.Value = [math]::Round(($tweakCount / $totalTweakActions) * 100)
            }

            try {
                & $action.Action
                Write-Host "DEBUG: Registry - $($action.Description)"
            } catch {
                Write-Warning "Gagal menerapkan tweak: $($action.Description). Error: $_"
            }
            
            Start-Sleep -Milliseconds 200
        }
    }
}
# GPT fix - end


# Pembaruan terakhir setelah semua instalasi selesai
$dispatcher.Invoke([Action]{
    $statusTextBlock.Text = "Instalasi selesai. Jendela akan ditutup sebentar lagi..."
    $progressBar.Value = 100
    $progressBar.Foreground = [System.Windows.Media.Brushes]::MediumSeaGreen
})

Process-UIEvents -Dispatcher $dispatcher # Ensure UI updates are processed
Start-Sleep -Seconds 15 # Increased sleep duration as requested
$installationWindow.Close()
