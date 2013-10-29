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

RunWait, %AhkDir%\Compiler\Ahk2Exe.exe /in MacroCreator.ahk /out Compiled\MacroCreator.exe /icon Resources\PMC4_Mult.ico /bin "%AhkDir%\Compiler\Unicode 32-bit.bin" /mpress 1,, UseErrorLevel
If ErrorLevel = ERROR
{
	MsgBox, 0x40000, Error, Error code: %A_LastError%
	ExitApp
}

RunWait, %AhkDir%\Compiler\Ahk2Exe.exe /in MacroCreator.ahk /out Compiled\MacroCreator-x64.exe /icon Resources\PMC4_Mult.ico /bin "%AhkDir%\Compiler\Unicode 64-bit.bin" /mpress 1,, UseErrorLevel
If ErrorLevel = ERROR
{
	MsgBox, 0x40000, Error, Error code: %A_LastError%
	ExitApp
}

RunWait, %AhkDir%\Compiler\Ahk2Exe.exe /in Launcher.ahk /out Compiled\MacroCreatorPortable.exe /icon Resources\PMC4_Mult.ico /bin "%AhkDir%\Compiler\Unicode 32-bit.bin" /mpress 1,, UseErrorLevel
If ErrorLevel = ERROR
{
	MsgBox, 0x40000, Error, Error code: %A_LastError%
	ExitApp
}

RunWait, %ProgramFiles%\Inno Setup 5\iscc.exe  %A_ScriptDir%\Installer.iss,, UseErrorLevel
If ErrorLevel = ERROR
{
	MsgBox, 0x40000, Error, Error code: %A_LastError%
	ExitApp
}

FileRemoveDir, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\Portable, 1
FileCreateDir, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\Portable
FileCreateDir, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\Portable\x86
FileCreateDir, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\Portable\x64
FileCreateDir, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\Portable\x86\MacroCreator
FileCreateDir, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\Portable\x64\MacroCreator

IniWrite, 0, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\MacroCreator.ini, Options, AutoUpdate

FileCopy, %A_MyDocuments%\Scripts\PuloversMacroCreator\License.txt, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\Portable\, 1
FileCopy, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\MacroCreator.exe, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\Portable\x86\MacroCreator\, 1
FileCopy, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\MacroCreator.ini, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\Portable\x86\MacroCreator\, 1
FileCopy, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\MacroCreator_Help.chm, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\Portable\x86\MacroCreator\, 1
FileCopy, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\Resources.dll, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\Portable\x86\MacroCreator\, 1
FileCopy, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\SciLexer-x86.dll, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\Portable\x86\MacroCreator\SciLexer.dll, 1
FileCopy, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\MacroCreator-x64.exe, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\Portable\x64\MacroCreator\MacroCreator.exe, 1
FileCopy, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\MacroCreator.ini, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\Portable\x64\MacroCreator\, 1
FileCopy, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\MacroCreator_Help.chm, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\Portable\x64\MacroCreator\, 1
FileCopy, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\Resources.dll, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\Portable\x64\MacroCreator\, 1
FileCopy, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\SciLexer-x64.dll, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\Portable\x64\MacroCreator\SciLexer.dll, 1
FileCopy, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\MacroCreatorPortable.exe, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\Portable\, 1

IniRead, Ver, %A_MyDocuments%\Scripts\PuloversMacroCreator\MacroCreator.ini, Application, Version
FileAppend,
(
Pulover's Macro Creator v%Ver% Portable Edition
===============================================

Thank you for downloading Pulover's Macro Creator.
Supported platforms: Windows XP SP3+, Vista, 7, 8

This file contains both x86 and x64 builds.

), %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\Portable\ReadMe.txt
FileDelete, %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\MacroCreator-Portable.zip
Try
	RunWait, %ProgramFiles%\7-Zip\7z.exe a -tzip %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\MacroCreator-Portable.zip %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\Portable\*
Catch
	RunWait, C:\Program Files\7-Zip\7z.exe a -tzip %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\MacroCreator-Portable.zip %A_MyDocuments%\Scripts\PuloversMacroCreator\Compiled\Portable\*

TrayTip,, Finished compiling files.
Sleep, 2000
return
