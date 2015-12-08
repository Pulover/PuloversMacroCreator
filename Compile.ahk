#NoEnv
SetWorkingDir %A_ScriptDir%
SplitPath, A_AhkPath,, AhkDir

FileCreateDir, Compiled
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
FileCopy, Resources.dll, Compiled\Resources.dll, 1
FileCopy, SciLexer-x64.dll, Compiled\SciLexer-x64.dll, 1
FileCopy, SciLexer-x86.dll, Compiled\SciLexer-x86.dll, 1

RunWait, %AhkDir%\Compiler\Ahk2Exe.exe /in MacroCreator.ahk /out Compiled\MacroCreator.exe /icon Resources\PMC4_Mult.ico /bin "%AhkDir%\Compiler\Unicode 32-bit.bin",, UseErrorLevel
If ErrorLevel = ERROR
{
	MsgBox, 0x40000, Error, % "Error code: " A_LastError " at line " A_LineNumber - 3
	ExitApp
}

RunWait, %AhkDir%\Compiler\Ahk2Exe.exe /in MacroCreator.ahk /out Compiled\MacroCreator-x64.exe /icon Resources\PMC4_Mult.ico /bin "%AhkDir%\Compiler\Unicode 64-bit.bin",, UseErrorLevel
If ErrorLevel = ERROR
{
	MsgBox, 0x40000, Error, % "Error code: " A_LastError " at line " A_LineNumber - 3
	ExitApp
}

RunWait, %ProgramFiles%\Inno Setup 5\iscc.exe  %A_ScriptDir%\Installer.iss,, UseErrorLevel
If ErrorLevel = ERROR
{
	RunWait, %ProgramFiles% (x86)\Inno Setup 5\iscc.exe  %A_ScriptDir%\Installer.iss,, UseErrorLevel
	If ErrorLevel = ERROR
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

IniWrite, 0, Compiled\MacroCreator.ini, Options, AutoUpdate

FileCopy, License.txt, Compiled\MacroCreatorPortable\, 1
FileCopy, Compiled\MacroCreator.exe, Compiled\MacroCreatorPortable\x86\MacroCreator\, 1
FileCopy, Compiled\MacroCreator.ini, Compiled\MacroCreatorPortable\x86\MacroCreator\, 1
FileCopy, Compiled\MacroCreator_Help.chm, Compiled\MacroCreatorPortable\x86\MacroCreator\, 1
FileCopy, Compiled\MacroCreator_Help_CN.chm, Compiled\MacroCreatorPortable\x86\MacroCreator\, 1
FileCopy, Compiled\Resources.dll, Compiled\MacroCreatorPortable\x86\MacroCreator\, 1
FileCopy, Compiled\SciLexer-x86.dll, Compiled\MacroCreatorPortable\x86\MacroCreator\SciLexer.dll, 1
FileCopy, Compiled\MacroCreator-x64.exe, Compiled\MacroCreatorPortable\x64\MacroCreator\MacroCreator.exe, 1
FileCopy, Compiled\MacroCreator.ini, Compiled\MacroCreatorPortable\x64\MacroCreator\, 1
FileCopy, Compiled\MacroCreator_Help.chm, Compiled\MacroCreatorPortable\x64\MacroCreator\, 1
FileCopy, Compiled\MacroCreator_Help_CN.chm, Compiled\MacroCreatorPortable\x64\MacroCreator\, 1
FileCopy, Compiled\Resources.dll, Compiled\MacroCreatorPortable\x64\MacroCreator\, 1
FileCopy, Compiled\SciLexer-x64.dll, Compiled\MacroCreatorPortable\x64\MacroCreator\SciLexer.dll, 1
FileCopy, Compiled\MacroCreatorPortable.exe, Compiled\MacroCreatorPortable\, 1

IniRead, Ver, MacroCreator.ini, Application, Version
FileAppend,
(
Pulover's Macro Creator v%Ver% Portable Edition
===============================================

Thank you for downloading Pulover's Macro Creator.
Supported platforms: Windows XP SP3+, Vista, 7, 8, 8.1, 10

This file contains both x86 and x64 builds.

), Compiled\MacroCreatorPortable\ReadMe.txt
FileDelete, Compiled\MacroCreator-Portable.zip
Try
	RunWait, %ProgramFiles%\7-Zip\7z.exe a -tzip MacroCreator-Portable.zip MacroCreatorPortable\*, Compiled
Catch
	RunWait, C:\Program Files\7-Zip\7z.exe a -tzip MacroCreator-Portable.zip MacroCreatorPortable\*, Compiled

TrayTip,, Finished compiling files.
Sleep, 2000
return
