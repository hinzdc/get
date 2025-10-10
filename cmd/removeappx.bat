<# ::
@echo off
title // REMOVE APPX - AuroraTOOLKIT - HINZDC X SARGA
mode con cols=90 lines=30
color 0B

:Begin UAC check and Auto-Elevate Permissions
:-------------------------------------
REM  --> Check for permissions
echo:
echo:
echo                 Requesting Administrative Privileges...
echo:
echo                 ENABLING ADMINISTRATOR RIGHTS...
echo                 Press YES in UAC Prompt to Continue
echo.
echo		 	     Please Wait...
echo:

::# elevate with native shell by AveYo
>nul reg add hkcu\software\classes\.Admin\shell\runas\command /f /ve /d "cmd /x /d /r set \"f0=%%2\"& call \"%%2\" %%3"& set _= %*
>nul fltmc|| if "%f0%" neq "%~f0" (cd.>"%temp%\runas.Admin" & start "%~n0" /high "%temp%\runas.Admin" "%~f0" "%_:"=""%" & cls & exit /b)

    pushd "%CD%"
    CD /D "%~dp0"
cls

reg add "HKCU\Console" /v QuickEdit /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Console\%SystemRoot%_system32_cmd.exe" /v QuickEdit /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Console\%SystemRoot%_SysWOW64_cmd.exe" /v QuickEdit /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Console\%SystemRoot%_Sysnative_cmd.exe" /v QuickEdit /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe" /v QuickEdit /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Console\%SystemRoot%_system32_conhost.exe" /v QuickEdit /t REG_DWORD /d 0 /f >nul 2>&1

powershell -c "iex ((Get-Content '%~f0') -join [Environment]::Newline); iex 'main %*'"
goto :eof

#>

#-----------------------------------------------------------------------------------------
$ProgressPreference = 'SilentlyContinue'
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class ConsoleControl {
    [DllImport("kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();

    [DllImport("user32.dll")]
    public static extern int GetWindowLong(IntPtr hWnd, int nIndex);

    [DllImport("user32.dll")]
    public static extern int SetWindowLong(IntPtr hWnd, int nIndex, int dwNewLong);

    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

    [DllImport("user32.dll")]
    public static extern int GetSystemMenu(IntPtr hWnd, bool bRevert);

    [DllImport("user32.dll")]
    public static extern bool RemoveMenu(int hMenu, int uPosition, int uFlags);
}
"@

# Mendapatkan handle jendela konsol saat ini
$consoleHandle = [ConsoleControl]::GetConsoleWindow()

# Mengatur constant untuk mengubah properti jendela konsol
$GWL_STYLE = -16
$WS_MAXIMIZEBOX = 0x10000
$WS_SIZEBOX = 0x40000

# Mengambil style jendela saat ini
$currentStyle = [ConsoleControl]::GetWindowLong($consoleHandle, $GWL_STYLE)

# Menghapus kemampuan untuk diubah ukurannya, dimaksimalkan dan menutup jendela
$newStyle = $currentStyle -band -bnot $WS_SIZEBOX -band -bnot $WS_MAXIMIZEBOX

# Menerapkan style baru ke jendela
[ConsoleControl]::SetWindowLong($consoleHandle, $GWL_STYLE, $newStyle) > $null

# Menyembunyikan jendela jika sudah dimodifikasi (untuk memastikan tidak ada kesalahan)
[ConsoleControl]::ShowWindow($consoleHandle, 5) > $null  # 5 = SW_SHOW

# Menghapus menu sistem (termasuk tombol Close/X)
$hMenu = [ConsoleControl]::GetSystemMenu($consoleHandle, $false)
[ConsoleControl]::RemoveMenu($hMenu, 0xF060, 0x0) > $null  # 0xF060 = SC_CLOSE (tombol Close)

function UnQuickEdit
{
	$t=[AppDomain]::CurrentDomain.DefineDynamicAssembly((Get-Random), 1).DefineDynamicModule((Get-Random), $False).DefineType((Get-Random))
	$t.DefinePInvokeMethod('GetStdHandle', 'kernel32.dll', 22, 1, [IntPtr], @([Int32]), 1, 3).SetImplementationFlags(128)
	$t.DefinePInvokeMethod('SetConsoleMode', 'kernel32.dll', 22, 1, [Boolean], @([IntPtr], [Int32]), 1, 3).SetImplementationFlags(128)
	$t.DefinePInvokeMethod('GetConsoleWindow', 'kernel32.dll', 22, 1, [IntPtr], @(), 1, 3).SetImplementationFlags(128)
	$t.DefinePInvokeMethod('SendMessageW', 'user32.dll', 22, 1, [IntPtr], @([IntPtr], [UInt32], [IntPtr], [IntPtr]), 1, 3).SetImplementationFlags(128)
	$k=$t.CreateType()
	if ($winbuild -GE 17763) {
		if ($k::SendMessageW($k::GetConsoleWindow(), 127, 0, 0) -EQ [IntPtr]::Zero) {
			return
		}
	}
	$v=(0x0080, 0x00A0)[!($winbuild -GE 10586)]
	$b=$k::SetConsoleMode($k::GetStdHandle(-10), $v)
}
UnQuickEdit
#-----------------------------------------------------------------------------------------
# Ambil handle jendela aktif (foreground window)
Add-Type -Name Win32 -Namespace Win32Functions -MemberDefinition @"
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll")]
    public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

    [DllImport("user32.dll")]
    public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);

    public struct RECT {
        public int Left;
        public int Top;
        public int Right;
        public int Bottom;
    }
"@

$hwnd = [Win32Functions.Win32]::GetForegroundWindow()

if ($hwnd -eq [IntPtr]::Zero) {
    return
}

# Ambil ukuran jendela
$rect = New-Object Win32Functions.Win32+RECT
[Win32Functions.Win32]::GetWindowRect($hwnd, [ref]$rect) | Out-Null
$w = $rect.Right - $rect.Left
$h = $rect.Bottom - $rect.Top

# Pindahkan jendela ke posisi baru tanpa mengubah ukuran
[Win32Functions.Win32]::MoveWindow($hwnd, 50, 10, $w, $h, $true)

#-----------------------------------------------------------------------------------------
$Host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size(90, 30)
$Host.UI.RawUI.WindowTitle = '> REMOVE APPX - AuroraTOOLKIT - HINZDC X SARGA'

cls
$colors = @("Cyan", "Blue", "Red", "White", "DarkRed", "DarkCyan")
$randomColor = Get-Random -InputObject $colors
$randomColor2 = Get-Random -InputObject $colors
$text = @"
                                                  $([char]0x2554)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2557)
         $([char]0x2554)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2563)  OLIH X SARGA A.K.A HINZDC  $([char]0x2551)
         $([char]0x2551)                                        $([char]0x255A)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2563)
         $([char]0x2551)           $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)            $([char]0x2551)
         $([char]0x2551)           $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588)            $([char]0x2551)
         $([char]0x2551)           $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2591)  $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2591)  $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)            $([char]0x2551)
         $([char]0x2551)           $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2592)$([char]0x2592) $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588)            $([char]0x2551)
         $([char]0x2551)                                                                      $([char]0x2551)
         $([char]0x2551)        $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588) $([char]0x255A)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2566)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x2569)$([char]0x255D) $([char]0x2588)$([char]0x2588)       $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)         $([char]0x2551)
         $([char]0x2551)           $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)       $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)   $([char]0x2591)$([char]0x2591)    $([char]0x2588)$([char]0x2588)            $([char]0x2551)
         $([char]0x2551)           $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588) $([char]0x2584) $([char]0x2588)$([char]0x2588)$([char]0x2566)$([char]0x2588)$([char]0x2588) $([char]0x2584) $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)       $([char]0x2588)$([char]0x2588)$([char]0x2588)     $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588)            $([char]0x2551)
         $([char]0x2551)           $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588)$([char]0x2569)$([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)       $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588)            $([char]0x2551)
         $([char]0x2551)           $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2591) $([char]0x2591)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)$([char]0x2588)  $([char]0x2588)$([char]0x2588)   $([char]0x2588)$([char]0x2588) $([char]0x2588)$([char]0x2588)    $([char]0x2588)$([char]0x2588)            $([char]0x2551)
         $([char]0x2551)                    $([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x255D) $([char]0x255A)$([char]0x2550)$([char]0x2550)$([char]0x2550)                                         $([char]0x2551)
         $([char]0x255A)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2550)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x2564)$([char]0x255D)
