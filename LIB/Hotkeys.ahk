#If ListFocus && !HotkeyCtrlHasFocus()
&& WinActive("ahk_id" PMCWinID) && !Capt

Delete::GoSub, h_Del
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
+WheelUp::
^[::
GoSub, MoveSelUp
return
+WheelDown::
^]::
GoSub, MoveSelDn
return

^c::GoSub, CopyRows
^x::GoSub, CutRows
^v::GoSub, PasteRows
^d::GoSub, Duplicate
Insert::GoSub, ApplyL
^Insert::GoSub, InsertKey
^a::GoSub, SelectAll
^+a::GoSub, SelectNone
^!a::GoSub, InvertSel
^q::GoSub, CheckSel
^+q::GoSub, UnCheckSel
^!q::GoSub, InvertCheck
^z::GoSub, Undo
^y::GoSub, Redo
^l::GoSub, EditComm
^m::GoSub, EditColor
+1::
+2::
+3::
+4::
+5::
+6::
+7::
+8::
+9::
+0::
RowSelection := LV_GetCount("Selected"), OwnerID := PMCWinID
If (RowSelection = 1)
{
	RowNumber := LV_GetNext()
	LV_GetText(rColor, RowNumber, 10)
}
clr := SubStr(A_ThisHotkey, 2)
If (clr = 0)
	clr := 10
StringSplit, Palette, CustomColors, `,, %A_Space%
rColor := Palette%clr%
GoSub, PaintRows
return

#If !HotkeyCtrlHasFocus() && WinActive("ahk_id" PMCWinID)

^f::GoSub, FindReplace
^+f::GoSub, CmdFind
^u::GoSub, FilterSelect
^n::GoSub, New
^o::GoSub, Open
^s::GoSub, Save
^+s::GoSub, SaveAs
^!s::GoSub, SaveCurrentList
^i::GoSub, Import
^+d::GoSub, DuplicateList
^+m::GoSub, EditMacros
^+u::GoSub, UserFunction
^+p::GoSub, FuncParameter
^+n::GoSub, FuncReturn
^+c::GoSub, ConvertToFunc
^e::GoSub, Export
^p::GoSub, Preview
^+e::GoSub, EditScript
^g::GoSub, Options
^r::GoSub, Record
^+t::GoSub, RunTimer
^!d::GoSub, ResetHotkeys
^+g::GoSub, GroupsMode
^+y::GoSub, AddGroup
^+r::GoSub, RemoveGroup
^!t::GoSub, Scheduler
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
If (mSel = 0)
	mSel := 10
GuiControl, chMacro:Choose, A_List, %mSel%
GoSub, TabSel
return

#If !HotkeyCtrlHasFocus() && !ControlXHasFocus() && WinActive("ahk_id" PMCWinID) && !Capt

+F1::GoSub, HelpAbout
F2::GoSub, Mouse
F3::GoSub, Text
F4::GoSub, ControlCmd
F5::GoSub, Sleep
+F5::GoSub, MsgBox
^F5::GoSub, KeyWait
F6::GoSub, Window
F7::GoSub, Image
F8::GoSub, Run
F9::GoSub, ComLoop
+F9::GoSub, ComGoto
^F9::GoSub, TimedLabel
F10::GoSub, IfSt
+F10::GoSub, AsVar
^F10::GoSub, AsFunc
F11::GoSub, Email
+F11::GoSub, DownloadFiles
^F11::GoSub, ZipFiles
F12::GoSub, IECom
+F12::GoSub, ComInt
^F12::GoSub, SendMsg
~Enter::GoSub, EditButton

#If ControlXHasFocus() && WinActive("ahk_id" PMCWinID)

~Enter::GoSub, GoToFind

#If WinActive("ahk_id " LVEditMacros) && !InEdit

Enter::GoSub, MacroListEdit

#If !HotkeyCtrlHasFocus() && WinActive("ahk_id " LVEdit)

^PgDn::
EditSel := 1
GoSub, SelList
return
^PgUp::
EditSel := 0
GoSub, SelList
return

#If !HotkeyCtrlHasFocus() && WinActive("ahk_id " ExLVEdit)

^PgDn::
ExpSel := 1
GoSub, ExpSelList
return
^PgUp::
ExpSel := 0
GoSub, ExpSelList
return

#If WinActive("ahk_id " PrevID)

F5::GoSub, PrevRefresh

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
*Enter::GoSub, Restore

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

Up::GoSub, PrevResult
Down::GoSub, NextResult
Enter::GoSub, GoResult

#If WinActive("ahk_id " CmdWin)

^Tab::
^+Tab::
^PgUp::
^PgDn::
^+PgUp::
^+PgDn::
return

#If (WinActive("ahk_id " CmdWin) && (ControlXHasFocus()))

Enter::
PgDn::
GoSub, GoNextLine
return

PgUp::
GoSub, GoPrevLine
return



