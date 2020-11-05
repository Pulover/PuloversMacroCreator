LV_GetTexts(Index, ByRef Act := "", ByRef Det := "", ByRef Tim := "", ByRef Del := "", ByRef Typ := "", ByRef Tar := "", ByRef Win := "", ByRef Com := "", ByRef Col := "", ByRef Cod := "")
{
	LV_GetText(Act, Index, 2)
	LV_GetText(Det, Index, 3)
	LV_GetText(Tim, Index, 4)
	LV_GetText(Del, Index, 5)
	LV_GetText(Typ, Index, 6)
	LV_GetText(Tar, Index, 7)
	LV_GetText(Win, Index, 8)
	LV_GetText(Com, Index, 9)
	LV_GetText(Col, Index, 10)
	LV_GetText(Cod, Index, 11)
	Act := LTrim(Act)
}

Data_GetTexts(Data, Index, ByRef Act := "", ByRef Det := "", ByRef Tim := "", ByRef Del := "", ByRef Typ := "", ByRef Tar := "", ByRef Win := "", ByRef Com := "", ByRef Col := "")
{
	Act := Data[Index, 3]
	Det := Data[Index, 4]
	Tim := Data[Index, 5]
	Del := Data[Index, 6]
	Typ := Data[Index, 7]
	Tar := Data[Index, 8]
	Win := Data[Index, 9]
	Com := Data[Index, 10]
	Col := Data[Index, 11]
	Act := LTrim(Act)
}

LV_GetSelCheck()
{
	Critical
	SelectedRows := {Checked: [], Selected: []}, RowNumber := 0
	Loop, % LV_GetCount()
	{
		IsChecked := LV_GetNext(A_Index-1, "Checked")
		If (IsChecked != A_Index)
			SelectedRows.Checked.Push(0)
		Else
			SelectedRows.Checked.Push(1)
	}
	Loop, % LV_GetCount()
	{
		IsSelected := LV_GetNext(A_Index-1)
		If (IsSelected != A_Index)
			SelectedRows.Selected.Push(0)
		Else
		{
			SelectedRows.Selected.Push(1)
			If (!SelectedRows.FirstSel)
				SelectedRows.FirstSel := A_Index
		}
	}
	Critical, Off
	return SelectedRows
}

GetRealLineFeeds(String)
{
	_Elements := {}
	While (RegExMatch(String, "\[([^\[\]]++|(?R))*\]", _Bracket%A_Index%))
		_Elements["&_Bracket" A_Index "_&"] := _Bracket%A_Index%
	,	String := RegExReplace(String, "\[([^\[\]]++|(?R))*\]", "&_Bracket" A_Index "_&", "", 1)
	While (RegExMatch(String, "\{[^\{\}]++\}", _Brace%A_Index%))
		_Elements["&_Brace" A_Index "_&"] := _Brace%A_Index%
	,	String := RegExReplace(String, "\{[^\{\}]++\}", "&_Brace" A_Index "_&", "", 1)
	While (RegExMatch(String, "\(([^()]++|(?R))*\)", _Parent%A_Index%))
		_Elements["&_Parent" A_Index "_&"] := _Parent%A_Index%
	,	String := RegExReplace(String, "\(([^()]++|(?R))*\)", "&_Parent" A_Index "_&", "", 1)
	While (RegExMatch(String, "sU)"".*""", _String%A_Index%))
		_Elements["&_String" A_Index "_&"] := _String%A_Index%
	,	String := RegExReplace(String, "sU)"".*""", "&_String" A_Index "_&", "", 1)
	String := StrReplace(String, "``n", "`n")
	While (RegExMatch(String, "&_\w+_&", pd))
		String := StrReplace(String, pd, _Elements[pd])
	return String
}

AssignReplace(String, ByRef VarName, ByRef Oper, ByRef VarValue)
{
	RegExMatch(String, "(.*?)\s+(:=|\+=|-=|\*=|/=|//=|\.=|\|=|&=|\^=|>>=|<<=)\s+(.*)", Out)
,	VarName := Trim(Out1), Oper := Out2, VarValue := Trim(Out3)
}

SetUserWords(Functions)
{
	global
	sciPrev.SetKeywords(0x7, Functions)
,	sciPrevF.SetKeywords(0x7, Functions)
}

ShowTooltip()
{
	static CurrControl, PrevControl, _TT, TT_A
	
	CurrControl := A_GuiControl
	If (!CurrControl)
		return
	If (CurrControl != PrevControl && !RegExMatch(CurrControl, "\W"))
	{
		TT_A := WinExist("A")
		ToolTip
		SetTimer, DisplayToolTip, -500
		PrevControl := CurrControl
	}
	return

	DisplayToolTip:
	If (TT_A != WinExist("A"))
		return
	Try
		ToolTip, % %CurrControl%_TT
	Catch
		return
	SetTimer, RemoveToolTip, -3000
	return
}

ReplaceCursor(hControl, hCursor)
{
	If (A_PtrSize = 8)
		DllCall("SetClassLongPtr", "Ptr", hControl, "int", -12, "Ptr", hCursor)
	Else
		DllCall("SetClassLong", "Uint", hControl, "int", -12, "int", hCursor)
}

SBShowTip(Command)
{
	global Cmd_Tips
	
	SB_SetText(Cmd_Tips[Command])
	return Cmd_Tips[Command]
}

