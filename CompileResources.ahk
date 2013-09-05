#NoEnv
SetWorkingDir %A_ScriptDir%

FileDelete, Resources.dll
If ErrorLevel = 0
	TrayTip,, Error! File in use.
Else
{
	CreateIconsDll("Resources.dll", A_ScriptDir "\Resources\Icons")
	TrayTip,, Finished compiling Resources.dll.
}
Sleep, 2000
return