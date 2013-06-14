WindowRecord(ListID, WinDelay)
{
	global p_Title, p_Class, WTitle, WClass
	WinGetTitle, c_Title, A
	WinGetClass, c_Class, A
	If ((c_Class = "") && (c_Title = ""))
		return
	If WTitle = 1
	{
		Window := c_Title
		If WClass = 1
			Window := Window " ahk_class " c_Class
	}
	Else
	{
		If WClass = 1
			Window := "ahk_class " c_Class
	}
	If (c_Class = p_Class)
	{
		If WTitle = 0
			return
		Else
		{
			If (c_Title = p_Title)
				return
			Else
				LV_Add("Check", ListCount%ListID%+1, "WinActivate", "", 1, WinDelay, "WinActivate", "", Window)
		}
	}
	Else
		LV_Add("Check", ListCount%ListID%+1, "WinActivate", "", 1, WinDelay, "WinActivate", "", Window)
	p_Class := c_Class, p_Title := c_Title
}

ClickOn(xPos, yPos, Button, Click="")
{
	global RelHold, LastPos, RelKey, Toggle
	If RelHold = 1
	{
		Loop, Parse, LastPos, /
			iPar%A_Index% := A_LoopField
		Relative := RelToLastPos(iPar1, iPar2, xPos, yPos)
	}
	LastPos := xPos "/" yPos
	If GetKeyState(RelKey, Toggle)
	{
		xPos = Rel 0
		yPos = 0
		RelHold = 1
	}
	If Relative <> 
		Details := Relative " " Button ", " Click
	Else
		Details := xPos ", " yPos " " Button ", " Click
	return Details
}

RelToLastPos(lX, lY, cX, cY)
{
	cX -= lX
	cY -= lY
	return "Rel " cX "`, " cY
}

MoveCheck()
{
	global MDelay, LastPos, RelKey, Toggle, CoordMouse
	CoordMode, Mouse, %CoordMouse%
	MouseGetPos, xPos, yPos
	If (LastPos = xPos "/" yPos)
		return
	If A_TimeIdle < %MDelay%
		return
	If GetKeyState(RelKey, Toggle)
	{
		Loop, Parse, LastPos, /
			iPar%A_Index% := A_LoopField
		MovedPos := RelToLastPos(iPar1, iPar2, xPos, yPos)
	}
	Else
		MovedPos := xPos ", " yPos
	LastPos := xPos "/" yPos
	return MovedPos
}

TimeRecord()
{
	global LastTime
	static TimeCount
	TimeCount := A_TickCount - LastTime
,	LastTime := A_TickCount
	return TimeCount
}

Controlpos(z1, z2)
{
	return z1 - z2
}

