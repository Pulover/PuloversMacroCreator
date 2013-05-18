If A_OSVersion in WIN_NT4,WIN_95,WIN_98,WIN_ME
{
	MsgBox This program requires Windows 2000/XP or later.
	ExitApp
}

EnvGet, SysRoot, SystemRoot

comres := SysRoot "\System32\comres.dll"
DDORes := SysRoot "\System32\DDORes.dll"
imageres := SysRoot "\System32\imageres.dll"
miguiresource := SysRoot "\System32\miguiresource.dll"
msctf := SysRoot "\System32\msctf.dll"
pifmgr := SysRoot "\System32\pifmgr.dll"
psr := SysRoot "\System32\psr.exe"
regedit := SysRoot "\regedit.exe"
setupapi := SysRoot "\System32\setupapi.dll"
shell32 := SysRoot "\System32\shell32.dll"
urlmon := SysRoot "\System32\urlmon.dll"
mmcndmgr := SysRoot "\System32\mmcndmgr.dll"
servdeps := SysRoot "\System32\servdeps.dll"
shimgvw := SysRoot "\System32\shimgvw.dll"
browseui := SysRoot "\System32\browseui.dll"
gcdef := SysRoot "\System32\gcdef.dll"
netcfgx := SysRoot "\System32\netcfgx.dll"
cscdll := SysRoot "\System32\cscdll.dll"
Mmsys := SysRoot "\System32\Mmsys.cpl"
inetcpl := SysRoot "\System32\inetcpl.cpl"
Timedate := SysRoot "\System32\Timedate.cpl"
xpsp2res := SysRoot "\System32\xpsp2res.dll"

If A_OSVersion in WIN_8
{
	IconFile := shell32
	HelpIconQ := 24
	HelpIconI := 222
	WarnIcon := 78
	HelpIconB := [shell32, 23]
	NewIcon := [imageres, 2]
	OpenIcon := [shell32, 45]
	SaveIcon := [shell32, 258]
	ExportIcon := [shell32, 68]
	PreviewIcon := [shell32, 22]
	OptionsIcon := [imageres, 109]
	DonateIcon := [shell32, 28]
	MouseIcon := [DDORes, 27]
	TextIcon := [DDORes, 26]
	SpecIcon := [DDORes, 1]
	ControlIcon := [DDORes, 28]
	PauseIcon := [shell32, 265]
	PauseIconB := [psr, 2]
	t_PauseIcon := [psr, 3]
	WindowIcon := [shell32, 2]
	ImageIcon := [shell32, 318]
	RunIcon := [shell32, 24]
	LoopIcon := [shell32, 238]
	IfStIcon := [shell32, 165]
	IEIcon := [shell32, 242]
	RecordIcon := [psr, 1]
	t_RecordIcon := [psr, 2]
	PlayIcon := [shell32, 137]
	t_PlayIcon := [shell32, 138]
	TestRunIcon := [psr, 3]
	RecStopIcon := [psr, 5]
	RunTimerIcon := [miguiresource, 1]
	PlusIcon := [shell32, 279]
	CloseIcon := [shell32, 234]
	DuplicateLIcon := [shell32, 278]
	InsertIcon := [shell32, 146]
	ApplyIcon := [urlmon, 0]
	ImportIcon := [imageres, 176]
	SaveLIcon := [shell32, 280]
	ContextIcon := [shell32, 261]
	RemoveIcon := [shell32, 131]
	DuplicateIcon := [shell32, 54]
	CopyIcon := [shell32, 134]
	CutIcon := [shell32, 259]
	PasteIcon := [shell32, 260]
	UndoIcon := [msctf, 14]
	RedoIcon := [comres, 4]
	MoveUpIcon := [shell32, 246]
	MoveDnIcon := [shell32, 247]
	EditIcon := [comres, 6]
	CommentIcon := [shell32, 133]
	FindIcon := [shell32, 55]
	ListVarsIcon := [shell32, 269]
	ExitIcon := [imageres, 218]
	RecentIcon := [shell32, 20]
	ProgBIcon := [shell32, 249]
	RecentFolder := A_AppData "\Microsoft\Windows\Recent"
	LVIcons := {1 : [DDORes, 27]	; Text
			, 	2 : [DDORes, 28]	; Mouse
			, 	3 : [shell32, 266]	; Pause
			, 	4 : [shell32, 239]	; Loop
			, 	5 : [shell32, 25]	; Run
			, 	6 : [shell32, 167]	; IfStatement
			, 	7 : [shell32, 318]	; Image
			, 	8 : [shell32, 3]	; Window
			, 	9 : [DDORes, 29]	; Control
			, 	10: [shell32, 243]	; IE
			, 	11: [DDORes, 1]		; Label
			, 	12: [DDORes, 35]	; Goto
			, 	13: [shell32, 157]	; SendMsg
			, 	14: [shell32, 76]	; Variables
			, 	15: [shell32, 167]	; Functions
			, 	16: [shell32, 127]	; File
			, 	17: [shell32, 134]	; String
			, 	18: [shell32, 278]	; Info
			, 	19: [comres, 6]		; Wait
			, 	20: [imageres, 1]	; Group
			, 	21: [shell32, 222]	; Dialog
			, 	22: [shell32, 70]	; Ini
			, 	23: [shell32, 73]	; Misc
			, 	24: [shell32, 162]	; Pixel
			, 	25: [comres, 4]		; COM
			, 	26: [comres, 16]	; Break
			, 	27: [shell32, 177]	; Continue
			, 	28: [shell32, 28]	; Shutdown
			, 	29: [imageres, 145]	; Process
			, 	30: [DDORes, 2]		; Sound
			, 	31: [regedit, 1]}	; Reg
}

