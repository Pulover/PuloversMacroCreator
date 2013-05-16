;###########################################################
; Original by diebagger (Guest) from:
; http://de.autohotkey.com/forum/viewtopic.php?p=58526#58526
; Slightly Modified by Obi-Wahn
; http://autohotkey.com/forum/topic60898.html
;###########################################################

LV_MoveRow(moveup = true)
{
	If moveup not in 1,0
		Return
	while x := LV_GetNext(x)
		i := A_Index, i%i% := x
	If (!i) || ((i1 < 2) && moveup) || ((i%i% = LV_GetCount()) && !moveup)
		Return
	cc := LV_GetCount("Col"), fr := LV_GetNext(0, "Focused"), d := moveup ? -1 : 1
	Loop, %i%
	{
		r := moveup ? A_Index : i - A_Index + 1, ro := i%r%, rn := ro + d
		Loop, %cc%
		{
			LV_GetText(to, ro, A_Index), LV_GetText(tn, rn, A_Index)
			LV_Modify(rn, "Col" A_Index, to), LV_Modify(ro, "Col" A_Index, tn)
			ckn := (LV_GetNext(rn-1, "Checked")=rn) ? 1 : 0
			cko := (LV_GetNext(ro-1, "Checked")=ro) ? 1 : 0
		}
		LV_Modify(ro, "-select -focus"), LV_Modify(rn, "select vis")
		LV_Modify(rn, "Check" cko), LV_Modify(ro, "Check" ckn)
		If (ro = fr)
			LV_Modify(rn, "Focus")
	}
}
