#NoEnv
SetBatchLines -1
SetWorkingDir %A_ScriptDir%
SplitPath, A_AhkPath,, AhkDir

FileCreateDir, Compiled
FileCreateDir, Compiled\Lang
FileCreateDir, Documentation\MacroCreator_Help-doc\Commands

IfWinExist, ahk_exe MacroCreator.exe
{
	WinClose
	WinWaitClose
}
FileDelete, Documentation\MacroCreator_Help-doc\*.html
FileDelete, Documentation\MacroCreator_Help-doc\Commands\*.html
FileCopy, Documentation\License.html, Documentation\MacroCreator_Help-doc, 1

RunWait, Documentation\GenDocs-mod.ahk,, UseErrorLevel
If ErrorLevel
	ExitApp
RunWait, BuildFiles.ahk,, UseErrorLevel
If ErrorLevel
	ExitApp
RunWait, Documentation\MacroCreator_Help-doc\CompileCHM.ahk,, UseErrorLevel
If ErrorLevel
	ExitApp
FileCopy, Documentation\MacroCreator_Help-doc\MacroCreator_Help.chm, Compiled\MacroCreator_Help.chm, 1

FileDelete, Compiled\Resources.dll
FileDelete, Compiled\SciLexer-x64.dll
FileDelete, Compiled\SciLexer-x86.dll
FileDelete, Compiled\Demo.pmc
FileDelete, Compiled\Lang\*.*

FileCopy, Resources.dll, Compiled\Resources.dll, 1
FileCopy, SciLexer-x64.dll, Compiled\SciLexer-x64.dll, 1
FileCopy, SciLexer-x86.dll, Compiled\SciLexer-x86.dll, 1
FileCopy, Documentation\MacroCreator_Help-doc\Examples\Demo.pmc, Compiled\Demo.pmc, 1
FileCopy, Lang\*.lang, Compiled\Lang\, 1

RunWait, %AhkDir%\Compiler\Ahk2Exe.exe /in MacroCreator.ahk /out Compiled\MacroCreator.exe /icon Resources\PMC4_Mult.ico /bin "%AhkDir%\Compiler\Unicode 32-bit.bin",, UseErrorLevel
If (ErrorLevel = "ERROR")
{
	MsgBox, 0x40000, Error, % "Error code: " A_LastError " at line " A_LineNumber - 3
	ExitApp
}
While (!FileExist("Compiled\MacroCreator.exe"))
	Sleep, 100
RunWait, %AhkDir%\Compiler\Ahk2Exe.exe /in MacroCreator.ahk /out Compiled\MacroCreator-x64.exe /icon Resources\PMC4_Mult.ico /bin "%AhkDir%\Compiler\Unicode 64-bit.bin",, UseErrorLevel
If (ErrorLevel = "ERROR")
{
	MsgBox, 0x40000, Error, % "Error code: " A_LastError " at line " A_LineNumber - 3
	ExitApp
}
While (!FileExist("Compiled\MacroCreator-x64.exe"))
	Sleep, 100

MsgBox, 262209, Sign files, Sign files with a valid certificate and click OK to continue.
IfMsgBox, Cancel
	ExitApp

RunWait, %ProgramFiles%\Inno Setup 6\iscc.exe  %A_ScriptDir%\Installer.iss,, UseErrorLevel
If (ErrorLevel = "ERROR")
{
	RunWait, %ProgramFiles% (x86)\Inno Setup 6\iscc.exe  %A_ScriptDir%\Installer.iss,, UseErrorLevel
	If (ErrorLevel = "ERROR")
	{
		MsgBox, 0x40000, Error, % "Error code: " A_LastError " at line " A_LineNumber - 3
		ExitApp
	}
}

FileRemoveDir, Compiled\MacroCreatorPortable, 1
FileCreateDir, Compiled\MacroCreatorPortable
FileCreateDir, Compiled\MacroCreatorPortable\x86
FileCreateDir, Compiled\MacroCreatorPortable\x64
FileCreateDir, Compiled\MacroCreatorPortable\x86\MacroCreator
FileCreateDir, Compiled\MacroCreatorPortable\x64\MacroCreator
FileCreateDir, Compiled\MacroCreatorPortable\x86\MacroCreator\Lang
FileCreateDir, Compiled\MacroCreatorPortable\x64\MacroCreator\Lang
FileCreateDir, Compiled\MacroCreatorPortable\x86\MacroCreator\Bin\leptonica_util
FileCreateDir, Compiled\MacroCreatorPortable\x64\MacroCreator\Bin\leptonica_util
FileCreateDir, Compiled\MacroCreatorPortable\x86\MacroCreator\Bin\tesseract\tessdata_best
FileCreateDir, Compiled\MacroCreatorPortable\x64\MacroCreator\Bin\tesseract\tessdata_best
FileCreateDir, Compiled\MacroCreatorPortable\x86\MacroCreator\Bin\tesseract\tessdata_fast
FileCreateDir, Compiled\MacroCreatorPortable\x64\MacroCreator\Bin\tesseract\tessdata_fast

