#If ListFocus && !HotkeyCtrlHasFocus()
&& HKOff = 0 && WinActive("ahk_id" PMCWinID) && Capt = 0

Del::GoSub, h_Del
NumpadDel::GoSub, h_Numdel
MButton & WheelUp::
^WheelUp::
^PgUp::
^+Up::
GoSub, MoveUp
return
MButton & WheelDown::
^WheelDown::
^PgDn::
^+Down::
GoSub, MoveDn
return

#If !HotkeyCtrlHasFocus() && WinActive("ahk_id" PMCWinID) && HKOff = 0

^c::GoSub, CopyRows
^x::GoSub, CutRows
^v::GoSub, PasteRows
^d::GoSub, Duplicate
Insert::GoSub, ApplyL
^a::GoSub, SelectAll
^+a::GoSub, SelectNone
^!a::GoSub, InvertSel
^q::GoSub, CheckSel
^+q::GoSub, UnCheckSel
^!q::GoSub, InvertCheck
^z::GoSub, Undo
^y::GoSub, Redo
^f::GoSub, FindReplace
^l::GoSub, EditComm
^n::GoSub, New
^o::GoSub, Open
^s::GoSub, Save
^+s::GoSub, SaveAs
^!s::GoSub, SaveCurrentList
^i::GoSub, Import
^+d::GoSub, DuplicateList
^e::GoSub, Export
^p::GoSub, Preview
^g::GoSub, Options
^r::GoSub, Record
^+t::GoSub, RunTimer
^t::GoSub, TabPlus
^w::GoSub, TabClose
^h::GoSub, SetWin
^b::GoSub, OnScControls
^Enter::GoSub, PlayStart
^+Enter::GoSub, TestRun
!1::GoSub, PlayFrom
!2::GoSub, PlayTo
!3::GoSub, PlaySel
!F3::GoSub, ListVars
!F5::GoSub, SetColSizes
!F6::GoSub, DefaultHotkeys
!F7::GoSub, LoadDefaults
^1::
^2::
^3::
^4::
^5::
^6::
^7::
^8::
^9::
^0::
mSel := SubStr(A_ThisHotkey, 2)
If mSel = 0
	mSel = 10
GuiControl, Choose, A_List, %mSel%
GoSub, TabSel
return

#If !HotkeyCtrlHasFocus() && WinActive("ahk_id" PMCWinID)
&& Capt = 0 && HKOff = 0

+F1::GoSub, HelpAbout
F2::GoSub, Mouse
F3::GoSub, Text
+F3::GoSub, Special
F4::GoSub, ControlCmd
F5::GoSub, Pause
+F5::GoSub, MsgBox
^F5::GoSub, KeyWait
F6::GoSub, Window
F7::GoSub, Image
F8::GoSub, Run
F9::GoSub, ComLoop
+F9::GoSub, AddLabel
^F9::GoSub, ComGoto
F10::GoSub, IfSt
+F10::GoSub, AsVar
^F10::GoSub, AsFunc
F11::GoSub, IECom
+F11::GoSub, ComInt
^F11::GoSub, RunScrLet
F12::GoSub, SendMsg

#If WinActive("ahk_id " PrevID) && HKOff = 0

F5::GoSub, PrevRefresh

#If ActiveGui(WinExist("A"))=8

^o::GoSub, OpenT
^s::GoSub, SaveT

#If Draw && DrawButton = "RButton"
RButton::GoSub, DrawStart
; RButton Up::GoSub, DrawEnd

#If Draw && DrawButton = "LButton"
LButton::GoSub, DrawStart
; LButton Up::GoSub, DrawEnd

#If Draw && DrawButton = "MButton"
MButton::GoSub, DrawStart
; MButton Up::GoSub, DrawEnd

#If Draw && OnEnter
Enter::GoSub, Restore

#If NoKey
RButton::
; RButton Up::
return

#If NoKey

Esc::
StopIt := 1
return

#If Draw

^Up::
^NumpadUp::
MoveRectangle("y", 0, LineW)
iX := "", iY := ""
GoSub, ShowAreaTip
return

+Up::
+NumpadUp::
MoveRectangle("h", 0, LineW)
iX := "", iY := ""
GoSub, ShowAreaTip
return

^Down::
^NumpadDown::
MoveRectangle("y", 1, LineW)
iX := "", iY := ""
GoSub, ShowAreaTip
return

+Down::
+NumpadDown::
MoveRectangle("h", 1, LineW)
iX := "", iY := ""
GoSub, ShowAreaTip
return

^Left::
^NumpadLeft::
MoveRectangle("x", 0, LineW)
iX := "", iY := ""
GoSub, ShowAreaTip
return

+Left::
+NumpadLeft::
MoveRectangle("w", 0, LineW)
iX := "", iY := ""
GoSub, ShowAreaTip
return

^Right::
^NumpadRight::
MoveRectangle("x", 1, LineW)
iX := "", iY := ""
GoSub, ShowAreaTip
return

+Right::
+NumpadRight::
MoveRectangle("w", 1, LineW)
iX := "", iY := ""
GoSub, ShowAreaTip
return

Esc::
Gui, 20:Cancel
SetTimer, WatchCursor, Off
Draw := 0
WinActivate, ahk_id %CmdWin%
Exit

#If WinActive("ahk_id " StartTipID)

Left::GoSub, PrevTip
Right::GoSub, NextTip
Esc::GoSub, TipClose3

#If

