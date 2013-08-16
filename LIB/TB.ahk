TB_Define(ByRef TbPtr, hCtrl, hIL, ButtonsArray, Options="", Rows=0)
{
	TbPtr := New Toolbar(hCtrl), TbPtr.SetImageList(hIL)
,	TbPtr.Add(Options, ButtonsArray*), TbPtr.SetMaxTextRows(Rows)
,	TbPtr.SetExStyle("DrawDDArrows HideClippedButtons")
}

TB_Rebar(RbPtr, BandID, tbChild, Options="", Text="")
{
	tbWidth := TB_GetSize(tbChild)
	tbChild.Get(,,, tbBtnWidth, tbBtnHeight)
,	NumButtons := tbChild.GetCount()
,	RbPtr.InsertBand(tbChild.tbHwnd, 0, Options, BandID, Text
	,	tbWidth+16, 0,, tbBtnHeight, tbBtnWidth, tbWidth)
}

TB_GetSize(tbPtr)
{
	tbWidth := 0
	Loop, % tbPtr.GetCount()
	{
		tbPtr.GetButtonPos(A_Index, "", "", btnWidth)
	,	tbWidth += btnWidth
	}
	return tbWidth
}

TB_Edit(tbPtr, tbButton, Check="", Enable="", Capt="")
{
	Index := tbPtr.LabelToIndex(tbButton)
	If (Check <> "")
		tbPtr.ModifyButton(Index, "Check", Check)
	If (Enable <> "")
		tbPtr.ModifyButton(Index, "Enable", Enable)
	If (Capt <> "")
		tbPtr.ModifyButtonInfo(Index, "Text", Capt)
}

TB_Messages(wParam, lParam)
{
	tbPtr := TB_GetHwnd(lParam)
    tbPtr.OnMessage(wParam)
}

TB_GetHwnd(Hwnd)
{
	Global TBHwndAll
	For each, Ptr in TBHwndAll
	{
		If (Ptr.tbHwnd = Hwnd)
			return Ptr
	}
	return False
}
