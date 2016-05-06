#NoEnv
SetBatchLines -1
SetWorkingDir %A_ScriptDir%

xlLastCell := 11

Clip := Clipboard

XL := ComObjCreate("Excel.Application")
XL.Workbooks.Open(A_ScriptDir "\Languages.xlsx")
XL.Sheets("Lang_Files").Activate
Xl.Range(Xl.Range("A1"), Xl.Range("A1").SpecialCells(xlLastCell)).Copy

ClipWait
Data := Clipboard, Clipboard := Clip
If !InStr(Data, "Lang_")=1
{
	MsgBox Error
	return
}
PMC := {}, nLang := []
Loop, Parse, Data, `n, `r
{
	Label := "", a := A_Index
	StringSplit, Line, A_LoopField, `t
	Loop, 2
		Label .= (a = 1) ? Line%A_Index% : Line%A_Index% "`t"
	Loop, % Line0 - 2
	{
		i := A_Index + 2
		PMC.Lang[A_Index] .= Label . Trim(Line%i%) "`n"
		If InStr(Label, "Lang_")
			nLang[A_Index] := Line%i%
	}
}

FileDelete, %A_ScriptDir%\Lang\*.Lang
For each, Lan in PMC.Lang
	FileAppend, % Lan, % A_ScriptDir "\Lang\" nLang[A_Index] ".lang", UTF-8

XL.Application.CutCopyMode := False
XL.Workbooks(1).Close(0)
TrayTip,, Finished extracting Lang files.
Sleep, 2000
return
