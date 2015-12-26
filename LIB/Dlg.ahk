;###########################################################
; Original by majkinetor
; http://www.autohotkey.com/board/topic/49214-ahk-ahk-l-forms-framework-08/
; With parts and adjustments based on rbrtryn's ChooseColor function
; http://www.autohotkey.com/board/topic/91229-windows-color-picker-plus/
;###########################################################
Dlg_Color(ByRef Color, hGui := 0, ByRef Palette := "")
{ 
	static StructSize := VarSetCapacity(ChooseColor, 9 * A_PtrSize, 0)
	static CustomSize := VarSetCapacity(Custom, 64, 0)

	clr := ColorBGR(Color)
    Loop, Parse, Palette, `,, %A_Space%
		NumPut(ColorBGR(A_LoopField), Custom, (A_Index - 1) * 4, "UInt")

	VarSetCapacity(ChooseColor, StructSize, 0)
,	NumPut(StructSize, ChooseColor, 0, "UInt")
,	NumPut(hGui, ChooseColor, A_PtrSize, "UPtr")
,	NumPut(clr, ChooseColor, 3 * A_PtrSize, "UInt")
,	NumPut(&Custom, ChooseColor, 4 * A_PtrSize, "UPtr")
,	NumPut(0x00000103, ChooseColor, 5 * A_PtrSize, "UInt")

	nRC := DllCall("comdlg32\ChooseColor", "UPtr", &ChooseColor, "UInt")
	ann := ErrorLevel
	
	oldFormat := A_FormatInteger 
	SetFormat, Integer, Hex
	
	Palette := ""
	Loop, 16
		Palette .= ColorRGB(NumGet(Custom, (A_Index - 1) * 4, "UInt")) ","
	
	If (ann != 0) || (nRC = 0) 
		return false 

	clr := NumGet(ChooseColor, 3 * A_PtrSize) 

	Color := ColorRGB(clr)
	StringTrimLeft, Color, Color, 2 
	Loop, % 6-strlen(Color) 
		Color := 0 Color
	Color := "0x" Color
	SetFormat, Integer, %oldFormat% 
	return true
}

ColorBGR(Color)
{
	return ((Color & 0xFF) << 16) + (Color & 0xFF00) + ((Color >> 16) & 0xFF)
}

ColorRGB(Color)
{
	return (Color & 0xff00) + ((Color & 0xff0000) >> 16) + ((Color & 0xff) << 16)
}