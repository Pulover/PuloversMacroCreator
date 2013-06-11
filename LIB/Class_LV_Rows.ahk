;========================================================================
;
; 				Class LV_Rows
;
; Author:		Pulover [Rodolfo U. Batista]
;				rodolfoub@gmail.com
;
; Additional functions for ListView controls.
;========================================================================
;
; This class provides an easy way to add more functionality to ListViews.
; Features:
; 		Copy:		Copy selected rows to memory.
; 		Cut:		Copy selected rows to memory and delete them.
; 		Paste:		Paste copied rows at selected position.
; 		Move:		Move selected rows up and down.
; 		Drag:		Drag-and-Drop selected rows.
;
;========================================================================

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
		If (this.ActiveSlot < this.Slot.MaxIndex())
			this.Slot.Remove(this.ActiveSlot+1, this.Slot.MaxIndex())
		Loop, % LV_GetCount()
		{
			RowData := LV_Rows.RowText(A_Index)
			Row[A_Index] := [RowData*]
		}
		this.Slot.Insert(Row)
		this.ActiveSlot := this.Slot.MaxIndex()
		return this.Slot.MaxIndex()
	}

	Undo()
	{
		If (this.ActiveSlot = 1)
			return False
		this.ActiveSlot -= 1
		this.Load(this.ActiveSlot)

		return this.ActiveSlot
	}

	Redo()
	{
		If (this.ActiveSlot = (this.Slot.MaxIndex()))
			return False
		this.ActiveSlot += 1
		this.Load(this.ActiveSlot)

		return this.ActiveSlot
	}

	Copy(Cut=0)
	{
		this.CopyData := {}
		LV_Row := 0
		Loop
		{
			LV_Row := LV_GetNext(LV_Row)
			If !LV_Row
				break
			RowData := LV_Rows.RowText(LV_Row)
			Row := [RowData*]
			this.CopyData.Insert(Row)
			CopiedLines++
		}
		If (Cut)
			LV_Rows.Delete()
		
		return CopiedLines
	}

	Delete()
	{
		If (LV_GetCount("Selected") = 0)
			return False
		LV_Row := 0
		Loop
		{
			LV_Row := LV_GetNext(LV_Row - 1)
			If !LV_Row
				break
			LV_Delete(LV_Row)
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
			LV_Row := TargetRow - 1
			For each, Row in this.CopyData
				LV_Insert(LV_Row+A_Index, Row*)
		}
		return True
	}

	Move(Up=False)
	{
		LV_Row := 0
		If Up
		{
			Loop
			{
				LV_Row := LV_GetNext(LV_Row)
				If !LV_Row
					break
				If (LV_Row = 1)
					return
				RowData := LV_Rows.RowText(LV_Row)
				LV_Insert(LV_Row-1, RowData*)
				LV_Delete(LV_Row+1)
				LV_Modify(LV_Row-1, "Select")
				If (A_Index = 1)
					LV_Modify(LV_Row-1, "Focus")
			}
		}
		Else
		{
			Selections := []
			Loop
			{
				LV_Row := LV_GetNext(LV_Row)
				If !LV_Row
					break
				If (LV_Row = LV_GetCount())
					return
				Selections.Insert(1, LV_Row)
			}
			For each, Row in Selections
			{
				RowData := LV_Rows.RowText(Row+1)
				LV_Insert(Row, RowData*)
				LV_Delete(Row+2)
				If (A_Index = 1)
					LV_Modify(Row+1, "Focus")
			}
		}
	}
	
	Drag(DragButton="D", AutoScroll=True, ScrollDelay=100, LineThick=2, Color="Black")
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
			Line_W := (LV_TotalNumOfRows > LV_NumOfRows) ? LV_lw - SM_CXVSCROLL : LV_lw

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
			If (LV_GetNext() < LV_currRow)
				o := Lines+1, FocusedRow := LV_currRow-1
			Else
				o := 1, FocusedRow := LV_currRow
			LV_Rows.Delete()
			DragRows := ""
			Loop, %Lines%
			{
				i := A_Index-o
				LV_Modify(LV_currRow+i, "Select")
			}
			LV_Modify(FocusedRow, "Focus")
		}

		return LV_currRow
	}

	; Internal Functions
	Load(Number)
	{
		If !IsObject(this.Slot[Number])
			return False

		LV_Delete()
		For each, Row in this.Slot[Number]
			LV_Add(Row*)

		return True
	}

	RowText(Index)
	{
		Data := []
		ckd := (LV_GetNext(Index-1, "Checked")=Index) ? 1 : 0
		Data.Insert("Check" ckd)
		Loop, % LV_GetCount("Col")
		{
			LV_GetText(Cell, Index, A_Index)
			Data.Insert(Cell)
		}

		return Data
	}
}

