CheckTroveWindow:
WinGet, PID, PID, ahk_exe Trove.exe
WinGet, hwnd, ID, ahk_pid %PID%
Base := getProcessBaseAddress(hwnd)

Gosub, getAddress
return

getAddress:
SpeedAddress := GetAddress(PID, Base, SpeedBase, SpeedOffsetString)

SpeedDEZAddress := GetAddress(PID, Base, SpeedDEZBase, SpeedDEZOffsetString)
return

ExitScript: ;called through "ExitFunktion()" use "ExitApp" to run that code on exit.
ExitApp
