LV_GetTexts(Index, ByRef Act="", ByRef Det="", ByRef Tim="", ByRef Del="", ByRef Typ="", ByRef Tar="", ByRef Win="", ByRef Com="", ByRef Col="")
{
	LV_GetText(Act, Index, 2)
,	Act := LTrim(Act)
,	LV_GetText(Det, Index, 3)
,	LV_GetText(Tim, Index, 4)
,	LV_GetText(Del, Index, 5)
,	LV_GetText(Typ, Index, 6)
,	LV_GetText(Tar, Index, 7)
,	LV_GetText(Win, Index, 8)
,	LV_GetText(Com, Index, 9)
,	LV_GetText(Col, Index, 10)
}

ShowTooltip()
{
	static CurrControl, PrevControl, _TT, TT_A
	CurrControl := A_GuiControl
	If (CurrControl <> PrevControl && !RegExMatch(CurrControl, "\W"))
	{
		TT_A := WinExist("A")
		ToolTip
		SetTimer, DisplayToolTip, -500
		PrevControl := CurrControl
		If InStr(A_GuiControl, "Static")
			SetTimer, HandCursor, 0
		Else
			SetTimer, HandCursor, Off
	}
	return

	DisplayToolTip:
	If (TT_A <> WinExist("A"))
		return
	Try
		ToolTip, % %CurrControl%_TT
	SetTimer, RemoveToolTip, -3000
	return
}

SBShowTip(Command)
{
	global Cmd_Tips
	
	For each, Line in Cmd_Tips
	{
		If (Line.Cmd = Command)
		{
			SB_SetText(Line.Desc)
			return Line.Desc
		}
	}
	SB_SetText("")
}