"@
Write-Host $text -ForegroundColor $randomColor
Write-Host "                             ----- REMOVE DEFAULT APPX  -----" -ForegroundColor $randomColor2
Write-Host
Write-Host "------------------------------------------------------------------------------------------"
Write-Host "   SERVICE - SPAREPART - UPGRADE - MAINTENANCE - INSTALL ULANG - JUAL - TROUBLESHOOTING   " -ForegroundColor Red
Write-Host "------------------------------------------------------------------------------------------"

# Embedded App List
$embeddedAppsList = @"
# -------------------------------------------------------------------------------------------------------------- #
#  The apps below this line WILL be uninstalled by default. Add a # character in front of any app you want to    #
#   KEEP installed by default.                                                                                   #
# -------------------------------------------------------------------------------------------------------------- #
Clipchamp.Clipchamp                            # Video editor from Microsoft
Microsoft.3DBuilder                            # Basic 3D modeling software
Microsoft.549981C3F5F10                        # Cortana app (Voice assistant)
Microsoft.BingFinance                          # Finance news and tracking via Bing (Discontinued)
Microsoft.BingFoodAndDrink                     # Recipes and food news via Bing (Discontinued)
Microsoft.BingHealthAndFitness                 # Health and fitness tracking/news via Bing (Discontinued)
Microsoft.BingNews                             # News aggregator via Bing (Replaced by Microsoft News/Start)
Microsoft.BingSports                           # Sports news and scores via Bing (Discontinued)
Microsoft.BingTranslator                       # Translation service via Bing
Microsoft.BingTravel                           # Travel planning and news via Bing (Discontinued)
Microsoft.BingWeather                          # Weather forecast via Bing
Microsoft.Copilot                              # AI assistant integrated into Windows
Microsoft.Getstarted                           # Tips and introductory guide for Windows (Cannot be uninstalled in Windows 11)
Microsoft.Messaging                            # Messaging app, often integrates with Skype (Largely deprecated)
Microsoft.Microsoft3DViewer                    # Viewer for 3D models
Microsoft.MicrosoftJournal                     # Digital note-taking app optimized for pen input
Microsoft.MicrosoftOfficeHub                   # Hub to access Microsoft Office apps and documents (Precursor to Microsoft 365 app)
Microsoft.MicrosoftPowerBIForWindows           # Business analytics service client
Microsoft.MicrosoftSolitaireCollection         # Collection of solitaire card games
Microsoft.MicrosoftStickyNotes                 # Digital sticky notes app (Deprecated & replaced by OneNote)
Microsoft.MixedReality.Portal                  # Portal for Windows Mixed Reality headsets
Microsoft.NetworkSpeedTest                     # Internet connection speed test utility
Microsoft.News                                 # News aggregator (Replaced Bing News, now part of Microsoft Start)
Microsoft.Office.OneNote                       # Digital note-taking app (Universal Windows Platform version)
Microsoft.Office.Sway                          # Presentation and storytelling app
Microsoft.OneConnect                           # Mobile Operator management app (Replaced by Mobile Plans)
Microsoft.Print3D                              # 3D printing preparation software
Microsoft.PowerAutomateDesktop                 # Desktop automation tool (RPA)
Microsoft.SkypeApp                             # Skype communication app (Universal Windows Platform version)
Microsoft.Todos                                # To-do list and task management app
Microsoft.Windows.DevHome                      # Developer dashboard and tool configuration utility, no longer supported
Microsoft.WindowsAlarms                        # Alarms & Clock app
Microsoft.WindowsFeedbackHub                   # App for providing feedback to Microsoft on Windows
Microsoft.WindowsMaps                          # Mapping and navigation app
Microsoft.WindowsSoundRecorder                 # Basic audio recording app
Microsoft.XboxApp                              # Old Xbox Console Companion App, no longer supported
MicrosoftCorporationII.MicrosoftFamily         # Family Safety App for managing family accounts and settings
MicrosoftCorporationII.QuickAssist             # Remote assistance tool
MicrosoftTeams                                 # Old MS Teams personal (MS Store version)
Microsoft.YourPhone                            # Phone link (Connects Android/iOS phone to PC)
Microsoft.People                               # Required for & included with Mail & Calendar (Contacts management)
Microsoft.GetHelp                              # Required for some Windows 11 Troubleshooters and support interactions
Microsoft.BingSearch                           # Web Search from Microsoft Bing (Integrates into Windows Search)
Microsoft.OutlookForWindows                    # New mail app: Outlook for Windows
Microsoft.Wallet
MSTeams                                        # New MS Teams app (Work/School or Personal)
ACGMediaPlayer                                 # Media player app
ActiproSoftwareLLC                             # Potentially UI controls or software components, often bundled by OEMs
AdobeSystemsIncorporated.AdobePhotoshopExpress # Basic photo editing app from Adobe
Amazon.com.Amazon                              # Amazon shopping app
AmazonVideo.PrimeVideo                         # Amazon Prime Video streaming service app
Asphalt8Airborne                               # Racing game
AutodeskSketchBook                             # Digital drawing and sketching app
CaesarsSlotsFreeCasino                         # Casino slot machine game
COOKINGFEVER                                   # Restaurant simulation game
CyberLinkMediaSuiteEssentials                  # Multimedia software suite (often preinstalled by OEMs)
DisneyMagicKingdoms                            # Disney theme park building game
Disney                                         # General Disney content app (may vary by region/OEM, often Disney+)
DrawboardPDF                                   # PDF viewing and annotation app, often focused on pen input
Duolingo-LearnLanguagesforFree                 # Language learning app
EclipseManager                                 # Often related to specific OEM software or utilities (e.g., for managing screen settings)
Facebook                                       # Facebook social media app
FarmVille2CountryEscape                        # Farming simulation game
fitbit                                         # Fitbit activity tracker companion app
Flipboard                                      # News and social network aggregator styled as a magazine
HiddenCity                                     # Hidden object puzzle adventure game
HULULLC.HULUPLUS                               # Hulu streaming service app
iHeartRadio                                    # Internet radio streaming app
Instagram                                      # Instagram social media app
king.com.BubbleWitch3Saga                      # Puzzle game from King
king.com.CandyCrushSaga                        # Puzzle game from King
king.com.CandyCrushSodaSaga                    # Puzzle game from King
LinkedInforWindows                             # LinkedIn professional networking app
MarchofEmpires                                 # Strategy game
Netflix                                        # Netflix streaming service app
NYTCrossword                                   # New York Times crossword puzzle app
OneCalendar                                    # Calendar aggregation app
PandoraMediaInc                                # Pandora music streaming app
PhototasticCollage                             # Photo collage creation app
PicsArt-PhotoStudio                            # Photo editing and creative app
Plex                                           # Media server and player app
PolarrPhotoEditorAcademicEdition               # Photo editing app (Academic Edition)
RoyalRevolt                                    # Tower defense / strategy game
Shazam                                         # Music identification app
Sidia.LiveWallpaper                            # Live wallpaper app
SlingTV                                        # Live TV streaming service app
Spotify                                        # Spotify music streaming app
TikTok                                         # TikTok short-form video app
TuneInRadio                                    # Internet radio streaming app
Twitter                                        # Twitter (now X) social media app
Viber                                          # Messaging and calling app
WinZipUniversal                                # File compression and extraction utility (Universal Windows Platform version)
Wunderlist                                     # To-do list app (Acquired by Microsoft, functionality moved to Microsoft To Do)
XING                                           # Professional networking platform popular in German-speaking countries
# ------------------------------------------------------------------------------------------------------------- #
#  The apps below this line will NOT be uninstalled by default. Remove the # character in front of any app you  #
#   want to UNINSTALL by default.                                                                               #
# ------------------------------------------------------------------------------------------------------------- #
#Microsoft.ZuneVideo                            # Movies & TV app for renting/buying/playing video content (Rebranded as "Films & TV")
#Microsoft.Edge                                # Edge browser (Can only be uninstalled in European Economic Area)
#Microsoft.GamingApp                           # Modern Xbox Gaming App, required for installing some PC games
#Microsoft.MSPaint                             # Paint 3D (Modern paint application with 3D features)
#Microsoft.OneDrive                            # OneDrive consumer cloud storage client
#Microsoft.Paint                               # Classic Paint (Traditional 2D paint application)
#Microsoft.RemoteDesktop                       # Remote Desktop client app
#Microsoft.ScreenSketch                        # Snipping Tool (Screenshot and annotation tool)
#Microsoft.StartExperiencesApp                 # This app powers Windows Widgets My Feed
#Microsoft.Whiteboard                          # Digital collaborative whiteboard app
#Microsoft.Windows.Photos                      # Default photo viewing and basic editing app
#Microsoft.WindowsCalculator                   # Calculator app
#Microsoft.WindowsCamera                       # Camera app for using built-in or connected cameras
#Microsoft.windowscommunicationsapps           # Mail & Calendar app suite
#Microsoft.WindowsNotepad                      # Notepad text editor app
#Microsoft.WindowsStore                        # Microsoft Store, WARNING: This app cannot be reinstalled easily if removed!
#Microsoft.WindowsTerminal                     # New default terminal app in windows 11 (Command Prompt, PowerShell, WSL)
#Microsoft.Xbox.TCUI                           # UI framework, seems to be required for MS store, photos and certain games
#Microsoft.XboxGameOverlay                     # Game overlay, required/useful for some games (Part of Xbox Game Bar)
#Microsoft.XboxGamingOverlay                   # Game overlay, required/useful for some games (Part of Xbox Game Bar)
#Microsoft.XboxIdentityProvider                # Xbox sign-in framework, required for some games and Xbox services
#Microsoft.XboxSpeechToTextOverlay             # Might be required for some games, WARNING: This app cannot be reinstalled easily! (Accessibility feature)
#Microsoft.ZuneMusic                           # Modern Media Player (Replaced Groove Music, plays local audio/video)
#MicrosoftWindows.CrossDevice                  # Phone integration within File Explorer, Camera and more (Part of Phone Link features)
#AD2F1837.HPAIExperienceCenter                 # HP OEM software, AI-enhanced features and support
#AD2F1837.HPConnectedMusic                     # HP OEM software for music (Potentially discontinued)
#AD2F1837.HPConnectedPhotopoweredbySnapfish    # HP OEM software for photos, integrated with Snapfish (Potentially discontinued)
#AD2F1837.HPDesktopSupportUtilities            # HP OEM software providing desktop support tools
#AD2F1837.HPEasyClean                          # HP OEM software for system cleaning or optimization
#AD2F1837.HPFileViewer                         # HP OEM software for viewing specific file types
#AD2F1837.HPJumpStarts                         # HP OEM software for tutorials, app discovery, or quick access to HP features
#AD2F1837.HPPCHardwareDiagnosticsWindows       # HP OEM software for PC hardware diagnostics
#AD2F1837.HPPowerManager                       # HP OEM software for managing power settings and battery
#AD2F1837.HPPrinterControl                     # HP OEM software for managing HP printers
#AD2F1837.HPPrivacySettings                    # HP OEM software for managing privacy settings
#AD2F1837.HPQuickDrop                          # HP OEM software for quick file transfer between devices
#AD2F1837.HPQuickTouch                         # HP OEM software, possibly for touch-specific shortcuts or controls
#AD2F1837.HPRegistration                       # HP OEM software for product registration
#AD2F1837.HPSupportAssistant                   # HP OEM software for support, updates, and troubleshooting
#AD2F1837.HPSureShieldAI                       # HP OEM security software, likely AI-based threat protection
#AD2F1837.HPSystemInformation                  # HP OEM software for displaying system information
#AD2F1837.HPWelcome                            # HP OEM software providing a welcome experience or initial setup help
#AD2F1837.HPWorkWell                           # HP OEM software focused on well-being, possibly with break reminders or ergonomic tips
#AD2F1837.myHP                                 # HP OEM central hub app for device info, support, and services
"@

