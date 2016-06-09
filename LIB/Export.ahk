LV_Export(ListID)
{
	local LVData, Id_LVData, Indent, RowData, Action, Match, ExpValue, Win
	, Step, TimesX, DelayX, Type, Target, Window, Comment, UntilArray := []
	, PAction, PType, PDelayX, PComment, Act, iCount, init_ie, ComExp
	, VarsScope, FuncParams, IsFunction := false, CommentOut := false
	, CDO_To, CDO_Sub, CDO_Msg, CDO_Att, CDO_Html, CDO_CC, CDO_BCC, SelAcc
	, _each, _Section
	Gui, chMacro:Default
	Gui, chMacro:ListView, InputList%ListID%
	ComType := ComCr ? "ComObjCreate" : "ComObjActive"
	Critical
	Loop, % LV_GetCount()
	{
		LV_GetTexts(A_Index, Action, Step, TimesX, DelayX, Type, Target, Window, Comment)
	,	IsChecked := LV_GetNext(A_Index-1, "Checked")
		If (InStr(FileCmdList, Type "|"))
			Step := StrReplace(Step, "```,", "`,")
		If (Type = cType1)
		{
			If (RegExMatch(Step, "^\s*%\s"))
				Step := StrReplace(Step, "``,", ",")
			If ((ConvertBreaks) && (InStr(Step, "``n")))
			{
				Step := StrReplace(Step, "``n", "`n")
			,	Step := StrReplace(Step, "``,", ",")
			,	Step := "`n(LTrim`n" Step "`n)"
			}
			If !(Send_Loop)
			{
				If (((TimesX > 1) || InStr(TimesX, "%")) && (Action != "[Text]"))
					Step := RegExReplace(Step, "{\w+\K(})", " " TimesX "$1")
				If (DelayX = 0)
				{
					LV_GetText(PAction, A_Index-1, 2)
				,	LV_GetText(PType, A_Index-1, 6)
				,	LV_GetText(PDelayX, A_Index-1, 5)
				,	LV_GetText(PComment, A_Index-1, 9)
					If (PType != Type)
						f_SendRow := A_Index
					IsPChecked := LV_GetNext(f_SendRow-1, "Checked")
					LV_GetText(NChecked, IsPChecked, 6)
					If ((f_SendRow != IsPChecked) && (PType != Type)
					&& (NChecked = Type))
						LVData .= "`n" Type ", "
					If ((Type = PType) && (PDelayX = 0) && (PComment = "")
					&& !InStr(Action, "[Text]") && (PAction != "[Text]"))
						RowData := Step
					Else
						RowData := "`n" Type ", " Step
				}
				Else
					RowData := "`n" Type ", " Step
				RowData := Add_CD(RowData, Comment, DelayX)
				If ((Action = "[Text]") && (TimesX > 1))
					RowData := "`nLoop, " TimesX "`n{" RowData "`n}"

			}
			Else
			{
				RowData := "`n" Type ", " Step
			,	RowData := Add_CD(RowData, Comment, DelayX)
				If ((TimesX > 1) || InStr(TimesX, "%"))
					RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
			}
		}
		If ((IsChecked != A_Index) && (!CommentUnchecked))
			continue
		If (Type = cType48)
		{
			If (IsChecked != A_Index)
				continue
			FuncParams .= LTrim(Target " " Step ", "), RowData := ""
		}
		Else If (Type = cType47)
		{
			IsFunction := true
		,	RowData := "`n" Step "(" RTrim(FuncParams, ", ") ")"
			If (Comment != "")
				RowData .= "  " "; " Comment
			RowData .= "`n{"
			StringSplit, FuncVariables, Window, /, %A_Space%
			If (FuncVariables1 != "")
				RowData .= "`n" ((Target = "local") ? "global " : "local ") . FuncVariables1
			Else If (Target = "global")
				RowData .= "`nglobal"
			If (FuncVariables2 != "")
				RowData .= "`n" "static " . FuncVariables2
		}
		Else If (Type = cType49)
			RowData := "`nreturn " Step
		Else If ((Type = cType2) || (Type = cType9) || (Type = cType10))
		{
			If (RegExMatch(Step, "^\s*%\s"))
				Step := StrReplace(Step, "``,", ",")
			If ((ConvertBreaks) && (InStr(Step, "``n")))
			{
				Step := StrReplace(Step, "``n", "`n")
			,	Step := StrReplace(Step, "``,", ",")
			,	Step := "`n(LTrim`n" Step "`n)"
			}
			If (((TimesX > 1) || InStr(TimesX, "%")) && (Action != "[Text]"))
				Step := RegExReplace(Step, "{\w+\K(})", " " TimesX "$1")
			RowData := "`n" Type ", " Target ", " Step ", " Window
		,	RowData := Add_CD(RowData, Comment, DelayX)
			If (TimesX > 1 || InStr(TimesX, "%"))
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		Else If (Type = cType4)
		{
			RowData := "`n" Type ", " Target ", " Window ",, " Step
		,	RowData := Add_CD(RowData, Comment, DelayX)
			If ((TimesX > 1) || InStr(TimesX, "%"))
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		Else If (Type = cType5)
		{
			RowData := "`n" Type ", " DelayX
			If (Comment != "")
				RowData .= "  " "; " Comment
			If ((TimesX > 1) || InStr(TimesX, "%"))
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		Else If (Type = cType6)
		{
			If (RegExMatch(Step, "^\s*%\s"))
				Step := StrReplace(Step, "``,", ",")
			If ((ConvertBreaks) && (InStr(Step, "``n")))
			{
				Step := StrReplace(Step, "``n", "`n")
			,	Step := StrReplace(Step, "``,", ",")
			,	Step := "`n(LTrim`n" Step "`n)"
			}
			If (!RegExMatch(Window, "^\s*%\s"))
				Window := StrReplace(Window, "```,", "`````,")
			RowData := "`n" Type ", " Target ", " Window ", " Step ((DelayX > 0) ? ", " DelayX : "")
			If (Comment != "")
				RowData .= "  " "; " Comment
			If ((TimesX > 1) || InStr(TimesX, "%"))
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		Else If ((Type = cType7) || (Type = cType38) || (Type = cType39)
		|| (Type = cType40) || (Type = cType41) || (Type = cType45) || (Type = cType51))
		{
			Loop, 3
				Stp%A_Index% := ""
			Step := StrReplace(Step, "````,", _x)
		,	Step := StrReplace(Step, "``,", ",")
			If (Action = "[LoopStart]")
			{
				If (Type = cType7)
					RowData := "`n" Type ((TimesX = 0) ? "" : ", " TimesX)
				Else If (Type = cType45)
				{
					StringSplit, Stp, Step, `,, %A_Space%``
					RowData := "`nFor " Stp2 (Stp3 != "" ? ", " Stp3 : "") " in " Stp1
				}
				Else
				{
					Type := StrReplace(Type, "FilePattern", ", Files")
				,	Type := StrReplace(Type, "Parse", ", Parse")
				,	Type := StrReplace(Type, "Read", ", Read")
				,	Type := StrReplace(Type, "Registry", ", Reg")
				,	RowData := "`n" Type . (Type = cType51 ? " " : ", ") . RTrim(Step, ", ")
					If (SubStr(RowData, 0) = "``")
						RowData := SubStr(RowData, 1, StrLen(RowData)-1)
				}
				UntilArray.Push(Target)
			}
			If (Comment != "")
				RowData .= "  " "; " Comment
			RowData .= "`n{"
			If (Action = "[LoopEnd]")
			{
				RowData := "`n}"
			,	Target := UntilArray.Pop()
				If (Target != "")
					RowData .= "`nUntil, " Target
			}
			If (Type = cType45)
				RowData := StrReplace(RowData, _x, ",")
			Else
				RowData := StrReplace(RowData, _x, "``,")
			If (Type = cType39)
				RowData := StrReplace(RowData, "``,", ",")
		}
		Else If (Type = cType12)
		{
			If ((ConvertBreaks) && (InStr(Step, "``n")))
			{
				Step := StrReplace(Step, "``n", "`n")
			,	Step := StrReplace(Step, "``,", ",")
			,	Step := "`n(LTrim`n" Step "`n)"
			}
			RowData := "`n" ((Step != "") ? "SavedClip := ClipboardAll`nClipboard := """"`nClipboard := " CheckExp(Step) "`nSleep, 333" : "")
			If ((Target != "") && (Step != ""))
				RowData .= "`nControlSend, " Target ", ^v, " Window
			Else
				RowData .= "`nSend, ^v"
			RowData := Add_CD(RowData, Comment, DelayX)
			If (Step != "")
				RowData .= "`nClipboard := SavedClip`nSavedClip := """""
			If ((TimesX > 1) || InStr(TimesX, "%"))
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		Else If ((Type = cType15) || (Type = cType16))
		{
			Loop, 5
				Act%A_Index% := ""
			Loop, 5
				Stp%A_Index% := ""
			Loop, Parse, Action, `,,%A_Space%
				Act%A_Index% := A_LoopField
			OutVarX := Act3 != "" ? Act3 : "FoundX"
		,	OutVarY := Act4 != "" ? Act4 : "FoundY"
		,	RowData := "`nCoordMode, Pixel, " Window
		,	RowData .= "`n" Type ", " OutVarX ", " OutVarY ", " Step
			If ((Type = cType16) && (Act5))
			{
				StringSplit, Stp, Step, `,, %A_Space%%A_Tab%
				RowData .= "`nCenterImgSrchCoords(" CheckExp(Stp5) ", " OutVarX ", " OutVarY ")"
			}
			If (Act1 != "Continue")
			{
				RowData .= "`nIf ErrorLevel = 0"
				If (Act1 = "Break")
					RowData .= "`n`tBreak"
				Else If (Act1 = "Stop")
					RowData .= "`n`tReturn"
				Else If (Act1 = "Move")
					RowData .= "`n`tClick, %" OutVarX "%, %" OutVarY "%, 0"
				Else If (InStr(Act1, "Click"))
					RowData .= "`n`tClick, %" OutVarX "%, %" OutVarY "% " StrReplace(Act1, " Click") ", 1"
				Else If (Act1 = "Prompt")
					RowData .= "`n{`nMsgBox, 49, " d_Lang035 ", " d_Lang036 " %" OutVarX "%x%" OutVarY "%.``n" d_Lang038 "`nIfMsgBox, Cancel`n`tReturn`n}"
				Else If (Act1 = "Play Sound")
					RowData .= "`n`tSoundBeep"
			}
			If (Act2 != "Continue")
			{
				RowData .= "`nIf ErrorLevel"
				If (Act2 = "Break")
					RowData .= "`n`tBreak"
				Else If (Act2 = "Stop")
					RowData .= "`n`tReturn"
				Else If (Act2 = "Prompt")
					RowData .= "`n{`nMsgBox, 49, " d_Lang035 ", " d_Lang037 "``n" d_Lang038 "`nIfMsgBox, Cancel`n`tReturn`n}"
				Else If (Act2 = "Play Sound")
					RowData .= "`n`tLoop, 2`n`t`tSoundBeep"
			}
			RowData := Add_CD(RowData, Comment, DelayX)
			If (Target = "UntilFound")
				RowData := "`nLoop" (TimesX != 1 ? ", " TimesX : "") "`n{" RowData "`n}`nUntil ErrorLevel = 0"
			Else If (Target = "UntilNotFound")
				RowData := "`nLoop" (TimesX != 1 ? ", " TimesX : "") "`n{" RowData "`n}`nUntil ErrorLevel"
			Else If ((TimesX > 1) || InStr(TimesX, "%"))
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		Else If (Type = cType17)
		{
			If (Step = "Else")
			{
				RowData := "`n}`nElse"
				If (Comment != "")
					RowData .= "  " "; " Comment
				RowData .= "`n{"
			}
			Else If (Step = "EndIf")
				RowData := "`n}"
			Else
			{
				IfStReplace(Action, Step)
			,	CompareParse(Step, VarName, Oper, VarValue)
				If ((Oper = "between") || (Oper = "not between"))
				{
					_Val1 := "", _Val2 := ""
				,	VarValue := StrReplace(VarValue, "``n", "`n")
					StringSplit, _Val, VarValue, `n, %A_Space%%A_Tab%
					Step := VarName " " Oper " " _Val1 " and " _Val2
				}
				RowData := "`n" Action " " Step
			,	RowData := RTrim(RowData)
				If (Comment != "")
					RowData .= "  " "; " Comment
				RowData .= "`n{"
			}
		}
		Else If ((Type = cType18) || (Type = cType19))
		{
			Loop, Parse, Step, `,
				Par%A_Index% := A_LoopField
			RowData := "`n" Type ", " Step ", " Target ", " Window
		,	RowData := Add_CD(RowData, Comment, DelayX)
			If ((TimesX > 1) || InStr(TimesX, "%"))
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		Else If ((Type = cType20) && (Action = "[KeyWait]"))
		{
			RowData := "`n" Type ", " Step
		,	RowData .= "`n" Type ", " Step ", D"
			If (DelayX > 0)
				RowData .= " T" Round(DelayX/1000, 2)
			Else If (InStr(DelayX, "%"))
				RowData .= " T" DelayX
			If (Comment != "")
				RowData .= "  " "; " Comment
			If ((TimesX > 1) || InStr(TimesX, "%"))
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		Else If ((Type = cType21) || (Type = cType44) || (Type = cType46))
		{
			AssignParse(Step, VarName, Oper, VarValue)
			If (Type = cType21)
			{
				If VarValue is not number
				{
					If (Target != "Expression")
						VarValue := CheckExp(VarValue, 1)
				}
				If ((ConvertBreaks) && (InStr(VarValue, "``n")))
				{
					VarValue := StrReplace(VarValue, "``n", "`n")
				,	VarValue := StrReplace(VarValue, "``,", ",")
				,	VarValue := "`n(LTrim`n" VarValue "`n)"
				}
				Step := VarName " " Oper " " VarValue
			}
			Else If (Type = cType46)
				Step := ((VarName = "_null") ? "" : VarName " " Oper " ") Target "." Action "(" ((VarValue = """") ? "" : VarValue) ")"
			Else
				Step := ((VarName = "_null") ? "" : VarName " " Oper " ") Action "(" ((VarValue = """") ? "" : VarValue) ")"
			RowData := "`n" Step
			If (Comment != "")
				RowData .= "  " "; " Comment
		}
		Else If (Type = cType22)
		{
			If (RegExMatch(Step, "^\s*%\s"))
				Step := StrReplace(Step, "``,", ",")
			If ((ConvertBreaks) && (InStr(Step, "``n")))
			{
				Step := StrReplace(Step, "``n", "`n")
			,	Step := StrReplace(Step, "``,", ",")
			,	Step := "`n(LTrim`n" Step "`n)"
			}
			RowData := "`nControl, EditPaste, " Step ", " Target ", " Window
		,	RowData := Add_CD(RowData, Comment, DelayX)
			If ((TimesX > 1) || InStr(TimesX, "%"))
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		Else If (Type = cType23)
		{
			RowData := "`n" Type ", " Step ", " Target ", " Window
		,	RowData := Add_CD(RowData, Comment, DelayX)
			If ((TimesX > 1) || InStr(TimesX, "%"))
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		Else If ((Type = cType24) || (Type = cType28))
		{
			Stp := StrReplace(Step, "``,", _x)
		,	Step := ""
			Loop, Parse, Stp, `,, %A_Space%
				Step .= (RegExMatch(A_LoopField, "^\s*%\s") ? StrReplace(A_LoopField, _x, ",") : StrReplace(A_LoopField, _x, "``,")) ", "
			Step := SubStr(Step, 1, -2)
		,	RowData := "`n" Type ", " Step ", " Target ", " Window
		,	RowData := Add_CD(RowData, Comment, DelayX)
			If ((TimesX > 1) || InStr(TimesX, "%"))
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		Else If (Type = cType25)
		{
			RowData := "`n" Type ", " Target ", " Window
		,	RowData := Add_CD(RowData, Comment, DelayX)
			If ((TimesX > 1) || InStr(TimesX, "%"))
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		Else If (Type = cType26)
		{
			RowData := "`n" Type ", " Target ", " Step ", " Window
		,	RowData := Add_CD(RowData, Comment, DelayX)
			If ((TimesX > 1) || InStr(TimesX, "%"))
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		Else If (Type = cType27)
		{
			RowData := "`n" Type ", " Step ", " Window
		,	RowData := Add_CD(RowData, Comment, DelayX)
			If ((TimesX > 1) || InStr(TimesX, "%"))
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		Else If ((Type = cType29) || (Type = cType30))
		{
			RowData := "`n" Type (RegExMatch(Step, "^\d+$") ? ", " Step : "")
		,	RowData := Add_CD(RowData, Comment, DelayX)
			If ((TimesX > 1) || InStr(TimesX, "%"))
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		Else If (Type = cType31)
		{
			RowData := "`n" Type ", " Step "X, " Step "Y, "
			. Step "W, " Step "H, " Target ", " Window
		,	RowData := Add_CD(RowData, Comment, DelayX)
			If ((TimesX > 1) || InStr(TimesX, "%"))
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		Else If (Type = cType32)
		{
			StringSplit, Act, Action, :
			StringSplit, El, Target, :
			RowData := "`n" IEComExp(Act2, Step, El1, El2, "", Act3, Act1)
		,	RowData := Add_CD(RowData, Comment, DelayX)
			If (!init_ie)
				RowData := "`nIf !IsObject(ie)"
				.			"`n`tie := ComObjCreate(""InternetExplorer.Application"")"
				.			"`nie.Visible := true" RowData
			init_ie := true
			If (Window = "LoadWait")
				RowData .= "`nIELoad(ie)"
			If ((TimesX > 1) || InStr(TimesX, "%"))
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		Else If (Type = cType33)
		{
			StringSplit, Act, Action, :
			StringSplit, El, Target, :
			RowData := "`n" IEComExp(Act2, "", El1, El2, Step, Act3, Act1)
		,	RowData := Add_CD(RowData, Comment, DelayX)
			If (!init_ie)
				RowData := "`nIf !IsObject(ie)"
				.			"`n`tie := ComObjCreate(""InternetExplorer.Application"")"
				.			"`nie.Visible := true" RowData
			init_ie := true
			If (Window = "LoadWait")
				RowData .= "`nIELoad(ie)"
			If ((TimesX > 1) || InStr(TimesX, "%"))
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		Else If ((Type = cType34) || (Type = cType43))
		{
			RowData := "`n" GetRealLineFeeds(Step)
		,	RowData := Add_CD(RowData, Comment, DelayX)
			If ((Target != "") && (!InStr(LVData, Action " := " ComType "(")))
				RowData := "`nIf !IsObject(" Action ")`n`t" Action " := " ComType "(""" Target """)" RowData
			If (Window = "LoadWait")
				RowData .= "`nIELoad(" Action ")"
			If ((TimesX > 1) || InStr(TimesX, "%"))
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		Else If (Type = cType35)
		{
			RowData := "`n" Step ":"
		,	RowData := Add_CD(RowData, Comment, DelayX)
		}
		Else If ((Type = cType36) || (Type = cType37))
		{
			RowData := "`n" Type ", " Step
		,	RowData := Add_CD(RowData, Comment, DelayX)
		}
		Else If (Type = cType42)
			RowData := (IsChecked = A_Index) ? "`n/*`n" Step "`n*/" : ""
		Else If (Type = cType50)
		{
			Action := RegExReplace(Action, ".*\s")
		,	RowData := "`n" Type ", " Step ", " (Action = "Once" ? (DelayX > 0 ? -DelayX : InStr(DelayX, "%") ? DelayX : -1)
												: Action = "Period" ? DelayX
												: Action)
			If (Comment != "")
				RowData .= "  " "; " Comment
		}
		Else If ((Type = cType3) || (Type = cType8) || (Type = cType13))
		{
			If (RegExMatch(Step, "^\s*%\s"))
				Step := StrReplace(Step, "``,", ",")
			Else If ((ConvertBreaks) && (InStr(Step, "``n")) && ((Type = cType8) || (Type = cType13)))
			{
				Step := StrReplace(Step, "``n", "`n")
			,	Step := StrReplace(Step, "``,", ",")
			,	Step := "`n(LTrim`n" Step "`n)"
			}
			Step := StrReplace(Step, "````,", "``,")
		,	RowData := "`n" Type ", " Step
			If (!RegExMatch(Step, "```,\s*?$"))
				RowData := RTrim(RowData, ", ")
			If ((Type = cType8) || (Action != "[Text]"))
				RowData := Add_CD(RowData, Comment, DelayX)
			Else If (Comment != "")
				RowData .= "  " "; " Comment
			If ((TimesX > 1) || InStr(TimesX, "%"))
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
			If ((Type = cType13) && (Action = "[Text]"))
				RowData := "`nCurrentKeyDelay := A_KeyDelay`nSetKeyDelay, " DelayX RowData "`nSetKeyDelay, %CurrentKeyDelay%"
		}
		Else If (Type = cType52)
		{
			StringSplit, Tar, Target, /
			CDO_Sub := SubStr(Step, 1, RegExMatch(Step, "=\d:") - 1)
		,	Step := SubStr(Step, RegExMatch(Step, "=\d:") + 1)
		,	CDO_To := CheckExp(SubStr(Tar1, 4), 1)
		,	CDO_Sub := CheckExp(CDO_Sub, 1)
		,	CDO_Msg := SubStr(Step, 3)
		,	CDO_Html := SubStr(Step, 1, 1)
		,	CDO_Att := Window
		,	CDO_CC := CheckExp(SubStr(Tar2, 4), 1), CDO_CC := CDO_CC = """""" ? "" : CDO_CC
		,	CDO_BCC := CheckExp(SubStr(Tar3, 5), 1), CDO_BCC := CDO_BCC = """""" ? "" : CDO_BCC
		
		,	SelAcc := ""
		,	User_Accounts := UserMailAccounts.Get(true)
			For _each, _Section in User_Accounts
			{
				If (Action = _Section.email)
				{
					SelAcc := _each
					break
				}
			}
			
			If ((ConvertBreaks) && (InStr(CDO_Msg, "``n")))
			{
				CDO_Msg := StrReplace(CDO_Msg, "``n", "`n")
			,	CDO_Msg := StrReplace(CDO_Msg, "``,", ",")
			,	CDO_Msg := "`n(LTrim`n" CDO_Msg "`n)"
			}
			If ((ConvertBreaks) && (InStr(CDO_Att, "``n")))
			{
				CDO_Att := StrReplace(CDO_Att, "``n", "`n")
			,	CDO_Att := StrReplace(CDO_Att, "``,", ",")
			,	CDO_Att := "`n(LTrim`n" CDO_Att "`n)"
			}
			RowData := "`nMsgBody = " CDO_Msg . (CDO_Att = "" ? "" : "`nAttachments = " CDO_Att)
		,	RowData .= "`nCDO(" SelAcc ", " CDO_To ", " CDO_Sub ", MsgBody, " CDO_Html ", " (CDO_Att = "" ? "" : "Attachments") ", " CDO_CC ", " CDO_BCC
		,	RowData := RTrim(RowData, ", ") . ")"
		,	RowData := Add_CD(RowData, Comment, DelayX)
			If ((TimesX > 1) || InStr(TimesX, "%"))
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		Else If (Type = cType53)
		{
			RowData := "`nWinHttpDownloadToFile(" CheckExp(Step, 1) ", " CheckExp(Target, 1) ")"
		,	RowData := Add_CD(RowData, Comment, DelayX)
			If ((TimesX > 1) || InStr(TimesX, "%"))
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		Else If ((Type = cType54) || (Type = cType55))
		{
			RowData := "`n" Type "(" CheckExp(Step, 1) ", " CheckExp(Target, 1) ", " (Window ? "true" : "")
		,	RowData := RTrim(RowData, ", ") . ")"
		,	RowData := Add_CD(RowData, Comment, DelayX)
			If ((TimesX > 1) || InStr(TimesX, "%"))
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		Else If (InStr(FileCmdList, Type "|"))
		{
			Stp := StrReplace(Step, "``,", _x)
		,	Step := ""
			Loop, Parse, Stp, `,, %A_Space%
				Step .= (RegExMatch(A_LoopField, "^\s*%\s") ? StrReplace(A_LoopField, _x, ",") : StrReplace(A_LoopField, _x, "``,")) ", "
			RowData := "`n" Type ", " Step
		,	RowData := SubStr(RowData, 1, -2)
		,	RowData := Add_CD(RowData, Comment, DelayX)
			If ((TimesX > 1) || InStr(TimesX, "%"))
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		Else If (InStr(Type, "Win"))
		{
			If (Type = "WinMove")
				RowData := "`n" Type ", " Window "," ", " Step
			Else If (Type = "WinGetPos")
				RowData := "`n" Type ", " Step "X, " Step "Y, "
				. Step "W, " Step "H, " Window
			Else If ((Type = "WinSet") || InStr(Type, "Get"))
				RowData := "`n" Type ", " Step ", " Window
			Else If Type contains Close,Kill,Wait,SetTitle
			{
				Win := SplitWin(Window)
			,	RowData := "`n" Type ", " Win[1] ", " Win[2] ", " Step ", " Win[3] ", " Win[4]
			}
			Else
				RowData := "`n" Type ", " Window
			RowData := RTrim(RowData, " ,")
		,	RowData := Add_CD(RowData, Comment, DelayX)
			If ((TimesX > 1) || InStr(TimesX, "%"))
				RowData := "`nLoop, " TimesX "`n{" RowData "`n}"
		}
		If ((IsChecked = A_Index) && (CommentOut))
			LVData .= "`n*/" RowData, CommentOut := false
		Else If ((IsChecked != A_Index) && (!CommentOut) && (Type != cType42))
			LVData .= "`n/*" RowData, CommentOut := true
		Else
			LVData .= RowData
	}
	If (CommentOut)
		LVData .= "`n*/"
	If (IsFunction)
		LVData .= "`n}"
	LVData := LTrim(LVData, "`n")
	If (TabIndent)
	{
		Loop, Parse, LVData, `n
		{
			If (RegExMatch(A_LoopField, "^\}(\s `;)?"))
				Indent--
			Loop, %Indent%
				Id_LVData .= IndentWith = "Tab" ? "`t" : "    "
			Id_LVData .= A_LoopField "`n"
			If (A_LoopField = "{")
				Indent++
		}
		return Id_LVData
	}
	return LVData "`n"
}

IfStReplace(ByRef Action, ByRef Step)
{
	local ElseIf := false
	If (InStr(Action, "[ElseIf]"))
		Action := SubStr(Action, 10), ElseIf := true
	Loop, 15
	{
		Act := "If" A_Index
		If (Action = %Act%)
		{
			Action := c_%Act%
			break
		}
	}
	If (Action = c_If15)
	{
		Action := "If"
		StringReplace, Step, Step, `%,, All
		Step := "(" Step ")"
	}
	If (ElseIf)
		Action := "}`nElse " Action
}

Add_CD(RowData, Comment, DelayX)
{
	If (Comment != "")
		RowData .= "  " "; " Comment
	If ((DelayX > 0) || InStr(DelayX, "%"))
		RowData .= "`n" "Sleep, " DelayX
	return RowData
}

Script_Header()
{
	global
	Header := HeadLine "`n`n#NoEnv`nSetWorkingDir %A_ScriptDir%"
	If (Ex_WN)
		Header .= "`n#Warn"
	If (Ex_CM)
		Header .= "`nCoordMode, Mouse, " CM
	If (Ex_SM)
		Header .= "`nSendMode " SM
	If (Ex_SI)
		Header .= "`n#SingleInstance " SI
	If (Ex_ST)
		Header .= "`nSetTitleMatchMode " ST
	If (Ex_SP)
		Header .= "`nSetTitleMatchMode " SP
	If (Ex_DH)
		Header .= "`nDetectHiddenWindows " DH
	If (Ex_DT)
		Header .= "`nDetectHiddenText " DT
	If (Ex_AF)
		Header .= "`n#WinActivateForce"
	If (Ex_NT)
		Header .= "`n#NoTrayIcon"
	If (Ex_SC)
		Header .= "`nSetControlDelay " SC
	If (Ex_SW)
		Header .= "`nSetWinDelay " SW
	If (Ex_SK)
		Header .= "`nSetKeyDelay " SK
	If (Ex_MD)
		Header .= "`nSetMouseDelay " MD
	If (Ex_SB)
		Header .= "`nSetBatchLines " SB
	If (Ex_HK)
		Header .= "`n#UseHook"
	If (Ex_PT)
		Header .= "`n#Persistent"
	If (Ex_MT)
		Header .= "`n#MaxThreadsPerHotkey " MT
	Header .= "`n`n"
	return Header
}

IncludeFiles(L, N)
{
	global cType44
	
	Gui, chMacro:Default
	Gui, chMacro:ListView, InputList%L%
	Loop, %N%
	{
		If (LV_GetNext(A_Index-1, "Checked") != A_Index)
			continue
		LV_GetText(Row_Type, A_Index, 6)
		If (Row_Type != cType44)
			continue
		LV_GetText(IncFile, A_Index, 7)
		If ((IncFile != "") && (IncFile != "Expression"))
			IncList .= "`#`Include " IncFile "`n"
	}
	Sort, IncList, U
	return IncList
}

CheckForExp(Field)
{
	global cType44
	
	RegExReplace(Field, "U)%\s+([\w%]+)\((.*)\)", "", iCount)
	Match := 0
	Loop, %iCount%
	{
		Match := RegExMatch(Field, "U)%\s+([\w%]+)\((.*)\)", Funct, Match+1)
		If (Type = cType44)
			StringReplace, Funct2, Funct2, `,, ```,
		If ((ExpValue := CheckExp(Funct2)) = """""")
			ExpValue := ""
		StringReplace, Field, Field, %Funct%, % "% " Funct1 "(" ExpValue ")"
	}
	return Field
}

CheckExp(String, IncCommas := false)
{
	Static _x := Chr(2), _y := Chr(3), _z := Chr(4)
	
	If (String = "")
		return """"""
	StringReplace, String, String, ```%, %_y%, All
	StringReplace, String, String, `````,, %_x%, All
	StringReplace, String, String, ``n, %_z%, All
	If (IncCommas)
		StringReplace, String, String, `,, %_x%, All
	Loop, Parse, String, `,, %A_Space%``
	{
		LoopField := (A_LoopField != """""") ? RegExReplace(A_LoopField, """", """""") : A_LoopField
		If (InStr(LoopField, "%"))
		{
			Loop, Parse, LoopField, `%
			{
				If (A_LoopField != "")
					NewStr .=  Mod(A_Index, 2) ? " """ RegExReplace(A_LoopField, "%") """ " : RegExReplace(A_LoopField, "%")
			}
			NewStr := RTrim(NewStr) ", "
		}
		Else If (RegExMatch(LoopField, "[\w%]+\[\S+?\]"))
			NewStr .= LoopField ", "
		Else
			NewStr .= """" LoopField """, "
	}
	StringReplace, NewStr, NewStr, %_x%, `,, All
	StringReplace, NewStr, NewStr, %_y%, `%, All
	StringReplace, NewStr, NewStr, %_z%, ``n, All
	NewStr := Trim(RegExReplace(NewStr, " """" "), ", ")
,	NewStr := RegExReplace(NewStr, """{4}", """""")
,	NewStr := RegExReplace(NewStr, "U)""(-?\d+)""", "$1")
	return NewStr
}

CheckComExp(String, OutVar := "", ByRef ArrString := "", Ptr := "ie")
{
	If (OutVar != "")
		String := Trim(RegExReplace(String, "(.*):=[\s]?"))
	Else If (RegExMatch(String, "[\s]?:=(.*)", Assign))
	{
		Value := Trim(Assign1), String := Trim(RegExReplace(String, "[\s]?:=(.*)"))
		If Value in true,false
			Value := "%" Value "%"
	}
	While, RegExMatch(String, "\(([^()]++|(?R))*\)", _Parent%A_Index%)
		String := RegExReplace(String, "\(([^()]++|(?R))*\)", "&_Parent" A_Index, "", 1)
	While, RegExMatch(String, "U)\[(.*)\]", _Block%A_Index%)
		String := RegExReplace(String, "U)\[(.*)\]", "&_Block" A_Index, "", 1)

	Loop, Parse, String, .&
	{
		If (RegExMatch(A_LoopField, "^_Parent\d+"))
		{
			Parent := SubStr(%A_LoopField%, 2, -1)
			While, RegExMatch(Parent, "U)[^\w\]]\[(.*)\]", _Arr%A_Index%)
				Parent := RegExReplace(Parent, "U)[^\w\]]\[(.*)\]", "_Arr" A_Index, "", 1)
			While, RegExMatch(Parent, "\(([^()]++|(?R))*\)", _iParent%A_Index%)
				Parent := RegExReplace(Parent, "\(([^()]++|(?R))*\)", "&_iParent" A_Index, "", 1)
			Params := ""
			If (InStr(Parent, "`,"))
			{
				Loop, Parse, Parent, `,, %A_Space%
				{
					LoopField := A_LoopField
					While, RegExMatch(LoopField, "&_iParent(\d+)", inPar)
					{
						iPar := RegExReplace(_iParent%inPar1%, "\$", "$$$$")
					,	LoopField := RegExReplace(LoopField, "&_iParent\d+", iPar, "", 1)
					}
					If (RegExMatch(LoopField, "^_Arr\d+"))
					{
						StringSplit, Arr, %LoopField%1, `,, %A_Space%
						ArrString := "SafeArray := ComObjArray(0xC, " Arr0 ")"
						Loop, %Arr0%
							ArrString .= "`nSafeArray[" A_Index-1 "] := " CheckExp(Arr%A_Index%)
						ArrString .= "`n"
						Params .= "SafeArray, "
					}
					Else
					{
						If (Loopfield = "")
							LoopField := "%ComObjMissing()%"
						If (RegExMatch(LoopField, "i)^" Ptr "\..*", NestStr))
							Params .= (CheckComExp(NestStr, OutVar,, Ptr)) ", "
						Else
							Params .= ((CheckExp(LoopField) = """""") ? "" : CheckExp(LoopField)) ", "
					}
				}
			}
			Else
			{
				While, RegExMatch(Parent, "&_iParent(\d+)", inPar)
					Parent := RegExReplace(Parent, "&_iParent\d+", _iParent%inPar1%, "", 1)
				Params := Parent
			}
			Params := RTrim(Params, ", ")
			If (!InStr(Params, "`,"))
			{
				If (RegExMatch(Params, "i)^" Ptr "\..*", NestStr))
					Params := (CheckComExp(NestStr, OutVar,, Ptr))
				Else
					Params := (CheckExp(Params) = """""") ? "" : CheckExp(Params)
			}
			String := RegExReplace(String, "&" A_LoopField, "(" Params ")")
		}
		If (RegExMatch(A_LoopField, "^_Block\d+"))
			String := RegExReplace(String, "&" A_LoopField, "[" CheckExp(%A_LoopField%1) "]")
	}
	If (Value != "")
	{
		StringReplace, Value, Value, `,, `````,, All
		String .= (Value = """""") ? " := """"" : " := " CheckExp(Value)
	}
	Else If (OutVar != "")
		String := "`n" OutVar " := " String
	
	return String
}

IEComExp(Method, Value := "", Element := "", ElIndex := 0, OutputVar := "", GetBy := "Name", Obj := "Method")
{
	If (GetBy = "ID")
		getEl := "getElementByID"
	Else
		getEl := "getElementsBy" GetBy
	
	ElIndex := (ElIndex != "") ? "[" CheckExp(ElIndex) "]" : ""
	
	Value := CheckExp(Value)
	If (!Element)
	{
		If (OutputVar)
			return OutputVar " := ie." Method
		Else If (Obj = "Method")
		{
			If (Value != "")
				return "ie." Method "(" Value ")"
			Else
				return "ie." Method "()"
		}
		Else If (Obj = "Property")
			return "ie." Method " := " Value
	}
	Element := CheckExp(Element)
	If (GetBy = "ID")
	{
		If (OutputVar)
			return OutputVar " := ie.document." getEl "(" Element ")." Method
		Else If (Obj = "Method")
		{
			If (Value != "")
				return "ie.document." getEl "(" Element ")." Method "(" Value ") := " Value
			Else
				return "ie.document." getEl "(" Element ")." Method "()"
		}
		Else If (Obj = "Property")
			return "ie.document." getEl "(" Element ")." Method " := " Value
	}
	Else If (GetBy = "Links")
	{
		If (OutputVar)
			return OutputVar " := ie.document." Element . ElIndex "." Method
		Else If (Obj = "Method")
		{
			If (Value != "")
				return "ie.document." Element . ElIndex "." Method "(" Value ")"
			Else
				return "ie.document." Element . ElIndex "." Method "()"
		}
		Else If (Obj = "Property")
			return "ie.document." Element . ElIndex "." Method " := " Value
	}
	Else If (GetBy != "ID")
	{
		If (OutputVar)
			return OutputVar " := ie.document." getEl "(" Element ")" ElIndex "." Method
		Else If (Obj = "Method")
		{
			If (Value != "")
				return "ie.document." getEl "(" Element ")" ElIndex "." Method "(" Value ")"
			Else
				return "ie.document." getEl "(" Element ")" ElIndex "." Method "()"
		}
		Else If (Obj = "Property")
			return "ie.document." getEl "(" Element ")" ElIndex "." Method " := " Value
	}
}

IncludeFunc(Which)
{
	Func_IELoad =
	(`%

IELoad(Pwb)
{
	While !(Pwb.busy)
		Sleep, 100
	While (Pwb.busy)
		Sleep, 100
	While !(Pwb.document.Readystate = "Complete")
		Sleep, 100
}

)

	Func_CDO =
	(`%

CDO(Account, To, Subject := "", Msg := "", Html := false, Attach := "", CC := "", BCC := "")
{
	MsgObj			:= ComObjCreate("CDO.Message")
	MsgObj.From		:= Account.email
	MsgObj.To		:= StrReplace(To, ",", ";")
	MsgObj.BCC		:= StrReplace(BCC, ",", ";")
	MsgObj.CC		:= StrReplace(CC, ",", ";")
	MsgObj.Subject	:= Subject

	If (Html)
		MsgObj.HtmlBody	:= Msg
	Else
		MsgObj.TextBody	:= Msg

	Schema	:= "http://schemas.microsoft.com/cdo/configuration/"
	Pfld	:= MsgObj.Configuration.Fields

	For Field, Value in Account
		(Field != "email") ? Pfld.Item(Schema . Field) := Value : ""
	Pfld.Update()

	Attach := StrReplace(Attach, ",", ";")
	Loop, Parse, Attach, `;, %A_Space%%A_Tab%
		MsgObj.AddAttachment(A_LoopField)
	
	MsgObj.Send()
}

)

	Func_Zip =
	(`%

Unzip(Sources, OutDir, SeparateFolders := false)
{
	Static vOptions := 16|256
	
	Sources := StrReplace(Sources, "`n", ";")
	Sources := StrReplace(Sources, ",", ";")
	Sources := Trim(Sources, ";")
	OutDir := RTrim(OutDir, "\")
	
	objShell := ComObjCreate("Shell.Application")
	Loop, Parse, Sources, `;, %A_Space%%A_Tab%
	{
		objSource := objShell.NameSpace(A_LoopField).Items()
		TargetDir := OutDir
		If (SeparateFolders)
		{
			SplitPath, A_LoopField,,,, FileNameNoExt
			TargetDir .= "\" FileNameNoExt
			If (!InStr(FileExist(TargetDir), "D"))
				FileCreateDir, %TargetDir%
		}
		objTarget := objShell.NameSpace(TargetDir)
		objTarget.CopyHere(objSource, vOptions)
	}
	ObjRelease(objShell)
}

Zip(FilesToZip, OutFile, SeparateFiles := false)
{
	Static vOptions := 4|16
	
	FilesToZip := StrReplace(FilesToZip, "`n", ";")
	FilesToZip := StrReplace(FilesToZip, ",", ";")
	FilesToZip := Trim(FilesToZip, ";")
	
	objShell := ComObjCreate("Shell.Application")
	If (SeparateFiles)
		SplitPath, OutFile,, OutDir
	Else
	{
		If (!FileExist(OutFile))
			CreateZipFile(OutFile)
		objTarget := objShell.Namespace(OutFile)
	}
	zipped := objTarget.items().Count
	Loop, Parse, FilesToZip, `;, %A_Space%%A_Tab%
	{
		LoopField := RTrim(A_LoopField, "\")
		Loop, Files, %LoopField%, FD
		{
			zipped++
			If (SeparateFiles)
			{
				OutFile := OutDir "\" RegExReplace(A_LoopFileName, "\.(?!.*\.).*") ".zip"
				If (!FileExist(OutFile))
					CreateZipFile(OutFile)
				objTarget := objShell.Namespace(OutFile)
				zipped := 1
			}
			For item in objTarget.Items
			{
				If (item.Name = A_LoopFileDir)
				{
					item.InvokeVerb("Delete")
					zipped--
					break
				}
				If (item.Name = A_LoopFileName)
				{
					FileRemoveDir, % A_Temp "\" item.Name, 1
					FileDelete, % A_Temp "\" item.Name
					objShell.Namespace(A_Temp).MoveHere(item)
					FileRemoveDir, % A_Temp "\" item.Name, 1
					FileDelete, % A_Temp "\" item.Name
					zipped--
					break
				}
			}
			If (A_LoopFileFullPath = OutFile)
			{
				zipped--
				continue
			}
			objTarget.CopyHere(A_LoopFileFullPath, vOptions)
			While (objTarget.items().Count != zipped)
				Sleep, 10
		}
	}
	ObjRelease(objShell)
}

CreateZipFile(sZip)
{
	CurrentEncoding := A_FileEncoding
	FileEncoding, CP1252
	Header1 := "PK" . Chr(5) . Chr(6)
	VarSetCapacity(Header2, 18, 0)
	file := FileOpen(sZip,"w")
	file.Write(Header1)
	file.RawWrite(Header2,18)
	file.close()
	FileEncoding, %CurrentEncoding%
}

)

	Func_WinHttpDownloadToFile =
	(`%

WinHttpDownloadToFile(UrlList, DestFolder)
{
	UrlList := StrReplace(UrlList, "`n", ";")
	UrlList := StrReplace(UrlList, ",", ";")
	DestFolder := RTrim(DestFolder, "\") . "\"
	
	Loop, Parse, UrlList, `;, %A_Space%%A_Tab%
	{
		Url := A_LoopField, FileName := DestFolder . RegExReplace(A_LoopField, ".*/")
		whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		whr.Open("GET", Url, True)
		whr.Send()
		If (whr.WaitForResponse())
		{
			ado := ComObjCreate("ADODB.Stream")
			ado.Type := 1 ; adTypeBinary
			ado.Open
			ado.Write(whr.ResponseBody)
			ado.SaveToFile(FileName, 2)
			ado.Close
		}
	}
}

)

	Func_CenterImgSrchCoords =
	(`%

CenterImgSrchCoords(File, ByRef CoordX, ByRef CoordY)
{
	static LoadedPic
	LastEL := ErrorLevel
	Gui, Pict:Add, Pic, vLoadedPic, %File% 
	GuiControlGet, LoadedPic, Pict:Pos
	Gui, Pict:Destroy
	CoordX += LoadedPicW // 2
	CoordY += LoadedPicH // 2
	ErrorLevel := LastEL
}

)

	return Func_%Which%
}