Find_Command(SearchWord)
{
	local Results, SearchIn, Search
	
	Results := {}
	Loop, Parse, KeywordsList, |
	{
		SearchIn := A_LoopField
		Loop, Parse, %A_LoopField%_Keywords, `,
		{
			If (SearchIn = "Type")
				Search := "Type" A_Index
			Else
				Search := SearchIn
			If InStr(A_LoopField, FindCmd)
				Results.Insert({Cmd: A_LoopField, Path: %Search%_Path})
			Else Try
			{
				If InStr(%A_LoopField%_Desc, FindCmd)
					Results.Insert({Cmd: A_LoopField, Path: %Search%_Path})
			}
		}
	}
	return Results
}

RebarLock(rbPtr, Lock=True)
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

DragToolbar()
{
	global
	
	CoordMode, Mouse, Window
	If (A_Gui = 28)
		PostMessage, 0xA1, 2,,, ahk_id %PMCOSC%
	Else If (A_Gui = "chMacro")
	{
		MouseGetPos, HitX, HitY,, cHwnd, 2
		If (cHwnd = TabSel)
		{
			GuiControl, chMacro:Choose, A_List, % TabGet()
			GoSub, TabSel
			NewOrder := TabDrag()
			If IsObject(NewOrder)
			{
				Project := [], Proj_Opts := [], ActiveList := A_List
				For each, Index in NewOrder.Order
					Proj_Opts.Insert({Auto: o_AutoKey[Index], Man: o_ManKey[Index]
									, Times: o_TimesG[Index], Hist: HistoryMacro%Index%})
				For each, Index in NewOrder.Order
				{
					o_AutoKey[A_Index] := Proj_Opts[A_Index].Auto
				,	o_ManKey[A_Index] := Proj_Opts[A_Index].Man
				,	o_TimesG[A_Index] := Proj_Opts[A_Index].Times
				,	Project.Insert(PMC.LVGet("InputList" Index))
					If (Index = ActiveList)
						NewActive := A_Index
				}
				ActiveList := NewActive
				Loop, %TabCount%
					PMC.LVLoad("InputList" A_Index, Project[A_Index])
				,	HistoryMacro%A_Index% := Proj_Opts[A_Index].Hist
				GuiControl, chMacro:, A_List, |
				GuiControl, chMacro:, A_List, % NewOrder.Tabs
				GuiControl, chMacro:Choose, A_List, %ActiveList%
				Gui, chMacro:Submit, NoHide
				GoSub, chMacroGuiSize
				GoSub, LoadData
				GoSub, RowCheck
				GoSub, UpdateCopyTo
				Project := "", Proj_Opts := "", SavePrompt := 1
				SetTimer, HitFix, -10
			}
			Else
				SetTimer, SetListFocus, -10
		}
	}
}

HitFix:
ControlClick,, ahk_id %cHwnd%,,,, x%HitX% y%HitY% NA
SetListFocus:
GuiControl, chMacro:Focus, InputList%A_List%
return

ShowContextHelp()
{
	local Pag,Title
	
	MouseGetPos,,,, Control
	If InStr(Control, "Edit")
		return
	If A_Gui in 3,5,7,8,10,11,12,14,16,19,21,22,23,24
	{
		GuiControlGet, Pag,, TabControl
		Title := ContHelp[A_Gui][Pag ? Pag : 1]
		Menu, %Title%, Show
		return
	}
	Else If A_Gui = 28
	{
		Menu, ToolbarMenu, Show
		return
	}
}

CmdHelp()
{
	local Gui,Pag,Title

	If HotkeyCtrlHasFocus()
		return
	Gui := ActiveGui(WinActive("A"))
	If (Gui = 0)
		return
	Gui, %Gui%:Submit, NoHide
	If (Gui = 19)
		Pag := (PixelS = 1) ? 2 : 1
	Else If (Gui = 12)
	{
		GuiControlGet, Pag,, TabControl
		If (Pag = 1)
		{
			If (LFilePattern = 1)
				Pag := 4
			Else If (LParse = 1)
				Pag := 5
			Else If (LRead = 1)
				Pag := 6
			Else If (LRegistry = 1)
				Pag := 7
		}
	}
	Else
		GuiControlGet, Pag,, TabControl
	Title := ContHTitle[Gui][Pag ? Pag : 1]
	If (WinActive("A") <> StartTipID) && ((!Title) || (WinActive("A") <> CmdWin))
		Title := "index.html"
	IfExist, %A_ScriptDir%\MacroCreator_Help.chm
		Run, hh.exe mk:@MSITStore:%A_ScriptDir%\MacroCreator_Help.chm::/%Title%
	Else
		Run, http://www.macrocreator.com/docs/%Title%
	return 0
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

GuiGetSize(ByRef W, ByRef H, GuiID=1)
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
	If InStr(ctrl,"hotkey")
	{
		GuiControlGet, ctrl, %GuiA%:FocusV
		Return, ctrl
	}
}

SleepRandom(Delay=0, Min="", Max="", Percent="")
{
	If (Percent)
	{
		Min := Floor(Delay - (Delay * Percent / 100))
		Max := Floor(Delay + (Delay * Percent / 100))
	}
	Random, RandTime, % (Min < 0) ? 0 : Min, %Max%
	Sleep, %RandTime%
}

EditCtrlHasFocus()
{
	global GuiA := ActiveGui(WinActive("A"))
	GuiControlGet, ctrl, %GuiA%:FocusV
	return ctrl
}

SCI_NOTIFY(wParam, lParam, msg, hwnd, sciObj) {

	line := sciObj.LineFromPosition(sciObj.position)

	if (sciObj.scnCode = SCN_MARGINCLICK)
		sciObj.ToggleFold(line)
}

MarkArea(LineW)
{
	global c_Lang004, c_Lang059, d_Lang057
	
	MouseGetPos,,, id, control
	ControlGetPos, cX, cY, cW, cH, %control%, ahk_id %id%
	WinGetPos, wX, wY, wW, wH, ahk_id %id%
	If (control <> "")
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
		If WMS = 1
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

ReadFunctions(LibFile, Msg="")
{
	IfNotExist, %LibFile%
		return "$"
	Pos := 1
	FileRead, Content, *t %LibFile%
	While, RegExMatch(Content, "OU)([\w\._]+)\(.*\)[\n\r\s]*?\{", Found, Pos)
	{
		Pos := Found.Pos(1) + Found.Len(1)
		If (Func(Found.Value(1)).IsBuiltIn)
			continue
		ExtList .= Found.Value(1) "$"
		Tooltip, %Msg%
	}
	Tooltip
	Sort, ExtList, D$ U
	return (ExtList <> "") ? ExtList : "$"
}

AssignVar(Name, Operator, Value)
{
	global
	local TempVar
	If InStr(Value, "!")=1
		Value := !SubStr(Value, 2)
	If (Operator = ":=")
		%Name% := Value
	Else If (Operator = "+=")
		%Name% += Value
	Else If (Operator = "-=")
		%Name% -= Value
	Else If (Operator = "*=")
		%Name% *= Value
	Else If (Operator = "/=")
		%Name% /= Value
	Else If (Operator = "//=")
		%Name% //= Value
	Else If (Operator = ".=")
		%Name% .= Value
}

ListIEWindows()
{
	List := "[blank]||"
	Try
	{
		For Pwb in ComObjCreate( "Shell.Application" ).Windows
			If InStr(Pwb.FullName, "iexplore.exe")
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
	Try Gui, chMacro:Add, ListView, x+0 y+0 AltSubmit Checked hwndListID%ident% vInputList%ident% gInputList NoSort LV0x10000, %w_Lang030%|%w_Lang031%|%w_Lang032%|%w_Lang033%|%w_Lang034%|%w_Lang035%|%w_Lang036%|%w_Lang037%|%w_Lang038%|%w_Lang039%
	LV_SetImageList(hIL_Icons)
	Loop, 10
		LV_ModifyCol(A_Index, Col_%A_Index%)
	LVOrder_Set(10, ColOrder, ListID%ident%)
}

SelectByType(SelType, Col=6)
{
	SelType := Trim(SelType)
	LV_Modify(0, "-Select")
	If SelType in Win,File,String
	{
		Loop, % ListCount%A_List%
		{
			LV_GetText(Type, A_Index, Col)
			If InStr(Trim(Type), SelType)
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
}

SelectByFilter(Act, Det, Tim, Del, Typ, Tar, Win, Com, Col, Case)
{
	LV_Modify(0, "-Select"), Found := 0
	Loop, % ListCount%A_List%
	{
		LV_GetTexts(A_Index, A, B, C, D, E, F, G, H, I)
		If InStr(A, Trim(Act), Case)
		&& InStr(B, Trim(Det), Case)
		&& InStr(C, Trim(Tim), Case)
		&& InStr(D, Trim(Del), Case)
		&& InStr(E, Trim(Typ), Case)
		&& InStr(F, Trim(Tar), Case)
		&& InStr(G, Trim(Win), Case)
		&& InStr(H, Trim(Com), Case)
		&& InStr(I, Trim(Col), Case)
		{
			LV_Modify(A_Index, "Select")
			Found++
		}
	}
	return Found
}

class IfWin
{
	Active(Win)
	{
		return WinActive(Win)
	}
	NotActive(Win)
	{
		return !WinActive(Win)
	}
	Exist(Win)
	{
		return WinExist(Win)
	}
	NotExist(Win)
	{
		return !WinExist(Win)
	}
	None(Win)
	{
		return 1
	}
}

ActivateHotkeys(Rec="", Play="", Speed="", Stop="", Pause="", Joy="")
{
	local ActiveKeys
	
	If (Speed <> "")
	{
		If (FastKey <>  "None")
			Hotkey, %FastKey%, FastKeyToggle, % (Speed) ? "On" : "Off"
		If (SlowKey <>  "None")
			Hotkey, %SlowKey%, SlowKeyToggle, % (Speed) ? "On" : "Off"
	}
	
	If (Pause <> "")
	{
		Hotkey, %PauseKey%, f_PauseKey, Off
		If ((PauseKey <> "") && (Pause = 1))
			Hotkey, %PauseKey%, f_PauseKey, On
	}
	
	If (Stop <> "")
	{
		Hotkey, %AbortKey%, f_AbortKey, Off
		If ((AbortKey <> "") && (Stop = 1))
			Hotkey, %AbortKey%, f_AbortKey, On
	}
	
	If (Rec <> "")
	{
		Try Hotkey, %RecKey%, RecStart, % (Rec) ? "On" : "Off"
		Try Hotkey, %RecNewKey%, RecStartNew, % (Rec) ? "On" : "Off"
	}
	
	If (Play <> "")
	{
		Loop, %TabCount%
		{
			#If !WinActive("ahk_id" PMCWinID) && IfWin[IfDirectContext](IfDirectWindow)
			Hotkey, If, !WinActive("ahk_id" PMCWinID) && IfWin[IfDirectContext](IfDirectWindow)
			If (ListCount%A_Index% = 0)
				continue
			If (o_AutoKey[A_Index] <> "")
			{
				Hotkey, % o_AutoKey[A_Index], f_AutoKey, % (Play) ? "On" : "Off"
				ActiveKeys++
			}
			If (o_ManKey[A_Index] <> "")
				Hotkey, % o_ManKey[A_Index], f_ManKey, % (Play) ? "On" : "Off"
			Hotkey, If
			#If
		}
	}
	
	If (Joy <> "")
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
		Proj_Labels .= TabGetText(TabSel, A_Index) "`n"
	Sort, Proj_Labels, U
	return ErrorLevel
}

RemoveDuplicates(ByRef String)
{
	StringTrimRight, String, String, 1
	Loop, Parse, String, |
		NewStr .= (InStr(NewStr, A_LoopField "|") ? "Macro" A_Index : A_LoopField) "|"
	String := NewStr
}

CheckDuplicates(Obj1, Obj2, Obj3*)
{
	global TabCount
	Loop, 3
	{
		If IsObject(Obj%A_Index%)
		{
			For Index, Obj in Obj%A_Index%
			{
				If ((Obj <> "") && (Index <= TabCount))
					Keys .= Obj "`n"
			}
		}
		Else If (Obj%A_Index% <> "")
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

AssignReplace(String)
{
	global
	RegExMatch(String, "sU)(.+)\s(\W\W?)(?-U)\s(.*)", Out)
	VarName := Out1, Oper := Out2, VarValue := Out3
}

EscCom(MatchList, Reverse=0)
{
	global
	
	If (Reverse)
	{
		Loop, Parse, MatchList, |
			StringReplace, %A_LoopField%, %A_LoopField%, ```,, `,, All
	}
	Else
	{
		Loop, Parse, MatchList, |
			StringReplace, %A_LoopField%, %A_LoopField%, `,, ```,, All
	}
}

HistCheck(L)
{
	global

	If (MaxHistory = 0)
		return
	HistoryMacro%L%.Slot.Remove(HistoryMacro%L%.ActiveSlot+1, HistoryMacro%L%.Slot.MaxIndex())
,	HistoryMacro%L%.Add()
	If (HistoryMacro%L%.Slot.MaxIndex() > MaxHistory+1)
		HistoryMacro%L%.Slot.Remove(1)
	HistoryMacro%L%.ActiveSlot := HistoryMacro%L%.Slot.MaxIndex()
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

ToggleIcon()
{
	global
	static IconFile, IconNumber, BarColor
	Color := (BarColor := !BarColor) ? "Red" : "20D000"
	ChangeProgBarColor(Color, "OSCProg", 28)
	If !A_IsPaused
		IconFile := A_IconFile, IconNumber := A_IconNumber
	Menu, Tray, Icon, % (A_IsPaused = 0) ? ResDllPath : IconFile, % (A_IsPaused = 0) ? 55 : IconNumber
	return A_IsPaused
}

ToggleButtonIcon(Button, Icon)
{
	ILButton(Button, Icon[1] ":" Icon[2], 0)
}

ChangeProgBarColor(Color, Control, Gui=1)
{
	GuiControl, %Gui%:+c%Color%, %Control%
}

ChangeIcon(hInst, ID, Icon)
{
	hIcon := DllCall("LoadImage", "Uint", hInst, "Uint", Icon, "Uint", 1, "int", 96, "int", 96, "Uint", 0x8000)

	SendMessage, 0x80, 0, hIcon,, ahk_id %ID% ;set the window's small icon (0x80 is WM_SETICON).
	SendMessage, 0x80, 1, hIcon,, ahk_id %ID% ;set the window's big icon to the same one.
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

LV_ColorsMessage(wParam, lParam)
{
	Static NM_CUSTOMDRAW := -12
	Static LVN_COLUMNCLICK := -108
	Critical, 1000
	If LV_Colors.HasKey(H := NumGet(lParam + 0, 0, "UPtr"))
	{
		M := NumGet(lParam + (A_PtrSize * 2), 0, "Int")
		; NM_CUSTOMDRAW --------------------------------------------------------------------------------------------------
		If (M = NM_CUSTOMDRAW)
			Return LV_Colors.On_NM_CUSTOMDRAW(H, lParam)
		; LVN_COLUMNCLICK ------------------------------------------------------------------------------------------------
		If (LV_Colors[H].NS && (M = LVN_COLUMNCLICK))
			Return 0
	}
}

ShowMenu(Menu, mX, mY)
{
	global
	
	If (Menu = "Open")
		Menu, RecentMenu, Show, %mX%, %mY%
	Else If (Menu = "Save")
	{
		Menu, TbMenu, Add, %f_Lang004%, SaveAs
		Menu, TbMenu, Icon, %f_Lang004%, %ResDllPath%, 86
		Menu, TbMenu, Show, %mX%, %mY%
		Menu, TbMenu, DeleteAll
	}
	Else If (Menu = "PlayStart")
		GoSub, ShowPlayMenu
	Else If (Menu = "OnFinish")
		GoSub, OnFinish
	Else If (Menu = "RecStart")
	{
		Menu, TbMenu, Add, %t_Lang020%, RecStartNew
		Menu, TbMenu, Show, %mX%, %mY%
		Menu, TbMenu, DeleteAll
	}
	Else If InStr(Menu, "Rec")
		GoSub, ShowRecMenu
	Else If (Menu = "ShowPlayMenu")
		GoSub, ShowPlayMenu
	Else If (Menu = "PrevRefreshButton")
	{
		Menu, TbMenu, Add, %t_Lang015%, AutoRefresh
		If (AutoRefresh)
			Menu, TbMenu, Check, %t_Lang015%
		Menu, TbMenu, Show, %mX%, %mY%
		Menu, TbMenu, DeleteAll
	}
	Else
		Menu, %Menu%, Show, %mX%, %mY%
}

ShowChevronMenu(rbPtr, BandID, X="", Y="")
{
	Global TbEdit, ResDllPath
	Band := rbPtr.IDToIndex(BandID)
,	rbPtr.GetBand(Band, "", "", "", "", "", "", hChild)
	tbPtr := TB_GetHwnd(hChild)
	If !IsObject(tbPtr)
		tbPtr := TbEdit
	If (tbPtr)
	{
		HidBtns := tbPtr.GetHiddenButtons()
		Loop, % HidBtns.MaxIndex()
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
