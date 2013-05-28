Class Ini
{
	__New(File, Section="")
	{
		Loop, Read, %File%
		{
			If (A_LoopReadLine = "")
				continue
			If RegExMatch(A_LoopReadLine, "^\[(.*)\]$", Sect)
			{
				If (ReadSection <> "")
				{
					this.Insert(ReadSection, %ReadSection%)
				}
				ReadSection := Sect1, %Sect1% := []
				continue
			}
			If ((Section <> "") && (Section <> ReadSection))
				continue
			If (RegExMatch(A_LoopReadLine, "U)^(.*)=(.*)$", Key))
			{
				Key1 := RegExReplace(Key1, "[^\w\d#_@$]")
				%Key1% := {Section: ReadSection, Key: Key1, Value: Key2}
				%ReadSection%.Insert(Key1, %Key1%)
			}
		}
		this.Insert(ReadSection, %ReadSection%)
	}
	
	__Delete()
	{
		this.Remove("", Chr(255))
		this.SetCapacity(0)
		this.base := ""
	}

	Read()
	{
		local each, Section, Key
		
		For each, Section in this
		{
			For each, Key in Section
			{
				Try
				{
					VarName := Key.Key
					%VarName% := Key.Value
				}
			}
		}
	}

	Write(File)
	{
		For each, Section in this
			For each, Key in Section
				IniWrite, % Key.Value, %File%, % Key.Section, % Key.Key
	}
	
	Get()
	{
		For each, Section in this
			For each, Key in Section
				List .= Key.Key " = " Key.Value "`n"
		return List
	}
	
	Set(NewList)
	{
		this.Remove("", Chr(255))
		this.SetCapacity(0)
		ReadSection := "UserGlobalVars"
		%ReadSection% := []
		Loop, Parse, NewList, `n
		{
			If (A_LoopField = "")
				continue
			If RegExMatch(A_LoopField, "^\[(.*)\]$", Sect)
			{
				If (ReadSection <> "")
					this.Insert(ReadSection, %ReadSection%)
				ReadSection := Sect1, %Sect1% := []
				continue
			}
			If (RegExMatch(A_LoopField, "U)^(.*)\s?=\s?(.*)$", Key))
			{
				Key1 := RegExReplace(Key1, "[^\w\d#_@$]")
				%Key1% := {Section: ReadSection, Key: Key1, Value: Key2}
				%ReadSection%.Insert(Key1, %Key1%)
			}
		}
		this.Insert(ReadSection, %ReadSection%)
	}
	
	Tree(Gui, h=500, w=300)
	{
		global IniTV
		
		Gui, %Gui%:Default
		Gui, %Gui%:Add, TreeView, Checked H%h% W%w% vIniTV
		For each, Section in this
		{
			For each, Key in Section
			{
				If (A_Index = 1)
					Level := TV_Add(Key.Section, "", "Bold Check Expand")
				TV_Add(Key.Key " = " Key.Value, Level, "Check")
			}
		}
	}
}





