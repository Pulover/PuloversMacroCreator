;=======================================================================================
;
; Function:	  Eval
; Description:   Evaluate Expressions in Strings.
; Return value:  An array (object) with the result of each expression.
;
; Author:		Pulover [Rodolfo U. Batista] (rodolfoub@gmail.com)
; Credits:	   ExprEval() by Uberi
;
;=======================================================================================
;
; Parameters:
;
;	$x:		   The input string to be evaluated. You can enter multiple expressions
;					  separated by commas (inside the string).
;	_CustomVars:  An optional Associative Array object containing variables names
;					  as keys and values to replace them.
;				  For example, setting it to {A_Index: A_Index} inside a loop will replace
;					  occurrences of A_Index with the correct value for the iteration.
;	_Init:		Used internally for the recursive calls. If TRUE it resets the static
;					  object _Objects, which holds objects references to be restored.
;
;=======================================================================================

Eval($x, _CustomVars := "", _Init := true)
{
	global TabSel, chMacro, InputList, InputList0, ListCount, cType47, RunningFunction
	Static _Objects
	_Elements := {}
	If (_Init)
		_Objects := {}

	; Strip off comments
	$x := RegExReplace($x, "U)/\*.*\*/"), $x := RegExReplace($x, "U)\s;.*(\v|$)")
	
	; Replace brackets, braces, parenthesis and isolated Strings
	While (RegExMatch($x, "\[([^\[\]]++|(?R))*\]", _Bracket%A_Index%))
		_Elements["&_Bracket" A_Index "_&"] := _Bracket%A_Index%
	,   $x := RegExReplace($x, "\[([^\[\]]++|(?R))*\]", "&_Bracket" A_Index "_&", "", 1)
	While (RegExMatch($x, "\{[^\{\}]++\}", _Brace%A_Index%))
		_Elements["&_Brace" A_Index "_&"] := _Brace%A_Index%
	,   $x := RegExReplace($x, "\{[^\{\}]++\}", "&_Brace" A_Index "_&", "", 1)
	While (RegExMatch($x, "\(([^()]++|(?R))*\)", _Parent%A_Index%))
		_Elements["&_Parent" A_Index "_&"] := _Parent%A_Index%
	,   $x := RegExReplace($x, "\(([^()]++|(?R))*\)", "&_Parent" A_Index "_&", "", 1)
	While (RegExMatch($x, "U)"".*""", _String%A_Index%))
		_Elements["&_String" A_Index "_&"] := _String%A_Index%
	,   $x := RegExReplace($x, "U)"".*""", "&_String" A_Index "_&", "", 1)
	
	; Split multiple expressions
	$z := StrSplit($x, ",", " `t")
	
	For $i, $v in $z
	{
		; Check for Ternary expression and evaluate
		If (RegExMatch($z[$i], "([^\?:]+?)\?([^\?:]+?):(.*)", _Match))
		{
			Loop, 3
			{
				$o := A_Index, _Match%$o% := Trim(_Match%$o%)
				While (RegExMatch(_Match%$o%, "&_\w+_&", $pd))
					_Match%$o% := StrReplace(_Match%$o%, $pd, _Elements[$pd])
			}
			EvalResult := Eval(_Match1, _CustomVars, false)
		,   $y := EvalResult[1]
			If ($y)
			{
				EvalResult := Eval(_Match2, _CustomVars, false)
			,   $y := StrJoin(EvalResult,, true)
			,   ObjName := RegExReplace(_Match2, "\W", "_")
				If (IsObject($y))
					_Objects[ObjName] := $y
				$z[$i] := StrReplace($z[$i], _Match, IsObject($y) ? """<~#" ObjName "#~>""" : $y)
			}
			Else
			{
				EvalResult := Eval(_Match3, _CustomVars, false)
			,   $y := StrJoin(EvalResult,, true)
			,   ObjName := RegExReplace(_Match3, "\W", "_")
				If (IsObject($y))
					_Objects[ObjName] := $y
				$z[$i] := StrReplace($z[$i], _Match, IsObject($y) ? """<~#" ObjName "#~>""" : $y)
			}
		}
		
		_Pos := 1
		; Check for Object calls
		While (RegExMatch($z[$i], "(\w+)(\.|&_Bracket|&_Parent\d+_&)[\w\.&]+(.*)", _Match, _Pos))
		{
			AssignParse(_Match, VarName, Oper, VarValue)
			If (Oper != "")
			{
				While (RegExMatch(VarValue, "&_\w+_&", $pd))
					VarValue := StrReplace(VarValue, $pd, _Elements[$pd])
				EvalResult := Eval(VarValue, _CustomVars, false)
			,   VarValue := StrJoin(EvalResult)
			}
			Else
				_Match := StrReplace(_Match, _Match3), VarName := _Match

			While (RegExMatch(VarName, "&_\w+_&", $pd))
				VarName := StrReplace(VarName, $pd, _Elements[$pd])
			
			If (RegExMatch(_Match1, "^-?\d+$"))
			{
				_Pos += StrLen(_Match1)
				continue
			}
			$y := ParseObjects(VarName, _CustomVars,, true, Oper, VarValue)
		,   ObjName := RegExReplace(_Match, "\W", "_")
			If (IsObject($y))
				_Objects[ObjName] := $y
			$z[$i] := StrReplace($z[$i], _Match, IsObject($y) ? """<~#" ObjName "#~>""" : $y)
		}
		
		; Assign Arrays
		While (RegExMatch($z[$i], "&_Bracket\d+_&", $pd))
		{
			$z[$i] := StrReplace($z[$i], $pd, _Elements[$pd],, 1)
		,   RegExMatch($z[$i], "\[(.*)\]", _Match)
		,   $y := Eval(_Match1, _CustomVars, false)
		,   ObjName := RegExReplace(_Match, "\W", "_")
		,   _Objects[ObjName] := $y
		,   $z[$i] := StrReplace($z[$i], _Match, """<~#" ObjName "#~>""")
		}
		
		; Assign Associative Arrays
		While (RegExMatch($z[$i], "&_Brace\d+_&", $pd))
		{
			$y := {}
		,   $z[$i] := StrReplace($z[$i], $pd, _Elements[$pd],, 1)
		,   RegExMatch($z[$i], "\{(.*)\}", _Match)
			Loop, Parse, _Match1, `,, %A_Space%%A_Tab%
			{
				$o := StrSplit(A_LoopField, ":", " `t")
				While (RegExMatch($o.2, "&_Brace\d+_&", $pd))
					$o.2 := StrReplace($o.2, $pd, _Elements[$pd])
				While (RegExMatch($o.2, "&_Bracket\d+_&", $pd))
					$o.2 := StrReplace($o.2, $pd, _Elements[$pd])
				EvalResult := Eval($o.2, _CustomVars, false)
			,   $o.1 := Trim($o.1, """")
			,   $y[$o.1] := EvalResult[1]
			}
			ObjName := RegExReplace(_Match, "\W", "_")
		,   _Objects[ObjName] := $y
		,   $z[$i] := StrReplace($z[$i], _Match, """<~#" ObjName "#~>""")
		}
		
		; Restore and evaluate any remaining parenthesis
		While (RegExMatch($z[$i], "&_Parent\d+_&", $pd))
		{
			_Match := RegExReplace(_Elements[$pd], "\((.*)\)", "$1")
		,   EvalResult := Eval(_Match, _CustomVars, false)
		,   $y := StrJoin(EvalResult, ", ", true)
		,   ObjName := RegExReplace($pd, "\W", "_")
			If (IsObject($y))
				_Objects[ObjName] := $y
			$z[$i] := StrReplace($z[$i], $pd, "(" (IsObject($y) ? """<~#" ObjName "#~>""" : $y) ")")
		}
		
		; Check whether the whole string is an object
		$y := $z[$i]
		Try
		{
			If (IsObject(%$y%))
			{
				ObjName := RegExReplace($y, "\W", "_")
			,   _Objects[ObjName] := %$y%.Clone()
			,   $z[$i] := """<~#" ObjName "#~>"""
			}
			Else If (IsObject(_CustomVars[$y]))
			{
				ObjName := RegExReplace($y, "\W", "_")
			,   _Objects[ObjName] := _CustomVars[$y].Clone()
			,   $z[$i] := """<~#" ObjName "#~>"""
			}
		}
		
		_Pos := 1
		; Check for Functions
		While (_Pos := RegExMatch($z[$i], "([\w_]+)\((.*?)\)", _Match, _Pos))
		{
			; ### Start of PMC exclusive code ###
			Loop, %TabCount%
			{
				TabIdx := A_Index
				If ((_Match1 "()") = TabGetText(TabSel, A_Index))
				{
					Gui, chMacro:ListView, InputList%TabIdx%
					Loop, % ListCount%TabIdx%
					{
						LV_GetText(Row_Type, A_Index, 6)
						LV_GetText(TargetFunc, A_Index, 3)
						If ((Row_Type = cType47) && (TargetFunc = _Match1))
						{
							_Params := {}
						,	FuncPars := ExprGetPars(_Match2)
						,	EvalResult := Eval(_Match2, _CustomVars, false)
							For i, v in EvalResult
								_Params[i] := {Name: FuncPars[i], Value: v}
							LastFuncRun := RunningFunction, RunningFunction := _Match1
						,	$y := Playback(TabIdx,,, _Params)
						,	$y := $y[1]
						,	RunningFunction := LastFuncRun
						,	ObjName := RegExReplace(_Match, "\W", "_")
							If (IsObject($y))
								_Objects[ObjName] := $y
							Else
							{
								If $y is not Number
									$y := """" $y """"
							}
							$z[$i] := StrReplace($z[$i], _Match, IsObject($y) ? """<~#" ObjName "#:>""" : $y)
							continue 3
						}
					}
				}
			}
			
			If ((IsFunc(_Match1)) && (!Func(_Match1).IsBuiltIn))
			{
				If _Match1 not in Screenshot,Zip,UnZip
				{
					$z[$i] := StrReplace($z[$i], _Match, "ERROR: NOT ALLOWED")
					_Match1 := ""
				}
			}
			; ### End of PMC exclusive code ###
			
			If (IsFunc(_Match1))
			{
				_Params := Eval(_Match2, _CustomVars, false)
			,   $y := %_Match1%(_Params*)
			,   ObjName := RegExReplace(_Match, "\W", "_")
				If (IsObject($y))
					_Objects[ObjName] := $y
				Else
				{
					If $y is not Number
						$y := """" $y """"
				}
				$z[$i] := StrReplace($z[$i], _Match, IsObject($y) ? """<~#" ObjName "#~>""" : $y)
			}
			Else
				_Pos += StrLen(_Match)
		}
		
		; Dereference variables in percent signs
		While (RegExMatch($z[$i], "U)%(\S+)%", _Match))
			EvalResult := Eval(_Match1, _CustomVars, false)
		,   $z[$i] := RegExReplace($z[$i], _Match, EvalResult[1])
		
		; Process strings again for objects results (to fix concatenation)
		While (RegExMatch($z[$i], "&_\w+_&", $pd))
			$z[$i] := StrReplace($z[$i], $pd, _Elements[$pd])
		While (RegExMatch($z[$i], "U)"".*""", _String%A_Index%))
			_Elements["&_String" A_Index "_&"] := _String%A_Index%
		,   $z[$i] := RegExReplace($z[$i], "U)"".*""", "&_String" A_Index "_&", "", 1)
		
		; Add concatenate operator after strings where necessary
		While (RegExMatch($z[$i], "(&_String\d+_&\s+)([^\d\.,\s:\?])"))
			$z[$i] := RegExReplace($z[$i], "(&_String\d+_&\s+)([^\d\.,\s:\?])", "$1. $2")
		
		; Restore isolated strings
		While (RegExMatch($z[$i], "&_\w+_&", $pd))
			$z[$i] := StrReplace($z[$i], $pd, _Elements[$pd])

		; Evaluate parsed expression with ExprEval()
		ExprInit()
	,   CompiledExpression := ExprCompile($z[$i])
	,   $Result := ExprEval(CompiledExpression, _CustomVars, _Objects)
	,   $Result := StrSplit($Result, Chr(1))
		
		; Restore object references
		For _i, _v in $Result
		{
			If (RegExMatch(_v, "^<~#(.*)#~>$", $pd))
				$Result[_i] := _Objects[$pd1]
		}
		
		$z[$i] := StrJoin($Result)
	}
	
	return $z
}

ParseObjects(v_String, _CustomVars  :=  "", ByRef v_levels := "", QuoteStrings := false, o_Oper := "", o_Value := "")
{
	Static _needle := "(\w+\.?|\(([^()]++|(?R))*\)\.?|\[([^\[\]]++|(?R))*\]\.?)"
	
	l_Matches := [], _Pos := 1, HasMethod := false
	While (_Pos := RegExMatch(v_String, _needle, l_Found, _Pos))
	{
		l_Matches.Push(RTrim(l_Found, "."))
	,	_Pos += StrLen(l_Found), o_String .= l_Found
	}
	_ArrayObject := o_String
,	v_levels := [], v_Obj := l_Matches[1]
	If (IsObject(_CustomVars[v_Obj]))
		_ArrayObject := _CustomVars[v_Obj]
	Else
		Try _ArrayObject := %v_Obj%
	For $i, $v in l_Matches
	{
		If (RegExMatch($v, "^\((.*)\)$"))
			continue
		If (RegExMatch($v, "^\[(.*)\]$", l_Found))
			EvalResult := Eval(l_Found1, _CustomVars, false)
		,   _Key := EvalResult
		Else
			_Key := [$v]
		$n := l_Matches[$i + 1]
		If ($i > 1)
			v_levels.Push(_Key*)
		If (RegExMatch($n, "^\((.*)\)$", l_Found))
		{
			_Key := _Key[1]
			If ($i = 1)
				_Params := Eval(l_Found1, _CustomVars, false)
			,   _ArrayObject := %_Key%(_Params*)
			Else
				_Params := Eval(l_Found1, _CustomVars, false)
			,   _ArrayObject := _ArrayObject[_Key](_Params*)
		}
		Else If (($i = l_Matches.Length()) && (o_Value != ""))
		{
			Try
			{
				If (o_Oper = ":=")
					_ArrayObject := _ArrayObject[_Key*] := o_Value
				Else If (o_Oper = "+=")
					_ArrayObject := _ArrayObject[_Key*] += o_Value
				Else If (o_Oper = "-=")
					_ArrayObject := _ArrayObject[_Key*] -= o_Value
				Else If (o_Oper = "*=")
					_ArrayObject := _ArrayObject[_Key*] *= o_Value
				Else If (o_Oper = "/=")
					_ArrayObject := _ArrayObject[_Key*] /= o_Value
				Else If (o_Oper = "//=")
					_ArrayObject := _ArrayObject[_Key*] //= o_Value
				Else If (o_Oper = ".=")
					_ArrayObject := _ArrayObject[_Key*] .= o_Value
				Else If (o_Oper = "|=")
					_ArrayObject := _ArrayObject[_Key*] |= o_Value
				Else If (o_Oper = "&=")
					_ArrayObject := _ArrayObject[_Key*] &= o_Value
				Else If (o_Oper = "^=")
					_ArrayObject := _ArrayObject[_Key*] ^= o_Value
				Else If (o_Oper = ">>=")
					_ArrayObject := _ArrayObject[_Key*] >>= o_Value
				Else If (o_Oper = "<<=")
					_ArrayObject := _ArrayObject[_Key*] <<= o_Value
			}
		}
		Else If ($i > 1)
			_ArrayObject := _ArrayObject[_Key*]
	}
	If ((!IsObject(_ArrayObject)) && (QuoteStrings) && (!RegExMatch(_ArrayObject, "^-?\d+$")))
		_ArrayObject := """" _ArrayObject """"
	If (HasMethod)
		v_levels := ""
	return _ArrayObject
}

AssignParse(String, ByRef VarName, ByRef Oper, ByRef VarValue)
{
	RegExMatch(String, "(.*?)(:=|\+=|-=|\*=|/=|//=|\.=|\|=|&=|\^=|>>=|<<=)(?=([^""]*""[^""]*"")*[^""]*$)(.*)", Out)
,   VarName := Trim(Out1), Oper := Out2, VarValue := Trim(Out4)
}

StrJoin(InputArray, JChr := "", Quote := false)
{
	For i, v in InputArray
	{
		If (IsObject(v))
			return v
		If (Quote) && ((!RegExMatch(v, "^-?\d+$")))
			v := """" v """"
		JoinedStr .= v . JChr
	}
	If (JChr != "")
		JoinedStr := SubStr(JoinedStr, 1, -(StrLen(JChr)))
	return JoinedStr
}

;##################################################
; Author: Uberi
; Modified by: Pulover
; https://autohotkey.com/board/topic/64167-expreval-evaluate-expressions/
;##################################################
ExprInit()
{
	global
	Exprot:="`n:= 0 R 2`n+= 0 R 2`n-= 0 R 2`n*= 0 R 2`n/= 0 R 2`n//= 0 R 2`n.= 0 R 2`n|= 0 R 2`n&= 0 R 2`n^= 0 R 2`n>>= 0 R 2`n<<= 0 R 2`n|| 3 L 2`n&& 4 L 2`n\! 5 R 1`n= 6 L 2`n== 6 L 2`n<> 6 L 2`n!= 6 L 2`n> 7 L 2`n< 7 L 2`n>= 7 L 2`n<= 7 L 2`n\. 8 L 2`n& 9 L 2`n^ 9 L 2`n| 9 L 2`n<< 10 L 2`n>> 10 L 2`n+ 11 L 2`n- 11 L 2`n* 12 L 2`n/ 12 L 2`n// 12 L 2`n\- 13 R 1`n! 13 R 1`n~ 13 R 1`n\& 13 R 1`n\* 13 R 1`n** 14 R 2`n\++ 15 R 1`n\-- 15 R 1`n++ 15 L 1`n-- 15 L 1`n. 16 L 2`n`% 17 R 1`n",Exprol:=SubStr(RegExReplace(Exprot,"iS) \d+ [LR] \d+\n","`n"),2,-1)
	Sort,Exprol,FExprols
}

ExprCompile(e)
{
	e:=Exprt(e)
	Loop,Parse,e,% Chr(1)
	{
		lf:=A_LoopField,tt:=SubStr(lf,1,1),to:=SubStr(lf,2)
		If tt=f
		Exprp1(s,lf)
		Else If lf=,
		{
			While,s<>""&&Exprp3(s)<>"("
			Exprp1(ou,Exprp2(s))
		}
		Else If tt=o
		{
			While,SubStr(so:=Exprp3(s),1,1)="o"
			{
				ta:=Expras(to),tp:=Exprpr(to),sop:=Exprpr(SubStr(so,2))
				If ((ta="L"&&tp>sop)||(ta="R"&&tp>=sop))
				Break
				Exprp1(ou,Exprp2(s))
			}
			Exprp1(s,lf)
		}
		Else If lf=(
		Exprp1(s,"(")
		Else If lf=)
		{
			While,Exprp3(s)<>"("
			{
				If s=
				Return
				Exprp1(ou,Exprp2(s))
			}
			Exprp2(s)
			If (SubStr(Exprp3(s),1,1)="f")
			Exprp1(ou,Exprp2(s))
		}
		Else Exprp1(ou,lf)
	}
	While,s<>""
	{
		t1:=Exprp2(s)
		If t1 In (,)
		Return
		Exprp1(ou,t1)
	}
	Return,ou
}

ExprEval(e,lp,eo)
{
	c1:=Chr(1)
	Loop,Parse,e,%c1%
	{
		lf:=A_LoopField,tt:=SubStr(lf,1,1),t:=SubStr(lf,2)
		If tt In l,v
		lf:=Exprp1(s,lf)
		Else{
			If tt=f
			t1:=InStr(t," "),a:=SubStr(t,1,t1-1),t:=SubStr(t,t1+1)
			Else a:=Exprac(t)
			Exprp1(s,Exprap(t,s,a,lp,eo))
		}
	}
	
	Loop,Parse,s,%c1%
	{
		lf:=A_LoopField
		If (SubStr(lf,1,1)="v")
		t1:=SubStr(lf,2),r.=(lp.HasKey(t1) ? lp[t1] : %t1%) . c1
		Else r.=SubStr(lf,2) . c1
	}
	Return,SubStr(r,1,-1)
}

Exprap(o,ByRef s,ac,lp,eo)
{
	local i,t1,a1,a2,a3,a4,a5,a6,a1v,a2v,a3v,a4v,a5v,a6v,a7v,a8v,a9v
	Loop,%ac%
	i:=ac-(A_Index-1),t1:=Exprp2(s),a%i%:=SubStr(t1,2),(SubStr(t1,1,1)="v")?(a%i%v:=1)
	Loop, 10
	{
		If (RegExMatch(a%A_Index%,"^<~#(.*)#~>$",rm))
		a%A_Index%:=eo[rm1],a%A_Index%v:=0
		Else If (lp.HasKey(a%A_Index%))
		a%A_Index%:=lp[a%A_Index%],a%A_Index%v:=0
	}
	If o=++
	Return,"l" . %a1%++
	If o=--
	Return,"l" . %a1%--
	If o=\++
	Return,"l" . ++%a1%
	If o=\--
	Return,"l" . --%a1%
	If o=`%
	Return,"v" . %a1%
	If o=!
	Return,"l" . !(a1v ? %a1%:a1)
	If o=\!
	Return,"l" . (a1v ? %a1%:a1)
	If o=~
	Return,"l" . ~(a1v ? %a1%:a1)
	If o=**
	Return,"l" . ((a1v ? %a1%:a1)**(a2v ? %a2%:a2))
	If o=*
	Return,"l" . ((a1v ? %a1%:a1)*(a2v ? %a2%:a2))
	If o=\*
	Return,"l" . *(a1v ? %a1%:a1)
	If o=/
	Return,"l" . ((a1v ? %a1%:a1)/(a2v ? %a2%:a2))
	If o=//
	Return,"l" . ((a1v ? %a1%:a1)//(a2v ? %a2%:a2))
	If o=+
	Return,"l" . ((a1v ? %a1%:a1)+(a2v ? %a2%:a2))
	If o=-
	Return,"l" . ((a1v ? %a1%:a1)-(a2v ? %a2%:a2))
	If o=\-
	Return,"l" . -(a1v ? %a1%:a1)
	If o=<<
	Return,"l" . ((a1v ? %a1%:a1)<<(a2v ? %a2%:a2))
	If o=>>
	Return,"l" . ((a1v ? %a1%:a1)>>(a2v ? %a2%:a2))
	If o=&
	Return,"l" . ((a1v ? %a1%:a1)&(a2v ? %a2%:a2))
	If o=\&
	Return,"l" . &(a1v ? %a1%:a1)
	If o=^
	Return,"l" . ((a1v ? %a1%:a1)^(a2v ? %a2%:a2))
	If o=|
	Return,"l" . ((a1v ? %a1%:a1)|(a2v ? %a2%:a2))
	If o=\.
	Return,"l" . ((a1v ? %a1%:a1) . (a2v ? %a2%:a2))
	If o=.
	Return,"v" . a1
	If o=<
	Return,"l" . ((a1v ? %a1%:a1)<(a2v ? %a2%:a2))
	If o=>
	Return,"l" . ((a1v ? %a1%:a1)>(a2v ? %a2%:a2))
	If o==
	Return,"l" . ((a1v ? %a1%:a1)=(a2v ? %a2%:a2))
	If o===
	Return,"l" . ((a1v ? %a1%:a1)==(a2v ? %a2%:a2))
	If o=<>
	Return,"l" . ((a1v ? %a1%:a1)<>(a2v ? %a2%:a2))
	If o=!=
	Return,"l" . ((a1v ? %a1%:a1)!=(a2v ? %a2%:a2))
	If o=>=
	Return,"l" . ((a1v ? %a1%:a1)>=(a2v ? %a2%:a2))
	If o=<=
	Return,"l" . ((a1v ? %a1%:a1)<=(a2v ? %a2%:a2))
	If o=&&
	Return,"l" . ((a1v ? %a1%:a1)&&(a2v ? %a2%:a2))
	If o=||
	Return,"l" . ((a1v ? %a1%:a1)||(a2v ? %a2%:a2))
	If o=:=
	{
		%a1%:=(a2v ? %a2%:a2)
		Return,"v" . a1
	}
	If o=+=
	{
		%a1%+=(a2v ? %a2%:a2)
		Return,"v" . a1
	}
	If o=-=
	{
		%a1%-=(a2v ? %a2%:a2)
		Return,"v" . a1
	}
	If o=*=
	{
		%a1%*=(a2v ? %a2%:a2)
		Return,"v" . a1
	}
	If o=/=
	{
		%a1%/=(a2v ? %a2%:a2)
		Return,"v" . a1
	}
	If o=//=
	{
		%a1%//=(a2v ? %a2%:a2)
		Return,"v" . a1
	}
	If o=.=
	{
		%a1%.=(a2v ? %a2%:a2)
		Return,"v" . a1
	}
	If o=|=
	{
		%a1%|=(a2v ? %a2%:a2)
		Return,"v" . a1
	}
	If o=&=
	{
		%a1%&=(a2v ? %a2%:a2)
		Return,"v" . a1
	}
	If o=^=
	{
		%a1%^=(a2v ? %a2%:a2)
		Return,"v" . a1
	}
	If o=>>=
	{
		%a1%>>=(a2v ? %a2%:a2)
		Return,"v" . a1
	}
	If o=<<=
	{
		%a1%<<=(a2v ? %a2%:a2)
		Return,"v" . a1
	}
	If ac=0
	Return,"l" . %o%()
	If ac=1
	Return,"l" . %o%(a1v ? %a1%:a1)
	If ac=2
	Return,"l" . %o%((a1v ? %a1%:a1),(a2v ? %a2%:a2))
	If ac=3
	Return,"l" . %o%((a1v ? %a1%:a1),(a2v ? %a2%:a2),(a3v ? %a3%:a3))
	If ac=4
	Return,"l" . %o%((a1v ? %a1%:a1),(a2v ? %a2%:a2),(a3v ? %a3%:a3),(a4v ? %a4%:a4))
	If ac=5
	Return,"l" . %o%((a1v ? %a1%:a1),(a2v ? %a2%:a2),(a3v ? %a3%:a3),(a4v ? %a4%:a4),(a5v ? %a5%:a5))
	If ac=6
	Return,"l" . %o%((a1v ? %a1%:a1),(a2v ? %a2%:a2),(a3v ? %a3%:a3),(a4v ? %a4%:a4),(a5v ? %a5%:a5),(a6v ? %a6%:a6))
	If ac=7
	Return,"l" . %o%((a1v ? %a1%:a1),(a2v ? %a2%:a2),(a3v ? %a3%:a3),(a4v ? %a4%:a4),(a5v ? %a5%:a5),(a6v ? %a6%:a6),(a7v ? %a7%:a7))
	If ac=8
	Return,"l" . %o%((a1v ? %a1%:a1),(a2v ? %a2%:a2),(a3v ? %a3%:a3),(a4v ? %a4%:a4),(a5v ? %a5%:a5),(a6v ? %a6%:a6),(a7v ? %a7%:a7),(a8v ? %a8%:a8))
	If ac=9
	Return,"l" . %o%((a1v ? %a1%:a1),(a2v ? %a2%:a2),(a3v ? %a3%:a3),(a4v ? %a4%:a4),(a5v ? %a5%:a5),(a6v ? %a6%:a6),(a7v ? %a7%:a7),(a8v ? %a8%:a8),(a9v ? %a9%:a9))
	If ac=10
	Return,"l" . %o%((a1v ? %a1%:a1),(a2v ? %a2%:a2),(a3v ? %a3%:a3),(a4v ? %a4%:a4),(a5v ? %a5%:a5),(a6v ? %a6%:a6),(a7v ? %a7%:a7),(a8v ? %a8%:a8),(a9v ? %a9%:a9),(a10v ? %a10%:a10))
}

Exprt(e)
{
	global Exprol
	c1:=Chr(1),f:=1,f1:=1
	While,(f:=RegExMatch(e,"S)""(?:[^""]|"""")*""",m,f))
	{
		t1:=SubStr(m,2,-1)
		StringReplace,t1,t1,"",",All
		StringReplace,t1,t1,','27,All
		StringReplace,t1,t1,````,%c1%,All
		StringReplace,t1,t1,``n,`n,All
		StringReplace,t1,t1,``r,`r,All
		StringReplace,t1,t1,``b,`b,All
		StringReplace,t1,t1,``t,`t,All
		StringReplace,t1,t1,``v,`v,All
		StringReplace,t1,t1,``a,`a,All
		StringReplace,t1,t1,``f,`f,All
		StringReplace,t1,t1,%c1%,``,All
		SetFormat,IntegerFast,Hex
		While,RegExMatch(t1,"iS)[^\w']",c)
		StringReplace,t1,t1,%c%,% "'" . SubStr("0" . SubStr(Asc(c),3),-1),All
		SetFormat,IntegerFast,D
		e1.=SubStr(e,f1,f-f1) . c1 . "l" . t1 . c1,f+=StrLen(m),f1:=f
	}
	e1.=SubStr(e,f1),e:=InStr(e1,"""")? "":e1,e1:="",e:=RegExReplace(e,"S)/\*.*?\*/|[ \t]`;.*?(?=\r|\n|$)")
	StringReplace,e,e,%A_Tab%,%A_Space%,All
	e:=RegExReplace(e,"S)([\w#@\$] +|\) *)(?=" . Chr(1) . "*[\w#@\$\(])","$1 . ")
	StringReplace,e,e,%A_Space%.%A_Space%,\.,All
	StringReplace,e,e,%A_Space%,,All
	f:=1,f1:=1
	While,(f:=RegExMatch(e,"S)(^|[^\w#@\$\.'])(0x\d+|\d+(?:\.\d+)?|\.\d+)(?=[^\d\.]|$)",m,f))
	{
		m2+=0
		StringReplace,m2,m2,.,'2E
		e1.=SubStr(e,f1,f-f1) . m1 . c1 . "n" . m2 . c1,f+=StrLen(m),f1:=f
	}
	e:=e1 . SubStr(e,f1),e1:="",e:=RegExReplace(e,"S)(^|\(|[^" . c1 . "-])-" . c1 . "n","$1" . c1 . "n'2D")
	StringReplace,e,e,%c1%n,%c1%l,All
	e:=RegExReplace(RegExReplace(e,"S)(%[\w#@\$]{1,253})%","$1"),"S)(?:^|[^\w#@\$'" . c1 . "])\K[\w#@\$]{1,253}(?=[^\(\w#@\$]|$)",c1 . "v$0" . c1),f:=1,f1:=1
	While,(f:=RegExMatch(e,"S)(^|[^\w#@\$'])([\w#@\$]{1,253})(?=\()",m,f))
	{
		t1:=f+StrLen(m)
		If (SubStr(e,t1+1,1)=")")
		ac=0
		Else
		{
			If !Exprmlb(e,t1,fa)
			Return
			StringReplace,fa,fa,`,,`,,UseErrorLevel
			ac:=ErrorLevel+1
		}
		e1.=SubStr(e,f1,f-f1) . m1 . c1 . "f" . ac . "'20" . m2 . c1,f+=StrLen(m),f1:=f
	}
	e:=e1 . SubStr(e,f1),e1:=""
	StringReplace,e,e,\.%c1%vNot%c1%\.,!,All
	StringReplace,e,e,\.%c1%vAnd%c1%\.,&&,All
	StringReplace,e,e,\.%c1%vOr%c1%\.,||,All
	StringReplace,e,e,%c1%vNot%c1%\.,!,All
	StringReplace,e,e,%c1%vAnd%c1%\.,&&,All
	StringReplace,e,e,%c1%vOr%c1%\.,||,All
	e:=RegExReplace(e,"S)(^|[^" . c1 . "\)-])-" . c1 . "(?=[lvf])","$1\-" . c1)
	e:=RegExReplace(e,"S)(^|[^" . c1 . "\)&])&" . c1 . "(?=[lvf])","$1\&" . c1)
	e:=RegExReplace(e,"S)(^|[^" . c1 . "\)\*])\*" . c1 . "(?=[lvf])","$1\*" . c1)
	e:=RegExReplace(e,"S)(^|[^" . c1 . "\)])(\+\+|--)" . c1 . "(?=[lvf])","$1\$2" . c1)
	t1:=RegExReplace(Exprol,"S)[\\\.\*\?\+\[\{\|\(\)\^\$]","\$0")
	StringReplace,t1,t1,`n,|,All
	e:=RegExReplace(e,"S)" . t1,c1 . "o$0" . c1)
	StringReplace,e,e,`,,%c1%`,%c1%,All
	StringReplace,e,e,(,%c1%(%c1%,All
	StringReplace,e,e,),%c1%)%c1%,All
	StringReplace,e,e,%c1%%c1%,%c1%,All
	If RegExMatch(e,"S)" . c1 . "[^lvfo\(\),\n]")
	Return
	e:=SubStr(e,2,-1),f:=0
	While,(f:=InStr(e,"'",False,f + 1))
	{
		If ((t1:=SubStr(e,f+1,2))<>27)
		StringReplace,e,e,'%t1%,% Chr("0x" . t1),All
	}
	StringReplace,e,e,'27,',All
	Return,e
}

Exprols(o1,o2)
{
	Return,StrLen(o2)-StrLen(o1)
}

Exprpr(o)
{
	global Exprot
	t:=InStr(Exprot,"`n" . o . " ")+StrLen(o)+2
	Return,SubStr(Exprot,t,InStr(Exprot," ",0,t)-t)
}

Expras(o)
{
	global Exprot
	Return,SubStr(Exprot,InStr(Exprot," ",0,InStr(Exprot,"`n" . o . " ")+StrLen(o)+2)+1,1)
}

Exprac(o)
{
	global Exprot
	Return,SubStr(Exprot,InStr(Exprot,"`n",0,InStr(Exprot,"`n" . o . " ")+1)-1,1)
}

Exprmlb(ByRef s,p,ByRef o="",b="(",e=")")
{
	t:=SubStr(s,p),bc:=0,VarSetCapacity(o,StrLen(t))
	If (SubStr(t,1,1)<>b)
	Return,0
	Loop,Parse,t
	{
		lf:=A_LoopField
		If lf=%b%
		bc++
		Else If lf=%e%
		{
			bc--
			If bc=0
			Return,p
		}
		Else If bc=1
		o.=lf
		p++
	}
	Return,0
}

Exprp1(ByRef dl,d)
{
	dl.=((dl="")? "":Chr(1)) . d
}

Exprp2(ByRef dl)
{
	t:=InStr(dl,Chr(1),0,0),t ?(t1:=SubStr(dl,t+1),dl:=SubStr(dl,1,t-1)):(t1:=dl,dl:="")
	Return,t1
}

Exprp3(ByRef dl)
{
	Return,SubStr(dl,InStr(dl,Chr(1),0,0)+1)
}

