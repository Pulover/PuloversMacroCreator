; Pulover's Macro Creator Portable Launcher
; Version: 1.0

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
