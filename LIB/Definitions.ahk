﻿If A_OSVersion in WIN_2003,WIN_XP,WIN_2000
	_s := Chr(4445)
,	RecentFolder := A_AppData "\..\Recent"
Else
	_s := Chr(8239)
,	RecentFolder := A_AppData "\Microsoft\Windows\Recent"

ListCount1 := 0
,	TabCount := 1
,	FastKeyOn := 0
,	SlowKeyOn := 0
,	cType1 := "Send"
,	cType2 := "ControlSend"
,	cType3 := "Click"
,	cType4 := "ControlClick"
,	cType5 := "Sleep"
,	cType6 := "MsgBox"
,	cType7 := "Loop"
,	cType8 := "SendRaw"
,	cType9 := "ControlSendRaw"
,	cType10 := "ControlSetText"
,	cType11 := "Run"
,	cType12 := "Clipboard"
,	cType13 := "SendEvent"
,	cType14 := "RunWait"
,	cType15 := "PixelSearch"
,	cType16 := "ImageSearch"
,	cType17 := "If_Statement"
,	cType18 := "SendMessage"
,	cType19 := "PostMessage"
,	cType20 := "KeyWait"
,	cType21 := "Variable"
,	cType22 := "ControlEditPaste"
,	cType23 := "ControlGetText"
,	cType24 := "Control"
,	cType25 := "ControlFocus"
,	cType26 := "ControlMove"
,	cType27 := "ControlGetFocus"
,	cType28 := "ControlGet"
,	cType29 := "Break"
,	cType30 := "Continue"
,	cType31 := "ControlGetPos"
,	cType32 := "IECOM_Set"
,	cType33 := "IECOM_Get"
,	cType34 := "COMInterface"
,	cType35 := "Label"
,	cType36 := "Goto"
,	cType37 := "Gosub"
,	cType38 := "LoopRead"
,	cType39 := "LoopParse"
,	cType40 := "LoopFilePattern"
,	cType41 := "LoopRegistry"
,	cType42 := "VBScript"
,	cType43 := "JScript"

,	Action1 := "Click"
,	Action2 := "Move"
,	Action3 := "Move & Click"
,	Action4 := "Click & Drag"
,	Action5 := "Mouse Wheel Up"
,	Action6 := "Mouse Wheel Down"
,	Help5 := "MouseB"
,	Help8 := "TextB"
,	Help7 := "SpecialB"
,	Help14 := "ExportG"
,	Help3 := "PauseB"
,	Help11 := "WindowB"
,	Help16 := "IfDirB"
,	Help19 := "ImageB"
,	Help10 := "RunB"
,	Help12 := "ComLoopB"
,	Help21 := "IfStB"
,	Help22 := "SendMsgB"
,	Help23 := "ControlB"
,	Help24 := "IEComB"
,	ContHTitle := {	2: ["p6-Preview.html"]
			,	3: ["Commands/Pause.html", "Commands/Message_Box.html", "Commands/KeyWait.html"]
			,	4: ["p7-Settings.html", "p7-Settings.html#misc.", "p7-Settings.html#user-global-variables"]
			,	5: ["Commands/Mouse.html"]
			,	8: ["Commands/Text.html"]
			,	10: ["Commands/Run.html"]
			,	11: ["Commands/Window.html"]
			,	12: ["Commands/Loop.html", "Commands/Goto_and_Gosub.html", "Commands/Label.html"
				, "Commands/Loop_FilePattern.html",	"Commands/Loop_Parse.html", "Commands/Loop_Read.html", "Commands/Loop_Registry.html"]
			,	14: ["p5-Export.html"]
			,	19: ["Commands/Image_Search.html", "Commands/Pixel_Search.html"]
			,	21: ["Commands/If_Statements.html", "Commands/Assign_Variable.html", "Commands/Functions.html"]
			,	22: ["Commands/PostMessage_and_SendMessage.html"]
			,	23: ["Commands/Control.html"]
			,	24: ["Commands/Internet_Explorer.html", "Commands/COM_Interface.html", "Commands/Run_Scriptlet.html"]
			,	26: ["Commands/Find_a_Command.html"]
			,	30: ["Commands/COM_Interface.html"]
			,	34: ["Commands/Find_a_Command.html"] }

,	RecOptChecks := ["ClearNewList", "", "Strokes", "CaptKDn", "RecKeybdCtrl"
					, "", "Mouse", "MScroll", "Moves", "RecMouseCtrl"
					, "", "TimedI", "WClass", "WTitle"]