Find_Command(SearchWord, TrueMatch := false)
{
	local Results, SearchIn, Search
	
	Results := []
	Loop, Parse, KeywordsList, |
	{
		SearchIn := A_LoopField
		Loop, Parse, %A_LoopField%_Keywords, `,
		{
			If (SearchIn = "Type")
				Search := "Type" A_Index
			Else
				Search := SearchIn
			If (TrueMatch)
			{
				If (A_LoopField = SearchWord)
					Results.Push({Cmd: A_LoopField, Path: %Search%_Path})
			}
			Else
			{
				If (InStr(A_LoopField, SearchWord))
					Results.Push({Cmd: A_LoopField, Path: %Search%_Path})
				Else Try
				{
					If (InStr(%A_LoopField%_Desc, SearchWord))
						Results.Push({Cmd: A_LoopField, Path: %Search%_Path})
				}
			}
		}
	}
	return Results
}

RebarLock(rbPtr, Lock := true)
{
	Loop, % rbPtr.GetBandCount()
		rbPtr.ModifyBand(A_Index, "Style", "NoGripper", Lock)
}

CloseTab()
{
	global
	
	MouseGetPos,,,, cHwnd, 2
	If (cHwnd = TabSel)
	{
		If (ClickedTab := TabGet())
			GoSub, TabClose
		ClickedTab := ""
	}
}

DragTab()
{
	global

	If (Record || Capt)
		return
		
	Critical
	CoordMode, Mouse, Window
	If (A_Gui = 28)
		PostMessage, 0xA1, 2,,, ahk_id %PMCOSC%
	Else If (A_Gui = "chMacro")
	{
		Gui, chMacro:Default
		MouseGetPos, HitX, HitY,, cHwnd, 2
		If (cHwnd = TabSel)
		{
			GuiControl, chMacro:Choose, A_List, % TabGet()
			GoSub, TabSel
			NewOrder := TabDrag()
			If (IsObject(NewOrder))
			{
				MoveTabs(NewOrder)
				SetTimer, HitFix, -10
			}
			Else
				SetTimer, SetListFocus, -10
		}
	}
	Critical, Off
}

MoveTabs(NewOrder)
{
	local Proj_Opts := []
	
	ActiveList := A_List
	For each, Index in NewOrder.Order
		Proj_Opts.Push({Auto: o_AutoKey[Index], Man: o_ManKey[Index], ID: ListID%Index%
						, Times: o_TimesG[Index], Context: o_MacroContext[Index], Hist: LVManager[Index].GetData()})
	For each, Index in NewOrder.Order
	{
		o_AutoKey[A_Index] := Proj_Opts[A_Index].Auto
		o_ManKey[A_Index] := Proj_Opts[A_Index].Man
		o_TimesG[A_Index] := Proj_Opts[A_Index].Times
		o_MacroContext[A_Index] := Proj_Opts[A_Index].Context
		If (Index = ActiveList)
			NewActive := A_Index
	}
	ActiveList := NewActive
	GpConfig := ShowGroups, ShowGroups := false
	Loop, %TabCount%
		GuiControl, chMacro:-g, InputList%A_Index%
	Loop, %TabCount%
		If (Proj_Opts[A_Index].ID != ListID%A_Index%)
			LVManager[A_Index].SetData(, Proj_Opts[A_Index].Hist)
	Loop, %TabCount%
		GuiControl, chMacro:+gInputList, InputList%A_Index%
	GuiControl, chMacro:, A_List, |
	CopyMenuLabels := StrSplit(Trim(NewOrder.Tabs, "|"), "|")
	GuiControl, chMacro:, A_List, % NewOrder.Tabs
	Loop, %TabCount%
	{
		Gui, chMacro:ListView, InputList%A_Index%
		A_List := A_Index
		GoSub, RowCheck
		GoSub, b_Enable
	}
	GuiControl, chMacro:Choose, A_List, %ActiveList%
	Gui, chMacro:Submit, NoHide
	ShowGroups := GpConfig
	GoSub, chMacroGuiSize
	GoSub, LoadData
	GoSub, UpdateCopyTo
	Proj_Opts := ""
	SavePrompt(true, A_ThisFunc)
}

HitFix:
ControlClick,, ahk_id %cHwnd%,,,, x%HitX% y%HitY% NA
SetListFocus:
GuiControl, chMacro:Focus, InputList%A_List%
return

CompareParse(String, ByRef VarName, ByRef Oper, ByRef VarValue)
{
	String := RegExReplace(String, "^(\w+\s+)not in ", "$1!@ ",, 1)
,	String := RegExReplace(String, "^(\w+\s+)not contains ", "$1!& ",, 1)
,	String := RegExReplace(String, "^(\w+\s+)not between ", "$1!| ",, 1)
,	String := RegExReplace(String, "^(\w+\s+)is not ", "$1!* ",, 1)
,	String := RegExReplace(String, "^(\w+\s+)in ", "$1@ ",, 1)
,	String := RegExReplace(String, "^(\w+\s+)contains ", "$1& ",, 1)
,	String := RegExReplace(String, "^(\w+\s+)between ", "$1| ",, 1)
,	String := RegExReplace(String, "^(\w+\s+)is ", "$1* ",, 1)
,	RegExMatch(String, "^(\w+)\s+([!=<>\|&@\*]{1,2})\s+(.*)", Out)
,   VarName := Out1, Oper := Out2, VarValue := Out3
,	Oper := RegExReplace(Oper, "!@", "not in")
,	Oper := RegExReplace(Oper, "!&", "not contains")
,	Oper := RegExReplace(Oper, "!\|", "not between")
,	Oper := RegExReplace(Oper, "!\*", "is not")
,	Oper := RegExReplace(Oper, "@", "in")
,	Oper := RegExReplace(Oper, "&", "contains")
,	Oper := RegExReplace(Oper, "\|", "between")
,	Oper := RegExReplace(Oper, "\*", "is")
}

ShowContextHelp()
{
	local Pag,Title
	
	MouseGetPos,,,, Control
	If (InStr(Control, "Edit"))
		return
	If (ContHelp.HasKey(A_Gui))
	{
		GuiControlGet, Pag,, TabControl
		Title := ContHelp[A_Gui][Pag ? Pag : 1]
		Menu, %Title%, Show
		return
	}
	Else If (A_Gui = 28)
	{
		Menu, ToolbarMenu, Show
		return
	}
}

CmdHelp()
{
	local Gui,Pag,Title

	If (HotkeyCtrlHasFocus())
		return
	Gui := ActiveGui(WinActive("A"))
	If (Gui = 0)
		return
	Gui, %Gui%:Submit, NoHide
	If (Gui = 19)
		Pag := (PixelS) ? 2 : 1
	Else If (Gui = 12)
	{
		GuiControlGet, Pag,, TabControl
		If (Pag = 1)
		{
			If (LFilePattern)
				Pag := 5
			Else If (LParse)
				Pag := 6
			Else If (LRead)
				Pag := 7
			Else If (LRegistry)
				Pag := 8
			Else If (LWhile)
				Pag := 9
			Else If (LFor)
				Pag := 10
		}
		Else If (Pag = 2)
		{
			If (NewLabelT)
				Pag := 4
		}
	}
	Else
		GuiControlGet, Pag,, TabControl
	Title := ContHTitle[Gui][Pag ? Pag : 1]
	If (!Title)
		If ((WinActive("A") != StartTipID) && (WinActive("A") != CmdWin))
			Title := "index.html"
	ShortLang := RegExReplace(Lang, "_.*")
	IfExist, %A_ScriptDir%\MacroCreator_Help_%Lang%.chm
		Run, hh.exe mk:@MSITStore:%A_ScriptDir%\MacroCreator_Help_%Lang%.chm::/%Title%
	Else IfExist, %A_ScriptDir%\MacroCreator_Help_%ShortLang%.chm
		Run, hh.exe mk:@MSITStore:%A_ScriptDir%\MacroCreator_Help_%ShortLang%.chm::/%Title%
	Else IfExist, %A_ScriptDir%\MacroCreator_Help.chm
		Run, hh.exe mk:@MSITStore:%A_ScriptDir%\MacroCreator_Help.chm::/%Title%
	Else
		Run, https://www.macrocreator.com/docs/%Title%
	return 0
}

PicGetSize(File, ByRef Width, ByRef Height)
{
	static LoadedPic
	LastEL := ErrorLevel
	Gui, Pict:Add, Pic, vLoadedPic, %File%
	GuiControlGet, LoadedPic, Pict:Pos
	Gui, Pict:Destroy
	Width := LoadedPicW, Height := LoadedPicH
	ErrorLevel := LastEL
}

CenterImgSrchCoords(File, ByRef CoordX, ByRef CoordY)
{
	static LoadedPic
	LastEL := ErrorLevel
	
	Gui, Pict:Add, Pic, vLoadedPic, % RegExReplace(File, "^(\*\w+\s)+")
	GuiControlGet, LoadedPic, Pict:Pos
	Gui, Pict:Destroy
	CoordX += LoadedPicW // 2
	CoordY += LoadedPicH // 2
	ErrorLevel := LastEL
}

ActiveGui(Hwnd)
{
	Loop, 99
	{
		Gui %A_Index%:+LastFoundExist
		If (Hwnd = WinExist())
			return A_Index
	}
	return 0
}

GuiGetSize(ByRef W, ByRef H, GuiID := 1)
{
	DetectHiddenWindows, On
	Gui %GuiID%:+LastFoundExist
	IfWinExist
	{
		VarSetCapacity(rect, 16, 0)
	,	DllCall("GetClientRect", "uint", MyGuiHWND := WinExist(), "uint", &rect)
	,	W := Floor(NumGet(rect, 8, "int") / Round(A_ScreenDPI / 96, 2))
	,	H := Floor(NumGet(rect, 12, "int") / Round(A_ScreenDPI / 96, 2))
	}
	DetectHiddenWindows, Off
}

HotkeyCtrlHasFocus()
{
	global GuiA := ActiveGui(WinActive("A"))

	GuiControlGet, ctrl, %GuiA%:Focus
	If (InStr(ctrl,"hotkey"))
	{
		GuiControlGet, ctrl, %GuiA%:FocusV
		return ctrl
	}
}

ControlXHasFocus()
{
	global GuiA := ActiveGui(WinActive("A"))
	
	GuiControlGet, ctrl, %GuiA%:Focus
	If (InStr(ctrl,"edit"))
	{
		GuiControlGet, ctrl, %GuiA%:FocusV
		If (ctrl = "RowLang")
			return true
	}
	If (ctrl = "FindList")
		return true
	return false
}

SleepRandom(Delay := 0, Min := "", Max := "", Percent := "")
{
	If (Percent)
	{
		Min := Floor(Delay - (Delay * Percent / 100))
		Max := Floor(Delay + (Delay * Percent / 100))
	}
	Random, RandTime, % (Min < 0) ? 0 : Min, %Max%
	Sleep, %RandTime%
}

ClickRandom(Options, Offset, SendCmd := False)
{
	RegExMatch(Options, "(-?\d+),\s(-?\d+)", Coord)
	MinX := Coord1 - Offset, MaxX := Coord1 + Offset
	MinY := Coord2 - Offset, MaxY := Coord2 + Offset
	Random, RandCoordX, %MinX%, %MaxX%
	Random, RandCoordY, %MinY%, %MaxY%
	Options := RegExReplace(Options, "-?\d+,\s-?\d+", RandCoordX ", " RandCoordY)

	OutputDebug, %Options%
	If (SendCmd)
		SendEvent, %Options%
	Else
		Click, %Options%
}

EditCtrlHasFocus()
{
	global GuiA := ActiveGui(WinActive("A"))
	GuiControlGet, ctrl, %GuiA%:FocusV
	return ctrl
}

SCI_NOTIFY(wParam, lParam, msg, hwnd, sciObj)
{
	line := sciObj.LineFromPosition(sciObj.position)

	If (sciObj.scnCode = SCN_MARGINCLICK)
		sciObj.ToggleFold(line)
}

MarkArea(LineW)
{
	global c_Lang004, c_Lang059, d_Lang057
	
	MouseGetPos,,, id, control
	ControlGetPos, cX, cY, cW, cH, %control%, ahk_id %id%
	WinGetPos, wX, wY, wW, wH, ahk_id %id%
	If (control != "")
	{
		cX += wX, cY += wY
	,	X1 := cX, Y1 := cY
	,	W1 := cW, H1 := cH
	,	W2 := W1 - LineW, H2 := H1 - LineW
		Tooltip,
		(LTrim
		%c_Lang059%: %W1% x %H1%
		%c_Lang004%: %control%
		%d_Lang057%
		)
	}
	Else
	{
		WinGet, WMS, MinMax, A
		If (WMS = 1)
		{
			SysGet, MWA, MonitorWorkArea
			wX := MWALeft, wY := MWATop, wW := MWARight, wH := MWABottom
		}
		X1 := wX, Y1 := wY
	,	W1 := wW, H1 := wH
	,	W2 := W1 - LineW, H2 := H1 - LineW
		Tooltip,
		(LTrim
		%c_Lang059%: %W1% x %H1%
		%d_Lang057%
		)
	}
	CoordMode, Mouse, Screen
	Gui, 20:+LastFound
	WinSet, Region, 0-0 %W1%-0 %W1%-%H1% 0-%H1% 0-0  %LineW%-%LineW% %W2%-%LineW% %W2%-%H2% %LineW%-%H2% %LineW%-%LineW%
	Gui, 20:Show, NA x%X1% y%Y1% w%W1% h%H1%
	WinMove, , , X1, Y1, W1, H1
}

MoveRectangle(o, p, LineW)
{
	Gui, 20:+LastFound
	WinGetPos, wX, wY, wW, wH
	w%o% := (p) ? w%o%+1 : w%o%-1
,	X1 := wX, Y1 := wY
,	W1 := wW, H1 := wH
,	W2 := W1 - LineW, H2 := H1 - LineW
	WinSet, Region, 0-0 %W1%-0 %W1%-%H1% 0-%H1% 0-0  %LineW%-%LineW% %W2%-%LineW% %W2%-%H2% %LineW%-%H2% %LineW%-%LineW%
	WinMove,,, %wX%, %wY%, %wW%, %wH%
}

Screenshot(outfile, screen)
{
	Gdip_1 := "Gdip_Startup"
,	Gdip_2 := "Gdip_BitmapFromScreen"
,	Gdip_3 := "Gdip_SaveBitmapToFile"
,	Gdip_4 := "Gdip_DisposeImage"
,	Gdip_5 := "Gdip_Shutdown"

,	pToken := %Gdip_1%()

,	pBitmap := %Gdip_2%(screen)

,	%Gdip_3%(pBitmap, outfile, 100)
,	%Gdip_4%(pBitmap)
,	%Gdip_5%(pToken)
}

AdjustCoords(ByRef x1, ByRef y1, ByRef x2, ByRef y2)
{
	Xa := x2 < x1 ? x2 : x1
,	Xb := x1 > x2 ? x1 : x2
,	Ya := y2 < y1 ? y2 : y1
,	Yb := y1 > y2 ? y1 : y2
,	x1 := Xa, x2 := Xb, y1 := Ya, y2 := Yb
}

ReadFunctions(LibFile, Msg := "")
{
	IfNotExist, %LibFile%
		return "$"
	Pos := 1
	FileRead, Content, *t %LibFile%
	While (RegExMatch(Content, "OU)([\w\._]+)\(.*\)[\n\r\s]*?\{", Found, Pos))
	{
		Pos := Found.Pos(1) + Found.Len(1)
		If (Func(Found.Value(1)).IsBuiltIn)
			continue
		ExtList .= Found.Value(1) "$"
		Tooltip, %Msg%
	}
	Tooltip
	Sort, ExtList, D$ U
	return (ExtList != "") ? ExtList : "$"
}

ListIEWindows()
{
	List := "[blank]||"
	Try
	{
		For Pwb in ComObjCreate( "Shell.Application" ).Windows
			If (InStr(Pwb.FullName, "iexplore.exe"))
				Try List .= RegExReplace(Pwb.Document.Title, "\|", "§") "|"
	}
	return List
}

GuiAddLV(ident)
{
	global

	Critical
	Gui, chMacro:Default
	Gui, chMacro:Tab, %ident%
	Try Gui, chMacro:Add, ListView, x+0 y+0 AltSubmit Checked hwndListID%ident% vInputList%ident% gInputList NoSort LV0x10000 LV0x4000, %w_Lang030%|%w_Lang031%|%w_Lang032%|%w_Lang033%|%w_Lang034%|%w_Lang035%|%w_Lang036%|%w_Lang037%|%w_Lang038%|%w_Lang039%|%w_Lang040%
	LV_SetImageList(hIL_Icons)
	Loop, 11
		LV_ModifyCol(A_Index, Col_%A_Index%)
	LVOrder_Set(11, ColOrder, ListID%ident%)
	o_MacroContext[ident] := {"Condition": "None", "Context": ""}
	Critical, Off
}

SelectByType(SelType, Col := 6)
{
	SelType := Trim(SelType)
	LV_Modify(0, "-Select")
	If SelType in Win,File,String
	{
		Loop, % ListCount%A_List%
		{
			LV_GetText(Type, A_Index, Col)
			If (InStr(Trim(Type), SelType))
				LV_Modify(A_Index, "Select")
		}
	}
	Else
	{
		Loop, % ListCount%A_List%
		{
			LV_GetText(Type, A_Index, Col)
			If (Trim(Type) = SelType)
				LV_Modify(A_Index, "Select")
		}
	}
	LV_Modify(LV_GetNext(), "Vis")
}

SelectByFilter(Act, Det, Tim, Del, Typ, Tar, Win, Com, Col, Case)
{
	LV_Modify(0, "-Select"), Found := 0
	Loop, % ListCount%A_List%
	{
		LV_GetTexts(A_Index, A, B, C, D, E, F, G, H, I)
		If (InStr(A, Trim(Act), Case))
		&& (InStr(B, Trim(Det), Case))
		&& (InStr(C, Trim(Tim), Case))
		&& (InStr(D, Trim(Del), Case))
		&& (InStr(E, Trim(Typ), Case))
		&& (InStr(F, Trim(Tar), Case))
		&& (InStr(G, Trim(Win), Case))
		&& (InStr(H, Trim(Com), Case))
		&& (InStr(I, Trim(Col), Case))
		{
			LV_Modify(A_Index, "Select")
			Found++
		}
	}
	return Found
}

class IfCondition
{
	Expression(Expr)
	{
		return Eval(Expr)[1]
	}
	WinActive(Win)
	{
		return WinActive(Win)
	}
	WinNotActive(Win)
	{
		return !WinActive(Win)
	}
	WinExist(Win)
	{
		return WinExist(Win)
	}
	WinNotExist(Win)
	{
		return !WinExist(Win)
	}
	None(Win)
	{
		return 1
	}
}

ActivateHotkeys(Rec := "", Play := "", Speed := "", Stop := "", Pause := "", Joy := "")
{
	static LastFast, LastSlow, LastPause, LastAbort, LastRec, LatRecNew, LastPlay := {}
	local ActiveKeys
	
	If (Speed != "")
	{
		Try Hotkey, %LastFast%, FastKeyToggle, Off
		Try Hotkey, %LastSlow%, SlowKeyToggle, Off
		If (FastKey !=  "None")
			Hotkey, %FastKey%, FastKeyToggle, % (Speed) ? "On" : "Off"
		If (SlowKey !=  "None")
			Hotkey, %SlowKey%, SlowKeyToggle, % (Speed) ? "On" : "Off"
		LastFast := FastKey, LastSlow := SlowKey
	}
	
	If (Pause != "")
	{
		Try Hotkey, %LastPause%, f_PauseKey, Off
		Try Hotkey, %PauseKey%, f_PauseKey, Off
		If ((PauseKey != "") && (Pause = 1))
			Hotkey, %PauseKey%, f_PauseKey, On
		LastPause := PauseKey
	}
	
	If (Stop != "")
	{
		Try Hotkey, %LastRec%, RecStart, Off
		Try Hotkey, %LatRecNew%, RecStartNew, Off
		Try Hotkey, %LastAbort%, f_AbortKey, Off
		Try Hotkey, %AbortKey%, f_AbortKey, Off
		If ((AbortKey != "") && (Stop = 1))
			Hotkey, %AbortKey%, f_AbortKey, On
		LastAbort := AbortKey
	}
	
	If (Rec != "")
	{
		Try Hotkey, %LastRec%, RecStart, Off
		Try Hotkey, %LatRecNew%, RecStartNew, Off
		Try Hotkey, %RecKey%, RecStart, % (Rec) ? "On" : "Off"
		Try Hotkey, %RecNewKey%, RecStartNew, % (Rec) ? "On" : "Off"
		LastRec := RecKey, LatRecNew := RecNewKey
	}
	
	If (Play != "")
	{
		Loop, %TabCount%
		{
			If ((o_MacroContext[A_Index].Condition != "") && (o_MacroContext[A_Index].Condition != "None"))
			{
				o_HotkeyCondition := o_MacroContext[A_Index].Condition
				o_HotkeyContext := o_MacroContext[A_Index].Context
				#If !WinActive("ahk_id" PMCWinID) && IfCondition[o_HotkeyCondition](o_HotkeyContext)
				Hotkey, If, !WinActive("ahk_id" PMCWinID) && IfCondition[o_HotkeyCondition](o_HotkeyContext)
				Try Hotkey, % LastPlay.Auto[A_Index], f_AutoKey, Off
				Try Hotkey, % LastPlay.Man[A_Index], f_ManKey, Off
				If (!ListCount%A_Index%)
					continue
				If (InStr(CopyMenuLabels[A_Index], "()"))
					o_AutoKey[A_Index] := "", o_ManKey[A_Index] := ""
				If (RegExMatch(o_AutoKey[A_Index], "^:.*?:"))
				{
					Hotstring(o_AutoKey[A_Index], "f_AutoKey", (Play) ? "On" : "Off")
					LastPlay["Auto", A_Index] := o_AutoKey[A_Index]
					ActiveKeys++
				}
				Else If (o_AutoKey[A_Index] != "")
				{
					Hotkey, % o_AutoKey[A_Index], f_AutoKey, % (Play) ? "On" : "Off"
					LastPlay["Auto", A_Index] := o_AutoKey[A_Index]
					ActiveKeys++
				}
				If (o_ManKey[A_Index] != "")
				{
					Hotkey, % o_ManKey[A_Index], f_ManKey, % (Play) ? "On" : "Off"
					LastPlay["Man", A_Index] := o_ManKey[A_Index]
				}
				Hotkey, If
				#If
			}
			Else
			{
				#If !WinActive("ahk_id" PMCWinID) && IfCondition[IfDirectContext](IfDirectWindow)
				Hotkey, If, !WinActive("ahk_id" PMCWinID) && IfCondition[IfDirectContext](IfDirectWindow)
				Try Hotkey, % LastPlay.Auto[A_Index], f_AutoKey, Off
				Try Hotkey, % LastPlay.Man[A_Index], f_ManKey, Off
				If (!ListCount%A_Index%)
					continue
				If (InStr(CopyMenuLabels[A_Index], "()"))
					o_AutoKey[A_Index] := "", o_ManKey[A_Index] := ""
				If (RegExMatch(o_AutoKey[A_Index], "^:.*?:"))
				{
					Hotstring(o_AutoKey[A_Index], "f_AutoKey", (Play) ? "On" : "Off")
					LastPlay["Auto", A_Index] := o_AutoKey[A_Index]
					ActiveKeys++
				}
				Else If (o_AutoKey[A_Index] != "")
				{
					Hotkey, % o_AutoKey[A_Index], f_AutoKey, % (Play) ? "On" : "Off"
					LastPlay["Auto", A_Index] := o_AutoKey[A_Index]
					ActiveKeys++
				}
				If (o_ManKey[A_Index] != "")
				{
					Hotkey, % o_ManKey[A_Index], f_ManKey, % (Play) ? "On" : "Off"
					LastPlay["Man", A_Index] := o_ManKey[A_Index]
				}
				Hotkey, If
				#If
			}
		}
	}
	
	If (Joy != "")
	{
		Loop, 16
		{
			j := A_Index
			Loop, 32
			{
				#If EditCtrlHasFocus() = "JoyKey"
				Hotkey, If, EditCtrlHasFocus() = "JoyKey"
				Hotkey, %j%Joy%A_Index%, CaptureJoyB, % (Joy) ? "On" : "Off"
				Hotkey, If
				#If
			}
		}
	}
	
	return ActiveKeys
}

CheckDuplicateLabels()
{
	local Proj_Labels
	
	Gui, chMacro:Default
	Loop, %TabCount%
	{
		Gui, chMacro:ListView, InputList%A_Index%
		Loop, % ListCount%A_Index%
		{
			LV_GetText(Row_Type, A_Index, 6)
			If (Row_Type = cType35)
			{
				LV_GetText(Row_Label, A_Index, 3)
				Proj_Labels .= Row_Label "`n"
			}
		}
	}
	Loop, %TabCount%
		Proj_Labels .= CopyMenuLabels[A_Index] "`n"
	Sort, Proj_Labels, U
	return ErrorLevel
}

