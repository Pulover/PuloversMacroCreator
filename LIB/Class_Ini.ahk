Class Ini
{
	__New(File, Section="")
	{
		Loop, Read, %File%
		{
			If RegExMatch(A_LoopReadLine, "^\[(.*)\]$", Sect)
			{
				If (ReadSection <> "")
					this.Insert(ReadSection, %ReadSection%)
				ReadSection := Sect1, %Sect1% := []
				continue
			}
			If ((Section <> "") && (Section <> ReadSection))
				continue
			RegExMatch(A_LoopReadLine, "U)^(.*)=(.*)$", Key)
			Try
			{
				%Key1% := {Section: ReadSection, Key: Key1, Value: Key2}
				%ReadSection%.Insert(Key1, %Key1%)
			}
		}
		this.Insert(ReadSection, %ReadSection%)
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
					msgbox % varname ": " %varname%
				}
			}
		}
	}

	Write(File)
	{
		For each, Section in this
		{
			For each, Key in Section
				IniWrite, % Key.Value, %File%, % Key.Section, % Key.Key
		}
	}
	
	Get()
	{
		For each, Section in this
			For each, Key in Section
				List .= Key.Key " = " Key.Value "`n"
		return List
	}
	
	Set(List)
	{
		ReadSection := "UserVars"
		Loop, Parse, List, `n
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
			RegExMatch(A_LoopField, "U)^(.*)\s?=\s?(.*)$", Key)
			%Key1% := {Section: ReadSection, Key: Key1, Value: Key2}
			%ReadSection%.Insert(Key1, %Key1%)
			msgbox % this[ReadSection][Key1].Value
		}
		this.Insert(ReadSection, %ReadSection%)
	}
}
