;###########################################################
; Original by just me
; http://autohotkey.com/community/viewtopic.php?t=80984
;###########################################################
GuiCtrlAddTab(HWND, Name) {
   Static TCM_GETITEMCOUNT := 0x1304
   Static TCM_INSERTITEMA  := 0x1307
   Static TCM_INSERTITEMW  := 0x133E
   Static TCM_INSERTITEM := A_IsUnicode ? TCM_INSERTITEMW : TCM_INSERTITEMA
   Static TCITEMSize := (5 * 4) + (2 * A_PtrSize) + (A_PtrSize - 4)
   Static TCIF_TEXT := 0x0001
   Static TEXTPos := (3 * 4) + (A_PtrSize - 4)
   SendMessage, TCM_GETITEMCOUNT, 0, 0, , % "ahk_id " . HWND
   ItemCount := ErrorLevel
   VarSetCapacity(TCITEM, TCITEMSize, 0)
   NumPut(TCIF_TEXT, TCITEM, 0, "UInt")
   NumPut(&Name, TCITEM, TEXTPos, "Ptr")
   SendMessage, TCM_INSERTITEM, ItemCount, &TCITEM, , % "ahk_id " . HWND
   Return ErrorLevel
}