RemoveDuplicates(ByRef String)
{
	StringTrimRight, String, String, 1
	Loop, Parse, String, |
		NewStr .= (RegExMatch(NewStr, "\b" A_LoopField "\b\|") ? "Macro" A_Index : A_LoopField) "|"
	String := NewStr
}

CheckDuplicates(Obj1, Obj2, Obj3*)
{
	global TabCount
	Loop, 3
	{
		If (IsObject(Obj%A_Index%))
		{
			For Index, Obj in Obj%A_Index%
			{
				If ((Obj != "") && (Index <= TabCount))
					Keys .= Obj "`n"
			}
		}
		Else If (Obj%A_Index% != "")
			Keys .= Obj%A_Index% "`n"
	}
	Sort, Keys, U
	return ErrorLevel
}

GetElIndex(elwb, GetBy)
{
	If (GetBy = "ID")
		return ""

	If (GetBy = "Links")
	{
		ElId := elwb.InnerText
	,	Links := elwb.Document.Links
		Loop, % Links.Length
			If (Links[A_Index-1].InnerText = ElId)
				return A_Index-1
	}
	Else
	{
		El3 := elwb[GetBy]
	,	ElId := elwb.SourceIndex
		Loop, % elwb["document"]["getElementsBy" GetBy](El3).Length
		{
			If (elwb["document"]["getElementsBy" GetBy](El3)[A_Index-1].SourceIndex = ElId)
				return A_Index-1
		}
	}
}

