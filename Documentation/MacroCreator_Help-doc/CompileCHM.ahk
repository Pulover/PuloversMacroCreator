SetWorkingDir %A_ScriptDir%
#SingleInstance, Force
FileEncoding, UTF-8

File := A_ScriptDir "\index.html"
FileRead, FileData, %File%
PMCVer := RegExReplace(FileData, "s).*Version: ([\d\.]+).*", "$1")
Data := "<a href=""https://www.macrocreator.com/""><img src=""Images/PMC.png"" alt=""Pulover's Macro Creator"" border=""0""></a>"
FileMod_Change(FileData, Data, 11)
Data := "<h1 id=""version:-" PMCVer """>Version: <a href=""About.html#change-log"">" PMCVer "</a></h1>"
FileMod_Change(FileData, Data, 12)
Data := "<Version: " PMCVer ">`n</head>"
FileMod_Change(FileData, Data, 9)
FileDelete, %File%
FileAppend, %FileData%, %File%

RunWait, hhc.exe MacroCreator_Help.chm,, UseErrorLevel
If ErrorLevel = ERROR
{
	MsgBox, 0x40000, Error, File: %A_ScriptFullPath%`nError code: %A_LastError%
	ExitApp, %A_LastError%
}
return

; ###############################################
;
; File Modification Functions - by Gamax92

; FileMod_Append(FileData, Data, Line)
; FileData - The name of a variable in which a file has been copied to.
; Data     - The String to add to the Line
; Line     - The line number to place this data on
;
; Returns 1 on success or 0 on failure

; FileMod_Change(FileData, Data, Line)
; FileData - The name of a variable in which a file has been copied to.
; Data     - The String to change the Line to
; Line     - The line number to swap this data with
;
; Returns 1 on success or 0 on failure

; FileMod_DeleteLine(FileData, Line)
; FileData - The name of a variable in which a file has been copied to.
; Line     - The line number to remove
;
; Returns 1 on success or 0 on failure

; FileMod_DeleteLines(FileData, Line)
; FileData - The name of a variable in which a file has been copied to.
; Line     - A list of Numbers seperated by a "|"
;
; Returns the number of lines that failed to be removed

FileMod_Append(ByRef FileData, Data, Line)
{
	Loop, parse, FileData, `n, `r
	{
    	FileData%a_index% := A_LoopField
	    FileData0 := a_index
	}
	If (Line <= FileData0 && Line > 0)
	{
		v_index := FileData0 - Line
		While v_index > -1
		{
			b_index := v_index + Line
			c_index := v_index + Line + 1
	    	FileData%c_index% := FileData%b_index%
			v_index -= 1
		}
		FileData%Line% := Data
		FileData0 := FileData0 + 1
		TmpVar := ""
		Loop, % FileData0
		{
			TmpVar .= FileData%a_index% . "`r`n"
		}
		StringTrimRight, FileData, TmpVar, 2
		Return 1
	}
	Else
		Return 0
}

FileMod_Change(ByRef FileData, Data, Line)
{
	Loop, parse, FileData, `n, `r
	{
    	FileData%a_index% := A_LoopField
	    FileData0 := a_index
	}
	If (Line <= FileData0 && Line > 0)
	{
		FileData%Line% := Data
		TmpVar := ""
		Loop, % FileData0
		{
			TmpVar .= FileData%a_index% . "`r`n"
		}
		StringTrimRight, FileData, TmpVar, 2
	}
	Else
		Return 0
}

FileMod_DeleteLine(ByRef FileData, Line)
{
	Loop, parse, FileData, `n, `r
	{
    	FileData%a_index% := A_LoopField
	    FileData0 := a_index
	}
	If (Line <= FileData0 && Line > 0)
	{
		Loop, % FileData0 - Line
		{
			b_index := a_index + Line
			c_index := a_index + Line - 1
    		FileData%c_index% := FileData%b_index%
		}
		FileData0 := FileData0 - 1
		TmpVar := ""
		Loop, % FileData0
		{
			TmpVar .= FileData%a_index% . "`r`n"
		}
		StringTrimRight, FileData, TmpVar, 2
		Return 1
	}
	Else
		Return 0
}

FileMod_DeleteLines(ByRef FileData, Line)
{
	StringSplit, Line, Line, |
	Reduction := 0
	Errors := 0
	Loop, % Line0
	{
		b_index := a_index - Reduction
		If (!FileMod_DeleteLine(FileData, Line%b_index%))
			Errors += 1
		b_index := a_index + 1
		If (Line%b_index% > Line%a_index%)
			Reduction += 1
	}
	Return Errors
}


