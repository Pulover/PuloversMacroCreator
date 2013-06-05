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
				PmcCode[ID] := {Opt: Opt, Row: Row}
			}
		}
		If (ID = 0)
		{
			If (PmcCode[0] = "")
				return 0
			PmcCode[1] := PmcCode[0]
			PmcCode[0] := ""
			ID := 1
		}
		return ID
	}

	Import(SelectedFile, DL="`n", New="1")
	{
		local FoundC
		If New
		{
			GoSub, DelLists
			GuiControl, Choose, A_List, 1
			GuiControl,, A_List, |
			TabCount := 0
		}
		Gui, +Disabled
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
				Gui, ListView, InputList%TabCount%
				GuiCtrlAddTab(TabSel, "Macro" TabCount)
				GuiAddLV(TabCount)
				Menu, CopyMenu, Add, Macro%TabCount%, CopyList
				PMC.LVLoad("InputList" TabCount, PmcCode[A_Index])
				Sleep, 1
				Gui, ListView, InputList%TabCount%
				ListCount%TabCount% := LV_GetCount()
				Opt := PmcCode[A_Index].Opt
				o_AutoKey[TabCount] := (Opt[2] <> "") ? Opt[2] : ""
				o_ManKey[TabCount] := (Opt[3] <> "") ? Opt[3] : ""
				o_TimesG[TabCount] := (Opt[4] <> "") ? Opt[4] : 1
				CoordMouse := (Opt[5] <> "") ? Opt[5] : CoordMouse
				HistoryMacro%TabCount% := new RowsData()
				HistoryMacro%TabCount%.Add()
			}
		}
		If (TabCount = 0)
			GoSub, TabPlus
		GuiControl,, CoordTip, CoordMode: %CoordMouse%
		Gui, -Disabled
	}

	LVLoad(List, Code)
	{
		Critical
		Gui, 1:Default
		Gui, ListView, %List%
		GuiControl, -Redraw, %List%
		LV_Delete()
		For each, Col in Code.Row
		{
			Loop, % Col.MaxIndex()
				Col[A_Index] := RegExReplace(Col[A_Index], "¢", "|")
			chk := SubStr(Col[1], 1, 1)
			LV_Add("Check" chk, Col*)
		}
		GuiControl, +Redraw, %List%
		Critical, Off
	}

	LVGet(List, DL="|")
	{
		Gui, 1:Default
		Gui, ListView, %List%
		Row := []
		Loop, % LV_GetCount()
		{
			LV_GetTexts(A_Index, Action, Details, TimesX, DelayX, Type, Target, Window, Comment)
			ckd := (LV_GetNext(A_Index-1, "Checked")=A_Index) ? "" : 0
			Row[A_Index] := [ckd A_Index, Action, Details, TimesX, DelayX, Type, Target, Window, Comment]
			For each, Col in Row[A_Index]
			{
				Col := RegExReplace(Col, "\|", "¢")
				Text .= Col "|"
			}
			Text .= "`n"
		}
		Data := {Row: Row, Text: Text}
		return Data
	}
}