EscCom(Reverse, ByRef Item1 := "", ByRef Item2 := "", ByRef Item3 := "", ByRef Item4 := "")
{
	If (Reverse)
	{
		Loop, 4
			If (IsByRef(Item%A_Index%))
				Item%A_Index% := StrReplace(Item%A_Index%, "``,", ",")
	}
	Else
	{
		Loop, 4
			If (IsByRef(Item%A_Index%))
				Item%A_Index% := StrReplace(Item%A_Index%, ",", "``,")
	}
}

HistCheck(ListID := "")
{
	global

	If (Record || Capt)
		return

	If (MaxHistory = 0)
		return
	If (ListID = "")
	{
		ListID := A_List
		LVManager[ListID].Add(HistData)
	}
	Else
		LVManager[ListID].Add()
	If (LVManager[ListID].Handle.Slot.Length() > MaxHistory+1)
		LVManager[ListID].Handle.Slot.RemoveAt(1)
	If (AutoRefresh = 1)
		GoSub, PrevRefresh
	SavePrompt(true, A_ThisFunc)
	return
}

WinCheck(wParam, lParam, Msg)
{
	global

	If (HaltCheck = 1)
		return
	Pause, Off
	SetTimer, WinCheck, -333
	WPHKC := wParam
}

ToggleIcon(Custom := "")
{
	global
	static IconFile, IconNumber, BarColor

	Color := (BarColor := !BarColor) ? "Red" : "20D000"
	ChangeProgBarColor(Color, "OSCProg", 28)
	If (Custom != "")
	{
		If (!Custom)
			IconFile := A_IconFile, IconNumber := A_IconNumber
		Menu, Tray, Icon, % (Custom = 0) ? ResDllPath : IconFile, % (Custom = 0) ? 55 : IconNumber
		return Custom
	}
	Else
	{
		If (!A_IsPaused)
			IconFile := A_IconFile, IconNumber := A_IconNumber
		Menu, Tray, Icon, % (A_IsPaused = 0) ? ResDllPath : IconFile, % (A_IsPaused = 0) ? 55 : IconNumber
		return A_IsPaused
	}
}

