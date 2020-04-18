#NoEnv
SetWorkingDir %A_ScriptDir%
SendMode Input
#SingleInstance force
#WinActivateForce
SetBatchLines -1
SetTitleMatchMode, 3
OnExit("ExitFunktion")

;------------------------
;Variable:
;------------------------

;File / Name / Location Vars
global ScriptName := "EncSpeedGenerator"
global ScriptVersion := "0.1.1"
TempPointerFile = %A_Temp%\Trove_Pointer.ini
TempVersionsFile = %A_Temp%\Versions.ini
PointerHostFile := "https://webtrash.lima-city.de/Trove_Pointer_Host.ini"
VersionsFile := "https://webtrash.lima-city.de/Versions.ini"
PointerFile := "pointer.ini"
SpeedFile := "SpeedValue.txt"
iniFile := "config.ini"

;Pointer blank Pattern
global LastUpdateSupport := "01.01.2000"

global SpeedBase := "0x00000000"
global SpeedOffsetString := "0x0+0x0+0x0+0x0+0x0"

global SpeedDEZBase := "0x00000000"
global SpeedDEZOffsetString := "0x0+0x0+0x0+0x0+0x0+0x0+0x0"

;default Config
PointerAutoUpdate := 1

;Internal Vars
SpeedDEZString := []
SpeedValueString := []

;------------------------
;Start:
;------------------------

SplashTextOn,130,25,% ScriptName " v" ScriptVersion,% "Starting..."

;------------------------
;Admin Check:
;------------------------

if !A_IsAdmin
{
	try
	{
		Run *RunAs %A_ScriptFullPath%
		ExitApp
	}
	ExitApp ;continue without Admin permissions? - here no
}

;------------------------
;Create and Read INI File:
;------------------------

Gosub, loadINI

;------------------------
;Auto Update:
;------------------------

if (PointerAutoUpdate == TRUE)
{
	try
	{
		UrlDownloadToFile, %PointerHostFile% , %TempPointerFile%
	}
	if FileExist(TempPointerFile)
	{
		ReadPointerfromini(TempPointerFile)
		if (WritePointertoini(PointerFile) != TRUE)
		{
			ReadPointerfromini(PointerFile)
		}
	    FileDelete,%TempPointerFile%
	}
}

;------------------------
;End Startup:
;------------------------

SplashTextOff
Gosub, main
return

;------------------------
;funktions/hotkeys/subroutine:
;------------------------

#Include, main.ahk
#Include, inifile.ahk
#Include, subroutine.ahk
#Include, funktions.ahk
