;##################################################
; Author: tkoi <http://www.autohotkey.net/~tkoi>
; Modified by: majkinetor
; www.autohotkey.com/community/viewtopic.php?f=2&t=40468
; Additional thanks to just me for adapting it to AHK_L 64bit
;##################################################
ILButton(HBtn, Images, Cx=16, Cy=16, Align="center", Margin="1 1 1 1") {
	static BCM_SETIMAGELIST=0x1602, a_right=1, a_top=2, a_bottom=3, a_center=4

	if Images is not integer
	{
		hIL := DllCall("ImageList_Create", "Int", Cx, "Int",Cy, "UInt", 0x20, "Int", 1, "Int", 6, "UPtr")
		Loop, Parse, Images, |, %A_Space%%A_Tab%
		{
			if (A_LoopField = "") {
				DllCall("ImageList_AddIcon", "Ptr", hIL, "Ptr", I)
				continue
			}
			if (k := InStr(A_LoopField, ":", 0, 0)) && ( k!=2 )
				 v1 := SubStr(A_LoopField, 1, k-1), v2 := SubStr(A_LoopField, k+1)
			else v1 := A_LoopField, v2 := 0

			ifEqual, v1,,SetEnv,v1, %prevFileName%
			else prevFileName := v1

			DllCall("PrivateExtractIcons", "Str", v1, "Int", v2, "Int", Cx, "Int", Cy, "PtrP", hIcon, "UInt", 0, "UInt", 1, "UInt", 0x20) ; LR_LOADTRANSPARENT = 0x20
			DllCall("ImageList_AddIcon", "Ptr", hIL, "Ptr", hIcon)
			ifEqual, A_Index, 1, SetEnv, I, %hIcon%
			else DllCall("DestroyIcon", "Ptr", hIcon)
		}
		DllCall("DestroyIcon", "Ptr", I)
	} else hIL := Images

	VarSetCapacity(BIL, A_PtrSize + (5 * 4) + (A_PtrSize - 4), 0), NumPut(hIL, BIL), NumPut(a_%Align%, BIL, A_PtrSize + (4 * 4), "UInt")
	Loop, Parse, Margin, %A_Space%
		NumPut(A_LoopField, BIL, A_PtrSize + ((A_Index - 1) * 4), "Int")

	SendMessage, BCM_SETIMAGELIST,,&BIL,, ahk_id %HBtn%
	ifEqual, ErrorLevel, 0, return 0, DllCall("ImageList_Destroy", "Ptr", hIL)

	sleep 1 ; workaround for a redrawing problem on WinXP
	return hIL
}