,	PlayOptChecks := ["ShowStep", "MouseReturn", "ShowBarOnStart", "AutoHideBar", "RandomSleeps"]
,	OnFinishCode := 1
,	CopyMenuLabels := []
,	Exp_Mult := {1:2, 2:4, 3:8, 4:16, 5:32}
,	MsgBoxStyles := [262144, 512, 256]
KeyNameRep := "
(Join,
LControl|Left Control
RControl|Right Control
LAlt|Left Alt
RAlt|Right Alt
LShift|Left Shift
RShift|Right Shift
LWin|Left Win
RWin|Right Win
AppsKey|Apps Key
PgUp|Page Up
PgDn|Page Down
PrintScreen|Print Screen
CapsLock|Caps Lock
ScrollLock|Scroll Lock
NumLock|Num Lock
Num Dot|Num .
Num Div|Num /
Num Mult|Num *
Num Add|Num +
Num Sub|Num -
Num Ins|Num Insert
Num PgDn|Num Page Down
Num PgUp|Num Page Up
Num Del|Num Delete
)"
,	CtrlCmdList := "
(Join|
Control|
ControlFocus
ControlMove
ControlSetText
ControlGet
ControlGetText
ControlGetFocus
ControlGetPos
)"
,	CtrlCmd := "
(Join|
Check|
Uncheck
Enable
Disable
Show
Hide
Style
ExStyle
ShowDropDown
HideDropDown
TabLeft
TabRight
Add
Delete
Choose
ChooseString
EditPaste
)"
,	CtrlGetCmd := "
(Join|
List|
Checked
Enabled
Visible
Tab
FindString
Choice
LineCount
CurrentLine
CurrentCol
Line
Selected
Style
ExStyle
Hwnd
)"
,	WinList := "
(
WinSet = WinTitle, WinText, ExcludeTitle, ExcludeText
WinActivate = WinTitle, WinText, ExcludeTitle, ExcludeText
WinActivateBottom = WinTitle, WinText, ExcludeTitle, ExcludeText
WinWait = WinTitle, WinText, ExcludeTitle, ExcludeText
WinWaitActive = WinTitle, WinText, ExcludeTitle, ExcludeText
WinWaitNotActive = WinTitle, WinText, ExcludeTitle, ExcludeText
WinWaitClose = WinTitle, WinText, ExcludeTitle, ExcludeText
WinMaximize = WinTitle, WinText, ExcludeTitle, ExcludeText
WinMinimize = WinTitle, WinText, ExcludeTitle, ExcludeText
WinRestore = WinTitle, WinText, ExcludeTitle, ExcludeText
WinMinimizeAll
WinMinimizeAllUndo
WinMove = WinTitle, WinText, ExcludeTitle, ExcludeText
WinShow = WinTitle, WinText, ExcludeTitle, ExcludeText
WinHide = WinTitle, WinText, ExcludeTitle, ExcludeText
WinClose = WinTitle, WinText, ExcludeTitle, ExcludeText
WinKill = WinTitle, WinText, ExcludeTitle, ExcludeText
WinSetTitle = WinTitle, WinText, NewTitle, ExcludeTitle, ExcludeText
WinGet = WinTitle, WinText, ExcludeTitle, ExcludeText
WinGetTitle = WinTitle, WinText, ExcludeTitle, ExcludeText
WinGetClass = WinTitle, WinText, ExcludeTitle, ExcludeText
WinGetText = WinTitle, WinText, ExcludeTitle, ExcludeText
WinGetPos = WinTitle, WinText, ExcludeTitle, ExcludeText
)"

Loop, Parse, WinList, `n
{
	Loop, Parse, A_LoopField, =, %A_Space%
	{
		If A_Index = 1
			WinCmdList .= A_LoopField "|", Par := A_LoopField
		Else
			wcmd_%Par% := A_LoopField
	}
	If A_Index = 1
		WinCmdList .= "|"
}
wcmd_All := "Title, Text, ExclTitle, ExclText"

,	WinCmd := "
(Join|
AlwaysOnTop|
Bottom
Top
Disable
Enable
Redraw
Style
ExStyle
Region
Transparent
TransColor
)"
,	WinGetCmd := "
(Join|
ID|
IDLast
PID
ProcessName
ProcessPath
Count
List
MinMax
ControlList
ControlListHwnd
Transparent
TransColor
Style
ExStyle
)"
,	IfCmd := "
(
If Window Active|IfWinActive,
If Window Not Active|IfWinNotActive, 
If Window Exist|IfWinExist, 
If Window Not Exist|IfWinNotExist, 
If File Exist|IfExist, 
If File Not Exist|IfNotExist, 
If Clipboard Text|If Clipboard = 
If Loop Index|If A_Index = 
If Image/Pixel Found|If ErrorLevel = 0
If Image/Pixel Not Found|If ErrorLevel
If String Contains|IfInString, 
If String Not Contains|IfNotInString, 
If Message Box|IfMsgBox, 
Compare Variables|If
Evaluate Expression|If (expression)
)"
Loop, Parse, IfCmd, `n
{
	Count := A_index
	Loop, Parse, A_LoopField, |
	{
		If A_Index = 1
		{
			If%Count% := A_LoopField
			IfList%Count% := A_LoopField
		}
		Else
			c_If%Count% := A_LoopField
	}
}

