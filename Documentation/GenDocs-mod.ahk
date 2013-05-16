#SingleInstance, Force

;
; File encoding:  UTF-8
; Platform:  Windows XP/Vista/7
; Author:    fincs
;
; GenDocs v3.0-alpha001
;

#NoEnv
SendMode Input
SetWorkingDir, %A_ScriptDir%

FileEncoding, UTF-8

DEBUG = 1
VER = 3.0-alpha002

if !DEBUG
{
	; Quick and dirty look for SciTE to grab initial filename.
	_DefaultFName =
	_SciTE := GetSciTEInstance()
	if _SciTE
		_DefaultFName := _SciTE.CurrentFile, _SciTE := ""
}else
	_DefaultFName := A_ScriptDir "\MacroCreator_Help.ahk"

if 0 > 0
{
	CUI := true
	file = %1%
	CreateCHM := false
	msgbox %file%
	if 0 > 1
	if file = /chm
	{
		file = %2%
		msgbox %file%
		CreateCHM := true
	}
	FileAppend, GenDocs v%VER%`n`n, *
	gosub DocumentCUI
	ExitApp
}

Gui, +AlwaysOnTop
Gui, Add, Text, x6 y10 w310 h20, Select your script and click on Document.
Gui, Add, Edit, x6 y30 w280 h20 vfile, %_DefaultFName%
Gui, Add, CheckBox, x26 y60 w260 h20 vCreateCHM Disabled, Generate CHM file (not implemented yet)
Gui, Add, Button, x286 y30 w30 h20 gSelectFile, ...
Gui, Add, Button, x26 y90 w100 h30 gDocument, &Document
Gui, Add, Button, x186 y90 w100 h30 gGuiClose, Exit
Gui, Add, StatusBar
Util_Status("Ready.")
; Gui, Show, w325 h149, GenDocs v%VER%
Gosub, Document
ExitApp
return

GuiClose:
ExitApp

GuiDropFiles:
selected =
Loop, Parse, A_GuiEvent, `n
{
    GuiControl,, file, %A_LoopField%
	break
}
return

SelectFile:
Gui, +OwnDialogs
FileSelectFile, temp, 1,, Select AutoHotkey script, AutoHotkey scripts (*.ahk)

if temp =
	return
GuiControl,, file, %temp%
return

Document:
Gui, Submit, NoHide
Gui, +OwnDialogs

DocumentCUI:
SplitPath, file,, filedir
imglist := []
docs := RetrieveDocs(file)
GenerateDocs(file, docs)
Util_Status("Done!")
if !CUI
	SoundPlay, *64
return

Util_Status(ByRef t, err=0)
{
	global CUI
	if !CUI
	{
		SB_SetText(t)
		if err
			SoundPlay, *16
	}else
	{
		FileAppend, %t%`n, *
		if err
			ExitApp 1
	}
}

GetSciTEInstance()
{
	olderr := ComObjError()
	ComObjError(false)
	scite := ComObjActive("SciTE4AHK.Application")
	ComObjError(olderr)
	return IsObject(scite) ? scite : ""
}
