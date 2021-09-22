; *****************************
; :: PULOVER'S MACRO CREATOR ::
; *****************************
; "The Complete Automation Tool"
; Author: Pulover [Rodolfo U. Batista]
; Home: https://www.macrocreator.com
; Forum: https://www.autohotkey.com/boards/viewforum.php?f=63
; Version: 5.4.1
; Release Date: September, 2021
; AutoHotkey Version: 1.1.33.09
; Copyright © 2012-2021 Cloversoft Serviços de Informática Ltda
; I specifically grant Michael Wong (user guest3456 on AHK forums) use of this code
; under the terms of the UNLICENSE here: <https://unlicense.org/UNLICENSE>
; For everyone else, the GPL below applies.
; GNU General Public License 3.0 or higher
; <https://www.gnu.org/licenses/gpl-3.0.txt>

/*
Thanks to:

tic (Tariq Porter) for his GDI+ Library.
https://www.autohotkey.com/boards/viewtopic.php?t=6517

tkoi & majkinetor for the Graphic Buttons function.
http://www.autohotkey.com/board/topic/37147-ilbutton-image-buttons

just me for LV_Colors Class, LV_EX/IL_EX libraries and for updating ILButton to 64bit.
https://www.autohotkey.com/boards/viewtopic.php?f=6&t=1081
https://www.autohotkey.com/boards/viewtopic.php?t=1256
https://www.autohotkey.com/boards/viewtopic.php?f=6&t=1273

Micahs for the base code of the Drag-Rows function.
http://www.autohotkey.com/board/topic/30486-listview-tooltip-on-mouse-hover/?p=280843

jaco0646 for the function to make hotkey controls detect other keys.
http://www.autohotkey.com/board/topic/47439-user-defined-dynamic-hotkeys

Uberi for the ExprEval function to solve expressions.
http://autohotkey.com/board/topic/64167-expreval-evaluate-expressions

Jethrow for the IEGet & WBGet Functions.
http://www.autohotkey.com/board/topic/47052-basic-webpage-controls

RaptorX for the Scintilla Wrapper for AHK
http://www.autohotkey.com/board/topic/85928-wrapper-scintilla-wrapper

majkinetor for the Dlg_Color function.
http://www.autohotkey.com/board/topic/49214-ahk-ahk-l-forms-framework-08

rbrtryn for the ChooseColor function.
http://www.autohotkey.com/board/topic/91229-windows-color-picker-plus

PhiLho and skwire for the function to Get/Set the order of columns.
http://www.autohotkey.com/board/topic/11926-can-you-move-a-listview-column-programmatically/#entry237340

fincs for GenDocs and SciLexer.dll custom builds.
http://www.autohotkey.com/board/topic/71751-gendocs-v30-alpha002
http://www.autohotkey.com/board/topic/54431-scite4autohotkey-v3004-updated-aug-14-2013/page-58#entry566139

tmplinshi for the CreateFormData function.
https://www.autohotkey.com/boards/viewtopic.php?f=6&t=7647

iseahound (Edison Hua) for the Vis2 function used for OCR.
https://www.autohotkey.com/boards/viewtopic.php?f=6&t=36047

Coco for JSON class.
https://www.autohotkey.com/boards/viewtopic.php?f=6&t=627

Thiago Talma for some improvements to the code, debugging and many suggestions.

chosen1ft for suggestions and testing.

Translation revisions:
https://www.macrocreator.com/project/
*/

; Compiler Settings
;@Ahk2Exe-SetName Pulover's Macro Creator
;@Ahk2Exe-SetDescription Pulover's Macro Creator
;@Ahk2Exe-SetVersion 5.4.1
;@Ahk2Exe-SetCopyright Copyright © 2012-2021 Cloversoft Serviços de Informática Ltda
;@Ahk2Exe-SetOrigFilename MacroCreator.exe

; AutoHotkey settings:
#NoEnv
ListLines Off
#InstallKeybdHook
#MaxThreadsBuffer On
#MaxHotkeysPerInterval 999999999
#HotkeyInterval 9999999999
SetWorkingDir %A_ScriptDir%
SendMode, Input
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
CoordMode, Menu, Window
CoordMode, Tooltip, Window

; Tray menu:
Menu, Tray, Tip, Pulovers's Macro Creator
DefaultIcon := (A_IsCompiled) ? A_ScriptFullPath
			:  (FileExist(A_ScriptDir "\Resources\PMC4_Mult.ico") ? A_ScriptDir "\Resources\PMC4_Mult.ico" : A_AhkPath)
Menu, Tray, Icon, %DefaultIcon%, 1, 1

; Loading SciLexer DLL:
SciDllPath := (A_IsCompiled) ? (A_ScriptDir "\SciLexer.dll")
			: (A_ScriptDir ((A_PtrSize = 8) ? "\SciLexer-x64.dll" : "\SciLexer-x86.dll"))
DllCall("LoadLibrary", "Str", SciDllPath)

IfNotExist, %SciDllPath%
{
	MsgBox, 16, Error, A required DLL is missing. Please reinstall the application.
	ExitApp
}

; Loading Icons DLL:
ResDllPath := A_ScriptDir "\Resources.dll", hIL_Icons := IL_Create(10, 10)
hIL_IconsHi := IL_Create(10, 10)
IL_EX_SetSize(hIL_IconsHi, 24, 24)

IfNotExist, %ResDllPath%
{
	MsgBox, 16, Error, A required DLL is missing. Please reinstall the application.
	ExitApp
}

; Loading Icons:
Loop
{
	If (!IL_Add(hIL_Icons, ResDllPath, A_Index) && (A_Index > 1))
		break
}

Loop
{
	If (!IL_Add(hIL_IconsHi, ResDllPath, A_Index) && (A_Index > 1))
		break
}

CurrentVersion := "5.4.1", ReleaseDate := "September, 2021"

;##### Ini File Read #####

If (!FileExist(A_ScriptDir "\MacroCreator.ini") && !InStr(FileExist(A_AppData "\MacroCreator"), "D"))
	FileCreateDir, %A_AppData%\MacroCreator

SettingsFolder := FileExist(A_ScriptDir "\MacroCreator.ini") ? A_ScriptDir : A_AppData "\MacroCreator"
IniFilePath := SettingsFolder "\MacroCreator.ini"
UserVarsPath := SettingsFolder "\UserGlobalVars.ini"
UserAccountsPath := SettingsFolder "\UserEmailAccounts.ini"

IniRead, Version, %IniFilePath%, Application, Version
IniRead, Lang, %IniFilePath%, Language, Lang
IniRead, LangVersion, %IniFilePath%, Language, LangVersion, 2
IniRead, LangLastCheck, %IniFilePath%, Language, LangLastCheck, 2
IniRead, AutoKey, %IniFilePath%, HotKeys, AutoKey, F3|F4|F5|F6|F7
IniRead, ManKey, %IniFilePath%, HotKeys, ManKey, |
IniRead, AbortKey, %IniFilePath%, HotKeys, AbortKey, F8
IniRead, PauseKey, %IniFilePath%, HotKeys, PauseKey, F12
IniRead, RecKey, %IniFilePath%, HotKeys, RecKey, F9
IniRead, RecNewKey, %IniFilePath%, HotKeys, RecNewKey, F10
IniRead, RelKey, %IniFilePath%, HotKeys, RelKey, CapsLock
IniRead, FastKey, %IniFilePath%, HotKeys, FastKey, Insert
IniRead, SlowKey, %IniFilePath%, HotKeys, SlowKey, Pause
IniRead, ClearNewList, %IniFilePath%, Options, ClearNewList, 0
IniRead, DelayG, %IniFilePath%, Options, DelayG, 0
IniRead, OnScCtrl, %IniFilePath%, Options, OnScCtrl, 1
IniRead, ShowStep, %IniFilePath%, Options, ShowStep, 1
IniRead, HideMainWin, %IniFilePath%, Options, HideMainWin, 0
IniRead, DontShowAdm, %IniFilePath%, Options, DontShowAdm, 0
IniRead, DontShowPb, %IniFilePath%, Options, DontShowPb, 0
IniRead, DontShowRec, %IniFilePath%, Options, DontShowRec, 0
IniRead, DontShowEdt, %IniFilePath%, Options, DontShowEdt, 0
IniRead, ConfirmDelete, %IniFilePath%, Options, ConfirmDelete, 1
IniRead, ShowTips, %IniFilePath%, Options, ShowTips, 1
IniRead, NextTip, %IniFilePath%, Options, NextTip, 1
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
IniRead, TitleMatch, %IniFilePath%, Options, TitleMatch, 2
IniRead, TitleSpeed, %IniFilePath%, Options, TitleSpeed, Fast
IniRead, KeyMode, %IniFilePath%, Options, KeyMode, Input
IniRead, KeyDelay, %IniFilePath%, Options, KeyDelay, -1
IniRead, MouseDelay, %IniFilePath%, Options, MouseDelay, -1
IniRead, ControlDelay, %IniFilePath%, Options, ControlDelay, 1
IniRead, HiddenWin, %IniFilePath%, Options, HiddenWin, 0
IniRead, HiddenText, %IniFilePath%, Options, HiddenText, 1
IniRead, SpeedUp, %IniFilePath%, Options, SpeedUp, 2
IniRead, SpeedDn, %IniFilePath%, Options, SpeedDn, 2
IniRead, HideErrors, %IniFilePath%, Options, HideErrors, 0
IniRead, MouseReturn, %IniFilePath%, Options, MouseReturn, 0
IniRead, ShowProgBar, %IniFilePath%, Options, ShowProgBar, 1
IniRead, ShowBarOnStart, %IniFilePath%, Options, ShowBarOnStart, 0
IniRead, AutoHideBar, %IniFilePath%, Options, AutoHideBar, 0
IniRead, RandomSleeps, %IniFilePath%, Options, RandomSleeps, 0
IniRead, RandPercent, %IniFilePath%, Options, RandPercent, 50
IniRead, DrawButton, %IniFilePath%, Options, DrawButton, RButton
IniRead, OnRelease, %IniFilePath%, Options, OnRelease, 1
IniRead, OnEnter, %IniFilePath%, Options, OnEnter, 0
IniRead, LineW, %IniFilePath%, Options, LineW, 2
IniRead, ScreenDir, %IniFilePath%, Options, ScreenDir, %SettingsFolder%\Screenshots
IniRead, GetWinTitle, %IniFilePath%, Options, GetWinTitle, 1,0,0,0,0
IniRead, DefaultEditor, %IniFilePath%, Options, DefaultEditor
IniRead, DefaultMacro, %IniFilePath%, Options, DefaultMacro, %A_Space%
IniRead, StdLibFile, %IniFilePath%, Options, StdLibFile, %A_Space%
IniRead, KeepDefKeys, %IniFilePath%, Options, KeepDefKeys, 0
IniRead, TbNoTheme, %IniFilePath%, Options, TbNoTheme, 0
IniRead, AutoBackup, %IniFilePath%, Options, AutoBackup, 1
IniRead, MultInst, %IniFilePath%, Options, MultInst, 0
IniRead, EvalDefault, %IniFilePath%, Options, EvalDefault, 1
IniRead, CloseAction, %IniFilePath%, Options, CloseAction, %A_Space%
IniRead, ShowLoopIfMark, %IniFilePath%, Options, ShowLoopIfMark, 1
IniRead, ShowActIdent, %IniFilePath%, Options, ShowActIdent, 1
IniRead, SearchAreaColor, %IniFilePath%, Options, SearchAreaColor, 0xFF0000
IniRead, LoopLVColor, %IniFilePath%, Options, LoopLVColor, 0xFFFF80
IniRead, IfLVColor, %IniFilePath%, Options, IfLVColor, 0x0080FF
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
IniRead, Ex_SP, %IniFilePath%, ExportOptions, Ex_SP, 0
IniRead, Ex_CM, %IniFilePath%, ExportOptions, Ex_CM, 1
IniRead, Ex_DH, %IniFilePath%, ExportOptions, Ex_DH, 0
IniRead, Ex_DT, %IniFilePath%, ExportOptions, Ex_DT, 0
IniRead, Ex_AF, %IniFilePath%, ExportOptions, Ex_AF, 1
IniRead, Ex_HK, %IniFilePath%, ExportOptions, Ex_HK, 0
IniRead, Ex_PT, %IniFilePath%, ExportOptions, Ex_PT, 0
IniRead, Ex_NT, %IniFilePath%, ExportOptions, Ex_NT, 0
IniRead, Ex_WN, %IniFilePath%, ExportOptions, Ex_WN, 0
IniRead, Ex_SC, %IniFilePath%, ExportOptions, Ex_SC, 1
IniRead, Ex_SW, %IniFilePath%, ExportOptions, Ex_SW, 1
IniRead, SW, %IniFilePath%, ExportOptions, SW, 0
IniRead, Ex_SK, %IniFilePath%, ExportOptions, Ex_SK, 1
IniRead, Ex_MD, %IniFilePath%, ExportOptions, Ex_MD, 1
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
IniRead, IndentWith, %IniFilePath%, ExportOptions, IndentWith, Space
IniRead, ConvertBreaks, %IniFilePath%, ExportOptions, ConvertBreaks, 1
IniRead, ShowGroupNames, %IniFilePath%, ExportOptions, ShowGroupNames, 0
IniRead, IncPmc, %IniFilePath%, ExportOptions, IncPmc, 0
IniRead, Exe_Exp, %IniFilePath%, ExportOptions, Exe_Exp, 0
IniRead, MainWinSize, %IniFilePath%, WindowOptions, MainWinSize, W930 H630
IniRead, MainWinPos, %IniFilePath%, WindowOptions, MainWinPos, Center
IniRead, WinState, %IniFilePath%, WindowOptions, WinState, 1
IniRead, ColSizes, %IniFilePath%, WindowOptions, ColSizes, 70,185,335,60,60,100,150,225,85,50,60
IniRead, ColOrder, %IniFilePath%, WindowOptions, ColOrder, 1,2,3,4,5,6,7,8,9,10,11
IniRead, PrevWinSize, %IniFilePath%, WindowOptions, PrevWinSize, W450 H500
IniRead, ShowPrev, %IniFilePath%, WindowOptions, ShowPrev, 1
IniRead, TextWrap, %IniFilePath%, WindowOptions, TextWrap, 0
IniRead, MacroFontSize, %IniFilePath%, WindowOptions, MacroFontSize, 8
IniRead, PrevFontSize, %IniFilePath%, WindowOptions, PrevFontSize, 8
IniRead, CommentUnchecked, %IniFilePath%, WindowOptions, CommentUnchecked, 1
IniRead, CustomColors, %IniFilePath%, WindowOptions, CustomColors, 0
IniRead, OSCPos, %IniFilePath%, WindowOptions, OSCPos, X0 Y0
IniRead, OSTrans, %IniFilePath%, WindowOptions, OSTrans, 255
IniRead, OSCaption, %IniFilePath%, WindowOptions, OSCaption, 0
IniRead, AutoRefresh, %IniFilePath%, WindowOptions, AutoRefresh, 1
IniRead, AutoSelectLine, %IniFilePath%, WindowOptions, AutoSelectLine, 1
IniRead, ShowGroups, %IniFilePath%, WindowOptions, ShowGroups, 0
IniRead, BarInfo, %IniFilePath%, WindowOptions, BarInfo, 1
IniRead, IconSize, %IniFilePath%, ToolbarOptions, IconSize, Large
IniRead, UserLayout, %IniFilePath%, ToolbarOptions, UserLayout
IniRead, MainLayout, %IniFilePath%, ToolbarOptions, MainLayout
IniRead, MacroLayout, %IniFilePath%, ToolbarOptions, MacroLayout
IniRead, FileLayout, %IniFilePath%, ToolbarOptions, FileLayout
IniRead, RecPlayLayout, %IniFilePath%, ToolbarOptions, RecPlayLayout
IniRead, SettingsLayout, %IniFilePath%, ToolbarOptions, SettingsLayout
IniRead, CommandLayout, %IniFilePath%, ToolbarOptions, CommandLayout
IniRead, EditLayout, %IniFilePath%, ToolbarOptions, EditLayout
IniRead, ShowBands, %IniFilePath%, ToolbarOptions, ShowBands, 1,1,1,1,1,1,1,1,1,1,1

If (Version < "5.1.2")
	EvalDefault := 1
If (Version < "5.0.0")
	ShowTips := 1, NextTip := 1, MainLayout := "ERROR", UserLayout := "ERROR"
If (LangVersion < 9)
	LangVersion := 9, LangLastCheck := 9

User_Vars := new ObjIni(UserVarsPath)
User_Vars.Read()
UserVars := User_Vars.Get(true)
For _each, _Section in UserVars
	For _key, _value in _Section
		Try SavedVars(_key)

UserMailAccounts := new ObjIni(UserAccountsPath)
IfDirectContext := "None"

If (DefaultEditor = "ERROR")
{
	SplitPath, A_AhkPath,, AhkDir
	ProgramsFolder := (A_PtrSize = 8) ? ProgramFiles " (x86)" : ProgramFiles
	If (FileExist(AhkDir "\SciTE\SciTE.exe"))
		DefaultEditor := AhkDir "\SciTE\SciTE.exe"
	Else If (FileExist(ProgramsFolder "\Notepad++\notepad++.exe"))
		DefaultEditor := ProgramsFolder "\Notepad++\notepad++.exe"
	Else If (FileExist(ProgramFiles "\Sublime Text 2\sublime_text.exe"))
		DefaultEditor := ProgramFiles "\Sublime Text 2\sublime_text.exe"
	Else If (FileExist(ProgramsFolder "\Notepad2\Notepad2.exe"))
		DefaultEditor := ProgramsFolder "\Notepad2\Notepad2.exe"
	Else
		DefaultEditor := "notepad.exe"
}

If (IconSize = "ERROR")
	IconSize := "Large"

hIL := (IconSize = "Large") ? hIL_IconsHi : hIL_Icons

LangInfo := "
(Join`n
0036	af	Afrikaans	Afrikaans	Afrikaans
0436	af_ZA	Afrikaans (South Africa)	Afrikaans	Afrikaans (Suid Afrika)
001C	sq	Albanian	Albanian	Shqipe
041C	sq_AL	Albanian (Albania)	Albanian	Shqipe (Shqipëria)
0484	gsw_FR	Alsatian (France)	Alsatian	Elsässisch (Frànkrisch)
045E	am_ET	Amharic (Ethiopia)	Amharic	አማርኛ (ኢትዮጵያ)
0001	ar	Arabic‎	Arabic	العربية‏
1401	ar_DZ	Arabic (Algeria)‎	Arabic	العربية (الجزائر)‏
3C01	ar_BH	Arabic (Bahrain)‎	Arabic	العربية (البحرين)‏
0C01	ar_EG	Arabic (Egypt)‎	Arabic	العربية (مصر)‏
0801	ar_IQ	Arabic (Iraq)‎	Arabic	العربية (العراق)‏
2C01	ar_JO	Arabic (Jordan)‎	Arabic	العربية (الأردن)‏
3401	ar_KW	Arabic (Kuwait)‎	Arabic	العربية (الكويت)‏
3001	ar_LB	Arabic (Lebanon)‎	Arabic	العربية (لبنان)‏
1001	ar_LY	Arabic (Libya)‎	Arabic	العربية (ليبيا)‏
1801	ar_MA	Arabic (Morocco)‎	Arabic	العربية (المملكة المغربية)‏
2001	ar_OM	Arabic (Oman)‎	Arabic	العربية (عمان)‏
4001	ar_QA	Arabic (Qatar)‎	Arabic	العربية (قطر)‏
0401	ar_SA	Arabic (Saudi Arabia)‎	Arabic	العربية (المملكة العربية السعودية)‏
2801	ar_SY	Arabic (Syria)‎	Arabic	العربية (سوريا)‏
1C01	ar_TN	Arabic (Tunisia)‎	Arabic	العربية (تونس)‏
3801	ar_AE	Arabic (U.A.E.)‎	Arabic	العربية (الإمارات العربية المتحدة)‏
2401	ar_YE	Arabic (Yemen)‎	Arabic	العربية (اليمن)‏
002B	hy	Armenian	Armenian	Հայերեն
042B	hy_AM	Armenian (Armenia)	Armenian	Հայերեն (Հայաստան)
044D	as_IN	Assamese (India)	Assamese	অসমীয়া (ভাৰত)
002C	az	Azeri	Azeri (Latin)	Azərbaycan­ılı
082C	az_Cyrl_AZ	Azeri (Cyrillic, Azerbaijan)	Azeri (Cyrillic)	Азәрбајҹан (Азәрбајҹан)
042C	az_Latn_AZ	Azeri (Latin, Azerbaijan)	Azeri (Latin)	Azərbaycan­ılı (Azərbaycanca)
046D	ba_RU	Bashkir (Russia)	Bashkir	Башҡорт (Россия)
002D	eu	Basque	Basque	Euskara
042D	eu_ES	Basque (Basque)	Basque	Euskara (euskara)
0023	be	Belarusian	Belarusian	Беларускі
0423	be_BY	Belarusian (Belarus)	Belarusian	Беларускі (Беларусь)
0845	bn_BD	Bengali (Bangladesh)	Bengali	বাংলা (বাংলা)
0445	bn_IN	Bengali (India)	Bengali	বাংলা (ভারত)
201A	bs_Cyrl_BA	Bosnian (Cyrillic, Bosnia and Herzegovina)	Bosnian (Cyrillic)	Босански (Босна и Херцеговина)
141A	bs_Latn_BA	Bosnian (Latin, Bosnia and Herzegovina)	Bosnian (Latin)	Bosanski (Bosna i Hercegovina)
047E	br_FR	Breton (France)	Breton	Brezhoneg (Frañs)
0002	bg	Bulgarian	Bulgarian	Български
0402	bg_BG	Bulgarian (Bulgaria)	Bulgarian	Български (България)
0003	ca	Catalan	Catalan	Català
0403	ca_ES	Catalan (Catalan)	Catalan	Català (català)
0C04	zh_HK	Chinese (Hong Kong S.A.R.)	Chinese	中文(香港特别行政區)
1404	zh_MO	Chinese (Macao S.A.R.)	Chinese	中文(澳門特别行政區)
0804	zh_CN	Chinese (Simplified)	Chinese	中文(简体)
0004	zh_Hans	Chinese (Simplified)	Chinese	中文(简体)
1004	zh_SG	Chinese (Singapore)	Chinese	中文(新加坡)
0404	zh_TW	Chinese (Traditional)	Chinese	中文(繁體)
7C04	zh_Hant	Chinese (Traditional)	Chinese	中文(繁體)
0483	co_FR	Corsican (France)	Corsican	Corsu (France)
001A	hr	Croatian	Croatian	Hrvatski
041A	hr_HR	Croatian (Croatia)	Croatian	Hrvatski (Hrvatska)
101A	hr_BA	Croatian (Latin, Bosnia and Herzegovina)	Croatian (Latin)	Hrvatski (Bosna i Hercegovina)
0005	cs	Czech	Czech	Čeština
0405	cs_CZ	Czech (Czech Republic)	Czech	Čeština (Česká republika)
0006	da	Danish	Danish	Dansk
0406	da_DK	Danish (Denmark)	Danish	Dansk (Danmark)
048C	prs_AF	Dari (Afghanistan)	Dari	درى (افغانستان)
0065	div	Divehi‎	Divehi	ދިވެހިބަސް‏
0465	div_MV	Divehi (Maldives)‎	Divehi	ދިވެހިބަސް (ދިވެހި ރާއްޖެ)‏
0013	nl	Dutch	Dutch	Nederlands
0813	nl_BE	Dutch (Belgium)	Dutch	Nederlands (België)
0413	nl_NL	Dutch (Netherlands)	Dutch	Nederlands (Nederland)
0009	en	English	English	English
0C09	en_AU	English (Australia)	English	English (Australia)
2809	en_BZ	English (Belize)	English	English (Belize)
1009	en_CA	English (Canada)	English	English (Canada)
2409	en_029	English (Caribbean)	English	English (Caribbean)
4009	en_IN	English (India)	English	English (India)
1809	en_IE	English (Ireland)	English	English (Eire)
2009	en_JM	English (Jamaica)	English	English (Jamaica)
4409	en_MY	English (Malaysia)	English	English (Malaysia)
1409	en_NZ	English (New Zealand)	English	English (New Zealand)
3409	en_PH	English (Republic of the Philippines)	English	English (Philippines)
4809	en_SG	English (Singapore)	English	English (Singapore)
1C09	en_ZA	English (South Africa)	English	English (South Africa)
2C09	en_TT	English (Trinidad and Tobago)	English	English (Trinidad y Tobago)
0809	en_GB	English (United Kingdom)	English	English (United Kingdom)
0409	en_US	English (United States)	English	English (United States)
3009	en_ZW	English (Zimbabwe)	English	English (Zimbabwe)
0025	et	Estonian	Estonian	Eesti
0425	et_EE	Estonian (Estonia)	Estonian	Eesti (Eesti)
0038	fo	Faroese	Faroese	Føroyskt
0438	fo_FO	Faroese (Faroe Islands)	Faroese	Føroyskt (Føroyar)
0464	fil_PH	Filipino (Philippines)	Filipino	Filipino (Pilipinas)
000B	fi	Finnish	Finnish	Suomi
040B	fi_FI	Finnish (Finland)	Finnish	Suomi (Suomi)
000C	fr	French	French	Français
080C	fr_BE	French (Belgium)	French	Français (Belgique)
0C0C	fr_CA	French (Canada)	French	Français (Canada)
040C	fr_FR	French (France)	French	Français (France)
140C	fr_LU	French (Luxembourg)	French	Français (Luxembourg)
180C	fr_MC	French (Principality of Monaco)	French	Français (Principauté de Monaco)
100C	fr_CH	French (Switzerland)	French	Français (Suisse)
0462	fy_NL	Frisian (Netherlands)	Frisian	Frysk (Nederlân)
0056	gl	Galician	Galician	Galego
0456	gl_ES	Galician (Galician)	Galician	Galego (galego)
0037	ka	Georgian	Georgian	ქართული
0437	ka_GE	Georgian (Georgia)	Georgian	ქართული (საქართველო)
0007	de	German	German	Deutsch
0C07	de_AT	German (Austria)	German	Deutsch (Österreich)
0407	de_DE	German (Germany)	German	Deutsch (Deutschland)
1407	de_LI	German (Liechtenstein)	German	Deutsch (Liechtenstein)
1007	de_LU	German (Luxembourg)	German	Deutsch (Luxemburg)
0807	de_CH	German (Switzerland)	German	Deutsch (Schweiz)
0008	el	Greek	Greek	Ελληνικά
0408	el_GR	Greek (Greece)	Greek	Ελληνικά (Ελλάδα)
046F	kl_GL	Greenlandic (Greenland)	Greenlandic	Kalaallisut (Kalaallit Nunaat)
0047	gu	Gujarati	Gujarati	ગુજરાતી
0447	gu_IN	Gujarati (India)	Gujarati	ગુજરાતી (ભારત)
0468	ha_Latn_NG	Hausa (Latin, Nigeria)	Hausa (Latin)	Hausa (Nigeria)
000D	he	Hebrew‎	Hebrew	עברית‏
040D	he_IL	Hebrew (Israel)‎	Hebrew	עברית (ישראל)‏
0039	hi	Hindi	Hindi	हिंदी
0439	hi_IN	Hindi (India)	Hindi	हिंदी (भारत)
000E	hu	Hungarian	Hungarian	Magyar
040E	hu_HU	Hungarian (Hungary)	Hungarian	Magyar (Magyarország)
000F	is	Icelandic	Icelandic	Íslenska
040F	is_IS	Icelandic (Iceland)	Icelandic	Íslenska (Ísland)
0470	ig_NG	Igbo (Nigeria)	Igbo	Igbo (Nigeria)
0021	id	Indonesian	Indonesian	Bahasa Indonesia
0421	id_ID	Indonesian (Indonesia)	Indonesian	Bahasa Indonesia (Indonesia)
085D	iu_Latn_CA	Inuktitut (Latin, Canada)	Inuktitut (Latin)	Inuktitut (Kanatami) (kanata)
045D	iu_Cans_CA	Inuktitut (Syllabics, Canada)	Inuktitut	ᐃᓄᒃᑎᑐᑦ (ᑲᓇᑕ)
083C	ga_IE	Irish (Ireland)	Irish	Gaeilge (Éire)
0434	xh_ZA	Xhosa (South Africa)	Xhosa	Xhosa (uMzantsi Afrika)
0435	zu_ZA	Zulu (South Africa)	Zulu	Zulu (iNingizimu Afrika)
0010	it	Italian	Italian	Italiano
0410	it_IT	Italian (Italy)	Italian	Italiano (Italia)
0810	it_CH	Italian (Switzerland)	Italian	Italiano (Svizzera)
0011	ja	Japanese	Japanese	日本語
0411	ja_JP	Japanese (Japan)	Japanese	日本語 (日本)
004B	kn	Kannada	Kannada	ಕನ್ನಡ
044B	kn_IN	Kannada (India)	Kannada	ಕನ್ನಡ (ಭಾರತ)
003F	kk	Kazakh	Kazakh	Қазащb
043F	kk_KZ	Kazakh (Kazakhstan)	Kazakh	Қазақ (Қазақстан)
0453	km_KH	Khmer (Cambodia)	Khmer	ខ្មែរ (កម្ពុជា)
0486	qut_GT	K'iche (Guatemala)	K'iche	K'iche (Guatemala)
0487	rw_RW	Kinyarwanda (Rwanda)	Kinyarwanda	Kinyarwanda (Rwanda)
0041	sw	Kiswahili	Kiswahili	Kiswahili
0441	sw_KE	Kiswahili (Kenya)	Kiswahili	Kiswahili (Kenya)
0057	kok	Konkani	Konkani	कोंकणी
0457	kok_IN	Konkani (India)	Konkani	कोंकणी (भारत)
0012	ko	Korean	Korean	한국어
0412	ko_KR	Korean (Korea)	Korean	한국어 (대한민국)
0040	ky	Kyrgyz	Kyrgyz	Кыргыз
0440	ky_KG	Kyrgyz (Kyrgyzstan)	Kyrgyz	Кыргыз (Кыргызстан)
0454	lo_LA	Lao (Lao P.D.R.)	Lao	ລາວ (ສ.ປ.ປ. ລາວ)
0026	lv	Latvian	Latvian	Latviešu
0426	lv_LV	Latvian (Latvia)	Latvian	Latviešu (Latvija)
0027	lt	Lithuanian	Lithuanian	Lietuvių
0427	lt_LT	Lithuanian (Lithuania)	Lithuanian	Lietuvių (Lietuva)
082E	wee_DE	Lower Sorbian (Germany)	Lower Sorbian	Dolnoserbšćina (Nimska)
046E	lb_LU	Luxembourgish (Luxembourg)	Luxembourgish	Lëtzebuergesch (Luxembourg)
002F	mk	Macedonian	Macedonian (FYROM)	Македонски јазик
042F	mk_MK	Macedonian (Former Yugoslav Republic of Macedonia)	Macedonian (FYROM)	Македонски јазик (Македонија)
003E	ms	Malay	Malay	Bahasa Malaysia
083E	ms_BN	Malay (Brunei Darussalam)	Malay	Bahasa Malaysia (Brunei Darussalam)
043E	ms_MY	Malay (Malaysia)	Malay	Bahasa Malaysia (Malaysia)
044C	ml_IN	Malayalam (India)	Malayalam	മലയാളം (ഭാരതം)
043A	mt_MT	Maltese (Malta)	Maltese	Malti (Malta)
0481	mi_NZ	Maori (New Zealand)	Maori	Reo Māori (Aotearoa)
047A	arn_CL	Mapudungun (Chile)	Mapudungun	Mapudungun (Chile)
004E	mr	Marathi	Marathi	मराठी
044E	mr_IN	Marathi (India)	Marathi	मराठी (भारत)
047C	moh_CA	Mohawk (Mohawk)	Mohawk	Kanien'kéha (Canada)
0050	mn	Mongolian	Mongolian (Cyrillic)	Монгол хэл
0450	mn_MN	Mongolian (Cyrillic, Mongolia)	Mongolian (Cyrillic)	Монгол хэл (Монгол улс)
0850	mn_Mong_CN	Mongolian (Traditional Mongolian, PRC)	Mongolian (Traditional Mongolian)	ᠮᠣᠩᠭᠤᠯ ᠬᠡᠯᠡ (ᠪᠦᠭᠦᠳᠡ ᠨᠠᠢᠷᠠᠮᠳᠠᠬᠤ ᠳᠤᠮᠳᠠᠳᠤ ᠠᠷᠠᠳ ᠣᠯᠣᠰ)
0461	ne_NP	Nepali (Nepal)	Nepali	नेपाली (नेपाल)
0014	no	Norwegian	Norwegian (Bokmål)	Norsk
0414	nb_NO	Norwegian, Bokmål (Norway)	Norwegian (Bokmål)	Norsk, bokmål (Norge)
0814	nn_NO	Norwegian, Nynorsk (Norway)	Norwegian (Nynorsk)	Norsk, nynorsk (Noreg)
0482	oc_FR	Occitan (France)	Occitan	Occitan (França)
0448	or_IN	Oriya (India)	Oriya	ଓଡ଼ିଆ (ଭାରତ)
0463	ps_AF	Pashto (Afghanistan)	Pashto	پښتو (افغانستان)
0029	fa	Persian‎	Persian	فارسى‏
0429	fa_IR	Persian‎	Persian	فارسى (ايران)‏
0015	pl	Polish	Polish	Polski
0415	pl_PL	Polish (Poland)	Polish	Polski (Polska)
0016	pt	Portuguese	Portuguese	Português
0416	pt_BR	Portuguese (Brazil)	Portuguese	Português (Brasil)
0816	pt_PT	Portuguese (Portugal)	Portuguese	Português (Portugal)
0046	pa	Punjabi	Punjabi	ਪੰਜਾਬੀ
0446	pa_IN	Punjabi (India)	Punjabi	ਪੰਜਾਬੀ (ਭਾਰਤ)
046B	quz_BO	Quechua (Bolivia)	Quechua	Runasimi (Bolivia Suyu)
086B	quz_EC	Quechua (Ecuador)	Quechua	Runasimi (Ecuador Suyu)
0C6B	quz_PE	Quechua (Peru)	Quechua	Runasimi (Peru Suyu)
0018	ro	Romanian	Romanian	Română
0418	ro_RO	Romanian (Romania)	Romanian	Română (România)
0417	rm_CH	Romansh (Switzerland)	Romansh	Rumantsch (Svizra)
0019	ru	Russian	Russian	Русский
0419	ru_RU	Russian (Russia)	Russian	Русский (Россия)
243B	smn_FI	Sami, Inari (Finland)	Sami (Inari)	Sämikielâ (Suomâ)
103B	smj_NO	Sami, Lule (Norway)	Sami (Lule)	Julevusámegiella (Vuodna)
143B	smj_SE	Sami, Lule (Sweden)	Sami (Lule)	Julevusámegiella (Svierik)
0C3B	se_FI	Sami, Northern (Finland)	Sami (Northern)	Davvisámegiella (Suopma)
043B	se_NO	Sami, Northern (Norway)	Sami (Northern)	Davvisámegiella (Norga)
083B	se_SE	Sami, Northern (Sweden)	Sami (Northern)	Davvisámegiella (Ruoŧŧa)
203B	sms_FI	Sami, Skolt (Finland)	Sami (Skolt)	Sääm´ǩiõll (Lää´ddjânnam)
183B	sma_NO	Sami, Southern (Norway)	Sami (Southern)	Åarjelsaemiengiele (Nöörje)
1C3B	sma_SE	Sami, Southern (Sweden)	Sami (Southern)	Åarjelsaemiengiele (Sveerje)
004F	sa	Sanskrit	Sanskrit	संस्कृत
044F	sa_IN	Sanskrit (India)	Sanskrit	संस्कृत (भारतम्)
0C1A	sr	Serbian (Cyrillic, Serbia)	Serbian (Cyrillic)	Српски (Србија и Црна Гора)
1C1A	sr_Cyrl_BA	Serbian (Cyrillic, Bosnia and Herzegovina)	Serbian (Cyrillic)	Српски (Босна и Херцеговина)
7C1A	sr_Latn	Serbian	Serbian (Latin)	Srpski
181A	sr_Latn_BA	Serbian (Latin, Bosnia and Herzegovina)	Serbian (Latin)	Srpski (Bosna i Hercegovina)
081A	sr_Latn_SP	Serbian (Latin, Serbia)	Serbian (Latin)	Srpski (Srbija i Crna Gora)
046C	nso_ZA	Sesotho sa Leboa (South Africa)	Sesotho sa Leboa	Sesotho sa Leboa (Afrika Borwa)
0432	tn_ZA	Setswana (South Africa)	Setswana	Setswana (Aforika Borwa)
045B	si_LK	Sinhala (Sri Lanka)	Sinhala	සිංහ (ශ්‍රී ලංකා)
001B	sk	Slovak	Slovak	Slovenčina
041B	sk_SK	Slovak (Slovakia)	Slovak	Slovenčina (Slovenská republika)
0024	sl	Slovenian	Slovenian	Slovenski
0424	sl_SI	Slovenian (Slovenia)	Slovenian	Slovenski (Slovenija)
000A	es	Spanish	Spanish	Español
2C0A	es_AR	Spanish (Argentina)	Spanish	Español (Argentina)
400A	es_BO	Spanish (Bolivia)	Spanish	Español (Bolivia)
340A	es_CL	Spanish (Chile)	Spanish	Español (Chile)
240A	es_CO	Spanish (Colombia)	Spanish	Español (Colombia)
140A	es_CR	Spanish (Costa Rica)	Spanish	Español (Costa Rica)
1C0A	es_DO	Spanish (Dominican Republic)	Spanish	Español (República Dominicana)
300A	es_EC	Spanish (Ecuador)	Spanish	Español (Ecuador)
440A	es_SV	Spanish (El Salvador)	Spanish	Español (El Salvador)
100A	es_GT	Spanish (Guatemala)	Spanish	Español (Guatemala)
480A	es_HN	Spanish (Honduras)	Spanish	Español (Honduras)
080A	es_MX	Spanish (Mexico)	Spanish	Español (México)
4C0A	es_NI	Spanish (Nicaragua)	Spanish	Español (Nicaragua)
180A	es_PA	Spanish (Panama)	Spanish	Español (Panamá)
3C0A	es_PY	Spanish (Paraguay)	Spanish	Español (Paraguay)
280A	es_PE	Spanish (Peru)	Spanish	Español (Perú)
500A	es_PR	Spanish (Puerto Rico)	Spanish	Español (Puerto Rico)
0C0A	es_ES	Spanish (Spain)	Spanish	Español (España)
540A	es_US	Spanish (United States)	Spanish	Español (Estados Unidos)
380A	es_UY	Spanish (Uruguay)	Spanish	Español (Uruguay)
200A	es_VE	Spanish (Venezuela)	Spanish	Español (Republica Bolivariana de Venezuela)
001D	sv	Swedish	Swedish	Svenska
081D	sv_FI	Swedish (Finland)	Swedish	Svenska (Finland)
041D	sv_SE	Swedish (Sweden)	Swedish	Svenska (Sverige)
005A	syr	Syriac‎	Syriac	ܣܘܪܝܝܐ‏
045A	syr_SY	Syriac (Syria)‎	Syriac	ܣܘܪܝܝܐ (سوريا)‏
0428	tg_Cyrl_TJ	Tajik (Cyrillic, Tajikistan)	Tajik (Cyrillic)	Тоҷикӣ (Тоҷикистон)
085F	tzm_Latn_DZ	Tamazight (Latin, Algeria)	Tamazight (Latin)	Tamazight (Djazaïr)
0049	ta	Tamil	Tamil	தமிழ்
0449	ta_IN	Tamil (India)	Tamil	தமிழ் (இந்தியா)
0044	tt	Tatar	Tatar	Татар
0444	tt_RU	Tatar (Russia)	Tatar	Татар (Россия)
004A	te	Telugu	Telugu	తెలుగు
044A	te_IN	Telugu (India)	Telugu	తెలుగు (భారత దేశం)
001E	th	Thai	Thai	ไทย
041E	th_TH	Thai (Thailand)	Thai	ไทย (ไทย)
0451	bo_CN	Tibetan (PRC)	Tibetan	བོད་ཡིག (ཀྲུང་ཧྭ་མི་དམངས་སྤྱི་མཐུན་རྒྱལ་ཁབ།)
001F	tr	Turkish	Turkish	Türkçe
041F	tr_TR	Turkish (Turkey)	Turkish	Türkçe (Türkiye)
0442	tk_TM	Turkmen (Turkmenistan)	Turkmen	Türkmençe (Türkmenistan)
0480	ug_CN	Uighur (PRC)	Uighur	ئۇيغۇر يېزىقى (جۇڭخۇا خەلق جۇمھۇرىيىتى)
0022	uk	Ukrainian	Ukrainian	Україньска
0422	uk_UA	Ukrainian (Ukraine)	Ukrainian	Україньска (Україна)
042E	wen_DE	Upper Sorbian (Germany)	Upper Sorbian	Hornjoserbšćina (Němska)
0020	ur	Urdu‎	Urdu	اُردو‏
0420	ur_PK	Urdu (Islamic Republic of Pakistan)‎	Urdu	اُردو (پاکستان)‏
0043	uz	Uzbek	Uzbek (Latin)	U'zbek
0843	uz_Cyrl_UZ	Uzbek (Cyrillic, Uzbekistan)	Uzbek (Cyrillic)	Ўзбек (Ўзбекистон)
0443	uz_Latn_UZ	Uzbek (Latin, Uzbekistan)	Uzbek (Latin)	U'zbek (U'zbekiston Respublikasi)
002A	vi	Vietnamese	Vietnamese	Tiếng Việt
042A	vi_VN	Vietnamese (Vietnam)	Vietnamese	Tiếng Việt (Việt Nam)
0452	cy_GB	Welsh (United Kingdom)	Welsh	Cymraeg (y Deyrnas Unedig)
0488	wo_SN	Wolof (Senegal)	Wolof	Wolof (Sénégal)
0485	sah_RU	Yakut (Russia)	Yakut	Саха (Россия)
0478	ii_CN	Yi (PRC)	Yi	ꆈꌠꁱꂷ (ꍏꉸꏓꂱꇭꉼꇩ)
046A	yo_NG	Yoruba (Nigeria)	Yoruba	Yoruba (Nigeria)
)"

LangData := {}
Loop, Parse, LangInfo, `n, `r
{
	F := StrSplit(A_LoopField, A_Tab, A_Space)
	LangData[F.2] := {Code: F.1, Lang: F.3, Idiom: F.4, Local: F.5}
	If (A_Language = F.1)
		SysLang := F.2
}

If (Lang = "ERROR")
	Lang := SysLang

GoSub, LoadLangFiles

GoSub, WriteSettings

If (!LangFiles.HasKey(Lang))
{
	Lang := RegExReplace(Lang, "_.*")
	For i, l in LangFiles
	{
		If (InStr(i, Lang)=1)
		{
			Lang := i
			break
		}
	}
}
If (!LangFiles.HasKey(Lang))
	Lang := "En"
If (!LangFiles.HasKey(Lang))
{
	MsgBox, 20, Error, Missing language files.`n`nWould you like to download them now?
	IfMsgBox, No
		ExitApp
	VerChk := ""
	url := "https://www.macrocreator.com/lang"
	Try
	{
		UrlDownloadToFile, %url%, %A_Temp%\lang.json
		FileRead, ResponseText, %A_Temp%\lang.json
		ResponseText := RegExReplace(ResponseText, "ms).*(\{.*\}).*", "$1")
		VerChk := Eval(ResponseText)[1]
	}
	If (!IsObject(VerChk))
		MsgBox, 16, Pulover's Macro Creator, An error occurred.
	FileDelete, %A_Temp%\Lang\*.*
	SplashTextOn, 300, 25, Pulover's Macro Creator, Downloading... Please wait.
	WinHttpDownloadToFile("https://www.macrocreator.com/lang/Lang.zip", A_Temp)
	SplashTextOff
	If (!FileExist(A_Temp "\Lang.zip"))
	{
		MsgBox, 16, Pulover's Macro Creator, An error occurred.
		ExitApp
	}
	FileCreateDir, %A_Temp%\Lang
	FileCreateDir, %SettingsFolder%\Lang
	FileDelete, %SettingsFolder%\Lang\*.*
	UnZip(A_Temp "\Lang.zip", A_Temp "\Lang\")
	FileCopy, %A_Temp%\Lang\*.lang, %SettingsFolder%\Lang\, 1
	FileDelete, %A_Temp%\Lang.zip
	FileRemoveDir, %A_Temp%\Lang
	LangVersion := VerChk.LangRev, LangLastCheck := VerChk.LangRev
	GoSub, WriteSettings
	Run, %A_ScriptFullPath%
	ExitApp
}
CurrentLang := Lang

AppName := "Pulover's Macro Creator"
HeadLine := "; This script was created using Pulover's Macro Creator`n; www.macrocreator.com"
PmcHead := "/*"
. "`nPMC File Version " CurrentVersion
. "`n---[Do not edit anything in this section]---`n`n"

If (KeepDefKeys = 1)
	DefAutoKey := AutoKey, DefManKey := ManKey

GoSub, LoadLang

If (RegExMatch(FileLayout, "\(Ctrl\s*\+\s*G\)"))
	FileLayout := RegExReplace(FileLayout, "=\w+\s*\(Ctrl\s*\+\s*G\)", "=" w_Lang046)

#Include <Definitions>
#Include <WordList>
UserDefFunctions := SyHi_UserDef " "

GoSub, ObjCreate
ToggleMode := ToggleC ? "T" : "P"
If (ColSizes = "0,0,0,0,0,0,0,0,0,0,0")
	ColSizes := "70,185,335,60,60,100,150,225,85,50,60"
Loop, Parse, ColSizes, `,
	Col_%A_Index% := A_LoopField
Loop, Parse, ShowBands, `,
	ShowBand%A_Index% := A_LoopField

RegRead, DClickSpd, HKEY_CURRENT_USER, Control Panel\Mouse, DoubleClickSpeed
DClickSpd := Round(DClickSpd * 0.001, 1)

o_MacroContext := [{"Condition": "None", "Context": ""}]

RowCheckInProgress := false

;##### Menus: #####

Gui, 1:+LastFound
Gui, 1:Default

Menu, Tray, NoStandard

GoSub, RecentFiles
GoSub, CreateMenuBar

Menu, MouseB, Add, Click, HelpB
Menu, MouseB, Add, ControlClick, HelpB
Menu, MouseB, Add
Menu, MouseB, Add, Variables and Expressions, HelpB
Menu, MouseB, Add, Built-in Variables, :BuiltInMenu
Menu, MouseB, Icon, Click, %ResDllPath%, 24
Menu, TextB, Add, Send / SendRaw, HelpB
Menu, TextB, Add, ControlSend, HelpB
Menu, TextB, Add, ControlSetText, HelpB
Menu, TextB, Add, Clipboard, HelpB
Menu, TextB, Add
Menu, TextB, Add, Variables and Expressions, HelpB
Menu, TextB, Add, Built-in Variables, :BuiltInMenu
Menu, TextB, Icon, Send / SendRaw, %ResDllPath%, 24
Menu, ControlB, Add, Control, HelpB
Menu, ControlB, Add, ControlFocus, HelpB
Menu, ControlB, Add, ControlGet, HelpB
Menu, ControlB, Add, ControlGetFocus, HelpB
Menu, ControlB, Add, ControlGetPos, HelpB
Menu, ControlB, Add, ControlGetText, HelpB
Menu, ControlB, Add, ControlMove, HelpB
Menu, ControlB, Add, ControlSetText, HelpB
Menu, ControlB, Add
Menu, ControlB, Add, Variables and Expressions, HelpB
Menu, ControlB, Add, Built-in Variables, :BuiltInMenu
Menu, ControlB, Icon, Control, %ResDllPath%, 24
Menu, SpecialB, Add, List of Keys, SpecialB
Menu, SpecialB, Icon, List of Keys, %ResDllPath%, 24
Menu, PauseB, Add, Sleep, HelpB
Menu, PauseB, Add
Menu, PauseB, Add, Variables and Expressions, HelpB
Menu, PauseB, Add, Built-in Variables, :BuiltInMenu
Menu, PauseB, Icon, Sleep, %ResDllPath%, 24
Menu, MsgboxB, Add, MsgBox, HelpB
Menu, MsgboxB, Add
Menu, MsgboxB, Add, Variables and Expressions, HelpB
Menu, MsgboxB, Add, Built-in Variables, :BuiltInMenu
Menu, MsgboxB, Icon, MsgBox, %ResDllPath%, 24
Menu, KeyWaitB, Add, KeyWait, HelpB
Menu, KeyWaitB, Add
Menu, KeyWaitB, Add, Variables and Expressions, HelpB
Menu, KeyWaitB, Add, Built-in Variables, :BuiltInMenu
Menu, KeyWaitB, Icon, KeyWait, %ResDllPath%, 24
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
Menu, WindowB, Add
Menu, WindowB, Add, Variables and Expressions, HelpB
Menu, WindowB, Add, Built-in Variables, :BuiltInMenu
Menu, WindowB, Icon, WinActivate, %ResDllPath%, 24
Menu, ImageB, Add, ImageSearch, HelpB
Menu, ImageB, Add, PixelSearch, HelpB
Menu, ImageB, Add
Menu, ImageB, Add, Variables and Expressions, HelpB
Menu, ImageB, Add, Built-in Variables, :BuiltInMenu
Menu, ImageB, Icon, ImageSearch, %ResDllPath%, 24
Loop, Parse, FileCmdList, |
{
	If (A_LoopField = "")
		continue
	If (InStr(A_LoopField, "File")=1 || InStr(A_LoopField, "Drive")=1)
	{
		RunList_File .= A_LoopField "|"
		Menu, m_File, Add, %A_LoopField%, HelpB
	}
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
		RunList_String .= A_LoopField "|"
	}
	Else If (!InStr(A_LoopField, "Run") && (InStr(A_LoopField, "Wait")
	|| (A_LoopField = "Input")))
	{
		Menu, m_Wait, Add, %A_LoopField%, HelpB
		RunList_Wait .= A_LoopField "|"
	}
	Else If A_LoopField contains Box,Tip,Progress,Splash
	{
		Menu, m_Dialogs, Add, %A_LoopField%, HelpB
		RunList_Dialogs .= A_LoopField "|"
	}
	Else If (InStr(A_LoopField, "Reg") || InStr(A_LoopField, "Ini")=1)
	{
		Menu, m_Registry, Add, %A_LoopField%, HelpB
		RunList_Registry .= A_LoopField "|"
	}
	Else If (InStr(A_LoopField, "Sound")=1)
	{
		Menu, m_Sound, Add, %A_LoopField%, HelpB
		RunList_Sound .= A_LoopField "|"
	}
	Else If (InStr(A_LoopField, "Group")=1)
	{
		Menu, m_Group, Add, %A_LoopField%, HelpB
		RunList_Group .= A_LoopField "|"
	}
	Else If (InStr(A_LoopField, "Env")=1)
	{
		Menu, m_Vars, Add, %A_LoopField%, HelpB
		RunList_Vars .= A_LoopField "|"
	}
	Else If (InStr(A_LoopField, "Get"))
	{
		Menu, m_Get, Add, %A_LoopField%, HelpB
		RunList_Get .= A_LoopField "|"
	}
	Else If A_LoopField not contains Run,Process,Shutdown
	{
		Menu, m_Misc, Add, %A_LoopField%, HelpB
		RunList_Misc .= A_LoopField "|"
	}
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
Menu, RunB, Add, Messages, :m_Dialogs
Menu, RunB, Add, Reg && Ini, :m_Registry
Menu, RunB, Add, Sound, :m_Sound
Menu, RunB, Add, Variables, :m_Vars
Menu, RunB, Add, Misc., :m_Misc
Menu, RunB, Add
Menu, RunB, Add, Variables and Expressions, HelpB
Menu, RunB, Add, Built-in Variables, :BuiltInMenu
Menu, RunB, Icon, Run / RunWait, %ResDllPath%, 24
Menu, ComLoopB, Add, Loop, LoopB
Menu, ComLoopB, Add, While, LoopB
Menu, ComLoopB, Add, For, LoopB
Menu, ComLoopB, Add, Until, LoopB
Menu, ComLoopB, Add, Loop`, Parse, LoopB
Menu, ComLoopB, Add, Loop`, Files, LoopB
Menu, ComLoopB, Add, Loop`, Read, LoopB
Menu, ComLoopB, Add, Loop`, Reg, LoopB
Menu, ComLoopB, Add, Break, HelpB
Menu, ComLoopB, Add, Continue, HelpB
Menu, ComLoopB, Add
Menu, ComLoopB, Add, Variables and Expressions, HelpB
Menu, ComLoopB, Add, Built-in Variables, :BuiltInMenu
Menu, ComLoopB, Icon, Loop, %ResDllPath%, 24
Menu, ComGotoB, Add, Goto, HelpB
Menu, ComGotoB, Add, Gosub, HelpB
Menu, ComGotoB, Add, Labels, HelpB
Menu, ComGotoB, Add
Menu, ComGotoB, Add, Variables and Expressions, HelpB
Menu, ComGotoB, Add, Built-in Variables, :BuiltInMenu
Menu, ComGotoB, Icon, Goto, %ResDllPath%, 24
Menu, TimedLabelB, Add, SetTimer, HelpB
Menu, TimedLabelB, Add
Menu, TimedLabelB, Add, Variables and Expressions, HelpB
Menu, TimedLabelB, Add, Built-in Variables, :BuiltInMenu
Menu, TimedLabelB, Icon, SetTimer, %ResDllPath%, 24
Menu, IfStB, Add, IfWinActive / IfWinNotActive, HelpB
Menu, IfStB, Add, IfWinExist / IfWinNotExist, HelpB
Menu, IfStB, Add, IfExist / IfNotExist, HelpB
Menu, IfStB, Add, IfInString / IfNotInString, HelpB
Menu, IfStB, Add, IfMsgBox, HelpB
Menu, IfStB, Add, If Statements, HelpB
Menu, IfStB, Add
Menu, IfStB, Add, Variables and Expressions, HelpB
Menu, IfStB, Add, Built-in Variables, :BuiltInMenu
Menu, IfStB, Icon, IfWinActive / IfWinNotActive, %ResDllPath%, 24
Menu, AsVarB, Add, Variables and Expressions, HelpB
Menu, AsVarB, Add, Arrays, HelpB
Menu, AsVarB, Add, Objects, HelpB
Menu, AsVarB, Add
Menu, AsVarB, Add, Built-in Variables, :BuiltInMenu
Menu, AsVarB, Icon, Variables and Expressions, %ResDllPath%, 24
Menu, AsFuncB, Add, Built-in Functions, HelpB
Menu, AsFuncB, Add, Arrays, HelpB
Menu, AsFuncB, Add, Objects, HelpB
Menu, AsFuncB, Add, Object Methods, HelpB
Menu, AsFuncB, Add
Menu, AsFuncB, Add, Variables and Expressions, HelpB
Menu, AsFuncB, Add, Built-in Variables, :BuiltInMenu
Menu, AsFuncB, Icon, Built-in Functions, %ResDllPath%, 24
Menu, EmailB, Add, COM, ComB
Menu, EmailB, Add, COM Object Reference, ComB
Menu, EmailB, Add, CDO (Microsoft MSDN), ComB
Menu, EmailB, Add
Menu, EmailB, Add, Variables and Expressions, HelpB
Menu, EmailB, Add, Built-in Variables, :BuiltInMenu
Menu, EmailB, Icon, COM, %ResDllPath%, 24
Menu, DownloadB, Add, COM, ComB
Menu, DownloadB, Add, COM Object Reference, ComB
Menu, DownloadB, Add, WinHttpRequest Object (Microsoft MSDN), ComB
Menu, DownloadB, Add
Menu, DownloadB, Add, Variables and Expressions, HelpB
Menu, DownloadB, Add, Built-in Variables, :BuiltInMenu
Menu, DownloadB, Icon, COM, %ResDllPath%, 24
Menu, ZipB, Add, COM, ComB
Menu, ZipB, Add, COM Object Reference, ComB
Menu, ZipB, Add, Shell Object (Microsoft MSDN), ComB
Menu, ZipB, Add
Menu, ZipB, Add, Variables and Expressions, HelpB
Menu, ZipB, Add, Built-in Variables, :BuiltInMenu
Menu, ZipB, Icon, COM, %ResDllPath%, 24
Menu, IEComB, Add, COM, ComB
Menu, IEComB, Add, COM Object Reference, ComB
Menu, IEComB, Add, Basic Webpage COM Tutorial, ComB
Menu, IEComB, Add, IWebBrowser2 Interface (Microsoft), ComB
Menu, IEComB, Add
Menu, IEComB, Add, Variables and Expressions, HelpB
Menu, IEComB, Add, Built-in Variables, :BuiltInMenu
Menu, IEComB, Icon, COM, %ResDllPath%, 24
Menu, SendMsgB, Add, PostMessage / SendMessage, HelpB
Menu, SendMsgB, Add, Message List, SendMsgB
Menu, SendMsgB, Add, Microsoft Docs, SendMsgB
Menu, SendMsgB, Add
Menu, SendMsgB, Add, Variables and Expressions, HelpB
Menu, SendMsgB, Add, Built-in Variables, :BuiltInMenu
Menu, SendMsgB, Icon, PostMessage / SendMessage, %ResDllPath%, 24
Menu, UserFuncB, Add, Functions, HelpB
Menu, UserFuncB, Add
Menu, UserFuncB, Add, Variables and Expressions, HelpB
Menu, UserFuncB, Add, Built-in Variables, :BuiltInMenu
Menu, UserFuncB, Icon, Functions, %ResDllPath%, 24
Menu, IfDirB, Add, #IfWinActive / #IfWinExist, HelpB
Menu, IfDirB, Icon, #IfWinActive / #IfWinExist, %ResDllPath%, 24
Menu, EditMacroB, Add, Hotkeys, HelpB
Menu, EditMacroB, Add, Hotstrings, HelpB
Menu, EditMacroB, Icon, Hotkeys, %ResDllPath%, 24
Menu, ExportG, Add, Hotkeys, ExportG
Menu, ExportG, Add, Hotstrings, ExportG
Menu, ExportG, Add, List of Keys, ExportG
Menu, ExportG, Add, ComObjCreate, ExportG
Menu, ExportG, Add, ComObjActive, ExportG
Menu, ExportG, Add, Auto-execute Section, ExportG
Menu, ExportG, Add, #IfWinActive / #IfWinExist, HelpB
Menu, ExportG, Icon, Hotkeys, %ResDllPath%, 24
Menu, ExportO, Add, #SingleInstance, ExportG
Menu, ExportO, Add, SetTitleMatchMode, ExportG
Menu, ExportO, Add, CoordMode, ExportG
Menu, ExportO, Add, DetectHiddenWindows, ExportG
Menu, ExportO, Add, DetectHiddenText, ExportG
Menu, ExportO, Add, #WinActivateForce, ExportG
Menu, ExportO, Add, #Persistent, ExportG
Menu, ExportO, Add, #UseHook, ExportG
Menu, ExportO, Add, SendMode, ExportG
Menu, ExportO, Add, SetKeyDelay, ExportG
Menu, ExportO, Add, SetMouseDelay, ExportG
Menu, ExportO, Add, SetMouseDelay, ExportG
Menu, ExportO, Add, SetControlDelay, ExportG
Menu, ExportO, Add, SetWinDelay, ExportG
Menu, ExportO, Add, SetBatchLines, ExportG
Menu, ExportO, Add, #MaxThreadsPerHotkey, ExportG
Menu, ExportO, Add, #NoTrayIcon, ExportG
Menu, ExportO, Add, #Warn, ExportG
Menu, ExportO, Icon, #SingleInstance, %ResDllPath%, 24

;##### Main Window: #####

Gui, +Resize +MinSize310x175 +HwndPMCWinID

Gui, Add, Custom, ClassToolbarWindow32 hwndhTbFile gTbFile 0x0800 0x0100 0x0040 0x0008 0x0004
Gui, Add, Custom, ClassToolbarWindow32 hwndhTbRecPlay gTbRecPlay 0x0800 0x0040 0x0008 0x0004
Gui, Add, Custom, ClassToolbarWindow32 hwndhTbCommand gTbCommand 0x0800 0x0100 0x0040 0x0008 0x0004
Gui, Add, Custom, ClassToolbarWindow32 hwndhTbSettings gTbSettings 0x0800 0x0100 0x0040 0x0008 0x0004
Gui, Add, Custom, ClassToolbarWindow32 hwndhTbEdit gTbEdit 0x0800 0x0100 0x0040 0x0008 0x0004
If (TbNoTheme)
	Gui, -Theme
Gui, Add, Custom, ClassReBarWindow32 hwndhRbMain vcRbMain gRB_Notify 0x0400 0x0040 0x8000
Gui, +Theme
Gui, Add, Custom, ClassReBarWindow32 hwndhRbMacro vcRbMacro gRB_Notify xm-15 ym+76 -Theme 0x0800 0x0040 0x8000 0x0008 ; 0x0004
Gui, Add, Combobox, hwndhFindList vFindList gFindInList, %Tips_List%
hFindEdit := DllCall("GetWindow", "PTR", hFindList, "Uint", 5) ;GW_CHILD = 5
Gui, Add, Hotkey, hwndhAutoKey vAutoKey gSaveData, % o_AutoKey[1]
Gui, Add, ListBox, hwndhJoyKey vJoyKey r1 ReadOnly Hidden
Gui, Add, Hotkey, hwndhManKey vManKey gWaitKeys Limit190, % o_ManKey[1]
Gui, Add, Hotkey, hwndhAbortKey vAbortKey, %AbortKey%
Gui, Add, Hotkey, hwndhPauseKey vPauseKey, %PauseKey%

Gui, Add, Checkbox, Section -Wrap Checked%BarInfo% y+316 xm W25 H23 hwndhBarInfo vBarInfo gBarInfo 0x1000
	ILButton(hBarInfo, ResDllPath ":" 29)
Gui, Add, Checkbox, -Wrap ys x+0 W25 H23 hwndhBarEdit vBarEdit gBarEdit 0x1000
	ILButton(hBarEdit, ResDllPath ":" 14)
Gui, Add, Text, -Wrap y+4 x+5 W85 R1 Right vRepeat Hidden, %w_Lang015%:
Gui, Add, Edit, ys-3 x+10 W75 R1 vRept Hidden
Gui, Add, UpDown, vTimesM 0x80 Range0-999999999 Hidden, 1
Gui, Add, Button, -Wrap ys-4 x+0 W25 H23 hwndhApplyT vApplyT gApplyT Hidden
	ILButton(hApplyT, ResDllPath ":" 1)
Gui, Add, Text, W2 H25 ys-3 x+5 0x11 vSeparator1 Hidden
Gui, Add, Text, -Wrap x+5 ys W85 R1 Right vDelayT Hidden, %w_Lang016%:
Gui, Add, Edit, ys-3 x+10 W75 R1 vDelay Hidden
Gui, Add, UpDown, vDelayG 0x80 Range0-999999999 Hidden, %DelayG%
Gui, Add, Button, -Wrap ys-4 x+0 W25 H23 hwndhApplyI vApplyI gApplyI Hidden
	ILButton(hApplyI, ResDllPath ":" 1)
Gui, Add, Text, W2 H25 ys-3 x+5 0x11 vSeparator2 Hidden
Gui, Add, Hotkey, ys-3 x+5 W150 vsInput Hidden
Gui, Add, Button, -Wrap ys-4 x+0 W25 H23 hwndhApplyL vApplyL gApplyL Hidden
	ILButton(hApplyL, ResDllPath ":" 31)
Gui, Add, Button, -Wrap ys-4 x+5 W25 H23 hwndhInsertKey vInsertKey gInsertKey Hidden
	ILButton(hInsertKey, ResDllPath ":" 91)
Gui, Add, Link, -Wrap ys xs+55 W125 R1 vTHotkeyTip gEditSelectedMacro, % "<a>Hotkey</a>: " o_AutoKey[A_List]
Gui, Add, Text, W2 H25 ys-3 x+5 0x11 vSeparator3
Gui, Add, Link, -Wrap ys x+5 W125 R1 vContextTip gSetWin, Global <a>#If</a>: %IfDirectContext%
Gui, Add, Text, W2 H25 ys-3 x+5 0x11 vSeparator4
Gui, Add, Link, -Wrap ys x+5 W125 R1 vMacroContextTip gEditSelectedMacro, % "Macro <a>#If</a>: " o_MacroContext[A_List].Condition
Gui, Add, Text, W2 H25 ys-3 x+5 0x11 vSeparator5
Gui, Add, Link, -Wrap ys x+5 W115 R1 vCoordTip gOptions, <a>CoordMode</a>: %CoordMouse%
Gui, Add, Text, W2 H25 ys-3 x+5 0x11 vSeparator6
Gui, Add, Link, -Wrap ys x+5 W115 R1 vTModeTip gOptions, <a>TitleMatchMode</a>: %TitleMatch%
Gui, Add, Text, W2 H25 ys-3 x+5 0x11 vSeparator7
Gui, Add, Link, -Wrap ys x+5 W145 R1 vTSendModeTip gOptions, <a>SendMode</a>: %KeyMode%
Gui, Add, Text, W2 H25 ys-3 x+5 0x11 vSeparator8
Gui, Add, Link, -Wrap ys x+5 W350 R1 vTLastMacroTip gGoToLastMacro, %w_Lang115%: <a>%LastMacroRun%</a>
GuiControl,, WinKey, % (InStr(o_AutoKey[1], "#")) ? 1 : 0
Gui, Submit
If (MainWinSize = "W H")
	MainWinSize := "W930 H630"
If (MainWinPos = "X Y")
	MainWinPos := "Center"
Else If (MainWinPos != "Center")
{
	mGuiX := RegExReplace(MainWinPos, "X(\d+).*", "$1"), mGuiY := RegExReplace(MainWinPos, ".*Y(\d+)", "$1")
	If (mGuiX < 0)
		mGuiX := 0
	If (mGuiY < 0)
		mGuiY := 0
	If (mGuiX >= A_ScreenWidth) || (mGuiY >= A_ScreenHeight)
		MainWinPos := "Center"
	Else
		MainWinPos := "X" mGuiX " Y" mGuiY
}
If (!BarInfo)
	GoSub, BarEdit
Gui, Show, %MainWinSize% %MainWinPos% Hide
IfExist, %SettingsFolder%\~ActiveProject.pmc
	BackupFound := true
GoSub, b_Start
SavePrompt(false, A_ThisLabel)
GoSub, DefineControls
GoSub, DefineToolbars
OnMessage(WM_COMMAND, "TB_Messages")
OnMessage(WM_MOUSEMOVE, "ShowTooltip")
OnMessage(WM_RBUTTONDOWN, "ShowContextHelp")
OnMessage(WM_LBUTTONDOWN, "DragTab")
OnMessage(WM_MBUTTONDOWN, "CloseTab")
OnMessage(WM_ACTIVATE, "WinCheck")
OnMessage(WM_COPYDATA, "Receive_Params")
OnMessage(WM_HELP, "CmdHelp")
OnMessage(0x404, "AHK_NOTIFYICON")
DllCall("SendMessageW", "Ptr", hFindEdit, "Uint", 0x1501, "Ptr", True, "WStr", w_Lang111) ; EM_SETCUEBANNER = 0x1501

If (KeepHkOn)
	Menu, Tray, Check, %w_Lang014%

; Command line parameters
If (A_Args.length())
{
	WinGetActiveTitle, LastFoundWin
	For n, Param in A_Args
	{
		Params .= Param "`n"
		If (Param = "-r")
			RecOn := 1
		If (!t_Macro) && (RegExMatch(Param, "i)^-s(\d+)*$", t_Macro))
		{
			AutoPlay := "Macro" t_Macro1
			HideWin := 1, CloseAfterPlay := 1
			break
		}
		If (!t_Macro) && (RegExMatch(Param, "i)^-a(\d+)*$", t_Macro))
			AutoPlay := "Macro" t_Macro1
		If (Param = "-p")
			PlayHK := 1
		If (Param = "-h")
			HideWin := 1
		If (!t_Timer) && (RegExMatch(Param, "i)^-t(\d*)(!)?$", _t))
			TimerPlay := 1, TimerDelayX := (_t1) ? _t1 : 250, TimedRun := RunFirst := (_t2) ? 1 : 0
		If (Param = "-c")
			CloseAfterPlay := 1
		If (Param = "-b")
			ShowCtrlBar := 1
	}
	Files := RTrim(Params, "`n")
	If (!MultInst) && (TargetID := WinExist("ahk_exe " A_ScriptFullPath))
	{
		Send_Params(Files, TargetID)
		ExitApp
	}
	GoSub, OpenFile
}
Else If (!MultInst) && (TargetID := WinExist("ahk_exe " A_ScriptFullPath))
{
	WinActivate, ahk_id %TargetID%
	ExitApp
}
Else
{
	Gui, chMacro:Default
	Gui, chMacro:Submit, NoHide
	LVManager[A_List] := new LV_Rows(ListID%A_List%)
	LVManager[A_List].Add()
	GoSub, MacroTab
	If (ShowGroups)
		GoSub, EnableGroups
}
Menu, Tray, Icon
Gui, 1:Show, % ((WinState) ? "Maximize" : MainWinSize " " MainWinPos) ((HideWin) ? "Hide" : ""), % (CurrentFileName ? CurrentFileName " - " : "") AppName " v" CurrentVersion
Gosub, GuiSize
GoSub, LoadData
TB_Edit(tbFile, "Preview", ShowPrev)
TB_Edit(TbSettings, "HideMainWin", HideMainWin), TB_Edit(TbSettings, "OnScCtrl", OnScCtrl)
TB_Edit(TbSettings, "CheckHkOn", KeepHkOn), TB_Edit(TbSettings, "SetWin", (IfDirectContext = "None") ? 0 : 1)
TB_Edit(TbEdit, "GroupsMode", ShowGroups)
Gui, 1:Default
IfExist, %DefaultMacro%
{
	AutoRefreshState := AutoRefresh, AutoRefresh := 0
	GpConfig := ShowGroups, ShowGroups := false
	LVManager[A_List].EnableGroups(false)
	PMC.Import(DefaultMacro)
	GoSub, UpdateCopyTo
	GoSub, SetFinishButton
	CurrentFileName := LoadedFileName
	GoSub, FileRead
}
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
If (RecOn)
{
	DontShowRec := 1, ShowStep := 0, OnScCtrl := 0
	GoSub, Record
	SetTimer, RecStart, -500
}
Else If ((AutoPlay) || (TimerPlay))
{
	GuiControl, chMacro:Choose, A_List, %t_Macro1%
	GoSub, TabSel
	If (TimerPlay)
		GoSub, TimerOK
	Else
		GoSub, TestRun
}
Else
{
	If A_OSVersion in WIN_VISTA,WIN_2003,WIN_XP,WIN_2000,WIN_7
	{
		If (!DontShowAdm && !A_IsAdmin)
		{
			Gui, 1:+Disabled
			Gui, 35:-SysMenu +HwndTipScrID +owner1
			Gui, 35:Color, FFFFFF
			Gui, 35:Add, Pic, y+20 Icon78 W48 H48, %ResDllPath%
			Gui, 35:Add, Text, -Wrap R1 yp x+10, %d_Lang058%`n
			Gui, 35:Add, Checkbox, -Wrap W300 vDontShowAdm R1, %d_Lang053%
			Gui, 35:Add, Button, -Wrap Default y+10 W90 H23 gTipClose2, %c_Lang020%
			Gui, 35:Show,, %AppName%
			WinWaitClose, ahk_id %TipScrID%
			Gui, 1:-Disabled
		}
	}
	If (ShowBarOnStart)
		GoSub, ShowControls
	If (ShowWelcome)
		GoSub, Welcome
	Else
	{
		If (ShowTips)
			GoSub, ShowTips
		If (AutoUpdate)
			SetTimer, CheckUpdates, -1
	}
	If (BackupFound)
	{
		Gui, 1:+OwnDialogs
		MsgBox, 36, %AppName%, %d_Lang083%
		IfMsgBox, Yes
		{
			Files := SettingsFolder "\~ActiveProject.pmc"
			GoSub, OpenFile
			CurrentFileName := ""
			SavePrompt(true, A_ThisLabel)
			Gui, 1:Show,, %AppName% v%CurrentVersion%
			Gosub, GuiSize
		}
		BackupFound := false
	}
	Else
	{
		FileDelete, %SettingsFolder%\~ActiveProject.pmc
		BackupFound := false
	}
}
HideWin := "", PlayHK := "", AutoPlay := "", TimerPlay := ""
FreeMemory()
SetTimer, FinishIcon, -1
SavePrompt(SavePrompt, A_ThisLabel)
If (AutoBackup)
	SetTimer, ProjBackup, 60000
return

;##### Toolbars #####

DefineToolbars:
TB_Define(TbFile, hTbFile, hIL, DefaultBar.File, DefaultBar.FileOpt)
TB_Define(TbRecPlay, hTbRecPlay, hIL, DefaultBar.RecPlay, DefaultBar.RecPlayOpt)
TB_Define(TbCommand, hTbCommand, hIL, DefaultBar.Command, DefaultBar.CommandOpt)
TB_Define(TbEdit, hTbEdit, hIL, DefaultBar.Edit, DefaultBar.EditOpt)
TB_Define(TbSettings, hTbSettings, hIL, DefaultBar.Settings, DefaultBar.SetOpt)
TB_Define(TbOSC, hTbOSC, hIL_Icons, FixedBar.OSC, FixedBar.OSCOpt)
TB_Edit(TbOSC, "ProgBarToggle", ShowProgBar)
RbMain := New Rebar(hRbMain)
TB_Rebar(RbMain, TbFile_ID, TbFile), TB_Rebar(RbMain, TbRecPlay_ID, TbRecPlay), TB_Rebar(RbMain, TbCommand_ID, TbCommand)
RbMain.InsertBand(hFindList, 0, "", 6, "", 150, 0, "", 22, 50)
RbMain.InsertBand(hTimesCh, 0, "FixedSize NoGripper", 11, w_Lang011 " (" t_Lang004 ")", 75 * (A_ScreenDPI/96), 0, "", 22, 75 * (A_ScreenDPI/96))
TB_Rebar(RbMain, TbEdit_ID, TbEdit, "Break"), TB_Rebar(RbMain, TbSettings_ID, TbSettings)
RbMain.InsertBand(hAutoKey, 0, "", 7, w_Lang005, 50, 0, "", 22, 50)
RbMain.InsertBand(hManKey, 0, "", 8, w_Lang007, 50, 0, "", 22, 50)
RbMain.InsertBand(hAbortKey, 0, "", 9, w_Lang008, 60, 0, "", 22, 50)
RbMain.InsertBand(hPauseKey, 0, "", 10, c_Lang003, 60, 0, "", 22, 50)
RbMain.SetMaxRows(3)
TBHwndAll := [TbFile, TbRecPlay, TbCommand, TbEdit, TbSettings, tbPrev, tbPrevF, TbOSC]
RBIndexTB := [1, 2, 3, 4, 5], RBIndexHK := [7, 8, 9, 10]
Default_Layout := RbMain.GetLayout()
Loop, Parse, Default_Layout, |
	l_Band%A_Index% := A_LoopField
If (MainLayout = "ERROR")
{
	If (UserLayout = "ERROR")
	{
		ShowWelcome := true
		SetTimer, SetBestFitLayout, -1
	}
	return
}
Loop, 3
	RbMain.SetLayout(MainLayout)
Loop, % RbMain.GetBandCount()
	RbMain.ShowBand(RbMain.IDToIndex(A_Index), ShowBand%A_Index%)
BtnsArray := []
If (FileLayout != "ERROR")
	TB_Layout(TbFile, FileLayout, TbFile_ID)
If (RecPlayLayout != "ERROR")
	TB_Layout(TbRecPlay, RecPlayLayout, TbRecPlay_ID)
If (CommandLayout != "ERROR")
	TB_Layout(TbCommand, CommandLayout, TbCommand_ID)
If (EditLayout != "ERROR")
	TB_Layout(TbEdit, EditLayout, TbEdit_ID)
If (SettingsLayout != "ERROR")
	TB_Layout(TbSettings, SettingsLayout, TbSettings_ID)
return

TbFile:
TbRecPlay:
TbCommand:
TbSettings:
TbEdit:
TbText:
TbOSC:
tbPrev:
tbPrevF:
If (A_GuiEvent = "N")
{
	TbPtr := %A_ThisLabel%
	ErrorLevel := TbPtr.OnNotify(A_EventInfo, MX, MY, bLabel)
	If (bLabel)
		ShowMenu(bLabel, MX, MY)
	If (ErrorLevel = 2) ; TBN_RESET
	{
		TB_Edit(TbFile, "Preview", ShowPrev), TB_Edit(TbSettings, "HideMainWin", HideMainWin)
		TB_Edit(TbSettings, "OnScCtrl", OnScCtrl), TB_Edit(TbSettings, "CheckHkOn", KeepHkOn)
		TB_Edit(TbSettings, "SetWin", (IfDirectContext = "None") ? 0 : 1)
		TB_Edit(TbSettings, "SetJoyButton", JoyHK), TB_Edit(TbOSC, "ProgBarToggle", ShowProgBar)
		TB_Edit(TbSettings, "OnFinish",(OnFinishCode = 1) ? 0 : 1,,, (OnFinishCode = 1) ? 20 : 62)
	}
	Else If (ErrorLevel = 1)
		TB_IdealSize(TbPtr, %A_ThisLabel%_ID)
}
return

RB_Notify:
If (A_GuiEvent = "N")
{
	rbEventCode := NumGet(A_EventInfo + (A_PtrSize * 2), 0, "Int")
	If (RbMain.OnNotify(A_EventInfo, tbMX, tbMY, BandID))
		ShowChevronMenu(RbMain, BandID, tbMX, tbMY)
	If (rbEventCode = -831) ; RBN_HEIGHTCHANGE
	{
		If (A_GuiControl = "cRbMain")
		{
			y_Values := IconSize = "Small" ? ["y55", "y30", "y83"] : ["y72", "y36", "y107"]
			o_Values := IconSize = "Small" ? [88, 63, 118] : [105, 69, 140]
			RowsCount := RbMain.GetRowCount()
			MacroOffset := (RowsCount = 2) ? o_Values[1] : ((RowsCount = 1) ? o_Values[2] : o_Values[3])
			GuiControl, 1:Move, cRbMacro, % (RowsCount = 2) ? y_Values[1] : (RowsCount = 1 ? y_Values[2] : y_Values[3])
			SetTimer, GuiSize, -1
		}
		Else
			RbMacro.OnNotify(A_EventInfo)
	}
	If (rbEventCode = -835) ; RBN_BEGINDRAG
		OnMessage(WM_NOTIFY, ""), LV_Colors.Detach(ListID%A_List%)
	If (rbEventCode = -836) ; RBN_ENDDRAG
	{
		GoSub, RowCheck
		SetTimer, chMacroGuiSize, -1
	}
}
return

;##### Other controls #####

DefineControls:
GoSub, BuildMacroWin
GoSub, BuildPrevWin
GoSub, BuildMixedControls
GoSub, BuildOSCWin
RbMacro := New Rebar(hRbMacro)
RbMacro.InsertBand(hMacroCh, 0, "NoGripper", 30, "", A_ScreenWidth/2, 0, "", "", 10, 10)
RbMacro.InsertBand(hPrevCh, 0, "", 31, "", A_ScreenWidth/2, 0, "", "", 0)
RbMacro.SetMaxRows(1)
(MacroLayout = "ERROR") ? "" : RbMacro.SetLayout(MacroLayout)
!ShowPrev ? RbMacro.ModifyBand(2, "Style", "Hidden")
return

BuildMacroWin:
Gui, chMacro:+LastFound
Gui, chMacro:+hwndhMacroCh -Caption +Parent1
Gui, chMacro:Add, Button, -Wrap y+0 W25 H23 hwndhMacrosMenu vMacrosMenu gMacrosMenu, ▼
Gui, chMacro:Add, Tab2, Section Buttons 0x0008 -Wrap AltSubmit yp H22 hwndTabSel vA_List gTabSel, Macro1
;  LV0x10000 = LVS_EX_DOUBLEBUFFER
Gui, chMacro:Font, s%MacroFontSize%
Gui, chMacro:Add, ListView, AltSubmit Checked xs+0 y+0 hwndListID1 vInputList1 gInputList NoSort LV0x10000 LV0x4000, %w_Lang030%|%w_Lang031%|%w_Lang032%|%w_Lang033%|%w_Lang034%|%w_Lang035%|%w_Lang036%|%w_Lang037%|%w_Lang038%|%w_Lang039%|%w_Lang040%
Gui, chMacro:Default
LV_SetImageList(hIL_Icons)
Loop, 11
	LV_ModifyCol(A_Index, Col_%A_Index%)
LVOrder_Set(11, ColOrder, ListID1)
Gui, chMacro:Submit
GuiControl, chMacro:Focus, InputList%A_List%
Gui, 1:Default
return

BuildMixedControls:
Gui, chTimes:+LastFound
Gui, chTimes:+hwndhTimesCh -Caption +Parent1
Gui, chTimes:Add, Edit, x0 y0 W75 H22 Number vReptC
Gui, chTimes:Add, UpDown, vTimesG gSaveData 0x80 Range0-999999999, 1
return

Preview:
If (FloatPrev)
	GoSub, PrevClose
Else
{
	TB_Edit(TbFile, "Preview", ShowPrev := !ShowPrev)
	RbMacro.ModifyBand(2, "Style", "Hidden", false)
	RbMacro.ModifyBand(2, "MinWidth", 0)
	GoSub, PrevRefresh
}
If (ShowPrev)
	Menu, PreviewMenu, Check, %v_Lang029%`t%_s%Ctrl+P
Else
	Menu, PreviewMenu, UnCheck, %v_Lang029%`t%_s%Ctrl+P
return

PrevDock:
Input
FloatPrev := !FloatPrev
If (FloatPrev)
{
	RbMacro.ModifyBand(2, "Style", "Hidden")
	If (InStr(PrevWinSize, "H0"))
		PrevWinSize := "W450 H500"
	Gui, 2:Show, %PrevWinSize%, %c_Lang072% - %AppName%
}
Else
{
	Gui, 2:Hide
	GuiGetSize(pGuiWidth, pGuiHeight, 2), PrevWinSize := "W" pGuiWidth " H" pGuiHeight
	RbMacro.ModifyBand(2, "Style", "Hidden", false)
}
lastCalcMargin := ""
GoSub, PrevRefresh
return

BuildPrevWin:
Gui, chPrev:+LastFound
Gui, chPrev:+hwndhPrevCh -Resize -Caption +Parent1
Gui, chPrev:Add, Custom, ClassToolbarWindow32 y+0 W400 hwndhtbPrev gtbPrev 0x0800 0x0100 0x0040 0x0008
Gui, chPrev:Add, Custom, ClassScintilla x0 y25 hwndhSciPrev vLVPrev
Gui, chPrev:Show, W450 H600 Hide
TB_Define(tbPrev, htbPrev, hIL_Icons, FixedBar.Preview, FixedBar.PrevOpt)
scintilla.encoding := "UTF-8"
sciPrev := new scintilla(hSciPrev)
sciPrev.SetCodePage(65001)
sciPrev.SetMarginWidthN(0x0, 0xA)
sciPrev.SetMarginWidthN(0x1, 0x5)
sciPrev.SetMarginTypeN(0x1, 0x2)
sciPrev.SetWrapMode(TextWrap ? 0x1 : 0x0)
sciPrev.SetSelBack(true, 0xFFFF80)
sciPrev.SetCaretLineBack(0xFFFF80)
sciPrev.SetCaretLineVisible(true)
sciPrev.SetCaretLineVisibleAlways(true)
sciPrev.SetLexer(0xC8)
sciPrev.StyleClearAll()

sciPrev.StyleSetFore(0x1, 0x2C974B) ; Line comment
sciPrev.StyleSetFore(0x2, 0x969896) ; Block comment
sciPrev.StyleSetFore(0x3, 0x183691) ; Escaped Char
sciPrev.StyleSetFore(0x4, 0xA71D5D) ; Operator
sciPrev.StyleSetFore(0x5, 0xA71D5D) ; Delimiters
sciPrev.StyleSetFore(0x6, 0x183691) ; String
sciPrev.StyleSetFore(0x7, 0x009999) ; Number
sciPrev.StyleSetFore(0x8, 0x008080) ; Variable
sciPrev.StyleSetFore(0x9, 0x008080) ; Variable
sciPrev.StyleSetFore(0xA, 0x8066A8), sciPrev.StyleSetBold(0xA, 0x1) ; Label && Hotkey
sciPrev.StyleSetFore(0xB, 0x0086B3), sciPrev.StyleSetBold(0xB, 0x1) ; Flow of Control
sciPrev.StyleSetFore(0xC, 0x0086B3) ; Command
sciPrev.StyleSetFore(0xD, 0xBB5046), sciPrev.StyleSetBold(0xD, 0x1) ; Built-in Function
sciPrev.StyleSetFore(0xE, 0x0086B3) ; Directive
sciPrev.StyleSetFore(0xF, 0x009B4E), sciPrev.StyleSetBold(0xF, 0x1) ; Key && Button
sciPrev.StyleSetFore(0x10, 0xCF00CF) ; Built-in Variable
sciPrev.StyleSetFore(0x11, 0xDD1144) ; Keyword
sciPrev.StyleSetFore(0x12, 0xF04020), sciPrev.StyleSetBold(0x12, 0x1) ; User defined
sciPrev.StyleSetBack(0x14, 0xFFC0C0) ; Syntax Error
sciPrev.StyleSetFore(0x21, 0x808080), sciPrev.StyleSetSize(0x21, 0x7) ; Line number

sciPrev.SetKeywords(0x0, SyHi_Flow)
sciPrev.SetKeywords(0x1, SyHi_Com)
sciPrev.SetKeywords(0x2, SyHi_Fun)
sciPrev.SetKeywords(0x3, SyHi_Dir)
sciPrev.SetKeywords(0x4, SyHi_Keys)
sciPrev.SetKeywords(0x5, SyHi_BIVar)
sciPrev.SetKeywords(0x6, SyHi_Keyw)
sciPrev.SetKeywords(0x7, SyHi_UserDef)
sciPrev.SetText("", Preview)
sciPrev.SetReadOnly(0x1)

Gui, 2:+Resize +MinSize215x20 +hwndPrevID
Gui, 2:Add, Custom, ClassToolbarWindow32 W400 hwndhtbPrevF gtbPrevF 0x0800 0x0100 0x0040 0x0008
Gui, 2:Add, Custom, ClassScintilla x0 y34 hwndhSciPrevF vLVPrevF
Gui, 2:Add, StatusBar
TB_Define(tbPrevF, htbPrevF, hIL_Icons, FixedBar.PreviewF, FixedBar.PrevOpt)
sciPrevF := new scintilla(hSciPrevF)
sciPrevF.SetCodePage(65001)
sciPrevF.SetMarginWidthN(0x0, 0xA)
sciPrevF.SetMarginWidthN(0x1, 0x5)
sciPrevF.SetMarginTypeN(0x1, 0x2)
sciPrevF.SetWrapMode(TextWrap ? 0x1 : 0x0)
sciPrevF.SetSelBack(true, 0xFFFF80)
sciPrevF.SetCaretLineBack(0xFFFF80)
sciPrevF.SetCaretLineVisible(true)
sciPrevF.SetCaretLineVisibleAlways(true)
sciPrevF.SetLexer(0xC8)
sciPrevF.StyleClearAll()

sciPrevF.StyleSetFore(0x1, 0x2C974B) ; Line comment
sciPrevF.StyleSetFore(0x2, 0x969896) ; Block comment
sciPrevF.StyleSetFore(0x3, 0x183691) ; Escaped Char
sciPrevF.StyleSetFore(0x4, 0xA71D5D) ; Operator
sciPrevF.StyleSetFore(0x5, 0xA71D5D) ; Delimiters
sciPrevF.StyleSetFore(0x6, 0x183691) ; String
sciPrevF.StyleSetFore(0x7, 0x009999) ; Number
sciPrevF.StyleSetFore(0x8, 0x008080) ; Variable
sciPrevF.StyleSetFore(0x9, 0x008080) ; Variable
sciPrevF.StyleSetFore(0xA, 0x8066A8), sciPrevF.StyleSetBold(0xA, 0x1) ; Label && Hotkey
sciPrevF.StyleSetFore(0xB, 0x0086B3), sciPrevF.StyleSetBold(0xB, 0x1) ; Flow of Control
sciPrevF.StyleSetFore(0xC, 0x0086B3) ; Command
sciPrevF.StyleSetFore(0xD, 0xBB5046), sciPrevF.StyleSetBold(0xD, 0x1) ; Built-in Function
sciPrevF.StyleSetFore(0xE, 0x0086B3) ; Directive
sciPrevF.StyleSetFore(0xF, 0x009B4E), sciPrevF.StyleSetBold(0xF, 0x1) ; Key && Button
sciPrevF.StyleSetFore(0x10, 0xCF00CF) ; Built-in Variable
sciPrevF.StyleSetFore(0x11, 0xDD1144) ; Keyword
sciPrevF.StyleSetFore(0x12, 0xF04020), sciPrevF.StyleSetBold(0x12, 0x1) ; User defined
sciPrevF.StyleSetBack(0x14, 0xFFC0C0) ; Syntax Error
sciPrevF.StyleSetFore(0x21, 0x808080), sciPrevF.StyleSetSize(0x21, 0x7) ; Line number

sciPrevF.SetKeywords(0x0, SyHi_Flow)
sciPrevF.SetKeywords(0x1, SyHi_Com)
sciPrevF.SetKeywords(0x2, SyHi_Fun)
sciPrevF.SetKeywords(0x3, SyHi_Dir)
sciPrevF.SetKeywords(0x4, SyHi_Keys)
sciPrevF.SetKeywords(0x5, SyHi_BIVar)
sciPrevF.SetKeywords(0x6, SyHi_Keyw)
sciPrevF.SetKeywords(0x7, SyHi_UserDef)
sciPrevF.SetText("", Preview)
ControlSetText,, %Preview%, ahk_id %hSciPrevF%
sciPrevF.SetReadOnly(0x1)

GoSub, PrevFont

Gui, 2:Default
SB_SetParts(80, 120, 120, 120)
SB_SetText("Macro" A_List ": " o_AutoKey[A_List], 1)
SB_SetText("Record Keys: " RecKey "/" RecNewKey, 2)
SB_SetText("CoordMode: " CoordMouse, 3)
SB_SetText("TitleMatchMode: " TitleMatch, 4)
SB_SetText("SendMode: " KeyMode, 5)
TB_Edit(tbPrev, "PrevRefreshButton", AutoRefresh)
TB_Edit(tbPrevF, "PrevRefreshButton", AutoRefresh)
TB_Edit(tbPrev, "GoToLine", AutoSelectLine)
TB_Edit(tbPrevF, "GoToLine", AutoSelectLine)
TB_Edit(tbPrev, "TextWrap", TextWrap)
TB_Edit(tbPrevF, "TextWrap", TextWrap)
TB_Edit(tbPrev, "TabIndent", TabIndent)
TB_Edit(tbPrevF, "TabIndent", TabIndent)
TB_Edit(tbPrev, "ConvertBreaks", ConvertBreaks)
TB_Edit(tbPrevF, "ConvertBreaks", ConvertBreaks)
TB_Edit(tbPrev, "CommentUnchecked", CommentUnchecked)
TB_Edit(tbPrevF, "CommentUnchecked", CommentUnchecked)
Gui, chMacro:Default
return

MacroFontSet:
MacroFontSize := A_ThisMenuItem
MacroFont:
Gui, 1:Submit, NoHide
Gui, chMacro:Font, s%MacroFontSize%
Loop, %TabCount%
	GuiControl, chMacro:Font, InputList%A_Index%
Loop, 13
	Menu, MacroFontMenu, Uncheck, % A_Index + 5
Menu, MacroFontMenu, Check, %MacroFontSize%
return

PrevFontSet:
PrevFontSize := A_ThisMenuItem
PrevFont:
sciPrev.StyleSetSize(0x0, PrevFontSize)
sciPrev.StyleSetSize(0x1, PrevFontSize)
sciPrev.StyleSetSize(0x2, PrevFontSize)
sciPrev.StyleSetSize(0x3, PrevFontSize)
sciPrev.StyleSetSize(0x4, PrevFontSize)
sciPrev.StyleSetSize(0x5, PrevFontSize)
sciPrev.StyleSetSize(0x6, PrevFontSize)
sciPrev.StyleSetSize(0x7, PrevFontSize)
sciPrev.StyleSetSize(0x8, PrevFontSize)
sciPrev.StyleSetSize(0x9, PrevFontSize)
sciPrev.StyleSetSize(0xA, PrevFontSize)
sciPrev.StyleSetSize(0xB, PrevFontSize)
sciPrev.StyleSetSize(0xC, PrevFontSize)
sciPrev.StyleSetSize(0xD, PrevFontSize)
sciPrev.StyleSetSize(0xE, PrevFontSize)
sciPrev.StyleSetSize(0xF, PrevFontSize)
sciPrev.StyleSetSize(0x10, PrevFontSize)
sciPrev.StyleSetSize(0x11, PrevFontSize)
sciPrev.StyleSetSize(0x12, PrevFontSize)
sciPrev.StyleSetSize(0x13, PrevFontSize)
sciPrev.StyleSetSize(0x14, PrevFontSize)

sciPrevF.StyleSetSize(0x0, PrevFontSize)
sciPrevF.StyleSetSize(0x1, PrevFontSize)
sciPrevF.StyleSetSize(0x2, PrevFontSize)
sciPrevF.StyleSetSize(0x3, PrevFontSize)
sciPrevF.StyleSetSize(0x4, PrevFontSize)
sciPrevF.StyleSetSize(0x5, PrevFontSize)
sciPrevF.StyleSetSize(0x6, PrevFontSize)
sciPrevF.StyleSetSize(0x7, PrevFontSize)
sciPrevF.StyleSetSize(0x8, PrevFontSize)
sciPrevF.StyleSetSize(0x9, PrevFontSize)
sciPrevF.StyleSetSize(0xA, PrevFontSize)
sciPrevF.StyleSetSize(0xB, PrevFontSize)
sciPrevF.StyleSetSize(0xC, PrevFontSize)
sciPrevF.StyleSetSize(0xD, PrevFontSize)
sciPrevF.StyleSetSize(0xE, PrevFontSize)
sciPrevF.StyleSetSize(0xF, PrevFontSize)
sciPrevF.StyleSetSize(0x10, PrevFontSize)
sciPrevF.StyleSetSize(0x11, PrevFontSize)
sciPrevF.StyleSetSize(0x12, PrevFontSize)
sciPrevF.StyleSetSize(0x13, PrevFontSize)
sciPrevF.StyleSetSize(0x14, PrevFontSize)
sciPrevF.StyleSetSize(0x19, PrevFontSize)
return

OnTop:
TB_Edit(tbPrevF, "OnTop", OnTop := !OnTop)
Gui, % (OnTop) ? "2:+AlwaysOnTop" : "2:-AlwaysOnTop"
return

PrevCopy:
PrevPtr := FloatPrev ? sciPrevF : sciPrev
If ((SelCount := PrevPtr.GetSelText(0, 0)) > 1)
{
	VarSetCapacity(PrevSelText, SelCount)
	PrevPtr.GetSelText(0, &PrevSelText)
	PrevSelText := StrGet(&PrevSelText, "UTF-8")
	Clipboard := StrReplace(PrevSelText, "`n", "`r`n")
}
Else
	Clipboard := StrReplace(PrevPtr.GetText(sciPrev.getLength()+1), "`n", "`r`n")
return

PrevRefreshButton:
If (AutoRefresh)
	GoSub, AutoRefresh
Else
	GoSub, PrevRefresh
return

PrevRefresh:
If (!ShowPrev)
	return
PrevPtr := FloatPrev ? sciPrevF : sciPrev
CodeLines := []
Preview := LV_Export(A_List, CodeLines)
PrevPtr.SetReadOnly(0x0), PrevPtr.ClearAll(), PrevPtr.SetText("", Preview)
PrevPtr.ScrollToEnd(), PrevPtr.SetReadOnly(0x1)
calcMargin := StrLen(PrevPtr.GetLineCount())*10
For _row, _line in CodeLines
	LV_Modify(_row, "Col11", _line)
If (calcMargin != lastCalcMargin)
{
	lastCalcMargin := calcMargin
	PrevPtr.SetMarginWidthN(0x0, calcMargin)
}
Gui, 2:Default
SB_SetText("Macro" A_List ": " o_AutoKey[A_List], 1)
SB_SetText("Record Keys: " RecKey "/" RecNewKey, 2)
SB_SetText("CoordMode: " CoordMouse, 3)
SB_SetText("TitleMatchMode: " TitleMatch, 4)
SB_SetText("SendMode: " KeyMode, 5)
Gui, chMacro:Default

If (AutoSelectLine)
	GoSub, GoToLine
return

GoToLine:
If (Capt || Record || !ShowPrev)
	return
Gui, chMacro:Default
GoRowSelection := LV_GetCount("Selected")
If (GoRowSelection = 0)
	return
GoSelectedRow := LV_GetNext()
LV_GetText(CodeLineStart, GoSelectedRow, 11)
GoRowNumber := 0
Loop, %GoRowSelection%
	GoRowNumber := LV_GetNext(GoRowNumber)
LV_GetText(CodeNextLine, GoRowNumber + 1, 11)
CodeLineStart--
CodeNextLine--
sciPrev.GoToLine(CodeLineStart)
sciPrevF.GoToLine(CodeLineStart)
If ((GoRowSelection > 1) || (CodeNextLine <= 0) || ((CodeNextLine - CodeLineStart) > 1))
{
	GoRowNumber := 0
	Loop, %GoRowSelection%
		GoRowNumber := LV_GetNext(GoRowNumber)
	LastRowSelected := GoRowNumber = LV_GetCount()
	GoRowNumber := LastRowSelected ? GoRowNumber : GoRowNumber + 1
	CaretPos := sciPrev.PositionFromLine(CodeLineStart)
	Anchor := (CodeNextLine > 0 ? sciPrev.PositionFromLine(CodeNextLine) : sciPrev.GetLength()) - 1
	sciPrev.SetSel(Anchor, CaretPos)
	sciPrevF.SetSel(Anchor, CaretPos)
}
return

TextWrap:
ConvertBreaks:
TabIndent:
CommentUnchecked:
ShowGroupNames:
TB_Edit(tbPrev, A_ThisLabel, %A_ThisLabel% := !%A_ThisLabel%)
TB_Edit(tbPrevF, A_ThisLabel, %A_ThisLabel%)
sciPrev.SetWrapMode(TextWrap ? 0x1 : 0x0), sciPrevF.SetWrapMode(TextWrap ? 0x1 : 0x0)
GoSub, PrevRefresh
Menu, PreviewMenu, % (TabIndent) ? "Check" : "Uncheck", %v_Lang033%
Menu, PreviewMenu, % (ConvertBreaks) ? "Check" : "Uncheck", %v_Lang036%
Menu, PreviewMenu, % (CommentUnchecked) ? "Check" : "Uncheck", %v_Lang037%
Menu, PreviewMenu, % (TextWrap) ? "Check" : "Uncheck", %v_Lang038%
Menu, PreviewMenu, % (ShowGroupNames) ? "Check" : "Uncheck", %v_Lang039%
return

PrevFontShow:
PrevFontSize := PrevFontSize + 1
If (PrevFontSize > 18)
	PrevFontSize := 6
GoSub, PrevFont
return

IndentWith:
If ((A_ThisMenuItemPos = 2) || (A_ThisMenuItemPos = 9))
	IndentWith := "Tab"
Else
	IndentWith := "Space"
GoSub, PrevRefresh
If (IndentWith = "Tab")
{
	Menu, PreviewMenu, Uncheck, %v_Lang034%
	Menu, PreviewMenu, Check, %v_Lang035%
}
Else
{
	Menu, PreviewMenu, Uncheck, %v_Lang035%
	Menu, PreviewMenu, Check, %v_Lang034%
}
return

AutoRefresh:
TB_Edit(tbPrev, "PrevRefreshButton", AutoRefresh := !AutoRefresh)
TB_Edit(tbPrevF, "PrevRefreshButton", AutoRefresh)
GoSub, PrevRefresh
Menu, PreviewMenu, % (AutoRefresh) ? "Check" : "Uncheck", %v_Lang031%
return

AutoSelectLine:
TB_Edit(tbPrev, "GoToLine", AutoSelectLine := !AutoSelectLine)
TB_Edit(tbPrevF, "GoToLine", AutoSelectLine)
Menu, PreviewMenu, % (AutoSelectLine) ? "Check" : "Uncheck", %v_Lang032%
return

PrevClose:
2GuiClose:
2GuiEscape:
GuiGetSize(pGuiWidth, pGuiHeight, 2), PrevWinSize := "W" pGuiWidth " H" pGuiHeight
TB_Edit(TbFile, "Preview", ShowPrev := 0), FloatPrev := 0
Menu, ViewMenu, UnCheck, %v_Lang002%
Gui, 2:Hide
return

EditScript:
If (!DontShowEdt)
{
	Gui, 1:+Disabled
	Gui, 35:-SysMenu +HwndTipScrID +owner1
	Gui, 35:Color, FFFFFF
	Gui, 35:Add, Pic, y+20 Icon78 W48 H48, %ResDllPath%
	Gui, 35:Add, Text, -Wrap R1 yp x+10, %d_Lang087%`n
	Gui, 35:Add, Checkbox, -Wrap W300 vDontShowEdt R1, %d_Lang053%
	Gui, 35:Add, Button, -Wrap Default y+10 W90 H23 gTipClose2, %c_Lang020%
	Gui, 35:Show,, %AppName%
	WinWaitClose, ahk_id %TipScrID%
	Gui, 1:-Disabled
}
EdPreview := LV_Export(A_List)
If (EdPreview = "")
	return
ExFileName := "PMC_" A_Now ".ahk"
FileAppend, %EdPreview%, %A_Temp%\%ExFileName%, UTF-8
Run, %DefaultEditor% %A_Temp%\%ExFileName%, %A_Temp%
return

;##### Recording: #####

Record:
Pause, Off
Tooltip
Gui, 1:+OwnDialogs
Gui, 1:Submit, NoHide
StopIt := 1
ActivateHotKeys(1, 0, 0,, 1)
If (HideMainWin)
	GoSub, ShowHide
Else
{
	WinMinimize, ahk_id %PMCWinID%
	WinActivate,,, ahk_id %PMCWinID%
}
If (!DontShowRec)
{
	Gui 26:+LastFoundExist
	IfWinExist
		GoSub, TipClose
	Gui, 26:-SysMenu +HwndTipScrID
	Gui, 26:Color, FFFFFF
	Gui, 26:Add, Pic, y+20 Icon29 W48 H48, %ResDllPath%
	Gui, 26:Add, Text, -Wrap R1 yp x+10, %d_Lang052%`n`n- %RecKey% %d_Lang026%`n- %RecNewKey% %d_Lang030%`n`n%d_Lang043%`n
	Gui, 26:Add, Checkbox, Section -Wrap W300 vDontShowRec R1 cGray, %d_Lang053%
	Gui, 26:Add, Button, -Wrap Default xs y+10 W90 H23 gTipClose, %c_Lang020%
	Gui, 26:Show,, %AppName%
}
If (ShowStep)
	Traytip, %AppName%, %RecKey% %d_Lang026%.`n%RecNewKey% %d_Lang030%.,,1
If (OnScCtrl)
	GoSub, ShowControls
return

RemoveToolTip:
ToolTip
return

RecStartNew:
GoSub, RecStop
ActivateHotkeys(1)
Pause, Off
If (ClearNewList)
{
	LV_Delete()
	LVManager[A_List].RemoveAllGroups(c_Lang061)
}
Else
{
	GoSub, RowCheck
	GoSub, b_Start
	GoSub, TabPlus
}
RecStart:
ActivateHotkeys(1)
Gui, chMacro:Default
Gui, chMacro:Listview, InputList%A_List%
Pause, Off
Input
If (Record := !Record)
{
	GuiControl, chMacro:-g, InputList%A_List%
	p_Title := "", p_Class := ""
	Hotkey, ~*WheelUp, MWUp, On
	Hotkey, ~*WheelDown, MWDn, On
	mScUp := 0, mScDn := 0
	CoordMode, Mouse, %CoordMouse%
	MouseGetPos, xPos, yPos
	LastPos := xPos "/" yPos
	LastTime := A_TickCount
	SetTimer, MouseRecord, 0
	If ((WClass = 1) || (WTitle = 1))
		WindowRecord(A_List, DelayW)
	If (Strokes = 1)
		SetTimer, KeyboardRecord, -1
	Tooltip
	If (ShowStep)
		Traytip, %AppName%, Macro%A_List%: %d_Lang028% %RecKey% %d_Lang029%.,,1
	Try Menu, Tray, Icon, %ResDllPath%, 54
	Menu, Tray, Default, %w_Lang008%
	tbOSC.ModifyButtonInfo(5, "Image", 65)
}
Else
{
	GuiControl, chMacro:+gInputList, InputList%A_List%
	GoSub, RecStop
	GoSub, RowCheck
	GoSub, b_Start
	GoSub, PlayActive
	ActivateHotKeys(1)
	If (ShowStep)
		Traytip, %AppName%, % d_Lang027
		. ".`nMacro" A_List ": " o_AutoKey[A_List],,1
	tbOSC.ModifyButtonInfo(5, "Image", 54)
	If (AutoRefresh = 1)
		GoSub, PrevRefresh
}
return

RecStop:
Gui, chMacro:Default
Pause, Off
Record := 0, KeyboardRecord := 0
Input
Tooltip
Traytip
Hotkey, ~*WheelUp, MWUp, off
Hotkey, ~*WheelDown, MWDn, off
SetTimer, MouseRecord, off
If ((!WinActive("ahk_id" PMCWinID)) && (KeepHkOn = 1))
	GoSub, KeepHkOn
Try Menu, Tray, Icon, %DefaultIcon%, 1
Try Menu, Tray, Default, %w_Lang005%
tbOSC.ModifyButtonInfo(5, "Image", 54)
return

;##### Subroutines: Menus & Buttons #####

New:
Gui, 1:+OwnDialogs
If (SavePrompt)
{
	MsgBox, 35, %d_Lang005%, % d_Lang002 "`n`n" (CurrentFileName ? """" CurrentFileName """" : "")
	IfMsgBox, Yes
		GoSub, Save
	IfMsgBox, Cancel
		return
}
Input
GoSub, DelLists
GuiControl, chMacro:, A_List, |Macro1
CopyMenuLabels := ["Macro1"]
LVManager.RemoveAt(1, TabCount)
Loop, %TabCount%
	o_MacroContext[A_Index] := {"Condition": "None", "Context": ""}
LVManager[1] := new LV_Rows(ListID1)
LVManager[1].Add()
TabCount := 1
Gui, 1:Submit, NoHide
Gui, chMacro:Submit, NoHide
If (KeepDefKeys = 1)
{
	AutoKey := DefAutoKey, ManKey := DefManKey
	GoSub, ObjCreate
}
GoSub, LoadData
GoSub, KeepHkOn
GuiControl, 1:, Capt, 0
GuiControl, 1:, TimesG, 1
IfDirectContext := "None"
IfDirectWindow := ""
GuiControl, 1:, ContextTip, Global <a>#If</a>: %IfDirectContext%
CurrentFileName := ""
Gui, 1:Show, % ((WinExist("ahk_id" PMCWinID)) ? "" : "Hide"), %AppName% v%CurrentVersion%
GuiControl, chMacro:Focus, InputList%A_List%
GoSub, b_Enable
FreeMemory()
OnFinishCode := 1
SetWorkingDir %A_ScriptDir%
GoSub, SetFinishButton
GoSub, RecentFiles
GoSub, PrevRefresh
SetTimer, FinishIcon, -1
SavePrompt(false, A_ThisLabel)
GoSub, MacroTab
return

GuiDropFiles:
Gui, chMacro:Default
Gui, chMacro:Submit, NoHide
Gui, 1:+OwnDialogs
Gui, 1:Submit, NoHide
GoSub, SaveData
If (SavePrompt, A_ThisLabel)
{
	MsgBox, 35, %d_Lang005%, % d_Lang002 "`n`n" (CurrentFileName ? """" CurrentFileName """" : "")
	IfMsgBox, Yes
	{
		GoSub, Save
		IfMsgBox, Cancel
			return
	}
	IfMsgBox, Cancel
		return
}
AutoRefreshState := AutoRefresh, AutoRefresh := 0
GpConfig := ShowGroups, ShowGroups := false
LVManager[A_List].EnableGroups(false)
PMC.Import(A_GuiEvent)
GoSub, UpdateCopyTo
GoSub, SetFinishButton
CurrentFileName := LoadedFileName
GoSub, FileRead
GoSub, RecentFiles
return

Open:
Gui, 1:+OwnDialogs
If (SavePrompt, A_ThisLabel)
{
	MsgBox, 35, %d_Lang005%, % d_Lang002 "`n`n" (CurrentFileName ? """" CurrentFileName """" : "")
	IfMsgBox, Yes
		GoSub, Save
	IfMsgBox, Cancel
		return
}
Input
FileSelectFile, SelectedFileName, M3,, %d_Lang001%, %d_Lang004% (*.pmc)
FreeMemory()
If (!SelectedFileName)
	return
Loop, Parse, SelectedFileName, `n
{
	If (A_Index = 1)
		FilePath := RTrim(A_LoopField, "\") "\"
	Else
		Files .= FilePath . A_LoopField "`n"
}
Files := RTrim(Files, "`n")
OpenFile:
AutoRefreshState := AutoRefresh, AutoRefresh := 0
GpConfig := ShowGroups, ShowGroups := false
LVManager[A_List].EnableGroups(false)
GoSub, ClearHistory
Sleep, 100
PMC.Import(Files)
GoSub, UpdateCopyTo
GoSub, SetFinishButton
CurrentFileName := LoadedFileName, Files := ""
; GoSub, b_Start
GoSub, FileRead
GoSub, RowCheck
GoSub, RecentFiles
return

FileRead:
GoSub, b_Enable
Gui, chMacro:Default
Gui, chMacro:Listview, InputList%A_List%
GuiControl, 1:, Capt, 0
Gui, 1:Show, % ((WinExist("ahk_id" PMCWinID)) ? "" : "Hide"), % (CurrentFileName ? CurrentFileName " - " : "") AppName " v" CurrentVersion
SplitPath, CurrentFileName,, wDir
SetWorkingDir %wDir%
Gui, chMacro:Submit, NoHide
ShowGroups := GpConfig
GoSub, chMacroGuiSize
GoSub, RowCheck
GoSub, b_Enable
GoSub, LoadData
AutoRefresh := AutoRefreshState
GoSub, PrevRefresh
Gui, chMacro:Default
Gui, chMacro:Listview, InputList%A_List%
GuiControl, chMacro:Focus, InputList%A_List%
SavePrompt(false, A_ThisLabel)
If (InStr(CopyMenuLabels[A_List], "()"))
	GoSub, FuncTab
Else
	GoSub, MacroTab
return

Import:
Gui, chMacro:Default
Gui, 1:+OwnDialogs
FileSelectFile, SelectedFileName, M3,, %d_Lang001%, %d_Lang004% (*.pmc)
FreeMemory()
If (!SelectedFileName)
	return
Files := ""
Loop, Parse, SelectedFileName, `n
{
	If (A_Index = 1)
		FilePath := A_LoopField "\"
	Else
		Files .= FilePath . A_LoopField "`n"
}
Files := RTrim(Files, "`n")
AutoRefreshState := AutoRefresh, AutoRefresh := 0
GpConfig := ShowGroups, ShowGroups := false
LVManager[A_List].EnableGroups(false)
PMC.Import(Files,, 0)
GoSub, UpdateCopyTo
GoSub, SetFinishButton
Files := ""
GuiControl, chMacro:Choose, A_List, %TabCount%
Gui, chMacro:Submit, NoHide
Gui, 1:Submit, NoHide
GoSub, LoadData
GoSub, RowCheck
GuiControl, chMacro:Focus, InputList%A_List%
AutoRefresh := AutoRefreshState
ShowGroups := GpConfig
GoSub, PrevRefresh
GoSub, b_Enable
GoSub, RecentFiles
GoSub, chMacroGuiSize
If (InStr(CopyMenuLabels[A_List], "()"))
	GoSub, FuncTab
Else
	GoSub, MacroTab
return

SaveAs:
Input
ActiveFileName := CurrentFileName
GoSub, SelectFile
GoSub, Save
return

SelectFile:
Gui 1:+OwnDialogs
FileSelectFile, SelectedFileName, S16, %CurrentFileName%, %d_Lang005%, %d_Lang004% (*.pmc)
FreeMemory()
If (SelectedFileName = "")
{
	CurrentFileName := ActiveFileName
	Exit
}
SplitPath, SelectedFileName, fileName, wDir, ext
If (ext != "pmc")
{
	SelectedFileName .= ".pmc"
	IfExist, %SelectedFileName%
	{
		MsgBox, 308, %d_Lang110%, %fileName%.pmc %d_Lang111%
		IfMsgBox, No, Exit
	}
}
CurrentFileName := SelectedFileName
GoSub, RecentFiles
return

Save:
Input
GoSub, SaveData
ActiveFileName := CurrentFileName
If (CurrentFileName = "")
	GoSub, SelectFile
IfExist %CurrentFileName%
{
	FileDelete %CurrentFileName%
	If (ErrorLevel)
	{
		MsgBox, 16, %d_Lang007%, %d_Lang006%`n`n"%CurrentFileName%".
		return
	}
}
Gui, chMacro:Default
SaveProject(CurrentFileName)
Gui, 1:Show, % ((WinExist("ahk_id" PMCWinID)) ? "NA" : "Hide"), % (CurrentFileName ? CurrentFileName " - " : "") AppName " v" CurrentVersion
SplitPath, CurrentFileName,, wDir
SetWorkingDir %wDir%
SavePrompt(false, A_ThisLabel)
GoSub, RecentFiles
return

SaveCurrentList:
Input
ActiveFileName := CurrentFileName, CurrentFileName := CopyMenuLabels[A_List] ".pmc"
GoSub, SaveData
GoSub, SelectFile
ThisListFile := CurrentFileName, CurrentFileName := ActiveFileName
IfExist %ThisListFile%
{
	FileDelete, %ThisListFile%
	If (ErrorLevel)
	{
		MsgBox, 16, %d_Lang007%, %d_Lang006% "%ThisListFile%".
		return
	}
}
PMCSet := "[PMC Code v" CurrentVersion "]|" o_AutoKey[A_List]
. "|" o_ManKey[A_List] "|" o_TimesG[A_List]
. "|" CoordMouse "," TitleMatch "," TitleSpeed "," HiddenWin "," HiddenText "," KeyMode "," KeyDelay "," MouseDelay "," ControlDelay "|" OnFinishCode "|" CopyMenuLabels[A_List] "`n"
IfContext := "Context=" o_MacroContext[A_List].Condition "|" o_MacroContext[A_List].Context "`n"
TabGroups := "Groups=" LVManager[A_List].GetGroups() "`n"
LV_Data := PMCSet . IfContext . TabGroups . PMC.LVGet("InputList" A_List).Text . "`n"
FileAppend, %LV_Data%, %ThisListFile%
GoSub, RecentFiles
return

ProjBackup:
If (!SavePrompt)
	return
If ((Record) || (BackupFound))
	return
BackupFileName := SettingsFolder "\~ActiveProject.pmc"
FileDelete, %BackupFileName%
SaveProject(BackupFileName, False)
return

RecentFiles:
If (PmcRecentFiles != "")
{
	Loop, Parse, PmcRecentFiles, `n
		Menu, RecentMenu, Delete, %A_Index%: %A_LoopField%
}
PmcRecentFiles := ""
AddRecentFiles:
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
Gui, 1:+OwnDialogs
If (SavePrompt)
{
	MsgBox, 35, %d_Lang005%, % d_Lang002 "`n`n" (CurrentFileName ? """" CurrentFileName """" : "")
	IfMsgBox, Yes
		GoSub, Save
	IfMsgBox, Cancel
		return
}
Input
File := RegExReplace(A_ThisMenuItem, "^\d+:\s")
If (!FileExist(File))
{
	MsgBox, 16, %d_Lang007%, %d_Lang082%`n"%File%"
	return
}
AutoRefreshState := AutoRefresh, AutoRefresh := 0
GpConfig := ShowGroups, ShowGroups := false
LVManager[A_List].EnableGroups(false)
GoSub, ClearHistory
Sleep, 100
PMC.Import(File)
GoSub, UpdateCopyTo
GoSub, SetFinishButton
CurrentFileName := LoadedFileName, Files := ""
; GoSub, b_Start
GoSub, FileRead
GoSub, RowCheck
return

Export:
Input
If (DebugCheckError)
{
	GoSub, b_Enable
	return
}
Gui, 1:Submit, NoHide
GoSub, SaveData
SplitPath, CurrentFileName, name, dir, ext, name_no_ext, drive
If (!A_AhkPath)
	Exe_Exp := 0
UserVarsList := User_Vars.Get(,, true, true, "global "), CheckedVars := []
Gui, 14:+owner1 -MinimizeBox +E0x00000400 +Delimiter%_x% +HwndCmdWin
Gui, 14:Default
Gui, 1:+Disabled
Gui, 14:Add, Tab3, W475 H460 vTabControl AltSubmit, %w_Lang001%%_x%%w_Lang003%
; Macros
Gui, 14:Add, GroupBox, Section W450 H190, %t_Lang002%:
Gui, 14:Add, ListView, ys+20 xs+10 AltSubmit Checked W430 r5 vExpList gExpEdit NoSort -ReadOnly LV0x4000, %t_Lang147%%_x%%w_Lang005%%_x%%t_Lang003%%_x%%t_Lang006%%_x%%w_Lang030%
Gui, 14:Add, Text, -Wrap W430, %t_Lang144%
Gui, 14:Add, Button, -Wrap W75 H23 gCheckAll, %t_Lang007%
Gui, 14:Add, Button, -Wrap yp x+5 W75 H23 gUnCheckAll, %t_Lang008%
Gui, 14:Add, Text, yp x+5 h25 0x11
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_AbortKey% yp+5 x+0 W65 vEx_AbortKey gEx_Checks R1, %w_Lang008%:
Gui, 14:Add, Hotkey, yp-5 x+0 W60 vAbortKey, %AbortKey%
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_PauseKey% yp+5 x+10 W65 vEx_PauseKey R1, %t_Lang081%:
Gui, 14:Add, Hotkey, yp-5 x+0 W60 vPauseKey, %PauseKey%
; Context
Gui, 14:Add, GroupBox, Section y+16 xs W450 H80
Gui, 14:Add, Checkbox, -Wrap Section ys xs vEx_IfDir gEx_Checks R1, %t_Lang009%:
Gui, 14:Add, DDL, xs+10 W105 vEx_IfDirType Disabled, #IfWinActive%_x%%_x%#IfWinNotActive%_x%#IfWinExist%_x%#IfNotWinExist%_x%#If
Gui, 14:Add, Button, yp x+250 W75 vIdent gWinTitle Disabled, WinTitle
Gui, 14:Add, Edit, -Wrap R1 xs+10 W400 vTitle Disabled
Gui, 14:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetWin gGetWin Disabled, ...
; Location and Style
Gui, 14:Add, GroupBox, Section y+16 xs W450 H140, %t_Lang010%:
Gui, 14:Add, Edit, -Wrap R1 ys+20 xs+10 W340 vExpFile -Multi, %dir%\%name_no_ext%.ahk
Gui, 14:Add, Button, -Wrap W30 H23 yp-1 x+0 gExpSearch, ...
Gui, 14:Add, Button, yp x+5 H23 W25 hwndEx_EdScript vEx_EdScript gExEditScript
	ILButton(Ex_EdScript, ResDllPath ":" 109)
Gui, 14:Add, Button, yp x+5 H23 W25 hwndEx_ExecScript vEx_ExecScript gExExecScript
	ILButton(Ex_ExecScript, ResDllPath ":" 58)
Gui, 14:Add, Checkbox, -Wrap Checked%TabIndent% ys+50 xs+10 W230 vTabIndent R1, %t_Lang011%
Gui, 14:Add, Checkbox, -Wrap Checked%CommentUnchecked% y+5 xs+10 W230 vCommentUnchecked R1, %w_Lang108%
Gui, 14:Add, Checkbox, -Wrap Checked%Send_Loop% y+5 xs+10 W230 vSend_Loop R1, %t_Lang013%
Gui, 14:Add, Checkbox, -Wrap Checked%ConvertBreaks% ys+50 x+5 W190 vConvertBreaks R1, %t_Lang190%
Gui, 14:Add, Checkbox, -Wrap Checked%IncPmc% y+5 xp W190 vIncPmc R1, %t_Lang012%
Gui, 14:Add, Checkbox, -Wrap Checked%Exe_Exp% y+5 xp W190 vExe_Exp gExeExp R1,%t_Lang088%
Gui, 14:Add, Text, -Wrap R1 y+5 xs+10 W155, %t_Lang221%:
Gui, 14:Add, Edit, -Wrap R1 yp x+5 W240 vExpIcon -Multi Disabled, %ExpIcon%
Gui, 14:Add, Button, -Wrap W30 H23 yp-1 x+0 vExpIconSearch gExpIconSearch Disabled, ...
If (Exe_Exp)
{
	GuiControl, 14:Enable, ExpIcon
	GuiControl, 14:Enable, ExpIconSearch
}
Gui, 14:Tab, 2
; Options
Gui, 14:Add, GroupBox, Section ym+28 xm+12 W450 H420, %w_Lang003%:
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_SI% yS+30 xs+10 W140 vEx_SI R1, #SingleInstance
Gui, 14:Add, DDL, yp-3 x+5 vSI w75, Force%_x%Ignore%_x%%_x%Off
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_ST% y+5 xs+10 W140 vEx_ST R1, SetTitleMatchMode
Gui, 14:Add, DDL, yp-3 x+5 vST w75, 1%_x%2%_x%%_x%3%_x%RegEx
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_SP% y+5 xs+10 W140 vEx_SP R1, SetTitleMatchMode
Gui, 14:Add, DDL, yp-3 x+5 vSP w75, Fast%_x%%_x%Slow
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_CM% y+5 xs+10 W140 vEx_CM R1, CoordMode, Mouse
Gui, 14:Add, DDL, yp-3 x+5 vCM w75, Window%_x%%_x%Screen%_x%Client
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_DH% y+5 xs+10 W140 vEx_DH R1, DetectHiddenWindows
Gui, 14:Add, DDL, yp-3 x+5 vDH w75, On%_x%Off%_x%%_x%
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_DT% y+5 xs+10 W140 vEx_DT R1, DetectHiddenText
Gui, 14:Add, DDL, yp-3 x+5 vDT w75, On%_x%%_x%Off
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_AF% y+8 xs+10 W220 vEx_AF R1, #WinActivateForce
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_PT% y+5 xs+10 W220 vEx_PT R1, #Persistent
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_HK% y+5 W220 vEx_HK R1, #UseHook
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_SM% ys+30 xs+245 W115 vEx_SM R1, SendMode
Gui, 14:Add, DDL, yp-3 x+5 vSM w75, Input%_x%%_x%Play%_x%Event%_x%InputThenPlay
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_SK% y+5 xs+245 W140 vEx_SK R1, SetKeyDelay
Gui, 14:Add, Edit, Limit Number -Wrap R1 yp-3 x+5 W50
Gui, 14:Add, UpDown, vSK 0x80 Range-1-1000, %KeyDelay%
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_MD% y+5 xs+245 W140 vEx_MD R1, SetMouseDelay
Gui, 14:Add, Edit, Limit Number -Wrap R1 yp-3 x+5 W50
Gui, 14:Add, UpDown, vMD 0x80 Range-1-1000, %MouseDelay%
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_SC% y+5 xs+245 W140 vEx_SC R1, SetControlDelay
Gui, 14:Add, Edit, Limit Number -Wrap R1 yp-3 x+5 W50
Gui, 14:Add, UpDown, vSC 0x80 Range-1-1000, %ControlDelay%
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_SW% y+5 xs+245 W140 vEx_SW R1, SetWinDelay
Gui, 14:Add, Edit, Limit Number -Wrap R1 yp-3 x+5 W50
Gui, 14:Add, UpDown, vSW 0x80 Range-1-1000, %SW%
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_SB% y+5 xs+245 W140 vEx_SB R1, SetBatchLines
Gui, 14:Add, Edit, Limit Number -Wrap R1 yp-3 x+5 W50
Gui, 14:Add, UpDown, vSB 0x80 Range-1-1000, %SB%
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_MT% y+5 xs+245 W140 vEx_MT R1, #MaxThreadsPerHotkey
Gui, 14:Add, Edit, Limit Number -Wrap R1 yp-3 x+5 W50
Gui, 14:Add, UpDown, vMT 0x80 Range1-255, %MT%
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_NT% y+1 xs+245 W200 vEx_NT R1, #NoTrayIcon
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_WN% y+5 xs+245 W200 vEx_WN R1, #Warn
Gui, 14:Add, Text, y+20 xs+10 W430 H2 0x10
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_IN% y+20 xs+10 W230 vEx_IN R1, `#`Include (%t_Lang087%)
Gui, 14:Add, Checkbox, -Wrap Checked%Ex_UV% yp x+5 W165 vEx_UV gEx_Checks R1, Global Variables
Gui, 14:Add, Button, yp-5 xp+170 H23 W25 hwndEx_EdVars vEx_EdVars gVarsTree Disabled
	ILButton(Ex_EdVars, ResDllPath ":" 73)
Gui, 14:Add, Text, -Wrap R1 y+20 xs+10 W80, %t_Lang101%:
Gui, 14:Add, Text, -Wrap R1 yp xs+90 W50, %t_Lang102%
Gui, 14:Add, Slider, yp-10 xs+140 H35 W180 Center TickInterval Range-8-8 vEx_Speed gSpeedTip, %Ex_Speed%
Gui, 14:Add, Text, -Wrap R1 yp+10 xs+350 W50, %t_Lang103%
Gui, 14:Add, Text, -Wrap R1 yp x+5 W35 vEx_SpeedTip, % RTrim(Round((2 ** Ex_Speed), 3), ".0") "x"
Gui, 14:Add, Text, -Wrap R1 y+30 xs+10 W105, COM Objects:
Gui, 14:Add, Radio, -Wrap Checked%ComCr% yp x+5 W120 vComCr R1, ComObjCreate
Gui, 14:Add, Radio, -Wrap Checked%ComAc% yp x+5 W120 vComAc R1, ComObjActive
Gui, 14:Add, Link, -Wrap R1 y+15 xs+10 W400 gDefaultExOpt, <a>%t_Lang063%</a>
Gui, 14:Tab
; Export button
Gui, 14:Add, Button, -Wrap Section Default xm W75 H23 hwndExpButton gExpButton, %w_Lang001%
	ILButton(ExpButton, ResDllPath ":" 16,, "left")
Gui, 14:Add, Button, -Wrap ys W75 H23 gExpClose, %c_Lang022%
Gui, 14:Add, Progress, ys W305 H20 vExpProgress

GuiControl, 14:ChooseString, SI, %SI%
GuiControl, 14:ChooseString, ST, %TitleMatch%
GuiControl, 14:ChooseString, SP, %TitleSpeed%
GuiControl, 14:ChooseString, CM, %CoordMouse%
GuiControl, 14:ChooseString, DH, % HiddenWin ? "On" : "Off"
GuiControl, 14:ChooseString, DT, % HiddenText ? "On" : "Off"
GuiControl, 14:ChooseString, SM, %KeyMode%
GuiControl, 14:ChooseString, IN, %IN%
GoSub, Ex_Checks
If (IfDirectContext != "None")
{
	GuiControl, 14:, Ex_IfDir, 1
	If (IfDirectContext = "Expression")
		GuiControl, 14:Choose, Ex_IfDirType, 5
	Else
		GuiControl, 14:ChooseString, Ex_IfDirType, #If%IfDirectContext%
	GuiControl, 14:, Title, %IfDirectWindow%
	GoSub, Ex_Checks
}
LV_Delete()
Loop, %TabCount%
	LV_Add("Check", CopyMenuLabels[A_Index], (A_GuiControl = "SchedOK") ? "" : o_AutoKey[A_Index], o_TimesG[A_Index], (BckIt%A_Index% ? 1 : 0), A_Index)
LV_ModifyCol(1, 120)	; Macros
LV_ModifyCol(2, 100)	; Hotkeys
LV_ModifyCol(3, 60)		; Loop
LV_ModifyCol(4, 80)		; Block
LV_ModifyCol(5, 40)		; Index
LV_Modify(0, "Check")
If (CurrentFileName = "")
	GuiControl, 14:, ExpFile, %A_MyDocuments%\MyScript.ahk
Gui, 14:Show, % (A_GuiControl = "SchedOK") ? "Hide" : "", %t_Lang001%
ChangeIcon(hIL_Icons, CmdWin, IconsNames["export"])
Tooltip
return

ExpEdit:
Gui, 14:+OwnDialogs
If (A_GuiEvent == "E")
{
	InEdit := 1
	EditRow := LV_GetNext(0, "Focused")
	LV_GetText(BeforeEdit, EditRow, 1)
	return
}
If (A_GuiEvent == "e")
{
	InEdit := 0
	If (InStr(BeforeEdit, "()"))
	{
		LV_Modify(EditRow,, BeforeEdit)
		return
	}
	LV_GetText(AfterEdit, EditRow, 1)
	If (AfterEdit = "")
		return
	Else If (!RegExMatch(AfterEdit, "^\w+$"))
	{
		LV_Modify(EditRow,, BeforeEdit)
		MsgBox, 16, %d_Lang007%, %d_Lang049%
		return
	}
	Else
	{
		Loop, % LV_GetCount()
		{
			LV_GetText(mLabel, A_Index, 1)
			If ((A_Index != EditRow) && (mLabel = AfterEdit))
			{
				LV_Modify(EditRow,, BeforeEdit)
				MsgBox, 16, %d_Lang007%, %d_Lang050%
				return
			}
		}
	}
	return
}
If (A_GuiEvent = "D")
	LV_Rows.Drag()
If (A_GuiEvent != "DoubleClick")
	return
If (LV_GetCount("Selected") = 0)
	return
RowNumber := LV_GetNext()
LV_GetText(Ex_Macro, RowNumber, 1)
LV_GetText(Ex_AutoKey, RowNumber, 2)
LV_GetText(Ex_TimesX, RowNumber, 3)
LV_GetText(Ex_BM, RowNumber, 4)
Gui, 13:+owner14 +ToolWindow +Delimiter%_x% +HwndExLVEdit
Gui, 14:Default
Gui, 14:+Disabled
Gui, 13:Add, GroupBox, Section xm W270 H105
Gui, 13:Add, Edit, ys+15 xs+10 W140 vEx_Macro, %Ex_Macro%
Gui, 13:Add, Checkbox, -Wrap Checked%Ex_BM% yp+3 x+10 W100 vEx_BM R1, %t_Lang006%
Gui, 13:Add, Hotkey, W100 y+15 xm+30 vEx_AutoKey, %Ex_AutoKey%
Gui, 13:Add, Combobox, W100 yp x+30 vEx_AutoKeyL gAutoComplete Disabled, %KeybdList%
Gui, 13:Add, Radio, W25 yp+5 xm+5 Checked vEx_AutoKeyFromH gExHotkey
Gui, 13:Add, Radio, W25 yp xm+135 vEx_AutoKeyFromL gExHotkey
Gui, 13:Add, Text, -Wrap y+13 xs+10 W60 R1 Right, %t_Lang003%:
Gui, 13:Add, Edit, yp-3 x+10 Limit Number W70 R1 vEx_TE
Gui, 13:Add, UpDown, 0x80 Range0-999999999 vEx_TimesX, %Ex_TimesX%
Gui, 13:Add, Text, -Wrap R1 yp+3 x+10 , %t_Lang004%
Gui, 13:Add, Button, Section Default -Wrap xm W75 H23 gExpEditOK, %c_Lang020%
Gui, 13:Add, Button, -Wrap ys W75 H23 gExpEditCancel, %c_Lang021%
Gui, 13:Add, Updown, ys x+60 W50 H20 Horz vExpSel gExpSelList Range0-1
If (InStr(KeybdList, Ex_AutoKey _x))
	GuiControl, 13:ChooseString, Ex_AutoKeyL, %Ex_AutoKey%
Else
	GuiControl, 13:, Ex_AutoKeyL, %Ex_AutoKey%%_x%%_x%
If (InStr(Ex_Macro, "()"))
{
	GuiControl, 13:Disable, Ex_Macro
	GuiControl, 13:Disable, Ex_AutoKey
	GuiControl, 13:Disable, Ex_AutoKeyL
	GuiControl, 13:Disable, Ex_AutoKeyFromH
	GuiControl, 13:Disable, Ex_AutoKeyFromL
	GuiControl, 13:Disable, Ex_BM
	GuiControl, 13:Disable, Ex_TE
	GuiControl, 13:Disable, Ex_TimesX
}
Gui, 13:Show,, %w_Lang019%
return

13GuiClose:
13GuiEscape:
ExpEditCancel:
Gui, 14:-Disabled
Gui, 13:Destroy
Gui, 14:Default
return

ExpEditOK:
Gui, 13:+OwnDialogs
Gui, 13:Submit, NoHide
Gui, 14:Default
If (Ex_Macro != "")
{
	If ((!InStr(Ex_Macro, "()")) && (!RegExMatch(Ex_Macro, "^\w+$")))
	{
		MsgBox, 16, %d_Lang007%, %d_Lang049%
		return
	}
	Else If (!InStr(Ex_Macro, "()"))
	{
		Loop, % LV_GetCount()
		{
			LV_GetText(mLabel, A_Index, 1)
			If ((A_Index != RowNumber) && (mLabel = Ex_Macro))
			{
				MsgBox, 16, %d_Lang007%, %d_Lang050%
				return
			}
		}
	}
}
Gui, 14:-Disabled
Gui, 13:Destroy
Ex_AutoKey := Ex_AutoKeyFromH ? Ex_AutoKey : Ex_AutoKeyL
LV_Modify(RowNumber,, Ex_Macro, Ex_AutoKey, Ex_TimesX, Ex_BM)
return

ExHotkey:
Gui, 13:Submit, NoHide
If (Ex_AutoKeyFromH)
{
	GuiControl, 13:Enable, Ex_AutoKey
	GuiControl, 13:Disable, Ex_AutoKeyL
}
Else
{
	GuiControl, 13:Disable, Ex_AutoKey
	GuiControl, 13:Enable, Ex_AutoKeyL
}
return

ExpSelList:
NewRow := ExpSel ? (RowNumber + 1) : (RowNumber - 1)
Gui, 13:+OwnDialogs
Gui, 13:Submit, NoHide
Gui, 14:Default
If (Ex_Macro != "")
{
	If ((!InStr(Ex_Macro, "()")) && (!RegExMatch(Ex_Macro, "^\w+$")))
	{
		MsgBox, 16, %d_Lang007%, %d_Lang049%
		return
	}
	Else If (!InStr(Ex_Macro, "()"))
	{
		Loop, % LV_GetCount()
		{
			LV_GetText(mLabel, A_Index, 1)
			If ((A_Index != RowNumber) && (mLabel = Ex_Macro))
			{
				MsgBox, 16, %d_Lang007%, %d_Lang050%
				return
			}
		}
	}
}
Ex_AutoKey := Ex_AutoKeyFromH ? Ex_AutoKey : Ex_AutoKeyL
LV_Modify(RowNumber,, Ex_Macro, Ex_AutoKey, Ex_TimesX, Ex_BM)
RowNumber := NewRow
If (RowNumber > LV_GetCount())
	RowNumber := 1
Else If (RowNumber = 0)
	RowNumber := LV_GetCount()
LV_Modify(0, "-Select"), LV_Modify(RowNumber, "Select")
LV_GetText(Ex_Macro, RowNumber, 1)
LV_GetText(Ex_AutoKey, RowNumber, 2)
LV_GetText(Ex_TimesX, RowNumber, 3)
LV_GetText(Ex_BM, RowNumber, 4)
If (InStr(Ex_Macro, "()"))
{
	Ex_AutoKey := ""
	GuiControl, 13:, Ex_AutoKeyFromH, 1
}
GuiControl, 13:, Ex_Macro, %Ex_Macro%
GuiControl, 13:, Ex_BM, %Ex_BM%
GuiControl, 13:, Ex_TimesX, %Ex_TimesX%
GuiControl, 13:, Ex_AutoKey, %Ex_AutoKey%
If (InStr(KeybdList, Ex_AutoKey _x))
	GuiControl, 13:ChooseString, Ex_AutoKeyL, %Ex_AutoKey%
Else
	GuiControl, 13:, Ex_AutoKeyL, %Ex_AutoKey%%_x%%_x%
If (InStr(Ex_Macro, "()"))
{
	GuiControl, 13:Disable, Ex_Macro
	GuiControl, 13:Disable, Ex_AutoKey
	GuiControl, 13:Disable, Ex_AutoKeyL
	GuiControl, 13:Disable, Ex_AutoKeyFromH
	GuiControl, 13:Disable, Ex_AutoKeyFromL
	GuiControl, 13:Disable, Ex_BM
	GuiControl, 13:Disable, Ex_TE
	GuiControl, 13:Disable, Ex_TimesX
}
Else
{
	GuiControl, 13:Enable, Ex_Macro
	If (Ex_AutoKeyFromH)
		GuiControl, 13:Enable, Ex_AutoKey
	Else
		GuiControl, 13:Enable, Ex_AutoKeyL
	GuiControl, 13:Enable, Ex_AutoKeyFromH
	GuiControl, 13:Enable, Ex_AutoKeyFromL
	GuiControl, 13:Enable, Ex_BM
	GuiControl, 13:Enable, Ex_TE
	GuiControl, 13:Enable, Ex_TimesX
}
return

VarsTree:
Gui, 29:+owner14 +ToolWindow
Gui, 14:+Disabled
Gui, 29:Add, TreeView, Checked H500 W300 vIniTV gIniTV -ReadOnly AltSubmit
Gui, 29:Add, Button, -Wrap Section xs W75 H23 gVarsTreeClose, %c_Lang020%
Gui, 29:Add, Button, -Wrap yp x+5 W75 H23 gCheckAll, %t_Lang007%
Gui, 29:Add, Button, -Wrap yp x+5 W75 H23 gUnCheckAll, %t_Lang008%
Gui, 29:Default
User_Vars.Tree(CheckedVars)
Gui, 29:Show,, %t_Lang096%
return

29GuiClose:
29GuiEscape:
VarsTreeClose:
Gui, 29:Submit, NoHide
UserVarsList := User_Vars.TreeGetItems(true, true, "global ")
CheckedVars := TreeGetChecked()
Gui, 14:-Disabled
Gui, 29:Destroy
Gui, 14:Default
return

IniTV:
If ((A_GuiEvent = "Normal") || (A_GuiEvent = "K"))
{
	If (!TV_GetParent(A_EventInfo))
	{
		ItemID := 0, C := TV_Get(A_EventInfo, "Check")
		Loop
		{
			ItemID := TV_GetNext(ItemID, "Full")
			If (!ItemID)
				break
			If (TV_GetParent(ItemID) != A_EventInfo)
				continue
			TV_Modify(ItemID, "Check" C)
		}
	}
	Else
		TV_Modify(TV_GetParent(A_EventInfo), "Check")
}
return

CheckAll:
ItemID := 0
LV_Modify(0, "Check")
Loop
{
	ItemID := TV_GetNext(ItemID, "Full")
	If (!ItemID)
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
	If (!ItemID)
		break
	TV_Modify(ItemID, "-Check")
}
return

Ex_Checks:
Gui, 14:Submit, NoHide
GuiControl, 14:Enable%Ex_IfDir%, Ex_IfDirType
GuiControl, 14:Enable%Ex_IfDir%, Ident
GuiControl, 14:Enable%Ex_IfDir%, Title
GuiControl, 14:Enable%Ex_IfDir%, GetWin
GuiControl, 14:Enable%Ex_UV%, Ex_EdVars
return

ExEditScript:
Gui, 14:Submit, NoHide
Run, "%DefaultEditor%" "%ExpFile%"
return

ExExecScript:
Gui, 14:Submit, NoHide
If (!A_AhkPath)
{
	GuiControl, 21:, UseExtFunc, 0
	MsgBox, 17, %d_Lang007%, %d_Lang056%
	IfMsgBox, OK
		Run, https://www.autohotkey.com/
	return
}
Run, "%ExpFile%"
return

DefaultExOpt:
GuiControl, 14:, Ex_SM, 1
GuiControl, 14:, Ex_SI, 1
GuiControl, 14:, Ex_ST, 1
GuiControl, 14:, Ex_SP, 0
GuiControl, 14:, Ex_CM, 1
GuiControl, 14:, Ex_DH, 0
GuiControl, 14:, Ex_DT, 0
GuiControl, 14:, Ex_AF, 1
GuiControl, 14:, Ex_HK, 0
GuiControl, 14:, Ex_PT, 0
GuiControl, 14:, Ex_NT, 0
GuiControl, 14:, Ex_WN, 0
GuiControl, 14:, Ex_SC, 1
GuiControl, 14:, SC, %ControlDelay%
GuiControl, 14:, Ex_SW, 1
GuiControl, 14:, SW, 0
GuiControl, 14:, Ex_SK, 1
GuiControl, 14:, SK, %KeyDelay%
GuiControl, 14:, Ex_MD, 1
GuiControl, 14:, MD, %MouseDelay%
GuiControl, 14:, Ex_SB, 1
GuiControl, 14:, SB, -1
GuiControl, 14:, Ex_MT, 0
GuiControl, 14:, MT, 2
GuiControl, 14:, Ex_IN, 1
GuiControl, 14:, Ex_UV, 1
GuiControl, 14:, Ex_Speed, 0
GuiControl, 14:, ComCr, 1
GuiControl, 14:ChooseString, SM, %KeyMode%
GuiControl, 14:ChooseString, SI, Force
GuiControl, 14:ChooseString, AbortKey, %AbortKey%
GuiControl, 14:ChooseString, PauseKey, %PauseKey%
GuiControl, 14:ChooseString, SM, %SM%
GuiControl, 14:ChooseString, SI, %SI%
GuiControl, 14:ChooseString, ST, %TitleMatch%
GuiControl, 14:ChooseString, SP, %TitleSpeed%
GuiControl, 14:ChooseString, CM, %CoordMouse%
GuiControl, 14:ChooseString, DH, % HiddenWin ? "On" : "Off"
GuiControl, 14:ChooseString, DT, % HiddenText ? "On" : "Off"
GuiControl, 14:ChooseString, IN, %IN%
return

ExpClose:
14GuiClose:
14GuiEscape:
Gui, 14:Submit, NoHide
Loop, %TabCount%
	LV_GetText(BckIt%A_Index%, A_Index, 4)
Gui, 1:-Disabled
Gui, 14:Destroy
Gui, chMacro:Default
TB_Edit(tbPrev, "TabIndent", TabIndent)
TB_Edit(tbPrevF, "TabIndent", TabIndent)
TB_Edit(tbPrev, "ConvertBreaks", ConvertBreaks)
TB_Edit(tbPrevF, "ConvertBreaks", ConvertBreaks)
TB_Edit(tbPrev, "CommentUnchecked", CommentUnchecked)
TB_Edit(tbPrevF, "CommentUnchecked", CommentUnchecked)
If (AutoRefresh = 1)
	GoSub, PrevRefresh
return

ExeExp:
Gui, 14:+OwnDialogs
If (!A_AhkPath)
{
	GuiControl, 14:, Exe_Exp, 0
	MsgBox, 17, %d_Lang007%, %d_Lang056%
	IfMsgBox, OK
		Run, https://www.autohotkey.com/
	return
}
Gui, 14:Submit, NoHide
If (Exe_Exp)
{
	GuiControl, 14:Enable, ExpIcon
	GuiControl, 14:Enable, ExpIconSearch
}
Else
{
	GuiControl, 14:Disable, ExpIcon
	GuiControl, 14:Disable, ExpIconSearch
}
return

ExpSearch:
Gui, 14:+OwnDialogs
Gui, 14:Submit, NoHide
SplitPath, ExpFile, ExpName
FileSelectFile, SelectedFileName, S16, %ExpName%, %d_Lang013%, AutoHotkey Scripts (*.ahk)
FreeMemory()
If (SelectedFileName = "")
	return
SplitPath, SelectedFileName, name, dir, ext, name_no_ext, drive
If (ext != "ahk")
	SelectedFileName := SelectedFileName ".ahk"
GuiControl,, ExpFile, %SelectedFileName%
return

ExpIconSearch:
Gui, 14:+OwnDialogs
Gui, 14:Submit, NoHide
SplitPath, ExpIcon, ExpName
FileSelectFile, SelectedFileName, 3, %ExpName%, %d_Lang013%, Icon files (*.ico)
FreeMemory()
If (SelectedFileName = "")
	return
SplitPath, SelectedFileName, name, dir, ext, name_no_ext, drive
GuiControl,, ExpIcon, %SelectedFileName%
return

ExpButton:
Gui, 14:+OwnDialogs
Gui, 14:Submit, NoHide
If (ExpFile = "")
	return
If (Ex_AbortKey = 1)
{
	If (AbortKey = "")
	{
		MsgBox, 16, %d_Lang007%, %d_Lang073%`n`n> %w_Lang008%
		return
	}
}
If (Ex_PauseKey = 1)
{
	If (PauseKey = "")
	{
		MsgBox, 16, %d_Lang007%, %d_Lang073%`n`n> %t_Lang081%
		return
	}
}
SelectedFileName := ExpFile
SplitPath, SelectedFileName,,, ext,, driv
If (ext != "ahk")
	SelectedFileName .= ".ahk"
If (driv = "")
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
RowNumber := 0, AutoKey := "", IncList := "", ProgRatio := 100 / LV_GetCount(), HasEmailFunc := {}
PmcCode := "[PMC Globals]|" IfDirectContext "|" IfDirectWindow "|" ExpIcon "`n"
Loop, % LV_GetCount()
{
	GuiControl, 14:, ExpProgress, +%ProgRatio%
	Gui, 14:Default
	Gui, 14:ListView, ExpList
	RowNumber := LV_GetNext(RowNumber, "Checked")
	If ((A_Index = 1) && (RowNumber = 0))
	{
		GuiControl, 14:, ExpProgress, 0
		MsgBox, 16, %d_Lang007%, %d_Lang008%
		return
	}
	If (RowNumber = 0)
		break
	LV_GetText(Ex_Macro, RowNumber, 1)
	LV_GetText(Ex_AutoKey, RowNumber, 2)
	LV_GetText(Ex_TimesX, RowNumber, 3)
	LV_GetText(Ex_BM, RowNumber, 4)
	LV_GetText(Ex_Idx, RowNumber, 5)
	If (ListCount%Ex_Idx% = 0)
		continue
	Body := LV_Export(Ex_Idx), AutoKey .= Ex_AutoKey "`n"
	If (RegExMatch(Body, "CDO\((UserAccount\d+)", Acc))
		HasEmailFunc[Acc1] := UserMailAccounts.Get(, Acc1,, true)
	GoSub, ExportOpt
	AllScripts .= Body "`n"
	PMCSet := "[PMC Code v" CurrentVersion "]|" Ex_AutoKey
	. "|" o_ManKey[Ex_Idx] "|" Ex_TimesX
	. "|" CoordMouse "," TitleMatch "," TitleSpeed "," HiddenWin "," HiddenText "," KeyMode "," KeyDelay "," MouseDelay "," ControlDelay "|" OnFinishCode "|" CopyMenuLabels[Ex_Idx] "`n"
	IfContext := "Context=" o_MacroContext[Ex_Idx].Condition "|" o_MacroContext[Ex_Idx].Context "`n"
	TabGroups := "Groups=" LVManager[Ex_Idx].GetGroups() "`n"
	PmcCode .= PMCSet . IfContext . TabGroups . PMC.LVGet("InputList" Ex_Idx).Text . "`n"
	If (Ex_IN)
		IncList .= IncludeFiles(Ex_Idx, ListCount%Ex_Idx%)
}
For _each, _Section in HasEmailFunc
{
	Acc := _each " := {" RTrim(StrReplace(StrReplace(_Section, " := ", ": "), "`n", ", "), ", ") "}`n"
	Header .= Acc
}
o_ExAutoKey := []
AbortKey := (Ex_AbortKey = 1) ? AbortKey : ""
PauseKey := (Ex_PauseKey = 1) ? PauseKey : ""
Loop, Parse, AutoKey, `n
	o_ExAutoKey[A_Index] := A_LoopField
If (CheckDuplicates(AbortKey, PauseKey, o_ExAutoKey*))
{
	Body := "", AllScripts := "", PmcCode := ""
	MsgBox, 16, %d_Lang007%, %d_Lang032%
	return
}
If (Ex_Speed != 0)
{
	Body := ""
	If (Ex_Speed < 0)
	{
		Ex_Speed *= -1
		Loop, Parse, AllScripts, `n
		{
			If (RegExMatch(A_LoopField, "^(\s*Sleep), (\d+)$", Value))
				Body .= Value1 ", " . Value2 * (2 ** Ex_Speed) . "`n"
			Else
				Body .= A_LoopField "`n"
		}
	}
	Else
	{
		Loop, Parse, AllScripts, `n
		{
			If (RegExMatch(A_LoopField, "^(\s*Sleep), (\d+)$", Value))
				Body .= Value1 ", " . Value2 // (2 ** Ex_Speed) . "`n"
			Else
				Body .= A_LoopField "`n"
		}
	}
}
Else
	Body := AllScripts
AllScripts := ""
If (Ex_IfDir = 1)
{
	If (InStr(Body, "#If") = 1)
		Body .= Ex_IfDirType "`n"
	Else
		Body := Ex_IfDirType " " Title "`n`n" Body Ex_IfDirType "`n"
	StringReplace, Body, Body, `n%Ex_IfDirType% %Title%`n`n%Ex_IfDirType%`n
}
If (Ex_AbortKey = 1)
	Body .= "`n" AbortKey "::ExitApp`n"
If (Ex_PauseKey = 1)
	Body .= "`n" PauseKey "::Pause`n"
If (HasEmailFunc.GetCapacity())
	IncList .= IncludeFunc("CDO")
If (InStr(Body, "IELoad("))
	IncList .= IncludeFunc("IELoad")
If (InStr(Body, "WinHttpDownloadToFile("))
	IncList .= IncludeFunc("WinHttpDownloadToFile")
If (InStr(Body, "zip("))
	IncList .= IncludeFunc("Zip")
If (InStr(Body, "CenterImgSrchCoords("))
	IncList .= IncludeFunc("CenterImgSrchCoords")
Script := Header . Body . IncList, ChoosenFileName := SelectedFileName
GoSub, SaveAHK
return

SaveAHK:
IfExist %ChoosenFileName%
{
	FileDelete %ChoosenFileName%
	If (ErrorLevel)
	{
		MsgBox, 16, %d_Lang007%, %d_Lang006% "%ChoosenFileName%".
		return
	}
}
FileAppend, %Script%, %ChoosenFileName%
If (ErrorLevel)
{
	MsgBox, 16, %d_Lang007%, %d_Lang006% "%ChoosenFileName%".
	return
}
If (IncPmc)
	FileAppend, `n%PmcHead%%PmcCode%*/`n, %SelectedFileName%
If (Exe_Exp)
{
	SplitPath, A_AhkPath,, AhkDir
	Compress := "", CustomIcon := ""

	If (FileExist(AhkDir "\Compiler\mpress.exe"))
		Compress := RegExReplace(A_AhkVersion, "\D") > 113200 ? "/compress 1" : "/mpress 1"
	Else If (FileExist(AhkDir "\Compiler\upx.exe"))
		Compress := RegExReplace(A_AhkVersion, "\D") > 113200 ? "/compress 2" : ""
	If ((ExpIcon != "") && (FileExist(ExpIcon)))
		CustomIcon := "/icon """ ExpIcon """"
	RunWait, "%AhkDir%\Compiler\Ahk2Exe.exe" /in "%SelectedFileName%" %CustomIcon% /bin "%AhkDir%\Compiler\Unicode 32-bit.bin" %Compress%,, UseErrorLevel
}
PmcCode := ""
MsgBox, 64, %d_Lang014%, % d_Lang015 . (HasEmailFunc.GetCapacity() ? "`n`n`n>>>>>>>>>>[" RegExReplace(d_Lang011, "(*UCP).*", "$u0") "]<<<<<<<<<<`n`n" d_Lang114 : "")
GuiControl, 14:, ExpProgress, 0
return

ExportOpt:
If ((TabIndent = 1) && (Ex_TimesX != 1))
	Body := RegExReplace(Body, "`am)^", (IndentWith = "Tab" ? "`t" : "    "))
If (Ex_TimesX = 0)
	Body := "Loop`n{`n" Body "}`n"
Else If (Ex_TimesX > 1)
	Body := "Loop, " Ex_TimesX "`n{`n" Body "}`n"
If (Ex_BM = 1)
	Body := "BlockInput, MouseMove`n" Body "BlockInput, MouseMoveOff`n"
If (!InStr(Ex_Macro, "()"))
	Body := ((Ex_Macro != "") ? Ex_Macro ":`n" : "") Body "Return`n"
If (Ex_AutoKey != "")
	Body := Ex_AutoKey "::`n" Body
If ((o_MacroContext[Ex_Idx].Condition != "") && (o_MacroContext[Ex_Idx].Condition != "None"))
{
	Body := "#If" o_MacroContext[Ex_Idx].Condition " " o_MacroContext[Ex_Idx].Context "`n" Body "#If" o_MacroContext[Ex_Idx].Condition "`n"
	If (Ex_IfDir = 1)
		Body .= "`n" Ex_IfDirType " " Title "`n"
}
return

Options:
Gui, 4:+LastFoundExist
IfWinExist
{
	WinActivate
	return
}
Gui, 4:+owner1 -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
GoSub, SaveData
GoSub, GetHotkeys
GoSub, ResetHotkeys
OldSpeedUp := SpeedUp, OldSpeedDn := SpeedDn,OldAreaColor := SearchAreaColor, OldLoopColor := LoopLVColor
, OldIfColor := IfLVColor, OldMoves := Moves, OldTimed := TimedI, OldRandM := RandomSleeps, OldRandP := RandPercent
User_Vars := new ObjIni(UserVarsPath)
User_Vars.Read()
UserVars := User_Vars.Get(true)
UserVarsList := User_Vars.Get(,, true)
Gui, 4:Add, Listbox, W160 H310 vAltTab gAltTabControl AltSubmit, %t_Lang018%||%t_Lang022%|%t_Lang035%|%t_Lang090%|%t_Lang046%|%t_Lang191%|%t_Lang189%|%t_Lang178%|%t_Lang096%
Gui, 4:Add, Tab2, yp x+0 W400 H0 vTabControl gAltTabControl AltSubmit, General|Recording|Playback|Defaults|Screenshots|Email|Language|LangEditor|UserVars|SubmitRev
; General
Gui, 4:Add, GroupBox, Section ym xm+170 W400 H175, %t_Lang018%:
Gui, 4:Add, Checkbox, -Wrap Checked%AutoBackup% vAutoBackup W380 ys+20 xs+10 R1, %t_Lang152%
Gui, 4:Add, Checkbox, -Wrap Checked%ShowBarOnStart% W380 vShowBarOnStart R1, %t_Lang085%
Gui, 4:Add, Checkbox, -Wrap Checked%MultInst% vMultInst W380 R1, %t_Lang089%
Gui, 4:Add, Checkbox, -Wrap Checked%TbNoTheme% vTbNoTheme W380 R1, %t_Lang142%
Gui, 4:Add, Checkbox, -Wrap Checked%EvalDefault% vEvalDefault W380 R1, %t_Lang059%
Gui, 4:Add, Checkbox, -Wrap Checked%ConfirmDelete% vConfirmDelete W380 R1, %t_Lang151%
Gui, 4:Add, Text, -Wrap W380 R1, %t_Lang148%:
Gui, 4:Add, Radio, -Wrap W180 vCloseApp R1, %t_Lang149%
Gui, 4:Add, Radio, -Wrap yp x+5 W180 vMinToTray R1, %t_Lang150%
Gui, 4:Add, GroupBox, Section y+15 xs W400 H125, %t_Lang136%:
Gui, 4:Add, Checkbox, -Wrap Checked%ShowLoopIfMark% ys+20 xs+10 vShowLoopIfMark W380 R1, %t_Lang060%
Gui, 4:Add, Text, -Wrap R1 xs+10 y+5 W380, %t_Lang061%
Gui, 4:Add, Text, -Wrap R1 y+5 W85, %t_Lang003% ">"
Gui, 4:Add, Text, -Wrap R1 yp x+10 W40 vLoopLVColor gEditColor c%LoopLVColor%, ██████
Gui, 4:Add, Text, -Wrap R1 yp x+20 W85, %t_Lang082% "*"
Gui, 4:Add, Text, -Wrap R1 yp x+10 W40 vIfLVColor gEditColor c%IfLVColor%, ██████
Gui, 4:Add, Checkbox, -Wrap Checked%ShowActIdent% y+15 xs+10 vShowActIdent W380 R1, %t_Lang083%
Gui, 4:Add, Text, -Wrap R1 W380, %t_Lang084%
Gui, 4:Add, GroupBox, Section y+17 xs W400 H81, %t_Lang062%:
Gui, 4:Add, Edit, ys+20 xs+10 W380 r2 vEditMod, %VirtualKeys%
Gui, 4:Add, Button, -Wrap y+0 W75 H23 gConfigRestore, %t_Lang063%
Gui, 4:Add, Button, -Wrap yp x+10 W75 H23 gKeyHistory, %c_Lang124%
Gui, 4:Tab, 2
; Recording
Gui, 4:Add, GroupBox, Section ym xm+170 W400 H85, %t_Lang053%:
Gui, 4:Add, Text, -Wrap R1 ys+20 xs+10 W380, %t_Lang019%:
Gui, 4:Add, Hotkey, y+1 W180 vRecKey, %RecKey%
Gui, 4:Add, Text, -Wrap R1 ys+20 x+20, %t_Lang020%:
Gui, 4:Add, Hotkey, y+1 W180 vRecNewKey, %RecNewKey%
Gui, 4:Add, Checkbox, -Wrap Checked%ClearNewList% vClearNewList W180 R1, %d_Lang019%
Gui, 4:Add, GroupBox, Section y+15 xs W400 H80, %t_Lang133%:
Gui, 4:Add, Checkbox, -Wrap Checked%Strokes% ys+20 xs+10 vStrokes W380 R1, %t_Lang021%
Gui, 4:Add, Checkbox, -Wrap Checked%CaptKDn% vCaptKDn W380 R1, %t_Lang023%
Gui, 4:Add, Checkbox, -Wrap Checked%RecKeybdCtrl% vRecKeybdCtrl W380 R1, %t_Lang031%
Gui, 4:Add, GroupBox, Section y+15 xs W400 H130, %t_Lang134%:
Gui, 4:Add, Checkbox, -Wrap Checked%Mouse% ys+20 xs+10 vMouse W380 R1, %t_Lang024%
Gui, 4:Add, Checkbox, -Wrap Checked%MScroll% vMScroll W380 R1, %t_Lang025%
Gui, 4:Add, Checkbox, -Wrap Checked%Moves% vMoves gOptionsSub W200 R1, %t_Lang026%
Gui, 4:Add, Text, -Wrap R1 yp x+0 W130, %t_Lang028%:
Gui, 4:Add, Edit, Limit Number yp-2 x+0 W40 R1 vMDelayT
Gui, 4:Add, UpDown, vMDelay 0x80 Range0-999999999, %MDelay%
Gui, 4:Add, Checkbox, -Wrap Checked%RecMouseCtrl%  y+0 xs+10 vRecMouseCtrl W380 R1, %t_Lang032%
Gui, 4:Add, Text, -Wrap R1 W200, %t_Lang033%:
Gui, 4:Add, DDL, yp x+0 vRelKey W80, CapsLock||ScrollLock|NumLock
Gui, 4:Add, Checkbox, -Wrap Checked%ToggleC% yp+5 x+5 vToggleC gOptionsSub W100 R1, %t_Lang034%
Gui, 4:Add, GroupBox, Section y+21 xs W400 H85, %t_Lang135%:
Gui, 4:Add, Checkbox, -Wrap Checked%TimedI% ys+20 xs+10 vTimedI gOptionsSub W200 R1, %t_Lang027%
Gui, 4:Add, Text, -Wrap R1 yp x+0 W130, %t_Lang028%:
Gui, 4:Add, Edit, Limit Number yp-2 x+0 W40 R1 vTDelayT
Gui, 4:Add, UpDown, vTDelay 0x80 Range0-999999999, %TDelay%
Gui, 4:Add, Checkbox, -Wrap Checked%WClass% y+0 xs+10 vWClass W380 R1, %t_Lang029%
Gui, 4:Add, Checkbox, -Wrap Checked%WTitle% vWTitle W380 R1, %t_Lang030%
Gui, 4:Tab, 3
; Playback
Gui, 4:Add, GroupBox, Section ym xm+170 W400 H75, %t_Lang202%:
Gui, 4:Add, Text, -Wrap R1 yp+20 xs+10 W200, %t_Lang205%:
Gui, 4:Add, DDL, yp-2 x+0 W80 vTitleMatch, 1|2||3|RegEx
Gui, 4:Add, DDL, yp x+5 W80 vTitleSpeed, Fast||Slow
Gui, 4:Add, Checkbox, -Wrap R1 Checked%HiddenWin% y+10 xs+10 W195 vHiddenWin, %t_Lang203%
Gui, 4:Add, Checkbox, -Wrap R1 Checked%HiddenText% yp x+5 W180 vHiddenText, %t_Lang204%
Gui, 4:Add, GroupBox, Section y+18 xs W400 H105, %t_Lang212%:
Gui, 4:Add, Text, -Wrap R1 yp+20 xs+10 W200, %t_Lang213%:
Gui, 4:Add, DDL, yp-2 x+0 W147 vKeyMode, Input|Play|Event|InputThenPlay
Gui, 4:Add, Text, Section -Wrap R1 y+10 xs+10 W120, %t_Lang214%:
Gui, 4:Add, Edit, Limit Number y+10 xp W50 R1 vKeyDelayE
Gui, 4:Add, UpDown, vKeyDelay 0x80 Range-1-1000, %KeyDelay%
Gui, 4:Add, Text, -Wrap R1 ys x+80 W120, %t_Lang215%:
Gui, 4:Add, Edit, Limit Number y+10 xp W50 R1 vMouseDelayE
Gui, 4:Add, UpDown, vMouseDelay 0x80 Range-1-1000, %MouseDelay%
Gui, 4:Add, Text, -Wrap R1 ys x+80 W120, %t_Lang216%:
Gui, 4:Add, Edit, Limit Number y+10 xp W50 R1 vControlDelayE
Gui, 4:Add, UpDown, vControlDelay 0x80 Range-1-1000, %ControlDelay%
Gui, 4:Add, GroupBox, Section y+16 xm+170 W400 H75, %t_Lang053%:
Gui, 4:Add, Text, -Wrap R1 ys+20 xs+10 W200, %t_Lang036%:
Gui, 4:Add, DDL, yp-2 x+0 W75 vFastKey, None|Insert||F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|CapsLock|NumLock|ScrollLock|
Gui, 4:Add, Slider, yp x+0 H25 W80 TickInterval Range1-8 vSpeedUp gSpeedTip, % Exp_Mult[SpeedUp]
Gui, 4:Add, Text, -Wrap W25 R1 yp x+0 vSpeedUpTip, %SpeedUp%x
Gui, 4:Add, Text, -Wrap R1 y+15 xs+10 W200, %t_Lang037%:
Gui, 4:Add, DDL, yp-2 x+0 W75 vSlowKey, None|Pause||F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|CapsLock|NumLock|ScrollLock|
Gui, 4:Add, Slider, yp x+0 H25 W80 TickInterval Range1-8 vSpeedDn gSpeedTip, % Exp_Mult[SpeedDn]
Gui, 4:Add, Text, -Wrap W25 R1 yp x+0 vSpeedDnTip, %SpeedDn%x
Gui, 4:Add, GroupBox, Section y+16 xs W400 H128, %w_Lang003%:
Gui, 4:Add, Checkbox, -Wrap R1 Checked%ShowStep% ys+20 xs+10 W380 vShowStep, %t_Lang100%
Gui, 4:Add, Checkbox, -Wrap R1 Checked%HideErrors% W380 vHideErrors, %t_Lang206%
Gui, 4:Add, Checkbox, -Wrap R1 Checked%MouseReturn% W380 vMouseReturn, %t_Lang038%
Gui, 4:Add, Checkbox, -Wrap R1 Checked%AutoHideBar% W380 vAutoHideBar, %t_Lang143%
Gui, 4:Add, Checkbox, -Wrap R1 Checked%RandomSleeps% W200 vRandomSleeps gOptionsSub, %t_Lang107%
Gui, 4:Add, Edit, Limit Number yp-2 x+0 W50 R1 vRandPer
Gui, 4:Add, UpDown, vRandPercent 0x80 Range0-1000, %RandPercent%
Gui, 4:Add, Text, -Wrap R1 yp+5 x+5, `%
Gui, 4:Tab, 4
; Defaults
Gui, 4:Add, GroupBox, Section ym xm+170 W400 H180, %t_Lang090%:
Gui, 4:Add, Text, -Wrap R1 ys+20 xs+10 W380, %t_Lang039%:
Gui, 4:Add, Radio, -Wrap y+5 xs+10 W120 R1 vRelative R1, %c_Lang005%
Gui, 4:Add, Radio, -Wrap yp x+10 W120 R1 vScreen R1, %t_Lang041%
Gui, 4:Add, Radio, -Wrap yp x+10 W120 R1 vClient R1, %t_Lang207%
Gui, 4:Add, Text, -Wrap R1 y+30 xs+10 W200, %t_Lang042%:
Gui, 4:Add, Edit, Limit Number yp-2 x+0 W60 R1
Gui, 4:Add, UpDown, yp x+0 vDelayM 0x80 Range0-999999999, %DelayM%
Gui, 4:Add, Text, -Wrap R1 y+10 xs+10 W200, %t_Lang043%:
Gui, 4:Add, Edit, Limit Number yp-2 x+0 W60 R1
Gui, 4:Add, UpDown, yp x+0 vDelayW 0x80 Range0-999999999, %DelayW%
Gui, 4:Add, Text, -Wrap R1 y+10 xs+10 W200, %t_Lang044%:
Gui, 4:Add, Edit, Limit Number yp-2 x+0 W60 R1
Gui, 4:Add, UpDown, yp x+0 vMaxHistory 0x80 Range0-999999999, %MaxHistory%
Gui, 4:Add, Link, -Wrap yp+5 x+5 gClearHistory W115, <a>%t_Lang045%</a>
Gui, 4:Add, GroupBox, Section y+33 xs W400 H55, %t_Lang137%:
Gui, 4:Add, Edit, ys+20 xs+10 vDefaultEditor W350 R1 -Multi, %DefaultEditor%
Gui, 4:Add, Button, -Wrap yp-1 x+0 W30 H23 gSearchEXE, ...
Gui, 4:Add, GroupBox, Section y+20 xs W400 H55, %t_Lang057%:
Gui, 4:Add, Edit, ys+20 xs+10 vDefaultMacro W350 R1 -Multi, %DefaultMacro%
Gui, 4:Add, Button, -Wrap yp-1 x+0 W30 H23 gSearchFile, ...
Gui, 4:Add, GroupBox, Section y+20 xs W400 H55, %t_Lang058%:
Gui, 4:Add, Edit, ys+20 xs+10 vStdLibFile W350 R1 -Multi, %StdLibFile%
Gui, 4:Add, Button, -Wrap yp-1 x+0 W30 H23 vStdLib gSearchAHK, ...
Gui, 4:Tab, 5
; Screenshots
Gui, 4:Add, GroupBox, Section ym xm+170 W400 H175, %t_Lang046%:
Gui, 4:Add, Text, -Wrap R1 ys+20 xs+10 W200, %t_Lang047%:
Gui, 4:Add, DDL, yp-5 x+0 vDrawButton W75, RButton||LButton|MButton
Gui, 4:Add, Text, -Wrap R1 y+10 xs+10 W200, %t_Lang048%:
Gui, 4:Add, Edit, Limit Number yp-2 x+0 W40 R1 vLineT
Gui, 4:Add, UpDown, yp x+20 vLineW 0x80 Range1-5, %LineW%
Gui, 4:Add, Text, -Wrap R1 y+10 xs+10 W200, %w_Lang039%:
Gui, 4:Add, Text, -Wrap R1 yp x+0 W75 vSearchAreaColor gEditColor c%SearchAreaColor%, ███████
Gui, 4:Add, Radio, -Wrap y+10 xs+10 W190 vOnRelease R1, %t_Lang049%
Gui, 4:Add, Radio, -Wrap yp x+10 W180 vOnEnter R1, %t_Lang050%
Gui, 4:Add, Text, -Wrap R1 y+10 xs+10 W380, %t_Lang051%:
Gui, 4:Add, Edit, vScreenDir W350 R1 -Multi, %ScreenDir%
Gui, 4:Add, Button, -Wrap yp-1 x+0 W30 H23 vSearchScreen gSearchDir, ...
Gui, 4:Tab, 6
; Email accounts
Gui, 4:Add, GroupBox, Section ym xm+170 W400 H395, %t_Lang191%:
Gui, 4:Add, Text, -Wrap R1 ys+20 xs+10 W80 vAccEmailT, %c_Lang227%*:
Gui, 4:Add, Edit, yp x+5 W295 vAccEmail
Gui, 4:Add, Text, -Wrap R1 y+5 xs+10 W80, %t_Lang194%*:
Gui, 4:Add, Edit, yp x+5 W150 vAccServer
Gui, 4:Add, Text, -Wrap R1 yp x+10 W80, %t_Lang195%*:
Gui, 4:Add, Edit, yp x+5 W50 vAccPort, 25
Gui, 4:Add, Text, -Wrap R1 y+5 xs+10 W80, %t_Lang197%:
Gui, 4:Add, Edit, yp x+5 W110 vAccUser
Gui, 4:Add, Text, -Wrap R1 yp x+10 W80, %t_Lang198%:
Gui, 4:Add, Edit, yp x+5 W90 vAccPass
Gui, 4:Add, Checkbox, -Wrap R1 Checked y+5 xs+10 W110 vAccAuth, %t_Lang196%
Gui, 4:Add, Checkbox, -Wrap R1 yp x+10 W50 vAccSsl, %t_Lang199%
Gui, 4:Add, Text, -Wrap yp x+10 W145, %c_Lang177% (%c_Lang019%):
Gui, 4:Add, Edit, Limit Number yp x+5 W50 R1
Gui, 4:Add, UpDown, yp x+0 vAccTimeout 0x80 Range0-999, 30
Gui, 4:Add, Button, -Wrap y+15 xs+10 W75 H23 gAccAdd, %c_Lang123%
Gui, 4:Add, Button, -Wrap yp x+10 W75 H23 gAccUpdate, %t_Lang192%
Gui, 4:Add, Button, -Wrap yp x+10 W75 H23 gAccDel, %c_Lang024%
Gui, 4:Add, Link, -Wrap yp+2 x+10 W130 R1 gEmailTest, <a>%t_Lang201%</a>
Gui, 4:Add, Text, -Wrap R1 y+12 xs+10 W380 cGray, %t_Lang193%
Gui, 4:Add, ListView, y+8 xs+10 W380 R10 vAccList gAccSub LV0x4000, %c_Lang227%|%t_Lang194%|%t_Lang195%|%t_Lang197%|%t_Lang198%|%t_Lang196%|%t_Lang199%|%c_Lang177%|%t_Lang200%
Gui, 4:Tab, 7
; Language select
Gui, 4:Add, GroupBox, Section ym xm+170 W400 H395, %t_Lang189%:
Gui, 4:Add, Listbox, ys+20 xs+10 W380 H355 vSelLang Sort, %Lang_List%
Gui, 4:Tab, 8
; Language Editor
Gui, 4:Add, GroupBox, Section ym xm+170 W400 H395, %t_Lang178%:
Gui, 4:Add, DDL, ys+20 xs+10 W185 vEditLang gUpdateEditList, %Lang_List%
Gui, 4:Add, DDL, yp x+10 W185 vRefLang gUpdateRefList, %Lang_List%
Gui, 4:Add, ListView, y+10 xs+10 W380 R9 hwndLangListID vLangList gLangList -Multi NoSort AltSubmit LV0x4000, %t_Lang184%|%t_Lang185%
Gui, 4:Add, Edit, y+5 xs+10 W380 R3 vRowLang gUpdateRowLang -WantReturn
Gui, 4:Add, Edit, y+5 xs+10 W380 R3 vRowRef -WantReturn ReadOnly
Gui, 4:Add, Text, -Wrap R1 y+5 xs+10 W260, %t_Lang180%
Gui, 4:Add, Button, -Wrap y+10 xs+10 W75 H23 Disabled vSaveLang gSaveLang, %t_Lang127%
Gui, 4:Add, Button, -Wrap yp x+10 W75 H23 gCreateLangFile, %t_Lang179%
Gui, 4:Add, Button, -Wrap yp-25 x+95 W115 H23 gColGroups, %t_Lang187%
Gui, 4:Add, Button, -Wrap yp+25 xp W115 H23 gExpGroups, %t_Lang188%
Gui, 4:Tab, 9
; User Variables
Gui, 4:Add, GroupBox, Section ym xm+170 W400 H395, %t_Lang096%:
Gui, 4:Add, Text, ys+20 xs+10 -Wrap W150 R1, %t_Lang093%:
Gui, 4:Add, Text, -Wrap W200 R1 yp xs+155 cRed, %t_Lang094%
Gui, 4:Add, Text, -Wrap W380 R1 y+5 xs+10, %t_Lang095%
Gui, 4:Add, Edit, W380 r24 vUserVarsList, %UserVarsList%
Gui, 4:Tab, 10
; Send Revision
Gui, 4:Add, GroupBox, Section ym xm+170 W400 H395, %t_Lang186%
Gui, 4:Add, Text, -Wrap R1 ys+30 xs+10 W75, %c_Lang230%:
Gui, 4:Add, Text, -Wrap R1 yp x+5 W300, pulover@macrocreator.com
Gui, 4:Add, Text, -Wrap R1 y+10 xs+10 W75, %c_Lang226%:
Gui, 4:Add, Edit, yp x+5 W300 R1 vFromMail Limit100, myemail@domain.com
Gui, 4:Add, Text, -Wrap R1 y+10 xs+10 W75, %t_Lang182%:
Gui, 4:Add, Edit, yp x+5 W300 R1 vName Limit100, %A_UserName%
Gui, 4:Add, Text, -Wrap R1 y+10 xs+10 W75, %c_Lang228%:
Gui, 4:Add, Edit, yp x+5 W300 R1 vSubject Limit100
Gui, 4:Add, Text, -Wrap R1 y+10 xs+10 W75, %c_Lang229%:
Gui, 4:Add, Edit, y+5 xs+10 W380 R10 vMessage Limit2000
Gui, 4:Add, Text, -Wrap R1 y+10 xs+10 W180, %t_Lang184%:
Gui, 4:Add, Edit, y+5 xs+10 W380 R1 vLFile Disabled
Gui, 4:Tab
Gui, 4:Add, Button, -Wrap Default Section xm ym+315 W160 H23 gConfigOK, %c_Lang020%
Gui, 4:Add, Button, -Wrap xp y+5 W160 H23 gConfigCancel, %c_Lang021%
Gui, 4:Add, Link, -Wrap xp y+10 W160 H23 gLoadDefaults, <a>%d_Lang003%</a>
Gui, 4:Default
GuiControl, 4:ChooseString, RelKey, %RelKey%
GuiControl, 4:ChooseString, FastKey, %FastKey%
GuiControl, 4:ChooseString, SlowKey, %SlowKey%
GuiControl, 4:ChooseString, TitleMatch, %TitleMatch%
GuiControl, 4:ChooseString, TitleSpeed, %TitleSpeed%
GuiControl, 4:ChooseString, KeyMode, %KeyMode%
GuiControl, 4:ChooseString, SpeedUp, %SpeedUp%
GuiControl, 4:ChooseString, SpeedDn, %SpeedDn%
GuiControl, 4:ChooseString, DrawButton, %DrawButton%
GuiControl, 4:ChooseString, SelLang, % RegExReplace(Lang_%Lang%, "\t.*")
GuiControl, 4:ChooseString, EditLang, % RegExReplace(Lang_%Lang%, "\t.*")
GuiControl, 4:ChooseString, RefLang, English

Gui, 4:ListView, LangList
LV_ModifyCol(1, 185)
LV_ModifyCol(2, 174)
InEditLang := ""
LangMan := new LV_Rows(LangListId)
LangMan.EnableGroups()

Gui, 4:ListView, AccList
LoadMailAccounts()
LV_ModifyCol(1, 80)

If (CloseAction = "Minimize")
	GuiControl, 4:, MinToTray, 1
Else If (CloseAction = "Close")
	GuiControl, 4:, CloseApp, 1
If (CoordMouse = "Window")
	GuiControl, 4:, Relative, 1
Else If (CoordMouse = "Screen")
	GuiControl, 4:, Screen, 1
Else If (CoordMouse = "Client")
	GuiControl, 4:, Client, 1
GuiControl, 4:, OnRelease, %OnRelease%
GuiControl, 4:, OnEnter, %OnEnter%
GuiControl, 4:Enable%RandomSleeps%, RandPercent
GuiControl, 4:Enable%RandomSleeps%, RandPer
GoSub, UpdateEditList
GoSub, OptionsSub
If (A_GuiControl = "CoordTip")
{
	GuiControl, 4:Choose, AltTab, %t_Lang090%
	GoSub, AltTabControl
}
If ((A_GuiControl = "TModeTip") || (A_GuiControl = "TSendModeTip"))
{
	GuiControl, 4:Choose, AltTab, %t_Lang035%
	GoSub, AltTabControl
}
Gui, 4:Show,, %t_Lang017%
OldMods := VirtualKeys
Input
Tooltip
return

ConfigOK:
Gui, 4:Submit, NoHide
Gui, 4:+OwnDialogs
GuiControlGet, EditOn, 4:Enabled, SaveLang
If (EditOn)
{
	MsgBox, 35, %t_Lang178%, %t_Lang183%
	IfMsgBox, Yes
		GoSub, SaveLang
	IfMsgBox, Cancel
		return
}
If (AutoBackup)
	SetTimer, ProjBackup, 60000
Else
	SetTimer, ProjBackup, Off
SpeedUp := 2 ** SpeedUp
SpeedDn := 2 ** SpeedDn
If (Relative = 1)
	CoordMouse := "Window"
Else If (Screen = 1)
	CoordMouse := "Screen"
Else If (Client = 1)
	CoordMouse := "Client"
SSMode := OnRelease ? "OnRelease" : "OnEnter"
CloseAction := MinToTray ? "Minimize" : (CloseApp ? "Close" : "")
VirtualKeys := EditMod, UserVarsList := Trim(UserVarsList, "`n ")
If (!RegExMatch(UserVarsList, "^\[\V+?\]\v"))
	UserVarsList := "[UserGlobalVars]`n" UserVarsList
User_Vars.Set(UserVarsList)
User_Vars.Read()
UserVars := User_Vars.Get(true)
For _each, _Section in UserVars
	For _key, _value in _Section
		Try SavedVars(_key)
FileDelete, %UserVarsPath%
User_Vars.Write(UserVarsPath)

Gui, 4:ListView, AccList
UpdateMailAccounts()

Gui, 1:-Disabled
Gui, 4:Destroy
Gui, chMacro:Default
IniWrite, %MultInst%, %IniFilePath%, Options, MultInst
GuiControl, 1:, CoordTip, <a>CoordMode</a>: %CoordMouse%
GuiControl, 1:, TModeTip, <a>TitleMatchMode</a>: %TitleMatch%
GuiControl, 1:, TSendModeTip, <a>SendMode</a>: %KeyMode%
GoSub, PrevRefresh
If (WinExist("ahk_id " PMCOSC))
	GuiControl, 28:, OSProgB, %ShowProgBar%
GoSub, RowCheck
LangMan := ""
Gui, 1:Default
Gui, 1:+Disabled
GoSub, KeepMenuCheck
GoSub, LoadLangFiles
GoSub, LoadLang
GoSub, LangChange
GoSub, UpdateRecPlayMenus
If (InEditLang != "")
	GoSub, UpdateLang
GoSub, WriteSettings
Gui, 1:-Disabled
return

ConfigCancel:
4GuiClose:
4GuiEscape:
SpeedUp := OldSpeedUp, SpeedDn := OldSpeedDn, VirtualKeys := OldMods, SearchAreaColor := OldAreaColor, LoopLVColor := OldLoopColor
, IfLVColor := OldIfColor, Moves := OldMoves, TimedI := OldTimed, RandomSleeps := OldRandM, RandPercent := OldRandP
LangMan := ""
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
Gui, 4:Submit, NoHide
GuiControl, 4:Enable%Moves%, MDelayT
GuiControl, 4:Enable%TimedI%, TDelayT
GuiControl, 4:Enable%RandomSleeps%, RandPercent
GuiControl, 4:Enable%RandomSleeps%, RandPer
ToggleMode := ToggleC ? "T" : "P"
return

AltTabControl:
Gui, 4:Submit, NoHide
GuiControl, 4:Choose, TabControl, %AltTab%
Gui, 4:Submit, NoHide
return

LoadDefaults:
Gui, 4:+LastFoundExist
IfWinExist
	GoSub, ConfigCancel
Gui, 1:+OwnDialogs
MsgBox, 49, %d_Lang003%, %d_Lang024%
IfMsgBox, OK
{
	If (KeepDefKeys)
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
SavePrompt(SavePrompt, A_ThisLabel)
return

DefaultMacro:
If (CurrentFileName = "")
{
	MsgBox, 33, %d_Lang005%, % d_Lang002 "`n`n" (CurrentFileName ? """" CurrentFileName """" : "")
	IfMsgBox, OK
		GoSub, Save
	IfMsgBox, Cancel
		return
}
DefaultMacro = %CurrentFileName%
return

SpeedTip:
Gui, 4:Submit, NoHide
Gui, 14:Submit, NoHide
GuiControl, 4:, SpeedUpTip, % (2 ** SpeedUp) "x"
GuiControl, 4:, SpeedDnTip, % (2 ** SpeedDn) "x"
GuiControl, 14:, Ex_SpeedTip, % RTrim(Round((2 ** Ex_Speed), 3), ".0") "x"
return

RemoveDefault:
DefaultMacro =
GuiControl, 4:, DefaultMacro
return

KeepDefKeys:
If (!A_GuiControl)
	KeepDefKeys := !KeepDefKeys
If (KeepDefKeys)
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
If (KeepDefKeys)
	Menu, OptionsMenu, Check, %o_Lang009%
Else
	Menu, OptionsMenu, Uncheck, %o_Lang009%
return

AccAdd:
Gui, Submit, NoHide
Gui, ListView, AccList
If ((Trim(AccEmail) = "") || (Trim(AccServer) = "") || (Trim(AccPort) = ""))
	return
If (!RegExMatch(Trim(AccEmail), "^[\w\.]+@[\w\.]+\.\w+$"))
{
	Gui, Font, cRed
	GuiControl, Font, AccEmailT
	return
}
Loop, % LV_GetCount()
{
	LV_GetText(MailAdd, A_Index, 1)
	If (AccEmail = MailAdd)
		return
}
LV_Add("", Trim(AccEmail), Trim(AccServer), Trim(AccPort), Trim(AccUser), Trim(AccPass), Trim(AccAuth), Trim(AccSsl), Trim(AccTimeout), 2)
return

AccUpdate:
Gui, Submit, NoHide
Gui, ListView, AccList
If ((Trim(AccEmail) = "") || (Trim(AccServer) = "") || (Trim(AccPort) = ""))
	return
If (!LV_GetNext())
	return
LV_Modify(LV_GetNext(),, Trim(AccEmail), Trim(AccServer), Trim(AccPort), Trim(AccUser), Trim(AccPass), Trim(AccAuth), Trim(AccSsl), Trim(AccTimeout), 2)
return

AccDel:
Gui, ListView, AccList
LV_Rows.Delete()
return

AccSub:
If (A_GuiEvent = "DoubleClick")
	Gosub, AccLoad
If (A_GuiEvent = "D")
{
	Gui, ListView, AccList
	LV_Rows.Drag(A_GuiEvent)
}
return

AccLoad:
Gui, ListView, AccList
RowNumber := LV_GetNext()
Loop, % LV_GetCount("Col")
	LV_GetText(Col%A_Index%, RowNumber, A_Index)
GuiControl,, AccEmail, %Col1%
GuiControl,, AccServer, %Col2%
GuiControl,, AccPort, %Col3%
GuiControl,, AccUser, %Col4%
GuiControl,, AccPass, %Col5%
GuiControl,, AccAuth, %Col6%
GuiControl,, AccSsl, %Col7%
GuiControl,, AccTimeout, %Col8%
return

EmailTest:
Gui, Submit, NoHide
Gui, %A_Gui%:+OwnDialogs
If ((Trim(AccEmail) = "") || (Trim(AccServer) = "") || (Trim(AccPort) = ""))
	return
Account	:= {email					: Trim(AccEmail)
		,	smtpserver				: Trim(AccServer)
		,	smtpserverport			: Trim(AccPort)
		,	sendusername			: Trim(AccUser)
		,	sendpassword			: Trim(AccPass)
		,	smtpauthenticate		: Trim(AccAuth)
		,	smtpusessl				: Trim(AccSsl)
		,	smtpconnectiontimeout	: Trim(AccTimeout)
		,	sendusing				: 2}
Try
	CDO(Account, Account.email, "Test message from PMC"
	, "This is a test message sent from Pulover's Macro Creator.`n`nwww.macrocreator.com")
Catch e
{
	MsgBox, 16, %d_Lang007%, % d_Lang064 " SendEmail (CDO)."
		.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" (InStr(e.Message, "0x800401E3") ? d_Lang088 : e.Extra)
	return
}
MsgBox, 64, %AppName%, %d_Lang113%
return

SubmitTrans:
Gui, 4:Submit, NoHide
Gui, 4:ListView, LangList
Gui, 4:+OwnDialogs
GuiControlGet, EditOn, 4:Enabled, SaveLang
If (EditOn)
{
	MsgBox, 33, %t_Lang178%, %t_Lang183%
	IfMsgBox, Cancel
		return
	GoSub, SaveLang
}
FilePath := RegExReplace(EditLang, "\s/.*")
GuiControl, 4:, Subject, Translation Revision: %FilePath%
Loop, Parse, LangInfo, `n, `r
{
	F := StrSplit(A_LoopField, A_Tab, A_Space)
	If ((FilePath = F.3) || (FilePath = F.4))
	{
		FilePath := SettingsFolder "\Lang\" F.2 ".lang"
		break
	}
}
GuiControl, 4:, LFile, %FilePath%
GuiControl, 4:Choose, TabControl, SubmitRev
return

GoNextLine:
Gui, 4:Default
Gui, 4:ListView, LangList
GoSub, UpdateRowLang
LV_Modify(LV_GetNext()+1, "Select")
GoSub, UpdateEditors
return

GoPrevLine:
Gui, 4:Default
Gui, 4:ListView, LangList
GoSub, UpdateRowLang
LV_Modify(LV_GetNext()-1, "Select")
GoSub, UpdateEditors
return

LangList:
Critical
If ((A_GuiEvent = "Normal") || (A_GuiEvent = "RightClick") || (A_GuiEvent = "K"))
	GoSub, UpdateEditors
return

UpdateEditors:
Gui, 4:Default
Gui, 4:Submit, NoHide
Gui, 4:ListView, LangList
RowNumber := LV_GetNext()
If (!RowNumber)
	return
LV_GetText(RowText, RowNumber)
GuiControl, 4:, RowLang, %RowText%
PostMessage, 0x00B1, 0, StrLen(RowText), Edit16, ahk_id %CmdWin%
LV_GetText(RowText, RowNumber, 2)
GuiControl, 4:, RowRef, %RowText%
LV_Modify(RowNumber, "Vis")
return

UpdateRowLang:
Gui, 4:Submit, NoHide
Gui, 4:ListView, LangList
If (!LV_GetNext())
	return
LV_Modify(LV_GetNext(),, RowLang)
InEditLang := EditLang
GuiControl, 4:Disable, EditLang
GuiControl, 4:Enable, SaveLang
return

AddLang:
Gui, 4:Submit, NoHide
Gui, 4:ListView, LangList
EditLang := RegExReplace(A_ThisMenuItem, "\s/.*"), SelLang := EditLang
GoSub, ExportLang
GoSub, ConfigCancel
Gui, 1:Default
GoSub, LoadLangFiles
GoSub, LoadLang
GoSub, LangChange
GoSub, Options
GuiControl, 4:Choose, AltTab, %t_Lang178%
GoSub, AltTabControl
return

SaveLang:
Gui, 4:Submit, NoHide
Gui, 4:ListView, LangList
SpeedUp := 2 ** SpeedUp
SpeedDn := 2 ** SpeedDn
EditLang := RegExReplace(EditLang, "\s/.*"), SelLang := ""
ExportLang:
Gui, 4:Default
RLang := RegExReplace(RefLang, "\s/.*")
For i, l in LangFiles
{
	If (LangData.HasKey(i))
		lName := (InStr(i, "_")) ? LangData[i].Lang : LangData[i].Idiom, n := i
	Else
	{
		c := RegExReplace(i, "_.*")
		For e, l in LangData
		{
			If (InStr(e, c)=1)
			{
				lName := (InStr(e, "_")) ? l.Lang : l.Idiom, n := e
				break
			}
		}
	}
	If (RLang = lName)
	{
		RLang := n
		break
	}
}
Loop, Parse, LangInfo, `n, `r
{
	F := StrSplit(A_LoopField, A_Tab, A_Space)
	If ((EditLang = F.3) || (EditLang = F.4))
	{
		eLang := F.2, FilePath := SettingsFolder "\Lang\" eLang ".lang"
		break
	}
}
LangFile := "Lang_" eLang "`n`t`t`n`t`t; " (SelLang ? SelLang : EditLang) "`n`t`t`n", RowIdx := 1
For i, _Section in LangFiles[RLang]
{
	LangFile .= "; " i "`t`t`n"
	For _var, _value in _Section
	{
		_values := StrSplit(_value, "`n")
		LangFile .= "`t" _var " =`t"
		For e, v in _values
		{
			LV_GetText(RowText, RowIdx)
			If (RegExMatch(v, "(.+)\t.*", lMatch))
				LangFile .= "`n`t" lMatch1 "`t" RowText ((e = _values.Length()) ? "`n`t`t" : "")
			Else
				LangFile .= RowText "`n`t`t"
			RowIdx++
		}
		LangFile := RTrim(LangFile, "`t")
	}
	LangFile .= "`t`t`n"
}
LangFile := RTrim(LangFile, "`n`t") "`n"
FileDelete, %FilePath%
FileAppend, %LangFile%, %FilePath%, UTF-8
GuiControl, 4:Enable, EditLang
GuiControl, 4:Disable, SaveLang
return

CreateLangFile:
Gui, 4:Submit, NoHide
Gui, 4:ListView, LangList
LangsArray := {}
For i, l in LangData
{
	x := RegExReplace(l.Idiom, "\s\(.*")
	y := (InStr(i, "_")) ? l.Lang : l.Idiom
	If (!LangsArray.HasKey(x))
		LangsArray[x] := []
	LangsArray[x].Push(y " / " l.Local)
}
For i, l in LangsArray
{
	m := A_Index
	For e, s in l
	{
		Menu, LangMenu%m%, Add, %s%, AddLang
		If (InStr(Lang_List, s "|"))
			Menu, LangMenu%m%, Disable, %s%
	}
	Menu, NewLangMenu, Add, %i%, :LangMenu%m%
}
Menu, NewLangMenu, Show
For i, l in LangsArray
	Menu, LangMenu%A_Index%, DeleteAll
Menu, NewLangMenu, DeleteAll
return

UpdateEditList:
Gui, 4:Submit, NoHide
Gui, 4:ListView, LangList
SelRow := LV_GetNext()
ELang := RegExReplace(EditLang, "\s/.*")
For i, l in LangFiles
{
	If (LangData.HasKey(i))
		lName := (InStr(i, "_")) ? LangData[i].Lang : LangData[i].Idiom, n := i
	Else
	{
		c := RegExReplace(i, "_.*")
		For e, l in LangData
		{
			If (InStr(e, c)=1)
			{
				lName := (InStr(e, "_")) ? l.Lang : l.Idiom, n := c
				break
			}
		}
	}
	If (ELang = lName)
	{
		ELang := n
		break
	}
}
RowDataA := []
LV_Delete(), Groups := [], Idx := 1
For i, _Section in LangFiles[ELang]
{
	Groups.Push({Name: RegExReplace(i, "\d+\.\s"), Row: Idx})
	For _var, _value in _Section
	{
		_values := StrSplit(RegExReplace(_value, "`am).+\t"), "`n")
		RowDataA.Push(_values*), Idx += _values.Length()
	}
}
For i, v in RowDataA
	LV_Add("", RowDataA[i])
UpdateRefList:
Gui, 4:Submit, NoHide
Gui, 4:ListView, LangList
RLang := RegExReplace(RefLang, "\s/.*")
For i, l in LangFiles
{
	If (LangData.HasKey(i))
		lName := (InStr(i, "_")) ? LangData[i].Lang : LangData[i].Idiom, n := i
	Else
	{
		c := RegExReplace(i, "_.*")
		For e, l in LangData
		{
			If (InStr(e, c)=1)
			{
				lName := (InStr(e, "_")) ? l.Lang : l.Idiom, n := c
				break
			}
		}
	}
	If (RLang = lName)
	{
		RLang := n
		break
	}
}
RowDataB := []
For i, _Section in LangFiles[RLang]
{
	For _var, _value in _Section
	{
		_values := StrSplit(RegExReplace(_value, "`am).+\t"), "`n")
		RowDataB.Push(_values*)
	}
}
For i, v in RowDataB
	LV_Modify(i, "Col2", RowDataB[i])
RowDataA := "", RowDataB := ""
If (A_ThisLabel = "UpdateRefList")
{
	SelRow := LV_GetNext()
	If (SelRow > 0)
	{
		LV_GetText(RowText, SelRow, 2)
		GuiControl, 4:, RowRef, %RowText%
	}
	return
}
If (SelRow > 0)
{
	LV_Modify(SelRow, "Select")
	LV_Modify(SelRow, "Vis")
	LV_GetText(RowText, SelRow)
	GuiControl, 4:, RowLang, %RowText%
	LV_GetText(RowText, SelRow, 2)
	GuiControl, 4:, RowRef, %RowText%
}
LangMan.SetGroups(Groups)
return

ColGroups:
ExpGroups:
Gui, 4:Default
Gui, 4:ListView, LangList
LangMan.CollapseAll(A_ThisLabel = "ColGroups")
return

SearchFile:
Gui, 4:Submit, NoHide
Gui, 4:+OwnDialogs
Gui, 4:+Disabled
FileSelectFile, SelectedFileName,,, %AppName%, Project Files (*.pmc; *.ahk)
Gui, 4:-Disabled
FreeMemory()
If (!SelectedFileName)
	return
GuiControl, 4:, DefaultMacro, %SelectedFileName%
return

SearchEXE:
Gui, 4:Submit, NoHide
Gui, 4:+OwnDialogs
Gui, 4:+Disabled
FileSelectFile, SelectedFileName,, %ProgramFiles%, %AppName%, Executable Files (*.exe)
Gui, 4:-Disabled
FreeMemory()
If (!SelectedFileName)
	return
GuiControl, 4:, DefaultEditor, %SelectedFileName%
return

ClearHistory:
Gui, chMacro:Default
Gui, chMacro:Submit, NoHide
Loop, %TabCount%
{
	LVManager[A_Index].ClearHistory()
	LVManager[A_Index].Add()
}
Sleep, 100
Gui, 4:Default
return

;##### Context Help: #####

HelpB:
ThisMenuItem := RegExReplace(A_ThisMenuItem, "\s/.*")
StringReplace, ThisMenuItem, ThisMenuItem, #, _
Switch ThisMenuItem
{
	Case "Clipboard":
		Run, %HelpDocsUrl%/misc/Clipboard.htm
	Case "If Statements":
		Run, %HelpDocsUrl%/commands/IfEqual.htm
	Case "Labels":
		Run, %HelpDocsUrl%/misc/Labels.htm
	Case "SplashImage":
		Run, %HelpDocsUrl%/commands/Progress.htm
	Case "SplashTextOff":
		Run, %HelpDocsUrl%/commands/SplashTextOn.htm
	Case "Variables and Expressions":
		Run, %HelpDocsUrl%/Variables.htm
	Case "Built-in Functions":
		Run, %HelpDocsUrl%/Functions.htm#BuiltIn
	Case "Functions":
		Run, %HelpDocsUrl%/Functions.htm
	Case "Arrays":
		Run, %HelpDocsUrl%/misc/Arrays.htm
	Case "Objects":
		Run, %HelpDocsUrl%/Objects.htm
	Case "Object Methods":
		Run, %HelpDocsUrl%/objects/Object.htm
	Case "Built-in Variables":
		Run, %HelpDocsUrl%/Variables.htm#BuiltIn
	Default:
		If (InStr(ThisMenuItem, "LockState"))
			Run, %HelpDocsUrl%/commands/SetNumScrollCapsLockState.htm
		Else
			Run, %HelpDocsUrl%/commands/%ThisMenuItem%.htm
}
return

LoopB:
StringReplace, ThisMenuItem, A_ThisMenuItem, #, _
StringReplace, ThisMenuItem, ThisMenuItem, `,
StringReplace, ThisMenuItem, ThisMenuItem, %A_Space%,, All
StringReplace, ThisMenuItem, ThisMenuItem, Files, File
StringReplace, ThisMenuItem, ThisMenuItem, Read, ReadFile
Run, %HelpDocsUrl%/commands/%ThisMenuItem%.htm
return

ExportG:
SpecialB:
If (A_ThisMenuItem = "List of Keys")
	Run, %HelpDocsUrl%/KeyList.htm
Else If (A_ThisMenuItem = "Auto-execute Section")
	Run, %HelpDocsUrl%/Scripts.htm#auto
Else If (InStr(A_ThisMenuItem, "ComObj"))
	Run, %HelpDocsUrl%/commands/%A_ThisMenuItem%.htm
Else If (InStr(A_ThisMenuItem, "#"))
	Run, % HelpDocsUrl "/commands/" RegExReplace(A_ThisMenuItem, "#", "_") ".htm"
Else
	Run, %HelpDocsUrl%/%A_ThisMenuItem%.htm
return

ComB:
If (A_ThisMenuItem = "COM")
	Run, %HelpDocsUrl%/commands/ComObjCreate.htm
If (A_ThisMenuItem = "COM Object Reference")
	Run, https://www.autohotkey.com/boards/viewtopic.php?t=77
If (A_ThisMenuItem = "Basic Webpage COM Tutorial")
	Run, http://www.autohotkey.com/board/topic/47052-basic-webpage-controls
If (A_ThisMenuItem = "IWebBrowser2 Interface (Microsoft)")
	Run, https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/platform-apis/aa752127(v=vs.85)
If (A_ThisMenuItem = "WinHttpRequest Object (Microsoft)")
	Run, https://docs.microsoft.com/en-us/windows/win32/winhttp/winhttprequest
If (A_ThisMenuItem = "CDO (Microsoft)")
	Run, https://docs.microsoft.com/en-us/previous-versions/office/developer/exchange-server-2003/ms988614(v=exchg.65)
If (A_ThisMenuItem = "Shell Object (Microsoft)")
	Run, https://docs.microsoft.com/en-us/windows/win32/shell/shell
return

SendMsgB:
If (A_ThisMenuItem = "Message List")
	Run, %HelpDocsUrl%/misc/SendMessageList.htm
If (A_ThisMenuItem = "Microsoft Docs")
	Run, https://docs.microsoft.com/
return

Help:
ShortLang := RegExReplace(Lang, "_.*")
IfExist, %A_ScriptDir%\MacroCreator_Help_%Lang%.chm
	Run, %A_ScriptDir%\MacroCreator_Help_%Lang%.chm
Else IfExist, %A_ScriptDir%\MacroCreator_Help_%ShortLang%.chm
	Run, %A_ScriptDir%\MacroCreator_Help_%ShortLang%.chm
Else IfExist, %A_ScriptDir%\MacroCreator_Help.chm
	Run, %A_ScriptDir%\MacroCreator_Help.chm
Else
	Run, https://www.macrocreator.com/docs
return

Homepage:
Run, https://www.macrocreator.com
return

Tutorials:
Run, https://www.macrocreator.com/help
return

Forum:
If (InStr(Lang, "Zh"))
	Run, https://www.autohotkey.com/boards/viewtopic.php?f=28&t=1175
Else
	Run, https://www.autohotkey.com/boards/viewforum.php?f=63
return

HelpAHK:
Run, %HelpDocsUrl%
return

ExprLink:
Run, %HelpDocsUrl%/Variables.htm#Expressions
return

StatusBarHelp:
If (A_GuiEvent = "DoubleClick")
	CmdHelp()
Else If (A_GuiEvent = "Normal")
{
	StatusBarGetText, StatusBarText
	Tooltip, %StatusBarText%
	SetTimer, RemoveToolTip, -3000
}
return

CheckNow:
CheckUpdates:
Gui, 1:+OwnDialogs
ComObjError(false)
VerChk := ""
url := "https://www.macrocreator.com/lang"
Try
{
	UrlDownloadToFile, %url%, %A_Temp%\lang.json
	FileRead, ResponseText, %A_Temp%\lang.json
	ResponseText := RegExReplace(ResponseText, "ms).*(\{.*\}).*", "$1")
	VerChk := Eval(ResponseText)[1]
}
If (IsObject(VerChk))
{
	If (VerChk.AppVersion > CurrentVersion)
	{
		UrlDownloadToFile, % VerChk.Url, %A_Temp%\VerChk
		FileRead, ResponseText, %A_Temp%\VerChk

		Gui, Update:+owner1 +ToolWindow
		Gui, 1:+Disabled
		Gui, Update:Add, ActiveX, W600 H400 vWB, about:<!DOCTYPE html><meta http-equiv="X-UA-Compatible" content="IE=edge">
		Gui, Update:Add, Button, -Wrap Section Default xm W600 H23 gDownloadPage, %d_Lang117%
		Gui, Update:Add, Button, -Wrap xm W290 H23 gUpdateCancel, %d_Lang061%
		Gui, Update:Add, Button, -Wrap yp x+20 W290 H23 gUpdateDisable, % SubStr(d_Lang053, 1, -1)

		document := WB.Document
		document.open()
		document.write(ResponseText)
		changes := document.getElementsByClassName(VerChk.ChangesEl)[0].InnerHTML
		document.close()
		document.open()
		document.write(changes)
		document.body.style.overflow := "scroll"
		document.close()

		Gui, Update:Show,, % d_Lang060 ": " VerChk.AppVersion
		return
	}
	Else If (VerChk.LangRev > LangVersion)
	{
		If ((LangLastCheck != VerChk.LangRev) || (A_ThisLabel = "CheckNow"))
		{
			MsgBox, 68, %d_Lang060%, %d_Lang103%
			IfMsgBox, Yes
			{
				FileDelete, %A_Temp%\Lang\*.*
				SplashTextOn, 300, 25, %AppName%, %d_Lang091%
				WinHttpDownloadToFile(VerChk.LangUrl, A_Temp)
				SplashTextOff
				If (FileExist(A_Temp "\Lang.zip"))
				{
					FileCreateDir, %A_Temp%\Lang
					FileCreateDir, %SettingsFolder%\Lang
					FileDelete, %SettingsFolder%\Lang\*.*
					UnZip(A_Temp "\Lang.zip", A_Temp "\Lang\")
					FileCopy, %A_Temp%\Lang\*.lang, %SettingsFolder%\Lang\, 1
					FileDelete, %A_Temp%\Lang.zip
					FileRemoveDir, %A_Temp%\Lang
					Gui, 1:Default
					GoSub, LoadLangFiles
					GoSub, LoadLang
					GoSub, UpdateLang
					LangVersion := VerChk.LangRev, LangLastCheck := VerChk.LangRev
					MsgBox, 64, %AppName%, %d_Lang106%
				}
				Else
					MsgBox, 16, %d_Lang007%, %d_Lang063%
			}
			Else If (A_ThisLabel != "CheckNow")
			{
				LangLastCheck := VerChk.LangRev
				MsgBox, 64, %AppName%, %d_Lang104%
			}
		}
	}
	Else If (A_ThisLabel = "CheckNow")
		MsgBox, 64, %AppName%, %d_Lang062%
}
Else If (A_ThisLabel = "CheckNow")
	MsgBox, 16, %d_Lang007%, % d_Lang063 "`n`n""" SubStr(ResponseText, 1, 500) """"
ComObjError(true)
return

TransferUpdate:
GoSub, UpdateCancel
SplashTextOn, 300, 25, %AppName%, %d_Lang091%
WinHttpDownloadToFile(VerChk.DlUrl, A_Temp)
SplashTextOff
File := A_Temp "\" RegExReplace(VerChk.DlUrl, ".*/")
Run, %File% /FORCECLOSEAPPLICATIONS, %A_Temp%
GoSub, Exit
return

DownloadPage:
Run, https://www.macrocreator.com/download/
return

UpdateDisable:
AutoUpdate := 0
Menu, HelpMenu, Uncheck, %h_Lang008%
UpdateGuiEscape:
UpdateGuiClose:
UpdateCancel:
Gui, 1:-Disabled
Gui, Update:Destroy
return

InsertBIVar:
Send, `%%A_ThisMenuItem%`%
return

AutoUpdate:
AutoUpdate := !AutoUpdate
Menu, HelpMenu, % (AutoUpdate) ? "Check" : "Uncheck", %h_Lang008%
return

HelpAbout:
Gui, 1:+Disabled
OsBit := (A_PtrSize = 8) ? "x64" : "x86"
Gui, 34:-SysMenu +HwndTipScrID +owner1
Gui, 34:Color, FFFFFF
Gui, 34:Add, Pic, W48 H48 y+20 Icon1, %DefaultIcon%
Gui, 34:Font, Bold s12, Tahoma
Gui, 34:Add, Text, -Wrap R1 yp x+10, PULOVER'S MACRO CREATOR
Gui, 34:Font
Gui, 34:Font, Italic, Tahoma
Gui, 34:Add, Text, -Wrap R1 y+0 w300, The Complete Automation Tool
Gui, 34:Font
Gui, 34:Font,, Tahoma
Gui, 34:Add, Link,, <a href="https://www.macrocreator.com">www.macrocreator.com</a>
Gui, 34:Add, Text,, Author: Pulover [Rodolfo U. Batista]
Gui, 34:Add, Text, -Wrap R1 y+0,
(
Copyright © 2012-2021 Cloversoft Serviços de Informática Ltda

Version: %CurrentVersion% (%OsBit%)
Release Date: %ReleaseDate%
AutoHotkey Version: %A_AhkVersion%
)
Gui, 34:Add, Link, y+0, Software Licence: <a href="https://www.gnu.org/licenses/gpl-3.0.txt">GNU General Public License</a>
Gui, 34:Font, Bold, Tahoma
Gui, 34:Font
Gui, 34:Add, Groupbox, Section W360 H130 Center, Thanks to
Gui, 34:Font,, Tahoma
Gui, 34:Add, Edit, ys+20 xs+10 W340 H100 ReadOnly -E0x200,
(
Chris and Lexikos for AutoHotkey.
tic (Tariq Porter) for his GDI+ Library.
tkoi && majkinetor for the ILButton function.
just me for LV_Colors Class, LV_EX/IL_EX libraries and for updating ILButton to 64bit.
Micahs for the base code of the Drag-Rows function.
jaco0646 for the function to make hotkey controls detect other keys.
Uberi for the ExprEval function to solve expressions.
Jethrow for the IEGet & WBGet Functions.
RaptorX for the Scintilla Wrapper for AHK.
majkinetor for the Dlg_Color function.
rbrtryn for the ChooseColor function.
PhiLho and skwire for the function to Get/Set the order of columns.
fincs for GenDocs and SciLexer.dll custom builds.
tmplinshi for the CreateFormData function.
iseahound (Edison Hua) for the Vis2 function used for OCR.
Coco for JSON class.
Thiago Talma for some improvements to the code, debugging and many suggestions.
chosen1ft for suggestions and testing.
)
Gui, 34:Add, Link, y+10 W340 r1, <a href="https://www.macrocreator.com/project/">Translation revisions.</a>
Gui, 34:Add, Groupbox, Section xm+58 W360 H130 Center, GNU General Public License
Gui, 34:Add, Edit, ys+20 xs+10 W340 H100 ReadOnly -E0x200,
(
This program is free software, and you are welcome to redistribute it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or any later version.

This program comes with ABSOLUTELY NO WARRANTY, for details see GNU General Public License.

You should have received a copy of the GNU General Public License along with this program, if not, write to the Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
)
Gui, 34:Font
Gui, 34:Add, Button, -Wrap Default y+20 xp-10 W80 H23 gTipsClose, %c_Lang020%
Gui, 34:Font, Bold, Tahoma
Gui, 34:Add, Text, yp-3 xm+380 H25 Center Hidden vHolderStatic, %m_Lang009%
GuiControlGet, Hold, 34:Pos, HolderStatic
Gui, 34:Add, Progress, % "x" 410 - HoldW " yp wp+20 hp BackgroundF68C06 vProgStatic Disabled"
Gui, 34:Add, Text, -Wrap xp yp wp hp Border cWhite Center 0x200 BackgroundTrans hwndhStatic vDonateStatic gDonatePayPal, %m_Lang009%
Gui, 34:Font
GuiControl, 34:Focus, %c_Lang020%
Gui, 34:Show, W460, %t_Lang076%
hCurs := DllCall("LoadCursor", "Int", 0, "Int", 32649, "UInt")
ReplaceCursor(hStatic, hCurs)
return

EditMouse:
s_Caller := "Edit"
Mouse:
Gui, 5:+owner1 -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
; Action
Gui, 5:Add, GroupBox, Section W250 H135, %c_Lang026%:
Gui, 5:Add, Radio, -Wrap ys+30 xs+10 Checked W115 vClick gClick R1, %c_Lang027%
Gui, 5:Add, Radio, -Wrap y+20 xp W115 vPoint gPoint R1, %c_Lang028%
Gui, 5:Add, Radio, -Wrap y+20 xp W115 vPClick gPClick R1, %c_Lang029%
Gui, 5:Add, Radio, -Wrap ys+30 xp+120 W115 vWUp gWUp R1, %c_Lang030%
Gui, 5:Add, Radio, -Wrap y+20 xp W115 vWDn gWDn R1, %c_Lang031%
Gui, 5:Add, Radio, -Wrap y+20 xp W115 vDrag gDrag R1, %c_Lang032%
; Coordinates
Gui, 5:Add, GroupBox, Section ys x+10 W250 H135, %c_Lang033%:
Gui, 5:Add, Text, -Wrap R1 Section ys+25 xs+10 W20 Right viX, X:
Gui, 5:Add, Edit, ys-3 x+5 vIniX W70 Disabled
Gui, 5:Add, Text, -Wrap R1 ys x+5 W20 Right viY, Y:
Gui, 5:Add, Edit, ys-3 x+5 vIniY W70 Disabled
Gui, 5:Add, Button, -Wrap ys-5 x+5 W30 H23 vMouseGetI gMouseGetI Disabled, ...
Gui, 5:Add, Text, -Wrap R1 Section xs W20 Right veX, X:
Gui, 5:Add, Edit, ys-3 x+5 vEndX W70 Disabled
Gui, 5:Add, Text, -Wrap R1 ys x+5 W20 Right veY, Y:
Gui, 5:Add, Edit, ys-3 x+5 vEndY W70 Disabled
Gui, 5:Add, Button, -Wrap ys-4 x+5 W30 H23 vMouseGetE gMouseGetE Disabled, ...
Gui, 5:Add, Radio, -Wrap Checked y+5 xs W65 vCL gCL R1, Click
Gui, 5:Add, Radio, -Wrap yp x+5 W65 vSE gSE R1, Send
Gui, 5:Add, Checkbox, -Wrap yp x+5 vMRel gMRel Disabled W95 R1, %c_Lang036%
Gui, 5:Add, Checkbox, -Wrap y+5 xs vMRand gMRand W225 R1 Disabled, %c_Lang263%
Gui, 5:Add, Text, -Wrap R1 y+5 xs W95, %c_Lang264%:
Gui, 5:Add, Edit, yp-2 x+10 W55 R1 vRandOffsetE Disabled
Gui, 5:Add, UpDown, vRandOffset 0x80 Range1-5000, 5
Gui, 5:Add, Text, -Wrap R1 yp+2 x+5 W60, %c_Lang265%
; Button
Gui, 5:Add, GroupBox, Section xm W505 H70, %c_Lang037%:
Gui, 5:Add, Radio, -Wrap ys+20 xs+10 Checked W90 vLB R1, %c_Lang038%
Gui, 5:Add, Radio, -Wrap yp x+5 W90 vRB R1, %c_Lang039%
Gui, 5:Add, Radio, -Wrap yp x+5 W90 vMB R1, %c_Lang040%
Gui, 5:Add, Radio, -Wrap yp x+5 W90 vX1 R1, %c_Lang041%
Gui, 5:Add, Radio, -Wrap yp x+5 W90 vX2 R1, %c_Lang042%
Gui, 5:Add, Radio, Group -Wrap y+10 xs+10 Checked W90 R1 vMNormal gMHold, %t_Lang108%
Gui, 5:Add, Radio, -Wrap yp x+5 W90 R1 vMHold gMHold, %c_Lang043%
Gui, 5:Add, Radio, -Wrap yp x+5 W90 R1 vMRelease gMHold, %c_Lang259%
Gui, 5:Add, Text, -Wrap R1 yp x+5 vClicks W90 Right, %c_Lang044%:
Gui, 5:Add, Edit, yp-2 x+10 W100 R1 vCCountE
Gui, 5:Add, UpDown, vCCount 0x80 Range0-999999999, 1
; Repeat
Gui, 5:Add, GroupBox, Section xm W250 H125
Gui, 5:Add, Text, -Wrap R1 ys+20 xs+10 W100 Right, %w_Lang015%:
Gui, 5:Add, Edit, yp x+10 W120 R1 vEdRept
Gui, 5:Add, UpDown, vTimesX 0x80 Range1-999999999, 1
Gui, 5:Add, Text, -Wrap R1 y+10 xs+10 W100 Right, %c_Lang017%:
Gui, 5:Add, Edit, yp x+10 W120 vDelayC
Gui, 5:Add, UpDown, vDelayX 0x80 Range0-999999999, %DelayM%
Gui, 5:Add, Radio, -Wrap Checked W125 vMsc R1, %c_Lang018%
Gui, 5:Add, Radio, -Wrap W125 vSec R1, %c_Lang019%
; Control
Gui, 5:Add, GroupBox, Section ys x+10 W250 H125
Gui, 5:Add, Checkbox, -Wrap ys+15 xs+10 W160 vCSend gCSend R1, %c_Lang016%:
Gui, 5:Add, Edit, vDefCt W200 Disabled
Gui, 5:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetCtrl gGetCtrl Disabled, ...
Gui, 5:Add, Text, -Wrap y+15 xs+10 W150 H20 vWinParsTip cGray, %Wcmd_Short%
Gui, 5:Add, Button, yp-5 x+5 W75 vIdent gWinTitle Disabled, WinTitle
Gui, 5:Add, Edit, y+5 xs+10 W200 vTitle Disabled, A
Gui, 5:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetWin gGetWin Disabled, ...
Gui, 5:Add, Button, -Wrap Section Default xm W75 H23 gMouseOK, %c_Lang020%
Gui, 5:Add, Button, -Wrap ys W75 H23 gMouseCancel, %c_Lang021%
Gui, 5:Add, Button, -Wrap ys W75 H23 vMouseApply gMouseApply Disabled, %c_Lang131%
Gui, 5:Add, Text, x+10 yp-3 W250 H25 cGray, %c_Lang025%
Gui, 5:Add, StatusBar, gStatusBarHelp
Gui, 5:Default
SB_SetIcon(ResDllPath, IconsNames["help"])
If (s_Caller = "Edit")
{
	EscCom(true, Details, Target)
	GuiControl, 5:, TimesX, %TimesX%
	GuiControl, 5:, EdRept, %TimesX%
	GuiControl, 5:, DelayX, %DelayX%
	GuiControl, 5:, DelayC, %DelayX%
	If (InStr(Action, "Left"))
		GuiControl, 5:, LB, 1
	If (InStr(Action, "Right"))
		GuiControl, 5:, RB, 1
	If (InStr(Action, "Middle"))
		GuiControl, 5:, MB, 1
	If (InStr(Action, "X1"))
		GuiControl, 5:, X1, 1
	If (InStr(Action, "X2"))
		GuiControl, 5:, X2, 1
	StringReplace, Action, Action, Left%A_Space%
	StringReplace, Action, Action, Right%A_Space%
	StringReplace, Action, Action, Middle%A_Space%
	StringReplace, Action, Action, X1%A_Space%
	StringReplace, Action, Action, X2%A_Space%
	If (Action = MAction1)
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
		If ((Par2 != "Down") && (Par2 != "Up"))
		{
			If (InStr(Par2, "%"))
				GuiControl, 5:, CCountE, %Par2%
			Else
				GuiControl, 5:, CCount, %Par2%
		}
		GuiControl, 5:Disable, DefCt
		GuiControl, 5:Disable, GetCtrl
	}
	If (Action = MAction2)
	{
		GuiControl, 5:, Point, 1
		GoSub, Point
	}
	If (Action = MAction3)
	{
		GuiControl, 5:, PClick, 1
		GoSub, PClick
	}
	If (Action = MAction4)
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
	If (Action = MAction5)
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
		If (InStr(Par2, "%"))
			GuiControl, 5:, CCountE, %Par2%
		Else
			GuiControl, 5:, CCount, %Par2%
		GuiControl, 5:Disable, DefCt
		GuiControl, 5:Disable, GetCtrl
	}
	If (Action = MAction6)
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
		If (InStr(Par2, "%"))
			GuiControl, 5:, CCountE, %Par2%
		Else
			GuiControl, 5:, CCount, %Par2%
		GuiControl, 5:Disable, DefCt
		GuiControl, 5:Disable, GetCtrl
	}
	If (InStr(Details, " Down"))
	{
		GuiControl, 5:, MHold, 1
		GuiControl, 5:, CCount, 1
		GuiControl, 5:Disable, Clicks
		GuiControl, 5:Disable, CCount
		GuiControl, 5:Disable, CCountE
		StringReplace, Details, Details, %A_Space%Down
	}
	If (InStr(Details, " Up"))
	{
		GuiControl, 5:, MRelease, 1
		GuiControl, 5:, CCount, 1
		GuiControl, 5:Disable, Clicks
		GuiControl, 5:Disable, CCount
		GuiControl, 5:Disable, CCountE
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
		If (InStr(Param1, "x"))
		{
			StringReplace, Param1, Param1, x
			StringReplace, Param2, Param2, y
			GuiControl, 5:, IniX, %Param1%
			GuiControl, 5:, IniY, %Param2%
		}
		If (InStr(Param2, "x"))
		{
			StringReplace, Param2, Param2, x
			StringReplace, Param3, Param3, y
			GuiControl, 5:, IniX, %Param2%
			GuiControl, 5:, IniY, %Param3%
		}
		If (RegExMatch(Target, "^x[0-9]+ y[0-9]+$"))
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
	If (InStr(Details, "Rel"))
		GuiControl, 5:, MRel, 1
	If (Target = "Random")
	{
		GuiControl, 5:Enable, MRand
		GuiControl, 5:, MRand, 1
		GuiControl, 5:Enable, RandOffsetE
		GuiControl, 5:, RandOffsetE, %Window%
	}
	If ((Action = MAction2) || (Action = MAction3))
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
		GuiControlGet, cc, 5:, CCount
		If (Action = MAction2)
			GuiControl, 5:, CCount, 1
		Else
		{
			If ((Par4 != "") && (Par4 != "Down") && (Par4 != "Up"))
			{
				If (InStr(Par4, "%"))
					GuiControl, 5:, CCountE, %Par4%
				Else
					GuiControl, 5:, CCount, %Par4%
			}
		}
	}
	GoSub, MRel
	GuiControl, 5:Enable, MouseApply
}
If (s_Caller = "Find")
{
	Gui, 5:Default
	Switch GotoRes1
	{
		Case MAction1:
			GuiControl, 5:, Click, 1
			GoSub, Click
		Case MAction2:
			GuiControl, 5:, Point, 1
			GoSub, Point
		Case MAction3:
			GuiControl, 5:, PClick, 1
			GoSub, PClick
		Case MAction4:
			GuiControl, 5:, Drag, 1
			GoSub, Drag
		Case MAction5:
			GuiControl, 5:, WUp, 1
			GoSub, WUp
		Case MAction6:
			GuiControl, 5:, WDn, 1
			GoSub, WDn
	}
}
Gui, 5:Submit, NoHide
SBShowTip((CSend ? "Control" : "") "Click")
Gui, 5:Show,, %c_Lang001%
ChangeIcon(hIL_Icons, CmdWin, IconsNames["mouse"])
Input
Tooltip
return

MouseApply:
MouseOK:
Gui, 5:+OwnDialogs
Gui, 5:Submit, NoHide
DelayX := InStr(DelayC, "%") ? DelayC : DelayX
If (Sec = 1)
	DelayX *= 1000
TimesX := InStr(EdRept, "%") ? EdRept : TimesX
If (TimesX = 0)
	TimesX := 1
If (LB)
	Button := "Left"
If (RB)
	Button := "Right"
If (MB)
	Button := "Middle"
If (X1)
	Button := "X1"
If (X2)
	Button := "X2"
If (Click = 1)
	GoSub, f_Click
If (Point = 1)
{
	If ((RegExMatch(IniX, "\s*%\s+")) || (RegExMatch(IniY, "\s*%\s+")))
	{
		MsgBox, 16, %d_Lang011%, %d_Lang059%
		return
	}
	If ((IniX = "") || (IniY = ""))
	{
		MsgBox, 16, %d_Lang011%, %d_Lang016%
		return
	}
	Else
		GoSub, f_Point
}
If (PClick = 1)
{
	If ((RegExMatch(IniX, "\s*%\s+")) || (RegExMatch(IniY, "\s*%\s+")))
	{
		MsgBox, 16, %d_Lang011%, %d_Lang059%
		return
	}
	If ((IniX = "") || (IniY = ""))
	{
		MsgBox, 16, %d_Lang011%, %d_Lang016%
		return
	}
	Else
		GoSub, f_PClick
}
If (Drag = 1)
{
	If ((RegExMatch(IniX, "\s*%\s+")) || (RegExMatch(IniY, "\s*%\s+")))
	{
		MsgBox, 16, %d_Lang011%, %d_Lang059%
		return
	}
	If ((IniX = "") || (IniY = "") || (EndX = "") || (EndY = ""))
	{
		MsgBox, 16, %d_Lang011%, %d_Lang016%
		return
	}
	Else
		GoSub, f_Drag
}
If (WUp = 1)
	GoSub, f_WUp
If (WDn = 1)
	GoSub, f_WDn
Window := Title
GuiControlGet, CtrlState, Enabled, DefCt
GuiControlGet, SendState, Enabled, CSend
If (CtrlState = 1)
{
	If ((CSend = 1) && (SendState = 1))
	{
		If (DefCt = "")
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
If (MRand)
	Target := "Random", Window := RandOffsetE
If (A_ThisLabel != "MouseApply")
{
	Gui, 1:-Disabled
	Gui, 5:Destroy
}
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected"), LV_GetText(RowType, LV_GetNext(), 6)
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", Action, Details, TimesX, DelayX, Type, Target, Window)
Else If ((RowSelection = 0) || ((RowType = cType47) || RowType = cType48))
{
	LV_Add("Check", ListCount%A_List%+1, Action, Details, TimesX, DelayX, Type, Target, Window)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	GuiControl, chMacro:-g, InputList%A_List%
	RowNumber := 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, Action, Details, TimesX, DelayX, Type, Target, Window)
		LVManager[A_List].InsertAtGroup(RowNumber)
		RowNumber++
	}
	GuiControl, chMacro:+gInputList, InputList%A_List%
}
GoSub, RowCheck
GoSub, b_Start
If (A_ThisLabel = "MouseApply")
	Gui, 5:Default
Else
{
	s_Caller := ""
	GuiControl, Focus, InputList%A_List%
}
return

MouseCancel:
5GuiClose:
5GuiEscape:
Gui, 1:-Disabled
Gui, 5:Destroy
s_Caller := ""
return

f_Click:
Action := Button " " MAction1, Details := Button
If (MNormal)
	Details .= ", " (InStr(CCountE, "%") ? CCountE : CCount) ", "
If (MHold)
	Details .= ", , Down"
If (MRelease)
	Details .= ", , Up"
If (MRel = 1)
{
	If ((IniX != "") && (IniY != ""))
		Details .= " x" IniX " y" IniY " NA"
}
If (SE = 1)
	Details := "{Click, " Details "}", Type := cType13
Else
	Type := cType3
return

f_Point:
Action := MAction2, Details := IniX ", " IniY ", 0"
If (MRel = 1)
	Details := "Rel " Details
If (SE = 1)
	Details := "{Click, " Details "}", Type := cType13
Else
	Type := cType3
return

f_PClick:
Action := Button " " MAction3, Details := IniX ", " IniY " " Button
If (MNormal)
	Details .= ", " (InStr(CCountE, "%") ? CCountE : CCount)
If (MHold)
	Details .= ", Down"
If (MRelease)
	Details .= ", Up"
If (MRel = 1)
	Details := "Rel " Details
If (SE = 1)
	Details := "{Click, " Details "}", Type := cType13
Else
	Type := cType3
return

f_Drag:
Action := Button " " MAction4, DetailsI := IniX ", " IniY ", " Button " Down"
DetailsE := EndX ", " EndY ", " Button " Up"
If (MRel = 1)
	DetailsI := " Rel " DetailsI, DetailsE := " Rel " DetailsE
Details := "{Click, " DetailsI "}{Click, " DetailsE "}", Type := cType13
return

f_WUp:
Action := MAction5
Details := "WheelUp"
Details .= ", " (InStr(CCountE, "%") ? CCountE : CCount)
If (SE = 1)
	Details := "{Click, " Details "}", Type := cType13
Else
	Type := cType3
return

f_WDn:
Action := MAction6
Details := "WheelDown"
Details .= ", " (InStr(CCountE, "%") ? CCountE : CCount)
If (SE = 1)
	Details := "{Click, " Details "}", Type := cType13
Else
	Type := cType3
return

Click:
GuiControl, 5:, CL, 1
Gui, 5:Submit, NoHide
GuiControl, 5:Disable, IniX
GuiControl, 5:Disable, IniY
GuiControl, 5:Disable, MouseGetI
GuiControl, 5:Disable, EndX
GuiControl, 5:Disable, EndY
GuiControl, 5:Disable, MouseGetE
GuiControl, 5:Disable, MRel
GuiControl, 5:Disable, MRand
GuiControl, 5:, MRand, 0
GuiControl, 5:Disable, RandOffsetE
GuiControl, 5:Enable, LB
GuiControl, 5:Enable, RB
GuiControl, 5:Enable, MB
GuiControl, 5:Enable, X1
GuiControl, 5:Enable, X2
GuiControl, 5:Enable, Clicks
GuiControl, 5:Enable, CCount
GuiControl, 5:Enable, CCountE
GuiControl, 5:Enable, CSend
GuiControl, 5:Enable, DefCt
GuiControl, 5:Enable, GetCtrl
GuiControl, 5:Enable, Ident
GuiControl, 5:Enable, Title
GuiControl, 5:Enable, GetWin
GuiControl, 5:Enable, CL
GuiControl, 5:Enable, MNormal
GuiControl, 5:Enable, MHold
GuiControl, 5:Enable, MRelease
GoSub, CSend
GuiControl, 5:Disable%SE%, CSend
return

Point:
GuiControl, 5:, CL, 1
Gui, 5:Submit, NoHide
GuiControl, 5:Disable, EndX
GuiControl, 5:Disable, EndY
GuiControl, 5:Disable, MouseGetE
GuiControl, 5:Enable, IniX
GuiControl, 5:Enable, IniY
GuiControl, 5:Enable, MouseGetI
GuiControl, 5:Enable, MRel
GuiControl, 5:Enable, MRand
GuiControl, 5:Disable, LB
GuiControl, 5:Disable, RB
GuiControl, 5:Disable, MB
GuiControl, 5:Disable, X1
GuiControl, 5:Disable, X2
GuiControl, 5:Disable, Clicks
GuiControl, 5:Disable, CCount
GuiControl, 5:Disable, CCountE
GuiControl, 5:Enable, CSend
GuiControl, 5:Disable, CSend
GuiControl, 5:Disable, DefCt
GuiControl, 5:Disable, GetCtrl
GuiControl, 5:Disable, Ident
GuiControl, 5:Disable, Title
GuiControl, 5:Disable, GetWin
GuiControl, 5:Enable, CL
GuiControl, 5:Disable, MNormal
GuiControl, 5:Disable, MHold
GuiControl, 5:Disable, MRelease
GuiControl, 5:Disable, CSend
return

PClick:
GuiControl, 5:, CL, 1
Gui, 5:Submit, NoHide
GuiControl, 5:Disable, EndX
GuiControl, 5:Disable, EndY
GuiControl, 5:Disable, MouseGetE
GuiControl, 5:Enable, IniX
GuiControl, 5:Enable, IniY
GuiControl, 5:Enable, MouseGetI
GuiControl, 5:Enable, MRel
GuiControl, 5:Enable, MRand
GuiControl, 5:Enable, LB
GuiControl, 5:Enable, RB
GuiControl, 5:Enable, MB
GuiControl, 5:Enable, X1
GuiControl, 5:Enable, X2
GuiControl, 5:Enable, Clicks
GuiControl, 5:Enable, CCount
GuiControl, 5:Enable, CCountE
GuiControl, 5:Enable, CSend
GuiControl, 5:Disable, CSend
GuiControl, 5:Disable, DefCt
GuiControl, 5:Disable, GetCtrl
GuiControl, 5:Disable, Ident
GuiControl, 5:Disable, Title
GuiControl, 5:Disable, GetWin
GuiControl, 5:Enable, CL
GuiControl, 5:Enable, MNormal
GuiControl, 5:Enable, MHold
GuiControl, 5:Enable, MRelease
GuiControl, 5:Disable, CSend
return

Drag:
Gui, 5:Submit, NoHide
GuiControl, 5:Enable, IniX
GuiControl, 5:Enable, IniY
GuiControl, 5:Enable, MouseGetI
GuiControl, 5:Enable, EndX
GuiControl, 5:Enable, EndY
GuiControl, 5:Enable, MouseGetE
GuiControl, 5:Enable, MRel
GuiControl, 5:Disable, MRand
GuiControl, 5:, MRand, 0
GuiControl, 5:Disable, RandOffsetE
GuiControl, 5:Enable, LB
GuiControl, 5:Enable, RB
GuiControl, 5:Enable, MB
GuiControl, 5:Enable, X1
GuiControl, 5:Enable, X2
GuiControl, 5:Disable, Clicks
GuiControl, 5:Disable, CCount
GuiControl, 5:Disable, CCountE
GuiControl, 5:Disable, CSend
GuiControl, 5:Disable, DefCt
GuiControl, 5:Disable, GetCtrl
GuiControl, 5:Disable, Ident
GuiControl, 5:Disable, Title
GuiControl, 5:Disable, GetWin
GuiControl, 5:, SE, 1
GuiControl, 5:Disable, CL
GuiControl, 5:Disable, MNormal
GuiControl, 5:Disable, MHold
GuiControl, 5:Disable, MRelease
GuiControl, 5:Disable, CSend
return

WUp:
GuiControl, 5:, CL, 1
Gui, 5:Submit, NoHide
GuiControl, 5:Disable, IniX
GuiControl, 5:Disable, IniY
GuiControl, 5:Disable, MouseGetI
GuiControl, 5:Disable, EndX
GuiControl, 5:Disable, EndY
GuiControl, 5:Disable, MouseGetE
GuiControl, 5:Disable, MRel
GuiControl, 5:Disable, MRand
GuiControl, 5:, MRand, 0
GuiControl, 5:Disable, RandOffsetE
GuiControl, 5:Disable, LB
GuiControl, 5:Disable, RB
GuiControl, 5:Disable, MB
GuiControl, 5:Disable, X1
GuiControl, 5:Disable, X2
GuiControl, 5:Enable, Clicks
GuiControl, 5:Enable, CCount
GuiControl, 5:Enable, CCountE
GuiControl, 5:Enable, CSend
GuiControl, 5:Enable, DefCt
GuiControl, 5:Enable, GetCtrl
GuiControl, 5:Enable, Ident
GuiControl, 5:Enable, Title
GuiControl, 5:Enable, GetWin
GuiControl, 5:Enable, CL
GuiControl, 5:Disable, MNormal
GuiControl, 5:Disable, MHold
GuiControl, 5:Disable, MRelease
GuiControl, 5:Disable%SE%, CSend
GoSub, CSend
return

WDn:
GuiControl, 5:, CL, 1
Gui, 5:Submit, NoHide
GuiControl, 5:Disable, IniX
GuiControl, 5:Disable, IniY
GuiControl, 5:Disable, MouseGetI
GuiControl, 5:Disable, EndX
GuiControl, 5:Disable, EndY
GuiControl, 5:Disable, MouseGetE
GuiControl, 5:Disable, MRel
GuiControl, 5:Disable, MRand
GuiControl, 5:, MRand, 0
GuiControl, 5:Disable, RandOffsetE
GuiControl, 5:Disable, LB
GuiControl, 5:Disable, RB
GuiControl, 5:Disable, MB
GuiControl, 5:Disable, X1
GuiControl, 5:Disable, X2
GuiControl, 5:Enable, Clicks
GuiControl, 5:Enable, CCount
GuiControl, 5:Enable, CCountE
GuiControl, 5:Enable, CSend
GuiControl, 5:Enable, DefCt
GuiControl, 5:Enable, GetCtrl
GuiControl, 5:Enable, Ident
GuiControl, 5:Enable, Title
GuiControl, 5:Enable, GetWin
GuiControl, 5:Enable, CL
GuiControl, 5:Disable, MNormal
GuiControl, 5:Disable, MHold
GuiControl, 5:Disable, MRelease
GuiControl, 5:Disable%SE%, CSend
GoSub, CSend
return

CL:
Gui, 5:Submit, NoHide
GuiControl, 5:Enable, CSend
GuiControl, 5:Enable, DefCt
GuiControl, 5:Enable, GetCtrl
GuiControl, 5:Enable, Ident
GuiControl, 5:Enable, Title
GuiControl, 5:Enable, GetWin
If (Click = 1)
	GoSub, Click
If (Point = 1)
	GoSub, Point
If (PClick = 1)
	GoSub, PClick
If (Drag = 1)
	GoSub, Drag
If (WUp = 1)
	GoSub, WUp
If (WDn = 1)
	GoSub, WDn
return

SE:
Gui, 5:Submit, NoHide
GuiControl, 5:Disable, CSend
GuiControl, 5:Disable, DefCt
GuiControl, 5:Disable, GetCtrl
GuiControl, 5:Disable, Ident
GuiControl, 5:Disable, Title
GuiControl, 5:Disable, GetWin
GuiControl, 5:, MRel, 0
return

MRel:
Gui, 5:Submit, NoHide
If ((Click = 1) || (WUp = 1) || (WDn = 1))
{
	GuiControl, 5:Enable%MRel%, DefCt
	GuiControl, 5:Enable%MRel%, GetCtrl
}
return

MRand:
Gui, 5:Submit, NoHide
If (MRand)
	GuiControl, 5:Enable, RandOffsetE
Else
	GuiControl, 5:Disable, RandOffsetE
return

MHold:
Gui, 5:Submit, NoHide
If (MNormal)
{
	GuiControl, 5:Enable, Clicks
	GuiControl, 5:Enable, CCount
	GuiControl, 5:Enable, CCountE
}
Else
{
	GuiControl, 5:Disable, Clicks
	GuiControl, 5:Disable, CCount
	GuiControl, 5:Disable, CCountE
}
return

MouseGetI:
CoordMode, Mouse, %CoordMouse%
Gui, 5:Submit, NoHide
Hotkey, RButton, NoKey, On
Hotkey, Esc, EscNoKey, On
WinMinimize, ahk_id %CmdWin%
SetTimer, WatchCursor, 100
StopIt := 0
Sleep, 100
WaitFor.Key("RButton")
SetTimer, WatchCursor, off
ToolTip
Sleep, 200
Hotkey, RButton, NoKey, Off
Hotkey, Esc, EscNoKey, Off
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
If (CtrlState = 1)
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
Hotkey, RButton, NoKey, On
Hotkey, Esc, EscNoKey, On
WinMinimize, ahk_id %CmdWin%
SetTimer, WatchCursor, 100
StopIt := 0
Sleep, 100
WaitFor.Key("RButton")
SetTimer, WatchCursor, off
ToolTip
Sleep, 200
Hotkey, RButton, NoKey, Off
Hotkey, Esc, EscNoKey, Off
WinActivate, ahk_id %CmdWin%
If (StopIt)
	Exit
GuiControl,, EndX, %xPos%
GuiControl,, EndY, %yPos%
StopIt := 1
return

GetEl:
Gui, 24:Submit, NoHide
Gui, 24:+OwnDialogs
If (TabControl = 1)
	ControlGet, SelIEWinName, Choice,, ComboBox2, ahk_id %CmdWin%
CoordMode, Mouse, Window
Hotkey, RButton, NoKey, On
Hotkey, Esc, EscNoKey, On
WinMinimize, ahk_id %CmdWin%
ComObjError(false)
If (TabControl = 2)
	ie := WBGet()
Else
{
	SelIEWin := IEWindows
	If (SelIEWinName = "[blank]")
		ie := ""
	Else
	{
		ie := WBGet(RegExReplace(SelIEWinName, "§", "|"))
		DetectHiddenWindows, On
		WinActivate, %SelIEWinName%
		DetectHiddenWindows, Off
	}
}
If (!IsObject(ie))
{
	ie := ComObjCreate("InternetExplorer.Application")
	ie.Visible := true
	ie.Navigate("about:blank")
}
SetTimer, WatchCursorIE, 100
StopIt := 0
Sleep, 100
WaitFor.Key("RButton")
SetTimer, WatchCursorIE, Off
ToolTip
Sleep, 200
Hotkey, RButton, NoKey, Off
Hotkey, Esc, EscNoKey, Off
WinActivate, ahk_id %CmdWin%
If (StopIt)
{
	ComObjError(true)
	Exit
}
If (oel_%Ident% != "")
{
	ElIndex := GetElIndex(Element, Ident)
	GuiControl,, DefEl, % oel_%Ident%
	GuiControl,, DefElInd, %ElIndex%
}
Else If (oel_Name != "")
{
	ElIndex := GetElIndex(Element, "Name"), f_ident := "Name"
	GuiControl,, DefEl, % oel_Name
	GuiControl,, DefElInd, %ElIndex%
	GuiControl, ChooseString, Ident, Name
}
Else If (oel_ID != "")
{
	ElIndex := GetElIndex(Element, "ID")
	GuiControl,, DefEl, %oel_ID%
	GuiControl,, DefElInd, %ElIndex%
	GuiControl, ChooseString, Ident, ID
}
Else If (oel_ClassName != "")
{
	ElIndex := GetElIndex(Element, "ClassName")
	GuiControl,, DefEl, %oel_ClassName%
	GuiControl,, DefElInd, %ElIndex%
	GuiControl, ChooseString, Ident, ClassName
}
Else If (oel_TagName != "")
{
	ElIndex := GetElIndex(Element, "TagName")
	GuiControl,, DefEl, %oel_tagName%
	GuiControl,, DefElInd, %ElIndex%
	GuiControl, ChooseString, Ident, TagName
}
Else If (oel_InnerText != "")
{
	ElIndex := GetElIndex(Element, "Links")
	GuiControl,, DefEl, Links
	GuiControl,, DefElInd, %ElIndex%
	GuiControl, ChooseString, Ident, Links
}
If (TabControl = 2)
{
	Gui, 24:Submit, NoHide
	ComExpSc := IEComExp("", "", oel_%Ident%, ElIndex, "", Ident)
	ComExpSc := SubStr(ComExpSc, 1, StrLen(ComExpSc)-5)
	GuiControl,, ComSc, %ComSc%`n%ComExpSc%
}
If (class = "IEFrame")
{
	GoSub, RefreshIEW
	GuiControl, 24:ChooseString, IEWindows, % RegExReplace(title, " - Internet Explorer.*")
}
ComObjError(true)
StopIt := 1
return

GetCtrl:
StringSplit, Ident, GetWinTitle, `,
Loop, 5
	Ident%A_Index% := Ident%A_Index% ? 1 : 0

CoordMode, Mouse, %CoordMouse%
Hotkey, RButton, NoKey, On
Hotkey, Esc, EscNoKey, On
WinMinimize, ahk_id %CmdWin%
SetTimer, WatchCursor, 100
StopIt := 0
Sleep, 100
WaitFor.Key("RButton")
SetTimer, WatchCursor, off
ToolTip
Sleep, 200
Hotkey, RButton, NoKey, Off
Hotkey, Esc, EscNoKey, Off
WinActivate, ahk_id %CmdWin%
If (StopIt)
	Exit
GuiControl,, DefCt, %control%
FoundTitle := ""
If (Ident1)
	FoundTitle .= Title
If (Ident2)
	FoundTitle .= " ahk_class " class
If (Ident3)
	FoundTitle .= " ahk_exe " pname
If (Ident4)
	FoundTitle .= " ahk_id " id
If (Ident5)
	FoundTitle .= " ahk_pid " pid
FoundTitle := Trim(FoundTitle)
If (FoundTitle = "")
	FoundTitle := " ahk_class " class
Window := FoundTitle
GuiControl,, Title, %FoundTitle%
StopIt := 1
return

WinTitle:
Menu, WinTitleMenu, Add, Title, SetWinTitle
Menu, WinTitleMenu, Add, Class, SetWinTitle
Menu, WinTitleMenu, Add, Process, SetWinTitle
Menu, WinTitleMenu, Add, ID, SetWinTitle
Menu, WinTitleMenu, Add, PID, SetWinTitle

StringSplit, Ident, GetWinTitle, `,
Loop, 5
	Ident%A_Index% := Ident%A_Index% ? 1 : 0

If (Ident1)
	Menu, WinTitleMenu, Check, Title
If (Ident2)
	Menu, WinTitleMenu, Check, Class
If (Ident3)
	Menu, WinTitleMenu, Check, Process
If (Ident4)
	Menu, WinTitleMenu, Check, ID
If (Ident5)
	Menu, WinTitleMenu, Check, PID

GuiControlGet, ButPos, Pos, %A_GuiControl%
Menu, WinTitleMenu, Show, % ButPosX + 2, % (ButPosY + ButPosH * 2) + 2
Menu, WinTitleMenu, DeleteAll
return

SetWinTitle:
GetWinTitle := ""
Loop, 5
	GetWinTitle .= (A_Index = A_ThisMenuItemPos ? !Ident%A_Index% : Ident%A_Index%) ","
return

GetWin:
StringSplit, Ident, GetWinTitle, `,
Loop, 5
	Ident%A_Index% := Ident%A_Index% ? 1 : 0

CoordMode, Mouse, %CoordMouse%
Gui, Submit, NoHide
Hotkey, RButton, NoKey, On
Hotkey, Esc, EscNoKey, On
WinMinimize, ahk_id %CmdWin%
SetTimer, WatchCursor, 100
StopIt := 0
Sleep, 100
WaitFor.Key("RButton")
SetTimer, WatchCursor, off
ToolTip
Sleep, 200
Hotkey, RButton, NoKey, Off
Hotkey, Esc, EscNoKey, Off
WinActivate, ahk_id %CmdWin%
If (StopIt)
	Exit
StringSplit, Ident, GetWinTitle, `,
Loop, 5
	Ident%A_Index% := Ident%A_Index% ? 1 : 0
FoundTitle := ""
EscCom(false, Title)
If (Ident1)
	FoundTitle .= Title
If (Ident2)
	FoundTitle .= " ahk_class " class
If (Ident3)
	FoundTitle .= " ahk_exe " pname
If (Ident4)
	FoundTitle .= " ahk_id " id
If (Ident5)
	FoundTitle .= " ahk_pid " pid
FoundTitle := Trim(FoundTitle)
If (FoundTitle = "")
	FoundTitle := Title
If (Label != "IfGet")
	GuiControl,, Title, %FoundTitle%
StopIt := 1
return

WinGetP:
CoordMode, Mouse, %CoordMouse%
Gui, Submit, NoHide
Hotkey, RButton, NoKey, On
Hotkey, Esc, EscNoKey, On
WinMinimize, ahk_id %CmdWin%
SetTimer, WatchCursor, 100
StopIt := 0
Sleep, 100
WaitFor.Key("RButton")
WinGetPos, X, Y, W, H, ahk_id %id%
SetTimer, WatchCursor, off
ToolTip
Sleep, 200
Hotkey, RButton, NoKey, Off
Hotkey, Esc, EscNoKey, Off
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
Hotkey, RButton, NoKey, On
Hotkey, Esc, EscNoKey, On
WinMinimize, ahk_id %CmdWin%
SetTimer, WatchCursor, 100
StopIt := 0
Sleep, 100
WaitFor.Key("RButton")
ControlGetPos, X, Y, W, H, %control%, ahk_id %id%
SetTimer, WatchCursor, off
ToolTip
Sleep, 200
Hotkey, RButton, NoKey, Off
Hotkey, Esc, EscNoKey, Off
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
SS := 1
GetArea:
Gui, Submit, NoHide
Draw := 1
WinMinimize, ahk_id %CmdWin%
FirstCall := true
CoordMode, Mouse, Screen
Gui, 20:-Caption +ToolWindow +LastFound +AlwaysOnTop
Gui, 20:Color, %SearchAreaColor%
SetTimer, WatchCursor, 100
return

DrawStart:
AreaSet := False
SetTimer, WatchCursor, Off
CoordMode, Mouse, %CoordPixel%
MouseGetPos, iX, iY
CoordMode, Mouse, Screen
MouseGetPos, OriginX, OriginY
If (CoordPixel = "Window")
{
	CoordMode, Mouse, Window
	MouseGetPos, xPos, yPos
}
SetTimer, DrawRectangle, 0
KeyWait, %DrawButton%
GoSub, DrawEnd
return

DrawEnd:
SetTimer, DrawRectangle, Off
FirstCall := true
ToolTip
CoordMode, Mouse, %CoordPixel%
MouseGetPos, eX, eY
If ((iX = eX) || (iY = eY))
	MarkArea(LineW)
Else
	GoSub, ShowAreaTip
If (OnRelease)
	GoSub, Restore
return

Restore:
Tooltip
Gui, 20:+LastFound
WinGetPos, wX, wY, wW, wH
Gui, 20:Cancel
AdjustCoords(iX, iY, eX, eY)
Sleep, 200
Draw := 0
If (SS = 1)
{
	If (ScreenDir = "")
		ScreenDir := SettingsFolder "\Screenshots"
	IfNotExist, %ScreenDir%
		FileCreateDir, %ScreenDir%
	file := ScreenDir "\Screen_" A_Now ".png", screen := wX "|" wY "|" wW "|" wH
	Screenshot(file, screen)
	GuiControl, 19:, ImgFile, %file%
	GoSub, MakePrev
	SS := 0
	If (!GetKeyState("Alt", "P"))
	{
		WinActivate, ahk_id %CmdWin%
		return
	}
}
If (AreaSet)
	iX := wX, iY := wY, eX := wX + wW, eY := wY + wH
Else If ((iX = eX) || (iY = eY)) && (control != "")
	GuiControl, 19:ChooseString, CoordPixel, Window
Else If (CoordPixel = "Screen")
	iX := wX, iY := wY, eX := wX + wW, eY := wY + wH
WinActivate, ahk_id %CmdWin%
GuiControl, 19:, iPosX, %iX%
GuiControl, 19:, iPosY, %iY%
GuiControl, 19:, ePosX, %eX%
GuiControl, 19:, ePosY, %eY%
return

GetPixel:
Gui, 19:Submit, NoHide
If (A_GuiControl = "ColorPick")
	iPixel := 1
Hotkey, RButton, NoKey, On
Hotkey, Esc, EscNoKey, On
WinMinimize, ahk_id %CmdWin%
SetTimer, WatchCursor, 10
StopIt := 0
Sleep, 100
WaitFor.Key("RButton")
SetRegionNow := GetKeyState("Alt", "P")
SetTimer, WatchCursor, off
ToolTip
Sleep, 200
Hotkey, RButton, NoKey, Off
Hotkey, Esc, EscNoKey, Off
iPixel := 0
WinActivate, ahk_id %CmdWin%
If (StopIt)
	Exit
If (A_GuiControl = "TransCS")
	GuiControl, 19:, TransC, %color%
Else
{
	GuiControl, 19:, ImgFile, %color%
	GuiControl, 19:+Background%color%, ColorPrev
	If (SetRegionNow)
	{
		GuiControl, 19:, iPosX, %xPos%
		GuiControl, 19:, iPosY, %yPos%
		GuiControl, 19:, ePosX, %xPos%
		GuiControl, 19:, ePosY, %yPos%
	}
}
StopIt := 1
return

WatchCursor:
CoordMode, Mouse, % (Draw || iPixel) ? CoordPixel : CoordMouse
CoordMode, Pixel, % (Draw || iPixel) ? CoordPixel : CoordMouse
ExtraTip := (iPixel || SS) ? d_Lang115 : ""
MouseGetPos, xPos, yPos, id, control
WinGetTitle, title, ahk_id %id%
WinGetClass, class, ahk_id %id%
WinGetText, text, ahk_id %id%
text := SubStr(text, 1, 50)
WinGet, pid, PID, ahk_id %id%
PixelGetColor, color, %xPos%, %yPos%, % (iPixel) ? (RGB ? "RGB" : "") : "RGB"
WinGet, pname, ProcessName, ahk_id %id%
ControlGetPos, cX, cY, cW, cH, %control%, ahk_id %id%
xcpos := Controlpos(xPos, cx), ycpos := Controlpos(yPos, cy)
DrawTip := RegExReplace(d_Lang034, "%DrawButton%", DrawButton)
If (Draw)
	ToolTip,
	(LTrim
	X%xPos% Y%yPos%
	%c_Lang004%: %control%
	%DrawTip%
	%ExtraTip%
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
	%ExtraTip%
	)
return

WatchCursorIE:
CoordMode, Mouse, Window
MouseGetPos, xPos, yPos, id
WinGetClass, class, ahk_id %id%
WinGetTitle, title, ahk_id %id%
If (class != "IEFrame")
{
	Tooltip, %d_Lang045%
	return
}
If (L_Label = "InternetExplorer.Application")
	Tooltip, %d_Lang017%
Else
{
	ControlGetPos, IEFrameX, IEFrameY, IEFrameW, IEFrameH, Internet Explorer_Server1, ahk_class IEFrame
	Element := ie.document.elementFromPoint(xPos-IEFrameX, yPos-IEFrameY)
	oel_Name := Element.Name
	oel_ID := Element.ID
	oel_ClassName := Element.ClassName
	oel_TagName := Element.TagName
	oel_Value := Element.Value
	oel_InnerText := (StrLen(Element.InnerText) > 50) ? SubStr(Element.InnerText, 1, 50) "..." : Element.InnerText
	oel_Type := Element.Type
	oel_Checked := Element.Checked
	oel_SelectedIndex := Element.SelectedIndex
	oel_SourceIndex := Element.sourceindex
	oel_Links := "Links"
	oel_OffsetLeft := Element.OffsetLeft
	oel_OffsetTop := Element.OffsetTop

	Tooltip  % "Name: " oel_Name
		. "`nID: " oel_ID
		. "`nClassName: " oel_ClassName
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
If (class != "XLMAIN")
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
  FirstCall := false
}
WinMove, , , X1, Y1, W1, H1
DrawTip := RegExReplace(d_Lang034, "%DrawButton%", DrawButton)
If (CoordPixel = "Window")
{
	CoordMode, Mouse, Window
	MouseGetPos, xPos2, yPos2
	If ((X2 > OriginX) || (Y2 > OriginY))
		ToolTip, X%xPos% Y%yPos%`nX%xPos2% Y%yPos2%`n%DrawTip%`n%ExtraTip%
	Else
		ToolTip, X%xPos% Y%yPos%`nX%xPos2% Y%yPos2%`n%DrawTip%`n%ExtraTip%, % OriginX +8, % OriginY +8
}
Else
{
	If ((X2 > OriginX) || (Y2 > OriginY))
		ToolTip, X%X1% Y%Y1%`nX%X2% Y%Y2%`n%DrawTip%`n%ExtraTip%
	Else
		ToolTip, X%X1% Y%Y1%`nX%X2% Y%Y2%`n%DrawTip%`n%ExtraTip%, % OriginX +8, % OriginY +8
}
return

ShowAreaTip:
Gui, 20:+LastFound
WinGetPos,,, gwW, gwH
Tooltip,
(
%c_Lang059%: %gwW% x %gwH%
%d_Lang057%
%ExtraTip%
)
return

EditText:
s_Caller := "Edit"
Text:
Gui 7:+LastFoundExist
IfWinExist
	GoSub, InsertKeyClose
Gui, 1:Submit, NoHide
Gui, 8:+owner1 -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
Gui, 8:Add, Custom, ClassToolbarWindow32 hwndhTbText gTbText H25 0x0800 0x0100 0x0040 0x0008 0x0004
Gui, 8:Add, Edit, Section xm ym+25 vTextEdit gTextEdit WantTab W710 R25
; Options
Gui, 8:Add, GroupBox, Section W220 H135, %c_Lang163%:
Gui, 8:Add, Radio, -Wrap Group Checked ys+20 xs+10 W200 vRaw gRaw R1, %c_Lang045%
Gui, 8:Add, Radio, -Wrap W200 vComText gComText R1, %c_Lang046%
Gui, 8:Add, Radio, -Wrap y+20 W200 vClip gClip R1, %c_Lang047%
Gui, 8:Add, Radio, -Wrap W200 vEditPaste gEditPaste R1, %c_Lang048%
Gui, 8:Add, Radio, -Wrap W200 vSetText gSetText R1, %c_Lang049%
Gui, 8:Add, Checkbox, -Wrap yp-55 xp+15 W185 vComEvent gComEvent R1 Disabled, %c_Lang178%
; Repeat
Gui, 8:Add, GroupBox, Section ys x+20 W230 H135
Gui, 8:Add, Text, -Wrap R1 ys+15 xs+10 W100 Right, %w_Lang015%:
Gui, 8:Add, Edit, yp x+10 W100 R1 vEdRept
Gui, 8:Add, UpDown, vTimesX 0x80 Range1-999999999, 1
Gui, 8:Add, Text, -Wrap R1 y+5 xs+10 W100 Right, %c_Lang017%:
Gui, 8:Add, Edit, yp x+10 W100 vDelayC
Gui, 8:Add, UpDown, vDelayX 0x80 Range0-999999999, %DelayG%
Gui, 8:Add, Radio, -Wrap Checked W100 vMsc R1, %c_Lang018%
Gui, 8:Add, Radio, -Wrap W100 vSec R1, %c_Lang019%
Gui, 8:Add, Text, -Wrap y+5 xs+10 W100 Right, %c_Lang179%:
Gui, 8:Add, Edit, yp x+10 W100 vKeyDelayC Disabled
Gui, 8:Add, UpDown, vKeyDelayX 0x80 Range-1-1000, -1
; Control
Gui, 8:Add, GroupBox, Section ys x+20 W240 H135
Gui, 8:Add, Checkbox, -Wrap ys+15 xs+10 W150 vCSend gCSend R1, %c_Lang016%:
Gui, 8:Add, Edit, vDefCt W190 Disabled
Gui, 8:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetCtrl gGetCtrl Disabled, ...
Gui, 8:Add, Text, -Wrap y+15 xs+10 W140 H20 vWinParsTip cGray, %Wcmd_Short%
Gui, 8:Add, Button, yp-5 x+5 W75 vIdent gWinTitle Disabled, WinTitle
Gui, 8:Add, Edit, y+5 xs+10 W190 vTitle Disabled, A
Gui, 8:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetWin gGetWin Disabled, ...
; Buttons
Gui, 8:Add, Button, -Wrap Section Default xm W75 H23 gTextOK, %c_Lang020%
Gui, 8:Add, Button, -Wrap ys W75 H23 gTextCancel, %c_Lang021%
Gui, 8:Add, Button, -Wrap ys W75 H23 vTextApply gTextApply Disabled, %c_Lang131%
Gui, 8:Add, Button, -Wrap ys W25 H23 hwndInsertKeyT vInsertKeyT gInsertKey Disabled
	ILButton(InsertKeyT, ResDllPath ":" 91)
Gui, 8:Add, Text, x+10 yp-3 W400 H25 cGray, %c_Lang025%
Gui, 8:Add, StatusBar, gStatusBarHelp
Gui, 8:Default
SB_SetParts(600, 70)
SB_SetText("length: " 0, 2)
SB_SetText("lines: " 0, 3)
SB_SetIcon(ResDllPath, IconsNames["help"])
If (s_Caller = "Edit")
{
	EscCom(true, Details, Target)
	StringReplace, Details, Details, ``n, `n, All
	GuiControl, 8:, TextEdit, %Details%
	GuiControl, 8:, TimesX, %TimesX%
	GuiControl, 8:, EdRept, %TimesX%
	GuiControl, 8:, DelayX, %DelayX%
	GuiControl, 8:, DelayC, %DelayX%
	If (InStr(Type, "Control"))
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
	If ((Type = cType1) || (Type = cType2) || (Type = cType13))
	{
		GuiControl, 8:, ComText, 1
		If (!InStr(Type, "Control"))
			GuiControl, 8:Enable, ComEvent
		GuiControl, 8:Enable, InsertKeyT
		SBShowTip((CSend ? "Control" : "") "Send")
		If (Type = cType13)
		{
			GuiControl, 8:, ComEvent, 1
			GuiControl, 8:, DelayC, %DelayG%
			GuiControl, 8:, DelayX, %DelayG%
			GuiControl, 8:, KeyDelayX, %DelayX%
			GuiControl, 8:, KeyDelayC, %DelayX%
			GoSub, ComEvent
		}
	}
	Else If ((Type = cType8) || (Type = cType9))
	{
		GuiControl, 8:, Raw, 1
		SBShowTip((CSend ? "Control" : "") "SendRaw")
	}
	Else If (Type = cType10)
	{
		GuiControl, 8:, SetText, 1
		GuiControl, 8:Disable, CSend
		SBShowTip("ControlSetText")
	}
	Else If (Type = cType22)
	{
		GuiControl, 8:, EditPaste, 1
		GuiControl, 8:Disable, CSend
		SBShowTip("ControlEditPaste")
	}
	Else If (Type = cType12)
	{
		GuiControl, 8:, Clip, 1
		SBShowTip("Clipboard")
	}
	Gui, 8:Default
		GoSub, TextEdit
	Gui, chMacro:Default
	GuiControl, 8:Enable, TextApply
}
If (s_Caller = "Find")
{
	Gui, 8:Default
	Switch GotoRes1
	{
		Case cType8:
			GuiControl, 8:, Raw, 1
			GoSub, Raw
		Case cType1:
			GuiControl, 8:, ComText, 1
			GoSub, ComText
		Case cType12:
			GuiControl, 8:, Clip, 1
			GoSub, Clip
		Case cType22:
			GuiControl, 8:, EditPaste, 1
			GoSub, EditPaste
		Case cType10:
			GuiControl, 8:, SetText, 1
			GoSub, SetText
	}
}
Else
	SBShowTip("SendRaw")
Gui, 8:Font, s%MacroFontSize%
GuiControl, 8:Font, TextEdit
Gui, 8:Show,, %c_Lang002%
ChangeIcon(hIL_Icons, CmdWin, IconsNames["text"])
TB_Define(TbText, hTbText, hIL_Icons, FixedBar.Text, FixedBar.TextOpt)
TBHwndAll[9] := TbText
GuiControl, 8:Focus, TextEdit
Input
Tooltip
return

TextApply:
TextOK:
Gui, 8:+OwnDialogs
Gui, 8:Submit, NoHide
StringReplace, TextEdit, TextEdit, `n, ``n, All
DelayX := (ComEvent) ? (InStr(KeyDelayC, "%") ? KeyDelayC : KeyDelayX)
:	InStr(DelayC, "%") ? DelayC : DelayX
TimesX := InStr(EdRept, "%") ? EdRept : TimesX
If (Raw = 1)
	Type := cType8
Else If (ComText = 1)
	Type := (ComEvent) ? cType13 : cType1
Else If (SetText = 1)
	Type := cType10
Else If (EditPaste = 1)
	Type := cType22
Else If (Clip = 1)
	Type := cType12
GuiControlGet, CtrlState, Enabled, DefCt
If (CtrlState = 1)
{
	If (CSend = 1)
	{
		If (DefCt = "")
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
		If (CSend = 0)
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
EscCom(false, TextEdit, Target)
If (A_ThisLabel != "TextApply")
{
	Gui, 1:-Disabled
	Gui, 8:Destroy
}
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected"), LV_GetText(RowType, LV_GetNext(), 6)
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", Action, TextEdit, TimesX, DelayX, Type, Target, Window)
Else If ((RowSelection = 0) || ((RowType = cType47) || RowType = cType48))
{
	LV_Add("Check", ListCount%A_List%+1, Action, TextEdit, TimesX, DelayX, Type, Target, Window)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	GuiControl, chMacro:-g, InputList%A_List%
	RowNumber := 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, Action, TextEdit, TimesX, DelayX, Type, Target, Window)
		LVManager[A_List].InsertAtGroup(RowNumber)
		RowNumber++
	}
	GuiControl, chMacro:+gInputList, InputList%A_List%
}
GoSub, RowCheck
GoSub, b_Start
If (A_ThisLabel = "TextApply")
	Gui, 8:Default
Else
{
	s_Caller := ""
	GuiControl, Focus, InputList%A_List%
}
return

TextCancel:
8GuiClose:
8GuiEscape:
Gui, 1:-Disabled
Gui, 8:Destroy
s_Caller := ""
return

Raw:
GuiControl, Enable, CSend
GuiControl, Enable, DefCt
GuiControl, Enable, GetCtrl
GuiControl, Disable, InsertKeyT
GuiControl,, ComEvent, 0
GuiControl, Disable, ComEvent
GuiControl, Disable, KeyDelayC
GuiControl, Disable, KeyDelayX
GuiControl, Enable, DelayC
GuiControl, Enable, DelayX
GoSub, CSend
Gui 7:+LastFoundExist
IfWinExist
	GoSub, InsertKeyClose
SBShowTip((CSend ? "Control" : "") "SendRaw")
return

ComText:
GuiControl, Enable, CSend
GuiControl, Enable, DefCt
GuiControl, Enable, GetCtrl
GuiControl, Enable, InsertKeyT
GuiControl, Enable, ComEvent
GoSub, CSend
SBShowTip((CSend ? "Control" : "") "Send")
return

SetText:
GuiControl, , CSend, 1
GuiControl, Disable, CSend
GuiControl, Enable, DefCt
GuiControl, Enable, GetCtrl
GuiControl, Disable, InsertKeyT
GuiControl,, ComEvent, 0
GuiControl, Disable, ComEvent
GuiControl, Disable, KeyDelayC
GuiControl, Disable, KeyDelayX
GuiControl, Enable, DelayC
GuiControl, Enable, DelayX
GoSub, CSend
Gui 7:+LastFoundExist
IfWinExist
	GoSub, InsertKeyClose
SBShowTip("ControlSetText")
return

Clip:
GuiControl, Enable, CSend
GuiControl, Enable, DefCt
GuiControl, Enable, GetCtrl
GuiControl, Disable, InsertKeyT
GuiControl,, ComEvent, 0
GuiControl, Disable, ComEvent
GuiControl, Disable, KeyDelayC
GuiControl, Disable, KeyDelayX
GuiControl, Enable, DelayC
GuiControl, Enable, DelayX
GoSub, CSend
Gui 7:+LastFoundExist
IfWinExist
	GoSub, InsertKeyClose
SBShowTip("Clipboard")
return

EditPaste:
GuiControl, , CSend, 1
GuiControl, Disable, CSend
GuiControl, Enable, DefCt
GuiControl, Enable, GetCtrl
GuiControl, Disable, InsertKeyT
GuiControl,, ComEvent, 0
GuiControl, Disable, ComEvent
GuiControl, Disable, KeyDelayC
GuiControl, Disable, KeyDelayX
GuiControl, Enable, DelayC
GuiControl, Enable, DelayX
GoSub, CSend
Gui 7:+LastFoundExist
IfWinExist
	GoSub, InsertKeyClose
SBShowTip("ControlEditPaste")
return

ComEvent:
Gui, Submit, NoHide
GuiControl, Enable%ComEvent%, KeyDelayC
GuiControl, Enable%ComEvent%, KeyDelayX
GuiControl, Disable%ComEvent%, DelayC
GuiControl, Disable%ComEvent%, DelayX
GuiControl, Disable%ComEvent%, Sec
GuiControl,, Msc, 1
return

TextEdit:
Gui, Submit, NoHide
StringSplit, cL, TextEdit, `n, `r
SB_SetText("length: " StrLen(TextEdit), 2)
SB_SetText("lines: " cL0, 3)
If (InStr(TextEdit, "<html>"))
	GuiControl,, IsHtml, 1
return

OpenT:
Gui, +OwnDialogs
FileSelectFile, TextFile, 3,, %AppName%
FreeMemory()
If (!TextFile)
	return
FileRead, InText, %TextFile%
GuiControl,, TextEdit, %InText%
GoSub, TextEdit
return

SaveT:
Gui, Submit, NoHide
Gui +OwnDialogs
FileSelectFile, TextFile, S16,, %AppName%
FreeMemory()
If (TextFile = "")
	Exit
SplitPath, TextFile,,, ext
If (ext = "")
	TextFile .= ".txt"
IfExist %TextFile%
{
	FileDelete %TextFile%
	If (ErrorLevel)
	{
		MsgBox, 16, %d_Lang007%, %d_Lang006% "%TextFile%".
		return
	}
}
FileAppend, %TextEdit%, %TextFile%
return

39GuiDropfiles:
Loop, Parse, A_GuiEvent, `n
{
	Loop, % LV_GetCount()
	{
		LV_GetText(RowText, A_Index)
		If (A_LoopField = RowText)
			continue 2
	}
	LV_Add("", A_LoopField)
}
return

CutT:
PostMessage, WM_CUT, 0, 0, Edit1, ahk_id %CmdWin%
return

CopyT:
PostMessage, WM_COPY, 0, 0, Edit1, ahk_id %CmdWin%
return

PasteT:
PostMessage, WM_PASTE, 0, 0, Edit1, ahk_id %CmdWin%
return

SelAllT:
Gui, Submit, NoHide
PostMessage, 0x00B1, 0, StrLen(TextEdit) + cL0, Edit1, ahk_id %CmdWin%
return

RemoveT:
PostMessage, WM_CLEAR, 0, 0, Edit1, ahk_id %CmdWin%
return

EditKeyWait:
EditMsgBox:
EditSleep:
s_Caller := "Edit"
KeyWait:
MsgBox:
Sleep:
Gui, 3:+owner1 -MinimizeBox +Delimiter%_x% +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
Gui, 3:Add, Tab2, W450 H0 vTabControl AltSubmit, CmdTab1%_x%CmdTab2%_x%CmdTab3
; Sleep
Gui, 3:Add, GroupBox, Section xm ym W450 H125
Gui, 3:Add, Text, -Wrap R1 ys+20 xs+10 W180 Right, %c_Lang050%:
Gui, 3:Add, Edit, yp-2 x+10 W100 vDelayC
Gui, 3:Add, UpDown, vDelayX 0x80 Range0-2147483647, 300
Gui, 3:Add, Radio, -Wrap Checked y+12 W170 vMsc R1, %c_Lang018%
Gui, 3:Add, Radio, -Wrap W170 vSec R1, %c_Lang019%
Gui, 3:Add, Radio, -Wrap W170 vMin R1, %c_Lang154%
Gui, 3:Add, GroupBox, Section xs y+30 W450 H130
Gui, 3:Add, Checkbox, -Wrap R1 ys+20 xs+10 W100 vRandom gRandomSleep, %c_Lang180%
Gui, 3:Add, Text, Section -Wrap yp x+5 W75 R1 Right, %c_Lang181%:
Gui, 3:Add, Edit, yp-2 x+10 W100 R1 vRandMin Disabled
Gui, 3:Add, UpDown, vRandMinimum 0x80 Range0-2147483647, 0
Gui, 3:Add, Text, -Wrap y+10 xs W75 R1 Right, %c_Lang182%:
Gui, 3:Add, Edit, yp-2 x+10 W100 R1 vRandMax Disabled
Gui, 3:Add, UpDown, vRandMaximum 0x80 Range0-2147483647, 500
Gui, 3:Add, Checkbox, -Wrap y+20 xm+10 W400 vNoRandom gNoRandom, %c_Lang183%
Gui, 3:Tab, 2
; MsgBox
Gui, 3:Add, GroupBox, Section ym xm W450 H105, %c_Lang015%:
Gui, 3:Add, Edit, ys+20 xs+10 W430 R5 WantTab vMsgPt
; Options
Gui, 3:Add, Groupbox, Section y+17 xs W450 H150, %w_Lang003%:
Gui, 3:Add, Text, -Wrap ys+17 xs+10 W70 R1 Right, %c_Lang189%:
Gui, 3:Add, Edit, -Wrap yp-2 x+10 W160 R1 vTitle
Gui, 3:Add, Text, -Wrap ys+17 x+10 W70 R1 Right, %c_Lang147%:
Gui, 3:Add, DDL, yp-2 x+10 W100 AltSubmit vIcon, %c_Lang148%%_x%%_x%%c_Lang149%%_x%%c_Lang150%%_x%%c_Lang151%%_x%%c_Lang152%
Gui, 3:Add, Text, -Wrap R1 y+12 xs+10 W70 Right, %c_Lang185%:
Gui, 3:Add, DDL, yp-2 x+10 W160 AltSubmit vButtons,
(Join%_x%
%c_Lang170%%_x%
%c_Lang170%/%c_Lang171%
%c_Lang172%/%c_Lang173%/%c_Lang174%
%c_Lang168%/%c_Lang169%/%c_Lang171%
%c_Lang168%/%c_Lang169%
%c_Lang174%/%c_Lang171%
%c_Lang171%/%c_Lang176%/%c_Lang175%
)
Gui, 3:Add, Text, -Wrap R1 yp+2 x+10 W70 Right, %t_Lang063%:
Gui, 3:Add, DDL, yp-2 x+10 W100 AltSubmit vDefault, %c_Lang186%%_x%%_x%%c_Lang187%%_x%%c_Lang188%
Gui, 3:Add, Checkbox, -Wrap W200 y+10 xs+10 vAot R1, %c_Lang153%
Gui, 3:Add, Checkbox, -Wrap W200 yp x+10 vRightJ R1, %c_Lang243%
Gui, 3:Add, Checkbox, -Wrap W200 y+10 xs+10 vRightRead R1, %c_Lang244%
Gui, 3:Add, CheckBox, -Wrap W200 yp x+10 vAddIf, %c_Lang162%
Gui, 3:Add, Text, -Wrap y+10 xs+10 W145 R1, %c_Lang177% (%c_Lang019%):
Gui, 3:Add, Edit, yp-3 x+5 W50 vTimeoutM
Gui, 3:Add, UpDown, vTimeoutMsg 0x80 Range0-2147483, 0
Gui, 3:Add, Text, -Wrap R1 yp x+10 W110, %w_Lang015%:
Gui, 3:Add, Edit, yp x+10 W100 R1 vEdRept
Gui, 3:Add, UpDown, vTimesX 0x80 Range1-999999999, 1
; KeyWait
Gui, 3:Tab, 3
Gui, 3:Add, GroupBox, Section xm ym W450 H140
Gui, 3:Add, Text, -Wrap ys+40 xs+10 W180 R1 Right vWaitKeysT, %c_Lang052%:
Gui, 3:Add, Hotkey, yp x+10 vWaitKeys gWaitKeys W120
Gui, 3:Add, Checkbox, y+20 xs+10 -Wrap W180 R1 Right vWaitKeyList gWaitKeyList, %c_Lang184%:
Gui, 3:Add, Combobox, yp-3 x+10 W120 vKeyW gAutoComplete Disabled, %KeybdList%
Gui, 3:Add, GroupBox, Section xm y+45 W450 H118
Gui, 3:Add, Text, -Wrap R1 ys+40 xs+10 vTimoutT W180 Right, %c_Lang053%:
Gui, 3:Add, Edit, Section yp-2 x+10 W120 vTimeoutC
Gui, 3:Add, UpDown, vTimeout 0x80 Range0-999999999, 0
Gui, 3:Add, Text, -Wrap R1 y+10 xs, %c_Lang054%
Gui, 3:Tab
Gui, 3:Add, Button, -Wrap Section Default xm W75 H23 gPauseOK, %c_Lang020%
Gui, 3:Add, Button, -Wrap ys W75 H23 gPauseCancel, %c_Lang021%
Gui, 3:Add, Button, -Wrap ys W75 H23 vPauseApply gPauseApply Disabled, %c_Lang131%
Gui, 3:Add, Text, x+10 yp-3 W190 H25 cGray, %c_Lang025%
Gui, 3:Add, StatusBar, gStatusBarHelp
Gui, 3:Default
SB_SetIcon(ResDllPath, IconsNames["help"])
If (s_Caller = "Edit")
{
	EscCom(true, Details, Target, Window)
	StringReplace, Details, Details, ``n, `n, All
	If (Type = cType5)
	{
		GuiControl, 3:, DelayX
		If (Details = "Random")
		{
			GuiControl, 3:, Random, 1
			If (InStr(DelayX, "%"))
				GuiControl, 3:, RandMin, %DelayX%
			Else
				GuiControl, 3:, RandMinimum, %DelayX%
			If (InStr(Target, "%"))
				GuiControl, 3:, RandMax, %Target%
			Else
				GuiControl, 3:, RandMaximum, %Target%
			GoSub, RandomSleep
		}
		Else
		{
			If (InStr(DelayX, "%"))
				GuiControl, 3:, DelayC, %DelayX%
			Else
				GuiControl, 3:, DelayX, %DelayX%
		}
		If (Details = "NoRandom")
		{
			GuiControl, 3:, NoRandom, 1
			GuiControl, 3:Disable%NoRandom%, Random
		}
	}
	If (Type = cType6)
	{
		GuiControl, 3:, CancelB, 0
		GuiControl, 3:, MsgPt, %Details%
		GuiControl, 3:, Title, %Window%
		GuiControl, 3:, TimesX, %TimesX%
		GuiControl, 3:, EdRept, %TimesX%
		GuiControl, 3:, DelayX, 0
		If (InStr(DelayX, "%"))
			GuiControl, 3:, TimeoutM, %DelayX%
		Else
			GuiControl, 3:, TimeoutMsg, %DelayX%
		InStyles := "|", MsgButton := 0
		For i, v in MsgBoxStyles
		{
			If (Target & v)
				InStyles .= v "|", Target -= v
		}
		Loop, 6
		{
			ic := (7-A_Index)
			If ((Target & ic) = ic)
			{
				MsgButton := ic, Target -= ic
				break
			}
		}
		GuiControl, 3:, RightRead, % InStr(InStyles, "|" MsgBoxStyles[1] "|") ? 1 : 0
		GuiControl, 3:, RightJ, % InStr(InStyles, "|" MsgBoxStyles[2] "|") ? 1 : 0
		GuiControl, 3:, Aot, % InStr(InStyles, "|" MsgBoxStyles[3] "|") ? 1 : 0
		GuiControl, 3:Choose, Default, % (InStr(InStyles, "|" MsgBoxStyles[4] "|")) ? 3 : (InStr(InStyles, "|" MsgBoxStyles[5] "|")) ? 2 : 1
		GuiControl, 3:Choose, Icon, % (Target = 64) ? 5 : (Target = 48) ? 4 : (Target = 32) ? 3	: (Target = 16) ? 2 : 1
		GuiControl, 3:Choose, Buttons, % MsgButton + 1
	}
	Else If (Type = cType20)
	{
		GuiControl, 3:, WaitKeys, %Details%
		GuiControl, 3:, Timeout
		If (InStr(DelayX, "%"))
			GuiControl, 3:, TimeoutC, %DelayX%
		Else
			GuiControl, 3:, Timeout, %DelayX%
	}
	GuiControl, 3:Enable, PauseApply
	GuiControl, 3:, AddIf, 0
	GuiControl, 3:Disable, AddIf
}
If (InStr(A_ThisLabel, "MsgBox"))
{
	GuiControl, 3:Choose, TabControl, 2
	GuiTitle := c_Lang051
}
Else If (InStr(A_ThisLabel, "KeyWait"))
{
	GuiControl, 3:Choose, TabControl, 3
	GuiTitle := c_Lang066
}
Else
	GuiTitle := c_Lang003
SBShowTip(LTrim(A_ThisLabel, "Edit"))
Gui, 3:Show,, %GuiTitle%
ChangeIcon(hIL_Icons, CmdWin, InStr(A_ThisLabel, "Sleep") ? IconsNames["pause"] : InStr(A_ThisLabel, "MsgBox") ? IconsNames["dialogs"] : IconsNames["wait"])
Input
Tooltip
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

RandomSleep:
Gui, 3:Submit, NoHide
GuiControl, 3:Disable%Random%, DelayC
GuiControl, 3:Disable%Random%, DelayX
GuiControl, 3:Disable%Random%, Msc
GuiControl, 3:Disable%Random%, Sec
GuiControl, 3:Disable%Random%, Min
GuiControl, 3:Disable%Random%, NoRandom
GuiControl, 3:Enable%Random%, RandMin
GuiControl, 3:Enable%Random%, RandMinimum
GuiControl, 3:Enable%Random%, RandMax
GuiControl, 3:Enable%Random%, RandMaximum
return

NoRandom:
Gui, 3:Submit, NoHide
GuiControl, 3:Disable%NoRandom%, Random
return

WaitKeyList:
Gui, 3:Submit, NoHide
GuiControl, 3:Enable%WaitKeyList%, KeyW
GuiControl, 3:Disable%WaitKeyList%, WaitKeys
return

PauseApply:
PauseOK:
Gui, 3:Submit, NoHide
DelayX := (Random) ? (InStr(RandMin, "%") ? RandMin : RandMinimum)
:	(InStr(DelayC, "%") ? DelayC : DelayX)
If (Sec = 1)
	DelayX *= 1000
Else If (Min = 1)
	DelayX *= 60000
If (TabControl = 2)
{
	Type := cType6, Details := MsgPT, DelayX := (InStr(TimeoutM, "%") ? TimeoutM : TimeoutMsg)
	Target := 0
	Target += Aot ? 262144 : 0
	Target += RightJ ? 524288 : 0
	Target += RightRead ? 1048576 : 0
	Target += (Default-1) * 256
	Target += (Icon-1) * 16
	Target += (Buttons-1)
	EscCom(false, Details, Title)
	TimesX := InStr(EdRept, "%") ? EdRept : TimesX
	StringReplace, Details, Details, `n, ``n, All
}
Else If (TabControl = 3)
{
	If ((!WaitKeyList) && (WaitKeys = ""))
	{
		Gui, 3:Font, cRed
		GuiControl, 3:Font, WaitKeysT
		GuiControl, 3:Focus, WaitKeys
		return
	}
	If ((WaitKeyList) && (KeyW = ""))
	{
		GuiControl, 3:Focus, KeyW
		return
	}
	Type := cType20, tKey := (WaitKeyList) ? KeyW : WaitKeys
	Details := tKey, Target := "", Title := ""
	DelayX := InStr(TimeoutC, "%") ? TimeoutC : Timeout
}
Else
{
	Type := cType5, Title := "", Details := (NoRandom) ? "NoRandom" : ((Random) ? "Random" : "")
	Target := (Random) ? (InStr(RandMax, "%") ? RandMax : RandMaximum) : ""
}
If (A_ThisLabel != "PauseApply")
{
	Gui, 1:-Disabled
	Gui, 3:Destroy
}
Action := (Type = cType5) ? "[Pause]" : "[" Type "]"
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected"), LV_GetText(RowType, LV_GetNext(), 6)
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", Action, Details, TimesX, DelayX, Type, Target, Title)
Else If ((RowSelection = 0) || ((RowType = cType47) || RowType = cType48))
{
	LV_Add("Check", ListCount%A_List%+1, Action, Details, 1, DelayX, Type, Target, Title)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	GuiControl, chMacro:-g, InputList%A_List%
	RowNumber := 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, Action, Details, 1, DelayX, Type, Target, Title)
		LVManager[A_List].InsertAtGroup(RowNumber)
		RowNumber++
		If (AddIf = 1)
			break
	}
	GuiControl, chMacro:+gInputList, InputList%A_List%
}
GoSub, RowCheck
GoSub, b_Start
If (AddIf = 1)
{
	IfMsg := (Buttons < 3) ? IfMsg3 : (Buttons = 3) ? IfMsg5
			: ((Buttons > 3) && (Buttons < 6)) ? IfMsg1 : (Buttons > 5) ? IfMsg4
	If ((RowSelection = 0) || ((RowType = cType47) || RowType = cType48))
	{
		LV_Add("Check", ListCount%A_List%+1, If13, IfMsg, 1, 0, cType17)
		LV_Add("Check", ListCount%A_List%+2, "[End If]", "EndIf", 1, 0, cType17)
		LV_Modify(ListCount%A_List%+2, "Vis")
	}
	Else
	{
		LV_Insert(LV_GetNext(), "Check",, If13, IfMsg, 1, 0, cType17)
		LVManager[A_List].InsertAtGroup(LV_GetNext()), RowNumber := 0, LastRow := 0
		Loop
		{
			RowNumber := LV_GetNext(RowNumber)
			If (!RowNumber)
			{
				LV_Insert(LastRow+1, "Check",LastRow+1, "[End If]", "EndIf", 1, 0, cType17)
				LVManager[A_List].InsertAtGroup(LastRow)
				break
			}
			LastRow := LV_GetNext(LastRow)
		}
	}
	GoSub, RowCheck
	GoSub, b_Start
}
If (A_ThisLabel = "PauseApply")
	Gui, 3:Default
Else
{
	s_Caller := ""
	GuiControl, Focus, InputList%A_List%
}
return

PauseCancel:
3GuiClose:
3GuiEscape:
Gui, 1:-Disabled
Gui, 3:Destroy
s_Caller := ""
return

EditGoto:
EditLoop:
EditTimer:
s_Caller := "Edit"
TimedLabel:
ComGoto:
ComLoop:
If (InStr(CopyMenuLabels[A_List], "()"))
{
	If (A_ThisLabel = "ComGoto")
	{
		Gui, 1:+OwnDialogs
		MsgBox, 16, %d_Lang007%, %d_Lang100%
		return
	}
}
Proj_Labels := ""
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
			Proj_Labels .= Row_Label "|"
		}
	}
}
Gui, chMacro:ListView, InputList%A_List%
Loop, %TabCount%
{
	Lab := CopyMenuLabels[A_Index]
	Proj_Labels .= InStr(Lab, "()") ? "" : Lab "|"
}
Gui, 12:+owner1 -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
Gui, 12:Add, Tab2, W450 H0 vTabControl AltSubmit, CmdTab1|CmdTab2|CmdTab3
; Loop
Gui, 12:Add, Groupbox, Section ym xm W260 H115
Gui, 12:Add, Radio, -Wrap Checked ys+20 xs+10 W120 vLoop gLoopType R1, %c_Lang132%
Gui, 12:Add, Radio, -Wrap y+10 xp W120 vLWhile gLoopType R1, While-%c_Lang132%
Gui, 12:Add, Radio, -Wrap y+10 xp W120 vLFor gLoopType R1, For-%c_Lang132%
Gui, 12:Add, Radio, -Wrap y+10 xp W120 vLParse gLoopType R1, %c_Lang134%
Gui, 12:Add, Radio, -Wrap ys+20 x+5 W120 vLFilePattern gLoopType R1, %c_Lang133%
Gui, 12:Add, Radio, -Wrap y+10 xp W120 R1 vLRegistry gLoopType R1, %c_Lang136%
Gui, 12:Add, Radio, -Wrap y+10 xp W120 vLRead gLoopType R1, %c_Lang135%
Gui, 12:Add, Groupbox, Section ym xs+270 W180 H115
Gui, 12:Add, Text, -Wrap R1 ys+15 xs+10 W160, %w_Lang015% (%t_Lang004%):
Gui, 12:Add, Edit, y+5 xp W120 R1 vEdRept
Gui, 12:Add, UpDown, vTimesL 0x80 Range0-999999999, 0
Gui, 12:Add, Checkbox, -Wrap y+10 xp W160 vLUntil gLUntil R1, %c_Lang155% (%c_Lang087%):
Gui, 12:Add, Edit, y+5 xp W160 vUntilExpr Disabled
Gui, 12:Add, Groupbox, Section xm y+17 W450 H110
Gui, 12:Add, Text, -Wrap R1 ys+15 xs+10 W160 vField1, %c_Lang137%
Gui, 12:Add, CheckBox, -Wrap yp x+10 W80 vIncFiles Disabled R1 Checked, %c_Lang145%
Gui, 12:Add, CheckBox, -Wrap yp x+10 W80 vIncFolders Disabled R1, %c_Lang138%
Gui, 12:Add, CheckBox, -Wrap yp x+10 W80 vRecurse Disabled R1, %c_Lang139%
Gui, 12:Add, Edit, y+5 xs+10 W400 R1 vLParamsFile Disabled
Gui, 12:Add, Button, -Wrap yp-1 x+0 W30 H23 vSearchLParams gSearch Disabled, ...
Gui, 12:Add, Text, -Wrap R1 y+5 xs+10 W210 vField2, %c_Lang141%
Gui, 12:Add, Text, -Wrap R1 yp x+10 W210 vField3, %c_Lang142%
Gui, 12:Add, Edit, y+5 xs+10 W210 R1 vDelim Disabled
Gui, 12:Add, Edit, yp x+10 W210 R1 vOmit Disabled
Gui, 12:Add, Groupbox, Section xm y+15 W450 H50, %c_Lang123%:
Gui, 12:Add, Button, -Wrap ys+18 xs+85 W75 H23 gAddBreak, %c_Lang075%
Gui, 12:Add, Button, -Wrap yp x+10 W75 H23 gAddContinue, %c_Lang076%
Gui, 12:Add, Button, -Wrap Section xm Default W75 H23 gLoopOK, %c_Lang020%
Gui, 12:Add, Button, -Wrap ys W75 H23 gLoopCancel, %c_Lang021%
Gui, 12:Add, Button, -Wrap ys W75 H23 vLoopApply gLoopApply Disabled, %c_Lang131%
Gui, 12:Add, Text, x+10 yp-3 W190 H25 cGray vVarTxt, %c_Lang025%
Gui, 12:Add, Link, -Wrap xp yp WP R1 vExprLink2 gExprLink Hidden, <a>%c_Lang091%</a>
Gui, 12:Tab, 2
; Goto / Label
Gui, 12:Add, Groupbox, Section xm ym W450 H100
Gui, 12:Add, Radio, -Wrap R1 Checked ys+20 xs+10 W150 vGoLabelT gGoto, %c_Lang078%:
Gui, 12:Add, ComboBox, yp x+10 W150 vGoLabel gAutoComplete, %Proj_Labels%
Gui, 12:Add, Radio, -Wrap R1 Section Checked vGoto gGoto, Goto
Gui, 12:Add, Radio, -Wrap R1 yp x+25 vGosub gGoto, Gosub
Gui, 12:Add, Text, -Wrap R1 y+15 xm+100 cGray, %c_Lang025%
Gui, 12:Add, Groupbox, Section xm y+15 W450 H55
Gui, 12:Add, Radio, -Wrap R1 ys+20 xs+10 W150 vNewLabelT gGoto, %c_Lang080%:
Gui, 12:Add, Edit, yp x+10 W150 R1 vNewLabel Disabled
Gui, 12:Add, Groupbox, Section xm y+17 W450 H50, %c_Lang123%:
Gui, 12:Add, Button, -Wrap ys+18 xs+85 W75 H23 gAddReturn, %c_Lang258%
Gui, 12:Add, Button, -Wrap Section xm y+15 W75 H23 vGotoOK gGotoOK, %c_Lang020%
Gui, 12:Add, Button, -Wrap ys W75 H23 gLoopCancel, %c_Lang021%
Gui, 12:Add, Button, -Wrap ys W75 H23 vGotoApply gGotoApply Disabled, %c_Lang131%
Gui, 12:Tab, 3
; SetTimer
Gui, 12:Add, Groupbox, Section xm ym W450 H80
Gui, 12:Add, Text, -Wrap R1 Checked ys+20 xs+10 W70 Right, %c_Lang079%:
Gui, 12:Add, ComboBox, yp x+10 W150 vGoTimerLabel gAutoComplete, %Proj_Labels%
Gui, 12:Add, Text, y+5 xp W190 H25 cGray, %c_Lang025%
Gui, 12:Add, Groupbox, Section xm y+15 W220 H125, %c_Lang257%
Gui, 12:Add, Edit, ys+30 xs+30 Limit W150 vTimerDelayE
Gui, 12:Add, UpDown, vTimerDelayX 0x80 Range0-9999999, 250
Gui, 12:Add, Radio, -Wrap Section Checked yp+25 W150 vTimerMsc R1, %c_Lang018%
Gui, 12:Add, Radio, -Wrap W150 vTimerSec R1, %c_Lang019%
Gui, 12:Add, Radio, -Wrap W150 vTimerMin R1, %c_Lang154%
Gui, 12:Add, Groupbox, Section W220 H125 ys-55 x+50, %w_Lang003%:
Gui, 12:Add, Radio, -Wrap Group Checked ys+20 xs+10 W200 vRunOnce gTimerOpt R1, %t_Lang078%
Gui, 12:Add, Radio, -Wrap W200 vPeriod gTimerOpt R1, %t_Lang079%
Gui, 12:Add, Radio, -Wrap W200 vTurnOn gTimerOpt R1, %c_Lang238%
Gui, 12:Add, Radio, -Wrap W200 vTurnOff gTimerOpt R1, %c_Lang239%
Gui, 12:Add, Radio, -Wrap W200 vDelete gTimerOpt R1, %t_Lang132%
Gui, 12:Add, Button, -Wrap Section xm y+22 W75 H23 vTimedLabelOK gTimedLabelOK, %c_Lang020%
Gui, 12:Add, Button, -Wrap ys W75 H23 gLoopCancel, %c_Lang021%
Gui, 12:Add, Button, -Wrap ys W75 H23 vTimedLabelApply gTimedLabelApply Disabled, %c_Lang131%
Gui, 12:Add, Text, -Wrap R1 ys x+5 W200 vTimersCount, % RegisteredTimers.Length() "/10 " c_Lang240
Gui, 12:Add, Link, -Wrap y+0 xp W200 R1 gClearTimers, <a>%c_Lang241%</a>
Gui, 12:Add, StatusBar, gStatusBarHelp
Gui, 12:Default
SB_SetIcon(ResDllPath, IconsNames["help"])
GoSub, ClearPars
If (s_Caller = "Edit")
{
	Switch Type
	{
		Case cType35:
			GuiControl, 12:, NewLabel, %Details%
			GuiControl, 12:, NewLabelT, 1
			GuiControl, 12:, GoLabelT, 0
			GuiControl, 12:Disable, GoLabelT
			GuiControl, 12:Disable, GoLabel
			GuiControl, 12:Disable, Goto
			GuiControl, 12:Disable, Gosub
			GuiControl, 12:Enable, NewLabel
		Case cType36, cType37:
			If (InStr(Proj_Labels, Details "|"))
				GuiControl, 12:ChooseString, GoLabel, %Details%
			Else
				GuiControl, 12:, GoLabel, %Details%||
			GuiControl, 12:, %Type%, 1
			GuiControl, 12:Disable, NewLabelT
			GuiControl, 12:Enable, GoLabel
			GuiControl, 12:Enable, Goto
			GuiControl, 12:Enable, Gosub
			GuiControl, 12:Disable, NewLabel
		Case cType50:
			If (InStr(Proj_Labels, Details "|"))
				GuiControl, 12:ChooseString, GoTimerLabel, %Details%
			Else
				GuiControl, 12:, GoTimerLabel, %Details%||
			Action := StrReplace(Action, " ")
			GuiControl, 12:, %Action%, 1
			If Action in TurnOn,TurnOff,Delete
			{
				GuiControl, 12:Disable, TimerDelayE
				GuiControl, 12:Disable, TimerDelayX
				GuiControl, 12:Disable, TimerMsc
				GuiControl, 12:Disable, TimerSec
				GuiControl, 12:Disable, TimerMin
			}
			Else If (InStr(DelayX, "%"))
				GuiControl, 12:, TimerDelayE, %DelayX%
			Else
				GuiControl, 12:, TimerDelayX, % StrReplace(DelayX, "-")
		Default:
			StringReplace, Details, Details, `````,, %_x%, All
			EscCom(true, Details)
			Pars := GetPars(Details)
			For i, v in Pars
			{
				Par%A_Index% := v
				StringReplace, Par%A_Index%, Par%A_Index%, %_x%, `,, All
			}
			Switch Type
			{
				Case cType7:
					If (InStr(TimesX, "%"))
						GuiControl, 12:, EdRept, %TimesX%
					Else
						GuiControl, 12:, TimesL, %TimesX%
					Par1 := ""
					GoSub, LoopType
				Case cType38:
					GuiControl, 12:, LRead, 1
					GoSub, LoopType
					GuiControl, 12:, LParamsFile, %Details%
				Case cType39:
					GuiControl, 12:, LParse, 1
					GoSub, LoopType
					GuiControl, 12:, LParamsFile, %Par1%
					GuiControl, 12:, Delim, %Par2%
					GuiControl, 12:, Omit, %Par3%
				Case cType40:
					GuiControl, 12:, LFilePattern, 1
					GoSub, LoopType
					GuiControl, 12:, LParamsFile, %Par1%
					GuiControl, 12:, IncFiles, % InStr(Par2, "F") ? 1 : 0
					GuiControl, 12:, IncFolders, % InStr(Par2, "D") ? 1 : 0
					GuiControl, 12:, Recurse, % InStr(Par2, "R") ? 1 : 0
				Case cType41:
					GuiControl, 12:, LRegistry, 1
					GoSub, LoopType
					GuiControl, 12:, LParamsFile, %Par1%
					GuiControl, 12:, IncFiles, % InStr(Par2, "V") ? 1 : 0
					GuiControl, 12:, IncFolders, % InStr(Par2, "K") ? 1 : 0
					GuiControl, 12:, Recurse, % InStr(Par2, "R") ? 1 : 0
				Case cType45:
					GuiControl, 12:, LFor, 1
					GoSub, LoopType
					GuiControl, 12:, LParamsFile, %Par1%
					GuiControl, 12:, Delim, %Par2%
					GuiControl, 12:, Omit, %Par3%
				Case cType51:
					GuiControl, 12:, LWhile, 1
					GoSub, LoopType
					GuiControl, 12:, LParamsFile, %Details%
			}
			If (Target != "")
			{
				GuiControl, 12:, LUntil, 1
				GoSub, LoopType
				GuiControl, 12:Enable, UntilExpr
				GuiControl, 12:, UntilExpr, %Target%
			}
			GoSub, ClearPars
	}
	GuiControl, 12:Enable, LoopApply
	GuiControl, 12:Enable, GotoApply
	GuiControl, 12:Enable, TimedLabelApply
}
If (InStr(A_ThisLabel, "Time"))
{
	GuiControl, 12:Choose, TabControl, 3
	GuiControl, 12:+Default, TimedLabelOK
	SBShowTip("SetTimer")
}
If (InStr(A_ThisLabel, "Goto"))
{
	GuiControl, 12:Choose, TabControl, 2
	GuiControl, 12:+Default, GotoOK
	If (s_Caller = "Find")
	{
		GuiControl, 12:, %GotoRes1%, 1
		SBShowTip(GotoRes1)
	}
	Else
		GoSub, Goto
}
Else If ((s_Caller = "Find") && ((InStr(GotoRes1, "Loop"))
		|| (GotoRes1 = "While") || (GotoRes1 = "For") || (GotoRes1 = "Until")))
{
	StringReplace, GotoRes1, GotoRes1, Loop
	StringReplace, GotoRes1, GotoRes1, %A_Space%(files & folders), FilePattern
	StringReplace, GotoRes1, GotoRes1, %A_Space%(normal)
	StringReplace, GotoRes1, GotoRes1, %A_Space%(parse a string), Parse
	StringReplace, GotoRes1, GotoRes1, %A_Space%(read file contents), Read
	StringReplace, GotoRes1, GotoRes1, %A_Space%(registry), Registry

	GotoRes1 := "L" GotoRes1
	GuiControl, 12:, %GotoRes1%, 1
	GoSub, LoopType
	GuiControl, 12:Enable%LUntil%, UntilExpr
}
Else If (s_Caller != "Edit")
	SBShowTip("Loop (normal)")
Gui, 12:Show, % InStr(A_ThisLabel, "Loop") ? "" : "H275", % InStr(A_ThisLabel, "Goto") ? c_Lang077 : InStr(A_ThisLabel, "Time") ? c_Lang242 : c_Lang073
ChangeIcon(hIL_Icons, CmdWin, InStr(A_ThisLabel, "Goto") ? IconsNames["goto"] : InStr(A_ThisLabel, "Time") ? IconsNames["timer"] : IconsNames["loop"])
Input
Tooltip
return

LoopApply:
LoopOK:
Gui, 12:+OwnDialogs
Gui, 12:Submit, NoHide
If (LRead = 1)
{
	If (LParamsFile = "")
	{
		Gui, 12:Font, cRed
		GuiControl, 12:Font, Field1
		GuiControl, 12:Focus, LParamsFile
		return
	}
	Details := RTrim(LParamsFile, ", ")
	TimesL := 1, Type := cType38
}
Else If (LParse = 1)
{
	If (LParamsFile = "")
	{
		Gui, 12:Font, cRed
		GuiControl, 12:Font, Field1
		GuiControl, 12:Focus, LParamsFile
		return
	}
	Try
		z_Check := VarSetCapacity(%LParamsFile%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%`n`n%LParamsFile%
		return
	}
	EscCom(false, Delim), EscCom(false, Omit)
	If (InStr(Delim, ";") && !InStr(Delim, "``;"))
		Delim := RegExReplace(Delim, ";", "``;")
	If (InStr(Delim, "%") && !InStr(Delim, "``%"))
		Delim := RegExReplace(Delim, "%", "``%")
	If (InStr(Omit, ";") && !InStr(Omit, "``;"))
		Omit := RegExReplace(Omit, ";", "``;")
	If (InStr(Omit, "%") && !InStr(Omit, "``%"))
		Omit := RegExReplace(Omit, "%", "``%")
	Details := LParamsFile ", " Delim ", " Omit
	TimesL := 1, Type := cType39
}
Else If (LFor = 1)
{
	If ((LParamsFile = "") || (Delim == ""))
	{
		Gui, 12:Font, cRed
		GuiControl, 12:Font, Field1
		GuiControl, 12:Font, Field2
		GuiControl, 12:Focus, LParamsFile
		return
	}
	Try
		z_Check := VarSetCapacity(%Delim%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%`n`n%Delim%
		return
	}
	Try
		z_Check := VarSetCapacity(%Omit%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%`n`n%Omit%
		return
	}
	EscCom(false, LParamsFile)
	Details := LParamsFile ", " Delim ", " Omit
	Details := RTrim(Details, ", ")
	TimesL := 1, Type := cType45
}
Else If (LWhile = 1)
{
	If (LParamsFile = "")
	{
		Gui, 12:Font, cRed
		GuiControl, 12:Font, Field1
		GuiControl, 12:Focus, LParamsFile
		return
	}
	Details := LParamsFile
	TimesL := 1, Type := cType51
}
Else If (LFilePattern = 1)
{
	If (LParamsFile = "")
	{
		Gui, 12:Font, cRed
		GuiControl, 12:Font, Field1
		GuiControl, 12:Focus, LParamsFile
		return
	}
	Details := LParamsFile ", " (IncFiles ? "F" : "") (IncFolders ? "D" : "") (Recurse ? "R" : "")
	TimesL := 1, Type := cType40
}
Else If (LRegistry = 1)
{
	Details := LParamsFile ", " (IncFiles ? "V" : "") (IncFolders ? "K" : "") (Recurse ? "R" : "")
	TimesL := 1, Type := cType41
}
Else
{
	Details := "LoopStart", Type := cType7
	TimesL := InStr(EdRept, "%") ? EdRept : TimesL
}
If (LUntil = 1)
{
	If (UntilExpr = "")
	{
		GuiControl, 12:Focus, UntilExpr
		return
	}
	Target := UntilExpr
}
Else
	Target := ""
EscCom(false, Details)
If (A_ThisLabel != "LoopApply")
{
	Gui, 1:-Disabled
	Gui, 12:Destroy
}
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected"), LV_GetText(RowType, LV_GetNext(), 6)
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col3", Details, TimesL, DelayX, Type, Target)
Else If ((RowSelection = 0) || ((RowType = cType47) || RowType = cType48))
{
	LV_Add("Check", ListCount%A_List%+1, "[LoopStart]", Details, TimesL, 0, Type, Target)
	LV_Add("Check", ListCount%A_List%+2, "[LoopEnd]", "LoopEnd", 1, 0, "Loop")
	LV_Modify(ListCount%A_List%+2, "Vis")
}
Else
{
	LV_Insert(LV_GetNext(), "Check",, "[LoopStart]", Details, TimesL, 0, Type, Target)
	LVManager[A_List].InsertAtGroup(LV_GetNext() - 1), RowNumber := 0, LastRow := 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If (!RowNumber)
		{
			LV_Insert(LastRow+1, "Check", LastRow+1, "[LoopEnd]", "LoopEnd", 1, 0, "Loop")
			LVManager[A_List].InsertAtGroup(LastRow)
			break
		}
		LastRow := LV_GetNext(LastRow)
	}
}
GoSub, RowCheck
GoSub, b_Start
If (A_ThisLabel = "LoopApply")
	Gui, 12:Default
Else
{
	s_Caller := ""
	GuiControl, Focus, InputList%A_List%
}
return

Goto:
If (A_GuiControl = "GoLabelT")
{
	GuiControl, 12:, NewLabelT, 0
	GuiControl, 12:Enable, GoLabel
	GuiControl, 12:Enable, Goto
	GuiControl, 12:Enable, Gosub
	GuiControl, 12:Disable, NewLabel
}
Else If (A_GuiControl = "NewLabelT")
{
	GuiControl, 12:, GoLabelT, 0
	GuiControl, 12:Disable, GoLabel
	GuiControl, 12:Disable, Goto
	GuiControl, 12:Disable, Gosub
	GuiControl, 12:Enable, NewLabel
}
Gui, 12:Submit, NoHide
SBShowTip(NewLabelT ? "Label" : (Goto = 1) ? "Goto" : "Gosub")
return

GotoApply:
GotoOK:
Gui, 12:+OwnDialogs
Gui, 12:Submit, NoHide
If (GoLabelT)
{
	If (GoLabel = "")
		return
	If (!RegExMatch(GoLabel, "^%\s+"))
	{
		If (!RegExMatch(GoLabel, "^[\w%]+$"))
		{
			MsgBox, 16, %d_Lang007%, %d_Lang049%
			return
		}
		If ((!InStr(GoLabel, "%")) && (!InStr(Proj_Labels, GoLabel "|")))
		{
			MsgBox, 16, %d_Lang007%, %d_Lang109%
			return
		}
	}
	Details := GoLabel, Type := (Goto = 1) ? "Goto" : "Gosub"
}
If (NewLabelT)
{
	If (NewLabel = "")
		return
	If (!RegExMatch(NewLabel, "^\w+$"))
	{
		MsgBox, 16, %d_Lang007%, %d_Lang049%
		return
	}
	Loop, Parse, Proj_Labels, |
	{
		If (A_LoopField = NewLabel)
		{
			MsgBox, 16, %d_Lang007%, %d_Lang050%
			return
		}
	}
	Details := NewLabel, Type := cType35
}
If (A_ThisLabel != "GotoApply")
{
	Gui, 1:-Disabled
	Gui, 12:Destroy
}
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected")
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", "[" Type "]", Details, TimesX, DelayX, Type)
Else If (RowSelection = 0)
{
	LV_Add("Check", ListCount%A_List%+1, "[" Type "]", Details, 1, 0, Type)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	LV_Insert(LV_GetNext(), "Check",, "[" Type "]", Details, 1, 0, Type)
	LVManager[A_List].InsertAtGroup(LV_GetNext())
}
GoSub, RowCheck
GoSub, b_Start
If (A_ThisLabel = "GotoApply")
	Gui, 12:Default
Else
{
	s_Caller := ""
	GuiControl, Focus, InputList%A_List%
}
return

TimerOpt:
If A_GuiControl in TurnOn,TurnOff,Delete
{
	GuiControl, 12:Disable, TimerDelayE
	GuiControl, 12:Disable, TimerDelayX
	GuiControl, 12:Disable, TimerMsc
	GuiControl, 12:Disable, TimerSec
	GuiControl, 12:Disable, TimerMin
}
Else
{
	GuiControl, 12:Enable, TimerDelayE
	GuiControl, 12:Enable, TimerDelayX
	GuiControl, 12:Enable, TimerMsc
	GuiControl, 12:Enable, TimerSec
	GuiControl, 12:Enable, TimerMin
}
return

ClearTimers:
Loop, 10
	SetTimer, RunTimerOn%A_Index%, Delete
RegisteredTimers.RemoveAt(1, RegisteredTimers.Length())
GuiControl, 12:, TimersCount, % RegisteredTimers.Length() "/10 " c_Lang240
return

TimedLabelApply:
TimedLabelOK:
Gui, 12:+OwnDialogs
Gui, 12:Submit, NoHide
If (GoTimerLabel = "")
	return
If (!RegExMatch(GoTimerLabel, "^%\s+"))
{
	If (!RegExMatch(GoTimerLabel, "^[\w%]+$"))
	{
		MsgBox, 16, %d_Lang007%, %d_Lang049%
		return
	}
	If ((!InStr(GoTimerLabel, "%")) && (!InStr(Proj_Labels, GoTimerLabel "|")))
	{
		MsgBox, 16, %d_Lang007%, %d_Lang109%
		return
	}
}
If ((RunOnce) || (Period))
{
	DelayX := (InStr(TimerDelayE, "%") ? TimerDelayE : TimerDelayX)
	If (TimerSec = 1)
		DelayX := TimerDelayX * 1000
	Else If (TimerMin = 1)
		DelayX := TimerDelayX * 60000
	Action := Period ? "Period" : "Run Once"
}
Else
	DelayX := 0, Action := TurnOn ? "Turn On" : TurnOff ? "Turn Off" : "Delete"
If (A_ThisLabel != "TimedLabelApply")
{
	Gui, 1:-Disabled
	Gui, 12:Destroy
}
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected")
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", Action, GoTimerLabel, 1, DelayX, cType50)
Else If (RowSelection = 0)
{
	LV_Add("Check", ListCount%A_List%+1, Action, GoTimerLabel, 1, DelayX, cType50)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	LV_Insert(LV_GetNext(), "Check",, Action, GoTimerLabel, 1, DelayX, cType50)
	LVManager[A_List].InsertAtGroup(LV_GetNext())
}
GoSub, RowCheck
GoSub, b_Start
If (A_ThisLabel = "TimedLabelApply")
	Gui, 12:Default
Else
{
	s_Caller := ""
	GuiControl, Focus, InputList%A_List%
}
return

LoopCancel:
12GuiClose:
12GuiEscape:
Gui, 1:-Disabled
Gui, 12:Destroy
s_Caller := ""
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
AddReturn:
Gui, 12:Submit, NoHide
Gui, 1:-Disabled
Gui, 12:Destroy
Gui, chMacro:Default
Type := LTrim(A_ThisLabel, "Add")
RowSelection := LV_GetCount("Selected"), LV_GetText(RowType, LV_GetNext(), 6)
If ((RowSelection = 0) || ((RowType = cType47) || RowType = cType48))
{
	LV_Add("Check", ListCount%A_List%+1, Type,, 1, 0, Type)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	LV_Insert(LV_GetNext(), "Check",, Type,, 1, 0, Type)
	LVManager[A_List].InsertAtGroup(LV_GetNext())
}
GoSub, RowCheck
GoSub, b_Start
GuiControl, Focus, InputList%A_List%
return

LUntil:
Gui, 12:Submit, NoHide
GuiControl, 12:Enable%LUntil%, UntilExpr
return

LoopType:
Gui, 12:Submit, NoHide
GuiControl, 12:Enable%Loop%, EdRept
GuiControl, 12:Disable%Loop%, LParamsFile
GuiControl, 12:Enable%LParse%, Omit
If (LFilePattern || LRegistry)
{
	GuiControl, 12:Enable, IncFiles
	GuiControl, 12:Enable, IncFolders
	GuiControl, 12:Enable, Recurse
}
Else
{
	GuiControl, 12:Disable, IncFiles
	GuiControl, 12:Disable, IncFolders
	GuiControl, 12:Disable, Recurse
}
If (LParse || LFor)
	GuiControl, 12:Enable, Delim
Else
	GuiControl, 12:Disable, Delim
If (LRead || LFilePattern)
	GuiControl, 12:Enable, SearchLParams
Else
	GuiControl, 12:Disable, SearchLParams
If (LFor)
{
	GuiControl, 12:Enable, Omit
	GuiControl, 12:, Field1, %c_Lang207% / %c_Lang211% / %c_Lang087%
	GuiControl, 12:, Field2, %c_Lang208%
	GuiControl, 12:, Field3, %c_Lang209%
	GuiControl, 12:, Delim, % Par2 ? Par2 : "key"
	GuiControl, 12:, Omit, % Par3 ? Par3 : "value"
}
Else
{
	GuiControl, 12:, Field1, % LWhile ? c_Lang087 : LParse ? c_Lang140 : LRead ? c_Lang143 : LRegistry ? c_Lang144 : c_Lang137
	GuiControl, 12:, Field2, %c_Lang141%
	GuiControl, 12:, Field3, %c_Lang142%
	If (!InStr(A_GuiControl, "InputList"))
	{
		GuiControl, 12:, Delim
		GuiControl, 12:, Omit
	}
}
If (LWhile)
{
	GuiControl, 12:, LUntil, 0
	GuiControl, 12:Disable, LUntil
	GuiControl, 12:Disable, UntilExpr
}
Else
	GuiControl, 12:Enable, LUntil
GuiControl, 12:Text, IncFiles, % (LRegistry ? c_Lang210 : c_Lang145)
GuiControl, 12:Text, IncFolders, % (LRegistry ? c_Lang146 : c_Lang138)
GuiControl, 12:, LParamsFile, % Par1 ? Par1 : ""
If (Loop)
	SBShowTip("Loop (normal)")
Else If (LFilePattern)
	SBShowTip("Loop (files & folders)")
Else If (LParse)
	SBShowTip("Loop (parse a string)")
Else If (LFor)
	SBShowTip("For")
Else If (LWhile)
	SBShowTip("While")
Else If (LRead)
	SBShowTip("Loop (read file contents)")
Else If (LRegistry)
	SBShowTip("Loop (registry)")
If (LWhile || LFor)
{
	GuiControl, 12:Hide, VarTxt
	GuiControl, 12:Show, ExprLink2
}
Else
{
	GuiControl, 12:Show, VarTxt
	GuiControl, 12:Hide, ExprLink2
}
return

EditWindow:
s_Caller := "Edit"
Window:
Gui, 11:+owner1 -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
Gui, 11:Add, Groupbox, Section W450 H220
Gui, 11:Add, Text, -Wrap R1 ys+15 xs+10 W120, %c_Lang055%:
Gui, 11:Add, DDL, W120 vWinCom gWinCom, %WinCmdList%
Gui, 11:Add, Text, -Wrap R1 W120, %c_Lang035%:
Gui, 11:Add, DDL, W120 -Multi vWCmd gWCmd, %WinCmd%
Gui, 11:Add, Text, -Wrap R1 yp-10 x+10 W180 vTValue Disabled, 255
Gui, 11:Add, Slider, y+0 W100 Buddy2TValue vN gN Range0-255 Disabled, 255
Gui, 11:Add, Radio, -Wrap Checked yp+2 x+30 W70 vAoT1 R1, Toggle
Gui, 11:Add, Radio, -Wrap yp x+5 W45 R1 vAoT2, On
Gui, 11:Add, Radio, -Wrap yp x+5 W45 R1 vAoT3, Off
Gui, 11:Add, Text, -Wrap R1 xs+10 y+10 W180 vValueT, %c_Lang056%:
Gui, 11:Add, Edit, W430 -Multi Disabled vValue
Gui, 11:Add, Text, -Wrap R1 W180, %c_Lang057%:
Gui, 11:Add, Edit, W430 -Multi Disabled vVarName
Gui, 11:Add, Text, -Wrap R1 xs+10 y+5 W430 vCPosT
Gui, 11:Add, Groupbox, Section xs y+15 W450 H80
Gui, 11:Add, Text, -Wrap ys+20 xs+10 W350 H20 cGray, %Wcmd_All%
Gui, 11:Add, Button, yp-5 x+5 W75 vIdent gWinTitle, WinTitle
Gui, 11:Add, Edit, xs+10 y+5 W400 vTitle, A
Gui, 11:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetWin gGetWin, ...
Gui, 11:Add, Text, -Wrap R1 Section ym+20 xm+130 W105 Right, %c_Lang058%
Gui, 11:Add, Text, -Wrap R1 yp x+5 W15 Right, X:
Gui, 11:Add, Edit, yp-3 x+5 vPosX W55 Disabled
Gui, 11:Add, Text, -Wrap R1 yp+3 x+10 W15 Right, Y:
Gui, 11:Add, Edit, yp-3 x+5 vPosY W55 Disabled
Gui, 11:Add, Button, -Wrap yp-1 x+5 W30 H23 vWinGetP gWinGetP Disabled, ...
Gui, 11:Add, Text, -Wrap R1 xs W105 Right, %c_Lang059%
Gui, 11:Add, Text, -Wrap R1 yp x+5 W15 Right, W:
Gui, 11:Add, Edit, yp-3 x+5 vSizeX W55 Disabled
Gui, 11:Add, Text, -Wrap R1 yp+3 x+10 W15 Right, H:
Gui, 11:Add, Edit, yp-3 x+5 vSizeY W55 Disabled
Gui, 11:Add, Button, -Wrap Section Default xm W75 H23 gWinOK, %c_Lang020%
Gui, 11:Add, Button, -Wrap ys W75 H23 gWinCancel, %c_Lang021%
Gui, 11:Add, Button, -Wrap ys W75 H23 vWinApply gWinApply Disabled, %c_Lang131%
Gui, 11:Add, Text, x+10 yp-3 W190 H25 cGray, %c_Lang025%
Gui, 11:Add, StatusBar, gStatusBarHelp
Gui, 11:Default
SB_SetIcon(ResDllPath, IconsNames["help"])
If (s_Caller = "Edit")
{
	WinCom := Type
	GuiControl, 11:ChooseString, WinCom, %WinCom%
	GoSub, WinCom
	If (WinCom = "WinSetTitle")
		EscCom(true, Details)
	Switch Type
	{
		Case "WinSet":
			WCmd := RegExReplace(Details, "(^\w*).*", "$1")
			Values := RegExReplace(Details, "^\w*, ?(.*)", "$1")
			GuiControl, 11:ChooseString, WCmd, %WCmd%
			SetTitleMatchMode, 3
			If (WCmd = "AlwaysOnTop")
				GuiControl, 11:, % (Values = "On") ? "Aot2" : (Values = "Off") ? "AoT3" : "", 1
			Else If (WCmd = "Transparent")
			{
				GuiControl, 11:, N, %Values%
				GuiControl, 11:, TValue, %Values%
			}
			Else If (InStr(Details, ","))
				GuiControl, 11:, Value, %Values%
			SetTitleMatchMode, 2
			GoSub, WCmd
		Case "WinMove":
			Pars := GetPars(Details)
			For i, v in Pars
				Par%A_Index% := v
			GuiControl, 11:, PosX, %Par1%
			GuiControl, 11:, PosY, %Par2%
			GuiControl, 11:, SizeX, %Par3%
			GuiControl, 11:, SizeY, %Par4%
		Default:
			If (InStr(WinCom, "Get"))
			{
				Pars := GetPars(Details)
				For i, v in Pars
					Par%A_Index% := v
				GuiControl, 11:, VarName, %Par1%
				GuiControl, 11:ChooseString, WCmd, %Par2%
			}
			Else
				GuiControl, 11:, Value, %Details%
	}
	GuiControl, 11:, Title, %Window%
	GuiControl, 11:Enable, WinApply
}
Else If (s_Caller = "Find")
{
	GuiControl, 11:ChooseString, WinCom, %GotoRes1%
	GoSub, WinCom


	If (InStr(WinCmd, GotoRes1))
	{
		GuiControl, 11:ChooseString, WCmd, %GotoRes1%
		GoSub, WCmd
	}
	Else If (InStr(WinGetCmd, GotoRes1))
	{
		GuiControl, 11:ChooseString, WinCom, WinGet
		GoSub, WinCom
		GuiControl, 11:ChooseString, WCmd, %GotoRes1%
		GoSub, WCmd
	}
	Else
	{
		GuiControl, 11:ChooseString, WinCom, %GotoRes1%
		GoSub, WinCom
	}
}
Else
	SBShowTip("WinSet")
Gui, 11:Show, , %c_Lang005%
ChangeIcon(hIL_Icons, CmdWin, IconsNames["window"])
Tooltip
return

WinApply:
WinOK:
Gui, 11:+OwnDialogs
Gui, 11:Submit, NoHide
GuiControlGet, VState, 11:Enabled, VarName
Details := ""
If (VState = 0)
	VarName := ""
GuiControlGet, VState, 11:Enabled, Value
If (VState = 0)
	Value := ""
If (WinCom = "WinSet")
{
	Details := WCmd
	If (WCmd = "AlwaysOnTop")
		Details .= ", " (Aot1 ? "Toggle" : Aot2 ? "On" : "Off")
	Else If (WCmd = "Transparent")
		Details .= ", " N
	Else If (VState = 1)
		Details .= ", " Value
	Else
		Details .= ", "
}
Else If (WinCom = "WinMove")
	Details := PosX ", " PosY ", " SizeX ", " SizeY
Else
	Details := Value
If (WinCom = "WinSetTitle")
	EscCom(false, Details)
If (InStr(WinCom, "MinimizeAll"))
	Title := ""
If (InStr(WinCom, "Get"))
{
	If (VarName = "")
	{
		Tooltip, %c_Lang127%, 25, 220
		return
	}
	Try
		z_Check := VarSetCapacity(%VarName%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%`n`n%VarName%
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
If (A_ThisLabel != "WinApply")
{
	Gui, 1:-Disabled
	Gui, 11:Destroy
}
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected"), LV_GetText(RowType, LV_GetNext(), 6)
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", WinCom, Details, TimesX, DelayX, WinCom,, Title)
Else If ((RowSelection = 0) || ((RowType = cType47) || RowType = cType48))
{
	LV_Add("Check", ListCount%A_List%+1, WinCom, Details, 1, DelayWX, WinCom,, Title)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	GuiControl, chMacro:-g, InputList%A_List%
	RowNumber := 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, WinCom, Details, 1, DelayWX, WinCom,, Title)
		LVManager[A_List].InsertAtGroup(RowNumber)
		RowNumber++
	}
	GuiControl, chMacro:+gInputList, InputList%A_List%
}
GoSub, RowCheck
GoSub, b_Start
If (A_ThisLabel = "WinApply")
	Gui, 11:Default
Else
{
	s_Caller := ""
	GuiControl, Focus, InputList%A_List%
}
return

WinCancel:
11GuiClose:
11GuiEscape:
Gui, 1:-Disabled
Gui, 11:Destroy
s_Caller := ""
return

WinCom:
Gui, 11:Submit, NoHide
SBShowTip(WinCom)
If (InStr(WinCom, "Get"))
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
	GuiControl, 11:, ValueT, %c_Lang177% (%c_Lang019%):
}
Else If WinCom contains SetTitle
{
	GuiControl, 11:Enable, Value
	GuiControl, 11:, ValueT, %c_Lang056%:
}
Else
{
	GuiControl, 11:Disable, Value
	GuiControl, 11:, ValueT, %c_Lang056%:
}
If (InStr(WinCom, "MinimizeAll"))
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
return

WCmd:
Gui, 11:Submit, NoHide
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
	GuiControl, 11:Enable, AoT1
	GuiControl, 11:Enable, AoT2
	GuiControl, 11:Enable, AoT3
}
Else
{
	GuiControl, 11:Disable, AoT1
	GuiControl, 11:Disable, AoT2
	GuiControl, 11:Disable, AoT3
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
Gui, 11:Submit, NoHide
GuiControl, 11:, TValue, %N%
return

EditImage:
s_Caller := "Edit"
Image:
TessLangs := ""
Loop, Files, %SettingsFolder%\Bin\tesseract\tessdata_fast\*.traineddata, F
	TessLangs .= A_LoopFileName "|"
TessSelectedLangs := "eng"
Gui, 1:Submit, NoHide
Gui, 19:+owner1 -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
; Region
Gui, 19:Add, GroupBox, Section W275 H80, %c_Lang205%:
Gui, 19:Add, Text, -Wrap R1 ys+20 xs+10, %c_Lang061%
Gui, 19:Add, Text, -Wrap R1 yp xs+65, X:
Gui, 19:Add, Edit, yp x+5 viPosX W60, 0
Gui, 19:Add, Text, -Wrap R1 yp x+15, Y:
Gui, 19:Add, Edit, yp x+5 viPosY W60, 0
Gui, 19:Add, Button, -Wrap yp-1 x+5 W30 H23 vGetArea gGetArea, ...
Gui, 19:Add, Text, -Wrap R1 y+10 xs+10, %c_Lang062%
Gui, 19:Add, Text, -Wrap R1 yp xs+65, X:
Gui, 19:Add, Edit, yp-3 x+5 vePosX W60, %A_ScreenWidth%
Gui, 19:Add, Text, -Wrap R1 yp x+15, Y:
Gui, 19:Add, Edit, yp x+5 vePosY W60, %A_ScreenHeight%
; Search
Gui, 19:Add, GroupBox, Section y+12 xs W275 H158, %c_Lang034%:
Gui, 19:Add, DDL, AltSubmit ys+20 xs+10 W100 vImageS gImageS, %c_Lang063%||%c_Lang064%|%c_Lang260% (OCR)
Gui, 19:Add, Text, -Wrap R1 yp+5 x+5 W140 vOutputVarT Hidden, %c_Lang057%/%c_Lang261%:
Gui, 19:Add, Button, -Wrap yp-1 xs+240 W25 H23 hwndScreenshot vScreenshot gScreenshot
	ILButton(Screenshot, ResDllPath ":" 60)
Gui, 19:Add, Button, -Wrap yp xs+240 W25 H23 hwndColorPick vColorPick gGetPixel Disabled Hidden
	ILButton(ColorPick, ResDllPath ":" 100)
Gui, 19:Add, Edit, y+5 xs+10 vImgFile W225 R1 -Multi
Gui, 19:Add, Button, -Wrap yp-1 x+0 W30 H23 hwndhSearchImg vSearchImg gSearchImg, ...
Gui, 19:Add, Text, Section -Wrap R1 y+5 xs+10 W163 Right vIfFoundT, %c_Lang067%:
Gui, 19:Add, DDL, yp-2 x+10 W80 vIfFound gIfFound, Continue||Break|Stop|Prompt|Move|Left Click|Right Click|Middle Click|Play Sound
Gui, 19:Add, Text, -Wrap R1 y+5 xs W163 Right vIfNotFoundT, %c_Lang068%:
Gui, 19:Add, DDL, yp-2 x+10 W80 vIfNotFound, Continue||Break|Stop|Prompt|Play Sound
Gui, 19:Add, CheckBox, Checked -Wrap y+0 xs+10 W180 vAddIf, %c_Lang162%
Gui, 19:Add, CheckBox, -Wrap ys xs+10 W180 vFileOCR gFileOCR Hidden, %c_Lang133%
Gui, 19:Add, Edit, y+5 xs+0 vImgFileOCR W225 R1 -Multi Hidden Disabled
Gui, 19:Add, Button, -Wrap yp-1 x+0 W30 H23 vSearchImgOCR gSearchImg Hidden Disabled, ...
; Preview
Gui, 19:Add, Groupbox, Section ym xs+280 W275 H240, %c_Lang072%:
Gui, 19:Add, Pic, ys+20 xs+10 W255 H200 0x100 vPicPrev gPicOpen
Gui, 19:Add, Progress, ys+20 xs+10 W255 H200 Disabled Hidden vColorPrev
Gui, 19:Add, Text, -Wrap R1 y+0 xs+10 W150 vImgSize
; Variables
Gui, 19:Add, Groupbox, Section y+8 xm W555 H50, %c_Lang010%:
Gui, 19:Add, Text, -Wrap ys+20 xs+10 W95 R1 vOutVarT, %c_Lang069%
Gui, 19:Add, Text, yp x+0 R1, X:
Gui, 19:Add, Edit, yp-5 x+5 W60 H20 vOutVarX, FoundX
Gui, 19:Add, Text, yp+5 x+10 R1, Y:
Gui, 19:Add, Edit, yp-5 x+5 W60 H20 vOutVarY, FoundY
Gui, 19:Add, Checkbox, yp+5 x+20 W260 R1 vFixFoundVars, %c_Lang256%
; Options
Gui, 19:Add, GroupBox, Section y+17 xm W275 H115, %c_Lang159%:
Gui, 19:Add, Text, -Wrap R1 ys+20 xs+10 W40 Right, %c_Lang070%:
Gui, 19:Add, DDL, yp x+10 W65 vCoordPixel, Window||Screen|Client
GuiControl, 19:ChooseString, CoordPixel, %CoordMouse%
Gui, 19:Add, Text, -Wrap R1 yp+3 x+0 W85 Right, %c_Lang071%:
Gui, 19:Add, Edit, yp-3 x+10 vVariatT W45 Number Limit
Gui, 19:Add, UpDown, vVariat 0x80 Range0-255, 0
Gui, 19:Add, Text, -Wrap R1 y+10 xs+10 W40 Right, %c_Lang147%:
Gui, 19:Add, Edit, yp-3 x+10 W45 vIconN
Gui, 19:Add, Text, -Wrap R1 yp+3 x+0 W75 Right, %c_Lang160%:
Gui, 19:Add, Edit, yp-3 x+10 W50 vTransC
Gui, 19:Add, Button, -Wrap yp-1 x+0 W25 H23 hwndTransCS vTransCS gGetPixel
	ILButton(TransCS, ResDllPath ":" 100)
Gui, 19:Add, Checkbox, -Wrap R1 Checked y+5 xs+10 W100 vFast Disabled, %t_Lang103%
Gui, 19:Add, Checkbox, -Wrap R1 Checked y+5 xs+10 W100 vRGB Disabled, RGB
Gui, 19:Add, Text, -Wrap R1 yp-10 x+0 W70 Right, %c_Lang161%:
Gui, 19:Add, Edit, yp-3 x+10 W35 vWScale
Gui, 19:Add, Text, -Wrap R1 yp+5 x+0, x
Gui, 19:Add, Edit, yp-5 x+0 W35 vHScale
; Repeat
Gui, 19:Add, GroupBox, Section ys xs+280 W275 H115
Gui, 19:Add, Text, -Wrap R1 ys+20 xs+35 W100 Right, %w_Lang015%:
Gui, 19:Add, Edit, yp x+10 W120 R1 vEdRept
Gui, 19:Add, UpDown, vTimesX 0x80 Range1-999999999, 1
Gui, 19:Add, Text, -Wrap R1 y+5 xs+35 W100 Right, %c_Lang017%:
Gui, 19:Add, Edit, yp x+10 W120 vDelayC
Gui, 19:Add, UpDown, vDelayX 0x80 Range0-999999999, %DelayG%
Gui, 19:Add, Radio, -Wrap Checked W120 vMsc R1, %c_Lang018%
Gui, 19:Add, Radio, -Wrap W120 vSec R1, %c_Lang019%
Gui, 19:Add, Checkbox, -Wrap ys+65 xs+10 W125 vBreakLoop gLoopUntil R1, %c_Lang130%
Gui, 19:Add, DDL, -Wrap W100 vLoopUntil Disabled, Found||Not Found
Gui, 19:Add, Button, -Wrap Section Default xm W75 H23 gImageOK, %c_Lang020%
Gui, 19:Add, Button, -Wrap ys W75 H23 gImageCancel, %c_Lang021%
Gui, 19:Add, Button, -Wrap ys W75 H23 vImageApply gImageApply Disabled, %c_Lang131%
Gui, 19:Add, Link, -Wrap R1 W100 ys+5 gImageOpt, <a>%w_Lang003%</a>
Gui, 19:Add, Text, x+10 yp-3 W190 H25 cGray, %c_Lang025%
Gui, 19:Add, StatusBar, gStatusBarHelp
Gui, 19:Default
SB_SetIcon(ResDllPath, IconsNames["help"])
If (s_Caller = "Edit")
{
	GuiControl, 19:, TimesX, %TimesX%
	GuiControl, 19:, EdRept, %TimesX%
	GuiControl, 19:, DelayX, %DelayX%
	GuiControl, 19:, DelayC, %DelayX%
	Loop, 5
		Act%A_Index% := ""
	Pars := GetPars(Action)
	For i, v in Pars
		Act%A_Index% := v
	GuiControl, 19:ChooseString, IfFound, %Act1%
	GuiControl, 19:ChooseString, IfNotFound, %Act2%
	If (Act3 != "")
		GuiControl, 19:, OutVarX, %Act3%
	If (Act4 != "")
		GuiControl, 19:, OutVarY, %Act4%
	If (Act5)
		GuiControl, 19:, FixFoundVars, 1
	Pars := GetPars(Details)
	For i, v in Pars
		Det%A_Index% := v
	If (Type = cType16)
	{
		GuiControl, 19:Choose, ImageS, 1
		RegExMatch(Det5, "\*(\d+?)\s+(.*)", ImgOpt)
		Variat := ImgOpt1, Det5 := ImgOpt2 ? ImgOpt2 : Det5
		RegExMatch(Det5, "\*Icon(.+?)\s+(.*)", ImgOpt)
		IconN := ImgOpt1, Det5 := ImgOpt2 ? ImgOpt2 : Det5
		RegExMatch(Det5, "\*Trans(.+?)\s+(.*)", ImgOpt)
		TransC := ImgOpt1, Det5 := ImgOpt2 ? ImgOpt2 : Det5
		RegExMatch(Det5, "\*W(.+?)\s+(.*)", ImgOpt)
		WScale := ImgOpt1, Det5 := ImgOpt2 ? ImgOpt2 : Det5
		RegExMatch(Det5, "\*H(.+?)\s+(.*)", ImgOpt)
		HScale := ImgOpt1, Det5 := ImgOpt2 ? ImgOpt2 : Det5
		File := Det5
		GuiControl, 19:, Variat, %Variat%
		GuiControl, 19:, IconN, %IconN%
		GuiControl, 19:, TransC, %TransC%
		GuiControl, 19:, WScale, %WScale%
		GuiControl, 19:, HScale, %HScale%
		GoSub, MakePrev
	}
	Else If (Type = cType15)
	{
		color := Det5, Fast := InStr(Det7, "Fast") ? 1 : 0, RGB := InStr(Det7, "RGB") ? 1 : 0
		GuiControl, 19:Choose, ImageS, 2
		GuiControl, 19:Hide, PicPrev
		GuiControl, 19:Show, ColorPrev
		GuiControl, 19:, Fast, %Fast%
		GuiControl, 19:, RGB, %RGB%
		GuiControl, 19:, Variat, %Det6%
		GuiControl, 19:Disable, Screenshot
		GoSub, PixelS
		GuiControl, 19:+Background%color%, ColorPrev
	}
	Else If (Type = cType56)
	{
		TessSelectedLangs := ""
		Loop, Parse, Target, +
			TessSelectedLangs .= InStr(TessLangs, A_LoopField) ? A_LoopField "+" : ""
		TessSelectedLangs := SubStr(TessSelectedLangs, 1, -1)
		GuiControl, 19:Choose, ImageS, 3
		GuiControl, 19:, ImgFile, %Details%
		GoSub, OcrS
	}
	If (Window = "File")
	{
		File := Det1
		GuiControl, 19:, FileOCR, 1
		GuiControl, 19:, ImgFileOCR, %File%
		GuiControl, 19:, ImgFile, %Det2%
		GoSub, FileOCR
		GuiControl, 19:ChooseString, CoordPixel, Screen
		GoSub, MakePrev
	}
	Else
	{
		GuiControl, 19:, iPosX, %Det1%
		GuiControl, 19:, iPosY, %Det2%
		GuiControl, 19:, ePosX, %Det3%
		GuiControl, 19:, ePosY, %Det4%
		GuiControl, 19:, ImgFile, %Det5%
		GuiControl, 19:ChooseString, CoordPixel, %Window%
	}
	If (Target = "UntilFound")
	{
		GuiControl, 19:, BreakLoop, 1
		GoSub, LoopUntil
	}
	Else If (Target = "UntilNotFound")
	{
		GuiControl, 19:, BreakLoop, 1
		GoSub, LoopUntil
		GuiControl, 19:Choose, LoopUntil, 2
	}
	GuiControl, 19:Enable, ImageApply
	GuiControl, 19:, AddIf, 0
	GuiControl, 19:Disable, AddIf
}
Else If (s_Caller = "Find")
{
	If (GotoRes1 = "PixelSearch")
	{
		GuiControl, 19:Choose, ImageS, 2
		GoSub, PixelS
	}
	Else If ((GotoRes1 = "ImageToText") || (GotoRes1 = "OCR"))
	{
		GuiControl, 19:Choose, ImageS, 3
		GoSub, OcrS
	}
}
Gui, Submit, NoHide
SBShowTip(ImageS = 1 ? "ImageSearch" : ImageS = 2 ? "PixelSearch" : "ImageToText")
Gui, 19:Show,, %c_Lang006% / %c_Lang007% / %c_Lang260%
ChangeIcon(hIL_Icons, CmdWin, IconsNames["image"])
Input
Tooltip
return

ImageApply:
ImageOK:
Gui, 19:Submit, NoHide
If (ImgFile = "")
{
	GuiControl, 19:Focus, ImgFile
	return
}
If (ImageS = 3)
{
	Try
		z_Check := VarSetCapacity(%ImgFile%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%`n`n%ImgFile%
		return
	}
}
Else
{
	If ((OutVarX = "") || (OutVarY = ""))
	{
		Gui, 19:Font, cRed
		GuiControl, 19:Font, OutVarT
		GuiControl, 19:Focus, OutVarX
		return
	}
	Try
		z_Check := VarSetCapacity(%OutVarX%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%`n`n%OutVarX%
		return
	}
	Try
		z_Check := VarSetCapacity(%OutVarY%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%`n`n%OutVarY%
		return
	}
}
DelayX := InStr(DelayC, "%") ? DelayC : DelayX
If (Sec = 1)
	DelayX *= 1000
TimesX := InStr(EdRept, "%") ? EdRept : TimesX
If (TimesX = 0)
	TimesX := 1
Action := (ImageS = 3) ? "OCR" : IfFound "`, " IfNotFound ", " OutVarX ", " OutVarY
EscCom(false, ImgFile)
EscCom(false, ImgFileOCR)
If (ImageS = 1)
{
	Action .=  ", " FixFoundVars
	ImgOptions := ""
	If (Variat > 0)
		ImgOptions .= "*" Variat " "
	If (IconN != "")
		ImgOptions .= "*Icon" IconN " "
	If (TransC != "")
		ImgOptions .= "*Trans" TransC " "
	If (WScale != "")
		ImgOptions .= "*W" WScale " "
	If (HScale != "")
		ImgOptions .= "*H" HScale " "
	Type := cType16, ImgFile := ImgOptions ImgFile
}
Details := iPosX "`, " iPosY "`, " ePosX "`, " ePosY "`, " ImgFile
If (ImageS = 2)
	Type := cType15, Details .= ", " Variat "," (Fast ? " Fast" : "") (RGB ? " RGB" : "")
If (ImageS = 3)
	Type := cType56
Details := RTrim(Details, ", ")
If (BreakLoop)
{
	If (LoopUntil = "Found")
		Target := "UntilFound"
	Else
		Target := "UntilNotFound"
}
Else If (ImageS = 3)
{
	If (FileOCR)
	{
		Details := ImgFileOCR "`, " ImgFile
		CoordPixel := "File"
	}
	Target := TessSelectedLangs != "" ? TessSelectedLangs : "eng"
}
Else
	Target := ""
If (A_ThisLabel != "ImageApply")
{
	Gui, 1:-Disabled
	Gui, 19:Destroy
}
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected"), LV_GetText(RowType, LV_GetNext(), 6)
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", Action, Details, TimesX, DelayX, Type, Target, CoordPixel)
Else If ((RowSelection = 0) || ((RowType = cType47) || RowType = cType48))
{
	LV_Add("Check", ListCount%A_List%+1, Action, Details, TimesX, DelayX, Type, Target, CoordPixel)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	LV_Insert(LV_GetNext(), "Check", LV_GetNext(), Action, Details, TimesX, DelayX, Type, Target, CoordPixel)
	LVManager[A_List].InsertAtGroup(LV_GetNext())
}
GoSub, RowCheck
GoSub, b_Start
If (AddIf = 1)
{
	If ((RowSelection = 0) || ((RowType = cType47) || RowType = cType48))
	{
		LV_Add("Check", ListCount%A_List%+1, If9,, 1, 0, cType17)
		LV_Add("Check", ListCount%A_List%+2, "[End If]", "EndIf", 1, 0, cType17)
		LV_Modify(ListCount%A_List%+2, "Vis")
	}
	Else
	{
		LV_Insert(LV_GetNext(), "Check",, If9,, 1, 0, cType17)
		LVManager[A_List].InsertAtGroup(LV_GetNext()), RowNumber := 0, LastRow := 0
		Loop
		{
			RowNumber := LV_GetNext(RowNumber)
			If (!RowNumber)
			{
				LV_Insert(LastRow+1, "Check",LastRow+1, "[End If]", "EndIf", 1, 0, cType17)
				LVManager[A_List].InsertAtGroup(LastRow)
				break
			}
			LastRow := LV_GetNext(LastRow)
		}
	}
	GoSub, RowCheck
	GoSub, b_Start
}
If (A_ThisLabel = "ImageApply")
	Gui, 19:Default
Else
{
	s_Caller := ""
	GuiControl, Focus, InputList%A_List%
}
return

ImageCancel:
PixelCancel:
19GuiClose:
19GuiEscape:
Gui, 1:-Disabled
Gui, 19:Destroy
s_Caller := ""
return

SearchImg:
Gui, 19:+OwnDialogs
Gui, 19:Submit, NoHide
If (ImageS = 1)
	GoSub, GetImage
Else If (ImageS = 2)
	GoSub, EditColor
Else If (ImageS = 3)
{
	If (A_GuiControl = "SearchImg")
		GoSub, ShowTessMenu
	Else
		GoSub, GetImage
}
return

GetImage:
FileSelectFile, File,,, %AppName%, Images (*.gif; *.jpg; *.bmp; *.png; *.tif; *.ico; *.cur; *.ani; *.exe; *.dll)
FreeMemory()
If (File = "")
	return
If (A_GuiControl = "SearchImg")
	GuiControl, 19:, ImgFile, %File%
Else
	GuiControl, 19:, ImgFileOCR, %File%

MakePrev:
If (InStr(File, "%"))
	File := DerefVars(File)
PicGetSize(File, LoadedPicW, LoadedPicH)
Width := 255
Height := 200
PropH := LoadedPicH * Width // LoadedPicW, PropW := LoadedPicW * Height // LoadedPicH
If ((LoadedPicW <= Width) && (LoadedPicH <= Height))
	GuiControl, 19:, PicPrev, *W0 *H0 %File%
Else If (PropH > Height)
	GuiControl, 19:, PicPrev, *W-1 *H%Height% %File%
Else
	GuiControl, 19:, PicPrev, *W%Width% *H-1 %File%
GuiControl, 19:, ImgSize, %c_Lang059%: %LoadedPicW% x %LoadedPicH%
return

ImageS:
Gui, 19:Submit, NoHide
If (ImageS = 3)
{
	GoSub, OcrS
	return
}
Else
{
	GuiControl, 19:Hide, OutputVarT
	GuiControl, 19:Hide, FileOCR
	GuiControl, 19:Hide, ImgFileOCR
	GuiControl, 19:Hide, SearchImgOCR
	GuiControl, 19:Show, IfFound
	GuiControl, 19:Show, IfFoundT
	GuiControl, 19:Show, IfNotFound
	GuiControl, 19:Show, IfNotFoundT
	GuiControl, 19:Show, AddIf
	GuiControl, 19:Enable, OutVarX
	GuiControl, 19:Enable, OutVarY
	GuiControl, 19:Enable, CoordPixel
	GuiControl, 19:Enable, VariatT
	GuiControl, 19:Enable, BreakLoop
}
GuiControl, 19:, FileOCR, 0
GuiControl, 19:Enable, iPosX
GuiControl, 19:Enable, iPosY
GuiControl, 19:Enable, ePosX
GuiControl, 19:Enable, ePosY
If (ImageS = 1)
{
	GuiControl, 19:, ImgFile
	GuiControl, 19:, PicPrev
	GuiControl, 19:, ImgSize
	GuiControl, +BackgroundDefault, ColorPrev
	GuiControl, 19:Show, PicPrev
	GuiControl, 19:Hide, ColorPrev
	GuiControl, 19:Disable, ColorPick
	GuiControl, 19:Hide, ColorPick
	GuiControl, 19:Disable, Fast
	GuiControl, 19:Disable, RGB
	GuiControl, 19:Show, Screenshot
	GuiControl, 19:Enable, Screenshot
	GuiControl, 19:Enable, IconN
	GuiControl, 19:Enable, TransC
	GuiControl, 19:Enable, TransCS
	GuiControl, 19:Enable, WScale
	GuiControl, 19:Enable, HScale
	GuiControl, 19:Enable, FixFoundVars
	SBShowTip("ImageSearch")
}
Else If (ImageS = 2)
{
	GoSub, PixelS
}
return

PixelS:
Gui, 19:Submit, NoHide
GuiControl, 19:, ImgFile
GuiControl, 19:, PicPrev
GuiControl, 19:, ImgSize
GuiControl, +BackgroundDefault, ColorPrev
GuiControl, 19:Hide, PicPrev
GuiControl, 19:Show, ColorPrev
GuiControl, 19:Enable, ColorPick
GuiControl, 19:Show, ColorPick
GuiControl, 19:Enable, Fast
GuiControl, 19:Enable, RGB
GuiControl, 19:Disable, Screenshot
GuiControl, 19:Hide, Screenshot
GuiControl, 19:Disable, IconN
GuiControl, 19:Disable, TransC
GuiControl, 19:Disable, TransCS
GuiControl, 19:Disable, WScale
GuiControl, 19:Disable, HScale
GuiControl, 19:Disable, FixFoundVars
SBShowTip("PixelSearch")
return

OcrS:
GuiControl, 19:, ImgFile
GuiControl, 19:, PicPrev
GuiControl, 19:, ImgSize
GuiControl, +BackgroundDefault, ColorPrev
GuiControl, 19:Show, OutputVarT
GuiControl, 19:Show, FileOCR
GuiControl, 19:Show, ImgFileOCR
GuiControl, 19:Show, SearchImgOCR
GuiControl, 19:Show, PicPrev
GuiControl, 19:Hide, ColorPrev
GuiControl, 19:Disable, ColorPick
GuiControl, 19:Hide, ColorPick
GuiControl, 19:Disable, Fast
GuiControl, 19:Disable, RGB
GuiControl, 19:Disable, Screenshot
GuiControl, 19:Hide, Screenshot
GuiControl, 19:Disable, IconN
GuiControl, 19:Disable, TransC
GuiControl, 19:Disable, TransCS
GuiControl, 19:Disable, WScale
GuiControl, 19:Disable, HScale
GuiControl, 19:Disable, FixFoundVars

GuiControl, 19:, AddIf, 0
GuiControl, 19:, FixFoundVars, 0
GuiControl, 19:, BreakLoop, 0
GuiControl, 19:ChooseString, CoordPixel, Screen
GuiControl, 19:Hide, IfFound
GuiControl, 19:Hide, IfFoundT
GuiControl, 19:Hide, IfNotFound
GuiControl, 19:Hide, IfNotFoundT
GuiControl, 19:Hide, AddIf
GuiControl, 19:Disable, OutVarX
GuiControl, 19:Disable, OutVarY
GuiControl, 19:Disable, CoordPixel
GuiControl, 19:Disable, VariatT
GuiControl, 19:Disable, BreakLoop

SBShowTip("ImageToText")
return

FileOCR:
Gui, 19:Submit, NoHide
If (FileOCR)
{
	GuiControl, 19:Disable, iPosX
	GuiControl, 19:Disable, iPosY
	GuiControl, 19:Disable, ePosX
	GuiControl, 19:Disable, ePosY
	GuiControl, 19:Enable, ImgFileOCR
	GuiControl, 19:Enable, SearchImgOCR
}
Else
{
	GuiControl, 19:Enable, iPosX
	GuiControl, 19:Enable, iPosY
	GuiControl, 19:Enable, ePosX
	GuiControl, 19:Enable, ePosY
	GuiControl, 19:Disable, ImgFileOCR
	GuiControl, 19:Disable, SearchImgOCR
}
return

PicOpen:
If (A_GuiEvent != "DoubleClick")
	return
Gui, 19:Submit, NoHide
Gui, 19:+OwnDialogs
If (InStr(FileExist(ImgFile), "A"))
Try
	Run, %ImgFile%
Catch e
	MsgBox, 16, %d_Lang007%, % d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" e.Extra

return

IfFound:
Gui, 19:Submit, NoHide
If (IfFound != "Continue")
	GuiControl, 19:, AddIf, 0
return

ImageOpt:
; Screenshots
Gui, 25:+owner19 +ToolWindow
Gui, 19:+Disabled
OldAreaColor := SearchAreaColor
Gui, 25:Add, GroupBox, Section ym xm W400 H175, %t_Lang046%:
Gui, 25:Add, Text, -Wrap R1 ys+20 xs+10 W200, %t_Lang047%:
Gui, 25:Add, DDL, yp-5 x+0 vDrawButton W75, RButton||LButton|MButton
Gui, 25:Add, Text, -Wrap R1 y+10 xs+10 W200, %t_Lang048%:
Gui, 25:Add, Edit, Limit Number yp-2 x+0 W40 R1 vLineT
Gui, 25:Add, UpDown, yp x+20 vLineW 0x80 Range1-5, %LineW%
Gui, 25:Add, Text, -Wrap R1 y+10 xs+10 W200, %w_Lang039%:
Gui, 25:Add, Text, -Wrap R1 yp x+0 W75 vSearchAreaColor gEditColor c%SearchAreaColor%, ███████
Gui, 25:Add, Radio, -Wrap y+10 xs+10 W190 vOnRelease R1, %t_Lang049%
Gui, 25:Add, Radio, -Wrap yp x+10 W180 vOnEnter R1, %t_Lang050%
Gui, 25:Add, Text, -Wrap R1 y+10 xs+10 W380, %t_Lang051%:
Gui, 25:Add, Edit, vScreenDir W350 R1 -Multi, %ScreenDir%
Gui, 25:Add, Button, -Wrap yp-1 x+0 W30 H23 vSearchScreen gSearchDir, ...
Gui, 25:Add, Button, -Wrap Default Section xm W75 H23 gImgConfigOK, %c_Lang020%
Gui, 25:Add, Button, -Wrap ys W75 H23 gImgConfigCancel, %c_Lang021%
GuiControl, 25:ChooseString, DrawButton, %DrawButton%
GuiControl, 25:, OnRelease, %OnRelease%
GuiControl, 25:, OnEnter, %OnEnter%
Gui, 25:Show,, %t_Lang017%
Gui, 25:Default
Tooltip
return

ImgConfigOK:
Gui, 25:Submit, NoHide
If (OnRelease = 1)
	SSMode := "OnRelease"
Else If (OnEnter = 1)
	SSMode := "OnEnter"
Gui, 19:-Disabled
Gui, 25:Destroy
Gui, 19:Default
return

ImgConfigCancel:
25GuiClose:
25GuiEscape:
SearchAreaColor := OldAreaColor
Gui, 19:-Disabled
Gui, 25:Destroy
Gui, 19:Default
return

LoopUntil:
Gui, 19:Submit, NoHide
GuiControl, 19:Enable%BreakLoop%, LoopUntil
return

EditRun:
s_Caller := "Edit"
Run:
s_Filter := "All"
Gui, 10:+owner1 -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
Gui, 10:Add, Groupbox, Section W600 H55
Gui, 10:Add, Text, -Wrap R1 ys+20 xs+10 W200 Right, %c_Lang055%:
Gui, 10:Add, ComboBox, yp x+10 W170 vFileCmdL gFileCmd, %FileCmdList%
Gui, 10:Add, Button, yp-1 x+0 W25 H23 hwndCmdFilter vCmdFilter gCmdFilter
	ILButton(CmdFilter, ResDllPath ":" 102)
Gui, 10:Add, Button, yp x+5 W25 H23 hwndCmdSort vCmdSort gCmdSort
	ILButton(CmdSort, ResDllPath ":" 110)
Gui, 10:Add, Groupbox, Section xs y+20 W600 H380
Gui, 10:Add, Text, -Wrap R1 ys+15 xs+10 W550 vFCmd1
Gui, 10:Add, Edit, vPar1File W550 R1 -Multi
Gui, 10:Add, Button, -Wrap yp-1 x+0 W30 H23 vSearchPar1 gSearch, ...
Gui, 10:Add, Text, -Wrap R1 xs+10 y+5 W550 vFCmd2
Gui, 10:Add, Edit, vPar2File W550 R1 -Multi
Gui, 10:Add, Button, -Wrap yp-1 x+0 W30 H23 vSearchPar2 gSearch, ...
Gui, 10:Add, Button, -Wrap yp xp W30 H23 vMouseGet gMouseGetI Hidden, ...
Gui, 10:Add, Text, -Wrap R1 xs+10 y+5 W550 vFCmd3
Gui, 10:Add, Edit, vPar3File W550 R1 -Multi
Gui, 10:Add, Button, -Wrap yp-1 x+0 W30 H23 vSearchPar3 gSearch, ...
Gui, 10:Add, Text, -Wrap R1 xs+10 y+5 W550 vFCmd4
Gui, 10:Add, Edit, vPar4File W550 R1 -Multi
Gui, 10:Add, Text, -Wrap R1 xs+10 y+5 W550 vFCmd5
Gui, 10:Add, Edit, vPar5File W550 R1 -Multi
Gui, 10:Add, Text, -Wrap R1 xs+10 y+5 W270 vFCmd6
Gui, 10:Add, Edit, vPar6File W270 R1 -Multi
Gui, 10:Add, Text, -Wrap R1 x+10 yp-20 W270 vFCmd7
Gui, 10:Add, Edit, vPar7File W270 R1 -Multi
Gui, 10:Add, Text, -Wrap R1 xs+10 y+5 W270 vFCmd8
Gui, 10:Add, Edit, vPar8File W270 R1 -Multi
Gui, 10:Add, Text, -Wrap R1 x+10 yp-20 W270 vFCmd9
Gui, 10:Add, Edit, vPar9File W270 R1 -Multi
Gui, 10:Add, Text, -Wrap R1 xs+10 y+5 W270 vFCmd10
Gui, 10:Add, Edit, vPar10File W270 R1 -Multi
Gui, 10:Add, Text, -Wrap R1 x+10 yp-20 W270 vFCmd11
Gui, 10:Add, Edit, vPar11File W270 R1 -Multi
Gui, 10:Add, Button, -Wrap Section Default xm W75 H23 vRunOK gRunOK, %c_Lang020%
Gui, 10:Add, Button, -Wrap ys W75 H23 gRunCancel, %c_Lang021%
Gui, 10:Add, Button, -Wrap ys W75 H23 vRunApply gRunApply Disabled, %c_Lang131%
Gui, 10:Add, Text, x+10 yp-3 W320 H25 cGray, %c_Lang025%
Gui, 10:Add, StatusBar, gStatusBarHelp
Gui, 10:Default
SB_SetIcon(ResDllPath, IconsNames["help"])
If (s_Caller = "Edit")
{
	GuiControl, 10:ChooseString, FileCmdL, %Type%
	StringReplace, Details, Details, `````,, %_x%, All
	Loop, Parse, Details, `,, %A_Space%
	{
		StringReplace, LoopField, A_LoopField, %_x%, `,, All
		GuiControl, 10:, Par%A_Index%File, %LoopField%
	}
	GuiControl, 10:Enable, RunApply
}
GoSub, FileCmd
If (s_Caller = "Find")
{
	GuiControl, 10:ChooseString, FileCmdL, %GotoRes1%
	GoSub, FileCmd
}
SetFilter := t_Lang007
Gui, 10:Show,, %c_Lang008%
ChangeIcon(hIL_Icons, CmdWin, IconsNames["run"])
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
FileSelectFile, File, 2,, %AppName%
FreeMemory()
If (File = "")
	return
EdField := SubStr(A_GuiControl, 7) "File"
GuiControl,, %EdField%, %File%
return

SearchDir:
Gui, +OwnDialogs
Gui, Submit, NoHide
FileSelectFolder, Folder, *%A_ScriptDir%,, %AppName%
FreeMemory()
If (Folder = "")
	return
EdField := SubStr(A_GuiControl, 7) "Dir"
GuiControl,, %EdField%, %Folder%
return

RunApply:
RunOK:
Gui, 10:Submit, NoHide
Details := ""
Loop, 11
{
	GuiControlGet, fTxt, 10:, FCmd%A_Index%
	If (InStr(fTxt, "OutputVar") || InStr(fTxt, "InputVar"))
	{
		VarName := Par%A_Index%File
		If (VarName = "")
		{
			If fTxt not in OutputVarPID,OutputVarX,OutputVarY,OutputVarWin,OutputVarControl
			{
				Tooltip, %c_Lang127%, 25, % (A_Index = 1) ? 125 : 170
				return
			}
		}
		Try
			z_Check := VarSetCapacity(%VarName%)
		Catch
		{
			MsgBox, 16, %d_Lang007%, %d_Lang041%`n`n%VarName%
			return
		}
	}
	GuiControlGet, fState, 10:Enabled, Par%A_Index%File
	If (fState = 1)
	{
		IfInString, Par%A_Index%File, `,
			StringReplace, Par%A_Index%File, Par%A_Index%File, `,, `````,, All
		Details .= Par%A_Index%File "`, "
	}
}
StringReplace, Details, Details, ```,, %_x%, All
Details := RTrim(Details, ", ")
StringReplace, Details, Details, %_x%, ```,, All
If (A_ThisLabel != "RunApply")
{
	Gui, 1:-Disabled
	Gui, 10:Destroy
}
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected"), LV_GetText(RowType, LV_GetNext(), 6)
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", FileCmdL, Details, TimesX, DelayX, FileCmdL)
Else If ((RowSelection = 0) || ((RowType = cType47) || RowType = cType48))
{
	LV_Add("Check", ListCount%A_List%+1, FileCmdL, Details, 1, DelayG, FileCmdL)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	GuiControl, chMacro:-g, InputList%A_List%
	RowNumber := 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, FileCmdL, Details, 1, DelayG, FileCmdL)
		LVManager[A_List].InsertAtGroup(RowNumber)
		RowNumber++
	}
	GuiControl, chMacro:+gInputList, InputList%A_List%
}
GoSub, RowCheck
GoSub, b_Start
If (A_ThisLabel = "RunApply")
	Gui, 10:Default
Else
{
	s_Caller := ""
	GuiControl, Focus, InputList%A_List%
}
return

RunCancel:
10GuiClose:
10GuiEscape:
Gui, 1:-Disabled
Gui, 10:Destroy
s_Caller := ""
return

FileCmd:
CbAutoComplete()
Gui, 10:Submit, NoHide
SBShowTip(FileCmdL)
Loop, 11
{
	Try
	{
		GuiControl, 10:, FCmd%A_Index%, % %FileCmdL%%A_Index%
		If (!%FileCmdL%%A_Index%)
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
If (FileCmdL = "InputBox")
{
	GuiControl, 10:, Par9File
	GuiControl, 10:+ReadOnly, Par9File
}
Else
	GuiControl, 10:-ReadOnly, Par9File
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

CmdFilter:
Menu, RunFilterMenu, Add, %t_Lang007%, SetRunFilter
Menu, RunFilterMenu, Add, %t_Lang166%, SetRunFilter
Menu, RunFilterMenu, Add, %t_Lang167%, SetRunFilter
Menu, RunFilterMenu, Add, %t_Lang168%, SetRunFilter
Menu, RunFilterMenu, Add, %t_Lang169%, SetRunFilter
Menu, RunFilterMenu, Add, %t_Lang170%, SetRunFilter
Menu, RunFilterMenu, Add, %t_Lang171%, SetRunFilter
Menu, RunFilterMenu, Add, %t_Lang172%, SetRunFilter
Menu, RunFilterMenu, Add, %t_Lang173%, SetRunFilter
Menu, RunFilterMenu, Add, %t_Lang174%, SetRunFilter
Menu, RunFilterMenu, Add, %t_Lang175%, SetRunFilter
Menu, RunFilterMenu, Check, %SetFilter%
Menu, RunFilterMenu, Show
Menu, RunFilterMenu, DeleteAll
return

SetRunFilter:
s_Filter := Run_Filter_%A_ThisMenuItemPos%
If (s_Filter = "All")
	GuiControl, 10:, FileCmdL, |%FileCmdList%
Else
	GuiControl, 10:, FileCmdL, % "|" RunList_%s_Filter%
GuiControl, 10:Choose, FileCmdL, 1
GoSub, FileCmd
SetFilter := A_ThisMenuItem
return

CmdSort:
Gui, 10:Submit, NoHide
If (s_Filter = "All")
	SortedCmdList := StrReplace(FileCmdList, "||", "|")
Else
	SortedCmdList := RunList_%s_Filter%
Sort, SortedCmdList, D|
GuiControl, 10:, FileCmdL, |%SortedCmdList%
GuiControl, 10:Choose, FileCmdL, %FileCmdL%
return

EditFunc:
EditVar:
EditSt:
s_Caller := "Edit"
If ((Action = "[End If]") || (Action = "[Else]"))
	return
AsFunc:
AsVar:
IfSt:
Proj_Funcs := ""
Gui, chMacro:Default
Loop, %TabCount%
{
	Gui, chMacro:ListView, InputList%A_Index%
	Loop, % ListCount%A_Index%
	{
		LV_GetText(Row_Type, A_Index, 6)
		If (Row_Type = cType47)
		{
			LV_GetText(Row_Func, A_Index, 3)
			Proj_Funcs .= Row_Func "$"
			%Row_Func%_Hint := "(", HasDefault := false
			Loop, % A_Index - 1
			{
				LV_GetText(Row_Type, A_Index, 6)
				If (Row_Type != cType48)
					continue
				LV_GetText(Row_Param, A_Index, 3)
				HasDefault := InStr(Row_Param, " :=")
				If (HasDefault)
				{
					If (!InStr(%Row_Func%_Hint, "["))
						%Row_Func%_Hint := Trim(%Row_Func%_Hint, ", ") (%Row_Func%_Hint = "(" ? "[" : " [, ")
					%Row_Func%_Hint .= SubStr(Row_Param, 1, HasDefault-1) ", "
				}
				Else
					%Row_Func%_Hint .= Row_Param ", "
			}
			%Row_Func%_Hint := Trim(%Row_Func%_Hint, ", ") . (HasDefault ? "])" : ")")
		}
	}
}
Statements := "
(Join$
" c_Lang190 "$
" c_Lang191 "
" c_Lang192 "
" c_Lang193 "
" c_Lang194 "
" c_Lang195 "
" c_Lang196 "
" c_Lang197 "
" c_Lang198 "
" c_Lang199 "
" c_Lang200 "
" c_Lang201 "
" c_Lang202 "
" c_Lang203 "
" c_Lang204 "
)"

Gui, 21:+owner1 -MinimizeBox +E0x00000400 +HwndCmdWin +Delimiter$
Gui, 1:+Disabled
Gui, 21:Add, Tab2, W450 H0 vTabControl AltSubmit, CmdTab1$CmdTab2$CmdTab3
; Statements
Gui, 21:Add, GroupBox, Section xm ym W450 H240
Gui, 21:Add, DDL, ys+15 xs+10 W190 vStatement gStatement AltSubmit, %Statements%
Gui, 21:Add, Text, yp x+5 h25 0x11
Gui, 21:Add, DDL, yp x+0 W105 vIfMsgB AltSubmit Disabled, %c_Lang168%$$%c_Lang169%$%c_Lang170%$%c_Lang171%$%c_Lang172%$%c_Lang173%$%c_Lang174%$%c_Lang175%$%c_Lang176%$%c_Lang177%
Gui, 21:Add, Text, yp x+5 h25 0x11
Gui, 21:Add, Button, yp x+0 W75 vIdent gWinTitle, WinTitle
Gui, 21:Add, Button, -Wrap yp x+5 W30 H23 vIfGet gIfGet, ...
Gui, 21:Add, Text, -Wrap R1 y+5 xs+10 W400 vFormatTip, %Wcmd_All%
Gui, 21:Add, Edit, y+5 xs+10 W430 R4 -vScroll vTestVar
Gui, 21:Add, Text, -Wrap R1 y+11 xs+10 W135 vFormatTip2
Gui, 21:Add, DDL, yp-5 x+0 W100 vIfOper gCoOper Disabled, =$$==$!=$>$<$>=$<=$in$not in$contains$not contains$between$not between$is$is not
Gui, 21:Add, Text, -Wrap R1 yp+5 x+5 W150 vCoOper cGray, %Co_Oper_01%
Gui, 21:Add, Text, -Wrap yp xs+10 W430 R6 vExpTxt Hidden, %d_Lang097%
Gui, 21:Add, Edit, yp+20 xs+10 W430 R4 -vScroll vTestVar2 Disabled
Gui, 21:Add, Text, -Wrap R1 W430 cGray vVarTxt, %c_Lang025%
Gui, 21:Add, Link, -Wrap xp yp W430 R1 vExprLink1 gExprLink Hidden, <a>%c_Lang091%</a>
Gui, 21:Add, Groupbox, Section xs y+15 W450 H50, %c_Lang123%:
Gui, 21:Add, Button, -Wrap ys+18 xs+85 W75 H23 vAddElse gAddElse, %c_Lang083%
Gui, 21:Add, Button, -Wrap Section Default xm y+14 W75 H23 gIfOK, %c_Lang020%
Gui, 21:Add, Button, -Wrap ys W75 H23 gIfCancel, %c_Lang021%
Gui, 21:Add, Button, -Wrap ys W75 H23 vIfApply gIfApply Disabled, %c_Lang131%
Gui, 21:Add, Checkbox, -Wrap R1 ys+5 W190 vElseIf, %c_Lang083% %c_Lang247%
Gui, 21:Tab, 2
; Variables
Gui, 21:Add, GroupBox, Section xm ym W450 H240
Gui, 21:Add, Text, -Wrap R1 ys+15 xs+10 vVarNameT, %c_Lang057%:
Gui, 21:Add, Edit, W200 R1 -Multi vVarName
Gui, 21:Add, Text, -Wrap R1 yp-20 x+5 W120, %c_Lang086%:
Gui, 21:Add, DDL, y+7 W60 vOper gAsOper, %AssignOperators%
Gui, 21:Add, Text, -Wrap R1 yp+5 x+5 W150 vAsOper cGray, %As_Oper_01%
Gui, 21:Add, Text, -Wrap R1 y+9 xs+10 W200, %c_Lang056%:
Gui, 21:Add, Checkbox, -Wrap Checked%EvalDefault% yp x+5 W220 vUseEval gUseEval R1, %c_Lang087% / %c_Lang211%
Gui, 21:Add, Edit, y+10 xs+10 W430 H110 vVarValue
Gui, 21:Add, Text, -Wrap R1 W430 cGray vVarTip, %c_Lang025%
Gui, 21:Add, Link, -Wrap xp yp W430 R1 vExprLink2 gExprLink Hidden, <a>%c_Lang091%</a>
Gui, 21:Add, Text, -Wrap R1 y+5 W430 cGray vArrayTip Hidden, %c_Lang206%
Gui, 21:Add, Groupbox, Section xs y+14 W450 H50, %c_Lang010%:
Gui, 21:Add, Button, -Wrap ys+18 xs+85 W75 H23 vVarCopyA gVarCopy, %c_Lang023%
Gui, 21:Add, Button, -Wrap x+10 yp W75 H23 gReset, %c_Lang088%
Gui, 21:Add, Button, -Wrap Section xm y+14 W75 H23 vVarOK gVarOK, %c_Lang020%
Gui, 21:Add, Button, -Wrap ys W75 H23 gIfCancel, %c_Lang021%
Gui, 21:Add, Button, -Wrap ys W75 H23 vVarApplyA gVarApply Disabled, %c_Lang131%
Gui, 21:Tab, 3
; Functions
Gui, 21:Add, GroupBox, Section xm ym W450 H240
Gui, 21:Add, Text, -Wrap R1 ys+20 xs+10 W200, %c_Lang057%:
Gui, 21:Add, Edit, W200 R1 -Multi vVarNameF
Gui, 21:Add, Checkbox, -Wrap R1 ys+20 x+5 W200 vIsArray gIsArray, %c_Lang207% / %c_Lang211%:
Gui, 21:Add, Edit, W200 R1 -Multi vArrayName Disabled
Gui, 21:Add, Checkbox, -Wrap R1 y+10 xs+10 W430 vUseExtFunc gUseExtFunc, %c_Lang128%
Gui, 21:Add, Edit, W400 R1 -Multi vFileNameEx Disabled, %StdLibFile%
Gui, 21:Add, Button, -Wrap yp-1 x+0 W30 H23 vSearchFEX gSearchAHK Disabled, ...
Gui, 21:Add, Text, -Wrap R1 y+10 xs+10 W130 vFuncNameT, %c_Lang089% / %c_Lang095%:
Gui, 21:Add, Combobox, W400 -Multi vFuncName gFuncName, %Proj_Funcs%%BuiltinFuncList%
Gui, 21:Add, Button, -Wrap W25 yp-1 x+5 hwndFuncHelp vFuncHelp gFuncHelp Disabled
	ILButton(FuncHelp, ResDllPath ":" 24)
Gui, 21:Add, Text, -Wrap R1 W430 y+11 xs+10, %c_Lang090%:
Gui, 21:Add, Edit, W430 R1 -Multi vVarValueF
Gui, 21:Add, Text, -Wrap R1 W430 vFuncTip
Gui, 21:Add, Groupbox, Section xs y+12 W450 H50, %c_Lang010%:
Gui, 21:Add, Button, -Wrap ys+18 xs+85 W75 H23 vVarCopyB gVarCopy, %c_Lang023%
Gui, 21:Add, Button, -Wrap x+10 yp W75 H23 gReset, %c_Lang088%
Gui, 21:Add, Button, -Wrap Section xm y+14 W75 H23 vFuncOK gVarOK, %c_Lang020%
Gui, 21:Add, Button, -Wrap ys W75 H23 gIfCancel, %c_Lang021%
Gui, 21:Add, Button, -Wrap ys W75 H23 vVarApplyB gVarApply Disabled, %c_Lang131%
Gui, 21:Add, Link, -Wrap R1 x+10 yp+3 W190 vExprLink3 gExprLink, <a>%c_Lang091%</a>
Gui, 21:Add, StatusBar, gStatusBarHelp
Gui, 21:Default
SB_SetIcon(ResDllPath, IconsNames["help"])
If (s_Caller = "Edit")
{
	If (A_ThisLabel = "EditSt")
	{
		If (Action != If15)
			StringReplace, Details, Details, ``n, `n, All
		If (InStr(Action, "[ElseIf] "))
		{
			Action := SubStr(Action, 10)
			GuiControl, 21:, ElseIf, 1
			GuiControl, 21:Disable, ElseIf
		}
		Loop, 15
		{
			If (IfList%A_Index% = Action)
				GuiControl, 21:Choose, Statement, %A_Index%
		}
		If (InStr(Action, "String"))
		{
			RegExMatch(Details, "^(\w*?)(,)(.*)", aMatch)
			GuiControl, 21:, TestVar, % Trim(aMatch1)
			GuiControl, 21:, TestVar2, % Trim(aMatch3)
		}
		Else If (InStr(Action, "Compare"))
		{
			CompareParse(Details, VarName, Oper, VarValue), Opers := "=$==$!=$>$<$>=$<=$in$not in$contains$not contains$between$not between$is$is not"
			StringReplace, VarValue, VarValue, ```,, `,, All
			GuiControl, 21:, TestVar, %VarName%
			GuiControl, 21:, TestVar2, %VarValue%
			Loop, Parse, Opers, $
				If (A_LoopField = Oper)
					GuiControl, 21:Choose, IfOper, %A_Index%
			Opers := ""
		}
		Else If (Action = "If Message Box")
		{
			Loop, %IfMsg0%
			{
				If (IfMsg%A_Index% = Details)
					GuiControl, 21:Choose, IfMsgB, %A_Index%
			}
		}
		Else
			GuiControl, 21:, TestVar, %Details%
		GoSub, Statement
		If (InStr(Action, "Image"))
			GuiControl, 21:Disable, TestVar
		GuiControl, 21:, TabControl, $%c_Lang009%
		GoSub, CoOper
		GuiTitle := c_Lang009
	}
	Else If (A_ThisLabel = "EditVar")
	{
		If (Target != "Expression")
			StringReplace, Details, Details, ``n, `n, All
		AssignReplace(Details, VarName, Oper, VarValue), GuiTitle := c_Lang010
		GuiControl, 21:Choose, TabControl, 2
		GuiControl, 21:+Default, VarOK
		GuiControl, 21:, VarName, %VarName%
		GuiControl, 21:ChooseString, Oper, %Oper%
		If (Target = "Expression")
		{
			GuiControl, 21:, UseEval, 1
			GuiControl, 21:Hide, VarTip
			GuiControl, 21:Show, ArrayTip
			GuiControl, 21:Show, ExprLink2
		}
		Else
		{
			GuiControl, 21:, UseEval, 0
			GuiControl, 21:Hide, ArrayTip
			GuiControl, 21:Hide, ExprLink2
			GuiControl, 21:Show, VarTip
		}
		GuiControl, 21:, VarValue, %VarValue%
		SBShowTip("Variable")
		GoSub, AsOper
	}
	Else If (A_ThisLabel = "EditFunc")
	{
		AssignReplace(Details, VarName, Oper, VarValue), FuncName := Action, ArrayName := Target, GuiTitle := c_Lang011
		GuiControl, 21:Choose, TabControl, 3
		GuiControl, 21:+Default, FuncOK
		If (VarName != "_null")
			GuiControl, 21:, VarNameF, %VarName%
		If (Type = cType46)
		{
			GuiControl, 21:, IsArray, 1
			GuiControl, 21:, UseExtFunc, 0
			GuiControl, 21:Disable, UseExtFunc
			GuiControl, 21:Enable, ArrayName
			GuiControl, 21:, FuncName, $%ArrayMethodsList%
			GuiControl, 21:, ArrayName, %ArrayName%
			If (InStr(ArrayMethodsList, FuncName))
				GuiControl, 21:ChooseString, FuncName, %FuncName%
			Else
				GuiControl, 21:, FuncName, %FuncName%$$
		}
		Else
		{
			Try IsBuiltIn := Func(FuncName).IsBuiltIn ? 1 : 0
			If (IsBuiltIn)
				GuiControl, 21:ChooseString, FuncName, %FuncName%
			Else
				GuiControl, 21:, FuncName, %FuncName%$$
		}
		GuiControl, 21:, VarValueF, %VarValue%
		If ((Type = cType44) && (Target != ""))
		{
			UseExtFunc := 1, FileNameEx := Target
			GuiControl, 21:, UseExtFunc, 1
			GuiControl, 21:, FileNameEx, %Target%
			GuiControl, 21:Enable, SearchAHK
			GoSub, UseExtFunc
			GuiControl, 21:, FuncName, %FuncName%$$
		}
		GoSub, FuncName
	}
	GuiControl, 21:Enable, IfApply
	GuiControl, 21:Enable, VarApplyA
	GuiControl, 21:Enable, VarApplyB
}
Else
	ExtList := ReadFunctions(StdLibFile)
If (A_ThisLabel = "IfSt")
{
	GuiTitle := c_Lang009
	If (s_Caller = "Find")
	{
		If (InStr(IfCmd, GotoRes1))
		{
			Loop, Parse, IfCmd, `n
			{
				cIf := RTrim(c_If%A_Index%, " ,=0")
				If (GotoRes1 = cIf)
				{
					GuiControl, 21:Choose, Statement, %A_Index%
					break
				}
			}
		}
		Else
		{
			GotoRes1 := If_Replace[GotoRes1]
			GuiControl, 21:ChooseString, Statement, %GotoRes1%
		}
		GoSub, Statement
	}
	Else
		SBShowTip(Trim(c_If1, "=0, "))
}
Else If (A_ThisLabel = "AsVar")
{
	GuiControl, 21:Choose, TabControl, 2
	GuiTitle := c_Lang010
	SBShowTip("Variable")
	If (EvalDefault)
	{
		GuiControl, 21:Hide, VarTip
		GuiControl, 21:Show, ArrayTip
		GuiControl, 21:Show, ExprLink2
	}
}
Else If (A_ThisLabel = "AsFunc")
{
	GuiControl, 21:Choose, TabControl, 3
	GuiTitle := c_Lang011
	If (s_Caller = "Find")
	{
		If (!IsFunc(GotoRes1))
		{
			If GotoRes1 in Delete,HasKey,InsertAt,Length,MaxIndex,MinIndex,RemoveAt,Pop,Push
			{
				GuiControl, 21:, IsArray, 1
				GoSub, IsArray
			}
		}
		GuiControl, 21:ChooseString, FuncName, %GotoRes1%
		GoSub, FuncName
	}
}
Gui, 21:Show,, %GuiTitle%
ChangeIcon(hIL_Icons, CmdWin, InStr(A_ThisLabel, "Var") ? IconsNames["variables"] : InStr(A_ThisLabel, "Func") ? IconsNames["functions"] : IconsNames["ifstatements"])
Tooltip
return

IfApply:
IfOK:
Gui, 21:+OwnDialogs
Gui, 21:Submit, NoHide
Statement := IfList%Statement%, TestVar := Trim(TestVar)
EscCom(false, TestVar2)
If (InStr(Statement, "Image") || (Statement = "If Message Box"))
	TestVar := ""
Else
{
	If (TestVar = "")
	{
		GuiControl, 21:Focus, TestVar
		return
	}
}
If (InStr(Statement, "Compare"))
{
	Try
		z_Check := VarSetCapacity(%TestVar%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%`n`n%TestVar%
		return
	}
	TestVar := TestVar " " IfOper " " TestVar2
	If IfOper in =,==,!=,>,<,>=,<=
	{
		If (RegExMatch(TestVar2, "%\w+%"))
		{
			MsgBox, 52, %d_Lang011%, %d_Lang097%`n`n%d_Lang035%
			IfMsgBox, No
				return
		}
	}
}
Else If (InStr(Statement, "String"))
{
	Try
		z_Check := VarSetCapacity(%TestVar%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%`n`n%TestVar%
		return
	}
	TestVar := TestVar ", " TestVar2
}
Else If (Statement = "If Message Box")
	TestVar := IfMsg%IfMsgB%
If (ElseIf)
	Statement := "[ElseIf] " Statement
StringReplace, TestVar, TestVar, `n, ``n, All
Target := ""
If (A_ThisLabel != "IfApply")
{
	Gui, 1:-Disabled
	Gui, 21:Destroy
}
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected"), LV_GetText(RowType, LV_GetNext(), 6)
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", Statement, TestVar, 1, 0, cType17, Target)
Else If ((RowSelection = 0) || ((RowType = cType47) || RowType = cType48))
{
	LV_Add("Check", ListCount%A_List%+1, Statement, TestVar, 1, 0, cType17, Target)
	If (!ElseIf)
		LV_Add("Check", ListCount%A_List%+2, "[End If]", "EndIf", 1, 0, cType17)
	LV_Modify(ListCount%A_List%+2, "Vis")
}
Else
{
	LV_Insert(LV_GetNext(), "Check",, Statement, TestVar, 1, 0, cType17, Target)
	LVManager[A_List].InsertAtGroup(LV_GetNext() - 1), RowNumber := 0, LastRow := 0
	Loop
	{
		If (ElseIf)
			break
		RowNumber := LV_GetNext(RowNumber)
		If (!RowNumber)
		{
			LV_Insert(LastRow+1, "Check",LastRow+1, "[End If]", "EndIf", 1, 0, cType17)
			LVManager[A_List].InsertAtGroup(LastRow)
			break
		}
		LastRow := LV_GetNext(LastRow)
	}
}
GoSub, RowCheck
GoSub, b_Start
If (A_ThisLabel = "IfApply")
	Gui, 21:Default
Else
{
	s_Caller := ""
	GuiControl, Focus, InputList%A_List%
}
return

VarApply:
VarOK:
Gui, 21:+OwnDialogs
Gui, 21:Submit, NoHide
If (TabControl = 3)
{
	If (FuncName = "")
	{
		Gui, 21:Font, cRed
		GuiControl, 21:Font, FuncNameT
		GuiControl, 21:Focus, FuncName
		return
	}
	If (UseExtFunc)
	{
		SplitPath, FileNameEx,,, ext
		If ((ext != "ahk") || (FuncName = ""))
		{
			MsgBox, 16, %d_Lang007%, %d_Lang055%
			return
		}
		Target := FileNameEx
	}
	Else If (IsArray)
		Target := ArrayName
	Else
		Target := ""
	VarName := VarNameF
	If (VarName = "")
		VarName := "_null"
}
If (VarName = "")
{
	Gui, 21:Font, cRed
	GuiControl, 21:Font, VarNameT
	GuiControl, 21:Focus, VarName
	Tooltip, %c_Lang127%, 25, 65
	return
}
If ((IsArray) && (ArrayName = ""))
{
	GuiControl, 21:Focus, ArrayName
	return
}
If (RegExMatch(VarName, "^(\w+)(\[\S+\]|\.\w+)+", lMatch))
{
	Try
		z_Check := VarSetCapacity(%lMatch1%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%`n`n%lMatch1%
		return
	}
}
Else
{
	Try
		z_Check := VarSetCapacity(%VarName%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%`n`n%VarName%
		return
	}
}
StringReplace, VarValue, VarValue, `n, ``n, All
If (TabControl = 3)
	Action := FuncName, Details := VarName " := " VarValueF, Type := IsArray ? cType46 : cType44
Else
{
	Details := VarName " " Oper " " VarValue, Type := cType21
	GuiControl, 21:+AltSubmit, Oper
	Gui, 21:Submit, NoHide
	Action := "[" ExprOper%Oper% " Variable]"
	GuiControl, 21:-AltSubmit, Oper
	If (UseEval = 1)
		Target := "Expression"
	Else
		Target := ""
}
If ((UseEval = 1) && (RegExMatch(Details, "%\w+%")))
{
	MsgBox, 52, %d_Lang011%, %d_Lang097%`n`n%d_Lang035%
	IfMsgBox, No
		return
}
If (A_ThisLabel != "VarApply")
{
	Gui, 1:-Disabled
	Gui, 21:Destroy
}
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected"), LV_GetText(RowType, LV_GetNext(), 6)
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", Action, Details, TimesX, DelayX, Type, Target)
Else If ((RowSelection = 0) || ((RowType = cType47) || RowType = cType48))
{
	LV_Add("Check", ListCount%A_List%+1, Action, Details, 1, 0, Type, Target)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	LV_Insert(LV_GetNext(), "Check",, Action, Details, 1, 0, Type, Target)
	LVManager[A_List].InsertAtGroup(LV_GetNext())
}
GoSub, RowCheck
GoSub, b_Start
If (A_ThisLabel = "VarApply")
	Gui, 21:Default
Else
{
	s_Caller := ""
	GuiControl, Focus, InputList%A_List%
}
return

CoOper:
GuiControl, 21:+AltSubmit, IfOper
Gui, 21:Submit, NoHide
GuiControl, 21:, CoOper, % IfOper < 10 ? Co_Oper_0%IfOper% : Co_Oper_%IfOper%
GuiControl, 21:-AltSubmit, IfOper
Gui, 21:Submit, NoHide
If (IfList%Statement% = If14)
{
	If IfOper in =,==,!=,>,<,>=,<=
	{
		GuiControl, 21:Hide, VarTxt
		GuiControl, 21:Show, ExprLink1
	}
	Else
	{
		GuiControl, 21:Hide, ExprLink1
		GuiControl, 21:Show, VarTxt
	}
}
return

AsOper:
GuiControl, 21:+AltSubmit, Oper
Gui, 21:Submit, NoHide
GuiControl, 21:, AsOper, % Oper < 10 ? As_Oper_0%Oper% : As_Oper_%Oper%
GuiControl, 21:-AltSubmit, Oper
return

AddElse:
Gui, 21:Submit, NoHide
Gui, 1:-Disabled
Gui, 21:Destroy
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected"), LV_GetText(RowType, LV_GetNext(), 6)
If ((RowSelection = 0) || ((RowType = cType47) || RowType = cType48))
{
	LV_Add("Check", ListCount%A_List%+1, "[Else]", "Else", 1, 0, cType17)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	LV_Insert(LV_GetNext(), "Check",, "[Else]", "Else", 1, 0, cType17)
	LVManager[A_List].InsertAtGroup(LV_GetNext())
}
GoSub, RowCheck
GoSub, b_Start
GuiControl, Focus, InputList%A_List%
return

VarCopy:
Gui, 21:Submit, NoHide
If (TabControl = 3)
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
Gui, 21:Submit, NoHide
If (TabControl = 3)
{
	If (VarNameF = "")
		return
	%VarNameF% := ""
	SavedVars(VarNameF)
}
Else
{
	If (VarName = "")
		return
	%VarName% := ""
	SavedVars(VarName)
}
return

UseEval:
Gui, 21:Submit, NoHide
If (UseEval)
{
	GuiControl, 21:Hide, VarTip
	GuiControl, 21:Show, ArrayTip
	GuiControl, 21:Show, ExprLink2
}
Else
{
	GuiControl, 21:Hide, ArrayTip
	GuiControl, 21:Hide, ExprLink2
	GuiControl, 21:Show, VarTip
}
return

IfCancel:
21GuiClose:
21GuiEscape:
Gui, 1:-Disabled
Gui, 21:Destroy
s_Caller := ""
return

FuncName:
CbAutoComplete()
Gui, 21:Submit, NoHide
If FuncName in Delete,HasKey,InsertAt,Length,MaxIndex,MinIndex,RemoveAt,Pop,Push
	IsBuiltIn := 1
Else
	Try IsBuiltIn := Func(FuncName).IsBuiltIn ? 1 : 0
	Catch
		IsBuiltIn := 0
GuiControl, 21:Enable%IsBuiltIn%, FuncHelp
Try GuiControl, 21:, FuncTip, % %FuncName%_Hint
SBShowTip(FuncName)
return

IsArray:
Gui, 21:Submit, NoHide
If (IsArray)
{
	GuiControl, 21:, UseExtFunc, 0
	GoSub, UseExtFunc
}
GuiControl, 21:Disable%IsArray%, UseExtFunc
GuiControl, 21:Enable%IsArray%, ArrayName
GuiControl, 21:, FuncName, % "$" (IsArray ? ArrayMethodsList : Proj_Funcs . BuiltinFuncList)
return

UseExtFunc:
Gui, 21:Submit, NoHide
Gui, 21:+OwnDialogs
If (!A_AhkPath)
{
	GuiControl, 21:, UseExtFunc, 0
	MsgBox, 17, %d_Lang007%, %d_Lang056%
	IfMsgBox, OK
		Run, https://www.autohotkey.com/
	return
}
GuiControl, 21:Enable%UseExtFunc%, FileNameEx
GuiControl, 21:Enable%UseExtFunc%, SearchFEX
GuiControl, 21:Disable, FuncHelp
GuiControl, 21:, FuncName, $
If (UseExtFunc = 1)
	ExtList := ReadFunctions(FileNameEx, t_Lang086)
GuiControl, 21:, FuncName, % (UseExtFunc) ? "$" ExtList : "$" Proj_Funcs . BuiltinFuncList
SB_SetText("")
return

SearchAHK:
Gui, +OwnDialogs
Gui, Submit, NoHide
FileSelectFile, File, 1,, %AppName%, AutoHotkey Scripts (*.ahk)
FreeMemory()
If (File = "")
	return
If (A_GuiControl = "StdLib")
	GuiControl, 4:, StdLibFile, %File%
Else
{
	GuiControl, 21:, FileNameEx, %File%
	GuiControl, 21:, FuncName, $
	ExtList := ReadFunctions(File, t_Lang086)
	GuiControl, 21:, FuncName, % (UseExtFunc) ? "$" ExtList : "$" BuiltinFuncList
}
return

FuncHelp:
Gui, Submit, NoHide
If FuncName in Abs,ACos,Asc,ASin,ATan,Ceil,Chr,Exp,FileExist,Floor,Func
,GetKeyName,GetKeySC,GetKeyState,GetKeyVK,InStr,IsByRef,IsFunc,IsLabel
,IsObject,Ln,Log,LTrim,Mod,NumGet,NumPut,Ord,Round,RTrim,Sin,Sqrt,StrGet
,StrLen,StrPut,SubStr,Tan,Trim,WinActive,WinExist
	Run, %HelpDocsUrl%/Functions.htm#%FuncName%
Else If (FuncName = "Array")
	Run, %HelpDocsUrl%/misc/Arrays.htm
Else If (FuncName = "StrSplit")
	Run, %HelpDocsUrl%/commands/StringSplit.htm
Else If (FuncName = "StrReplace")
	Run, %HelpDocsUrl%/commands/StringReplace.htm
Else If FuncName in Delete,HasKey,InsertAt,Length,MaxIndex,MinIndex,RemoveAt,Pop,Push
	Run, %HelpDocsUrl%/objects/Object.htm#%FuncName%
Else
	Run, %HelpDocsUrl%/commands/%FuncName%.htm
return

Statement:
Gui, 21:Submit, NoHide
SBShowTip(Trim(c_If%Statement%, "=0, "))
Statement := IfList%Statement%
If (InStr(Statement, "Window"))
	GuiControl, 21:Enable, Ident
If (!InStr(Statement, "Window"))
	GuiControl, 21:Disable, Ident
If (!InStr(Statement, "Window") && !InStr(Statement, "File"))
	GuiControl, 21:Disable, IfGet
Else
	GuiControl, 21:Enable, IfGet
If (InStr(Statement, "Image"))
	GuiControl, 21:Disable, TestVar
Else
	GuiControl, 21:Enable, TestVar
If (InStr(Statement, "String"))
{
	GuiControl, 21:, FormatTip, %c_Lang081%
	GuiControl, 21:, FormatTip2, %c_Lang056%
	GuiControl, 21:Enable, TestVar2
}
Else If (InStr(Statement, "Compare"))
{
	GuiControl, 21:, FormatTip, %c_Lang082%
	GuiControl, 21:, FormatTip2, %c_Lang056%
	GuiControl, 21:Enable, TestVar2
	GuiControl, 21:Enable, IfOper
}
Else If (InStr(Statement, "Window"))
{
	GuiControl, 21:, FormatTip, %Wcmd_All%
	GuiControl, 21:, FormatTip2
}
Else
{
	GuiControl, 21:, FormatTip
	GuiControl, 21:, FormatTip2
	GuiControl, 21:Disable, TestVar2
	GuiControl, 21:Disable, IfOper
}
If (Statement = If13)
{
	GuiControl, 21:Enable, IfMsgB
	GuiControl, 21:Disable, TestVar
}
Else
{
	GuiControl, 21:Disable, IfMsgB
}
If (Statement = If15)
{
	GuiControl, 21:Hide, CoOper
	GuiControl, 21:Hide, IfOper
	GuiControl, 21:Hide, TestVar2
	GuiControl, 21:Hide, VarTxt
	GuiControl, 21:Show, ExpTxt
	GuiControl, 21:Show, ExprLink1
}
Else If (Statement = If14)
{
	If IfOper in =,==,!=,>,<,>=,<=
	{
		GuiControl, 21:Hide, VarTxt
		GuiControl, 21:Show, ExprLink1
	}
	Else
	{
		GuiControl, 21:Hide, ExprLink1
		GuiControl, 21:Show, VarTxt
	}
	GuiControl, 21:Hide, ExpTxt
	GuiControl, 21:Show, CoOper
	GuiControl, 21:Show, IfOper
	GuiControl, 21:Show, TestVar2
}
Else
{
	GuiControl, 21:Hide, ExpTxt
	GuiControl, 21:Hide, ExprLink1
	GuiControl, 21:Show, CoOper
	GuiControl, 21:Show, IfOper
	GuiControl, 21:Show, VarTxt
	GuiControl, 21:Show, TestVar2
}
return

IfGet:
Gui, 21:Submit, NoHide
Statement := IfList%Statement%
If (InStr(Statement, "Window"))
{
	Label := "IfGet"
	GoSub, GetWin
	Label := ""
	GuiControl, 21:, TestVar, %FoundTitle%
	return
}
If (InStr(Statement, "File"))
{
	GoSub, Search
	GuiControl, 21:, TestVar, %File%
	return
}
return

EditMsg:
s_Caller := "Edit"
SendMsg:
Gui, 22:+owner1 -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
Gui, 22:Add, Groupbox, Section W450 H190
Gui, 22:Add, DDL, ys+15 xs+10 W150 vMsgType gMsgType, PostMessage||SendMessage
Gui, 22:Add, DDL, yp x+10 W270 vWinMsg gWinMsg, %WM_Msgs%
Gui, 22:Add, Text, -Wrap R1 xs+10 y+10 W120 vMsgNumT, %c_Lang102%:
Gui, 22:Add, Edit, W430 -Multi vMsgNum
Gui, 22:Add, Text, -Wrap R1 W430, wParam:
Gui, 22:Add, Edit, W430 -Multi vwParam
Gui, 22:Add, Text, -Wrap R1 W430, lParam:
Gui, 22:Add, Edit, W430 -Multi vlParam
Gui, 22:Add, Groupbox, Section xs y+15 W450 H130
Gui, 22:Add, Text, -Wrap R1 ys+15 xs+10, %c_Lang004%:
Gui, 22:Add, Edit, vDefCt W400
Gui, 22:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetCtrl gGetCtrl, ...
Gui, 22:Add, Text, -Wrap y+10 xs+10 W350 H20 vWinParsTip cGray, %Wcmd_All%
Gui, 22:Add, Button, yp-5 x+5 W75 vIdent gWinTitle, WinTitle
Gui, 22:Add, Edit, y+5 xs+10 W400 vTitle, A
Gui, 22:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetWin gGetWin, ...
Gui, 22:Add, Button, -Wrap Section Default xm W75 H23 gSendMsgOK, %c_Lang020%
Gui, 22:Add, Button, -Wrap ys W75 H23 gSendMsgCancel, %c_Lang021%
Gui, 22:Add, Button, -Wrap ys W75 H23 vSendMsgApply gSendMsgApply Disabled, %c_Lang131%
Gui, 22:Add, Text, x+10 yp-3 W190 H25 cGray, %c_Lang025%
Gui, 22:Add, StatusBar, gStatusBarHelp
Gui, 22:Default
SB_SetIcon(ResDllPath, IconsNames["help"])
If (s_Caller = "Edit")
{
	EscCom(true, Details, Target)
	Loop, Parse, Details, `,,%A_Space%
	{
		StringReplace, LoopField, A_LoopField, %_x%, `,, All
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
If (s_Caller = "Find")
	GuiControl, 22:ChooseString, MsgType, %GotoRes1%
GoSub, MsgType
Gui, 22:Show, , % cType19 " / " cType18
ChangeIcon(hIL_Icons, CmdWin, IconsNames["sendmsg"])
Tooltip
return

SendMsgApply:
SendMsgOK:
Gui, 22:+OwnDialogs
Gui, 22:Submit, NoHide
If (MsgNum = "")
{
	Gui, 22:Font, cRed
	GuiControl, 22:Font, MsgNumT
	GuiControl, 22:Focus, MsgNum
	return
}
EscCom(false, lParam, wParam, DefCt)
Details := MsgNum ", " wParam ", " lParam
If (A_ThisLabel != "SendMsgApply")
{
	Gui, 1:-Disabled
	Gui, 22:Destroy
}
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected"), LV_GetText(RowType, LV_GetNext(), 6)
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", "[Windows Message]", Details, TimesX, DelayX, MsgType, DefCt, Title)
Else If ((RowSelection = 0) || ((RowType = cType47) || RowType = cType48))
{
	LV_Add("Check", ListCount%A_List%+1, "[Windows Message]", Details, 1, DelayG, MsgType, DefCt, Title)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	GuiControl, chMacro:-g, InputList%A_List%
	RowNumber := 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, "[Windows Message]", Details, 1, DelayG, MsgType, DefCt, Title)
		LVManager[A_List].InsertAtGroup(RowNumber)
		RowNumber++
	}
	GuiControl, chMacro:+gInputList, InputList%A_List%
}
GoSub, RowCheck
GoSub, b_Start
If (A_ThisLabel = "SendMsgApply")
	Gui, 22:Default
Else
{
	s_Caller := ""
	GuiControl, Focus, InputList%A_List%
}
return

MsgType:
Gui, 22:Submit, NoHide
SBShowTip(MsgType)
return

WinMsg:
Gui, 22:Submit, NoHide
GuiControl, 22:, MsgNum, % %WinMsg%
return

SendMsgCancel:
22GuiClose:
22GuiEscape:
Gui, 1:-Disabled
Gui, 22:Destroy
s_Caller := ""
return

EditControl:
s_Caller := "Edit"
ControlCmd:
Gui, 23:+owner1 -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
Gui, 23:Add, Groupbox, Section W450 H220
Gui, 23:Add, Text, -Wrap R1 ys+15 xs+10 W120, %c_Lang055%:
Gui, 23:Add, DDL, W120 vControlCmd gCtlCmd, %CtrlCmdList%
Gui, 23:Add, Text, -Wrap R1 W120, %c_Lang035%:
Gui, 23:Add, DDL, W120 -Multi vCmd gCmd, %CtrlCmd%
Gui, 23:Add, Text, -Wrap R1 W80, %c_Lang056% / %w_Lang003%:
Gui, 23:Add, Edit, W430 -Multi Disabled vValue
Gui, 23:Add, Text, -Wrap R1 W180, %c_Lang057%:
Gui, 23:Add, Edit, W430 -Multi Disabled vVarName
Gui, 23:Add, Text, -Wrap R1 xs+10 y+5 W430 vCPosT
Gui, 23:Add, Groupbox, Section xs y+15 W450 H130
Gui, 23:Add, Text, -Wrap R1 ys+15 xs+10, %c_Lang004%:
Gui, 23:Add, Edit, vDefCt W400
Gui, 23:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetCtrl gGetCtrl, ...
Gui, 23:Add, Text, -Wrap y+10 xs+10 W350 H20 vWinParsTip cGray, %Wcmd_All%
Gui, 23:Add, Button, yp-5 x+5 W75 vIdent gWinTitle, WinTitle
Gui, 23:Add, Edit, xs+10 y+5 W400 vTitle, A
Gui, 23:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetWin gGetWin, ...
Gui, 23:Add, Text, -Wrap R1 Section ym+20 xm+130 W105 Right, %c_Lang058%
Gui, 23:Add, Text, -Wrap R1 yp x+5 W15 Right, X:
Gui, 23:Add, Edit, yp-3 x+5 vPosX W55 Disabled
Gui, 23:Add, Text, -Wrap R1 yp+3 x+15 W10, Y:
Gui, 23:Add, Edit, yp-3 x+5 vPosY W55 Disabled
Gui, 23:Add, Button, -Wrap yp-1 x+5 W30 H23 vGetCtrlP gCtrlGetP Disabled, ...
Gui, 23:Add, Text, -Wrap R1 xs W105 Right, %c_Lang059%
Gui, 23:Add, Text, -Wrap R1 yp x+5 W15 Right, W:
Gui, 23:Add, Edit, yp-3 x+5 vSizeX W55 Disabled
Gui, 23:Add, Text, -Wrap R1 yp+3 x+10 W15 Right, H:
Gui, 23:Add, Edit, yp-3 x+5 vSizeY W55 Disabled
Gui, 23:Add, Button, -Wrap Section Default xm W75 H23 gControlOK, %c_Lang020%
Gui, 23:Add, Button, -Wrap ys W75 H23 gControlCancel, %c_Lang021%
Gui, 23:Add, Button, -Wrap ys W75 H23 vControlApply gControlApply Disabled, %c_Lang131%
Gui, 23:Add, Text, x+10 yp-3 W190 H25 cGray, %c_Lang025%
Gui, 23:Add, StatusBar, gStatusBarHelp
Gui, 23:Default
SB_SetIcon(ResDllPath, IconsNames["help"])
If (s_Caller = "Edit")
{
	Details := StrReplace(Details, "``,", _x)
	EscCom(true, Details, Target)
	ControlCmd := Type
	GuiControl, 23:ChooseString, ControlCmd, %ControlCmd%
	Switch Type
	{
		Case cType24:
			Details := StrReplace(Details, _x, ",")
			GuiControl, 23:ChooseString, Cmd, % cmd := RegExReplace(Details, "(^\w*).*", "$1")
			GuiControl, 23:, Value, % RegExReplace(Details, "^\w*, ?(.*)", "$1")
			GoSub, Cmd
			SBShowTip("Control")
		Case cType10:
			GoSub, CtlCmd
			Details := StrReplace(Details, _x, ",")
			GuiControl, 23:, Value, %Details%
		Case cType23, cType27, cType28, cType31:
			Pars := GetPars(Details)
			For i, v in Pars
				Par%A_Index% := StrReplace(v, _x, ",")
			GoSub, CtlCmd
			GuiControl, 23:, VarName, %Par1%
			GuiControl, 23:ChooseString, Cmd, %Par2%
			GuiControl, 23:, Value, %Par3%
			GoSub, Cmd
		Case cType26:
			GoSub, CtlCmd
			Pars := GetPars(Details)
			For i, v in Pars
				Par%A_Index% := StrReplace(v, _x, ",")
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
Else If (s_Caller = "Find")
{
	If (InStr(CtrlCmd, GotoRes1))
	{
		GoSub, CtlCmd
		GuiControl, 23:ChooseString, Cmd, %GotoRes1%
		GoSub, Cmd
	}
	Else If (InStr(CtrlGetCmd, GotoRes1))
	{
		GuiControl, 23:ChooseString, ControlCmd, ControlGet
		GoSub, CtlCmd
		GuiControl, 23:ChooseString, Cmd, %GotoRes1%
		GoSub, Cmd
	}
	Else
	{
		GuiControl, 23:ChooseString, ControlCmd, %GotoRes1%
		GoSub, CtlCmd
	}
}
Else
	SBShowTip("Control")
Gui, 23:Show, , %c_Lang004%
ChangeIcon(hIL_Icons, CmdWin, IconsNames["control"])
Tooltip
return

ControlApply:
ControlOK:
Gui, 23:+OwnDialogs
Gui, 23:Submit, NoHide
GuiControlGet, VState, 23:Enabled, Value
If (VState = 0)
	Value := ""
GuiControlGet, VState, 23:Enabled, VarName
EscCom(false, Value)
If (VState = 0)
	VarName := ""
If (ControlCmd = cType24)
	Details := Cmd ", " Value
If (ControlCmd = cType25)
	Details := ""
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
		Tooltip, %c_Lang127%, 25, 185
		return
	}
	Try
		z_Check := VarSetCapacity(%VarName%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%`n`n%VarName%
		return
	}
	If (ControlCmd = cType28)
		Details := VarName ", " Cmd ", " Value
	Else
		Details := VarName
}
EscCom(false, DefCt)
If (A_ThisLabel != "ControlApply")
{
	Gui, 1:-Disabled
	Gui, 23:Destroy
}
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected"), LV_GetText(RowType, LV_GetNext(), 6)
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", "[Control]", Details, TimesX, DelayX, ControlCmd, DefCt, Title)
Else If ((RowSelection = 0) || ((RowType = cType47) || RowType = cType48))
{
	LV_Add("Check", ListCount%A_List%+1, "[Control]", Details, 1, DelayG, ControlCmd, DefCt, Title)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	GuiControl, chMacro:-g, InputList%A_List%
	RowNumber := 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, "[Control]", Details, 1, DelayG, ControlCmd, DefCt, Title)
		LVManager[A_List].InsertAtGroup(RowNumber)
		RowNumber++
	}
	GuiControl, chMacro:+gInputList, InputList%A_List%
}
GoSub, RowCheck
GoSub, b_Start
If (A_ThisLabel = "ControlApply")
	Gui, 23:Default
Else
{
	s_Caller := ""
	GuiControl, Focus, InputList%A_List%
}
return

ControlCancel:
23GuiClose:
23GuiEscape:
Gui, 1:-Disabled
Gui, 23:Destroy
s_Caller := ""
return

CtlCmd:
Gui, 23:Submit, NoHide
SBShowTip(ControlCmd)
If ((ControlCmd != cType24) && (ControlCmd != cType28))
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
Gui, 23:Submit, NoHide
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

EditEmail:
s_Caller := "Edit"
Email:
User_Accounts := UserMailAccounts.Get(true), MailList := ""
For _each, _Section in User_Accounts
	MailList .= _Section.email "|"
Gui, 1:Submit, NoHide
Gui, 39:+owner1 -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
Gui, 39:Add, Custom, ClassToolbarWindow32 hwndhTbText gTbText H25 0x0800 0x0100 0x0040 0x0008 0x0004
Gui, 39:Add, Edit, Section xm ym+25 vTextEdit gTextEdit W525 R16
Gui, 39:Add, Checkbox, -Wrap R1 xm y+5 W100 vIsHtml, %c_Lang234%
; From/To
Gui, 39:Add, GroupBox, Section W525 H160
Gui, 39:Add, Text, -Wrap R1 xs+10 ys+20 W80 Right vToT, %c_Lang230%:
Gui, 39:Add, Edit, x+5 yp W410 R1 vTo
Gui, 39:Add, Text, -Wrap R1 xs+10 y+5 W80 Right, %c_Lang231%:
Gui, 39:Add, Edit, x+5 yp W410 R1 vCc
Gui, 39:Add, Text, -Wrap R1 xs+10 y+5 W80 Right, %c_Lang232%:
Gui, 39:Add, Edit, x+5 yp W410 R1 vBcc
Gui, 39:Add, Text, -Wrap R1 xs+10 y+5 W80 Right vFromT, %c_Lang226%:
Gui, 39:Add, DDL, x+5 yp W200 vFrom, %MailList%
GuiControl, 39:Choose, From, 1
Gui, 39:Add, Link, -Wrap yp+5 x+10 W200 R1 vAccounts gAccounts, <a>%t_Lang191%</a>
Gui, 39:Add, Text, -Wrap R1 xs+10 y+10 W80 Right, %c_Lang228%:
Gui, 39:Add, Edit, x+5 yp W410 R1 vSubject
; Attachments
Gui, 39:Add, GroupBox, Section xm y+20 W325 H120, %c_Lang245% (%c_Lang233%)
Gui, 39:Add, ListView, xs+10 ys+20 W275 R5 vAttachments -ReadOnly -Hdr Grid LV0x4000, FilePath
Gui, 39:Add, Button, -Wrap x+5 ys+20 W25 H23 vAddAtt gAddAtt, ...
Gui, 39:Add, Button, -Wrap xp y+10 W25 H23 gAddLine, +
Gui, 39:Add, Button, -Wrap xp y+10 W25 H23 gDelAtt, -
; Repeat
Gui, 39:Add, GroupBox, Section ys x+20 W190 H120, %w_Lang003%:
Gui, 39:Add, Text, -Wrap R1 ys+20 xs+10 W80 Right, %w_Lang015%:
Gui, 39:Add, Edit, yp x+10 W80 R1 vEdRept
Gui, 39:Add, UpDown, vTimesX 0x80 Range1-999999999, 1
Gui, 39:Add, Text, -Wrap R1 y+5 xs+10 W80 Right, %c_Lang017%:
Gui, 39:Add, Edit, yp x+10 W80 vDelayC
Gui, 39:Add, UpDown, vDelayX 0x80 Range0-999999999, %DelayG%
Gui, 39:Add, Radio, -Wrap Checked W80 vMsc R1, %c_Lang018%
Gui, 39:Add, Radio, -Wrap W80 vSec R1, %c_Lang019%
Gui, 39:Add, Button, -Wrap Section Default xm W75 H23 gEmailOK, %c_Lang020%
Gui, 39:Add, Button, -Wrap ys W75 H23 gEmailCancel, %c_Lang021%
Gui, 39:Add, Button, -Wrap ys W75 H23 vEmailApply gEmailApply Disabled, %c_Lang131%
Gui, 39:Add, Text, x+10 yp-3 W190 H25 cGray, %c_Lang025%
Gui, 39:Add, StatusBar, gStatusBarHelp
Gui, 39:Default
SB_SetParts(420, 70)
SB_SetText("length: " 0, 2)
SB_SetText("lines: " 0, 3)
SB_SetIcon(ResDllPath, IconsNames["help"])
If (s_Caller = "Edit")
{
	Subject := SubStr(Details, 1, RegExMatch(Details, "=\d:") - 1)
	Details := SubStr(Details, RegExMatch(Details, "=\d:") + 1)
	StringReplace, Details, Details, ``n, `n, All
	StringSplit, Tar, Target, /
	GuiControl, 39:, IsHtml, % SubStr(Details, 1, 1)
	GuiControl, 39:, TextEdit, % SubStr(Details, 3)
	GuiControl, 39:, To, % SubStr(Tar1, 4)
	GuiControl, 39:, Cc, % SubStr(Tar2, 4)
	GuiControl, 39:, Bcc, % SubStr(Tar3, 5)
	GuiControl, 39:ChooseString, From, %Action%
	GuiControl, 39:, Subject, %Subject%
	GuiControl, 39:, TimesX, %TimesX%
	GuiControl, 39:, EdRept, %TimesX%
	GuiControl, 39:, DelayX, %DelayX%
	GuiControl, 39:, DelayC, %DelayX%
	Loop, Parse, Window, `;,
		If (A_LoopField != "")
			LV_Add("", A_LoopField)
}
SBShowTip("CDO")
Gui, 39:Font, s%MacroFontSize%
GuiControl, 39:Font, TextEdit
Gui, 39:Show,, %c_Lang235%
ChangeIcon(hIL_Icons, CmdWin, IconsNames["email"])
TB_Define(TbText, hTbText, hIL_Icons, FixedBar.Text, FixedBar.TextOpt)
TBHwndAll[9] := TbText
GuiControl, 39:Focus, TextEdit
Input
Tooltip
return

EmailApply:
EmailOK:
Gui, 39:+OwnDialogs
Gui, 39:Submit, NoHide
If (To = "")
{
	Gui, 39:Font, cRed
	GuiControl, 39:Font, ToT
	GuiControl, 39:Focus, To
	return
}
If (From = "")
{
	Gui, 39:Font, cRed
	GuiControl, 39:Font, FromT
	GuiControl, 39:Focus, Accounts
	return
}
StringReplace, TextEdit, TextEdit, `n, ``n, All
Action := From, Details := Subject "=" IsHtml ":" TextEdit, Type := cType52
Target := "To=" To "/CC=" Cc "/BCC=" Bcc
DelayX := InStr(DelayC, "%") ? DelayC : DelayX
TimesX := InStr(EdRept, "%") ? EdRept : TimesX
Attach := ""
Loop, % LV_GetCount()
{
	LV_GetText(RowText, A_Index)
	If (RowText != "")
		Attach .= RowText ";"
}
Attach := RTrim(Attach, "; ")
If (A_ThisLabel != "EmailApply")
{
	Gui, 1:-Disabled
	Gui, 39:Destroy
}
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected"), LV_GetText(RowType, LV_GetNext(), 6)
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", Action, Details, TimesX, DelayX, Type, Target, Attach)
Else If ((RowSelection = 0) || ((RowType = cType47) || RowType = cType48))
{
	LV_Add("Check", ListCount%A_List%+1, Action, Details, TimesX, DelayX, Type, Target, Attach)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	LV_Insert(LV_GetNext(), "Check",, Action, Details, TimesX, DelayX, Type, Target, Attach)
	LVManager[A_List].InsertAtGroup(LV_GetNext())
}
GoSub, RowCheck
GoSub, b_Start
If (A_ThisLabel = "EmailApply")
	Gui, 39:Default
Else
{
	s_Caller := ""
	GuiControl, Focus, InputList%A_List%
}
return

39GuiEscape:
39GuiClose:
EmailCancel:
Gui, 1:-Disabled
Gui, 39:Destroy
s_Caller := ""
return

AddAtt:
Gui, +OwnDialogs
FileSelectFile, AttFile, M3,, %AppName%
FreeMemory()
AddAttOn:
If (!AttFile)
	return
Loop, Parse, AttFile, `n, ˋr
{
	If (A_Index = 1)
		FilePath := RTrim(A_LoopField, "\") "\"
	Else
	{
		File := FilePath . A_LoopField
		Loop, % LV_GetCount()
		{
			LV_GetText(RowText, A_Index)
			If (File = RowText)
				continue 2
		}
		LV_Add("", File)
	}
}
return

AddLine:
LV_Add()
LV_Modify(0, "-Select")
LV_Modify(LV_GetCount(), "Select Vis")
return

DelAtt:
LV_Rows.Delete()
return

Accounts:
; Email accounts
Gui, 9:+owner39 +ToolWindow
Gui, 39:+Disabled
Gui, 9:Add, GroupBox, Section ym xm W400 H395, %t_Lang191%:
Gui, 9:Add, Text, -Wrap R1 ys+20 xs+10 W80 vAccEmailT, %c_Lang227%*:
Gui, 9:Add, Edit, yp x+5 W295 vAccEmail
Gui, 9:Add, Text, -Wrap R1 y+5 xs+10 W80, %t_Lang194%*:
Gui, 9:Add, Edit, yp x+5 W150 vAccServer
Gui, 9:Add, Text, -Wrap R1 yp x+10 W80, %t_Lang195%*:
Gui, 9:Add, Edit, yp x+5 W50 vAccPort, 25
Gui, 9:Add, Text, -Wrap R1 y+5 xs+10 W80, %t_Lang197%:
Gui, 9:Add, Edit, yp x+5 W110 vAccUser
Gui, 9:Add, Text, -Wrap R1 yp x+10 W80, %t_Lang198%:
Gui, 9:Add, Edit, yp x+5 W90 vAccPass
Gui, 9:Add, Checkbox, -Wrap R1 Checked y+5 xs+10 W110 vAccAuth, %t_Lang196%
Gui, 9:Add, Checkbox, -Wrap R1 yp x+10 W50 vAccSsl, %t_Lang199%
Gui, 9:Add, Text, -Wrap yp x+10 W145, %c_Lang177% (%c_Lang019%):
Gui, 9:Add, Edit, Limit Number yp x+5 W50 R1
Gui, 9:Add, UpDown, yp x+0 vAccTimeout 0x80 Range0-999, 30
Gui, 9:Add, Button, -Wrap y+15 xs+10 W75 H23 gAccAdd, %c_Lang123%
Gui, 9:Add, Button, -Wrap yp x+10 W75 H23 gAccUpdate, %t_Lang192%
Gui, 9:Add, Button, -Wrap yp x+10 W75 H23 gAccDel, %c_Lang024%
Gui, 9:Add, Link, -Wrap yp+2 x+10 W130 R1 gEmailTest, <a>%t_Lang201%</a>
Gui, 9:Add, Text, -Wrap R1 y+12 xs+10 W380 cGray, %t_Lang193%
Gui, 9:Add, ListView, y+8 xs+10 W380 R10 vAccList gAccSub LV0x4000, %c_Lang227%|%t_Lang194%|%t_Lang195%|%t_Lang197%|%t_Lang198%|%t_Lang196%|%t_Lang199%|%c_Lang177%|%t_Lang200%
Gui, 9:Add, Button, -Wrap Default Section xm W75 H23 gAccConfigOK, %c_Lang020%
Gui, 9:Add, Button, -Wrap ys W75 H23 gAccConfigCancel, %c_Lang021%
Gui, 9:Default
LoadMailAccounts()
LV_ModifyCol(1, 80)
Gui, 9:Show,, %t_Lang017%
Tooltip
return

AccConfigOK:
Gui, 9:Submit, NoHide
Gui, 9:ListView, AccList
UpdateMailAccounts()
User_Accounts := UserMailAccounts.Get(true), MailList := ""
For _each, _Section in User_Accounts
	MailList .= _Section.email "|"
GuiControl, 39:, From, |%MailList%
GuiControl, 39:Choose, From, 1
Gui, 39:-Disabled
Gui, 9:Destroy
Gui, 39:Default
return

9GuiClose:
9GuiEscape:
AccConfigCancel:
Gui, 39:-Disabled
Gui, 9:Destroy
return

EditDownload:
EditZip:
s_Caller := "Edit"
ZipFiles:
DownloadFiles:
Gui, 40:+owner1 -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
Gui, 40:Add, Tab2, W450 H0 vTabControl AltSubmit, CmdTab1|CmdTab2
; Download
Gui, 40:Add, GroupBox, Section xm ym W450 H235
Gui, 40:Add, Text, -Wrap R1 ys+20 xs+10 W180 vDlFolderT, %c_Lang253%:
Gui, 40:Add, Edit, y+5 xs+10 W400 R1 vDlFolderVar
Gui, 40:Add, Button, -Wrap yp-1 x+0 W30 H23 vDlFolder gDlSearch, ...
Gui, 40:Add, Text, -Wrap R1 y+10 xs+10 W180 vDlLinksT, %c_Lang252%:
Gui, 40:Add, Edit, R9 y+5 xs+10 W430 vDlLinks
Gui, 40:Add, Text, -Wrap R1 y+3 xs+10 W400 cGray, %c_Lang255%
Gui, 40:Tab, 2
; Zip / Unzip
Gui, 40:Add, GroupBox, Section xm ym W450 H235
Gui, 40:Add, Radio, Checked -Wrap R1 ys+20 xs+10 W180 vZip gZipMode, %c_Lang250%
Gui, 40:Add, Radio, -Wrap R1 yp x+10 W180 vUnzip gZipMode, %c_Lang251%
Gui, 40:Add, Text, -Wrap R1 y+10 xs+10 W180 vZipFileT, %c_Lang254%:
Gui, 40:Add, Edit, y+5 xs+10 W400 R1 vZipFileVar
Gui, 40:Add, Button, -Wrap yp-1 x+0 W30 H23 vZipFile gDlSearch, ...
Gui, 40:Add, Text, -Wrap R1 y+10 xs+10 W180 vZipFilesT, %c_Lang145%:
Gui, 40:Add, Edit, R5 y+5 xs+10 W400 vZipFilesVar
Gui, 40:Add, Button, -Wrap yp-1 x+0 W30 H23 vZipFiles gDlSearch, ...
Gui, 40:Add, Text, -Wrap R1 y+55 xs+10 W400 cGray, %c_Lang255%
Gui, 40:Add, Checkbox, -Wrap R1 y+10 xs+10 W400 vSeparate, %c_Lang248%
Gui, 40:Tab
Gui, 40:Add, Button, -Wrap Section xm Default W75 H23 gDownloadOK, %c_Lang020%
Gui, 40:Add, Button, -Wrap ys W75 H23 gDownloadCancel, %c_Lang021%
Gui, 40:Add, Button, -Wrap ys W75 H23 gDownloadApply Disabled, %c_Lang131%
Gui, 40:Add, Text, x+10 yp-3 W190 H25 cGray, %c_Lang025%
Gui, 40:Add, StatusBar, gStatusBarHelp
Gui, 40:Default
LV_ModifyCol(1, 185)
LV_ModifyCol(2, 185)
SB_SetIcon(ResDllPath, IconsNames["help"])
If (s_Caller = "Edit")
{
	StringReplace, Details, Details, ``n, `n, All
	If (A_ThisLabel = "EditDownload")
	{
		GuiControl, 40:, DlFolderVar, %Target%
		GuiControl, 40:, DlLinks, %Details%
	}
	Else
	{
		If (Type = cType55)
			GuiControl, 40:, Unzip, 1
		GoSub, ZipMode
		GuiControl, 40:, ZipFileVar, %Target%
		GuiControl, 40:, ZipFilesVar, %Details%
		If (Window = "Separate")
			GuiControl, 40:, Separate, 1
	}
}
If (InStr(A_ThisLabel, "Download"))
{
	GuiTitle := c_Lang236
	SBShowTip("WinHttpDownloadToFile")
}
Else
{
	GuiControl, 40:Choose, TabControl, 2
	GuiTitle := c_Lang237
	SBShowTip("Zip")
}
Gui, 40:Show,, %GuiTitle%
ChangeIcon(hIL_Icons, CmdWin, InStr(A_ThisLabel, "Download") ? IconsNames["download"] : IconsNames["zip"])
Input
Tooltip
return

DownloadApply:
DownloadOK:
Gui, 40:Submit, NoHide
If (TabControl = 1)
{
	If ((DlFolderVar = "") || (DlLinks = ""))
	{
		Gui, 40:Font, cRed
		GuiControl, 40:Font, DlFolderT
		GuiControl, 40:Font, DlLinksT
		return
	}
	StringReplace, DlLinks, DlLinks, `n, ``n, All
	Type := cType53, Action := "[Download]", Details := DlLinks, Target := DlFolderVar, Window := ""
	If (A_ThisLabel != "DownloadApply")
	{
		Gui, 1:-Disabled
		Gui, 40:Destroy
	}
}
Else
{
	If ((ZipFileVar = "") || (ZipFilesVar = ""))
	{
		Gui, 40:Font, cRed
		GuiControl, 40:Font, ZipFileT
		GuiControl, 40:Font, ZipFilesT
		return
	}
	StringReplace, ZipFilesVar, ZipFilesVar, `n, ``n, All
	Type := Zip ? cType54 : cType55, Action := "[" Type "]", Details := ZipFilesVar, Target := ZipFileVar, Window := Separate ? "Separate" : ""
	If (A_ThisLabel != "ZipApply")
	{
		Gui, 1:-Disabled
		Gui, 40:Destroy
	}
}
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected"), LV_GetText(RowType, LV_GetNext(), 6)
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", Action, Details, TimesX, DelayX, Type, Target, Window)
Else If ((RowSelection = 0) || ((RowType = cType47) || RowType = cType48))
{
	LV_Add("Check", ListCount%A_List%+1, Action, Details, 1, DelayG, Type, Target, Window)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	GuiControl, chMacro:-g, InputList%A_List%
	RowNumber := 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, Action, Details, 1, DelayG, Type, Target, Window)
		LVManager[A_List].InsertAtGroup(RowNumber)
		RowNumber++
	}
	GuiControl, chMacro:+gInputList, InputList%A_List%
}
GoSub, RowCheck
GoSub, b_Start
If (A_ThisLabel = "DownloadApply")
	Gui, 40:Default
Else
{
	s_Caller := ""
	GuiControl, Focus, InputList%A_List%
}
return

DownloadCancel:
40GuiClose:
40GuiEscape:
Gui, 1:-Disabled
Gui, 40:Destroy
s_Caller := ""
return

40GuiDropFiles:
Gui, 40:Submit, NoHide
GuiControl, 40:, ZipFilesVar, %ZipFilesVar%%A_GuiEvent%
return

ZipMode:
Gui, 40:Submit, NoHide
If (Unzip)
{
	GuiControl, 40:, ZipFileT, %c_Lang253%:
	GuiControl, 40:, Separate, %c_Lang249%
}
Else
{
	GuiControl, 40:, ZipFileT, %c_Lang254%:
	GuiControl, 40:, Separate, %c_Lang248%
}
GuiControl, 40:, ZipFileVar
return

DlSearch:
Gui, 40:+OwnDialogs
Gui, 40:Submit, NoHide
If ((A_GuiControl = "DlFolder") || ((A_GuiControl = "ZipFile") && (Unzip)))
{
	FileSelectFolder, Folder, *%A_ScriptDir%,, %AppName%
	FreeMemory()
	If (Folder = "")
		return
	GuiControl, 40:, %A_GuiControl%Var, %Folder%
}
Else
{
	Opt := (A_GuiControl = "ZipFiles") ? "M2" : 2, Filt := ((A_GuiControl = "ZipFiles") && (Unzip)) ? "*.zip" : ""
	FileSelectFile, File, %Opt%,, %AppName%, %Filt%
	If (A_GuiControl = "ZipFile")
	{
		SplitPath, File,,, ext
		If (ext != "zip")
			File .= ".zip"
	}
	Else
	{
		Files := ""
		Loop, Parse, File, `n
		{
			If (A_Index = 1)
				FilePath := RTrim(A_LoopField, "\") "\"
			Else
				Files .= FilePath . A_LoopField "`n"
		}
		File := ZipFilesVar . Files
	}
	FreeMemory()
	If (File = "")
		return
	GuiControl, 40:, %A_GuiControl%Var, %File%
}
return

EditComInt:
EditIECom:
s_Caller := "Edit"
ComInt:
IECom:
IEWindows := ListIEWindows()
Gui, 24:+owner1 -MinimizeBox +E0x00000400 +hwndCmdWin
Gui, 1:+Disabled
Gui, 24:Add, Tab2, W410 H0 vTabControl gTabControl AltSubmit, CmdTab1|CmdTab2|CmdTab3
Gui, 24:Add, GroupBox, Section xm ym W450 H265
Gui, 24:Add, Combobox, ys+15 xs+10 W160 vIECmd gIECmd, %IECmdList%
Gui, 24:Add, Radio, Section -Wrap Checked ys+20 x+20 W90 vSet gIECmd R1, %c_Lang093%
Gui, 24:Add, Radio, -Wrap x+0 W90 vGet gIECmd Disabled R1, %c_Lang094%
Gui, 24:Add, Radio, -Wrap Group Checked xs W90 vMethod gIECmd Disabled R1, %c_Lang095%
Gui, 24:Add, Radio, -Wrap x+0 W90 vProperty gIECmd Disabled R1, %c_Lang096%
Gui, 24:Add, Text, -Wrap R1 Section ys+35 xm+10 W250 vValueT, %c_Lang056%:
Gui, 24:Add, Edit, yp+20 xs W430 R5 vValue
Gui, 24:Add, Text, -Wrap R1 y+10 W55, %c_Lang005%:
Gui, 24:Add, DDL, yp-2 xp+60 W340 vIEWindows AltSubmit, %IEWindows%
Gui, 24:Add, Button, -Wrap yp-1 x+5 W25 H23 hwndRefreshIEW vRefreshIEW gRefreshIEW
	ILButton(RefreshIEW, ResDllPath ":" 90)
Gui, 24:Add, Button, -Wrap Section Default ym+270 xm W75 H23 gIEComOK, %c_Lang020%
Gui, 24:Add, Button, -Wrap ys xs+170 W75 H23 vIEComApply gIEComApply Disabled, %c_Lang131%
Gui, 24:Add, Text, x+10 yp-3 W190 H25 cGray, %c_Lang025%
Gui, 24:Tab, 2
; COM Interface
Gui, 24:Add, GroupBox, Section xm ym W450 H75
Gui, 24:Add, Checkbox, -Wrap R1 ys+15 xs+10 W400 vCreateComObj gCreateComObj, %c_Lang074%
Gui, 24:Add, Text, -Wrap R1 y+10 xs+10 W55 Right vComHwndT, %c_Lang100%:
Gui, 24:Add, Edit, yp x+10 W80 vComHwnd Disabled, %ComHwnd%
Gui, 24:Add, Text, -Wrap R1 yp x+10 W40 Right vComCLSIDT, %c_Lang098%:
Gui, 24:Add, Combobox, yp x+10 W150 vComCLSID gClsidCmd Disabled, %CLSList%
GuiControl, 24:ChooseString, ComCLSID, %ComCLSID%
Gui, 24:Add, Button, -Wrap yp-1 x+0 W75 H23 vActiveObj gActiveObj Disabled, %c_Lang099%
Gui, 24:Add, GroupBox, Section xm y+20 W450 H185
Gui, 24:Add, Text, -Wrap R1 ys+15 xs+10 W300 vComScT, %c_Lang087% / %c_Lang101%:
Gui, 24:Add, Edit, y+5 xs+10 W430 R5 vComSc
Gui, 24:Add, Button, -Wrap y+1 xs+416 W25 H23 hwndExpView vExpView gExpView
	ILButton(ExpView, ResDllPath ":" 17)
Gui, 24:Add, Button, -Wrap Section ym+270 xm W75 H23 vComOK gComOK, %c_Lang020%
Gui, 24:Add, Button, -Wrap ys xs+170 W75 H23 vComApply gComApply Disabled, %c_Lang131%
Gui, 24:Add, Link, -Wrap x+10 yp-3 W190 R1 vExprLink2 gExprLink, <a>%c_Lang091%</a>
Gui, 24:Tab
Gui, 24:Add, Text, -Wrap R1 Section ym+192 xm+12 vPgTxt, %c_Lang092%:
Gui, 24:Add, DDL, W80 vIdent, Name||ID|ClassName|TagName|Links
Gui, 24:Add, Edit, yp x+0 vDefEl W235
Gui, 24:Add, Edit, yp x+0 vDefElInd W85
Gui, 24:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetEl gGetEl, ...
Gui, 24:Add, Checkbox, -Wrap Checked y+10 xs W300 vLoadWait R1 Disabled, %c_Lang097%
Gui, 24:Add, Button, -Wrap Section ym+270 xs+72 W75 H23 gIEComCancel, %c_Lang021%
Gui, 24:Add, StatusBar, gStatusBarHelp
Gui, 24:Default
SB_SetIcon(ResDllPath, IconsNames["help"])
If (s_Caller = "Edit")
{
	If ((Type = cType34) || (Type = cType43))
	{
		Details := GetRealLineFeeds(Details)
		TabControl := 2, GuiTitle := c_Lang013, SBShowTip("ComObjCreate")
		GuiControl, 24:Choose, TabControl, 2
		If (Type = cType34)
		{
			GuiControl, 24:, CreateComObj, 1
			Gosub, CreateComObj
			If (Target = "")
				GuiControl, 24:Choose, ComCLSID, 0
			Else If (InStr(CLSList, Target))
				GuiControl, 24:ChooseString, ComCLSID, %Target%
			Else
				GuiControl, 24:, ComCLSID, %ComCLSID%||
			GuiControl, 24:, ComHwnd, %Action%
			GoSub, TabControl
		}
		Else
			SB_SetText(Cmd_Tips["Expression"])
		GuiControl, 24:, ComSc, %Details%
	}
	Else
	{
		StringReplace, Details, Details, ``n, `n, All
		Meth := RegExReplace(Action, ":.*"), IECmd := RegExReplace(Action, "^.*:(.*):.*", "$1")
		Ident := RegExReplace(Action, "^.*:"), Act := RegExReplace(Type, ".*_")
		DefEl := RegExReplace(Target, ":.*"), DefElInd := RegExReplace(Target, "^.*:")
		GuiControl, 24:, %Act%, 1
		GuiControl, 24:, %Meth%, 1
		If (InStr(IECmdList, IECmd))
			GuiControl, 24:ChooseString, IECmd, %IECmd%
		Else
			GuiControl, 24:, IECmd, %IECmd%||
		GuiControl, 24:ChooseString, Ident, %Ident%
		GuiControl, 24:, DefEl, %DefEl%
		GuiControl, 24:, DefElInd, %DefElInd%
		GuiControl, 24:, Value, %Details%
		GoSub, IECmd
		GuiTitle := c_Lang012
	}
	If (Window = "LoadWait")
		GuiControl, 24:, LoadWait, 1
	Else
		GuiControl, 24:, LoadWait, 0
	GuiControl, 24:Enable, IEComApply
	GuiControl, 24:Enable, ComApply
	GuiControl, 24:Enable, LoadWait
}
If (A_ThisLabel = "IECom")
{
	GuiTitle := c_Lang012
	If (s_Caller = "Find")
		GuiControl, 24:ChooseString, IECmd, %GotoRes1%
	GoSub, IECmd
	GuiControl, 24:Enable, LoadWait
	SB_SetText(IE_Tips["Navigate"])
}
If (A_ThisLabel = "ComInt")
{
	GuiControl, 24:Choose, TabControl, 2
	GuiControl, 24:+Default, ComOK
	If ((s_Caller = "Find") && (InStr(CLSList, GotoRes1)))
	{
		GuiControl, 24:, CreateComObj, 1
		GuiControl, 24:ChooseString, ComCLSID, %GotoRes1%
	}
	Gosub, CreateComObj
	GuiControl, 24:, LoadWait, 0
	GuiTitle := c_Lang013
	SB_SetText(Cmd_Tips["Expression"])
}
GuiControl, 24:Choose, IEWindows, %SelIEWin%
Gui, 24:Show, , %GuiTitle%
ChangeIcon(hIL_Icons, CmdWin, InStr(A_ThisLabel, "ComInt") ? IconsNames["com"] : IconsNames["ie"])
Tooltip
return

IEComCancel:
24GuiClose:
24GuiEscape:
Gui, 1:-Disabled
Gui, 24:Destroy
s_Caller := ""
return

IEComApply:
IEComOK:
Gui, 24:+OwnDialogs
Gui, 24:Submit, NoHide
GuiControlGet, VState, 24:Enabled, Value
If (VState = 0)
	Value := ""
GuiControlGet, VState, 24:Enabled, DefEl
If ((VState = 0) || (DefEl = ""))
	DefEl := "", Ident := ""
If (Get)
{
	If (Value = "")
	{
		Tooltip, %c_Lang127%, 25, 145
		return
	}
	If (RegExMatch(Value, "^(\w+)(\[\S+\]|\.\w+)+", lMatch))
	{
		Try
			z_Check := VarSetCapacity(%lMatch1%)
		Catch
		{
			MsgBox, 16, %d_Lang007%, %d_Lang041%`n`n%lMatch1%
			return
		}
	}
	Else
	{
		Try
			z_Check := VarSetCapacity(%Value%)
		Catch
		{
			MsgBox, 16, %d_Lang007%, %d_Lang041%`n`n%Value%
			return
		}
	}
	Type := cType33
}
Else
	Type := cType32
If (Value != "")
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
If (LoadWait)
	Load := "LoadWait"
Else
	Load := ""
ControlGet, SelIEWinName, Choice,, ComboBox2, ahk_id %CmdWin%
SelIEWin := IEWindows
If (SelIEWinName = "[blank]")
	ie := ""
Else
	ie := WBGet(RegExReplace(SelIEWinName, "§", "|"))
If (A_ThisLabel != "IEComApply")
{
	Gui, 1:-Disabled
	Gui, 24:Destroy
}
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected"), LV_GetText(RowType, LV_GetNext(), 6)
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", Action, Details, TimesX, DelayX, Type, Target, Load)
Else If ((RowSelection = 0) || ((RowType = cType47) || RowType = cType48))
{
	LV_Add("Check", ListCount%A_List%+1, Action , Details, 1, DelayG, Type, Target, Load)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	GuiControl, chMacro:-g, InputList%A_List%
	RowNumber := 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, Action , Details, 1, DelayG, Type, Target, Load)
		LVManager[A_List].InsertAtGroup(RowNumber)
		RowNumber++
	}
	GuiControl, chMacro:+gInputList, InputList%A_List%
}
GoSub, RowCheck
GoSub, b_Start
If (A_ThisLabel = "IEComApply")
	Gui, 24:Default
Else
{
	s_Caller := ""
	GuiControl, chMacro:Focus, InputList%A_List%
}
return

ComApply:
ComOK:
Gui, 24:+OwnDialogs
Gui, 24:Submit, NoHide
StringReplace, ComSc, ComSc, `n, ``n, All
If (CreateComObj)
{
	If (ComHwnd = "")
	{
		Gui, 24:Font, cRed
		GuiControl, 24:Font, ComHwndT
		return
	}
	Try
		z_Check := VarSetCapacity(%ComHwnd%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%`n`n%ComHwnd%
		return
	}
	Action := ComHwnd, Type := cType34, Target := ComCLSID
}
Else
	Action := "[Expression]", Type := cType43, Target := ""
If (LoadWait)
	Load := "LoadWait"
Else
	Load := ""
If (A_ThisLabel != "ComApply")
{
	Gui, 1:-Disabled
	Gui, 24:Destroy
}
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected"), LV_GetText(RowType, LV_GetNext(), 6)
If (s_Caller = "Edit")
	LV_Modify(RowNumber, "Col2", Action, ComSc, TimesX, DelayX, Type, Target, Load)
Else If ((RowSelection = 0) || ((RowType = cType47) || RowType = cType48))
{
	LV_Add("Check", ListCount%A_List%+1, Action, ComSc, 1, DelayG, Type, Target, Load)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	GuiControl, chMacro:-g, InputList%A_List%
	RowNumber := 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, Action, ComSc, 1, DelayG, Type, Target, Load)
		LVManager[A_List].InsertAtGroup(RowNumber)
		RowNumber++
	}
	GuiControl, chMacro:+gInputList, InputList%A_List%
}
GoSub, RowCheck
GoSub, b_Start
If (A_ThisLabel = "ComApply")
	Gui, 24:Default
Else
{
	s_Caller := ""
	GuiControl, Focus, InputList%A_List%
}
return

CreateComObj:
Gui, 24:Submit, NoHide
GuiControl, 24:Enable%CreateComObj%, ComHwnd
GuiControl, 24:Enable%CreateComObj%, ComCLSID
GuiControl, 24:Enable%CreateComObj%, ActiveObj
SB_SetText(CreateComObj ? Com_Tips[ComCLSID] : Cmd_Tips["Expression"])
Gosub, TabControl
return

ClsidCmd:
CbAutoComplete()
Gosub, TabControl
return

IECmd:
If (A_GuiControl = "IECmd")
	CbAutoComplete()
Gui, 24:Submit, NoHide
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
Gui, 24:Submit, NoHide
If (Set)
	GuiControl, 24:, ValueT, %c_Lang056%:
Else If (Get)
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
	SB_SetText(IE_Tips[IECmd])
Catch
	SB_SetText("")
return

ActiveObj:
Gui, 24:Submit, NoHide
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
	MsgBox, 16, %d_Lang007%, %d_Lang041%`n`n%ComHwnd%
	return
}
%ComHwnd% := "", Title := ""
If (ComCLSID = "InternetExplorer.Application")
{
	CoordMode, Mouse, Window
	Hotkey, RButton, NoKey, On
	Hotkey, Esc, EscNoKey, On
	L_Label := ComCLSID
	WinMinimize, ahk_id %CmdWin%
	SetTimer, WatchCursorIE, 100
	StopIt := 0
	Sleep, 100
	WaitFor.Key("RButton")
	SetTimer, WatchCursorIE, off
	ToolTip
	Sleep, 200
	Hotkey, RButton, NoKey, Off
	Hotkey, Esc, EscNoKey, Off
	L_Label := ""
	WinActivate, ahk_id %CmdWin%
	If (StopIt)
		Exit
	Try
		%ComHwnd% := WBGet()
	If (IsObject(%ComHwnd%))
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
	Hotkey, RButton, NoKey, On
	Hotkey, Esc, EscNoKey, On
	WinMinimize, ahk_id %CmdWin%
	SetTimer, WatchCursorXL, 100
	StopIt := 0
	Sleep, 100
	WaitFor.Key("RButton")
	SetTimer, WatchCursorXL, off
	ToolTip
	Sleep, 200
	Hotkey, RButton, NoKey, Off
	Hotkey, Esc, EscNoKey, Off
	WinActivate, ahk_id %CmdWin%
	If (StopIt)
		Exit
	Try
	{
		%ComHwnd% := ComObjActive(ComCLSID)
		Title := %ComHwnd%["ActiveWorkbook"]["Name"]
	}
	If (IsObject(%ComHwnd%))
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
	If (IsObject(%ComHwnd%))
		MsgBox, 64, %c_Lang099%, %d_Lang046%
	Else
		MsgBox, 16, %c_Lang099%, %d_Lang047%
}
return

TabControl:
Gui, 24:Submit, NoHide
If (TabControl = 2)
{
	If ((CreateComObj) && (ComCLSID = "InternetExplorer.Application"))
		GuiControl, 24:Enable, LoadWait
	Else
		GuiControl, 24:Disable, LoadWait
	If (CreateComObj)
		SB_SetText(Com_Tips[ComCLSID])
}
Else
{
	GuiControl, 24:Enable, LoadWait
	GoSub, IECmd
}
return

RefreshIEW:
IEWindows := ListIEWindows()
GuiControl, 24:, IEWindows, |%IEWindows%
return

ExpView:
Gui, Submit, NoHide
Script := (TabControl = 2) ? ComSc : ScLet
Gui, 30:+owner1 -MinimizeBox +E0x00000400 +hwndCmdWin
Gui, 24:+Disabled
Gui, 30:Font, s9, Courier New
Gui, 30:Font, s9, Lucida Console
Gui, 30:Font, s9, Consolas
Gui, 30:Add, Custom, ClassToolbarWindow32 hwndhTbText gTbText H25 0x0800 0x0100 0x0040 0x0008 0x0004
Gui, 30:Add, Edit, Section xm ym+25 vTextEdit gTextEdit WantTab W720 R30, %Script%
Gui, 30:Font
Gui, 30:Add, Button, -Wrap Section Default xm y+15 W75 H23 gExpViewOK, %c_Lang020%
Gui, 30:Add, Button, -Wrap ys W75 H23 gExpViewCancel, %c_Lang021%
Gui, 30:Add, StatusBar, gStatusBarHelp
Gui, 30:Default
SB_SetParts(480, 80)
SB_SetText(c_Lang091, 1)
SB_SetText("length: " 0, 2)
SB_SetText("lines: " 0, 3)
GoSub, TextEdit
Gui, 30:Font, s%MacroFontSize%
GuiControl, 30:Font, TextEdit
Gui, 30:Show,, %GuiTitle%
TB_Define(TbText, hTbText, hIL_Icons, FixedBar.Text, FixedBar.TextOpt)
TBHwndAll[9] := TbText
GuiControl, 30:Focus, TextEdit
return

ExpViewOK:
Gui, Submit, NoHide
Gui, 24:-Disabled
Gui, 30:Destroy
Gui, 24:Default
GuiControl,, % (TabControl = 2) ? "ComSc" : "ScLet", %TextEdit%
return

ExpViewCancel:
30GuiClose:
30GuiEscape:
Gui, 24:-Disabled
Gui, 30:Destroy
return

EditUserFunc:
EditParam:
EditReturn:
s_Caller := "Edit"
FuncReturn:
FuncParameter:
If (!InStr(CopyMenuLabels[A_List], "()"))
{
	s_Caller := ""
	return
}
UserFunction:
Gui, 38:+owner1 -MinimizeBox +E0x00000400 +HwndCmdWin
Gui, 1:+Disabled
Gui, 38:Add, Tab2, W450 H0 vTabControl AltSubmit, CmdTab1|CmdTab2|CmdTab3
; Function
Gui, 38:Add, GroupBox, Section xm ym W450 H70
Gui, 38:Add, Text, -Wrap R1 ys+15 xs+10 W210 vFuncNameT, %c_Lang089%:
Gui, 38:Add, Text, -Wrap R1 yp x+5 W105, %c_Lang218%:
Gui, 38:Add, Edit, y+5 xs+10 W210 vFuncName, MyFunc
Gui, 38:Add, Radio, -Wrap R1 yp+5 x+5 W105 vLocalScope gFuncScope Checked, %c_Lang219%
Gui, 38:Add, Radio, -Wrap R1 yp x+5 W105 vGlobalScope gFuncScope, %c_Lang220%
Gui, 38:Add, GroupBox, Section xm ys+75 W450 H155, %c_Lang215%:
Gui, 38:Add, Text, -Wrap R1 ys+20 xs+25 W210, %c_Lang221%:
Gui, 38:Add, Text, -Wrap R1 yp x+5 W150, %c_Lang217%:
Gui, 38:Add, Text, -Wrap R1 yp x+5 W30, ByRef
Gui, 38:Add, Text, -Wrap R1 y+10 xs+5 W15, #1
Gui, 38:Add, Edit, yp-5 xs+25 W210 vParam1
Gui, 38:Add, ComboBox, yp x+5 W150 vValue1, true|false|_blank
Gui, 38:Add, CheckBox, -Wrap R1 yp+5 x+15 W30 vByRef1
Gui, 38:Add, Text, -Wrap R1 y+10 xs+5 W15, #2
Gui, 38:Add, Edit, yp-5 xs+25 W210 vParam2
Gui, 38:Add, ComboBox, yp x+5 W150 vValue2, true|false|_blank
Gui, 38:Add, CheckBox, -Wrap R1 yp+5 x+15 W30 vByRef2
Gui, 38:Add, Text, -Wrap R1 y+10 xs+5 W15, #3
Gui, 38:Add, Edit, yp-5 xs+25 W210 vParam3
Gui, 38:Add, ComboBox, yp x+5 W150 vValue3, true|false|_blank
Gui, 38:Add, CheckBox, -Wrap R1 yp+5 x+15 W30 vByRef3
Gui, 38:Add, Text, -Wrap R1 y+10 xs+5 W15, #4
Gui, 38:Add, Edit, yp-5 xs+25 W210 vParam4
Gui, 38:Add, ComboBox, yp x+5 W150 vValue4, true|false|_blank
Gui, 38:Add, CheckBox, -Wrap R1 yp+5 x+15 W30 vByRef4
Gui, 38:Add, Text, -Wrap R1 y+10 xs+25 W400 cGray, %c_Lang222%
Gui, 38:Add, GroupBox, Section xm ys+160 W450 H55 vVarsGroup, %c_Lang223% (VarName1, VarName2, VarName3...):
Gui, 38:Add, Edit, ys+20 xs+10 W400 vFuncScoped
Gui, 38:Add, GroupBox, Section xm ys+60 W450 H55, %c_Lang225% (VarName1 [:= VarValue1], VarName2 [:= VarValue2]...):
Gui, 38:Add, Edit, ys+20 xs+10 W400 vFuncStatic
Gui, 38:Tab, 2
; Parameters
Gui, 38:Add, GroupBox, Section xm ym W450 H350
Gui, 38:Add, Text, -Wrap R1 ys+15 xs+10 W430 vParamNameT, %c_Lang221%
Gui, 38:Add, Edit, y+5 xs+10 W430 vParamName
Gui, 38:Add, Text, -Wrap R1 y+15 xs+10 W430, %c_Lang217%
Gui, 38:Add, ComboBox, y+5 xs+10 W430 vDefaultValue, true|false|_blank
Gui, 38:Add, CheckBox, -Wrap R1 y+15 xs+10 W100 vByRef, ByRef
Gui, 38:Add, Text, y+15 xs+10 W430 H120, %d_Lang095%
Gui, 38:Tab, 3
; Return
Gui, 38:Add, GroupBox, Section xm ym W450 H350
Gui, 38:Add, Text, -Wrap R1 ys+15 xs+10 W430, %c_Lang216%:
Gui, 38:Add, Edit, y+5 xs+10 W430 vRetExpr
Gui, 38:Add, Text, y+15 xs+10 W430 H250, %d_Lang096%
Gui, 38:Add, Link, -Wrap y+10 W430 R1 vExprLink gExprLink, <a>%c_Lang091%</a>
Gui, 38:Tab
Gui, 38:Add, Button, -Wrap Section Default xm ys+360 W75 H23 gUDFOK, %c_Lang020%
Gui, 38:Add, Button, -Wrap ys W75 H23 gUDFCancel, %c_Lang021%
Gui, 38:Add, Button, -Wrap ys W75 H23 vUDFApply gUDFApply Disabled, %c_Lang131%
Gui, 38:Add, StatusBar, gStatusBarHelp
Gui, 38:Default
SB_SetIcon(ResDllPath, IconsNames["help"])
If (s_Caller = "Edit")
{
	If (A_ThisLabel = "EditUserFunc")
	{
		GuiControl, 38:, FuncName, %Details%
		If (Target = "Global")
			GuiControl, 38:, GlobalScope, 1
		StringSplit, FuncVariables, Window, /, %A_Space%
		GuiControl, 38:, FuncScoped, % StrReplace(FuncVariables1, """")
		GuiControl, 38:, FuncStatic, % StrReplace(FuncVariables2, """")
		Loop, 4
		{
			GuiControl, 38:Disable, Param%A_Index%
			GuiControl, 38:Disable, Value%A_Index%
			GuiControl, 38:Disable, ByRef%A_Index%
		}
		GoSub, FuncScope
		SBShowTip("UserFunction")
	}
	Else If (A_ThisLabel = "EditParam")
	{
		AssignReplace(Details, VarName, Oper, VarValue)
		If (VarName = "")
			GuiControl, 38:, ParamName, %Details%
		Else
		{
			GuiControl, 38:, ParamName, %VarName%
			If (VarValue = """""")
				GuiControl, 38:ChooseString, DefaultValue, _blank
			Else If ((VarValue = "true") || (VarValue = "false"))
				GuiControl, 38:ChooseString, DefaultValue, %VarValue%
			Else
				GuiControl, 38:, DefaultValue, % Trim(VarValue, """") "||"
		}
		GuiControl, 38:, ByRef, % Target = "ByRef"
		GuiControl, 38:Choose, TabControl, 2
		SBShowTip("Parameter")
	}
	Else If (A_ThisLabel = "EditReturn")
	{
		GuiControl, 38:, RetExpr, %Details%
		GuiControl, 38:Choose, TabControl, 3
		SBShowTip("Return")
	}
	GuiControl, 38:Enable, UDFApply
}
If (InStr(A_ThisLabel, "UserFunc"))
{
	GuiTitle := c_Lang212
	SBShowTip("UserFunction")
}
Else If (InStr(A_ThisLabel, "Param"))
{
	GuiControl, 38:Choose, TabControl, 2
	GuiTitle := c_Lang213
	SBShowTip("Parameter")
}
Else
{
	GuiControl, 38:Choose, TabControl, 3
	GuiTitle := c_Lang214
	SBShowTip("Return")
}
Gui, 38:Show,, %GuiTitle%
ChangeIcon(hIL_Icons, CmdWin, InStr(A_ThisLabel, "UserFunc") ? IconsNames["userfunc"] : InStr(A_ThisLabel, "Param") ? IconsNames["parameter"] : IconsNames["return"])
Tooltip
return

UDFApply:
UDFOK:
Gui, 38:+OwnDialogs
Gui, 38:Submit, NoHide
If (TabControl = 1)
{
	If (FuncName = "")
	{
		Gui, 38:Font, cRed
		GuiControl, 38:Font, FuncNameT
		GuiControl, 38:Focus, FuncName
		return
	}
	If (!RegExMatch(FuncName, "^\w+$"))
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%
		return
	}
	MustDefault := false
	Loop, 4
	{
		If (Param%A_Index% = "")
			continue
		Param := Param%A_Index%
		Try
			z_Check := VarSetCapacity(%Param%)
		Catch
		{
			MsgBox, 16, %d_Lang007%, %d_Lang041%`n`n%Param%
			return
		}
		If ((MustDefault) && (Value%A_Index% == ""))
		{
			MsgBox, 16, %d_Lang007%, %d_Lang098%
			Return
		}
		If (Value%A_Index% != "")
			MustDefault := true
	}
	FuncVariables := ""
	Loop, Parse, FuncScoped, `,, %A_Space%
	{
		If (LocalScope = 1)
		{
			Try
				z_Check := VarSetCapacity(%A_LoopField%)
			Catch
			{
				MsgBox, 16, %d_Lang007%, %d_Lang041%`n`n%A_LoopField%
				return
			}
			FuncVariables .= A_LoopField ", "
		}
		Else
		{
			AssignReplace(A_LoopField, VarName, Oper, VarValue)
			If (VarName = "")
			{
				Try
					z_Check := VarSetCapacity(%A_LoopField%)
				Catch
				{
					MsgBox, 16, %d_Lang007%, %d_Lang041%`n`n%A_LoopField%
					return
				}
				FuncVariables .= A_LoopField ", "
			}
			Else
			{
				Try
					z_Check := VarSetCapacity(%VarName%)
				Catch
				{
					MsgBox, 16, %d_Lang007%, %d_Lang041%`n`n%VarName%
					return
				}
				FuncVariables .= VarName " := " Trim(VarValue, """") ", "
			}
		}
	}
	StaticVariables := ""
	Loop, Parse, FuncStatic, `,, %A_Space%
	{
		AssignReplace(A_LoopField, VarName, Oper, VarValue)
		If (VarName = "")
		{
			Try
				z_Check := VarSetCapacity(%A_LoopField%)
			Catch
			{
				MsgBox, 16, %d_Lang007%, %d_Lang041%`n`n%A_LoopField%
				return
			}
			StaticVariables .= A_LoopField ", "
		}
		Else
		{
			Try
				z_Check := VarSetCapacity(%VarName%)
			Catch
			{
				MsgBox, 16, %d_Lang007%, %d_Lang041%`n`n%VarName%
				return
			}
			StaticVariables .= VarName " := " Trim(VarValue, """") ", "
		}
	}
	StaticVariables := RegExReplace(StaticVariables, ":=\s(\D+?),", ":= ""$1"",")
	StaticVariables := StrReplace(StaticVariables, """true""", "true")
	StaticVariables := StrReplace(StaticVariables, """false""", "false")
	FuncVariables := RegExReplace(FuncVariables, ":=\s(\D+?),", ":= ""$1"",")
	FuncVariables := StrReplace(FuncVariables, """true""", "true")
	FuncVariables := StrReplace(FuncVariables, """false""", "false")
	FuncVariables := Trim(FuncVariables, ", ") " / " Trim(StaticVariables, ", ")
	CurrentTabs := ""
	Loop, % TabCount
	{
		If ((s_Caller != "") && (A_List = A_Index))
		{
			CurrentTabs .= FuncName "()|"
			continue
		}
		TabName := CopyMenuLabels[A_Index]
		If (TabName = (FuncName "()"))
		{
			MsgBox, 16, %d_Lang007%, %d_Lang101%
			return
		}
		CurrentTabs .= TabName "|"
	}
	If (s_Caller = "")
	{
		GoSub, TabPlus
		CurrentTabs .= FuncName "()"
	}
	GuiControl, chMacro:, %TabSel%, |%CurrentTabs%
	CopyMenuLabels := StrSplit(Trim(CurrentTabs, "|"), "|")
	GuiControl, chMacro:Choose, A_List, %A_List%
	GoSub, FuncTab
	If (A_ThisLabel != "UDFApply")
	{
		Gui, 1:-Disabled
		Gui, 38:Destroy
	}
	Gui, chMacro:Default
	RowIdx := 1
	Loop, 4
	{
		DefaultDet := ""
		If (Param%A_Index% = "")
			continue
		If (Value%A_Index% != "")
		{
			DefaultDet := (Value%A_Index% = "_blank" ? "" : Value%A_Index%)
			If DefaultDet not in true,false
			{
				If DefaultDet is not Number
					DefaultDet := """" DefaultDet """"
			}
			DefaultDet := " := " DefaultDet
		}
		Else
			DefaultDet := ""
		Action := "[FuncParameter]", Details := Param%A_Index% . DefaultDet, Type := cType48
		Target := ByRef%A_Index% ? "ByRef" : ""
		If (s_Caller = "Conv")
			LV_Insert(RowIdx, "Check", ListCount%A_List%+1, Action, Details, 1, 0, Type, Target)
		Else
			LV_Add("Check", ListCount%A_List%+1, Action, Details, 1, 0, Type, Target)
		RowIdx++
	}
	FuncScope := (GlobalScope = 1) ? "Global" : "Local"
	If (s_Caller = "Conv")
		LV_Insert(RowIdx, "Check", ListCount%A_List%+1, "[FunctionStart]", FuncName, 1, 0, cType47, FuncScope, FuncVariables)
	Else If (s_Caller = "Edit")
		LV_Modify(RowNumber, "Col2", "[FunctionStart]", FuncName, 1, 0, cType47, FuncScope, FuncVariables)
	Else
		LV_Add("Check", ListCount%A_List%+1, "[FunctionStart]", FuncName, 1, 0, cType47, FuncScope, FuncVariables)
	GoSub, PrevRefresh
	GoSub, UpdateCopyTo
}
If (TabControl = 2)
{
	If (ParamName = "")
	{
		Gui, 38:Font, cRed
		GuiControl, 38:Font, ParamNameT
		GuiControl, 38:Focus, ParamName
		return
	}
	Try
		z_Check := VarSetCapacity(%ParamName%)
	Catch
	{
		MsgBox, 16, %d_Lang007%, %d_Lang041%`n`n%ParamName%
		return
	}
	If (DefaultValue != "")
	{
		DefaultDet := (DefaultValue = "_blank" ? "" : DefaultValue)
		If DefaultDet not in true,false
		{
			If DefaultDet is not Number
				DefaultDet := """" DefaultDet """"
		}
		DefaultDet := " := " DefaultDet
	}
	Else
		DefaultDet := ""
	Action := "[FuncParameter]", Details := ParamName . DefaultDet, Type := cType48
	Target := ByRef ? "ByRef" : ""
	Gui, chMacro:Default
	RowSelection := LV_GetCount("Selected")
	If (s_Caller = "Edit")
		LV_Modify(RowNumber, "Col2", Action, Details, 1, 0, Type, Target)
	Else If (RowSelection = 0)
	{
		RowNumber := 1
		Loop, % ListCount%A_List%
		{
			LV_GetText(RowType, RowNumber, 6)
			If (RowType = cType47)
				break
			RowNumber++
		}
		LV_Insert(RowNumber, "Check",, Action, Details, 1, 0, Type, Target)
		LVManager[A_List].InsertAtGroup(RowNumber)
	}
	Else
	{
		LV_Insert(LV_GetNext(), "Check",, Action, Details, 1, 0, Type, Target)
		LVManager[A_List].InsertAtGroup(LV_GetNext())
	}
}
If (TabControl = 3)
{
	Gui, chMacro:Default
	RowSelection := LV_GetCount("Selected"), LV_GetText(RowType, LV_GetNext(), 6)
	If (s_Caller = "Edit")
		LV_Modify(RowNumber, "Col2", "[FuncReturn]", RetExpr, 1, 0, cType49)
	Else If ((RowSelection = 0) || ((RowType = cType47) || RowType = cType48))
	{
		LV_Add("Check", ListCount%A_List%+1, "[FuncReturn]", RetExpr, 1, 0, cType49)
		LV_Modify(ListCount%A_List%+1, "Vis")
	}
	Else
	{
		LV_Insert(LV_GetNext(), "Check",, "[FuncReturn]", RetExpr, 1, 0, cType49)
		LVManager[A_List].InsertAtGroup(LV_GetNext())
	}
}
If (A_ThisLabel != "UDFApply")
{
	Gui, 1:-Disabled
	Gui, 38:Destroy
}
GoSub, RowCheck
GoSub, b_Start
If (A_ThisLabel = "UDFApply")
	Gui, 38:Default
Else
{
	s_Caller := ""
	GuiControl, Focus, InputList%A_List%
}
return

UDFCancel:
38GuiEscape:
38GuiClose:
Gui, 1:-Disabled
Gui, 38:Destroy
s_Caller := ""
return

ConvertToFunc:
If (InStr(CopyMenuLabels[A_List], "()"))
	return
s_Caller := "Conv"
GoSub, UserFunction
return

FuncScope:
Gui, 38:Submit, NoHide
If (GlobalScope = 1)
	GuiControl, 38:, VarsGroup, %c_Lang224% (VarName1 [:= VarValue1], VarName2 [:= VarValue2]...):
Else
	GuiControl, 38:, VarsGroup, %c_Lang223% (VarName1, VarName2, VarName3...):
return

DonatePayPal:
Run, "https://www.macrocreator.com/donate"
return

26GuiEscape:
26GuiClose:
TipClose:
Gui, 26:Submit
Gui, 26:Destroy
Gui, 1:-Disabled
WinActivate,,, ahk_id %PMCWinID%
return

35GuiEscape:
35GuiClose:
TipClose2:
Gui, 1:-Disabled
Gui, 35:Submit
Gui, 35:Destroy
return

Welcome:
Gui, 31:-MinimizeBox +owner1
Gui, 1:+Disabled
Gui, 31:Font, Bold s10, Tahoma
Gui, 31:Add, Text, -Wrap R1 w460 Center, %d_Lang075%
Gui, 31:Font
Gui, 31:Add, Groupbox, Section w480 h90 Center, %d_Lang076%:
Gui, 31:Add, Radio, -Wrap R1 Checked xs+30 ys+30 W130 vBestFit gBestFitLayout, %d_Lang118%
Gui, 31:Add, Radio, -Wrap R1 yp x+20 W130 vDefault gDefaultLayout, %d_Lang078%
Gui, 31:Add, Radio, -Wrap R1 yp x+20 W130 vBasic gBasicLayout, %d_Lang077%
Gui, 31:Add, Text, -Wrap y+15 xs+10 W300 R1 cGray, %d_Lang081%
Gui, 31:Add, Text, -Wrap y+30 xs W170 R1, %t_Lang189% (Language):
Gui, 31:Add, DDL, yp x+5 W190 vSelLang, %Lang_List%
GuiControl, 31:ChooseString, SelLang, % RegExReplace(Lang_%CurrentLang%, "\t.*")
Gui, 31:Add, Button, Default xm W75 H23 gWelcClose, %c_Lang020%
Gui, 31:Add, Checkbox, Checked%AutoUpdate% -Wrap yp+5 x+10 W350 r1 vAutoUpdate, %d_Lang079%
Gui, 31:Show,, %AppName%
return

31GuiClose:
31GuiEscape:
WelcClose:
Gui, 1:-Disabled
Gui, 31:Submit
Gui, 31:Destroy
If (AutoUpdate)
	Menu, HelpMenu, Check, %h_Lang008%
Else
	Menu, HelpMenu, Uncheck, %h_Lang008%
If (Basic = 1)
	UserLayout := "Basic"
If (Default = 1)
	UserLayout := "Default"
SetTimer, LangChange, -1
Sleep, 500
Files := SettingsFolder "\Demo.pmc"
GoSub, OpenFile
If (ShowTips)
	GoSub, ShowTips
If (AutoUpdate)
	SetTimer, CheckUpdates, -1
return

CmdFind:
ShowTips:
If (NextTip > MaxTips)
	NextTip := 1
Gui, 34:+owner1 -MinimizeBox +E0x00000400 +HwndStartTipID
Gui, 1:+Disabled
If (A_ThisLabel != "CmdFind")
{
	Gui, 34:Color, FFFFFF
	Gui, 34:Font, Bold s10, Tahoma
	Gui, 34:Add, Text, w220, %d_Lang072%
	Gui, 34:Font
	Gui, 34:Font,, Tahoma
	Gui, 34:Add, Text, w220, %d_Lang069%
	Gui, 34:Font
	Gui, 34:Add, Button, Section -Wrap xm+60 W75 H23 gDonatePayPal, %d_Lang070%
	Gui, 34:Add, Button, -Wrap ys W75 H23 gTipsClose, %d_Lang071%
	Gui, 34:Add, Checkbox, -Wrap Checked%ShowTips% xm y+20 W220 vShowTips R1, %d_Lang067%
	Gui, 34:Add, Text, x+10 ym h255 0x11
	Gui, 34:Add, Pic, x+1 ym Icon72 W48 H48, %ResDllPath%
	Gui, 34:Add, Text, -Wrap R1 Section yp x+10, %d_Lang068%%A_Space%
	Gui, 34:Add, Text, -Wrap R1 yp x+0 vCurrTip, %NextTip%%A_Space%%A_Space%%A_Space%
	Gui, 34:Add, Text, -Wrap R1 yp x+0, / %MaxTips%
	Gui, 34:Add, Edit, xs W350 r6 vTipDisplay ReadOnly -0x200000 -E0x200, % StartTip_%NextTip%
	Gui, 34:Add, Button, Section -Wrap y+0 W90 H23 vPTip gPrevTip, %d_Lang022%
	Gui, 34:Add, Button, -Wrap yp x+5 W90 H23 vNTip gNextTip, %d_Lang021%
	Gui, 34:Add, Text, -Wrap R1 xs-30 w380 0x10
	If (NextTip = 1)
		GuiControl, 34:Disable, PTip
	Gui, 34:Font, Bold
	Gui, 34:Add, Text, yp+5 -Wrap r1, %d_Lang074%:
	Gui, 34:Font
	Gui, 34:Add, Edit, -Wrap W380 r1 vFindCmd gFindCmd
	Gui, 34:Add, ListView, y+0 W380 r4 hwndhFindRes vFindResult gFindResult AltSubmit -Multi -Hdr LV0x4000, Command|Description
}
Else
{
	Gui, 34:Add, Groupbox, Section yp+5 -Wrap W450 H195, %d_Lang074%:
	Gui, 34:Add, Edit, -Wrap ys+20 xs+10 W430 r1 vFindCmd gFindCmd
	Gui, 34:Add, ListView, r8 y+0 W430 hwndhFindRes vFindResult gFindResult AltSubmit -Multi -Hdr LV0x4000, Command|Description
	Gui, 34:Add, StatusBar, gStatusBarHelp
	Gui, 34:Default
	SB_SetIcon(ResDllPath, IconsNames["help"])
}
GuiControl, 34:Focus, FindCmd
Gui, 34:Show,, %AppName%
return

34GuiEscape:
34GuiClose:
TipsClose:
NextTip++
Gui, 1:-Disabled
Gui, 34:Submit
Gui, 34:Destroy
return

PrevTip:
If (NextTip = 1)
	return
NextTip--
GuiControl, 34:, CurrTip, %NextTip%
GuiControl, 34:, TipDisplay, % StartTip_%NextTip%
GuiControl, 34:Enable, NTip
If (NextTip = 1)
{
	GuiControl, 34:Disable, PTip
	GuiControl, 34:Focus, NTip
}
return

NextTip:
If (NextTip = MaxTips)
	return
NextTip++
GuiControl, 34:, CurrTip, %NextTip%
GuiControl, 34:, TipDisplay, % StartTip_%NextTip%
GuiControl, 34:Enable, PTip
If (NextTip = MaxTips)
{
	GuiControl, 34:Disable, NTip
	GuiControl, 34:Focus, PTip
}
return

FindCmd:
Gui, 34:Submit, NoHide
If (FindCmd = "")
	return
FoundResults := Find_Command(FindCmd)
Gui, 34:Default
LV_Delete()
For _each, Line in FoundResults
	LV_Add("", Line.Cmd, Line.Path)
LV_ModifyCol()
return

NextResult:
ControlSend,, {Down}, ahk_id %hFindRes%
return

PrevResult:
ControlSend,, {Up}, ahk_id %hFindRes%
return

FindResult:
Gui, 34:Default
LV_GetText(SelectedResult, LV_GetNext(), 1)
SBShowTip(SelectedResult)
If (A_GuiEvent != "DoubleClick")
	return
GoResult:
Gui, 34:Submit, NoHide
Gui, 34:Default
LV_GetText(GotoRes1, LV_GetNext(), 1), LV_GetText(GotoRes2, LV_GetNext(), 2)
GotoResult:
Loop, Parse, KeywordsList, |
{
	SearchIn := A_LoopField
	Loop, Parse, %A_LoopField%_Keywords, `,
	{
		If ((SearchIn = "Type") && (GotoRes1 = A_LoopField))
			SearchIn := "Type" A_Index
		If ((A_LoopField = GotoRes1) && (%SearchIn%_Path = GotoRes2))
		{
			s_Caller := "Find"
			GoSub, TipsClose
			Goto, % %SearchIn%_Goto
		}
	}
}
return

Scheduler:
Gui, 1:+OwnDialogs
If (SavePrompt)
{
	Gui, 27:+Disabled
	MsgBox, 48, %AppName%, %d_Lang084%
	Gui, 27:-Disabled
	return
}
Gui, 1:-Disabled
Gui, 27:Destroy
Gui, 36:+owner1 -MinimizeBox +HwndCmdWin
Gui, 1:+Disabled
Gui, 36:Add, Groupbox, Section W165 H50, %t_Lang154%:
Gui, 36:Add, DateTime, xs+10 ys+20 vScheduleTime W140, yyyy/MM/dd HH:mm
Gui, 36:Add, Groupbox, Section x+25 ym W165 H50, %t_Lang155%:
Gui, 36:Add, DDL, xs+10 ys+20 vScheduleType W140 AltSubmit, %t_Lang156%
Gui, 36:Add, GroupBox, Section xm y+15 W340 H85, %w_Lang003%:
Gui, 36:Add, Radio, -Wrap R1 Checked xs+10 ys+20 vTargetPMC gTargetFile W160, %t_Lang157%
Gui, 36:Add, Radio, -Wrap R1 y+10 vTargetAHK gTargetFile W160, %t_Lang158%
Gui, 36:Add, Text, -Wrap R1 x+15 ys+20 W150, %t_Lang165%:
Gui, 36:Add, Edit, W75 vSchedEd Number
Gui, 36:Add, UpDown, vSchedHK 0x80 Range1-%TabCount%, %A_List%
Gui, 36:Add, Text, -Wrap R1 xs+10 y+5 W300 cRed vWarning
Gui, 36:Add, Button, -Wrap Section Default xm W75 H23 vSchedOK gSchedOK, %c_Lang020%
Gui, 36:Add, Button, -Wrap ys W75 H23 gSchedCancel, %c_Lang021%
Gui, 36:Add, Link, -Wrap ys+5 W160 R1, <a href="taskschd.msc">%t_Lang160%</a>
Gui, 36:Add, StatusBar, gStatusBarHelp
Gui, 36:Default
SB_SetIcon(ResDllPath, IconsNames["help"])
SB_SetText(t_Lang153)
Gui, 36:Show,, %t_Lang164%
ChangeIcon(hIL_Icons, CmdWin, IconsNames["scheduler"])
return

SchedOK:
Gui, 36:Submit, NoHide
Gui, 36:+OwnDialogs
FormatTime, StartTime, %ScheduleTime%, yyyy-MM-ddTHH`:mm`:ss
FormatTime, SchedDate, %ScheduleTime%
If (TargetAHK)
{
	GoSub, Export
	GoSub, ExpButton
	GoSub, ExpClose
	TaskRun := """" ExpFile """"
	TaskArgs := ""
}
Else
{
	TaskRun := """" A_ScriptFullPath """"
	TaskArgs := """" CurrentFileName """ -s" SchedHK
}
Try
{
	SplitPath, CurrentFileName, Name
	ScheduleTask(Sched_%ScheduleType%, StartTime, TaskRun, TaskArgs, Name)
	MsgBox, 64, %AppName%, %t_Lang161%`n`n'%SchedDate%'
}
Catch
{
	MsgBox, 16, %AppName%, %t_Lang162%
	return
}
SchedCancel:
36GuiClose:
36GuiEscape:
Gui, 36:Submit, NoHide
Gui, 1:-Disabled
Gui, 36:Destroy
return

TargetFile:
Gui, 36:Submit, NoHide
GuiControl, 36:Disable%TargetAHK%, SchedEd
GuiControl, 36:Disable%TargetAHK%, SchedHK
If (TargetAHK)
	GuiControl, 36:, Warning, * %t_Lang159%
Else
	GuiControl, 36:, Warning
return

RunTimer:
If (InStr(CopyMenuLabels[A_List], "()"))
	return
Gui, 27:+owner1 -MinimizeBox +HwndCmdWin
Gui, 1:+Disabled
Gui, 27:Add, Groupbox, Section W220 H100
Gui, 27:Add, Edit, ys+15 xs+30 Limit Number W150
Gui, 27:Add, UpDown, vTimerDelayX 0x80 Range0-9999999, %TimerDelayX%
Gui, 27:Add, Radio, -Wrap Section Checked%TimerMsc% yp+25 W150 vTimerMsc R1, %c_Lang018%
Gui, 27:Add, Radio, -Wrap Checked%TimerSec% W150 vTimerSec R1, %c_Lang019%
Gui, 27:Add, Radio, -Wrap Checked%TimerMin% W150 vTimerMin R1, %c_Lang154%
Gui, 27:Add, Groupbox, Section W220 H100 ym x+50, %w_Lang003%:
Gui, 27:Add, Radio, -Wrap Group Checked%RunOnce% ys+20 xs+10 W200 vRunOnce gTimerSub R1, %t_Lang078%
Gui, 27:Add, Radio, -Wrap Checked%TimedRun% W200 vTimedRun gTimerSub R1, %t_Lang079%
Gui, 27:Add, Checkbox, -Wrap Checked%RunFirst% y+5 xp+15 W185 vRunFirst R1 Disabled, %t_Lang106%
Gui, 27:Add, Checkbox, -Wrap Checked%ShowBar% y+8 xs+10 W200 vShowBar R1, %w_Lang009%
Gui, 27:Add, Button, -Wrap Section Default xm W75 H23 gTimerOK, %c_Lang020%
Gui, 27:Add, Button, -Wrap ys W75 H23 gTimerCancel, %c_Lang021%
Gui, 27:Add, Button, -Wrap ys W75 H23 gScheduler, %t_Lang163%
Gui, 27:Add, StatusBar, gStatusBarHelp
Gui, 27:Default
SB_SetIcon(ResDllPath, IconsNames["help"])
If (!Timer_ran)
{
	GuiControl, 27:, TimerDelayX, 250
	GuiControl, 27:, TimerMsc, 1
	GuiControl, 27:, RunOnce, 1
	GuiControl, 27:, RunFirst, 0
	GuiControl, 27:, ShowBar, 0
}
If (TimedRun)
	GuiControl, 27:Enable, RunFirst
SBShowTip("SetTimer")
Gui, 27:Show,, %t_Lang080%
ChangeIcon(hIL_Icons, CmdWin, IconsNames["timer"])
return

TimerSub:
Gui, 27:Submit, NoHide
GuiControl, 27:Enable%TimedRun%, RunFirst
return

TimerOK:
Gui, 27:Submit, NoHide
Gui, 1:-Disabled
Gui, 27:Destroy
Gui, chMacro:Default
Timer_ran := true
GoSub, b_Enable
If (ListCount%A_List% = 0)
	return
GoSub, SaveData
StopIt := 0
Tooltip
If ((!PlayHK) && (!HideWin) && (HideMainWin))
	GoSub, ShowHide
Else
	WinMinimize, ahk_id %PMCWinID%
If (TimerSec = 1)
	DelayX := TimerDelayX * 1000
Else If (TimerMin = 1)
	DelayX := TimerDelayX * 60000
Else
	DelayX := TimerDelayX
If (RunOnce = 1)
	DelayX := DelayX > 0 ? DelayX * -1 : -1
ActivateHotkeys(0, 1, 1, 1, 1)
aHK_Timer0 := A_List, aHK_Label0 := 0
If (CheckDuplicateLabels())
{
	MsgBox, 16, %d_Lang007%, %d_Lang050%
	StopIt := 1
	return
}
If (ShowBar)
	GoSub, ShowControls
SetTimer, RunTimerOn0, %DelayX%
If (TimedRun) && (RunFirst)
	GoSub, RunTimerOn0
return

RunTimerOn0:
If (InStr(CopyMenuLabels[aHK_Timer0], "()"))
{
	SetTimer, %A_ThisLabel%, Off
	return
}
RunTimerOn1:
RunTimerOn2:
RunTimerOn3:
RunTimerOn4:
RunTimerOn5:
RunTimerOn6:
RunTimerOn7:
RunTimerOn8:
RunTimerOn9:
RunTimerOn10:
RegExMatch(A_ThisLabel, "\d+", nMatch)
If (StopIt)
{
	SetTimer, %A_ThisLabel%, Off
	return
}
If (aHK_On := Playback(aHK_Timer%nMatch%, aHK_Label%nMatch%))
	SetTimer, f_RunMacro, -1
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
If (!pb_From)
	Menu, MacroMenu, Uncheck, %r_Lang008%`t%_s%Alt+1
Else
	Menu, MacroMenu, Check, %r_Lang008%`t%_s%Alt+1
Menu, MacroMenu, Uncheck, %r_Lang009%`t%_s%Alt+2
Menu, MacroMenu, Uncheck, %r_Lang010%`t%_s%Alt+3
pb_To := "", pb_Sel := ""
GoSub, UpdateRecPlayMenus
return

PlayTo:
pb_To := !pb_To
If (!pb_To)
	Menu, MacroMenu, Uncheck, %r_Lang009%`t%_s%Alt+2
Else
	Menu, MacroMenu, Check, %r_Lang009%`t%_s%Alt+2
Menu, MacroMenu, Uncheck, %r_Lang008%`t%_s%Alt+1
Menu, MacroMenu, Uncheck, %r_Lang010%`t%_s%Alt+3
pb_From := "", pb_Sel := ""
GoSub, UpdateRecPlayMenus
return

PlaySel:
pb_Sel := !pb_Sel
If (!pb_Sel)
	Menu, MacroMenu, Uncheck, %r_Lang010%`t%_s%Alt+3
Else
	Menu, MacroMenu, Check, %r_Lang010%`t%_s%Alt+3
Menu, MacroMenu, Uncheck, %r_Lang008%`t%_s%Alt+1
Menu, MacroMenu, Uncheck, %r_Lang009%`t%_s%Alt+2
pb_To := "", pb_From := ""
GoSub, UpdateRecPlayMenus
return

TestRun:
GoSub, b_Enable
If (ListCount%A_List% = 0)
	return
If (DebugCheckError)
	return
If (InStr(CopyMenuLabels[A_List], "()"))
	return
Gui, 1:Submit, NoHide
Gui, chMacro:Submit, NoHide
GoSub, SaveData
Gui, chMacro:Default
Gui, chMacro:ListView, InputList%A_List%
ActivateHotkeys(0, 0, 1, 1, 1)
StopIt := 0
Tooltip
If ((!PlayHK) && (!HideWin) && (HideMainWin))
	GoSub, ShowHide
Else
	WinMinimize, ahk_id %PMCWinID%
aHK_On := [A_List]
SetTimer, f_RunMacro, -1
return

PlayStart:
Gui, 1:+OwnDialogs
Gui, 1:Submit, NoHide
GoSub, b_Enable
If ((!PlayHK) && (!HideWin) && (!WinExist("ahk_id" PMCWinID)))
{
	GoSub, ShowHide
	return
}
Else If (!ListCount)
	return
Gui, chMacro:Submit, NoHide
If (AutoBackup)
	SetTimer, ProjBackup, -100
If (DebugCheckError)
	return
SetTimer, PlayActive, -1
If (ActiveKeys = "Error")
	return
If (!DontShowPb)
{
	Gui 26:+LastFoundExist
	IfWinExist
		GoSub, TipClose
	Gui, 26:-SysMenu +HwndTipScrID
	Gui, 26:Color, FFFFFF
	Gui, 26:Add, Pic, y+20 Icon29 W48 H48, %ResDllPath%
	Gui, 26:Add, Text, -Wrap R1 yp x+10, %d_Lang051%`n`n%d_Lang043%`n
	Gui, 26:Add, Checkbox, Section -Wrap W300 vDontShowPb R1 cGray, %d_Lang053%
	Gui, 26:Add, Button, -Wrap Default xs y+10 W75 H23 gTipClose, %c_Lang020%
	Gui, 26:Show,, %AppName%
}
If ((!PlayHK) && (!HideWin) && (HideMainWin))
	GoSub, ShowHide
Else
{
	WinMinimize, ahk_id %PMCWinID%
	WinActivate,,, ahk_id %PMCWinID%
}
If (OnScCtrl)
	GoSub, ShowControls
Gui, chMacro:Default
Gui, chMacro:ListView, InputList%A_List%
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
If (!ActiveKeys)
{
	TrayTip, %AppName%, %d_Lang009%,,3
	return
}
StopIt := 0
Tooltip
return

OnScControls:
If (WinExist("ahk_id " PMCOSC))
{
	GoSub, 28GuiClose
	return
}
ShowControls:
Menu, ViewMenu, Check, %v_Lang004%`t%_s%Ctrl+B
Menu, Tray, Check, %y_Lang003%
Gui, 28:Show, % (ShowProgBar ? "H40" : "H30") " W415 NoActivate", %AppName%
return

BuildOSCWin:
Gui, 28:+Toolwindow +AlwaysOntop +HwndPMCOSC +E0x08000000
If (!OSCaption)
	Gui, 28:-Caption
Gui, 28:Add, Edit, W40 H23 vOSHKEd Number
Gui, 28:Add, UpDown, hwndOSHK vOSHK gOSHK 0x80 Horz 16 Range1-%TabCount%, %A_List%
Gui, 28:Add, Custom, ClassToolbarWindow32 hwndhTbOSC x55 y5 W320 H25 0x0800 0x0100 0x0040 0x0008 0x0004
Gui, 28:Add, Progress, ym+25 xm W120 H10 vOSCProg c20D000
Gui, 28:Font
Gui, 28:Font, s6 Bold
Gui, 28:Add, Text, -Wrap yp x+0 W180 r1 vOSCProgTip
Gui, 28:Add, Slider, yp-2 x+0 W65 H10 vOSTrans gTrans NoTicks Thick20 ToolTip Range25-255, %OSTrans%
OSCPos := StrSplit(OSCPos, " ")
OSCPos[1] := (SubStr(OSCPos[1], 2) > A_ScreenWidth || SubStr(OSCPos[1], 2) < 400) ? "X0" : OSCPos[1]
OSCPos[2] := (SubStr(OSCPos[2], 2) > A_ScreenHeight || SubStr(OSCPos[2], 2) < 25) ? "Y0" : OSCPos[2]
OSCPos := OSCPos[1] " " OSCPos[2]
Gui, 28:Show, % OSCPos (ShowProgBar ? " H40" : " H30") " W380 NoActivate Hide", %AppName%
WinSet, Transparent, %OSTrans%, ahk_id %PMCOSC%
return

OSHK:
Gui, 28:Submit, NoHide
Gui, chMacro:Default
GuiControl, chMacro:Choose, A_List, %OSHK%
GoSub, TabSel
return

OSPlay:
GoSub, OSHK
GoSub, b_Enable
If (ListCount%OSHK% = 0)
	return
If (DebugCheckError)
	return
If (WinActive("ahk_id " PMCWinID))
	WinActivate,,, ahk_id %PMCWinID%
If (!PlayOSOn)
{
	ActivateHotkeys(,, 1, 1, 1)
	StopIt := 0
	Tooltip
	SetTimer, OSPlayOn, -1
}
Else If (IsPauseCheck)
{
	If ((!CurrentRange) && (!Record))
		return
	If (ToggleIcon(IsPauseCheck) && (!Record))
		tbOSC.ModifyButtonInfo(1, "Image", 55)
	Else
		tbOSC.ModifyButtonInfo(1, "Image", 48)
	Pause, Off, 1
	IsPauseCheck := false
}
Else
{
	If ((!CurrentRange) && (!Record))
		return
	If (ToggleIcon(IsPauseCheck) && (!Record))
		tbOSC.ModifyButtonInfo(1, "Image", 55)
	Else
		tbOSC.ModifyButtonInfo(1, "Image", 48)
	Pause,, 1
	IsPauseCheck := true
}
return

OSStop:
If (IsPauseCheck)
{
	If ((!CurrentRange) && (!Record))
		return
	If (ToggleIcon(IsPauseCheck) && (!Record))
		tbOSC.ModifyButtonInfo(1, "Image", 55)
	Else
		tbOSC.ModifyButtonInfo(1, "Image", 48)
	Pause, Off, 1
	IsPauseCheck := false
}
If (Record)
	GoSub, RecStart
Else
	GoSub, f_AbortKey
return

OSPlayOn:
aHK_On := [OSHK]
SetTimer, f_RunMacro, -1
return

OSClear:
Gui, 28:Submit, NoHide
Gui, chMacro:Default
Gui, chMacro:Listview, %OSHK%
MsgBox, 1, %d_Lang019%, %d_Lang020%
IfMsgBox, OK
{
	LV_Delete()
	LVManager[A_List].RemoveAllGroups(c_Lang061)
}
GoSub, RowCheck
GoSub, b_Start
return

ProgBarToggle:
Gui, 28:Submit, NoHide
TB_Edit(TbOSC, "ProgBarToggle", ShowProgBar := !ShowProgBar)
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
Gui, 28:Hide
Menu, ViewMenu, Uncheck, %v_Lang004%`t%_s%Ctrl+B
Menu, Tray, Uncheck, %y_Lang003%
return

ToggleTB:
If (OSCaption := !OSCaption)
	Gui, 28:+Caption
Else
	Gui, 28:-Caption
return

WinKey:
OnScCtrl:
HideMainWin:
TB_Edit(TbSettings, A_ThisLabel, %A_ThisLabel% := !%A_ThisLabel%)
If (OnScCtrl)
	Menu, OptionsMenu, Check, %o_Lang003%
Else
	Menu, OptionsMenu, Uncheck, %o_Lang003%
If (WinKey)
	Menu, OptionsMenu, Check, %o_Lang007%
Else
	Menu, OptionsMenu, Uncheck, %o_Lang007%
If (HideMainWin)
	Menu, OptionsMenu, Check, %o_Lang002%
Else
	Menu, OptionsMenu, Uncheck, %o_Lang002%
return

Capt:
LVManager[A_List].EnableGroups(false)
SetTimer, MainLoop, % (Capt := !Capt) ? 100 : "Off"
ListFocus := 1
Input
TB_Edit(TbSettings, "Capt", Capt)
If (Capt)
{
	GuiControl, chMacro:-g, InputList%A_List%
	Menu, OptionsMenu, Check, %o_Lang004%
}
Else
{
	ListFocus := 0
	GuiControl, chMacro:+gInputList, InputList%A_List%
	Menu, OptionsMenu, Uncheck, %o_Lang004%
	GoSub, RowCheck
	GoSub, b_Start
	If (AutoRefresh = 1)
		GoSub, PrevRefresh
}
return

InputList:
If (RowCheckInProgress)
	return
Critical
Gui, chMacro:ListView, InputList%A_List%
If ((A_GuiEvent == "I") || (A_GuiEvent == "K"))
{
	If ((InStr(ErrorLevel, "c")) || (Chr(A_EventInfo) = " "))
	{
		LV_GetText(RowType, A_EventInfo, 6)
		If (RowType = cType47)
			LV_Modify(A_EventInfo, "Check")
	}
	If (InStr(ErrorLevel, "c"))
	{
		HistCheck(A_List) ; Programmatically pasting rows causes this event to be triggered!
		If (AutoRefresh = 1)
			GoSub, PrevRefresh
	}
	If (AutoSelectLine)
		GoSub, GoToLine
}
If (A_GuiEvent == "F")
{
	Input
	ListFocus := 1
	If (Capt)
		SetTimer, MainLoop, -100
}
If (A_GuiEvent == "f")
{
	Input
	ListFocus := 0
	SetTimer, MainLoop, Off
	If (Capt)
		GoSub, Capt
}
If (A_GuiEvent == "ColClick")
{
	If (A_EventInfo = 1)
	{
		GoSub, ShowLoopIfMark
		GoSub, RowCheck
	}
	Else If (A_EventInfo = 2)
	{
		KeyWait, LButton
		KeyWait, LButton, D T%DClickSpd%
		If (ErrorLevel)
		{
			SelectedRow := LV_GetNext()
			LV_GetText(SelType, SelectedRow, A_EventInfo)
			SelectByType(SelType, A_EventInfo)
		}
		Else
		{
			GoSub, ShowActIdent
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
If (A_GuiEvent = "D")
{
	GuiControl, chMacro:-g, InputList%A_List%
	Dest_Row := LVManager[A_List].Drag(A_GuiEvent)
	GoSub, RowCheck
	GoSub, b_Start
	GuiControl, chMacro:+gInputList, InputList%A_List%
	If ((Dest_Row) && (A_GuiEvent == "d"))
		SetTimer, MoveCopy, -10
	Else
		Dest_Row := ""
}
If (A_GuiEvent == "RightClick")
{
	RowNumber := 0
	RowSelection := LV_GetCount("Selected")
	RowNumber := LV_GetNext(RowNumber - 1)
}
If (A_GuiEvent != "DoubleClick")
	return
RowNumber := LV_GetNext()
LV_GetText(RowType, RowNumber, 6)
If (RowType = cType47)
	LV_Modify(RowNumber, "Check")
If (!RowNumber)
	return
Critical, Off
GoSub, Edit
Tooltip
return

GuiContextMenu:
If (Dest_Row)
	return
MouseGetPos,,,, cHwnd, 2
If (cHwnd = ListID%A_List%)
	Menu, EditMenu, Show, %A_GuiX%, %A_GuiY%
Else If (cHwnd = TabSel)
{
	If (ClickedTab := TabGet())
	{
		GuiControl, chMacro:Choose, A_List, %ClickedTab%
		Menu, TabMenu, Add, %c_Lang022%, TabClose
	}
	Menu, TabMenu, Add, %w_Lang019%, EditMacros
	Menu, TabMenu, Show
	Menu, TabMenu, DeleteAll
	GoSub, TabSel
	ClickedTab := ""
}
Else
{
	tbPtr := TB_GetHwnd(cHwnd)
	If (IsObject(tbPtr))
	{
		If ((tbPtr.tbHwnd = htbPrev) || (tbPtr.tbHwnd = htbPrevF))
			return
		Menu, TbMenu, Add, %w_Lang091%, Customize
		Menu, TbMenu, Add, %w_Lang094%, TbHide
		Menu, TbMenu, Show
		Menu, TbMenu, DeleteAll
	}
}
return

TbCustomize:
bID := RBIndexTB[A_ThisMenuItemPos]
tBand := RbMain.IDToIndex(bID), RbMain.GetBand(tBand,,,,,,, cHwnd)
tbPtr := TB_GetHwnd(cHwnd), tbPtr.Customize()
GoSub, SetIdealSize
return

Customize:
tbPtr.Customize(), TB_IdealSize(tbFile, TbFile_ID)
GoSub, SetIdealSize
return

SetIdealSize:
TB_IdealSize(tbRecPlay, TbRecPlay_ID), TB_IdealSize(tbCommand, TbCommand_ID)
TB_IdealSize(tbEdit, TbEdit_ID), TB_IdealSize(tbSettings, TbSettings_ID)
return

TbHide:
For _each, Ptr in TBHwndAll
{
	If (Ptr.tbHwnd = tbPtr.tbHwnd)
	{
		bID := RBIndexTB[_each]
		break
	}
}
GoSub, ShowHideBandOn
return

DuplicateList:
Critical
Gui, chMacro:Default
Gui, chMacro:Submit, NoHide
s_List := A_List
GuiControlGet, c_Time, chTimes:, TimesG
GoSub, TabPlus
GuiControl, chMacro:-g, InputList%TabCount%
LVManager[A_List].SetData(, LVManager[s_List].GetData())
LVManager[A_List].ClearHistory()
GuiControl, chTimes:, TimesG, %c_Time%
GuiControl, chMacro:+gInputList, InputList%A_List%
GoSub, b_Enable
GoSub, RowCheck
HistCheck()
GuiControl, chMacro:+Redraw, InputList%A_List%
Gosub, PrevRefresh
return

CopyList:
If (IsMacrosMenu)
{
	GuiControl, chMacro:Choose, A_List, %A_ThisMenuItemPos%
	GoSub, TabSel
	return
}
Critical
Gui, chMacro:Default
Gui, chMacro:Submit, NoHide
Gui, chMacro:ListView, InputList%A_List%
s_List := A_List, d_List := A_ThisMenuItemPos, RowSelection := LV_GetCount("Selected")
RowNumber := 0
If RowSelection = 0
{
	Loop, % ListCount%s_List%
	{
		RowNumber++
		Gui, chMacro:ListView, InputList%s_List%
		LV_GetTexts(RowNumber, Action, Details, TimesX, DelayX, Type, Target, Window, Comment, Color)
		ckd := (LV_GetNext(RowNumber-1, "Checked")=RowNumber) ? 1 : 0
		Gui, chMacro:ListView, InputList%d_List%
		LV_Add("Check" ckd, ListCount%d_List%+1, Action, Details, TimesX, DelayX, Type, Target, Window, Comment, Color)
	}
}
Else
{
	Loop, %RowSelection%
	{
		Gui, chMacro:ListView, InputList%s_List%
		RowNumber := LV_GetNext(RowNumber)
		LV_GetTexts(RowNumber, Action, Details, TimesX, DelayX, Type, Target, Window, Comment, Color)
		ckd := (LV_GetNext(RowNumber-1, "Checked")=RowNumber) ? 1 : 0
		Gui, chMacro:ListView, InputList%d_List%
		LV_Add("Check" ckd, ListCount%d_List%+1, Action, Details, TimesX, DelayX, Type, Target, Window, Comment, Color)
	}
}
Gui, chMacro:ListView, InputList%d_List%
ListCount%d_List% := LV_GetCount()
HistCheck(d_List)
GoSub, RowCheck
Gui, chMacro:ListView, InputList%s_List%
GuiControl, Focus, InputList%A_List%
return

Duplicate:
Critical
Gui, chMacro:Default
Gui, chMacro:Submit, NoHide
GuiControl, chMacro:-g, InputList%A_List%
RN := 0
Loop, % LV_GetCount("Selected")
	RN := LV_GetNext(RN), LVManager[A_List].InsertAtGroup(RN)
If (LVCopier.Duplicate())
{
	GoSub, RowCheck
	GoSub, b_Start
}
GuiControl, chMacro:+gInputList, InputList%A_List%
If (AutoRefresh)
	GoSub, PrevRefresh
return

CopyRows:
Critical
Gui, chMacro:Default
Gui, chMacro:Submit, NoHide
If (LV_GetCount("Selected") = 0)
	return
InMemoryRows := LVCopier.Copy()
return

CutRows:
Critical
Gui, chMacro:Default
Gui, chMacro:Submit, NoHide
GuiControl, chMacro:-g, InputList%A_List%
If (LV_GetCount("Selected") = 0)
{
	GuiControl, chMacro:+gInputList, InputList%A_List%
	return
}
InMemoryRows := LVCopier.Cut()
GoSub, RowCheck
GoSub, b_Start
GuiControl, chMacro:+gInputList, InputList%A_List%
If (AutoRefresh)
	GoSub, PrevRefresh
return

PasteRows:
Critical
Gui, chMacro:Default
Gui, chMacro:Submit, NoHide
GuiControl, chMacro:-g, InputList%A_List%
If (!InMemoryRows)
	return
RN := 0
Loop, % LV_GetCount("Selected")
{
	RN := LV_GetNext(RN)
	Loop, %InMemoryRows%
		LVManager[A_List].InsertAtGroup(RN)
}
If (LVCopier.Paste(, true))
{
	GoSub, RowCheck
	GoSub, b_Start
}
GuiControl, chMacro:+gInputList, InputList%A_List%
If (AutoRefresh)
	GoSub, PrevRefresh
return

Remove:
Critical
Gui, chMacro:Default
Gui, chMacro:Submit, NoHide
GuiControl, chMacro:-g, InputList%A_List%
RowSelection := LV_GetCount("Selected"), TotalRows := LV_GetCount()
If (RowSelection = 0)
{
	LV_GetText(Type, 1, 6)
	If ((Type != cType47) && (Type != cType48))
	{
		GuiControl, chMacro:+gInputList, InputList%A_List%
		return
	}
	LV_Delete()
	LVManager[A_List].RemoveAllGroups(c_Lang061)
}
Else If (RowSelection = TotalRows)
{
	LV_Delete()
}
Else
{
	PrevState := AutoRefresh
	AutoRefresh := 0
	LVManager[A_List].Delete()
	AutoRefresh := PrevState
}
LV_Modify(LV_GetNext(0, "Focused"), "Select")
GoSub, RowCheck
GoSub, b_Start
GuiControl, chMacro:+gInputList, InputList%A_List%
If (AutoRefresh)
	GoSub, PrevRefresh
return

MoveCopy:
Menu, MoveCopy, Add, %w_Lang095%, MoveHere
Menu, MoveCopy, Add, %w_Lang096%, CopyHere
Menu, MoveCopy, Add
Menu, MoveCopy, Add, %c_Lang021%, NoKey
Menu, MoveCopy, Default, %w_Lang095%
Menu, MoveCopy, Show
Menu, MoveCopy, DeleteAll
Gui, MarkLine:Cancel
GoSub, RowCheck
GoSub, b_Start
Dest_Row := ""
return

CopyHere:
Critical
Gui, chMacro:Default
Gui, chMacro:Submit, NoHide
GuiControl, chMacro:-g, InputList%A_List%
TempData := new LV_Rows()
TempData.Copy()
TempData.Paste(Dest_Row)
TempData := ""
LVManager[A_List].RefreshGroups()
GuiControl, chMacro:+gInputList, InputList%A_List%
If (AutoRefresh)
	GoSub, PrevRefresh
return

MoveHere:
Critical
Gui, chMacro:Default
Gui, chMacro:Submit, NoHide
GuiControl, chMacro:-g, InputList%A_List%
TempData := new LV_Rows()
TempData.Copy()
TempData.Paste(Dest_Row)
TempData.Delete()
TempData := ""
LVManager[A_List].RefreshGroups()
GuiControl, chMacro:+gInputList, InputList%A_List%
If (AutoRefresh)
	GoSub, PrevRefresh
return

Undo:
Critical
Gui, 1:Submit, NoHide
Gui, chMacro:Default
Gui, chMacro:Submit, NoHide
Gui, chMacro:Listview, InputList%A_List%
GuiControl, chMacro:-Redraw, InputList%A_List%
GuiControl, chMacro:-g, InputList%A_List%
SelRow := LV_GetNext(0, "Focused")
If (LVManager[A_List].Undo())
{
	SelRow ? LV_Modify(SelRow, "Select Focus Vis") : ""
	GoSub, RowCheck
	GoSub, b_Enable
}
GuiControl, chMacro:+gInputList, InputList%A_List%
GuiControl, chMacro:+Redraw, InputList%A_List%
If (AutoRefresh)
	GoSub, PrevRefresh
return

Redo:
Critical
Gui, 1:Submit, NoHide
Gui, chMacro:Default
Gui, chMacro:Submit, NoHide
Gui, chMacro:Listview, InputList%A_List%
GuiControl, chMacro:-Redraw, InputList%A_List%
GuiControl, chMacro:-g, InputList%A_List%
SelRow := LV_GetNext(0, "Focused")
If (LVManager[A_List].Redo())
{
	SelRow ? LV_Modify(SelRow, "Select Focus Vis")
	GoSub, RowCheck
	GoSub, b_Enable
}
GuiControl, chMacro:+gInputList, InputList%A_List%
GuiControl, chMacro:+Redraw, InputList%A_List%
If (AutoRefresh)
	GoSub, PrevRefresh
return

TabPlus:
Gui, 1:Submit, NoHide
Gui, chMacro:Default
Gui, chMacro:Font, s%MacroFontSize%
Gui, chMacro:Submit, NoHide
If (TabCount = 256)
	return
Try Menu, CopyTo, Uncheck, % CopyMenuLabels[A_List]
ColOrder := LVOrder_Get(11, ListID%A_List%), AllTabs := "", TabName := ""
Loop, %TabCount%
	AllTabs .= CopyMenuLabels[A_Index] ","
While (InStr(AllTabs, TabName ","))
	TabName := "Macro" TabCount+A_Index
TabCount++
GuiControl, chMacro:, %TabSel%, %TabName%
CopyMenuLabels[TabCount] := TabName
GuiControl, chMacro:Choose, A_List, %TabCount%
GoSub, SaveData
Gui, chMacro:Submit, NoHide
GuiAddLV(TabCount)
Gui, chMacro:ListView, InputList%A_List%
GoSub, LoadData
LVManager[A_List] := new LV_Rows(ListID%A_List%)
LVManager[A_List].Add()
GoSub, chMacroGuiSize
Menu, CopyTo, Add, % CopyMenuLabels[TabCount], CopyList, Radio
Try Menu, CopyTo, Check, % CopyMenuLabels[A_List]
GuiControl, 28:+Range1-%TabCount%, OSHK
SavePrompt(true, A_ThisLabel)

TabSel:
GoSub, SaveData
Gui, 1:Submit, NoHide
Try Menu, CopyTo, Uncheck, % CopyMenuLabels[A_List]
Gui, chMacro:Default
Gui, chMacro:Submit, NoHide
Gui, chMacro:ListView, InputList%A_List%
GoSub, PrevRefresh
GoSub, chMacroGuiSize
GoSub, LoadData
GoSub, RowCheck
GuiControl, 28:, OSHK, %A_List%
Try Menu, CopyTo, Check, % CopyMenuLabels[A_List]
GuiControl, chMacro:Focus, InputList%A_List%
If (InStr(CopyMenuLabels[A_List], "()"))
	GoSub, FuncTab
Else
	GoSub, MacroTab
return

TabClose:
Gui, 1:+OwnDialogs
GoSub, SaveData
GoSub, ResetHotkeys
Gui, 1:Submit, NoHide
If (TabCount = 1)
	return
c_List := ClickedTab ? ClickedTab : A_List
If ((ConfirmDelete) && (ListCount%c_List% > 0))
{

	Gui, 1:+Disabled
	Gui, 35:-SysMenu hwndCloseTab +owner1
	Gui, 35:Color, FFFFFF
	Gui, 35:Add, Pic, y+20 Icon78 W48 H48, %ResDllPath%
	Gui, 35:Add, Text, -Wrap R1 Section yp x+10 W250, %d_Lang020%`n
	Gui, 35:Add, Checkbox, Checked -Wrap xs W250 R1 vConfirmDelete cGray, %t_Lang151%
	Gui, 35:Add, Button, -Wrap Section Default xs y+10 W90 H23 gConfirmDel, %c_Lang020%
	Gui, 35:Add, Button, -Wrap ys W90 H23 gTipClose2, %c_Lang021%
	GuiControl, 35:Focus, %c_Lang020%
	Gui, 35:Show,, %AppName%
	WinWaitClose, ahk_id %CloseTab%
	return
}
ConfirmDel:
Critical
Gui, 1:-Disabled
Gui, 35:Submit
Gui, 35:Destroy
Menu, CopyTo, Uncheck, % CopyMenuLabels[A_List]
Gui, chMacro:Default
Gui, chMacro:Submit, NoHide
Menu, CopyTo, Delete, % CopyMenuLabels[c_List]
CopyMenuLabels.RemoveAt(c_List)
o_MacroContext.RemoveAt(c_List)
s_Tab := c_List
Loop, %TabCount%
	GuiControl, chMacro:-g, InputList%A_Index%
Loop, % TabCount - c_List
{
	n_Tab := s_Tab+1
	LVManager[s_Tab].SetData(, LVManager[n_Tab].GetData())
	Labels .= CopyMenuLabels[s_Tab] "|"
	s_Tab++
}
Gui, chMacro:ListView, InputList%TabCount%
LV_Delete()
LVManager.RemoveAt(TabCount)
If (c_List != TabCount)
{
	o_AutoKey.RemoveAt(c_List)
	o_ManKey.RemoveAt(c_List)
	o_TimesG.RemoveAt(c_List)
}
s_List := ""
ListCount%TabCount% := 0
TabCount--
Loop, %TabCount%
{
	s_List .= CopyMenuLabels[A_Index] "|"
	GuiControl, chMacro:+gInputList, InputList%A_Index%
}
Gui, chMacro:ListView, InputList%A_List%
GuiControl, chMacro:, A_List, |%s_List%
GuiControl, chMacro:Choose, A_List, % (A_List < TabCount) ? A_List : TabCount
Gui, chMacro:Submit, NoHide
GoSub, LoadData
GoSub, TabSel
SavePrompt(true, A_ThisLabel)
return

FuncTab:
GuiControl, 1:, AutoKey
GuiControl, 1:, ManKey
GuiControl, 1:, JoyKey
GuiControl, chTimes:, TimesG, 1
GuiControl, 1:Disable, AutoKey
GuiControl, 1:Disable, ManKey
GuiControl, 1:Disable, JoyKey
o_MacroContext[A_List] := {"Condition": "None", "Context": ""}
GuiControl, 1:, THotkeyTip, <a>Hotkey</a>:
GuiControl, 1:, MacroContextTip, Macro <a>#If</a>: None
GuiControl, chTimes:Disable, TimesG
GuiControl, chTimes:Disable, ReptC
Menu, FuncMenu, Enable, %u_Lang002%`t%_s%Ctrl+Shift+P
Menu, FuncMenu, Enable, %u_Lang003%`t%_s%Ctrl+Shift+N
Menu, FuncMenu, Disable, %u_Lang004%`t%_s%Ctrl+Shift+C
TB_Edit(TbEdit, "FuncParameter",, 1), TB_Edit(TbEdit, "FuncReturn",, 1)
If (!IsFunc(LVManager[A_List].Callback))
	LVManager[A_List].SetCallback("LVCallback")
return

MacroTab:
GuiControl, 1:Enable, AutoKey
GuiControl, 1:Enable, ManKey
GuiControl, 1:Enable, JoyKey
GuiControl, 1:, THotkeyTip, % "<a>Hotkey</a>: " o_AutoKey[A_List]
GuiControl, 1:, MacroContextTip, % "Macro <a>#If</a>: " o_MacroContext[A_List].Condition
GuiControl, chTimes:Enable, TimesG
GuiControl, chTimes:Enable, ReptC
Menu, FuncMenu, Disable, %u_Lang002%`t%_s%Ctrl+Shift+P
Menu, FuncMenu, Disable, %u_Lang003%`t%_s%Ctrl+Shift+N
Menu, FuncMenu, Enable, %u_Lang004%`t%_s%Ctrl+Shift+C
TB_Edit(TbEdit, "FuncParameter",, 0), TB_Edit(TbEdit, "FuncReturn",, 0)
return

MacrosMenu:
IsMacrosMenu := true
ControlGetPos, CtrPosX, CtrPosY,, CtrlPosH,, ahk_id %hMacrosMenu%
Menu, CopyTo, Show, %CtrPosX%, % CtrPosY + CtrlPosH
IsMacrosMenu := false
return

SaveData:
Gui, 1:Default
If ((A_GuiControl = "AutoKey") || (A_GuiControl = "TimesG"))
	SavePrompt(true, A_ThisLabel)
If (JoyHK = 1)
{
	GuiControlGet, HK_AutoKey, 1:, JoyKey
	If (!RegExMatch(HK_AutoKey, "i)Joy\d+$"))
		HK_AutoKey := ""
}
Else
	GuiControlGet, HK_AutoKey, 1:, AutoKey
GuiControlGet, ManKey, 1:, ManKey
GuiControlGet, TimesO, chTimes:, TimesG
If ((HK_AutoKey = "") && (!HotkeyCtrlHasFocus()))
	HK_AutoKey := StrReplace(o_AutoKey[A_List], "#")
o_AutoKey[A_List] := (WinKey = 1) ? "#" HK_AutoKey : HK_AutoKey
If (o_AutoKey[A_List] = "#")
	o_AutoKey[A_List] := "LWin"
o_ManKey[A_List] := ManKey, o_TimesG[A_List] := TimesO
GuiControl, 1:, THotkeyTip, % "<a>Hotkey</a>: " o_AutoKey[A_List]
return

LoadData:
Gui, 1:Default
If (InStr(o_AutoKey[A_List], "Joy"))
{
	TB_Edit(TbSettings, "SetJoyButton", JoyHK := 1)
	GuiControl, 1:, AutoKey
	GoSub, SetJoyHK
}
Else
{
	TB_Edit(TbSettings, "SetJoyButton", JoyHK := 0)
	GuiControl, 1:, JoyKey
	GuiControl, 1:, AutoKey, % StrReplace(o_AutoKey[A_List], "#")
	GoSub, SetNoJoy
}
WinKey := InStr(o_AutoKey[A_List], "#") ? 1 : 0
TB_Edit(TbSettings, "WinKey", WinKey)
GuiControl, 1:, ManKey, % o_ManKey[A_List]
GuiControl, chTimes:, TimesG, % (o_TimesG[A_List] = "") ? 1 : o_TimesG[A_List]
return

AutoComplete:
CbAutoComplete()
If (A_GuiControl = "AutoKeyL")
{
	Gui, 33:Submit, NoHide
	If (AutoKeyL = "")
		GuiControl, 33:Enable, AutoKey
	Else
		GuiControl, 33:Disable, AutoKey
}
return

FindInList:
CbAutoComplete()
Gui, Submit, NoHide
CoordMode, Tooltip, Window
GuiControlGet, CBPos, Pos, FindList
Tooltip, % SBShowTip(FindList), %CBPosX%, % CBPosY + CBPosH * 4
return

GoToFind:
Gui, Submit, NoHide
If (FindList = "")
	return
FoundResults := Find_Command(FindList, true)
If (FoundResults.Length() = 1)
{
	GotoRes1 := FoundResults[1].Cmd, GotoRes2 := FoundResults[1].Path
	Goto, GotoResult
}
GoSub, CmdFind
GuiControl,, FindCmd, %FindList%
GoSub, FindCmd
return

GetHotkeys:
AutoKey := "", ManKey := ""
For _each, _key in o_AutoKey
	AutoKey .= _key "|"
For _each, _key in o_ManKey
	ManKey .= _key "|"
AutoKey := RTrim(AutoKey, "|"), ManKey := RTrim(ManKey, "|")
return

MoveUp:
Gui, chMacro:Default
GuiControl, chMacro:-Redraw, InputList%A_List%
LVManager[A_List].Move(1)
GoSub, RowCheck
GoSub, b_Enable
HistCheck()
GuiControl, chMacro:+Redraw, InputList%A_List%
return

MoveDn:
Gui, chMacro:Default
GuiControl, chMacro:-Redraw, InputList%A_List%
LVManager[A_List].Move()
GoSub, RowCheck
GoSub, b_Enable
HistCheck()
GuiControl, chMacro:+Redraw, InputList%A_List%
return

DelLists:
StopIt := 1
OnMessage(WM_NOTIFY, ""), LV_Colors.Detach(ListID%A_List%)
Gui, chMacro:Default
Loop, %TabCount%
{
	Gui, chMacro:ListView, InputList%A_Index%
	LV_Delete()
	LVManager[A_Index].RemoveAllGroups(c_Lang061)
	LVManager[A_Index].ClearHistory()
	ListCount%A_Index% := 0
	GuiControl, chMacro:+Redraw, InputList%A_Index%
	Try Menu, CopyTo, Delete, % CopyMenuLabels[A_Index]
}
CopyMenuLabels[1] := "Macro1"
Menu, CopyTo, Add, % CopyMenuLabels[1], CopyList, Radio
Menu, CopyTo, Check, % CopyMenuLabels[1]
Gosub, ResetHotkeys
Gosub, ClearTimers
UserDefFunctions := SyHi_UserDef " ", SetUserWords(UserDefFunctions)
DebugCheckError := False
DebugCheckLoop := []
DebugCheckIf := []
DebugDefault := []
return

SelectAll:
Gui, chMacro:Default
LV_Modify(0, "Select")
return

SelectNone:
Gui, chMacro:Default
LV_Modify(0, "-Select")
return

MoveSelDn:
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected")
If (RowSelection = 0)
	return
RowNumber := 0, SelectedRows := ""
Loop, % RowSelection
{
	RowNumber := LV_GetNext(RowNumber)
	SelectedRows := RowNumber "|" SelectedRows
}
SelectedRows := RTrim(SelectedRows, "|")
Loop, Parse, SelectedRows, |
{
	LV_Modify(A_LoopField+1, "Select")
	LV_Modify(A_LoopField, "-Select")
}
return

MoveSelUp:
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected")
If (RowSelection = 0)
	return
RowNumber := 0
Loop, % RowSelection
{
	RowNumber := LV_GetNext(RowNumber)
	LV_Modify(RowNumber, "-Select")
	If (RowNumber > 1)
		LV_Modify(RowNumber-1, "Select")
}
return

InvertSel:
Gui, chMacro:Default
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
Gui, chMacro:Default
GuiControl, chMacro:-g, InputList%A_List%
RowNumber := 0
Loop
{
	RowNumber := LV_GetNext(RowNumber)
	If (!RowNumber)
		break
	LV_Modify(RowNumber, "Check")
}
HistCheck(A_List)
GuiControl, chMacro:+gInputList, InputList%A_List%
return

UnCheckSel:
Gui, chMacro:Default
GuiControl, chMacro:-g, InputList%A_List%
RowNumber := 0
Loop
{
	RowNumber := LV_GetNext(RowNumber)
	If (!RowNumber)
		break
	LV_Modify(RowNumber, "-Check")
}
HistCheck(A_List)
GuiControl, chMacro:+gInputList, InputList%A_List%
return

InvertCheck:
Gui, chMacro:Default
GuiControl, chMacro:-g, InputList%A_List%
RowNumber := 0
Loop
{
	RowNumber := LV_GetNext(RowNumber)
	If (!RowNumber)
		break
	If (LV_GetNext(RowNumber-1, "Checked")=RowNumber)
		LV_Modify(RowNumber, "-Check")
	Else
		LV_Modify(RowNumber, "Check")
}
HistCheck(A_List)
GuiControl, chMacro:+gInputList, InputList%A_List%
return

SelectCmd:
Gui, chMacro:Default
SelectByType(A_ThisMenuItem)
return

SelType:
Gui, chMacro:Default
SelectedRow := LV_GetNext()
LV_GetText(SelType, SelectedRow, 6)
SelectByType(SelType)
return

BarInfo:
GuiControl, 1:Hide, Repeat
GuiControl, 1:Hide, Rept
GuiControl, 1:Hide, TimesM
GuiControl, 1:Hide, ApplyT
GuiControl, 1:Hide, Separator1
GuiControl, 1:Hide, DelayT
GuiControl, 1:Hide, Delay
GuiControl, 1:Hide, DelayG
GuiControl, 1:Hide, ApplyI
GuiControl, 1:Hide, Separator2
GuiControl, 1:Hide, sInput
GuiControl, 1:Hide, ApplyL
GuiControl, 1:Hide, InsertKey
GuiControl, 1:Show, THotkeyTip
GuiControl, 1:Show, Separator3
GuiControl, 1:Show, ContextTip
GuiControl, 1:Show, Separator4
GuiControl, 1:Show, MacroContextTip
GuiControl, 1:Show, Separator5
GuiControl, 1:Show, CoordTip
GuiControl, 1:Show, Separator6
GuiControl, 1:Show, TModeTip
GuiControl, 1:Show, Separator7
GuiControl, 1:Show, TSendModeTip
GuiControl, 1:Show, Separator8
GuiControl, 1:Show, TLastMacroTip
GuiControl, 1:, BarEdit, 0
GuiControl, 1:, BarInfo, 1
Gui, 1:Submit, NoHide
return

BarEdit:
GuiControl, 1:Show, Repeat
GuiControl, 1:Show, Rept
GuiControl, 1:Show, TimesM
GuiControl, 1:Show, ApplyT
GuiControl, 1:Show, Separator1
GuiControl, 1:Show, DelayT
GuiControl, 1:Show, Delay
GuiControl, 1:Show, DelayG
GuiControl, 1:Show, ApplyI
GuiControl, 1:Show, Separator2
GuiControl, 1:Show, sInput
GuiControl, 1:Show, ApplyL
GuiControl, 1:Show, InsertKey
GuiControl, 1:Hide, THotkeyTip
GuiControl, 1:Hide, Separator3
GuiControl, 1:Hide, ContextTip
GuiControl, 1:Hide, Separator4
GuiControl, 1:Hide, MacroContextTip
GuiControl, 1:Hide, Separator5
GuiControl, 1:Hide, CoordTip
GuiControl, 1:Hide, Separator6
GuiControl, 1:Hide, TModeTip
GuiControl, 1:Hide, Separator7
GuiControl, 1:Hide, TSendModeTip
GuiControl, 1:Hide, Separator8
GuiControl, 1:Hide, TLastMacroTip
GuiControl, 1:, BarInfo, 0
GuiControl, 1:, BarEdit, 1
Gui, 1:Submit, NoHide
return

ApplyT:
Gui, 1:Submit, NoHide
Gui, chMacro:Default
ApplyTEd:
RowSelection := LV_GetCount("Selected")
If (RowSelection = 0)
	LV_Modify(0, "Col4", (InStr(Rept, "%") ? Rept : TimesM))
Else
{
	RowNumber := 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Modify(RowNumber, "Col4", (InStr(Rept, "%") ? Rept : TimesM))
	}
}
GoSub, RowCheck
GoSub, b_Start
return

ApplyI:
Gui, 1:Submit, NoHide
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected")
If (RowSelection = 0)
	LV_Modify(0, "Col5", (InStr(Delay, "%") ? Delay : DelayG))
Else
{
	RowNumber := 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Modify(RowNumber, "Col5", (InStr(Delay, "%") ? Delay : DelayG))
	}
}
GoSub, RowCheck
GoSub, b_Start
return

ApplyIEd:
RowSelection := LV_GetCount("Selected")
If (IncrementDelay)
{
	If (RowSelection = 0)
	{
		Loop, % LV_GetCount()
		{
			LV_GetText(RowDelay, A_Index, 5)
			NewDelay := RowDelay + DelayX
			LV_Modify(A_Index, "Col5", NewDelay > 0 ? NewDelay : 0)
		}
	}
	Else
	{
		RowNumber := 0
		Loop, %RowSelection%
		{
			RowNumber := LV_GetNext(RowNumber)
			LV_GetText(RowDelay, RowNumber, 5)
			NewDelay := RowDelay + DelayX
			LV_Modify(RowNumber, "Col5", NewDelay > 0 ? NewDelay : 0)
		}
	}
}
Else
{
	If (RowSelection = 0)
		LV_Modify(0, "Col5", (InStr(Delay, "%") ? Delay : DelayX))
	Else
	{
		RowNumber := 0
		Loop, %RowSelection%
		{
			RowNumber := LV_GetNext(RowNumber)
			LV_Modify(RowNumber, "Col5", (InStr(Delay, "%") ? Delay : DelayX))
		}
	}
}
GoSub, RowCheck
GoSub, b_Start
return

ApplyL:
Gui, 1:Submit, NoHide
Gui, chMacro:Default
StringReplace, sInput, sInput, SC15D, AppsKey
StringReplace, sInput, sInput, SC145, NumLock
StringReplace, sInput, sInput, SC154, PrintScreen
If (sInput = "")
	return
sKey := RegExReplace(sInput, "(.$)", "$l1"), tKey := sKey
GoSub, Replace
sKey := "{" sKey "}", RowSelection := LV_GetCount("Selected"), LV_GetText(RowType, LV_GetNext(), 6)
If ((RowSelection = 0) || ((RowType = cType47) || RowType = cType48))
{
	LV_Add("Check", ListCount%A_List%+1, tKey, sKey, 1, DelayG, cType1)
	GoSub, b_Start
	LV_Modify(ListCount%A_List%, "Vis")
}
Else
{
	GuiControl, chMacro:-g, InputList%A_List%
	RowNumber := 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Insert(RowNumber, "Check", RowNumber, tKey, sKey, 1, DelayG, cType1)
		LVManager[A_List].InsertAtGroup(RowNumber)
		RowNumber++
	}
	GuiControl, chMacro:+gInputList, InputList%A_List%
}
GoSub, RowCheck
GoSub, b_Start
return

InsertKey:
Gui 7:+LastFoundExist
IfWinExist
	GoSub, InsertKeyClose
Gui, 1:Submit, NoHide
Gui, chMacro:Default
If (A_GuiControl = "InsertKeyT")
{
	Gui, 7:+owner8 +ToolWindow +Delimiter%_x%
	InsertToText := true
}
Else
{
	Gui, 7:+owner1 +ToolWindow +Delimiter%_x%
	InsertToText := false
}
Gui, 7:Add, Groupbox, Section W360 H240
Gui, 7:Add, ListBox, ys+15 xs+10 W200 H220 vsKey gInsertThisKey, %KeybdList%
Gui, 7:Add, Radio, -Wrap R1 Checked yp x+10 W130 vKeystroke, %t_Lang108%
Gui, 7:Add, Radio, -Wrap R1 W130 vKeyDown, %t_Lang109%
Gui, 7:Add, Radio, -Wrap R1 W130 vKeyUp, %t_Lang110%
If (!InsertToText)
{
	Gui, 7:Add, Text, -Wrap R1 y+20, %w_Lang015%:
	Gui, 7:Add, Edit, W120 R1 vEdRept
	Gui, 7:Add, UpDown, vTimesX 0x80 Range1-999999999, 1
	Gui, 7:Add, Text,, %c_Lang017%:
	Gui, 7:Add, Edit, W120 vDelayC
	Gui, 7:Add, UpDown, vDelayX 0x80 Range0-999999999, %DelayG%
	Gui, 7:Add, Radio, -Wrap Checked W125 vMsc R1, %c_Lang018%
	Gui, 7:Add, Radio, -Wrap W125 vSec R1, %c_Lang019%
}
Gui, 7:Add, Button, -Wrap Section Default xm W75 H23 gInsertKeyOK, %w_Lang018%
Gui, 7:Add, Button, -Wrap ys W75 H23 gInsertKeyClose, %c_Lang022%
Gui, 7:Show,, %t_Lang111%
return

InsertThisKey:
If (A_GuiEvent != "DoubleClick")
	return
InsertKeyOK:
Gui, 7:Submit, NoHide
If (KeyDown)
	State := " Down"
Else If (KeyUp)
	State := " Up"
Else
	State := ""
tKey := sKey, sKey := "{" sKey State "}"
If (InsertToText)
	Control, EditPaste, %sKey%, Edit1, ahk_id %CmdWin%
Else
{
	DelayX := InStr(DelayC, "%") ? DelayC : DelayX
	If (Sec = 1)
		DelayX *= 1000
	TimesX := InStr(EdRept, "%") ? EdRept : TimesX
	If (TimesX = 0)
		TimesX := 1
	Gui, chMacro:Default
	RowSelection := LV_GetCount("Selected"), LV_GetText(RowType, LV_GetNext(), 6)
	If ((RowSelection = 0) || ((RowType = cType47) || RowType = cType48))
	{
		LV_Add("Check", ListCount%A_List%+1, tKey, sKey, TimesX, DelayX, cType1)
		GoSub, b_Start
		LV_Modify(ListCount%A_List%, "Vis")
	}
	Else
	{
		GuiControl, chMacro:-g, InputList%A_List%
		RowNumber := 0
		Loop, %RowSelection%
		{
			RowNumber := LV_GetNext(RowNumber)
			LV_Insert(RowNumber, "Check", RowNumber, tKey, sKey, TimesX, DelayX, cType1)
			LVManager[A_List].InsertAtGroup(RowNumber)
			RowNumber++
		}
		GuiControl, chMacro:+gInputList, InputList%A_List%
	}
	GoSub, RowCheck
	GoSub, b_Start
}
return

InsertKeyClose:
7GuiClose:
7GuiEscape:
Gui, 7:Destroy
InsertToText := false
return

EditButton:
Gui, 1:Submit, NoHide
Gui, chMacro:Default
RowSelection := LV_GetCount("Selected"), RowNumber := LV_GetNext()
If (RowSelection = 1)
	GoSub, Edit
Else
	GoSub, MultiEdit
return

GoToLastMacro:
GuiControl, chMacro:Choose, A_List, %LastMacroRun%
GoSub, TabSel
return

EditSelectedMacro:
EditMacros:
Input
Gui, 1:Submit, NoHide
GoSub, SaveData
Gui, 32:+Resize -MinimizeBox +MinSize690x300 +owner1 +HwndLVEditMacros
Gui, 1:+Disabled
Gui, 32:Add, GroupBox, Section W450 H240 vEMGroup
Gui, 32:Add, ListView, ys+15 xs+10 W430 r10 hwndMacroL vMacroList gMacroList -ReadOnly NoSort AltSubmit LV0x4000, %t_Lang147%|%w_Lang005%|%w_Lang007%|%t_Lang003%|#If|%w_Lang030%
Gui, 32:Add, Text, -Wrap W430 vLabel1, %t_Lang144%
Gui, 32:Add, Button, -Wrap Section xm W75 H23 vEditMacrosOK gEditMacrosOK, %c_Lang020%
Gui, 32:Add, Button, -Wrap ys W75 H23 vEditMacrosCancel gEditMacrosCancel, %c_Lang021%
Gui, 32:Default
Loop, %TabCount%
	LV_Add("", CopyMenuLabels[A_Index], o_AutoKey[A_Index], o_ManKey[A_Index], o_TimesG[A_Index], o_MacroContext[A_Index].Condition " " o_MacroContext[A_Index].Context, A_Index)
LV_ModifyCol(1, 100)	; Macros
LV_ModifyCol(2, 100)	; Play
LV_ModifyCol(3, 100)	; Manual
LV_ModifyCol(4, 60)		; Loop
LV_ModifyCol(5, 200)	; Context
LV_ModifyCol(6, 45)		; Index
LV_Modify(A_List, "Select Vis")
Gui, 32:Show, W690 H500, %t_Lang145%

If (A_ThisLabel = "EditSelectedMacro")
	Goto, MacroListEdit
return

32GuiSize:
GuiGetSize(GuiWidth, GuiHeight, 32)
GuiControl, 32:Move, EMGroup, % "W" GuiWidth-20 "H" GuiHeight-40
GuiControl, 32:Move, MacroList, % "W" GuiWidth-40 "H" GuiHeight-80
GuiControl, 32:Move, Label1, % "Y" GuiHeight-55
GuiControl, 32:Move, EditMacrosOK, % "Y" GuiHeight-28
GuiControl, 32:Move, EditMacrosCancel, % "Y" GuiHeight-28
return

EditMacrosOK:
GuiControl, 32:Disable, MacroList
GuiControl, 32:Disable, EditMacrosOK
GuiControl, 32:Disable, EditMacrosCancel
Critical
Gui, 32:Submit, NoHide
Project := [], Labels := "", ActiveList := A_List
Sleep, 10
Gui, 32:Default
Loop, %TabCount%
{
	LV_GetText(Macro, A_Index, 1)
	LV_GetText(AutoKey, A_Index, 2)
	LV_GetText(ManKey, A_Index, 3)
	LV_GetText(TimesX, A_Index, 4)
	LV_GetText(Context, A_Index, 5)
	LV_GetText(IndexN, A_Index, 6)
	RegExMatch(Context, "O)(\w+)\s(.*)", MContext)
	Labels .= ((Macro != "") ? Macro : "Macro" IndexN) "|"
	o_AutoKey[A_Index] := AutoKey
	If ((RegExMatch(o_AutoKey[A_Index], "^:.*?:")) && (!RegExMatch(o_AutoKey[A_Index], "^:.*X.*?:")))
		o_AutoKey[A_Index] := RegExReplace(o_AutoKey[A_Index], "^:(.*?):", ":X$1:")
	o_ManKey[A_Index] := ManKey
	o_TimesG[A_Index] := TimesX
	o_MacroContext[A_Index].Condition := MContext[1]
	o_MacroContext[A_Index].Context := MContext[2]
	Project.Push(LVData := LVManager[IndexN].GetData())
	If (IndexN = ActiveList)
		NewActive := A_Index
	Sleep, 10
}
ActiveList := NewActive
Gui, chMacro:Default
GpConfig := ShowGroups, ShowGroups := false
LVManager[A_List].EnableGroups(false)
Loop, %TabCount%
	GuiControl, chMacro:-g, InputList%A_Index%
Loop, %TabCount%
	LVManager[A_Index].SetData(, Project[A_Index])
Loop, %TabCount%
	GuiControl, chMacro:+gInputList, InputList%A_Index%
GuiControl, chMacro:, A_List, |%Labels%
CopyMenuLabels := StrSplit(Trim(Labels, "|"), "|")
Loop, %TabCount%
{
	Gui, chMacro:ListView, InputList%A_Index%
	A_List := A_Index
	GoSub, RowCheck
	GoSub, b_Enable
}
GuiControl, chMacro:Choose, A_List, %ActiveList%
Gui, chMacro:Submit, NoHide
Gui, chMacro:ListView, InputList%A_List%
ShowGroups := GpConfig
GoSub, chMacroGuiSize
GoSub, LoadData
GoSub, TabSel
GoSub, UpdateCopyTo
Gui, 1:-Disabled
Gui, 32:Destroy
If (ShowGroups)
	GoSub, EnableGroups
Project := ""
SavePrompt(true, A_ThisLabel)
return

EditMacrosCancel:
32GuiClose:
32GuiEscape:
Gui, 1:-Disabled
Gui, 32:Destroy
Gui, chMacro:Default
return

MacroList:
Gui, 32:+OwnDialogs
If (A_GuiEvent == "E")
{
	InEdit := 1
	EditRow := LV_GetNext(0, "Focused")
	LV_GetText(BeforeEdit, EditRow, 1)
	return
}
If (A_GuiEvent == "e")
{
	InEdit := 0
	If (InStr(BeforeEdit, "()"))
	{
		LV_Modify(EditRow,, BeforeEdit)
		return
	}
	LV_GetText(AfterEdit, EditRow, 1)
	If (!RegExMatch(AfterEdit, "^\w+$"))
	{
		LV_Modify(EditRow,, BeforeEdit)
		MsgBox, 16, %d_Lang007%, %d_Lang049%
		return
	}
	Else
	{
		Loop, % LV_GetCount()
		{
			LV_GetText(mLabel, A_Index, 1)
			If ((A_Index != EditRow) && (mLabel = AfterEdit))
			{
				LV_Modify(EditRow,, BeforeEdit)
				MsgBox, 16, %d_Lang007%, %d_Lang050%
				return
			}
		}
	}
	return
}
If (A_GuiEvent = "D")
	LV_Rows.Drag()
If (A_GuiEvent != "DoubleClick")
	return
MacroListEdit:
Gui, 32:Default
Gui, 32:Submit, NoHide
If (LV_GetCount("Selected") = 0)
	RowNumber := A_List
Else
	RowNumber := LV_GetNext()
LV_GetText(Macro, RowNumber, 1)
LV_GetText(AutoKey, RowNumber, 2)
LV_GetText(ManKey, RowNumber, 3)
LV_GetText(TimesX, RowNumber, 4)
LV_GetText(Context, RowNumber, 5)
RegExMatch(Context, "O)(\w+)\s(.*)", MContext)
Gui, 33:+owner32 +ToolWindow +Delimiter%_x% +HwndLVEdit
Gui, 32:Default
Gui, 32:+Disabled
Gui, 33:Add, Groupbox, Section xm W450 H130
Gui, 33:Add, Edit, ys+15 xs+10 W430 vMacro, %Macro%
Gui, 33:Add, Text, -Wrap W90 R1 Right, %w_Lang005%:
Gui, 33:Add, Hotkey, yp x+10 W120 vAutoKey Disabled, %AutoKey%
Gui, 33:Add, Combobox, W180 yp x+30 vAutoKeyL gAutoComplete, % RegExReplace(KeybdList, _x . "{2}", _x)
Gui, 33:Add, Text, -Wrap y+5 xs+10 W90 R1 Right, %w_Lang007%:
Gui, 33:Add, Hotkey, yp x+10 W120 vManKey, %ManKey%
Gui, 33:Add, Text, -Wrap y+5 xs+10 W90 R1 Right, %t_Lang003%:
Gui, 33:Add, Edit, yp x+10 Limit Number W70 R1 vTE
Gui, 33:Add, UpDown, 0x80 Range0-999999999 vTimesX, %TimesX%
Gui, 33:Add, Text, -Wrap yp+3 x+10 W100, %t_Lang004%
Gui, 33:Add, Text, -Wrap yp-28 x+0 W100, # = Win`n! = Alt`n^ = Ctrl`n+ = Shift
Gui, 33:Add, Groupbox, Section xs y+20 W450 H75
Gui, 33:Add, Text, -Wrap R1 ys+20 xs+10 W40 cBlue, #If
Gui, 33:Add, DDL, yp-3 x+5 W100 vIfMacroContext, None%_x%WinActive%_x%WinNotActive%_x%WinExist%_x%WinNotExist%_x%Expression
Gui, 33:Add, Button, yp x+210 W75 vIdent gWinTitle, WinTitle
Gui, 33:Add, Edit, y+5 xs+10 W400 vTitle R1 -Multi, % MContext[2]
Gui, 33:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetWin gGetWin, ...
Gui, 33:Add, Button, Section Default -Wrap xm W75 H23 gEditMacroOK, %c_Lang020%
Gui, 33:Add, Button, Wrap ys W75 H23 gEditMacroCancel, %c_Lang021%
Gui, 33:Add, Updown, ys x+90 W50 H20 Horz vEditSel gSelList Range0-1
GuiControl, 33:ChooseString, IfMacroContext, % MContext[1]
If (InStr(KeybdList, AutoKey _x))
	GuiControl, 33:ChooseString, AutoKeyL, %AutoKey%
Else
	GuiControl, 33:, AutoKeyL, %AutoKey%%_x%%_x%

If (InStr(Macro, "()"))
{
	GuiControl, 33:Disable, Macro
	GuiControl, 33:Disable, AutoKey
	GuiControl, 33:Disable, AutoKeyL
	GuiControl, 33:Disable, ManKey
	GuiControl, 33:Disable, TE
	GuiControl, 33:Disable, TimesX
	GuiControl, 33:Disable, IfMacroContext
	GuiControl, 33:Disable, Ident
	GuiControl, 33:Disable, Title
	GuiControl, 33:Disable, GetWin
}
Gui, 33:Show,, %w_Lang019%
If (AutoKey = "")
	GuiControl, 33:Enable, AutoKey
return

33GuiClose:
33GuiEscape:
EditMacroCancel:
Gui, 32:-Disabled
Gui, 33:Destroy
Gui, 32:Default
return

EditMacroOK:
Gui, 33:+OwnDialogs
Gui, 33:Submit, NoHide
Gui, 32:Default
If ((!InStr(Macro, "()")) && (!RegExMatch(Macro, "^\w+$")))
{
	MsgBox, 16, %d_Lang007%, %d_Lang049%
	return
}
Else If (!InStr(Macro, "()"))
{
	Loop, % LV_GetCount()
	{
		LV_GetText(mLabel, A_Index, 1)
		If ((A_Index != RowNumber) && (mLabel = Macro))
		{
			MsgBox, 16, %d_Lang007%, %d_Lang050%
			return
		}
	}
}
Gui, 32:-Disabled
Gui, 33:Destroy
LV_Modify(RowNumber,, Macro, AutoKeyL != "" ? AutoKeyL : AutoKey, ManKey, TimesX, IfMacroContext " " Title)
return

SelList:
NewRow := EditSel ? (RowNumber + 1) : (RowNumber - 1)
Gui, 33:+OwnDialogs
Gui, 33:Submit, NoHide
Gui, 32:Default
If ((!InStr(Macro, "()")) && (!RegExMatch(Macro, "^\w+$")))
{
	MsgBox, 16, %d_Lang007%, %d_Lang049%
	return
}
Else If (!InStr(Macro, "()"))
{
	Loop, % LV_GetCount()
	{
		LV_GetText(mLabel, A_Index, 1)
		If ((A_Index != RowNumber) && (mLabel = Macro))
		{
			MsgBox, 16, %d_Lang007%, %d_Lang050%
			return
		}
	}
}
LV_Modify(RowNumber,, Macro, AutoKeyL != "" ? AutoKeyL : AutoKey, ManKey, TimesX, IfMacroContext " " Title)
RowNumber := NewRow
If (RowNumber > LV_GetCount())
	RowNumber := 1
Else If (RowNumber = 0)
	RowNumber := LV_GetCount()
LV_Modify(0, "-Select"), LV_Modify(RowNumber, "Select")
LV_GetText(Macro, RowNumber, 1)
LV_GetText(AutoKey, RowNumber, 2)
LV_GetText(ManKey, RowNumber, 3)
LV_GetText(TimesX, RowNumber, 4)
LV_GetText(Context, RowNumber, 5)
RegExMatch(Context, "O)(\w+)\s(.*)", MContext)
GuiControl, 33:, Macro, %Macro%
GuiControl, 33:, AutoKey, %AutoKey%
GuiControl, 33:, ManKey, %ManKey%
GuiControl, 33:, TimesX, %TimesX%
GuiControl, 33:ChooseString, IfMacroContext, % MContext[1]
GuiControl, 33:, Title, % MContext[2]
If (InStr(KeybdList, AutoKey _x))
	GuiControl, 33:ChooseString, AutoKeyL, %AutoKey%
Else
	GuiControl, 33:, AutoKeyL, %AutoKey%%_x%%_x%
If (InStr(Macro, "()"))
{
	GuiControl, 33:Disable, Macro
	GuiControl, 33:Disable, AutoKey
	GuiControl, 33:Disable, AutoKeyL
	GuiControl, 33:Disable, ManKey
	GuiControl, 33:Disable, TE
	GuiControl, 33:Disable, TimesX
	GuiControl, 33:Disable, IfMacroContext
	GuiControl, 33:Disable, Ident
	GuiControl, 33:Disable, Title
	GuiControl, 33:Disable, GetWin
}
Else
{
	GuiControl, 33:Enable, Macro
	GuiControl, 33:Enable, AutoKeyL
	GuiControl, 33:Enable, ManKey
	GuiControl, 33:Enable, TE
	GuiControl, 33:Enable, TimesX
	GuiControl, 33:Enable, IfMacroContext
	GuiControl, 33:Enable, Ident
	GuiControl, 33:Enable, Title
	GuiControl, 33:Enable, GetWin
}
return

Edit:
GoSub, ClearPars
Gui, chMacro:Default
Gui, chMacro:Listview, InputList%A_List%
LV_GetTexts(RowNumber, Action, Details, TimesX, DelayX, Type, Target, Window, Comment)
If (Action = "[LoopEnd]")
	return
Switch Type
{
	Case cType7, cType38, cType39, cType40, cType41, cType45, cType51:
		Goto, EditLoop
	Case cType15, cType16, cType56:
		Goto, EditImage
	Case cType21:
		Goto, EditVar
	Case cType44, cType46:
		Goto, EditFunc
	Case cType47:
		Goto, EditUserFunc
	Case cType48:
		Goto, EditParam
	Case cType49:
		Goto, EditReturn
	Case cType17:
		Goto, EditSt
	Case cType18, cType19:
		Goto, EditMsg
	Case cType20:
		If (Action = "[KeyWait]")
			Goto, EditKeyWait
		Else
			Goto, EditRun
	Case cType11, cType14:
		Goto, EditRun
	Case cType29, cType30:
		return
	Case cType32, cType33:
		Goto, EditIECom
	Case cType34, cType43:
		Goto, EditComInt
	Case cType5:
		Goto, EditSleep
	Case cType6:
		Goto, EditMsgBox
	Case cType42:
		Goto, EditComm
	Case cType35, cType36, cType37:
		Goto, EditGoto
	Case cType50:
		Goto, EditTimer
	Case cType52:
		Goto, EditEmail
	Case cType53:
		Goto, EditDownload
	Case cType54, cType55:
		Goto, EditZip
	Default:
		If (Action = "[Control]")
			Goto, EditControl
		If ((Details = "EndIf") || (Details = "Else") || (Action = "[LoopEnd]"))
			return
		If (InStr(FileCmdList, Type "|"))
			Goto, EditRun
		If (InStr(Type, "Win"))
			Goto, EditWindow
		If Action contains %MAction1%,%MAction2%,%MAction3%,%MAction4%,%MAction5%,%MAction6%
			Goto, EditMouse
		If (InStr(Action, "[Text]"))
			Goto, EditText
}
Gui, 15:+owner1 -MinimizeBox +HwndCmdWin
Gui, 1:+Disabled
Gui, 15:Add, GroupBox, vSGroup Section xm W280 H130
Gui, 15:Add, Checkbox, -Wrap Section ys+15 xs+10 W260 vCSend gCSend R1, %c_Lang016%:
Gui, 15:Add, Edit, vDefCt W230 Disabled
Gui, 15:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetCtrl gGetCtrl Disabled, ...
Gui, 15:Add, Button, Section xs W75 vIdent gWinTitle Disabled, WinTitle
Gui, 15:Add, Text, -Wrap yp+5 x+5 W180 H20 vWinParsTip cGray, %Wcmd_Short%
Gui, 15:Add, Edit, xs+2 W230 vTitle Disabled, A
Gui, 15:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetWin gGetWin Disabled, ...
Gui, 15:Add, GroupBox, Section xm W280 H110
Gui, 15:Add, Text, -Wrap R1 Section ys+15 xs+10, %w_Lang015%:
Gui, 15:Add, Text,, %c_Lang017%:
Gui, 15:Add, Edit, ys xs+90 W170 R1 ys vEdRept
Gui, 15:Add, UpDown, vTimesX 0x80 Range1-999999999, %TimesX%
Gui, 15:Add, Edit, W170 vDelayC
Gui, 15:Add, UpDown, vDelayX 0x80 Range0-999999999, %DelayX%
Gui, 15:Add, Radio, -Wrap Section yp+25 xm+10 Checked W175 vMsc R1, %c_Lang018%
Gui, 15:Add, Radio, -Wrap W175 vSec R1, %c_Lang019%
Gui, 15:Add, Button, -Wrap Section Default xm W75 H23 gEditOK, %c_Lang020%
Gui, 15:Add, Button, -Wrap ys W75 H23 gEditCancel, %c_Lang021%
Gui, 15:Add, Button, -Wrap ys W75 H23 gEditApply, %c_Lang131%
If (InStr(DelayX, "%"))
	GuiControl, 15:, DelayC, %DelayX%
If (InStr(TimesX, "%"))
	GuiControl, 15:, EdRept, %TimesX%
If Type in %cType1%,%cType2%,%cType3%,%cType4%,%cType8%,%cType9%,%cType13%
{
	If (Target != "")
		GuiControl, 15:, DefCt, %Target%
	If Action contains %MAction2%,%MAction3%,%MAction4%
		GuiControl, 15:Disable, CSend
	If (InStr(Type, "Control"))
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
Gui, 15:Show,, %w_Lang019%: %Type%
If (Window = "")
	Window := "A"
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
If ((CSend) && (A_Gui = 8))
{
	GuiControl,, ComEvent, 0
	GoSub, ComEvent
	GuiControl, Disable, ComEvent
}
Else If (ComText)
	GuiControl, Enable, ComEvent
Gui 8:+LastFoundExist
IfWinExist
{
	If (Raw = 1)
		SBShowTip((CSend ? "Control" : "") "SendRaw")
	Else If (ComText = 1)
		SBShowTip((CSend ? "Control" : "") "Send")
	Else If (SetText = 1)
		SBShowTip("ControlSetText")
	Else If (Clip = 1)
		SBShowTip("Clipboard")
	Else If (EditPaste = 1)
		SBShowTip("ControlEditPaste")
}
Gui 5:+LastFoundExist
IfWinExist
	SBShowTip((CSend ? "Control" : "") "Click")
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
GuiControl, Enable%MEditDelay%, IncrementDelay
GuiControl, Enable%MEditDelay%, DelayC
GuiControl, Enable%MEditDelay%, Msc
GuiControl, Enable%MEditDelay%, Sec
return

IncrementDelay:
Gui, Submit, NoHide
If (IncrementDelay)
	GuiControl, +Range-999999999-999999999, DelayX
Else
{
	GuiControl, +Range0-999999999, DelayX
	GuiControl,, DelayX, 0
}
return

EditApply:
EditOK:
Gui, 15:+OwnDialogs
Gui, 15:Submit, NoHide
TimesX := InStr(EdRept, "%") ? EdRept : TimesX, DelayX := InStr(DelayC, "%") ? DelayC : DelayX
If (Sec = 1)
	DelayX *= 1000
Window := Title
If (CSend = 1)
{
	If (DefCt = "")
	{
		MsgBox, 52, %d_Lang011%, %d_Lang012%
		IfMsgBox, No
			return
	}
	Target := DefCt
	If (Type = cType1)
		Type := cType2
	Else If (Type = cType3)
		Type := cType4
	Else If (Type = cType8)
		Type := cType9
}
Else
{
	Target := "", Window := ""
	If (Type = cType2)
		Type := cType1
	Else If (Type = cType4)
		Type := cType3
	Else If (Type = cType9)
		Type := cType8
}
If ((Type = cType5) || (Type = cType6))
{
	If (MP = 1)
	{
		StringReplace, MsgPT, MsgPT, `n, ``n, All
		StringReplace, MsgPT, MsgPT, `,, ```,, All
		Type := cType6, Details := MsgPT, DelayX := 0
		If (NoI = 1)
			Target := 0
		If (Err = 1)
			Target := 16
		If (Que = 1)
			Target := 32
		If (Exc = 1)
			Target := 48
		If (Inf = 1)
			Target := 64
		If (Aot = 1)
			Target += 262144
		If (CancelB = 1)
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
If (A_ThisLabel != "EditApply")
{
	Gui, 1:-Disabled
	Gui, 15:Destroy
}
Gui, chMacro:Default
LV_Modify(RowNumber, "Col3", Details, TimesX, DelayX, Type, Target, Window)
GoSub, RowCheck
GoSub, b_Start
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
Gui, 6:+owner1 -MinimizeBox +hwndCmdWin
Gui, 1:+Disabled
Gui, 6:Add, GroupBox, vSGroup Section xm W280 H120
Gui, 6:Add, Checkbox, -Wrap Section ys+15 xs+10 W250 vCSend gCSend R1, %c_Lang016%:
Gui, 6:Add, Edit, vDefCt W230 Disabled
Gui, 6:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetCtrl gGetCtrl Disabled, ...
Gui, 6:Add, Button, Section xs W75 vIdent gWinTitle Disabled, WinTitle
Gui, 6:Add, Text, -Wrap yp+5 x+5 W180 H20 vWinParsTip cGray, %Wcmd_Short%
Gui, 6:Add, Edit, xs+2 W230 vTitle Disabled, A
Gui, 6:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetWin gGetWin Disabled, ...
Gui, 6:Add, GroupBox, Section xm W280 H110
Gui, 6:Add, Checkbox, -Wrap Section ys+15 xs+10 W85 vMEditRept gMEditRept R1, %w_Lang015%:
Gui, 6:Add, Checkbox, -Wrap y+15 W85 vMEditDelay gMEditDelay R1, %c_Lang017%:
Gui, 6:Add, Edit, Disabled W170 R1 ys xs+90 vEdRept
Gui, 6:Add, UpDown, vTimesX 0x80 Range1-999999999, 1
Gui, 6:Add, Edit, Disabled W80 vDelayC
Gui, 6:Add, UpDown, vDelayX 0x80 Range0-999999999, 0
Gui, 6:Add, Checkbox, -Wrap yp+5 x+5 W85 vIncrementDelay gIncrementDelay R1 Disabled, %t_Lang217%
Gui, 6:Add, Radio, -Wrap Section Checked Disabled xs+90 W175 vMsc R1, %c_Lang018%
Gui, 6:Add, Radio, -Wrap Disabled W175 vSec R1, %c_Lang019%
Gui, 6:Add, Button, -Wrap Section Default xm W75 H23 gMultiOK, %c_Lang020%
Gui, 6:Add, Button, -Wrap ys W75 H23 gMultiCancel, %c_Lang021%
Gui, 6:Add, Button, -Wrap ys W75 H23 gMultiApply, %c_Lang131%
Gui, 6:Show,, %w_Lang019%
Window := "A"
Input
Tooltip
return

MultiApply:
MultiOK:
Gui, 6:+OwnDialogs
Gui, 6:Submit, NoHide
TimesX := InStr(EdRept, "%") ? EdRept : TimesX, DelayX := InStr(DelayC, "%") ? DelayC : DelayX
If (Sec = 1)
	DelayX *= 1000
If (MEditRept = 1)
{
	TimesTemp := TimesM, TimesM := TimesX
	Gui, chMacro:Default
	GoSub, ApplyTEd
	TimesM := TimesTemp
	If (A_ThisLabel != "MultiApply")
		Goto, MultiCancel
	Else
		return
}
Else If (MEditDelay = 1)
{
	Gui, chMacro:Default
	GoSub, ApplyIEd
	If (A_ThisLabel != "MultiApply")
		Goto, MultiCancel
	Else
		return
}
If (CSend = 1)
{
	If (DefCt = "")
	{
		MsgBox, 52, %d_Lang011%, %d_Lang012%
		IfMsgBox, No
			return
	}
	Target := DefCt, Window := Title
}
If (CSend = 0)
	Target := "", Window := ""
If (A_ThisLabel != "MultiApply")
{
	Gui, 1:-Disabled
	Gui, 6:Destroy
}
Gui, chMacro:Default
If (RowSelection = 0)
{
	Loop
	{
		RowNumber := A_Index
		If (RowNumber > ListCount%A_List%)
			break
		LV_GetText(Action, RowNumber, 2)
		If Action contains %MAction2%,%MAction3%,%MAction4%
			continue
		LV_GetText(Type, RowNumber, 6)
		If ((Type = cType1) || (Type = cType2) || (Type = cType3)
		|| (Type = cType4) || (Type = cType8) || (Type = cType9)
		|| (Type = cType10) || (Type = cType22) || (Type = cType23)
		|| (Type = cType24) || (Type = cType25) || (Type = cType26))
		{
			If (CSend = 1)
			{
				If (Type = cType1)
					Type := cType2
				Else If (Type = cType3)
					Type := cType4
				Else If (Type = cType8)
					Type := cType9
				LV_Modify(RowNumber, "Col6", Type, Target, Window)
			}
			If (CSend = 0)
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
		Else If (InStr(Type, "Win"))
			LV_Modify(RowNumber, "Col8", Window)
	}
}
Else
{
	RowNumber := 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_GetText(Action, RowNumber, 2)
		If Action contains %MAction2%,%MAction3%,%MAction4%
			continue
		LV_GetText(Type, RowNumber, 6)
		If ((Type = cType1) || (Type = cType2) || (Type = cType3)
		|| (Type = cType4) || (Type = cType8) || (Type = cType9)
		|| (Type = cType10) || (Type = cType22) || (Type = cType23)
		|| (Type = cType24) || (Type = cType25) || (Type = cType26))
		{
			If (CSend = 1)
			{
				If (Type = cType1)
					Type := cType2
				Else If (Type = cType3)
					Type := cType4
				Else If (Type = cType8)
					Type := cType9
				LV_Modify(RowNumber, "Col6", Type, Target, Window)
			}
			Else If (CSend = 0)
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
		Else If (InStr(Type, "Win"))
			LV_Modify(RowNumber, "Col8", Window)
	}
}
If (A_ThisLabel = "MultiApply")
	Gui, 6:Default
Else
	GuiControl, Focus, InputList%A_List%
GoSub, RowCheck
GoSub, b_Start
return

MultiCancel:
6GuiClose:
6GuiEscape:
Gui, 1:-Disabled
Gui, 6:Destroy
return

SetJoyButton:
TB_Edit(TbSettings, "SetJoyButton", JoyHK := !JoyHK)
If (JoyHK = 1)
{
	GoSub, SetJoyHK
	If (JoyKey = "")
		GuiControl, 1:, JoyKey, |%t_Lang097%
	GuiControl, 1:Focus, JoyKey
	Menu, OptionsMenu, Check, %o_Lang008%
}
Else
{
	GoSub, SetNoJoy
	Menu, OptionsMenu, Uncheck, %o_Lang008%
}
return

CaptureJoyB:
GuiControl, 1:, JoyKey, |%A_ThisHotkey%||
GoSub, SaveData
return

SetJoyHK:
Gui, chMacro:Submit, NoHide
GuiControl, 1:Hide, AutoKey
GuiControl, 1:Disable, AutoKey
If (RegExMatch(o_AutoKey[A_List], "i)Joy\d+$"))
	GuiControl, 1:, JoyKey, % "|" o_AutoKey[A_List] "||"
GuiControl, 1:Show, JoyKey
aBand := RbMain.IDToIndex(7), RbMain.GetBand(aBand,,, bSize)
RbMain.ModifyBand(aBand, "Child", hJoyKey), RbMain.SetBandWidth(aBand, bSize)
ActivateHotkeys(,,,,, 1), TB_Edit(TbSettings, "WinKey", 0, 0)
return

SetNoJoy:
Gui, chMacro:Submit, NoHide
GuiControl, 1:Enable, AutoKey
GuiControl, 1:Show, AutoKey
GuiControl, 1:Hide, JoyKey
GuiControl, 1:Enable, WinKey
ActivateHotkeys(,,,,, 0), TB_Edit(TbSettings, "WinKey", 0, 1)
aBand := RbMain.IDToIndex(7)
RbMain.GetBand(aBand,,, bSize,,,, cChild)
If (cChild != hAutoKey)
	RbMain.ModifyBand(aBand, "Child", hAutoKey), RbMain.SetBandWidth(aBand, bSize)
return

SetWin:
Gui, 16:+owner1 -MinimizeBox +HwndCmdWin
Gui, chMacro:Default
Gui, 1:+Disabled
Gui, 16:Add, Groupbox, W450 H75
Gui, 16:Add, Text, -Wrap R1 ys+20 xs+10 W40 cBlue, #If
Gui, 16:Add, DDL, yp-3 x+5 W100 vIfDirectContext, None||WinActive|WinNotActive|WinExist|WinNotExist|Expression
Gui, 16:Add, Button, yp x+210 W75 vIdent gWinTitle, WinTitle
Gui, 16:Add, Edit, y+5 xs+10 W400 vTitle R1 -Multi, %IfDirectWindow%
Gui, 16:Add, Button, -Wrap yp-1 x+0 W30 H23 vGetWin gGetWin, ...
Gui, 16:Add, Button, -Wrap Section Default xm W75 H23 gSWinOK, %c_Lang020%
Gui, 16:Add, Button, -Wrap ys W75 H23 gSWinCancel, %c_Lang021%
GuiControl, 16:ChooseString, IfDirectContext, %IfDirectContext%
Gui, 16:Show,, %t_Lang009%
Tooltip
return

SWinOK:
Gui, 16:Submit, NoHide
IfDirectWindow := Title, TB_Edit(TbSettings, "SetWin", (IfDirectContext = "None") ? 0 : 1)
Gui, 1:-Disabled
Gui, 16:Destroy
Gui, chMacro:Default
GuiControl, 1:, ContextTip, Global <a>#If</a>: %IfDirectContext%
SavePrompt(true, A_ThisLabel)
return

SWinCancel:
16GuiClose:
16GuiEscape:
Gui, 1:-Disabled
Gui, 16:Destroy
return

GoToMacro:
MenuList := ""
For Index, MacroLabel in CopyMenuLabels
	MenuList .= MacroLabel "|"
Gui, 41:+owner1 -MinimizeBox +HwndCmdWin
Gui, chMacro:Default
Gui, 1:+Disabled
Gui, 41:Add, Groupbox, W400 H75
Gui, 41:Add, Text, -Wrap R1 ys+20 xs+10 W280, %t_Lang147%:
Gui, 41:Add, Text, -Wrap R1 yp x+15 W80, %t_Lang220%:
Gui, 41:Add, Combobox, W280 y+5 xs+10 vGoToMacro gAutoComplete, %MenuList%
Gui, 41:Add, Edit, yp x+15 W80 H22 Number vGoLine
Gui, 41:Add, UpDown, yp x+15 0x80 Range0-999999999 vGoToLine
Gui, 41:Add, Button, -Wrap Section Default xm W75 H23 gGoToMacroOK, %c_Lang020%
Gui, 41:Add, Button, -Wrap ys W75 H23 gGoToMacroCancel, %c_Lang021%
GuiControl, 41:ChooseString, GotoMacro, % CopyMenuLabels[A_List]
Gui, 41:Show,, %w_Lang113%
Tooltip
return

GoToMacroOK:
Gui, 41:Submit, NoHide
Gui, 1:-Disabled
Gui, 41:Destroy
Gui, chMacro:Default
GuiControl, chMacro:Choose, A_List, %GoToMacro%
GoSub, TabSel
If (GoToLine)
	LV_Modify(GoToLine, "Select Focus Vis")
return

GoToMacroCancel:
41GuiClose:
41GuiEscape:
Gui, 1:-Disabled
Gui, 41:Destroy
return

EditComm:
Gui, chMacro:Default
Gui, chMacro:Listview, InputList%A_List%
Gui, 17:+owner1 -MinimizeBox
Gui, chMacro:Default
Gui, 1:+Disabled
Gui, 17:Add, GroupBox, Section xm W450 H105, %t_Lang064%:
Gui, 17:Add, Edit, ys+20 xs+10 vComm W430 r5
Gui, 17:Add, Button, -Wrap Section Default xm W75 H23 gCommOK, %c_Lang020%
Gui, 17:Add, Button, -Wrap ys W75 H23 gCommCancel, %c_Lang021%
Gui, 17:Add, Button, -Wrap ys W75 H23 vCommBlock gCommBlock, %w_Lang018%
GoSub, ClearPars
RowNumber := LV_GetNext()
LV_GetTexts(RowNumber, Action, Details, TimesX, DelayX, Type, Target, Window, Comment)
RowSelection := LV_GetCount("Selected")
If (RowSelection = 1)
{
	If (Type = cType42)
	{
		Comment := Details
		GuiControl, 17:Disable, CommBlock
	}
	StringReplace, Comment, Comment, `n, %A_Space%, All
	GuiControl, 17:, Comm, %Comment%
}
Gui, 17:Show,, %t_Lang065%
Tooltip
return

CommOK:
Gui, 17:Submit, NoHide
If (RowSelection = 1)
{
	If (Type != cType42)
		StringReplace, Comm, Comm, `n, %A_Space%, All
}
Else
	StringReplace, Comm, Comm, `n, %A_Space%, All
Comment := Comm
Gui, 1:-Disabled
Gui, 17:Destroy
Gui, chMacro:Default
If (RowSelection = 1)
{
	If (Type = cType42)
		LV_Modify(RowNumber, "Col3", Comment, 0, 1, cType42)
	Else
		LV_Modify(RowNumber, "Col9", Comment)
}
Else If (RowSelection = 0)
{
	RowNumber := 0
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
	RowNumber := 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Modify(RowNumber, "Col9", Comment)
	}
}
GoSub, RowCheck
GoSub, b_Start
GuiControl, Focus, InputList%A_List%
s_Caller := ""
return

CommBlock:
Gui, 17:Submit, NoHide
StringReplace, Comm, Comm, `n, %A_Space%, All
Comment := Comm
Gui, 1:-Disabled
Gui, 17:Destroy
Gui, chMacro:Default
If (RowSelection = 0)
{
	LV_Add("Check", ListCount%A_List%+1, "[CommentBlock]", Comment, 0, 1, cType42)
	LV_Modify(ListCount%A_List%+1, "Vis")
}
Else
{
	LV_Insert(RowNumber, "Check", LV_GetNext(), "[CommentBlock]", Comment, 0, 1, cType42)
	LVManager[A_List].InsertAtGroup(LV_GetNext())
}
GoSub, RowCheck
GoSub, b_Start
GuiControl, Focus, InputList%A_List%
return

CommCancel:
17GuiClose:
17GuiEscape:
Gui, 1:-Disabled
Gui, 17:Destroy
return

ShowTessMenu:
Loop, Parse, TessLangs, "|"
{
	If (A_LoopField != "")
	{
		LoopField := RegExReplace(A_LoopField, "\..*")
		Menu, TessMenu, Add, %LoopField%, SelectTessLang
		If (InStr(TessSelectedLangs, LoopField))
			Menu, TessMenu, Check, %LoopField%
	}
}
Menu, TessMenu, Add
Menu, TessMenu, Add, %c_Lang262%, DownloadTessLangFiles
ControlGetPos, CtrPosX, CtrPosY,, CtrlPosH,, ahk_id %hSearchImg%
Menu, TessMenu, Show, %CtrPosX%, % CtrPosY + CtrlPosH
Menu, TessMenu, DeleteAll
return

SelectTessLang:
If (!InStr(TessSelectedLangs, A_ThisMenuItem))
	TessSelectedLangs .= "+" A_ThisMenuItem
Else
	TessSelectedLangs := RegExReplace(TessSelectedLangs, "\+?" A_ThisMenuItem)
TessSelectedLangs := RegExReplace(TessSelectedLangs, "^\+")
return

DownloadTessLangFiles:
Gui, 19:+OwnDialogs
ComObjError(false)
AvailableLangs := []
url := "https://github.com/tesseract-ocr/tessdata_fast"
UrlDownloadToFile, %url%, %A_Temp%\tessdata_fast.html
FileRead, ResponseText, %A_Temp%\tessdata_fast.html
Try
{
	Pos := 1
	While (Pos := RegExMatch(ResponseText, "title=\""(\w+).traineddata\""", FoundLang, Pos + StrLen(FoundLang)))
		AvailableLangs.Push(FoundLang1)
	Gui, Tess:+owner1 +ToolWindow
	Gui, 19:+Disabled
	For each, key in AvailableLangs
	{
		LangName := ""
		For l, k in LangData
		{
			If ((SubStr(k.Local, 1, 3) = key) || (SubStr(k.Idiom, 1, 3) = key))
			{
				LangName := k.Local
				break
			}
		}
		Gui, Tess:Add, Checkbox, % (!Mod(each-1, 22)) ? "v" key " R2 W200 ym x+10" : "v" key " R2 W200", % key . (LangName ? ": " LangName : "")
	}
	For each, key in AvailableLangs
	{
		If (InStr(TessLangs, key))
		{
			GuiControl, Tess:, %key%, 1
			GuiControl, Tess:Disable, %key%
		}
	}
	Gui, Tess:Add, Button, -Wrap Section Default xm W290 H23 gTransferLangs, %d_Lang116%
	Gui, Tess:Add, Button, -Wrap yp x+5 W290 H23 gTessCancel, %c_Lang021%
	Gui, Tess:Show, H760, %c_Lang260% (OCR) | %c_Lang262%
}
return

TransferLangs:
Gui, Tess:Submit, NoHide
Gui, Tess:Destroy
SplashTextOn, 300, 25, %AppName%, %d_Lang091%
BestBaseUrl := "https://github.com/tesseract-ocr/tessdata_best/raw/master/"
FastBaseUrl := "https://github.com/tesseract-ocr/tessdata_fast/raw/master/"
TessdataBestFolder := SettingsFolder "\bin\tesseract\tessdata_best"
TessdataFastFolder := SettingsFolder "\bin\tesseract\tessdata_fast"
FileCreateDir, %TessdataBestFolder%
FileCreateDir, %TessdataFastFolder%
For each, key in AvailableLangs
{
	If ((!InStr(TessLangs, key)) && (%key%))
	{
		WinHttpDownloadToFile(BestBaseUrl . key ".traineddata", TessdataBestFolder)
		WinHttpDownloadToFile(FastBaseUrl . key ".traineddata", TessdataFastFolder)
	}
}
TessLangs := ""
Loop, Files, %SettingsFolder%\Bin\tesseract\tessdata_fast\*.traineddata, F
	TessLangs .= A_LoopFileName "|"
SplashTextOff
Gui, 19:-Disabled
return

TessGuiEscape:
TessGuiClose:
TessCancel:
Gui, 19:-Disabled
Gui, Tess:Destroy
return

EditColor:
Gui, 1:Submit, NoHide
Gui, 19:Submit, NoHide
rColor := ""
If (A_GuiControl = "SearchImg")
	rColor := ImgFile, OwnerID := CmdWin
Else If (InStr(A_GuiControl, "LVColor") || (A_GuiControl = "SearchAreaColor"))
	rColor := %A_GuiControl%, OwnerID := CmdWin
Else
{
	Gui, chMacro:Default
	Gui, chMacro:Listview, InputList%A_List%
	RowSelection := LV_GetCount("Selected"), OwnerID := PMCWinID
	If (RowSelection = 1)
	{
		RowNumber := LV_GetNext()
		LV_GetText(rColor, RowNumber, 10)
	}
}
If (Dlg_Color(rColor, OwnerID, CustomColors))
{
	If (A_GuiControl = "SearchImg")
	{
		GuiControl,, ImgFile, %rColor%
		GuiControl, +Background%rColor%, ColorPrev
	}
	Else If (InStr(A_GuiControl, "LVColor") || (A_GuiControl = "SearchAreaColor"))
	{
		%A_GuiControl% := rColor
		Gui, Font, c%rColor%
		GuiControl, Font, %A_GuiControl%
	}
	Else
		GoSub, PaintRows
}
return

PaintRows:
If (rColor = "0xffffff")
	rColor := ""
If (RowSelection = 1)
	LV_Modify(RowNumber, "Col10", rColor)
Else If (RowSelection = 0)
{
	RowNumber := 0
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
	RowNumber := 0
	Loop, %RowSelection%
	{
		RowNumber := LV_GetNext(RowNumber)
		LV_Modify(RowNumber, "Col10", rColor)
	}
}
GoSub, RowCheck
return

FilterSelect:
FindReplace:
Input
Gui 18:+LastFoundExist
IfWinExist
	GoSub, FindClose
Gui, 18:+owner1 +ToolWindow
Gui, chMacro:Default
Gui, 18:Add, Tab3, Section W400 H365 vFindTabC, %t_Lang140%|%t_Lang141%
Gui, 18:Add, Text, -Wrap R1 ys+40 xs+10 W150 Right, %t_Lang066%:
Gui, 18:Add, DDL, yp-5 x+10 W120 vSearchCol gSearchCol AltSubmit, %w_Lang031%||%w_Lang032%|%w_Lang033%|%w_Lang034%|%w_Lang035%|%w_Lang036%|%w_Lang037%|%w_Lang038%|%w_Lang039%
Gui, 18:Add, GroupBox, ys+60 xs+10 W380 H130, %t_Lang208%:
Gui, 18:Add, Edit, -Wrap R1 yp+20 xs+20 vFind W360
Gui, 18:Add, Button, -Wrap Default y+5 xs+305 W75 H23 vFindOK gFindOK, %t_Lang068%
Gui, 18:Add, Checkbox, -Wrap yp xs+20 W285 vWholC R1, %t_Lang092%
Gui, 18:Add, Checkbox, -Wrap W285 vMCase R1, %t_Lang069%
Gui, 18:Add, Checkbox, -Wrap W285 vRegExSearch gRegExSearch R1, %t_Lang077%
Gui, 18:Add, Text, -Wrap R1 y+10 xs+20 W280 vFound
Gui, 18:Add, GroupBox, Section y+25 xs+10 W380 H130, %t_Lang209%:
Gui, 18:Add, Edit, -Wrap R1 ys+25 xs+10 vReplace W360
Gui, 18:Add, Button, -Wrap y+5 xs+295 W75 H23 vReplaceOK gReplaceOK, %t_Lang070%
Gui, 18:Add, Radio, -Wrap Checked yp xs+10 W285 vRepSelRows R1, %t_Lang073%
Gui, 18:Add, Radio, -Wrap W285 vRepAllRows R1, %t_Lang074%
Gui, 18:Add, Radio, -Wrap W285 vRepAllMacros R1, %t_Lang075%
Gui, 18:Add, Text, -Wrap R1 y+10 xs+10 W280 vReplaced
Gui, 18:Tab, 2
Gui, 18:Add, Groupbox, Section ym+30 xm+10 W380 H321
Gui, 18:Add, Text, -Wrap R1 ys+20 xs+10 W100 Right, %w_Lang031%:
Gui, 18:Add, Edit, -Wrap R1 yp x+10 W250 vFilterA, %FilterA%
Gui, 18:Add, Text, -Wrap R1 y+5 xs+10 W100 Right, %w_Lang032%:
Gui, 18:Add, Edit, -Wrap R1 yp x+10 W250 vFilterB, %FilterB%
Gui, 18:Add, Text, -Wrap R1 y+5 xs+10 W100 Right, %w_Lang033%:
Gui, 18:Add, Edit, -Wrap R1 yp x+10 W250 vFilterC, %FilterC%
Gui, 18:Add, Text, -Wrap R1 y+5 xs+10 W100 Right, %w_Lang034%:
Gui, 18:Add, Edit, -Wrap R1 yp x+10 W250 vFilterD, %FilterD%
Gui, 18:Add, Text, -Wrap R1 y+5 xs+10 W100 Right, %w_Lang035%:
Gui, 18:Add, Edit, -Wrap R1 yp x+10 W250 vFilterE, %FilterE%
Gui, 18:Add, Text, -Wrap R1 y+5 xs+10 W100 Right, %w_Lang036%:
Gui, 18:Add, Edit, -Wrap R1 yp x+10 W250 vFilterF, %FilterF%
Gui, 18:Add, Text, -Wrap R1 y+5 xs+10 W100 Right, %w_Lang037%:
Gui, 18:Add, Edit, -Wrap R1 yp x+10 W250 vFilterG, %FilterG%
Gui, 18:Add, Text, -Wrap R1 y+5 xs+10 W100 Right, %w_Lang038%:
Gui, 18:Add, Edit, -Wrap R1 yp x+10 W250 vFilterH, %FilterH%
Gui, 18:Add, Text, -Wrap R1 y+5 xs+10 W100 Right, %w_Lang039%:
Gui, 18:Add, Edit, -Wrap R1 yp x+10 W250 vFilterI, %FilterI%
Gui, 18:Add, Checkbox, -Wrap y+25 xs+10 W185 vFCase R1, %t_Lang069%
Gui, 18:Add, Button, -Wrap yp-5 xs+295 W75 H23 gFilterOK, %t_Lang068%
Gui, 18:Add, Text, -Wrap R1 y+5 xs+10 W280 vFFound
Gui, 18:Tab
Gui, 18:Add, Button, -Wrap Section xm W75 H23 gFindClose, %c_Lang022%
If (A_ThisLabel = "FilterSelect")
	GuiControl, 18:Choose, FindTabC, 2
Gui, 18:Show,, %t_Lang067%
GuiControl, 18:Choose, SearchCol, 2
GuiControl, 18:Focus, Find
Tooltip
return

SearchCol:
Gui, 18:Submit, NoHide
SeIsType := ((SearchCol = 1) || (SearchCol = 5))
GuiControl, 18:Disable%SeIsType%, Replace
GuiControl, 18:Disable%SeIsType%, ReplaceOK
GuiControl, 18:Disable%SeIsType%, RepSelRows
GuiControl, 18:Disable%SeIsType%, RepAllRows
GuiControl, 18:Disable%SeIsType%, RepAllMacros
return

FindOK:
Gui, 18:Submit, NoHide
If (Find = "")
	return
Gui, chMacro:Default
StringReplace, Find, Find, `n, ``n, All
LV_Modify(0, "-Select")
t_Col := SearchCol + 1
Loop
{
	RowNumber := A_Index
	If (RowNumber > ListCount%A_List%)
		break
	LV_GetText(CellText, RowNumber, t_Col)
	If (RegExSearch = 1)
	{
		If (RegExMatch(CellText, Find))
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
	Else If (InStr(CellText, Find, MCase))
		LV_Modify(RowNumber, "Select")
}
RowSelection := LV_GetCount("Selected")
GuiControl, 18:, Found, %t_Lang071%: %RowSelection%
If (RowSelection)
	LV_Modify(LV_GetNext(), "Vis")
return

ReplaceOK:
Gui, 18:Submit, NoHide
If (Find = "")
	return
Gui, chMacro:Default
StringReplace, Find, Find, `n, ``n, All
t_Col := SearchCol + 1, Replaces := 0
If (RepAllRows = 1)
{
	Loop, % ListCount%A_List%
	{
		LV_GetText(CellText, A_Index, t_Col)
		If (RegExSearch = 1)
		{
			If (RegExMatch(CellText, Find))
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
					CellText := StrReplace(CellText, Find, Replace)
					LV_Modify(A_Index, "Col" t_Col, CellText)
					Replaces += 1
				}
			}
			Else If (CellText = Find)
			{
				CellText := StrReplace(CellText, Find, Replace)
				LV_Modify(A_Index, "Col" t_Col, CellText)
				Replaces += 1
			}
		}
		Else If (InStr(CellText, Find, MCase))
		{
			CellText := StrReplace(CellText, Find, Replace)
			LV_Modify(A_Index, "Col" t_Col, CellText)
			Replaces += 1
		}
	}
	If (Replaces > 0)
		HistCheck(A_List)
}
Else If (RepAllMacros = 1)
{
	Tmp_List := A_List
	Loop, %TabCount%
	{
		Replaces := 0
		Gui, chMacro:Listview, InputList%A_Index%
		Loop,  % ListCount%A_Index%
		{
			LV_GetText(CellText, A_Index, t_Col)
			If (RegExSearch = 1)
			{
				If (RegExMatch(CellText, Find))
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
						CellText := StrReplace(CellText, Find, Replace)
						LV_Modify(A_Index, "Col" t_Col, CellText)
						Replaces += 1
					}
				}
				Else If (CellText = Find)
				{
					CellText := StrReplace(CellText, Find, Replace)
					LV_Modify(A_Index, "Col" t_Col, CellText)
					Replaces += 1
				}
			}
			Else If (InStr(CellText, Find, MCase))
			{
				CellText := StrReplace(CellText, Find, Replace)
				LV_Modify(A_Index, "Col" t_Col, CellText)
				Replaces += 1
			}
		}
		If (Replaces > 0)
			HistCheck(A_Index)
	}
	Gui, chMacro:Listview, InputList%A_List%
}
Else
{
	RowNumber := 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		If (!RowNumber)
			break
		LV_GetText(CellText, RowNumber, t_Col)
		If (RegExSearch = 1)
		{
			If (RegExMatch(CellText, Find))
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
					CellText := StrReplace(CellText, Find, Replace)
					LV_Modify(RowNumber, "Col" t_Col, CellText)
					Replaces += 1
				}
			}
			Else If (CellText = Find)
			{
				CellText := StrReplace(CellText, Find, Replace)
				LV_Modify(RowNumber, "Col" t_Col, CellText)
				Replaces += 1
			}
		}
		Else If (InStr(CellText, Find, MCase))
		{
			CellText := StrReplace(CellText, Find, Replace)
			LV_Modify(RowNumber, "Col" t_Col, CellText)
			Replaces += 1
		}
	}
	If (Replaces > 0)
		HistCheck(A_List)
}
GuiControl, 18:, Replaced, %t_Lang072%: %Replaces%

return

RegExSearch:
Gui, 18:Submit, NoHide
GuiControl, 18:Disable%RegExSearch%, WholC
GuiControl, 18:Disable%RegExSearch%, MCase
return

FindClose:
18GuiClose:
18GuiEscape:
Gui, 18:Destroy
return

FilterOK:
Gui, 18:Submit, NoHide
Gui, chMacro:Default
FFound := SelectByFilter(FilterA, FilterB, FilterC, FilterD, FilterE, FilterF, FilterG, FilterH, FilterI, FCase)
GuiControl, 18:, FFound, %t_Lang071%: %FFound%
return

MainOnTop:
Gui, % (MainOnTop := !MainOnTop) ? "1:+AlwaysOnTop" : "1:-AlwaysOnTop"
If (MainOnTop)
	Menu, ViewMenu, Check, %v_Lang001%
Else
	Menu, ViewMenu, UnCheck, %v_Lang001%
return

ShowLoopIfMark:
ShowLoopIfMark := !ShowLoopIfMark
If (ShowLoopIfMark)
	Menu, ViewMenu, Check, %v_Lang002%
Else
	Menu, ViewMenu, UnCheck, %v_Lang002%
GoSub, RowCheck
return

ShowActIdent:
ShowActIdent := !ShowActIdent
If (ShowActIdent)
	Menu, ViewMenu, Check, %v_Lang003%
Else
	Menu, ViewMenu, UnCheck, %v_Lang003%
GoSub, RowCheck
return

ShowLoopCounter:
bID := 11
GoSub, ShowHideBandOn
If (ShowBand11)
	Menu, ViewMenu, Check, %v_Lang008%
Else
	Menu, ViewMenu, UnCheck, %v_Lang008%
return

ShowSearchBar:
bID := 6
GoSub, ShowHideBandOn
If (ShowBand6)
	Menu, ViewMenu, Check, %v_Lang009%
Else
	Menu, ViewMenu, UnCheck, %v_Lang009%
return

ShowHideBand:
bID := RBIndexTB[A_ThisMenuItemPos]
ShowHideBandOn:
tBand := RbMain.IDToIndex(bID), ShowBand%bID% := !ShowBand%bID%
RbMain.ShowBand(tBand, ShowBand%bID%)
RbMain.ShowBand(RbMain.IDToIndex(1), ShowBand1)
If (ShowBand1)
	Menu, ToolbarsMenu, Check, %v_Lang014%
Else
	Menu, ToolbarsMenu, UnCheck, %v_Lang014%
If (ShowBand2)
	Menu, ToolbarsMenu, Check, %v_Lang015%
Else
	Menu, ToolbarsMenu, UnCheck, %v_Lang015%
If (ShowBand3)
	Menu, ToolbarsMenu, Check, %v_Lang016%
Else
	Menu, ToolbarsMenu, UnCheck, %v_Lang016%
If (ShowBand4)
	Menu, ToolbarsMenu, Check, %v_Lang017%
Else
	Menu, ToolbarsMenu, UnCheck, %v_Lang017%
If (ShowBand5)
	Menu, ToolbarsMenu, Check, %v_Lang018%
Else
	Menu, ToolbarsMenu, UnCheck, %v_Lang018%
return

ShowHideBandHK:
bID := RBIndexHK[A_ThisMenuItemPos]
tBand := RbMain.IDToIndex(bID), ShowBand%bID% := !ShowBand%bID%
RbMain.ShowBand(tBand, ShowBand%bID%)
If (ShowBand7)
	Menu, HotkeyMenu, Check, %v_Lang020%
Else
	Menu, HotkeyMenu, UnCheck, %v_Lang020%
If (ShowBand8)
	Menu, HotkeyMenu, Check, %v_Lang021%
Else
	Menu, HotkeyMenu, UnCheck, %v_Lang021%
If (ShowBand9)
	Menu, HotkeyMenu, Check, %v_Lang022%
Else
	Menu, HotkeyMenu, UnCheck, %v_Lang022%
If (ShowBand10)
	Menu, HotkeyMenu, Check, %v_Lang023%
Else
	Menu, HotkeyMenu, UnCheck, %v_Lang023%
return

;##### Playback: #####

f_AutoKey:
If (CheckDuplicateLabels())
{
	MsgBox, 16, %d_Lang007%, %d_Lang050%
	StopIt := 1
	return
}
Loop, %TabCount%
{
	If (("" o_AutoKey[A_Index] "" = "" A_ThisHotkey "")	|| ("" LTrim(o_AutoKey[A_Index], "*~$") "" = "" LTrim(A_ThisHotkey, "*~$") ""))
	{
		aHK_On := [A_Index]
		break
	}
}
StopIt := 0
f_RunMacro:
If (InStr(CopyMenuLabels[aHK_On[1]], "()"))
	return
If (CheckDuplicateLabels())
{
	MsgBox, 16, %d_Lang007%, %d_Lang050%
	StopIt := 1
	return
}
If (aHK_On := Playback(aHK_On*))
	Goto, f_RunMacro
If (CloseAfterPlay)
{
	IL_Destroy(hIL_Icons), IL_Destroy(hIL_IconsHi)
	FileDelete, %SettingsFolder%\~ActiveProject.pmc
	Loop, %A_Temp%\PMC_*.ahk
		FileDelete, %A_LoopFileFullPath%
	ExitApp
}
If (OnFinishCode > 1)
	GoSub, OnFinishAction
return

f_ManKey:
Loop, %TabCount%
	If (o_ManKey[A_Index] = A_ThisHotkey)
		mHK_On := [A_Index, 0, A_Index]
f_RunMan:
If (InStr(CopyMenuLabels[mHK_On], "()"))
	return
StopIt := 0
If (mHK_On := Playback(mHK_On*))
	Goto, f_RunMan
return

f_AbortKey:
Gui, chMacro:Default
StopIt := 1, PlayOSOn := 0
Pause, Off
If (Record)
{
	GoSub, RecStop
	GoSub, b_Start
}
GoSub, RowCheck
Try Menu, Tray, Icon, %DefaultIcon%, 1
Menu, Tray, Tip, Pulovers's Macro Creator
tbOSC.ModifyButtonInfo(1, "Image", 48)
Tooltip
return

NoKey:
return

EscNoKey:
StopIt := 1
return

PauseKey:
Gui, 1:Submit, NoHide
return

f_PauseKey:
If ((!CurrentRange) && (!Record))
	return
If (ToggleIcon() && (!Record))
	tbOSC.ModifyButtonInfo(1, "Image", 55)
Else
	tbOSC.ModifyButtonInfo(1, "Image", 48)
IsPauseCheck := !A_IsPaused
Pause,, 1
return

FastKeyToggle:
SlowKeyOn := 0, FastKeyOn := !FastKeyOn
If (ShowStep)
	TrayTip, %AppName%, % (FastKeyOn) ? t_Lang036 " " SpeedUp "x" : t_Lang035 " 1x"
TB_Edit(TbOSC, "SlowKeyToggle", SlowKeyOn), TB_Edit(TbOSC, "FastKeyToggle", FastKeyOn)
return

SlowKeyToggle:
FastKeyOn := 0, SlowKeyOn := !SlowKeyOn
If (ShowStep)
	TrayTip, %AppName%, % (SlowKeyOn) ? t_Lang037 " " SpeedDn "x" : t_Lang035 " 1x"
TB_Edit(TbOSC, "SlowKeyToggle", SlowKeyOn), TB_Edit(TbOSC, "FastKeyToggle", FastKeyOn)
return

CheckHkOn:
TB_Edit(TbSettings, "CheckHkOn", KeepHkOn := !KeepHkOn)
If (KeepHkOn = 1)
{
	GoSub, KeepHkOn
	Menu, Tray, Check, %w_Lang014%
	Menu, OptionsMenu, Check, %o_Lang005%
}
Else
{
	GoSub, ResetHotkeys
	Menu, Tray, Uncheck, %w_Lang014%
	Menu, OptionsMenu, Uncheck, %o_Lang005%
	Traytip
}
return

KeepHkOn:
If (A_Gui > 2)
	return
If (KeepHkOn)
{
	GoSub, SaveData
	ActivateHotkeys(1, 1, 1, 1, 1)
}
return

ResetHotkeys:
ActivateHotkeys(0, 0, 0, 0, 0)
Menu, Tray, Tip, %AppName%
return

ActivateHotkeys:
Loop, %TabCount%
	If (InStr(CopyMenuLabels[A_Index], "()"))
		o_AutoKey[A_Index] := ""
If (CheckDuplicates(AbortKey, o_ManKey, o_AutoKey*))
{
	ActiveKeys := "Error"
	If (ShowStep)
		Traytip, %AppName%, %d_Lang032%,,3
	return
}
ActiveKeys := ActivateHotkeys(0, 1, 1, 1, 1)
If ((ActiveKeys > 0) && (ShowStep))
	Traytip, %AppName%, % ActiveKeys " " d_Lang025 ((IfDirectContext != "None") ? "`n[" RegExReplace(t_Lang009, ".*", "$u0") "]" : ""),,1
Menu, Tray, Tip, %AppName%`n%ActiveKeys% %d_Lang025%
return

h_Del:
Gui, chMacro:Default
Gui, chMacro:ListView, InputList%A_List%
RowSelection := LV_GetCount("Selected")
If (RowSelection > 0)
	GoSub, Remove
return

ClearPars:
Par0 := ""
Loop, 12
{
	Par%A_Index% := ""
	Det%A_Index% := ""
}
return

ListVars:
SavedVars(, UserVars)
FilteredVars := ""
Loop, Parse, UserVars, `n
	FilteredVars .= RegExMatch(A_LoopField, ":\s$") ? "" : A_LoopField "`n"
FilteredVars := RTrim(FilteredVars, "`n")
FileDelete, %SettingsFolder%\ListOfVars.txt
FileAppend, %FilteredVars%, %SettingsFolder%\ListOfVars.txt
Run, %DefaultEditor% %SettingsFolder%\ListOfVars.txt
return

;##### Hide / Close: #####

ShowHideTB:
ShowHide:
If (WinExist("ahk_id" PMCWinID))
{
	If (A_ThisLabel = "ShowHideTB")
	{
		WinGet, WinState, MinMax, ahk_id %PMCWinID%
		If (WinState = -1)
			WinActivate
		Else
		{
			Menu, Tray, Rename, %y_Lang001%, %y_Lang002%
			Gui, 1:Show, Hide
		}
	}
	Else
	{
		Menu, Tray, Rename, %y_Lang001%, %y_Lang002%
		Gui, 1:Show, Hide
	}
}
Else
{
	Menu, Tray, Rename, %y_Lang002%, %y_Lang001%
	Gui, 1:Show,, % (CurrentFileName ? CurrentFileName " - " : "") AppName " v" CurrentVersion
	Gosub, GuiSize
}
return

OnFinishAction:
If (OnFinishCode =  2)
{
	IL_Destroy(hIL_Icons), IL_Destroy(hIL_IconsHi)
	FileDelete, %SettingsFolder%\~ActiveProject.pmc
	Loop, %A_Temp%\PMC_*.ahk
		FileDelete, %A_LoopFileFullPath%
	ExitApp
}
If (OnFinishCode =  3)
	Shutdown, 1
If (OnFinishCode =  4)
	Shutdown, 5
If (OnFinishCode =  5)
	Shutdown, 2
If (OnFinishCode =  6)
	Shutdown, 0
If (OnFinishCode =  7)
{
	DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)
	return
}
If (OnFinishCode =  8)
{
	DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
	return
}
If (OnFinishCode =  9)
{
	DllCall("LockWorkStation")
	return
}
ExitApp

GuiClose:
If (!CloseAction)
{
	Gui, 1:+Disabled
	Gui, 35:-SysMenu hwndCloseSel +owner1
	Gui, 35:Color, FFFFFF
	Gui, 35:Add, Pic, y+20 Icon24 W48 H48, %ResDllPath%
	Gui, 35:Add, Text, -Wrap R1 yp x+10, %t_Lang148%:
	Gui, 35:Add, Radio, -Wrap Section Checked y+20 W140 vCloseApp R1, %t_Lang149%
	Gui, 35:Add, Radio, -Wrap yp x+10 W140 vMinToTray R1, %t_Lang150%
	Gui, 35:Add, Text, -Wrap xs R1 cGray, %d_Lang080%
	Gui, 35:Add, Button, -Wrap Section Default xs y+10 W90 H23 gTipClose2, %c_Lang020%
	Gui, 35:Show,, %AppName%
	WinWaitClose, ahk_id %CloseSel%
	Gui, 35:Submit, NoHide
	CloseAction := MinToTray ? "Minimize" : "Close"
	Gui, 1:-Disabled
}
If (CloseAction = "Minimize")
{
	GoSub, ShowHide
	return
}
Exit:
Gui, 1:+OwnDialogs
Gui, 1:Submit, NoHide
GoSub, SaveData
Gui, chMacro:Default
Gui, chMacro:ListView, InputList%A_List%
If (SavePrompt)
{
	GoSub, ProjBackup
	MsgBox, 35, %d_Lang005%, % d_Lang002 "`n`n" (CurrentFileName ? """" CurrentFileName """" : "")
	IfMsgBox, Yes
	{
		ActiveFileName := CurrentFileName
		If (CurrentFileName = "")
			GoSub, SelectFile
		IfExist %CurrentFileName%
		{
			FileDelete %CurrentFileName%
			If (ErrorLevel)
			{
				MsgBox, 16, %d_Lang007%, %d_Lang006%`n`n"%CurrentFileName%".
				return
			}
		}
		FileCopy, %SettingsFolder%\~ActiveProject.pmc, %CurrentFileName%, 1
		IfMsgBox, Cancel
			return
	}
	IfMsgBox, Cancel
		return
}
DetectHiddenWindows, On
WinGet, WindowState, MinMax, ahk_id %PMCWinID%
If (WindowState != -1)
	WinState := WindowState
If (WindowState = 0)
{
	GuiGetSize(mGuiWidth, mGuiHeight), MainWinSize := "W" mGuiWidth " H" mGuiHeight
	WinGetPos, mGuiX, mGuiY,,, ahk_id %PMCWinID%
	MainWinPos := "X" mGuiX " Y" mGuiY
}
If (WinExist("ahk_id " PrevID))
{
	WinGet, WindowState, MinMax, ahk_id %PrevID%
	If (WindowState = 0)
		GuiGetSize(pGuiWidth, pGuiHeight, 2), PrevWinSize := "W" pGuiWidth " H" pGuiHeight
}
ColSizes := ""
Loop % LV_GetCount("Col")
{
	SendMessage, 4125, A_Index - 1, 0,, % "ahk_id " ListID%A_List%
	ColSizes .= Floor(ErrorLevel / Round(A_ScreenDPI / 96, 2)) ","
}
StringTrimRight, ColSizes, ColSizes, 1
ColOrder := LVOrder_Get(11, ListID%A_List%)
GoSub, GetHotkeys
If (KeepDefKeys = 1)
	AutoKey := DefAutoKey, ManKey := DefManKey
IfWinExist, ahk_id %PMCOSC%
	GoSub, 28GuiClose
MainLayout := RbMain.GetLayout(), MacroLayout := RbMacro.GetLayout()
FileLayout := TbFile.Export(), RecPlayLayout := TbRecPlay.Export()
SettingsLayout := TbSettings.Export(), CommandLayout := TbCommand.Export()
EditLayout := TbEdit.Export(), ShowBands := ""
Loop, % RbMain.GetBandCount()
	ShowBands .= ShowBand%A_Index% ","
StringTrimRight, ShowBands, ShowBands, 1
GoSub, WriteSettings
IL_Destroy(hIL_Icons), IL_Destroy(hIL_IconsHi)
FileDelete, %SettingsFolder%\~ActiveProject.pmc
Loop, %A_Temp%\PMC_*.ahk
	FileDelete, %A_LoopFileFullPath%
ExitApp
return

;##### Default Settings: #####

LoadSettings:
If (!KeepDefKeys)
	AutoKey := "F3|F4|F5|F6|F7", ManKey := ""
AbortKey := "F8"
PauseKey := "F12"
RecKey := "F9"
RecNewKey := "F10"
RelKey := "CapsLock"
DelayG := 0
OnScCtrl := 1
ShowStep := 1
HideMainWin := 0
DontShowAdm := 0
DontShowPb := 0
DontShowRec := 0
DontShowEdt := 0
ConfirmDelete := 1
IfDirectContext := "None"
IfDirectWindow := ""
KeepHkOn := 0
Mouse := 1
Moves := 1
TimedI := 1
Strokes := 1
CaptKDn := 0
MScroll := 1
WClass := 1
WTitle := 1
MDelay := 0
DelayM := 10
DelayW := 333
MaxHistory := 100
TDelay := 10
ToggleC := 0
RecKeybdCtrl := 0
RecMouseCtrl := 0
CoordMouse := "Window"
TitleMatch := 2
TitleSpeed := "Fast"
HiddenWin := 0
HiddenText := 1
KeyMode := "Input"
KeyDelay := -1
MouseDelay := -1
ControlDelay := 1
FastKey := "Insert"
SlowKey := "Pause"
ClearNewList := 0
SpeedUp := 2
SpeedDn := 2
HideErrors := 0
MouseReturn := 0
ShowProgBar := 1
ShowBarOnStart := 0
AutoHideBar := 0
RandomSleeps := 0
RandPercent := 50
DrawButton := "RButton"
OnRelease := 1
OnEnter := 0
LineW := 2
ScreenDir := SettingsFolder "\MacroCreator\Screenshots"
GetWinTitle := "1,0,0,0,0"
DefaultMacro := ""
StdLibFile := ""
Ex_AbortKey := 0
Ex_PauseKey := 0
Ex_SM := 1
SM := "Input"
Ex_SI := 1
SI := "Force"
Ex_ST := 1
Ex_SP := 0
Ex_CM := 1
Ex_DH := 0
Ex_DT := 0
Ex_AF := 1
Ex_HK := 0
Ex_PT := 0
Ex_NT := 0
Ex_WN := 0
Ex_SC := 1
SC := 1
Ex_SW := 1
SW := 0
Ex_SK := 1
SK := -1
Ex_MD := 1
MD := -1
Ex_SB := 1
SB := -1
Ex_MT := 0
MT := 2
Ex_IN := 1
Ex_UV := 1
Ex_Speed := 0
ComCr := 1
ComAc := 0
Send_Loop := 0
TabIndent := 1
IndentWith := "Space"
ConvertBreaks := 1
ShowGroupNames := 0
TextWrap := 0
MacroFontSize := 8
PrevFontSize := 8
CommentUnchecked := 1
IncPmc := 0
Exe_Exp := 0
TbNoTheme := 0
AutoBackup := 1
MultInst := 0
EvalDefault := 1
CloseAction := ""
ShowLoopIfMark := 1
ShowActIdent := 1
SearchAreaColor := 0xFF0000
LoopLVColor := 0xFFFF80
IfLVColor := 0x0080FF
OSCPos := "X0 Y0"
OSTrans := 255
OSCaption := 0
AutoRefresh := 1
AutoSelectLine := 1
CustomColors := 0
BarInfo := 1
OnFinishCode := 1
sciPrev.SetWrapMode(0x0)
sciPrevF.SetWrapMode(0x0)
TB_Edit(tbPrev, "TextWrap", 0)
TB_Edit(tbPrevF, "TextWrap", 0)
TB_Edit(tbPrev, "TabIndent", 1)
TB_Edit(tbPrevF, "TabIndent", 1)
TB_Edit(tbPrev, "ConvertBreaks", 1)
TB_Edit(tbPrevF, "ConvertBreaks", 1)
TB_Edit(tbPrev, "CommentUnchecked", 1)
TB_Edit(tbPrevF, "CommentUnchecked", 1)

SplitPath, A_AhkPath,, AhkDir
ProgramsFolder := (A_PtrSize = 8) ? ProgramFiles " (x86)" : ProgramFiles
If (FileExist(AhkDir "\SciTE\SciTE.exe"))
	DefaultEditor := AhkDir "\SciTE\SciTE.exe"
Else If (FileExist(ProgramsFolder "\Notepad++\notepad++.exe"))
	DefaultEditor := ProgramsFolder "\Notepad++\notepad++.exe"
Else If (FileExist(ProgramFiles "\Sublime Text 2\sublime_text.exe"))
	DefaultEditor := ProgramFiles "\Sublime Text 2\sublime_text.exe"
Else If (FileExist(ProgramsFolder "\Notepad2\Notepad2.exe"))
	DefaultEditor := ProgramsFolder "\Notepad2\Notepad2.exe"
Else
	DefaultEditor := "notepad.exe"
WinSet, Transparent, %OSTrans%, ahk_id %PMCOSC%
GuiControl, 28:, OSTrans, 255
Gui, 28:-Caption
If (WinExist("ahk_id " PMCOSC))
{
	OSCPos := StrSplit(OSCPos, " ")
	OSCPos[1] := (SubStr(OSCPos[1], 2) > A_ScreenWidth || SubStr(OSCPos[1], 2) < 400) ? "X0" : OSCPos[1]
	OSCPos[2] := (SubStr(OSCPos[2], 2) > A_ScreenHeight || SubStr(OSCPos[2], 2) < 25) ? "Y0" : OSCPos[1]
	OSCPos := OSCPos[1] " " OSCPos[2]
	Gui, 28:Show, % OSCPos (ShowProgBar ? "H40" : "H30") " W415 NoActivate", %AppName%
}
GuiControl, 1:, CoordTip, <a>CoordMode</a>: %CoordMouse%
GuiControl, 1:, TModeTip, <a>TitleMatchMode</a>: %TitleMatch%
GuiControl, 1:, TSendModeTip, <a>SendMode</a>: %KeyMode%
GuiControl, 1:, THotkeyTip, % "<a>Hotkey</a>: " o_AutoKey[A_List]
GuiControl, 1:, ContextTip, Global <a>#If</a>: %IfDirectContext%
GuiControl, 1:, AbortKey, %AbortKey%
GuiControl, 1:, PauseKey, %PauseKey%
GuiControl, 1:, DelayG, 0
GoSub, %UserLayout%Layout
GoSub, CheckMenuItems
GoSub, DefaultMod
GoSub, ObjCreate
GoSub, LoadData
TB_Edit(tbPrev, "PrevRefreshButton", AutoRefresh)
TB_Edit(tbPrevF, "PrevRefreshButton", AutoRefresh)
TB_Edit(tbPrev, "GoToLine", AutoSelectLine)
TB_Edit(tbPrevF, "GoToLine", AutoSelectLine)
GoSub, PrevRefresh
GoSub, MacroFont
GoSub, PrevFont
SetColOrder:
ColOrder := "1,2,3,4,5,6,7,8,9,10,11"
Loop, %TabCount%
	LVOrder_Set(11, ColOrder, ListID%A_Index%)
SetColSizes:
WinGet, WinState, MinMax, ahk_id %PMCWinID%
ColSizes := WinState ? "70,185,335,60,60,100,150,225,85,50,60" : "70,130,190,50,40,85,95,95,60,40,50"
Loop, Parse, ColSizes, `,
	Col_%A_Index% := A_LoopField
Gui, chMacro:Default
Loop, %TabCount%
{
	Gui, chMacro:ListView, InputList%A_Index%
	Loop, 10
		LV_ModifyCol(A_Index, Col_%A_Index%)
}
Gui, chMacro:ListView, InputList%A_List%
GoSub, SetFinishButton
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
o_ManKey := Object()
o_TimesG := Object()

ObjParse:
Loop, Parse, AutoKey, |
	o_AutoKey.Push(A_LoopField)
Loop, Parse, ManKey, |
	o_ManKey.Push(A_LoopField)
return

SetBasicLayout:
SetDefaultLayout:
SetBestFitLayout:
If (A_ThisLabel = "SetBasicLayout")
	UserLayout := "Basic"
Else If (A_ThisLabel = "SetBestFitLayout")
	UserLayout := "BestFit"
Else
	UserLayout := "Default"
GoSub, %UserLayout%Layout
return

SetSmallIcons:
SetLargeIcons:
Gui, 1:+OwnDialogs
IconSize := (A_ThisLabel = "SetSmallIcons") ? "Small" : "Large"
MsgBox, 64, %AppName%, % d_Lang119 "`n`n" d_Lang120 "`n" StrReplace(m_Lang007 " > " v_Lang013, "&")
return

DefaultLayout:
Loop, % RbMain.GetBandCount()
	ShowBand%A_Index% := 1
TbFile.Reset(), TB_IdealSize(TbFile, TbFile_ID)
TbRecPlay.Reset(), TB_IdealSize(TbRecPlay, TbRecPlay_ID)
TbCommand.Reset(), TB_IdealSize(TbCommand, TbCommand_ID)
TbEdit.Reset(), TB_IdealSize(TbEdit, TbEdit_ID)
TbSettings.Reset(), TB_IdealSize(TbSettings, TbSettings_ID)
TB_Edit(TbFile, "Preview", ShowPrev)
TB_Edit(TbSettings, "HideMainWin", HideMainWin)
TB_Edit(TbSettings, "OnScCtrl", OnScCtrl)
TB_Edit(TbSettings, "CheckHkOn", KeepHkOn)
TB_Edit(TbSettings, "SetWin", 0)
TB_Edit(TbSettings, "SetJoyButton", 0)
TB_Edit(TbOSC, "ProgBarToggle", ShowProgBar)
Loop, 3
	RbMain.SetLayout(Default_Layout)
Menu, ToolbarsMenu, Check, %v_Lang014%
Menu, ToolbarsMenu, Check, %v_Lang015%
Menu, ToolbarsMenu, Check, %v_Lang016%
Menu, ToolbarsMenu, Check, %v_Lang017%
Menu, ToolbarsMenu, Check, %v_Lang018%
Menu, ViewMenu, Check, %v_Lang008%
Menu, ViewMenu, Check, %v_Lang009%
Menu, HotkeyMenu, Check, %v_Lang020%
Menu, HotkeyMenu, Check, %v_Lang021%
Menu, HotkeyMenu, Check, %v_Lang022%
Menu, HotkeyMenu, Check, %v_Lang023%
GoSub, TabSel
SavePrompt(SavePrompt, A_ThisLabel)
return

BestFitLayout:
Loop, % RbMain.GetBandCount()
	ShowBand%A_Index% := 1
TbFile.Reset(), TB_IdealSize(TbFile, TbFile_ID)
TbRecPlay.Reset(), TB_IdealSize(TbRecPlay, TbRecPlay_ID)
TbCommand.Reset(), TB_IdealSize(TbCommand, TbCommand_ID)
TbEdit.Reset(), TB_IdealSize(TbEdit, TbEdit_ID)
TbSettings.Reset(), TB_IdealSize(TbSettings, TbSettings_ID)
TB_Edit(TbFile, "Preview", ShowPrev)
TB_Edit(TbSettings, "HideMainWin", HideMainWin)
TB_Edit(TbSettings, "OnScCtrl", OnScCtrl)
TB_Edit(TbSettings, "CheckHkOn", KeepHkOn)
TB_Edit(TbSettings, "SetWin", 0)
TB_Edit(TbSettings, "SetJoyButton", 0)
TB_Edit(TbOSC, "ProgBarToggle", ShowProgBar)
BFLayout := "1," (TB_GetSize(TbFile) + 16) ",644|"
		.	"2," (TB_GetSize(TbRecPlay) + 16) ",644|"
		.	"5," (TB_GetSize(TbSettings) + 16) ",644|"
		.	"7,50,644|"
		.	"8,50,644|"
		.	"11," 75 * (A_ScreenDPI/96) ",902|"
		.	"3," (TB_GetSize(TbCommand) + 16) ",645|"
		.	"6,150,644|"
		.	"9,60,644|"
		.	"10,60,644|"
		.	"4," (TB_GetSize(TbEdit) + 16) ",645"
Loop, 3
	RbMain.SetLayout(BFLayout)
Menu, ToolbarsMenu, Check, %v_Lang014%
Menu, ToolbarsMenu, Check, %v_Lang015%
Menu, ToolbarsMenu, Check, %v_Lang016%
Menu, ToolbarsMenu, Check, %v_Lang017%
Menu, ToolbarsMenu, Check, %v_Lang018%
Menu, ViewMenu, Check, %v_Lang008%
Menu, ViewMenu, Check, %v_Lang009%
Menu, HotkeyMenu, Check, %v_Lang020%
Menu, HotkeyMenu, Check, %v_Lang021%
Menu, HotkeyMenu, Check, %v_Lang022%
Menu, HotkeyMenu, Check, %v_Lang023%
GoSub, TabSel
SavePrompt(SavePrompt, A_ThisLabel)
return

BasicLayout:
Loop, 3
	RbMain.SetLayout(Default_Layout)
ShowBands := "0,1,1,0,0,1,1,0,1,0,1"
Loop, Parse, ShowBands, `,
	ShowBand%A_Index% := A_LoopField
Loop, % RbMain.GetBandCount()
	RbMain.ShowBand(RbMain.IDToIndex(A_Index), ShowBand%A_Index%)
RecPlayLayout := "Record=" w_Lang047 ":54(Enabled AutoSize Dropdown),, PlayStart=" w_Lang048 ":46(Enabled AutoSize Dropdown)"
TB_Layout(TbRecPlay, RecPlayLayout, TbRecPlay_ID)
TbCommand.Reset(), TB_IdealSize(TbCommand, TbCommand_ID)
RbMain.SetBandWidth(TbRecPlay_ID, TB_GetSize(tbRecPlay)+16)
Menu, ToolbarsMenu, UnCheck, %v_Lang014%
Menu, ToolbarsMenu, Check, %v_Lang015%
Menu, ToolbarsMenu, Check, %v_Lang016%
Menu, ToolbarsMenu, UnCheck, %v_Lang017%
Menu, ToolbarsMenu, UnCheck, %v_Lang018%
Menu, ViewMenu, Check, %v_Lang008%
Menu, ViewMenu, Check, %v_Lang009%
Menu, HotkeyMenu, Check, %v_Lang020%
Menu, HotkeyMenu, UnCheck, %v_Lang021%
Menu, HotkeyMenu, Check, %v_Lang022%
Menu, HotkeyMenu, UnCheck, %v_Lang023%
GoSub, TabSel
SavePrompt(SavePrompt, A_ThisLabel)
return

WriteSettings:
IniWrite, %CurrentVersion%, %IniFilePath%, Application, Version
IniWrite, %Lang%, %IniFilePath%, Language, Lang
IniWrite, %LangVersion%, %IniFilePath%, Language, LangVersion
IniWrite, %LangLastCheck%, %IniFilePath%, Language, LangLastCheck
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
IniWrite, %DontShowAdm%, %IniFilePath%, Options, DontShowAdm
IniWrite, %DontShowPb%, %IniFilePath%, Options, DontShowPb
IniWrite, %DontShowRec%, %IniFilePath%, Options, DontShowRec
IniWrite, %DontShowEdt%, %IniFilePath%, Options, DontShowEdt
IniWrite, %ConfirmDelete%, %IniFilePath%, Options, ConfirmDelete
IniWrite, %ShowTips%, %IniFilePath%, Options, ShowTips
IniWrite, %NextTip%, %IniFilePath%, Options, NextTip
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
IniWrite, %KeyMode%, %IniFilePath%, Options, KeyMode
IniWrite, %KeyDelay%, %IniFilePath%, Options, KeyDelay
IniWrite, %ControlDelay%, %IniFilePath%, Options, ControlDelay
IniWrite, %CoordMouse%, %IniFilePath%, Options, CoordMouse
IniWrite, %TitleMatch%, %IniFilePath%, Options, TitleMatch
IniWrite, %TitleSpeed%, %IniFilePath%, Options, TitleSpeed
IniWrite, %KeyMode%, %IniFilePath%, Options, KeyMode
IniWrite, %KeyDelay%, %IniFilePath%, Options, KeyDelay
IniWrite, %MouseDelay%, %IniFilePath%, Options, MouseDelay
IniWrite, %ControlDelay%, %IniFilePath%, Options, ControlDelay
IniWrite, %HiddenWin%, %IniFilePath%, Options, HiddenWin
IniWrite, %HiddenText%, %IniFilePath%, Options, HiddenText
IniWrite, %SpeedUp%, %IniFilePath%, Options, SpeedUp
IniWrite, %SpeedDn%, %IniFilePath%, Options, SpeedDn
IniWrite, %HideErrors%, %IniFilePath%, Options, HideErrors
IniWrite, %MouseReturn%, %IniFilePath%, Options, MouseReturn
IniWrite, %ShowProgBar%, %IniFilePath%, Options, ShowProgBar
IniWrite, %ShowBarOnStart%, %IniFilePath%, Options, ShowBarOnStart
IniWrite, %AutoHideBar%, %IniFilePath%, Options, AutoHideBar
IniWrite, %RandomSleeps%, %IniFilePath%, Options, RandomSleeps
IniWrite, %RandPercent%, %IniFilePath%, Options, RandPercent
IniWrite, %DrawButton%, %IniFilePath%, Options, DrawButton
IniWrite, %OnRelease%, %IniFilePath%, Options, OnRelease
IniWrite, %OnEnter%, %IniFilePath%, Options, OnEnter
IniWrite, %LineW%, %IniFilePath%, Options, LineW
IniWrite, %ScreenDir%, %IniFilePath%, Options, ScreenDir
IniWrite, %GetWinTitle%, %IniFilePath%, Options, GetWinTitle
IniWrite, %DefaultEditor%, %IniFilePath%, Options, DefaultEditor
IniWrite, %DefaultMacro%, %IniFilePath%, Options, DefaultMacro
IniWrite, %StdLibFile%, %IniFilePath%, Options, StdLibFile
IniWrite, %KeepDefKeys%, %IniFilePath%, Options, KeepDefKeys
IniWrite, %TbNoTheme%, %IniFilePath%, Options, TbNoTheme
IniWrite, %AutoBackup%, %IniFilePath%, Options, AutoBackup
IniWrite, %MultInst%, %IniFilePath%, Options, MultInst
IniWrite, %EvalDefault%, %IniFilePath%, Options, EvalDefault
IniWrite, %CloseAction%, %IniFilePath%, Options, CloseAction
IniWrite, %ShowLoopIfMark%, %IniFilePath%, Options, ShowLoopIfMark
IniWrite, %ShowActIdent%, %IniFilePath%, Options, ShowActIdent
IniWrite, %SearchAreaColor%, %IniFilePath%, Options, SearchAreaColor
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
IniWrite, %Ex_SP%, %IniFilePath%, ExportOptions, Ex_SP
IniWrite, %Ex_CM%, %IniFilePath%, ExportOptions, Ex_CM
IniWrite, %Ex_DH%, %IniFilePath%, ExportOptions, Ex_DH
IniWrite, %Ex_DT%, %IniFilePath%, ExportOptions, Ex_DT
IniWrite, %Ex_AF%, %IniFilePath%, ExportOptions, Ex_AF
IniWrite, %Ex_HK%, %IniFilePath%, ExportOptions, Ex_HK
IniWrite, %Ex_PT%, %IniFilePath%, ExportOptions, Ex_PT
IniWrite, %Ex_NT%, %IniFilePath%, ExportOptions, Ex_NT
IniWrite, %Ex_WN%, %IniFilePath%, ExportOptions, Ex_WN
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
IniWrite, %IndentWith%, %IniFilePath%, ExportOptions, IndentWith
IniWrite, %ConvertBreaks%, %IniFilePath%, ExportOptions, ConvertBreaks
IniWrite, %ShowGroupNames%, %IniFilePath%, ExportOptions, ShowGroupNames
IniWrite, %IncPmc%, %IniFilePath%, ExportOptions, IncPmc
IniWrite, %Exe_Exp%, %IniFilePath%, ExportOptions, Exe_Exp
IniWrite, %MainWinSize%, %IniFilePath%, WindowOptions, MainWinSize
IniWrite, %MainWinPos%, %IniFilePath%, WindowOptions, MainWinPos
IniWrite, %WinState%, %IniFilePath%, WindowOptions, WinState
IniWrite, %ColSizes%, %IniFilePath%, WindowOptions, ColSizes
IniWrite, %ColOrder%, %IniFilePath%, WindowOptions, ColOrder
IniWrite, %PrevWinSize%, %IniFilePath%, WindowOptions, PrevWinSize
IniWrite, %ShowPrev%, %IniFilePath%, WindowOptions, ShowPrev
IniWrite, %TextWrap%, %IniFilePath%, WindowOptions, TextWrap
IniWrite, %MacroFontSize%, %IniFilePath%, WindowOptions, MacroFontSize
IniWrite, %PrevFontSize%, %IniFilePath%, WindowOptions, PrevFontSize
IniWrite, %CommentUnchecked%, %IniFilePath%, WindowOptions, CommentUnchecked
IniWrite, %CustomColors%, %IniFilePath%, WindowOptions, CustomColors
IniWrite, %OSCPos%, %IniFilePath%, WindowOptions, OSCPos
IniWrite, %OSTrans%, %IniFilePath%, WindowOptions, OSTrans
IniWrite, %OSCaption%, %IniFilePath%, WindowOptions, OSCaption
IniWrite, %AutoRefresh%, %IniFilePath%, WindowOptions, AutoRefresh
IniWrite, %AutoSelectLine%, %IniFilePath%, WindowOptions, AutoSelectLine
IniWrite, %ShowGroups%, %IniFilePath%, WindowOptions, ShowGroups
IniWrite, %BarInfo%, %IniFilePath%, WindowOptions, BarInfo
IniWrite, %IconSize%, %IniFilePath%, ToolbarOptions, IconSize
IniWrite, %UserLayout%, %IniFilePath%, ToolbarOptions, UserLayout
IniWrite, %MainLayout%, %IniFilePath%, ToolbarOptions, MainLayout
IniWrite, %MacroLayout%, %IniFilePath%, ToolbarOptions, MacroLayout
IniWrite, %FileLayout%, %IniFilePath%, ToolbarOptions, FileLayout
IniWrite, %RecPlayLayout%, %IniFilePath%, ToolbarOptions, RecPlayLayout
IniWrite, %SettingsLayout%, %IniFilePath%, ToolbarOptions, SettingsLayout
IniWrite, %CommandLayout%, %IniFilePath%, ToolbarOptions, CommandLayout
IniWrite, %EditLayout%, %IniFilePath%, ToolbarOptions, EditLayout
IniWrite, %ShowBands%, %IniFilePath%, ToolbarOptions, ShowBands
return

;###########################################################
; Original by jaco0646
; http://autohotkey.com/forum/topic51428.html
;###########################################################

#If (ctrl := HotkeyCtrlHasFocus())
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
If (GuiA != 15) && (GuiA != 3) && HotkeyCtrlHasFocus()!="ManKey"
{
	If (GetKeyState("Shift","P"))
		modifier .= "+"
	If (GetKeyState("Ctrl","P"))
		modifier .= "^"
	If (GetKeyState("Alt","P"))
		modifier .= "!"
}
Gui, %GuiA%:Submit, NoHide
If (A_ThisHotkey == "*BackSpace" && %ctrl% && !modifier)
	GuiControl, %GuiA%:,%ctrl%
Else
	GuiControl, %GuiA%:,%ctrl%, % modifier SubStr(A_ThisHotkey,2)
SavePrompt(true, A_ThisHotkey)
GoSub, SaveData
return
#If

;##################################################

;##### Subroutines: Checks #####

b_Start:
Gui, 1:Submit, NoHide
GoSub, b_Enable
If (!Record)
	HistCheck()
return

b_Enable:
GuiControl, 28:+Range1-%TabCount%, OSHK
GuiControl, 28:, OSHK, %A_List%
Gui, 1:+OwnDialogs
Gui, chMacro:Default
Gui, chMacro:ListView, InputList%A_List%
ListCount%A_List% := LV_GetCount(), ListCount := 0
DebugCheckError := false
Loop, %TabCount%
{
	ListCount += ListCount%A_Index%
	If (DebugCheckLoop[A_Index])
	{
		DebugCheckError := true
		MsgBox, 16, %d_Lang007%, % d_Lang085 A_Index " (" CopyMenuLabels[A_Index] ")"
	}
	Else If (DebugCheckIf[A_Index])
	{
		DebugCheckError := true
		MsgBox, 16, %d_Lang007%, % d_Lang086 A_Index " (" CopyMenuLabels[A_Index] ")"
	}
	If (DebugDefault[A_Index])
	{
		DebugCheckError := true
		MsgBox, 16, %d_Lang007%, % CopyMenuLabels[A_Index] "`n`n" d_Lang098
	}
}
Gui, chMacro:Default
Gui, chMacro:ListView, InputList%A_List%
GuiControl, chMacro:+Redraw, InputList%A_List%
If (ShowGroups)
	GoSub, EnableGroups
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
	If (Record = 1)
		GoSub, RowCheck
	If (WinActive("ahk_id " PMCWinID))
	{
		GuiControl, chMacro:+Redraw, InputList%A_List%
		Record := 0 ;, StopIt := 1
		Sleep, 100
		GoSub, RecStop
		; GoSub, ResetHotkeys
	}
	IfWinExist, ahk_id %PMCOSC%
		Gui, 28:+AlwaysOntop
}
Else
	GoSub, KeepHkOn
Gui, 1:Submit, NoHide
Gui, chMacro:ListView, InputList%A_List%
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
If (Record = 1)
	return
Critical
RowCheckInProgress := true
Gui, chMacro:Default
Gui, chMacro:ListView, InputList%A_List%
GuiControl, chMacro:-Redraw, InputList%A_List%
ListCount%A_List% := LV_GetCount()
IdxLv := "", ActLv := "", IsInIf := 0, IsInLoop := 0, RowColorLoop := 0, RowColorIf := 0
IsUserFunc := InStr(CopyMenuLabels[A_List], "()")
BadCmd := false, BadPos := false, FuncLn := false, MustDefault := false, DebugDefault[A_List] := false
HistData := RowCheckFunc()
GuiControl, chMacro:+Redraw, InputList%A_List%
DebugCheckLoop[A_List] := RowColorLoop
DebugCheckIf[A_List] := RowColorIf
If (BadPos)
	SetTimer, RowCheck, -100, 1
If (BadCmd)
{
	SetTimer, RowCheck, -100, 1
	Gui, 1:+OwnDialogs
	MsgBox, 16, %d_Lang007%, %d_Lang100%
}
RowCheckInProgress := false
Critical, Off
return

;##### Size & Position: #####

2GuiSize:
If (A_EventInfo = 1)
	return

GuiGetSize(GuiWidth, GuiHeight, 2)
GuiControl, 2:Move, LVPrevF, % "W" GuiWidth "H" GuiHeight-57
return

chPrevGuiSize:
GuiGetSize(GuiWidth, GuiHeight, "chPrev")
GuiControl, chPrev:Move, LVPrev, % "W" GuiWidth "H" GuiHeight-27
return

28GuiSize:
If (WinExist("ahk_id " PMCOSC))
	Gui, 28:Show, % (ShowProgBar ? "H40" : "H30") " W380 NoActivate", %AppName%
return

chMacroGuiSize:
GuiGetSize(GuiWidth, GuiHeight, "chMacro")
GuiControl, chMacro:Move, InputList%A_List%, % "W" GuiWidth-15 "H" GuiHeight-25
GuiControl, chMacro:Move, A_List, % "W" GuiWidth-40
GuiControl, chMacro:Move, MacrosMenu, % "X" GuiWidth-29
return

GuiSize:
If (A_EventInfo = 1)
	return
Critical
Loop, 3
	GuiGetSize(GuiWidth, GuiHeight)
RbMain.ShowBand(RbMain.IDToIndex(11))
If (!ShowBand11)
	RbMain.ShowBand(RbMain.IDToIndex(11), false)
RbMacro.ModifyBand(1, "MinHeight", (GuiHeight-MacroOffset)*(A_ScreenDPI/96))
RbMacro.ModifyBand(2, "MinHeight", (GuiHeight-MacroOffset)*(A_ScreenDPI/96))
GuiControl, 1:Move, cRbMacro, % "W" GuiWidth+5
GuiControl, 1:Move, Repeat, % "y" GuiHeight-23
GuiControl, 1:Move, Rept, % "y" GuiHeight-27
GuiControl, 1:Move, BarInfo, % "y" GuiHeight-28
GuiControl, 1:Move, BarEdit, % "y" GuiHeight-28
GuiControl, 1:Move, TimesM, % "y" GuiHeight-27
GuiControl, 1:Move, DelayT, % "y" GuiHeight-23
GuiControl, 1:Move, Delay, % "y" GuiHeight-27
GuiControl, 1:Move, DelayG, % "y" GuiHeight-27
GuiControl, 1:Move, ApplyT, % "y" GuiHeight-28
GuiControl, 1:Move, ApplyI, % "y" GuiHeight-28
GuiControl, 1:Move, sInput, % "y" GuiHeight-27
GuiControl, 1:Move, ApplyL, % "y" GuiHeight-28
GuiControl, 1:Move, InsertKey, % "y" GuiHeight-28
GuiControl, 1:Move, Separator1, % "y" GuiHeight-27
GuiControl, 1:Move, Separator2, % "y" GuiHeight-27
GuiControl, 1:Move, Separator3, % "y" GuiHeight-27
GuiControl, 1:Move, Separator4, % "y" GuiHeight-27
GuiControl, 1:Move, Separator5, % "y" GuiHeight-27
GuiControl, 1:Move, Separator6, % "y" GuiHeight-27
GuiControl, 1:Move, Separator7, % "y" GuiHeight-27
GuiControl, 1:Move, Separator8, % "y" GuiHeight-27
GuiControl, 1:MoveDraw, THotkeyTip, % "y" GuiHeight-23
GuiControl, 1:MoveDraw, ContextTip, % "y" GuiHeight-23
GuiControl, 1:MoveDraw, MacroContextTip, % "y" GuiHeight-23
GuiControl, 1:MoveDraw, CoordTip, % "y" GuiHeight-23
GuiControl, 1:MoveDraw, TModeTip, % "y" GuiHeight-23
GuiControl, 1:MoveDraw, TSendModeTip, % "y" GuiHeight-23
GuiControl, 1:MoveDraw, TLastMacroTip, % "y" GuiHeight-23
return

;##### MenuBar: #####

CreateMenuBar:
; Menus
Menu, RecOptMenu, Add, %d_Lang019%, RecOpt
Menu, RecOptMenu, Add
Menu, RecOptMenu, Add, %t_Lang021%, RecOpt
Menu, RecOptMenu, Add, %t_Lang023%, RecOpt
Menu, RecOptMenu, Add, %t_Lang031%, RecOpt
Menu, RecOptMenu, Add
Menu, RecOptMenu, Add, %t_Lang024%, RecOpt
Menu, RecOptMenu, Add, %t_Lang025%, RecOpt
Menu, RecOptMenu, Add, %t_Lang026%, RecOpt
Menu, RecOptMenu, Add, %t_Lang032%, RecOpt
Menu, RecOptMenu, Add
Menu, RecOptMenu, Add, %t_Lang027%, RecOpt
Menu, RecOptMenu, Add, %t_Lang029%, RecOpt
Menu, RecOptMenu, Add, %t_Lang030%, RecOpt

Menu, SpeedUpMenu, Add, 2x, SpeedOpt
Menu, SpeedUpMenu, Add, 4x, SpeedOpt
Menu, SpeedUpMenu, Add, 8x, SpeedOpt
Menu, SpeedUpMenu, Add, 16x, SpeedOpt
Menu, SpeedUpMenu, Add, 32x, SpeedOpt
Menu, SpeedUpMenu, Add, 64x, SpeedOpt
Menu, SpeedUpMenu, Add, 128x, SpeedOpt
Menu, SpeedUpMenu, Add, 256x, SpeedOpt
Menu, SpeedDnMenu, Add, 2x, SpeedOpt
Menu, SpeedDnMenu, Add, 4x, SpeedOpt
Menu, SpeedDnMenu, Add, 8x, SpeedOpt
Menu, SpeedDnMenu, Add, 16x, SpeedOpt
Menu, SpeedDnMenu, Add, 32x, SpeedOpt
Menu, SpeedDnMenu, Add, 64x, SpeedOpt
Menu, SpeedDnMenu, Add, 128x, SpeedOpt
Menu, SpeedDnMenu, Add, 256x, SpeedOpt
Menu, PlayOptMenu, Add, %r_Lang007%, ResetHotkeys
Menu, PlayOptMenu, Add
Menu, PlayOptMenu, Add, %r_Lang008%, PlayFrom
Menu, PlayOptMenu, Add, %r_Lang009%, PlayTo
Menu, PlayOptMenu, Add, %r_Lang010%, PlaySel
Menu, PlayOptMenu, Add
Menu, PlayOptMenu, Add, %t_Lang036%, :SpeedUpMenu
Menu, PlayOptMenu, Add, %t_Lang037%, :SpeedDnMenu
Menu, PlayOptMenu, Add
Menu, PlayOptMenu, Add, %t_Lang100%, PlayOpt
Menu, PlayOptMenu, Add, %t_Lang206%, PlayOpt
Menu, PlayOptMenu, Add, %t_Lang038%, PlayOpt
Menu, PlayOptMenu, Add, %t_Lang085%, PlayOpt
Menu, PlayOptMenu, Add, %t_Lang143%, PlayOpt
Menu, PlayOptMenu, Add, %t_Lang107%, PlayOpt

GoSub, UpdateRecPlayMenus

Menu, FileMenu, Add, %f_Lang001%`t%_s%Ctrl+N, New
Menu, FileMenu, Add, %f_Lang002%`t%_s%Ctrl+O, Open
Menu, FileMenu, Add, %f_Lang003%`t%_s%Ctrl+S, Save
Menu, FileMenu, Add, %f_Lang004%`t%_s%Ctrl+Shift+S, SaveAs
Menu, FileMenu, Add, %f_Lang005%, :RecentMenu
Menu, FileMenu, Add
Menu, FileMenu, Add, %f_Lang006%`t%_s%Ctrl+E, Export
Menu, FileMenu, Add, %f_Lang007%`t%_s%Ctrl+P, Preview
Menu, FileMenu, Add, %f_Lang008%`t%_s%Ctrl+Shift+E, EditScript
Menu, FileMenu, Add, %f_Lang009%`t%_s%Ctrl+Alt+T, Scheduler
Menu, FileMenu, Add
Menu, FileMenu, Add, %f_Lang010%`t%_s%Alt+F3, ListVars
Menu, FileMenu, Add
Menu, FileMenu, Add, %f_Lang011%`t%_s%Alt+F4, Exit

Menu, MacroMenu, Add, %r_Lang001%`t%_s%Ctrl+R, Record
Menu, MacroMenu, Add, %r_Lang002%, :RecOptMenu
Menu, MacroMenu, Add
Menu, MacroMenu, Add, %r_Lang003%`t%_s%Ctrl+Enter, PlayStart
Menu, MacroMenu, Add, %r_Lang004%, :PlayOptMenu
Menu, MacroMenu, Add, %r_Lang005%`t%_s%Ctrl+Shift+Enter, TestRun
Menu, MacroMenu, Add, %r_Lang006%`t%_s%Ctrl+Shift+T, RunTimer
Menu, MacroMenu, Add
Menu, MacroMenu, Add, %r_Lang007%`t%_s%Ctrl+Alt+D, ResetHotkeys
Menu, MacroMenu, Add
Menu, MacroMenu, Add, %r_Lang008%`t%_s%Alt+1, PlayFrom
Menu, MacroMenu, Add, %r_Lang009%`t%_s%Alt+2, PlayTo
Menu, MacroMenu, Add, %r_Lang010%`t%_s%Alt+3, PlaySel
Menu, MacroMenu, Add
Menu, MacroMenu, Add, %r_Lang011%`t%_s%Ctrl+H, SetWin
Menu, MacroMenu, Add
Menu, MacroMenu, Add, %r_Lang012%`t%_s%Ctrl+T, TabPlus
Menu, MacroMenu, Add, %r_Lang013%`t%_s%Ctrl+W, TabClose
Menu, MacroMenu, Add, %r_Lang014%`t%_s%Ctrl+Shift+D, DuplicateList
Menu, MacroMenu, Add, %r_Lang015%`t%_s%Ctrl+Shift+M, EditMacros
Menu, MacroMenu, Add
Menu, MacroMenu, Add, %r_Lang016%`t%_s%Ctrl+I, Import
Menu, MacroMenu, Add, %r_Lang017%`t%_s%Ctrl+Alt+S, SaveCurrentList

Menu, FuncMenu, Add, %u_Lang001%`t%_s%Ctrl+Shift+U, UserFunction
Menu, FuncMenu, Add, %u_Lang002%`t%_s%Ctrl+Shift+P, FuncParameter
Menu, FuncMenu, Add, %u_Lang003%`t%_s%Ctrl+Shift+N, FuncReturn
Menu, FuncMenu, Add
Menu, FuncMenu, Add, %u_Lang004%`t%_s%Ctrl+Shift+C, ConvertToFunc

Menu, CommandMenu, Add, %i_Lang001%`t%_s%F2, Mouse
Menu, CommandMenu, Add, %i_Lang002%`t%_s%F3, Text
Menu, CommandMenu, Add, %i_Lang003%`t%_s%F4, ControlCmd
Menu, CommandMenu, Add
Menu, CommandMenu, Add, %i_Lang004%`t%_s%F5, Sleep
Menu, CommandMenu, Add, %i_Lang005%`t%_s%Shift+F5, MsgBox
Menu, CommandMenu, Add, %i_Lang006%`t%_s%Ctrl+F5, KeyWait
Menu, CommandMenu, Add
Menu, CommandMenu, Add, %i_Lang007%`t%_s%F6, Window
Menu, CommandMenu, Add, %i_Lang008%`t%_s%F7, Image
Menu, CommandMenu, Add, %i_Lang009%`t%_s%F8, Run
Menu, CommandMenu, Add
Menu, CommandMenu, Add, %i_Lang010%`t%_s%F9, ComLoop
Menu, CommandMenu, Add, %i_Lang011%`t%_s%Shift+F9, ComGoto
Menu, CommandMenu, Add, %i_Lang012%`t%_s%Ctrl+F9, TimedLabel
Menu, CommandMenu, Add
Menu, CommandMenu, Add, %i_Lang013%`t%_s%F10, IfSt
Menu, CommandMenu, Add, %i_Lang014%`t%_s%Shift+F10, AsVar
Menu, CommandMenu, Add, %i_Lang015%`t%_s%Ctrl+F10, AsFunc
Menu, CommandMenu, Add
Menu, CommandMenu, Add, %i_Lang016%`t%_s%F11, Email
Menu, CommandMenu, Add, %i_Lang017%`t%_s%Shift+F11, DownloadFiles
Menu, CommandMenu, Add, %i_Lang018%`t%_s%Ctrl+F11, ZipFiles
Menu, CommandMenu, Add
Menu, CommandMenu, Add, %i_Lang019%`t%_s%F12, IECom
Menu, CommandMenu, Add, %i_Lang020%`t%_s%Shift+F12, ComInt
Menu, CommandMenu, Add, %i_Lang021%`t%_s%Ctrl+F12, SendMsg
Menu, CommandMenu, Add
Menu, CommandMenu, Add, %i_Lang022%`t%_s%Ctrl+Shift+F, CmdFind

TypesMenu := "Win`nFile`nString"
Loop
{
	If (!cType%A_Index%)
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
Menu, SelectMenu, Add, %s_Lang007%`t%_s%Ctrl+Up, MoveSelUp
Menu, SelectMenu, Add, %s_Lang008%`t%_s%Ctrl+Down, MoveSelDn
Menu, SelectMenu, Add
Menu, SelectMenu, Add, %s_Lang009%, SelType
Menu, SelectMenu, Add, %s_Lang010%, :SelCmdMenu

If (CopyMenuLabels[1] = "")
{
	CopyMenuLabels[1] := "Macro1"
	Menu, CopyTo, Add, % CopyMenuLabels[1], CopyList, Radio
	Menu, CopyTo, Check, % CopyMenuLabels[1]
}

Menu, GroupMenu, Add, %e_Lang018%`t%_s%Ctrl+Shift+G, GroupsMode
Menu, GroupMenu, Add
Menu, GroupMenu, Add, %e_Lang019%`t%_s%Ctrl+Shift+Y, AddGroup
Menu, GroupMenu, Add, %e_Lang020%`t%_s%Ctrl+Shift+R, RemoveGroup
Menu, GroupMenu, Add, %e_Lang021%, RemoveAllGroups
Menu, GroupMenu, Add
Menu, GroupMenu, Add, %e_Lang022%, CollapseGroups
Menu, GroupMenu, Add, %e_Lang023%, ExpandGroups

Menu, EditMenu, Add, %m_Lang005%`t%_s%Enter, EditButton
Menu, EditMenu, Add, %e_Lang007%`t%_s%Ctrl+X, CutRows
Menu, EditMenu, Add, %e_Lang008%`t%_s%Ctrl+C, CopyRows
Menu, EditMenu, Add, %e_Lang009%`t%_s%Ctrl+V, PasteRows
Menu, EditMenu, Add, %e_Lang010%`t%_s%Delete, Remove
Menu, EditMenu, Add
Menu, EditMenu, Add, %e_Lang001%`t%_s%Ctrl+D, Duplicate
Menu, EditMenu, Add, %m_Lang006%, :SelectMenu
Menu, EditMenu, Add, %e_Lang004%, :CopyTo
Menu, EditMenu, Add
Menu, EditMenu, Add, %e_Lang017%, :GroupMenu
Menu, EditMenu, Add
Menu, EditMenu, Add, %e_Lang011%`t%_s%Ctrl+PgUp, MoveUp
Menu, EditMenu, Add, %e_Lang012%`t%_s%Ctrl+PgDn, MoveDn
Menu, EditMenu, Add
Menu, EditMenu, Add, %e_Lang005%`t%_s%Ctrl+Z, Undo
Menu, EditMenu, Add, %e_Lang006%`t%_s%Ctrl+Y, Redo
Menu, EditMenu, Add
Menu, EditMenu, Add, %e_Lang003%`t%_s%Ctrl+F, FindReplace
Menu, EditMenu, Add, %e_Lang013%`t%_s%Ctrl+G, GoToMacro
Menu, EditMenu, Add, %e_Lang002%`t%_s%Ctrl+L, EditComm
Menu, EditMenu, Add, %e_Lang016%`t%_s%Ctrl+M, EditColor
Menu, EditMenu, Add
Menu, EditMenu, Add, %e_Lang014%`t%_s%Insert, ApplyL
Menu, EditMenu, Add, %e_Lang015%`t%_s%Ctrl+Insert, InsertKey
Menu, EditMenu, Default, %m_Lang005%`t%_s%Enter

Menu, CustomMenu, Add, %v_Lang014%, TbCustomize
Menu, CustomMenu, Add, %v_Lang015%, TbCustomize
Menu, CustomMenu, Add, %v_Lang016%, TbCustomize
Menu, CustomMenu, Add, %v_Lang017%, TbCustomize
Menu, CustomMenu, Add, %v_Lang018%, TbCustomize

Menu, PreviewMenu, Add, %v_Lang029%`t%_s%Ctrl+P, Preview
Menu, PreviewMenu, Add, %v_Lang030%, PrevCopy
Menu, PreviewMenu, Add
Menu, PreviewMenu, Add, %v_Lang031%, AutoRefresh
Menu, PreviewMenu, Add, %v_Lang032%, AutoSelectLine
Menu, PreviewMenu, Add
Menu, PreviewMenu, Add, %v_Lang033%, TabIndent
Menu, PreviewMenu, Add, %v_Lang034%, IndentWith, Radio
Menu, PreviewMenu, Add, %v_Lang035%, IndentWith, Radio
Menu, PreviewMenu, Add
Menu, PreviewMenu, Add, %v_Lang036%, ConvertBreaks
Menu, PreviewMenu, Add, %v_Lang037%, CommentUnchecked
Menu, PreviewMenu, Add, %v_Lang038%, TextWrap
Menu, PreviewMenu, Add, %v_Lang039%, ShowGroupNames

Menu, ToolbarsMenu, Add, %v_Lang014%, ShowHideBand
Menu, ToolbarsMenu, Add, %v_Lang015%, ShowHideBand
Menu, ToolbarsMenu, Add, %v_Lang016%, ShowHideBand
Menu, ToolbarsMenu, Add, %v_Lang017%, ShowHideBand
Menu, ToolbarsMenu, Add, %v_Lang018%, ShowHideBand
Menu, ToolbarsMenu, Add
Menu, ToolbarsMenu, Add, %v_Lang019%, :CustomMenu

Menu, HotkeyMenu, Add, %v_Lang020%, ShowHideBandHK
Menu, HotkeyMenu, Add, %v_Lang021%, ShowHideBandHK
Menu, HotkeyMenu, Add, %v_Lang022%, ShowHideBandHK
Menu, HotkeyMenu, Add, %v_Lang023%, ShowHideBandHK

Menu, SetIconSizeMenu, Add, %v_Lang027%, SetSmallIcons, Radio
Menu, SetIconSizeMenu, Add, %v_Lang028%, SetLargeIcons, Radio

Menu, SetLayoutMenu, Add, %v_Lang024%, SetBasicLayout
Menu, SetLayoutMenu, Add, %v_Lang025%, SetBestFitLayout
Menu, SetLayoutMenu, Add, %v_Lang026%, SetDefaultLayout

Menu, MacroFontMenu, Add, 6, MacroFontSet, Radio
Menu, MacroFontMenu, Add, 7, MacroFontSet, Radio
Menu, MacroFontMenu, Add, 8, MacroFontSet, Radio
Menu, MacroFontMenu, Add, 9, MacroFontSet, Radio
Menu, MacroFontMenu, Add, 10, MacroFontSet, Radio
Menu, MacroFontMenu, Add, 11, MacroFontSet, Radio
Menu, MacroFontMenu, Add, 12, MacroFontSet, Radio
Menu, MacroFontMenu, Add, 13, MacroFontSet, Radio
Menu, MacroFontMenu, Add, 14, MacroFontSet, Radio
Menu, MacroFontMenu, Add, 15, MacroFontSet, Radio
Menu, MacroFontMenu, Add, 16, MacroFontSet, Radio
Menu, MacroFontMenu, Add, 17, MacroFontSet, Radio
Menu, MacroFontMenu, Add, 18, MacroFontSet, Radio

Menu, ViewMenu, Add, %v_Lang001%, MainOnTop
Menu, ViewMenu, Add, %v_Lang002%, ShowLoopIfMark
Menu, ViewMenu, Add, %v_Lang003%, ShowActIdent
Menu, ViewMenu, Add
Menu, ViewMenu, Add, %v_Lang004%`t%_s%Ctrl+B, OnScControls
Menu, ViewMenu, Add, %v_Lang005%, :PreviewMenu
Menu, ViewMenu, Add, %v_Lang006%, :ToolbarsMenu
Menu, ViewMenu, Add, %v_Lang007%, :HotkeyMenu
Menu, ViewMenu, Add, %v_Lang008%, ShowLoopCounter
Menu, ViewMenu, Add, %v_Lang009%, ShowSearchBar
Menu, ViewMenu, Add
Menu, ViewMenu, Add, %v_Lang010%`t%_s%Alt+F5, SetColSizes
Menu, ViewMenu, Add, %v_Lang011%, :MacroFontMenu
Menu, ViewMenu, Add, %v_Lang012%, :SetIconSizeMenu
Menu, ViewMenu, Add, %v_Lang013%, :SetLayoutMenu

GoSub, BuildOnFinishMenu
Menu, OptionsMenu, Add, %o_Lang001%`t%_s%Ctrl+`,, Options
Menu, OptionsMenu, Add
Menu, OptionsMenu, Add, %o_Lang002%, HideMainWin
Menu, OptionsMenu, Add, %o_Lang003%, OnScCtrl
Menu, OptionsMenu, Add, %o_Lang004%, Capt
Menu, OptionsMenu, Add, %o_Lang005%, CheckHkOn
Menu, OptionsMenu, Add, %o_Lang006%, :OnFinishMenu
Menu, OptionsMenu, Add, %o_Lang007%, WinKey
Menu, OptionsMenu, Add, %o_Lang008%, SetJoyButton
Menu, OptionsMenu, Add
Menu, OptionsMenu, Add, %o_Lang009%, KeepDefKeys
Menu, OptionsMenu, Add, %o_Lang010%, DefaultMacro
Menu, OptionsMenu, Add, %o_Lang011%, RemoveDefault
Menu, OptionsMenu, Add
Menu, OptionsMenu, Add, %o_Lang012%`t%_s%Alt+F6, DefaultHotkeys
Menu, OptionsMenu, Add, %o_Lang013%`t%_s%Alt+F7, LoadDefaults

Menu, HelpMenu, Add, %h_Lang001%`t%_s%F1, Help
Menu, HelpMenu, Add, %h_Lang002%, Tutorials
Menu, HelpMenu, Add, %h_Lang003%, ShowTips
Menu, HelpMenu, Add
Menu, HelpMenu, Add, %h_Lang004%, Homepage
Menu, HelpMenu, Add, %h_Lang005%, Forum
Menu, HelpMenu, Add, %h_Lang006%, HelpAHK
Menu, HelpMenu, Add
Menu, HelpMenu, Add, %h_Lang007%, CheckNow
Menu, HelpMenu, Add, %h_Lang008%, AutoUpdate
Menu, HelpMenu, Add
Menu, HelpMenu, Add, %h_Lang009%`t%_s%Shift+F1, HelpAbout

Loop, Parse, Start_Tips, `n
{
	StartTip_%A_Index% := A_LoopField
	MaxTips := A_Index
}

Menu, DonationMenu, Add, %p_Lang001%, DonatePayPal

Menu, MenuBar, Add, %m_Lang001%, :FileMenu
Menu, MenuBar, Add, %m_Lang002%, :MacroMenu
Menu, MenuBar, Add, %m_Lang003%, :CommandMenu
Menu, MenuBar, Add, %m_Lang004%, :FuncMenu
Menu, MenuBar, Add, %m_Lang005%, :EditMenu
Menu, MenuBar, Add, %m_Lang006%, :SelectMenu
Menu, MenuBar, Add, %m_Lang007%, :ViewMenu
Menu, MenuBar, Add, %m_Lang008%, :OptionsMenu
Menu, MenuBar, Add, %m_Lang009%, :DonationMenu
Menu, MenuBar, Add, %m_Lang010%, :HelpMenu

Gui, Menu, MenuBar

Menu, ToolbarMenu, Add, %c_Lang022%, OSCClose
Menu, ToolbarMenu, Add
Menu, ToolbarMenu, Add, %t_Lang104%, ToggleTB
Menu, ToolbarMenu, Add, %t_Lang105%, ShowHide

Loop, Parse, BIV_Characters, `n
	Menu, BI_Characters, Add, %A_LoopField%, InsertBIVar
Loop, Parse, BIV_Properties, `n
	Menu, BI_Properties, Add, %A_LoopField%, InsertBIVar
Loop, Parse, BIV_Date, `n
	Menu, BI_Date, Add, %A_LoopField%, InsertBIVar
Loop, Parse, BIV_Idle, `n
	Menu, BI_Idle, Add, %A_LoopField%, InsertBIVar
Loop, Parse, BIV_System, `n
	Menu, BI_System, Add, %A_LoopField%, InsertBIVar
Loop, Parse, BIV_Misc, `n
	Menu, BI_Misc, Add, %A_LoopField%, InsertBIVar
Loop, Parse, BIV_Loop, `n
	Menu, BI_Loop, Add, %A_LoopField%, InsertBIVar
Menu, BuiltInMenu, Add, %b_Lang001%, :BI_Characters
Menu, BuiltInMenu, Add, %b_Lang002%, :BI_Properties
Menu, BuiltInMenu, Add, %b_Lang003%, :BI_Date
Menu, BuiltInMenu, Add, %b_Lang004%, :BI_Idle
Menu, BuiltInMenu, Add, %b_Lang005%, :BI_System
Menu, BuiltInMenu, Add, %b_Lang006%, :BI_Misc
Menu, BuiltInMenu, Add, %b_Lang007%, :BI_Loop
Menu, BuiltInMenu, Add
Menu, BuiltInMenu, Add, Built-in Variables, HelpB
Menu, BuiltInMenu, Icon, Built-in Variables, %ResDllPath%, 24

Menu, Tray, Add, %w_Lang005%, PlayStart
Menu, Tray, Add, %w_Lang008%, f_AbortKey
Menu, Tray, Add, %w_Lang004%, Record
Menu, Tray, Add, %r_Lang006%, RunTimer
Menu, Tray, Add
Menu, Tray, Add, %t_Lang121%, SlowKeyToggle
Menu, Tray, Add, %t_Lang120%, FastKeyToggle
Menu, Tray, Add
Menu, Tray, Add, %r_Lang007%, ResetHotkeys
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

GoSub, CheckMenuItems

; Menu Icons
Menu, FileMenu, Icon, %f_Lang001%`t%_s%Ctrl+N, %ResDllPath%, % IconsNames["new"]
Menu, FileMenu, Icon, %f_Lang002%`t%_s%Ctrl+O, %ResDllPath%, % IconsNames["open"]
Menu, FileMenu, Icon, %f_Lang003%`t%_s%Ctrl+S, %ResDllPath%, % IconsNames["save"]
Menu, FileMenu, Icon, %f_Lang004%`t%_s%Ctrl+Shift+S, %ResDllPath%, % IconsNames["saveas"]
Menu, FileMenu, Icon, %f_Lang005%, %ResDllPath%, % IconsNames["recent"]
Menu, FileMenu, Icon, %f_Lang006%`t%_s%Ctrl+E, %ResDllPath%, % IconsNames["export"]
Menu, FileMenu, Icon, %f_Lang007%`t%_s%Ctrl+P, %ResDllPath%, % IconsNames["preview"]
Menu, FileMenu, Icon, %f_Lang008%`t%_s%Ctrl+Shift+E, %ResDllPath%, % IconsNames["extedit"]
Menu, FileMenu, Icon, %f_Lang009%`t%_s%Ctrl+Alt+T, %ResDllPath%, % IconsNames["scheduler"]
Menu, FileMenu, Icon, %f_Lang011%`t%_s%Alt+F4, %ResDllPath%, % IconsNames["exit"]
Menu, MacroMenu, Icon, %r_Lang001%`t%_s%Ctrl+R, %ResDllPath%, % IconsNames["record"]
Menu, MacroMenu, Icon, %r_Lang003%`t%_s%Ctrl+Enter, %ResDllPath%, % IconsNames["play"]
Menu, MacroMenu, Icon, %r_Lang005%`t%_s%Ctrl+Shift+Enter, %ResDllPath%, % IconsNames["playtest"]
Menu, MacroMenu, Icon, %r_Lang006%`t%_s%Ctrl+Shift+T, %ResDllPath%, % IconsNames["timer"]
Menu, MacroMenu, Icon, %r_Lang011%`t%_s%Ctrl+H, %ResDllPath%, % IconsNames["context"]
Menu, MacroMenu, Icon, %r_Lang012%`t%_s%Ctrl+T, %ResDllPath%, % IconsNames["tabadd"]
Menu, MacroMenu, Icon, %r_Lang013%`t%_s%Ctrl+W, %ResDllPath%, % IconsNames["tabclose"]
Menu, MacroMenu, Icon, %r_Lang014%`t%_s%Ctrl+Shift+D, %ResDllPath%, % IconsNames["tabdup"]
Menu, MacroMenu, Icon, %r_Lang015%`t%_s%Ctrl+Shift+M, %ResDllPath%, % IconsNames["tabedit"]
Menu, MacroMenu, Icon, %r_Lang016%`t%_s%Ctrl+I, %ResDllPath%, % IconsNames["import"]
Menu, MacroMenu, Icon, %r_Lang017%`t%_s%Ctrl+Alt+S, %ResDllPath%, % IconsNames["tabsave"]
Menu, FuncMenu, Icon, %u_Lang001%`t%_s%Ctrl+Shift+U, %ResDllPath%, % IconsNames["userfunc"]
Menu, FuncMenu, Icon, %u_Lang002%`t%_s%Ctrl+Shift+P, %ResDllPath%, % IconsNames["parameter"]
Menu, FuncMenu, Icon, %u_Lang003%`t%_s%Ctrl+Shift+N, %ResDllPath%, % IconsNames["return"]
Menu, CommandMenu, Icon, %i_Lang001%`t%_s%F2, %ResDllPath%, % IconsNames["mouse"]
Menu, CommandMenu, Icon, %i_Lang002%`t%_s%F3, %ResDllPath%, % IconsNames["text"]
Menu, CommandMenu, Icon, %i_Lang003%`t%_s%F4, %ResDllPath%, % IconsNames["control"]
Menu, CommandMenu, Icon, %i_Lang004%`t%_s%F5, %ResDllPath%, % IconsNames["pause"]
Menu, CommandMenu, Icon, %i_Lang005%`t%_s%Shift+F5, %ResDllPath%, % IconsNames["dialogs"]
Menu, CommandMenu, Icon, %i_Lang006%`t%_s%Ctrl+F5, %ResDllPath%, % IconsNames["wait"]
Menu, CommandMenu, Icon, %i_Lang007%`t%_s%F6, %ResDllPath%, % IconsNames["window"]
Menu, CommandMenu, Icon, %i_Lang008%`t%_s%F7, %ResDllPath%, % IconsNames["image"]
Menu, CommandMenu, Icon, %i_Lang009%`t%_s%F8, %ResDllPath%, % IconsNames["run"]
Menu, CommandMenu, Icon, %i_Lang010%`t%_s%F9, %ResDllPath%, % IconsNames["loop"]
Menu, CommandMenu, Icon, %i_Lang011%`t%_s%Shift+F9, %ResDllPath%, % IconsNames["goto"]
Menu, CommandMenu, Icon, %i_Lang012%`t%_s%Ctrl+F9, %ResDllPath%, % IconsNames["timer"]
Menu, CommandMenu, Icon, %i_Lang013%`t%_s%F10, %ResDllPath%, % IconsNames["ifstatements"]
Menu, CommandMenu, Icon, %i_Lang014%`t%_s%Shift+F10, %ResDllPath%, % IconsNames["variables"]
Menu, CommandMenu, Icon, %i_Lang015%`t%_s%Ctrl+F10, %ResDllPath%, % IconsNames["functions"]
Menu, CommandMenu, Icon, %i_Lang016%`t%_s%F11, %ResDllPath%, % IconsNames["email"]
Menu, CommandMenu, Icon, %i_Lang017%`t%_s%Shift+F11, %ResDllPath%, % IconsNames["download"]
Menu, CommandMenu, Icon, %i_Lang018%`t%_s%Ctrl+F11, %ResDllPath%, % IconsNames["zip"]
Menu, CommandMenu, Icon, %i_Lang019%`t%_s%F12, %ResDllPath%, % IconsNames["ie"]
Menu, CommandMenu, Icon, %i_Lang020%`t%_s%Shift+F12, %ResDllPath%, % IconsNames["com"]
Menu, CommandMenu, Icon, %i_Lang021%`t%_s%Ctrl+F12, %ResDllPath%, % IconsNames["sendmsg"]
Menu, CommandMenu, Icon, %i_Lang022%`t%_s%Ctrl+Shift+F, %ResDllPath%, % IconsNames["findcmd"]
Menu, EditMenu, Icon, %m_Lang005%`t%_s%Enter, %ResDllPath%, % IconsNames["edit"]
Menu, EditMenu, Icon, %e_Lang007%`t%_s%Ctrl+X, %ResDllPath%, % IconsNames["cut"]
Menu, EditMenu, Icon, %e_Lang008%`t%_s%Ctrl+C, %ResDllPath%, % IconsNames["copy"]
Menu, EditMenu, Icon, %e_Lang009%`t%_s%Ctrl+V, %ResDllPath%, % IconsNames["paste"]
Menu, EditMenu, Icon, %e_Lang010%`t%_s%Delete, %ResDllPath%, % IconsNames["delete"]
Menu, EditMenu, Icon, %e_Lang001%`t%_s%Ctrl+D, %ResDllPath%, % IconsNames["duplicate"]
Menu, EditMenu, Icon, %e_Lang017%, %ResDllPath%, % IconsNames["groups"]
Menu, EditMenu, Icon, %e_Lang011%`t%_s%Ctrl+PgUp, %ResDllPath%, % IconsNames["moveup"]
Menu, EditMenu, Icon, %e_Lang012%`t%_s%Ctrl+PgDn, %ResDllPath%, % IconsNames["movedn"]
Menu, EditMenu, Icon, %e_Lang005%`t%_s%Ctrl+Z, %ResDllPath%, % IconsNames["undo"]
Menu, EditMenu, Icon, %e_Lang006%`t%_s%Ctrl+Y, %ResDllPath%, % IconsNames["redo"]
Menu, EditMenu, Icon, %e_Lang003%`t%_s%Ctrl+F, %ResDllPath%, % IconsNames["find"]
Menu, EditMenu, Icon, %e_Lang013%`t%_s%Ctrl+G, %ResDllPath%, % IconsNames["goto"]
Menu, EditMenu, Icon, %e_Lang002%`t%_s%Ctrl+L, %ResDllPath%, % IconsNames["comment"]
Menu, EditMenu, Icon, %e_Lang016%`t%_s%Ctrl+M, %ResDllPath%, % IconsNames["color"]
Menu, EditMenu, Icon, %e_Lang014%`t%_s%Insert, %ResDllPath%, % IconsNames["insert"]
Menu, EditMenu, Icon, %e_Lang015%`t%_s%Ctrl+Insert, %ResDllPath%, % IconsNames["keystroke"]
Menu, OptionsMenu, Icon, %o_Lang001%`t%_s%Ctrl+`,, %ResDllPath%, % IconsNames["options"]
Menu, HelpMenu, Icon, %h_Lang001%`t%_s%F1, %ResDllPath%, % IconsNames["help"]
Menu, DonationMenu, Icon, %p_Lang001%, %ResDllPath%, % IconsNames["donate"]
Menu, Tray, Icon, %w_Lang005%, %ResDllPath%, % IconsNames["play"]
Menu, Tray, Icon, %w_Lang008%, %ResDllPath%, % IconsNames["stop"]
Menu, Tray, Icon, %w_Lang004%, %ResDllPath%, % IconsNames["record"]
Menu, Tray, Icon, %r_Lang006%, %ResDllPath%, % IconsNames["timer"]
Menu, Tray, Icon, %t_Lang121%, %ResDllPath%, % IconsNames["slowdown"]
Menu, Tray, Icon, %t_Lang120%, %ResDllPath%, % IconsNames["fastforward"]
Menu, Tray, Icon, %w_Lang002%, %ResDllPath%, % IconsNames["preview"]
Menu, Tray, Icon, %f_Lang001%, %ResDllPath%, % IconsNames["new"]
Menu, Tray, Icon, %f_Lang002%, %ResDllPath%, % IconsNames["open"]
Menu, Tray, Icon, %f_Lang003%, %ResDllPath%, % IconsNames["save"]
Menu, Tray, Icon, %w_Lang003%, %ResDllPath%, % IconsNames["options"]
Menu, Tray, Icon, %f_Lang011%, %ResDllPath%, % IconsNames["exit"]
return

CheckMenuItems:
Menu, GroupMenu, % (ShowGroups) ? "Check" : "Uncheck", %e_Lang018%`t%_s%Ctrl+Shift+G
Menu, OptionsMenu, % (KeepDefKeys) ? "Check" : "Uncheck", %o_Lang009%
Menu, OptionsMenu, % (OnScCtrl) ? "Check" : "Uncheck", %o_Lang003%
Menu, OptionsMenu, % (WinKey) ? "Check" : "Uncheck", %o_Lang007%
Menu, OptionsMenu, % (HideMainWin) ? "Check" : "Uncheck", %o_Lang002%
Menu, OptionsMenu, % (KeepHkOn) ? "Check" : "Uncheck", %o_Lang005%
Menu, OptionsMenu, % (JoyHK) ? "Check" : "Uncheck", %o_Lang008%

Menu, HelpMenu, % (AutoUpdate) ? "Check" : "Uncheck", %h_Lang008%
Menu, ViewMenu, % (ShowLoopIfMark) ? "Check" : "Uncheck", %v_Lang002%
Menu, ViewMenu, % (ShowActIdent) ? "Check" : "Uncheck", %v_Lang003%
Menu, ViewMenu, % (ShowBarOnStart) ? "Check" : "Uncheck", %v_Lang004%`t%_s%Ctrl+B
Menu, Tray, % (ShowBarOnStart) ? "Check" : "Uncheck", %y_Lang003%

Menu, PreviewMenu, % (ShowPrev) ? "Check" : "Uncheck", %v_Lang029%`t%_s%Ctrl+P
Menu, PreviewMenu, % (AutoRefresh) ? "Check" : "Uncheck", %v_Lang031%
Menu, PreviewMenu, % (AutoSelectLine) ? "Check" : "Uncheck", %v_Lang032%
Menu, PreviewMenu, % (TabIndent) ? "Check" : "Uncheck", %v_Lang033%
Menu, PreviewMenu, % (IndentWith = "Tab") ? "Check" : "Uncheck", %v_Lang035%
Menu, PreviewMenu, % (IndentWith = "Space") ? "Check" : "Uncheck", %v_Lang034%
Menu, PreviewMenu, % (ConvertBreaks) ? "Check" : "Uncheck", %v_Lang036%
Menu, PreviewMenu, % (CommentUnchecked) ? "Check" : "Uncheck", %v_Lang037%
Menu, PreviewMenu, % (TextWrap) ? "Check" : "Uncheck", %v_Lang038%
Menu, PreviewMenu, % (ShowGroupNames) ? "Check" : "Uncheck", %v_Lang039%

Menu, MacroFontMenu, Check, %MacroFontSize%

Menu, SetIconSizeMenu, % (IconSize = "Small") ? "Check" : "Uncheck", %v_Lang027%
Menu, SetIconSizeMenu, % (IconSize = "Large") ? "Check" : "Uncheck", %v_Lang028%

Menu, ToolbarsMenu, % (ShowBand1) ? "Check" : "Uncheck", %v_Lang014%
Menu, ToolbarsMenu, % (ShowBand2) ? "Check" : "Uncheck", %v_Lang015%
Menu, ToolbarsMenu, % (ShowBand3) ? "Check" : "Uncheck", %v_Lang016%
Menu, ToolbarsMenu, % (ShowBand4) ? "Check" : "Uncheck", %v_Lang017%
Menu, ToolbarsMenu, % (ShowBand5) ? "Check" : "Uncheck", %v_Lang018%
Menu, ViewMenu, % (ShowBand11) ? "Check" : "Uncheck", %v_Lang008%
Menu, ViewMenu, % (ShowBand6) ? "Check" : "Uncheck", %v_Lang009%
Menu, HotkeyMenu, % (ShowBand7) ? "Check" : "Uncheck", %v_Lang020%
Menu, HotkeyMenu, % (ShowBand8) ? "Check" : "Uncheck", %v_Lang021%
Menu, HotkeyMenu, % (ShowBand9) ? "Check" : "Uncheck", %v_Lang022%
Menu, HotkeyMenu, % (ShowBand10) ? "Check" : "Uncheck", %v_Lang023%
return

UpdateCopyTo:
Menu, CopyTo, DeleteAll
Loop, %TabCount%
	Menu, CopyTo, Add, % CopyMenuLabels[A_Index], CopyList, Radio
Gui, chMacro:Submit, NoHide
Try Menu, CopyTo, Check, % CopyMenuLabels[A_List]
return

; Playback / Recording options menu:

ShowRecMenu:
Menu, RecOptMenu, Show, %mX%, %mY%
mX := "", mY := ""
return

RecOpt:
ItemVar := RecOptChecks[A_ThisMenuItemPos], %ItemVar% := !%ItemVar%
GoSub, UpdateRecPlayMenus
return

ShowPlayMenu:
Menu, PlayOptMenu, Show, %mX%, %mY%
mX := "", mY := ""
return

PlayOpt:
ItemVar := PlayOptChecks[A_ThisMenuItemPos-9], %ItemVar% := !%ItemVar%
GoSub, UpdateRecPlayMenus
return

SpeedOpt:
ItemVar := SubStr(A_ThisMenu, 1, 7), %ItemVar% := RegExReplace(A_ThisMenuItem, "\D")
GoSub, UpdateRecPlayMenus
return

UpdateRecPlayMenus:
If (ClearNewList)
	Menu, RecOptMenu, Check, %d_Lang019%
Else
	Menu, RecOptMenu, Uncheck, %d_Lang019%

If (Strokes)
	Menu, RecOptMenu, Check, %t_Lang021%
Else
	Menu, RecOptMenu, Uncheck, %t_Lang021%

If (CaptKDn)
	Menu, RecOptMenu, Check, %t_Lang023%
Else
	Menu, RecOptMenu, Uncheck, %t_Lang023%

If (Mouse)
	Menu, RecOptMenu, Check, %t_Lang024%
Else
	Menu, RecOptMenu, Uncheck, %t_Lang024%

If (MScroll)
	Menu, RecOptMenu, Check, %t_Lang025%
Else
	Menu, RecOptMenu, Uncheck, %t_Lang025%

If (Moves)
	Menu, RecOptMenu, Check, %t_Lang026%
Else
	Menu, RecOptMenu, Uncheck, %t_Lang026%

If (TimedI)
	Menu, RecOptMenu, Check, %t_Lang027%
Else
	Menu, RecOptMenu, Uncheck, %t_Lang027%

If (WClass)
	Menu, RecOptMenu, Check, %t_Lang029%
Else
	Menu, RecOptMenu, Uncheck, %t_Lang029%

If (WTitle)
	Menu, RecOptMenu, Check, %t_Lang030%
Else
	Menu, RecOptMenu, Uncheck, %t_Lang030%

If (RecMouseCtrl)
	Menu, RecOptMenu, Check, %t_Lang032%
Else
	Menu, RecOptMenu, Uncheck, %t_Lang032%

If (RecKeybdCtrl)
	Menu, RecOptMenu, Check, %t_Lang031%
Else
	Menu, RecOptMenu, Uncheck, %t_Lang031%

If (pb_From)
	Menu, PlayOptMenu, Check, %r_Lang008%
Else
	Menu, PlayOptMenu, Uncheck, %r_Lang008%

If (pb_To)
	Menu, PlayOptMenu, Check, %r_Lang009%
Else
	Menu, PlayOptMenu, Uncheck, %r_Lang009%

If (pb_Sel)
	Menu, PlayOptMenu, Check, %r_Lang010%
Else
	Menu, PlayOptMenu, Uncheck, %r_Lang010%

If (ShowStep)
	Menu, PlayOptMenu, Check, %t_Lang100%
Else
	Menu, PlayOptMenu, Uncheck, %t_Lang100%

If (HideErrors)
	Menu, PlayOptMenu, Check, %t_Lang206%
Else
	Menu, PlayOptMenu, Uncheck, %t_Lang206%

If (MouseReturn)
	Menu, PlayOptMenu, Check, %t_Lang038%
Else
	Menu, PlayOptMenu, Uncheck, %t_Lang038%

If (ShowBarOnStart)
	Menu, PlayOptMenu, Check, %t_Lang085%
Else
	Menu, PlayOptMenu, Uncheck, %t_Lang085%

If (AutoHideBar)
	Menu, PlayOptMenu, Check, %t_Lang143%
Else
	Menu, PlayOptMenu, Uncheck, %t_Lang143%

If (RandomSleeps)
	Menu, PlayOptMenu, Check, %t_Lang107%
Else
	Menu, PlayOptMenu, Uncheck, %t_Lang107%

Count := 2
Loop, 8
{
	Menu, SpeedUpMenu, Uncheck, %Count%x
	Menu, SpeedDnMenu, Uncheck, %Count%x
	Count *= 2
}
Menu, SpeedUpMenu, Check, % (SpeedUp = 1 ? SpeedUp := 2 : SpeedUp) "x"
Menu, SpeedDnMenu, Check, % (SpeedDn = 1 ? SpeedDn := 2 : SpeedDn) "x"
return

OnFinish:
Menu, OnFinish, Add, %w_Lang021%, FinishOpt, Radio
Menu, OnFinish, Add, %w_Lang022%, FinishOpt, Radio
Menu, OnFinish, Add, %w_Lang023%, FinishOpt, Radio
Menu, OnFinish, Add, %w_Lang024%, FinishOpt, Radio
Menu, OnFinish, Add, %w_Lang025%, FinishOpt, Radio
Menu, OnFinish, Add, %w_Lang026%, FinishOpt, Radio
Menu, OnFinish, Add, %w_Lang027%, FinishOpt, Radio
Menu, OnFinish, Add, %w_Lang028%, FinishOpt, Radio
Menu, OnFinish, Add, %w_Lang029%, FinishOpt, Radio

Menu, OnFinish, Check, % w_Lang02%OnFinishCode%

Menu, OnFinish, Show, %mX%, %mY%
Menu, OnFinish, DeleteAll
SetTimer, FinishIcon, -1
GoSub, BuildOnFinishMenu
return

BuildOnFinishMenu:
Menu, OnFinishMenu, Add, %w_Lang021%, FinishOpt, Radio
Menu, OnFinishMenu, Add, %w_Lang022%, FinishOpt, Radio
Menu, OnFinishMenu, Add, %w_Lang023%, FinishOpt, Radio
Menu, OnFinishMenu, Add, %w_Lang024%, FinishOpt, Radio
Menu, OnFinishMenu, Add, %w_Lang025%, FinishOpt, Radio
Menu, OnFinishMenu, Add, %w_Lang026%, FinishOpt, Radio
Menu, OnFinishMenu, Add, %w_Lang027%, FinishOpt, Radio
Menu, OnFinishMenu, Add, %w_Lang028%, FinishOpt, Radio
Menu, OnFinishMenu, Add, %w_Lang029%, FinishOpt, Radio

Menu, OnFinishMenu, Uncheck, %w_Lang021%
Menu, OnFinishMenu, Uncheck, %w_Lang022%
Menu, OnFinishMenu, Uncheck, %w_Lang023%
Menu, OnFinishMenu, Uncheck, %w_Lang024%
Menu, OnFinishMenu, Uncheck, %w_Lang025%
Menu, OnFinishMenu, Uncheck, %w_Lang026%
Menu, OnFinishMenu, Uncheck, %w_Lang027%
Menu, OnFinishMenu, Uncheck, %w_Lang028%
Menu, OnFinishMenu, Uncheck, %w_Lang029%
Menu, OnFinishMenu, Check, % w_Lang02%OnFinishCode%
SetTimer, FinishIcon, -1
return

FinishOpt:
OnFinishCode := A_ThisMenuItemPos
GoSub, BuildOnFinishMenu
SetFinishButton:
If (OnFinishCode > 1)
	SetTimer, FinishIcon, -1
return

FinishIcon:
TB_Edit(TbSettings, "OnFinish",(OnFinishCode = 1) ? 0 : 1,,, (OnFinishCode = 1) ? 20 : 62)
return

ShowGroupsMenu:
Menu, GroupMenu, Show, %mX%, %mY%
return

AddGroup:
Gui, chMacro:Default
Gui, chMacro:Listview, InputList%A_List%
If A_OSVersion in WIN_2003,WIN_XP,WIN_2000
{
	Gui, 1:+OwnDialogs
	MsgBox, 16, %d_Lang007%, %d_Lang094%
	return
}
If (!LV_GetNext())
{
	Gui, 1:+OwnDialogs
	MsgBox, 16, %d_Lang089%, %d_Lang090%
	return
}
Gui, 37:+owner1 -MinimizeBox
Gui, chMacro:Default
Gui, 1:+Disabled
Gui, 37:Add, GroupBox, Section xm W450 H50, %w_Lang103%:
Gui, 37:Add, Edit, ys+20 xs+10 vGrName W430 r1, %t_Lang177%
Gui, 37:Add, Button, -Wrap Section Default xm W75 H23 gGrOK, %c_Lang020%
Gui, 37:Add, Button, -Wrap ys W75 H23 gGrCancel, %c_Lang021%
Gui, 37:Show,, %t_Lang176%
Tooltip
return

GrOK:
Gui, 37:Submit, NoHide
Gui, 1:-Disabled
Gui, 37:Destroy
Gui, chMacro:Default
Gui, chMacro:Listview, InputList%A_List%
If (GrName = "")
	GrName := t_Lang177
If (!ShowGroups)
	GoSub, GroupsMode
LVManager[A_List].InsertGroup(, GrName)
LVManager[A_List].Add()
SavePrompt(true, A_ThisLabel)
GoSub, PrevRefresh
return

GrCancel:
37GuiClose:
37GuiEscape:
Gui, 1:-Disabled
Gui, 37:Destroy
return

GroupsMode:
Gui, chMacro:Default
Gui, chMacro:Listview, InputList%A_List%
If A_OSVersion in WIN_2003,WIN_XP,WIN_2000
{
	Gui, 1:+OwnDialogs
	MsgBox, 64, %AppName%, %d_Lang094%
	return
}
TB_Edit(TbEdit, "GroupsMode", ShowGroups := !ShowGroups)

EnableGroups:
Gui, chMacro:Submit, NoHide
Loop, %TabCount%
{
	Gui, chMacro:Listview, InputList%A_Index%
	GuiControl, chMacro:-g, InputList%A_Index%
	LVManager[A_Index].EnableGroups(ShowGroups, c_Lang061)
	GuiControl, chMacro:+gInputList, InputList%A_Index%
}
If (ShowGroups)
	Menu, GroupMenu, Check, %e_Lang018%`t%_s%Ctrl+Shift+G
Else
	Menu, GroupMenu, Uncheck, %e_Lang018%`t%_s%Ctrl+Shift+G
GoSub, PrevRefresh
return

RemoveGroup:
Gui, chMacro:Default
Gui, chMacro:Listview, InputList%A_List%
If (!LV_GetNext())
{
	Gui, 1:+OwnDialogs
	MsgBox, 16, %d_Lang089%, %d_Lang090%
	return
}
LVManager[A_List].RemoveGroup()
LVManager[A_List].Add()
SavePrompt(true, A_ThisLabel)
GoSub, PrevRefresh
return

RemoveAllGroups:
Gui, chMacro:Default
Gui, chMacro:Listview, InputList%A_List%
LVManager[A_List].RemoveAllGroups(c_Lang061)
LVManager[A_List].Add()
SavePrompt(true, A_ThisLabel)
GoSub, PrevRefresh
return

CollapseGroups:
ExpandGroups:
Gui, chMacro:Default
Gui, chMacro:Listview, InputList%A_List%
LVManager[A_List].CollapseAll(A_ThisLabel = "CollapseGroups")
return

;##### Languages: #####

LangChange:
SelLang := RegExReplace(SelLang, "\s/.*")
For i, l in LangFiles
{
	If (LangData.HasKey(i))
		lName := (InStr(i, "_")) ? LangData[i].Lang : LangData[i].Idiom, n := i
	Else
	{
		c := RegExReplace(i, "_.*")
		For e, l in LangData
		{
			If (InStr(e, c)=1)
			{
				lName := (InStr(e, "_")) ? l.Lang : l.Idiom, n := c
				break
			}
		}
	}
	If (SelLang = lName)
	{
		Lang := n
		break
	}
}
If (Lang = CurrentLang)
	return
UpdateLang:
Gui, Menu
Menu, SpeedUpMenu, DeleteAll
Menu, SpeedDnMenu, DeleteAll
Menu, RecOptMenu, DeleteAll
Menu, PlayOptMenu, DeleteAll
Menu, FileMenu, DeleteAll
Menu, MacroMenu, DeleteAll
Menu, FuncMenu, DeleteAll
Menu, CommandMenu, DeleteAll
Menu, SelectMenu, DeleteAll
Menu, SelCmdMenu, DeleteAll
Menu, GroupMenu, DeleteAll
Menu, EditMenu, DeleteAll
Menu, CustomMenu, DeleteAll
Menu, ToolbarsMenu, DeleteAll
Menu, HotkeyMenu, DeleteAll
Menu, SetIconSizeMenu, DeleteAll
Menu, SetLayoutMenu, DeleteAll
Menu, ViewMenu, DeleteAll
Menu, PreviewMenu, DeleteAll
Menu, OnFinishMenu, DeleteAll
Menu, OptionsMenu, DeleteAll
Menu, HelpMenu, DeleteAll
Menu, DonationMenu, DeleteAll
Menu, MenuBar, DeleteAll
Menu, ToolbarMenu, DeleteAll
Menu, BI_Characters, DeleteAll
Menu, BI_Properties, DeleteAll
Menu, BI_Date, DeleteAll
Menu, BI_Idle, DeleteAll
Menu, BI_System, DeleteAll
Menu, BI_Misc, DeleteAll
Menu, BI_Loop, DeleteAll
Menu, BuiltInMenu, DeleteAll
Menu, Tray, DeleteAll
If (PmcRecentFiles != "")
	Menu, RecentMenu, DeleteAll
PmcRecentFiles := ""
GoSub, LoadLang
GoSub, AddRecentFiles
GoSub, CreateMenuBar
If (InStr(CopyMenuLabels[A_List], "()"))
	GoSub, FuncTab
Else
	GoSub, MacroTab
CurrentLang := Lang

Gui, chMacro:Default
Loop, %TabCount%
{
	Gui, chMacro:ListView, InputList%A_Index%
	Loop, % LV_GetCount("Col")
		colTx := "w_Lang0"  29 + A_Index, LV_ModifyCol(A_Index,, %colTx%)
}
Gui, chMacro:ListView, InputList%A_List%

GuiControl, 1:, Repeat, %w_Lang015%:
GuiControl, 1:, DelayT, %w_Lang016%:
GuiControl, 1:, TLastMacroTip, %w_Lang115%: <a>%LastMacroRun%</a>
GuiControl, 1:-Redraw, cRbMain
RbMain.ModifyBand(RbMain.IDToIndex(7), "Text", w_Lang005)
, RbMain.ModifyBand(RbMain.IDToIndex(8), "Text", w_Lang007)
, RbMain.ModifyBand(RbMain.IDToIndex(9), "Text", w_Lang008)
, RbMain.ModifyBand(RbMain.IDToIndex(10), "Text", c_Lang003)
, RbMain.ModifyBand(RbMain.IDToIndex(11), "Text", w_Lang011 " (" t_Lang004 ")")
; File
TB_Edit(tbFile, "New", "", "", w_Lang112), TB_Edit(tbFile, "Open", "", "", w_Lang041), TB_Edit(tbFile, "Save", "", "", w_Lang042), TB_Edit(tbFile, "SaveAs", "", "", w_Lang043)
, TB_Edit(tbFile, "Export", "", "", w_Lang044), TB_Edit(tbFile, "Preview", "", "", w_Lang045), TB_Edit(tbFile, "Options", "", "", w_Lang046)
; RecPlay
TB_Edit(tbRecPlay, "Record", "", "", w_Lang047)
, TB_Edit(tbRecPlay, "PlayStart", "", "", w_Lang048), TB_Edit(tbRecPlay, "TestRun", "", "", w_Lang049), TB_Edit(tbRecPlay, "RunTimer", "", "", w_Lang050)
; Command
TB_Edit(tbCommand, "Mouse", "", "", w_Lang051), TB_Edit(tbCommand, "Text", "", "", w_Lang052), TB_Edit(tbCommand, "ControlCmd", "", "", w_Lang054)
, TB_Edit(tbCommand, "Sleep", "", "", w_Lang055), TB_Edit(tbCommand, "MsgBox", "", "", w_Lang056), TB_Edit(tbCommand, "KeyWait", "", "", w_Lang057)
, TB_Edit(tbCommand, "Window", "", "", w_Lang058), TB_Edit(tbCommand, "Image", "", "", w_Lang059), TB_Edit(tbCommand, "Run", "", "", w_Lang060)
, TB_Edit(tbCommand, "ComLoop", "", "", w_Lang061), TB_Edit(tbCommand, "ComGoto", "", "", w_Lang062), TB_Edit(tbCommand, "TimedLabel", "", "", w_Lang063)
, TB_Edit(tbCommand, "IfSt", "", "", w_Lang064), TB_Edit(tbCommand, "AsVar", "", "", w_Lang065), TB_Edit(tbCommand, "AsFunc", "", "", w_Lang066)
, TB_Edit(tbCommand, "Email", "", "", w_Lang067), TB_Edit(tbCommand, "DownloadFiles", "", "", w_Lang068), TB_Edit(tbCommand, "Zipfiles", "", "", w_Lang069)
, TB_Edit(tbCommand, "IECom", "", "", w_Lang070), TB_Edit(tbCommand, "ComInt", "", "", w_Lang071), TB_Edit(tbCommand, "SendMsg", "", "", w_Lang072)
, TB_Edit(tbCommand, "CmdFind", "", "", w_Lang092)
; Settings
TB_Edit(tbSettings, "HideMainWin", "", "", w_Lang013), TB_Edit(tbSettings, "OnScCtrl", "", "", w_Lang009)
, TB_Edit(tbSettings, "Capt", "", "", w_Lang012), TB_Edit(tbSettings, "CheckHkOn", "", "", w_Lang014)
, TB_Edit(tbSettings, "OnFinish", "", "", w_Lang020) , TB_Edit(tbSettings, "SetWin", "", "", t_Lang009)
, TB_Edit(tbSettings, "WinKey", "", "", w_Lang109), TB_Edit(tbSettings, "SetJoyButton", "", "", w_Lang110)
; Edit
TB_Edit(tbEdit, "EditButton", "", "", w_Lang093), TB_Edit(tbEdit, "CutRows", "", "", w_Lang081), TB_Edit(tbEdit, "CopyRows", "", "", w_Lang082), TB_Edit(tbEdit, "PasteRows", "", "", w_Lang083), TB_Edit(tbEdit, "Remove", "", "", w_Lang084)
, TB_Edit(tbEdit, "Duplicate", "", "", w_Lang080), TB_Edit(tbEdit, "SelectMenu", "", "", t_Lang139), TB_Edit(tbEdit, "CopyTo", "", "", w_Lang087)
, TB_Edit(tbEdit, "GroupsMode", "", "", w_Lang097)
, TB_Edit(tbEdit, "MoveUp", "", "", w_Lang078), TB_Edit(tbEdit, "MoveDn", "", "", w_Lang079)
, TB_Edit(tbEdit, "Undo", "", "", w_Lang085), TB_Edit(tbEdit, "Redo", "", "", w_Lang086)
, TB_Edit(tbEdit, "FindReplace", "", "", w_Lang088), TB_Edit(tbEdit, "EditComm", "", "", w_Lang089), TB_Edit(tbEdit, "EditColor", "", "", w_Lang090)
, TB_Edit(tbEdit, "TabPlus", "", "", w_Lang073), TB_Edit(tbEdit, "TabClose", "", "", w_Lang074), TB_Edit(tbEdit, "DuplicateList", "", "", w_Lang075), TB_Edit(tbEdit, "EditMacros", "", "", w_Lang053)
, TB_Edit(tbEdit, "Import", "", "", w_Lang076), TB_Edit(tbEdit, "SaveCurrentList", "", "", w_Lang077)
, TB_Edit(tbEdit, "UserFunction", "", "", w_Lang104), TB_Edit(tbEdit, "FuncParameter", "", "", w_Lang105), TB_Edit(tbEdit, "FuncReturn", "", "", w_Lang106)
; Preview
TB_Edit(tbPrev, "PrevCopy", "", "", c_Lang023), TB_Edit(tbPrev, "PrevRefreshButton", "", "", t_Lang014), TB_Edit(tbPrev, "GoToLine", "", "", t_Lang218)
, TB_Edit(tbPrev, "TabIndent", "", "", t_Lang011), TB_Edit(tbPrev, "ConvertBreaks", "", "", t_Lang190), TB_Edit(tbPrev, "CommentUnchecked", "", "", w_Lang108), TB_Edit(tbPrev, "TextWrap", "", "", t_Lang052), TB_Edit(tbPrev, "PrevFontShow", "", "", v_Lang011)
, TB_Edit(tbPrev, "EditScript", "", "", t_Lang138), TB_Edit(tbPrev, "PrevDock", "", "", t_Lang124), TB_Edit(tbPrev, "Preview", "", "", c_Lang022)

, TB_Edit(tbPrevF, "PrevCopy", "", "", c_Lang023), TB_Edit(tbPrevF, "PrevRefreshButton", "", "", t_Lang014), TB_Edit(tbPrevF, "GoToLine", "", "", t_Lang218)
, TB_Edit(tbPrevF, "TabIndent", "", "", t_Lang011), TB_Edit(tbPrevF, "ConvertBreaks", "", "", t_Lang190), TB_Edit(tbPrevF, "CommentUnchecked", "", "", w_Lang108), TB_Edit(tbPrevF, "TextWrap", "", "", t_Lang052), TB_Edit(tbPrev, "PrevFontShow", "", "", v_Lang011), TB_Edit(tbPrevF, "OnTop", "", "", t_Lang016)
, TB_Edit(tbPrevF, "EditScript", "", "", t_Lang138), TB_Edit(tbPrevF, "PrevDock", "", "", t_Lang125)
; OSC
TB_Edit(tbOSC, "OSPlay", "", "", t_Lang112), TB_Edit(tbOSC, "OSStop", "", "", t_Lang113), TB_Edit(tbOSC, "ShowPlayMenu", "", "", t_Lang114)
, TB_Edit(tbOSC, "RecStart", "", "", t_Lang115), TB_Edit(tbOSC, "RecStartNew", "", "", t_Lang116), TB_Edit(tbOSC, "ShowRecMenu", "", "", t_Lang117)
, TB_Edit(tbOSC, "OSClear", "", "", t_Lang118)
, TB_Edit(tbOSC, "ProgBarToggle", "", "", t_Lang119)
, TB_Edit(tbOSC, "SlowKeyToggle", "", "", t_Lang121), TB_Edit(tbOSC, "FastKeyToggle", "", "", t_Lang120)
, TB_Edit(tbOSC, "ToggleTB", "", "", t_Lang122), TB_Edit(tbOSC, "ShowHideTB", "", "", t_Lang123)

FixedBar.Text := ["OpenT=" t_Lang126 ":42", "SaveT=" t_Lang127 ":59"
				, "", "CutT=" t_Lang128 ":9", "CopyT=" t_Lang129 ":8", "PasteT=" t_Lang130 ":44"
				, "", "RemoveT=" t_Lang132 ":10", "SelAllT=" t_Lang131 ":99"]
DllCall("SendMessageW", "Ptr", hFindEdit, "Uint", 0x1501, "Ptr", True, "WStr", w_Lang111) ; EM_SETCUEBANNER = 0x1501
GuiControl, 1:+Redraw, cRbMain

Gui 7:+LastFoundExist
IfWinExist
	GoSub, InsertKey
Gui 18:+LastFoundExist
IfWinExist
	GoSub, FindReplace
Gui 26:+LastFoundExist
IfWinExist
	GoSub, TipClose
GoSub, SetFindCmd
SavePrompt(SavePrompt, A_ThisLabel)
return

LoadLangFiles:
LangFiles := {}
Loop, Files, %SettingsFolder%\Lang\*.lang
{
	_L := StrReplace(A_LoopFileName, ".lang"), ReadData := {}
	Loop, Read, %A_LoopFileFullPath%
	{
		If (A_Index < 5)
			continue
		If (InStr(A_LoopReadLine, "; ")=1)
		{
			_Section := Trim(SubStr(A_LoopReadLine, 3))
			ReadData[_Section] := []
			continue
		}
		L := StrSplit(A_LoopReadLine, A_Tab)
		If (RegExMatch(L.2, " =$"))
			lVar := RTrim(StrReplace(L.2, " =")), ReadData[_Section][lVar] := Trim(L.3)
		Else If (L.3 != "")
			ReadData[_Section][lVar] .= ((ReadData[_Section][lVar] != "") ? "`n" : "") Trim(Trim(L.2) . A_Tab . Trim(L.3))
	}
	LangFiles[_L] := ReadData
}
return

LoadLang:
Lang_List := ""
For i, f in LangFiles
{
	If (LangData.HasKey(i))
	{
		lName := (InStr(i, "_")) ? LangData[i].Lang : LangData[i].Idiom
		lLocal := LangData[i].Local
	}
	Else
	{
		c := RegExReplace(i, "_.*")
		For e, l in LangData
		{
			If (InStr(e, c)=1)
			{
				lName := (InStr(e, "_")) ? l.Lang : l.Idiom
				lLocal := l.Local
				break
			}
		}
	}
	Lang_%i% := lName "`t" lLocal, Lang_List .= lName " / " lLocal "|"
}

For i, _Section in LangFiles[Lang]
{
	For _var, _value in _Section
		%_var% := _value
}

HelpDocsUrl := (InStr(Lang, "zh")=1) ?  "https://ahkcn.github.io/docs/AutoHotkey.htm"
			: (Lang = "de") ? "https://ahkde.github.io/docs/AutoHotkey.htm" : "https://www.autohotkey.com/docs"
Cmd_Tips := {}, IE_Tips := {}, Com_Tips := {}, Tips_List := ""
Loop, Parse, Ahk_Cmd_Index, `n
{
	TipArray := StrSplit(A_LoopField, A_Tab), Command := TipArray[1]
	Loop, Parse, Command, /, %A_Space%
		Cmd_Tips[A_LoopField] := TipArray[2], Tips_List .= A_LoopField "|"
}
Loop, Parse, IE_Cmd_Index, `n
{
	TipArray := StrSplit(A_LoopField, A_Tab), Command := TipArray[1]
	Loop, Parse, Command, /, %A_Space%
		IE_Tips[A_LoopField] := TipArray[2], Tips_List .= A_LoopField "|"
}
Loop, Parse, COM_CLSID_Index, `n
{
	TipArray := StrSplit(A_LoopField, A_Tab), Command := TipArray[1]
	Loop, Parse, Command, /, %A_Space%
		Com_Tips[A_LoopField] := TipArray[2], Tips_List .= A_LoopField "|"
}
Sort, Tips_List, UD|
TipArray := ""
return

;##### Command Search: #####
SetFindCmd:
Type_Keywords := "
(C Join,
" cType4 "    ; ControlClick
" cType5 "    ; Sleep
" cType6 "    ; MsgBox
" cType7 "    ; Loop
" cType15 "   ; PixelSearch
" cType16 "   ; ImageSearch
" cType56 "   ; ImageToText
OCR
" cType17 "   ; If_Statement
Else
" cType18 "   ; SendMessage
" cType19 "   ; PostMessage
" cType20 "   ; KeyWait
" cType21 "   ; Variable
" cType29 "   ; Break
" cType30 "   ; Continue
" cType35 "   ; Label
" cType36 "   ; Goto
" cType37 "   ; Gosub
" cType38 "   ; LoopRead
" cType39 "   ; LoopParse
" cType40 "   ; LoopFilePattern
" cType41 "   ; LoopRegistry
Loop (files & folders)
Loop (normal)
Loop (parse a string)
Loop (read file contents)
Loop (registry)
Until
" cType43 "   ; Expression
" cType44 "   ; Function
" cType45 "   ; For
" cType46 "   ; Method
" cType47 "   ; UserFunction
" cType48 "   ; FuncParameter
Parameter
" cType49 "   ; FuncReturn
" cType50 "   ; SetTimer
" cType51 "   ; While
" cType52 "   ; SendEmail
CDO
" cType53 "   ; DownloadFiles
WinHttpDownloadToFile
" cType54 "   ; Zip
" cType55 "   ; Unzip
InternetExplorer
" cType34 "   ; COMInterface
)"
Types_Path := "
(C
" w_Lang051 " ; Mouse (F2)
" w_Lang055 " ; Pause (F5)
" w_Lang056 " ; Message Box (Shift+F5)
" w_Lang061 " ; Loop (F9)
" w_Lang059 " ; Image / Pixel Search / Image to Text (F7)
" w_Lang059 " ; Image / Pixel Search / Image to Text (F7)
" w_Lang059 " ; Image / Pixel Search / Image to Text (F7)
OCR
" w_Lang064 " ; If Statements (F10)
" w_Lang064 " ; If Statements (F10)
" w_Lang072 " ; Windows Messages (Ctrl+F12)
" w_Lang072 " ; Windows Messages (Ctrl+F12)
" w_Lang057 " ; Key Wait (Ctrl+F5)
" w_Lang065 " ; Variables / Arrays (Shift+F10)
" w_Lang061 " ; Loop (F9)
" w_Lang061 " ; Loop (F9)
" w_Lang062 " ; Go To / Label (Shift+F9)
" w_Lang062 " ; Go To / Label (Shift+F9)
" w_Lang062 " ; Go To / Label (Shift+F9)
" w_Lang061 " ; Loop (F9)
" w_Lang061 " ; Loop (F9)
" w_Lang061 " ; Loop (F9)
" w_Lang061 " ; Loop (F9)
" w_Lang061 " ; Loop (F9)
" w_Lang061 " ; Loop (F9)
" w_Lang061 " ; Loop (F9)
" w_Lang061 " ; Loop (F9)
" w_Lang061 " ; Loop (F9)
" w_Lang061 " ; Loop (F9)
" w_Lang071 " ; Expression / COM Interface (Shift+F12)
" w_Lang066 " ; Functions / Array Methods (Ctrl+F10)
" w_Lang061 " ; Loop (F9)
" w_Lang066 " ; Functions / Array Methods (Ctrl+F10)
" w_Lang104 " ; Create Function (Ctrl+Shift+U)
" w_Lang105 " ; Add Parameter (Ctrl+Shift+P)
" w_Lang105 " ; Add Parameter (Ctrl+Shift+P)
" w_Lang106 " ; Add Return (Ctrl+Shift+N)
" w_Lang063 " ; Set Timer (Ctrl+F9)
" w_Lang061 " ; Loop (F9)
" w_Lang067 " ; Send Email (F11)
" w_Lang067 " ; Send Email (F11)
" w_Lang068 " ; Download files (Shift+F11)
" w_Lang068 " ; Download files (Shift+F11)
" w_Lang069 " ; Zip / Unzip files (Ctrl+F11)
" w_Lang069 " ; Zip / Unzip files (Ctrl+F11)
" w_Lang070 " ; Internet Explorer (F12)
" w_Lang071 " ; Expression / COM Interface (Shift+F12)
)"
Types_Goto := "
(
Mouse
Sleep
MsgBox
ComLoop
Image
Image
Image
Image
IfSt
IfSt
SendMsg
SendMsg
KeyWait
AsVar
ComLoop
ComLoop
ComGoto
ComGoto
ComGoto
ComLoop
ComLoop
ComLoop
ComLoop
ComLoop
ComLoop
ComLoop
ComLoop
ComLoop
ComLoop
ComInt
AsFunc
ComLoop
AsFunc
UserFunction
FuncParameter
FuncParameter
FuncReturn
TimedLabel
ComLoop
Email
Email
DownloadFiles
DownloadFiles
ZipFiles
ZipFiles
IECom
ComInt
)"
Loop, Parse, Types_Path, `n
	Type%A_Index%_Path := A_LoopField
Loop, Parse, Types_Goto, `n
	Type%A_Index%_Goto := A_LoopField

Text_Keywords := "
(Join,
" cType1 "
" cType2 "
" cType8 "
" cType9 "
" cType10 "
" cType12 "
" cType22 "
)"
Text_Path := w_Lang052, Text_Goto := "Text"

Mouse_Keywords := "
(Join,
)"
While (Action%A_Index%)
	Mouse_Keywords .= Action%A_Index% ","
Mouse_Path := w_Lang051, Mouse_Goto := "Mouse"

Ctrl_Keywords := RegExReplace(CtrlCmdList, "\|", ",") ","
.	RegExReplace(CtrlCmd, "\|", ",") ","
.	RegExReplace(CtrlGetCmd, "\|", ",")
	Ctrl_Path := w_Lang054, Ctrl_Goto := "ControlCmd"

Win_Keywords := RegExReplace(WinCmdList, "\|", ",") ","
.	RegExReplace(WinCmd, "\|", ",") ","
.	RegExReplace(WinGetCmd, "\|", ",")
	Win_Path := w_Lang058, Win_Goto := "Window"

Misc_Keywords := RegExReplace(FileCmdList, "\|", ",")
Misc_Path := w_Lang060, Misc_Goto := "Run"

If_Keywords := "
(Join,
If
If (expression)
If A_Index
If Clipboard
If ErrorLevel
If var [not] between
If var [not] in
If var [not] contains MatchList
If var is [not] type
IfEqual
IfNotEqual
IfExist
IfNotExist
IfGreater
IfGreaterOrEqual
IfInString
IfNotInString
IfLess
IfLessOrEqual
IfMsgBox
IfWinActive
IfWinNotActive
IfWinExist
IfWinNotExist
)"
If_Keywords .= "," RegExReplace(IfList, "\$", ",")
If_Path := w_Lang064, If_Goto := "IfSt"

IE_Keywords := RegExReplace(IECmdList, "\|", ",")
IE_Path := w_Lang070, IE_Goto := "IECom"

Com_Keywords := RegExReplace(CLSList, "\|", ",")
Com_Path := w_Lang071, Com_Goto := "ComInt"

Func_Keywords := RegExReplace(BuiltinFuncList, "\$", ",")
Func_Path := w_Lang066, Func_Goto := "AsFunc"

Meth_Keywords := RegExReplace(ArrayMethodsList, "\$", ",")
Meth_Path := w_Lang066, Meth_Goto := "AsFunc"

Loop, Parse, KeywordsList, |
	Loop, Parse, %A_LoopField%_Keywords, `,
		Try %A_LoopField%_Desc := SBShowTip(A_LoopField)

If_Replace := { "If": If14
			,	"If (expression)": If15
			,	"If A_Index": If8
			,	"If Clipboard": If7
			,	"If ErrorLevel": If9
			,	"If var [not] between": If14
			,	"If var [not] in": If14
			,	"If var [not] contains MatchList": If14
			,	"If var is [not] type": If14
			,	"IfEqual": If14
			,	"IfNotEqual": If14
			,	"IfExist": If5
			,	"IfNotExist": If6
			,	"IfGreater": If14
			,	"IfGreaterOrEqual": If14
			,	"IfInString": If11
			,	"IfNotInString": If12
			,	"IfLess": If14
			,	"IfLessOrEqual": If14
			,	"IfMsgBox": If13
			,	"IfWinActive": If1
			,	"IfWinNotActive": If2
			,	"IfWinExist": If3
			,	"IfWinNotExist": If4}
return

#Include <Hotkeys>
#Include <Internal>
#Include <Recording>
#Include <Playback>
#Include <Export>
#Include <TabDrag>
#Include <Class_PMC>
#Include <Class_Toolbar>
#Include <Class_Rebar>
#Include <Class_LV_Rows>
#Include <Class_ObjIni>
#Include <Class_LV_Colors>
#Include <IL_EX>
#Include <Gdip_All>
#Include <JSON>
#Include <Vis2>
#Include <Eval>
#Include <SCI>
#SingleInstance Off