MsgButtons := "Yes,No,OK,Cancel,Abort,Ignore,Retry,Continue,TryAgain,Timeout"
StringSplit, IfMsg, MsgButtons, `,

IECmdList := "
(Join|
Navigate|
Value
Focus
Click
Submit
GoHome
GoBack
GoForward
GoSearch
Refresh
Stop
Quit
LocationName
LocationURL
InnerText
InnerHTML
OuterHTML
Href
Src
SelectedIndex
Checked
Type
Width
Height
Length
)"

,	SetOnlyList := "GoHome,GoBack,GoForward,GoSearch,Refresh,Stop,Quit
				,Navigate,Navigate2,Focus,Click,Submit"
,	GetOnlyList := "LocationName,LocationURL"
,	NoValueList := "GoHome,GoBack,GoForward,GoSearch,Refresh,Stop,Quit
			,Focus,Click,Submit"
,	NoElemList := "Navigate,Navigate2,GoHome,GoBack,GoForward,GoSearch,Refresh,Stop,Quit
				,LocationName,LocationURL"

,	MethodList := "
(Join,
ClientToWindow
ExecWB
Focus
Click
Submit
GetProperty
GoBack
GoForward
GoHome
GoSearch
Navigate
Navigate2
PutProperty
QueryStatusWB
Quit
Refresh
Refresh2
ShowBrowserBar
Stop
)"
,	ProperList := "
(Join,
AddressBar
FullScreen
Application
Busy
Container
Document
FullName
LocationName
LocationURL
Name
Parent
Path
ReadyState
RegisterAsBrowser
Src
Href
TopLevelContainer
Type
Height
HWND
Left
Length
MenuBar
Offline
RegisterAsDropTarget
Resizable
Silent
StatusBar
StatusText
TheaterMode
ToolBar
Top
Visible
Width
Value
InnerText
InnerHTML
OuterHTML
SelectedIndex
Checked
)"
CLSList := " 
(Join|
InternetExplorer.Application|
Excel.Application
Word.Application
Outlook.Application
PowerPoint.Application
SAPI.SpVoice
Schedule.Service
ScriptControl
WScript.Shell
WMPlayer.OCX
HTMLfile
XStandard.Zip
)"

,	FileCmd := "
(
Run, Target, WorkingDir, Max|Min|Hide|UseErrorLevel, OutputVarPID
RunWait, Target, WorkingDir, Max|Min|Hide|UseErrorLevel, OutputVarPID
RunAs, User, Password, Domain
Process, Cmd, PID-or-Name, Param3
Shutdown, Code
FileAppend, Text, Filename, Encoding
FileCopy, SourcePattern, DestPattern, Flag
FileCopyDir, Source, Dest, Flag
FileCreateDir, DirName
FileDelete, FilePattern
FileGetAttrib, OutputVar, Filename
FileGetSize, OutputVar, Filename, Units
FileGetTime, OutputVar, Filename, WhichTime
FileGetVersion, OutputVar, Filename
FileMove, SourcePattern, DestPattern, Flag
FileMoveDir, Source, Dest, Flag
FileRead, OutputVar, Filename
FileReadLine, OutputVar, Filename, LineNum
FileRecycle, FilePattern
FileRecycleEmpty, DriveLetter
FileRemoveDir, DirName, Recurse?
FileSelectFile, OutputVar, Options, RootDir\Filename, Prompt, Filter
FileSelectFolder, OutputVar, StartingFolder, Options, Prompt
FileSetAttrib, Attributes, FilePattern, OperateOnFolders?, Recurse?
FileSetTime, YYYYMMDDHH24MISS, FilePattern, WhichTime, OperateOnFolders?, Recurse?
Drive, Sub-command, Drive , Value
DriveGet, OutputVar, Cmd, Value
DriveSpaceFree, OutputVar, Path
Sort, VarName, Options
StringGetPos, OutputVar, InputVar, SearchText, L#|R#, Offset
StringLeft, OutputVar, InputVar, Count
StringRight, OutputVar, InputVar, Count
StringLen, OutputVar, InputVar
StringLower, OutputVar, InputVar, T
StringUpper, OutputVar, InputVar, T
StringMid, OutputVar, InputVar, StartChar, Count , L
StringReplace, OutputVar, InputVar, SearchText, ReplaceText, ReplaceAll? 
StringSplit, OutputArray, InputVar, Delimiters, OmitChars
StringTrimLeft, OutputVar, InputVar, Count
StringTrimRight, OutputVar, InputVar, Count
SplitPath, InputVar, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
Input, OutputVar, Options, EndKeys, MatchList
KeyWait, KeyName, Options
StatusBarWait, BarText, Seconds, Part#, WinTitle, WinText, Interval
ClipWait, SecondsToWait, 1
GetKeyState, OutputVar, KeyName, Mode
MouseGetPos, OutputVarX, OutputVarY, OutputVarWin, OutputVarControl, 1|2|3
PixelGetColor, OutputVar, X, Y, Alt|Slow|RGB
SysGet, OutputVar, Sub-command, Param3
StatusBarGetText, OutputVar, Part#, WinTitle, WinText, ExcludeTitle, ExcludeText
GroupAdd, GroupName, WinTitle, WinText, Label, ExcludeTitle, ExcludeText
GroupActivate, GroupName, R
GroupDeactivate, GroupName, R
GroupClose, GroupName, A|R
InputBox, OutputVar, Title, Prompt, HIDE, Width, Height, X, Y, Font, Timeout, Default
ToolTip, Text, X, Y, WhichToolTip
TrayTip, Title, Text, Seconds, Options
Progress, ProgressParam1, SubText, MainText, WinTitle, FontName
SplashImage, ImageFile, Options, SubText, MainText, WinTitle, FontName
SplashTextOn, Width, Height, Title, Text
SplashTextOff
RegRead, OutputVar, RootKey, SubKey, ValueName
RegWrite, ValueType, RootKey, SubKey, ValueName, Value
RegDelete, RootKey, SubKey, ValueName
SetRegView, RegView
IniRead, OutputVar, Filename, Section, Key, Default
IniWrite, Value, Filename, Section, Key
IniDelete, Filename, Section, Key
SoundBeep, Frequency, Duration
SoundGet, OutputVar, ComponentType, ControlType, DeviceNumber
SoundGetWaveVolume, OutputVar, DeviceNumber
SoundPlay, Filename, wait
SoundSet, NewSetting, ComponentType, ControlType, DeviceNumber
SoundSetWaveVolume, Percent, DeviceNumber
EnvAdd, Var, Value, TimeUnits
EnvSub, Var, Value, TimeUnits
EnvDiv, Var, Value
EnvMult, Var, Value
EnvGet, OutputVar, EnvVarName
EnvSet, EnvVar, Value
EnvUpdate
FormatTime, OutputVar, YYYYMMDDHH24MISS, Format
Transform, OutputVar, Cmd, Value1, Value2
Random, OutputVar, Min, Max
BlockInput, Mode
CoordMode, ToolTip|Pixel|Mouse|Caret|Menu, Screen|Window|Client
WinMenuSelectItem, WinTitle, WinText, Menu, SubMenu1, SubMenu2, SubMenu3, SubMenu4, SubMenu5, SubMenu6, ExcludeTitle, ExcludeText
SendLevel, Level
SetKeyDelay, Delay, PressDuration, Play
SetCapsLockState, State
SetNumLockState, State
SetScrollLockState, State
OutputDebug, Text
UrlDownloadToFile, URL, Filename
Break, LoopNumber
Continue, LoopNumber
Pause
Return
ExitApp
)"
Loop, Parse, FileCmd, `n
{
	Loop, Parse, A_LoopField, `,,%A_Space%
	{
		If A_Index = 1
			FileCmdList .= A_LoopField "|", fcmd := A_LoopField, Par := 1
			, FileCmdML .= A_LoopField ","
		Else
		{
			%fcmd%%Par% := A_LoopField
			Par++
		}
	}
	If A_Index = 1
		FileCmdList .= "|"
}

;##### Functions: #####

BuiltinFuncList := "
(Join$
Abs
ACos
Array
Asc
ASin
ATan
Ceil
Chr
ComObjActive
ComObjArray
ComObjConnect
ComObjCreate
ComObjEnwrap
ComObjError
ComObjFlags
ComObjGet
ComObjMissing
ComObjParameter
ComObjQuery
ComObjType
ComObjUnwrap
ComObjValue
Cos
DllCall
Exp
FileExist
FileOpen
Floor
Func
GetKeyName
GetKeySC
GetKeyState
GetKeyVK
InStr
Ln
Log
LTrim
Mod
NumGet
NumPut
RegExMatch
RegExReplace
Round
RTrim
Screenshot
Sin
Sqrt
StrGet
StrLen
StrPut
StrSplit
SubStr
Tan
Trim
WinActive
WinExist
)"

BuiltinFuncParams := "
(
Abs (Number)
ACos (Number)
Array (Value1, Value2, Value3...)
Asc (String)
ASin (Number)
ATan (Number)
Ceil (Number)
Chr (Number)
ComObjActive (CLSID)
ComObjArray (VarType, Count1 [, Count2, ... Count8])
ComObjConnect (ComObject [, Prefix])
ComObjCreate (CLSID [, IID])
ComObjEnwrap (DispPtr)
ComObjError ([Enable])
ComObjFlags (ComObject [, NewFlags, Mask])
ComObjGet (Name)
ComObjMissing ()
ComObjParameter (VarType, Value [, Flags])
ComObjQuery (ComObject, [SID,] IID)
ComObjType (ComObject)
ComObjUnwrap (ComObject)
ComObjValue (ComObject)
Cos (Number)
DllCall (""[DllFile\]Function"" [, Type1, Arg1, Type2, Arg2, ""Cdecl ReturnType""])
Exp (N)
FileExist (FilePattern)
FileOpen ()
Floor (Number)
Func (FunctionName)
GetKeyName (Key)
GetKeySC (Key)
GetKeyState (KeyName [, ""P"" or ""T""])
GetKeyVK (Key)
InStr (Haystack, Needle [, CaseSensitive = false, StartingPos = 1, Occurrence = 1])
Ln (Number)
Log (Number)
LTrim (String, OmitChars = "" `t"")
Mod (Dividend, Divisor)
NumGet (VarOrAddress [, Offset = 0][, Type = ""UPtr""])
NumPut (Number, VarOrAddress [, Offset = 0][, Type = ""UPtr""])
RegExMatch (Haystack, NeedleRegEx [, UnquotedOutputVar = "", StartingPos = 1])
RegExReplace (Haystack, NeedleRegEx [, Replacement = """", OutputVarCount = """", Limit = -1, StartingPos = 1])
Round (Number [, N])
RTrim (String, OmitChars = "" `t"")
Screenshot (FilePattern, X|Y|Width|Height)
Sin (Number)
Sqrt (Number)
StrGet (Address [, Length] [, Encoding = None ] )
StrLen (String)
StrPut (String, Address [, Length] [, Encoding = None ] )
StrSplit (String [, Delimiters, OmitChars])
SubStr (String, StartingPos [, Length])
Tan (Number)
Trim (String, OmitChars = "" `t"")
WinActive ([WinTitle, WinText, ExcludeTitle, ExcludeText])
WinExist ([WinTitle, WinText, ExcludeTitle, ExcludeText])
)"

Loop, Parse, BuiltinFuncParams, `n
{
	RegExMatch(A_LoopField, "(\w+)\s(\(.*\))", FuncT)
,	%FuncT1%_Hint := FuncT2
}

KeywordsList := "Type|Text|Mouse|Ctrl|Win|Misc|If|IE|Com|Func"
GoSub, SetFindCmd

;##### Messages: #####

MsgList := "
(
WM_NULL = 0x00
WM_CREATE = 0x01
WM_DESTROY = 0x02
WM_MOVE = 0x03
WM_SIZE = 0x05
WM_ACTIVATE = 0x06
WM_SETFOCUS = 0x07
WM_KILLFOCUS = 0x08
WM_ENABLE = 0x0A
WM_SETREDRAW = 0x0B
WM_SETTEXT = 0x0C
WM_GETTEXT = 0x0D
WM_GETTEXTLENGTH = 0x0E
WM_PAINT = 0x0F
WM_CLOSE = 0x10
WM_QUERYENDSESSION = 0x11
WM_QUIT = 0x12
WM_QUERYOPEN = 0x13
WM_ERASEBKGND = 0x14
WM_SYSCOLORCHANGE = 0x15
WM_ENDSESSION = 0x16
WM_SYSTEMERROR = 0x17
WM_SHOWWINDOW = 0x18
WM_CTLCOLOR = 0x19
WM_WININICHANGE = 0x1A
WM_SETTINGCHANGE = 0x1A
WM_DEVMODECHANGE = 0x1B
WM_ACTIVATEAPP = 0x1C
WM_FONTCHANGE = 0x1D
WM_TIMECHANGE = 0x1E
WM_CANCELMODE = 0x1F
WM_SETCURSOR = 0x20
WM_MOUSEACTIVATE = 0x21
WM_CHILDACTIVATE = 0x22
WM_QUEUESYNC = 0x23
WM_GETMINMAXINFO = 0x24
WM_PAINTICON = 0x26
WM_ICONERASEBKGND = 0x27
WM_NEXTDLGCTL = 0x28
WM_SPOOLERSTATUS = 0x2A
WM_DRAWITEM = 0x2B
WM_MEASUREITEM = 0x2C
WM_DELETEITEM = 0x2D
WM_VKEYTOITEM = 0x2E
WM_CHARTOITEM = 0x2F
WM_SETFONT = 0x30
WM_GETFONT = 0x31
WM_SETHOTKEY = 0x32
WM_GETHOTKEY = 0x33
WM_QUERYDRAGICON = 0x37
WM_COMPAREITEM = 0x39
WM_COMPACTING = 0x41
WM_WINDOWPOSCHANGING = 0x46
WM_WINDOWPOSCHANGED = 0x47
WM_POWER = 0x48
WM_COPYDATA = 0x4A
WM_CANCELJOURNAL = 0x4B
WM_NOTIFY = 0x4E
WM_INPUTLANGCHANGEREQUEST = 0x50
WM_INPUTLANGCHANGE = 0x51
WM_TCARD = 0x52
WM_HELP = 0x53
WM_USERCHANGED = 0x54
WM_NOTIFYFORMAT = 0x55
WM_CONTEXTMENU = 0x7B
WM_STYLECHANGING = 0x7C
WM_STYLECHANGED = 0x7D
WM_DISPLAYCHANGE = 0x7E
WM_GETICON = 0x7F
WM_SETICON = 0x80
WM_NCCREATE = 0x81
WM_NCDESTROY = 0x82
WM_NCCALCSIZE = 0x83
WM_NCHITTEST = 0x84
WM_NCPAINT = 0x85
WM_NCACTIVATE = 0x86
WM_GETDLGCODE = 0x87
WM_NCMOUSEMOVE = 0xA0
WM_NCLBUTTONDOWN = 0xA1
WM_NCLBUTTONUP = 0xA2
WM_NCLBUTTONDBLCLK = 0xA3
WM_NCRBUTTONDOWN = 0xA4
WM_NCRBUTTONUP = 0xA5
WM_NCRBUTTONDBLCLK = 0xA6
WM_NCMBUTTONDOWN = 0xA7
WM_NCMBUTTONUP = 0xA8
WM_NCMBUTTONDBLCLK = 0xA9
WM_KEYFIRST = 0x100
WM_KEYDOWN = 0x100
WM_KEYUP = 0x101
WM_CHAR = 0x102
WM_DEADCHAR = 0x103
WM_SYSKEYDOWN = 0x104
WM_SYSKEYUP = 0x105
WM_SYSCHAR = 0x106
WM_SYSDEADCHAR = 0x107
WM_KEYLAST = 0x108
WM_IME_STARTCOMPOSITION = 0x10D
WM_IME_ENDCOMPOSITION = 0x10E
WM_IME_COMPOSITION = 0x10F
WM_IME_KEYLAST = 0x10F
WM_INITDIALOG = 0x110
WM_COMMAND = 0x111
WM_SYSCOMMAND = 0x112
WM_TIMER = 0x113
WM_HSCROLL = 0x114
WM_VSCROLL = 0x115
WM_INITMENU = 0x116
WM_INITMENUPOPUP = 0x117
WM_MENUSELECT = 0x11F
WM_MENUCHAR = 0x120
WM_ENTERIDLE = 0x121
WM_CTLCOLORMSGBOX = 0x132
WM_CTLCOLOREDIT = 0x133
WM_CTLCOLORLISTBOX = 0x134
WM_CTLCOLORBTN = 0x135
WM_CTLCOLORDLG = 0x136
WM_CTLCOLORSCROLLBAR = 0x137
WM_CTLCOLORSTATIC = 0x138
WM_MOUSEFIRST = 0x200
WM_MOUSEMOVE = 0x200
WM_LBUTTONDOWN = 0x201
WM_LBUTTONUP = 0x202
WM_LBUTTONDBLCLK = 0x203
WM_RBUTTONDOWN = 0x204
WM_RBUTTONUP = 0x205
WM_RBUTTONDBLCLK = 0x206
WM_MBUTTONDOWN = 0x207
WM_MBUTTONUP = 0x208
WM_MBUTTONDBLCLK = 0x209
WM_MOUSEWHEEL = 0x20A
WM_MOUSEHWHEEL = 0x20E
WM_PARENTNOTIFY = 0x210
WM_ENTERMENULOOP = 0x211
WM_EXITMENULOOP = 0x212
WM_NEXTMENU = 0x213
WM_SIZING = 0x214
WM_CAPTURECHANGED = 0x215
WM_MOVING = 0x216
WM_POWERBROADCAST = 0x218
WM_DEVICECHANGE = 0x219
WM_MDICREATE = 0x220
WM_MDIDESTROY = 0x221
WM_MDIACTIVATE = 0x222
WM_MDIRESTORE = 0x223
WM_MDINEXT = 0x224
WM_MDIMAXIMIZE = 0x225
WM_MDITILE = 0x226
WM_MDICASCADE = 0x227
WM_MDIICONARRANGE = 0x228
WM_MDIGETACTIVE = 0x229
WM_MDISETMENU = 0x230
WM_ENTERSIZEMOVE = 0x231
WM_EXITSIZEMOVE = 0x232
WM_DROPFILES = 0x233
WM_MDIREFRESHMENU = 0x234
WM_IME_SETCONTEXT = 0x281
WM_IME_NOTIFY = 0x282
WM_IME_CONTROL = 0x283
WM_IME_COMPOSITIONFULL = 0x284
WM_IME_SELECT = 0x285
WM_IME_CHAR = 0x286
WM_IME_KEYDOWN = 0x290
WM_IME_KEYUP = 0x291
WM_MOUSEHOVER = 0x2A1
WM_NCMOUSELEAVE = 0x2A2
WM_MOUSELEAVE = 0x2A3
WM_CUT = 0x300
WM_COPY = 0x301
WM_PASTE = 0x302
WM_CLEAR = 0x303
WM_UNDO = 0x304
WM_RENDERFORMAT = 0x305
WM_RENDERALLFORMATS = 0x306
WM_DESTROYCLIPBOARD = 0x307
WM_DRAWCLIPBOARD = 0x308
WM_PAINTCLIPBOARD = 0x309
WM_VSCROLLCLIPBOARD = 0x30A
WM_SIZECLIPBOARD = 0x30B
WM_ASKCBFORMATNAME = 0x30C
WM_CHANGECBCHAIN = 0x30D
WM_HSCROLLCLIPBOARD = 0x30E
WM_QUERYNEWPALETTE = 0x30F
WM_PALETTEISCHANGING = 0x310
WM_PALETTECHANGED = 0x311
WM_HOTKEY = 0x312
WM_PRINT = 0x317
WM_PRINTCLIENT = 0x318
WM_HANDHELDFIRST = 0x358
WM_HANDHELDLAST = 0x35F
WM_PENWINFIRST = 0x380
WM_PENWINLAST = 0x38F
WM_COALESCE_FIRST = 0x390
WM_COALESCE_LAST = 0x39F
WM_DDE_FIRST = 0x3E0
WM_DDE_INITIATE = 0x3E0
WM_DDE_TERMINATE = 0x3E1
WM_DDE_ADVISE = 0x3E2
WM_DDE_UNADVISE = 0x3E3
WM_DDE_ACK = 0x3E4
WM_DDE_DATA = 0x3E5
WM_DDE_REQUEST = 0x3E6
WM_DDE_POKE = 0x3E7
WM_DDE_EXECUTE = 0x3E8
WM_DDE_LAST = 0x3E8
WM_USER = 0x400
WM_APP = 0x8000
)"

Loop, Parse, MsgList, `n
{
	Loop, Parse, A_LoopField, =, %A_Space%
		If InStr(A_LoopField, "_")
			Msg := A_LoopField, WM_Msgs .= A_LoopField "|"
		Else
			%Msg% := A_LoopField
}

Sort, WM_Msgs, D|

DefaultBar := {FileOpt: "Enabled AutoSize", File: ["New=" w_Lang040 ":41", "Open=" w_Lang041 ":42(Enabled Dropdown)", "Save=" w_Lang042 ":59(Enabled Dropdown)"
													, "", "Export=" w_Lang043 ":16", "Preview=" w_Lang044 ":49", "Options=" w_Lang045 ":43"]
			, RecPlayOpt: "Enabled AutoSize", RecPlay: ["Record=" w_Lang046 ":54(Enabled AutoSize Dropdown)"
																, "", "PlayStart=" w_Lang047 ":46(Enabled AutoSize Dropdown)", "TestRun=" w_Lang048 ":48", "RunTimer=" w_Lang049 ":71"]
			, CommandOpt: "Enabled AutoSize", Command: ["Mouse=" w_Lang050 ":38", "Text=" w_Lang051 ":70", "ControlCmd=" w_Lang053 ":7"
														, "", "Sleep=" w_Lang054 ":45", "MsgBox=" w_Lang055 ":11", "KeyWait=" w_Lang056 ":77"
														, "", "Window=" w_Lang057 ":79", "Image=" w_Lang058 ":27", "Run=" w_Lang059 ":58"
														, "", "ComLoop=" w_Lang060 ":36", "ComGoto=" w_Lang061 ":22", "AddLabel=" w_Lang062 ":34"
														, "", "IfSt=" w_Lang063 ":26", "AsVar=" w_Lang064 ":75", "AsFunc=" w_Lang065 ":21"
														, "", "IECom=" w_Lang066 ":25", "ComInt=" w_Lang067 ":4", "RunScrLet=" w_Lang068 ":76"
														, "", "SendMsg=" w_Lang069 ":61"
														, "", "CmdFind=" w_Lang091 ":92"]
			, SetOpt: "Enabled AutoSize", Settings: ["HideMainWin=" w_Lang013 ":80", "OnScCtrl=" w_Lang009 ":87"
														, "", "Capt=" w_Lang012 ":83", "CheckHkOn=" w_Lang014 ":82"
														, "", "OnFinish=" w_Lang020 ":20(Enabled WholeDropdown)", "SetWin=" t_Lang009 ":101"
														, "", "WinKey=" w_Lang070 ":88", "SetJoyButton=" w_Lang071 ":32"]
			, EditOpt: "Enabled AutoSize", Edit: ["EditButton=" w_Lang092 ":14"
														, "", "CutRows=" w_Lang080 ":9", "CopyRows=" w_Lang081 ":8", "PasteRows=" w_Lang082 ":44", "Remove=" w_Lang083 ":10"
														, "", "Undo=" w_Lang084 ":74", "Redo=" w_Lang085 ":56"
														, "" , "MoveUp=" w_Lang077 ":40", "MoveDn=" w_Lang078 ":39"
														, "", "Duplicate=" w_Lang079 ":13", "CopyTo=" w_Lang086 ":8(Enabled WholeDropdown)"
														, "", "EditColor=" w_Lang089 ":3", "EditComm=" w_Lang088 ":5", "FindReplace=" w_Lang087 ":19"
														, "", "TabPlus=" w_Lang072 ":66", "TabClose=" w_Lang073 ":68", "DuplicateList=" w_Lang074 ":69", "EditMacros=" w_Lang094 ":97"
														, "", "Import=" w_Lang075 ":28", "SaveCurrentList=" w_Lang076 ":67"]}
FixedBar :=	{PrevOpt: "Enabled AutoSize", Preview: ["PrevDock=" t_Lang124 ":17"
														, "", "PrevCopy=" c_Lang023 ":8", "PrevRefresh=" t_Lang014 ":90(Enabled Dropdown)"
														, "", "TabIndent=" t_Lang011 ":85", "TextWrap=" t_Lang052 ":96", "OnTop=" t_Lang016 ":81"
														, "", "EditScript=" t_Lang138 ":14"]
			, TextOpt: "Enabled AutoSize", Text: ["OpenT=" t_Lang126 ":42", "SaveT=" t_Lang127 ":59"
														, "", "CutT=" t_Lang128 ":9", "CopyT=" t_Lang129 ":8", "PasteT=" t_Lang130 ":44"
														, "", "SelAllT=" t_Lang131 ":99", "RemoveT=" t_Lang132 ":10"]
			, OSCOpt: "Enabled AutoSize", OSC: ["OSPlay=" t_Lang112 ":48", "OSStop=" t_Lang113 ":65", "ShowPlayMenu=" t_Lang114 ":47"
														, "", "RecStart=" t_Lang115 ":54", "RecStartNew=" t_Lang116 ":89", "ShowRecMenu=" t_Lang117 ":53"
														, "", "OSClear=" t_Lang118 ":10"
														, "", "ProgBarToggle=" t_Lang119 ":51"
														, "", "SlowKeyToggle=" t_Lang120 ":63", "FastKeyToggle=" t_Lang121 ":84"
														, "", "ToggleTB=" t_Lang122 ":98", "ShowHideTB=" t_Lang123 ":80"]}

TbFile_ID := 1, TbRecPlay_ID := 2, TbSettings_ID := 3, TbCommand_ID := 5, TbEdit_ID := 9

Loop, 26
	KeybdList .= Chr(A_Index+96) "¢" ((A_Index = 1) ? "¢" : "")
Loop, 26
	KeybdList .= Chr(A_Index+64) "¢"
Loop, 10
	KeybdList .= Chr(A_Index+47) "¢"
KeybdList .= "
(Join¢
Control¢LControl¢RControl¢Alt¢LAlt¢RAlt¢Shift¢LShift¢RShift¢LWin¢RWin
F1¢F2¢F3¢F4¢F5¢F6¢F7¢F8¢F9¢F10¢F11¢F12¢F13¢F14¢F15¢F16¢F17¢F18¢F19¢F20¢F21¢F22¢F23¢F24
'¢""¢!¢@¢#¢$¢%¢¨¢&¢*¢(¢)¢-¢_¢=¢+¢´¢``¢[¢]¢{¢}¢<¢>¢~¢^¢.¢,¢;¢:¢?¢/¢\¢|
Left¢Right¢Up¢Down¢Home¢End¢PgUp¢PgDn¢AppsKey¢PrintScreen¢Pause
Delete¢Insert¢Backspace¢Escape¢Enter¢Tab¢Space¢CapsLock¢ScrollLock¢NumLock
Numpad0¢Numpad1¢Numpad2¢Numpad3¢Numpad4¢Numpad5¢Numpad6¢Numpad7¢Numpad8¢Numpad9
NumpadDot¢NumpadDiv¢NumpadMult¢NumpadAdd¢NumpadSub¢NumpadIns¢NumpadEnd¢NumpadDown
NumpadPgDn¢NumpadLeft¢NumpadClear¢NumpadRight¢NumpadHome¢NumpadUp¢NumpadPgUp¢NumpadDel
NumpadEnter¢Browser_Back¢Browser_Forward¢Browser_Refresh¢Browser_Stop¢Browser_Search
Browser_Favorites¢Browser_Home¢Volume_Mute¢Volume_Down¢Volume_Up¢Media_Next¢Media_Prev
Media_Stop¢Media_Play_Pause¢Launch_Mail¢Launch_Media¢Launch_App1¢Launch_App2
LButton¢RButton¢MButton¢XButton1¢XButton2¢WheelDown¢WheelUp¢WheelLeft¢WheelRight
)"
