;##################################################
; Author: tkoi <http://www.autohotkey.net/~tkoi>
; Modified by: majkinetor
; Modified by: Pulover
; www.autohotkey.com/community/viewtopic.php?f=2&t=40468
; Additional thanks to just me for adapting it to AHK_L 64bit
;##################################################
ILButton(HBtn, Images, Large := 0, Align := "center", Margin := "1 1 1 1") {
	static BCM_SETIMAGELIST=0x1602, a_right=1, a_top=2, a_bottom=3, a_center=4

	if Images is not integer
	{
		hIL := IL_Create(1, 2, Large)
		Loop, Parse, Images, |, %A_Space%%A_Tab%
		{
			if (A_LoopField = "") {
				IL_Add(hIL, v1, v2)
				continue
			}
			if (k := InStr(A_LoopField, ":", 0, 0)) && ( k!=2 )
				 v1 := SubStr(A_LoopField, 1, k-1), v2 := SubStr(A_LoopField, k+1)
			else v1 := A_LoopField, v2 := 0

			IL_Add(hIL, v1, v2)
		}
	} else hIL := Images

	VarSetCapacity(BIL, A_PtrSize + (5 * 4) + (A_PtrSize - 4), 0), NumPut(hIL, BIL), NumPut(a_%Align%, BIL, A_PtrSize + (4 * 4), "UInt")
	Loop, Parse, Margin, %A_Space%
		NumPut(A_LoopField, BIL, A_PtrSize + ((A_Index - 1) * 4), "Int")

	SendMessage, BCM_SETIMAGELIST,,&BIL,, ahk_id %HBtn%
	ifEqual, ErrorLevel, 0, return 0, DllCall("ImageList_Destroy", "Ptr", hIL)
	return hIL
}