If A_OSVersion in WIN_7,WIN_VISTA
{
	IconFile := shell32
	HelpIconQ := 24
	HelpIconI := 222
	WarnIcon := 78
	HelpIconB := [shell32, 23]
	NewIcon := [imageres, 2]
	OpenIcon := [shell32, 45]
	SaveIcon := [shell32, 258]
	ExportIcon := [shell32, 68]
	PreviewIcon := [shell32, 22]
	OptionsIcon := [imageres, 109]
	DonateIcon := [shell32, 28]
	MouseIcon := [DDORes, 27]
	TextIcon := [DDORes, 26]
	SpecIcon := [DDORes, 1]
	ControlIcon := [DDORes, 28]
	PauseIcon := [shell32, 265]
	PauseIconB := [psr, 2]
	t_PauseIcon := [psr, 3]
	WindowIcon := [shell32, 2]
	ImageIcon := [shell32, 302]
	RunIcon := [shell32, 24]
	LoopIcon := [shell32, 238]
	IfStIcon := [shell32, 165]
	IEIcon := [shell32, 242]
	RecordIcon := [psr, 1]
	t_RecordIcon := [psr, 2]
	PlayIcon := [shell32, 137]
	t_PlayIcon := [shell32, 138]
	TestRunIcon := [psr, 3]
	RecStopIcon := [psr, 5]
	RunTimerIcon := [miguiresource, 1]
	PlusIcon := [shell32, 279]
	CloseIcon := [shell32, 234]
	DuplicateLIcon := [shell32, 278]
	ImportIcon := [imageres, 176]
	SaveLIcon := [shell32, 280]
	ContextIcon := [shell32, 261]
	RemoveIcon := [shell32, 131]
	DuplicateIcon := [shell32, 54]
	InsertIcon := [shell32, 146]
	ApplyIcon := [urlmon, 0]
	CopyIcon := [shell32, 134]
	CutIcon := [shell32, 259]
	PasteIcon := [shell32, 260]
	UndoIcon := [msctf, 14]
	RedoIcon := [comres, 4]
	MoveUpIcon := [shell32, 246]
	MoveDnIcon := [shell32, 247]
	EditIcon := [comres, 6]
	CommentIcon := [shell32, 133]
	FindIcon := [shell32, 55]
	ListVarsIcon := [shell32, 269]
	ExitIcon := [imageres, 218]
	RecentIcon := [shell32, 20]
	ProgBIcon := [shell32, 249]
	RecentFolder := A_AppData "\Microsoft\Windows\Recent"
	LVIcons := {1 : [DDORes, 27]	; Text
			, 	2 : [DDORes, 28]	; Mouse
			, 	3 : [shell32, 266]	; Pause
			, 	4 : [shell32, 239]	; Loop
			, 	5 : [shell32, 25]	; Run
			, 	6 : [shell32, 166]	; IfStatement
			, 	7 : [shell32, 303]	; Image
			, 	8 : [shell32, 3]	; Window
			, 	9 : [DDORes, 29]	; Control
			, 	10: [shell32, 243]	; IE
			, 	11: [DDORes, 1]		; Label
			, 	12: [DDORes, 35]	; Goto
			, 	13: [shell32, 157]	; SendMsg
			, 	14: [shell32, 76]	; Variables
			, 	15: [shell32, 167]	; Functions
			, 	16: [shell32, 127]	; File
			, 	17: [shell32, 134]	; String
			, 	18: [shell32, 278]	; Info
			, 	19: [comres, 6]		; Wait
			, 	20: [imageres, 1]	; Group
			, 	21: [shell32, 222]	; Dialog
			, 	22: [shell32, 70]	; Ini
			, 	23: [shell32, 73]	; Misc
			, 	24: [shell32, 162]	; Pixel
			, 	25: [comres, 4]		; COM
			, 	26: [comres, 16]	; Break
			, 	27: [shell32, 177]	; Continue
			, 	28: [shell32, 28]	; Shutdown
			, 	29: [imageres, 145]	; Process
			, 	30: [DDORes, 2]		; Sound
			, 	31: [regedit, 1]}	; Reg
}

