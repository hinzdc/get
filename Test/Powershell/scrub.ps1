<#
.SYNOPSIS
  Uninstall registered Office products (using UninstallString / QuietUninstallString),
  then perform aggressive cleanup (stop services/processes, remove folders, registry keys).
.NOTES
  - Run as Administrator
  - Save as uninstall_then_clean_office.ps1
  - Use at your own risk. Make a restore point first.
#>

# ------------------ Config ------------------
$LogFile = "$env:TEMP\office_cleanup_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
$DebugPreference = 'SilentlyContinue'
Function Log { param($s); $t = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss'); "$t  $s" | Tee-Object -FilePath $LogFile -Append }

# ------------------ Admin check ------------------
If (-not ([bool]([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator))) {
    Write-Error "Script harus dijalankan sebagai Administrator. Tutup, lalu jalankan PowerShell (Run as Administrator)."
    exit 1
}

Log "=== Mulai Uninstall + Cleanup Microsoft Office ==="

# ------------------ Restore point (best-effort) ------------------
Try {
    Log "Mencoba membuat System Restore Point..."
    Checkpoint-Computer -Description "Pre-Office-Uninstall-Cleanup" -RestorePointType "Modify_Settings" -ErrorAction Stop
    Log "Restore point dibuat."
} catch {
    Log "Gagal membuat restore point (mungkin disabled atau tidak diizinkan): $($_.Exception.Message)"
}

# ------------------ Helper: find uninstall entries ------------------
Function Get-OfficeUninstallEntries {
    $hives = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall"
    )
    $matches = @()
    foreach ($h in $hives) {
        try {
            Get-ChildItem -Path $h -ErrorAction SilentlyContinue | ForEach-Object {
                $props = Get-ItemProperty -Path $_.PSPath -ErrorAction SilentlyContinue
                if ($props) {
                    $dn = $props.DisplayName
                    if ($dn -and $dn -match "Office|Microsoft 365|Microsoft Office|Office 365|OfficePro|ClickToRun") {
                        $entry = [PSCustomObject]@{
                            Hive = $h
                            Key  = $_.PSPath
                            DisplayName = $dn
                            UninstallString = $props.UninstallString
                            QuietUninstallString = $props.QuietUninstallString
                            Publisher = $props.Publisher
                            Version = $props.DisplayVersion
                        }
                        $matches += $entry
                    }
                }
            }
        } catch {
            # ignore
        }
    }
    return $matches
}

# ------------------ Enumerate and attempt uninstall ------------------
$entries = Get-OfficeUninstallEntries
if (-not $entries -or $entries.Count -eq 0) {
    Log "Tidak ditemukan entri uninstall Office di registry."
} else {
    Log "Ditemukan $($entries.Count) entri Office yang cocok. Mencoba uninstall one-by-one..."
    $i=0
    foreach ($e in $entries) {
        $i++
        Log "[$i/$($entries.Count)] DisplayName: $($e.DisplayName) | Publisher: $($e.Publisher) | Version: $($e.Version)"
        $cmd = $null
        if ($e.QuietUninstallString) { $cmd = $e.QuietUninstallString; Log " - Menggunakan QuietUninstallString (silent)"; }
        elseif ($e.UninstallString) { $cmd = $e.UninstallString; Log " - Menggunakan UninstallString (interactive if no silent flag)"; }

        if ($cmd) {
            # Normalize msiexec if possible
            $cmdTrim = $cmd.Trim()
            Try {
                if ($cmdTrim -match 'MsiExec' -or $cmdTrim -match 'msiexec') {
                    # If it contains /I{GUID} convert to /x{GUID} for uninstall if needed; otherwise run as-is
                    $cmdTrim = $cmdTrim -replace "/I","/X"
                    # Ensure no user prompt if possible
                    if ($cmdTrim -notmatch "/qn" -and $cmdTrim -notmatch "/quiet") {
                        $cmdTrim += " /qn /norestart"
                    }
                    Log " - Menjalankan: $cmdTrim"
                    Start-Process -FilePath "cmd.exe" -ArgumentList "/c $cmdTrim" -Wait -NoNewWindow
                } else {
                    # Some UninstallString include quoted exe + args, run via cmd /c
                    Log " - Menjalankan: $cmdTrim"
                    Start-Process -FilePath "cmd.exe" -ArgumentList "/c $cmdTrim" -Wait -NoNewWindow
                }
                Log " - Uninstall command selesai (cek if UI appeared or logs)."
            } catch {
                Log " - Gagal menjalankan uninstall: $($_.Exception.Message)"
            }
            Start-Sleep -Seconds 3
        } else {
            Log " - Tidak ada UninstallString/QuietUninstallString untuk entri ini."
        }
    }
}

# Pause briefly to allow uninstalls to finalize
Log "Menunggu 10 detik agar proses uninstall menyelesaikan sisa ..."
Start-Sleep -Seconds 10

# ------------------ Stop common Office processes ------------------
$procs = @("WINWORD","EXCEL","POWERPNT","OUTLOOK","MSACCESS","ONENOTE","OfficeC2RClient","sdbinst","msosync","Groove","communicator","lync")
Log "Menghentikan proses Office umum..."
foreach ($p in $procs) {
    Try {
        Get-Process -Name $p -ErrorAction SilentlyContinue | ForEach-Object {
            Log " - Menghentikan proses $($_.Name) (Id=$($_.Id))"
            Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
        }
    } catch {
        # ignore
    }
}

# ------------------ Stop related services ------------------
$svcNames = @("ClickToRunSvc","osppsvc") # Click-to-Run, Office Software Protection
foreach ($s in $svcNames) {
    Try {
        $svc = Get-Service -Name $s -ErrorAction SilentlyContinue
        if ($svc) {
            if ($svc.Status -ne 'Stopped') {
                Log " - Stopping service $s ..."
                Stop-Service -Name $s -Force -ErrorAction SilentlyContinue
            }
            Log " - Disabling startup for $s"
            Set-Service -Name $s -StartupType Disabled -ErrorAction SilentlyContinue
        }
    } catch {
        Log " - Gagal stop/disable $s : $($_.Exception.Message)"
    }
}

# ------------------ Remove common Office folders (best-effort) ------------------
$folders = @(
    "$env:ProgramFiles\Microsoft Office",
    "$env:ProgramFiles(x86)\Microsoft Office",
    "$env:ProgramFiles\Common Files\Microsoft Shared\ClickToRun",
    "$env:ProgramFiles(x86)\Common Files\Microsoft Shared\ClickToRun",
    "$env:ProgramData\Microsoft\Office",
    "$env:ProgramData\Microsoft\ClickToRun",
    "$env:LOCALAPPDATA\Microsoft\Office",
    "$env:APPDATA\Microsoft\Office"
)

Log "Menghapus folder instalasi Office/ClickToRun yang umum (best-effort)..."
foreach ($f in $folders) {
    if ([string]::IsNullOrWhiteSpace($f)) { continue }
    if (Test-Path $f) {
        Try {
            Log " - Menghapus $f ..."
            # takeown + icacls to ensure deletion on locked permissions
            & takeown /f $f /r /d y | Out-Null
            & icacls $f /grant Administrators:F /t /c | Out-Null
            Remove-Item -Path $f -Recurse -Force -ErrorAction Stop
            Log "   => Berhasil dihapus."
        } catch {
            Log "   => Gagal hapus $f : $($_.Exception.Message)"
        }
    } else {
        Log " - Tidak ditemukan: $f"
    }
}

# ------------------ Registry cleanup (Uninstall entries and Office keys) ------------------
Log "Membersihkan entri Uninstall registry yang mengandung Office (best-effort)."
$regUninstallPaths = @("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall","HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall")
foreach ($r in $regUninstallPaths) {
    try {
        Get-ChildItem -Path $r -ErrorAction SilentlyContinue | ForEach-Object {
            $p = Get-ItemProperty -Path $_.PSPath -ErrorAction SilentlyContinue
            if ($p.DisplayName -and ($p.DisplayName -match "Office|Microsoft 365|Microsoft Office|Office 365|ClickToRun")) {
                Log " - Menghapus registry key: $($_.PSPath)  (DisplayName: $($p.DisplayName))"
                try { Remove-Item -Path $_.PSPath -Recurse -Force -ErrorAction Stop; Log "   => Dihapus." } catch { Log "   => Gagal: $($_.Exception.Message)" }
            }
        }
    } catch {
        # ignore
    }
}

# Remove main Office registry roots
$officeRoots = @("HKLM:\SOFTWARE\Microsoft\Office","HKLM:\SOFTWARE\WOW6432Node\Microsoft\Office","HKCU:\Software\Microsoft\Office")
foreach ($root in $officeRoots) {
    if (Test-Path $root) {
        Try {
            Log " - Menghapus registry tree $root ..."
            Remove-Item -Path $root -Recurse -Force -ErrorAction Stop
            Log "   => Dihapus."
        } catch {
            Log "   => Gagal hapus $root : $($_.Exception.Message)"
        }
    } else {
        Log " - Tidak ada registry key: $root"
    }
}

# ------------------ Remove shortcuts Start Menu / Desktop ------------------
Try {
    $startProg = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs"
    $msOfficeFolder = Join-Path $startProg "Microsoft Office"
    if (Test-Path $msOfficeFolder) {
        Log "Menghapus Start Menu folder: $msOfficeFolder"
        Remove-Item -Path $msOfficeFolder -Recurse -Force -ErrorAction SilentlyContinue
    }
    Log "Menghapus shortcut Office di Public Desktop..."
    Get-ChildItem "$env:Public\Desktop" -Filter "*Office*.lnk" -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
    Get-ChildItem "$env:Public\Desktop" -Include "*Word*.lnk","*Excel*.lnk","*Outlook*.lnk" -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
} catch { }

# ------------------ Run msiexec maintenance attempt ------------------
Try {
    Log "Menjalankan msiexec repair attempt to fix installer info (best-effort)..."
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/fvomus" -Wait -NoNewWindow -ErrorAction SilentlyContinue
    Log "msiexec attempt selesai."
} catch {
    Log "msiexec attempt gagal: $($_.Exception.Message)"
}

Log "=== Selesai. Beberapa sisa mungkin masih ada tergantung jenis instalasi (Click-to-Run vs MSI). ==="
Log "Periksa log: $LogFile"
Write-Output ""
Write-Output "Operation finished. Lihat log: $LogFile"