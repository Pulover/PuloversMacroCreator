;
; File encoding:  UTF-8
; Platform:  Windows XP/Vista/7
; Author:    fincs
;
; GenDocs v3.0-alpha004
;

#NoEnv
#SingleInstance Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

FileEncoding, UTF-8

DEBUG = 1
VER = 3.0-alpha004
_DefaultFName =

#include *i %A_ScriptDir%\..\$gendocs_scite

if DEBUG
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

Gui, +AlwaysOnTop +hwndguiHnd
Gui, Add, Text, , Select your script and click on Document.
Gui, Add, Edit, section w280 vfile
Gui, Add, Button, ys gSelectFile, ...
GuiControl,, file, %_DefaultFName%
Gui, Add, CheckBox, section xs vCreateCHM Disabled, Generate CHM file (not implemented yet)
Gui, Add, Button, xs+125 gDocument vdocBtn, &Document
Gui, Add, StatusBar
Util_Status("Ready.")
; Gui, Show,, GenDocs v%VER%
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
if !docs.contents.MaxIndex()
{
	Util_Status("No documentation could be found!", 1)
	return
}
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
