Class PMC
{
	Static PmcCode
	Static PmcGroups
	Load(FileName)
	{
		local ID := 0, Col, Row := [], Opt := []
		this.PmcCode := [], this.PmcGroups := []
		Loop, Read, %FileName%
		{
			If (RegExMatch(A_LoopReadLine, "\[PMC Code(\sv)*(.*)\]", v)=1)
			{
				ID++, Row := [], Opt := [], Version := v2
				Loop, Parse, A_LoopReadLine, |
					Opt.Push(A_LoopField)
			}
			Else If (InStr(A_LoopReadLine, "Groups=")=1)
				this.PmcGroups[ID] := SubStr(A_LoopReadLine, 8)
			Else If (RegExMatch(A_LoopReadLine, "^\d+\|"))
			{
				Col := []
				Loop, Parse, A_LoopReadLine, |
					Col.Push(A_LoopField)
				Row.Push(Col)
			}
			Else If (Trim(A_LoopReadLine) = "")
				this.PmcCode[ID] := {Opt: Opt, Row: Row, Version: Version}
		}
		If (!IsObject(this.PmcCode[ID].opt))
			this.PmcCode[ID] := {Opt: Opt, Row: Row, Version: Version}
		If (ID = 0)
		{
			If (this.PmcCode[0] = "")
				return 0
			this.PmcCode[1] := this.PmcCode[0], this.PmcCode[0] := "", ID := 1
		,	this.PmcGroups[1] := this.PmcGroups[0], this.PmcGroups[0] := ""
		}
		return ID
	}

	Import(SelectedFile, DL := "`n", New := "1")
	{
		local FoundC, Labels, TabText, AutoRefreshState

		Gui, chMacro:Submit, NoHide
		ColOrder := LVOrder_Get(10, ListID%A_List%)
		If (New)
		{
			GoSub, DelLists
			GuiControl, chMacro:Choose, A_List, 1
			GuiControl, chMacro:, A_List, |
			TabCount := 0
		}
		Else
		{
			Loop, %TabCount%
				Labels .= TabGetText(TabSel, A_Index) "|"
		}
		Gui, 1:+Disabled
		Gui, chMacro:Default
		StringSplit, SelectedFile, SelectedFile, %DL%, `r
		Loop, %SelectedFile0%
		{
			If InStr(FileExist(SelectedFile%A_Index%), "D")
				continue
			If InStr(SelectedFile%A_Index%, ".pmc")
				LoadedFileName := SelectedFile%A_Index%
			Else
				LoadedFileName := ""
			FoundC := this.Load(SelectedFile%A_Index%)
			Loop, %FoundC%
			{
				TabCount++
				Gui, chMacro:ListView, InputList%TabCount%
				GuiControl, chMacro:, %TabSel%, Macro%TabCount%
				GuiAddLV(TabCount), CopyMenuLabels[TabCount] := "Macro" TabCount
				Menu, CopyTo, Add, % CopyMenuLabels[TabCount], CopyList, Radio
				GuiControl, chMacro:-g, InputList%TabCount%
				this.LVLoad("InputList" TabCount, this.PmcCode[A_Index])
				Gui, chMacro:ListView, InputList%TabCount%
				ListCount%TabCount% := LV_GetCount()
			,	Opt := this.PmcCode[A_Index].Opt
			,	o_AutoKey[TabCount] := (Opt[2] != "") ? Opt[2] : ""
			,	o_ManKey[TabCount] := (Opt[3] != "") ? Opt[3] : ""
			,	o_TimesG[TabCount] := (Opt[4] != "") ? Opt[4] : 1
				
				If (Opt[5] != "")
				{
					Loop, 9
						Mode%A_Index% := ""
					Loop, Parse, % Opt[5], `,, %A_Space%
						Mode%A_Index% := A_LoopField
					CoordMouse := (Mode1 != "") ? Mode1 : CoordMouse
				,	TitleMatch := (Mode2 != "") ? Mode2 : TitleMatch
				,	TitleSpeed := (Mode3 != "") ? Mode3 : TitleSpeed
				,	HiddenWin := (Mode4 != "") ? Mode4 : HiddenWin
				,	HiddenText := (Mode5 != "") ? Mode5 : HiddenText
				,	KeyMode := (Mode6 != "") ? Mode6 : KeyMode
				,	KeyDelay := (Mode7 != "") ? Mode7 : KeyDelay
				,	MouseDelay := (Mode8 != "") ? Mode8 : MouseDelay
				,	ControlDelay := (Mode9 != "") ? Mode9 : ControlDelay
				}
				
				OnFinishCode := (Opt[6] != "") ? Opt[6] : 1
			,	Labels .= ((Opt[7] != "") ? Opt[7] : "Macro" TabCount) "|"
			,	LVManager.SetHwnd(ListID%TabCount%), LVManager.ClearHistory()
			,	LVManager.SetGroups(this.PmcGroups[A_Index]), LVManager.Add()
				GuiControl, chMacro:+gInputList, InputList%TabCount%
			}
		}
		If (TabCount = 0)
			GoSub, TabPlus
		Else
		{
			RemoveDuplicates(Labels)
			GuiControl, chMacro:, A_List, |%Labels%
			GoSub, UpdateCopyTo
		}
		GoSub, SetFinishButtom
		GuiControl, 1:, CoordTip, <a>CoordMode</a>: %CoordMouse%
		GuiControl, 1:, TModeTip, <a>TitleMatchMode</a>: %TitleMatch%
		GuiControl, 1:, TSendModeTip, <a>SendMode</a>: %KeyMode%
		Gui, 1:-Disabled
	}

	LVLoad(List, Code)
	{
		Global UserDefFunctions
		Static _w := Chr(2), _x := Chr(3), _y := Chr(4), _z := Chr(5)
		
		Gui, chMacro:Default
		Gui, chMacro:ListView, %List%
		GuiControl, chMacro:-Redraw, %List%
		LV_Delete()
		For each, Col in Code.Row
		{
			Loop, % Col.Length()
				Col[A_Index] := RegExReplace(Col[A_Index], (Code.Version = "") ? "¢" : _x, "|")
			chk := SubStr(Col[1], 1, 1)
		,	((Col[2] = "[Pause]") && (Col[6] != "Sleep")) ? (Col[2] := "[" Col[6] "]") : ""
		,	((Col[6] = "LoopFilePattern") && (RegExMatch(Col[3], "```, \d```, \d"))) ? (Col[3] := this.FormatCmd(Col[3], "Files")) : ""
		,	((Col[6] = "LoopRegistry") && (RegExMatch(Col[3], "```, \d```, \d"))) ? (Col[3] := this.FormatCmd(Col[3], "Reg")) : ""
		,	((Col[6] = "Variable") && (!InStr(Col[2], " Variable]"))) ? (Col[6] := "Function") : ""
		,	Col[6] := RegExReplace(Col[6], "\s", "_")
			If (Col[6] = "UserFunction")
			{
				If (!InStr(UserDefFunctions, " " Col[3] " "))
				{
					StringLower, UserDefFunc, % Col[3]
					UserDefFunctions .= UserDefFunc " "
				,	SetUserWords(UserDefFunctions)
				}
			}
			If (Code.Version < "5.0.2")
			{
				If (Col[6] = "SendEmail")
				{
					Action := Col[2]
					StringSplit, Act, Action, :
					Action := SubStr(Col[2], StrLen(Act1) + 2)
				,	Col[2] := Act1, Col[3] := Action "=" Col[3]
				}
				If ((Col[6] = "DownloadFiles") || (Col[6] = "Zip") || (Col[6] = "Unzip"))
					Col[8] := Col[7], Col[7] := Col[2], Col[2] := "[" StrReplace(Col[6], "Files") "]"
				If ((InStr(Col[6], "Search")) || (Col[6] = "Variable") || (Col[6] = "Function"))
					Col[3] := StrReplace(Col[3], "``,", ","), Col[7] := StrReplace(Col[7], "``,", ","), Col[8] := StrReplace(Col[8], "``,", ",")
			}
			If (Code.Version = "")
			{
				Col[3] := CheckForExp(Col[3])
			,	Col[4] := CheckForExp(Col[4])
			,	Col[5] := CheckForExp(Col[5])
			,	Col[7] := CheckForExp(Col[7])
			,	Col[8] := CheckForExp(Col[8])
				If ((Col[2] = "[Assign Variable]") && (Col[7] = "Expression"))
					Col[3] := CheckComExp(Col[3])
				If (Col[6] = "Function")
				{
					RegExMatch(Col[3], "sU)(.+)\s(\W?\W\W?)(?-U)\s(.*)", Out)
				,	Col[3] := Out1 " " Out2 " " CheckExp(Out3)
				}
				If (Col[6] = "COMInterface")
				{
					Action := Col[2]
					StringSplit, Act, Action, :
					If (Act2 != "")
						Details := Act2 " := " Act1 "." CheckComExp(Col[3],,, Act1)
					Else
					{
						Details := "", Step := StrReplace(Col[3], "``n", "`n")
						Loop, Parse, Step, `n, %A_Space%%A_Tab%
						{
							If (A_LoopField = "")
								continue
							ComExp := CheckComExp(A_LoopField,,, Act1)
						,	Details .= Act1 "." ComExp "``n"
						}
					}
					Col[2] := Act1, Col[3] := Details
				}
				If ((Col[6] = "VBScript") || (Col[6] = "JScript"))
				{
					Act := SubStr(Col[2], 1, 2)
				,	LV_Add("Check" chk, 1, "[Assign Variable]", Act "Code := " Col[3], 1, 0, "Variable")
				,	Details := Act ".Language := """ Col[6] """"
				,	Details .= "`n" Act ".ExecuteStatement(" Act "Code)"
				,	Col[2] := Act, Col[3] := Details, Col[6] := "COMInterface"
				}
				If (InStr(Col[6], "Search"))
				{
					If (Col[7] = "Break")
						Col[7] := "UntilFound"
					If (Col[7] = "Continue")
						Col[7] := "UntilNotFound"
				}
				If (InStr(Col[6], "Win") = 1)
					Col[3] := StrReplace(Col[3], "``,", ",")
				If ((Col[6] != "MsgBox") && (Col[6] != "PixelSearch") && (Col[6] != "ImageSearch"))
					Col[8] := StrReplace(Col[8], "``,", ",")
			}
			LV_Add("Check" chk, Col*)
		}
		GuiControl, chMacro:+Redraw, %List%
	}

	LVGet(List, DL := "|")
	{
		Static _w := Chr(2), _x := Chr(3), _y := Chr(4), _z := Chr(5)
		
		Gui, chMacro:Default
		Gui, chMacro:ListView, %List%
		Row := []
		Loop, % LV_GetCount()
		{
			LV_GetTexts(A_Index, Action, Details, TimesX, DelayX, Type, Target, Window, Comment, Color)
		,	ckd := (LV_GetNext(A_Index-1, "Checked")=A_Index) ? "" : 0
		,	Row[A_Index] := [ckd A_Index, Action, Details, TimesX, DelayX, Type, Target, Window, Comment, Color]
		}
		Loop, % LV_GetCount()
		{
			For each, Col in Row[A_Index]
			{
				Col := RegExReplace(Col, "\|", _x)
				Text .= Col "|"
			}
			Text .= "`n"
		}
		StringReplace, Text, Text, `r,, All
		Data := {Row: Row, Text: Text}
		return Data
	}
	
	FormatCmd(ColTxt, Type)
	{
		StringSplit, Col, ColTxt, `,, ``
		If (Type = "Files")
		{
			NewText := Col1 "`, "
			If (Col2 = 0)
				NewText .= "F"
			Else If (Col2 = 1)
				NewText .= "FD"
			Else If (Col2 = 2)
				NewText .= "D"
			If (Col3 = 1)
				NewText .= "R"
		}
		Else If (Type = "Reg")
		{
			NewText := Col1 "\" Col2 "`, "
			If (Col3 = 0)
				NewText .= "V"
			Else If (Col3 = 1)
				NewText .= "VK"
			Else If (Col3 = 2)
				NewText .= "K"
			If (Col4 = 1)
				NewText .= "R"
		}
		return NewText
	}
}
