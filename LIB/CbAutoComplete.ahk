;=======================================================================================
;
; Function:      CbAutoComplete
; Description:   Auto-completes typed values in a combobox with matches from the list.
;
; Author:        Pulover [Rodolfo U. Batista] (rodolfoub@gmail.com)
; Usage:         Call the function from the Combobox's gLabel, passing A_GuiControl or
;                    the control's associated variable, e.g.: CbAutoComplete(A_GuiControl)
;
;=======================================================================================
CbAutoComplete(CtrlVar)
{	; CB_GETEDITSEL = 0x0140, CB_SETEDITSEL = 0x0142
	If ((GetKeyState("Delete", "P")) || (GetKeyState("Backspace", "P")))
		return
	GuiControlGet, lHwnd, Hwnd, %CtrlVar%
	SendMessage, 0x0140, 0, 0,, ahk_id %lHwnd%
	MakeShort(ErrorLevel, Start, End)
	GuiControlGet, CurContent,, %lHwnd%
	GuiControl, ChooseString, %CtrlVar%, %CurContent%
	If (ErrorLevel)
	{
		ControlSetText,, %CurContent%, ahk_id %lHwnd%
		SendMessage, 0x0142, 0, MakeLong(Start, Start),, ahk_id %lHwnd%
		return
	}
	GuiControlGet, CurContent,, %lHwnd%
	SendMessage, 0x0142, 0, MakeLong(Start, StrLen(CurContent)),, ahk_id %lHwnd%
}

MakeLong(LoWord, HiWord)
{
	return (HiWord << 16) | (LoWord & 0xffff)
}

MakeShort(Long, ByRef LoWord, ByRef HiWord)
{
	LoWord := Long & 0xffff
,   HiWord := Long >> 16
}
