Class PMC
{
	Load(FileName)
	{
		local ID, Col, Row := [], Opt := []
		PmcCode := {}, ID := 0
		Loop, Read, %FileName%
		{
			If InStr(A_LoopReadLine, "[PMC Code]")=1
			{
				ID++, Row := [], Opt := []
				Loop, Parse, A_LoopReadLine, |
					Opt.Insert(A_LoopField)
			}
			Else If RegExMatch(A_LoopReadLine, "^\d+\|")
			{
				Col := []
				Loop, Parse, A_LoopReadLine, |
					Col.Insert(A_LoopField)
				Row.Insert(Col)
			}
			Else If (A_LoopReadLine = "")
				PmcCode[ID] := {Opt: Opt, Row: Row}
		}
		If (ID = 0)
		{
			If (PmcCode[0] = "")
				return 0
			PmcCode[1] := PmcCode[0], PmcCode[0] := "", ID := 1
		}
		return ID
	}

	Import(SelectedFile, DL="`n", New="1")
	{
		local FoundC, Labels, TabText

		Gui, chMacro:Submit, NoHide
		ColOrder := LVOrder_Get(10, ListID%A_List%)
		If New
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
			FoundC := PMC.Load(SelectedFile%A_Index%)
			Loop, %FoundC%
			{
				TabCount++
				Gui, chMacro:ListView, InputList%TabCount%
				GuiCtrlAddTab(TabSel, "Macro" TabCount)
			,	GuiAddLV(TabCount), CopyMenuLabels[TabCount] := "Macro" TabCount
				Menu, CopyTo, Add, % CopyMenuLabels[TabCount], CopyList
				PMC.LVLoad("InputList" TabCount, PmcCode[A_Index])
				Gui, chMacro:ListView, InputList%TabCount%
				ListCount%TabCount% := LV_GetCount()
			,	Opt := PmcCode[A_Index].Opt
			,	o_AutoKey[TabCount] := (Opt[2] <> "") ? Opt[2] : ""
			,	o_ManKey[TabCount] := (Opt[3] <> "") ? Opt[3] : ""
			,	o_TimesG[TabCount] := (Opt[4] <> "") ? Opt[4] : 1
			,	CoordMouse := (Opt[5] <> "") ? Opt[5] : CoordMouse
			,	OnFinishCode := (Opt[6] <> "") ? Opt[6] : 1
			,	Labels .= ((Opt[7] <> "") ? Opt[7] : "Macro" TabCount) "|"
			,	HistoryMacro%TabCount% := new LV_Rows()
			,	HistoryMacro%TabCount%.Add()
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
		GuiControl, 1:, CoordTip, CoordMode: %CoordMouse%
		Gui, 1:-Disabled
	}

	LVLoad(List, Code)
	{
		Critical
		Gui, chMacro:Default
		Gui, chMacro:ListView, %List%
		GuiControl, chMacro:-Redraw, %List%
		LV_Delete()
		For each, Col in Code.Row
		{
			Loop, % Col.MaxIndex()
				Col[A_Index] := RegExReplace(Col[A_Index], "¢", "|")
			chk := SubStr(Col[1], 1, 1)
		,	((Col[2] = "[Pause]") && (Col[6] <> "Sleep")) ? (Col[2] := "[" Col[6] "]") : ""
		,	((Col[6] = "Variable") && (Col[2] <> "[Assign Variable]")) ? (Col[6] := "Function") : ""
		,	Col[6] := RegExReplace(Col[6], "\s", "_")
		,	LV_Add("Check" chk, Col*)
		}
		GuiControl, chMacro:+Redraw, %List%
		Critical, Off
	}

	LVGet(List, DL="|")
	{
		Gui, chMacro:Default
		Gui, chMacro:ListView, %List%
		Row := []
		Loop, % LV_GetCount()
		{
			LV_GetTexts(A_Index, Action, Details, TimesX, DelayX, Type, Target, Window, Comment, Color)
			ckd := (LV_GetNext(A_Index-1, "Checked")=A_Index) ? "" : 0
		,	Row[A_Index] := [ckd A_Index, Action, Details, TimesX, DelayX, Type, Target, Window, Comment, Color]
			For each, Col in Row[A_Index]
			{
				Col := RegExReplace(Col, "\|", "¢")
				Text .= Col "|"
			}
			Text .= "`n"
		}
		StringReplace, Text, Text, `r,, All
		Data := {Row: Row, Text: Text}
		return Data
	}
}
