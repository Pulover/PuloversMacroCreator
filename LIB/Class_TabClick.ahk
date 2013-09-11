;=======================================================================================
;
; Function:      TabClick
; Description:   Returns the Tab Index under the mouse.
;
; Author:        Pulover [Rodolfo U. Batista] (rodolfoub@gmail.com)
;
;=======================================================================================

Class TabClick
{
	__New()
	{
		return False
	}
	
	Drag(DragButton="LButton", LineThick=2, Color="Black")
	{
		Static TCM_GETITEMRECT  := 0x130A
		Static TCM_GETITEMCOUNT := 0x1304
		
		HitTab := this.Get()
		CoordMode, Mouse, Window
		MouseGetPos,,, TabWin, TabCtrl, 2
		WinGetPos, Win_X, Win_Y, Win_W, Win_H, ahk_id %TabWin%
		ControlGetPos, Tab_lx, Tab_ly, Tab_lw, Tab_lh, , ahk_id %TabCtrl%
		VarSetCapacity(TabXYStruct, 16, 0)
        While, GetKeyState(DragButton, "P")
        {
			MouseGetPos, Tab_mx, Tab_my,, CurrCtrl, 2
			CurrTab := this.Get()
			If (CurrTab = HitTab)
				continue
			SendMessage, TCM_GETITEMRECT, CurrTab-1, &TabXYStruct,, ahk_id %TabCtrl%
			Tab_X := NumGet(TabXYStruct, 0, "UInt"), Tab_Y := NumGet(TabXYStruct, 4, "UInt")
		,   Tab_X2 := NumGet(TabXYStruct, 8, "UInt"), Tab_Y2 := NumGet(TabXYStruct, 12, "UInt")
		,	Line_H := Tab_Y2-Tab_Y
			If (CurrTab < HitTab)
			{
				Line_Y := Win_Y + Tab_ly + Tab_Y
			,	Line_X := Win_X + Tab_lx + Tab_X - 6
			}
			Else
			{
				Line_Y := Win_Y + Tab_ly + Tab_Y
			,	Line_X := Win_X + Tab_lx + Tab_X2 + 3
			}
			If ((CurrCtrl <> TabCtrl) || (CurrTab = 0))
			{
                Gui, MarkLine:Cancel
                continue
			}
			Else
			{
				Gui, MarkLine:Color, %Color%
				Gui, MarkLine:+LastFound +AlwaysOnTop +Toolwindow -Caption +HwndLineMark
				Gui, MarkLine:Show, W%LineThick% H%Line_H% Y%Line_Y% X%Line_X% NoActivate
			}
		}
		Gui, MarkLine:Cancel
		If ((CurrTab <> 0) && (CurrTab <> HitTab))
		{
			SendMessage, TCM_GETITEMCOUNT, 0, 0,, ahk_id %TabCtrl%
			TotalTabs := ErrorLevel
			Order := this.Swap(HitTab, CurrTab, TotalTabs)
		,	Tabs := "|"
			For each, Index in Order
				Tabs .= TabGetText(TabCtrl, Index) "|"
			Order.Tabs := Tabs
			return Order
		}
		return CurrTab
	}

	Get()
	{
		Static TCM_HITTEST := 0x130D
		
		CoordMode, Mouse, Window
		MouseGetPos, mX, mY, hwnd, Control, 2
		ControlGetPos, cX, cY,,,, ahk_id %Control%
		x := mX-cX, y := mY-cY
		VarSetCapacity(HitTest, 12, 0)
	,	NumPut(x, HitTest, 0, "Int")
	,	NumPut(y, HitTest, 4, "Int")
		SendMessage, TCM_HITTEST, 0, &HitTest,, ahk_id %Control%
		return (ErrorLevel = 4294967295) ? 0 : (ErrorLevel+1)
	}
	
	Swap(From, To, Total)
	{
		Tabs := []
		Loop, %Total%
			Tabs[A_Index] := A_Index
		Tabs.Remove(From), Tabs.Insert(To, From)
		return Tabs
	}
}