If A_OSVersion in WIN_2003,WIN_XP,WIN_2000
{
	IconFile := shell32
	HelpIconQ := 24
	HelpIconI := 222
	WarnIcon := 78
	HelpIconB := [shell32, 23]
	NewIcon := [shell32, 100]
	OpenIcon := [shell32, 4]
	SaveIcon := [shell32, 78]
	ExportIcon := [shell32, 66]
	PreviewIcon := [shell32, 22]
	OptionsIcon := [shell32, 165]
	DonateIcon := [shell32, 28]
	MouseIcon := [setupapi, 1]
	TextIcon := [setupapi, 2]
	SpecIcon := [Mmsys, 0]
	ControlIcon := [shell32, 192]
	PauseIcon := [mmcndmgr, 14]
	PauseIconB := [mmcndmgr, 34]
	t_PauseIcon := [shell32, 21]
	WindowIcon := [shell32, 2]
	ImageIcon := [shimgvw, 1]
	RunIcon := [shell32, 24]
	LoopIcon := [xpsp2res, 53]
	IfStIcon := [setupapi, 22]
	IEIcon := [shell32, 220]
	RecordIcon := [gcdef, 1]
	t_RecordIcon := [gcdef, 1]
	PlayIcon := [shell32, 137]
	t_PlayIcon := [shell32, 138]
	TestRunIcon := [browseui, 1]
	RecStopIcon := [shell32, 109]
	RunTimerIcon := [Timedate, 0]
	PlusIcon := [inetcpl, 21]
	CloseIcon := [inetcpl, 22]
	DuplicateLIcon := [shell32, 54]
	InsertIcon := [shell32, 146]
	ApplyIcon := [shell32, 144]
	ImportIcon := [shell32, 147]
	SaveLIcon := [shell32, 78]
	ContextIcon := [xpsp2res, 12]
	RemoveIcon := [shell32, 131]
	DuplicateIcon := [shell32, 54]
	CopyIcon := [shell32, 134]
	CutIcon := [cscdll, 10]
	PasteIcon := [shell32, 110]
	UndoIcon := [mmcndmgr, 31]
	RedoIcon := [mmcndmgr, 3]
	MoveUpIcon := [netcfgx, 0]
	MoveDnIcon := [netcfgx, 1]
	EditIcon := [pifmgr, 17]
	CommentIcon := [shell32, 133]
	FindIcon := [shell32, 55]
	ListVarsIcon := [shell32, 75]
	ExitIcon := [xpsp2res, 0]
	RecentIcon := [xpsp2res, 7]
	ProgBIcon := [shell32, 176]
	RecentFolder := A_AppData "\..\Recent"
	LVIcons := {1 : [setupapi, 3]	; Text
			, 	2 : [setupapi, 2]	; Mouse
			, 	3 : [shell32, 21]	; Pause
			, 	4 : [xpsp2res, 54]	; Loop
			, 	5 : [shell32, 25]	; Run
			, 	6 : [setupapi, 23]	; IfStatement
			, 	7 : [shell32, 128]	; Image
			, 	8 : [shell32, 3]	; Window
			, 	9 : [shell32, 193]	; Control
			, 	10: [shell32, 221]	; IE
			, 	11: [shell32, 228]	; Label
			, 	12: [shell32, 226]	; Goto
			, 	13: [shell32, 157]	; SendMsg
			, 	14: [shell32, 76]	; Variables
			, 	15: [shell32, 167]	; Functions
			, 	16: [shell32, 127]	; File
			, 	17: [shell32, 134]	; String
			, 	18: [shell32, 56]	; Info
			, 	19: [servdeps, 3]	; Wait
			, 	20: [shell32, 99]	; Group
			, 	21: [shell32, 222]	; Dialog
			, 	22: [shell32, 70]	; Ini
			, 	23: [shell32, 73]	; Misc
			, 	24: [shell32, 162]	; Pixel
			, 	25: [setupapi, 14]	; COM
			, 	26: [shell32, 110]	; Break
			, 	27: [shell32, 177]	; Continue
			, 	28: [shell32, 28]	; Shutdown
			, 	29: [shell32, 72]	; Process
			, 	30: [Mmsys, 1]		; Sound
			, 	31: [regedit, 1]}	; Reg
}

