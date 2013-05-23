;========================================================================
;
; 				COMInterface
;
; Author:		Pulover [Rodolfo U. Batista]
;				rodolfoub@gmail.com
;
; COM Objects interface using dotted syntax in text strings.
;
;========================================================================

COMInterface(String, Ptr="", ByRef OutputVar="", CLSID="InternetExplorer.Application")
{
	If !IsObject(Ptr)
	{
		If !CLSID
			return False
		Ptr := ComObjCreate(CLSID)
	}
	
	If RegExMatch(String, "[\s]?:=(.*)", Assign)
	{
		String := Trim(RegExReplace(String, "[\s]?:=(.*)"))
		Value := Trim(Assign1)
	}
	
	While, RegExMatch(String, "U)\((.*)\)", _Parent%A_Index%)
	{
		If RegExMatch(String, "U)\((.*[\(]+.*\).*)\)")
		{
			RegExMatch(String, "U)\((.*[\(]+.*[\)]+.*)\)", _Parent%A_Index%)
			String := RegExReplace(String, "U)\((.*[\(]+.*[\)]+.*)\)", "&_Parent" A_Index, "", 1)
		}
		Else
			String := RegExReplace(String, "U)\((.*)\)", "&_Parent" A_Index, "", 1)
	}
	While, RegExMatch(String, "U)\[(.*)\]", _Block%A_Index%)
		String := RegExReplace(String, "U)\[(.*)\]", "&_Block" A_Index, "", 1)
	; While, RegExMatch(String, "&_Parent(\d+)\)", _N)
	; {
		; msgbox % _Parent%_N1%
		; _Parent%_N1% .= ")"
		; msgbox % _Parent%_N1%
		; String := RegExReplace(String, "(&_Parent\d+)\)", "$1")
	; }

	ComSet := Ptr
	
	Loop, Parse, String, .&
	{
		Pos += StrLen(A_LoopField) + 1
		Delimiter := SubStr(String, Pos, 1)
		If RegExMatch(A_LoopField, "^_Parent\d+")
		{
			Par := A_LoopField, Parent := %A_LoopField%1
			While, RegExMatch(Parent, "U)\[(.*)\]", _Arr%A_Index%)
				Parent := RegExReplace(Parent, "U)\[(.*)\]", "_Arr" A_Index, "", 1)
			While, RegExMatch(Parent, "U)\((.*)\)", _iParent%A_Index%)
			{
				msgbox a %parent%
				Parent := RegExReplace(Parent, "U)\((.*)\)", "&_iParent" A_Index, "", 1)
				msgbox d %parent%
			}
			Params := Object()
			Loop, Parse, Parent, `,, %A_Space%
			{
				LoopField := A_LoopField
				If RegExMatch(LoopField, "&_iParent(\d+)", inPar)
				{
					; msgbox 1 %LoopField%
					LoopField := RegExReplace(LoopField, "&_iParent\d+", _iParent%inPar1%)
					; msgbox 2 %LoopField%
				}
				If RegExMatch(LoopField, "^_Arr\d+")
				{
					StringSplit, Arr, %LoopField%1, `,, %A_Space%
					Array := ComObjArray(0xC, Arr0)
					Loop, %Arr0%
					{
						Var := Arr%A_Index%
						Array[A_Index-1] := (!Var) ? 0 : Var
					}
					Params.Insert(Array)
				}
				Else If RegExMatch(LoopField, "^\w+\.(.*)", NestedString)
				{
					Try
						Params.Insert(COMInterface(NestedString1, Ptr, "", CLSID))
					Catch
					{
						Var := LoopField
						Params.Insert((!Var) ? 0 : Var)
					}
				}
				Else
				{
					Var := LoopField
					Params.Insert((!Var) ? 0 : Var)
				}
			}
		}
		Else If RegExMatch(A_LoopField, "^_Block\d+")
			Index := A_LoopField
		Else
			Obj := A_LoopField
		If (Delimiter = ".")
		{
			If ((Par <> "") && (Index <> ""))
				ComSet := ComSet[Obj](Params*)[%Index%1]
			Else If (Par <> "")
				ComSet := ComSet[Obj](Params*)
			Else If (Index <> "")
				ComSet := ComSet[Obj][%Index%1]
			Else
				ComSet := ComSet[Obj]
			Par := "", Index := ""
		}
		Else If (Delimiter = "")
		{
			If (Value <> "")
				ComSet[Obj] := (Value = """""") ? "" : Value
			Else
			{
				If ((Par <> "") && (Index <> ""))
				{
					If IsByRef(OutputVar)
						OutputVar := ComSet[Obj](Params*)[%Index%1]
					return ComSet[Obj](Params*)[%Index%1]
				}
				Else If (Par <> "")
				{
					If IsByRef(OutputVar)
						OutputVar := ComSet[Obj](Params*)
					return ComSet[Obj](Params*)
				}
				Else If (Index <> "")
				{
					If IsByRef(OutputVar)
						OutputVar := ComSet[Obj][%Index%1]
					return ComSet[Obj][%Index%1]
				}
				Else
				{
					If IsByRef(OutputVar)
						OutputVar := ComSet[Obj]
					return ComSet[Obj]
				}
			}
		}
	}
	return Ptr
}


str := "test(x.(v).y().z(va).off).new(go(1).on())"

Loop, Parse, Str
{
	If (A_LoopField = "(")
		o++
	Else If (A_LoopField = ")")
		o--
	If (o)
		p .= A_LoopField
	Else
		t .= A_LoopField
}

msgbox %p%
msgbox %t%