IELoad(Pwb)
{
	global StopIt
	
	If !Pwb
		Return False
	While !(Pwb.busy)
	{
		Sleep, 100
		If StopIt
			return False
	}
	While (Pwb.busy)
	{
		Sleep, 100
		If StopIt
			return False
	}
	While !(Pwb.document.Readystate = "Complete")
	{
		Sleep, 100
		If StopIt
			return False
	}
	Return True
}