_s := Chr(8239)
ListCount1 := 0
TabCount := 1
FastKeyOn := 0
SlowKeyOn := 0
cType1 := "Send"
cType2 := "ControlSend"
cType3 := "Click"
cType4 := "ControlClick"
cType5 := "Sleep"
cType6 := "MsgBox"
cType7 := "Loop"
cType8 := "SendRaw"
cType9 := "ControlSendRaw"
cType10 := "ControlSetText"
cType11 := "Run"
cType12 := "Clipboard"
cType13 := "SendEvent"
cType14 := "RunWait"
cType15 := "PixelSearch"
cType16 := "ImageSearch"
cType17 := "If Statement"
cType18 := "SendMessage"
cType19 := "PostMessage"
cType20 := "KeyWait"
cType21 := "Variable"
cType22 := "ControlEditPaste"
cType23 := "ControlGetText"
cType24 := "Control"
cType25 := "ControlFocus"
cType26 := "ControlMove"
cType27 := "ControlGetFocus"
cType28 := "ControlGet"
cType29 := "Break"
cType30 := "Continue"
cType31 := "ControlGetPos"
cType32 := "IECOM_Set"
cType33 := "IECOM_Get"
cType34 := "COMInterface"
cType35 := "Label"
cType36 := "Goto"
cType37 := "Gosub"
cType38 := "LoopRead"
cType39 := "LoopParse"
cType40 := "LoopFilePattern"
cType41 := "LoopRegistry"

Action1 := "Click"
Action2 := "Move"
Action3 := "Move & Click"
Action4 := "Click & Drag"
Action5 := "Mouse Wheel Up"
Action6 := "Mouse Wheel Down"
Help5 := "MouseB"
Help8 := "TextB"
Help7 := "SpecialB"
Help14 := "ExportG"
Help3 := "PauseB"
Help11 := "WindowB"
Help16 := "IfDirB"
Help19 := "ImageB"
Help10 := "RunB"
Help12 := "ComLoopB"
Help21 := "IfStB"
Help22 := "SendMsgB"
Help23 := "ControlB"
Help24 := "IEComB"
ContHTitle := {	2: ["p6-Preview"]
			,	3: ["Commands/Pause", "Commands/Message", "Commands/KeyWait"]
			,	4: ["p7-Settings"]
			,	5: ["Commands/Mouse"]
			,	7: ["Commands/Special_Keys"]
			,	8: ["Commands/Text"]
			,	10: ["Commands/Run"]
			,	11: ["Commands/Window"]
			,	12: ["Commands/Loop", "Commands/Goto_and_Gosub", "Commands/Label"
				, "Commands/Loop_FilePattern",	"Commands/Loop_Parse", "Commands/Loop_Read", "Commands/Loop_Registry"]
			,	14: ["p5-Export"]
			,	19: ["Commands/Image_Search", "Commands/Pixel_Search"]
			,	21: ["Commands/If_Statements", "Commands/Assign_Variable", "Commands/Functions"]
			,	22: ["Commands/PostMessage_and_SendMessage"]
			,	23: ["Commands/Control"]
			,	24: ["Commands/Internet_Explorer", "Commands/COM_Interface"] }

