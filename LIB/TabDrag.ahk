;=======================================================================================
;
; Function:      TabDrag
; Description:   Shows a destination bar when dragging a tab in Tab Controls.
;                    and returns an array with the new order and text labels.
;
; Author:        Pulover [Rodolfo U. Batista] (rodolfoub@gmail.com)
; Credits:       TabGetText() adapted from TC_EX by just me
;                https://www.autohotkey.com/boards/viewtopic.php?f=6&t=1271
;
;=======================================================================================
TabDrag(DragButton := "LButton", LineThick := 2, Color := "Black", ShowUnder := false)
{
	Static TCM_GETITEMCOUNT := 0x1304
	
	HitTab := TabGet()
	CoordMode, Mouse, Window
	MouseGetPos, iTabX,, TabWin, TabCtrl, 2
	WinGetPos, Win_X, Win_Y, Win_W, Win_H, ahk_id %TabWin%
	ControlGetPos, Tab_lx, Tab_ly, Tab_lw, Tab_lh, , ahk_id %TabCtrl%
	If (ShowUnder)
	{
		TabGetRect(HitTab, TabCtrl, iTab_X, iTab_Y, iTab_X2, iTab_Y2)
	,	Line_Y := Win_Y + Tab_ly + iTab_Y2
	,   Line_X := Win_X + Tab_lx + iTab_X
	,   Line_W := iTab_X2 - iTab_X
	,   Line_W := Line_W * 96 / A_ScreenDPI
		Gui, MarkLineH:Color, %Color%
		Gui, MarkLineH:+LastFound +AlwaysOnTop +Toolwindow -Caption +HwndLineMark
		Gui, MarkLineH:Show, W%Line_W% H%LineThick% Y%Line_Y% X%Line_X% NoActivate Hide
	}
	While, GetKeyState(DragButton, "P")
	{
		MouseGetPos, Tab_mx,,, CurrCtrl, 2
		If (ShowUnder) && (Tab_mx != iTabX)
			Gui, MarkLineH:Show, NoActivate
		CurrTab := TabGet()
		If (CurrTab = HitTab)
			continue
		TabGetRect(CurrTab, TabCtrl, Tab_X, Tab_Y, Tab_X2, Tab_Y2)
	,   Line_H := Tab_Y2-Tab_Y
	,	Line_H := Line_H * 96 / A_ScreenDPI
		If (CurrTab < HitTab)
		{
			Line_Y := Win_Y + Tab_ly + Tab_Y
		,   Line_X := Win_X + Tab_lx + Tab_X - 6
		}
		Else
		{
			Line_Y := Win_Y + Tab_ly + Tab_Y
		,   Line_X := Win_X + Tab_lx + Tab_X2 + 3
		}
		If ((CurrCtrl != TabCtrl) || (CurrTab = 0))
		{
			CurrTab := ""
			Gui, MarkLineV:Cancel
			continue
		}
		Else
		{
			Gui, MarkLineV:Color, %Color%
			Gui, MarkLineV:+LastFound +AlwaysOnTop +Toolwindow -Caption +HwndLineMark
			Gui, MarkLineV:Show, W%LineThick% H%Line_H% Y%Line_Y% X%Line_X% NoActivate
		}
	}
	Gui, MarkLineV:Cancel
	Gui, MarkLineH:Cancel
	If ((CurrTab) && (CurrTab != HitTab))
	{
		SendMessage, TCM_GETITEMCOUNT, 0, 0,, ahk_id %TabCtrl%
		TotalTabs := ErrorLevel, TabInfo := []
		Order := Swap(HitTab, CurrTab, TotalTabs)
	,   Tabs := "|"
		For each, Index in Order
			Tabs .= TabGetText(TabCtrl, Index) "|"
		TabInfo.Tabs := Tabs, TabInfo.Order := Order
		return TabInfo
	}
	return CurrTab
}
;=======================================================================================
; Private Functions:
;=======================================================================================
TabGet()
{
	Static TCM_HITTEST := 0x130D
	
	CoordMode, Mouse, Window
	MouseGetPos, mX, mY, hwnd, Control, 2
	ControlGetPos, cX, cY,,,, ahk_id %Control%
	x := mX-cX, y := mY-cY
	VarSetCapacity(HitTest, 12, 0)
,   NumPut(x, HitTest, 0, "Int")
,   NumPut(y, HitTest, 4, "Int")
	SendMessage, TCM_HITTEST, 0, &HitTest,, ahk_id %Control%
	return (ErrorLevel = 4294967295) ? 0 : (ErrorLevel+1)
}
;=======================================================================================
TabGetRect(Tab, Hwnd, ByRef Left, ByRef Top, ByRef Right, ByRef Bottom)
{
	Static TCM_GETITEMRECT  := 0x130A
	
	VarSetCapacity(TabXYStruct, 16, 0)
	SendMessage, TCM_GETITEMRECT, Tab-1, &TabXYStruct,, ahk_id %Hwnd%
	Left := NumGet(TabXYStruct, 0, "UInt"), Top := NumGet(TabXYStruct, 4, "UInt")
,   Right := NumGet(TabXYStruct, 8, "UInt"), Bottom := NumGet(TabXYStruct, 12, "UInt")
}
;=======================================================================================
TabGetText(HTC, TabIndex)
{
   Static TCIF_TEXT := 0x0001
   Static TCM_GETITEM := A_IsUnicode ? 0x133C : 0x1305 ; TCM_GETITEMW : TCM_GETITEMA
   Static OffTxL := (3 * 4) + (A_PtrSize - 4) + A_PtrSize
   Static OffTxP := (3 * 4) + (A_PtrSize - 4)
   Static MaxLength := 256
   If (TabIndex < 0) or (TabIndex > GetCount(HTC))
      Return
   VarSetCapacity(ItemText, MaxLength * (A_IsUnicode ? 2 : 1), 0)
   CreateTCITEM(TCITEM)
   NumPut(TCIF_TEXT, TCITEM, 0, "UInt")
   NumPut(&ItemText, TCITEM, OffTxP, "Ptr")
   NumPut(MaxLength, TCITEM, OffTxL, "Int")
   SendMessage, % TCM_GETITEM, % (TabIndex - 1), % &TCITEM, , % "ahk_id " . HTC
   If (ErrorLevel = 0)
      Return
   TxtPtr := NumGet(TCITEM, OffTxP, "UPtr")
   If (TxtPtr = 0)
      Return
   Return StrGet(TxtPtr, MaxLength)
}
; ======================================================================================================================
CreateTCITEM(ByRef TCITEM) {
   Static Size := (5 * 4) + (2 * A_PtrSize) + (A_PtrSize - 4)
   VarSetCapacity(TCITEM, Size, 0)
}
; ======================================================================================================================
GetCount(HTC) {
   Static TCM_GETITEMCOUNT := 0x1304
   SendMessage, % TCM_GETITEMCOUNT, 0, 0, , % "ahk_id " . HTC
   Return ErrorLevel
}
;=======================================================================================
Swap(From, To, Total)
{
	Tabs := []
	Loop, %Total%
		Tabs[A_Index] := A_Index
	Tabs.RemoveAt(From), Tabs.InsertAt(To, From)
	return Tabs
}
