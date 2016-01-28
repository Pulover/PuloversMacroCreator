Eval($x, l_Point)
{
	Local $y, $z, $i, $v, $o, _i, _v, $Result, CompiledExpression, LastFuncRun, _Params, EvalResult
		, _Match, _Match1, _Match2, _Match3, _Elements := {}, _Objects := {}, ObjName, _Pos := 1, $pd

	; Save and remove isolated strings
	While (RegExMatch($x, "\[([^\[\]]++|(?R))*\]", _Bracket%A_Index%))
		_Elements["&_Bracket" A_Index "_&"] := _Bracket%A_Index%
	,	$x := RegExReplace($x, "\[([^\[\]]++|(?R))*\]", "&_Bracket" A_Index "_&", "", 1)
	While (RegExMatch($x, "\{[^\{\}]++\}", _Brace%A_Index%))
		_Elements["&_Brace" A_Index "_&"] := _Brace%A_Index%
	,	$x := RegExReplace($x, "\{[^\{\}]++\}", "&_Brace" A_Index "_&", "", 1)
	While (RegExMatch($x, "\(([^()]++|(?R))*\)", _Parent%A_Index%))
		_Elements["&_Parent" A_Index "_&"] := _Parent%A_Index%
	,	$x := RegExReplace($x, "\(([^()]++|(?R))*\)", "&_Parent" A_Index "_&", "", 1)
	While (RegExMatch($x, "U)"".*""", _String%A_Index%))
		_Elements["&_String" A_Index "_&"] := _String%A_Index%
	,	$x := RegExReplace($x, "U)"".*""", "&_String" A_Index "_&", "", 1)
	
	$z := StrSplit($x, ",", " `t")
	For $i, $v in $z
	{
		_Pos := 1
		While (_Pos := RegExMatch($z[$i], "(\w+)(\.|&_Bracket|&_Parent\d+_&[\.\[])[\w\.&]+(\s+\W?\W\W?\s+.*)?", _Match, _Pos)) ; Object calls
		{
			_$v := _Match, AssignReplace(_$v)
			While (RegExMatch($z[$i], "&_(Parent|Bracket)\d+_&", $pd))
				$z[$i] := StrReplace($z[$i], $pd, _Elements[$pd])
				
			While (RegExMatch(_Match, "&_(Parent|Bracket)\d+_&", $pd))
				_Match := StrReplace(_Match, $pd, _Elements[$pd])
				
			While (RegExMatch(VarName, "&_(Parent|Bracket)\d+_&", $pd))
				VarName := StrReplace(VarName, $pd, _Elements[$pd])
				
			While (RegExMatch(VarValue, "&_(Parent|Bracket)\d+_&", $pd))
				VarValue := StrReplace(VarValue, $pd, _Elements[$pd])
			
			If (Oper != "")
			{
				While (RegExMatch(VarValue, "&_\w+_&", $pd))
					VarValue := StrReplace(VarValue, $pd, _Elements[$pd])
				$o := Oper
			,	EvalResult := Eval(VarValue, l_Point)
			,	VarValue := StrJoin(EvalResult)
			}
			Else
				VarName := _Match
			If (RegExMatch(_Match1, "^-?\d+$"))
			{
				_Pos += StrLen(_Match1)
				continue
			}
			$y := ParseObjects(VarName, l_Point,, true, $o, VarValue)
			If ($y = "_ArrayObject")
				Try $y := %$y%
			ObjName := RegExReplace(_Match, "\W", "_")
			If (IsObject($y))
				_Objects[ObjName] := $y
			$z[$i] := StrReplace($z[$i], _Match, IsObject($y) ? """<:#" ObjName "#:>""" : $y)
			If (IsObject($y))
			{
				_Pos += StrLen(_Match1)
				continue
			}
			Else
				_Pos += StrLen($y)
		}
		
		If (RegExMatch($z[$i], "^&_Bracket\d+_&$", _Match)) ; Assign Arrays
		{
			While (RegExMatch($z[$i], "&_Bracket\d+_&", $pd))
				$z[$i] := StrReplace($z[$i], $pd, _Elements[$pd])
			_Match := RegExReplace($z[$i], "^\[(.*)\]$", "$1")
		,	$y := Eval(_Match, l_Point)
		,	ObjName := RegExReplace(_Match, "\W", "_")
		,	_Objects[ObjName] := $y
		,	$z[$i] := """<:#" ObjName "#:>"""
		}
		
		If (RegExMatch($z[$i], "^&_Brace\d+_&$", _Match)) ; Assign Associative Arrays
		{
			$y := {}
		,	RegExMatch($z[$i], "&_Brace\d+_&", $pd)
		,	$z[$i] := RegExReplace($z[$i], "&_Brace\d+_&", _Elements[$pd])
		,	_Match := RegExReplace($z[$i], "^\{(.*)\}$", "$1")
			Loop, Parse, _Match, `,, %A_Space%%A_Tab%
			{
				$o := StrSplit(A_LoopField, ":", " `t")
				While (RegExMatch($o.2, "&_Brace\d+_&", $pd))
					$o.2 := StrReplace($o.2, $pd, _Elements[$pd])
				While (RegExMatch($o.2, "&_Bracket\d+_&", $pd))
					$o.2 := StrReplace($o.2, $pd, _Elements[$pd])
				EvalResult := Eval($o.2, l_Point)
			,	$o.1 := Trim($o.1, """")
			,	$y[$o.1] := EvalResult[1]
			}
			ObjName := RegExReplace(_Match, "\W", "_")
		,	_Objects[ObjName] := $y
		,	$z[$i] := """<:#" ObjName "#:>"""
		}
		
		While (RegExMatch($z[$i], "&_Parent\d+_&", $pd))
			$z[$i] := StrReplace($z[$i], $pd, _Elements[$pd])
		While (RegExMatch($z[$i], "&_Bracket\d+_&", $pd))
			$z[$i] := StrReplace($z[$i], $pd, _Elements[$pd])
		
		$y := $z[$i]
		Try
		{
			If (IsObject(%$y%))
			{
				ObjName := RegExReplace($y, "\W", "_")
			,	_Objects[ObjName] := %$y%.Clone()
			,	$z[$i] := """<:#" ObjName "#:>"""
			}
		}
		
		_Pos := 1
		While (_Pos := RegExMatch($z[$i], "([\w_]+)\((.*?)\)", _Match, _Pos))  ; Functions
		{
			Loop, %TabCount% ; Check for User-Defined Functions
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
						,	EvalResult := Eval(_Match2, l_Point)
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
							$z[$i] := StrReplace($z[$i], _Match, IsObject($y) ? """<:#" ObjName "#:>""" : $y)
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
			
			If (IsFunc(_Match1))
			{
				_Params := Eval(_Match2, l_Point)
			,	$y := %_Match1%(_Params*)
			,	ObjName := RegExReplace(_Match, "\W", "_")
				If (IsObject($y))
					_Objects[ObjName] := $y
				Else
				{
					If $y is not Number
						$y := """" $y """"
				}
				$z[$i] := StrReplace($z[$i], _Match, IsObject($y) ? """<:#" ObjName "#:>""" : $y)
			}
			Else
				_Pos += StrLen(_Match)
		}
		
		While (RegExMatch($z[$i], "&_\w+_&", $pd))
			$z[$i] := StrReplace($z[$i], $pd, _Elements[$pd])
		
		ExprInit()
	,	CompiledExpression := ExprCompile($z[$i])
	,	$Result := ExprEval(CompiledExpression, l_Point, _Objects)
	,	$Result := StrSplit($Result, Chr(1))
		For _i, _v in $Result
		{
			If (RegExMatch(_v, "^<:#(.*)#:>$", _Match))
				$Result[_i] := _Objects[_Match1]
		}
		$z[$i] := StrJoin($Result)
	}
	
	return $z
}

ParseObjects(v_String, l_Point, ByRef v_levels := "", QuoteStrings := false, o_Oper := "", o_Value := "")
{
	local po_ArrayObject, EvalResult, l_Matches := [], o_String, v_Obj
	, _Pos := 1, l_Found, l_Found1, l_Found2, _Params, _Key
	, HasMethod := false, $i, $v, $n
	Static _needle := "(\w+\.?|\(([^()]++|(?R))*\)\.?|\[([^\[\]]++|(?R))*\]\.?)"

	While (_Pos := RegExMatch(v_String, _needle, l_Found, _Pos))
	{
		l_Matches.Push(RTrim(l_Found, "."))
	,	_Pos += StrLen(l_Found), o_String .= l_Found
	}
	_ArrayObject := o_String
,	v_levels := [], v_Obj := l_Matches[1]
	Try _ArrayObject := %v_Obj%
	For $i, $v in l_Matches
	{
		If (RegExMatch($v, "^\((.*)\)$", l_Found))
			continue
		If (RegExMatch($v, "^\[(.*)\]$", l_Found))
		{
			po_ArrayObject := _ArrayObject
		,	EvalResult := Eval(l_Found1, l_Point)
		,	_ArrayObject := po_ArrayObject
		,	_Key := EvalResult[1]
		}
		Else
			_Key := $v
		If ($i > 1)
			v_levels.Push(_Key)
		$n := l_Matches[$i + 1]
		If (RegExMatch($n, "^\((.*)\)$", l_Found))
		{
			If ($i = 1)
			{
				_Params := Eval(l_Found1, l_Point)
				_ArrayObject := %_Key%(_Params*)
				HasMethod := true
			}
			Else
			{
				po_ArrayObject := _ArrayObject
			,	_Params := Eval(l_Found1, l_Point)
			,	_ArrayObject := po_ArrayObject
			,	_ArrayObject := _ArrayObject[_Key](_Params*)
			,	HasMethod := true
			}
		}
		Else If (($i = l_Matches.Length()) && (o_Value != ""))
		{
			Try
			{
				If (o_Oper = ":=")
					_ArrayObject := _ArrayObject[_Key] := o_Value
				Else If (o_Oper = "+=")
					_ArrayObject := _ArrayObject[_Key] += o_Value
				Else If (o_Oper = "-=")
					_ArrayObject := _ArrayObject[_Key] -= o_Value
				Else If (o_Oper = "*=")
					_ArrayObject := _ArrayObject[_Key] *= o_Value
				Else If (o_Oper = "/=")
					_ArrayObject := _ArrayObject[_Key] /= o_Value
				Else If (o_Oper = "//=")
					_ArrayObject := _ArrayObject[_Key] //= o_Value
				Else If (o_Oper = ".=")
					_ArrayObject := _ArrayObject[_Key] .= o_Value
				Else If (o_Oper = "|=")
					_ArrayObject := _ArrayObject[_Key] |= o_Value
				Else If (o_Oper = "&=")
					_ArrayObject := _ArrayObject[_Key] &= o_Value
				Else If (o_Oper = "^=")
					_ArrayObject := _ArrayObject[_Key] ^= o_Value
				Else If (o_Oper = ">>=")
					_ArrayObject := _ArrayObject[_Key] >>= o_Value
				Else If (o_Oper = "<<=")
					_ArrayObject := _ArrayObject[_Key] <<= o_Value
			}
		}
		Else If ($i > 1)
			_ArrayObject := _ArrayObject[_Key]
	}
	If (IsObject(_ArrayObject))
		v_String := StrReplace(v_String, o_String, "_ArrayObject")
	Else
	{
		If (QuoteStrings)
			If (!RegExMatch(_ArrayObject, "^-?\d+$"))
				_ArrayObject := """" _ArrayObject """"
		v_String := StrReplace(v_String, o_String, _ArrayObject)
	}
	If (HasMethod)
		v_levels := ""
	return v_String
}

;##################################################
; Author: Uberi
; Modified by: Pulover
; https://autohotkey.com/board/topic/64167-expreval-evaluate-expressions/
;##################################################
ExprInit()
{global 
Exprot:="`n:= 0 R 2`n+= 0 R 2`n-= 0 R 2`n*= 0 R 2`n/= 0 R 2`n//= 0 R 2`n.= 0 R 2`n|= 0 R 2`n&= 0 R 2`n^= 0 R 2`n>>= 0 R 2`n<<= 0 R 2`n|| 3 L 2`n&& 4 L 2`n\! 5 R 1`n= 6 L 2`n== 6 L 2`n<> 6 L 2`n!= 6 L 2`n> 7 L 2`n< 7 L 2`n>= 7 L 2`n<= 7 L 2`n\. 8 L 2`n& 9 L 2`n^ 9 L 2`n| 9 L 2`n<< 10 L 2`n>> 10 L 2`n+ 11 L 2`n- 11 L 2`n* 12 L 2`n/ 12 L 2`n// 12 L 2`n\- 13 R 1`n! 13 R 1`n~ 13 R 1`n\& 13 R 1`n\* 13 R 1`n** 14 R 2`n\++ 15 R 1`n\-- 15 R 1`n++ 15 L 1`n-- 15 L 1`n. 16 L 2`n`% 17 R 1`n",Exprol:=SubStr(RegExReplace(Exprot,"iS) \d+ [LR] \d+\n","`n"),2,-1)
Sort,Exprol,FExprols
}
ExprCompile(e)
{e:=Exprt(e)
Loop,Parse,e,% Chr(1)
{lf:=A_LoopField,tt:=SubStr(lf,1,1),to:=SubStr(lf,2)
If tt=f
Exprp1(s,lf)
Else If lf=,
{While,s<>""&&Exprp3(s)<>"("
Exprp1(ou,Exprp2(s))
}Else If tt=o
{While,SubStr(so:=Exprp3(s),1,1)="o"
{ta:=Expras(to),tp:=Exprpr(to),sop:=Exprpr(SubStr(so,2))
If ((ta="L"&&tp>sop)||(ta="R"&&tp>=sop))
Break
Exprp1(ou,Exprp2(s))
}Exprp1(s,lf)
}Else If lf=(
Exprp1(s,"(")
Else If lf=)
{While,Exprp3(s)<>"("
{If s=
Return
Exprp1(ou,Exprp2(s))
}Exprp2(s)
If (SubStr(Exprp3(s),1,1)="f")
Exprp1(ou,Exprp2(s))
}Else Exprp1(ou,lf)
}While,s<>""
{t1:=Exprp2(s)
If t1 In (,)
Return
Exprp1(ou,t1)
}Return,ou
}
ExprEval(e,lp,eo)
{global __lv ; Lined modified for PMC
c1:=Chr(1)
Loop,Parse,e,%c1%
{lf:=A_LoopField,tt:=SubStr(lf,1,1),t:=SubStr(lf,2)
If tt In l,v
lf:=Exprp1(s,lf)
Else{
If tt=f
t1:=InStr(t," "),a:=SubStr(t,1,t1-1),t:=SubStr(t,t1+1)
Else a:=Exprac(t)
Exprp1(s,Exprap(t,s,a,eo))
}}
Loop,Parse,s,%c1%
{lf:=A_LoopField
If (SubStr(lf,1,1)="v")
t1:=SubStr(lf,2),__lv:="%" . t1 . "%",CheckVars("__lv",lp),r.=__lv . c1 ; Lined modified for PMC
Else r.=SubStr(lf,2) . c1
}Return,SubStr(r,1,-1)
}
Exprap(o,ByRef s,ac,eo)
{local i,t1,a1,a2,a3,a4,a5,a6,a1v,a2v,a3v,a4v,a5v,a6v,a7v,a8v,a9v
Loop,%ac%
i:=ac-(A_Index-1),t1:=Exprp2(s),a%i%:=SubStr(t1,2),(SubStr(t1,1,1)="v")?(a%i%v:=1)
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
If o=&&
Return,"l" . ((a1v ? %a1%:a1)&&(a2v ? %a2%:a2))
If o=||
Return,"l" . ((a1v ? %a1%:a1)||(a2v ? %a2%:a2))
If (RegExMatch(a2,"^<:#(.*)#:>$",rm))  ; Lined modified for PMC
a2:=eo[rm1]  ; Lined modified for PMC
If o=:=
{%a1%:=(a2v ? %a2%:a2)
Return,"v" . a1
}If o=+=
{%a1%+=(a2v ? %a2%:a2)
Return,"v" . a1
}If o=-=
{%a1%-=(a2v ? %a2%:a2)
Return,"v" . a1
}If o=*=
{%a1%*=(a2v ? %a2%:a2)
Return,"v" . a1
}If o=/=
{%a1%/=(a2v ? %a2%:a2)
Return,"v" . a1
}If o=//=
{%a1%//=(a2v ? %a2%:a2)
Return,"v" . a1
}If o=.=
{%a1%.=(a2v ? %a2%:a2)
Return,"v" . a1
}If o=|=
{%a1%|=(a2v ? %a2%:a2)
Return,"v" . a1
}If o=&=
{%a1%&=(a2v ? %a2%:a2)
Return,"v" . a1
}If o=^=
{%a1%^=(a2v ? %a2%:a2)
Return,"v" . a1
}If o=>>=
{%a1%>>=(a2v ? %a2%:a2)
Return,"v" . a1
}If o=<<=
{%a1%<<=(a2v ? %a2%:a2)
Return,"v" . a1
}If ac=0
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
{global Exprol
c1:=Chr(1),f:=1,f1:=1
While,(f:=RegExMatch(e,"S)""(?:[^""]|"""")*""",m,f))
{t1:=SubStr(m,2,-1)
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
}e1.=SubStr(e,f1),e:=InStr(e1,"""")? "":e1,e1:="",e:=RegExReplace(e,"S)/\*.*?\*/|[ \t]`;.*?(?=\r|\n|$)")
StringReplace,e,e,%A_Tab%,%A_Space%,All
e:=RegExReplace(e,"S)([\w#@\$] +|\) *)(?=" . Chr(1) . "*[\w#@\$\(])","$1 . ")
StringReplace,e,e,%A_Space%.%A_Space%,\.,All
StringReplace,e,e,%A_Space%,,All
f:=1,f1:=1
While,(f:=RegExMatch(e,"S)(^|[^\w#@\$\.'])(0x\d+|\d+(?:\.\d+)?|\.\d+)(?=[^\d\.]|$)",m,f))
{m2+=0
StringReplace,m2,m2,.,'2E
e1.=SubStr(e,f1,f-f1) . m1 . c1 . "n" . m2 . c1,f+=StrLen(m),f1:=f
}e:=e1 . SubStr(e,f1),e1:="",e:=RegExReplace(e,"S)(^|\(|[^" . c1 . "-])-" . c1 . "n","$1" . c1 . "n'2D")
StringReplace,e,e,%c1%n,%c1%l,All
e:=RegExReplace(RegExReplace(e,"S)(%[\w#@\$]{1,253})%","$1"),"S)(?:^|[^\w#@\$'" . c1 . "])\K[\w#@\$]{1,253}(?=[^\(\w#@\$]|$)",c1 . "v$0" . c1),f:=1,f1:=1
While,(f:=RegExMatch(e,"S)(^|[^\w#@\$'])([\w#@\$]{1,253})(?=\()",m,f))
{t1:=f+StrLen(m)
If (SubStr(e,t1+1,1)=")")
ac=0
Else
{If !Exprmlb(e,t1,fa)
Return
StringReplace,fa,fa,`,,`,,UseErrorLevel
ac:=ErrorLevel+1
}e1.=SubStr(e,f1,f-f1) . m1 . c1 . "f" . ac . "'20" . m2 . c1,f+=StrLen(m),f1:=f
}e:=e1 . SubStr(e,f1),e1:=""
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
{If ((t1:=SubStr(e,f+1,2))<>27)
StringReplace,e,e,'%t1%,% Chr("0x" . t1),All
}StringReplace,e,e,'27,',All
Return,e
}
Exprols(o1,o2)
{Return,StrLen(o2)-StrLen(o1)
}
Exprpr(o)
{global Exprot
t:=InStr(Exprot,"`n" . o . " ")+StrLen(o)+2
Return,SubStr(Exprot,t,InStr(Exprot," ",0,t)-t)
}
Expras(o)
{global Exprot
Return,SubStr(Exprot,InStr(Exprot," ",0,InStr(Exprot,"`n" . o . " ")+StrLen(o)+2)+1,1)
}
Exprac(o)
{global Exprot
Return,SubStr(Exprot,InStr(Exprot,"`n",0,InStr(Exprot,"`n" . o . " ")+1)-1,1)
}
Exprmlb(ByRef s,p,ByRef o="",b="(",e=")")
{t:=SubStr(s,p),bc:=0,VarSetCapacity(o,StrLen(t))
If (SubStr(t,1,1)<>b)
Return,0
Loop,Parse,t
{lf:=A_LoopField
If lf=%b%
bc++
Else If lf=%e%
{bc--
If bc=0
Return,p
}Else If bc=1
o.=lf
p++
}Return,0
}
Exprp1(ByRef dl,d)
{dl.=((dl="")? "":Chr(1)) . d
}
Exprp2(ByRef dl)
{t:=InStr(dl,Chr(1),0,0),t ?(t1:=SubStr(dl,t+1),dl:=SubStr(dl,1,t-1)):(t1:=dl,dl:="")
Return,t1
}
Exprp3(ByRef dl)
{Return,SubStr(dl,InStr(dl,Chr(1),0,0)+1)
}