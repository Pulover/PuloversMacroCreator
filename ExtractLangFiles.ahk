xlLastCell = 11

XL := ComObjCreate("Excel.Application")
XL.Workbooks.Open(A_ScriptDir "\Languages.xls")
XL.Sheets("Lang_Files").Activate
Xl.Range(Xl.Range("A1"), Xl.Range("A1").SpecialCells(xlLastCell)).Copy
XL.Workbooks(1).Close(0)

ClipWait
If !InStr(Clipboard, "LoadLang_")=1
{
	MsgBox Error
	return
}
PMC := {}, nLang := []
Loop, Parse, Clipboard, `n, `r
{
	Label := "", a := A_Index
	StringSplit, Line, A_LoopField, `t
	Loop, 2
		Label .= (a = 1) ? Line%A_Index% : Line%A_Index% "`t"
	Loop, % Line0 - 2
	{
		i := A_Index + 2
		PMC.Lang[A_Index] .= Label . Line%i% "`n"
		If InStr(Label, "LoadLang_")
			nLang[A_Index] := SubStr(Line%i%, 1, 2)
	}
}

FileDelete, %A_ScriptDir%\MacroCreator\Lang\*.Lang
For each, Lan in PMC.Lang
	FileAppend, % Lan, % A_ScriptDir "\MacroCreator\Lang\" nLang[A_Index] ".Lang", UTF-8

MsgBox OK