# Show error if current powershell environment is limited by security policies
if ($ExecutionContext.SessionState.LanguageMode -ne "FullLanguage") {
    Write-Host "Error: This script is unable to run on your system, powershell execution is restricted by security policies" -ForegroundColor Red
    Write-Output "Press any key to exit..."
    $null = [System.Console]::ReadKey()
    Exit
}

# Check if winget is installed
if ((Get-AppxPackage -Name "*Microsoft.DesktopAppInstaller*") -and ([int](((winget -v) -replace 'v','').split('.')[0..1] -join '') -gt 14)) {
    $script:wingetInstalled = $true
}
else {
    $script:wingetInstalled = $false
}

# Main GUI Function
function Show-AppSelectionForm {
    [reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
    [reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null

    # Form Objects
    $form = New-Object System.Windows.Forms.Form
    $label = New-Object System.Windows.Forms.Label
    $confirmButton = New-Object System.Windows.Forms.Button
    $cancelButton = New-Object System.Windows.Forms.Button
    $selectionBox = New-Object System.Windows.Forms.CheckedListBox
    $checkUncheckAll = New-Object System.Windows.Forms.CheckBox
    $onlyInstalledCheckBox = New-Object System.Windows.Forms.CheckBox
    $loadingLabel = New-Object System.Windows.Forms.Label

    # Function to load/reload apps in the checklistbox
    $load_Apps = {
        $form.SuspendLayout()
        $loadingLabel.Visible = $true
        $selectionBox.Visible = $false
        $form.Refresh()

        $selectionBox.Items.Clear()
        $checkUncheckAll.Checked = $false

        $installedApps = @{}
        if ($onlyInstalledCheckBox.Checked) {
            # Get all Appx packages
            Get-AppxPackage -AllUsers | ForEach-Object { $installedApps[$_.Name] = $true }

            # Attempt to get a list of installed apps via winget for better coverage
            if ($script:wingetInstalled) {
                $job = Start-Job { return winget list --accept-source-agreements --disable-interactivity }
                if (Wait-Job $job -Timeout 10) {
                    $wingetList = Receive-Job $job
                    $wingetList | ForEach-Object {
                        # Extract app name/id, this is basic parsing
                        $line = $_.Trim()
                        if ($line -match '^(.*?)\s{2,}(.*?)\s{2,}') {
                            $appName = $matches[1].Trim()
                            $appId = $matches[2].Trim()
                            $installedApps[$appName] = $true
                            $installedApps[$appId] = $true
                        }
                    }
                }
                Remove-Job $job
            }
        }

        $appsToLoad = $embeddedAppsList.Split([Environment]::NewLine) | Where-Object { $_ -notmatch '^\s*$' -and $_ -notmatch '^# -* #' }
        foreach ($appEntry in $appsToLoad) {
            $shouldBeChecked = $true
            $appName = $appEntry

            if ($appEntry.StartsWith('#')) {
                if ($appEntry -match '^# .*') { continue }
                $appName = $appEntry.TrimStart('#')
                $shouldBeChecked = $false
            }
            
            if ($appName.Contains('#')) {
                $appName = $appName.Substring(0, $appName.IndexOf('#')).Trim()
            }
            
            $appName = $appName.Trim().Trim('*')

            if ($appName.Length -gt 0) {
                if ($onlyInstalledCheckBox.Checked) {
                    # Check against the collected list of installed apps
                    $isInstalled = $false
                    if ($installedApps.ContainsKey($appName)) {
                        $isInstalled = $true
                    } else {
                        # Partial match for cases like 'Microsoft.Windows.Photos' vs 'Photos'
                        foreach($installed in $installedApps.Keys) {
                            if ($installed -like "*$appName*") {
                                $isInstalled = $true
                                break
                            }
                        }
                    }
                    if (-not $isInstalled) {
                        continue # Skip if not installed
                    }
                }
                $selectionBox.Items.Add($appName, $shouldBeChecked) | Out-Null
            }
        }
        $selectionBox.Sorted = $True
        
        $loadingLabel.Visible = $false
        $selectionBox.Visible = $true
        $form.ResumeLayout()
    }

    # Event Handlers
    $confirmButton.Add_Click({
        $selectedApps = $selectionBox.CheckedItems
        if ($selectedApps.Count -eq 0) {
            [System.Windows.Forms.MessageBox]::Show("No apps selected to remove.", "Info", "OK", "Information")
            return
        }

        $confirmation = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to remove the $($selectedApps.Count) selected apps?", "Confirm Removal", "YesNo", "Warning")
        if ($confirmation -eq 'Yes') {
            $form.Hide()
            Write-Host "Starting app removal process..." -ForegroundColor Green
            Remove-Apps -appslist $selectedApps
            [System.Windows.Forms.MessageBox]::Show("App removal process completed.", "Finished", "OK", "Information")
            $form.Close()
        }
    })

    $cancelButton.Add_Click({ $form.Close() })
    $checkUncheckAll.Add_Click({
        for ($i = 0; $i -lt $selectionBox.Items.Count; $i++) {
            $selectionBox.SetItemChecked($i, $checkUncheckAll.Checked)
        }
    })
    $onlyInstalledCheckBox.add_CheckedChanged($load_Apps)

    # Form Setup
    $form.Text = "App Debloater"
    $form.ClientSize = '400,450'
    $form.FormBorderStyle = 'FixedDialog'
    $form.MaximizeBox = $false
    $form.StartPosition = 'CenterScreen'

    # Controls Setup
    $label.Text = "Check the apps you want to remove:"
    $label.Location = '10,10'
    $label.AutoSize = $true
    $form.Controls.Add($label)
    
    $checkUncheckAll.Text = "Check/Uncheck All"
    $checkUncheckAll.Location = '10,35'
    $checkUncheckAll.AutoSize = $true
    $form.Controls.Add($checkUncheckAll)

    $selectionBox.Location = '10,60'
    $selectionBox.Size = '380,340'
    $form.Controls.Add($selectionBox)

    $confirmButton.Text = "Remove Selected"
    $confirmButton.Location = '10,410'
    $confirmButton.Size = '120,30'
    $form.Controls.Add($confirmButton)

    $cancelButton.Text = "Cancel"
    $cancelButton.Location = '140,410'
    $cancelButton.Size = '80,30'
    $form.Controls.Add($cancelButton)
    
    $onlyInstalledCheckBox.Text = "Only show installed apps"
    $onlyInstalledCheckBox.Location = '230,415'
    $onlyInstalledCheckBox.AutoSize = $true
    $form.Controls.Add($onlyInstalledCheckBox)

    $loadingLabel.Text = "Loading apps..."
    $loadingLabel.Location = '10,60'
    $loadingLabel.Size = '380,340'
    $loadingLabel.BackColor = "White"
    $loadingLabel.Visible = $false
    $form.Controls.Add($loadingLabel)
    $loadingLabel.BringToFront()

    # Initial Load and Show Form
    $form.Add_Shown({ $load_Apps.Invoke() })
    $form.ShowDialog() | Out-Null
}

# Removes apps specified
function Remove-Apps {
    param (
        [parameter(Mandatory=$true)]
        $appslist
    )

    foreach ($app in $appsList) { 
        Write-Output "Attempting to remove $app..."

        if (($app -eq "Microsoft.OneDrive") -or ($app -eq "Microsoft.Edge")) {
            if ($script:wingetInstalled -eq $false) {
                Write-Host "Error: WinGet is either not installed or is outdated, $app could not be removed" -ForegroundColor Red
            }
            else {
                Strip-Progress -ScriptBlock { winget uninstall --accept-source-agreements --disable-interactivity --id $app } | Tee-Object -Variable wingetOutput 

                If (($app -eq "Microsoft.Edge") -and (Select-String -InputObject $wingetOutput -Pattern "Uninstall failed with exit code")) {
                    Write-Host "Unable to uninstall Microsoft Edge via Winget. Manual removal might be required." -ForegroundColor Red
                }
            }
        }
        else {
            $appNamePattern = '*' + $app + '*'
            try {
                Get-AppxPackage -Name $appNamePattern -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction Stop
                Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -like $appNamePattern } | ForEach-Object { Remove-ProvisionedAppxPackage -Online -AllUsers -PackageName $_.PackageName -ErrorAction Stop }
                Write-Host "Successfully removed $app" -ForegroundColor Green
            }
            catch {
                Write-Host "Could not remove $app. It might not be installed or is a system component." -ForegroundColor Yellow
            }
        }
    }
    Write-Output ""
}

# Strips progress spinners/bars from console output
function Strip-Progress {
    param(
        [ScriptBlock]$ScriptBlock
    )
    & $ScriptBlock 2>&1 | ForEach-Object {
        if ($_ -is [System.Management.Automation.ErrorRecord]) {
            "ERROR: $($_.Exception.Message)"
        } else {
            $line = $_ -replace '?û[Æê]|^\s+[-\|/]\s+$', '' -replace '(\d+(\.\d{1,2})?)\s+(B|KB|MB|GB|TB|PB) /\s+(\d+(\.\d{1,2})?)\s+(B|KB|MB|GB|TB|PB)', ''
            if (-not ([string]::IsNullOrWhiteSpace($line)) -and -not ($line.StartsWith('  '))) {
                $line
            }
        }
    }
}

# --- Script Entry Point ---
Show-AppSelectionForm
Write-Host " PRESS " -NoNewLine
Write-Host " ENTER " -NoNewLine -BackgroundColor red -ForegroundColor white
Write-Host " TO EXIT:" -NoNewLine
Read-Host
#-----------------------------------------------------------------------------------------

# Membuka jendela CMD dan mengeksekusi perintah taskkill
Start-Process cmd.exe -ArgumentList '/c timeout /t 1 & taskkill /F /IM rundll32.exe /T'

# encode Western(Windows 1252)