ToggleButtonIcon(Button, Icon)
{
	ILButton(Button, Icon[1] ":" Icon[2], 0)
}

ChangeProgBarColor(Color, Control, Gui := 1)
{
	GuiControl, %Gui%:+c%Color%, %Control%
}

ChangeIcon(hInst, ID, Icon)
{
	; hIcon := DllCall("LoadImage", "Uint", hInst, "Uint", Icon, "Uint", 1, "int", 96, "int", 96, "Uint", 0x8000)
	hIcon := IL_EX_GetHICON(hInst, Icon)
	
	SendMessage, 0x80, 0, hIcon,, ahk_id %ID% ;set the window's small icon (0x80 is WM_SETICON).
	; SendMessage, 0x80, 1, hIcon,, ahk_id %ID% ;set the window's big icon to the same one.
}

AHK_NOTIFYICON(wParam, lParam)
{
	global HaltCheck

	If (lParam = 0x205) ; WM_RBUTTONUP
	{
		HaltCheck := 1
		SetTimer, WaitMenuClose, 1
		return
	}
	Else If (lParam = 0x208) ; WM_MBUTTONUP
	{
		GoSub, f_PauseKey
		return 1
	}
}

Send_Params(ByRef String, ByRef Target)
{
	VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)
,	SizeInBytes := (StrLen(String) + 1) * (A_IsUnicode ? 2 : 1)
,	NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)
,	NumPut(&String, CopyDataStruct, 2*A_PtrSize)
	DetectHiddenWindows, On
	SendMessage, 0x4A, 0, &CopyDataStruct,, ahk_id %Target%
	return ErrorLevel
}

Receive_Params(wParam, lParam)
{
	global
	
	StringAddress := NumGet(lParam + 2*A_PtrSize)
,	CopyOfData := StrGet(StringAddress)
	Gui, 1:Default
	Gui, 1:+OwnDialogs
	Gui, 1:Submit, NoHide
	GoSub, SaveData
	If ((ListCount > 0) && (SavePrompt))
	{
		MsgBox, 35, %d_Lang005%, %d_Lang002%`n`"%CurrentFileName%`"
		IfMsgBox, Yes
		{
			GoSub, Save
			IfMsgBox, Cancel
				return
		}
		IfMsgBox, Cancel
			return
	}
	PMC.Import(CopyOfData)
	CurrentFileName := LoadedFileName
	GoSub, FileRead
	return
}

FreeMemory()
{
	return, DllCall("psapi.dll\EmptyWorkingSet", "UInt", -1)
}

