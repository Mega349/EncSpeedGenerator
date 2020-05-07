;------------------------
;own Functions:
;------------------------

trimArray(Array,RegEx) ; wirft alles weg was nicht in die RegEx passt!
{
	tempArray := []
	i := 0
	j := 0

	while (i < Array.length())
	{
		RegExMatch(Array[i], RegEx, value)
		if(value != "")
		{
			tempArray[j] := Array[i]
			j++
		}
		i++
	}
	return tempArray
}

sortArray(Array) ;Array -> String (mit "$" trennen) -> String sortieren -> Array
{
	string := ArraytoString(Array,1,"$")
	Sort, string, D$
	Array := StrSplit(String,"$")
	return Array
}

ArraytoString(Array,counter = 0,delimiter = ",") ;(Array,Start-position,Delimiter)
{
	String := Array[counter]
	while (counter < Array.Length())
	{
		counter++
		String := String delimiter Array[counter]
	}
	return String
}

ReadFiletoArray(file) ;Index 0 = Amount of lines | Index 1 = line 1 etc...
{
    Array := []
    line = 0
    counter := 0

    fileObjekt := FileOpen(file, "r")
    while (line != "")
    {
        counter++
        line := fileObjekt.ReadLine()

        if (line != "")
        {
            Array[counter] := RTrim(line,"`n")
        }
    }
    Array[0] := Array.Length()
    fileObjekt.Close()

    return Array
}

WriteArraytoFile(file, Array) ;Index 0 = ungenutzt | Index 1 = Zeile 1 usw... | Datei sollte leer oder nicht vorhanden sein sonst wird der inhalt angehängt!
{	
	counter := 1

	while (counter <= Array.Length())
	{
		if (counter == "1" )
		{
			String := Array[counter]
		}
		else
		{
			String := String "`n" Array[counter]
		}
		counter++
	}
	fileObjekt := FileOpen(file,"a")
    fileObjekt.Write(String)
    fileObjekt.Close()
}

ExitFunktion()
{
    gosub,ExitScript
}

ReadMemoryAoB(Address, pid ,size)
{
	AoB := []
	i := 0
	while (i < size)
	{
    	AoB[i] := ReadMemory(Address+i, pid, 1)
		i++
	}
    return AoB
}

WriteMemoryAoB(Address, pid , Array)
{
	i := 0
	while (i <= Array.Length())
	{
    	WriteProcessMemory(pid, Address+i, Array[i], 1)
		i++
	}
}

;------------------------
;other Functions:
;------------------------

getProcessBaseAddress(Handle)
{
	Return DllCall( A_PtrSize = 4
	? "GetWindowLong"
	: "GetWindowLongPtr"
    , "Ptr", Handle
    , "Int", -6
    , "Int64")
}
	
GetAddress(PID, Base, Address, Offset)
{
	pointerBase := base + Address
	y := ReadMemory(pointerBase,PID)
	OffsetSplit := StrSplit(Offset, "+")
	OffsetCount := OffsetSplit.MaxIndex()
	Loop, %OffsetCount%
	{
		if (a_index = OffsetCount)
		{
			Address := (y + OffsetSplit[a_index])
		}
		Else if(a_index = 1) 
		{
			y := ReadMemory(y + OffsetSplit[a_index],PID)
		}
		Else
		{
			y := ReadMemory(y + OffsetSplit[a_index],PID)
		}
	}
	Return Address
}

ReadMemory(MADDRESS, pid, size = 4)
{
	VarSetCapacity(MVALUE,size,0)
	ProcessHandle := DllCall("OpenProcess", "Int", 24, "Char", 0, "UInt", pid, "UInt")
	DllCall("ReadProcessMemory", "UInt", ProcessHandle, "Ptr", MADDRESS, "Ptr", &MVALUE, "Uint",size)
	Loop %size%
	result += *(&MVALUE + A_Index-1) << 8*(A_Index-1)
	Return, result
}

WriteProcessMemory(pid,address,wert, size = 4)
{
	VarSetCapacity(processhandle,32,0)
	VarSetCapacity(value, 32, 0)
	NumPut(wert,value,0,Uint)
	processhandle:=DllCall("OpenProcess","Uint",0x38,"int",0,"int",pid)
	Bvar:=DllCall("WriteProcessMemory","Uint",processhandle,"Uint",address+0,"Uint",&value,"Uint",size,"Uint",0)
}

HexToFloat(d)
{
	Return (1-2*(d>>31)) * (2**((d>>23 & 255)-127)) * (1+(d & 8388607)/8388608)
}

FloatToHex(f)
{
   form := A_FormatInteger
   SetFormat Integer, HEX
   v := DllCall("MulDiv", Float,f, Int,1, Int,1, UInt)
   SetFormat Integer, %form%
   Return v
}
