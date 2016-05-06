If A_OSVersion in WIN_2003,WIN_XP,WIN_2000
	_s := Chr(4445)
,	RecentFolder := A_AppData "\..\Recent"
Else
	_s := Chr(8239)
,	RecentFolder := A_AppData "\Microsoft\Windows\Recent"
_w := Chr(2), _x := Chr(3), _y := Chr(4), _z := Chr(5)

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
,	cType42 := "CommentBlock"
,	cType43 := "Expression"
,	cType44 := "Function"
,	cType45 := "For"
,	cType46 := "Method"
,	cType47 := "UserFunction"
,	cType48 := "FuncParameter"
,	cType49 := "FuncReturn"
,	cType50 := "SetTimer"
,	cType51 := "While"
,	cType52 := "SendEmail"
,	cType53 := "DownloadFiles"
,	cType54 := "Zip"
,	cType55 := "Unzip"

MAction1 := "Click"
,	MAction2 := "Move"
,	MAction3 := "Move & Click"
,	MAction4 := "Click & Drag"
,	MAction5 := "Mouse Wheel Up"
,	MAction6 := "Mouse Wheel Down"
,	ContHelp := { 3: ["PauseB", "MsgboxB", "KeyWaitB"]
			,	5: ["MouseB"]
			,	7: ["SpecialB"]
			,	8: ["TextB"]
			,	10: ["RunB"]
			,	11: ["WindowB"]
			,	12: ["ComLoopB", "ComGotoB", "TimedLabelB"]
			,	14: ["ExportG"]
			,	16: ["IfDirB"]
			,	19: ["ImageB"]
			,	21: ["IfStB", "AsVarB", "AsFuncB"]
			,	22: ["SendMsgB"]
			,	23: ["ControlB"]
			,	24: ["IEComB", "IEComB"]
			,	38: ["UserFuncB", "UserFuncB", "UserFuncB"]
			,	39: ["EmailB"]
			,	40: ["DownloadB", "ZipB"]}
,	ContHTitle := {	2: ["Preview.html"]
			,	3: ["Commands/Pause.html", "Commands/Message_Box.html", "Commands/KeyWait.html"]
			,	4: ["Settings.html", "Record.html#recording-options.", "Playback.html#playback-options", "Settings.html#defaults"
				, "Settings.html#screenshots", "Settings.html#email-accounts", "Settings.html#language"
				, "Settings.html#language-editor", "Settings.html#user-global-variables", "Settings.html#language-editor"]
			,	5: ["Commands/Mouse.html"]
			,	6: ["Main.html#edit"]
			,	7: ["Main.html#insert-/-modify"]
			,	8: ["Commands/Text.html"]
			,	10: ["Commands/Run.html"]
			,	11: ["Commands/Window.html"]
			,	12: ["Commands/Loop.html", "Commands/Goto_and_Gosub.html", "Commands/Set_Timer.html"
				, "Commands/Label.html"
				, "Commands/Loop_FilePattern.html",	"Commands/Loop_Parse.html", "Commands/Loop_Read.html", "Commands/Loop_Registry.html"
				, "Commands/While_Loop.html", "Commands/For_Loop.html"]
			,	14: ["Export.html"]
			,	16: ["Playback.html#context-sensitive-hotkeys"]
			,	19: ["Commands/Image_Search.html", "Commands/Pixel_Search.html"]
			,	21: ["Commands/If_Statements.html", "Commands/Variables.html", "Commands/Functions.html"]
			,	22: ["Commands/PostMessage_and_SendMessage.html"]
			,	23: ["Commands/Control.html"]
			,	24: ["Commands/Internet_Explorer.html", "Commands/Expression.html"]
			,	26: ["Commands.html#find-a-command"]
			,	27: ["Main.html#timer"]
			,	30: ["Variables.html#expressions"]
			,	34: ["Commands.html#find-a-command"]
			,	36: ["Main.html#schedule-macros"]
			,	38: ["Functions.html#user-defined-functions", "Functions.html#parameters", "Functions.html#return"]
			,	39: ["Commands/Send_Email.html"]
			,	40: ["Commands/Download_Files.html", "Commands/Zip_Files.html"] }

