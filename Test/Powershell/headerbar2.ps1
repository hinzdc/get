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

Header -Label "// A U R O R A  T O O L K I T //" -Center " "