; *****************************
; :: PULOVER'S MACRO CREATOR ::
; *****************************
; "An Interface-Based Automation Tool & Script Writer."
; Author: Pulover [Rodolfo U. Batista]
; rodolfoub@gmail.com
; Home: http://www.autohotkey.net/~Pulover
; Forum: http://www.autohotkey.com/board/topic/79763-macro-creator
; Version: 3.8.1
; Release Date: July, 2013
; AutoHotkey Version: 1.1.11.01
; Copyright © 2012-2013 Rodolfo U. Batista
; GNU General Public License 3.0 or higher
; <http://www.gnu.org/licenses/gpl-3.0.txt>

/*
Thanks to:

tic (Tariq Porter) for his GDI+ Library.
http://www.autohotkey.com/board/topic/29449-gdi-standard-library

tkoi & majkinetor for the Graphic Buttons function.
http://www.autohotkey.com/board/topic/37147-ilbutton-image-buttons

just me for LV_Colors Class, GuiCtrlAddTab and for updating ILButton to 64bit.
http://www.autohotkey.com/board/topic/88699-class-lv-colors

diebagger and Obi-Wahn for the function to move rows.
http://www.autohotkey.com/board/topic/56396-techdemo-move-rows-in-a-listview

Micahs for the base code of the Drag-Rows function.
http://www.autohotkey.com/board/topic/30486-listview-tooltip-on-mouse-hover/?p=280843

Kdoske & trueski for the CSV functions.
http://www.autohotkey.com/board/topic/51681-csv-library-lib
http://www.autohotkey.com/board/topic/39392-fairly-elaborate-csv-functions

jaco0646 for the function to make hotkey controls detect other keys.
http://www.autohotkey.com/board/topic/47439-user-defined-dynamic-hotkeys

Laszlo for the Monster function to solve expressions.
http://www.autohotkey.com/board/topic/15675-monster

Jethrow for the IEGet Function.
http://www.autohotkey.com/board/topic/47052-basic-webpage-controls

majkinetor for the Dlg_Color function.
http://www.autohotkey.com/board/topic/49214-ahk-ahk-l-forms-framework-08/

rbrtryn for the ChooseColor function.
http://www.autohotkey.com/board/topic/91229-windows-color-picker-plus/

fincs for GenDocs.
http://www.autohotkey.com/board/topic/71751-gendocs-v30-alpha002

T800 for Html Help utils.
http://www.autohotkey.com/board/topic/17984-html-help-utils

Translation revisions: Snow Flake (Swedish), huyaowen (Chinese Simplified), Jörg Schmalenberger (German).
*/

; Compiler Settings
;@Ahk2Exe-SetName Pulover's Macro Creator
;@Ahk2Exe-SetDescription Pulover's Macro Creator
;@Ahk2Exe-SetVersion 3.8.1
;@Ahk2Exe-SetCopyright Copyright © 2012-2013 Rodolfo U. Batista
;@Ahk2Exe-SetOrigFilename MacroCreator.exe

#NoEnv
#InstallKeybdHook
#MaxThreadsBuffer On
#MaxHotkeysPerInterval 999999999
#HotkeyInterval 9999999999
SetWorkingDir %A_ScriptDir%
SendMode Input
#WinActivateForce
SetTitleMatchMode, 2
SetControlDelay, 1
SetWinDelay, 0
SetKeyDelay, -1
SetMouseDelay, -1
SetBatchLines, -1
FileEncoding, UTF-8
Process, Priority,, High
#NoTrayIcon

Menu, Tray, Tip, Pulovers's Macro Creator
DefaultIcon := (A_IsCompiled) ? A_ScriptFullPath
			:  (FileExist(A_ScriptDir "\Resources\PMC3_Mult.ico") ? A_ScriptDir "\Resources\PMC3_Mult.ico" : A_AhkPath)
Menu, Tray, Icon, %DefaultIcon%, 1, 1

CurrentVersion := "3.8.1", ReleaseDate := "July, 2013"

;##### Ini File Read #####

If ((A_IsCompiled) && !InStr(FileExist(A_AppData "\MacroCreator"), "D"))
	FileCreateDir, %A_AppData%\MacroCreator

IniFilePath := ((A_IsCompiled) ? A_AppData "\MacroCreator" : A_ScriptDir) "\MacroCreator.ini"
,	UserVarsPath := ((A_IsCompiled) ? A_AppData "\MacroCreator" : A_ScriptDir) "\UserGlobalVars.ini"

IniRead, Lang, %IniFilePath%, Language, Lang
IniRead, AutoKey, %IniFilePath%, HotKeys, AutoKey, F3|F4|F5|F6|F7
IniRead, ManKey, %IniFilePath%, HotKeys, ManKey, |
IniRead, AbortKey, %IniFilePath%, HotKeys, AbortKey, F8
IniRead, PauseKey, %IniFilePath%, HotKeys, PauseKey, 0
IniRead, RecKey, %IniFilePath%, HotKeys, RecKey, F9
IniRead, RecNewKey, %IniFilePath%, HotKeys, RecNewKey, F10
IniRead, RelKey, %IniFilePath%, HotKeys, RelKey, CapsLock
IniRead, FastKey, %IniFilePath%, HotKeys, FastKey, Insert
IniRead, SlowKey, %IniFilePath%, HotKeys, SlowKey, Pause
IniRead, ClearNewList, %IniFilePath%, Options, ClearNewList, 0
IniRead, DelayG, %IniFilePath%, Options, DelayG, 0
IniRead, OnScCtrl, %IniFilePath%, Options, OnScCtrl, 1
IniRead, ShowStep, %IniFilePath%, Options, ShowStep, 1
IniRead, HideMainWin, %IniFilePath%, Options, HideMainWin, 1
IniRead, DontShowPb, %IniFilePath%, Options, DontShowPb, 0
IniRead, DontShowRec, %IniFilePath%, Options, DontShowRec, 0
IniRead, DontShowAdm, %IniFilePath%, Options, DontShowAdm, 0
IniRead, ShowTips, %IniFilePath%, Options, ShowTips, 1
IniRead, NextTip, %IniFilePath%, Options, NextTip, 1
IniRead, IfDirectContext, %IniFilePath%, Options, IfDirectContext, None
IniRead, IfDirectWindow, %IniFilePath%, Options, IfDirectWindow, %A_Space%
IniRead, KeepHkOn, %IniFilePath%, Options, KeepHkOn, 0
IniRead, Mouse, %IniFilePath%, Options, Mouse, 1
IniRead, Moves, %IniFilePath%, Options, Moves, 1
IniRead, TimedI, %IniFilePath%, Options, TimedI, 1
IniRead, Strokes, %IniFilePath%, Options, Strokes, 1
IniRead, CaptKDn, %IniFilePath%, Options, CaptKDn, 0
IniRead, MScroll, %IniFilePath%, Options, MScroll, 1
IniRead, WClass, %IniFilePath%, Options, WClass, 1
IniRead, WTitle, %IniFilePath%, Options, WTitle, 1
IniRead, MDelay, %IniFilePath%, Options, MDelay, 0
IniRead, DelayM, %IniFilePath%, Options, DelayM, 10
IniRead, DelayW, %IniFilePath%, Options, DelayW, 333
IniRead, MaxHistory, %IniFilePath%, Options, MaxHistory, 100
IniRead, TDelay, %IniFilePath%, Options, TDelay, 10
IniRead, ToggleC, %IniFilePath%, Options, ToggleC, 0
IniRead, RecKeybdCtrl, %IniFilePath%, Options, RecKeybdCtrl, 0
IniRead, RecMouseCtrl, %IniFilePath%, Options, RecMouseCtrl, 0
IniRead, CoordMouse, %IniFilePath%, Options, CoordMouse, Window
IniRead, SpeedUp, %IniFilePath%, Options, SpeedUp, 2
IniRead, SpeedDn, %IniFilePath%, Options, SpeedDn, 2
IniRead, MouseReturn, %IniFilePath%, Options, MouseReturn, 0
IniRead, ShowProgBar, %IniFilePath%, Options, ShowProgBar, 1
IniRead, ShowBarOnStart, %IniFilePath%, Options, ShowBarOnStart, 0
IniRead, RandomSleeps, %IniFilePath%, Options, RandomSleeps, 0
IniRead, RandPercent, %IniFilePath%, Options, RandPercent, 50
IniRead, DrawButton, %IniFilePath%, Options, DrawButton, RButton
IniRead, OnRelease, %IniFilePath%, Options, OnRelease, 1
IniRead, OnEnter, %IniFilePath%, Options, OnEnter, 0
IniRead, LineW, %IniFilePath%, Options, LineW, 2
IniRead, ScreenDir, %IniFilePath%, Options, ScreenDir, %A_AppData%\MacroCreator\Screenshots
IniRead, DefaultMacro, %IniFilePath%, Options, DefaultMacro, %A_Space%
IniRead, StdLibFile, %IniFilePath%, Options, StdLibFile, %A_Space%
IniRead, KeepDefKeys, %IniFilePath%, Options, KeepDefKeys, 0
IniRead, HKOff, %IniFilePath%, Options, HKOff, 0
IniRead, MultInst, %IniFilePath%, Options, MultInst, 0
IniRead, EvalDefault, %IniFilePath%, Options, EvalDefault, 0
IniRead, AllowRowDrag, %IniFilePath%, Options, AllowRowDrag, 1
IniRead, ShowLoopIfMark, %IniFilePath%, Options, ShowLoopIfMark, 1
IniRead, ShowActIdent, %IniFilePath%, Options, ShowActIdent, 1
IniRead, LoopLVColor, %IniFilePath%, Options, LoopLVColor, 0xFFFF00
IniRead, IfLVColor, %IniFilePath%, Options, IfLVColor, 0x0000FF
IniRead, VirtualKeys, %IniFilePath%, Options, VirtualKeys, % "
(Join
{LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}
{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{1}{2}{3}{4}{5}{6}{7}{8}{9}{0}
{'}{-}{=}{[}{]}{;}{/}{,}{.}{\}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}
{Del}{Ins}{BS}{Esc}{PrintScreen}{Pause}{Enter}{Tab}{Space}
{Numpad0}{Numpad1}{Numpad2}{Numpad3}{Numpad4}{Numpad5}{Numpad6}{Numpad7}{Numpad8}{Numpad9}
{NumpadDot}{NumpadDiv}{NumpadMult}{NumpadAdd}{NumpadSub}{NumpadIns}{NumpadEnd}{NumpadDown}
{NumpadPgDn}{NumpadLeft}{NumpadClear}{NumpadRight}{NumpadHome}{NumpadUp}{NumpadPgUp}{NumpadDel}
{NumpadEnter}{Browser_Back}{Browser_Forward}{Browser_Refresh}{Browser_Stop}{Browser_Search}
{Browser_Favorites}{Browser_Home}{Volume_Mute}{Volume_Down}{Volume_Up}{Media_Next}{Media_Prev}
{Media_Stop}{Media_Play_Pause}{Launch_Mail}{Launch_Media}{Launch_App1}{Launch_App2}
)"
IniRead, AutoUpdate, %IniFilePath%, Options, AutoUpdate, 1
IniRead, Ex_AbortKey, %IniFilePath%, ExportOptions, Ex_AbortKey, 0
IniRead, Ex_PauseKey, %IniFilePath%, ExportOptions, Ex_PauseKey, 0
IniRead, Ex_SM, %IniFilePath%, ExportOptions, Ex_SM, 1
IniRead, SM, %IniFilePath%, ExportOptions, SM, Input
IniRead, Ex_SI, %IniFilePath%, ExportOptions, Ex_SI, 1
IniRead, SI, %IniFilePath%, ExportOptions, SI, Force
IniRead, Ex_ST, %IniFilePath%, ExportOptions, Ex_ST, 1
IniRead, ST, %IniFilePath%, ExportOptions, ST, 2
IniRead, Ex_DH, %IniFilePath%, ExportOptions, Ex_DH, 1
IniRead, Ex_AF, %IniFilePath%, ExportOptions, Ex_AF, 1
IniRead, Ex_HK, %IniFilePath%, ExportOptions, Ex_HK, 0
IniRead, Ex_PT, %IniFilePath%, ExportOptions, Ex_PT, 0
IniRead, Ex_NT, %IniFilePath%, ExportOptions, Ex_NT, 0
IniRead, Ex_SC, %IniFilePath%, ExportOptions, Ex_SC, 1
IniRead, SC, %IniFilePath%, ExportOptions, SC, 1
IniRead, Ex_SW, %IniFilePath%, ExportOptions, Ex_SW, 1
IniRead, SW, %IniFilePath%, ExportOptions, SW, 0
IniRead, Ex_SK, %IniFilePath%, ExportOptions, Ex_SK, 1
IniRead, SK, %IniFilePath%, ExportOptions, SK, -1
IniRead, Ex_MD, %IniFilePath%, ExportOptions, Ex_MD, 1
IniRead, MD, %IniFilePath%, ExportOptions, MD, -1
IniRead, Ex_SB, %IniFilePath%, ExportOptions, Ex_SB, 1
IniRead, SB, %IniFilePath%, ExportOptions, SB, -1
IniRead, Ex_MT, %IniFilePath%, ExportOptions, Ex_MT, 0
IniRead, MT, %IniFilePath%, ExportOptions, MT, 2
IniRead, Ex_IN, %IniFilePath%, ExportOptions, Ex_IN, 1
IniRead, Ex_UV, %IniFilePath%, ExportOptions, Ex_UV, 1
IniRead, Ex_Speed, %IniFilePath%, ExportOptions, Ex_Speed, 0
IniRead, ComCr, %IniFilePath%, ExportOptions, ComCr, 1
IniRead, ComAc, %IniFilePath%, ExportOptions, ComAc, 0
IniRead, Send_Loop, %IniFilePath%, ExportOptions, Send_Loop, 0
IniRead, TabIndent, %IniFilePath%, ExportOptions, TabIndent, 1
IniRead, IncPmc, %IniFilePath%, ExportOptions, IncPmc, 0
IniRead, Exe_Exp, %IniFilePath%, ExportOptions, Exe_Exp, 0
IniRead, WinState, %IniFilePath%, WindowOptions, WinState, 0
IniRead, ColSizes, %IniFilePath%, WindowOptions, ColSizes, 65,125,190,50,40,85,90,90,60,40
IniRead, CustomColors, %IniFilePath%, WindowOptions, CustomColors, 0
IniRead, OSCPos, %IniFilePath%, WindowOptions, OSCPos, X0 Y0
IniRead, OSTrans, %IniFilePath%, WindowOptions, OSTrans, 255
IniRead, OSCaption, %IniFilePath%, WindowOptions, OSCaption, 0

User_Vars := new ObjIni(UserVarsPath)
User_Vars.Read()

If Lang = Error
{
	If A_Language in 0416,0816
		Lang = Pt
	Else If A_Language in 040a,080a,0c0a,100a
	,140a,180a,1c0a,200a,240a,280a,2c0a,300a
	,340a,380a,3c0a,400a,440a,480a,4c0a,500a
		Lang = Es
	Else If A_Language in 0407,0807,0c07,1007,1407
		Lang = De
	Else If A_Language in 040c,080c,0c0c,100c,140c,180c
		Lang = Fr
	Else If A_Language in 0410,0810
		Lang = It
	Else If A_Language in 0419
		Lang = Ru
	Else If A_Language in 0415
		Lang = Pl
	Else If A_Language in 0413,0813
		Lang = Nl
	Else If A_Language in 0406
		Lang = Da
	Else If A_Language in 0414,0814
		Lang = No
	Else If A_Language in 040b
		Lang = Fi
	Else If A_Language in 041d,081d
		Lang = Sv
	Else If A_Language in 0403
		Lang = Ca
	Else If A_Language in 041a
		Lang = Hr
	Else If A_Language in 0405
		Lang = Cs
	Else If A_Language in 041f
		Lang = Tr
	Else If A_Language in 040e
		Lang = Hu
	Else If A_Language in 0402
		Lang = Bg
	Else If A_Language in 1c1a,0c1a
		Lang = Sr
	Else If A_Language in 0422
		Lang = Uk
	Else If A_Language in 0408
		Lang = El
	Else If A_Language in 0804,0c04,1004,1404,0004,7c04
		Lang = Zh
	Else If A_Language in 0404
		Lang = Zt
	Else If A_Language in 0411
		Lang = Ja
	Else If A_Language in 0412
		Lang = Ko
	Else
		Lang = En
}

GoSub, WriteSettings

CurrentLang := Lang

#Include LIB\Definitions.ahk

Lang_Ca := "Català`t(Catalan)"
,	Lang_Da := "Dansk`t(Danish﻿)"
,	Lang_De := "Deutsch`t(German)"
,	Lang_En := "English"
,	Lang_Es := "Español`t(Spanish)"
,	Lang_Fr := "Français`t(French)"
,	Lang_Hr := "Hrvatski`t(Croatian)"
,	Lang_It := "Italiano`t(Italian)"
,	Lang_Hu := "Magyar`t(Hungarian)"
,	Lang_Nl := "Nederlands`t(Dutch)"
,	Lang_No := "Norsk`t(Norwegian)"
,	Lang_Pl := "Polski`t(Polish)"
,	Lang_Pt := "Português`t(Portuguese)"
,	Lang_Fi := "Suomi`t(Finnish)"
,	Lang_Sv := "Svenska`t(Swedish)"
,	Lang_Tr := "Türkçe`t(Turkish)"
,	Lang_Cs := "Čeština`t(Czech)"
,	Lang_El := "ελληνικά`t(Greek)"
,	Lang_Bg := "Български`t(Bulgarian)"
,	Lang_Ru := "Русский`t(Russian)"
,	Lang_Sr := "Српски`t(Serbian)"
,	Lang_Uk := "Україньска`t(Ukrainian)"
,	Lang_Zh := "中文(简体)`t(Chinese Simplified)"
,	Lang_Zt := "中文(繁體)`t(Chinese Traditional)"
,	Lang_Ja := "日本語`t(Japanese)"
,	Lang_Ko := "한국어`t(Korean)"
,	Lang_All :=
(Join|
"Català`t(Catalan)=Ca
Dansk`t(Danish﻿)=Da
Deutsch`t(German)=De
English=En
Español`t(Spanish)=Es
Français`t(French)=Fr
Hrvatski`t(Croatian)=Hr
Italiano`t(Italian)=It
Magyar`t(Hungarian)=Hu
Nederlands`t(Dutch)=Nl
Norsk`t(Norwegian)=No
Polski`t(Polish)=Pl
Português`t(Portuguese)=Pt
Suomi`t(Finnish)=Fi
Svenska`t(Swedish)=Sv
Türkçe`t(Turkish)=Tr
Čeština`t(Czech)=Cs
ελληνικά`t(Greek)=El
Български`t(Bulgarian)=Bg
Русский`t(Russian)=Ru
Српски`t(Serbian)=Sr
Україньска`t(Ukrainian)=Uk
中文(简体)`t(Chinese Simplified)=Zh
中文(繁體)`t(Chinese Traditional)=Zt
日本語`t(Japanese)=Ja
한국어`t(Korean)=Ko"
)

AppName := "Pulover's Macro Creator"
,	HeadLine := "; This script was created using Pulover's Macro Creator"
,	PmcHead := "/*"
. "`nPMC File Version " CurrentVersion
. "`n---[Do not edit anything in this section]---`n`n"

If (KeepDefKeys = 1)
	DefAutoKey := AutoKey, DefManKey := ManKey

GoSub, ObjCreate

GoSub, LoadLang
ToggleMode := ToggleC ? "T" : "P"
Loop, Parse, ColSizes, `,
	Col_%A_Index% := A_LoopField

RegRead, DClickSpd, HKEY_CURRENT_USER, Control Panel\Mouse, DoubleClickSpeed
DClickSpd := Round(DClickSpd * 0.001, 1)

;##### Menus: #####

Menu, Tray, NoStandard
GoSub, CreateMenuBar

Menu, MouseB, Add, Click, HelpB
Menu, MouseB, Add, ControlClick, HelpB
Menu, MouseB, Add, MouseClickDrag, HelpB
Menu, MouseB, Icon, Click, %shell32%, %HelpIconQ%
Menu, TextB, Add, Send / SendRaw, HelpB
Menu, TextB, Add, ControlSend, HelpB
Menu, TextB, Add, ControlSetText, HelpB
Menu, TextB, Add, Clipboard, HelpB
Menu, TextB, Icon, Send / SendRaw, %shell32%, %HelpIconQ%
Menu, ControlB, Add, Control, HelpB
Menu, ControlB, Add, ControlFocus, HelpB
Menu, ControlB, Add, ControlGet, HelpB
Menu, ControlB, Add, ControlGetFocus, HelpB
Menu, ControlB, Add, ControlGetPos, HelpB
Menu, ControlB, Add, ControlGetText, HelpB
Menu, ControlB, Add, ControlMove, HelpB
Menu, ControlB, Add, ControlSetText, HelpB
Menu, ControlB, Icon, Control, %shell32%, %HelpIconQ%
Menu, SpecialB, Add, List of Keys, SpecialB
Menu, SpecialB, Icon, List of Keys, %shell32%, %HelpIconQ%
Menu, PauseB, Add, Sleep, HelpB
Menu, PauseB, Add, MsgBox, HelpB
Menu, PauseB, Add, KeyWait, HelpB
Menu, PauseB, Icon, Sleep, %shell32%, %HelpIconQ%
Menu, WindowB, Add, WinActivate, HelpB
Menu, WindowB, Add, WinActivateBottom, HelpB
Menu, WindowB, Add, WinClose, HelpB
Menu, WindowB, Add, WinGet, HelpB
Menu, WindowB, Add, WinGetClass, HelpB
Menu, WindowB, Add, WinGetText, HelpB
Menu, WindowB, Add, WinGetTitle, HelpB
Menu, WindowB, Add, WinGetPos, HelpB
Menu, WindowB, Add, WinHide, HelpB
Menu, WindowB, Add, WinKill, HelpB
Menu, WindowB, Add, WinMaximize, HelpB
Menu, WindowB, Add, WinMinimize, HelpB
Menu, WindowB, Add, WinMinimizeAll / WinMinimizeAllUndo, HelpB
Menu, WindowB, Add, WinMove, HelpB
Menu, WindowB, Add, WinRestore, HelpB
Menu, WindowB, Add, WinSet, HelpB
Menu, WindowB, Add, WinShow, HelpB
Menu, WindowB, Add, WinWait, HelpB
Menu, WindowB, Add, WinWaitActive / WinWaitNotActive, HelpB
Menu, WindowB, Add, WinWaitClose, HelpB
Menu, WindowB, Icon, WinActivate, %shell32%, %HelpIconQ%
Menu, ImageB, Add, ImageSearch, HelpB
Menu, ImageB, Add, PixelSearch, HelpB
Menu, ImageB, Icon, ImageSearch, %shell32%, %HelpIconQ%
Loop, Parse, FileCmdList, |
{
	If (A_LoopField = "")
		continue
	If (InStr(A_LoopField, "File")=1 || InStr(A_LoopField, "Drive")=1)
		Menu, m_File, Add, %A_LoopField%, HelpB
	Else If (InStr(A_LoopField, "Sort")=1 || InStr(A_LoopField, "String")=1
	|| InStr(A_LoopField, "Split")=1)
	{
		If (InStr(A_LoopField, "Left") || InStr(A_LoopField, "Lower"))
		{
			LastCmd := A_LoopField " / "
			continue
		}
		Else
		{
			Menu, m_String, Add, %LastCmd%%A_LoopField%, HelpB
			LastCmd := ""
		}
	}
	Else If (!InStr(A_LoopField, "Run") && (InStr(A_LoopField, "Wait")
	|| (A_LoopField = "Input")))
		Menu, m_Wait, Add, %A_LoopField%, HelpB
	Else If A_LoopField contains Box,Tip,Progress,Splash
		Menu, m_Dialogs, Add, %A_LoopField%, HelpB
	Else If (InStr(A_LoopField, "Reg") || InStr(A_LoopField, "Ini")=1)
		Menu, m_Registry, Add, %A_LoopField%, HelpB
	Else If InStr(A_LoopField, "Sound")=1
		Menu, m_Sound, Add, %A_LoopField%, HelpB
	Else If InStr(A_LoopField, "Group")=1
		Menu, m_Group, Add, %A_LoopField%, HelpB
	Else If InStr(A_LoopField, "Env")=1
		Menu, m_Vars, Add, %A_LoopField%, HelpB
	Else If InStr(A_LoopField, "Get")
		Menu, m_Get, Add, %A_LoopField%, HelpB
	Else If A_LoopField not contains Run,Process,Shutdown
		Menu, m_Misc, Add, %A_LoopField%, HelpB
}
Menu, RunB, Add, Run / RunWait, HelpB
Menu, RunB, Add, RunAs, HelpB
Menu, RunB, Add, Process, HelpB
Menu, RunB, Add, Shutdown, HelpB
Menu, RunB, Add, File, :m_File
Menu, RunB, Add, String, :m_String
Menu, RunB, Add, Get Info, :m_Get
Menu, RunB, Add, Wait, :m_Wait
Menu, RunB, Add, Window Groups, :m_Group
Menu, RunB, Add, Dialogs, :m_Dialogs
Menu, RunB, Add, Reg && Ini, :m_Registry
Menu, RunB, Add, Sound, :m_Sound
Menu, RunB, Add, Variables, :m_Vars
Menu, RunB, Add, Misc., :m_Misc
Menu, RunB, Icon, Run / RunWait, %shell32%, %HelpIconQ%
Menu, ComLoopB, Add, Loop, LoopB
Menu, ComLoopB, Add, Loop`, FilePattern, LoopB
Menu, ComLoopB, Add, Loop`, Parse, LoopB
Menu, ComLoopB, Add, Loop`, Read File, LoopB
Menu, ComLoopB, Add, Loop`, Registry, LoopB
Menu, ComLoopB, Add, Break, HelpB
Menu, ComLoopB, Add, Continue, HelpB
Menu, ComLoopB, Add, Goto, HelpB
Menu, ComLoopB, Add, Gosub, HelpB
Menu, ComLoopB, Add, Labels, HelpB
Menu, ComLoopB, Icon, Loop, %shell32%, %HelpIconQ%
Menu, IfStB, Add, IfWinActive / IfWinNotActive, HelpB
Menu, IfStB, Add, IfWinExist / IfWinNotExist, HelpB
Menu, IfStB, Add, IfExist / IfNotExist, HelpB
Menu, IfStB, Add, IfInString / IfNotInString, HelpB
Menu, IfStB, Add, IfMsgBox, HelpB
Menu, IfStB, Add, If Statements, HelpB
Menu, IfStB, Add, Variables, HelpB
Menu, IfStB, Add, Functions, HelpB
Menu, IfStB, Icon, IfWinActive / IfWinNotActive, %shell32%, %HelpIconQ%
Menu, IEComB, Add, COM, IEComB
Menu, IEComB, Add, Basic Webpage COM Tutorial, IEComB
Menu, IEComB, Add, IWebBrowser2 Interface (MSDN), IEComB
Menu, IEComB, Icon, COM, %shell32%, %HelpIconQ%
Menu, SendMsgB, Add, PostMessage / SendMessage, HelpB
Menu, SendMsgB, Add, Message List, SendMsgB
Menu, SendMsgB, Add, Microsoft MSDN, SendMsgB
Menu, SendMsgB, Icon, PostMessage / SendMessage, %shell32%, %HelpIconQ%
Menu, IfDirB, Add, #IfWinActive / #IfWinExist, HelpB
Menu, IfDirB, Icon, #IfWinActive / #IfWinExist, %shell32%, %HelpIconQ%
Menu, ExportG, Add, Hotkeys, ExportG
Menu, ExportG, Add, Hotstrings, ExportG
Menu, ExportG, Add, List of Keys, ExportG
Menu, ExportG, Add, ComObjCreate, ExportG
Menu, ExportG, Add, ComObjActive, ExportG
Menu, ExportG, Add, Auto-execute Section, ExportG
Menu, ExportG, Add, #IfWinActive / #IfWinExist, HelpB
Menu, ExportG, Icon, Hotkeys, %shell32%, %HelpIconQ%

Menu, LangMenu, Check, % Lang_%Lang%

;##### Main Window: #####

; Gui, Font, s7
Gui, +Resize +MinSize310x140 +HwndPMCWinID
Gui, Add, Button, -Wrap W25 H25 hwndNewB vNewB gNew
	ILButton(NewB, NewIcon[1] ":" NewIcon[2])
Gui, Add, Button, -Wrap W25 H25 ys x+0 hwndOpenB vOpenB gOpen
	ILButton(OpenB, OpenIcon[1] ":" OpenIcon[2])
Gui, Add, Button, -Wrap W25 H25 ys x+0 hwndSaveB vSaveB gSave
	ILButton(SaveB, SaveIcon[1] ":" SaveIcon[2])
Gui, Add, Text, W2 H25 ys+2 x+5 0x11
Gui, Add, Button, -Wrap W69 H25 ys x+4 hwndExportB vExportB gExport, %w_Lang001%
	ILButton(ExportB, ExportIcon[1] ":" ExportIcon[2], 0, "Left")
Gui, Add, Button, -Wrap W69 H25 yp x+2 hwndPreviewB vPreviewB gPreview, %w_Lang002%
	ILButton(PreviewB, PreviewIcon[1] ":" PreviewIcon[2], 0, "Left")
Gui, Add, Button, -Wrap W69 H25 yp x+2 hwndOptionsB vOptionsB gOptions, %w_Lang003%
	ILButton(OptionsB, OptionsIcon[1] ":" OptionsIcon[2], 0, "Left")
Gui, Add, Button, -Wrap W25 H25 yp+30 xm hwndMouseB vMouseB gMouse
	ILButton(MouseB, MouseIcon[1] ":" MouseIcon[2])
Gui, Add, Button, -Wrap W25 H25 yp x+0 hwndTextB vTextB gText
	ILButton(TextB, TextIcon[1] ":" TextIcon[2])
Gui, Add, Button, -Wrap W25 H25 yp x+0 hwndControlB vControlB gControlCmd
	ILButton(ControlB, ControlIcon[1] ":" ControlIcon[2])
Gui, Add, Text, W2 H25 yp+2 x+5 0x11
Gui, Add, Button, -Wrap W25 H25 yp-2 x+4 hwndPauseB vPauseB gPause
	ILButton(PauseB, PauseIcon[1] ":" PauseIcon[2])
Gui, Add, Button, -Wrap W25 H25 yp x+0 hwndWindowB vWindowB gWindow
	ILButton(WindowB, WindowIcon[1] ":" WindowIcon[2])
Gui, Add, Button, -Wrap W25 H25 yp x+0 hwndImageB vImageB gImage
	ILButton(ImageB, ImageIcon[1] ":" ImageIcon[2])
Gui, Add, Button, -Wrap W25 H25 yp x+0 hwndRunB vRunB gRun
	ILButton(RunB, RunIcon[1] ":" RunIcon[2])
Gui, Add, Text, W2 H25 yp+2 x+5 0x11
Gui, Add, Button, -Wrap W25 H25 yp-2 x+4 hwndComLoopB vComLoopB gComLoop
	ILButton(ComLoopB, LoopIcon[1] ":" LoopIcon[2])
Gui, Add, Button, -Wrap W25 H25 yp x+0 hwndIfStB vIfStB gIfSt
	ILButton(IfStB, IfStIcon[1] ":" IfStIcon[2])
Gui, Add, Button, -Wrap W25 H25 yp x+0 hwndIEComB vIEComB gIECom
	ILButton(IEComB, IEIcon[1] ":" IEIcon[2])
Gui, Font, s10, Courier New
Gui, Add, Button, -Wrap W25 H25 yp x+0 hwndSendMsgB vSendMsgB gSendMsg
	ILButton(SendMsgB, MsgIcon[1] ":" MsgIcon[2])
Gui, Font
Gui, Add, Text, W2 H55 yp-28 x+5 0x11
Gui, Font, Bold
Gui, Add, Button, -Wrap W90 H40 ys xm+310 hwndRecordB vRecordB gRecord, %w_Lang004%
	ILButton(RecordB, RecordIcon[1] ":" RecordIcon[2], 1, "Left")
Gui, Add, Button, -Wrap W90 H40 ys xm+405 hwndStartB vStartB gPlayStart, %w_Lang005%
	ILButton(StartB, PlayIcon[1] ":" PlayIcon[2], 1, "Left")
Gui, Font
; Gui, Font, s7
Gui, Add, Checkbox, -Wrap Checked%HideMainWin% yp+45 xp-95 W90 vHideMainWin R1, %w_Lang013%
Gui, Add, Checkbox, -Wrap Checked%OnScCtrl% yp xp+95 W90 vOnScCtrl R1, %w_Lang009%
Gui, Add, Button, -Wrap ys xm+500 W25 H25 hwndTestRun vTestRun gTestRun
	ILButton(TestRun, TestRunIcon[1] ":" TestRunIcon[2])
Gui, Add, Button, -Wrap W25 H25 hwndRunTimer vRunTimer gRunTimer
	ILButton(RunTimer, RunTimerIcon[1] ":" RunTimerIcon[2])
Gui, Add, GroupBox, Section W355 H65 ys-9 xm+530
Gui, Add, Text, -Wrap W25 H22 ys+15 xs+10 vAutoT, %w_Lang006%:
Gui, Add, Text, -Wrap W25 H22 y+3 vManT, %w_Lang007%:
Gui, Add, Hotkey, vAutoKey gSaveData W150 ys+13 xp+30
Gui, Add, Edit, yp xp WP HP vJoyKey Hidden
Gui, Add, Hotkey, vManKey gWaitKeys W55 y+5 Limit190, % o_ManKey[1]
Gui, Add, Text, -Wrap W25 H22 yp+3 xp+65 vAbortT, %w_Lang008%:
Gui, Add, Hotkey,  yp-3 xp+30 vAbortKey W55, %AbortKey%
Gui, Font, s10, Wingdings
Gui, Add, Checkbox, -Wrap ys+11 xs+193 W25 H25 vWin1 gSaveData 0x1000, ÿ
Gui, Font
; Gui, Font, s7
Gui, Add, Checkbox, -Wrap yp x+2 W25 H25 hwndJoyHK vJoyHK gSetJoyButton 0x1000
	ILButton(JoyHK, JoyIcon[1] ":" JoyIcon[2])
Gui, Add, Checkbox, -Wrap Checked%PauseKey% y+1 xs+193 W25 H25 hwndPauseKey vPauseKey gPauseKey 0x1000 ;, %w_Lang010%
	ILButton(PauseKey, PauseIconB[1] ":" PauseIconB[2])
Gui, Add, Checkbox, -Wrap yp x+2 W25 H25 hwndOnFinish vOnFinish gOnFinish 0x1000 ;, %w_Lang010%
	ILButton(OnFinish, FinishIcon[1] ":" FinishIcon[2])
Gui, Add, Text, W2 H55 ys+10 xs+250 0x11
Gui, Add, Text, -Wrap yp+5 x+5 W90 H22 vRepeatT, %w_Lang011% (%t_Lang004%):
Gui, Add, Edit, y+1 W90 R1 Number vReptC
Gui, Add, UpDown, vTimesG 0x80 Range0-999999999, 1
Gui, Add, Button, -Wrap hwndTabPlus vTabPlus gTabPlus ys+70 xm+500 W25 H25
	ILButton(TabPlus, PlusIcon[1] ":" PlusIcon[2])
Gui, Add, Button, -Wrap hwndTabClose vTabClose gTabClose x+0 ys+70 W25 H25
	ILButton(TabClose, CloseIcon[1] ":" CloseIcon[2])
Gui, Add, Button, -Wrap hwndDuplicateL vDuplicateL gDuplicateList x+0 ys+70 W25 H25
	ILButton(DuplicateL, DuplicateLIcon[1] ":" DuplicateLIcon[2])
Gui, Add, Text, W2 H25 ys+72 x+5 0x11
Gui, Add, Button, -Wrap hwndImportB vImportB gImport x+4 ys+70 W25 H25
	ILButton(ImportB, ImportIcon[1] ":" ImportIcon[2])
Gui, Add, Button, -Wrap hwndSaveC vSaveC gSaveCurrentList x+0 ys+70 W25 H25
	ILButton(SaveC, SaveLIcon[1] ":" SaveLIcon[2])
Gui, Add, Text, W2 H25 ys+72 x+5 0x11
Gui, Add, Button, -Wrap x+4 ys+70 W25 H25 hwndIfDirB vIfDirB gSetWin
	ILButton(IfDirB, ContextIcon[1] ":" ContextIcon[2])
Gui, Add, Checkbox, -Wrap ys+75 xp+30 W100 gCapt vCapt R1, %w_Lang012%
Gui, Add, Checkbox, -Wrap Checked%KeepHkOn% W100 -Wrap yp x+5 vKeepHkOn gCheckHkOn R1, %w_Lang014%
Gui, Add, Tab2, Section Buttons -Wrap AltSubmit xm ys+72 H22 W500 hwndTabSel vA_List gTabSel, Macro1
Gui, Add, ListView, x+0 y+0 AltSubmit Checked hwndListID1 vInputList1 gInputList W860 r28 NoSort LV0x10000, Index|Action|Details|Repeat|Delay|Type|Control|Window|Comment|Color
LV_hIL := IL_Create(LVIcons.MaxIndex())
LV_SetImageList(LV_hIL)
Loop, % LVIcons.MaxIndex()
	IL_Add(LV_hIL, LVIcons[A_Index][1], LVIcons[A_Index][2])
Loop, 10
	LV_ModifyCol(A_Index, Col_%A_Index%)
Gui, Tab
Gui, Add, UpDown, ys+23 x+4 gOrder vOrder -16 Range0-1, 0
Gui, Add, Button, -Wrap W22 H25 hwndCut vCut gCutRows
	ILButton(Cut, CutIcon[1] ":" CutIcon[2])
Gui, Add, Button, -Wrap W22 H25 hwndCopy vCopy gCopyRows
	ILButton(Copy, CopyIcon[1] ":" CopyIcon[2])
Gui, Add, Button, -Wrap W22 H25 hwndPaste vPaste gPasteRows
	ILButton(Paste, PasteIcon[1] ":" PasteIcon[2])
Gui, Add, Button, -Wrap W22 H25 hwndRemove vRemove gRemove
	ILButton(Remove, RemoveIcon[1] ":" RemoveIcon[2])
Gui, Add, Text, vSeparator5 W25 H2 0x10
Gui, Add, Button, -Wrap W22 H25 hwndUndo vUndo gUndo
	ILButton(Undo, UndoIcon[1] ":" UndoIcon[2])
Gui, Add, Button, -Wrap W22 H25 hwndRedo vRedo gRedo
	ILButton(Redo, RedoIcon[1] ":" RedoIcon[2])
Gui, Add, Text, vSeparator6 W25 H2 0x10
Gui, Add, Button, -Wrap W22 H25 hwndDuplicate vDuplicate gDuplicate
	ILButton(Duplicate, DuplicateIcon[1] ":" DuplicateIcon[2])
Gui, Add, Button, -Wrap W22 H25 hwndCopyTo vCopyTo gCopyTo
	ILButton(CopyTo, CopyIcon[1] ":" CopyIcon[2])
Gui, Add, Text, vSeparator7 W25 H2 0x10
Gui, Add, Button, -Wrap W22 H25 hwndEditColor vEditColor gEditColor
	ILButton(EditColor, ColorIcon[1] ":" ColorIcon[2])
Gui, Add, Button, -Wrap W22 H25 hwndEditComm vEditComm gEditComm
	ILButton(EditComm, CommentIcon[1] ":" CommentIcon[2])
Gui, Add, Button, -Wrap W22 H25 hwndFindReplace vFindReplace gFindReplace
	ILButton(FindReplace, FindIcon[1] ":" FindIcon[2])
Gui, Add, Text, -Wrap y+129 xm W100 H22 Section vRepeat, %w_Lang015%:
Gui, Add, Edit, ys-3 x+5 W90 R1 vRept Number
Gui, Add, UpDown, vTimesM 0x80 Range0-999999999, 1
Gui, Add, Button, -Wrap ys-4 x+0 W25 H23 hwndApplyT vApplyT gApplyT
	ILButton(ApplyT, ApplyIcon[1] ":" ApplyIcon[2])
Gui, Add, Text, W2 H25 ys-3 x+5 0x11 vSeparator1
Gui, Add, Text, -Wrap x+5 ys W100 H22 vDelayT, %w_Lang016%
Gui, Add, Edit, ys-3 x+5 W90 R1 vDelay
Gui, Add, UpDown, vDelayG 0x80 Range0-999999999, %DelayG%
Gui, Add, Button, -Wrap ys-4 x+0 W25 H23 hwndApplyI vApplyI gApplyI
	ILButton(ApplyI, ApplyIcon[1] ":" ApplyIcon[2])
Gui, Add, Text, W2 H25 ys-3 x+5 0x11 vSeparator2
Gui, Add, Hotkey, ys-3 x+5 W150 vsInput
Gui, Add, Button, -Wrap ys-4 x+0 W25 H23 hwndApplyL vApplyL gApplyL
	ILButton(ApplyL, InsertIcon[1] ":" InsertIcon[2])
Gui, Add, Button, -Wrap ys-4 x+5 W25 H23 hwndInsertKey vInsertKey gInsertKey
	ILButton(InsertKey, TextIcon[1] ":" TextIcon[2])
Gui, Add, Text, W2 H25 ys-3 x+5 0x11 vSeparator3
Gui, Add, Button, -Wrap Default ys-4 x+5 W25 H23 hwndEditButton vEditButton gEditButton
	ILButton(EditButton, EditIcon[1] ":" EditIcon[2])
Gui, Add, Text, W2 H25 ys-3 x+5 0x11 vSeparator4
Gui, Add, Text, -Wrap ys-6 x+5 W100 vContextTip gSetWin cBlue, #IfWin: %IfDirectContext%
Gui, Add, Text, -Wrap yp+16 W100 vCoordTip gOptions, CoordMode: %CoordMouse%
GuiControl,, Win1, % (InStr(o_AutoKey[1], "#")) ? 1 : 0
GuiControl, Focus, InputList%A_List%
Gui, Submit
GoSub, LoadData
GoSub, b_Start
OnMessage(WM_MOUSEMOVE, "ShowTooltip")
OnMessage(WM_RBUTTONDOWN, "ShowContextHelp")
OnMessage(WM_LBUTTONDOWN, "DragToolbar")
OnMessage(WM_ACTIVATE, "WinCheck")
OnMessage(WM_COPYDATA, "Receive_Params")
OnMessage(WM_HELP, "CmdHelp")
OnMessage(WM_CTLCOLORSTATIC, "WM_CTLCOLOR" )
OnMessage(0x404, "AHK_NOTIFYICON")
If KeepHkOn
	Menu, Tray, Check, %w_Lang014%

If %0%
{
	WinGetActiveTitle, LastFoundWin
	Loop, %0%
	{
		Param .= %A_Index% "`n"
		If !(t_Macro) && (RegExMatch(%A_Index%, "i)^-s(\d+)*$", t_Macro))
		{
			AutoPlay := "Macro" t_Macro1
		,	HideWin := 1, CloseAfterPlay := 1
			break
		}
		If !(t_Macro) && (RegExMatch(%A_Index%, "i)^-a(\d+)*$", t_Macro))
			AutoPlay := "Macro" t_Macro1
		If (%A_Index% = "-p")
			PlayHK := 1
		If (%A_Index% = "-h")
			HideWin := 1
		If !(t_Timer) && (RegExMatch(%A_Index%, "i)^-t(\d*)(!)?$", _t))
			TimerPlay := 1, TimerDelayX := (_t1) ? _t1 : 250, TimedRun := RunFirst := (_t2) ? 1 : 0
		If (%A_Index% = "-c")
			CloseAfterPlay := 1
		If (%A_Index% = "-b")
			ShowCtrlBar := 1
	}
	Param := RTrim(Param, "`n")
	If !MultInst && (TargetID := WinExist("ahk_exe " A_ScriptFullPath))
	{
		Send_Params(Param, TargetID)
		ExitApp
	}
	PMC.Import(Param)
	CurrentFileName := LoadedFileName
	GoSub, FileRead
}
Else If !MultInst && (TargetID := WinExist("ahk_exe " A_ScriptFullPath))
{
	WinActivate, ahk_id %TargetID%
	ExitApp
}
Else IfExist, %DefaultMacro%
{
	PMC.Import(DefaultMacro)
	CurrentFileName := LoadedFileName
	GoSub, FileRead
}
Else
{
	HistoryMacro1 := new LV_Rows()
	HistoryMacro1.Add()
}
Menu, Tray, Icon
Gui, Show, % ((WinState) ? "Maximize" : "W900 H630") ((HideWin) ? "Hide" : ""), %AppName% v%CurrentVersion% %CurrentFileName%
GuiControl, +ReadOnly, JoyKey
GoSub, RowCheck
If (HideWin)
{
	Menu, Tray, Rename, %y_Lang001%, %y_Lang002%
	WinActivate, %LastFoundWin%
}
If (ShowCtrlBar)
	GoSub, OnScControls
If (PlayHK)
	GoSub, PlayStart
If ((AutoPlay) || (TimerPlay))
{
	GuiControl, Choose, A_List, %t_Macro1%
	GoSub, TabSel
	If (TimerPlay)
		GoSub, TimerOK
	Else
		GoSub, TestRun
}
Else
{
	If (!DontShowAdm && !A_IsAdmin)
	{
		Gui 26:+LastFoundExist
		IfWinExist
			GoSub, TipClose
		Gui, 26:-SysMenu +HwndTipScrID +owner1
		Gui, 26:Color, FFFFFF
		; Gui, 26:Font, s7
		Gui, 26:Add, Pic, y+20 Icon%WarnIcon%, %shell32%
		Gui, 26:Add, Text, yp x+10, %d_Lang058%`n
		Gui, 26:Add, Checkbox, -Wrap W300 vDontShowAdm R1, %d_Lang053%
		Gui, 26:Add, Button, -Wrap Default y+10 W90 H25 gTipClose2, %c_Lang020%
		Gui, 26:Show,, %AppName%
		WinWaitClose, ahk_id %TipScrID%
	}
	If (ShowBarOnStart)
		GoSub, ShowControls
	If (ShowTips)
		GoSub, ShowTips
	If (AutoUpdate)
		SetTimer, CheckUpdates, -1
}
HideWin := "", PlayHK := "", AutoPlay := "", TimerPlay := ""
FreeMemory()
return

;##### Capture Keys #####

MainLoop:
Loop
{
	WinWaitActive, ahk_id %PMCWinID%
	Gui, Submit, NoHide
	If Capt = 0
		break
	If ListFocus
	{
		Input, sKey, M L1, %VirtualKeys%
		If ErrorLevel = NewInput
			continue
		sKey := (ErrorLevel <> "Max") ? SubStr(ErrorLevel, 8) : sKey
		If sKey in %A_Space%,`n,`t
			continue
		If (Asc(sKey) < 192) && ((sKey <> "/") && (sKey <> ".") && (!GetKeyState(sKey, "P")))
			continue
		If ((GetKeyState("RAlt", "P")) && !(HoldRAlt))
			sKey := "RAlt", HoldRAlt := 1
		If (Asc(sKey) < 192) && ((CaptKDn = 1) || InStr(sKey, "Control") || InStr(sKey, "Shift")
		|| InStr(sKey, "Alt") || InStr(sKey, "Win"))
		{
			ScK := GetKeySC(sKey)
			If Hold%ScK%
				continue
			Hotkey, If
			#If
			If (sKey = "/")
				HotKey, ~*VKC1SC730 Up, RecKeyUp, On
			Else
				HotKey, ~*%sKey% Up, RecKeyUp, On
			If (sKey = ".")
				HotKey, ~*VKC2SC7E0 Up, RecKeyUp, On
			Hotkey, If
			#If
			Hold%ScK% := 1
			sKey .= " Down"
		}
		tKey := sKey, sKey := "{" sKey "}"
		Gui, Submit, NoHide
		If Capt = 0
			break
		If ListFocus
			GoSub, InsertRow
	}
}
return

;##### Recording: #####

Record:
Pause, Off
Tooltip
Gui, +OwnDialogs
Gui, Submit, NoHide
ActivateHotKeys(1, 0, 0, ((PauseKey) ? 1 : 0))
If (HideMainWin)
	GoSub, ShowHide
Else
	WinMinimize, ahk_id %PMCWinID%
If !DontShowRec
{
	Gui 26:+LastFoundExist
	IfWinExist
		GoSub, TipClose
	Gui, 26:-SysMenu +HwndTipScrID
	Gui, 26:Color, FFFFFF
	; Gui, 26:Font, s7
	Gui, 26:Add, Pic, y+20 Icon%HelpIconI%, %shell32%
	Gui, 26:Add, Text, yp x+10, %d_Lang052%`n`n- %RecKey% %d_Lang026%`n- %RecNewKey% %d_Lang030%`n`n%d_Lang043%`n
	Gui, 26:Add, Checkbox, -Wrap W300 vDontShowRec R1, %d_Lang053%
	Gui, 26:Add, Button, -Wrap Default y+10 W90 H25 gTipClose, %c_Lang020%
	Gui, 26:Show,, %AppName%
}
If (ShowStep = 1)
	Traytip, %AppName%, %RecKey% %d_Lang026%.`n%RecNewKey% %d_Lang030%.,,1
If (OnScCtrl)
	GoSub, ShowControls
return

RemoveToolTip:
ToolTip
return

RecStartNew:
ActivateHotkeys(1)
Pause, Off
GoSub, RecStop
If ClearNewList
	LV_Delete()
Else
{
	GoSub, RowCheck
	GoSub, b_Start
	GoSub, TabPlus
}
GoSub, RecStart
return

RecStart:
ActivateHotkeys(1)
Gui, 1:Default
Pause, Off
If (Record := !Record)
{
	p_Title := "", p_Class := ""
	Hotkey, ~*WheelUp, MWUp, On
	Hotkey, ~*WheelDown, MWDn, On
	mScUp := 0, mScDn := 0
	CoordMode, Mouse, %CoordMouse%
	MouseGetPos, xPos, yPos
	LastPos := xPos "/" yPos
,	LastTime := A_TickCount
	SetTimer, MouseRecord, 0
	If ((WClass = 1) || (WTitle = 1))
		WindowRecord(A_List, DelayW)
	If Strokes = 1
		SetTimer, KeyboardRecord, -100
	Tooltip
	If (ShowStep = 1)
		Traytip, %AppName%, Macro%A_List%: %d_Lang028% %RecKey% %d_Lang029%.,,1
	Menu, Tray, Icon, % t_RecordIcon[1], % t_RecordIcon[2]
	Menu, Tray, Default, %w_Lang008%
	ToggleButtonIcon(OSRec, RecStopIcon)
	return
}
Else
{
	GoSub, RecStop
	GoSub, b_Start
	GoSub, RowCheck
	GoSub, PlayActive
	ActivateHotKeys(1)
	If ShowStep = 1
		Traytip, %AppName%, % d_Lang027
		. ".`nMacro" A_List ": " o_AutoKey[A_List],,1
	ToggleButtonIcon(OSRec, RecordIcon)
	return
}
return

RecStop:
Gui, 1:Default
Pause, Off
Record := 0
Input
Tooltip
Traytip
Hotkey, ~*WheelUp, MWUp, off
Hotkey, ~*WheelDown, MWDn, off
SetTimer, MouseRecord, off
If (!(WinActive("ahk_id" PMCWinID)) && (KeepHkOn = 1))
	GoSub, KeepHkOn
Menu, Tray, Icon, %DefaultIcon%, 1
Try Menu, Tray, Default, %w_Lang005%
ToggleButtonIcon(OSRec, RecordIcon)
return

KeyboardRecord:
Loop
{
	If Record = 0
		break
	Input, sKey, V M L1, %VirtualKeys%
	If ErrorLevel = NewInput
		continue
	sKey := (ErrorLevel <> "Max") ? SubStr(ErrorLevel, 8) : sKey
	If sKey in %A_Space%,`n,`t
		continue
	GoSub, ChReplace
	If (Asc(sKey) < 192) && ((sKey <> "/") && (sKey <> ".") && (sKey <> "?")&& (!GetKeyState(sKey, "P")))
		continue
	If ((GetKeyState("RAlt", "P")) && !(HoldRAlt))
		sKey := "RAlt", HoldRAlt := 1
	If (Asc(sKey) < 192) && ((CaptKDn = 1) || InStr(sKey, "Control") || InStr(sKey, "Shift")
	|| InStr(sKey, "Alt") || InStr(sKey, "Win"))
	{
		ScK := GetKeySC(sKey)
		If Hold%ScK%
			continue
		Hotkey, If
		#If
		If (sKey = "/")
			HotKey, ~*VKC1SC730 Up, RecKeyUp, On
		Else
			HotKey, ~*%sKey% Up, RecKeyUp, On
		If (sKey = ".")
			HotKey, ~*VKC2SC7E0 Up, RecKeyUp, On
		Hotkey, If
		#If
		Hold%ScK% := 1
		sKey .= " Down"
	}
	tKey := sKey, sKey := "{" sKey "}"
	If Record = 0
		break
	GoSub, InsertRow
}
return

InsertRow:
IfWinActive, ahk_id %PMCOSC%
	return
Type := cType1, Target := "", Window := ""
If Record = 1
{
	If RecKeybdCtrl = 1
	{
		If ((InStr(sKey, "Control")) || (InStr(sKey, "Shift"))
		|| (InStr(sKey, "Alt")))
			Goto, KeyInsert
		ControlGetFocus, ActiveCtrl, A
		If (ActiveCtrl <> "")
		{
			Type := cType2, Target := ActiveCtrl
			WinGetTitle, c_Title, A
			WinGetClass, c_Class, A
			If WTitle = 1
				Window := c_Title
			If WClass = 1
				Window := Window " ahk_class " c_Class
			If ((WTitle = 0) && (WClass = 0))
				Window = A
		}
	}
}
KeyInsert:
Gui, 1:Default
If Record = 1
{
	If TimedI = 1
	{
		If (Interval := TimeRecord())
		{
			If Interval > %TDelay%
			GoSub, SleepInput
		}
		InputDelay := 0, WinDelay = 0
	}
	Else
		InputDelay := DelayG, WinDelay := DelayW
	If ((WClass = 1) || (WTitle = 1))
		WindowRecord(A_List, WinDelay)
}
Else
	InputDelay := DelayG
RowSelection := LV_GetCount("Selected")
If (Record || RowSelection = 0)
{
	LV_Add("Check", ListCount%A_List%+1, tKey, sKey, 1, InputDelay, Type, Target, Window)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	RowNumber := 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, tKey, sKey, 1, DelayG, Type, Target, Window)
		RowNumber++
	}
	LV_Modify(RowNumber, "Vis")
}
If !Record
{
	GoSub, b_Start
	GoSub, RowCheck
}
return

MouseRecord:
If (Moves = 1) && (MouseMove := MoveCheck())
{
	Action := Action2, Details := MouseMove ", 0"
,	Type := cType3, Target := "", Window := ""
	GoSub, MouseAdd
}
If !GetKeyState(RelKey, ToggleMode)
	RelHold := 0, Relative := ""
If MScroll = 1
{
	If (mScUp > 0 && A_TimeIdle > 50)
	{
		If RecMouseCtrl = 1
			Details := ClickOn(xPos, yPos, "WheelUp", Up)
		Else
			Details := "WheelUp, " Up
		Action := Action5, Type := cType3
		GoSub, MouseInput
		mScUp := 0
	}
	If (mScDn > 0 && A_TimeIdle > 50)
	{
		If RecMouseCtrl = 1
			Details := ClickOn(xPos, yPos, "WheelDown", Dn)
		Else
			Details := "WheelDown, " Dn
		Action := Action6, Type := cType3
		GoSub, MouseInput
		mScDn := 0
	}
}
return

#If ((Record = 1) && (Mouse = 1) && !(A_IsPaused))
*~LButton::
	Critical
	; Send, {Blind}{LButton Down}
	CoordMode, Mouse, %CoordMouse%
	MouseGetPos,,, id, control
	WinGetClass, m_Class, ahk_id %id%
	If ((InStr(m_Class, "#32") <> 1) && (m_Class <> "Button")
	&& (id <> PMCWinID) && (id <> PrevID) && (id <> PMCOSC))
		WinActivate, ahk_id %id%
	MouseGetPos, xPd, yPd
	Button := "Left"
,	Details := ClickOn(xPd, yPd, Button) ((RecMouseCtrl = 1) ? ", Down" : "Down")
,	Action := Button " " Action3, Type := cType3
	GoSub, MouseInput
return
*~LButton Up::
	Critical
	; Send, {Blind}{LButton Up}
	CoordMode, Mouse, %CoordMouse%
	MouseGetPos, xPd, yPd
	Button := "Left"
,	Details := ClickOn(xPd, yPd, Button) ((RecMouseCtrl = 1) ? ", Up" : "Up")
,	Action := Button " " Action3, Type := cType3
	GoSub, MouseInput
return
*~RButton::
	Critical
	; Send, {Blind}{RButton Down}
	CoordMode, Mouse, %CoordMouse%
	MouseGetPos,,, id, control
	WinGetClass, m_Class, ahk_id %id%
	If ((InStr(m_Class, "#32") <> 1) && (m_Class <> "Button")
	&& (id <> PMCWinID) && (id <> PrevID) && (id <> PMCOSC))
		WinActivate, ahk_id %id%
	MouseGetPos, xPd, yPd
	Button := "Right"
,	Details := ClickOn(xPd, yPd, Button) ((RecMouseCtrl = 1) ? ", Down" : "Down")
,	Action := Button " " Action3, Type := cType3
	GoSub, MouseInput
return
*~RButton Up::
	Critical
	; Send, {Blind}{RButton Up}
	CoordMode, Mouse, %CoordMouse%
	MouseGetPos, xPd, yPd
	Button := "Right"
,	Details := ClickOn(xPd, yPd, Button) ((RecMouseCtrl = 1) ? ", Up" : "Up")
,	Action := Button " " Action3, Type := cType3
	GoSub, MouseInput
return
*~MButton::
	Critical
	; Send, {Blind}{MButton Down}
	CoordMode, Mouse, %CoordMouse%
	MouseGetPos,,, id, control
	WinGetClass, m_Class, ahk_id %id%
	If ((InStr(m_Class, "#32") <> 1) && (m_Class <> "Button")
	&& (id <> PMCWinID) && (id <> PrevID) && (id <> PMCOSC))
		WinActivate, ahk_id %id%
	MouseGetPos, xPd, yPd
	Button := "Middle"
,	Details := ClickOn(xPd, yPd, Button) ((RecMouseCtrl = 1) ? ", Down" : "Down")
,	Action := Button " " Action3, Type := cType3
	GoSub, MouseInput
return
*~MButton Up::
	Critical
	; Send, {Blind}{MButton Up}
	CoordMode, Mouse, %CoordMouse%
	MouseGetPos, xPd, yPd
	Button := "Middle"
,	Details := ClickOn(xPd, yPd, Button) ((RecMouseCtrl = 1) ? ", Up" : "Up")
,	Action := Button " " Action3, Type := cType3
	GoSub, MouseInput
return
*~XButton1::
	Critical
	; Send, {Blind}{XButton1 Down}
	CoordMode, Mouse, %CoordMouse%
	MouseGetPos,,, id, control
	WinGetClass, m_Class, ahk_id %id%
	If ((InStr(m_Class, "#32") <> 1) && (m_Class <> "Button")
	&& (id <> PMCWinID) && (id <> PrevID) && (id <> PMCOSC))
		WinActivate, ahk_id %id%
	MouseGetPos, xPd, yPd
	Button := "X1"
,	Details := ClickOn(xPd, yPd, Button) ((RecMouseCtrl = 1) ? ", Down" : "Down")
,	Action := Button " " Action3, Type := cType3
	GoSub, MouseInput
return
*~XButton1 Up::
	Critical
	; Send, {Blind}{XButton1 Up}
	CoordMode, Mouse, %CoordMouse%
	MouseGetPos, xPd, yPd
	Button := "X1"
,	Details := ClickOn(xPd, yPd, Button) ((RecMouseCtrl = 1) ? ", Up" : "Up")
,	Action := Button " " Action3, Type := cType3
	GoSub, MouseInput
return
*~XButton2::
	Critical
	; Send, {Blind}{XButton2 Down}
	CoordMode, Mouse, %CoordMouse%
	MouseGetPos,,, id, control
	WinGetClass, m_Class, ahk_id %id%
	If ((InStr(m_Class, "#32") <> 1) && (m_Class <> "Button")
	&& (id <> PMCWinID) && (id <> PrevID) && (id <> PMCOSC))
		WinActivate, ahk_id %id%
	MouseGetPos, xPd, yPd
	Button := "X2"
,	Details := ClickOn(xPd, yPd, Button) ((RecMouseCtrl = 1) ? ", Down" : "Down")
,	Action := Button " " Action3, Type := cType3
	GoSub, MouseInput
return
*~XButton2 Up::
	Critical
	; Send, {Blind}{XButton2 Up}
	CoordMode, Mouse, %CoordMouse%
	MouseGetPos, xPd, yPd
	Button := "X2"
,	Details := ClickOn(xPd, yPd, Button) ((RecMouseCtrl = 1) ? ", Up" : "Up")
,	Action := Button " " Action3, Type := cType3
	GoSub, MouseInput
return
#If

MWUp:
mScUp++
return

MWDn:
mScDn++
return

MouseInput:
If (id = PMCOSC)
	return
Target := "", Window := ""
If ((RecMouseCtrl = 1) && (InStr(m_Class, "#32") <> 1))
{
	If ((InStr(Details, "rel")) || (InStr(Details, "click")))
		Goto, MouseAdd
	CoordMode, Mouse, %CoordMouse%
	If (control <> "")
	{
		ControlGetPos, x, y,,, %control%, A
		xcpos := Controlpos(xPd, x), ycpos := Controlpos(yPd, y)
	,	Details := RegExReplace(Details, "\d+, \d+ ")
		If (xcpos <> "")
			Details .= " x" xcpos " y" ycpos " NA"
		Else
			Details .= " NA"
		Target := control
	}
	Else
	{
		Details := RegExReplace(Details, "\d+, \d+ ")
	,	Details .= " NA"
	,	Target := "x" xPd " y" yPd
	}
	Action := Button " " Action1, Type := cType4
	WinGetTitle, c_Title, A
	WinGetClass, c_Class, A
	If WTitle = 1
		Window := c_Title
	If WClass = 1
		Window := Window " ahk_class " c_Class
	If ((WTitle = 0) && (WClass = 0))
		Window := "A"
}
MouseAdd:
Gui, 1:Default
If TimedI = 1
{
	If (Interval := TimeRecord())
	{
		If Interval > %TDelay%
		GoSub, SleepInput
	}
	RecDelay := 0, WinDelay := 0
}
Else
	RecDelay := DelayM, WinDelay := DelayW
If (!InStr(Details, "Up") && (Action <> Action2))
{
	If ((WClass = 1) || (WTitle = 1))
		WindowRecord(A_List, WinDelay)
}
LV_Add("Check", ListCount%A_List%+1, Action, Details, 1, RecDelay, Type, Target, Window)
return

SleepInput:
LV_Add("Check", ListCount%A_List%+1, "[Pause]", "", 1, Interval, cType5)
return

;##### Subroutines: Menus & Buttons #####

New:
Gui, +OwnDialogs
If ((ListCount > 0) && (SavePrompt))
{
	MsgBox, 35, %d_Lang005%, %d_Lang002%`n`"%CurrentFileName%`"
	IfMsgBox, Yes
		GoSub, Save
	IfMsgBox, Cancel
		return
}
Input
GoSub, DelLists
GuiControl,, A_List, |Macro1
Loop, %TabCount%
	HistoryMacro%A_Index% := ""
HistoryMacro1 := new LV_Rows()
TabCount := 1
Gui, Submit, NoHide
If (KeepDefKeys = 1)
{
	AutoKey := DefAutoKey, ManKey := DefManKey
	GoSub, ObjCreate
}
GoSub, LoadData
GoSub, KeepHkOn
GuiControl,, Capt, 0
GuiControl,, TimesG, 1
CurrentFileName = 
Gui, Show, % ((WinExist("ahk_id" PMCWinID)) ? "" : "Hide"), %AppName% v%CurrentVersion%
GuiControl, Focus, InputList%A_List%
GoSub, b_Start
FreeMemory()
OnFinishCode := 1
SetWorkingDir %A_ScriptDir%
GoSub, SetFinishButtom
GoSub, RecentFiles
return

GuiDropFiles:
Gui, 1:Default
Gui, +OwnDialogs
Gui, Submit, NoHide
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
PMC.Import(A_GuiEvent)
CurrentFileName := LoadedFileName
GoSub, FileRead
GoSub, RecentFiles
return

Open:
Gui, +OwnDialogs
If ((ListCount > 0) && (SavePrompt))
{
	MsgBox, 35, %d_Lang005%, %d_Lang002%`n`"%CurrentFileName%`"
	IfMsgBox, Yes
		GoSub, Save
	IfMsgBox, Cancel
		return
}
Input
FileSelectFile, SelectedFileName, M3,, %d_Lang001%, %d_Lang004% (*.pmc)
FreeMemory()
If !SelectedFileName
	return
Loop, Parse, SelectedFileName, `n
{
	If A_Index = 1
		FilePath := RTrim(A_LoopField, "\") "\"
	Else
		Files .= FilePath . A_LoopField "`n"
}
Files := RTrim(Files, "`n")
PMC.Import(Files)
CurrentFileName := LoadedFileName, Files := ""
GoSub, b_Start
GoSub, FileRead
GoSub, RecentFiles
return

FileRead:
GoSub, b_Start
HistoryMacro1 := new LV_Rows()
HistoryMacro1.Add()
GuiControl,, Capt, 0
Gui, Show, % ((WinExist("ahk_id" PMCWinID)) ? "" : "Hide"), %AppName% v%CurrentVersion% %CurrentFileName%
SplitPath, CurrentFileName,, wDir
SetWorkingDir %wDir%
GoSub, RowCheck
GoSub, LoadData
GuiControl, Focus, InputList%A_List%
SavePrompt := False
return

Import:
Gui, +OwnDialogs
FileSelectFile, SelectedFileName, M3,, %d_Lang001%, %d_Lang004% (*.pmc)
FreeMemory()
If !SelectedFileName
	return
Files := ""
Loop, Parse, SelectedFileName, `n
{
	If A_Index = 1
		FilePath := A_LoopField "\"
	Else
		Files .= FilePath . A_LoopField "`n"
}
Files := RTrim(Files, "`n")
PMC.Import(Files, "`n", 0)
Files := ""
GuiControl, Choose, A_List, %TabCount%
Gui, Submit, NoHide
GoSub, GuiSize
GoSub, LoadData
GoSub, RowCheck
GuiControl, Focus, InputList%A_List%
If WinExist("ahk_id " PrevID)
	GoSub, PrevRefresh
GoSub, b_Start
GoSub, RecentFiles
return

SaveAs:
Input
GoSub, SelectFile
GoSub, Save
return

SelectFile:
Gui 1:+OwnDialogs
FileSelectFile, SelectedFileName, S16, %CurrentFileName%, %d_Lang005%, %d_Lang004% (*.pmc)
FreeMemory()
If SelectedFileName = 
	Exit
SplitPath, SelectedFileName,, wDir, ext
If (ext <> "pmc")
	SelectedFileName .= ".pmc"
CurrentFileName := SelectedFileName
GoSub, RecentFiles
return

Save:
Input
GoSub, SaveData
If CurrentFileName = 
	GoSub, SelectFile
IfExist %CurrentFileName%
{
    FileDelete %CurrentFileName%
    If ErrorLevel
    {
        MsgBox, 16, %d_Lang007%, %d_Lang006% "%CurrentFileName%".
        return
    }
}
Loop, %TabCount%
{
	If (ListCount%A_Index% = 0)
		continue
	PMCSet := "[PMC Code]|" o_AutoKey[A_Index]
	. "|" o_ManKey[A_Index] "|" o_TimesG[A_Index]
	. "|" CoordMouse "|" OnFinishCode "`n"
	LV_Data := PMCSet . PMC.LVGet("InputList" A_Index).Text . "`n"
	FileAppend, %LV_Data%, %CurrentFileName%
}
Gui, Show, % ((WinExist("ahk_id" PMCWinID)) ? "NA" : "Hide"), %AppName% v%CurrentVersion% %CurrentFileName%
SplitPath, CurrentFileName,, wDir
SetWorkingDir %wDir%
SavePrompt := False
GoSub, RecentFiles
return

SaveCurrentList:
Input
ActiveFile := CurrentFileName
GoSub, SaveData
GoSub, SelectFile
ThisListFile := CurrentFileName, CurrentFileName := ActiveFile
IfExist %ThisListFile%
{
    FileDelete %ThisListFile%
    If ErrorLevel
    {
        MsgBox, 16, %d_Lang007%, %d_Lang006% "%ThisListFile%".
        return
    }
}
PMCSet := "[PMC Code]|" o_AutoKey[A_List]
. "|" o_ManKey[A_List] "|" o_TimesG[A_List]
. "|" CoordMouse "`n"
LV_Data := PMCSet . PMC.LVGet("InputList" A_List).Text . "`n"
FileAppend, %LV_Data%, %ThisListFile%
GoSub, RecentFiles
return

RecentFiles:
If (PmcRecentFiles <> "")
{
	Loop, Parse, PmcRecentFiles, `n
		Menu, RecentMenu, Delete, %A_Index%: %A_LoopField%
}
PmcRecentFiles := ""
Loop, %RecentFolder%\*.pmc.lnk
{
	FileGetShortcut, %A_LoopFileFullPath%, OutTarget
	PmcRecentFiles .= A_LoopFileTimeModified "|" OutTarget "`n"
}
Sort, PmcRecentFiles, R
PmcRecentFiles := Trim(RegExReplace(PmcRecentFiles, "`am)^.*\|"), "`n")
Loop, Parse, PmcRecentFiles, `n
	Menu, RecentMenu, Add, %A_Index%: %A_LoopField%, OpenRecent
If (PmcRecentFiles = "")
{
	Menu, RecentMenu, Add, 1: %f_Lang012%, OpenRecent
	Menu, RecentMenu, Disable, 1: %f_Lang012%
	PmcRecentFiles := f_Lang012
}
return

OpenRecent:
Gui, +OwnDialogs
If ((ListCount > 0) && (SavePrompt))
{
	MsgBox, 35, %d_Lang005%, %d_Lang002%`n`"%CurrentFileName%`"
	IfMsgBox, Yes
		GoSub, Save
	IfMsgBox, Cancel
		return
}
Input
PMC.Import(RegExReplace(A_ThisMenuItem, "^\d+:\s"))
CurrentFileName := LoadedFileName, Files := ""
GoSub, FileRead
return

Export:
Input
Gui, Submit, NoHide
GoSub, SaveData
SplitPath, CurrentFileName, name, dir, ext, name_no_ext, drive
If !A_AhkPath
	Exe_Exp := 0
UserVarsList := User_Vars.Get()
Gui, 14:+owner1 -MaximizeBox -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 14:Default
Gui, 1:+Disabled
; Gui, 14:Font, s7
; Macros
Gui, 14:Add, GroupBox, W415 H150, %t_Lang002%:
Gui, 14:Add, ListView, Section ys+20 xs+10 AltSubmit Checked W395 r4 vExpList gExpEdit -Multi NoSort -ReadOnly, Macro|Hotkey|Loop|Hotstring?|BlockMouse?
Gui, 14:Add, Button, -Wrap Section xs W70 H23 gCheckAll, %t_Lang007%
Gui, 14:Add, Button, -Wrap yp x+5 W70 H23 gUnCheckAll, %t_Lang008%
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_AbortKey% yp+5 x+10 W70 vEx_AbortKey gEx_Checks R1, %w_Lang008%:
Gui, 14:Add, Edit, yp-5 x+0 W45 vAbortKey, % PauseKey ? "Esc" : AbortKey
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_PauseKey% yp+5 x+10 W70 vEx_PauseKey R1, %t_Lang081%:
Gui, 14:Add, Edit, yp-5 x+0 W45 vPauseKey, % PauseKey ? AbortKey : "Pause"
; Context
Gui, 14:Add, GroupBox, Section xm W415 H80
Gui, 14:Add, Checkbox, -Wrap Section ys xs vEx_IfDir gEx_Checks R1, %t_Lang009%:
Gui, 14:Add, DDL, xs+10 W105 vEx_IfDirType Disabled, #IfWinActive||#IfWinNotActive|#IfWinExist|#IfNotWinExist
Gui, 14:Add, DDL, yp x+225 W65 vIdent Disabled, Title||Class|Process|ID|PID
Gui, 14:Add, Edit, xs+10 W365 vTitle Disabled
Gui, 14:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetWin gGetWin Disabled, ...
; Options
Gui, 14:Add, GroupBox, Section xm W415 H260, %w_Lang003%:
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_SM% ys+20 xs+10 W110 vEx_SM R1, SendMode
Gui, 14:Add, DDL, yp-3 xp+115 vSM w75, Input||Play|Event|InputThenPlay|
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_SI% y+5 xs+10 W110 vEx_SI R1, #SingleInstance
Gui, 14:Add, DDL, yp-3 xp+115 vSI w75, Force|Ignore||Off|
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_ST% y+5 xs+10 W110 vEx_ST R1, SetTitleMatchMode
Gui, 14:Add, DDL, yp-3 xp+115 vST w75, 1|2||3|RegEx|
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_DH% y+5 xs+10 W195 vEx_DH R1, DetectHiddenWindows
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_AF% y+8 W195 vEx_AF R1, #WinActivateForce
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_PT% y+8 W195 vEx_PT R1, #Persistent
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_HK% y+8 W195 vEx_HK R1, #UseHook
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_SK% ys+15 x+5 W165 vEx_SK R1, SetKeyDelay
Gui, 14:Add, Edit, yp-3 xp+165 W30 vSK, %SK%
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_MD% y+5 xs+210 W165 vEx_MD R1, SetMouseDelay
Gui, 14:Add, Edit, yp-3 xp+165 W30 vMD, %MD%
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_SC% y+5 xs+210 W165 vEx_SC R1, SetControlDelay
Gui, 14:Add, Edit, yp-3 xp+165 W30 vSC, %SC%
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_SW% y+5 xs+210 W165 vEx_SW R1, SetWinDelay
Gui, 14:Add, Edit, yp-3 xp+165 W30 vSW, %SW%
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_SB% y+5 xs+210 W165 vEx_SB R1, SetBatchLines
Gui, 14:Add, Edit, yp-3 xp+165 W30 vSB, %SB%
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_MT% y+5 xs+210 W165 vEx_MT R1, #MaxThreadsPerHotkey
Gui, 14:Add, Edit, yp-3 xp+165 W30 vMT, %MT%
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_NT% y+5 xs+210 W165 vEx_NT R1, #NoTrayIcon
Gui, 14:Add, Text, y+10 xs+10 W395 H2 0x10
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_IN% y+10 xs+10 W195 vEx_IN R1, `#`Include (%t_Lang087%)
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_UV% yp x+5 W165 vEx_UV gEx_Checks R1, Global Variables
Gui, 14:Add, Button, yp-5 xp+170 H25 W25 hwndEx_EdVars vEx_EdVars gVarsTree Disabled
	ILButton(Ex_EdVars, IniTVIcon[1] ":" IniTVIcon[2])
Gui, 14:Add, Text, y+5 xs+10 W80, %t_Lang101%:
Gui, 14:Add, Text, yp xs+90 W50, %t_Lang102%
Gui, 14:Add, Slider, yp-10 xs+140 H35 W150 Center TickInterval Range-5-5 vEx_Speed, %Ex_Speed%
Gui, 14:Add, Text, yp+10 xs+320 W50, %t_Lang103%
Gui, 14:Add, Text, y+15 xs+10 W95, COM Objects:
Gui, 14:Add, Radio, -Wrap Checked%ComCr% yp xp+100 W95 vComCr R1, ComObjCreate
Gui, 14:Add, Radio, -Wrap Checked%ComAc% yp xp+100 W95 vComAc R1, ComObjActive
; Export
Gui, 14:Add, GroupBox, Section xm W415 H100
Gui, 14:Add, Text, Section ys+15 xs+10, %t_Lang010%:
Gui, 14:Add, Edit, vExpFile xs W365 R1 -Multi, %dir%\%name_no_ext%.ahk
Gui, 14:Add, Button, -Wrap W30 H23 yp-1 x+0 gExpSearch, ...
Gui, 14:Add, Checkbox, -Wrap Checked%TabIndent% xs W200 vTabIndent R1, %t_Lang011%
Gui, 14:Add, Checkbox, -Wrap Checked%IncPmc% yp xp+200 W145 vIncPmc R1, %t_Lang012%
Gui, 14:Add, Checkbox, -Wrap Checked%Send_Loop% y+5 xs W200 vSend_Loop R1, %t_Lang013%
Gui, 14:Add, Checkbox, -Wrap Checked%Exe_Exp% yp xp+200 W145 vExe_Exp gExe_Exp R1,%t_Lang088% 
Gui, 14:Add, Button, -Wrap Section Default xm W60 H23 gExpButton, %w_Lang001%
Gui, 14:Add, Button, -Wrap ys W60 H23 gExpClose, %c_Lang022%
Gui, 14:Add, Progress, ys W280 H20 vExpProgress
GuiControl, 14:ChooseString, SM, %SM%
GuiControl, 14:ChooseString, SI, %SI%
GuiControl, 14:ChooseString, ST, %ST%
GuiControl, 14:ChooseString, IN, %IN%
GoSub, Ex_Checks
If (IfDirectContext <> "None")
{
	GuiControl, 14:, Ex_IfDir, 1
	GuiControl, 14:ChooseString, Ex_IfDirType, #IfWin%IfDirectContext%
	GuiControl, 14:, Title, %IfDirectWindow%
	GoSub, Ex_Checks
}
LV_Delete()
Loop, %TabCount%
	LV_Add("Check", A_Index, o_AutoKey[A_Index], o_TimesG[A_Index], 0, (BckIt%A_Index% ? 1 : 0))
LV_ModifyCol(1, 50)		; Macros
LV_ModifyCol(2, 120)	; Hotkeys
LV_ModifyCol(3, 60)		; Loop
LV_ModifyCol(4, 60)		; Hotstrings
LV_ModifyCol(5, 80)		; Block
LV_Modify(0, "Check")
If CurrentFileName = 
	GuiControl, 14:, ExpFile, %A_MyDocuments%\MyScript.ahk
Gui, 14:Show,, %t_Lang001%
Tooltip
return

ExpEdit:
If A_GuiEvent = D
	LV_Rows.Drag()
If A_GuiEvent <> DoubleClick
	return
If (LV_GetCount("Selected") = 0)
	return
RowNumber := LV_GetNext()
LV_GetText(Ex_AutoKey, RowNumber, 2)
LV_GetText(Ex_TimesX, RowNumber, 3)
LV_GetText(Ex_Hotstring, RowNumber, 4)
LV_GetText(Ex_BM, RowNumber, 5)
Gui, 13:+owner14 +ToolWindow
Gui, 14:Default
Gui, 14:+Disabled
; Gui, 13:Font, s7
Gui, 13:Add, GroupBox, Section xm W270 H95
Gui, 13:Add, Edit, ys+20 xs+10 W140 vEx_AutoKey, %Ex_AutoKey%
Gui, 13:Add, Checkbox, -Wrap Checked%Ex_Hotstring% ys+25 xp+150 W100 vEx_Hotstring gEx_Hotstring R1, %t_Lang005%
Gui, 13:Add, Text, Section ys+50 xs+10, %t_Lang003%:
Gui, 13:Add, Edit, yp-3 xp+40 Limit Number W100 R1 vEx_TE, %Ex_TE%
Gui, 13:Add, UpDown, 0x80 Range0-999999999 vEx_TimesX, %Ex_TimesX%
Gui, 13:Add, Text,, %t_Lang004%
Gui, 13:Add, Checkbox, -Wrap Checked%Ex_BM% yp-22 xp+110 W100 vEx_BM R1, %t_Lang006%
Gui, 13:Show,, %w_Lang019%
return

13GuiClose:
13GuiEscape:
Gui, 13:Submit, NoHide
Gui, 14:-Disabled
Gui, 13:Destroy
Gui, 14:Default
Ex_Hotstring := InStr(Ex_AutoKey, "::")=1 ? 1 : 0
LV_Modify(RowNumber, "Col2", Ex_AutoKey, Ex_TimesX, Ex_Hotstring, Ex_BM)
return

VarsTree:
Gui, 29:+owner14 +ToolWindow
Gui, 14:+Disabled
Gui, 29:Add, TreeView, Checked H500 W300 vIniTV -ReadOnly
User_Vars.Tree(29)
Gui, 29:Add, Button, -Wrap Section xs W70 H23 gCheckAll, %t_Lang007%
Gui, 29:Add, Button, -Wrap yp x+5 W70 H23 gUnCheckAll, %t_Lang008%
Gui, 29:Show,, %t_Lang096%
return

29GuiClose:
29GuiEscape:
Gui, 29:Submit, NoHide
UserVarsList := "", ItemID := 0
Loop
{
	ItemID := TV_GetNext(ItemID, "Checked")
	If !(ItemID)
		break
	TV_GetText(ItemText, ItemID)
	If (TV_Get(TV_GetParent(ItemID), "Checked"))
		UserVarsList .= ItemText "`n"
}
Gui, 14:-Disabled
Gui, 29:Destroy
Gui, 14:Default
return

CheckAll:
ItemID := 0
LV_Modify(0, "Check")
Loop
{
	ItemID := TV_GetNext(ItemID, "Full")
	If !(ItemID)
		break
	TV_Modify(ItemID, "Check")
}
return

UnCheckAll:
LV_Modify(0, "-Check")
ItemID := 0
Loop
{
	ItemID := TV_GetNext(ItemID, "Checked")
	If !(ItemID)
		break
	TV_Modify(ItemID, "-Check")
}
return

Ex_Checks:
Gui, Submit, NoHide
; GuiControl, 14:Enable%Ex_AbortKey%, PauseKey
GuiControl, 14:Enable%Ex_IfDir%, Ex_IfDirType
GuiControl, 14:Enable%Ex_IfDir%, Ident
GuiControl, 14:Enable%Ex_IfDir%, Title
GuiControl, 14:Enable%Ex_IfDir%, GetWin
GuiControl, 14:Enable%Ex_UV%, Ex_EdVars
return

Ex_Hotstring:
Gui, Submit, NoHide
If Ex_Hotstring = 1
	GuiControl, 13:, Ex_AutoKey, ::%Ex_AutoKey%
Else
	GuiControl, 13:, Ex_AutoKey, % RegExReplace(Ex_AutoKey, ".*:")
return

ExpClose:
14GuiClose:
14GuiEscape:
Gui, Submit, NoHide
Loop, %TabCount%
	LV_GetText(BckIt%A_Index%, A_Index, 5)
Gui, 1:-Disabled
Gui, 14:Destroy
Gui, 1:Default
return

Exe_Exp:
Gui, 14:+OwnDialogs
If !A_AhkPath
{
	GuiControl, 14:, Exe_Exp, 0
	MsgBox, 17, %d_Lang007%, %d_Lang056%
	IfMsgBox, OK
		Run, http://www.autohotkey.com
	return
}
return

ExpSearch:
Gui, +OwnDialogs
Gui, Submit, NoHide
SplitPath, ExpFile, ExpName
FileSelectFile, SelectedFileName, S16, %ExpName%, %d_Lang013%, AutoHotkey Scripts (*.ahk)
FreeMemory()
If SelectedFileName = 
	return
SplitPath, SelectedFileName, name, dir, ext, name_no_ext, drive
If (ext <> "ahk")
	SelectedFileName := SelectedFileName ".ahk"
GuiControl,, ExpFile, %SelectedFileName%
return

ExpButton:
Gui, +OwnDialogs
Gui, Submit, NoHide
If (ExpFile = "")
	return
If (Ex_AbortKey = 1)
{
	If !RegExMatch(AbortKey, "^\w+$")
	{
		MsgBox, 16, %d_Lang007%, %d_Lang070%
		return
	}
}
If (Ex_PauseKey = 1)
{
	If !RegExMatch(PauseKey, "^\w+$")
	{
		MsgBox, 16, %d_Lang007%, %d_Lang070%
		return
	}
}
SelectedFileName := ExpFile
SplitPath, SelectedFileName, name, dir, ext, name_no_ext, drive
If (ext <> "ahk")
	SelectedFileName .= ".ahk"
If drive = 
{
	MsgBox, 16, %d_Lang007%, %d_Lang010%
	return
}
GoSub, ExportFile
return

ExportFile:
Header := Script_Header()
If (Ex_UV = 1)
	Header .= UserVarsList "`n"
RowNumber := 0, AutoKey := "", IncList := "", ProgRatio := 100 / LV_GetCount()
Loop, % LV_GetCount()
{
	GuiControl, 14:, ExpProgress, +%ProgRatio%
	Gui, 14:Default
	Gui, ListView, ExpList
	RowNumber := LV_GetNext(RowNumber, "Checked")
	If ((A_Index = 1) && (RowNumber = 0))
	{
		GuiControl, 14:, ExpProgress, 0
		MsgBox, 16, %d_Lang007%, %d_Lang008%
		return
	}
	If RowNumber = 0
		break
	LV_GetText(Ex_Macro, RowNumber, 1)
	LV_GetText(Ex_AutoKey, RowNumber, 2)
	LV_GetText(Ex_TimesX, RowNumber, 3)
	LV_GetText(Ex_Hotstring, RowNumber, 4)
	LV_GetText(Ex_BM, RowNumber, 5)
	If (ListCount%Ex_Macro% = 0)
		continue
	Body := LV_Export(Ex_Macro), AutoKey .= Ex_AutoKey "`n"
	GoSub, ExportOpt
	AllScripts .= Body "`n"
	PMCSet := "[PMC Code]|" Ex_AutoKey
	. "|" o_ManKey[Ex_Macro] "|" Ex_TimesX
	. "|" CoordMouse "`n"
	PmcCode .= PMCSet . PMC.LVGet("InputList" Ex_Macro).Text . "`n"
	If (Ex_IN)
		IncList .= IncludeFiles(Ex_Macro, ListCount%Ex_Macro%)
}
AutoKey := RTrim(AutoKey, "`n")
,	AbortKey := (Ex_AbortKey = 1) ? AbortKey : ""
,	PauseKey := (Ex_PauseKey = 1) ? PauseKey : ""
If CheckDuplicates(AbortKey, PauseKey, AutoKey)
{
	Body := "", AllScripts := "", PmcCode := ""
	MsgBox, 16, %d_Lang007%, %d_Lang032%
	return
}
If (Ex_Speed <> 0)
{
	Body := ""
	If (Ex_Speed < 0)
	{
		Ex_Speed *= -1
		Loop, Parse, AllScripts, `n
		{
			If RegExMatch(A_LoopField, "^Sleep, (\d+)$", Value)
				Body .= "Sleep, " . Value1 * Exp_Mult[Ex_Speed] . "`n"
			Else
				Body .= A_LoopField "`n"
		}
	}
	Else
	{
		Loop, Parse, AllScripts, `n
		{
			If RegExMatch(A_LoopField, "^Sleep, (\d+)$", Value)
				Body .= "Sleep, " . Value1 // Exp_Mult[Ex_Speed] . "`n"
			Else
				Body .= A_LoopField "`n"
		}
	}
}
Else
	Body := AllScripts
AllScripts := ""
If (Ex_IfDir = 1)
	Body := Ex_IfDirType ", " Title "`n`n" Body Ex_IfDirType "`n"
If (Ex_AbortKey = 1)
	Body .= "`n" AbortKey "::ExitApp`n"
If (Ex_PauseKey = 1)
	Body .= "`n" PauseKey "::Pause`n"
Script := Header . Body . IncList, ChoosenFileName := SelectedFileName
GoSub, SaveAHK
return

SaveAHK:
IfExist %ChoosenFileName%
{
    FileDelete %ChoosenFileName%
    If ErrorLevel
    {
        MsgBox, 16, %d_Lang007%, %d_Lang006% "%ChoosenFileName%".
        return
    }
}
FileAppend, %Script%, %ChoosenFileName%
If ErrorLevel
{
	MsgBox, 16, %d_Lang007%, %d_Lang006% "%ChoosenFileName%".
	return
}
If IncPmc
	FileAppend, `n%PmcHead%%PmcCode%*/`n, %SelectedFileName%
If Exe_Exp
{
	SplitPath, A_AhkPath,, AhkDir
	RunWait, "%AhkDir%\Compiler\Ahk2Exe.exe" /in "%SelectedFileName%" /bin "%AhkDir%\Compiler\Unicode 32-bit.bin" /mpress 1,, UseErrorLevel
}
PmcCode := ""
MsgBox, 0, %d_Lang014%, %d_Lang015%
GuiControl, 14:, ExpProgress, 0
return

ExportOpt:
If ((TabIndent = 1) &&(Ex_TimesX <> 1))
	Body := RegExReplace(Body, "`am)^", "`t")
If Ex_TimesX = 0
	Body := "Loop`n{`n" Body "}`n"
Else If Ex_TimesX > 1
	Body := "Loop, " Ex_TimesX "`n{`n" Body "}`n"
If Ex_BM = 1
	Body := "BlockInput, MouseMove`n" Body "BlockInput, MouseMoveOff`n"
Body := "Macro" Ex_Macro ":`n" Body "Return`n"
If (Ex_AutoKey <> "")
	Body := Ex_AutoKey "::`n" Body
return

Preview:
Input
Gui 2:+LastFoundExist
IfWinExist
    GoSub, PrevClose
Preview := LV_Export(A_List)
; Gui, 2:Font, s7
Gui, 2:+Resize +hwndPrevID
Gui, 2:Add, Button, -Wrap Section W60 H25 gPrevClose, %c_Lang022%
Gui, 2:Add, Button, -Wrap ys W25 H25 hwndPrevCopy vPrevCopy gPrevCopy
	ILButton(PrevCopy, CopyIcon[1] ":" CopyIcon[2])
Gui, 2:Add, Button, -Wrap ys W25 H25 hwndPrevRefresh vPrevRefresh gPrevRefresh
	ILButton(PrevRefresh, LoopIcon[1] ":" LoopIcon[2])
Gui, 2:Add, Checkbox, -Wrap ys+5 W95 vAutoRefresh R1, %t_Lang015%
Gui, 2:Add, Checkbox, -Wrap ys+5 xp+100 W105 vOnTop gOnTop R1, %t_Lang016%
Gui, 2:Add, Checkbox, -Wrap Checked%TabIndent% ys+5 xp+110 W85 vTabIndent gPrevRefresh R1, %t_Lang011%
Gui, 2:Font, s8, Courier New
Gui, 2:Add, Edit, Section xm-8 vLVPrev W420 R35 -Wrap HScroll ReadOnly
Gui, 2:Font
; Gui, 2:Font, s7
Gui, 2:Add, StatusBar
Gui, 2:Default
SB_SetParts(150, 150)
SB_SetText("Macro" A_List ": " o_AutoKey[A_List], 1)
SB_SetText("Record Keys: " RecKey "/" RecNewKey, 2)
SB_SetText("CoordMode: " CoordMouse, 3)
Gui, 1:Default
GuiControl, 2:, LVPrev, %Preview%
Gui, 2:Show,, %c_Lang072% - %AppName%
Tooltip
return

OnTop:
Gui, Submit, NoHide
Gui, % (OnTop) ? "2:+AlwaysOnTop" : "2:-AlwaysOnTop"
return

PrevCopy:
Gui, Submit, NoHide
Clipboard := LVPrev
return

PrevRefresh:
Gui, Submit, NoHide
GuiControl, 2:-Redraw, LVPrev
Preview := LV_Export(A_List)
GuiControl, 2:, LVPrev, %Preview%
PostMessage, %WM_VSCROLL%, 7, , Edit1, ahk_id %PrevID%
Gui, 2:Default
SB_SetText("Macro" A_List ": " o_AutoKey[A_List], 1)
SB_SetText("Record Keys: " RecKey "/" RecNewKey, 2)
SB_SetText("CoordMode: " CoordMouse, 3)
Gui, 1:Default
GuiControl, 2:+Redraw, LVPrev
return

PrevClose:
2GuiClose:
2GuiEscape:
Gui, 2:Destroy
AutoRefresh = 0
return

Options:
Gui 4:+LastFoundExist
IfWinExist
{
	WinActivate
	return
}
Gui, 4:+owner1 -MaximizeBox -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
GoSub, SaveData
GoSub, GetHotkeys
GoSub, ResetHotkeys
OldLoopColor := LoopLVColor, OldIfColor := IfLVColor
, OldMoves := Moves, OldTimed := TimedI, OldRandM := RandomSleeps, OldRandP := RandPercent
FileRead, UserVarsList, %UserVarsPath%
; Gui, 4:Font, s7
Gui, 4:Add, Tab2, W420 H590 vTabControl AltSubmit, %t_Lang018%|%t_Lang052%|%t_Lang096%
; Recording
Gui, 4:Add, GroupBox, W400 H200, %t_Lang022%:
Gui, 4:Add, Text, ys+40 xs+245, %t_Lang019%:
Gui, 4:Add, DDL, y+1 W75 vRecKey, F1|F2|F3|F4|F5|F6|F7|F8|F9||F10|F11|F12|CapsLock|NumLock|ScrollLock|
Gui, 4:Add, Text, y+1, %t_Lang020%:
Gui, 4:Add, DDL, y+1 W75 vRecNewKey, F1|F2|F3|F4|F5|F6|F7|F8|F9|F10||F11|F12|CapsLock|NumLock|ScrollLock|
Gui, 4:Add, Checkbox, -Wrap Checked%ClearNewList% yp+5 x+2 vClearNewList W85 R1, %d_Lang019%
Gui, 4:Add, Checkbox, -Wrap Checked%Strokes% ys+50 xs+22 vStrokes W210 R1, %t_Lang021%
Gui, 4:Add, Checkbox, -Wrap Checked%CaptKDn% vCaptKDn W210 R1, %t_Lang023%
Gui, 4:Add, Checkbox, -Wrap Checked%Mouse% vMouse W210 R1, %t_Lang024%
Gui, 4:Add, Checkbox, -Wrap Checked%MScroll% vMScroll W210 R1, %t_Lang025%
Gui, 4:Add, Checkbox, -Wrap Checked%Moves% vMoves gOptionsSub W210 R1, %t_Lang026%
Gui, 4:Add, Text,, %t_Lang028%:
Gui, 4:Add, Edit, Limit Number yp-2 xp+110 W40 R1 vMDelayT
Gui, 4:Add, UpDown, vMDelay 0x80 Range0-999999999, %MDelay%
Gui, 4:Add, Checkbox, -Wrap Checked%TimedI% yp-18 xs+245 vTimedI gOptionsSub W160 R1, %t_Lang027%
Gui, 4:Add, Text, yp+20 xp, %t_Lang028%:
Gui, 4:Add, Edit, Limit Number yp-2 xp+110 W40 R1 vTDelayT
Gui, 4:Add, UpDown, vTDelay 0x80 Range0-999999999, %TDelay%
Gui, 4:Add, Checkbox, -Wrap Checked%WClass% xs+22 yp+22 vWClass W210 R1, %t_Lang029%
Gui, 4:Add, Checkbox, -Wrap Checked%WTitle% vWTitle W210 R1, %t_Lang030%
Gui, 4:Add, Checkbox, -Wrap Checked%RecMouseCtrl% yp-19 xs+245 vRecMouseCtrl W160 R1, %t_Lang032%
Gui, 4:Add, Checkbox, -Wrap Checked%RecKeybdCtrl% vRecKeybdCtrl W160 R1, %t_Lang031%
Gui, 4:Add, Text, yp+22 xs+22, %t_Lang033%:
Gui, 4:Add, DDL, vRelKey W80 yp-5 xp+135, CapsLock||ScrollLock|NumLock
Gui, 4:Add, Checkbox, -Wrap Checked%ToggleC% yp+5 xs+245 vToggleC gOptionsSub W160 R1, %t_Lang034%
; Playback
Gui, 4:Add, GroupBox, Section yp+25 xs+12 W400 H100, %t_Lang035%:
Gui, 4:Add, Text, yp+20 xp+10, %t_Lang036%:
Gui, 4:Add, DDL, yp-2 xp+70 W75 vFastKey, None|Insert||F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|CapsLock|NumLock|ScrollLock|
Gui, 4:Add, DDL, yp xp+83 W37 vSpeedUp, 2||4|8|16|32
Gui, 4:Add, Text, yp+5 xp+40, X
Gui, 4:Add, Text, yp+25 xs+10, %t_Lang037%:
Gui, 4:Add, DDL, yp-2 xp+70 W75 vSlowKey, None|Pause||F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|CapsLock|NumLock|ScrollLock|
Gui, 4:Add, DDL, yp xp+83 W37 vSpeedDn, 2||4|8|16|32
Gui, 4:Add, Text, yp+5 xp+40, X
Gui, 4:Add, Checkbox, Checked%MouseReturn% ys+15 xp+15 W175 R2 vMouseReturn, %t_Lang038%
Gui, 4:Add, Checkbox, Checked%ShowBarOnStart% W175 y+10 xp vShowBarOnStart, %t_Lang085%
Gui, 4:Add, Checkbox, Checked%RandomSleeps% yp+25 xs+10 vRandomSleeps gOptionsSub, %t_Lang107%
Gui, 4:Add, Edit, Limit Number yp-2 x+20 W50 R1 vRandPer
Gui, 4:Add, UpDown, vRandPercent 0x80 Range0-1000, %RandPercent%
Gui, 4:Add, Text, yp+5 x+5, `%
; Defaults
Gui, 4:Add, GroupBox, Section yp+25 xs W400 H115, %t_Lang090%:
Gui, 4:Add, Text, yp+20 xs+10, %t_Lang039%:
Gui, 4:Add, Radio, -Wrap yp xp+150 W100 R1 vRelative R1, %c_Lang005%
Gui, 4:Add, Radio, -Wrap yp x+5 W100 R1 vScreen R1, %t_Lang041%
Gui, 4:Add, Checkbox, -Wrap Checked%ShowStep% ys+60 xp W130 vShowStep R1, %t_Lang100%
Gui, 4:Add, Text, ys+40 xs+10, %t_Lang042%:
Gui, 4:Add, Edit, Limit Number yp-2 xp+180 W60 R1
Gui, 4:Add, UpDown, yp xp+60 vDelayM 0x80 Range0-999999999, %DelayM%
Gui, 4:Add, Text, yp+25 xp-180, %t_Lang043%:
Gui, 4:Add, Edit, Limit Number yp-2 xp+180 W60 R1
Gui, 4:Add, UpDown, yp xp+60 vDelayW 0x80 Range0-999999999, %DelayW%
Gui, 4:Add, Text, yp+25 xp-180, %t_Lang044%:
Gui, 4:Add, Edit, Limit Number yp-2 xp+180 W60 R1
Gui, 4:Add, UpDown, yp xp+60 vMaxHistory 0x80 Range0-999999999, %MaxHistory%
Gui, 4:Add, Button, -Wrap yp xp+75 gClearHistory, %t_Lang045%
; Screenshots
Gui, 4:Add, GroupBox, Section yp+35 xs W400 H120, %t_Lang046%:
Gui, 4:Add, Text, ys+20 xs+10, %t_Lang047%:
Gui, 4:Add, DDL, yp-5 xs+100 vDrawButton W75, RButton||LButton|MButton
Gui, 4:Add, Text, yp+3 xs+210, %t_Lang048%:
Gui, 4:Add, Edit, Limit Number yp-2 x+5 W40 R1 vLineT
Gui, 4:Add, UpDown, yp xp+60 vLineW 0x80 Range1-5, %LineW%
Gui, 4:Add, Radio, -Wrap ys+45 xs+10 W180 vOnRelease R1, %t_Lang049%
Gui, 4:Add, Radio, -Wrap ys+45 xs+210 W180 vOnEnter R1, %t_Lang050%
Gui, 4:Add, Text, ys+70 xs+10, %t_Lang051%:
Gui, 4:Add, Edit, vScreenDir W350 R1 -Multi, %ScreenDir%
Gui, 4:Add, Button, -Wrap yp-1 x+0 W30 H23 vSearchScreen gSearchDir, ...
; Misc
Gui, 4:Tab, 2
Gui, 4:Add, GroupBox, Section W400 H90, %t_Lang053%:
Gui, 4:Add, Text, ys+20 xs+10, %w_Lang006%
Gui, 4:Add, Edit, yp xp+50 W320 R1 -Multi ReadOnly, %AutoKey%
Gui, 4:Add, Text, yp+25 xp-50, %w_Lang007%
Gui, 4:Add, Edit, yp xp+50 W320 R1 -Multi ReadOnly, %ManKey%
Gui, 4:Add, Checkbox, -Wrap Checked%KeepDefKeys% yp+25 xp vKeepDefKeys R1, %t_Lang054%.
Gui, 4:Add, Checkbox, -Wrap Checked%HKOff% Section yp+30 xm+15 vHKOff R1, %t_Lang055%
Gui, 4:Add, Button, -Wrap yp-5 xs+240 H23 gSetColSizes, %t_Lang056%
Gui, 4:Add, Checkbox, -Wrap Checked%MultInst% yp+23 xs vMultInst R1, %t_Lang089%
Gui, 4:Add, Checkbox, -Wrap Checked%EvalDefault% vEvalDefault W390 R1, %t_Lang059%
Gui, 4:Add, Checkbox, -Wrap Checked%AllowRowDrag% vAllowRowDrag R1, %t_Lang091%
Gui, 4:Add, Checkbox, -Wrap Checked%ShowLoopIfMark% vShowLoopIfMark W390 R1, %t_Lang060%
Gui, 4:Add, Text, W390, %t_Lang061%
Gui, 4:Add, Text, y+10 W85, %t_Lang003% "{"
Gui, 4:Add, Text, yp x+10 W40 vLoopLVColor gEditColor c%LoopLVColor%, ██████
Gui, 4:Add, Text, yp x+20 W85, %t_Lang082% "*"
Gui, 4:Add, Text, yp x+10 W40 vIfLVColor gEditColor c%IfLVColor%, ██████
Gui, 4:Add, Checkbox, -Wrap Checked%ShowActIdent% yp+25 xs vShowActIdent W390 R1, %t_Lang083%
Gui, 4:Add, Text, W390, %t_Lang084%
Gui, 4:Add, Text,, %t_Lang057%:
Gui, 4:Add, Edit, vDefaultMacro W360 R1 -Multi, %DefaultMacro%
Gui, 4:Add, Button, -Wrap yp-1 x+0 W30 H23 gSearchFile, ...
Gui, 4:Add, Text, yp+30 xs, %t_lang058%:
Gui, 4:Add, Edit, vStdLibFile W360 R1 -Multi, %StdLibFile%
Gui, 4:Add, Button, -Wrap yp-1 x+0 W30 H23 vStdLib gSearchAHK, ...
Gui, 4:Add, Text, y+5 xs, %t_Lang062%:
Gui, 4:Add, Edit, W390 H110 vEditMod, %VirtualKeys%
Gui, 4:Add, Button, -Wrap y+0 W100 H23 gConfigRestore, %t_Lang063%
Gui, 4:Add, Button, -Wrap yp x+10 W100 H23 gKeyHistory, %c_Lang124%
; User Variables
Gui, 4:Tab, 3
Gui, 4:Add, Text, -Wrap W150 R1, %t_Lang093%:
Gui, 4:Add, Text, -Wrap W250 R1 yp xp+155 cRed, %t_Lang094%
Gui, 4:Add, Text, -Wrap W400 R1 y+5 xm+10, %t_Lang095%
Gui, 4:Add, Edit, W400 H490 vUserVarsList, %UserVarsList%
Gui, 4:Tab
Gui, 4:Add, Button, -Wrap Default Section xm W60 H23 gConfigOK, %c_Lang020%
Gui, 4:Add, Button, -Wrap ys W60 H23 gConfigCancel, %c_Lang021%
GuiControl, 4:ChooseString, RecKey, %RecKey%
GuiControl, 4:ChooseString, RecNewKey, %RecNewKey%
GuiControl, 4:ChooseString, RelKey, %RelKey%
GuiControl, 4:ChooseString, FastKey, %FastKey%
GuiControl, 4:ChooseString, SlowKey, %SlowKey%
GuiControl, 4:ChooseString, SpeedUp, %SpeedUp%
GuiControl, 4:ChooseString, SpeedDn, %SpeedDn%
GuiControl, 4:ChooseString, DrawButton, %DrawButton%
If CoordMouse = Window
	GuiControl, 4:, Relative, 1
Else If CoordMouse = Screen
	GuiControl, 4:, Screen, 1
GuiControl, 4:, OnRelease, %OnRelease%
GuiControl, 4:, OnEnter, %OnEnter%
GuiControl, 4:Enable%RandomSleeps%, RandPercent
GuiControl, 4:Enable%RandomSleeps%, RandPer
GoSub, OptionsSub
Gui, 4:Show,, %t_Lang017%
OldMods := VirtualKeys
Input
Tooltip
return

ConfigOK:
Gui, Submit, NoHide
Gui, +OwnDialogs
If Relative = 1
	CoordMouse = Window
Else If Screen = 1
	CoordMouse = Screen
If OnRelease = 1
	SSMode = OnRelease
Else If OnEnter = 1
	SSMode = OnEnter
VirtualKeys := EditMod, UserVarsList := RegExReplace(UserVarsList, "U)\s+=\s+", "=")
User_Vars.Set(UserVarsList)
User_Vars.Read()
FileDelete, %UserVarsPath%
User_Vars.Write(UserVarsPath)
Gui, 1:-Disabled
Gui, 4:Destroy
Gui, 1:Default
GoSub, KeepMenuCheck
GoSub, LoadLang
IniWrite, %MultInst%, %IniFilePath%, Options, MultInst
GuiControl, 1:, CoordTip, CoordMode: %CoordMouse%
If WinExist("ahk_id " PrevID)
	GoSub, PrevRefresh
If WinExist("ahk_id " PMCOSC)
	GuiControl, 28:, OSProgB, %ShowProgBar%
GoSub, RowCheck
return

ConfigCancel:
4GuiClose:
4GuiEscape:
VirtualKeys := OldMods, LoopLVColor := OldLoopColor, IfLVColor := OldIfColor
, Moves := OldMoves, TimedI := OldTimed, RandomSleeps := OldRandM, RandPercent := OldRandP
Gui, 1:-Disabled
Gui, 4:Destroy
return

ConfigRestore:
GoSub, DefaultMod
GuiControl,, EditMod, %VirtualKeys%
return

KeyHistory:
KeyHistory
return

OptionsSub:
Gui, Submit, NoHide
GuiControl, 4:Enable%Moves%, MDelayT
GuiControl, 4:Enable%TimedI%, TDelayT
GuiControl, 4:Enable%RandomSleeps%, RandPercent
GuiControl, 4:Enable%RandomSleeps%, RandPer
ToggleMode := ToggleC ? "T" : "P"
return

LoadDefaults:
Gui, +OwnDialogs
MsgBox, 49, %d_Lang003%, %d_Lang024%
IfMsgBox, OK
{
	If KeepDefKeys
	{
		IniRead, AutoKey, %IniFilePath%, HotKeys, AutoKey, F2|F3|F4
		IniRead, ManKey, %IniFilePath%, HotKeys, ManKey, F5|F6|F7
	}
	IfExist, %IniFilePath%
		FileDelete %IniFilePath%
	GoSub, LoadSettings
	GoSub, RowCheck
	GoSub, WriteSettings
}
return

DefaultMacro:
If CurrentFileName = 
{
	MsgBox, 33, %d_Lang005%, %d_Lang002%`n`"%CurrentFileName%`"
	IfMsgBox, OK
		GoSub, Save
	IfMsgBox, Cancel
		return
}
DefaultMacro = %CurrentFileName%
return

RemoveDefault:
DefaultMacro =
GuiControl, 4:, DefaultMacro
return

KeepDefKeys:
If !A_GuiControl
	KeepDefKeys := !KeepDefKeys
If KeepDefKeys
{
	GoSub, SaveData
	GoSub, GetHotKeys
	IniWrite, %AutoKey%, %IniFilePath%, HotKeys, AutoKey
	IniWrite, %ManKey%, %IniFilePath%, HotKeys, ManKey
	DefAutoKey := AutoKey, DefManKey := ManKey
}
GoSub, KeepMenuCheck
return

KeepMenuCheck:
If KeepDefKeys
	Menu, OptionsMenu, Check, %o_Lang002%
Else
	Menu, OptionsMenu, Uncheck, %o_Lang002%
return

SearchFile:
Gui, Submit, NoHide
Gui, 4:+OwnDialogs
Gui, 4:+Disabled
FileSelectFile, SelectedFileName,,,, Project Files (*.pmc; *.ahk)
Gui, 4:-Disabled
FreeMemory()
If !SelectedFileName
	return
GuiControl, 4:, DefaultMacro, %SelectedFileName%
return

ClearHistory:
Loop, %TabCount%
{
	Gui, 1:ListView, InputList%A_Index%
	HistoryMacro%A_Index% := new LV_Rows()
	HistoryMacro%A_Index%.Add()
}
Gui, 1:ListView, InputList%A_List%
return

HandCursor:
DllCall("SetCursor", "UInt", hCurs)
return


;##### Context Help: #####

HelpB:
ThisMenuItem := RegExReplace(A_ThisMenuItem, "\s/.*")
StringReplace, ThisMenuItem, ThisMenuItem, #, _
If ThisMenuItem = Clipboard
	Run, http://l.autohotkey.net/docs/misc/Clipboard.htm
Else If ThisMenuItem = If Statements
	Run, http://l.autohotkey.net/docs/commands/IfEqual.htm
Else If ThisMenuItem = Labels
	Run, http://l.autohotkey.net/docs/misc/Labels.htm
Else If ThisMenuItem = SplashImage
	Run, http://l.autohotkey.net/docs/commands/Progress.htm
Else If ThisMenuItem = SplashTextOff
	Run, http://l.autohotkey.net/docs/commands/SplashTextOn.htm
Else If InStr(ThisMenuItem, "LockState")
	Run, http://l.autohotkey.net/docs/commands/SetNumScrollCapsLockState.htm
Else If ThisMenuItem = Variables
	Run, http://l.autohotkey.net/docs/Variables.htm
Else If ThisMenuItem = Functions
	Run, http://l.autohotkey.net/docs/Functions.htm
Else
	Run, http://l.autohotkey.net/docs/commands/%ThisMenuItem%.htm
return

LoopB:
StringReplace, ThisMenuItem, A_ThisMenuItem, #, _
StringReplace, ThisMenuItem, ThisMenuItem, `,
StringReplace, ThisMenuItem, ThisMenuItem, %A_Space%,, All
StringReplace, ThisMenuItem, ThisMenuItem, Pattern
StringReplace, ThisMenuItem, ThisMenuItem, istry
Run, http://l.autohotkey.net/docs/commands/%ThisMenuItem%.htm
return

ExportG:
SpecialB:
If A_ThisMenuItem = List of Keys
	Run, http://l.autohotkey.net/docs/KeyList.htm
Else If A_ThisMenuItem = Auto-execute Section
	Run, http://l.autohotkey.net/docs/Scripts.htm#auto
Else If InStr(A_ThisMenuItem, "ComObj")
	Run, http://l.autohotkey.net/docs/commands/%A_ThisMenuItem%.htm
Else
	Run, http://l.autohotkey.net/docs/%A_ThisMenuItem%.htm
return

IEComB:
If A_ThisMenuItem = COM
	Run, http://l.autohotkey.net/docs/commands/ComObjCreate.htm
If A_ThisMenuItem = Basic Webpage COM Tutorial
	Run, http://www.autohotkey.com/board/topic/47052-basic-webpage-controls
If A_ThisMenuItem = IWebBrowser2 Interface (MSDN)
	Run, http://msdn.microsoft.com/en-us/library/aa752127
return

SendMsgB:
If A_ThisMenuItem = Message List
	Run, http://l.autohotkey.net/docs/misc/SendMessageList.htm
If A_ThisMenuItem = Microsoft MSDN
	Run, http://msdn.microsoft.com
return

Help:
Gui, +OwnDialogs
IfExist, MacroCreator_Help.chm
	Run, MacroCreator_Help.chm
Else
	Run, http://www.autohotkey.net/~Pulover/Docs
return

Homepage:
Run, http://www.autohotkey.net/~Pulover
return

Forum:
Run, http://www.autohotkey.com/board/topic/79763-macro-creator
return

HelpAHK:
Run, http://l.autohotkey.net/docs
return

CheckNow:
CheckUpdates:
Gui, +OwnDialogs
IfExist, %A_Temp%\PMCIndex.html
	FileDelete, %A_Temp%\PMCIndex.html
UrlDownloadToFile, http://www.autohotkey.net/~Pulover/Docs/, %A_Temp%\PMCIndex.html
FileRead, VerChk, %A_Temp%\PMCIndex.html
VerChk := RegExReplace(VerChk, ".*Version: ([\d\.]+).*", "$1", vFound)
If vFound
{
	FileDelete, %A_Temp%\PMCIndex.html
	If (VerChk <> CurrentVersion)
	{
		MsgBox, 68, %d_Lang060%, %d_Lang060%: %VerChk%`n%d_Lang061%
		IfMsgBox, Yes
			Run, http://www.autohotkey.net/~Pulover/MacroCreator/MacroCreator-setup.exe
	}
	Else If (A_ThisLabel = "CheckNow")
		MsgBox, 64, %AppName%, %d_Lang062%
}
Else If (A_ThisLabel = "CheckNow")
	MsgBox, 16, %d_Lang007%, % d_Lang063 "`n`n""" RegExReplace(VerChk, ".*<H2>(.*)</H2>.*", "$1") """"
return

AutoUpdate:
AutoUpdate := !AutoUpdate
Menu, HelpMenu, % (AutoUpdate) ? "Check" : "Uncheck", %h_Lang004%
return

HelpAbout:
Gui 26:+LastFoundExist
IfWinExist
    GoSub, TipClose
OsBit := (A_PtrSize = 8) ? "x64" : "x86"
Gui, 26:-SysMenu +HwndTipScrID +owner1
Gui, 26:Color, FFFFFF
; Gui, 26:Font, s7
Gui, 26:Add, Pic, % "w48 y+20 Icon" ((A_IsCompiled) ? 1 : HelpIconI), % (A_IsCompiled) ? A_ScriptFullPath : shell32
Gui, 26:Font, Bold s12, Tahoma
Gui, 26:Add, Text, yp x+10, PULOVER'S MACRO CREATOR
Gui, 26:Font
Gui, 26:Font, Italic, Tahoma
Gui, 26:Add, Text, y+0, An Interface-Based Automation Tool && Script Writer.
Gui, 26:Font
Gui, 26:Font,, Tahoma
Gui, 26:Add, Link,, <a href="www.autohotkey.net/~Pulover">www.autohotkey.net/~Pulover</a>
Gui, 26:Add, Text,, Author: Pulover [Rodolfo U. Batista]
Gui, 26:Add, Link, y+0, <a href="mailto:rodolfoub@gmail.com">rodolfoub@gmail.com</a>
Gui, 26:Add, Text, y+0,
(
Copyright © 2012-2013 Rodolfo U. Batista

Version: %CurrentVersion% (%OsBit%)
Release Date: %ReleaseDate%
AutoHotkey Version: %A_AhkVersion%
)
Gui, 26:Add, Link, y+0, Software Licence: <a href="http://www.gnu.org/licenses/gpl-3.0.txt">GNU General Public License</a>
Gui, 26:Font, Bold, Tahoma
Gui, 26:Add, Text,, Thanks to:
Gui, 26:Font
Gui, 26:Font,, Tahoma
Gui, 26:Add, Link, y+0, Chris and Lexikos for <a href="http://www.autohotkey.com/">AutoHotkey</a>.
Gui, 26:Add, Link, y+0, tic (Tariq Porter) for his <a href="http://www.autohotkey.com/board/topic/29449-gdi-standard-library">GDI+ Library</a>.
Gui, 26:Add, Link, y+0, tkoi && majkinetor for the <a href="http://www.autohotkey.com/board/topic/37147-ilbutton-image-buttons">ILButton function</a>.
Gui, 26:Add, Link, y+0, just me for <a href="http://www.autohotkey.com/board/topic/88699-class-lv-colors">LV_Colors Class</a>, GuiCtrlAddTab and for updating ILButton to 64bit.
Gui, 26:Add, Link, y+0, diebagger and Obi-Wahn for the <a href="http://www.autohotkey.com/board/topic/56396-techdemo-move-rows-in-a-listview">function to move rows</a>.
Gui, 26:Add, Link, y+0, Micahs for the <a href="http://www.autohotkey.com/board/topic/30486-listview-tooltip-on-mouse-hover/?p=280843">base code</a> of the Drag-Rows function.
Gui, 26:Add, Link, y+0, Kdoske && trueski for the <a href="http://www.autohotkey.com/board/topic/51681-csv-library-lib">CSV functions</a>.
Gui, 26:Add, Link, y+0, jaco0646 for the <a href="http://www.autohotkey.com/board/topic/47439-user-defined-dynamic-hotkeys">function</a> to make hotkey controls detect other keys.
Gui, 26:Add, Link, y+0, Laszlo for the <a href="http://www.autohotkey.com/board/topic/15675-monster">Monster function</a> to solve expressions.
Gui, 26:Add, Link, y+0, Jethrow for the <a href="http://www.autohotkey.com/board/topic/47052-basic-webpage-controls">IEGet Function</a>.
Gui, 26:Add, Link, y+0, majkinetor for the <a href="http://www.autohotkey.com/board/topic/49214-ahk-ahk-l-forms-framework-08/">Dlg_Color</a> function.
Gui, 26:Add, Link, y+0, rbrtryn for the <a href="http://www.autohotkey.com/board/topic/91229-windows-color-picker-plus/">ChooseColor</a> function.
Gui, 26:Add, Link, y+0, fincs for <a href="http://www.autohotkey.com/board/topic/71751-gendocs-v30-alpha002">GenDocs</a>.
Gui, 26:Add, Link, y+0, T800 for <a href="http://www.autohotkey.com/board/topic/17984-html-help-utils">Html Help utils</a>.
Gui, 26:Add, Text, y+0 w380, Translation revisions: Snow Flake (Swedish), huyaowen (Chinese Simplified), Jörg Schmalenberger (German).
Gui, 26:Add, Groupbox, W380 H130 Center, GNU General Public License
Gui, 26:Add, Edit, yp+20 xp+10 W360 H100 ReadOnly -E0x200,
(
This program is free software, and you are welcome to redistribute it under  the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or any later version.

This program comes with ABSOLUTELY NO WARRANTY; for details see GNU General Public License.

You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
)
Gui, 26:Font
Gui, 26:Add, Button, -Wrap Default y+20 xp-10 W80 H23 gTipClose, %c_Lang020%
Gui, 26:Font, Bold, Tahoma
Gui, 26:Add, Text, yp-3 xp+255 H25 Center Hidden vHolderStatic, %m_Lang008%
GuiControlGet, Hold, 26:Pos, HolderStatic
Gui, 26:Add, Progress, % "x" 429 - HoldW " yp wp+20 hp BackgroundF68C06 vProgStatic Disabled"
Gui, 26:Add, Text, xp yp wp hp Border cWhite Center 0x200 BackgroundTrans vDonateStatic gDonatePayPal, %m_Lang008%
Gui, 26:Font
GuiControl, 26:Focus, %c_Lang020%
Gui, 26:Show, W460, %t_Lang076%
hCurs := DllCall("LoadCursor", "Int", 0, "Int", 32649, "UInt")
return

EditMouse:
s_Caller = Edit
Mouse:
Gui, 5:+owner1 -MaximizeBox -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
; Gui, 5:Font, s7
Gui, 5:Add, GroupBox, W250 H80, %c_Lang026%:
Gui, 5:Add, Radio, -Wrap ys+20 xs+10 Checked W115 vClick gClick R1, %c_Lang027%
Gui, 5:Add, Radio, -Wrap W115 vPoint gPoint R1, %c_Lang028%
Gui, 5:Add, Radio, -Wrap W115 vPClick gPClick R1, %c_Lang029%
Gui, 5:Add, Radio, -Wrap ys+20 xp+120 W115 vWUp gWUp R1, %c_Lang030%
Gui, 5:Add, Radio, -Wrap W115 vWDn gWDn R1, %c_Lang031%
Gui, 5:Add, Radio, -Wrap W115 vDrag gDrag R1, %c_Lang032%
Gui, 5:Add, GroupBox, Section xm W250 H100, %c_Lang033%:
Gui, 5:Add, Text, Section ys+25 xs+10, X:
Gui, 5:Add, Edit, ys-3 x+5 vIniX W70 Disabled
Gui, 5:Add, Text, ys x+20, Y:
Gui, 5:Add, Edit, ys-3 x+5 vIniY W70 Disabled
Gui, 5:Add, Button, -Wrap ys-5 x+5 W30 H23 vMouseGetI gMouseGetI Disabled, ...
Gui, 5:Add, Text, Section xs, X:
Gui, 5:Add, Edit, ys-3 x+5 vEndX W70 Disabled
Gui, 5:Add, Text, ys x+20, Y:
Gui, 5:Add, Edit, ys-3 x+5 vEndY W70 Disabled
Gui, 5:Add, Button, -Wrap ys-4 x+5 W30 H23 vMouseGetE gMouseGetE Disabled, ...
Gui, 5:Add, Radio, -Wrap Checked Section yp+30 xm+10 W65 vCL gCL R1, %c_Lang034%
Gui, 5:Add, Radio, -Wrap yp xp+70 W65 vSE gSE R1, %c_Lang035%
Gui, 5:Add, Checkbox, -Wrap yp xp+70 vMRel gMRel Disabled W95 R1, %c_Lang036%
Gui, 5:Add, GroupBox, Section xm W250 H110, %c_Lang037%:
Gui, 5:Add, Radio, -Wrap Section ys+20 xs+10 Checked W65 vLB R1, %c_Lang038%
Gui, 5:Add, Radio, -Wrap yp xp+70 W65 vRB R1, %c_Lang039%
Gui, 5:Add, Radio, -Wrap yp xp+70 W65 vMB R1, %c_Lang040%
Gui, 5:Add, Radio, -Wrap ys+20 xs W65 vX1 R1, %c_Lang041%
Gui, 5:Add, Radio, -Wrap yp xp+70 W65 vX2 R1, %c_Lang042%
Gui, 5:Add, Checkbox, -Wrap Check3 ys+40 xs vMHold gMHold R1, %c_Lang043%
Gui, 5:Add, Text, Section yp+25 xs vClicks, %c_Lang044%:
Gui, 5:Add, Edit, Limit Number ys-2 W60 R1 vCCount
Gui, 5:Add, UpDown, 0x80 Range0-999999999, 1
Gui, 5:Add, GroupBox, Section xm W250 H115
Gui, 5:Add, Checkbox, -Wrap Section ys+15 xs+10 W160 vCSend gCSend R1, %c_Lang016%:
Gui, 5:Add, Edit, vDefCt W200 Disabled
Gui, 5:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetCtrl gGetCtrl Disabled, ...
Gui, 5:Add, DDL, xs W65 vIdent Disabled, Title||Class|Process|ID|PID
Gui, 5:Add, Text, -Wrap yp+5 x+5 W140 H20 vWinParsTip Disabled, %wcmd_All%
Gui, 5:Add, Edit, xs W200 vTitle Disabled, A
Gui, 5:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetWin gGetWin Disabled, ...
Gui, 5:Add, GroupBox, Section xm W250 H110
Gui, 5:Add, Text, Section ys+15 xs+10, %w_Lang015%:
Gui, 5:Add, Text,, %c_Lang017%:
Gui, 5:Add, Edit, ys xs+110 W120 R1 vEdRept
Gui, 5:Add, UpDown, vTimesX 0x80 Range1-999999999, 1
Gui, 5:Add, Edit, W120 vDelayC
Gui, 5:Add, UpDown, vDelayX 0x80 Range0-999999999, %DelayM%
Gui, 5:Add, Radio, -Wrap Section Checked W125 vMsc R1, %c_Lang018%
Gui, 5:Add, Radio, -Wrap W125 vSec R1, %c_Lang019%
Gui, 5:Add, Button, -Wrap Section Default xm W60 H23 gMouseOK, %c_Lang020%
Gui, 5:Add, Button, -Wrap ys W60 H23 gMouseCancel, %c_Lang021%
Gui, 5:Add, Button, -Wrap ys W60 H23 vMouseApply gMouseApply Disabled, %c_Lang131%
If (s_Caller = "Edit")
{
	EscCom("Details|TimesX|DelayX|Target|Window", 1)
	If InStr(Action, "Left")
		GuiControl, 5:, LB, 1
	If InStr(Action, "Right")
		GuiControl, 5:, RB, 1
	If InStr(Action, "Middle")
		GuiControl, 5:, MB, 1
	If InStr(Action, "X1")
		GuiControl, 5:, X1, 1
	If InStr(Action, "X2")
		GuiControl, 5:, X2, 1
	StringReplace, Action, Action, Left%A_Space%
	StringReplace, Action, Action, Right%A_Space%
	StringReplace, Action, Action, Middle%A_Space%
	StringReplace, Action, Action, X1%A_Space%
	StringReplace, Action, Action, X2%A_Space%
	If (Action = Action1)
	{
		If (Type = cType13)
		{
			StringReplace, Details, Details, `{Click`,%A_Space%
			StringReplace, Details, Details, `}
		}
		GuiControl, 5:, Click, 1
		GoSub, Click
		Loop, Parse, Details, %A_Space%, `,
			Par%A_Index% := A_LoopField
		If ((Par2 <> "Down") && (Par2 <> "Up"))
			GuiControl, 5:, CCount, %Par2%
		GuiControl, 5:Disable, DefCt
		GuiControl, 5:Disable, GetCtrl
	}
	If (Action = Action2)
	{
		GuiControl, 5:, Point, 1
		GoSub, Point
	}
	If (Action = Action3)
	{
		GuiControl, 5:, PClick, 1
		GoSub, PClick
	}
	If (Action = Action4)
	{
		StringReplace, DetailsX, Details, Rel%A_Space%,, All
		StringReplace, DetailsX, DetailsX, `}`{, |, All
		StringReplace, DetailsX, DetailsX, %A_Space%,, All
		Loop, Parse, DetailsX, |
			Details%A_Index% := A_LoopField
		StringReplace, Details1, Details1, `{
		StringReplace, Details2, Details2, `}
		Loop, Parse, Details1, `,
			Par%A_Index% := A_LoopField
		GuiControl, 5:, IniX, %Par2%
		GuiControl, 5:, IniY, %Par3%
		Loop, Parse, Details2, `,
			Par%A_Index% := A_LoopField
		GuiControl, 5:, EndX, %Par2%
		GuiControl, 5:, EndY, %Par3%
		GuiControl, 5:, Drag, 1
		GoSub, Drag
	}
	If (Action = Action5)
	{
		If (Type = cType13)
		{
			StringReplace, Details, Details, `{Click`,%A_Space%
			StringReplace, Details, Details, `}
		}
		GuiControl, 5:, WUp, 1
		GoSub, WUp
		Loop, Parse, Details, %A_Space%
			Par%A_Index% := A_LoopField
		GuiControl, 5:, CCount, %Par2%
		GuiControl, 5:Disable, DefCt
		GuiControl, 5:Disable, GetCtrl
	}
	If (Action = Action6)
	{
		If (Type = cType13)
		{
			StringReplace, Details, Details, `{Click`,%A_Space%
			StringReplace, Details, Details, `}
		}
		GuiControl, 5:, WDn, 1
		GoSub, WDn
		Loop, Parse, Details, %A_Space%, `,
			Par%A_Index% := A_LoopField
		GuiControl, 5:, CCount, %Par2%
		GuiControl, 5:Disable, DefCt
		GuiControl, 5:Disable, GetCtrl
	}
	If InStr(Details, " Down")
	{
		GuiControl, 5:, MHold, 1
		GuiControl, 5:, CCount, 1
		GuiControl, 5:Disable, Clicks
		GuiControl, 5:Disable, CCount
		StringReplace, Details, Details, %A_Space%Down
	}
	If InStr(Details, " Up")
	{
		GuiControl, 5:, MHold, -1
		GuiControl, 5:, CCount, 1
		GuiControl, 5:Disable, Clicks
		GuiControl, 5:Disable, CCount
		StringReplace, Details, Details, %A_Space%Up
	}
	If (Type = cType4)
	{
		GuiControl, 5:, CSend, 1
		GuiControl, 5:Enable, CSend
		GuiControl, 5:Enable, DefCt
		GuiControl, 5:Enable, GetCtrl
		GuiControl, 5:Enable, Ident
		GuiControl, 5:Enable, Title
		GuiControl, 5:Enable, GetWin
		GuiControl, 5:Enable, MRel
		GuiControl, 5:, MRel, 1
		GuiControl, 5:Enable, IniX
		GuiControl, 5:Enable, IniY
		GuiControl, 5:Enable, MouseGetI
		GuiControl, 5:, DefCt, %Target%
		Loop, Parse, Details, `,, %A_Space%
			Par%A_Index% := A_LoopField
		Loop, Parse, Par3, %A_Space%
			Param%A_Index% := A_LoopField
		If InStr(Param1, "x")
		{
			StringReplace, Param1, Param1, x
			StringReplace, Param2, Param2, y
			GuiControl, 5:, IniX, %Param1%
			GuiControl, 5:, IniY, %Param2%
		}
		If InStr(Param2, "x")
		{
			StringReplace, Param2, Param2, x
			StringReplace, Param3, Param3, y
			GuiControl, 5:, IniX, %Param2%
			GuiControl, 5:, IniY, %Param3%
		}
		If RegExMatch(Target, "^x[0-9]+ y[0-9]+$")
		{
			StringReplace, Target, Target, x
			StringReplace, Target, Target, y
			Loop, Parse, Target, %A_Space%
				Targ%A_Index% := A_LoopField
			GuiControl, 5:Enable, CSend
			GuiControl, 5:Disable, DefCt
			GuiControl, 5:Disable, GetCtrl
			GuiControl, 5:, MRel, 0
			GuiControl, 5:, DefCt
			GuiControl, 5:, IniX, %Targ1%
			GuiControl, 5:, IniY, %Targ2%
		}
		GuiControl, 5:, Title, %Window%
	}
	If (Type = cType13)
	{
		GuiControl, 5:, SE, 1
		GoSub, SE
	}
	If InStr(Details, "Rel")
		GuiControl, 5:, MRel, 1
	GuiControl, 5:, TimesX, %TimesX%
	GuiControl, 5:, EdRept, %TimesX%
	GuiControl, 5:, DelayX, %DelayX%
	GuiControl, 5:, DelayC, %DelayX%
	If ((Action = Action2) || (Action = Action3))
	{
		If (Type = cType13)
		{
			StringReplace, Details, Details, `{Click`,%A_Space%
			StringReplace, Details, Details, `}
		}
		StringReplace, Details, Details, Rel%A_Space%
		Loop, Parse, Details, %A_Space%
			Par%A_Index% := A_LoopField
		StringReplace, Par1, Par1, `,
		StringReplace, Par2, Par2, `,
		GuiControl, 5:, IniX, %Par1%
		GuiControl, 5:, IniY, %Par2%
		If (Action = Action2)
			GuiControl, 5:, CCount, 1
		Else
		{
			If ((Par4 <> "Down") && (Par4 <> "Up"))
				GuiControl, 5:, CCount, %Par4%
		}
	}
	GuiControl, 5:Enable, MouseApply
}
Else
	Window = A
Gui, 5:Show,, %c_Lang001%
Input
Tooltip
return

MouseApply:
MouseOK:
Gui, +OwnDialogs
Gui, Submit, NoHide
DelayX := InStr(DelayC, "%") ? DelayC : DelayX
If Sec = 1
	DelayX *= 1000
TimesX := InStr(EdRept, "%") ? EdRept : TimesX
If TimesX = 0
	TimesX := 1
If LB = 1
	Button = Left
If RB = 1
	Button = Right
If MB = 1
	Button = Middle
If X1 = 1
	Button = X1
If X2 = 1
	Button = X2
If Click = 1
	GoSub, f_Click
If Point = 1
{
	If ((IniX = "") || (IniY = ""))
	{
		MsgBox, 16, %d_Lang011%, %d_Lang016%
			return
	}
	Else
	GoSub, f_Point
}
If PClick = 1
{
	If ((IniX = "") || (IniY = ""))
	{
		MsgBox, 16, %d_Lang011%, %d_Lang016%
		return
	}
	Else
	GoSub, f_PClick
}
If Drag = 1
{
	If ((IniX = "") || (IniY = "") || (EndX = "") || (EndY = ""))
	{
		MsgBox, 16, %d_Lang011%, %d_Lang016%
		return
	}
	Else
	GoSub, f_Drag
}
If WUp = 1
	GoSub, f_WUp
If WDn = 1
	GoSub, f_WDn
Window := Title
GuiControlGet, CtrlState, Enabled, DefCt
GuiControlGet, SendState, Enabled, CSend
If CtrlState = 1
{
	If ((CSend = 1) && (SendState = 1))
	{
		If DefCt = 
		{
			MsgBox, 52, %d_Lang011%, %d_Lang012%
			IfMsgBox, No
				return
		}
		If ((IniX = "") || (IniY = ""))
			Details .= " NA"
		Target := DefCt, Type := cType4
	}
	Else
		Target := "", Window := ""
}
Else
{
	If ((CSend = 1) && (SendState = 1))
	{
		If ((IniX = "") || (IniY = ""))
		{
			MsgBox, 16, %d_Lang011%, %d_Lang016%
			return
		}
		Else
			Details .= " NA", Target := "x" IniX " y" IniY, Type := cType4
	}
	Else
		Target := "", Window := ""
}
If InStr(Details, "% ")
{
	MsgBox, 16, %d_Lang007%, %d_Lang059%
	return
}
EscCom("TimesX|DelayX")
If (A_ThisLabel <> "MouseApply")
{
	Gui, 1:-Disabled
	Gui, 5:Destroy
}
Gui, 1:Default
RowSelection := LV_GetCount("Selected")
If (s_Caller = "Edit")
{
	LV_Modify(RowNumber, "Col2", Action, Details, TimesX, DelayX, Type, Target, Window)
}
Else If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, Action, Details, TimesX, DelayX, Type, Target, Window)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, Action, Details, TimesX, DelayX, Type, Target, Window)
		RowNumber++
	}
}
GoSub, b_Start
GoSub, RowCheck
If (A_ThisLabel = "MouseApply")
	Gui, 5:Default
Else
{
	s_Caller = 
	GuiControl, Focus, InputList%A_List%
}
return

MouseCancel:
5GuiClose:
5GuiEscape:
Gui, 1:-Disabled
Gui, 5:Destroy
s_Caller = 
return

f_Click:
Action := Button " " Action1, Details := Button
If MHold = 0
	Details .= ", " CCount ", "
If MHold = 1
	Details .= ", , Down"
If MHold = -1
	Details .= ", , Up"
If MRel = 1
{
	If ((IniX <> "") && (IniY <> ""))
		Details .= " x" IniX " y" IniY " NA"
}
If SE = 1
	Details := "{Click, " Details "}", Type := cType13
Else
	Type := cType3
return

f_Point:
Action := Action2, Details := IniX ", " IniY ", 0"
If MRel = 1
	Details := "Rel " Details
If SE = 1
	Details := "{Click, " Details "}", Type := cType13
Else
	Type := cType3
return

f_PClick:
Action := Button " " Action3, Details := IniX ", " IniY " " Button
If MHold = 1
	Details .= ", Down"
If MHold = -1
	Details .= ", Up"
If MRel = 1
	Details := "Rel " Details
If MHold = 0
	Details .= ", " CCount
If SE = 1
	Details := "{Click, " Details "}", Type := cType13
Else
	Type := cType3
return

f_Drag:
Action := Button " " Action4, DetailsI := IniX ", " IniY ", " Button " Down"
,	DetailsE := EndX ", " EndY ", " Button " Up"
If MRel = 1
	DetailsI := " Rel " DetailsI, DetailsE := " Rel " DetailsE
Details := "{Click, " DetailsI "}{Click, " DetailsE "}", Type := cType13
return

f_WUp:
Action := Action5
,	Details := "WheelUp"
,	Details .= ", " CCount
If SE = 1
	Details := "{Click, " Details "}", Type := cType13
Else
	Type := cType3
return

f_WDn:
Action := Action6
,	Details := "WheelDown"
,	Details .= ", " CCount
If SE = 1
	Details := "{Click, " Details "}", Type := cType13
Else
	Type := cType3
return

Click:
GuiControl, 5:, CL, 1
Gui, Submit, NoHide
GuiControl, 5:Disable, IniX
GuiControl, 5:Disable, IniY
GuiControl, 5:Disable, MouseGetI
GuiControl, 5:Disable, EndX
GuiControl, 5:Disable, EndY
GuiControl, 5:Disable, MouseGetE
GuiControl, 5:Disable, MRel
GuiControl, 5:Enable, LB
GuiControl, 5:Enable, RB
GuiControl, 5:Enable, MB
GuiControl, 5:Enable, X1
GuiControl, 5:Enable, X2
GuiControl, 5:Enable, Clicks
GuiControl, 5:Enable, CCount
GuiControl, 5:Enable, CSend
GuiControl, 5:Enable, DefCt
GuiControl, 5:Enable, GetCtrl
GuiControl, 5:Enable, Ident
GuiControl, 5:Enable, Title
GuiControl, 5:Enable, GetWin
GuiControl, 5:Enable, CL
GuiControl, 5:Enable, MHold
GoSub, CSend
GuiControl, 5:Disable%SE%, CSend
return

Point:
GuiControl, 5:, CL, 1
Gui, Submit, NoHide
GuiControl, 5:Disable, EndX
GuiControl, 5:Disable, EndY
GuiControl, 5:Disable, MouseGetE
GuiControl, 5:Enable, IniX
GuiControl, 5:Enable, IniY
GuiControl, 5:Enable, MouseGetI
GuiControl, 5:Enable, MRel
GuiControl, 5:Disable, LB
GuiControl, 5:Disable, RB
GuiControl, 5:Disable, MB
GuiControl, 5:Disable, X1
GuiControl, 5:Disable, X2
GuiControl, 5:Disable, Clicks
GuiControl, 5:Disable, CCount
GuiControl, 5:Enable, CSend
GuiControl, 5:Disable, CSend
GuiControl, 5:Disable, DefCt
GuiControl, 5:Disable, GetCtrl
GuiControl, 5:Disable, Ident
GuiControl, 5:Disable, Title
GuiControl, 5:Disable, GetWin
GuiControl, 5:Enable, CL
GuiControl, 5:Disable, MHold
GuiControl, 5:Disable, CSend
return

PClick:
GuiControl, 5:, CL, 1
Gui, Submit, NoHide
GuiControl, 5:Disable, EndX
GuiControl, 5:Disable, EndY
GuiControl, 5:Disable, MouseGetE
GuiControl, 5:Enable, IniX
GuiControl, 5:Enable, IniY
GuiControl, 5:Enable, MouseGetI
GuiControl, 5:Enable, MRel
GuiControl, 5:Enable, LB
GuiControl, 5:Enable, RB
GuiControl, 5:Enable, MB
GuiControl, 5:Enable, X1
GuiControl, 5:Enable, X2
GuiControl, 5:Enable, Clicks
GuiControl, 5:Enable, CCount
GuiControl, 5:Enable, CSend
GuiControl, 5:Disable, CSend
GuiControl, 5:Disable, DefCt
GuiControl, 5:Disable, GetCtrl
GuiControl, 5:Disable, Ident
GuiControl, 5:Disable, Title
GuiControl, 5:Disable, GetWin
GuiControl, 5:Enable, CL
GuiControl, 5:Enable, MHold
GuiControl, 5:Disable, CSend
return

Drag:
Gui, Submit, NoHide
GuiControl, 5:Enable, IniX
GuiControl, 5:Enable, IniY
GuiControl, 5:Enable, MouseGetI
GuiControl, 5:Enable, EndX
GuiControl, 5:Enable, EndY
GuiControl, 5:Enable, MouseGetE
GuiControl, 5:Enable, MRel
GuiControl, 5:Enable, LB
GuiControl, 5:Enable, RB
GuiControl, 5:Enable, MB
GuiControl, 5:Enable, X1
GuiControl, 5:Enable, X2
GuiControl, 5:Disable, Clicks
GuiControl, 5:Disable, CCount
GuiControl, 5:Disable, CSend
GuiControl, 5:Disable, DefCt
GuiControl, 5:Disable, GetCtrl
GuiControl, 5:Disable, Ident
GuiControl, 5:Disable, Title
GuiControl, 5:Disable, GetWin
GuiControl, 5:, SE, 1
GuiControl, 5:Disable, CL
GuiControl, 5:Disable, MHold
GuiControl, 5:Disable, CSend
return

WUp:
GuiControl, 5:, CL, 1
Gui, Submit, NoHide
GuiControl, 5:Disable, IniX
GuiControl, 5:Disable, IniY
GuiControl, 5:Disable, MouseGetI
GuiControl, 5:Disable, EndX
GuiControl, 5:Disable, EndY
GuiControl, 5:Disable, MouseGetE
GuiControl, 5:Disable, MRel
GuiControl, 5:Disable, LB
GuiControl, 5:Disable, RB
GuiControl, 5:Disable, MB
GuiControl, 5:Disable, X1
GuiControl, 5:Disable, X2
GuiControl, 5:Enable, Clicks
GuiControl, 5:Enable, CCount
GuiControl, 5:Enable, CSend
GuiControl, 5:Enable, DefCt
GuiControl, 5:Enable, GetCtrl
GuiControl, 5:Enable, Ident
GuiControl, 5:Enable, Title
GuiControl, 5:Enable, GetWin
GuiControl, 5:Enable, CL
GuiControl, 5:Disable, MHold
GuiControl, 5:Disable%SE%, CSend
GoSub, CSend
return

WDn:
GuiControl, 5:, CL, 1
Gui, Submit, NoHide
GuiControl, 5:Disable, IniX
GuiControl, 5:Disable, IniY
GuiControl, 5:Disable, MouseGetI
GuiControl, 5:Disable, EndX
GuiControl, 5:Disable, EndY
GuiControl, 5:Disable, MouseGetE
GuiControl, 5:Disable, MRel
GuiControl, 5:Disable, LB
GuiControl, 5:Disable, RB
GuiControl, 5:Disable, MB
GuiControl, 5:Disable, X1
GuiControl, 5:Disable, X2
GuiControl, 5:Enable, Clicks
GuiControl, 5:Enable, CCount
GuiControl, 5:Enable, CSend
GuiControl, 5:Enable, DefCt
GuiControl, 5:Enable, GetCtrl
GuiControl, 5:Enable, Ident
GuiControl, 5:Enable, Title
GuiControl, 5:Enable, GetWin
GuiControl, 5:Enable, CL
GuiControl, 5:Disable, MHold
GuiControl, 5:Disable%SE%, CSend
GoSub, CSend
return

CL:
Gui, Submit, NoHide
GuiControl, 5:Enable, CSend
GuiControl, 5:Enable, DefCt
GuiControl, 5:Enable, GetCtrl
GuiControl, 5:Enable, Ident
GuiControl, 5:Enable, Title
GuiControl, 5:Enable, GetWin
If Click = 1
	GoSub, Click
If Point = 1
	GoSub, Point
If PClick = 1
	GoSub, PClick
If Drag = 1
	GoSub, Drag
If WUp = 1
	GoSub, WUp
If WDn = 1
	GoSub, WDn
return

SE:
Gui, Submit, NoHide
GuiControl, 5:Disable, CSend
GuiControl, 5:Disable, DefCt
GuiControl, 5:Disable, GetCtrl
GuiControl, 5:Disable, Ident
GuiControl, 5:Disable, Title
GuiControl, 5:Disable, GetWin
GuiControl, 5:, MRel, 0
return

MRel:
Gui, Submit, NoHide
If ((Click = 1) || (WUp = 1) || (WDn = 1))
{
	GuiControl, 5:Enable%MRel%, DefCt
	GuiControl, 5:Enable%MRel%, GetCtrl
}
return

MHold:
Gui, Submit, NoHide
If MHold = 0
{
	GuiControl, 5:Enable, Clicks
	GuiControl, 5:Enable, CCount
}
If MHold = 1
{
	GuiControl, 5:Disable, Clicks
	GuiControl, 5:Disable, CCount
}
If MHold = -1
{
	GuiControl, 5:Disable, Clicks
	GuiControl, 5:Disable, CCount
}
return

MouseGetI:
CoordMode, Mouse, %CoordMouse%
Gui, Submit, NoHide
NoKey := 1
WinMinimize, ahk_id %CmdWin%
SetTimer, WatchCursor, 100
StopIt := 0
WaitFor.Key("RButton")
SetTimer, WatchCursor, off
ToolTip
Sleep, 200
NoKey := 0
WinActivate, ahk_id %CmdWin%
If (StopIt)
	Exit
GuiControlGet, CtrlState, Enabled, DefCt
If (A_GuiControl = "MouseGet")
{
	GuiControl,, Par2File, %xPos%
	GuiControl,, Par3File, %yPos%
	return
}
If CtrlState = 1
{
	GuiControl,, IniX, %xcpos%
	GuiControl,, IniY, %ycpos%
}
Else
{
	GuiControl,, IniX, %xPos%
	GuiControl,, IniY, %yPos%
}
StopIt := 1
return

MouseGetE:
CoordMode, Mouse, %CoordMouse%
NoKey := 1
WinMinimize, ahk_id %CmdWin%
SetTimer, WatchCursor, 100
StopIt := 0
WaitFor.Key("RButton")
SetTimer, WatchCursor, off
ToolTip
Sleep, 200
NoKey := 0
WinActivate, ahk_id %CmdWin%
If (StopIt)
	Exit
GuiControl,, EndX, %xPos%
GuiControl,, EndY, %yPos%
StopIt := 1
return

GetEl:
Gui, Submit, NoHide
Gui, 24:+OwnDialogs
If (TabControl = 2)
{
	If ((ComHwnd = "") || (ComCLSID = ""))
	{
		MsgBox, 16, %d_Lang007%, %d_Lang048%
		return
	}
}
Else
	ControlGet, SelIEWinName, Choice,, ComboBox2, ahk_id %CmdWin%
CoordMode, Mouse, Window
NoKey := 1
WinMinimize, ahk_id %CmdWin%
ComObjError(false)
If (TabControl = 2)
	o_ie := %ComHwnd%
Else
{
	SelIEWin := IEWindows
	If (SelIEWinName = "[blank]")
		o_ie := ""
	Else
	{
		o_ie := IEGet(SelIEWinName)
		DetectHiddenWindows, On
		WinActivate, %SelIEWinName%
		DetectHiddenWindows, Off
	}
}
If !IsObject(o_ie)
{
	o_ie := COMInterface("Visible := true")
	COMInterface("Navigate(about:blank)", o_ie)
}
SetTimer, WatchCursorIE, 100
StopIt := 0
WaitFor.Key("RButton")
SetTimer, WatchCursorIE, off
ToolTip
Sleep, 200
NoKey := 0
WinActivate, ahk_id %CmdWin%
If (StopIt)
{
	ComObjError(true)
	Exit
}
If (oel_%Ident% <> "")
{
	ElIndex := GetElIndex(Element, Ident)
	GuiControl,, DefEl, % oel_%Ident%
	GuiControl,, DefElInd, %ElIndex%
}
Else If (oel_Name <> "")
{
	ElIndex := GetElIndex(Element, "Name"), f_ident := "Name"
	GuiControl,, DefEl, % oel_Name
	GuiControl,, DefElInd, %ElIndex%
	GuiControl, ChooseString, Ident, Name
}
Else If (oel_ID <> "")
{
	ElIndex := GetElIndex(Element, "ID")
	GuiControl,, DefEl, %oel_ID%
	GuiControl,, DefElInd, %ElIndex%
	GuiControl, ChooseString, Ident, ID
}
Else If (oel_TagName <> "")
{
	ElIndex := GetElIndex(Element, "TagName")
	GuiControl,, DefEl, %oel_tagName%
	GuiControl,, DefElInd, %ElIndex%
	GuiControl, ChooseString, Ident, TagName
}
Else If (oel_InnerText <> "")
{
	ElIndex := GetElIndex(Element, "Links")
	GuiControl,, DefEl, Links
	GuiControl,, DefElInd, %ElIndex%
	GuiControl, ChooseString, Ident, Links
}
If (TabControl = 2)
{
	Gui, Submit, NoHide
	ComExpSc := IEComExp("", "", oel_%Ident%, ElIndex, "", Ident)
,	ComExpSc := SubStr(ComExpSc, 4, StrLen(ComExpSc)-6)
	GuiControl,, ComSc, %ComExpSc%
}
ComObjError(true)
StopIt := 1
return

GetCtrl:
CoordMode, Mouse, %CoordMouse%
NoKey := 1
WinMinimize, ahk_id %CmdWin%
SetTimer, WatchCursor, 100
StopIt := 0
WaitFor.Key("RButton")
SetTimer, WatchCursor, off
ToolTip
Sleep, 200
NoKey := 0
WinActivate, ahk_id %CmdWin%
If (StopIt)
	Exit
GuiControl,, DefCt, %control%
GuiControl,, Title, ahk_class %class%
FoundTitle := "ahk_class " class, Window := "ahk_class " class, StopIt := 1
return

GetWin:
CoordMode, Mouse, %CoordMouse%
Gui, Submit, NoHide
NoKey := 1
WinMinimize, ahk_id %CmdWin%
SetTimer, WatchCursor, 100
StopIt := 0
WaitFor.Key("RButton")
SetTimer, WatchCursor, off
ToolTip
Sleep, 200
NoKey := 0
WinActivate, ahk_id %CmdWin%
If (StopIt)
	Exit
If Ident = Title
{
	If Label = IfGet
	{
		FoundTitle := Title
		return
	}
	GuiControl,, Title, %Title%
}
Else If Ident = Class
{
	GuiControl,, Title, ahk_class %class%
	FoundTitle := "ahk_class " class
}
Else If Ident = Process
{
	GuiControl,, Title, ahk_exe %pname%
	FoundTitle := "ahk_exe " pname
}
Else If Ident = ID
{
	GuiControl,, Title, ahk_id %id%
	FoundTitle := "ahk_id " id
}
Else If Ident = PID
{
	GuiControl,, Title, ahk_pid %pid%
	FoundTitle := "ahk_pid " pid
}
StopIt := 1
return

WinGetP:
CoordMode, Mouse, %CoordMouse%
Gui, Submit, NoHide
NoKey := 1
WinMinimize, ahk_id %CmdWin%
SetTimer, WatchCursor, 100
StopIt := 0
WaitFor.Key("RButton")
WinGetPos, X, Y, W, H, ahk_id %id%
SetTimer, WatchCursor, off
ToolTip
Sleep, 200
NoKey := 0
WinActivate, ahk_id %CmdWin%
If (StopIt)
	Exit
GuiControl,, PosX, %X%
GuiControl,, PosY, %Y%
GuiControl,, SizeX, %W%
GuiControl,, SizeY, %H%
StopIt := 1
return

CtrlGetP:
CoordMode, Mouse, %CoordMouse%
Gui, Submit, NoHide
NoKey := 1
WinMinimize, ahk_id %CmdWin%
SetTimer, WatchCursor, 100
StopIt := 0
WaitFor.Key("RButton")
ControlGetPos, X, Y, W, H, %control%, ahk_id %id%
SetTimer, WatchCursor, off
ToolTip
Sleep, 200
NoKey := 0
WinActivate, ahk_id %CmdWin%
If (StopIt)
	Exit
GuiControl,, PosX, %X%
GuiControl,, PosY, %Y%
GuiControl,, SizeX, %W%
GuiControl,, SizeY, %H%
StopIt := 1
return

Screenshot:
Gui, +OwnDialogs
If !IsFunc("Gdip_Startup")
{
	MsgBox, 17, %d_Lang007%, %d_Lang040%
	IfMsgBox, OK
		Run, http://www.autohotkey.com/board/topic/29449-gdi-standard-library
	return
}
SS := 1
GetArea:
Gui, Submit, NoHide
Draw := 1
WinMinimize, ahk_id %CmdWin%
FirstCall := True
CoordMode, Mouse, Screen
Gui, 20:-Caption +ToolWindow +LastFound +AlwaysOnTop
Gui, 20:Color, Red
SetTimer, WatchCursor, 100
Return

DrawStart:
SetTimer, WatchCursor, Off
CoordMode, Mouse, %CoordPixel%
MouseGetPos, iX, iY
CoordMode, Mouse, Screen
MouseGetPos, OriginX, OriginY
SetTimer, DrawRectangle, 0
KeyWait, %DrawButton%
GoSub, DrawEnd
Return

DrawEnd:
SetTimer, DrawRectangle, Off
FirstCall := True
ToolTip
CoordMode, Mouse, %CoordPixel%
MouseGetPos, eX, eY
If ((iX = eX) || (iY = eY))
	MarkArea(LineW)
Else
	GoSub, ShowAreaTip
If OnRelease
	GoSub, Restore
Return

Restore:
Tooltip
Gui, 20:+LastFound
WinGetPos, wX, wY, wW, wH
Gui, 20:Cancel
AdjustCoords(iX, iY, eX, eY)
Sleep, 200
Draw := 0
If SS = 1
{
	If (ScreenDir = "")
		ScreenDir := A_AppData "\MacroCreator\Screenshots"
	IfNotExist, %ScreenDir%
		FileCreateDir, %ScreenDir%
	file := ScreenDir "\Screen_" A_Now ".png", screen := wX "|" wY "|" wW "|" wH
	Screenshot(file, screen)
	GuiControl, 19:, ImgFile, %file%
	GoSub, MakePrev
	SS := 0
	WinActivate, ahk_id %CmdWin%
	return
}
If ((iX = eX) || (iY = eY)) && (control <> "")
	GuiControl, 19:ChooseString, CoordPixel, Window
iX := wX, iY := wY, eX := wX + wW, eY := wY + wH
WinActivate, ahk_id %CmdWin%
GuiControl, 19:, iPosX, %iX%
GuiControl, 19:, iPosY, %iY%
GuiControl, 19:, ePosX, %eX%
GuiControl, 19:, ePosY, %eY%
return

GetPixel:
CoordMode, Mouse, %CoordPixel%
NoKey := 1
WinMinimize, ahk_id %CmdWin%
SetTimer, WatchCursor, 10
StopIt := 0
WaitFor.Key("RButton")
SetTimer, WatchCursor, off
ToolTip
Sleep, 200
NoKey := 0
WinActivate, ahk_id %CmdWin%
If (StopIt)
	Exit
If (A_GuiControl = "TransCS")
{
	GuiControl, 19:, TransC, %color%
}
Else
{
	GuiControl,, ImgFile, %color%
	GuiControl, +Background%color%, ColorPrev
}
StopIt := 1
return

WatchCursor:
CoordMode, Mouse, % (Draw) ? CoordPixel : CoordMouse
MouseGetPos, xPos, yPos, id, control
WinGetTitle, title, ahk_id %id%
WinGetClass, class, ahk_id %id%
WinGetText, text, ahk_id %id%
text := SubStr(text, 1, 50)
WinGet, pid, PID, ahk_id %id%
PixelGetColor, color, %xPos%, %yPos%, RGB
WinGet, pname, ProcessName, ahk_id %id%
ControlGetPos, cX, cY, cW, cH, %control%, ahk_id %id%
xcpos := Controlpos(xPos, cx), ycpos := Controlpos(yPos, cy)
If Draw
	ToolTip,
	(LTrim
	X%xPos% Y%yPos%
	%c_Lang004%: %control%
	%d_Lang034%
	)
Else
	ToolTip,
	(LTrim
	X%xPos% Y%yPos%
	%c_Lang004%: %control% X%xcpos% Y%ycpos%
	%d_Lang018%: %color%
	
	WinTitle: %title%
	Class: %class%
	Process: %pname%
	ID: %id%
	PID: %pid%
	
	WinText: %text% (...)
	
	%d_Lang017%
	)
return

WatchCursorIE:
CoordMode, Mouse, Window
MouseGetPos, xPos, yPos, id
WinGetClass, class, ahk_id %id%
If (class <> "IEFrame")
{
	Tooltip, %d_Lang045%
	return
}
If (L_Label = "InternetExplorer.Application")
	Tooltip, %d_Lang017%
Else
{
	ControlGetPos, IEFrameX, IEFrameY, IEFrameW, IEFrameH, Internet Explorer_Server1, ahk_class IEFrame
	Element := o_ie.document.elementFromPoint(xPos-IEFrameX, yPos-IEFrameY)
,	oel_Name := Element.Name, oel_ID := Element.ID
,	oel_TagName := Element.TagName, oel_Value := Element.Value
,	oel_InnerText := (StrLen(Element.InnerText) > 50) ? SubStr(Element.InnerText, 1, 50) "..." : Element.InnerText
,	oel_Type := Element.Type
,	oel_Checked := Element.Checked, oel_SelectedIndex := Element.SelectedIndex
,	oel_SourceIndex := Element.sourceindex, oel_Links := "Links"
,	oel_OffsetLeft := Element.OffsetLeft, oel_OffsetTop := Element.OffsetTop

	Tooltip  % "Name: " oel_Name
		. "`nID: " oel_ID
		. "`nTagName: " oel_TagName
		. "`nValue: " oel_Value
		. "`nInnerText: " oel_InnerText
		. "`nType: " oel_Type
		. "`nChecked: " oel_Checked
		. "`nSelectedIndex: " oel_SelectedIndex
		. "`nSourceIndex: " oel_SourceIndex
		. "`nPosition: " oel_OffsetLeft " x " oel_OffsetTop
}
return

WatchCursorXL:
CoordMode, Mouse, Window
MouseGetPos, xPos, yPos, id
WinGetClass, class, ahk_id %id%
If (class <> "XLMAIN")
{
	Tooltip, %d_Lang054%
	return
}
Tooltip, %d_Lang017%
return

DrawRectangle:
CoordMode, Mouse, Screen
MouseGetPos, X2, Y2
; Has the mouse moved?
If (XO = X2) && (YO = Y2)
  Return
Gui, 20:+LastFound
XO := X2, YO := Y2
; Allow dragging to the left of the click point.
If (X2 < OriginX)
  X1 := X2, X2 := OriginX
Else
  X1 := OriginX
; Allow dragging above the click point.
If (Y2 < OriginY)
  Y1 := Y2, Y2 := OriginY
Else
  Y1 := OriginY
; Draw the rectangle
W1 := X2 - X1, H1 := Y2 - Y1, W2 := W1 - LineW, H2 := H1 - LineW
WinSet, Region, 0-0 %W1%-0 %W1%-%H1% 0-%H1% 0-0  %LineW%-%LineW% %W2%-%LineW% %W2%-%H2% %LineW%-%H2% %LineW%-%LineW%
If (FirstCall) {
  Gui, 20:Show, NA x%X1% y%Y1% w%W1% h%H1%
  FirstCall := False
}
WinMove, , , X1, Y1, W1, H1
If ((X2 > OriginX) || (Y2 > OriginY))
	ToolTip, X%X1% Y%Y1%`nX%X2% Y%Y2%`n%d_Lang034%
Else
	ToolTip, X%X1% Y%Y1%`nX%X2% Y%Y2%`n%d_Lang034%, % OriginX +8, % OriginY +8
Return

ShowAreaTip:
Gui, 20:+LastFound
WinGetPos,,, gwW, gwH
Tooltip,
(
%c_Lang059%: %gwW% x %gwH%
%d_Lang057%
)
return

SpecKeys:
GoSub, TextCancel
Special:
Gui, 7:+owner1 -MaximizeBox -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
spKey := ""
; Gui, 7:Font, s7
Gui, 7:Add, GroupBox, W400 H170 , %c_Lang103%:
Gui, 7:Add, Radio, -Wrap ys+20 xs+10 Group W120 vBrowser_Back gSpecKey R1, %c_Lang104%
Gui, 7:Add, Radio, -Wrap ys+20 xp+120 W120 vBrowser_Forward gSpecKey R1, %c_Lang105%
Gui, 7:Add, Radio, -Wrap ys+20 xp+120 W120 vBrowser_Refresh gSpecKey R1, %c_Lang106%
Gui, 7:Add, Radio, -Wrap ys+40 xs+10 W120 vBrowser_Stop gSpecKey R1, %c_Lang107%
Gui, 7:Add, Radio, -Wrap ys+40 xp+120 W120 vBrowser_Search gSpecKey R1, %c_Lang108%
Gui, 7:Add, Radio, -Wrap ys+40 xp+120 W120 vBrowser_Favorites gSpecKey R1, %c_Lang109%
Gui, 7:Add, Radio, -Wrap ys+60 xs+10 W120 vBrowser_Home gSpecKey R1, %c_Lang110%
Gui, 7:Add, Radio, -Wrap ys+60 xp+120 W120 vLaunch_Media gSpecKey R1, %c_Lang111%
Gui, 7:Add, Radio, -Wrap ys+60 xp+120 W120 vVolume_Mute gSpecKey R1, %c_Lang112%
Gui, 7:Add, Radio, -Wrap ys+80 xs+10 W120 vVolume_Up gSpecKey R1, %c_Lang113%
Gui, 7:Add, Radio, -Wrap ys+80 xp+120 W120 vVolume_Down gSpecKey R1, %c_Lang114%
Gui, 7:Add, Radio, -Wrap ys+80 xp+120 W125 vMedia_Play_Pause gSpecKey R1, %c_Lang115%
Gui, 7:Add, Radio, -Wrap ys+100 xs+10 W120 vMedia_Prev gSpecKey R1, %c_Lang116%
Gui, 7:Add, Radio, -Wrap ys+100 xp+120 W120 vMedia_Next gSpecKey R1, %c_Lang117%
Gui, 7:Add, Radio, -Wrap ys+100 xp+120 W120 vMedia_Stop gSpecKey R1, %c_Lang118% 
Gui, 7:Add, Radio, -Wrap ys+120 xs+10 W120 vLaunch_Mail gSpecKey R1, %c_Lang119%
Gui, 7:Add, Radio, -Wrap ys+120 xp+120 W120 vLaunch_App1 gSpecKey R1, %c_Lang120%
Gui, 7:Add, Radio, -Wrap ys+120 xp+120 W120 vLaunch_App2 gSpecKey R1, %c_Lang121%
Gui, 7:Add, Radio, -Wrap ys+140 xs+10 W90 vScanCode gSpecKey R1, %c_Lang122%:
Gui, 7:Add, Text, ys+140 xp+90, VK:
Gui, 7:Add, Edit, ys+138 xp+20 W50 vVKey 0x201
Gui, 7:Add, Text, ys+140 xp+60, SC:
Gui, 7:Add, Edit, ys+138 xp+20 W50 vSCode 0x201
Gui, 7:Add, Button, -Wrap yp-1 x+0 W60 gAddSC, %c_Lang123%
Gui, 7:Add, Button, -Wrap yp-1 x+10 W70 H23 gKeyHistory, %c_Lang124%
Gui, 7:Add, Button, -Wrap Section Default xm W60 H23 gSpecOK, %c_Lang020%
Gui, 7:Add, Button, -Wrap ys W60 H23 gSpecCancel, %c_Lang021%
Gui, 7:Add, Text, ys+5 xp+80 W250 vStMsg
Gui, 7:Show,, %c_Lang103%
Tooltip
Input
return

SpecKey:
spKey := A_GuiControl
return

SpecOK:
Gui, Submit, NoHide
If spKey =
	return
If spKey = ScanCode
{
	If SCode = 
	{
		GuiControl,, StMsg, %c_Lang125%
			return
	}
	Else
		spKey := (VKey <> "") ? "VK" VKey "SC" SCode : "SC" SCode
}
Else
	StringReplace, tpKey, spKey, _, %A_Space%, All
spKey := "{" spKey "}"
Gui, 1:-Disabled
Gui, 7:Destroy
Gui, 1:Default
RowSelection := LV_GetCount("Selected")
If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, spKey, spKey, 1, DelayG, cType1)
	LV_Modify(ListCount%A_List%, "Vis")
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, spKey, spKey, 1, DelayG, cType1)
		RowNumber++
	}
}
GoSub, b_Start
GoSub, RowCheck
GuiControl, Focus, InputList%A_List%
return

SpecCancel:
7GuiClose:
7GuiEscape:
Gui, 1:-Disabled
Gui, 7:Destroy
return

AddSC:
Gui, +OwnDialogs
Gui, Submit, NoHide
{
	If SCode = 
	{
		GuiControl,, StMsg, %c_Lang125%
		return
	}
	Else
	{
		VirtualKeys .= (VKey = "") ? "{SC" SCode "}" : "{VK" VKey "SC" SCode "}"
		GuiControl,, StMsg, %c_Lang126%
		Sleep, 3000
		GuiControl,, StMsg
	}
}
return

EditText:
s_Caller = Edit
Text:
Gui, Submit, NoHide
Gui, 8:+owner1 -MaximizeBox -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
; Gui, 8:Font, s7
Gui, 8:Add, Button, -Wrap W25 H25 hwndOpenT vOpenT gOpenT
	ILButton(OpenT, OpenIcon[1] ":" OpenIcon[2])
Gui, 8:Add, Button, -Wrap W25 H25 ys x+0 hwndSaveT vSaveT gSaveT
	ILButton(SaveT, SaveIcon[1] ":" SaveIcon[2])
Gui, 8:Add, Text, W2 H25 ys+2 x+5 0x11
Gui, 8:Add, Button, -Wrap W25 H25 ys x+4 hwndCutT vCutT gCutT
	ILButton(CutT, CutIcon[1] ":" CutIcon[2])
Gui, 8:Add, Button, -Wrap W25 H25 ys x+0 hwndCopyT vCopyT gCopyT
	ILButton(CopyT, CopyIcon[1] ":" CopyIcon[2])
Gui, 8:Add, Button, -Wrap W25 H25 ys x+0 hwndPasteT vPasteT gPasteT
	ILButton(PasteT, PasteIcon[1] ":" PasteIcon[2])
Gui, 8:Add, Button, -Wrap W25 H25 ys x+0 hwndSelAllT vSelAllT gSelAllT
	ILButton(SelAllT, CommentIcon[1] ":" CommentIcon[2])
Gui, 8:Add, Edit, Section xm vTextEdit gTextEdit WantTab W720 R30
Gui, 8:Add, Text, Section, %w_Lang015%:
Gui, 8:Add, Text,, %c_Lang017%:
Gui, 8:Add, Edit, ys-2 xp+75 W100 R1 vEdRept
Gui, 8:Add, UpDown, vTimesX 0x80 Range1-999999999, 1
Gui, 8:Add, Edit, W100 vDelayC
Gui, 8:Add, UpDown, vDelayX 0x80 Range0-999999999, %DelayG%
Gui, 8:Add, Button, -Wrap Section Default xm y+15 W60 H23 gTextOK, %c_Lang020%
Gui, 8:Add, Button, -Wrap ys W60 H23 gTextCancel, %c_Lang021%
Gui, 8:Add, Button, -Wrap ys W60 H23 vTextApply gTextApply Disabled, %c_Lang131%
Gui, 8:Add, Button, -Wrap ys W25 H23 hwndSpecialB vSpecialB gSpecKeys
	ILButton(SpecialB, SpecIcon[1] ":" SpecIcon[2])
Gui, 8:Add, Radio, -Wrap Section ys-45 xs+190 Checked W100 vMsc R1, %c_Lang018%
Gui, 8:Add, Radio, -Wrap W100 vSec R1, %c_Lang019%
Gui, 8:Add, Radio, -Wrap Section Group Checked ys-15 xs+100 W200 vRaw gRaw R1, %c_Lang045%
Gui, 8:Add, Radio, -Wrap W200 vComText gComText R1, %c_Lang046%
Gui, 8:Add, Radio, -Wrap W200 vClip gClip R1, %c_Lang047%
Gui, 8:Add, Radio, -Wrap W200 vEditPaste gEditPaste R1, %c_Lang048%
Gui, 8:Add, Radio, -Wrap W200 vSetText gSetText R1, %c_Lang049%
Gui, 8:Add, Checkbox, Section -Wrap ys xm+490 vCSend gCSend W140 R1, %c_Lang016%:
Gui, 8:Add, Edit, vDefCt W200 Disabled
Gui, 8:Add, Button, yp-1 x+0 W30 H23 vGetCtrl gGetCtrl Disabled, ...
Gui, 8:Add, DDL, y+5 xs W65 vIdent Disabled, Title||Class|Process|ID|PID
Gui, 8:Add, Text, -Wrap yp+5 x+5 W140 H20 vWinParsTip Disabled, %wcmd_All%
Gui, 8:Add, Edit, yp+20 xp-70 W200 vTitle Disabled, A
Gui, 8:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetWin gGetWin Disabled, ...
Gui, 8:Add, StatusBar
Gui, 8:Default
SB_SetParts(480, 80)
SB_SetText(c_Lang025, 1)
SB_SetText("length: " 0, 2)
SB_SetText("lines: " 0, 3)
If (s_Caller = "Edit")
{
	EscCom("Details|TimesX|DelayX|Target|Window", 1)
	StringReplace, Details, Details, ``n, `n, All
	GuiControl, 8:, TextEdit, %Details%
	GuiControl, 8:, TimesX, %TimesX%
	GuiControl, 8:, EdRept, %TimesX%
	GuiControl, 8:, DelayX, %DelayX%
	GuiControl, 8:, DelayC, %DelayX%
	If InStr(Type, "Control")
	{
		GuiControl, 8:, CSend, 1
		GuiControl, 8:Enable, DefCt
		GuiControl, 8:Enable, GetCtrl
		GuiControl, 8:Enable, Ident
		GuiControl, 8:Enable, Title
		GuiControl, 8:Enable, GetWin
		GuiControl, 8:, Title, %Window%
		GuiControl, 8:, DefCt, %Target%
	}
	If ((Type = cType1) || (Type = cType2))
		GuiControl, 8:, ComText, 1
	Else If ((Type = cType8) || (Type = cType9))
		GuiControl, 8:, Raw, 1
	Else If (Type = cType10)
	{
		GuiControl, 8:, SetText, 1
		GuiControl, 8:Disable, CSend
	}
	Else If (Type = cType22)
	{
		GuiControl, 8:, EditPaste, 1
		GuiControl, 8:Disable, CSend
	}
	Else If (Type = cType12)
		GuiControl, 8:, Clip, 1
	Gui, 8:Default
		GoSub, TextEdit
	Gui, 1:Default
	GuiControl, 8:Enable, TextApply
}
Else
	Window = A
Gui, 8:Show,, %c_Lang002%
GuiControl, 8:Focus, TextEdit
Input
Tooltip
return

TextApply:
TextOK:
Gui, +OwnDialogs
Gui, Submit, NoHide
StringReplace, TextEdit, TextEdit, `n, ``n, All
DelayX := InStr(DelayC, "%") ? DelayC : DelayX, TimesX := InStr(EdRept, "%") ? EdRept : TimesX
If Raw = 1
	Type := cType8
Else If ComText = 1
	Type := cType1
Else If SetText = 1
	Type := cType10
Else If EditPaste = 1
	Type := cType22
Else If Clip = 1
	Type := cType12
GuiControlGet, CtrlState, Enabled, DefCt
If CtrlState = 1
{
	If CSend = 1
	{
		If DefCt = 
		{
			MsgBox, 52, %d_Lang011%, %d_Lang012%
			IfMsgBox, No
				return
		}
		Target := DefCt, Window := Title
		If (Type = cType1)
			Type := cType2
		If (Type = cType8)
			Type := cType9
	}
	Else
	{
		If CSend = 0
		{
			Target := "", Window := ""
			If (Type = cType2)
				Type := cType1
			If (Type = cType9)
				Type := cType8
		}
	}
}
Else
	Target := "", Window := ""
Action := "[Text]"
EscCom("TextEdit|TimesX|DelayX|Target|Window")
If (A_ThisLabel <> "TextApply")
{
	Gui, 1:-Disabled
	Gui, 8:Destroy
}
Gui, 1:Default
RowSelection := LV_GetCount("Selected")
If (s_Caller = "Edit")
{
	LV_Modify(RowNumber, "Col2", Action, TextEdit, TimesX, DelayX, Type, Target, Window)
}	
Else If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, Action, TextEdit, TimesX, DelayX, Type, Target, Window)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, Action, TextEdit, TimesX, DelayX, Type, Target, Window)
		RowNumber++
	}
}
GoSub, b_Start
GoSub, RowCheck
If (A_ThisLabel = "TextApply")
	Gui, 8:Default
Else
{
	s_Caller = 
	GuiControl, Focus, InputList%A_List%
}
return

TextCancel:
8GuiClose:
8GuiEscape:
Gui, 1:-Disabled
Gui, 8:Destroy
s_Caller = 
return

Raw:
GuiControl, Enable, CSend
GuiControl, Enable, DefCt
GuiControl, Enable, GetCtrl
GoSub, CSend
return

ComText:
GuiControl, Enable, CSend
GuiControl, Enable, DefCt
GuiControl, Enable, GetCtrl
GoSub, CSend
return

SetText:
GuiControl, , CSend, 1
GuiControl, Disable, CSend
GuiControl, Enable, DefCt
GuiControl, Enable, GetCtrl
GoSub, CSend
return

Clip:
GuiControl, Enable, CSend
GuiControl, Enable, DefCt
GuiControl, Enable, GetCtrl
GoSub, CSend
return

EditPaste:
GuiControl, , CSend, 1
GuiControl, Disable, CSend
GuiControl, Enable, DefCt
GuiControl, Enable, GetCtrl
GoSub, CSend
return

TextEdit:
Gui, Submit, NoHide
StringSplit, cL, TextEdit, `n
SB_SetText("length: " StrLen(TextEdit), 2)
SB_SetText("lines: " cL0, 3)
return

OpenT:
Gui, +OwnDialogs
FileSelectFile, TextFile, 3
FreeMemory()
If !TextFile
	return
FileRead, InText, %TextFile%
GuiControl,, TextEdit, %InText%
GoSub, TextEdit
return

SaveT:
Gui, Submit, NoHide
Gui +OwnDialogs
FileSelectFile, TextFile, S16
FreeMemory()
If TextFile = 
	Exit
SplitPath, TextFile,,, ext
If (ext = "")
	TextFile .= ".txt"
IfExist %TextFile%
{
    FileDelete %TextFile%
    If ErrorLevel
    {
        MsgBox, 16, %d_Lang007%, %d_Lang006% "%TextFile%".
        return
    }
}
FileAppend, %TextEdit%, %TextFile%
return

CutT:
GuiControl, Focus, TextEdit
ControlSend, Edit1, {Control Down}{x}{Control Up}, ahk_id %CmdWin%
return

CopyT:
GuiControl, Focus, TextEdit
ControlSend, Edit1, {Control Down}{c}{Control Up}, ahk_id %CmdWin%
return

PasteT:
GuiControl, Focus, TextEdit
ControlSend, Edit1, {Control Down}{v}{Control Up}, ahk_id %CmdWin%
return

SelAllT:
GuiControl, Focus, TextEdit
ControlSend, Edit1, {Control Down}{a}{Control Up}, ahk_id %CmdWin%
return

KeyWait:
MsgBox:
Pause:
Gui, 3:+owner1 -MaximizeBox -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
Gui, 3:Add, Tab2, W305 H275 vTabControl AltSubmit, %c_Lang003%|%c_Lang015%|%c_Lang066%
; Gui, 3:Font, s7
; Sleep
Gui, 3:Add, GroupBox, Section W280 H100
Gui, 3:Add, Text, ys+15 xs+10, %c_Lang050%:
Gui, 3:Add, Edit, yp-2 xs+90 W170 vDelayC
Gui, 3:Add, UpDown, vDelayX 0x80 Range0-9999999, 300
Gui, 3:Add, Radio, -Wrap Checked W170 vMsc R1, %c_Lang018%
Gui, 3:Add, Radio, -Wrap W170 vSec R1, %c_Lang019%
Gui, 3:Add, Radio, -Wrap W170 vMin R1, %c_Lang154%
; MsgBox
Gui, 3:Tab, 2
Gui, 3:Add, GroupBox, Section ys xs W280 H235
Gui, 3:Add, Text, -Wrap Section ys+15 xs+10 W260 R1, %c_Lang051%:
Gui, 3:Add, Edit, vMsgPt W260 r6
Gui, 3:Add, Text, W260, %c_Lang025%
Gui, 3:Add, Text, yp+30 W210, %c_Lang147%:
Gui, 3:Add, Radio, -Wrap Checked W80 vNoI R1, %c_Lang148%
Gui, 3:Add, Radio, -Wrap x+5 W80 vErr R1, %c_Lang149%
Gui, 3:Add, Radio, -Wrap  x+5 W80 vQue R1, %c_Lang150%
Gui, 3:Add, Radio, -Wrap xs W80 vExc R1, %c_Lang151%
Gui, 3:Add, Radio, -Wrap x+5 W80 vInf R1, %c_Lang152%
Gui, 3:Add, Checkbox, -Wrap W125 xs vAot R1, %c_Lang153%
Gui, 3:Add, Checkbox, -Wrap Checked W125 yp xp+130 vCancelB R1, %c_Lang021%
; KeyWait
Gui, 3:Tab, 3
Gui, 3:Add, GroupBox, Section x+10 W280 H110
Gui, 3:Add, Text, -Wrap Section ys+15 xs+10 W200 R1, %c_Lang052%:
Gui, 3:Add, Hotkey, vWaitKeys gWaitKeys W260
Gui, 3:Add, Text, Section xs vTimoutT, %c_Lang053%:
Gui, 3:Add, Edit, ys-2 xs+90 W170 vTimeoutC
Gui, 3:Add, UpDown, vTimeout 0x80 Range0-999999999, 0
Gui, 3:Add, Text, xs+90, %c_Lang054%
Gui, 3:Tab
Gui, 3:Add, Button, -Wrap Section Default xm W60 H23 gPauseOK, %c_Lang020%
Gui, 3:Add, Button, -Wrap ys W60 H23 gPauseCancel, %c_Lang021%
If (A_ThisLabel = "MsgBox")
	GuiControl, 3:Choose, TabControl, 2
If (A_ThisLabel = "KeyWait")
	GuiControl, 3:Choose, TabControl, 3
Gui, 3:Show,, %c_Lang003% / %c_Lang015% / %c_Lang066%
Input
Tooltip
return

MP:
Gui, Submit, NoHide
GuiControl, Enable%MP%, MsgPt
GuiControl, Enable%MP%, NoI
GuiControl, Enable%MP%, Err
GuiControl, Enable%MP%, Que
GuiControl, Enable%MP%, Exc
GuiControl, Enable%MP%, Inf
GuiControl, Enable%MP%, Aot
GuiControl, Enable%MP%, CancelB
GuiControl, Disable%MP%, DelayC
; GuiControl, Disable%MP%, EdRept
GuiControl, Disable%MP%, DelayX
GuiControl, Disable%MP%, Msc
GuiControl, Disable%MP%, Sec
GuiControl, Disable%MP%, KW
return

KW:
Gui, Submit, NoHide
GuiControl, 3:Disable%KW%, DelayC
GuiControl, 3:Disable%KW%, EdRept
GuiControl, 3:Disable%KW%, DelayX
GuiControl, 3:Disable%KW%, Msc
GuiControl, 3:Disable%KW%, Sec
GuiControl, 3:Enable%KW%, WaitKeys
GuiControl, 3:Enable%KW%, TimeoutC
GuiControl, 3:Enable%KW%, Timeout
GuiControl, 3:Disable%KW%, MP
return

WaitKeys:
GuiA := ActiveGui(WinExist())
If %A_GuiControl% contains +^,+!,^!,+^!
	GuiControl, %GuiA%:, %A_GuiControl%
If %A_GuiControl% contains +
	GuiControl, %GuiA%:, %A_GuiControl%, Shift
If %A_GuiControl% contains ^
	GuiControl, %GuiA%:, %A_GuiControl%, Control
If %A_GuiControl% contains !
	GuiControl, %GuiA%:, %A_GuiControl%, Alt
return

PauseOK:
Gui, Submit, NoHide
DelayX := InStr(DelayC, "%") ? DelayC : DelayX
If Sec = 1
	DelayX *= 1000
Else If Min = 1
	DelayX *= 60000
If TabControl = 2
{
	StringReplace, MsgPT, MsgPT, `n, ``n, All
	StringReplace, MsgPT, MsgPT, `,, ```,, All
	Type := cType6, Details := MsgPT, DelayX := 0
	If NoI = 1
		Target := 0
	If Err = 1
		Target := 16
	If Que = 1
		Target := 32
	If Exc = 1
		Target := 48
	If Inf = 1
		Target := 64
	If Aot = 1
		Target += 262144
	If CancelB = 1
		Target += 1
}
Else If TabControl = 3
{
	If (WaitKeys = "")
		return
	Type := cType20, tKey := WaitKeys
,	Details := tKey, Target := ""
,	DelayX := InStr(TimeoutC, "%") ? TimeoutC : Timeout
}
Else If TabControl = 1
	Type := cType5, Details := "", Target := ""
Gui, 1:-Disabled
Gui, 3:Destroy
Gui, 1:Default
RowSelection := LV_GetCount("Selected")
If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, "[Pause]", Details, 1, DelayX, Type, Target)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, "[Pause]", Details, 1, DelayX, Type, Target)
		RowNumber++
	}
}
GoSub, b_Start
GoSub, RowCheck
GuiControl, Focus, InputList%A_List%
return

PauseCancel:
3GuiClose:
3GuiEscape:
Gui, 1:-Disabled
Gui, 3:Destroy
return

EditLoop:
s_Caller = Edit
ComLoop:
ComGoto:
AddLabel:
Proj_Labels := ""
Loop, %TabCount%
{
	Gui, ListView, InputList%A_Index%
	Loop, % ListCount%A_Index%
	{
		LV_GetText(Row_Type, A_Index, 6)
		If (Row_Type = cType35)
		{
			LV_GetText(Row_Label, A_Index, 3)
			Proj_Labels .= Row_Label "|"
		}
	}
}
Gui, ListView, InputList%A_List%
Loop, %TabCount%
	Proj_Labels .= "Macro" A_Index "|"
Gui, 12:+owner1 -MaximizeBox -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
; Gui, 12:Font, s7
Gui, 12:Add, Tab2, W330 H220 vTabControl AltSubmit, %c_Lang073%|%c_Lang077%|%c_Lang079%
Gui, 12:Add, Radio, -Wrap Checked ys+27 xs+15 W55 vLoop gLoopType R1, %c_Lang132%
Gui, 12:Add, Radio, -Wrap x+5 W55 vLFilePattern gLoopType R1, %c_Lang133%
Gui, 12:Add, Radio, -Wrap x+5 W55 vLParse gLoopType R1, %c_Lang134%
Gui, 12:Add, Radio, -Wrap x+5 W55 vLRead gLoopType R1, %c_Lang135%
Gui, 12:Add, Radio, -Wrap x+5 W55 R1 vLRegistry gLoopType R1, %c_Lang136%
Gui, 12:Add, Text, y+5 xs+15, %w_Lang015% (%t_Lang004%):
Gui, 12:Add, Edit, W300 R1 vEdRept
Gui, 12:Add, UpDown, vTimesX 0x80 Range0-999999999, 2
Gui, 12:Add, Text, W125 vField1, %c_Lang137%
Gui, 12:Add, CheckBox, -Wrap Check3 yp xp+130 W85 vIncFolders Disabled R1, %c_Lang138%
Gui, 12:Add, CheckBox, -Wrap yp xp+85 W85 vRecurse Disabled R1, %c_Lang139%
Gui, 12:Add, Edit, y+5 xs+15 W270 R1 vLParamsFile Disabled
Gui, 12:Add, Button, -Wrap yp-1 x+0 W30 H23 vSearchLParams gSearch Disabled, ...
Gui, 12:Add, Text, y+5 xs+15 W150 vField2, %c_Lang141%
Gui, 12:Add, Text, yp xp+155 W150 vField3, %c_Lang142%
Gui, 12:Add, Edit, y+5 xs+15 W145 R1 vDelim Disabled
Gui, 12:Add, Edit, yp x+10 W145 R1 vOmit Disabled
Gui, 12:Add, Text, y+5 xs+15 r1, %c_Lang074%
Gui, 12:Add, Text, y+5 r1, %c_Lang025%
Gui, 12:Add, Button, -Wrap Section Default xm W60 H23 gLoopOK, %c_Lang020%
Gui, 12:Add, Button, -Wrap ys W60 H23 gLoopCancel, %c_Lang021%
Gui, 12:Add, Button, -Wrap ys W60 H23 vLoopApply gLoopApply Disabled, %c_Lang131%
Gui, 12:Add, Button, -Wrap ys W60 H23 gAddBreak, %c_Lang075%
Gui, 12:Add, Button, -Wrap ys W60 H23 gAddContinue, %c_Lang076%
Gui, 12:Tab, 2
Gui, 12:Add, Text, y+5 xs+15, %c_Lang078%:
Gui, 12:Add, ComboBox, W300 vGoLabel, %Proj_Labels%
Gui, 12:Add, Radio, Checked vGoto, Goto
Gui, 12:Add, Radio, yp x+25 vGosub, Gosub
Gui, 12:Add, Text, y+5 xs+15 r1, %c_Lang025%
Gui, 12:Add, Button, -Wrap Section xm ys W60 H23 gGotoOK, %c_Lang020%
Gui, 12:Add, Button, -Wrap ys W60 H23 gLoopCancel, %c_Lang021%
Gui, 12:Tab, 3
Gui, 12:Add, Text, y+5 xs+15, %c_Lang080%:
Gui, 12:Add, Edit, W300 R1 vNewLabel
Gui, 12:Add, Button, -Wrap Section xm ys W60 H23 gLabelOK, %c_Lang020%
Gui, 12:Add, Button, -Wrap ys W60 H23 gLoopCancel, %c_Lang021%
If (s_Caller = "Edit")
{
	EscCom("Details|TimesX|DelayX", 1)
	StringReplace, Details, Details, ```,, ¢, All
	Loop, Parse, Details, `,, %A_Space%
	{
		Par%A_Index% := A_LoopField
		StringReplace, Par%A_Index%,  Par%A_Index%, ¢, ```,, All
	}
	If (Type = cType7)
		GuiControl, 12:, TimesX, %TimesX%
	If (Type = cType38)
	{
		GuiControl, 12:, LParamsFile, %Details%
		GuiControl, 12:, LRead, 1
	}
	If (Type = cType39)
	{
		GuiControl, 12:, LParamsFile, %Par1%
		GuiControl, 12:, Delim, %Par2%
		GuiControl, 12:, Omit, %Par3%
		GuiControl, 12:, LParse, 1
	}
	If (Type = cType40)
	{
		GuiControl, 12:, LParamsFile, %Par1%
		GuiControl, 12:, IncFolders, % ((Par2 = 2) ? -1 : Par2)
		GuiControl, 12:, Recurse, %Par3%
		GuiControl, 12:, LFilePattern, 1
	}
	If (Type = cType41)
	{
		GuiControl, 12:, Delim, %Par1%
		GuiControl, 12:, LParamsFile, %Par2%
		GuiControl, 12:, IncFolders, % ((Par3 = 2) ? -1 : Par3)
		GuiControl, 12:, Recurse, %Par4%
		GuiControl, 12:, LRegistry, 1
	}
	GuiControl, 12:, TabControl, |%c_Lang073%
	GuiControl, 12:Enable, LoopApply
	GoSub, LoopType
}
Else If (A_ThisLabel = "AddLabel")
	GuiControl, 12:Choose, TabControl, 2
Else If (A_ThisLabel = "ComGoto")
	GuiControl, 12:Choose, TabControl, 3
Gui, 12:Show,, %c_Lang073%
Input
Tooltip
return

LoopApply:
LoopOK:
Gui, +OwnDialogs
Gui, Submit, NoHide
If (LRead = 1)
{
	If (LParamsFile = "")
		return
	Details := RTrim(LParamsFile, ", ")
,	TimesX := 1, Type := cType38
}
Else If (LParse = 1)
{
	If (LParamsFile = "")
		return
	Try
		z_Check := VarSetCapacity(%LParamsFile%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%
		return
	}
	Details := LParamsFile ", " Delim ", " Omit
,	TimesX := 1, Type := cType39
}
Else If (LFilePattern = 1)
{
	If (LParamsFile = "")
		return
	Details := LParamsFile ", " ((IncFolders = -1) ? 2 : IncFolders) ", " Recurse
,	TimesX := 1, Type := cType40
}
Else If (LRegistry = 1)
{
	If (Delim = "")
		return
	Details := Delim ", " LParamsFile ", " ((IncFolders = -1) ? 2 : IncFolders) ", " Recurse
,	TimesX := 1, Type := cType41
}
Else
{
	Details := "LoopStart", Type := cType7
,	TimesX := InStr(EdRept, "%") ? EdRept : TimesX
}
EscCom("Details")
If (A_ThisLabel <> "LoopApply")
{
	Gui, 1:-Disabled
	Gui, 12:Destroy
}
Gui, 1:Default
RowSelection := LV_GetCount("Selected")
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col3", Details, TimesX, DelayX, Type)
Else If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, "[LoopStart]", Details, TimesX, 0, Type)
	LV_Add("Check", ListCount%A_List%+2, "[LoopEnd]", "LoopEnd", 1, 0, "Loop")
	LV_Modify(ListCount%A_List%+2, "Vis")
}
Else
{
	LV_Insert(LV_GetNext(), "Check", "", "[LoopStart]", Details, TimesX, 0, Type)
	RowNumber := 0, LastRow := 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If !RowNumber
		{
			LV_Insert(LastRow+1, "Check",LastRow+1, "[LoopEnd]", "LoopEnd", 1, 0, "Loop")
			break
		}
		LastRow := LV_GetNext(LastRow)
	}
}
GoSub, b_Start
GoSub, RowCheck
If (A_ThisLabel = "LoopApply")
	Gui, 12:Default
Else
{
	s_Caller =
	GuiControl, Focus, InputList%A_List%
}
return

GotoOK:
Gui, +OwnDialogs
Gui, Submit, NoHide
If (GoLabel = "")
	return
If RegExMatch(GoLabel, "[\s,``]")
{
	MsgBox, 16, %d_Lang007%, %d_Lang049%
	return
}
Gui, 1:-Disabled
Gui, 12:Destroy
Gui, 1:Default
RowSelection := LV_GetCount("Selected"), Type := (Goto = 1) ? "Goto" : "Gosub"
If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, "[Goto]", GoLabel, 1, 0, Type)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
	LV_Insert(LV_GetNext(), "Check", "", "[Goto]", GoLabel, 1, 0, Type)
GoSub, b_Start
GoSub, RowCheck
GuiControl, Focus, InputList%A_List%
return

LabelOK:
Gui, +OwnDialogs
Gui, Submit, NoHide
If (NewLabel = "")
	return
Try
	z_Check := VarSetCapacity(%NewLabel%)
Catch
{
	MsgBox, 16, %d_Lang007%, %d_Lang049%
	return
}
Loop, Parse, Proj_Labels, |
	If (A_LoopField = NewLabel)
	{
		MsgBox, 16, %d_Lang007%, %d_Lang050%
		return
	}
Gui, 1:-Disabled
Gui, 12:Destroy
Gui, 1:Default
RowSelection := LV_GetCount("Selected")
If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, "[Label]", NewLabel, 1, 0, cType35)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
	LV_Insert(LV_GetNext(), "Check", "", "[Label]", NewLabel, 1, 0, cType35)
GoSub, b_Start
GoSub, RowCheck
GuiControl, Focus, InputList%A_List%
return

LoopCancel:
12GuiClose:
12GuiEscape:
Gui, 1:-Disabled
Gui, 12:Destroy
s_Caller = 
return

LoopS:
GuiControl, Enable, EdRept
GuiControl, Enable, TimesX
return

LoopE:
GuiControl, Disable, EdRept
GuiControl, Disable, TimesX
return

AddBreak:
AddContinue:
Gui, Submit, NoHide
Gui, 1:-Disabled
Gui, 12:Destroy
Gui, 1:Default
Type := LTrim(A_ThisLabel, "Add"), RowSelection := LV_GetCount("Selected")
If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, Type, "", 1, 0, Type)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
	LV_Insert(LV_GetNext(), "Check", "", Type, "", 1, 0, Type)
GoSub, b_Start
GoSub, RowCheck
GuiControl, Focus, InputList%A_List%
return

LoopType:
Gui, 12:Submit, NoHide
GuiControl, 12:Enable%Loop%, EdRept
GuiControl, 12:Disable%Loop%, LParamsFile
GuiControl, 12:Enable%LParse%, Omit
If (LFilePattern || LRegistry)
{
	GuiControl, 12:Enable, IncFolders
	GuiControl, 12:Enable, Recurse
}
Else
{
	GuiControl, 12:Disable, IncFolders
	GuiControl, 12:Disable, Recurse
}
If (LParse || LRegistry)
	GuiControl, 12:Enable, Delim
Else
	GuiControl, 12:Disable, Delim
If (LRead || LFilePattern)
	GuiControl, 12:Enable, SearchLParams
Else
	GuiControl, 12:Disable, SearchLParams
GuiControl, 12:, Field1, % (LParse ? c_Lang140 : (LRead ? c_Lang143 : (LRegistry ? c_Lang144 : c_Lang137)))
GuiControl, 12:, Field2, % (LRegistry ? c_Lang145 : c_Lang141)
GuiControl, 12:Text, IncFolders, % (LRegistry ? c_Lang146 : c_Lang138)
return

EditWindow:
s_Caller = Edit
Window:
Gui, 11:+owner1 -MaximizeBox -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
; Gui, 11:Font, s7
Gui, 11:Add, DDL, W120 vWinCom gWinCom, %WinCmdList%
Gui, 11:Add, Text, xm W120, %c_Lang055%:
Gui, 11:Add, DDL, xm W120 -Multi vWCmd gWCmd, %WinCmd%
Gui, 11:Add, Text, vTValue Disabled, 255
Gui, 11:Add, Slider, yp+10 Buddy2TValue vN gN Range0-255 Disabled, 255
Gui, 11:Add, Radio, -Wrap Checked yp+2 xp+150 vAoT R1, Toggle
Gui, 11:Add, Radio, -Wrap yp xp+70 R1, On
Gui, 11:Add, Radio, -Wrap yp xp+70 R1, Off
Gui, 11:Add, Text, xm W80 vValueT, %c_Lang056%:
Gui, 11:Add, Edit, xm W380 -Multi Disabled vValue
Gui, 11:Add, Text, xm W180, %c_Lang057%:
Gui, 11:Add, Edit, xm W380 -Multi Disabled vVarName
Gui, 11:Add, DDL, Section xm W65 vIdent, Title||Class|Process|ID|PID
Gui, 11:Add, Text, -Wrap yp+5 x+5 W240 H20 vWinParsTip Disabled, %wcmd_WinSet%
Gui, 11:Add, Edit, xm W350 vTitle, A
Gui, 11:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetWin gGetWin, ...
Gui, 11:Add, Text, Section ym+5 xm+145, %c_Lang058%
Gui, 11:Add, Text, yp xp+50, X:
Gui, 11:Add, Edit, yp-3 xp+15 vPosX W55 Disabled
Gui, 11:Add, Text, yp+3 x+10, Y:
Gui, 11:Add, Edit, yp-3 xp+15 vPosY W55 Disabled
Gui, 11:Add, Button, -Wrap yp-2 x+5 W30 H23 vWinGetP gWinGetP Disabled, ...
Gui, 11:Add, Text, xs, %c_Lang059%
Gui, 11:Add, Text, yp xp+50, W:
Gui, 11:Add, Edit, yp-3 xp+15 vSizeX W55 Disabled
Gui, 11:Add, Text, yp+3 x+10, H:
Gui, 11:Add, Edit, yp-3 xp+15 vSizeY W55 Disabled
Gui, 11:Add, Button, -Wrap Section Default xm W60 H23 gWinOK, %c_Lang020%
Gui, 11:Add, Button, -Wrap ys W60 H23 gWinCancel, %c_Lang021%
Gui, 11:Add, Button, -Wrap ys W60 H23 vWinApply gWinApply Disabled, %c_Lang131%
Gui, 11:Add, Text, ys W180 r2 vCPosT
If (s_Caller = "Edit")
{
	EscCom("Details|TimesX|DelayX|Target|Window", 1)
	WinCom := Type
	GoSub, WinCom
	GuiControl, 11:ChooseString, WinCom, %WinCom%
	If (Type = "WinSet")
	{
		WCmd := RegExReplace(Details, "(^\w*).*", "$1")
	,	Values := RegExReplace(Details, "^\w*, ?(.*)", "$1")
		GuiControl, 11:ChooseString, WCmd, %WCmd%
		SetTitleMatchMode, 3
		If (WCmd = "AlwaysOnTop")
			GuiControl, 11:, %Values%, 1
		Else If (WCmd = "Transparent")
		{
			GuiControl, 11:, N, %Values%
			GuiControl, 11:, TValue, %Values%
		}
		Else If InStr(Details, ",")
			GuiControl, 11:, Value, %Values%
		SetTitleMatchMode, 2
		GoSub, WCmd
	}
	Else If (Type = "WinMove")
	{
		Loop, Parse, Details, `,,%A_Space%
			Par%A_Index% := A_LoopField
		GuiControl, 11:, PosX, %Par1%
		GuiControl, 11:, PosY, %Par2%
		GuiControl, 11:, SizeX, %Par3%
		GuiControl, 11:, SizeY, %Par4%
	}
	Else If InStr(WinCom, "Get")
	{
		Loop, Parse, Details, `,, %A_Space%
			Par%A_Index% := A_LoopField
		GuiControl, 11:, VarName, %Par1%
		GuiControl, 11:ChooseString, WCmd, %Par2%
	}
	Else
		GuiControl, 11:, Value, %Details%
	GuiControl, 11:, Title, %Window%
	GuiControl, 11:Enable, WinApply
}
Gui, 11:Show, , %c_Lang005%
Tooltip
return

WinApply:
WinOK:
Gui, +OwnDialogs
Gui, Submit, NoHide
If (s_Caller <> "Edit")
	TimesX := 1
GuiControlGet, VState, 11:Enabled, VarName
If (VState = 0)
	VarName := ""
GuiControlGet, VState, 11:Enabled, Value
If (VState = 0)
	Value := ""
If (WinCom = "WinSet")
{
	GuiControlGet, Radio,, Button%AoT%, Text
	Details := WCmd
	If (WCmd = "AlwaysOnTop")
		Details .= ", " Radio
	Else If (WCmd = "Transparent")
		Details .= ", " N
	Else If VState = 1
		Details .= ", " Value
	Else
		Details .= ", "
}
Else If (WinCom = "WinMove")
	Details := PosX ", " PosY ", " SizeX ", " SizeY
Else
	Details := Value
If InStr(WinCom, "MinimizeAll")
	Title := ""
If InStr(WinCom, "Get")
{
	If (VarName = "")
	{
		Tooltip, %c_Lang127%, 15, 210
		return
	}
	Try
		z_Check := VarSetCapacity(%VarName%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%
		return
	}
	If (WinCom = "WinGet")
		Details := VarName ", " WCmd
	Else
		Details := VarName
	DelayWX := DelayG
}
Else
	DelayWX := DelayW
EscCom("Details|WinCom|Title")
If (A_ThisLabel <> "WinApply")
{
	Gui, 1:-Disabled
	Gui, 11:Destroy
}
Gui, 1:Default
RowSelection := LV_GetCount("Selected")
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", WinCom, Details, TimesX, DelayX, WinCom, "", Title)
Else If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, WinCom, Details, TimesX, DelayWX, WinCom, "", Title)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, WinCom, Details, TimesX, DelayWX, WinCom, "", Title)
		RowNumber++
	}
}
GoSub, b_Start
GoSub, RowCheck
If (A_ThisLabel = "WinApply")
	Gui, 11:Default
Else
{
	s_Caller = 
	GuiControl, Focus, InputList%A_List%
}
return

WinCancel:
11GuiClose:
11GuiEscape:
Gui, 1:-Disabled
Gui, 11:Destroy
s_Caller = 
return

WinCom:
Gui, Submit, NoHide
If InStr(WinCom, "Get")
{
	GuiControl, 11:, WCmd, |%WinGetCmd%
	GuiControl, 11:Enable, VarName
}
Else
{
	GuiControl, 11:, WCmd, |%WinCmd%
	GuiControl, 11:Disable, VarName
}
If ((WinCom = "WinSet") || (WinCom = "WinGet"))
	GuiControl, 11:Enable, WCmd
Else
	GuiControl, 11:Disable, WCmd
If (WinCom = "WinMove")
{
	GuiControl, 11:Enable, PosX
	GuiControl, 11:Enable, PosY
	GuiControl, 11:Enable, WinGetP
	GuiControl, 11:Enable, SizeX
	GuiControl, 11:Enable, SizeY
	GuiControl, 11:Enable, SizeY
}
Else
{
	GuiControl, 11:Disable, PosX
	GuiControl, 11:Disable, PosY
	GuiControl, 11:Disable, WinGetP
	GuiControl, 11:Disable, SizeX
	GuiControl, 11:Disable, SizeY
}
If (WinCom = "WinGetPos")
	GuiControl, 11:, CPosT, * %c_Lang060%
Else
	GuiControl, 11:, CPosT
GoSub, WCmd
If WinCom contains Close,Kill,Wait
{
	GuiControl, 11:Enable, Value
	GuiControl, 11:, ValueT, %c_Lang019%
}
Else
{
	GuiControl, 11:Disable, Value
	GuiControl, 11:, ValueT, %c_Lang056%:
}
If InStr(WinCom, "MinimizeAll")
{
	GuiControl, 11:Disable, Ident
	GuiControl, 11:Disable, Title
	GuiControl, 11:Disable, GetWin
}
Else
{
	GuiControl, 11:Enable, Ident
	GuiControl, 11:Enable, Title
	GuiControl, 11:Enable, GetWin
}
GuiControl, 11:, WinParsTip, % wcmd_%WinCom%
return

WCmd:
Gui, Submit, NoHide
If ((WinCom = "WinSet") && (WCmd = "Transparent"))
{
	GuiControl, 11:Enable, TValue
	GuiControl, 11:Enable, N
}
Else
{
	GuiControl, 11:Disable, TValue
	GuiControl, 11:Disable, N
}
If ((WinCom = "WinSet") && (WCmd = "AlwaysOnTop"))
{
	GuiControl, 11:Enable, Button1
	GuiControl, 11:Enable, Button2
	GuiControl, 11:Enable, Button3
}
Else
{
	GuiControl, 11:Disable, Button1
	GuiControl, 11:Disable, Button2
	GuiControl, 11:Disable, Button3
}
If (WinCom = "WinSet")
{
	If WCmd in Style,ExStyle,Region,TransColor
		GuiControl, 11:Enable, Value
	Else
		GuiControl, 11:Disable, Value
}
Else
	GuiControl, 11:Disable, Value
return

N:
Gui, Submit, NoHide
GuiControl, 11:, TValue, %N%
return

EditImage:
s_Caller = Edit
Image:
Gui, Submit, NoHide
Gui, 19:+owner1 -MaximizeBox -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
; Gui, 19:Font, s7
Gui, 19:Add, Text,, %c_Lang061%
Gui, 19:Add, Text, yp xs+65, X:
Gui, 19:Add, Edit, yp x+5 viPosX W60, 0
Gui, 19:Add, Text, yp x+15, Y:
Gui, 19:Add, Edit, yp x+5 viPosY W60, 0
Gui, 19:Add, Button, -Wrap yp-1 x+5 W30 H23 vGetArea gGetArea, ...
Gui, 19:Add, Text, yp+27 xs, %c_Lang062%
Gui, 19:Add, Text, yp xs+65, X:
Gui, 19:Add, Edit, yp-3 x+5 vePosX W60, %A_ScreenWidth%
Gui, 19:Add, Text, yp x+15, Y:
Gui, 19:Add, Edit, yp x+5 vePosY W60, %A_ScreenHeight%
Gui, 19:Add, Radio, -Wrap Section Checked yp+25 xs W80 vImageS gImageS R1, %c_Lang063%
Gui, 19:Add, Radio, -Wrap yp xs+125 W80 vPixelS gPixelS R1, %c_Lang064%
Gui, 19:Add, Button, -Wrap yp-1 xs+80 W25 H25 hwndScreenshot vScreenshot gScreenshot ;, %c_Lang065%
	ILButton(Screenshot, ScreenshotIcon[1] ":" ScreenshotIcon[2])
Gui, 19:Add, Button, -Wrap yp xs+205 W25 H25 hwndColorPick vColorPick gEditColor Disabled
	ILButton(ColorPick, ColorIcon[1] ":" ColorIcon[2])
Gui, 19:Add, Edit, xs vImgFile W235 R1 -Multi
Gui, 19:Add, Button, -Wrap yp-1 x+0 W30 H23 gSearchImg, ...
Gui, 19:Add, Text, yp+30 xs W180 H25, %c_Lang067%:
Gui, 19:Add, DDL, yp-2 xs+185 W80 vIfFound gIfFound, Continue||Break|Stop|Prompt|Move|Left Click|Right Click|Middle Click
Gui, 19:Add, Text, yp+25 xs W180 H25, %c_Lang068%:
Gui, 19:Add, DDL, yp-2 xs+185 W80 vIfNotFound, Continue||Break|Stop|Prompt
Gui, 19:Add, CheckBox, Checked -Wrap yp+15 xs W180 H25 vAddIf, %c_Lang162%
Gui, 19:Add, Text, -Wrap y+0 xs W260 H25 cBlue, %c_Lang069%
Gui, 19:Font, Bold
Gui, 19:Add, Text, yp+15 xs, %c_Lang072%:
Gui, 19:Font
Gui, 19:Add, Pic, Section xm+5 W260 H200 0x100 vPicPrev gPicOpen
Gui, 19:Add, Progress, ys xm W260 H200 Disabled Hidden vColorPrev
Gui, 19:Add, Text, y+0 xm+2 W150 vImgSize
; Options
Gui, 19:Add, GroupBox, Section y+5 xm+2 W265 H200, %c_Lang159%:
Gui, 19:Add, Text, ys+20 xs+10 W80, %c_Lang070%:
Gui, 19:Add, DDL, ys+18 xs+45 W65 vCoordPixel, Screen||Window
Gui, 19:Add, Text, yp+3 xs+115 W85, %c_Lang071%:
Gui, 19:Add, Edit, yp-3 xp+65 vVariatT W45 Number Limit
Gui, 19:Add, UpDown, vVariat 0x80 Range0-255, 0
Gui, 19:Add, Text, y+5 xs+10 W55 r1, %c_Lang147%:
Gui, 19:Add, Edit, yp-3 xp+55 W45 vIconN
Gui, 19:Add, Text, yp+3 xs+115 W65 r1, %c_Lang160%:
Gui, 19:Add, Edit, yp-3 xp+65 W45 vTransC
Gui, 19:Add, Button, -Wrap yp-1 x+0 W30 H23 vTransCS gGetPixel, ...
Gui, 19:Add, Text, y+5 xs+10 W40 r1, %c_Lang161%:
Gui, 19:Add, Text, yp xs+50 W20, W:
Gui, 19:Add, Edit, yp-3 xs+65 W45 vWScale
Gui, 19:Add, Text, yp+3 xs+168 W20, H:
Gui, 19:Add, Edit, yp-3 xs+180 W45 vHScale
; Gui, 19:Add, GroupBox, Section xm W265 H110
Gui, 19:Add, Text, y+10 xs+10 W245 H2 0x10
Gui, 19:Add, Text, Section y+10 xs+10, %w_Lang015%:
Gui, 19:Add, Text,, %c_Lang017%:
Gui, 19:Add, Edit, ys xs+120 W120 R1 vEdRept
Gui, 19:Add, UpDown, vTimesX 0x80 Range1-999999999, 1
Gui, 19:Add, Edit, W120 vDelayC
Gui, 19:Add, UpDown, vDelayX 0x80 Range0-999999999, %DelayG%
Gui, 19:Add, Radio, -Wrap Section Checked W120 vMsc R1, %c_Lang018%
Gui, 19:Add, Radio, -Wrap W120 vSec R1, %c_Lang019%
Gui, 19:Add, Checkbox, ys xm+7 W120 vBreakLoop R2, %c_Lang130%
Gui, 19:Add, Button, -Wrap Section Default xm W60 H23 gImageOK, %c_Lang020%
Gui, 19:Add, Button, -Wrap ys W60 H23 gImageCancel, %c_Lang021%
Gui, 19:Add, Button, -Wrap ys W60 H23 vImageApply gImageApply Disabled, %c_Lang131%
Gui, 19:Add, Button, -Wrap ys W60 H23 gImageOpt, %w_Lang003%
If (s_Caller = "Edit")
{
	EscCom("Details|TimesX|DelayX|Target|Window", 1)
	Loop, Parse, Action, `,,%A_Space%
		Act%A_Index% := A_LoopField
	GuiControl, 19:ChooseString, IfFound, %Act1%
	GuiControl, 19:ChooseString, IfNotFound, %Act2%
	Loop, Parse, Details, `,,%A_Space%
		Det%A_Index% := A_LoopField
	If (Type = cType16)
	{
		GuiControl, 19:, ImageS, 1
		RegExMatch(Det5, "\*(\d+?)\s+(.*)", ImgOpt)
	,	Variat := ImgOpt1, Det5 := ImgOpt2 ? ImgOpt2 : Det5
	,	RegExMatch(Det5, "\*Icon(.+?)\s+(.*)", ImgOpt)
	,	IconN := ImgOpt1, Det5 := ImgOpt2 ? ImgOpt2 : Det5
	,	RegExMatch(Det5, "\*Trans(.+?)\s+(.*)", ImgOpt)
	,	TransC := ImgOpt1, Det5 := ImgOpt2 ? ImgOpt2 : Det5
	,	RegExMatch(Det5, "\*W(.+?)\s+(.*)", ImgOpt)
	,	WScale := ImgOpt1, Det5 := ImgOpt2 ? ImgOpt2 : Det5
	,	RegExMatch(Det5, "\*H(.+?)\s+(.*)", ImgOpt)
	,	HScale := ImgOpt1, Det5 := ImgOpt2 ? ImgOpt2 : Det5
	,	File := Det5
		GuiControl, 19:, Variat, %Variat%
		GuiControl, 19:, IconN, %IconN%
		GuiControl, 19:, TransC, %TransC%
		GuiControl, 19:, WScale, %WScale%
		GuiControl, 19:, HScale, %HScale%
		GoSub, MakePrev
	}
	If (Type = cType15)
	{
		GuiControl, 19:, PixelS, 1
		GuiControl, 19:Hide, PicPrev
		GuiControl, 19:Show, ColorPrev
		color := Det5
		GuiControl, 19:+Background%color%, ColorPrev
		GuiControl, 19:, Variat, %Det6%
		GuiControl, 19:Disable, Screenshot
		GoSub, PixelS
	}
	GuiControl, 19:, iPosX, %Det1%
	GuiControl, 19:, iPosY, %Det2%
	GuiControl, 19:, ePosX, %Det3%
	GuiControl, 19:, ePosY, %Det4%
	GuiControl, 19:, ImgFile, %Det5%
	GuiControl, 19:ChooseString, CoordPixel, %Window%
	GuiControl, 19:, TimesX, %TimesX%
	GuiControl, 19:, EdRept, %TimesX%
	GuiControl, 19:, DelayX, %DelayX%
	GuiControl, 19:, DelayC, %DelayX%
	If Target = Break
		GuiControl, 19:, BreakLoop, 1
	GuiControl, 19:Enable, ImageApply
	GuiControl, 19:, AddIf, 0
	GuiControl, 19:Disable, AddIf
}
Gui, 19:Show,, %c_Lang006% / %c_Lang007%
Input
Tooltip
return

ImageApply:
ImageOK:
Gui, Submit, NoHide
If ImgFile = 
	return
DelayX := InStr(DelayC, "%") ? DelayC : DelayX
If Sec = 1
	DelayX *= 1000
TimesX := InStr(EdRept, "%") ? EdRept : TimesX
If TimesX = 0
	TimesX := 1
Action := IfFound "`, " IfNotFound
If ImageS = 1
{
	ImgOptions := ""
	If (Variat > 0)
		ImgOptions .= "*" Variat " "
	If (IconN <> "")
		ImgOptions .= "*Icon" IconN " "
	If (TransC <> "")
		ImgOptions .= "*Trans" TransC " "
	If (WScale <> "")
		ImgOptions .= "*W" WScale " "
	If (HScale <> "")
		ImgOptions .= "*H" HScale " "
	Type := cType16, ImgFile := ImgOptions ImgFile
}
Details := iPosX "`, " iPosY "`, " ePosX "`, " ePosY "`, " ImgFile
If PixelS = 1
	Type := cType15, Details .= ", " Variat ", Fast RGB"
Target := BreakLoop ? "Break" : ""
EscCom("Details|TimesX|DelayX|CoordPixel")
If (A_ThisLabel <> "ImageApply")
{
	Gui, 1:-Disabled
	Gui, 19:Destroy
}
Gui, 1:Default
RowSelection := LV_GetCount("Selected")
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", Action, Details, TimesX, DelayX, Type, Target, CoordPixel)
Else If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, Action, Details, TimesX, DelayX, Type, Target, CoordPixel)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
	LV_Insert(LV_GetNext(), "Check", LV_GetNext(), Action, Details, TimesX, DelayX, Type, Target, CoordPixel)
GoSub, b_Start
GoSub, RowCheck
If (AddIf = 1)
{
	If RowSelection = 0
	{
		LV_Add("Check", ListCount%A_List%+1, If9, "", 1, 0, cType17)
		LV_Add("Check", ListCount%A_List%+2, "[End If]", "EndIf", 1, 0, cType17)
		LV_Modify(ListCount%A_List%+2, "Vis")
	}
	Else
	{
		LV_Insert(LV_GetNext(), "Check", "", If9, "", 1, 0, cType17)
		RowNumber := 0, LastRow := 0
		Loop
		{
			RowNumber := LV_GetNext(RowNumber)
			If !RowNumber
			{
				LV_Insert(LastRow+1, "Check",LastRow+1, "[End If]", "EndIf", 1, 0, cType17)
				break
			}
			LastRow := LV_GetNext(LastRow)
		}
	}
	GoSub, b_Start
	GoSub, RowCheck
}
If (A_ThisLabel = "ImageApply")
	Gui, 19:Default
Else
{
	s_Caller = 
	GuiControl, Focus, InputList%A_List%
}
return

ImageCancel:
PixelCancel:
19GuiClose:
19GuiEscape:
Gui, 1:-Disabled
Gui, 19:Destroy
s_Caller = 
return

SearchImg:
Gui, +OwnDialogs
Gui, Submit, NoHide
If ImageS = 1
	GoSub, GetImage
If PixelS = 1
	GoSub, GetPixel
return

GetImage:
FileSelectFile, file,,,, Images (*.gif; *.jpg; *.bmp; *.png; *.tif; *.ico; *.cur; *.ani; *.exe; *.dll)
FreeMemory()
If (file = "")
	return
GuiControl, 19:, ImgFile, %File%

MakePrev:
If InStr(file, "%")
	file := DerefVars(file)
Gui, 9:Add, Pic, vLoadedPic, %file% 
GuiControlGet, LoadedPic, 9:Pos
Gui, 9:Destroy
Width = 260
Height = 200
PropH := LoadedPicH * Width // LoadedPicW, PropW := LoadedPicW * Height // LoadedPicH
If ((LoadedPicW <= Width) && (LoadedPicH <= Height))
	GuiControl, 19:, PicPrev, *W0 *H0 %file%
Else If (PropH > Height)
	GuiControl, 19:, PicPrev, *W-1 *H%Height% %file%
Else
	GuiControl, 19:, PicPrev, *W%Width% *H-1 %file%
GuiControl, 19:, ImgSize, %c_Lang059%: %LoadedPicW% x %LoadedPicH%
return

ImageS:
Gui, Submit, NoHide
GuiControl, 19:, ImgFile
GuiControl, 19:, PicPrev
GuiControl, 19:, ImgSize
GuiControl, +BackgroundDefault, ColorPrev
GuiControl, 19:Show, PicPrev
GuiControl, 19:Hide, ColorPrev
GuiControl, 19:Disable, ColorPick
GuiControl, 19:Enable, Screenshot
GuiControl, 19:Enable, IconN
GuiControl, 19:Enable, TransC
GuiControl, 19:Enable, TransCS
GuiControl, 19:Enable, WScale
GuiControl, 19:Enable, HScale
return

PixelS:
Gui, Submit, NoHide
GuiControl, 19:, ImgFile
GuiControl, 19:, PicPrev
GuiControl, 19:, ImgSize
GuiControl, +BackgroundDefault, ColorPrev
GuiControl, 19:Hide, PicPrev
GuiControl, 19:Show, ColorPrev
GuiControl, 19:Enable, ColorPick
GuiControl, 19:Disable, Screenshot
GuiControl, 19:Disable, IconN
GuiControl, 19:Disable, TransC
GuiControl, 19:Disable, TransCS
GuiControl, 19:Disable, WScale
GuiControl, 19:Disable, HScale
return

PicOpen:
If A_GuiEvent <> DoubleClick
	return
Gui, Submit, NoHide
If InStr(FileExist(ImgFile), "A")
	Run, %ImgFile%
return

IfFound:
Gui, Submit, NoHide
If (IfFound <> "Continue")
	GuiControl, 19:, AddIf, 0
return

ImageOpt:
; Screenshots
Gui, 25:+owner19 +ToolWindow
Gui, 19:Default
Gui, 19:+Disabled
; Gui, 25:Font, s7
Gui, 25:Add, GroupBox, Section W400 H120, %t_Lang046%:
Gui, 25:Add, Text, ys+20 xs+10, %t_Lang047%:
Gui, 25:Add, DDL, yp-5 xs+100 vDrawButton W75, RButton||LButton|MButton
Gui, 25:Add, Text, yp+3 xs+210, %t_Lang048%:
Gui, 25:Add, Edit, Limit Number yp-2 x+5 W40 R1 vLineT
Gui, 25:Add, UpDown, yp xp+60 vLineW 0x80 Range1-5, %LineW%
Gui, 25:Add, Radio, -Wrap ys+45 xs+10 W180 vOnRelease R1, %t_Lang049%
Gui, 25:Add, Radio, -Wrap ys+45 xs+210 W180 vOnEnter R1, %t_Lang050%
Gui, 25:Add, Text, ys+70 xs+10, %t_Lang051%:
Gui, 25:Add, Edit, vScreenDir W350 R1 -Multi, %ScreenDir%
Gui, 25:Add, Button, -Wrap yp-1 x+0 W30 H23 vSearchScreen gSearchDir, ...
Gui, 25:Add, Button, -Wrap Default Section xm W60 H23 gImgConfigOK, %c_Lang020%
Gui, 25:Add, Button, -Wrap ys W60 H23 gImgConfigCancel, %c_Lang021%
GuiControl, 25:ChooseString, DrawButton, %DrawButton%
GuiControl, 25:, OnRelease, %OnRelease%
GuiControl, 25:, OnEnter, %OnEnter%
Gui, 25:Show,, %t_Lang017%
Tooltip
return

ImgConfigOK:
Gui, Submit, NoHide
If OnRelease = 1
	SSMode = OnRelease
Else If OnEnter = 1
	SSMode = OnEnter
Gui, 19:-Disabled
Gui, 25:Destroy
Gui, 19:Default
return

ImgConfigCancel:
25GuiClose:
25GuiEscape:
Gui, 19:-Disabled
Gui, 25:Destroy
return

EditRun:
s_Caller = Edit
Run:
Gui, 10:+owner1 -MaximizeBox -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
; Gui, 10:Font, s7
Gui, 10:Add, Text, ym+5 W55, %c_Lang055%:
Gui, 10:Add, ComboBox, yp-2 xs+100 W170 vFileCmdL gFileCmd, %FileCmdList%
Gui, 10:Add, Text, yp+30 xm W200 vFCmd1
Gui, 10:Add, Edit, vPar1File W270 R1 -Multi
Gui, 10:Add, Button, -Wrap yp-1 x+0 W30 H23 vSearchPar1 gSearch, ...
Gui, 10:Add, Text, xm W200 vFCmd2
Gui, 10:Add, Edit, vPar2File W270 R1 -Multi
Gui, 10:Add, Button, -Wrap yp-1 x+0 W30 H23 vSearchPar2 gSearch, ...
Gui, 10:Add, Button, -Wrap yp xp W30 H23 vMouseGet gMouseGetI Hidden, ...
Gui, 10:Add, Text, xm W200 vFCmd3
Gui, 10:Add, Edit, vPar3File W270 R1 -Multi
Gui, 10:Add, Button, -Wrap yp-1 x+0 W30 H23 vSearchPar3 gSearch, ...
Gui, 10:Add, Text, xm W200 vFCmd4
Gui, 10:Add, Edit, vPar4File W270 R1 -Multi
Gui, 10:Add, Text, xm W200 vFCmd5
Gui, 10:Add, Edit, vPar5File W270 R1 -Multi
Gui, 10:Add, Text, xm W200 vFCmd6
Gui, 10:Add, Edit, vPar6File W270 R1 -Multi
Gui, 10:Add, Button, -Wrap Section Default y+20 xm W60 H23 vRunOK gRunOK, %c_Lang020%
Gui, 10:Add, Button, -Wrap ys W60 H23 gRunCancel, %c_Lang021%
Gui, 10:Add, Button, -Wrap ys W60 H23 vRunApply gRunApply Disabled, %c_Lang131%
If (s_Caller = "Edit")
{
	GuiControl, 10:ChooseString, FileCmdL, %Type%
	StringReplace, Details, Details, ```,, ¢, All
	Loop, Parse, Details, `,, %A_Space%
	{
		StringReplace, LoopField, A_LoopField, ¢, `,, All
		GuiControl, 10:, Par%A_Index%File, %LoopField%
	}
	GuiControl, 10:Enable, RunApply
}
GoSub, FileCmd
Gui, 10:Show,, %c_Lang008%
Tooltip
Input
return

Search:
Gui, +OwnDialogs
Gui, Submit, NoHide
GuiControlGet, FcCmd,, FileCmdL
GuiControlGet, FcCtrl,, % "FCmd" SubStr(A_GuiControl, 0, 1)
GuiControlGet, LFile,, LFilePattern
If (InStr(FcCmd, "Dir") || InStr(FcCmd, "Folder") || InStr(FcCtrl, "WorkingDir")
|| InStr(FcCtrl, "Drive") || InStr(FcCtrl, "Path")) || (LFile = 1)
{
	GoSub, SearchDir
	EdField := SubStr(A_GuiControl, 7) "File"
	If (EdField = "LParamsFile")
			Folder .= "\*.*"
	GuiControl,, %EdField%, %Folder%
	return
}
FileSelectFile, File, 2
FreeMemory()
If File = 
	return
EdField := SubStr(A_GuiControl, 7) "File"
GuiControl,, %EdField%, %File%
return

SearchDir:
Gui, +OwnDialogs
Gui, Submit, NoHide
FileSelectFolder, Folder, *%A_ScriptDir%
FreeMemory()
If Folder = 
	return
EdField := SubStr(A_GuiControl, 7) "Dir"
GuiControl,, %EdField%, %Folder%
return

RunApply:
RunOK:
Gui, Submit, NoHide
Details := ""
Loop, 6
{
	GuiControlGet, fTxt, 10:, FCmd%A_Index%
	If (InStr(fTxt, "OutputVar") || InStr(fTxt, "InputVar"))
	{
		VarName := Par%A_Index%File
		If (VarName = "")
		{
			If fTxt not in OutputVarPID,OutputVarX,OutputVarY,OutputVarWin,OutputVarControl
			{
				Tooltip, %c_Lang127%, 15, % (A_Index = 1) ? 80 : 130
				return
			}
		}
		Try
			z_Check := VarSetCapacity(%VarName%)
		Catch
		{
			MsgBox, 16, %d_Lang007%, %d_Lang041%
			return
		}
	}
	GuiControlGet, fState, 10:Enabled, Par%A_Index%File
	If (fState = 1)
	{
		IfInString, Par%A_Index%File, `,
			StringReplace, Par%A_Index%File, Par%A_Index%File, `,, ```,, All
		Details .= Par%A_Index%File ", "
	}
}
StringReplace, Details, Details, ```,, ¢, All
Details := RTrim(Details, ", ")
StringReplace, Details, Details, ¢, ```,, All
If (A_ThisLabel <> "RunApply")
{
	Gui, 1:-Disabled
	Gui, 10:Destroy
}
Gui, 1:Default
RowSelection := LV_GetCount("Selected")
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", FileCmdL, Details, TimesX, DelayX, FileCmdL)
Else If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, FileCmdL, Details, 1, DelayG, FileCmdL)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, FileCmdL, Details, 1, DelayG, FileCmdL)
		RowNumber++
	}
}
GoSub, b_Start
GoSub, RowCheck
If (A_ThisLabel = "RunApply")
	Gui, 10:Default
Else
{
	s_Caller = 
	GuiControl, Focus, InputList%A_List%
}
return

RunCancel:
10GuiClose:
10GuiEscape:
Gui, 1:-Disabled
Gui, 10:Destroy
s_Caller = 
return

FileCmd:
Gui, 10:Submit, NoHide
Loop, 6
{
	Try
	{
		GuiControl, 10:, FCmd%A_Index%, % %FileCmdL%%A_Index%
		If !(%FileCmdL%%A_Index%)
			GuiControl, 10:Disable, Par%A_Index%File
		Else
			GuiControl, 10:Enable, Par%A_Index%File
	}
	Catch
	{
		GuiControl, 10:, FCmd%A_Index%
		GuiControl, 10:Disable, Par%A_Index%File
	}
	Try
	{
		If %FileCmdL%%A_Index% contains Target,Dir,File,Source,Dest,Starting,Drive,Path
			GuiControl, 10:Enable, SearchPar%A_Index%
		Else
			GuiControl, 10:Disable, SearchPar%A_Index%
	}
	Catch
		GuiControl, 10:Disable, SearchPar%A_Index%
}
If ((FileCmdL = "PixelGetColor") || (FileCmdL = "Tooltip"))
{
	GuiControl, 10:Hide, SearchPar2
	GuiControl, 10:Show, MouseGet
}
Else
{
	GuiControl, 10:Hide, MouseGet
	GuiControl, 10:Show, SearchPar2
}
If FileCmdL not in %FileCmdML%
{
	GuiControl, 10:Disable, RunOK
	GuiControl, 10:Disable, RunApply
}
Else
{
	GuiControl, 10:Enable, RunOK
	If (s_Caller = "Edit")
		GuiControl, 10:Enable, RunApply
}
return

EditVar:
EditSt:
s_Caller = Edit
AsFunc:
AsVar:
IfSt:
Gui, 21:+owner1 -MaximizeBox -MinimizeBox +E0x00000400 +HwndCmdWin +Delimiter$
Gui, 1:+Disabled
; Gui, 21:Font, s7
Gui, 21:Add, Tab2, W330 H240 vTabControl AltSubmit, %c_Lang009%$%c_Lang084%$%c_Lang011%
; Statements
Gui, 21:Add, DDL, y+10 W200 vStatement gStatement, %IfList%
Gui, 21:Add, Button, -Wrap yp-1 x+5 W30 H23 vIfGet gIfGet, ...
Gui, 21:Add, DDL, yp+1 x+0 W75 vIdent, Title$$Class$Process$ID
Gui, 21:Add, Text, Section ym+60 xm+10 W200 vFormatTip
Gui, 21:Add, Edit, W310 H136 -vScroll vTestVar
Gui, 21:Add, Text,, %c_Lang025%
Gui, 21:Add, Button, -Wrap Section Default xm W60 H23 gIfOK, %c_Lang020%
Gui, 21:Add, Button, -Wrap ys W60 H23 gIfCancel, %c_Lang021%
Gui, 21:Add, Button, -Wrap ys W60 H23 vIfApply gIfApply Disabled, %c_Lang131%
Gui, 21:Add, Button, -Wrap ys W60 H23 vAddElse gAddElse, %c_Lang083%
; Variables
Gui, 21:Tab, 2
Gui, 21:Add, Text,, %c_Lang057%:
Gui, 21:Add, Edit, W245 R1 -Multi vVarName
Gui, 21:Add, Text, yp-20 x+5 W40, %c_Lang086%:
Gui, 21:Add, DDL, y+7 W60 vOper, :=$$+=$-=$*=$/=$//=$.=$|=$&=$^=$>>=$<<=
Gui, 21:Add, Text, Section ym+70 xm+10 W60, %c_Lang085%:
Gui, 21:Add, Checkbox, -Wrap Checked%EvalDefault% yp x+5 W235 vUseEval gUseEval R1, %c_Lang087%
Gui, 21:Add, Edit, yp+19 xs W310 H125 vVarValue
Gui, 21:Add, Text,, %c_Lang025%
Gui, 21:Add, Button, -Wrap Section xm ym+245 W60 H23 gVarOK, %c_Lang020%
Gui, 21:Add, Button, -Wrap ys W60 H23 gIfCancel, %c_Lang021%
Gui, 21:Add, Button, -Wrap ys W60 H23 vVarApplyA gVarApply Disabled, %c_Lang131%
Gui, 21:Add, Button, -Wrap ys W60 H23 vVarCopyA gVarCopy, %c_Lang023%
Gui, 21:Add, Button, -Wrap ys W60 H23 gReset, %c_Lang088%
; Functions
Gui, 21:Tab, 3
Gui, 21:Add, Text,, %c_Lang057%:
Gui, 21:Add, Edit, W310 R1 -Multi vVarNameF
Gui, 21:Add, Checkbox, yp+30 xs+10 W310 vUseExtFunc gUseExtFunc, %c_Lang128%
Gui, 21:Add, Edit, W280 R1 -Multi vFileNameEx Disabled, %StdLibFile%
Gui, 21:Add, Button, -Wrap yp-1 x+0 W30 H23 vSearchFEX gSearchAHK Disabled, ...
Gui, 21:Add, Text, yp+30 xs+10 W130, %c_Lang089%:
Gui, 21:Add, Combobox, W285 -Multi vFuncName gFuncName, %BuiltinFuncList%
Gui, 21:Add, Button, -Wrap W22 yp-1 x+5 hwndFuncHelp vFuncHelp gFuncHelp Disabled
	ILButton(FuncHelp, HelpIconB[1] ":" HelpIconB[2])
Gui, 21:Add, Text, W310 yp+25 xs+10, %c_Lang090%:
Gui, 21:Add, Edit, W310 R1 -Multi vVarValueF
Gui, 21:Add, Text, y+7 W310, %c_Lang091%
Gui, 21:Add, Button, -Wrap Section xm ys W60 H23 gVarOK, %c_Lang020%
Gui, 21:Add, Button, -Wrap ys W60 H23 gIfCancel, %c_Lang021%
Gui, 21:Add, Button, -Wrap ys W60 H23 vVarApplyB gVarApply Disabled, %c_Lang131%
Gui, 21:Add, Button, -Wrap ys W60 H23 vVarCopyB gVarCopy, %c_Lang023%
Gui, 21:Add, Button, -Wrap ys W60 H23 gReset, %c_Lang088%
If (s_Caller = "Edit")
{
	If (A_ThisLabel = "EditSt")
	{
		StringReplace, Details, Details, ``n, `n, All
		EscCom("Details|TimesX|DelayX|Target|Window", 1)
		GuiControl, 21:ChooseString, Statement, %Action%
		GuiControl, 21:, TestVar, %Details%
		GoSub, Statement
		If InStr(Action, "Image")
			GuiControl, 21:Disable, TestVar
		GuiControl, 21:, TabControl, $%c_Lang009%
	}
	Else If (A_ThisLabel = "EditVar")
	{
		If (Action = "[Assign Variable]")
		{
			StringReplace, Details, Details, ``n, `n, All
			AssignReplace(Details)
			EscCom("VarValue", 1)
			GuiControl, 21:Choose, TabControl, 2
			GuiControl, 21:, VarName, %VarName%
			GuiControl, 21:ChooseString, Oper, %Oper%
			GuiControl, 21:, VarValue, %VarValue%
			If (Target = "Expression")
				GuiControl, 21:, UseEval, 1
		}
		Else
		{
			AssignReplace(Details)
			FuncName := Action
			GoSub, FuncName
			GuiControl, 21:Choose, TabControl, 3
			If (VarName <> "_null")
				GuiControl, 21:, VarNameF, %VarName%
			If (IsBuiltIn)
				GuiControl, 21:ChooseString, FuncName, %FuncName%
			Else
				GuiControl, 21:, FuncName, %FuncName%$$
			If (Target <> "")
			{
				UseExtFunc := 1, FileNameEx := Target
				GuiControl, 21:, UseExtFunc, 1
				GuiControl, 21:, FileNameEx, %Target%
				GuiControl, 21:Enable, SearchAHK
				GoSub, UseExtFunc
				GuiControl, 21:ChooseString, FuncName, %FuncName%
			}
			GuiControl, 21:, VarValueF, %VarValue%
		}
	}
	GuiControl, 21:Enable, IfApply
	GuiControl, 21:Enable, VarApplyA
	GuiControl, 21:Enable, VarApplyB
}
Else
	ExtList := ReadFunctions(StdLibFile)
If !IsFunc("Eval")
	GuiControl, 21:, UseEval, 0
If (A_ThisLabel = "AsVar")
	GuiControl, 21:Choose, TabControl, 2
If (A_ThisLabel = "AsFunc")
	GuiControl, 21:Choose, TabControl, 3
Gui, 21:Show,, %c_Lang009% / %c_Lang010% / %c_Lang011%
Tooltip
return

IfApply:
IfOK:
Gui, +OwnDialogs
Gui, Submit, NoHide
If InStr(Statement, "Image")
	TestVar =
Else
{
	If (TestVar = "")
		return
}
If InStr(Statement, "Compare")
{
	AssignReplace(TestVar)
	Try
		z_Check := VarSetCapacity(%VarName%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%
		return
	}
	If Oper not in =,==,<>,!=,>,<,>=,<=
	{
		MsgBox, 16, %d_Lang007%, %d_Lang042%
		return
	}
}
Else If InStr(Statement, "String")
{
	If !RegExMatch(TestVar, "(.+),\s.+", tMatch)
		return
	VarName := Trim(tMatch1)
	Try
		z_Check := VarSetCapacity(%VarName%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%
		return
	}
}
Else If (Statement = "Evaluate Expression")
{
	If !IsFunc("Eval")
	{
		MsgBox, 17, %d_Lang007%, %d_Lang044%
		IfMsgBox, OK
			Run, http://www.autohotkey.com/board/topic/15675-monster
		return
	}
}
EscCom("TestVar")
If (A_ThisLabel <> "IfApply")
{
	Gui, 1:-Disabled
	Gui, 21:Destroy
}
Gui, 1:Default
RowSelection := LV_GetCount("Selected")
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", Statement, TestVar, 1, 0, cType17)
Else If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, Statement, TestVar, 1, 0, cType17)
	LV_Add("Check", ListCount%A_List%+2, "[End If]", "EndIf", 1, 0, cType17)
	LV_Modify(ListCount%A_List%+2, "Vis")
}
Else
{
	LV_Insert(LV_GetNext(), "Check", "", Statement, TestVar, 1, 0, cType17)
	RowNumber := 0, LastRow := 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If !RowNumber
		{
			LV_Insert(LastRow+1, "Check",LastRow+1, "[End If]", "EndIf", 1, 0, cType17)
			break
		}
		LastRow := LV_GetNext(LastRow)
	}
}
GoSub, b_Start
GoSub, RowCheck
If (A_ThisLabel = "IfApply")
	Gui, 21:Default
Else
{
	s_Caller =
	GuiControl, Focus, InputList%A_List%
}
return

VarApply:
VarOK:
Gui, +OwnDialogs
Gui, Submit, NoHide
If TabControl = 3
{
	If (UseExtFunc)
	{
		SplitPath, FileNameEx,,, ext
		If ((ext <> "ahk") || (FuncName = ""))
		{
			MsgBox, 16, %d_Lang007%, %d_Lang055%
			return
		}
		Target := FileNameEx
	}
	Else If !IsFunc(FuncName)
	{
		MsgBox, 16, %d_Lang007%, "%FuncName%" %d_Lang031%
		return
	}
	Else
		Target := ""
	VarName := VarNameF
	If (VarName = "")
		VarName := "_null"
}
If (VarName = "")
{
	Tooltip, %c_Lang127%, 25, 75
	return
}
Try
	z_Check := VarSetCapacity(%VarName%)
Catch
{
	MsgBox, 16, %d_Lang007%, %d_Lang041%
	return
}
StringReplace, VarValue, VarValue, `n, ``n, All
If (s_Caller <> "Edit")
	TimesX := 1
If TabControl = 3
	Action := FuncName, Details := VarName " := " VarValueF
Else
{
	Action := "[Assign Variable]", Details := VarName " " Oper " " VarValue
	If (UseEval = 1)
		Target := "Expression"
	Else
		Target := ""
	EscCom("Details|TimesX|DelayX|Target|Window")
}
Type := cType21
If (A_ThisLabel <> "VarApply")
{
	Gui, 1:-Disabled
	Gui, 21:Destroy
}
Gui, 1:Default
RowSelection := LV_GetCount("Selected")
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", Action, Details, TimesX, DelayX, Type, Target, "")
Else If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, Action, Details, 1, 0, Type, Target, "")
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
	LV_Insert(LV_GetNext(), "Check", "", Action, Details, 1, 0, Type, Target, "")
GoSub, b_Start
GoSub, RowCheck
If (A_ThisLabel = "VarApply")
	Gui, 21:Default
Else
{
	s_Caller = 
	GuiControl, Focus, InputList%A_List%
}
return

AddElse:
Gui, Submit, NoHide
Gui, 1:-Disabled
Gui, 21:Destroy
Gui, 1:Default
RowSelection := LV_GetCount("Selected")
If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, "[Else]", "Else", 1, 0, cType17)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
	LV_Insert(LV_GetNext(), "Check", "", "[Else]", "Else", 1, 0, cType17)
GoSub, b_Start
GoSub, RowCheck
GuiControl, Focus, InputList%A_List%
return

VarCopy:
Gui, Submit, NoHide
If TabControl = 3
{
	If (VarNameF = "")
		return
	Clipboard := %VarNameF%
}
Else
{
	If (VarName = "")
		return
	Clipboard := %VarName%
}
return

Reset:
Gui, Submit, NoHide
If TabControl = 3
{
	If (VarNameF = "")
		return
	%VarNameF% := ""
}
Else
{
	If (VarName = "")
		return
	%VarName% := ""
}
return

UseEval:
Gui, 21:+OwnDialogs
If !IsFunc("Eval")
{
	GuiControl, 21:, UseEval, 0
	MsgBox, 17, %d_Lang007%, %d_Lang044%
	IfMsgBox, OK
		Run, http://www.autohotkey.com/board/topic/15675-monster
	return
}
return

IfCancel:
21GuiClose:
21GuiEscape:
Gui, 1:-Disabled
Gui, 21:Destroy
s_Caller = 
return

FuncName:
Gui, Submit, NoHide
Try IsBuiltIn := Func(FuncName).IsBuiltIn ? 1 : 0
GuiControl, 21:Enable%IsBuiltIn%, FuncHelp
return

UseExtFunc:
Gui, 21:+OwnDialogs
If !A_AhkPath
{
	GuiControl, 21:, UseExtFunc, 0
	MsgBox, 17, %d_Lang007%, %d_Lang056%
	IfMsgBox, OK
		Run, http://www.autohotkey.com
	return
}
Gui, Submit, NoHide
GuiControl, 21:Enable%UseExtFunc%, FileNameEx
GuiControl, 21:Enable%UseExtFunc%, SearchFEX
GuiControl, 21:Disable, FuncHelp
GuiControl, 21:, FuncName, $
If (UseExtFunc = 1)
	ExtList := ReadFunctions(FileNameEx, t_lang086)
GuiControl, 21:, FuncName, % (UseExtFunc) ? "$" ExtList : "$" BuiltinFuncList
return

SearchAHK:
Gui, +OwnDialogs
Gui, Submit, NoHide
FileSelectFile, File, 1,,, AutoHotkey Scripts (*.ahk)
FreeMemory()
If File = 
	return
If (A_GuiControl = "StdLib")
	GuiControl, 4:, StdLibFile, %File%
Else
{
	GuiControl, 21:, FileNameEx, %File%
	GuiControl, 21:, FuncName, $
	ExtList := ReadFunctions(File, t_lang086)
	GuiControl, 21:, FuncName, % (UseExtFunc) ? "$" ExtList : "$" BuiltinFuncList
}
return

FuncHelp:
Gui, Submit, NoHide
If FuncName in Abs,ACos,Asc,ASin,ATan,Ceil,Chr,Exp,FileExist,Floor,Func
,GetKeyName,GetKeySC,GetKeyState,GetKeyVK,InStr,IsByRef,IsFunc,IsLabel
,IsObject,Ln,Log,LTrim,Mod,NumGet,NumPut,Round,RTrim,Sin,Sqrt,StrGet
,StrLen,StrPut,SubStr,Tan,Trim,WinActive,WinExist
	Run, http://l.autohotkey.net/docs/Functions.htm#%FuncName%
Else
	Run, http://l.autohotkey.net/docs/commands/%FuncName%.htm
return

Statement:
Gui, 21:Submit, NoHide
If InStr(Statement, "Window")
	GuiControl, 21:Enable, Ident
If !InStr(Statement, "Window")
	GuiControl, 21:Disable, Ident
If (!InStr(Statement, "Window") && !InStr(Statement, "File"))
	GuiControl, 21:Disable, IfGet
Else
	GuiControl, 21:Enable, IfGet
If InStr(Statement, "Image")
	GuiControl, 21:Disable, TestVar
Else
	GuiControl, 21:Enable, TestVar
If InStr(Statement, "String")
	GuiControl, 21:, FormatTip, %c_Lang081%
Else If InStr(Statement, "Compare")
	GuiControl, 21:, FormatTip, %c_Lang082%
Else
	GuiControl, 21:, FormatTip
return

IfGet:
Gui, Submit, NoHide
If InStr(Statement, "Window")
{
	Label = IfGet
	GoSub, GetWin
	Label =
	GuiControl, 21:, TestVar, %FoundTitle%
	return
}
If InStr(Statement, "File")
{
	GoSub, Search
	GuiControl, 21:, TestVar, %File%
	return
}
return

EditMsg:
s_Caller = Edit
SendMsg:
Gui, 22:+owner1 -MaximizeBox -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
; Gui, 22:Font, s7
Gui, 22:Add, DDL, W100 vMsgType, PostMessage||SendMessage
Gui, 22:Add, DDL, yp xp+110 W210 vWinMsg gWinMsg, %WM_Msgs%
Gui, 22:Add, Text, xm W120, %c_Lang102%:
Gui, 22:Add, Edit, xm W320 -Multi vMsgNum
Gui, 22:Add, Text, xm W80, wParam:
Gui, 22:Add, Edit, xm W320 -Multi vwParam
Gui, 22:Add, Text, xm W80, lParam:
Gui, 22:Add, Edit, xm W320 -Multi vlParam
Gui, 22:Add, Text, Section xm, %c_Lang004%:
Gui, 22:Add, Edit, vDefCt W290
Gui, 22:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetCtrl gGetCtrl, ...
Gui, 22:Add, DDL, Section xm W65 vIdent, Title||Class|Process|ID|PID
Gui, 22:Add, Text, -Wrap yp+5 x+5 W240 H20 vWinParsTip Disabled, %wcmd_WinSet%
Gui, 22:Add, Edit, xs+2 W290 vTitle, A
Gui, 22:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetWin gGetWin, ...
Gui, 22:Add, Button, -Wrap Section Default xm W60 H23 gSendMsgOK, %c_Lang020%
Gui, 22:Add, Button, -Wrap ys W60 H23 gSendMsgCancel, %c_Lang021%
Gui, 22:Add, Button, -Wrap ys W60 H23 vSendMsgApply gSendMsgApply Disabled, %c_Lang131%
If (s_Caller = "Edit")
{
	EscCom("Details|TimesX|DelayX|Target|Window", 1)
	Loop, Parse, Details, `,,%A_Space%
	{
		StringReplace, LoopField, A_LoopField, ¢, `,, All
		Par%A_Index% := LoopField
	}
	GuiControl, 22:ChooseString, MsgType, %Type%
	GuiControl, 22:, MsgNum, %Par1%
	GuiControl, 22:, wParam, %Par2%
	GuiControl, 22:, lParam, %Par3%
	GuiControl, 22:, DefCt, %Target%
	GuiControl, 22:, Title, %Window%
	GuiControl, 22:Enable, SendMsgApply
}
Gui, 22:Show, , % cType19 " / " cType18
Tooltip
return

SendMsgApply:
SendMsgOK:
Gui, +OwnDialogs
Gui, Submit, NoHide
If (MsgNum = "")
	return
If (s_Caller <> "Edit")
	TimesX := 1
IfInString, wParam, `,
	StringReplace, wParam, wParam, `,, ```,, All
IfInString, lParam, `,
	StringReplace, lParam, lParam, `,, ```,, All
Details := MsgNum ", " wParam ", " lParam
EscCom("Details|DefCt|Title")
If (A_ThisLabel <> "SendMsgApply")
{
	Gui, 1:-Disabled
	Gui, 22:Destroy
}
Gui, 1:Default
RowSelection := LV_GetCount("Selected")
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", "[Windows Message]", Details, TimesX, DelayX, MsgType, DefCt, Title)
Else If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, "[Windows Message]", Details, TimesX, DelayG, MsgType, DefCt, Title)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, "[Windows Message]", Details, TimesX, DelayG, MsgType, DefCt, Title)
		RowNumber++
	}
}
GoSub, b_Start
GoSub, RowCheck
If (A_ThisLabel = "SendMsgApply")
	Gui, 22:Default
Else
{
	s_Caller = 
	GuiControl, Focus, InputList%A_List%
}
return

WinMsg:
Gui, Submit, NoHide
GuiControl, 22:, MsgNum, % %WinMsg%
return

SendMsgCancel:
22GuiClose:
22GuiEscape:
Gui, 1:-Disabled
Gui, 22:Destroy
s_Caller = 
return

EditControl:
s_Caller = Edit
ControlCmd:
Gui, 23:+owner1 -MaximizeBox -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
; Gui, 23:Font, s7
Gui, 23:Add, DDL, W120 vControlCmd gCtlCmd, %CtrlCmdList%
Gui, 23:Add, Text, xm W120, %c_Lang055%:
Gui, 23:Add, DDL, xm W120 -Multi vCmd gCmd, %CtrlCmd%
Gui, 23:Add, Text, xm W80, %c_Lang056%:
Gui, 23:Add, Edit, xm W380 -Multi Disabled vValue
Gui, 23:Add, Text, xm W180, %c_Lang057%:
Gui, 23:Add, Edit, xm W380 -Multi Disabled vVarName
Gui, 23:Add, Text, Section xm, %c_Lang004%:
Gui, 23:Add, Edit, vDefCt W350
Gui, 23:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetCtrl gGetCtrl, ...
Gui, 23:Add, DDL, Section xm W65 vIdent, Title||Class|Process|ID|PID
Gui, 23:Add, Text, -Wrap yp+5 x+5 W240 H20 vWinParsTip Disabled, %wcmd_WinSet%
Gui, 23:Add, Edit, xs+2 W350 vTitle, A
Gui, 23:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetWin gGetWin, ...
Gui, 23:Add, Text, Section ym+5 xm+145, %c_Lang058%
Gui, 23:Add, Text, yp xp+50, X:
Gui, 23:Add, Edit, yp-3 xp+15 vPosX W55 Disabled
Gui, 23:Add, Text, yp+3 x+10, Y:
Gui, 23:Add, Edit, yp-3 xp+15 vPosY W55 Disabled
Gui, 23:Add, Button, -Wrap yp-2 x+5 W30 H23 vGetCtrlP gCtrlGetP Disabled, ...
Gui, 23:Add, Text, xs, %c_Lang059%
Gui, 23:Add, Text, yp xp+50, W:
Gui, 23:Add, Edit, yp-3 xp+15 vSizeX W55 Disabled
Gui, 23:Add, Text, yp+3 x+10, H:
Gui, 23:Add, Edit, yp-3 xp+15 vSizeY W55 Disabled
Gui, 23:Add, Button, -Wrap Section Default xm W60 H23 gControlOK, %c_Lang020%
Gui, 23:Add, Button, -Wrap ys W60 H23 gControlCancel, %c_Lang021%
Gui, 23:Add, Button, -Wrap ys W60 H23 vControlApply gControlApply Disabled, %c_Lang131%
Gui, 23:Add, Text, ys W180 r2 vCPosT
If (s_Caller = "Edit")
{
	EscCom("Details|TimesX|DelayX|Target|Window", 1)
	ControlCmd := Type
	GuiControl, 23:ChooseString, ControlCmd, %ControlCmd%
	If (Type = cType24)
	{
		GuiControl, 23:ChooseString, Cmd, % cmd := RegExReplace(Details, "(^\w*).*", "$1")
		GuiControl, 23:, Value, % RegExReplace(Details, "^\w*, ?(.*)", "$1")
		GoSub, Cmd
	}
	Else If (Type = cType10)
	{
		GoSub, CtlCmd
		GuiControl, 23:, Value, %Details%
	}
	Else If ((Type = cType23)	|| (Type = cType27)
	|| (Type = cType28) || (Type = cType31))
	{
		Loop, Parse, Details, `,, %A_Space%
			Par%A_Index% := A_LoopField
		GoSub, CtlCmd
		GuiControl, 23:, VarName, %Par1%
		GuiControl, 23:ChooseString, Cmd, %Par2%
		GuiControl, 23:, Value, %Par3%
	}
	Else If (Type = cType26)
	{
		GoSub, CtlCmd
		Loop, Parse, Details, `,,%A_Space%
			Par%A_Index% := A_LoopField
		GuiControl, 23:, PosX, %Par1%
		GuiControl, 23:, PosY, %Par2%
		GuiControl, 23:, SizeX, %Par3%
		GuiControl, 23:, SizeY, %Par4%
	}
	GuiControl, 23:, DefCt, %Target%
	GuiControl, 23:, Title, %Window%
	If (Type = cType25)
		GoSub, CtlCmd
	GuiControl, 23:Enable, ControlApply
}
Gui, 23:Show, , %c_Lang004%
Tooltip
return

ControlApply:
ControlOK:
Gui, +OwnDialogs
Gui, Submit, NoHide
If (s_Caller <> "Edit")
	TimesX := 1
GuiControlGet, VState, 23:Enabled, Value
If (VState = 0)
	Value := ""
GuiControlGet, VState, 23:Enabled, VarName
If (VState = 0)
	VarName := ""
If (ControlCmd = cType24)
	Details := Cmd ", " Value
If (ControlCmd = cType25)
	Details =
If (ControlCmd = cType26)
	Details := PosX ", " PosY ", " SizeX ", " SizeY
If (ControlCmd = cType10)
	Details := Value
If (ControlCmd = cType27)
	DefCt := ""
If ((ControlCmd = cType23) || (ControlCmd = cType27)
|| (ControlCmd = cType28) || (ControlCmd = cType31))
{
	If (VarName = "")
	{
		Tooltip, %c_Lang127%, 15, 160
		return
	}
	Try
		z_Check := VarSetCapacity(%VarName%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%
		return
	}
	If (ControlCmd = cType28)
		Details := VarName ", " Cmd ", " Value
	Else
		Details := VarName
}
EscCom("Details|DefCt|Title")
If (A_ThisLabel <> "ControlApply")
{
	Gui, 1:-Disabled
	Gui, 23:Destroy
}
Gui, 1:Default
RowSelection := LV_GetCount("Selected")
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", "[Control]", Details, TimesX, DelayX, ControlCmd, DefCt, Title)
Else If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, "[Control]", Details, TimesX, DelayG, ControlCmd, DefCt, Title)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, "[Control]", Details, TimesX, DelayG, ControlCmd, DefCt, Title)
		RowNumber++
	}
}
GoSub, b_Start
GoSub, RowCheck
If (A_ThisLabel = "ControlApply")
	Gui, 23:Default
Else
{
	s_Caller = 
	GuiControl, Focus, InputList%A_List%
}
return

ControlCancel:
23GuiClose:
23GuiEscape:
Gui, 1:-Disabled
Gui, 23:Destroy
s_Caller = 
return

CtlCmd:
Gui, Submit, NoHide
If ((ControlCmd <> cType24) && (ControlCmd <> cType28))
	GuiControl, 23:Disable, Cmd
Else
	GuiControl, 23:Enable, Cmd
If ((ControlCmd = cType24) || (ControlCmd = cType10))
	GuiControl, 23:Enable, Value
Else
	GuiControl, 23:Disable, Value
If (ControlCmd = cType24)
	GuiControl, 23:, Cmd, |%CtrlCmd%
Else If (ControlCmd = cType28)
	GuiControl, 23:, Cmd, |%CtrlGetCmd%
If ((ControlCmd = cType23) || (ControlCmd = cType27)
|| (ControlCmd = cType28) || (ControlCmd = cType31))
	GuiControl, 23:Enable, VarName
Else
	GuiControl, 23:Disable, VarName
If (ControlCmd = cType26)
{
	GuiControl, 23:Enable, PosX
	GuiControl, 23:Enable, PosY
	GuiControl, 23:Enable, GetCtrlP
	GuiControl, 23:Enable, SizeX
	GuiControl, 23:Enable, SizeY
}
Else
{
	GuiControl, 23:Disable, PosX
	GuiControl, 23:Disable, PosY
	GuiControl, 23:Disable, GetCtrlP
	GuiControl, 23:Disable, SizeX
	GuiControl, 23:Disable, SizeY
}
If (ControlCmd = cType31)
	GuiControl, 23:, CPosT, * %c_Lang060%
Else
	GuiControl, 23:, CPosT
GoSub, Cmd
return

Cmd:
Gui, Submit, NoHide
If (ControlCmd = cType24)
{
	If Cmd in Style,ExStyle,TabLeft,TabRight,Add,Delete,Choose,ChooseString,EditPaste
		GuiControl, 23:Enable, Value
	Else
		GuiControl, 23:Disable, Value
}
Else If (ControlCmd = cType28)
{
	If Cmd in List,FindString,Line
		GuiControl, 23:Enable, Value
	Else
		GuiControl, 23:Disable, Value
}
return

EditIECom:
s_Caller = Edit
RunScrLet:
ComInt:
IECom:
IEWindows := ListIEWindows()
Gui, 24:+owner1 -MaximizeBox -MinimizeBox +E0x00000400 +hwndCmdWin
Gui, 1:+Disabled
; Gui, 24:Font, s7
Gui, 24:Add, Tab2, W410 H240 vTabControl gTabControl AltSubmit, %c_Lang012%|%c_Lang014%|%c_Lang155%
Gui, 24:Add, Combobox, W160 vIECmd gIECmd, %IECmdList%
Gui, 24:Add, Radio, -Wrap Checked W90 vSet gIECmd R1, %c_Lang093%
Gui, 24:Add, Radio, -Wrap x+0 W90 vGet gIECmd Disabled R1, %c_Lang094%
Gui, 24:Add, Radio, -Wrap Group Checked ys+75 xs+10 W90 vMethod gIECmd Disabled R1, %c_Lang095%
Gui, 24:Add, Radio, -Wrap x+0 W90 vProperty gIECmd Disabled R1, %c_Lang096%
Gui, 24:Add, Text, Section ys+95 xs+12 W250 vValueT, %c_Lang056%:
Gui, 24:Add, Edit, yp+20 xs W385 -Multi vValue
Gui, 24:Add, Text, y+10 W55, %c_Lang005%:
Gui, 24:Add, DDL, yp-2 xp+60 W295 vIEWindows AltSubmit, %IEWindows%
Gui, 24:Add, Button, -Wrap yp-1 x+5 W25 H25 hwndRefreshIEW vRefreshIEW gRefreshIEW
	ILButton(RefreshIEW, LoopIcon[1] ":" LoopIcon[2])
Gui, 24:Add, Text, Section ym+30 xm+180 W215 R4 vComTip
Gui, 24:Add, Button, -Wrap Section Default ym+246 xm W60 H23 gIEComOK, %c_Lang020%
Gui, 24:Add, Button, -Wrap ys xs+135 W60 H23 vIEComApply gIEComApply Disabled, %c_Lang131%
; COM Interface
Gui, 24:Tab, 2
Gui, 24:Add, Text, Section W40, %c_Lang098%:
Gui, 24:Add, Combobox, yp xp+50 W260 vComCLSID gTabControl, %CLSList%
GuiControl, 24:ChooseString, ComCLSID, %ComCLSID%
Gui, 24:Add, Button, -Wrap yp-1 x+0 W80 H23 vActiveObj gActiveObj, %c_Lang099%
Gui, 24:Add, Text, xs W80, %c_Lang100%:
Gui, 24:Add, Edit, xp+50 W115 vComHwnd, %ComHwnd%
Gui, 24:Add, Text, x+5 W100, %c_Lang057%:
Gui, 24:Add, Edit, xp+105 W115 vVarName
Gui, 24:Add, Text, Section xs W200, %c_Lang101%:
Gui, 24:Add, Edit, yp+20 xs W390 R4 vComSc gComSc
Gui, 24:Add, Button, -Wrap y+2 xs+365 W25 H25 hwndExpView vExpView gExpView
	ILButton(ExpView, ExpViewIcon[1] ":" ExpViewIcon[2])
Gui, 24:Add, Button, -Wrap Section Default ym+246 xm W60 H23 gComOK, %c_Lang020%
Gui, 24:Add, Button, -Wrap ys xs+135 W60 H23 vComApply gComApply Disabled, %c_Lang131%
; Run Scriptlet
Gui, 24:Tab, 3
Gui, 24:Add, Text, W100, %c_Lang156%:
Gui, 24:Add, Edit, W390 R10 vScLet
Gui, 24:Add, Text, W100, %c_Lang157%:
Gui, 24:Add, Radio, -Wrap Checked yp x+5 W100 vRunVB R1, VBScript
Gui, 24:Add, Radio, -Wrap x+5 W100 vRunJS R1, JScript
Gui, 24:Add, Button, -Wrap yp-2 xs+375 W25 H25 hwndExpView2 vExpView2 gExpView
	ILButton(ExpView2, ExpViewIcon[1] ":" ExpViewIcon[2])
Gui, 24:Add, Button, -Wrap Section Default ym+246 xm W60 H23 gScLetOK, %c_Lang020%
Gui, 24:Add, Button, -Wrap ys xs+135 W60 H23 vScLetApply gScLetApply Disabled, %c_Lang131%
If (A_PtrSize = 8)
	Gui, 24:Add, Text, ys+5 xs+200 W210 cRed, %c_Lang158%
Gui, 24:Tab
Gui, 24:Add, Text, Section ym+172 xm+12 vPgTxt, %c_Lang092%:
Gui, 24:Add, DDL, W70 vIdent Disabled, Name||ID|TagName|Links
Gui, 24:Add, Edit, yp xp+70 vDefEl W245 Disabled
Gui, 24:Add, Edit, yp x+0 vDefElInd W43 Disabled
Gui, 24:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetEl gGetEl Disabled, ...
Gui, 24:Add, Text, yp+30 xs, %c_Lang025%
Gui, 24:Add, Button, -Wrap Section ym+246 xs+55 W60 H23 gIEComCancel, %c_Lang021%
Gui, 24:Add, Checkbox, -Wrap Checked ys+5 xs+135 W205 vLoadWait R1, %c_Lang097%
If (s_Caller = "Edit")
{
	StringReplace, Details, Details, ``n, `n, All
	If (Type = cType34)
	{
		ComCLSID := Target, TabControl := 2
		StringSplit, Act, Action, :
		GuiControl, 24:Choose, TabControl, 2
		If (Target = "")
			GuiControl, 24:Choose, ComCLSID, 0
		Else If InStr(CLSList, Target)
			GuiControl, 24:ChooseString, ComCLSID, %ComCLSID%
		Else
			GuiControl, 24:, ComCLSID, %ComCLSID%||
		GuiControl, 24:, ComHwnd, %Act1%
		GuiControl, 24:, VarName, %Act2%
		GuiControl, 24:, ComSc, %Details%
		GoSub, TabControl
		If InStr(Details, "`n")
			GuiControl, 24:Disabled, VarName
	}
	Else If ((Type = cType42) || (Type = cType43))
	{
		GuiControl, 24:Choose, TabControl, 3
		GuiControl, 24:, ScLet, %Details%
		GuiControl, 24:, % (Type = cType42) ? "RunVB" : "RunJS", 1
		GoSub, TabControl
	}
	Else
	{
		Meth := RegExReplace(Action, ":.*"), IECmd := RegExReplace(Action, "^.*:(.*):.*", "$1")
	,	Ident := RegExReplace(Action, "^.*:"), Act := RegExReplace(Type, ".*_")
	,	DefEl := RegExReplace(Target, ":.*"), DefElInd := RegExReplace(Target, "^.*:")
		GuiControl, 24:, %Act%, 1
		GuiControl, 24:, %Meth%, 1
		If InStr(IECmdList, IECmd)
			GuiControl, 24:ChooseString, IECmd, %IECmd%
		Else
			GuiControl, 24:, IECmd, %IECmd%||
		GoSub, IECmd
		GuiControl, 24:ChooseString, Ident, %Ident%
		GuiControl, 24:, DefEl, %DefEl%
		GuiControl, 24:, DefElInd, %DefElInd%
		GuiControl, 24:, Value, %Details%
	}
	If (Window = "LoadWait")
		GuiControl, 24:, LoadWait, 1
	Else
		GuiControl, 24:, LoadWait, 0
	GuiControl, 24:Enable, IEComApply
	GuiControl, 24:Enable, ComApply
	GuiControl, 24:Enable, ScLetApply
}
Else
{
	Try
		GuiControl, 24:, ComTip, %Tip_Navigate%
	Catch
		GuiControl, 24:, ComTip
}
If (A_ThisLabel = "ComInt")
{
	GuiControl, 24:Choose, TabControl, 2
	GoSub, TabControl
}
Else If (A_ThisLabel = "RunScrLet")
{
	GuiControl, 24:Choose, TabControl, 3
	GoSub, TabControl
}
GuiControl, 24:Choose, IEWindows, %SelIEWin%
Gui, 24:Show, , %c_Lang012% / %c_Lang013%
Tooltip
return

IEComCancel:
24GuiClose:
24GuiEscape:
Gui, 1:-Disabled
Gui, 24:Destroy
s_Caller = 
return

IEComApply:
IEComOK:
Gui, +OwnDialogs
Gui, Submit, NoHide
If (s_Caller <> "Edit")
	TimesX := 1
GuiControlGet, VState, 24:Enabled, Value
If (VState = 0)
	Value := ""
GuiControlGet, VState, 24:Enabled, DefEl
If ((VState = 0) || (DefEl = ""))
	DefEl := "", Ident := ""
If Get
{
	If (Value = "")
	{
		Tooltip, %c_Lang127%, 25, 145
		return
	}
	Try
		z_Check := VarSetCapacity(%Value%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%
		return
	}
	Type := cType33
}
Else
	Type := cType32
If (Value <> "")
	Details := Value
Else
	Details := ""
If (Ident = "ID")
	DefElInd := ""
If (Method = 1)
	Action := "Method:"
Else If (Property = 1)
	Action := "Property:"
Action .= IECmd ":" Ident, Target := DefEl ":" DefElInd
If LoadWait
	Load := "LoadWait"
Else
	Load := ""
ControlGet, SelIEWinName, Choice,, ComboBox2, ahk_id %CmdWin%
SelIEWin := IEWindows
If (SelIEWinName = "[blank]")
	o_ie := ""
Else
	o_ie := IEGet(SelIEWinName)
If (A_ThisLabel <> "IEComApply")
{
	Gui, 1:-Disabled
	Gui, 24:Destroy
}
Gui, 1:Default
RowSelection := LV_GetCount("Selected")
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", Action, Details, TimesX, DelayX, Type, Target, Load)
Else If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, Action , Details, TimesX, DelayG, Type, Target, Load)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, Action , Details, TimesX, DelayG, Type, Target, Load)
		RowNumber++
	}
}
GoSub, b_Start
GoSub, RowCheck
If (A_ThisLabel = "IEComApply")
	Gui, 24:Default
Else
{
	s_Caller = 
	GuiControl, Focus, InputList%A_List%
}
return

ComApply:
ComOK:
Gui, +OwnDialogs
Gui, Submit, NoHide
StringReplace, ComSc, ComSc, `n, ``n, All
If ((ComHwnd = "") || (ComSc = ""))
	return
If (s_Caller <> "Edit")
	TimesX := 1
Try
	z_Check := VarSetCapacity(%ComHwnd%)
Catch
{
	MsgBox, 16, %d_Lang007%, %d_Lang041%
	return
}
If (VarName <> "")
{
	Try
		z_Check := VarSetCapacity(%VarName%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%
		return
	}
}
If ((ComCLSID = "InternetExplorer.Application") && LoadWait)
	Load := "LoadWait"
Else
	Load := ""
Action := ComHwnd ":" VarName
If (A_ThisLabel <> "ComApply")
{
	Gui, 1:-Disabled
	Gui, 24:Destroy
}
Gui, 1:Default
RowSelection := LV_GetCount("Selected")
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", Action, ComSc, TimesX, DelayX, cType34, ComCLSID, Load)
Else If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, Action, ComSc, TimesX, DelayG, cType34, ComCLSID, Load)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, Action, ComSc, TimesX, DelayG, cType34, ComCLSID, Load)
		RowNumber++
	}
}
GoSub, RowCheck
GoSub, b_Start
If (A_ThisLabel = "ComApply")
	Gui, 24:Default
Else
{
	s_Caller = 
	GuiControl, Focus, InputList%A_List%
}
return

ScLetApply:
ScLetOK:
Gui, +OwnDialogs
Gui, Submit, NoHide
StringReplace, ScLet, ScLet, `n, ``n, All
If (ScLet = "")
	return
If (s_Caller <> "Edit")
	TimesX := 1
Action := (RunVB = 1) ? "VB:" : "JS:"
Type := (RunVB = 1) ? cType42 : cType43
If (A_ThisLabel <> "ScLetApply")
{
	Gui, 1:-Disabled
	Gui, 24:Destroy
}
Gui, 1:Default
RowSelection := LV_GetCount("Selected")
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", Action, ScLet, TimesX, DelayX, Type, "ScriptControl")
Else If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, Action, ScLet, TimesX, DelayG, Type, "ScriptControl")
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, Action, ScLet, TimesX, DelayG, Type, "ScriptControl")
		RowNumber++
	}
}
GoSub, RowCheck
GoSub, b_Start
If (A_ThisLabel = "ScLetApply")
	Gui, 24:Default
Else
{
	s_Caller = 
	GuiControl, Focus, InputList%A_List%
}
return

IECmd:
Gui, Submit, NoHide
If IECmd in %NoElemList%
{
	GuiControl, 24:Disable, DefEl
	GuiControl, 24:Disable, DefElInd
	GuiControl, 24:Disable, GetEl
	GuiControl, 24:Disable, Ident
	GuiControl, 24:, LoadWait, 1
}
Else
{
	GuiControl, 24:Enable, DefEl
	GuiControl, 24:Enable, DefElInd
	GuiControl, 24:Enable, GetEl
	GuiControl, 24:Enable, Ident
	GuiControl, 24:, LoadWait, 0
}
If IECmd in %SetOnlyList%
{
	GuiControl, 24:, Set, 1
	GuiControl, 24:Enable, Set
	GuiControl, 24:Disable, Get
	GuiControl, 24:Enable, Value
}
Else If IECmd in %GetOnlyList%
{
	GuiControl, 24:, Get, 1
	GuiControl, 24:Enable, Get
	GuiControl, 24:Disable, Set
	GuiControl, 24:Enable, Value
	GuiControl, 24:, LoadWait, 0
}
Else
{
	GuiControl, 24:Enable, Get
	GuiControl, 24:Enable, Set
}
If IECmd in %NoValueList%
	GuiControl, 24:Disable, Value
Else
	GuiControl, 24:Enable, Value
Gui, Submit, NoHide
If Set
	GuiControl, 24:, ValueT, %c_Lang056%:
Else If Get
	GuiControl, 24:, ValueT, %c_Lang057%:
If IECmd in %MethodList%
{
	GuiControl, 24:Disable, Method
	GuiControl, 24:Disable, Property
	GuiControl, 24:, Method, 1
}
Else If IECmd in %ProperList%
{
	GuiControl, 24:Disable, Method
	GuiControl, 24:Disable, Property
	GuiControl, 24:, Property, 1
}
Else
{
	GuiControl, 24:Enable, Method
	GuiControl, 24:Enable, Property
}
Try
	GuiControl, 24:, ComTip, % Tip_%IECmd%
Catch
	GuiControl, 24:, ComTip
return

ComSc:
Gui, Submit, NoHide
If InStr(ComSc, "`n")
{
	GuiControl, 24:, VarName
	GuiControl, 24:Disabled, VarName
}
Else
	GuiControl, 24:Enabled, VarName
return

ActiveObj:
Gui, Submit, NoHide
Gui, 24:+OwnDialogs
If ((ComHwnd = "") || (ComCLSID = ""))
{
	MsgBox, 16, %d_Lang007%, %d_Lang048%
	return
}
Try
	z_Check := VarSetCapacity(%ComHwnd%)
Catch
{
	MsgBox, 16, %d_Lang007%, %d_Lang041%
	return
}
%ComHwnd% := "", Title := ""
If (ComCLSID = "InternetExplorer.Application")
{
	CoordMode, Mouse, Window
	NoKey := 1, L_Label := ComCLSID
	WinMinimize, ahk_id %CmdWin%
	SetTimer, WatchCursorIE, 100
	StopIt := 0
	WaitFor.Key("RButton")
	SetTimer, WatchCursorIE, off
	ToolTip
	Sleep, 200
	NoKey := 0, L_Label := ""
	WinActivate, ahk_id %CmdWin%
	If (StopIt)
		Exit
	Try
		%ComHwnd% := IEGet()
	If IsObject(%ComHwnd%)
	{
		Title := %ComHwnd%["Document"]["Title"]
		MsgBox, 64, %c_Lang099%, %d_Lang046%`n`n%Title%
	}
	Else
		MsgBox, 16, %c_Lang099%, %d_Lang047%
	StopIt := 1
}
Else If (ComCLSID = "Excel.Application")
{
	CoordMode, Mouse, Window
	NoKey := 1
	WinMinimize, ahk_id %CmdWin%
	SetTimer, WatchCursorXL, 100
	StopIt := 0
	WaitFor.Key("RButton")
	SetTimer, WatchCursorXL, off
	ToolTip
	Sleep, 200
	NoKey := 0
	WinActivate, ahk_id %CmdWin%
	If (StopIt)
		Exit
	Try
	{
		%ComHwnd% := ComObjActive(ComCLSID)
	,	Title := %ComHwnd%["ActiveWorkbook"]["Name"]
	}
	If IsObject(%ComHwnd%)
	{
		MsgBox, 64, %c_Lang099%, %d_Lang046%`n`n%Title%
	}
	Else
		MsgBox, 16, %c_Lang099%, %d_Lang047%
	StopIt := 1
}
Else
{
	Try
		%ComHwnd% := ComObjActive(ComCLSID)
	If IsObject(%ComHwnd%)
		MsgBox, 64, %c_Lang099%, %d_Lang046%
	Else
		MsgBox, 16, %c_Lang099%, %d_Lang047%
}
return

TabControl:
Gui, 24:Submit, NoHide
If (TabControl = 2)
{
	If (ComCLSID = "InternetExplorer.Application")
	{
		GuiControl, 24:Enable, DefEl
		GuiControl, 24:Enable, DefElInd
		GuiControl, 24:Enable, GetEl
		GuiControl, 24:Enable, Ident
		GuiControl, 24:Enable, LoadWait
	}
	Else
	{
		GuiControl, 24:Disabled, DefEl
		GuiControl, 24:Disabled, DefElInd
		GuiControl, 24:Disabled, GetEl
		GuiControl, 24:Disabled, Ident
		GuiControl, 24:Disabled, LoadWait
	}
	GuiControl, 24:, LoadWait, 0
}
Else
{
	GuiControl, 24:Enable, LoadWait
	GoSub, IECmd
}
If (TabControl = 3)
{
	GuiControl, 24:Hide, PgTxt
	GuiControl, 24:Hide, DefEl
	GuiControl, 24:Hide, DefElInd
	GuiControl, 24:Hide, GetEl
	GuiControl, 24:Hide, Ident
	GuiControl, 24:Hide, LoadWait
}
Else
{
	GuiControl, 24:Show, PgTxt
	GuiControl, 24:Show, DefEl
	GuiControl, 24:Show, DefElInd
	GuiControl, 24:Show, GetEl
	GuiControl, 24:Show, Ident
	GuiControl, 24:Show, LoadWait
}
return

RefreshIEW:
IEWindows := ListIEWindows()
GuiControl, 24:, IEWindows, |%IEWindows%
return

ExpView:
Gui, Submit, NoHide
Script := (TabControl = 2) ? ComSc : ScLet
Gui, 30:+owner1 -MaximizeBox -MinimizeBox +E0x00000400 +hwndCmdWin
Gui, 24:+Disabled
; Gui, 30:Font, s7
Gui, 30:Add, Button, -Wrap W25 H25 hwndOpenT vOpenT gOpenT
	ILButton(OpenT, OpenIcon[1] ":" OpenIcon[2])
Gui, 30:Add, Button, -Wrap W25 H25 ys x+0 hwndSaveT vSaveT gSaveT
	ILButton(SaveT, SaveIcon[1] ":" SaveIcon[2])
Gui, 30:Add, Text, W2 H25 ys+2 x+5 0x11
Gui, 30:Add, Button, -Wrap W25 H25 ys x+4 hwndCutT vCutT gCutT
	ILButton(CutT, CutIcon[1] ":" CutIcon[2])
Gui, 30:Add, Button, -Wrap W25 H25 ys x+0 hwndCopyT vCopyT gCopyT
	ILButton(CopyT, CopyIcon[1] ":" CopyIcon[2])
Gui, 30:Add, Button, -Wrap W25 H25 ys x+0 hwndPasteT vPasteT gPasteT
	ILButton(PasteT, PasteIcon[1] ":" PasteIcon[2])
Gui, 30:Add, Button, -Wrap W25 H25 ys x+0 hwndSelAllT vSelAllT gSelAllT
	ILButton(SelAllT, CommentIcon[1] ":" CommentIcon[2])
Gui, 30:Font, s9, Courier New
Gui, 30:Add, Edit, Section xm vTextEdit gTextEdit WantTab W720 R30, %Script%
Gui, 30:Font
; Gui, 30:Font, s7
Gui, 30:Add, Button, -Wrap Section Default xm y+15 W60 H23 gExpViewOK, %c_Lang020%
Gui, 30:Add, Button, -Wrap ys W60 H23 gExpViewCancel, %c_Lang021%
Gui, 30:Add, StatusBar
Gui, 30:Default
SB_SetParts(480, 80)
SB_SetText(c_Lang025, 1)
SB_SetText("length: " 0, 2)
SB_SetText("lines: " 0, 3)
GoSub, TextEdit
Gui, 30:Show,, %c_Lang013%
GuiControl, 30:Focus, TextEdit
return

ExpViewOK:
Gui, Submit, NoHide
Gui, 24:-Disabled
Gui, 30:Destroy
Gui, 24:Default
GuiControl,, % (TabControl = 2) ? "ComSc" : "ScLet", %TextEdit%
GoSub, ComSc
return

ExpViewCancel:
30GuiClose:
30GuiEscape:
Gui, 24:-Disabled
Gui, 30:Destroy
return

DonatePayPal:
If (Lang = "Pt")
	Run, "https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=rodolfoub`%40gmail`%2ecom&lc=BR&item_name=Pulover`%27s`%20Macro`%20Creator&item_number=App`%2ePMC`%2eBr&currency_code=BRL&bn=PP`%2dDonationsBF`%3abtn_donateCC_LG`%2egif`%3aNonHosted"
Else
	Run, "https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=rodolfoub`%40gmail`%2ecom&lc=US&item_name=Pulover`%27s`%20Macro`%20Creator&item_number=App`%2ePMC&currency_code=USD&bn=PP`%2dDonationsBF`%3abtn_donateCC_LG`%2egif`%3aNonHosted"
return

26GuiEscape:
TipClose:
Gui, 26:Submit
Gui, 26:Destroy
WinActivate,,, ahk_id %PMCWinID%
return

TipClose2:
Gui, 26:Submit
Gui, 26:Destroy
return

TipClose3:
NextTip++
Gui, 26:Submit
Gui, 26:Destroy
return

ShowTips:
Gui 26:+LastFoundExist
IfWinExist
	GoSub, TipClose
If (NextTip > MaxTips)
	NextTip := 1
Gui, 26:-SysMenu +HwndStartTipID +owner1
Gui, 26:Color, FFFFFF
; Gui, 26:Font, s7
Gui, 26:Add, Pic, y+20 W48 H48 Icon%TipIcon%, %TipFile%
Gui, 26:Add, Text, Section yp x+10, %d_Lang068%%A_Space%
Gui, 26:Add, Text, yp x+0 vCurrTip, %NextTip%%A_Space%%A_Space%%A_Space%
Gui, 26:Add, Text, yp x+0, / %MaxTips%
Gui, 26:Add, Edit, xs W450 r5 vTipDisplay ReadOnly -0x200000 -E0x200, % StartTip_%NextTip%
Gui, 26:Add, Button, -Wrap y+10 W90 H25 vPTip gPrevTip, %d_Lang022%
Gui, 26:Add, Button, -Wrap yp x+5 W90 H25 vNTip gNextTip, %d_Lang021%
Gui, 26:Add, Button, -Wrap yp x+15 W90 H25 vTipClose gTipClose3, %c_Lang022%
Gui, 26:Add, Checkbox, -Wrap Checked%ShowTips% xm+60 W300 vShowTips R1, %d_Lang067%
Gui, 26:Add, Link, xm, %d_Lang069%
If (NextTip = 1)
	GuiControl, 26:Disable, PTip
GuiControl, 26:Focus, TipClose
Gui, 26:Show,, %AppName%
return

PrevTip:
If (NextTip = 1)
	return
NextTip--
GuiControl, 26:, CurrTip, %NextTip%
GuiControl, 26:, TipDisplay, % StartTip_%NextTip%
GuiControl, 26:Enable, NTip
If (NextTip = 1)
{
	GuiControl, 26:Disable, PTip
	GuiControl, 26:Focus, NTip
}
return

NextTip:
If (NextTip = MaxTips)
	return
NextTip++
GuiControl, 26:, CurrTip, %NextTip%
GuiControl, 26:, TipDisplay, % StartTip_%NextTip%
GuiControl, 26:Enable, PTip
If (NextTip = MaxTips)
{
	GuiControl, 26:Disable, NTip
	GuiControl, 26:Focus, PTip
}
return

RunTimer:
Gui, 27:+owner1 +ToolWindow
Gui, 1:+Disabled
; Gui, 27:Font, s7
Gui, 27:Add, Groupbox, W180 H100
Gui, 27:Add, Edit, ys+15 xs+15 Limit Number W150
Gui, 27:Add, UpDown, vTimerDelayX 0x80 Range0-9999999, %TimerDelayX%
Gui, 27:Add, Radio, -Wrap Section Checked%TimerMsc% yp+25 W150 vTimerMsc R1, %c_Lang018%
Gui, 27:Add, Radio, -Wrap Checked%TimerSec% W150 vTimerSec R1, %c_Lang019%
Gui, 27:Add, Radio, -Wrap Checked%TimerMin% W150 vTimerMin R1, %c_Lang154%
Gui, 27:Add, Radio, -Wrap Section Group Checked%RunOnce% xm W180 vRunOnce gTimerSub R1, %t_Lang078%
Gui, 27:Add, Radio, -Wrap Checked%TimedRun% W180 vTimedRun gTimerSub R1, %t_Lang079%
Gui, 27:Add, Checkbox, -Wrap Checked%RunFirst% xp+15 y+5 W180 vRunFirst R1 Disabled, %t_Lang106%
Gui, 27:Add, Button, -Wrap Section Default xm W60 H23 gTimerOK, %c_Lang020%
Gui, 27:Add, Button, -Wrap ys W60 H23 gTimerCancel, %c_Lang021%
If !(Timer_ran)
{
	GuiControl, 27:, TimerDelayX, 250
	GuiControl, 27:, TimerMsc, 1
	GuiControl, 27:, RunOnce, 1
	GuiControl, 27:, RunFirst, 0
}
If (TimedRun)
	GuiControl, 27:Enable, RunFirst
Gui, 27:Show,, %t_Lang080%
return

TimerSub:
Gui, 27:Submit, NoHide
GuiControl, 27:Enable%TimedRun%, RunFirst
return

TimerOK:
Gui, 27:Submit, NoHide
Gui, 1:-Disabled
Gui, 27:Destroy
Gui, 1:Default
Timer_ran := True
If ListCount%A_List% = 0
	return
GoSub, SaveData
StopIt := 0
Tooltip
WinMinimize, ahk_id %PMCWinID%
If TimerSec = 1
	DelayX := TimerDelayX * 1000
Else If TimerMin = 1
	DelayX := TimerDelayX * 60000
Else
	DelayX := TimerDelayX
If RunOnce = 1
	DelayX := DelayX * -1
ActivateHotkeys(0, 1, 1, 1)
aHK_Timer := A_List
SetTimer, RunTimerOn, %DelayX%
If (TimedRun) && (RunFirst)
	GoSub, RunTimerOn
return

RunTimerOn:
If StopIt
{
	SetTimer, RunTimerOn, Off
	aHK_Timer := False
	return
}
If (aHK_On := Playback(aHK_Timer))
	GoSub, f_RunMacro
FreeMemory()
return

TimerCancel:
27GuiClose:
27GuiEscape:
Gui, 1:-Disabled
Gui, 27:Destroy
return

PlayFrom:
pb_From := !pb_From
If !(pb_From)
	Menu, MacroMenu, Uncheck, %r_Lang009%`t%_s%Alt+1
Else
	Menu, MacroMenu, Check, %r_Lang009%`t%_s%Alt+1
Menu, MacroMenu, Uncheck, %r_Lang010%`t%_s%Alt+2
Menu, MacroMenu, Uncheck, %r_Lang011%`t%_s%Alt+3
pb_To := "", pb_Sel := ""
return

PlayTo:
pb_To := !pb_To
If !(pb_To)
	Menu, MacroMenu, Uncheck, %r_Lang010%`t%_s%Alt+2
Else
	Menu, MacroMenu, Check, %r_Lang010%`t%_s%Alt+2
Menu, MacroMenu, Uncheck, %r_Lang009%`t%_s%Alt+1
Menu, MacroMenu, Uncheck, %r_Lang011%`t%_s%Alt+3
pb_From := "", pb_Sel := ""
return

PlaySel:
pb_Sel := !pb_Sel
If !(pb_Sel)
	Menu, MacroMenu, Uncheck, %r_Lang011%`t%_s%Alt+3
Else
	Menu, MacroMenu, Check, %r_Lang011%`t%_s%Alt+3
Menu, MacroMenu, Uncheck, %r_Lang009%`t%_s%Alt+1
Menu, MacroMenu, Uncheck, %r_Lang010%`t%_s%Alt+2
pb_To := "", pb_From := ""
return

TestRun:
If (ListCount%A_List% = 0)
	return
Gui, Submit, NoHide
GoSub, SaveData
ActivateHotkeys(0, 0, 1, 1)
StopIt := 0
Tooltip
WinMinimize, ahk_id %PMCWinID%
aHK_On := [A_List]
GoSub, f_RunMacro
return

PlayStart:
Gui, +OwnDialogs
Gui, Submit, NoHide
GoSub, PlayActive
If !DontShowPb
{
	Gui 26:+LastFoundExist
	IfWinExist
		GoSub, TipClose
	Gui, 26:-SysMenu +HwndTipScrID
	Gui, 26:Color, FFFFFF
	; Gui, 26:Font, s7
	Gui, 26:Add, Pic, y+20 Icon%HelpIconI%, %shell32%
	Gui, 26:Add, Text, yp x+10, %d_Lang051%`n`n%d_Lang043%`n
	Gui, 26:Add, Checkbox, -Wrap W300 vDontShowPb R1, %d_Lang053%
	Gui, 26:Add, Button, -Wrap Default y+10 W90 H25 gTipClose, %c_Lang020%
	Gui, 26:Show,, %AppName%
}
If (HideMainWin)
	GoSub, ShowHide
Else
	WinMinimize, ahk_id %PMCWinID%
If (OnScCtrl)
	GoSub, ShowControls
return

PlayActive:
Pause, Off
If (ListCount = 0)
	return
GoSub, SaveData
GoSub, ActivateHotkeys
If (ActiveKeys = "Error")
{
	MsgBox, 16, %d_Lang007%, %d_Lang032%
	return
}
If !ActiveKeys
{
	TrayTip, %AppName%, %d_Lang009%,,3
	return
}
StopIt := 0
Tooltip
return

OnScControls:
Gui 28:+LastFoundExist
IfWinExist
{
	GoSub, 28GuiClose
	return
}
ShowControls:
Gui 28:+LastFoundExist
IfWinExist
	return
Gui, 28: +Toolwindow +AlwaysOntop +HwndPMCOSC +E0x08000000
If !(OSCaption)
	Gui, 28:-Caption
Gui, 1:Default
; Gui, 28:Font, s7
Gui, 28:Add, Edit, W40 H23 vOSHKEd Number
Gui, 28:Add, UpDown, vOSHK gOSHK 0x80 Horz 16 Range1-%TabCount%, %A_List%
Gui, 28:Font, Bold s7
Gui, 28:Add, Button, ym-1 x+4 W25 H25 hwndOSPlay vOSPlay gOSPlay
	ILButton(OSPlay, TestRunIcon[1] ":" TestRunIcon[2])
Gui, 28:Add, Button, ym-1 x+0 W25 H25 hwndOSStop vOSStop gOSStop
	ILButton(OSStop, RecStopIcon[1] ":" RecStopIcon[2])
Gui, 28:Add, Button, ym-1 x+0 W25 H25 hwndOSPlayOpt vOSPlayOpt gShowPlayMenu
	ILButton(OSPlayOpt, PlayOptIcon[1] ":" PlayOptIcon[2], 0, "Left")
Gui, 28:Add, Text, W2 H22 ys+3 x+5 0x11
Gui, 28:Add, Button, ym-1 x+4 W25 H25 hwndOSRec vOSRec gRecStart
	ILButton(OSRec, RecordIcon[1] ":" RecordIcon[2])
Gui, 28:Add, Button, ym-1 x+0 W35 H25 hwndOSRecNew vOSRecNew gRecStartNew, +
	ILButton(OSRecNew, RecordIcon[1] ":" RecordIcon[2], 0, "Left")
Gui, 28:Add, Button, ym-1 x+0 W25 H25 hwndOSRecOpt vOSRecOpt gShowRecMenu
	ILButton(OSRecOpt, RecOptIcon[1] ":" RecOptIcon[2], 0, "Left")
Gui, 28:Add, Text, W2 H22 ys+3 x+5 0x11
Gui, 28:Add, Button, ym-1 x+4 W25 H25 hwndOSClear vOSClear gOSClear
	ILButton(OSClear, RemoveIcon[1] ":" RemoveIcon[2])
Gui, 28:Add, Text, W2 H22 ys+3 x+5 0x11
Gui, 28:Add, Checkbox, Checked%ShowProgBar% ys-1 x+4 W25 H25 hwndOSProgB vOSProgB gProgBarToggle 0x1000
	ILButton(OSProgB, ProgBIcon[1] ":" ProgBIcon[2])
Gui, 28:Add, Text, W2 H22 ys+3 x+5 0x11
Gui, 28:Font
Gui, 28:Font, s10, Webdings
Gui, 28:Add, Checkbox, Checked%SlowKeyOn% ys-1 x+4 W30 H16 hwndOSSlow vOSSlow gSlowKeyToggle 0x1000 0xC00
	ILButton(OSSlow, SlowDownIcon[1] ":" SlowDownIcon[2])
Gui, 28:Add, Checkbox, Checked%FastKeyOn% ys-1 x+0 W30 H16 vOSFast gFastKeyToggle 0x1000 0xC00, 8
Gui, 28:Add, Slider, ym+14 xp-40 W115 H10 vOSTrans gTrans NoTicks Thick20 ToolTip Range25-255, %OSTrans%
Gui, 28:Add, Button, ym-1 xp+75 W20 H16 vToggleTB gToggleTB, 1
Gui, 28:Add, Button, yp x+0 W20 H16 vToggleMW gShowHide, 2
Gui, 28:Add, Progress, ym+25 xm W125 H10 vOSCProg c20D000
Gui, 28:Font
Gui, 28:Font, s6 Bold
Gui, 28:Add, Text, yp x+0 W170 r1 vOSCProgTip
Gui, 28:Show, % OSCPos (ShowProgBar ? "H40" : "H30") " W415 NoActivate", %AppName%
WinSet, Transparent, %OSTrans%, ahk_id %PMCOSC%
return

OSHK:
Gui, 28:Submit, NoHide
Gui, 1:Default
GuiControl, 1:Choose, A_List, %OSHK%
GoSub, TabSel
return

OSPlay:
Gui, 28:Submit, NoHide
Gui, 1:Default
GoSub, b_Enable
If (ListCount%OSHK% = 0)
	return
If !(PlayOSOn)
{
	ActivateHotkeys("", "", 1, 1)
	StopIt := 0
	Tooltip
	SetTimer, OSPlayOn, -1
}
Else
	GoSub, f_PauseKey
return

OSStop:
If (Record)
	GoSub, RecStart
Else
	GoSub, f_AbortKey
return

OSPlayOn:
aHK_On := [OSHK]
Gosub, f_RunMacro
return

OSClear:
Gui, 28:Submit, NoHide
Gui, 1:Default
Gui, 1:Listview, %OSHK%
MsgBox, 1, %d_Lang019%, %d_Lang020%
IfMsgBox, OK
	LV_Delete()
GoSub, b_Start
GoSub, RowCheck
return

ProgBarToggle:
Gui, 28:Submit, NoHide
ShowProgBar := OSProgB
GuiControl,, OSCProg
GuiControl,, OSCProgTip
GoSub, 28GuiSize
return

Trans:
Gui, 28:Submit, NoHide
WinSet, Transparent, %OSTrans%, ahk_id %PMCOSC%
return

28GuiClose:
OSCClose:
Gui, 28: +LastFound
WinGetPos, OSX, OSY
OSCPos := "X" OSX " Y" OSY
Gui, 28:Destroy
return

ToggleTB:
If (OSCaption := !OSCaption)
	Gui, 28:+Caption
Else
	Gui, 28:-Caption
return

Capt:
Gui, Submit, NoHide
GuiControl, Focus, InputList%A_List%
Goto, MainLoop
return

InputList:
Gui, ListView, InputList%A_List%
StringCaseSense, On
If ((A_GuiEvent = "I") || (A_GuiEvent = "Normal") || (A_GuiEvent = "A")
|| (A_GuiEvent = "C") || (A_GuiEvent = "K") || (A_GuiEvent = "F")
|| (A_GuiEvent = "f"))
{
	Gui, 2:Submit, NoHide
	If (WinExist("ahk_id " PrevID) && (AutoRefresh = 1))
		GoSub, PrevRefresh
}
If A_GuiEvent = F
{
	Input
	ListFocus := 1
}
If A_GuiEvent = f
{
	Input
	ListFocus := 0
}
If A_GuiEvent = ColClick
{
	If A_EventInfo = 1
	{
		ShowLoopIfMark := !ShowLoopIfMark
		GoSub, RowCheck
	}
	Else If A_EventInfo = 2
	{
		KeyWait, LButton
		KeyWait, LButton, D T%DClickSpd%
		If ErrorLevel
		{
			SelectedRow := LV_GetNext()
			LV_GetText(SelType, SelectedRow, A_EventInfo)
			SelectByType(SelType, A_EventInfo)
		}
		Else
		{
			ShowActIdent := !ShowActIdent
			GoSub, RowCheck
		}
	}
	Else
	{
		SelectedRow := LV_GetNext()
		LV_GetText(SelType, SelectedRow, A_EventInfo)
		SelectByType(SelType, A_EventInfo)
	}
}
If A_GuiEvent = D
{
	If (AllowRowDrag)
	{
		LV_Rows.Drag()
		GoSub, b_Start
		GoSub, RowCheck
	}
}
If A_GuiEvent = RightClick
{
	RowNumber = 0
,	RowSelection := LV_GetCount("Selected")
,	RowNumber := LV_GetNext(RowNumber - 1)
}
If A_GuiEvent <> DoubleClick
	return
RowNumber := LV_GetNext()
If !RowNumber
	return
GoSub, Edit
Tooltip
return

GuiContextMenu:
If A_GuiControl <> InputList%A_List%
	return
Menu, EditMenu, Show, %A_GuiX%, %A_GuiY%
return

CopyTo:
Gui, Submit, NoHide
Menu, CopyMenu, Show
return

DuplicateList:
s_List := A_List
GoSub, TabPlus
d_List := TabCount, RowSelection := 0
GoSub, CopySelection
HistoryMacro%A_List% := new LV_Rows()
GoSub, b_Start
return

CopyList:
s_List := A_List, d_List := A_ThisMenuItemPos, RowSelection := LV_GetCount("Selected")
GoSub, CopySelection
return

CopySelection:
RowNumber := 0
If RowSelection = 0
{
	Loop, % ListCount%s_List%
	{
		RowNumber++
		Gui, ListView, InputList%s_List%
		LV_GetTexts(RowNumber, Action, Details, TimesX, DelayX, Type, Target, Window, Comment, Color)
		ckd := (LV_GetNext(RowNumber-1, "Checked")=RowNumber) ? 1 : 0
		Gui, ListView, InputList%d_List%
		LV_Add("Check" ckd, ListCount%d_List%+1, Action, Details, TimesX, DelayX, Type, Target, Window, Comment, Color)
	}
}
Else
{
	Loop, %RowSelection%
	{
		Gui, ListView, InputList%s_List%
		RowNumber := LV_GetNext(RowNumber)
		LV_GetTexts(RowNumber, Action, Details, TimesX, DelayX, Type, Target, Window, Comment, Color)
		ckd := (LV_GetNext(RowNumber-1, "Checked")=RowNumber) ? 1 : 0
		Gui, ListView, InputList%d_List%
		LV_Add("Check" ckd, ListCount%d_List%+1, Action, Details, TimesX, DelayX, Type, Target, Window)
	}
}
Gui, ListView, InputList%d_List%
ListCount%d_List% := LV_GetCount()
HistCheck(d_List)
GoSub, RowCheck
Gui, ListView, InputList%s_List%
GuiControl, Focus, InputList%A_List%
return

Duplicate:
TempData := new LV_Rows()
TempData.Copy()
If TempData.Paste()
{
	GoSub, b_Start
	GoSub, RowCheck
}
TempData := ""
GuiControl, Focus, InputList%A_List%
return

CopyRows:
If (LV_GetCount("Selected") = 0)
	return
CopyRows := new LV_Rows()
CopyRows.Copy()
return

CutRows:
If (LV_GetCount("Selected") = 0)
	return
CopyRows := new LV_Rows()
CopyRows.Cut()
GoSub, b_Start
GoSub, RowCheck
GuiControl, Focus, InputList%A_List%
return

PasteRows:
If CopyRows.Paste()
{
	GoSub, b_Start
	GoSub, RowCheck
}
return

Undo:
GuiControl, -Redraw, InputList%A_List%
HistoryMacro%A_List%.Undo()
GoSub, RowCheck
GoSub, b_Enable
GuiControl, +Redraw, InputList%A_List%
return

Redo:
GuiControl, -Redraw, InputList%A_List%
HistoryMacro%A_List%.Redo()
GoSub, RowCheck
GoSub, b_Enable
GuiControl, +Redraw, InputList%A_List%
return

TabPlus:
Gui, Submit, NoHide
TabCount++
GuiCtrlAddTab(TabSel, "Macro" TabCount)
Gui, ListView, InputList%TabCount%
HistoryMacro%TabCount% := new LV_Rows(), HistoryMacro%TabCount%.Slot[1] := ""
Gui, ListView, InputList%A_List%
GuiAddLV(TabCount)
GuiControl, Choose, A_List, %TabCount%
Menu, CopyMenu, Add, Macro%TabCount%, CopyList
GuiControl, 28:+Range1-%TabCount%, OSHK

TabSel:
GoSub, SaveData
Gui, Submit, NoHide
Gui, ListView, InputList%A_List%
GoSub, GuiSize
GoSub, LoadData
GoSub, RowCheck
GuiControl, 28:, OSHK, %A_List%
If WinExist("ahk_id " PrevID)
	GoSub, PrevRefresh
return

TabClose:
GoSub, SaveData
GoSub, ResetHotkeys
Gui, Submit, NoHide
If (TabCount = 1)
	return
HistoryMacro%A_List% := ""
Menu, CopyMenu, Delete, Macro%A_List%
s_Tab := A_List
Loop, % TabCount - A_List
{
	n_Tab := s_Tab+1
,	LV_Data := PMC.LVGet("InputList" n_Tab)
,	HistoryMacro%s_Tab% := HistoryMacro%n_Tab%
	Gui, ListView, InputList%s_Tab%
	LV_Delete()
	PMC.LVLoad("InputList" s_Tab, LV_Data)
	Menu, CopyMenu, Rename, % "Macro" n_Tab, Macro%s_Tab%
	s_Tab++
}
Gui, ListView, InputList%s_Tab%
LV_Delete()
If (A_List <> TabCount)
{
	o_AutoKey.Remove(A_List)
	o_ManKey.Remove(A_List)
	o_TimesG.Remove(A_List)
}
TabCount--
s_List := ""
Loop, %TabCount%
	s_List .= "|Macro" A_Index
Gui, ListView, InputList%A_List%
GuiControl,, A_List, %s_List%
GuiControl, Choose, A_List, % (A_List < TabCount) ? A_List : TabCount
Gui, Submit, NoHide
GoSub, GuiSize
GoSub, LoadData
GoSub, RowCheck
If WinExist("ahk_id " PrevID)
	GoSub, PrevRefresh
return

SaveData:
GuiControlGet, JHKOn,, JoyHK
If (JHKOn = 1)
{
	GuiControlGet, HK_AutoKey,, JoyKey
	If !RegExMatch(HK_AutoKey, "i)Joy\d+$")
		HK_AutoKey := ""
}
Else
	GuiControlGet, HK_AutoKey,, AutoKey
GuiControlGet, ManKey,, ManKey
GuiControlGet, TimesO,, TimesG
GuiControlGet, Win1,, Win1
o_AutoKey[A_List] := (Win1 = 1) ? "#" HK_AutoKey : HK_AutoKey
If (o_AutoKey[A_List] = "#")
	o_AutoKey[A_List] := "LWin"
o_ManKey[A_List] := ManKey, o_TimesG[A_List] := TimesO
If WinExist("ahk_id " PrevID)
	GoSub, PrevRefresh
return

LoadData:
If InStr(o_AutoKey[A_List], "Joy")
{
	GuiControl,, JoyHK, 1
	GuiControl,, AutoKey
	GoSub, SetJoyHK
}
Else
{
	GuiControl,, JoyHK, 0
	GuiControl,, JoyKey
	GuiControl,, AutoKey, % LTrim(o_AutoKey[A_List], "#")
	GoSub, SetNoJoy
}
GuiControl,, Win1, % (InStr(o_AutoKey[A_List], "#")) ? 1 : 0
GuiControl,, ManKey, % o_ManKey[A_List]
GuiControl,, TimesG, % (o_TimesG[A_List] = "") ? 1 : o_TimesG[A_List]
return

GetHotkeys:
AutoKey := "", ManKey := ""
For Index, Key in o_AutoKey
	AutoKey .= Key "|"
For Index, Key in o_ManKey
	ManKey .= Key "|"
AutoKey := RTrim(AutoKey, "|"), ManKey := RTrim(ManKey, "|")
return

MoveUp:
GuiControl, -Redraw, InputList%A_List%
LV_Rows.Move(1)
GoSub, RowCheck
HistCheck(A_List)
GuiControl, +Redraw, InputList%A_List%
return

MoveDn:
GuiControl, -Redraw, InputList%A_List%
LV_Rows.Move()
GoSub, RowCheck
HistCheck(A_List)
GuiControl, +Redraw, InputList%A_List%
return

DelLists:
Loop, %TabCount%
{
	Gui, ListView, InputList%A_Index%
	LV_Delete()
	GuiControl, +Redraw, InputList%A_Index%
	Menu, CopyMenu, Delete, Macro%A_Index%
}
Menu, CopyMenu, Add, Macro1, CopyList
return

Order:
LV_Rows.Move(Order)
HistCheck(A_List)
GoSub, RowCheck
return

SelectAll:
LV_Modify(0, "Select")
return

SelectNone:
LV_Modify(0, "-Select")
return

InvertSel:
If (LV_GetCount("Selected") = 0)
	LV_Modify(0, "Select")
Else
{
	Loop, % ListCount%A_List%
	{
		If (LV_GetNext(A_Index-1) = A_Index)
			LV_Modify(A_Index, "-Select")
		Else
			LV_Modify(A_Index, "Select")
	}
}
return

CheckSel:
RowNumber = 0
Loop
{
	RowNumber := LV_GetNext(RowNumber)
	If !RowNumber
		break
	LV_Modify(RowNumber, "Check")
}
GoSub, b_Start
return

UnCheckSel:
RowNumber = 0
Loop
{
	RowNumber := LV_GetNext(RowNumber)
	If !RowNumber
		break
	LV_Modify(RowNumber, "-Check")
}
GoSub, b_Start
return

InvertCheck:
RowNumber = 0
Loop
{
	RowNumber := LV_GetNext(RowNumber)
	If !RowNumber
		break
	If (LV_GetNext(RowNumber-1, "Checked")=RowNumber)
		LV_Modify(RowNumber, "-Check")
	Else
		LV_Modify(RowNumber, "Check")
}
GoSub, b_Start
return


SelectCmd:
SelectByType(A_ThisMenuItem)
return

SelType:
SelectedRow := LV_GetNext()
LV_GetText(SelType, SelectedRow, 6)
SelectByType(SelType)
return

Remove:
Gui, +OwnDialogs
Gui, Submit, NoHide
RowSelection := LV_GetCount("Selected")
If RowSelection = 0
{
	MsgBox, 1, %d_Lang019%, %d_Lang020%
	IfMsgBox, OK
		LV_Delete()
	IfMsgBox, Cancel
		return
}
Else
{
	RowNumber := 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber - 1)
		If !RowNumber
			break
		LV_Delete(RowNumber)
	}
}
GoSub, b_Start
GoSub, RowCheck
GuiControl, Focus, InputList%A_List%
return

ApplyT:
Gui, Submit, NoHide
ApplyTEd:
RowSelection := LV_GetCount("Selected")
If RowSelection = 0
	LV_Modify(0, "Col4", (InStr(Rept, "%") ? Rept : TimesM))
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Modify(RowNumber, "Col4", (InStr(Rept, "%") ? Rept : TimesM))
	}
}
HistCheck(A_List)
return

ApplyI:
Gui, Submit, NoHide
ApplyIEd:
RowSelection := LV_GetCount("Selected")
If RowSelection = 0
	LV_Modify(0, "Col5", (InStr(Delay, "%") ? Delay : DelayG))
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Modify(RowNumber, "Col5", (InStr(Delay, "%") ? Delay : DelayG))
	}
}
HistCheck(A_List)
return

ApplyL:
Gui, Submit, NoHide
StringReplace, sInput, sInput, SC15D, AppsKey
StringReplace, sInput, sInput, SC145, NumLock
StringReplace, sInput, sInput, SC154, PrintScreen
If sInput = 
	return
sKey := RegExReplace(sInput, "(.$)", "$l1"), tKey := sKey
GoSub, Replace
sKey := "{" sKey "}", RowSelection := LV_GetCount("Selected")
If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, tKey, sKey, 1, DelayG, cType1)
	GoSub, b_Start
	LV_Modify(ListCount%A_List%, "Vis")
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, tKey, sKey, 1, DelayG, cType1)
		RowNumber++
	}
}
GoSub, RowCheck
GoSub, b_Start
return

InsertKey:
Gui, Submit, NoHide
Gui, 31:+owner1 +ToolWindow +Delimiter¢ +HwndCmdWin
Gui, 1:+Disabled
; Gui, 13:Font, s7
Gui, 31:Add, Groupbox, Section W220 H100
Gui, 31:Add, DDL, ys+15 xs+10 W200 vsKey, %KeybdList%
Gui, 31:Add, Radio, Checked W200 vKeystroke, %t_Lang108%
Gui, 31:Add, Radio, W200 vKeyDown, %t_Lang109%
Gui, 31:Add, Radio, W200 vKeyUp, %t_Lang110%
Gui, 31:Add, Button, -Wrap Section Default xm W60 H23 gInsertKeyOK, %c_Lang020%
Gui, 31:Add, Button, -Wrap ys W60 H23 gInsertKeyCancel, %c_Lang021%
Gui, 31:Show,, %t_Lang111%
return

InsertKeyOK:
Gui, Submit, NoHide
If (KeyDown)
	State := " Down"
Else If (KeyUp)
	State := " Up"
Else
	State := ""
tKey := sKey, sKey := "{" sKey State "}"
Gui, 1:-Disabled
Gui, 31:Destroy
Gui, 1:Default
RowSelection := LV_GetCount("Selected")
If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, tKey, sKey, 1, DelayG, cType1)
	GoSub, b_Start
	LV_Modify(ListCount%A_List%, "Vis")
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, tKey, sKey, 1, DelayG, cType1)
		RowNumber++
	}
}
GoSub, RowCheck
GoSub, b_Start
return

InsertKeyCancel:
31GuiClose:
31GuiEscape:
Gui, 1:-Disabled
Gui, 31:Destroy
return

/*
Gui, Submit, NoHide
StringReplace, sInput, sInput, SC15D, AppsKey
StringReplace, sInput, sInput, SC145, NumLock
StringReplace, sInput, sInput, SC154, PrintScreen
If sInput = 
	return
sKey := RegExReplace(sInput, "(.$)", "$l1"), tKey := sKey
GoSub, Replace
sKey := "{" sKey "}", RowSelection := LV_GetCount("Selected")
If RowSelection = 0
{
	LV_Add("Check", ListCount%A_List%+1, tKey, sKey, 1, DelayG, cType1)
	GoSub, b_Start
	LV_Modify(ListCount%A_List%, "Vis")
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, tKey, sKey, 1, DelayG, cType1)
		RowNumber++
	}
}
GoSub, RowCheck
GoSub, b_Start
return
*/

EditButton:
Gui, Submit, NoHide
RowSelection := LV_GetCount("Selected"), RowNumber := LV_GetNext()
If (RowSelection = 1)
	GoSub, Edit
Else
	GoSub, MultiEdit
return

Edit:
GoSub, ClearPars
LV_GetTexts(RowNumber, Action, Details, TimesX, DelayX, Type, Target, Window, Comment)
If (Action = "[LoopEnd]")
	return
If Type in %cType7%,%cType38%,%cType39%,%cType40%,%cType41%
	Goto, EditLoop
If Type in %cType15%,%cType16%
	Goto, EditImage
If (Type = cType21)
	Goto, EditVar
If (Action = "[Control]")
	Goto, EditControl
If ((Details = "EndIf") || (Details = "Else") || (Action = "[LoopEnd]"))
	return
If (Type = cType17)
	Goto, EditSt
If Type in %cType18%,%cType19%
	Goto, EditMsg
If ((Type = cType11) || (Type = cType14)
|| InStr(FileCmdList, Type "|")) && (Action <> "[Pause]")
	Goto, EditRun
If Type in %cType29%,%cType30%
	return
If Type in %cType32%,%cType33%,%cType34%,%cType42%,%cType43%
	Goto, EditIECom
If InStr(Type, "Win")
	Goto, EditWindow
If Action contains %Action1%,%Action2%,%Action3%,%Action4%,%Action5%,%Action6%
	Goto, EditMouse
If InStr(Action, "[Text]")
	Goto, EditText
Gui, 15:+owner1 +ToolWindow +HwndCmdWin
Gui, 1:+Disabled
; Gui, 15:Font, s7
Gui, 15:Add, GroupBox, vSGroup Section xm W280 H130 Disabled
Gui, 15:Add, Checkbox, -Wrap Section ys+15 xs+10 W260 vCSend gCSend Hidden R1, %c_Lang016%:
Gui, 15:Add, Edit, vDefCt W230 Disabled Hidden
Gui, 15:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetCtrl gGetCtrl Disabled Hidden, ...
Gui, 15:Add, DDL, Section xs W65 vIdent Disabled Hidden, Title||Class|Process|ID|PID
Gui, 15:Add, Text, -Wrap yp+5 x+5 W190 H20 vWinParsTip Disabled Hidden, %wcmd_All%
Gui, 15:Add, Edit, xs+2 W230 vTitle Disabled Hidden, A
Gui, 15:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetWin gGetWin Disabled Hidden, ...
Gui, 15:Add, Checkbox, -Wrap Section ym+15 xs W260 vMP gMP Hidden R1, %c_Lang051%:
Gui, 15:Add, Edit, vMsgPt W260 r4 Multi Disabled Hidden
Gui, 15:Add, Text, vMsgTxt W260 y+5 xs r2 Hidden, %c_Lang025%
If Type in %cType5%,%cType6%
{
	Gui, 15:Add, Text, y+5 W210, %c_Lang147%:
	Gui, 15:Add, Radio, -Wrap Checked W80 vNoI R1 Disabled, %c_Lang148%
	Gui, 15:Add, Radio, -Wrap x+5 W80 vErr R1 Disabled, %c_Lang149%
	Gui, 15:Add, Radio, -Wrap  x+5 W80 vQue R1 Disabled, %c_Lang150%
	Gui, 15:Add, Radio, -Wrap xs W80 vExc R1 Disabled, %c_Lang151%
	Gui, 15:Add, Radio, -Wrap x+5 W80 vInf R1 Disabled, %c_Lang152%
	Gui, 15:Add, Checkbox, -Wrap W125 xs vAot R1 Disabled, %c_Lang153%
	Gui, 15:Add, Checkbox, -Wrap W125 yp xp+130 vCancelB R1 Disabled, %c_Lang021%
	GuiControl, 15:Move, SGroup, H205
}
Gui, 15:Add, Text, Section ys xs vKWT Hidden, %c_Lang052%
Gui, 15:Add, Hotkey, vWaitKeys gWaitKeys W260 Hidden
Gui, 15:Add, Text, vTimoutT Hidden, %c_Lang053%:
Gui, 15:Add, Edit, yp-2 xs+90 W170 vTimeoutC Hidden
Gui, 15:Add, UpDown, vTimeout 0x80 Range0-999999999 Hidden, 0
Gui, 15:Add, Text, xs+90 vWTT Hidden, %c_Lang054%
Gui, 15:Add, Text, Section ys xs vGoLabT Hidden, %c_Lang078%:
Gui, 15:Add, ComboBox, W260 vGoLabel Hidden
Gui, 15:Add, Radio, vGoto Hidden, Goto
Gui, 15:Add, Radio, yp x+25 vGosub Hidden, Gosub
Gui, 15:Add, Text, Section ys xs vLabelT Hidden, %c_Lang080%:
Gui, 15:Add, Edit, W260 R1 vNewLabel Hidden, %Details%
If Type in %cType35%,%cType36%,%cType37%
{
	Proj_Labels := ""
	Loop, %TabCount%
	{
		Gui, ListView, InputList%A_Index%
		Loop, % ListCount%A_Index%
		{
			LV_GetText(Row_Type, A_Index, 6)
			If (Row_Type = cType35)
			{
				LV_GetText(Row_Label, A_Index, 3)
				Proj_Labels .= Row_Label "|"
			}
		}
	}
	Loop, %TabCount%
		Proj_Labels .= "Macro" A_Index "|"
	GuiControl, 15:, GoLabel, %Proj_Labels%
}
Else
{
	Gui, 15:Add, GroupBox, Section xm W280 H110
	Gui, 15:Add, Text, Section ys+15 xs+10, %w_Lang015%:
	Gui, 15:Add, Text,, %c_Lang017%:
	Gui, 15:Add, Edit, ys xs+90 W170 R1 ys vEdRept
	Gui, 15:Add, UpDown, vTimesX 0x80 Range1-999999999, %TimesX%
	Gui, 15:Add, Edit, W170 vDelayC
	Gui, 15:Add, UpDown, vDelayX 0x80 Range0-999999999, %DelayX%
	Gui, 15:Add, Radio, -Wrap Section yp+25 xm+10 Checked W175 vMsc R1, %c_Lang018%
	Gui, 15:Add, Radio, -Wrap W175 vSec R1, %c_Lang019%
}
Gui, 15:Add, Button, -Wrap Section Default xm W60 H23 gEditOK, %c_Lang020%
Gui, 15:Add, Button, -Wrap ys W60 H23 gEditCancel, %c_Lang021%
Gui, 15:Add, Button, -Wrap ys W60 H23 gEditApply, %c_Lang131%
If InStr(DelayX, "%")
	GuiControl, 15:, DelayC, %DelayX%
If InStr(TimesX, "%")
	GuiControl, 15:, EdRept, %TimesX%
If Type in %cType1%,%cType2%,%cType3%
,%cType4%,%cType8%,%cType9%,%cType13%
{
	GuiControl, 15:Show, CSend
	GuiControl, 15:Show, DefCt
	GuiControl, 15:Show, GetCtrl
	GuiControl, 15:Show, Ident
	GuiControl, 15:Show, WinParsTip
	GuiControl, 15:Show, Title
	GuiControl, 15:Show, GetWin
	If Target <> ""
		GuiControl, 15:, DefCt, %Target%
	If Action contains %Action2%,%Action3%,%Action4%
		GuiControl, 15:Disable, CSend
	If InStr(Type, "Control")
	{
		GuiControl, 15:, CSend, 1
		GuiControl, 15:Enable, DefCt
		GuiControl, 15:Enable, GetCtrl
		GuiControl, 15:Enable, Ident
		GuiControl, 15:, Title, %Window%
		GuiControl, 15:Enable, Title
		GuiControl, 15:Enable, GetWin
	}
}
Else If Type in %cType35%,%cType36%,%cType37%
{
	If Type in %cType36%,%cType37%
	{
		If InStr(Proj_Labels, Details "|")
			GuiControl, 15:ChooseString, GoLabel, %Details%
		Else
			GuiControl, 15:, GoLabel, %Details%||
		GuiControl, 15:Show, GoLabT
		GuiControl, 15:Show, GoLabel
		GuiControl, 15:Show, Goto
		GuiControl, 15:Show, GoSub
		GuiControl, 15:, %Type%, 1
	}
	Else
	{
		GuiControl, 15:Show, LabelT
		GuiControl, 15:Show, NewLabel
	}
}
Else
{
	If (Type = cType5)
	{
		GuiControl, 15:Show, MP
		GuiControl, 15:Show, MsgPt
		GuiControl, 15:Show, MsgTxt
	}
	If (Type = cType6)
	{
		StringReplace, Details, Details, ``n, `n, All
		StringReplace, Details, Details, ```,, `,, All
		GuiControl, 15:Show, MP
		GuiControl, 15:Show, MsgPt
		GuiControl, 15:Show, MsgTxt
		GuiControl, 15:, MP, 1
		GuiControl, 15:, MsgPt, %Details%
		Gui, 15:Default
		GoSub, MP
		GuiControl, 15:, DelayX, 0
		MsgNum := Target
		If (MsgNum > 64)
		{
			GuiControl, 15:, Aot, 1
			MsgNum := MsgNum - 262144
		}
		If (Mod(MsgNum, 2))
		{
			GuiControl, 15:, CancelB, 1
			MsgNum := MsgNum - 1
		}
		If MsgNum = 16
			GuiControl, 15:, Err, 1
		If MsgNum = 32
			GuiControl, 15:, Que, 1
		If MsgNum = 48
			GuiControl, 15:, Exc, 1
		If MsgNum = 64
			GuiControl, 15:, Inf, 1
	}
	Else If (Type = cType20)
	{
		GuiControl, 15:Show, WaitKeys
		GuiControl, 15:Show, TimoutT
		GuiControl, 15:Show, TimeoutC
		GuiControl, 15:Show, Timeout
		GuiControl, 15:Show, KWT
		GuiControl, 15:Show, WTT
		GuiControl, 15:Disable, DelayC
		; GuiControl, 15:Disable, EdRept
		GuiControl, 15:Disable, DelayX
		GuiControl, 15:Disable, Msc
		GuiControl, 15:Disable, Sec
		GuiControl, 15:, WaitKeys, %Details%
		GuiControl, 15:, Timeout, %DelayX%
		GuiControl, 15:, TimeoutC, %DelayX%
		GuiControl, 15:, DelayX, 0
	}
}
If Type in %cType36%,%cType37%
	GuiControl, 15:Show, MsgTxt
Gui, 15:Show,, %w_Lang019%: %Type%
If Window = 
	Window = A
Input
Tooltip
return

CSend:
Gui, Submit, NoHide
GuiControl, Enable%CSend%, DefCt
GuiControl, Enable%CSend%, GetCtrl
GuiControl, Enable%CSend%, SetWin
GuiControl, Enable%CSend%, MRel
GuiControl,, MRel, %CSend%
GuiControl, Enable%CSend%, IniX
GuiControl, Enable%CSend%, IniY
GuiControl, Enable%CSend%, MouseGetI
GuiControl, Enable%CSend%, Ident
GuiControl, Enable%CSend%, Title
GuiControl, Enable%CSend%, GetWin
GuiControl, Disable%CSend%, MEditRept
GuiControl, Disable%CSend%, MEditDelay
return

MEditRept:
Gui, Submit, NoHide
GuiControl, Disable%MEditRept%, MEditDelay
GuiControl, Disable%MEditRept%, CSend
GuiControl, Enable%MEditRept%, EdRept
return

MEditDelay:
Gui, Submit, NoHide
GuiControl, Disable%MEditDelay%, MEditRept
GuiControl, Disable%MEditDelay%, CSend
GuiControl, Enable%MEditDelay%, DelayC
GuiControl, Enable%MEditDelay%, Msc
GuiControl, Enable%MEditDelay%, Sec
return

EditApply:
EditOK:
Gui, +OwnDialogs
Gui, Submit, NoHide
DelayX := InStr(DelayC, "%") ? DelayC : DelayX
If Sec = 1
	DelayX *= 1000
TimesX := InStr(EdRept, "%") ? EdRept : TimesX
If TimesX = 0
	TimesX := 1
Window := Title
If CSend = 1
{
	If DefCt = 
	{
		MsgBox, 52, %d_Lang011%, %d_Lang012%
		IfMsgBox, No
			return
	}
	Target := DefCt
	If (Type = cType1)
		Type := cType2
	If (Type = cType3)
		Type := cType4
	If (Type = cType8)
		Type := cType9
}
Else
{
	Target := "", Window := ""
	If (Type = cType2)
		Type := cType1
	If (Type = cType4)
		Type := cType3
	If (Type = cType9)
		Type := cType8
}
If ((Type = cType5) || (Type = cType6))
{
	If MP = 1
	{
		StringReplace, MsgPT, MsgPT, `n, ``n, All
		StringReplace, MsgPT, MsgPT, `,, ```,, All
		Type := cType6, Details := MsgPT, DelayX := 0
		If NoI = 1
			Target := 0
		If Err = 1
			Target := 16
		If Que = 1
			Target := 32
		If Exc = 1
			Target := 48
		If Inf = 1
			Target := 64
		If Aot = 1
			Target += 262144
		If CancelB = 1
			Target += 1
	}
	Else
		Type := cType5, Details := ""
}
If (Type = cType20)
{
	If (WaitKeys = "")
		return
	tKey := WaitKeys, Details := tKey, DelayX := InStr(TimeoutC, "%") ? TimeoutC : Timeout
}
Else If ((Type = cType36) || (Type = cType37))
	Details := GoLabel, Type := (Goto = 1) ? "Goto" : "Gosub"
Else If (Type = cType35)
	Details := NewLabel
If (A_ThisLabel <> "EditApply")
{
	Gui, 1:-Disabled
	Gui, 15:Destroy
}
Gui, 1:Default
LV_Modify(RowNumber, "Col3", Details, TimesX, DelayX, Type, Target, Window)
GoSub, b_Start
GoSub, RowCheck
If (A_ThisLabel = "EditApply")
{
	LV_GetTexts(RowNumber, Action, Details, TimesX, DelayX, Type, Target, Window, Comment)
	Gui, 15:Default
}
Else
	GuiControl, Focus, InputList%A_List%
return

EditCancel:
15GuiClose:
15GuiEscape:
Gui, 1:-Disabled
Gui, 15:Destroy
return

MultiEdit:
Gui, 6:+owner1 +ToolWindow +hwndCmdWin
Gui, 1:+Disabled
; Gui, 6:Font, s7
Gui, 6:Add, GroupBox, vSGroup Section xm W280 H120
Gui, 6:Add, Checkbox, -Wrap Section ys+15 xs+10 W250 vCSend gCSend R1, %c_Lang016%:
Gui, 6:Add, Edit, vDefCt W230 Disabled
Gui, 6:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetCtrl gGetCtrl Disabled, ...
Gui, 6:Add, DDL, Section xs W65 vIdent Disabled, Title||Class|Process|ID|PID
Gui, 6:Add, Text, -Wrap yp+5 x+5 W190 H20 vWinParsTip Disabled, %wcmd_All%
Gui, 6:Add, Edit, xs+2 W230 vTitle Disabled, A
Gui, 6:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetWin gGetWin Disabled, ...
Gui, 6:Add, GroupBox, Section xm W280 H110
Gui, 6:Add, Checkbox, -Wrap Section ys+15 xs+10 vMEditRept gMEditRept R1, %w_Lang015%:
Gui, 6:Add, Checkbox, -Wrap y+15 vMEditDelay gMEditDelay R1, %c_Lang017%:
Gui, 6:Add, Edit, Disabled W170 R1 ys xs+90 vEdRept
Gui, 6:Add, UpDown, vTimesX 0x80 Range1-999999999, 1
Gui, 6:Add, Edit, Disabled W170 vDelayC
Gui, 6:Add, UpDown, vDelayX 0x80 Range0-999999999, 0
Gui, 6:Add, Radio, -Wrap Section Checked Disabled W175 vMsc R1, %c_Lang018%
Gui, 6:Add, Radio, -Wrap Disabled W175 vSec R1, %c_Lang019%
Gui, 6:Add, Button, -Wrap Section Default xm W60 H23 gMultiOK, %c_Lang020%
Gui, 6:Add, Button, -Wrap ys W60 H23 gMultiCancel, %c_Lang021%
Gui, 6:Add, Button, -Wrap ys W60 H23 gMultiApply, %c_Lang131%
Gui, 6:Show,, %w_Lang019%
Window := "A"
Input
Tooltip
return

MultiApply:
MultiOK:
Gui, +OwnDialogs
Gui, Submit, NoHide
DelayX := InStr(DelayC, "%") ? DelayC : DelayX, TimesX := InStr(EdRept, "%") ? EdRept : TimesX
If MEditRept = 1
{
	TimesTemp := TimesM, TimesM := TimesX
	Gui, 1:Default
	GoSub, ApplyTEd
	TimesM := TimesTemp
	If (A_ThisLabel <> "MultiApply")
		Goto, MultiCancel
	Else
		return
}
Else If MEditDelay = 1
{
	DelayTemp := DelayG, DelayG := DelayX
	Gui, 1:Default
	GoSub, ApplyIEd
	DelayG := DelayTemp
	If (A_ThisLabel <> "MultiApply")
		Goto, MultiCancel
	Else
		return
}
If CSend = 1
{
	If DefCt = 
	{
		MsgBox, 52, %d_Lang011%, %d_Lang012%
		IfMsgBox, No
			return
	}
	Target := DefCt, Window := Title
}
If CSend = 0
	Target := "", Window := ""
If (A_ThisLabel <> "MultiApply")
{
	Gui, 1:-Disabled
	Gui, 6:Destroy
}
Gui, 1:Default
If RowSelection = 0
{
	Loop
	{
		RowNumber := A_Index
		If (RowNumber > ListCount%A_List%)
			break
		LV_GetText(Action, RowNumber, 2)
		If Action contains %Action2%,%Action3%,%Action4%
			continue
		LV_GetText(Type, RowNumber, 6)
		If ((Type = cType1) || (Type = cType2) || (Type = cType3)
		|| (Type = cType4) || (Type = cType8) || (Type = cType9)
		|| (Type = cType10) || (Type = cType22) || (Type = cType23)
		|| (Type = cType24) || (Type = cType25) || (Type = cType26))
		{
			If CSend = 1
			{
				If (Type = cType1)
					Type := cType2
				Else If (Type = cType3)
					Type := cType4
				Else If (Type = cType8)
					Type := cType9
				LV_Modify(RowNumber, "Col6", Type, Target, Window)
			}
			If CSend = 0
			{
				If (Type = cType2)
					Type := cType1
				Else If (Type = cType4)
					Type := cType3
				Else If (Type = cType9)
					Type := cType8
				LV_Modify(RowNumber, "Col6", Type, Target, Window)
			}
		}
		Else If InStr(Type, "Win")
			LV_Modify(RowNumber, "Col8", Window)
	}
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_GetText(Action, RowNumber, 2)
		If Action contains %Action2%,%Action3%,%Action4%
			continue
		LV_GetText(Type, RowNumber, 6)
		If ((Type = cType1) || (Type = cType2) || (Type = cType3)
		|| (Type = cType4) || (Type = cType8) || (Type = cType9)
		|| (Type = cType10) || (Type = cType22) || (Type = cType23)
		|| (Type = cType24) || (Type = cType25) || (Type = cType26))
		{
			If CSend = 1
			{
				If (Type = cType1)
					Type := cType2
				Else If (Type = cType3)
					Type := cType4
				Else If (Type = cType8)
					Type := cType9
				LV_Modify(RowNumber, "Col6", Type, Target, Window)
			}
			Else If CSend = 0
			{
				If (Type = cType2)
					Type := cType1
				Else If (Type = cType4)
					Type := cType3
				Else If (Type = cType9)
					Type := cType8
				LV_Modify(RowNumber, "Col6", Type, Target, Window)
			}
		}
		Else If InStr(Type, "Win")
			LV_Modify(RowNumber, "Col8", Window)
	}
}
If (A_ThisLabel = "MultiApply")
	Gui, 6:Default
Else
	GuiControl, Focus, InputList%A_List%
HistCheck(A_List)
return

MultiCancel:
6GuiClose:
6GuiEscape:
Gui, 1:-Disabled
Gui, 6:Destroy
return

SetJoyButton:
Gui, Submit, NoHide
If (JoyHK = 1)
{
	GoSub, SetJoyHK
	If (JoyKey = "")
		GuiControl,, JoyKey, %t_Lang097%
	GuiControl, Focus, JoyKey
}
Else
	GoSub, SetNoJoy
return

CaptureJoyB:
GuiControl,, JoyKey, %A_ThisHotkey%
GoSub, SaveData
return

SetJoyHK:
GuiControl, Hide, AutoKey
GuiControl, Disable, AutoKey
GuiControl,, Win1, 0
GuiControl, Disable, Win1
If RegExMatch(o_AutoKey[A_List], "i)Joy\d+$")
	GuiControl,, JoyKey, % o_AutoKey[A_List]
GuiControl, Show, JoyKey
ActivateHotkeys("", "", "", "", 1)
return

SetNoJoy:
GuiControl, Enable, AutoKey
GuiControl, Show, AutoKey
GuiControl, Hide, JoyKey
GuiControl, Enable, Win1
ActivateHotkeys("", "", "", "", 0)
return

SetWin:
Gui, 16:+owner1 +ToolWindow +HwndCmdWin
Gui, 1:Default
Gui, 1:+Disabled
; Gui, 16:Font, s7
Gui, 16:Add, Text, ym+5 cBlue, #IfWin
Gui, 16:Add, DDL, yp-3 xp+35 W80 vIfDirectContext, None||Active|NotActive|Exist|NotExist
Gui, 16:Add, DDL, yp x+130 W65 vIdent, Title||Class|Process|ID|PID
Gui, 16:Add, Edit, Section xm W280 vTitle R1 -Multi, %IfDirectWindow%
Gui, 16:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetWin gGetWin, ...
Gui, 16:Add, Button, -Wrap Section Default yp+30 xm W60 H23 gSWinOK, %c_Lang020%
Gui, 16:Add, Button, -Wrap ys W60 H23 gSWinCancel, %c_Lang021%
GuiControl, 16:ChooseString, IfDirectContext, %IfDirectContext%
Gui, 16:Show,, %t_Lang009%
Tooltip
return

SWinOK:
Gui, Submit, NoHide
IfDirectWindow := Title
Gui, 1:-Disabled
Gui, 16:Destroy
Gui, 1:Default
GuiControl, 1:, ContextTip, #IfWin: %IfDirectContext%
return

SWinCancel:
16GuiClose:
16GuiEscape:
Gui, 1:-Disabled
Gui, 16:Destroy
return

EditComm:
RowSelection := LV_GetCount("Selected")
Gui, 17:+owner1 +ToolWindow
Gui, 1:Default
Gui, 1:+Disabled
; Gui, 17:Font, s7
Gui, 17:Add, GroupBox, Section xm W230 H110, %t_Lang064%:
Gui, 17:Add, Edit, ys+25 xs+10 vComm W210 r5
Gui, 17:Add, Button, -Wrap Section Default xm W60 H23 gCommOK, %c_Lang020%
Gui, 17:Add, Button, -Wrap ys W60 H23 gCommCancel, %c_Lang021%
If RowSelection = 1
{
	RowNumber := LV_GetNext()
	LV_GetText(Comment, RowNumber, 9)
	StringReplace, Comment, Comment, `n, %A_Space%, All
	GuiControl, 17:, Comm, %Comment%
}
Gui, 17:Show,, %t_Lang065%
Tooltip
return

CommOK:
Gui, Submit, NoHide
StringReplace, Comm, Comm, `n, %A_Space%, All
Comment := Comm
Gui, 1:-Disabled
Gui, 17:Destroy
Gui, 1:Default
If RowSelection = 1
	LV_Modify(RowNumber, "Col9", Comment)
Else If RowSelection = 0
{
	RowNumber = 0
	Loop
	{
		RowNumber := A_Index
		If (RowNumber > ListCount%A_List%)
			break
		LV_Modify(RowNumber, "Col9", Comment)
	}
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Modify(RowNumber, "Col9", Comment)
	}
}
GuiControl, Focus, InputList%A_List%
return

CommCancel:
17GuiClose:
17GuiEscape:
Gui, 1:-Disabled
Gui, 17:Destroy
return

EditColor:
Gui, Submit, NoHide
rColor := ""
If (A_GuiControl = "ColorPick")
	rColor := ImgFile, OwnerID := CmdWin
Else If InStr(A_GuiControl, "LVColor")
	rColor := %A_GuiControl%, OwnerID := CmdWin
Else
{
	RowSelection := LV_GetCount("Selected"), OwnerID := PMCWinID
	If RowSelection = 1
	{
		RowNumber := LV_GetNext()
		LV_GetText(rColor, RowNumber, 10)
	}
}
If Dlg_Color(rColor, OwnerID, CustomColors)
{
	If (A_GuiControl = "ColorPick")
	{
		GuiControl,, ImgFile, %rColor%
		GuiControl, +Background%rColor%, ColorPrev
	}
	Else If InStr(A_GuiControl, "LVColor")
	{
		%A_GuiControl% := rColor
		Gui, 4:Font, c%rColor%
		GuiControl, 4:Font, %A_GuiControl%
	}
	Else
		GoSub, PaintRows
}
return

PaintRows:
If (rColor = "0xffffff")
	rColor := ""
If RowSelection = 1
	LV_Modify(RowNumber, "Col10", rColor)
Else If RowSelection = 0
{
	RowNumber = 0
	Loop
	{
		RowNumber := A_Index
		If (RowNumber > ListCount%A_List%)
			break
		LV_Modify(RowNumber, "Col10", rColor)
	}
}
Else
{
	RowNumber = 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Modify(RowNumber, "Col10", rColor)
	}
}
GoSub, RowCheck
return

FindReplace:
Input
Gui 18:+LastFoundExist
IfWinExist
	GoSub, FindClose
Gui, 18:+owner1 +ToolWindow
Gui, 1:Default
; Gui, 18:Font, s7
Gui, 18:Add, Text, y+15 x+120 W100, %t_Lang066%:
Gui, 18:Add, DDL, yp-5 xp+90 W70 vSearchCol AltSubmit, Details||Repeat|Delay|Control|Window|Comment|Color
Gui, 18:Add, GroupBox, Section xm W280 H185, %t_Lang068%:
Gui, 18:Add, Edit, ys+25 xs+10 vFind W260 r5
Gui, 18:Add, Button, -Wrap Default y+5 xs+210 W60 H23 gFindOK, %t_Lang068%
Gui, 18:Add, Checkbox, -Wrap yp xs+10 vWholC R1, %t_Lang092%
Gui, 18:Add, Checkbox, -Wrap vMCase R1, %t_Lang069%
Gui, 18:Add, Checkbox, -Wrap vRegExSearch gRegExSearch R1, %t_Lang077%
Gui, 18:Add, Text, y+10 xs+10 W180 vFound
Gui, 18:Add, GroupBox, Section xm W280 H185, %t_Lang070%:
Gui, 18:Add, Edit, ys+25 xs+10 vReplace W260 r5
Gui, 18:Add, Button, -Wrap y+5 xs+210 W60 H23 gReplaceOK, %t_Lang070%
Gui, 18:Add, Radio, -Wrap Checked yp xs+10 W125 vRepSelRows R1, %t_Lang073%
Gui, 18:Add, Radio, -Wrap W125 vRepAllRows R1, %t_Lang074%
Gui, 18:Add, Radio, -Wrap W160 vRepAllMacros R1, %t_Lang075%
Gui, 18:Add, Text, y+10 xs+10 W180 vReplaced
Gui, 18:Add, Button, -Wrap Section xm W60 H23 gFindClose, %c_Lang022%
Gui, 18:Show,, %t_Lang067%
GuiControl, 18:Focus, Find
Tooltip
return

FindOK:
Gui, Submit, NoHide
If Find = 
	return
Gui, 1:Default
StringReplace, Find, Find, `n, ``n, All
LV_Modify(0, "-Select")
t_Col := (SearchCol < 4) ? SearchCol + 2 : SearchCol + 3
Loop
{
	RowNumber := A_Index
	If (RowNumber > ListCount%A_List%)
		break
	LV_GetText(CellText, RowNumber, t_Col)
	If (RegExSearch = 1)
	{
		If RegExMatch(CellText, Find)
			LV_Modify(RowNumber, "Select")
	}
	Else If (WholC = 1)
	{
		 If (MCase = 1)
		 {
			If (CellText == Find)
				LV_Modify(RowNumber, "Select")
		}
		 Else If (CellText = Find)
			LV_Modify(RowNumber, "Select")
	}
	Else If InStr(CellText, Find, MCase)
		LV_Modify(RowNumber, "Select")
}
RowSelection := LV_GetCount("Selected")
GuiControl, 18:, Found, %t_Lang071%: %RowSelection%
If (RowSelection)
	LV_Modify(LV_GetNext(), "Vis")
; GuiControl, Focus, InputList%A_List%
return

ReplaceOK:
Gui, Submit, NoHide
If Find = 
	return
Gui, 1:Default
StringReplace, Find, Find, `n, ``n, All
t_Col := (SearchCol < 4) ? SearchCol + 2 : SearchCol + 3
If RepAllRows = 1
{
	Loop, % ListCount%A_List%
	{
		LV_GetText(CellText, A_Index, t_Col)
		If (RegExSearch = 1)
		{
			If RegExMatch(CellText, Find)
			{
				CellText := RegExReplace(CellText, Find, Replace)
				LV_Modify(A_Index, "Col" t_Col, CellText)
				Replaces += 1
			}
		}
		Else If (WholC = 1)
		{
			If (MCase = 1)
			{
				If (CellText == Find)
				{
					StringReplace, CellText, CellText, %Find%, %Replace%, All
					LV_Modify(A_Index, "Col" t_Col, CellText)
					Replaces += 1
				}
			}
			Else If (CellText = Find)
			{
				StringReplace, CellText, CellText, %Find%, %Replace%, All
				LV_Modify(A_Index, "Col" t_Col, CellText)
				Replaces += 1
			}
		}
		Else If InStr(CellText, Find, MCase)
		{
			StringReplace, CellText, CellText, %Find%, %Replace%, All
			LV_Modify(A_Index, "Col" t_Col, CellText)
			Replaces += 1
		}
	}
	If Replaces > 0
		HistCheck(A_List)
}
Else If RepAllMacros = 1
{
	Tmp_List := A_List
	Loop, %TabCount%
	{
		Gui, 1:ListView, InputList%A_Index%
		Loop,  % ListCount%A_Index%
		{
			LV_GetText(CellText, A_Index, t_Col)
			If (RegExSearch = 1)
			{
				If RegExMatch(CellText, Find)
				{
					CellText := RegExReplace(CellText, Find, Replace)
					LV_Modify(A_Index, "Col" t_Col, CellText)
					Replaces += 1
				}
			}
			Else If (WholC = 1)
			{
				If (MCase = 1)
				{
					If (CellText == Find)
					{
						StringReplace, CellText, CellText, %Find%, %Replace%, All
						LV_Modify(A_Index, "Col" t_Col, CellText)
						Replaces += 1
					}
				}
				Else If (CellText = Find)
				{
					StringReplace, CellText, CellText, %Find%, %Replace%, All
					LV_Modify(A_Index, "Col" t_Col, CellText)
					Replaces += 1
				}
			}
			Else If InStr(CellText, Find, MCase)
			{
				StringReplace, CellText, CellText, %Find%, %Replace%, All
				LV_Modify(A_Index, "Col" t_Col, CellText)
				Replaces += 1
			}
		}
		If Replaces > 0
			HistCheck(A_Index)
	}
	Gui, 1:ListView, InputList%A_List%
}
Else
{
	RowNumber = 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If !RowNumber
			break
		LV_GetText(CellText, RowNumber, t_Col)
		If (RegExSearch = 1)
		{
			If RegExMatch(CellText, Find)
			{
				CellText := RegExReplace(CellText, Find, Replace)
				LV_Modify(RowNumber, "Col" t_Col, CellText)
				Replaces += 1
			}
		}
		Else If (WholC = 1)
		{
			If (MCase = 1)
			{
				If (CellText == Find)
				{
					StringReplace, CellText, CellText, %Find%, %Replace%, All
					LV_Modify(RowNumber, "Col" t_Col, CellText)
					Replaces += 1
				}
			}
			Else If (CellText = Find)
			{
				StringReplace, CellText, CellText, %Find%, %Replace%, All
				LV_Modify(RowNumber, "Col" t_Col, CellText)
				Replaces += 1
			}
		}
		Else If InStr(CellText, Find, MCase)
		{
			StringReplace, CellText, CellText, %Find%, %Replace%, All
			LV_Modify(RowNumber, "Col" t_Col, CellText)
			Replaces += 1
		}
	}
	If Replaces > 0
		HistCheck(A_List)
}
GuiControl, 18:, Replaced, %t_Lang072%: %Replaces%
; GuiControl, Focus, InputList%A_List%
return

RegExSearch:
Gui, Submit, NoHide
GuiControl, 18:Disable%RegExSearch%, WholC
GuiControl, 18:Disable%RegExSearch%, MCase
return

FindClose:
18GuiClose:
18GuiEscape:
Gui, 18:Destroy
return

;##### Playback: #####

f_AutoKey:
Loop, %TabCount%  
	If (o_AutoKey[A_Index] = A_ThisHotkey)
		aHK_On := [A_Index]
StopIt := 0
f_RunMacro:
If (aHK_On := Playback(aHK_On*))
	Goto, f_RunMacro
return

f_ManKey:
Loop, %TabCount%
	If (o_ManKey[A_Index] = A_ThisHotkey)
		mHK_On := A_Index
StopIt := 0
Playback(mHK_On, 0, mHK_On)
return

f_AbortKey:
Gui, 1:Default
StopIt := 1
Pause, Off
If Record
{
	GoSub, RecStop
	GoSub, b_Start
}
GoSub, RowCheck
Try Menu, Tray, Icon, %DefaultIcon%, 1
ToggleButtonIcon(OSPlay, TestRunIcon)
return

PauseKey:
Gui, Submit, NoHide
return

f_PauseKey:
If !(CurrentRange) && !(Record)
	return
If ToggleIcon() && !(Record)
	ToggleButtonIcon(OSPlay, PauseIconB)
Else
	ToggleButtonIcon(OSPlay, TestRunIcon)
Pause,, 1
return

FastKeyToggle:
SlowKeyOn := 0, FastKeyOn := !FastKeyOn
If ShowStep = 1
	TrayTip, %AppName%, % (FastKeyOn) ? t_Lang036 " " SpeedUp "x" : t_Lang035 " 1x"
GuiControl, 28:, OSSlow, 0
GuiControl, 28:, OSFast, %FastKeyOn%
return

SlowKeyToggle:
FastKeyOn := 0, SlowKeyOn := !SlowKeyOn
If ShowStep = 1
	TrayTip, %AppName%, % (SlowKeyOn) ? t_Lang037 " " SpeedDn "x" : t_Lang035 " 1x"
GuiControl, 28:, OSFast, 0
GuiControl, 28:, OSSlow, %SlowKeyOn%
return

CheckHkOn:
Gui, Submit, NoHide
If !A_GuiControl
{
	KeepHkOn := !KeepHkOn
	GuiControl,, KeepHkOn, %KeepHkOn%
}
If (KeepHkOn = 1)
{
	GoSub, KeepHkOn
	Menu, Tray, Check, %w_Lang014%
}
Else
{
	GoSub, ResetHotkeys
	Menu, Tray, Uncheck, %w_Lang014%
	Traytip
}
return

KeepHkOn:
If (A_Gui > 2)
	return
If KeepHkOn
{
	GoSub, SaveData
	ActivateHotkeys(1, 1, 1, 1)
}
return

ResetHotkeys:
ActivateHotkeys(0, 0, 0, 0)
Menu, Tray, Tip, %AppName%
return

ActivateHotkeys:
If CheckDuplicates(AbortKey, o_ManKey, o_AutoKey*)
{
	ActiveKeys := "Error"
	If ShowStep = 1
		Traytip, %AppName%, %d_Lang032%,,3
	return
}
ActiveKeys := ActivateHotkeys(0, 1, 1, 1)
If ((ActiveKeys > 0) && (ShowStep = 1))
	Traytip, %AppName%, % ActiveKeys " " d_Lang025 ((IfDirectContext <> "None") ? "`n[" RegExReplace(t_Lang009, ".*", "$u0") "]" : ""),,1
Menu, Tray, Tip, %AppName%`n%ActiveKeys% %d_Lang025%
return

h_Del:
RowNumber = 0
Loop
{
	RowNumber := LV_GetNext(RowNumber - 1)
	If !RowNumber
		break
	LV_Delete(RowNumber)
}
GoSub, RowCheck
GoSub, b_Start
return

h_NumDel:
RowNumber = 0
Loop
{
	RowNumber := LV_GetNext(RowNumber - 1)
	If !RowNumber
		break
	LV_Delete(RowNumber)
	GoSub, RowCheck
	GoSub, b_Start
}
return

;##### Playback Commands #####

pb_Send:
	Send, %Step%
return
pb_ControlSend:
	Win := SplitWin(Window)
	ControlSend, %Target%, %Step%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_Click:
	Click, %Step%
return
pb_ControlClick:
	Win := SplitWin(Window)
	ControlClick, %Target%, % Win[1], % Win[2], %Par1%, %Par2%, %Par3%, % Win[3], % Win[4]
return
pb_Sleep:
	If (RandomSleeps)
		SleepRandom(DelayX, RandPercent)
	Else If (SlowKeyOn)
		Sleep, (DelayX*SpeedDn)
	Else If (FastKeyOn)
		Sleep, (DelayX/SpeedUp)
	Else
		Sleep, %DelayX%
return
pb_MsgBox:
	StringReplace, Step, Step, ``n, `n, All
	StringReplace, Step, Step, ```,, `,, All
	Try Menu, Tray, Icon, % t_WaitIcon[1], % t_WaitIcon[2]
	If (Action = "MsgBox")
	{
		MsgBox, % Par1, %Par2%, %Par3%, %Par4%
		Try Menu, Tray, Icon, % t_PlayIcon[1], % t_PlayIcon[2]
	}
	Else
	{
		MsgBox, % Target, %d_Lang023%, %Step%
		Try Menu, Tray, Icon, % t_PlayIcon[1], % t_PlayIcon[2]
		IfMsgBox, OK
			return
		IfMsgBox, Cancel
		{
			StopIt := 1
			return
		}
	}
return
pb_SendRaw:
	SendRaw, %Step%
return
pb_ControlSendRaw:
	Win := SplitWin(Window)
	ControlSendRaw, %Target%, %Step%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_ControlSetText:
	Win := SplitWin(Window)
	ControlSetText, %Target%, %Step%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_Run:
	If (Par4 <> "")
		Run, %Par1%, %Par2%, %Par3%, %Par4%
	Else
		Run, %Par1%, %Par2%, %Par3%
return
pb_RunWait:
	Try Menu, Tray, Icon, % t_WaitIcon[1], % t_WaitIcon[2]
	If (Par4 <> "")
		RunWait, %Par1%, %Par2%, %Par3%, %Par4%
	Else
		RunWait, %Par1%, %Par2%, %Par3%
	Try Menu, Tray, Icon, % t_PlayIcon[1], % t_PlayIcon[2]
return
pb_RunAs:
	RunAs, %Par1%, %Par2%, %Par3%
return
pb_Process:
	Process, %Par1%, %Par2%, %Par3%
return
pb_Shutdown:
	Shutdown, %Step%
return
pb_GetKeyState:
	GetKeyState, %Par1%, %Par2%, %Par3%
return
pb_MouseGetPos:
	Loop, 4
	{
		If (Par%A_Index% = "")
			Par%A_Index% := "Null"
	}
	MouseGetPos, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
	Null := ""
return
pb_PixelGetColor:
	PixelGetColor, %Par1%, %Par2%, %Par3%, %Par4%
return
pb_SysGet:
	SysGet, %Par1%, %Par2%, %Par3%
return
pb_SetCapsLockState:
	SetCapsLockState, %Par1%
return
pb_SetNumLockState:
	SetNumLockState, %Par1%
return
pb_SetScrollLockState:
	SetScrollLockState, %Par1%
return
pb_EnvAdd:
	EnvAdd, %Par1%, %Par2%, %Par3%
return
pb_EnvSub:
	EnvSub, %Par1%, %Par2%, %Par3%
return
pb_EnvDiv:
	EnvDiv, %Par1%, %Par2%
return
pb_EnvMult:
	EnvMult, %Par1%, %Par2%
return
pb_EnvGet:
	EnvGet, %Par1%, %Par2%
return
pb_EnvSet:
	EnvSet, %Par1%, %Par2%
return
pb_EnvUpdate:
	EnvUpdate
return
pb_FormatTime:
	FormatTime, %Par1%, %Par2%, %Par3%
return
pb_Transform:
	Transform, %Par1%, %Par2%, %Par3%, %Par4%
return
pb_Random:
	Random, %Par1%, %Par2%, %Par3%
return
pb_FileAppend:
	FileAppend, %Par1%, %Par2%, %Par3%
return
pb_FileCopy:
	FileCopy, %Par1%, %Par2%, %Par3%
return
pb_FileCopyDir:
	FileCopyDir, %Par1%, %Par2%, %Par3%
return
pb_FileCreateDir:
	FileCreateDir, %Step%
return
pb_FileDelete:
	FileDelete, %Step%
return
pb_FileGetAttrib:
	FileGetAttrib, %Par1%, %Par2%
return
pb_FileGetSize:
	FileGetSize, %Par1%, %Par2%, %Par3%
return
pb_FileGetTime:
	FileGetTime, %Par1%, %Par2%, %Par3%
return
pb_FileGetVersion:
	FileGetVersion, %Par1%, %Par2%
return
pb_FileMove:
	FileMove, %Par1%, %Par2%, %Par3%
return
pb_FileMoveDir:
	FileMoveDir, %Par1%, %Par2%, %Par3%
return
pb_FileRead:
	FileRead, %Par1%, %Par2%
return
pb_FileReadLine:
	FileReadLine, %Par1%, %Par2%, %Par3%
return
pb_FileRecycle:
	FileRecycle, %Step%
return
pb_FileRecycleEmpty:
	FileRecycleEmpty, %Step%
return
pb_FileRemoveDir:
	FileRemoveDir, %Par1%, %Par2%
return
pb_FileSelectFile:
	FileSelectFile, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
return
pb_FileSelectFolder:
	FileSelectFolder, %Par1%, %Par2%, %Par3%, %Par4%
return
pb_FileSetAttrib:
	FileSetAttrib, %Par1%, %Par2%, %Par3%, %Par4%
return
pb_FileSetTime:
	FileSetTime, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
return
pb_Drive:
	Drive, %Par1%, %Par2%, %Par3%
return
pb_DriveGet:
	DriveGet, %Par1%, %Par2%, %Par3%
return
pb_DriveSpaceFree:
	DriveSpaceFree, %Par1%, %Par2%
return
pb_Sort:
	Sort, %Par1%, %Par2%
return
pb_StringGetPos:
	StringGetPos, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
return
pb_StringLeft:
	StringLeft, %Par1%, %Par2%, %Par3%
return
pb_StringRight:
	StringRight, %Par1%, %Par2%, %Par3%
return
pb_StringLen:
	StringLen, %Par1%, %Par2%
return
pb_StringLower:
	StringLower, %Par1%, %Par2%, %Par3%
return
pb_StringUpper:
	StringUpper, %Par1%, %Par2%, %Par3%
return
pb_StringMid:
	StringMid, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
return
pb_StringReplace:
	StringReplace, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
return
pb_StringSplit:
	StringSplit, %Par1%, %Par2%, %Par3%, %Par4%
return
pb_StringTrimLeft:
	StringTrimLeft, %Par1%, %Par2%, %Par3%
return
pb_StringTrimRight:
	StringTrimRight, %Par1%, %Par2%, %Par3%
return
pb_SplitPath:
	Loop, 6
	{
		If (Par%A_Index% = "")
			Par%A_Index% := "Null"
	}
	SplitPath, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%
	Null := ""
return
pb_InputBox:
	InputBox, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%
return
pb_ToolTip:
	ToolTip, %Par1%, %Par2%, %Par3%, %Par4%
return
pb_TrayTip:
	TrayTip, %Par1%, %Par2%, %Par3%, %Par4%
return
pb_Progress:
	Progress, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
return
pb_SplashImage:
	SplashImage, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%
return
pb_SplashTextOn:
	SplashTextOn, %Par1%, %Par2%, %Par3%, %Par4%
return
pb_SplashTextOff:
	SplashTextOff
return
pb_RegRead:
	RegRead, %Par1%, %Par2%, %Par3%, %Par4%
return
pb_RegWrite:
	RegWrite, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
return
pb_RegDelete:
	RegDelete, %Par1%, %Par2%, %Par3%
return
pb_SetRegView:
	SetRegView, %Par1%
return
pb_IniRead:
	IniRead, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
return
pb_IniWrite:
	IniWrite, %Par1%, %Par2%, %Par3%, %Par4%
return
pb_IniDelete:
	IniDelete, %Par1%, %Par2%, %Par3%
return
pb_SoundBeep:
	SoundBeep, %Par1%, %Par2%
return
pb_SoundGet:
	SoundGet, %Par1%, %Par2%, %Par3%, %Par4%
return
pb_SoundGetWaveVolume:
	SoundGetWaveVolume, %Par1%, %Par2%
return
pb_SoundPlay:
	SoundPlay, %Par1%, %Par2%
return
pb_SoundSet:
	SoundSet, %Par1%, %Par2%, %Par3%, %Par4%
return
pb_SoundSetWaveVolume:
	SoundSetWaveVolume, %Par1%, %Par2%
return
pb_ClipWait:
	Try Menu, Tray, Icon, % t_WaitIcon[1], % t_WaitIcon[2]
	ClipWait, %Par1%, %Par2%
	Try Menu, Tray, Icon, % t_PlayIcon[1], % t_PlayIcon[2]
return
pb_BlockInput:
	BlockInput, %Step%
return
pb_UrlDownloadToFile:
	UrlDownloadToFile, %Par1%, %Par2%
return
pb_CoordMode:
	CoordMode, %Par1%, %Par2%
return
pb_SendLevel:
	SendLevel, %Step%
return
pb_Pause:
	ToggleIcon()
	Pause
return
pb_ExitApp:
	ExitApp
return
pb_StatusBarGetText:
	StatusBarGetText, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%
return
pb_StatusBarWait:
	Try Menu, Tray, Icon, % t_WaitIcon[1], % t_WaitIcon[2]
	StatusBarWait, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%
	Try Menu, Tray, Icon, % t_PlayIcon[1], % t_PlayIcon[2]
return
pb_Clipboard:
	SavedClip := ClipboardAll
	If (Step <> "")
	{
		Clipboard =
		Clipboard := Step
		Sleep, 333
	}
	If (Target <> "")
	{
		Win := SplitWin(Window)
		ControlSend, %Target%, {Control Down}{v}{Control Up}, % Win[1], % Win[2], % Win[3], % Win[4]
	}
	Else
		Send, {Control Down}{v}{Control Up}
	Clipboard := SavedClip
	SavedClip =
return
pb_SendEvent:
	SendEvent, %Step%
return
pb_Control:
	Win := SplitWin(Window)
	Control, % RegExReplace(Step, "(^\w*).*", "$1")
	, % RegExReplace(Step, "^\w*, ?(.*)", "$1")
	, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_ControlFocus:
	Win := SplitWin(Window)
	ControlFocus, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_ControlMove:
	Win := SplitWin(Window)
	ControlMove, %Target%, %Par1%, %Par2%, %Par3%, %Par4%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_PixelSearch:
	CoordMode, Pixel, %Window%
	PixelSearch, FoundX, FoundY, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%, %Par7%
	SearchResult := ErrorLevel
	GoSub, TakeAction
return
pb_ImageSearch:
	CoordMode, Pixel, %Window%
	ImageSearch, FoundX, FoundY, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
	SearchResult := ErrorLevel
	GoSub, TakeAction
return
pb_SendMessage:
	Win := SplitWin(Window)
	SendMessage, %Par1%, %Par2%, %Par3%, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_PostMessage:
	Win := SplitWin(Window)
	PostMessage, %Par1%, %Par2%, %Par3%, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_KeyWait:
	Try Menu, Tray, Icon, % t_WaitIcon[1], % t_WaitIcon[2]
	If (Action = "KeyWait")
		KeyWait, %Par1%, %Par2%
	Else
		WaitFor.Key(Step, DelayX / 1000)
	Try Menu, Tray, Icon, % t_PlayIcon[1], % t_PlayIcon[2]
return
pb_Input:
	Input, %Par1%, %Par2%, %Par3%, %Par4%
return
pb_ControlEditPaste:
	Win := SplitWin(Window)
	Control, EditPaste, %Step%, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_ControlGetText:
	Win := SplitWin(Window)
	ControlGetText, %Step%, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_ControlGetFocus:
	Win := SplitWin(Window)
	ControlGetFocus, %Step%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_ControlGet:
	Win := SplitWin(Window)
	ControlGet, %Par1%, %Par2%, %Par3%, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_ControlGetPos:
	Win := SplitWin(Window)
	ControlGetPos, %Step%X, %Step%Y, %Step%W, %Step%H, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_WinActivate:
	Win := SplitWin(Window)
	WinActivate, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_WinActivateBottom:
	Win := SplitWin(Window)
	WinActivateBottom, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_WinClose:
	Win := SplitWin(Window)
	WinClose, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_WinHide:
	Win := SplitWin(Window)
	WinHide, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_WinKill:
	Win := SplitWin(Window)
	WinKill, % Win[1], % Win[2], % Win[3], % Win[4], % Win[5]
return
pb_WinMaximize:
	Win := SplitWin(Window)
	WinMaximize, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_WinMinimize:
	Win := SplitWin(Window)
	WinMinimize, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_WinMinimizeAll:
	WinMinimizeAll, %Window%
return
pb_WinMinimizeAllUndo:
	WinMinimizeAllUndo, %Window%
return
pb_WinMove:
	Win := SplitWin(Window)
	WinMove, % Win[1], % Win[2], %Par1%, %Par2%, %Par3%, %Par4%, % Win[3], % Win[4]
return
pb_WinRestore:
	Win := SplitWin(Window)
	WinRestore, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_WinSet:
	Win := SplitWin(Window)
	WinSet, %Par1%, %Par2%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_WinShow:
	Win := SplitWin(Window)
	WinShow, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_WinSetTitle:
	Win := SplitWin(Window)
	WinSetTitle, % Win[1], % Win[2], % Win[3], % Win[4], % Win[5]
return
pb_WinWait:
	Try Menu, Tray, Icon, % t_WaitIcon[1], % t_WaitIcon[2]
	WaitFor.WinExist(SplitWin(Window), Step)
	Try Menu, Tray, Icon, % t_PlayIcon[1], % t_PlayIcon[2]
return
pb_WinWaitActive:
	Try Menu, Tray, Icon, % t_WaitIcon[1], % t_WaitIcon[2]
	WaitFor.WinActive(SplitWin(Window), Step)
	Try Menu, Tray, Icon, % t_PlayIcon[1], % t_PlayIcon[2]
return
pb_WinWaitNotActive:
	Try Menu, Tray, Icon, % t_WaitIcon[1], % t_WaitIcon[2]
	WaitFor.WinNotActive(SplitWin(Window), Step)
	Try Menu, Tray, Icon, % t_PlayIcon[1], % t_PlayIcon[2]
return
pb_WinWaitClose:
	Try Menu, Tray, Icon, % t_WaitIcon[1], % t_WaitIcon[2]
	WaitFor.WinClose(SplitWin(Window), Step)
	Try Menu, Tray, Icon, % t_PlayIcon[1], % t_PlayIcon[2]
return
pb_WinGet:
	Win := SplitWin(Window)
	WinGet, %Par1%, %Par2%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_WinGetTitle:
	Win := SplitWin(Window)
	WinGetTitle, %Step%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_WinGetClass:
	Win := SplitWin(Window)
	WinGetClass, %Step%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_WinGetText:
	Win := SplitWin(Window)
	WinGetText, %Step%, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_WinGetpos:
	Win := SplitWin(Window)
	WinGetPos, %Step%X, %Step%Y, %Step%W, %Step%H, % Win[1], % Win[2], % Win[3], % Win[4]
return
pb_GroupAdd:
	GroupAdd, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%
return
pb_GroupActivate:
	GroupActivate, %Par1%, %Par2%
return
pb_GroupDeactivate:
	GroupDeactivate, %Par1%, %Par2%
return
pb_GroupClose:
	GroupClose, %Par1%, %Par2%
return

;##### Playback COM Commands #####

pb_IECOM_Set:
	StringSplit, Act, Action, :
	StringSplit, El, Target, :
	IeIntStr := IEComExp(Act2, Step, El1, El2, "", Act3, Act1)
,	IeIntStr := SubStr(IeIntStr, 4)

	Try
		o_ie.readyState
	Catch
	{
		If (ComAc)
			o_ie := IEGet()
		Else
		{
			o_ie := ComObjCreate("InternetExplorer.Application")
		,	o_ie.Visible := true
		}
	}
	If !IsObject(o_ie)
	{
		o_ie := ComObjCreate("InternetExplorer.Application")
	,	o_ie.Visible := true
	}
	
	Try
		COMInterface(IeIntStr, o_ie)
	Catch e
	{
		MsgBox, 20, %d_Lang007%, % d_Lang064 " Macro" mMacroOn ", " d_Lang065 " " mListRow
			.	"`n" d_Lang007 ": " e.Message "`n" d_Lang066 ": " e.Extra "`n`n" d_Lang035
		IfMsgBox, No
		{
			StopIt := 1
			return
		}
	}
	
	If (Window = "LoadWait")
		Try
			IELoad(o_ie)
return

pb_IECOM_Get:
	Try
		z_Check := VarSetCapacity(%Step%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%
		StopIt := 1
		return
	}
	
	StringSplit, Act, Action, :
	StringSplit, El, Target, :
	IeIntStr := IEComExp(Act2, "", El1, El2, Step, Act3, Act1)
,	IeIntStr := SubStr(IeIntStr, InStr(IeIntStr, "ie.") + 3)
	
	Try
		o_ie.readyState
	Catch
	{
		If (ComAc)
			o_ie := IEGet()
		Else
		{
			o_ie := ComObjCreate("InternetExplorer.Application")
		,	o_ie.Visible := true
		}
	}
	If !IsObject(o_ie)
	{
		o_ie := ComObjCreate("InternetExplorer.Application")
	,	o_ie.Visible := true
	}
	
	Try
		COMInterface(IeIntStr, o_ie, %Step%)
	Catch e
	{
		MsgBox, 20, %d_Lang007%, % d_Lang064 " Macro" mMacroOn ", " d_Lang065 " " mListRow
			.	"`n" d_Lang007 ": " e.Message "`n" d_Lang066 ": " e.Extra "`n`n" d_Lang035
		IfMsgBox, No
		{
			StopIt := 1
			return
		}
	}
	
	If (Window = "LoadWait")
		Try
			IELoad(o_ie)
return

pb_VBScript:
pb_JScript:
VB := "", JS := ""
StringReplace, Step, Step, `n, ``n, All
Step := "Language := " Type "`nExecuteStatement(" Step ")"

pb_COMInterface:
	StringSplit, Act, Action, :

	Try
		z_Check := VarSetCapacity(%Act2%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%
		StopIt := 1
		return
	}

	Loop, Parse, Step, `n, %A_Space%%A_Tab%
	{
		StringReplace, LoopField, A_LoopField, ``n, `n, All
		Try
		{
			If !IsObject(%Act1%)
				%Act1% := COMInterface(LoopField, %Act1%, %Act2%, Target)
			Else
				COMInterface(LoopField, %Act1%, %Act2%, Target)
		}
		Catch e
		{
			MsgBox, 20, %d_Lang007%, % d_Lang064 " Macro" mMacroOn ", " d_Lang065 " " mListRow
				.	"`n" d_Lang007 ": " e.Message "`n" d_Lang066 ": " e.Extra "`n`n" d_Lang035
			IfMsgBox, No
			{
				StopIt := 1
				return
			}
		}
	}

	If (Window = "LoadWait")
		Try
			IELoad(%Act1%)
return

TakeAction:
TakeAction := DoAction(FoundX, FoundY, Act1, Act2, Window, SearchResult)
If (TakeAction = "Continue")
	TakeAction := 0
Else If (TakeAction = "Stop")
	StopIt := 1
Else If (TakeAction = "Prompt")
{
	If (SearchResult = 0)
		MsgBox, 49, %d_Lang035%, %d_Lang036% %FoundX%x%FoundY%.`n%d_Lang038%
	Else
		MsgBox, 49, %d_Lang035%, %d_Lang037%`n%d_Lang038%
	IfMsgBox, Cancel
		StopIt := 1
}
CoordMode, Mouse, %CoordMouse%
return

SplitStep:
GoSub, ClearPars
If (Type = cType34)
	StringReplace, Step, Step, `n, ø, All
If (Type = cType39)
	Step := RegExReplace(Step, "\w+", "%$0%", "", 1)
EscCom("Step|TimesX|DelayX|Target|Window", 1)
StringReplace, Step, Step, `%A_Space`%, ⱥ, All
CheckVars("Step|TimesX|DelayX|Target|Window", This_Point)
StringReplace, Step, Step, ```,, ¢, All
StringReplace, Step, Step, ``n, `n, All
StringReplace, Step, Step, ``r, `r, All
StringReplace, Step, Step, ``t, `t, All
Loop, Parse, Step, `,, %A_Space%
{
	LoopField := A_LoopField
	CheckVars("LoopField", This_Point)
	If ((InStr(Type, "String") = 1) || (Type = SplitPath))
	{
		If RegExMatch(LoopField, "i)^A_Loop\w+$", lMatch)
		{
			I := DerefVars(LoopIndex), L := SubStr(lMatch, 3)
		,	This_Par := o_Loop%This_Point%[I][L]
		,	Par%A_Index% := "This_Par"
		}
		Else
			Par%A_Index% := LoopField
	}
	Else
		Par%A_Index% := LoopField
	StringReplace, Par%A_Index%, Par%A_Index%, ``n, `n, All
	StringReplace, Par%A_Index%, Par%A_Index%, ``r, `r, All
	StringReplace, Par%A_Index%, Par%A_Index%, ¢, `,, All
	StringReplace, Par%A_Index%, Par%A_Index%, ⱥ, %A_Space%, All
	StringReplace, Par%A_Index%, Par%A_Index%, ``,, All
}
StringReplace, Step, Step, ¢, `,, All
StringReplace, Step, Step, ⱥ, %A_Space%, All
StringReplace, Step, Step, ``,, All
If (Type = cType34)
{
	StringReplace, Step, Step, `n, ``n, All
	StringReplace, Step, Step, ø, `n, All
}
return

ClearPars:
Loop, 7
	Par%A_Index% := ""
return

ListVars:
ListVars
return

;##### Hide / Close: #####

ShowHide:
If WinExist("ahk_id" PMCWinID)
{
	Menu, Tray, Rename, %y_Lang001%, %y_Lang002%
	Gui, 1:Show, Hide
}
Else
{
	Menu, Tray, Rename, %y_Lang002%, %y_Lang001%
	Gui, 1:Show,, %AppName% v%CurrentVersion% %CurrentFileName%
	GoSub, GuiSize
}
return

OnFinishAction:
If OnFinishCode =  2
	ExitApp
If OnFinishCode =  3
	Shutdown, 1
If OnFinishCode =  4
	Shutdown, 5
If OnFinishCode =  5
	Shutdown, 2
If OnFinishCode =  6
	Shutdown, 0
If OnFinishCode =  7
	DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)
If OnFinishCode =  8
	DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
If OnFinishCode =  9
	DllCall("LockWorkStation")
return

Exit:
GuiClose:
Gui, 1:Default
Gui, +OwnDialogs
Gui, Submit, NoHide
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
DetectHiddenWindows, On
WinGet, WinState, MinMax, ahk_id %PMCWinID%
If WinState = -1
	WinState := 0
ColSizes := ""
Loop % LV_GetCount("Col")
{
    SendMessage, 4125, A_Index - 1, 0, SysListView321, ahk_id %PMCWinID%
	ColSizes .= Floor(ErrorLevel / Round(A_ScreenDPI / 96, 2)) ","
}
GoSub, GetHotkeys
If (KeepDefKeys = 1)
	AutoKey := DefAutoKey, ManKey := DefManKey
IfWinExist, ahk_id %PMCOSC%
	GoSub, 28GuiClose
GoSub, WriteSettings
IL_Destroy(LV_hIL)
ExitApp
return

;##### Default Settings: #####

LoadSettings:
If !KeepDefKeys
	AutoKey := "F3|F4|F5|F6|F7", ManKey := ""
AbortKey := "F8"
,	PauseKey := 0
,	RecKey := "F9"
,	RecNewKey := "F10"
,	RelKey := "CapsLock"
,	DelayG := 0
,	OnScCtrl := 1
,	ShowStep := 1
,	HideMainWin := 1
,	DontShowPb := 0
,	DontShowRec := 0
,	DontShowAdm := 0
,	IfDirectContext := "None"
,	IfDirectWindow := ""
,	KeepHkOn := 0
,	Mouse := 1
,	Moves := 1
,	TimedI := 1
,	Strokes := 1
,	CaptKDn := 0
,	MScroll := 1
,	WClass := 1
,	WTitle := 1
,	MDelay := 0
,	DelayM := 10
,	DelayW := 333
,	MaxHistory := 100
,	TDelay := 10
,	ToggleC := 0
,	RecKeybdCtrl := 0
,	RecMouseCtrl := 0
,	CoordMouse := "Window"
,	FastKey := "Insert"
,	SlowKey := "Pause"
,	ClearNewList := 0
,	SpeedUp := 2
,	SpeedDn := 2
,	MouseReturn := 0
,	ShowProgBar := 1
,	ShowBarOnStart := 0
,	RandomSleeps := 0
,	RandPercent := 50
,	DrawButton := "RButton"
,	OnRelease := 1
,	OnEnter := 0
,	LineW := 2
,	ScreenDir := A_AppData "\MacroCreator\Screenshots"
,	DefaultMacro := ""
,	StdLibFile := ""
,	Ex_AbortKey := 0
,	Ex_PauseKey := 0
,	Ex_SM := 1
,	SM := "Input"
,	Ex_SI := 1
,	SI := "Force"
,	Ex_ST := 1
,	ST := 2
,	Ex_DH := 1
,	Ex_AF := 1
,	Ex_HK := 0
,	Ex_PT := 0
,	Ex_NT := 0
,	Ex_SC := 1
,	SC := 1
,	Ex_SW := 1
,	SW := 0
,	Ex_SK := 1
,	SK := -1
,	Ex_MD := 1
,	MD := -1
,	Ex_SB := 1
,	SB := -1
,	Ex_MT := 0
,	MT := 2
,	Ex_IN := 1
,	Ex_UV := 1
,	Ex_Speed := 0
,	ComCr := 1
,	ComAc := 0
,	Send_Loop := 0
,	TabIndent := 1
,	IncPmc := 0
,	Exe_Exp := 0
,	WinState := 0
,	HKOff := 0
,	MultInst := 0
,	EvalDefault := 0
,	AllowRowDrag := 1
,	ShowLoopIfMark := 1
,	ShowActIdent := 1
,	LoopLVColor := 0xFFFF00
,	IfLVColor := 0x0000FF
,	OSCPos := "X0 Y0"
,	OSTrans := 255
,	OSCaption := 0
,	OSCaption := 0
,	CustomColors := 0
,	OnFinishCode := 1
GoSub, SetFinishButtom
Gui 28:+LastFoundExist
IfWinExist
{
    WinSet, Transparent, %OSTrans%, ahk_id %PMCOSC%
	GuiControl, 28:, OSTrans, 255
	GuiControl, 28:, OSProgB, 1
	Gui, 28:-Caption
	Gui, 28:Show, % OSCPos (ShowProgBar ? "H40" : "H30") " W415 NoActivate", %AppName%
}
GuiControl, 1:, CoordTip, CoordMode: %CoordMouse%
GuiControl, 1:, ContextTip, #IfWin: %IfDirectContext%
GuiControl, 1:, AbortKey, %AbortKey%
GuiControl, 1:, Win1, 0
GuiControl, 1:, PauseKey, 0
GuiControl, 1:, DelayG, 0
GuiControl, 1:, KeepHkOn, 0
GuiControl, 1:, HideMainWin, 1
GuiControl, 1:, OnScCtrl, 1
GoSub, DefaultMod
GoSub, ObjCreate
GoSub, LoadData
SetColSizes:
ColSizes := "65,125,190,50,40,85,90,90,60,40"
Loop, Parse, ColSizes, `,
	Col_%A_Index% := A_LoopField
Gui, 1:Default
Loop, %TabCount%
{
	Gui, ListView, InputList%A_Index%
	Loop, 10
		LV_ModifyCol(A_Index, Col_%A_Index%)
}
Gui, ListView, InputList%A_List%
return

DefaultMod:
VirtualKeys := "
(Join
{LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}
{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}
{1}{2}{3}{4}{5}{6}{7}{8}{9}{0}{'}{-}{=}{[}{]}{;}{/}{,}{.}{\}
{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Esc}
{PrintScreen}{Pause}{Enter}{Tab}{Space}
{Numpad0}{Numpad1}{Numpad2}{Numpad3}{Numpad4}{Numpad5}{Numpad6}{Numpad7}
{Numpad8}{Numpad9}{NumpadDot}{NumpadDiv}{NumpadMult}{NumpadAdd}{NumpadSub}
{NumpadIns}{NumpadEnd}{NumpadDown}{NumpadPgDn}{NumpadLeft}{NumpadClear}
{NumpadRight}{NumpadHome}{NumpadUp}{NumpadPgUp}{NumpadDel}{NumpadEnter}
{Browser_Back}{Browser_Forward}{Browser_Refresh}{Browser_Stop}
{Browser_Search}{Browser_Favorites}{Browser_Home}{Volume_Mute}{Volume_Down}
{Volume_Up}{Media_Next}{Media_Prev}{Media_Stop}{Media_Play_Pause}
{Launch_Mail}{Launch_Media}{Launch_App1}{Launch_App2}
)"
return

DefaultHotkeys:
If (KeepDefKeys = 1)
	AutoKey := DefAutoKey, ManKey := DefManKey
Else
	AutoKey := "F3|F4|F5|F6|F7", ManKey := ""
o_AutoKey := Object(), o_ManKey := Object()
GoSub, ObjParse
GoSub, SetNoJoy
GoSub, LoadData
GoSub, b_Start
return

ObjCreate:
o_AutoKey := Object()
,	o_ManKey := Object()
,	o_TimesG := Object()

ObjParse:
Loop, Parse, AutoKey, |
	o_AutoKey.Insert(A_LoopField)
Loop, Parse, ManKey, |
	o_ManKey.Insert(A_LoopField)
return

WriteSettings:
IniWrite, %CurrentVersion%, %IniFilePath%, Application, Version
IniWrite, %Lang%, %IniFilePath%, Language, Lang
IniWrite, %AutoKey%, %IniFilePath%, HotKeys, AutoKey
IniWrite, %ManKey%, %IniFilePath%, HotKeys, ManKey
IniWrite, %AbortKey%, %IniFilePath%, HotKeys, AbortKey
IniWrite, %PauseKey%, %IniFilePath%, HotKeys, PauseKey
IniWrite, %RecKey%, %IniFilePath%, HotKeys, RecKey
IniWrite, %RecNewKey%, %IniFilePath%, HotKeys, RecNewKey
IniWrite, %RelKey%, %IniFilePath%, HotKeys, RelKey
IniWrite, %FastKey%, %IniFilePath%, HotKeys, FastKey
IniWrite, %SlowKey%, %IniFilePath%, HotKeys, SlowKey
IniWrite, %ClearNewList%, %IniFilePath%, Options, ClearNewList
IniWrite, %DelayG%, %IniFilePath%, Options, DelayG
IniWrite, %OnScCtrl%, %IniFilePath%, Options, OnScCtrl
IniWrite, %ShowStep%, %IniFilePath%, Options, ShowStep
IniWrite, %HideMainWin%, %IniFilePath%, Options, HideMainWin
IniWrite, %DontShowPb%, %IniFilePath%, Options, DontShowPb
IniWrite, %DontShowRec%, %IniFilePath%, Options, DontShowRec
IniWrite, %DontShowAdm%, %IniFilePath%, Options, DontShowAdm
IniWrite, %ShowTips%, %IniFilePath%, Options, ShowTips
IniWrite, %NextTip%, %IniFilePath%, Options, NextTip
IniWrite, %IfDirectContext%, %IniFilePath%, Options, IfDirectContext
IniWrite, %IfDirectWindow%, %IniFilePath%, Options, IfDirectWindow
IniWrite, %KeepHkOn%, %IniFilePath%, Options, KeepHkOn
IniWrite, %Mouse%, %IniFilePath%, Options, Mouse
IniWrite, %Moves%, %IniFilePath%, Options, Moves
IniWrite, %TimedI%, %IniFilePath%, Options, TimedI
IniWrite, %Strokes%, %IniFilePath%, Options, Strokes
IniWrite, %CaptKDn%, %IniFilePath%, Options, CaptKDn
IniWrite, %MScroll%, %IniFilePath%, Options, MScroll
IniWrite, %WClass%, %IniFilePath%, Options, WClass
IniWrite, %WTitle%, %IniFilePath%, Options, WTitle
IniWrite, %MDelay%, %IniFilePath%, Options, MDelay
IniWrite, %DelayM%, %IniFilePath%, Options, DelayM
IniWrite, %DelayW%, %IniFilePath%, Options, DelayW
IniWrite, %MaxHistory%, %IniFilePath%, Options, MaxHistory
IniWrite, %TDelay%, %IniFilePath%, Options, TDelay
IniWrite, %ToggleC%, %IniFilePath%, Options, ToggleC
IniWrite, %RecKeybdCtrl%, %IniFilePath%, Options, RecKeybdCtrl
IniWrite, %RecMouseCtrl%, %IniFilePath%, Options, RecMouseCtrl
IniWrite, %CoordMouse%, %IniFilePath%, Options, CoordMouse
IniWrite, %SpeedUp%, %IniFilePath%, Options, SpeedUp
IniWrite, %SpeedDn%, %IniFilePath%, Options, SpeedDn
IniWrite, %MouseReturn%, %IniFilePath%, Options, MouseReturn
IniWrite, %ShowProgBar%, %IniFilePath%, Options, ShowProgBar
IniWrite, %ShowBarOnStart%, %IniFilePath%, Options, ShowBarOnStart
IniWrite, %RandomSleeps%, %IniFilePath%, Options, RandomSleeps
IniWrite, %RandPercent%, %IniFilePath%, Options, RandPercent
IniWrite, %DrawButton%, %IniFilePath%, Options, DrawButton
IniWrite, %OnRelease%, %IniFilePath%, Options, OnRelease
IniWrite, %OnEnter%, %IniFilePath%, Options, OnEnter
IniWrite, %LineW%, %IniFilePath%, Options, LineW
IniWrite, %ScreenDir%, %IniFilePath%, Options, ScreenDir
IniWrite, %DefaultMacro%, %IniFilePath%, Options, DefaultMacro
IniWrite, %StdLibFile%, %IniFilePath%, Options, StdLibFile
IniWrite, %KeepDefKeys%, %IniFilePath%, Options, KeepDefKeys
IniWrite, %HKOff%, %IniFilePath%, Options, HKOff
IniWrite, %MultInst%, %IniFilePath%, Options, MultInst
IniWrite, %EvalDefault%, %IniFilePath%, Options, EvalDefault
IniWrite, %AllowRowDrag%, %IniFilePath%, Options, AllowRowDrag
IniWrite, %ShowLoopIfMark%, %IniFilePath%, Options, ShowLoopIfMark
IniWrite, %ShowActIdent%, %IniFilePath%, Options, ShowActIdent
IniWrite, %LoopLVColor%, %IniFilePath%, Options, LoopLVColor
IniWrite, %IfLVColor%, %IniFilePath%, Options, IfLVColor
IniWrite, %VirtualKeys%, %IniFilePath%, Options, VirtualKeys
IniWrite, %AutoUpdate%, %IniFilePath%, Options, AutoUpdate
IniWrite, %Ex_AbortKey%, %IniFilePath%, ExportOptions, Ex_AbortKey
IniWrite, %Ex_PauseKey%, %IniFilePath%, ExportOptions, Ex_PauseKey
IniWrite, %Ex_SM%, %IniFilePath%, ExportOptions, Ex_SM
IniWrite, %SM%, %IniFilePath%, ExportOptions, SM
IniWrite, %Ex_SI%, %IniFilePath%, ExportOptions, Ex_SI
IniWrite, %SI%, %IniFilePath%, ExportOptions, SI
IniWrite, %Ex_ST%, %IniFilePath%, ExportOptions, Ex_ST
IniWrite, %ST%, %IniFilePath%, ExportOptions, ST
IniWrite, %Ex_DH%, %IniFilePath%, ExportOptions, Ex_DH
IniWrite, %Ex_AF%, %IniFilePath%, ExportOptions, Ex_AF
IniWrite, %Ex_HK%, %IniFilePath%, ExportOptions, Ex_HK
IniWrite, %Ex_PT%, %IniFilePath%, ExportOptions, Ex_PT
IniWrite, %Ex_NT%, %IniFilePath%, ExportOptions, Ex_NT
IniWrite, %Ex_SC%, %IniFilePath%, ExportOptions, Ex_SC
IniWrite, %SC%, %IniFilePath%, ExportOptions, SC
IniWrite, %Ex_SW%, %IniFilePath%, ExportOptions, Ex_SW
IniWrite, %SW%, %IniFilePath%, ExportOptions, SW
IniWrite, %Ex_SK%, %IniFilePath%, ExportOptions, Ex_SK
IniWrite, %SK%, %IniFilePath%, ExportOptions, SK
IniWrite, %Ex_MD%, %IniFilePath%, ExportOptions, Ex_MD
IniWrite, %MD%, %IniFilePath%, ExportOptions, MD
IniWrite, %Ex_SB%, %IniFilePath%, ExportOptions, Ex_SB
IniWrite, %SB%, %IniFilePath%, ExportOptions, SB
IniWrite, %Ex_MT%, %IniFilePath%, ExportOptions, Ex_MT
IniWrite, %MT%, %IniFilePath%, ExportOptions, MT
IniWrite, %Ex_IN%, %IniFilePath%, ExportOptions, Ex_IN
IniWrite, %Ex_UV%, %IniFilePath%, ExportOptions, Ex_UV
IniWrite, %Ex_Speed%, %IniFilePath%, ExportOptions, Ex_Speed
IniWrite, %ComCr%, %IniFilePath%, ExportOptions, ComCr
IniWrite, %ComAc%, %IniFilePath%, ExportOptions, ComAc
IniWrite, %Send_Loop%, %IniFilePath%, ExportOptions, Send_Loop
IniWrite, %TabIndent%, %IniFilePath%, ExportOptions, TabIndent
IniWrite, %IncPmc%, %IniFilePath%, ExportOptions, IncPmc
IniWrite, %Exe_Exp%, %IniFilePath%, ExportOptions, Exe_Exp
IniWrite, %WinState%, %IniFilePath%, WindowOptions, WinState
IniWrite, %ColSizes%, %IniFilePath%, WindowOptions, ColSizes
IniWrite, %CustomColors%, %IniFilePath%, WindowOptions, CustomColors
IniWrite, %OSCPos%, %IniFilePath%, WindowOptions, OSCPos
IniWrite, %OSTrans%, %IniFilePath%, WindowOptions, OSTrans
IniWrite, %OSCaption%, %IniFilePath%, WindowOptions, OSCaption
return

;###########################################################
; Original by jaco0646
; http://autohotkey.com/forum/topic51428.html
;###########################################################

#If ctrl := HotkeyCtrlHasFocus()
*AppsKey::
*BackSpace::
*Delete::
*Enter::
*NumpadEnter::
*Escape::
*Pause::
*PrintScreen::
*Space::
*Tab::
modifier := ""
If (GuiA <> 15) && (GuiA <> 3) && HotkeyCtrlHasFocus()!="ManKey"
{
	If GetKeyState("Shift","P")
		modifier .= "+"
	If GetKeyState("Ctrl","P")
		modifier .= "^"
	If GetKeyState("Alt","P")
		modifier .= "!"
}
Gui, %GuiA%:Submit, NoHide
If (A_ThisHotkey == "*BackSpace" && %ctrl% && !modifier)
	GuiControl, %GuiA%:,%ctrl%
Else
	GuiControl, %GuiA%:,%ctrl%, % modifier SubStr(A_ThisHotkey,2)
return
#If

;##################################################

;##### Subroutines: Checks #####

b_Start:
Gui, Submit, NoHide
Gui, ListView, InputList%A_List%
GoSub, b_Enable
If !Record
	HistCheck(A_List)
GuiControl, 28:+Range1-%TabCount%, OSHK
GuiControl, 28:, OSHK, %A_List%
return

b_Enable:
ListCount%A_List% := LV_GetCount(), ListCount := 0
Loop, %TabCount%
	ListCount += ListCount%A_Index%
GuiControl, Enable%ListCount%, StartB
return

WinCheck:
WinGet, W_ID, ID, A
If ((WinActive("ahk_id " PrevID)) || (W_ID = TipScrID)
|| (W_ID = StartTipID) || (W_ID = PMCOSC))
	return
WinGetClass, W_CLS, ahk_id %W_ID%
If (W_CLS = "#32770")
	return
If ((WPHKC = 1) || (WPHKC = 2))
{
	Input
	ToolTip
	If Record = 1
		GoSub, RowCheck
	If WinActive("ahk_id " PMCWinID)
	{
		Record := 0, StopIt := 1
		Sleep, 100
		GoSub, RecStop
		GoSub, ResetHotkeys
	}
}
Else
	GoSub, KeepHkOn
Gui, 1:Submit, NoHide
Gui, 1:ListView, InputList%A_List%
return

WaitMenuClose:
IfWinNotExist, ahk_class #32768
{
	SetTimer, WaitMenuClose, Off
	SetTimer, ResumeCheck, -333
}
return

ResumeCheck:
HaltCheck := 0
return

RowCheck:
Gui, ListView, InputList%A_List%
GuiControl, -Redraw, InputList%A_List%
ListCount%A_List% := LV_GetCount()
,	IdxLv := "", ActLv := "", IsInIf := 0, IsInLoop := 0, RowColorLoop := 0, RowColorIf := 0
Loop, % LV_GetCount()
{
	LV_GetText(Action, A_Index, 2)
	Action := LTrim(Action)
	LV_GetText(Type, A_Index, 6)
	LV_GetText(Color, A_Index, 10)
	LV_Modify(A_Index, "Col2", Action)
	If ShowLoopIfMark = 1
	{
		OnMessage(WM_NOTIFY, "LV_ColorsMessage")
		LV_Colors.Attach(ListID%A_List%, False, False)
		If (Action = "[LoopEnd]")
			RowColorLoop--, IdxLv := SubStr(IdxLv, 1, StrLen(IdxLv)-1)
		Else If (Action = "[End If]")
			RowColorIf--, IdxLv := SubStr(IdxLv, 1, StrLen(IdxLv)-1)
		Else If (Action = "[LoopStart]")
			RowColorLoop++, IdxLv .= "{"
		Else If ((Type = cType17) && (Action <> "[Else]"))
			RowColorIf++, IdxLv .= "*"
		LV_Colors.Row(ListID%A_List%, A_Index
		, (RowColorLoop > 0) ? LoopLVColor : ((Action = "[LoopEnd]") ? LoopLVColor : "")
		, (RowColorIf > 0 ) ? IfLVColor : ((Action = "[End If]") ? IfLVColor : ""))
		LV_Colors.Cell(ListID%A_List%, A_Index, 1, Color ? Color : "")
	}
	Else
	{
		OnMessage(WM_NOTIFY, "")
		LV_Colors.Detach(ListID%A_List%)
	}
	If ShowActIdent = 1
	{
		LV_Modify(A_Index, "Col2", ActLv Action)
		If (Action = "[LoopEnd]")
			ActLv := SubStr(ActLv, 4), LV_Modify(A_Index, "Col2", ActLv Action)
		Else If (Action = "[End If]")
			ActLv := SubStr(ActLv, 4), LV_Modify(A_Index, "Col2", ActLv Action)
		Else If (Action = "[Else]")
			LV_Modify(A_Index, "Col2", SubStr(ActLv, 4) Action)
		Else If (Action = "[LoopStart]")
			ActLv .= (ShowActIdent) ? "   " : ""
		Else If ((Type = cType17) && (Action <> "[Else]"))
			ActLv .= (ShowActIdent) ? "   " : ""
	}
	LV_Modify(A_Index, "", A_Index " " IdxLv)
	If (Action = "[Text]")
		LV_Modify(A_Index, "Icon" 1)
	Else If Type in %cType1%,%cType2%,%cType8%,%cType9%
		LV_Modify(A_Index, "Icon" 1)
	Else If Type in %cType3%,%cType4%,%cType13%
		LV_Modify(A_Index, "Icon" 2)
	Else If Action = [Pause]
		LV_Modify(A_Index, "Icon" 3)
	Else If Type in %cType7%,%cType38%,%cType39%,%cType40%,%cType41%
		LV_Modify(A_Index, "Icon" 4)
	Else If Type = %cType29%
		LV_Modify(A_Index, "Icon" 26)
	Else If Type = %cType30%
		LV_Modify(A_Index, "Icon" 27)
	Else If Type in %cType11%,%cType14%
		LV_Modify(A_Index, "Icon" 5)
	Else If Action = [Assign Variable]
		LV_Modify(A_Index, "Icon" 14)
	Else If Type = %cType21%
		LV_Modify(A_Index, "Icon" 15)
	Else If Type = %cType17%
		LV_Modify(A_Index, "Icon" 6)
	Else If Type in %cType18%,%cType19%
		LV_Modify(A_Index, "Icon" 13)
	Else If Type = %cType15%
		LV_Modify(A_Index, "Icon" 24)
	Else If Type = %cType16%
		LV_Modify(A_Index, "Icon" 7)
	Else If Action = [Control]
		LV_Modify(A_Index, "Icon" 9)
	Else If Type in %cType32%,%cType33%
		LV_Modify(A_Index, "Icon" 10)
	Else If Type = %cType34%
		LV_Modify(A_Index, "Icon" 25)
	Else If Type = %cType42%
		LV_Modify(A_Index, "Icon" 35)
	Else If Type = %cType43%
		LV_Modify(A_Index, "Icon" 36)
	Else If Type = %cType35%
		LV_Modify(A_Index, "Icon" 11)
	Else If Type in %cType36%,%cType37%
		LV_Modify(A_Index, "Icon" 12)
	Else If InStr(Type, "Win")
		LV_Modify(A_Index, "Icon" 8)
	Else If Type in Run,RunWait,RunAs
		LV_Modify(A_Index, "Icon" 5)
	Else If Type in Process
		LV_Modify(A_Index, "Icon" 29)
	Else If Type in Shutdown
		LV_Modify(A_Index, "Icon" 28)
	Else If (InStr(Type, "File")=1 || InStr(Type, "Drive")=1)
		LV_Modify(A_Index, "Icon" 16)
	Else If Type contains Sort,String,Split
		LV_Modify(A_Index, "Icon" 17)
	Else If Type contains InputBox,Msg,Tip,Progress,Splash
		LV_Modify(A_Index, "Icon" 21)
	Else If (InStr(Type, "Wait") || InStr(Type, "Input")=1)
		LV_Modify(A_Index, "Icon" 19)
	Else If Type contains Ini
		LV_Modify(A_Index, "Icon" 22)
	Else If Type contains Reg
		LV_Modify(A_Index, "Icon" 31)
	Else If Type contains Sound
		LV_Modify(A_Index, "Icon" 30)
	Else If Type contains Group
		LV_Modify(A_Index, "Icon" 20)
	Else If Type contains Env
		LV_Modify(A_Index, "Icon" 14)
	Else If Type contains Get
		LV_Modify(A_Index, "Icon" 18)
	Else If (Type = "Pause")
		LV_Modify(A_Index, "Icon" 32)
	Else If (Type = "Return")
		LV_Modify(A_Index, "Icon" 33)
	Else If (Type = "ExitApp")
		LV_Modify(A_Index, "Icon" 34)
	Else If Type contains LockState,Time,Transform,Random,ClipWait,Block,Url,Status,SendLevel,CoordMode
		LV_Modify(A_Index, "Icon" 23)
	Else
		LV_Modify(A_Index, "Icon" 1)
}
GuiControl, +Redraw, InputList%A_List%
FreeMemory()
return

RecKeyUp:
If !GetKeyState("RAlt", "P")
	HoldRAlt := 0
If Record = 0
{
	Gui, Submit, NoHide
	If Capt = 0
	{
		HotKey, %A_ThisHotKey%, RecKeyUp, Off
		return
	}
}
StringTrimLeft, sKey, A_ThisHotKey, 2
If (sKey = "VKC1SC730 Up")
	sKey := "/ Up"
Else If (sKey = "VKC2SC7E0 Up")
	sKey := ". Up"
ScK := GetKeySC(RegExReplace(sKey, " Up$"))
Hold%ScK% := 0, tKey := sKey, sKey := "{" sKey "}"
If (Record || ListFocus)
	GoSub, InsertRow
HotKey, %A_ThisHotKey%, RecKeyUp, Off
return

;##### Size & Position: #####

2GuiSize:
If A_EventInfo = 1
	return

pGuiWidth := A_GuiWidth, pGuiHeight := A_GuiHeight

GuiControl, Move, LVPrev, % "W" pGuiWidth "H" pGuiHeight-60
return

28GuiSize:
Gui, 28:Show, % (ShowProgBar ? "H40" : "H30") " W415 NoActivate", %AppName%
return

GuiSize:
If A_EventInfo = 1
	return

GuiGetSize(WinW, WinH) , GuiSize(WinW, WinH)
; GuiSize(A_GuiWidth, A_GuiHeight)
return

;##### Subroutines: Substitution #####

Replace:
If InStr(sKey, "_")
	StringReplace, tKey, tKey, _, %A_Space%, All
If InStr(tKey, "+")
	StringReplace, sKey, tKey, +, Shift Down}{
If InStr(tKey, "^")
	StringReplace, sKey, tKey, ^, Control Down}{
If InStr(tKey, "!")
	StringReplace, sKey, tKey, !, Alt Down}{
If InStr(sKey, "+")
	StringReplace, sKey, sKey, +, Shift Down}{
If InStr(sKey, "^")
	StringReplace, sKey, sKey, ^, Control Down}{
If InStr(sKey, "!")
	StringReplace, sKey, sKey, !, Alt Down}{

If InStr(sKey, "Alt Down")
	sKey := sKey "}{Alt Up"
If InStr(sKey, "Control Down")
	sKey := sKey "}{Control Up"
If InStr(sKey, "Shift Down")
	sKey := sKey "}{Shift Up"

StringGetPos, pos, tKey, +
If pos = 0
	StringReplace, tKey, tKey, +, Shift +%A_Space%
If InStr(tKey, "^")
	StringReplace, tKey, tKey, ^, Control +%A_Space%
If InStr(tKey, "!")
	StringReplace, tKey, tKey, !, Alt +%A_Space%

If InStr(tKey, "Numpad")
	StringReplace, tKey, tKey, Numpad, Num%A_Space%
return

ChReplace:
Loop, 26
{
	Transform, Ch, Chr, %A_Index%
	StringReplace, sKey, sKey, %Ch%, % Chr(96+A_Index)
}
return

;##### MenuBar: #####

CreateMenuBar:
GoSub, RecentFiles
; Menus
Menu, FileMenu, Add, %f_Lang001%`t%_s%Ctrl+N, New
Menu, FileMenu, Add, %f_Lang002%`t%_s%Ctrl+O, Open
Menu, FileMenu, Add, %f_Lang003%`t%_s%Ctrl+S, Save
Menu, FileMenu, Add, %f_Lang004%`t%_s%Ctrl+Shift+S, SaveAs
Menu, FileMenu, Add, %f_Lang005%`t%_s%Ctrl+I, Import
Menu, FileMenu, Add, %f_Lang006%`t%_s%Ctrl+Alt+S, SaveCurrentList
Menu, FileMenu, Add, %f_Lang007%, :RecentMenu
Menu, FileMenu, Add
Menu, FileMenu, Add, %f_Lang008%`t%_s%Ctrl+E, Export
Menu, FileMenu, Add, %f_Lang009%`t%_s%Ctrl+P, Preview
Menu, FileMenu, Add
Menu, FileMenu, Add, %f_Lang010%`t%_s%Alt+F3, ListVars
Menu, FileMenu, Add
Menu, FileMenu, Add, %f_Lang011%`t%_s%Alt+F4, Exit
Menu, InsertMenu, Add, %i_Lang001%`t%_s%F2, Mouse
Menu, InsertMenu, Add, %i_Lang002%`t%_s%F3, Text
Menu, InsertMenu, Add, %i_Lang003%`t%_s%F4, ControlCmd
Menu, InsertMenu, Add, %i_Lang004%`t%_s%F5, Pause
Menu, InsertMenu, Add, %i_Lang005%`t%_s%F6, Window
Menu, InsertMenu, Add, %i_Lang006%`t%_s%F7, Image
Menu, InsertMenu, Add, %i_Lang007%`t%_s%F8, Run
Menu, InsertMenu, Add, %i_Lang008%`t%_s%F9, ComLoop
Menu, InsertMenu, Add, %i_Lang009%`t%_s%F10, IfSt
Menu, InsertMenu, Add, %i_Lang010%`t%_s%F11, IECom
Menu, InsertMenu, Add, %i_Lang011%`t%_s%F12, SendMsg
Menu, InsertMenu, Add, %i_Lang012%`t%_s%Shift+F3, Special

TypesMenu := "Win`nFile`nString"
Loop
{
	If !(cType%A_Index%)
		break
	TypesMenu .= "`n" cType%A_Index%
}
Sort, TypesMenu
Loop, Parse, TypesMenu, `n
	Menu, SelCmdMenu, Add, %A_LoopField%, SelectCmd

Menu, SelectMenu, Add, %s_Lang001%`t%_s%Ctrl+A, SelectAll
Menu, SelectMenu, Add, %s_Lang002%`t%_s%Ctrl+Shift+A, SelectNone
Menu, SelectMenu, Add, %s_Lang003%`t%_s%Ctrl+Alt+A, InvertSel
Menu, SelectMenu, Add
Menu, SelectMenu, Add, %s_Lang004%`t%_s%Ctrl+Q, CheckSel
Menu, SelectMenu, Add, %s_Lang005%`t%_s%Ctrl+Shift+Q, UnCheckSel
Menu, SelectMenu, Add, %s_Lang006%`t%_s%Ctrl+Alt+Q, InvertCheck
Menu, SelectMenu, Add
Menu, SelectMenu, Add, %s_Lang007%, SelType
Menu, SelectMenu, Add, %s_Lang008%, :SelCmdMenu
Menu, CopyMenu, Add, Macro1, CopyList
Menu, EditMenu, Add, %m_Lang004%`t%_s%Enter, EditButton
Menu, EditMenu, Add, %e_Lang001%`t%_s%Ctrl+D, Duplicate
Menu, EditMenu, Add, %e_Lang003%`t%_s%Ctrl+F, FindReplace
Menu, EditMenu, Add, %e_Lang002%`t%_s%Ctrl+L, EditComm
Menu, EditMenu, Add, %e_Lang014%`t%_s%Ctrl+M, EditColor
Menu, EditMenu, Default, %m_Lang004%`t%_s%Enter
Menu, EditMenu, Add
Menu, EditMenu, Add, %m_Lang002%, :InsertMenu
Menu, EditMenu, Add, %m_Lang003%, :SelectMenu
Menu, EditMenu, Add, %e_Lang004%, :CopyMenu
Menu, EditMenu, Add
Menu, EditMenu, Add, %e_Lang005%`t%_s%Ctrl+Z, Undo
Menu, EditMenu, Add, %e_Lang006%`t%_s%Ctrl+Y, Redo
Menu, EditMenu, Add
Menu, EditMenu, Add, %e_Lang007%`t%_s%Ctrl+X, CutRows
Menu, EditMenu, Add, %e_Lang008%`t%_s%Ctrl+C, CopyRows
Menu, EditMenu, Add, %e_Lang009%`t%_s%Ctrl+V, PasteRows
Menu, EditMenu, Add, %e_Lang010%`t%_s%Delete, Remove
Menu, EditMenu, Add, %e_Lang013%`t%_s%Insert, ApplyL
Menu, EditMenu, Add
Menu, EditMenu, Add, %e_Lang011%`t%_s%Ctrl+PgUp, MoveUp
Menu, EditMenu, Add, %e_Lang012%`t%_s%Ctrl+PgDn, MoveDn
Menu, MacroMenu, Add, %r_Lang001%`t%_s%Ctrl+R, Record
Menu, MacroMenu, Add, %r_Lang002%`t%_s%Ctrl+Enter, PlayStart
Menu, MacroMenu, Add, %r_Lang003%`t%_s%Ctrl+Shift+Enter, TestRun
Menu, MacroMenu, Add, %r_Lang004%`t%_s%Ctrl+Shift+T, RunTimer
Menu, MacroMenu, Add, %r_Lang005%`t%_s%Ctrl+T, TabPlus
Menu, MacroMenu, Add, %r_Lang006%`t%_s%Ctrl+W, TabClose
Menu, MacroMenu, Add, %r_Lang007%`t%_s%Ctrl+H, SetWin
Menu, MacroMenu, Add, %r_Lang008%`t%_s%Ctrl+B, OnScControls
Menu, MacroMenu, Add, %r_Lang009%`t%_s%Alt+1, PlayFrom
Menu, MacroMenu, Add, %r_Lang010%`t%_s%Alt+2, PlayTo
Menu, MacroMenu, Add, %r_Lang011%`t%_s%Alt+3, PlaySel
Menu, OptionsMenu, Add, %o_Lang001%`t%_s%Ctrl+G, Options
Menu, OptionsMenu, Add, %o_Lang002%, KeepDefKeys
Menu, OptionsMenu, Add, %o_Lang003%, DefaultMacro
Menu, OptionsMenu, Add, %o_Lang004%, RemoveDefault
Menu, OptionsMenu, Add, %o_Lang005%`t%_s%Alt+F5, SetColSizes
Menu, OptionsMenu, Add, %o_Lang006%`t%_s%Alt+F6, DefaultHotkeys
Menu, OptionsMenu, Add, %o_Lang007%`t%_s%Alt+F7, LoadDefaults

Loop, Parse, Lang_All, |
{
	LangTxt := SubStr(A_LoopField, -1)
	If IsLabel("LoadLang_" LangTxt)
		Menu, LangMenu, Add, % Lang_%LangTxt%, LangChange
}

Menu, HelpMenu, Add, %m_Lang009%`t%_s%F1, Help
Menu, HelpMenu, Add, %h_Lang006%, ShowTips
Menu, HelpMenu, Add
Menu, HelpMenu, Add, %h_Lang001%, Homepage
Menu, HelpMenu, Add, %h_Lang007%, Forum
Menu, HelpMenu, Add, %h_Lang002%, HelpAHK
Menu, HelpMenu, Add
Menu, HelpMenu, Add, %h_Lang003%, CheckNow
Menu, HelpMenu, Add, %h_Lang004%, AutoUpdate
Menu, HelpMenu, Add
Menu, HelpMenu, Add, %h_Lang005%`t%_s%Shift+F1, HelpAbout

Loop, Parse, Start_Tips, `n
{
	StartTip_%A_Index% := A_LoopField
	MaxTips := A_Index
}

Menu, DonationMenu, Add, %p_Lang001%, DonatePayPal

Menu, MenuBar, Add, %m_Lang001%, :FileMenu
Menu, MenuBar, Add, %m_Lang002%, :InsertMenu
Menu, MenuBar, Add, %m_Lang003%, :SelectMenu
Menu, MenuBar, Add, %m_Lang004%, :EditMenu
Menu, MenuBar, Add, %m_Lang005%, :MacroMenu
Menu, MenuBar, Add, %m_Lang006%, :OptionsMenu
Menu, MenuBar, Add, %m_Lang007%, :LangMenu
Menu, MenuBar, Add, %m_Lang008%, :DonationMenu
Menu, MenuBar, Add, %m_Lang009%, :HelpMenu

Gui, Menu, MenuBar

Menu, ToolbarMenu, Add, %c_Lang022%, OSCClose
Menu, ToolbarMenu, Add, %t_Lang104%, ToggleTB
Menu, ToolbarMenu, Add, %t_Lang105%, ShowHide

Menu, Tray, Add, %w_Lang005%, PlayStart
Menu, Tray, Add, %w_Lang008%, f_AbortKey
Menu, Tray, Add, %w_Lang004%, Record
Menu, Tray, Add, %r_Lang004%, RunTimer
Menu, Tray, Add
Menu, Tray, Add, %w_Lang002%, Preview
Menu, Tray, Add, %f_Lang010%, ListVars
Menu, Tray, Add, %y_Lang003%, OnScControls
Menu, Tray, Add, %w_Lang014%, CheckHkOn
Menu, Tray, Add
Menu, Tray, Add, %f_Lang001%, New
Menu, Tray, Add, %f_Lang002%, Open
Menu, Tray, Add, %f_Lang003%, Save
Menu, Tray, Add, %w_Lang003%, Options
Menu, Tray, Add
Menu, Tray, Add, %y_Lang001%, ShowHide
Menu, Tray, Add, %f_Lang011%, Exit
Menu, Tray, Default, %w_Lang005%

If KeepDefKeys
	Menu, OptionsMenu, Check, %o_Lang002%
If AutoUpdate
	Menu, HelpMenu, Check, %h_Lang004%

; Menu Icons
Try Menu, FileMenu, Icon, %f_Lang001%`t%_s%Ctrl+N, % NewIcon[1], % NewIcon[2]
Try Menu, FileMenu, Icon, %f_Lang002%`t%_s%Ctrl+O, % OpenIcon[1], % OpenIcon[2]
Try Menu, FileMenu, Icon, %f_Lang003%`t%_s%Ctrl+S, % SaveIcon[1], % SaveIcon[2]
Try Menu, FileMenu, Icon, %f_Lang004%`t%_s%Ctrl+Shift+S, % SaveIcon[1], % SaveIcon[2]
Try Menu, FileMenu, Icon, %f_Lang005%`t%_s%Ctrl+I, % ImportIcon[1], % ImportIcon[2]
Try Menu, FileMenu, Icon, %f_Lang006%`t%_s%Ctrl+Alt+S, % SaveLIcon[1], % SaveLIcon[2]
Try Menu, FileMenu, Icon, %f_Lang007%, % RecentIcon[1], % RecentIcon[2]
Try Menu, FileMenu, Icon, %f_Lang008%`t%_s%Ctrl+E, % ExportIcon[1], % ExportIcon[2]
Try Menu, FileMenu, Icon, %f_Lang009%`t%_s%Ctrl+P, % PreviewIcon[1], % PreviewIcon[2]
Try Menu, FileMenu, Icon, %f_Lang010%`t%_s%Alt+F3, % ListVarsIcon[1], % ListVarsIcon[2]
Try Menu, FileMenu, Icon, %f_Lang011%`t%_s%Alt+F4, % ExitIcon[1], % ExitIcon[2]
Try Menu, InsertMenu, Icon, %i_Lang001%`t%_s%F2, % LVIcons[2][1], % LVIcons[2][2] ; Mouse
Try Menu, InsertMenu, Icon, %i_Lang002%`t%_s%F3, % LVIcons[1][1], % LVIcons[1][2] ; Text
Try Menu, InsertMenu, Icon, %i_Lang003%`t%_s%F4, % LVIcons[9][1], % LVIcons[9][2] ; ControlCmd
Try Menu, InsertMenu, Icon, %i_Lang004%`t%_s%F5, % LVIcons[3][1], % LVIcons[3][2] ; Pause
Try Menu, InsertMenu, Icon, %i_Lang005%`t%_s%F6, % LVIcons[8][1], % LVIcons[8][2] ; Window
Try Menu, InsertMenu, Icon, %i_Lang006%`t%_s%F7, % LVIcons[7][1], % LVIcons[7][2] ; Image
Try Menu, InsertMenu, Icon, %i_Lang007%`t%_s%F8, % LVIcons[5][1], % LVIcons[5][2] ; Run
Try Menu, InsertMenu, Icon, %i_Lang008%`t%_s%F9, % LVIcons[4][1], % LVIcons[4][2] ; ComLoop
Try Menu, InsertMenu, Icon, %i_Lang009%`t%_s%F10, % LVIcons[6][1], % LVIcons[6][2] ; IfSt
Try Menu, InsertMenu, Icon, %i_Lang010%`t%_s%F11, % LVIcons[10][1], % LVIcons[10][2] ; IECom
Try Menu, InsertMenu, Icon, %i_Lang011%`t%_s%F12, % LVIcons[13][1], % LVIcons[13][2] ; SendMsg
Try Menu, InsertMenu, Icon, %i_Lang012%`t%_s%Shift+F3, % LVIcons[30][1], % LVIcons[30][2] ; Special
Try Menu, EditMenu, Icon, %m_Lang004%`t%_s%Enter, % EditIcon[1], % EditIcon[2]
Try Menu, EditMenu, Icon, %e_Lang001%`t%_s%Ctrl+D, % DuplicateIcon[1], % DuplicateIcon[2]
Try Menu, EditMenu, Icon, %e_Lang003%`t%_s%Ctrl+F, % FindIcon[1], % FindIcon[2]
Try Menu, EditMenu, Icon, %e_Lang002%`t%_s%Ctrl+L, % CommentIcon[1], % CommentIcon[2]
Try Menu, EditMenu, Icon, %e_Lang014%`t%_s%Ctrl+M, % ColorIcon[1], % ColorIcon[2]
Try Menu, EditMenu, Icon, %e_Lang005%`t%_s%Ctrl+Z, % UndoIcon[1], % UndoIcon[2]
Try Menu, EditMenu, Icon, %e_Lang006%`t%_s%Ctrl+Y, % RedoIcon[1], % RedoIcon[2]
Try Menu, EditMenu, Icon, %e_Lang007%`t%_s%Ctrl+X, % CutIcon[1], % CutIcon[2]
Try Menu, EditMenu, Icon, %e_Lang008%`t%_s%Ctrl+C, % CopyIcon[1], % CopyIcon[2]
Try Menu, EditMenu, Icon, %e_Lang009%`t%_s%Ctrl+V, % PasteIcon[1], % PasteIcon[2]
Try Menu, EditMenu, Icon, %e_Lang010%`t%_s%Delete, % RemoveIcon[1], % RemoveIcon[2]
Try Menu, EditMenu, Icon, %e_Lang013%`t%_s%Insert, % InsertIcon[1], % InsertIcon[2]
Try Menu, EditMenu, Icon, %e_Lang011%`t%_s%Ctrl+PgUp, % MoveUpIcon[1], % MoveUpIcon[2]
Try Menu, EditMenu, Icon, %e_Lang012%`t%_s%Ctrl+PgDn, % MoveDnIcon[1], % MoveDnIcon[2]
Try Menu, MacroMenu, Icon, %r_Lang001%`t%_s%Ctrl+R, % RecordIcon[1], % RecordIcon[2]
Try Menu, MacroMenu, Icon, %r_Lang002%`t%_s%Ctrl+Enter, % PlayIcon[1], % PlayIcon[2]
Try Menu, MacroMenu, Icon, %r_Lang003%`t%_s%Ctrl+Shift+Enter, % TestRunIcon[1], % TestRunIcon[2]
Try Menu, MacroMenu, Icon, %r_Lang004%`t%_s%Ctrl+Shift+T, % RunTimerIcon[1], % RunTimerIcon[2]
Try Menu, MacroMenu, Icon, %r_Lang005%`t%_s%Ctrl+T, % PlusIcon[1], % PlusIcon[2]
Try Menu, MacroMenu, Icon, %r_Lang006%`t%_s%Ctrl+W, % CloseIcon[1], % CloseIcon[2]
Try Menu, MacroMenu, Icon, %r_Lang007%`t%_s%Ctrl+H, % ContextIcon[1], % ContextIcon[2]
Try Menu, OptionsMenu, Icon, %o_Lang001%`t%_s%Ctrl+G, % OptionsIcon[1], % OptionsIcon[2]
Try Menu, HelpMenu, Icon, %m_Lang009%`t%_s%F1, % HelpIconB[1], % HelpIconB[2]
Try Menu, DonationMenu, Icon, %p_Lang001%, % DonateIcon[1], % DonateIcon[2]
Try Menu, Tray, Icon, %w_Lang005%, % PlayIcon[1], % PlayIcon[2]
Try Menu, Tray, Icon, %w_Lang008%, % RecStopIcon[1], % RecStopIcon[2]
Try Menu, Tray, Icon, %w_Lang004%, % RecordIcon[1], % RecordIcon[2]
Try Menu, Tray, Icon, %r_Lang004%, % RunTimerIcon[1], % RunTimerIcon[2]
Try Menu, Tray, Icon, %w_Lang002%, % PreviewIcon[1], % PreviewIcon[2]
Try Menu, Tray, Icon, %f_Lang010%, % ListVarsIcon[1], % ListVarsIcon[2]
Try Menu, Tray, Icon, %f_Lang001%, % NewIcon[1], % NewIcon[2]
Try Menu, Tray, Icon, %f_Lang002%, % OpenIcon[1], % OpenIcon[2]
Try Menu, Tray, Icon, %f_Lang003%, % SaveIcon[1], % SaveIcon[2]
Try Menu, Tray, Icon, %w_Lang003%, % OptionsIcon[1], % OptionsIcon[2]
Try Menu, Tray, Icon, %f_Lang011%, % ExitIcon[1], % ExitIcon[2]
return

; Playback / Recording options menu:

ShowRecMenu:
Menu, RecOptMenu, Add, %d_Lang019%, RecOpt
Menu, RecOptMenu, Add, %t_Lang021%, RecOpt
Menu, RecOptMenu, Add, %t_Lang023%, RecOpt
Menu, RecOptMenu, Add, %t_Lang024%, RecOpt
Menu, RecOptMenu, Add, %t_Lang025%, RecOpt
Menu, RecOptMenu, Add, %t_Lang026%, RecOpt
Menu, RecOptMenu, Add, %t_Lang027%, RecOpt
Menu, RecOptMenu, Add, %t_Lang029%, RecOpt
Menu, RecOptMenu, Add, %t_Lang030%, RecOpt
Menu, RecOptMenu, Add, %t_Lang032%, RecOpt
Menu, RecOptMenu, Add, %t_Lang031%, RecOpt

If (ClearNewList)
	Menu, RecOptMenu, Check, %d_Lang019%
If (Strokes)
	Menu, RecOptMenu, Check, %t_Lang021%
If (CaptKDn)
	Menu, RecOptMenu, Check, %t_Lang023%
If (Mouse)
	Menu, RecOptMenu, Check, %t_Lang024%
If (MScroll)
	Menu, RecOptMenu, Check, %t_Lang025%
If (Moves)
	Menu, RecOptMenu, Check, %t_Lang026%
If (TimedI)
	Menu, RecOptMenu, Check, %t_Lang027%
If (WClass)
	Menu, RecOptMenu, Check, %t_Lang029%
If (WTitle)
	Menu, RecOptMenu, Check, %t_Lang030%
If (RecMouseCtrl)
	Menu, RecOptMenu, Check, %t_Lang032%
If (RecKeybdCtrl)
	Menu, RecOptMenu, Check, %t_Lang031%

Menu, RecOptMenu, Show
Menu, RecOptMenu, DeleteAll
return

RecOpt:
ItemVar := RecOptChecks[A_ThisMenuItemPos], %ItemVar% := !%ItemVar%
return

ShowPlayMenu:
Menu, SpeedUpMenu, Add, 2x, SpeedOpt
Menu, SpeedUpMenu, Add, 4x, SpeedOpt
Menu, SpeedUpMenu, Add, 8x, SpeedOpt
Menu, SpeedUpMenu, Add, 16x, SpeedOpt
Menu, SpeedUpMenu, Add, 32x, SpeedOpt
Menu, SpeedDnMenu, Add, 2x, SpeedOpt
Menu, SpeedDnMenu, Add, 4x, SpeedOpt
Menu, SpeedDnMenu, Add, 8x, SpeedOpt
Menu, SpeedDnMenu, Add, 16x, SpeedOpt
Menu, SpeedDnMenu, Add, 32x, SpeedOpt
Menu, PlayOptMenu, Add, %r_Lang009%, PlayFrom
Menu, PlayOptMenu, Add, %r_Lang010%, PlayTo
Menu, PlayOptMenu, Add, %r_Lang011%, PlaySel
Menu, PlayOptMenu, Add, %t_Lang038%, PlayOpt
Menu, PlayOptMenu, Add, %t_Lang107%, RandOpt
Menu, PlayOptMenu, Add, %t_Lang036%, :SpeedUpMenu
Menu, PlayOptMenu, Add, %t_Lang037%, :SpeedDnMenu

If (pb_From)
	Menu, PlayOptMenu, Check, %r_Lang009%
If (pb_To)
	Menu, PlayOptMenu, Check, %r_Lang010%
If (pb_Sel)
	Menu, PlayOptMenu, Check, %r_Lang011%
If (MouseReturn)
	Menu, PlayOptMenu, Check, %t_Lang038%
If (RandomSleeps)
	Menu, PlayOptMenu, Check, %t_Lang107%
Menu, SpeedUpMenu, Check, %SpeedUp%x
Menu, SpeedDnMenu, Check, %SpeedDn%x

Menu, PlayOptMenu, Show
Menu, PlayOptMenu, DeleteAll
Menu, SpeedUpMenu, DeleteAll
Menu, SpeedDnMenu, DeleteAll
return

RandOpt:
RandomSleeps := !RandomSleeps
return

PlayOpt:
MouseReturn := !MouseReturn
return

SpeedOpt:
ItemVar := SubStr(A_ThisMenu, 1, 7), %ItemVar% := RegExReplace(A_ThisMenuItem, "\D")
return

OnFinish:
GuiControl,, OnFinish, %OnFinish%
Menu, FinishOptMenu, Add, %w_Lang021%, FinishOpt
Menu, FinishOptMenu, Add, %w_Lang022%, FinishOpt
Menu, FinishOptMenu, Add, %w_Lang023%, FinishOpt
Menu, FinishOptMenu, Add, %w_Lang024%, FinishOpt
Menu, FinishOptMenu, Add, %w_Lang025%, FinishOpt
Menu, FinishOptMenu, Add, %w_Lang026%, FinishOpt
Menu, FinishOptMenu, Add, %w_Lang027%, FinishOpt
Menu, FinishOptMenu, Add, %w_Lang028%, FinishOpt
Menu, FinishOptMenu, Add, %w_Lang029%, FinishOpt

Menu, FinishOptMenu, Check, % w_Lang02%OnFinishCode%

Menu, FinishOptMenu, Show
Menu, FinishOptMenu, DeleteAll
return

FinishOpt:
OnFinishCode := A_ThisMenuItemPos
SetFinishButtom:
If (OnFinishCode = 1)
	GuiControl,, OnFinish, 0
Else
	GuiControl,, OnFinish, 1
Gui, Submit, NoHide
return

;##### Languages: #####

LangChange:
Loop, Parse, Lang_All, |
{
	If InStr(A_LoopField, A_ThisMenuItem)=1
		Lang := SubStr(A_LoopField, -1)
}
If (Lang = CurrentLang)
	return
If !IsLabel("LoadLang_" Lang)
	return
Gui, Menu
Menu, MenuBar, DeleteAll
Menu, FileMenu, DeleteAll
Menu, InsertMenu, DeleteAll
Menu, SelectMenu, DeleteAll
Menu, SelCmdMenu, DeleteAll
Menu, EditMenu, DeleteAll
Menu, MacroMenu, DeleteAll
Menu, OptionsMenu, DeleteAll
Menu, DonationMenu, DeleteAll
Menu, LangMenu, DeleteAll
Menu, HelpMenu, DeleteAll
Menu, ToolbarMenu, DeleteAll
Menu, Tray, DeleteAll
GoSub, LoadLang
GoSub, CreateMenuBar
Menu, LangMenu, Uncheck, % Lang_%CurrentLang%
Menu, LangMenu, Check, % Lang_%Lang%
CurrentLang := Lang

GuiControl,, ExportB, %w_Lang001%
GuiControl,, PreviewB, %w_Lang002%
GuiControl,, OptionsB, %w_Lang003%
GuiControl,, AutoT, %w_Lang006%:
GuiControl,, ManT, %w_Lang007%:
GuiControl,, AbortT, %w_Lang008%:
GuiControl,, RecordB, %w_Lang004%
GuiControl,, StartB, %w_Lang005%
GuiControl,, RepeatT, %w_Lang011% (%t_Lang004%):
GuiControl,, Capt, %w_Lang012%
GuiControl,, OnScCtrl, %w_Lang009%
GuiControl,, HideMainWin, %w_Lang013%
GuiControl,, KeepHkOn, %w_Lang014%
GuiControl,, Repeat, %w_Lang015%:
Gui 2:+LastFoundExist
IfWinExist
    GoSub, Preview
Gui 18:+LastFoundExist
IfWinExist
    GoSub, FindReplace
return

LoadLang:
If IsLabel("LoadLang_" Lang)
	GoSub, LoadLang_%Lang%
Else
{
	Lang = En
	GoSub, LoadLang_En
}
return

#Include <Hotkeys>
#Include <Internal>
#Include <Recording>
#Include <Playback>
#Include <Export>
#Include <Class_PMC>
#Include <Class_LV_Rows>
#Include <Class_ObjIni>
#Include <Gdip>
#Include <Eval>
#Include <Class_LV_Colors>
#SingleInstance Off

#Include Lang\En.lang
#Include *i Lang\Pt.lang
#Include *i Lang\Ca.lang
#Include *i Lang\Da.lang
#Include *i Lang\De.lang
#Include *i Lang\Es.lang
#Include *i Lang\Fr.lang
#Include *i Lang\It.lang
#Include *i Lang\Hr.lang
#Include *i Lang\Hu.lang
#Include *i Lang\Nl.lang
#Include *i Lang\No.lang
#Include *i Lang\Pl.lang
#Include *i Lang\Fi.lang
#Include *i Lang\Sv.lang
#Include *i Lang\Tr.lang
#Include *i Lang\Cs.lang
#Include *i Lang\El.lang
#Include *i Lang\Ru.lang
#Include *i Lang\Bg.lang
#Include *i Lang\Sr.lang
#Include *i Lang\Uk.lang
#Include *i Lang\Zh.lang
#Include *i Lang\Zt.lang
#Include *i Lang\Ja.lang
#Include *i Lang\Ko.lang
