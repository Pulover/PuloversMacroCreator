TB_Define(ByRef TbPtr, hCtrl, hIL, ButtonsArray, Options="", Rows=0)
{
	TbPtr := New Toolbar(hCtrl), TbPtr.SetImageList(hIL)
,	TbPtr.Add(Options, ButtonsArray*), TbPtr.SetMaxTextRows(Rows)
,	TbPtr.SetExStyle("DrawDDArrows HideClippedButtons")
,	TbPtr.SetExStyle("DrawDDArrows HideClippedButtons")
}

TB_Rebar(RbPtr, BandID, tbChild, Options="", Text="")
{
	tbWidth := 0
	loop, % tbChild.GetCount()
	{
		tbChild.GetButtonPos(A_Index, "", "", btnWidth)
	,	tbWidth += btnWidth
	}
	tbChild.Get("", "", "", tbBtnWidth, tbBtnHeight)
,	NumButtons := tbChild.GetCount()
,	RbPtr.InsertBand(tbChild.tbHwnd, 0, Options, BandID, Text
	,	tbWidth+16, 0, "", tbBtnHeight, tbBtnWidth, tbWidth)
}

TB_Messages(wParam, lParam, msg, hwnd)
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