RecOptChecks := ["ClearNewList", "", "Strokes", "CaptKDn", "RecKeybdCtrl"
					, "", "Mouse", "MScroll", "Moves", "RecMouseCtrl"
					, "", "TimedI", "WClass", "WTitle"]
,	PlayOptChecks := ["ShowStep", "HideErrors", "MouseReturn", "ShowBarOnStart", "AutoHideBar", "RandomSleeps"]
,	OnFinishCode := 1
,	CopyMenuLabels := []
,	ScopedVars := {}
,	Static_Vars := {}
,	RegisteredTimers := []
,	LVManager := new LV_Rows()
,	LVManager.SetCallback("LVCallback")
,	Exp_Mult := {2:1, 4:2, 8:3, 16:4, 32:5, 64:6, 128:7, 256:8}
,	MsgBoxStyles := [1048576, 524288, 262144, 512, 256]
,	Email_Fields := ["email", "smtpserver", "smtpserverport", "sendusername", "sendpassword"
				,	"smtpauthenticate", "smtpusessl", "smtpconnectiontimeout", "sendusing"]

IconsNames := { "apply": 1
			,	"break": 2
			,	"color": 3
			,	"com": 4
			,	"comment": 5
			,	"continue": 6
			,	"control": 7
			,	"copy": 8
			,	"cut": 9
			,	"delete": 10
			,	"dialogs": 11
			,	"donate": 12
			,	"duplicate": 13
			,	"edit": 14
			,	"exit": 15
			,	"export": 16
			,	"expview": 17
			,	"files": 18
			,	"find": 19
			,	"finish": 20
			,	"functions": 21
			,	"goto": 22
			,	"group": 23
			,	"help": 24
			,	"ie": 25
			,	"ifstatements": 26
			,	"image": 27
			,	"import": 28
			,	"info": 29
			,	"ini": 30
			,	"insert": 31
			,	"joy": 32
			,	"expression": 33
			,	"labels": 34
			,	"userfunc": 35
			,	"loop": 36
			,	"misc": 37
			,	"mouse": 38
			,	"movedn": 39
			,	"moveup": 40
			,	"new": 41
			,	"open": 42
			,	"options": 43
			,	"paste": 44
			,	"pause": 45
			,	"play": 46
			,	"playopt": 47
			,	"playtest": 48
			,	"preview": 49
			,	"process": 50
			,	"progbar": 51
			,	"recent": 52
			,	"recopt": 53
			,	"record": 54
			,	"recpause": 55
			,	"redo": 56
			,	"registry": 57
			,	"run": 58
			,	"save": 59
			,	"screenshot": 60
			,	"sendmsg": 61
			,	"shutdown": 62
			,	"slowdown": 63
			,	"sound": 64
			,	"stop": 65
			,	"tabadd": 66
			,	"tabsave": 67
			,	"tabclose": 68
			,	"tabdup": 69
			,	"text": 70
			,	"timer": 71
			,	"tip_hi": 72
			,	"treeview": 73
			,	"undo": 74
			,	"variables": 75
			,	"paragraph": 76
			,	"wait": 77
			,	"warn": 78
			,	"window": 79
			,	"mintotray": 80
			,	"pin": 81
			,	"alwaysactive": 82
			,	"capt": 83
			,	"fastforward": 84
			,	"indent": 85
			,	"saveas": 86
			,	"toolbar": 87
			,	"winkey": 88
			,	"recordnew": 89
			,	"refresh": 90
			,	"keystroke": 91
			,	"findcmd": 92
			,	"dock": 93
			,	"string": 94
			,	"download": 95
			,	"wrap": 96
			,	"tabedit": 97
			,	"border": 98
			,	"select": 99
			,	"eyedropper": 100
			,	"context": 101
			,	"filter": 102
			,	"scheduler": 103
			,	"groups": 104
			,	"return": 105
			,	"undock": 106
			,	"parameter": 107
			,	"close": 108
			,	"extedit": 109
			,	"sort": 110
			,	"zip": 111
			,	"email": 112 }

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
		If (A_Index = 1)
			WinCmdList .= A_LoopField "|", Par := A_LoopField
	}
	If (A_Index = 1)
		WinCmdList .= "|"
}
Wcmd_All := "WinTitle, WinText, ExcludeTitle, ExcludeText"
,	Wcmd_Short := "Title, Text, ExclTitle, ExclText"

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
	Count := A_Index
	Loop, Parse, A_LoopField, |
	{
		If (A_Index = 1)
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

ExprOper := "
(
Assign
Add
Subtract
Multiply
Divide
Floor divide
Concatenate
Bitwise inclusive OR
Bitwise AND
Bitwise exclusive OR
Right shift AND
Left shift AND
)"
StringSplit, ExprOper, ExprOper, `n

IECmdList := "
(Join|
Checked
Click
Focus
GoBack
GoForward
GoHome
GoSearch
Height
Href
InnerHTML
InnerText
Length
LocationName
LocationURL
Navigate|
OuterHTML
Quit
Refresh
SelectedIndex
Src
Stop
Submit
Type
Value
Width
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
Click
ClientToWindow
ExecWB
Focus
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
Submit
)"
,	ProperList := "
(Join,
AddressBar
Application
Busy
Checked
Container
Document
FullName
FullScreen
HWND
Height
Href
InnerHTML
InnerText
Left
Length
LocationName
LocationURL
MenuBar
Name
Offline
OuterHTML
Parent
Path
ReadyState
RegisterAsBrowser
RegisterAsDropTarget
Resizable
SelectedIndex
Silent
Src
StatusBar
StatusText
TheaterMode
ToolBar
Top
TopLevelContainer
Type
Value
Visible
Width
)"
CLSList := " 
(Join|
Excel.Application
HTMLfile
InternetExplorer.Application|
MSXML2.DOMDocument.6.0
MSXML2.XMLHTTP
Outlook.Application
PowerPoint.Application
SAPI.SpVoice
Schedule.Service
ScriptControl
Scripting.Dictionary
Scripting.FileSystemObject
Shell.Application
Shell.Explorer
VBScript.RegExp
WMPlayer.OCX
WScript.Shell
WinHttp.WinHttpRequest.5.1
Winmgmt
Word.Application
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
FileCreateShortcut, Target, LinkFile, WorkingDir, Args, Description, IconFile, ShortcutKey, IconNumber, RunState
FileDelete, FilePattern
FileGetAttrib, OutputVar, Filename
FileGetShortcut, LinkFile, OutTarget, OutDir, OutArgs, OutDescription, OutIcon, OutIconNum, OutRunState
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
SendMode, Input|Play|Event|InputThenPlay
SetKeyDelay, Delay, PressDuration, Play
SetMouseDelay, Delay, Play
SetControlDelay, Delay
SetCapsLockState, State
SetNumLockState, State
SetScrollLockState, State
OutputDebug, Text
UrlDownloadToFile, URL, Filename
Break, LoopNumber
Continue, LoopNumber
Pause
Return
ListVars
ExitApp
)"
Loop, Parse, FileCmd, `n
{
	Loop, Parse, A_LoopField, `,,%A_Space%
	{
		If (A_Index = 1)
			FileCmdList .= A_LoopField "|", fcmd := A_LoopField, Par := 1
			, FileCmdML .= A_LoopField ","
		Else
		{
			%fcmd%%Par% := A_LoopField
			Par++
		}
	}
	If (A_Index = 1)
		FileCmdList .= "|"
}

AssignOperators := ":=$$+=$-=$*=$/=$//=$.=$|=$&=$^=$>>=$<<="

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
Format
Func
GetKeyName
GetKeySC
GetKeyState
GetKeyVK
InStr
Ln
LoadPicture
Log
LTrim
Mod
NumGet
NumPut
Object
Ord
RegExMatch
RegExReplace
Round
RTrim
Sin
Sqrt
StrGet
StrLen
StrPut
StrReplace
StrSplit
SubStr
Tan
Trim
Unzip
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
Format (FormatStr [, Values...])
Func (FunctionName)
GetKeyName (Key)
GetKeySC (Key)
GetKeyState (KeyName [, ""P"" or ""T""])
GetKeyVK (Key)
InStr (Haystack, Needle [, CaseSensitive = false, StartingPos = 1, Occurrence = 1])
Ln (Number)
LoadPicture (Filename [, Options, ByRef ImageType])
Log (Number)
LTrim (String, OmitChars = "" `t"")
Mod (Dividend, Divisor)
NumGet (VarOrAddress [, Offset = 0][, Type = ""UPtr""])
NumPut (Number, VarOrAddress [, Offset = 0][, Type = ""UPtr""])
Object ()
Ord (String)
RegExMatch (Haystack, NeedleRegEx [, UnquotedOutputVar = "", StartingPos = 1])
RegExReplace (Haystack, NeedleRegEx [, Replacement = """", OutputVarCount = """", Limit = -1, StartingPos = 1])
Round (Number [, N])
RTrim (String, OmitChars = "" `t"")
Sin (Number)
Sqrt (Number)
StrGet (Address [, Length] [, Encoding = None])
StrLen (String)
StrPut (String, Address [, Length] [, Encoding = None])
StrReplace (Haystack, SearchText [, ReplaceText, OutputVarCount, Limit := -1])
StrSplit (String [, Delimiters, OmitChars])
SubStr (String, StartingPos [, Length])
Tan (Number)
Trim (String, OmitChars = "" `t"")
Unzip (Sources, OutDir [, SeparateFolders])
WinActive ([WinTitle, WinText, ExcludeTitle, ExcludeText])
WinExist ([WinTitle, WinText, ExcludeTitle, ExcludeText])
Delete (Key / FirstKey, LastKey)
HasKey (Key)
InsertAt (Pos, Value1 [, Value2, ... ValueN])
Length ()
MaxIndex ()
MinIndex ()
RemoveAt (Pos [, Length])
Pop ()
Push ([Value, Value2, ..., ValueN])
)"

ArrayMethodsList := "
(Join$
Delete
HasKey
InsertAt
Length
MaxIndex
MinIndex
RemoveAt
Pop
Push
)"

Loop, Parse, BuiltinFuncParams, `n
{
	RegExMatch(A_LoopField, "(\w+)\s(\(.*\))", FuncT)
,	%FuncT1%_Hint := FuncT2
}

KeywordsList := "Type|Text|Mouse|Ctrl|Win|Misc|If|IE|Com|Func|Meth"
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
		If (InStr(A_LoopField, "_"))
			Msg := A_LoopField, WM_Msgs .= A_LoopField "|"
		Else
			%Msg% := A_LoopField
}

Sort, WM_Msgs, D|

DefaultBar := {FileOpt: "Enabled AutoSize", File: ["New=" w_Lang040 ":41", "Open=" w_Lang041 ":42(Enabled Dropdown)", "Save=" w_Lang042 ":59", "SaveAs=" w_Lang043 ":86"
													, "", "Export=" w_Lang044 ":16", "Preview=" w_Lang045 ":49", "Options=" w_Lang046 ":43"]
			, RecPlayOpt: "Enabled AutoSize", RecPlay: ["Record=" w_Lang047 ":54(Enabled AutoSize Dropdown)"
																, "", "PlayStart=" w_Lang048 ":46(Enabled AutoSize Dropdown)", "TestRun=" w_Lang049 ":48", "RunTimer=" w_Lang050 ":71"]
			, CommandOpt: "Enabled AutoSize", Command: ["Mouse=" w_Lang051 ":38", "Text=" w_Lang052 ":70", "ControlCmd=" w_Lang054 ":7"
														, "", "Sleep=" w_Lang055 ":45", "MsgBox=" w_Lang056 ":11", "KeyWait=" w_Lang057 ":77"
														, "", "Window=" w_Lang058 ":79", "Image=" w_Lang059 ":27", "Run=" w_Lang060 ":58"
														, "", "ComLoop=" w_Lang061 ":36", "ComGoto=" w_Lang062 ":22", "TimedLabel=" w_Lang063 ":71"
														, "", "IfSt=" w_Lang064 ":26", "AsVar=" w_Lang065 ":75", "AsFunc=" w_Lang066 ":21"
														, "", "Email=" w_Lang067 ":112", "DownloadFiles=" w_Lang068 ":95", "ZipFiles=" w_Lang069 ":111"
														, "", "IECom=" w_Lang070 ":25", "ComInt=" w_Lang071 ":33", "SendMsg=" w_Lang072 ":61"
														, "", "CmdFind=" w_Lang092 ":92"]
			, SetOpt: "Enabled AutoSize", Settings: ["HideMainWin=" w_Lang013 ":80", "OnScCtrl=" w_Lang009 ":87"
														, "", "Capt=" w_Lang012 ":83", "CheckHkOn=" w_Lang014 ":82"
														, "", "OnFinish=" w_Lang020 ":20(Enabled WholeDropdown)", "SetWin=" t_Lang009 ":101"
														, "", "WinKey=" w_Lang109 ":88", "SetJoyButton=" w_Lang110 ":32"]
			, EditOpt: "Enabled AutoSize", Edit: ["EditButton=" w_Lang093 ":14", "CutRows=" w_Lang081 ":9", "CopyRows=" w_Lang082 ":8", "PasteRows=" w_Lang083 ":44", "Remove=" w_Lang084 ":10"
														, "", "Duplicate=" w_Lang080 ":13", "SelectMenu=" t_Lang139 ":99(Enabled WholeDropdown)", "CopyTo=" w_Lang087 ":8(Enabled WholeDropdown)"
														, "", "GroupsMode=" w_Lang097 ":104(Enabled AutoSize Dropdown)"
														, "", "MoveUp=" w_Lang078 ":40", "MoveDn=" w_Lang079 ":39"
														, "", "Undo=" w_Lang085 ":74", "Redo=" w_Lang086 ":56"
														, "", "FindReplace=" w_Lang088 ":19", "EditComm=" w_Lang089 ":5", "EditColor=" w_Lang090 ":3"
														, "", "TabPlus=" w_Lang073 ":66", "TabClose=" w_Lang074 ":68", "DuplicateList=" w_Lang075 ":69", "EditMacros=" w_Lang053 ":97"
														, "", "Import=" w_Lang076 ":28", "SaveCurrentList=" w_Lang077 ":67"
														, "", "UserFunction=" w_Lang104 ":35", "FuncParameter=" w_Lang105 ":107", "FuncReturn=" w_Lang106 ":105"]}
FixedBar :=	{PrevOpt: "Enabled AutoSize", Preview: ["PrevCopy=" c_Lang023 ":8", "PrevRefreshButton=" t_Lang014 ":90(Enabled Dropdown)"
														, "", "TabIndent=" t_Lang011 ":85(Enabled Dropdown)", "ConvertBreaks=" t_Lang190 ":76", "CommentUnchecked=" w_Lang108 ":5", "TextWrap=" t_Lang052 ":96"
														, "", "EditScript=" t_Lang138 ":109", "PrevDock=" t_Lang124 ":106", "Preview=" c_Lang022 ":108"]
			, PreviewF: ["PrevCopy=" c_Lang023 ":8", "PrevRefreshButton=" t_Lang014 ":90(Enabled Dropdown)"
														, "", "TabIndent=" t_Lang011 ":85(Enabled Dropdown)", "ConvertBreaks=" t_Lang190 ":76", "CommentUnchecked=" w_Lang108 ":5", "TextWrap=" t_Lang052 ":96", "OnTop=" t_Lang016 ":81"
														, "", "EditScript=" t_Lang138 ":109", "PrevDock=" t_Lang125 ":93"]
			, TextOpt: "Enabled AutoSize", Text: ["OpenT=" t_Lang126 ":42", "SaveT=" t_Lang127 ":59"
														, "", "CutT=" t_Lang128 ":9", "CopyT=" t_Lang129 ":8", "PasteT=" t_Lang130 ":44"
														, "", "RemoveT=" t_Lang132 ":10", "SelAllT=" t_Lang131 ":99"]
			, OSCOpt: "Enabled AutoSize", OSC: ["OSPlay=" t_Lang112 ":48", "OSStop=" t_Lang113 ":65", "ShowPlayMenu=" t_Lang114 ":47"
														, "", "RecStart=" t_Lang115 ":54", "RecStartNew=" t_Lang116 ":89", "ShowRecMenu=" t_Lang117 ":53"
														, "", "OSClear=" t_Lang118 ":10"
														, "", "ProgBarToggle=" t_Lang119 ":51"
														, "", "SlowKeyToggle=" t_Lang121 ":63", "FastKeyToggle=" t_Lang120 ":84"
														, "", "ToggleTB=" t_Lang122 ":98", "ShowHideTB=" t_Lang123 ":80"]}

TbFile_ID := 1, TbRecPlay_ID := 2, TbCommand_ID := 3, TbEdit_ID := 4, TbSettings_ID := 5

Loop, 26
	KeybdList .= Chr(A_Index+96) _x ((A_Index = 1) ? _x : "")
Loop, 26
	KeybdList .= Chr(A_Index+64) _x
Loop, 10
	KeybdList .= Chr(A_Index+47) _x
KeybdList .= "Control" _x "LControl" _x "RControl" _x "Alt" _x "LAlt" _x "RAlt" _x "Shift" _x "LShift" _x "RShift" _x "LWin" _x "RWin"
. _x "F1" _x "F2" _x "F3" _x "F4" _x "F5" _x "F6" _x "F7" _x "F8" _x "F9" _x "F10" _x "F11" _x "F12" _x "F13" _x "F14" _x "F15" _x "F16" _x "F17" _x "F18" _x "F19" _x "F20" _x "F21" _x "F22" _x "F23" _x "F24"
. _x "'" _x """" _x "!" _x "@" _x "#" _x "$" _x "%" _x "¨" _x "&" _x "*" _x "(" _x ")" _x "-" _x "_" _x "=" _x "+" _x "´" _x "``" _x "[" _x "]" _x "{" _x "}" _x "<" _x ">" _x "~" _x "^" _x "." _x "," _x ";" _x ":" _x "?" _x "/" _x "\" _x "|"
. _x "Left" _x "Right" _x "Up" _x "Down" _x "Home" _x "End" _x "PgUp" _x "PgDn" _x "AppsKey" _x "PrintScreen" _x "Pause"
. _x "Delete" _x "Insert" _x "Backspace" _x "Escape" _x "Enter" _x "Tab" _x "Space" _x "CapsLock" _x "ScrollLock" _x "NumLock"
KeybdList .= _x "Numpad0" _x "Numpad1" _x "Numpad2" _x "Numpad3" _x "Numpad4" _x "Numpad5" _x "Numpad6" _x "Numpad7" _x "Numpad8" _x "Numpad9"
. _x "NumpadDot" _x "NumpadDiv" _x "NumpadMult" _x "NumpadAdd" _x "NumpadSub" _x "NumpadIns" _x "NumpadEnd" _x "NumpadDown"
. _x "NumpadPgDn" _x "NumpadLeft" _x "NumpadClear" _x "NumpadRight" _x "NumpadHome" _x "NumpadUp" _x "NumpadPgUp" _x "NumpadDel"
. _x "NumpadEnter" _x "Browser_Back" _x "Browser_Forward" _x "Browser_Refresh" _x "Browser_Stop" _x "Browser_Search"
. _x "Browser_Favorites" _x "Browser_Home" _x "Volume_Mute" _x "Volume_Down" _x "Volume_Up" _x "Media_Next" _x "Media_Prev"
. _x "Media_Stop" _x "Media_Play_Pause" _x "Launch_Mail" _x "Launch_Media" _x "Launch_App1" _x "Launch_App2"
. _x "LButton" _x "RButton" _x "MButton" _x "XButton1" _x "XButton2" _x "WheelDown" _x "WheelUp" _x "WheelLeft" _x "WheelRight"

Run_Filters := "All|File|String|Get|Wait|Group|Dialogs|Registry|Sound|Vars|Misc"
Loop, Parse, Run_Filters, |
	Run_Filter_%A_Index% := A_LoopField
SchedTypes := "1|2|3|4|8|9|6"
Loop, Parse, SchedTypes, |
	Sched_%A_Index% := A_LoopField

BIV_Characters := "
(
A_Space
A_Tab
)"

BIV_Properties := "
(
A_AhkPath
A_AhkVersion
A_ExitReason
A_IsCompiled
A_IsUnicode
A_LineFile
A_LineNumber
A_ScriptDir
A_ScriptFullPath
A_ScriptHwnd
A_ScriptName
A_ThisFunc
A_ThisLabel
A_WorkingDir
)"

BIV_Date := "
(
A_DD
A_DDD
A_DDDD
A_Hour
A_MM
A_MMM
A_MMMM
A_MSec
A_Min
A_Now
A_NowUTC
A_Sec
A_TickCount
A_WDay
A_YDay
A_YWeek
A_YYYY
)"

BIV_Idle := "
(
A_TimeIdle
A_TimeIdlePhysical
)"

BIV_System := "
(
A_AppData
A_AppDataCommon
A_ComputerName
A_Desktop
A_DesktopCommon
A_IPAddress1
A_Is64bitOS
A_IsAdmin
A_Language
A_MyDocuments
A_OSType
A_OSVersion
A_ProgramFiles
A_Programs
A_ProgramsCommon
A_PtrSize
A_ScreenDPI
A_ScreenHeight
A_ScreenWidth
A_StartMenu
A_StartMenuCommon
A_Startup
A_StartupCommon
A_Temp
A_UserName
A_WinDir
ComSpec
)"

BIV_Misc := "
(
A_CaretX
A_CaretY
A_Cursor
A_LastError
Clipboard
ClipboardAll
ErrorLevel
)"

BIV_Loop := "
(
A_Index
A_LoopField
A_LoopFileAttrib
A_LoopFileDir
A_LoopFileExt
A_LoopFileFullPath
A_LoopFileLongPath
A_LoopFileName
A_LoopFileShortName
A_LoopFileShortPath
A_LoopFileSize
A_LoopFileSizeKB
A_LoopFileSizeMB
A_LoopFileTimeAccessed
A_LoopFileTimeCreated
A_LoopFileTimeModified
A_LoopReadLine
A_LoopRegKey
A_LoopRegName
A_LoopRegSubKey
A_LoopRegTimeModified
A_LoopRegType
)"

BuiltinVars := StrReplace(BIV_Characters, "`n", ",")
			. StrReplace(BIV_Properties, "`n", ",")
			. StrReplace(BIV_Date, "`n", ",")
			. StrReplace(BIV_Idle, "`n", ",")
			. StrReplace(BIV_System, "`n", ",")
			. StrReplace(BIV_Misc, "`n", ",")
			. StrReplace(BIV_Loop, "`n", ",")

FuncWhiteList := "Gdip_,Screenshot,CDO,Zip,CreateZipFile,WinHttpDownloadToFile,CenterImgSrchCoords,Dlg_,IEGet,IELoad,WBGet,ScheduleTask"
