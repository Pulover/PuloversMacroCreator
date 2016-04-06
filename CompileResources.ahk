#NoEnv
SetBatchLines -1
SetWorkingDir %A_ScriptDir%

FileDelete, Resources.dll
Sleep, 100
CreateIconsDll("Resources.dll", A_ScriptDir "\Resources\Icons")
TrayTip,, Finished compiling Resources.dll.
Sleep, 2000
return