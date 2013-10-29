; Pulover's Macro Creator Portable Launcher
; Version: 1.0.0
; Compiler Settings
;@Ahk2Exe-SetName Pulover's Macro Creator Portable Launcher
;@Ahk2Exe-SetDescription Pulover's Macro Creator Portable Launcher
;@Ahk2Exe-SetVersion 1.0.0
;@Ahk2Exe-SetCopyright Copyright © 2012-2013 Rodolfo U. Batista
;@Ahk2Exe-SetOrigFilename MacroCreatorPortable.exe

#NoTrayIcon
SetWorkingDir %A_ScriptDir%
FileEncoding, UTF-8

FileGetTime, ModTime86, x86\MacroCreator\MacroCreator.ini, M
FileGetTime, ModTime64, x64\MacroCreator\MacroCreator.ini, M

If (ModTime86 > ModTime64)
	FileCopy, x86\MacroCreator\MacroCreator.ini, x64\MacroCreator\MacroCreator.ini, 1
Else If (ModTime64 > ModTime86)
	FileCopy, x64\MacroCreator\MacroCreator.ini, x86\MacroCreator\MacroCreator.ini, 1

If (A_Is64BitOS)
	Run, % "x64\MacroCreator\MacroCreator.exe" (%0% ? " " %0% : ""), x64\MacroCreator
Else
	Run, % "x86\MacroCreator\MacroCreator.exe" (%0% ? " " %0% : ""), x86\MacroCreator
