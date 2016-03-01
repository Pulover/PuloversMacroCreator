;========================================================================
;
; 				Class ObjIni
;
; Author:		Pulover [Rodolfo U. Batista]
;				rodolfoub@gmail.com
;
; Object-oriented INI class.
;
;========================================================================
Class ObjIni
{
	__New(File)
	{
		this.IniObj := Object()
		Loop, Read, %File%
		{
			If (A_LoopReadLine = "")
				continue
			If (RegExMatch(A_LoopReadLine, "^\[(.*)\]$", Sect))
			{
				ReadSection := Trim(Sect1)
			,	this.IniObj[ReadSection] := {}
				continue
			}
			If (RegExMatch(A_LoopReadLine, "U)^(.*)=(.*)$", Key))
			{
				If (ReadSection = "")
					ReadSection := "Main", this.IniObj[ReadSection] := {}
				Key1 := Trim(RegExReplace(Key1, "[^\w\d#_@$]"))
			,	this.IniObj[ReadSection][Key1] := Trim(Key2)
			}
		}
	}
	
	__Delete()
	{
		this.RemoveAt(1, this.Length())
		this.SetCapacity(0)
		this.base := ""
	}

	Read()
	{
		local Each, Section
		For Each, Section in this.IniObj
			For Key, Value in Section
				Try %Key% := Value
	}

	Write(File)
	{
		FileDelete, %File%
		For Each, Section in this.IniObj
			For Key, Value in Section
				IniWrite, % Value, %File%, %Each%, % Key
	}
	
	Get(AsObject := false, WhichSection := false, IncludeSection := false, AsExpression := false, Prefix := "")
	{
		If (AsObject)
		{
			If (!WhichSection)
				return this.IniObj.Clone()
			If (IsObject(this.IniObj[WhichSection]))
				return this.IniObj[WhichSection].Clone()
			Else
				return ""
		}
		If (!WhichSection)
		{
			For Each, Section in this.IniObj
			{
				If (IncludeSection)
					List .= AsExpression ? "; " Each "`n" : "[" Each "]`n"
				For Key, Value in Section
					List .= Prefix . (AsExpression ? Key " := " (RegExMatch(Value, "^-?\d+$") ? Value : """" Value """") "`n"
																: Key " = " Value "`n")
			}
		}
		Else If (IsObject(this.IniObj[WhichSection]))
		{
			For Key, Value in this.IniObj[WhichSection]
			{
				If (IncludeSection)
					List .= AsExpression ? "; " WhichSection "`n" : "[" WhichSection "]`n"
				List .= Prefix . (AsExpression ? Key " := " (RegExMatch(Value, "^-?\d+$") ? Value : """" Value """") "`n"
															: Key " = " Value "`n")
			}
		}
		return List
	}
	
	Set(NewList)
	{
		this.IniObj := Object()
		Loop, Parse, NewList, `n
		{
			If (A_LoopField = "")
				continue
			If (RegExMatch(A_LoopField, "^\[(.*)\]$", Sect))
			{
				ReadSection := Trim(Sect1)
			,	this.IniObj[ReadSection] := {}
				continue
			}
			If (RegExMatch(A_LoopField, "U)^(.*)\s?=\s?(.*)$", Key))
			{
				If (ReadSection = "")
					ReadSection := "Main", this.IniObj[ReadSection] := {}
				Key1 := Trim(RegExReplace(Key1, "[^\w\d#_@$]"))
			,	this.IniObj[ReadSection][Key1] := Trim(Key2)
			}
			For Each, Section in this.IniObj
				size := A_Index
		}
	}
	
	Tree(ChecksArray := "")
	{
		Idx := 0
		For Each, Section in this.IniObj
		{
			Idx++
		,	Level := TV_Add(Each, "", "Bold Check Expand")
			If (ChecksArray[Idx] = 0)
				TV_Modify(Level, "-Check")
			For Key, Value in Section
			{
				Idx++
			,	ItemID := TV_Add(Key " = " Value, Level, "Check")
				If (ChecksArray[Idx] = 0)
					TV_Modify(ItemID, "-Check")
			}
		}
	}
	
	TreeGetItems(IncludeSection := false, AsExpression := false, Prefix := "")
	{
		ItemID := 0
		Loop
		{
			ItemID := TV_GetNext(ItemID, "Full")
			If !(ItemID)
				break
			TV_GetText(ItemText, ItemID)
			If (!TV_GetParent(ItemID))
				ReadSection := ItemText
			If (!TV_Get(ItemID, "Check"))
				continue
			If ((IncludeSection) && (!TV_GetParent(ItemID)))
				List .= AsExpression ? "; " ItemText "`n" : "[" ItemText "]`n"
			If (RegExMatch(ItemText, "U)^(.*)\s?=\s?(.*)$", Key))
			{
				Key := Trim(Key1), Value := this.IniObj[ReadSection][Key]
			,	List .= Prefix . (AsExpression ? Key " := " (RegExMatch(Value, "^-?\d+$") ? Value : """" Value """") "`n"
															: Key " = " Value "`n")
			}
		}
		return List
	}
}

