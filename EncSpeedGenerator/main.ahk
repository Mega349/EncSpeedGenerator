main:
Gosub, CheckTroveWindow

MsgBox,% "Open your Charcheet ('C') then Press [OK]"

SpeedAoB := ReadMemoryAoB(SpeedAddress, PID, 4) ; 4 Byte einlesen und in index 0-3 Schreiben
SpeedAoB[2] := 0 ; mit 0 überschreiben um von vorne anzufangen
SpeedAoB[3] := 0 ; mit 0 überschreiben um von vorne anzufangen

SpeedArray := []

while (SpeedAoB[2] <= 255)
{
    while (SpeedAoB[3] <= 255)
    {
        WriteMemoryAoB(SpeedAddress, PID, SpeedAoB)
        sleep, 50 ; wenn Zeit zu kurz wird z.B. nur 0.000000 (NaN) gelesen oder Werte von vorher nochmnal
        currentDEZSpeedValue := HexToFloat(ReadMemory(SpeedDEZAddress, PID))
        currentSpeedValue := ReadMemory(SpeedAddress, PID)
        SpeedArray[SpeedArray.Length()+1] := currentDEZSpeedValue "=" currentSpeedValue 
        SpeedAoB[3]++
    }
    SpeedAoB[3] := 0
    SpeedAoB[2]++
}

;SpeedArray := ReadFiletoArray("test.txt")

;WriteArraytoFile("untrimmed-"SpeedFile, SpeedArray)
SpeedArray := trimArray(SpeedArray,"^[1-9]\d?\d?\.0{6}=\d+") ; wirft alles weg was nicht in die RegEx passt!
;WriteArraytoFile("trimmed-"SpeedFile, SpeedArray)
SpeedArray := sortArray(SpeedArray) ; Array -> String (mit "$" trennen) -> String sortieren -> Array
WriteArraytoFile(SpeedFile, SpeedArray)
MsgBox,% SpeedArray.Length() " Ergebnisse"
return
