;========================================================================
;
; 				COMInterface
;
; Author:		Pulover [Rodolfo U. Batista]
;				rodolfoub@gmail.com
;
; COM Objects interface using dotted syntax in text strings.
;
; NOTE: This function is DEPRECATED from PMC v5+.
;       It has been replaced by Eval and it's kept in the project files for reference only.
;
;========================================================================

COMInterface(String, Ptr := "", ByRef OutputVar := "", CLSID := "InternetExplorer.Application")
{
	; If the Pointer is not an object, create one.
	If (!IsObject(Ptr))
	{
		If (!CLSID)
			return false
		Ptr := ComObjCreate(CLSID)
	}

	; Look for Assignments (:=) and separate Command from Value.
	If (RegExMatch(String, "[\s]?:=(.*)", Assign))
	{
		String := Trim(RegExReplace(String, "[\s]?:=(.*)"))
	,	Value := Trim(Assign1)
	}
	
	; Look for Parameters and replace with a pattern.
	While (RegExMatch(String, "\(([^()]++|(?R))*\)", _Parent%A_Index%))
		String := RegExReplace(String, "\(([^()]++|(?R))*\)", "&_Parent" A_Index, "", 1)
	
	; Look foor Blocks that will be used to create SafeArrays and replace with a pattern.
	While (RegExMatch(String, "U)\[(.*)\]", _Block%A_Index%))
		String := RegExReplace(String, "U)\[(.*)\]", "&_Block" A_Index, "", 1)

	ComSet := Ptr

	Loop, Parse, String, .&
	{
		Pos += StrLen(A_LoopField) + 1
		Delimiter := SubStr(String, Pos, 1)
		If (RegExMatch(A_LoopField, "^_Parent\d+"))
		{
			Par := A_LoopField, Parent := SubStr(%A_LoopField%, 2, -1)
		,	Params := Object()
			
			If (InStr(CLSID, "Script"))
				Params.Push(Parent)
			Else
			{
				; Look for Blocks and divide arguments.
				While (RegExMatch(Parent, "U)\[(.*)\]", _Arr%A_Index%))
					Parent := RegExReplace(Parent, "U)\[(.*)\]", "_Arr" A_Index, "", 1)
				; Look for Parameters inside Parameters.
				While (RegExMatch(Parent, "\(([^()]++|(?R))*\)", _iParent%A_Index%))
					Parent := RegExReplace(Parent, "\(([^()]++|(?R))*\)", "&_iParent" A_Index, "", 1)
				Loop, Parse, Parent, `,, %A_Space%
				{
					LoopField := A_LoopField
					While (RegExMatch(LoopField, "&_iParent(\d+)", inPar))
					{
						iPar := RegExReplace(_iParent%inPar1%, "\$", "$$$$")
					,	LoopField := RegExReplace(LoopField, "&_iParent\d+", iPar, "", 1)
					}
					If (RegExMatch(LoopField, "^_Arr\d+"))
					{
						StringSplit, Arr, %LoopField%1, `,, %A_Space%
						Array := ComObjArray(0xC, Arr0)
						Loop, %Arr0%
						{
							Var := Arr%A_Index%
						,	Array[A_Index-1] := (!Var) ? 0 : Var
						}
						Params.Push(Array)
					}
					Else If (RegExMatch(LoopField, "^\w+\.(.*)", NestStr)) ; Search for nested strings.
					{
						If (Loopfield = "")
							LoopField := ComObjMissing()
						Var := LoopField
						If (NestStr = _Parent11)
							Params.Push((!Var) ? (IsObject(Var) ? Var : 0) : Var)
						Else
						{
							Try
								Params.Push(COMInterface(NestStr1, ComSet, "", CLSID))
							Catch
							{
								Try
									Params.Push(COMInterface(NestStr1, Ptr, "", CLSID))
								Catch
									Params.Push((!Var) ? (IsObject(Var) ? Var : 0) : Var)
							}
						}
					}
					Else
					{
						If (Loopfield = "")
							LoopField := ComObjMissing()
						Var := LoopField
						Params.Push((!Var) ? (IsObject(Var) ? Var : 0) : Var)
					}
				}
			}
		}
		Else If (RegExMatch(A_LoopField, "^_Block\d+"))
			Index := A_LoopField
		Else
			Obj := A_LoopField
		If (Delimiter = ".")
		{
			If ((Par != "") && (Index != ""))
				ComSet := ComSet[Obj](Params*)[%Index%1]
			Else If (Par != "")
				ComSet := ComSet[Obj](Params*)
			Else If (Index != "")
				ComSet := ComSet[Obj][%Index%1]
			Else
				ComSet := ComSet[Obj]
			Par := "", Index := ""
		}
		Else If (Delimiter = "")
		{
			If (Value != "")
				ComSet[Obj] := (Value = """""") ? "" : ((Value = "true") ? true : ((Value = "false") ? false : Value))
			Else
			{
				If ((Par != "") && (Index != ""))
				{
					If (IsByRef(OutputVar))
						OutputVar := ComSet[Obj](Params*)[%Index%1]
					Try
						Result := ComSet[Obj](Params*)[%Index%1]
					If (IsObject(Result))
						return Result
					Try
						Result := ComSet[Obj](Params*)
					If (IsObject(Result))
						return Result
					Try
						Result := ComSet[Obj]
					If (IsObject(Result))
						return Result
					return ComSet
				}
				Else If (Par != "")
				{
					If IsByRef(OutputVar)
						OutputVar := ComSet[Obj](Params*)
					Try
						Result := ComSet[Obj](Params*)
					If (IsObject(Result))
						return Result
					Try
						Result := ComSet[Obj]
					If (IsObject(Result))
						return Result
					return ComSet
				}
				Else If (Index != "")
				{
					If IsByRef(OutputVar)
						OutputVar := ComSet[Obj][%Index%1]
					Try
						Result := ComSet[Obj][%Index%1]
					If (IsObject(Result))
						return Result
					Try
						Result := ComSet[Obj]
					If (IsObject(Result))
						return Result
					return ComSet
				}
				Else
				{
					If IsByRef(OutputVar)
						OutputVar := ComSet[Obj]
					Try
						Result := ComSet[Obj]
					If (IsObject(Result))
						return Result
					return ComSet
				}
			}
		}
	}
	return Ptr
}
