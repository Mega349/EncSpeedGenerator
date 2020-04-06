loadINI:
if !FileExist(PointerFile)
{
	WritePointertoini(PointerFile)
}

if !FileExist(iniFile)
{
	IniWrite,1,%iniFile%,Version,ConfigVersion

	IniWrite,%PointerAutoUpdate%,%iniFile%,General,PointerAutoUpdate
	IniWrite,%EnableUpdateCheck%,%iniFile%,General,EnableUpdateCheck
	IniWrite,%minValue%,%iniFile%,Value,minValue
	IniWrite,%maxValue%,%iniFile%,Value,maxValue
}

;------------------------

if FileExist(PointerFile)
{
	ReadPointerfromini(PointerFile)
}

if FileExist(iniFile)
{
	IniRead,ConfigVersion,%iniFile%,Version,ConfigVersion

	Gosub, Updateini

	IniRead,PointerAutoUpdate,%iniFile%,General,PointerAutoUpdate
	IniRead,EnableUpdateCheck,%iniFile%,General,EnableUpdateCheck
	IniRead,minValue,%iniFile%,Value,minValue
	IniRead,maxValue,%iniFile%,Value,maxValue
}
Return

WritePointertoini(ini)
{
	if (LastUpdateSupport != "ERROR")
	{
		IniWrite,%LastUpdateSupport%,%ini%,date,LastUpdateSupport

		IniWrite,%SpeedBase%,%ini%,speed,Base
		IniWrite,%SpeedOffsetString%,%ini%,speed,Offsets
		IniWrite,%SpeedDEZBase%,%ini%,speed_DEZ,Base
		IniWrite,%SpeedDEZOffsetString%,%ini%,speed_DEZ,Offsets

		state := TRUE
	}
	else
	{
		state := FALSE
	}
	
	return state
}

ReadPointerfromini(ini)
{
	IniRead,LastUpdateSupport,%ini%,date,LastUpdateSupport

	IniRead,SpeedBase,%ini%,speed,Base
	IniRead,SpeedOffsetString,%ini%,speed,Offsets
	IniRead,SpeedDEZBase,%ini%,speed_DEZ,Base
	IniRead,SpeedDEZOffsetString,%ini%,speed_DEZ,Offsets
}

Updateini:
return