KeyNameRep :=
(Join,
"LControl|Left Control
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
Num Del|Num Delete"
)
CtrlCmdList :=
(Join|
"Control|
ControlFocus
ControlMove
ControlSetText
ControlGet
ControlGetText
ControlGetFocus
ControlGetPos"
)
CtrlCmd :=
(Join|
"Check|
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
EditPaste"
)
CtrlGetCmd :=
(Join|
"List|
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
Hwnd"
)
WinList :=
(
"WinSet = WinTitle, WinText, ExcludeTitle, ExcludeText
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
WinGetPos = WinTitle, WinText, ExcludeTitle, ExcludeText"
)

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

WinCmd :=
(Join|
"AlwaysOnTop|
Bottom
Top
Disable
Enable
Redraw
Style
ExStyle
Region
Transparent
TransColor"
)
WinGetCmd :=
(Join|
"ID|
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
ExStyle"
)
IfCmd :=
(
"If Window Active|IfWinActive,
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
Evaluate Expression|Expression"
)
Loop, Parse, IfCmd, `n
{
	Count := A_index
	Loop, Parse, A_LoopField, |
	{
		If A_Index = 1
		{
			If%Count% := A_LoopField
			IfList .= A_LoopField "$"
		}
		Else
			c_If%Count% := A_LoopField
	}
	If A_Index = 1
		IfList .= "$"
}

IECmdList := 
(Join|
"Navigate|
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
Href
Src
SelectedIndex
Checked
Type
Width
Height
Length"
)

SetOnlyList := "GoHome,GoBack,GoForward,GoSearch,Refresh,Stop,Quit
				,Navigate,Navigate2,Focus,Click,Submit"
GetOnlyList := "LocationName,LocationURL"
NoValueList := "GoHome,GoBack,GoForward,GoSearch,Refresh,Stop,Quit
			,Focus,Click,Submit"
NoElemList := "Navigate,Navigate2,GoHome,GoBack,GoForward,GoSearch,Refresh,Stop,Quit
				,LocationName,LocationURL"

MethodList :=
(Join,
"ClientToWindow
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
Stop"
)
ProperList :=
(Join,
"AddressBar
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
SelectedIndex
Checked"
)
CLSList := 
(Join|
"InternetExplorer.Application|
Excel.Application
Word.Application
Outlook.Application
PowerPoint.Application
SAPI.SpVoice
Schedule.Service
ScriptControl
XStandard.Zip"
)

FileCmd :=
(
"Run, Target, WorkingDir, Max|Min|Hide|UseErrorLevel, OutputVarPID
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
MsgBox, Options, Title, Text, Timeout
InputBox, OutputVar, Title, Prompt, HIDE, Width, Height
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
SetCapsLockState, State
SetNumLockState, State
SetScrollLockState, State
FormatTime, OutputVar, YYYYMMDDHH24MISS, Format
Transform, OutputVar, Cmd, Value1, Value2
Random, OutputVar, Min, Max
BlockInput, Mode
UrlDownloadToFile, URL, Filename
SendLevel, Level
Pause
Return
ExitApp"
)
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

BuiltinFuncList =
(Join$
Abs
ACos
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
IsByRef
IsFunc
IsLabel
IsObject
Ln
Log
LTrim
Mod
NumGet
NumPut
ObjAddRef
ObjRelease
RegExMatch
RegExReplace
RegisterCallback
Round
RTrim
Sin
Sqrt
StrGet
StrLen
StrPut
SubStr
Tan
Trim
VarSetCapacity
WinActive
WinExist
)
;##### Messages: #####

MsgList =
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
)

Loop, Parse, MsgList, `n
{
	Loop, Parse, A_LoopField, =, %A_Space%
		If InStr(A_LoopField, "_")
			Msg := A_LoopField, WM_Msgs .= A_LoopField "|"
		Else
			%Msg% := A_LoopField
}

Sort, WM_Msgs, D|