GetPars(Param, KeepEscapes := false)
{
	static _w := Chr(2), _c := Chr(3)

	ExprOn := false, InExpr := []
,	Param := Trim(Param)
,	Param := StrReplace(Param, "``,", _c)
,	Param := RegExReplace(Param, "(?<=^)%\s+|(?<=,)\s*%\s+", _w)
,	r := [], i := 1
	
	Loop, Parse, Param
	{
		If (A_LoopField = _w)
		{
			ExprOn := true
		,	r[i] .= "% "
			continue
		}
		If (A_LoopField = _c)
		{
			r[i] .= KeepEscapes ? "``," : ","
			continue
		}
		If ((InExpr.Length()) && (A_LoopField = InExpr[InExpr.Length()]))
		{
			InExpr.Pop()
		,	r[i] .= A_LoopField
			continue
		}
		If ((ExprOn) && ((A_LoopField = """") || (A_LoopField = "(") || (A_LoopField = "[") || (A_LoopField = "{")))
		{
			InExpr.Push(A_LoopField = "(" ? ")" : A_LoopField = "[" ? "]" : A_LoopField = "{" ? "}" : """")
		,	r[i] .= A_LoopField
			continue
		}
		If ((A_LoopField = ",") && (InExpr.Length() = 0))
		{
			ExprOn := false, i++
			continue
		}
		r[i] .= A_LoopField
	}
	
	For k, v in r
		r[k] := Trim(v)
	
	return r
}

LV_ColorsMessage(wParam, lParam)
{
	static NM_CUSTOMDRAW := -12
	static LVN_COLUMNCLICK := -108

	Critical, 1000
	If (LV_Colors.HasKey(H := NumGet(lParam + 0, 0, "UPtr")))
	{
		M := NumGet(lParam + (A_PtrSize * 2), 0, "Int")
		; NM_CUSTOMDRAW --------------------------------------------------------------------------------------------------
		If (M = NM_CUSTOMDRAW)
			Return LV_Colors.On_NM_CUSTOMDRAW(H, lParam)
		; LVN_COLUMNCLICK ------------------------------------------------------------------------------------------------
		If (LV_Colors[H].NS && (M = LVN_COLUMNCLICK))
			Return 0
	}
	Critical, Off
}

ShowMenu(Menu, mX, mY)
{
	global

	Switch Menu
	{
		Case "Open":
			Menu, RecentMenu, Show, %mX%, %mY%
		Case "Save":
			Menu, TbMenu, Add, %f_Lang004%, SaveAs
			Menu, TbMenu, Icon, %f_Lang004%, %ResDllPath%, 86
			Menu, TbMenu, Show, %mX%, %mY%
			Menu, TbMenu, DeleteAll
		Case "PlayStart":
			GoSub, ShowPlayMenu
		Case "OnFinish":
			GoSub, OnFinish
		Case "RecStart":
			Menu, TbMenu, Add, %t_Lang020%, RecStartNew
			Menu, TbMenu, Show, %mX%, %mY%
			Menu, TbMenu, DeleteAll
		Case "ShowPlayMenu":
			GoSub, ShowPlayMenu
		Case "PrevRefreshButton":
			Menu, TbMenu, Add, %t_Lang015%, AutoRefresh
			If (AutoRefresh)
				Menu, TbMenu, Check, %t_Lang015%
			Menu, TbMenu, Show, %mX%, %mY%
			Menu, TbMenu, DeleteAll
		Case "GoToLine":
			Menu, TbMenu, Add, %t_Lang219%, AutoSelectLine
			If (AutoSelectLine)
				Menu, TbMenu, Check, %t_Lang219%
			Menu, TbMenu, Show, %mX%, %mY%
			Menu, TbMenu, DeleteAll
		Case "TabIndent":
			Menu, TbMenu, Add, %t_Lang211%, IndentWith, Radio
			Menu, TbMenu, Add, %t_Lang210%, IndentWith, Radio
			If (IndentWith = "Tab")
				Menu, TbMenu, Check, %t_Lang210%
			Else
				Menu, TbMenu, Check, %t_Lang211%
			Menu, TbMenu, Show, %mX%, %mY%
			Menu, TbMenu, DeleteAll
		Case "CommentUnchecked":
			Menu, TbMenu, Add, %w_Lang114%, ShowGroupNames
			If (ShowGroupNames)
				Menu, TbMenu, Check, %w_Lang114%
			Menu, TbMenu, Show, %mX%, %mY%
			Menu, TbMenu, DeleteAll
		Case "PrevFontShow":
			Menu, PrevFontMenu, Add, 6, PrevFontSet, Radio
			Menu, PrevFontMenu, Add, 7, PrevFontSet, Radio
			Menu, PrevFontMenu, Add, 8, PrevFontSet, Radio
			Menu, PrevFontMenu, Add, 9, PrevFontSet, Radio
			Menu, PrevFontMenu, Add, 10, PrevFontSet, Radio
			Menu, PrevFontMenu, Add, 11, PrevFontSet, Radio
			Menu, PrevFontMenu, Add, 12, PrevFontSet, Radio
			Menu, PrevFontMenu, Add, 13, PrevFontSet, Radio
			Menu, PrevFontMenu, Add, 14, PrevFontSet, Radio
			Menu, PrevFontMenu, Add, 15, PrevFontSet, Radio
			Menu, PrevFontMenu, Add, 16, PrevFontSet, Radio
			Menu, PrevFontMenu, Add, 17, PrevFontSet, Radio
			Menu, PrevFontMenu, Add, 18, PrevFontSet, Radio
			Menu, PrevFontMenu, Check, %PrevFontSize%
			Menu, PrevFontMenu, Show, %mX%, %mY%
			Menu, PrevFontMenu, DeleteAll
		Case "GroupsMode":
			GoSub, ShowGroupsMenu
		Default:
			If (InStr(Menu, "Rec"))
				GoSub, ShowRecMenu
			Else
				Menu, %Menu%, Show, %mX%, %mY%
	}
}

ShowChevronMenu(rbPtr, BandID, X := "", Y := "")
{
	Global TbEdit, ResDllPath

	Band := rbPtr.IDToIndex(BandID)
,	rbPtr.GetBand(Band, "", "", "", "", "", "", hChild)
	tbPtr := TB_GetHwnd(hChild)
	If (!IsObject(tbPtr))
		tbPtr := TbEdit
	If (tbPtr)
	{
		HidBtns := tbPtr.GetHiddenButtons()
		Loop, % HidBtns.Length()
		{
			Try
			{
				Menu, ChevMenu, Add, % HidBtns[A_Index].Text, % HidBtns[A_Index].Label
				Menu, ChevMenu, Icon, % HidBtns[A_Index].Text, %ResDllPath%, % HidBtns[A_Index].Icon
			}
		}
		Menu, ChevMenu, Show, %X%, %Y%
		Menu, ChevMenu, DeleteAll
	}
}

LVCallback(Func, Hwnd)
{
	global
	
	If (!InStr(CopyMenuLabels[A_List], "()"))
		return true

	If Func in Copy,Cut,Paste,Duplicate,Delete,Move,Drag
	{
		Critical
		LV_Row := 0
		Loop
		{
			LV_Row := LV_GetNext(LV_Row)
			If (!LV_Row)
				break
			LV_GetText(Type, LV_Row, 6)
			If (Type = cType47)
				return false
		}
	}
		
	return true
}

TVUpdateRows()
{
	local Lists := [], ItemID := 0

	Loop, %TabCount%
		Lists.Push(LVManager[A_Index].Handle.Slot[LVManager[A_Index].Handle.ActiveSlot])

	For Idx, Code in Lists
	{
		For each, Col in Code.Rows
		{
			ItemID := TV_GetNext(ItemID, "Full")
			While (!TVData[ItemID].Row)
			{
				If (!TVData.HasKey(ItemId))
					break 3
				ItemID := TV_GetNext(ItemID, "Full")
			}
			TVData[ItemID].Row := each
		,	TVData[ItemID].Content := RegExReplace(TVData[ItemID].Content, "^\d+:", each ":")
		,	TV_Modify(ItemID,, TVData[ItemID].Content)
		}
	}
}

TVCountChildren(Node)
{
	global TVData

	NextSibling := TV_GetNext(Node), Children := 0
	While (Node != NextSibling)
	{
		If (TVData[Node].Row)
			Children++
		Node := TV_GetNext(Node, "Full")
	}
	return Children
}

TVCollapse(Node)
{
	global TVData

	TV_Modify(Node, "-Expand")
	NextSibling := TV_GetNext(Node)
	While (Node != NextSibling)
	{
		OutputDebug, % TVData[Node].Row
		If (TVData[Node].Row)
			TV_Modify(Node, "-Expand")
		Node := TV_GetNext(Node, "Full")
	}
}

RowCheckFunc()
{
	local LvData, RowData, Rows := []

	ControlGet, LvData, List,,, % "ahk_id " ListID%A_List%
	Loop, Parse, LvData, `n
	{
        RowData := []
		Index := A_Index
		ckd := (LV_GetNext(Index-1, "Checked")=Index) ? 1 : 0
        RowData.Push("Check" ckd)
		Loop, Parse, A_LoopField, `t
            RowData.Push(A_LoopField)
		Rows[A_Index] := [RowData*]
	}
	For Index, RowData in Rows
	{
		Action := RowData[3]
		Action := LTrim(Action)
		Details := RowData[4]
		Type := RowData[7]
		Color := RowData[11]
		LV_Modify(A_Index, "Col2", Action)
		If (Type = "")
			break
		If (Type = cType47)
		{
			If (!InStr(UserDefFunctions, " " Details " "))
			{
				StringLower, UserDefFunc, Details
				UserDefFunctions .= UserDefFunc " "
			,	SetUserWords(UserDefFunctions)
			}
		}
		If (ShowLoopIfMark = 1)
		{
			OnMessage(WM_NOTIFY, "LV_ColorsMessage")
			LV_Colors.Row(ListID%A_List%, A_Index)
			LV_Colors.Attach(ListID%A_List%, false, false)
			If ((Action = "[LoopEnd]") && (RowColorLoop > 0))
				RowColorLoop--, LV_Modify(A_Index,, A_Index " " IdxLv), IdxLv := SubStr(IdxLv, 1, StrLen(IdxLv)-1)
			Else If ((Action = "[End If]") && (RowColorIf > 0))
				RowColorIf--, LV_Modify(A_Index,, A_Index " " IdxLv), IdxLv := SubStr(IdxLv, 1, StrLen(IdxLv)-1)
			Else If (Action = "[LoopStart]")
				RowColorLoop++, IdxLv .= ">", LV_Modify(A_Index,, A_Index " " IdxLv)
			Else If ((Type = cType17) && (!InStr(Action, "[Else")))
				RowColorIf++, IdxLv .= "*", LV_Modify(A_Index,, A_Index " " IdxLv)
			Else
				LV_Modify(A_Index,, A_Index " " IdxLv)
			LV_Colors.Row(ListID%A_List%, A_Index
			, (RowColorLoop > 0) ? LoopLVColor : ((Action = "[LoopEnd]") ? LoopLVColor : "")
			, (RowColorIf > 0 ) ? IfLVColor : ((Action = "[End If]") ? IfLVColor : ""))
			If (Type = cType47)
				LV_Colors.Row(ListID%A_List%, A_Index, 0xBB5046)
			LV_Colors.Cell(ListID%A_List%, A_Index, 1, Color ? Color : "")
		}
		Else
		{
			LV_Modify(A_Index,, A_Index)
			OnMessage(WM_NOTIFY, ""), LV_Colors.Detach(ListID%A_List%)
		}
		If (ShowActIdent = 1)
		{
			LV_Modify(A_Index, "Col2", ActLv Action)
			If (Action = "[LoopEnd]")
				ActLv := SubStr(ActLv, 4), LV_Modify(A_Index, "Col2", ActLv Action)
			Else If (Action = "[End If]")
				ActLv := SubStr(ActLv, 4), LV_Modify(A_Index, "Col2", ActLv Action)
			Else If ((Type = cType17) && (InStr(Action, "[Else")))
				LV_Modify(A_Index, "Col2", SubStr(ActLv, 4) Action)
			Else If (Action = "[LoopStart]")
				ActLv .= (ShowActIdent) ? "   " : ""
			Else If ((Type = cType17) && (!InStr(Action, "[Else")))
				ActLv .= (ShowActIdent) ? "   " : ""
		}
		If (IsUserFunc)
		{
			If (Type = cType47)
				FuncLn := true
			If Type in %cType35%,%cType36%,%cType37%
			{
				LV_Delete(A_Index), BadCmd := true
				break
			}
			If ((FuncLn) && (Type = cType48))
			{
				LV_Delete(A_Index), BadPos := true
				break
			}
			Else If ((!FuncLn) && ((Type != cType48) && (Type != cType42)))
			{
				LV_Delete(A_Index), BadPos := true
				break
			}
			If ((MustDefault) && (Type = cType48) && (!InStr(Details, " := ")))
				DebugDefault%A_List% := true
			If ((Type = cType48) && (InStr(Details, " := ")))
				MustDefault := true
		}
		Else If Type in %cType47%,%cType48%,%cType49%
		{
			LV_Delete(A_Index)
			continue
		}
		LV_Modify(A_Index, "Icon" GetIconForType(Type, Action))
	}
	return Rows
}

GetIconForType(Type, Action)
{
	global
	
	Switch Type
	{
		Case cType3, cType4, cType13:
			return IconsNames["mouse"]
		Case cType5:
			return IconsNames["pause"]
		Case cType6:
			return IconsNames["dialogs"]
		Case cType14:
			return IconsNames["wait"]
		Case cType7, cType38, cType39, cType40, cType41, cType45, cType51:
			return IconsNames["loop"]
		Case cType29:
			return IconsNames["break"]
		Case cType30:
			return IconsNames["continue"]
		Case cType21:
			return IconsNames["variables"]
		Case cType44, cType46:
			return IconsNames["functions"]
		Case cType17:
			return IconsNames["ifstatements"]
		Case cType18, cType19:
			return IconsNames["sendmsg"]
		Case cType15:
			return IconsNames["color"]
		Case cType16:
			return IconsNames["image"]
		Case cType56:
			return IconsNames["ocr"]
		Case cType34:
			return IconsNames["com"]
		Case cType35:
			return IconsNames["labels"]
		Case cType47:
			return IconsNames["userfunc"]
		Case cType48:
			return IconsNames["parameter"]
		Case cType49:
			return IconsNames["return"]
		Case cType43:
			return IconsNames["expression"]
		Case cType52:
			return IconsNames["email"]
		Case "Pause":
			return IconsNames["recpause"]
		Case "Return":
			return IconsNames["stop"]
		Case "ExitApp":
			return IconsNames["exit"]
		Case cType36, cType37:
			return IconsNames["goto"]
		Case cType11, cType14, "Run", "RunWait", "RunAs":
			return IconsNames["run"]
		Case "Process":
			return IconsNames["process"]
		Case "Shutdown":
			return IconsNames["shutdown"]
		Case cType42:
			return IconsNames["comment"]
		Case cType50:
			return IconsNames["timer"]
		Case cType53:
			return IconsNames["download"]
		Case cType54, cType55:
			return IconsNames["zip"]
		Case cType32, cType33:
			return IconsNames["ie"]
		Default:
			return (Action = "[Text]") ? IconsNames["text"]
		:	(Action = "[Control]") ? IconsNames["control"]
		:	(InStr(Type, "Sort") || InStr(Type, "String") || InStr(Type, "Split")) ? IconsNames["string"]
		:	(InStr(Type, "InputBox") || InStr(Type, "Msg") || InStr(Type, "Tip")
			|| InStr(Type, "Progress") || InStr(Type, "Splash")) ? IconsNames["dialogs"]
		:	InStr(Type, "Win") ? IconsNames["window"]
		:	(InStr(Type, "File")=1 || InStr(Type, "Drive")=1) ? IconsNames["files"]
		:	(InStr(Type, "Wait") || InStr(Type, "Input")=1) ? IconsNames["wait"]
		:	InStr(Type, "Ini") ? IconsNames["ini"]
		:	InStr(Type, "Reg")=1 ? IconsNames["registry"]
		:	InStr(Type, "Sound") ? IconsNames["sound"]
		:	InStr(Type, "Group") ? IconsNames["group"]
		:	InStr(Type, "Env") ? IconsNames["variables"]
		:	(!InStr(Type, "Control") && InStr(Type, "Get")) ? IconsNames["info"]
		:	(InStr(Type, "Url")) ? IconsNames["download"]
		:	(InStr(Type, "LockState") || InStr(Type, "Time") || InStr(Type, "Transform") || InStr(Type, "ListVars")
			|| InStr(Type, "Random") || InStr(Type, "ClipWait") || InStr(Type, "Block") || InStr(Type, "Debug")
			|| InStr(Type, "Status") || InStr(Type, "SendLevel") || InStr(Type, "CoordMode")) ?  IconsNames["misc"]
		:	IconsNames["keystroke"]
	}
}

SavePrompt(State, _Caller)
{
	global
	
	If (RowCheckInProgress)
		return

	SavePrompt := State
	TB_Edit(TbFile, "Save",, State)
	If (State)
		Menu, FileMenu, Enable, %f_Lang003%`t%_s%Ctrl+S
	Else
		Menu, FileMenu, Disable, %f_Lang003%`t%_s%Ctrl+S
}

SaveProject(FileName)
{
	local All_Data

	Loop, %TabCount%
	{
		PMCSet := "[PMC Code v" CurrentVersion "]|" o_AutoKey[A_Index]
		. "|" o_ManKey[A_Index] "|" o_TimesG[A_Index]
		. "|" CoordMouse "," TitleMatch "," TitleSpeed "," HiddenWin "," HiddenText "," KeyMode "," KeyDelay "," MouseDelay "," ControlDelay "|" OnFinishCode "|" CopyMenuLabels[A_Index] "`n"
		IfContext := "Context=" o_MacroContext[A_Index].Condition "|" o_MacroContext[A_Index].Context "|" IfDirectContext "|" IfDirectWindow "`n"
		TabGroups := "Groups=" LVManager[A_Index].GetGroups() "`n"
		LV_Data := PMCSet . IfContext . TabGroups . PMC.LVGet("InputList" A_Index).Text . "`n"
		All_Data .= LV_Data
	}
	FileAppend, %All_Data%, %FileName%
}

TreeGetChecked()
{
	ItemID := 0, LastItemID := 0, CheckedVars := []
	Loop
	{
		ItemID := TV_GetNext(ItemID, "Full")
		If (!ItemID)
			break
		CheckedVars.Push(TV_GetNext(LastItemID, "Checked") = ItemID)
		LastItemID := ItemID
	}
	return CheckedVars
}

UpdateMailAccounts()
{
	global

	Critical
	MailIni := ""
	Loop, % LV_GetCount()
	{
		RowData := LV_Rows.RowText(A_Index)
	,	RowData.RemoveAt(1)
	,	MailIni .= "[UserAccount" A_Index "]`n"
		For _each, _value in RowData
			MailIni .= Email_Fields[A_Index] "=" _value "`n"
	}
	UserMailAccounts.Set(MailIni)
	UserMailAccounts.Write(UserAccountsPath)
	Critical, Off
}

LoadMailAccounts()
{
	global

	User_Accounts := UserMailAccounts.Get(true)
	For _each, Section in User_Accounts
	{
		RowData := []
		For _key, _value in Email_Fields
			RowData.Push(Section[_value])
		LV_Add("", RowData*)
	}
}

WinHttpDownloadToFile(UrlList, DestFolder)
{
	UrlList := StrReplace(UrlList, "`n", ";")
	UrlList := StrReplace(UrlList, ",", ";")
	DestFolder := RTrim(DestFolder, "\") . "\"
	
	Loop, Parse, UrlList, `;, %A_Space%%A_Tab%
	{
		Url := A_LoopField, FileName := DestFolder . RegExReplace(A_LoopField, ".*/")
		whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		whr.Open("GET", Url, True)
		whr.Send()
		If (whr.WaitForResponse())
		{
			ado := ComObjCreate("ADODB.Stream")
			ado.Type := 1 ; adTypeBinary
			ado.Open
			ado.Write(whr.ResponseBody)
			ado.SaveToFile(FileName, 2)
			ado.Close
		}
	}
}

Unzip(Sources, OutDir, SeparateFolders := false)
{
	static vOptions := 16|256
	
	Sources := StrReplace(Sources, "`n", ";")
	Sources := StrReplace(Sources, ",", ";")
	Sources := Trim(Sources, ";")
	OutDir := RTrim(OutDir, "\")
	
	objShell := ComObjCreate("Shell.Application")
	Loop, Parse, Sources, `;, %A_Space%%A_Tab%
	{
		objSource := objShell.NameSpace(A_LoopField).Items()
		TargetDir := OutDir
		If (SeparateFolders)
		{
			SplitPath, A_LoopField,,,, FileNameNoExt
			TargetDir .= "\" FileNameNoExt
			If (!InStr(FileExist(TargetDir), "D"))
				FileCreateDir, %TargetDir%
		}
		objTarget := objShell.NameSpace(TargetDir)
		objTarget.CopyHere(objSource, vOptions)
	}
	ObjRelease(objShell)
}

Zip(FilesToZip, OutFile, SeparateFiles := false)
{
	static vOptions := 4|16
	
	FilesToZip := StrReplace(FilesToZip, "`n", ";")
	FilesToZip := StrReplace(FilesToZip, ",", ";")
	FilesToZip := Trim(FilesToZip, ";")
	
	objShell := ComObjCreate("Shell.Application")
	If (SeparateFiles)
		SplitPath, OutFile,, OutDir
	Else
	{
		If (!FileExist(OutFile))
			CreateZipFile(OutFile)
		objTarget := objShell.Namespace(OutFile)
	}
	zipped := objTarget.items().Count
	Loop, Parse, FilesToZip, `;, %A_Space%%A_Tab%
	{
		LoopField := RTrim(A_LoopField, "\")
		Loop, Files, %LoopField%, FD
		{
			zipped++
			If (SeparateFiles)
			{
				OutFile := OutDir "\" RegExReplace(A_LoopFileName, "\.(?!.*\.).*") ".zip"
				If (!FileExist(OutFile))
					CreateZipFile(OutFile)
				objTarget := objShell.Namespace(OutFile)
				zipped := 1
			}
			For item in objTarget.Items
			{
				If (item.Name = A_LoopFileDir)
				{
					item.InvokeVerb("Delete")
					zipped--
					break
				}
				If (item.Name = A_LoopFileName)
				{
					FileRemoveDir, % A_Temp "\" item.Name, 1
					FileDelete, % A_Temp "\" item.Name
					objShell.Namespace(A_Temp).MoveHere(item)
					FileRemoveDir, % A_Temp "\" item.Name, 1
					FileDelete, % A_Temp "\" item.Name
					zipped--
					break
				}
			}
			If (A_LoopFileFullPath = OutFile)
			{
				zipped--
				continue
			}
			objTarget.CopyHere(A_LoopFileFullPath, vOptions)
			While (objTarget.items().Count != zipped)
				Sleep, 10
		}
	}
	ObjRelease(objShell)
}

CreateZipFile(sZip)
{
	CurrentEncoding := A_FileEncoding
	FileEncoding, CP1252
	Header1 := "PK" . Chr(5) . Chr(6)
	VarSetCapacity(Header2, 18, 0)
	file := FileOpen(sZip,"w")
	file.Write(Header1)
	file.RawWrite(Header2,18)
	file.close()
	FileEncoding, %CurrentEncoding%
}

SavedVars(_Var := "", ByRef _Saved := "", AsArray := false, RunningFunction := "", ClearLocal := false)
{
	static VarsRecord := {}, LocalRecord := {}
	local ListOfVars, i, v
	
	If (ClearLocal)
	{
		LocalRecord[RunningFunction] := ""
		return
	}

	If (RunningFunction != "")
	{
		If (!VarsRecord.HasKey(_Var))
			VarsRecord[_Var] := []
	}
	
	If _Var in %BuiltinVars%,TabCount,Record,Action,Step,Details,TimesX,DelayX,Type,Target,Window,Win,IfError,VarName,VarValue,Oper,Par,Param,Version,Lang,AutoKey,ManKey,AbortKey,PauseKey,RecKey,RecNewKey,RelKey,FastKey,SlowKey,ClearNewList,DelayG,OnScCtrl,ShowStep,HideMainWin,DontShowPb,DontShowRec,DontShowEdt,ConfirmDelete,ShowTips,NextTip,IfDirectContext,IfDirectWindow,KeepHkOn,Mouse,Moves,TimedI,Strokes,CaptKDn,MScroll,WClass,WTitle,MDelay,DelayM,DelayW,MaxHistory,TDelay,ToggleC,RecKeybdCtrl,RecMouseCtrl,CoordMouse,SpeedUp,SpeedDn,MouseReturn,ShowProgBar,ShowBarOnStart,AutoHideBar,RandomSleeps,RandPercent,DrawButton,OnRelease,OnEnter,LineW,ScreenDir,DefaultEditor,DefaultMacro,StdLibFile,KeepDefKeys,TbNoTheme,AutoBackup,MultInst,EvalDefault,CloseAction,ShowLoopIfMark,ShowActIdent,SearchAreaColor,LoopLVColor,IfLVColor,VirtualKeys,AutoUpdate,Ex_AbortKey,Ex_PauseKey,Ex_SM,SM,Ex_SI,SI,Ex_ST,ST,Ex_DH,Ex_AF,Ex_HK,Ex_PT,Ex_NT,Ex_SC,SC,Ex_SW,SW,Ex_SK,SK,Ex_MD,MD,Ex_SB,SB,Ex_MT,MT,Ex_IN,Ex_UV,Ex_Speed,ComCr,ComAc,Send_Loop,TabIndent,IncPmc,Exe_Exp,ShowExpOpt,MainWinSize,MainWinPos,WinState,ColSizes,ColOrder,PrevWinSize,ShowPrev,TextWrap,CommentUnchecked,CustomColors,OSCPos,OSTrans,OSCaption,AutoRefresh,ShowGroups,IconSize,UserLayout,MainLayout,MacroLayout,FileLayout,RecPlayLayout,SettingsLayout,CommandLayout,EditLayout,ShowBands
		If ((_Var != "Clipboard") && (_Var != "ErrorLevel"))
			TrayTip, %d_Lang011%, %_Var% %d_Lang042%,, 18
	If (IsByRef(_Saved))
	{
		If ((AsArray) && (RunningFunction != ""))
		{
			ListOfVars := []
			For i, v in LocalRecord[RunningFunction]
				ListOfVars.Push(i)
			_Saved := ListOfVars
			return
		}
		If (AsArray)
		{
			ListOfVars := []
			For i, v in VarsRecord
				ListOfVars.Push(i)
			_Saved := ListOfVars
			return
		}
		For i, v in VarsRecord
			ListOfVars .= i ": " v "`n"
		Sort, ListOfVars
		ListOfVars := "Global Variables (alphabetical)`n--------------------------------------------------`n" ListOfVars
		_Saved := ListOfVars
		If (RunningFunction != "")
		{
			ListOfVars := ""
			For i, v in LocalRecord[RunningFunction]
				ListOfVars .= i ": " v "`n"
			Sort, ListOfVars
			ListOfVars := "Local Variables for " RunningFunction "()`n--------------------------------------------------`n" ListOfVars
			_Saved := ListOfVars "`n" _Saved
		}
		return
	}
	
	If _Var in %BuiltinVars%
		return
	
	If (RunningFunction != "")
	{
		If (!IsObject(LocalRecord[RunningFunction]))
			LocalRecord[RunningFunction] := {}
		If (IsObject(%_Var%))
			LocalRecord[RunningFunction][_Var] := SubStr(JSON.Dump(%_Var%), 1, 60)
		Else
			LocalRecord[RunningFunction][_Var] := SubStr(%_Var%, 1, 60)
	}
	Else
	{
		If (IsObject(%_Var%))
			VarsRecord[_Var] := SubStr(JSON.Dump(%_Var%), 1, 60)
		Else
			VarsRecord[_Var] := SubStr(%_Var%, 1, 60)
	}
}