IniWrite, 0, Compiled\MacroCreator.ini, Options, AutoUpdate

FileCopy, License.txt, Compiled\MacroCreatorPortable\, 1

FileCopy, Compiled\MacroCreator.exe, Compiled\MacroCreatorPortable\x86\MacroCreator\, 1
FileCopy, Compiled\MacroCreator.ini, Compiled\MacroCreatorPortable\x86\MacroCreator\, 1
FileCopy, Compiled\MacroCreator_Help.chm, Compiled\MacroCreatorPortable\x86\MacroCreator\, 1
FileCopy, Compiled\MacroCreator_Help_CN.chm, Compiled\MacroCreatorPortable\x86\MacroCreator\, 1
FileCopy, Compiled\Resources.dll, Compiled\MacroCreatorPortable\x86\MacroCreator\, 1
FileCopy, Compiled\SciLexer-x86.dll, Compiled\MacroCreatorPortable\x86\MacroCreator\SciLexer.dll, 1
FileCopy, Compiled\Demo.pmc, Compiled\MacroCreatorPortable\x86\MacroCreator\Demo.pmc, 1
FileCopy, Compiled\Lang\*.lang, Compiled\MacroCreatorPortable\x86\MacroCreator\Lang\, 1
FileCopy, Bin\leptonica_util\*.*, Compiled\MacroCreatorPortable\x86\MacroCreator\Bin\leptonica_util\, 1
FileCopy, Bin\tesseract\tesseract.exe, Compiled\MacroCreatorPortable\x86\MacroCreator\Bin\tesseract\, 1

FileCopy, Compiled\MacroCreator-x64.exe, Compiled\MacroCreatorPortable\x64\MacroCreator\MacroCreator.exe, 1
FileCopy, Compiled\MacroCreator.ini, Compiled\MacroCreatorPortable\x64\MacroCreator\, 1
FileCopy, Compiled\MacroCreator_Help.chm, Compiled\MacroCreatorPortable\x64\MacroCreator\, 1
FileCopy, Compiled\MacroCreator_Help_CN.chm, Compiled\MacroCreatorPortable\x64\MacroCreator\, 1
FileCopy, Compiled\Resources.dll, Compiled\MacroCreatorPortable\x64\MacroCreator\, 1
FileCopy, Compiled\SciLexer-x64.dll, Compiled\MacroCreatorPortable\x64\MacroCreator\SciLexer.dll, 1
FileCopy, Compiled\Demo.pmc, Compiled\MacroCreatorPortable\x64\MacroCreator\Demo.pmc, 1
FileCopy, Compiled\Lang\*.lang, Compiled\MacroCreatorPortable\x64\MacroCreator\Lang\, 1
FileCopy, Bin\leptonica_util\*.*, Compiled\MacroCreatorPortable\x64\MacroCreator\Bin\leptonica_util\, 1
FileCopy, Bin\tesseract\tesseract.exe, Compiled\MacroCreatorPortable\x64\MacroCreator\Bin\tesseract\, 1

IniRead, Ver, MacroCreator.ini, Application, Version
FileAppend,
(
Pulover's Macro Creator v%Ver% Portable Edition
===============================================

https://www.macrocreator.com

Thank you for downloading Pulover's Macro Creator.
Supported platforms: Windows 7, 8, 8.1, 10
NOT tested on: Windows XP, Vista

This file contains both x86 and x64 builds.

), Compiled\MacroCreatorPortable\ReadMe.txt
FileDelete, Compiled\PuloversMacroCreator-Portable.zip
FileDelete, Compiled\Lang.zip
Zip(A_ScriptDir "\Compiled\MacroCreatorPortable", A_ScriptDir "\Compiled\PuloversMacroCreator-Portable.zip")
Zip(A_ScriptDir "\Compiled\Lang\*.lang", A_ScriptDir "\Compiled\Lang.zip")

TrayTip,, Finished compiling files.
Sleep, 2000
return

Zip(FilesToZip, OutFile, SeparateFiles := false)
{
	Static vOptions := 4|16
	
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
