Class LV_Rows
{
	__New()
	{
		this.Slot := []
		this.ActiveSlot := 1
	}

	__Call()
	{
		global SavePrompt := True
	}

	__Delete()
	{
		this.Remove("", Chr(255))
		this.SetCapacity(0)
		this.base := ""
	}

	Add()
	{
		Row := []
		Gui, 1:Default
		Loop, % LV_GetCount()
		{
			RowData := LV_Rows.RowText(A_Index)
			ckd := (LV_GetNext(A_Index-1, "Checked")=A_Index) ? 1 : 0
			Row[A_Index] := ["Check" ckd, RowData*]
		}
		this.Slot.Insert(Row)
	}

	Load(N)
	{
		For each, Row in this.Slot[N]
			LV_Add(Row*)
	}

	Copy(Cut=0)
	{
		this.CopyData := {}
		RowNumber := 0
		Loop
		{
			RowNumber := LV_GetNext(RowNumber)
			If !RowNumber
				break
			RowData := LV_Rows.RowText(RowNumber)
			ckd := (LV_GetNext(RowNumber-1, "Checked")=RowNumber) ? 1 : 0
			Row := ["Check" ckd, RowData*]
			this.CopyData.Insert(Row)
			CopiedLines++
		}
		If (Cut)
			LV_Rows.Delete()
		
		return CopiedLines
	}

	Delete()
	{
		RowNumber := 0
		Loop
		{
			RowNumber := LV_GetNext(RowNumber - 1)
			If !RowNumber
				break
			LV_Delete(RowNumber)
			DeletedLines++
		}
		
		return DeletedLines
	}

	Paste(Row=0)
	{
		If !this.CopyData.MaxIndex()
			return False
		TargetRow := Row ? Row : LV_GetNext()
		If !TargetRow
		{
			For each, Row in this.CopyData
				LV_Add(Row*)
		}
		Else
		{
			RowNumber := TargetRow - 1
			For each, Row in this.CopyData
				LV_Insert(RowNumber+A_Index, Row*)
		}
		return True
	}

	Drag(AutoScroll=1, ScrollDelay=100, DragButton="D", LineThick=2, Color="Black")
	{
		LVIR_LABEL := 0x0002
		LVM_GETITEMCOUNT := 0x1004
		LVM_SCROLL := 0x1014
		LVM_GETTOPINDEX := 0x1027
		LVM_GETCOUNTPERPAGE := 0x1028
		LVM_GETSUBITEMRECT := 0x1038
		LV_currColHeight := 0
		SysGet, SM_CXVSCROLL, 2

		If InStr(DragButton, "d", True)
			DragButton := "RButton"
		Else
			DragButton := "LButton"

		CoordMode, Mouse, Window
		MouseGetPos,,, LV_Win, LV_LView, 2
		WinGetPos, Win_X, Win_Y, Win_W, Win_H, ahk_id %LV_Win%
		ControlGetPos, LV_lx, LV_ly, LV_lw, LV_lh, , ahk_id %LV_LView%
		Line_W := LV_lw - SM_CXVSCROLL
		VarSetCapacity(LV_XYstruct, 16, 0)

		While, GetKeyState(DragButton, "P")
		{
			MouseGetPos, LV_mx, LV_my,, CurrCtrl, 2
			LV_mx -= LV_lx, LV_my -= LV_ly

			If (AutoScroll)
			{
				If (LV_my < 0)
				{
					SendMessage, LVM_SCROLL, 0, -LV_currColHeight, , ahk_id %LV_LView%
					Sleep, %ScrollDelay%
				}
				If (LV_my > LV_lh)
				{
					SendMessage, LVM_SCROLL, 0, LV_currColHeight, , ahk_id %LV_LView%
					Sleep, %ScrollDelay%
				}
			}

			If (CurrCtrl <> LV_LView)
			{
				LV_currRow := ""
				Gui, MarkLine:Cancel
				continue
			}

			SendMessage, LVM_GETITEMCOUNT, 0, 0, , ahk_id %LV_LView%
			LV_TotalNumOfRows := ErrorLevel
			SendMessage, LVM_GETCOUNTPERPAGE, 0, 0, , ahk_id %LV_LView%
			LV_NumOfRows := ErrorLevel
			SendMessage, LVM_GETTOPINDEX, 0, 0, , ahk_id %LV_LView%
			LV_topIndex := ErrorLevel

			Loop,% LV_NumOfRows + 1
			{	
				LV_which := LV_topIndex + A_Index - 1
				NumPut(LVIR_LABEL, LV_XYstruct, 0)
				NumPut(A_Index - 1, LV_XYstruct, 4)
				SendMessage, LVM_GETSUBITEMRECT, %LV_which%, &LV_XYstruct, , ahk_id %LV_LView%
				LV_RowY := NumGet(LV_XYstruct,4)
				LV_RowY2 := NumGet(LV_XYstruct,12)
				LV_currColHeight := LV_RowY2 - LV_RowY
				If(LV_my <= LV_RowY + LV_currColHeight)
				{	
					LV_currRow  := LV_which + 1
					LV_currRow0 := LV_which
					Line_Y := Win_Y + LV_ly + LV_RowY
					Line_X := Win_X + LV_lx
					If (LV_currRow > (LV_TotalNumOfRows+1))
					{
						Gui, MarkLine:Cancel
						LV_currRow := ""
					}
					Break
				}
			}

			If LV_currRow
			{
				Gui, MarkLine:Color, %Color%
				Gui, MarkLine:+LastFound +AlwaysOnTop +Toolwindow -Caption +HwndLineMark
				Gui, MarkLine:Show, W%Line_W% H%LineThick% Y%Line_Y% X%Line_X% NoActivate
			}
		}
		Gui, MarkLine:Cancel

		If LV_currRow
		{
			DragRows := new LV_Rows()
			Lines := DragRows.Copy()
			DragRows.Paste(LV_currRow)
			LV_Rows.Delete()
			DragRows := ""
		}

		return LV_currRow
	}

	RowText(Index)
	{
		Data := []
		Loop, % LV_GetCount("Col")
		{
			LV_GetText(Cell, Index, A_Index)
			Data.Insert(Cell)
		}

		return Data
	}
}

