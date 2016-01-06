Eval(x, l_Point)
{
   Local y, Result, CompiledExpression, LastFuncRun, Func_Result
		, Funct, Funct1, Funct2, Funct3

	While (RegExMatch(x, "\b([\w\d_]+)\b\.([\w%]+)\((.*?)\)", Funct))  ; Methods
	{
		y := x
		If (IsObject(%Funct1%))
		{
			Params := Object()
		,	Funct3 := StrReplace(Funct3, Funct3, "```,", "`,")
		,	Funct3 := RegExReplace(Funct3, "U)""(.*),(.*)""", """$1¢$2""")
			Loop, Parse, Funct3, `,, %A_Space%``""
			{
				LoopField := CheckParam(A_LoopField, l_Point)
			,	LoopField := StrReplace(LoopField, "¢", "`,")
			,	Params.Push(LoopField)
			}
			Func_Result := %Funct1%[Funct2](Params*)
			If (!IsObject(Func_Result))
			{
				If Func_Result is not Number
					Func_Result := """" Func_Result """"
			}
			Func_Result := StrReplace(Func_Result, "`,", "```,")
		,	x := StrReplace(x, Funct, Func_Result)
		}
		If (y = x)
			break
	}
	While (RegExMatch(x, "([\w_]+)\((.*?)\)", Funct))  ; Functions
	{
		If ((IsFunc(Funct1)) && ((Func(Funct1).IsBuiltIn) || (Func1 = "Screenshot")))
			break
		y := x
		Loop, %TabCount%
		{
			TabIdx := A_Index
			If ((Funct1 "()") = TabGetText(TabSel, A_Index))
			{
				Gui, chMacro:ListView, InputList%TabIdx%
				Loop, % ListCount%TabIdx%
				{
					LV_GetText(Row_Type, A_Index, 6)
					LV_GetText(TargetFunc, A_Index, 3)
					If ((Row_Type = cType47) && (TargetFunc = Funct1))
					{
						Params := Object()
					,	Funct2 := StrReplace(Funct2, "```,", "`,")
					,	Funct2 := RegExReplace(Funct2, "U)""(.*),(.*)""", """$1¢$2""")
						Loop, Parse, Funct2, `,, %A_Space%``
						{
							VarName := LoopField
						,	LoopField := CheckParam(A_LoopField, l_Point)
						,	Params.Push({Name: VarName, Value: LoopField})
						}
						LastFuncRun := RunningFunction, RunningFunction := Funct1
					,	Func_Result := Playback(TabIdx,,, Params)
					,	Func_Result := Func_Result[1]
					,	RunningFunction := LastFuncRun
						If (!IsObject(Func_Result))
						{
							If Func_Result is not Number
								Func_Result := """" Func_Result """"
						}
						Func_Result := StrReplace(Func_Result, "`,", "```,")
					,	x := StrReplace(x, Funct, Func_Result)
						break 2
					}
				}
			}
		}
		If (x = y)
		{
			If ((IsFunc(Funct1)) && (!Func(Funct1).IsBuiltIn))
				return ""
			break
		}
	}
	
	If (RegExMatch(x, "[\w\d_]+\[\S+\]", _Match)) ; Read Arrays
	{
		y := ExtractArrays(x, l_Point)
		If (IsObject(y))
			return y
		If (y = "_ArrayObject")
			y := %LoopField%
		Else If y is not Number
			y := """" y """"
		Func_Result := StrReplace(Func_Result, "`,", "```,") 
		x := StrReplace(x, _Match, y)
	}
	
	If (RegExMatch(x, "^\s*\[(.*)\]\s*$", Found)) ; Assign Arrays
	{
		y := [], Found1 := StrReplace(Found1, "```,", "`,")
		Loop, Parse, Found1, `,, %A_Space%%A_Tab%
		{
			LoopField := A_LoopField
			If LoopField is not Number
			{
				If (LoopField = "A_Index")
					LoopField := LoopIndex
				Else If (LoopField = "ErrorLevel")
					LoopField := LastError
				Else If (RegExMatch(LoopField, "^""(.*)""", lMatch))
					LoopField := lMatch1
				Else If (RegExMatch(LoopField, "i)(A_Loop\w+)", lMatch))
				{
					I := DerefVars(LoopIndex), L := SubStr(lMatch1, 3)
				,	LoopField := RegExReplace(LoopField, "U)" lMatch, o_Loop%l_Point%[I][L])
				}
				Else
					LoopField := DerefVars("%" LoopField "%")
			}
			y.Push(LoopField)
		}
		return y
	}

	Try
	{
		If (IsObject(%x%))
			return %x%.Clone()
	}
	
	ExprInit()
	CompiledExpression := ExprCompile(x)
	Result := ExprEval(CompiledExpression, l_Point)

	Result := StrReplace(Result, Chr(1), A_Space) ;format output list for viewing
	return Result
}

CheckParam(Param, l_Point)
{
	global
	
	Param := DerefVars(Param)
,	Param := StrReplace(Param, "```,", "`,")
,	Param := StrReplace(Param, "¢", "`,")
	If (RegExMatch(Param, "[\w\d_]+\[\S+\]"))
	{
		Param := ExtractArrays(Param, l_Point)
		If (Param = "_ArrayObject")
			Param := %Param%
		Else
		{
			Param := StrReplace(Param, "¢", "`,")
		,	Param := StrReplace(Param, "¥Space", A_Space)
		}
	}
	Else
	{
		ExprInit()
	,	CompiledExpression := ExprCompile(Param)
	,	Param := ExprEval(CompiledExpression, l_Point)
	,	Param := StrReplace(Param, Chr(1), A_Space)
	}
	return Param
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
ExprEval(e,lp)
{global __lv
c1:=Chr(1)
Loop,Parse,e,%c1%
{lf:=A_LoopField,tt:=SubStr(lf,1,1),t:=SubStr(lf,2)
If tt=v
__lv:="%" . SubStr(lf, 2) . "%",CheckVars("__lv",lp),n .= "v__lv" . c1
Else n .= A_LoopField . c1
}e := RTrim(n, c1)
Loop,Parse,e,%c1%
{lf:=A_LoopField,tt:=SubStr(lf,1,1),t:=SubStr(lf,2)
If tt In l,v
Exprp1(s,lf)
Else{
If tt=f
t1:=InStr(t," "),a:=SubStr(t,1,t1-1),t:=SubStr(t,t1+1)
Else a:=Exprac(t)
Exprp1(s,Exprap(t,s,a))
}}
Loop,Parse,s,%c1%
{lf:=A_LoopField
If (SubStr(lf,1,1)="v")
t1:=SubStr(lf,2),r.=%t1% . c1
Else r.=SubStr(lf,2) . c1
}Return,SubStr(r,1,-1)
}
Exprap(o,ByRef s,ac)
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
StringReplace,e,e,%c1%vNot%c1%,\!,All
StringReplace,e,e,%c1%vAnd%c1%,&&,All
StringReplace,e,e,%c1%vOr%c1%,||,All
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