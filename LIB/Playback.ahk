Playback(Macro_On, LoopInfo := "", Manual := "", UDFParams := "", ByRef BreakIt := 0, ByRef SkipIt := 0)
{
	local PlaybackVars := [], LVData := [], IfError := 0, LoopDepth := 0, LoopCount := [0], StartMark := []
	, m_ListCount := ListCount%Macro_On%, mLoopIndex, cLoopIndex, iLoopIndex := 0, mLoopLength, mLoopSize, mListRow
	, Action, Step, TimesX, DelayX, Type, Target, Window, Loop_Start, Loop_End, _Label, _i, Pars
	, NextStep, NStep, NTimesX, NType, NTarget, NWindow, _each, _value, _key
	, pbParams, VarName, VarValue, Oper, RowData, ActiveRows, Increment := 0
	, ScopedParams := [], LastFuncRun, UserGlobals, GlobalList, CursorX, CursorY
	, Func_Result, SVRef, FuncPars, ParamIdx := 1, EvalResult

	If (LoopInfo.GetCapacity())
	{
		LoopDepth := LoopInfo.LoopDepth
	,	PlaybackVars := LoopInfo.PlaybackVars
	,	Loop_Start := LoopInfo.Range.Start
	,	Loop_End := LoopInfo.Range.End
	,	Increment := LoopInfo.Increment
	,	mLoopSize := LoopInfo.Count
	}
	Else
	{
		CoordMode, Mouse, Screen
		MouseGetPos, CursorX, CursorY
		CoordMode, Mouse, %CoordMouse%
		If (Record = 1)
		{
			GoSub, RecStop
			GoSub, b_Start
			Sleep, 500
			GoSub, RowCheck
		}
		Pause, Off
		Try Menu, Tray, Icon, %ResDllPath%, 46
		Menu, Tray, Default, %w_Lang008%
		If (AutoHideBar)
		{
			If (!WinExist("ahk_id " PMCOSC))
				GoSub, ShowControls
		}
		
		PlaybackVars[LoopDepth] := []
	,	PlayOSOn := 1, tbOSC.ModifyButtonInfo(1, "Image", 55)
		If (ShowProgBar = 1)
			GuiControl, 28:+Range0-%m_ListCount%, OSCProg
		mLoopSize := o_TimesG[Macro_On]
	}
	CurrentRange := m_ListCount, ChangeProgBarColor("20D000", "OSCProg", 28)
	Gui, chMacro:Default
	Gui, chMacro:ListView, InputList%Macro_On%
	LVManager.SetHwnd(ListID%Macro_On%)
	Loop, %m_ListCount%
	{
		RowData := LVManager.RowText(A_Index)
	,   LVData[A_Index] := [RowData*]
	}
	ActiveRows := LV_GetSelCheck()
,	mLoopLength := (UDFParams.GetCapacity() || Manual || Increment) ? 1 : o_TimesG[Macro_On]
	While (A_Index <= mLoopLength)
	{
		If (StopIt)
			break
		
		cLoopIndex := A_Index + Increment
		; For _each, _value in PlaybackVars[LoopDepth][mLoopIndex]
			; (InStr(_each, "A_")=1) ? "" : %_each% := _value
		Loop, %m_ListCount%
		{
			mLoopIndex := iLoopIndex ? 1 : cLoopIndex
		,	PlaybackVars[LoopDepth][mLoopIndex, "A_Index"] := mLoopIndex
		,	mListRow := A_Index
			If (StopIt)
				break 2
			If (ShowProgBar = 1)
			{
				GuiControl, 28:, OSCProg, %A_Index%
				GuiControl, 28:, OSCProgTip, % "M" Macro_On " [Loop: " (iLoopIndex ? 1 : mLoopIndex) "/" mLoopSize " | Row: " A_Index "/" m_ListCount "]"
			}
			If (Loop_Start > 0)
			{
				Loop_Start--
				continue
			}
			If (Loop_End = A_Index)
				return
			If ((pb_From) && (A_Index < ActiveRows["Selected"][0]))
				continue
			Else If ((pb_To) && ((ActiveRows["Selected"][0] > 0) && (A_Index > ActiveRows["Selected"][0])))
				break
			Data_GetTexts(LVData, A_Index, Action, Step, TimesX, DelayX, Type, Target, Window)
			If ((Manual) && (ShowStep = 1))
			{
				NexStep := A_Index + 1
			,	Data_GetTexts(LVData, NextStep,, NStep, NTimesX,, NType, NTarget, NWindow)
				ToolTip, 
				(LTrim
				%d_Lang021%: %NextStep%
				%NType%, %NStep%   [x%NTimesX% @ %NWindow%|%NTarget%]

				%d_Lang022%: %A_Index%
				%Type%, %Step%   [x%TimesX% @ %Window%|%Target%]
				)
			}
			If (!ActiveRows.Checked[A_Index])
				continue
			If (pb_Sel)
			{
				If (!ActiveRows.Selected[A_Index])
					continue
			}
			If (WinExist("ahk_id " PMCOSC))
				Gui, 28:+AlwaysOntop
			If (Type = cType48)
			{
				AssignParse(Step, VarName, Oper, VarValue)
				If (VarName = "")
					VarName := Step, VarValue := UDFParams[ParamIdx].Value
				Else
					VarValue := (UDFParams[ParamIdx].Value = "") ? VarValue : UDFParams[ParamIdx].Value
				VarValue := (VarValue = "true") ? 1
						: (VarValue = "false") ? 0
						: Trim(VarValue, """")
			,	ScopedParams[ParamIdx] := {ParamName: VarName
										, VarName: UDFParams[ParamIdx].Name
										, Value: %VarName%
										, NewValue: VarValue
										, Type: (Target = "ByRef") ? "ByRef" : "Param"}
				ParamIdx++
				continue
			}
			If (Type = cType47)
			{
				If (!IsObject(ScopedVars[RunningFunction]))
					ScopedVars[RunningFunction] := []
				If (!IsObject(Static_Vars[RunningFunction]))
					Static_Vars[RunningFunction] := {}
				ScopedVars[RunningFunction].Push([])
			,	SVRef := ScopedVars[RunningFunction][ScopedVars[RunningFunction].MaxIndex()]
				Loop, Parse, Window, /, %A_Space%
				{
					If (A_Index = 2)
					{
						Loop, Parse, A_LoopField, `,, %A_Space%
						{
							AssignParse(A_LoopField, VarName, Oper, VarValue)
							If (VarName = "")
							{
								If (!Static_Vars[RunningFunction].HasKey(A_LoopField))
									Static_Vars[RunningFunction][A_LoopField] := ""
							}
							Else
							{
								If (!Static_Vars[RunningFunction].HasKey(VarName))
									Static_Vars[RunningFunction][VarName] := VarValue
							}
						}
					}
				}
				If (Target = "Global")
				{
					GlobalList := ""
					Loop, Parse, Window, /, %A_Space%
					{
						If (A_Index = 1)
						{
							Loop, Parse, A_LoopField, `,, %A_Space%
							{
								AssignParse(A_LoopField, VarName, Oper, VarValue)
								If (VarName = "")
									SVRef[A_LoopField] := %A_LoopField%, %A_LoopField% := ""
								Else
									SVRef[VarName] := %VarName%, %VarName% := VarValue
							}
						}
					}
				}
				Else If (Target = "Local")
				{
					GlobalList := ""
					Loop, Parse, Window, /, %A_Space%
					{
						If (A_Index = 1)
							Loop, Parse, A_LoopField, `,, %A_Space%
								GlobalList .= A_LoopField ","
					}
					UserGlobals := User_Vars.Get(true)
					For each, Section in UserGlobals
						For _each, _Key in Section
							GlobalList .= _Key.Key ","
					UserGlobals := ""
					
					SavedVars(, VarsList, true)
					For _each, _value in VarsList
					{
						If (_value = "##_Locals:")
							break
						If _value in %GlobalList%
							continue
						SVRef[_value] := %_value%, %_value% := ""
					}
				}
				For _each, _value in Static_Vars[RunningFunction]
					SVRef[_each] := %_value%
				,	%_each% := _value
				
				For _each, _value in ScopedParams
					SVRef[_value.ParamName] := _value.Value
				,	VarName := _value.ParamName
				,	%VarName% := _value.NewValue
				continue
			}
			If (Type = cType49)
			{
				Try
					Func_Result := Eval(Step, PlaybackVars[LoopDepth][mLoopIndex])
				Catch 
				{
					MsgBox, 16, %d_Lang007%, % "Function: " RunningFunction
						.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" (InStr(e.Message, "0x800401E3") ? d_Lang088 : e.Extra)
				}
				
				For _each, _value in ScopedParams
				{
					If (_value.Type = "ByRef")
					{
						ParamName := _value.ParamName
					,	_value.NewValue := %ParamName%
					}
				}
				
				For _each, _value in SVRef
				{
					If (Static_Vars[RunningFunction].HasKey(_each))
						Static_Vars[RunningFunction][_each] := %_each%
					%_each% := _value
				}
				
				For _each, _value in ScopedParams
				{
					If (_value.Type = "ByRef")
					{
						VarName := _value.VarName
					,	%VarName% := _value.NewValue
					}
				}
				
				ScopedVars[RunningFunction].Pop()
				return Func_Result
			}
			If ((Type = cType3) || (Type = cType13))
				MouseReset := 1
			If (Type = cType17)
			{
				IfError := IfStatement(IfError, PlaybackVars[LoopDepth][mLoopIndex], Action, Step, TimesX, DelayX, Type, Target, Window)
				continue
			}
			If (IfError > 0)
				continue
			If ((Type = cType36) || (Type = cType37))
			{
				If ((BreakIt > 0) || (SkipIt > 0))
					continue
				CheckVars(PlaybackVars[LoopDepth][mLoopIndex], Step)
				Loop, %TabCount%
				{
					TabIdx := A_Index
					If (Step = TabGetText(TabSel, A_Index))
					{
						If (Type = cType36)
						{
							_Label := [A_Index, 0, Manual]
							return _Label
						}
						Else
						{
							_Label := Playback(A_Index, 0, Manual)
							If (IsObject(_Label))
								return _Label
							Else If (_Label)
							{
								Lab := _Label, _Label := 0
								If (_Label := Playback(Lab))
									return _Label
							}
							break
						}
					}
					Else
					{
						Gui, chMacro:ListView, InputList%TabIdx%
						Loop, % ListCount%A_Index%
						{
							LV_GetText(Row_Type, A_Index, 6)
							If ((Row_Type = cType36) || (Row_Type = cType37))
								continue
							LV_GetText(TargetLabel, A_Index, 3)
							If ((Row_Type = cType35) && (TargetLabel = Step))
							{
								If (Type = cType36)
								{
									_Label := [TabIdx, A_Index, Manual]
									return _Label
								}
								Else
								{
									_Label := Playback(TabIdx, A_Index, Manual)
									If (IsObject(_Label))
										return _Label
									Else If (_Label)
									{
										Lab := _Label, _Label := 0
										If (_Label := Playback(Lab))
											return _Label
									}
									break
								}
							}
						}
					}
				}
				If (BreakIt > 0)
					BreakIt--
				If (SkipIt > 0)
					SkipIt--
				; If (ShowProgBar = 1)
				; {
					; GuiControl, 28:+Range0-%m_ListCount%, OSCProg
					; GuiControl, 28:, OSCProgTip, % "M" Macro_On " [Loop: 0 / " o_TimesG[Macro_On] " | Row: 0 / " m_ListCount "]"
				; }
				continue
			}
			If (Type = cType35)
				continue
			If (Manual)
			{
				If Type in %cType5%,%cType7%,%cType38%,%cType39%,%cType40%,%cType41%,%cType45%
					continue
			}
			If ((Type = cType7) || (Type = cType38) || (Type = cType39)
			|| (Type = cType40) || (Type = cType41) || (Type = cType45))
			{
				If (Action = "[LoopStart]")
				{
					If (BreakIt > 0)
					{
						BreakIt++
						continue
					}
					If (SkipIt > 0)
					{
						SkipIt++
						continue
					}
					Pars := SplitStep(PlaybackVars[LoopDepth][mLoopIndex], Step, TimesX, DelayX, Type, Target, Window)
				,	CheckVars(PlaybackVars[LoopDepth][mLoopIndex], TimesX)
				,	LoopDepth++
					If (!IsObject(PlaybackVars[LoopDepth]))
						PlaybackVars[LoopDepth] := []
					iLoopIndex++, StartMark[LoopDepth] := A_Index
				,	PlaybackVars[LoopDepth][mLoopIndex, "A_Index"] := 1
					For _key, _value in PlaybackVars[LoopDepth - 1]
						For _each, _value in _value
							PlaybackVars[LoopDepth][_key, _each] := _value
					If (Type = cType38)
					{
						Loop, Read, % Pars[1], % Pars[2]
						{
							If (StopIt)
								break 3
							PlaybackVars[LoopDepth][A_Index, "A_LoopReadLine"] := A_LoopReadLine
						,	LoopCount[LoopDepth] := A_Index - 1
						}
					}
					Else If (Type = cType39)
					{
						Loop, Parse, % Pars[1], % Pars[2], % Pars[3]
						{
							If (StopIt)
								break 3
							PlaybackVars[LoopDepth][A_Index, "A_LoopField"] := A_LoopField
						,	LoopCount[LoopDepth] := A_Index - 1
						}
					}
					Else If (Type = cType40)
					{
						Loop, Files, % Pars[1], % Pars[2]
						{
							If (StopIt)
								break 3
							PlaybackVars[LoopDepth][A_Index, "A_LoopFileName"] := A_LoopFileName
						,	PlaybackVars[LoopDepth][A_Index, "A_LoopFileExt"] := A_LoopFileExt
						,	PlaybackVars[LoopDepth][A_Index, "A_LoopFileFullPath"] := A_LoopFileFullPath
						,	PlaybackVars[LoopDepth][A_Index, "A_LoopFileLongPath"] := A_LoopFileLongPath
						,	PlaybackVars[LoopDepth][A_Index, "A_LoopFileShortPath"] := A_LoopFileShortPath
						,	PlaybackVars[LoopDepth][A_Index, "A_LoopFileShortName"] := A_LoopFileShortName
						,	PlaybackVars[LoopDepth][A_Index, "A_LoopFileDir"] := A_LoopFileDir
						,	PlaybackVars[LoopDepth][A_Index, "A_LoopFileTimeModified"] := A_LoopFileTimeModified
						,	PlaybackVars[LoopDepth][A_Index, "A_LoopFileTimeCreated"] := A_LoopFileTimeCreated
						,	PlaybackVars[LoopDepth][A_Index, "A_LoopFileTimeAccessed"] := A_LoopFileTimeAccessed
						,	PlaybackVars[LoopDepth][A_Index, "A_LoopFileAttrib"] := A_LoopFileAttrib
						,	PlaybackVars[LoopDepth][A_Index, "A_LoopFileSize"] := A_LoopFileSize
						,	PlaybackVars[LoopDepth][A_Index, "A_LoopFileSizeKB"] := A_LoopFileSizeKB
						,	PlaybackVars[LoopDepth][A_Index, "A_LoopFileSizeMB"] := A_LoopFileSizeMB
						,	LoopCount[LoopDepth] := A_Index - 1
						}
					}
					Else If (Type = cType41)
					{
						Loop, Reg, % Pars[1], % Pars[2]
						{
							If (StopIt)
								break 3
							PlaybackVars[LoopDepth][A_Index, "A_LoopRegName"] := A_LoopRegName
						,	PlaybackVars[LoopDepth][A_Index, "A_LoopRegType"] := A_LoopRegType
						,	PlaybackVars[LoopDepth][A_Index, "A_LoopRegKey"] := A_LoopRegKey
						,	PlaybackVars[LoopDepth][A_Index, "A_LoopRegSubKey"] := A_LoopRegSubKey
						,	PlaybackVars[LoopDepth][A_Index, "A_LoopRegTimeModified"] := A_LoopRegTimeModified
						,	LoopCount[LoopDepth] := A_Index - 1
						}
					}
					Else If (Type = cType45)
					{
						VarName := Eval(Pars[1], PlaybackVars[LoopDepth][mLoopIndex])[1]
						For _each, _value in VarName
						{
							PlaybackVars[LoopDepth][A_Index, Pars[2]] := _each
						,	PlaybackVars[LoopDepth][A_Index, Pars[3]] := _value
						,	LoopCount[LoopDepth] := A_Index - 1
						}
					}
					Else
						LoopCount[LoopDepth] := TimesX - 1
					If (LoopCount[LoopDepth] = "")
					{
						PlaybackVars[LoopDepth][mLoopIndex, "A_Index"] := mLoopIndex
						BreakIt++
					}
					For _each, _value in PlaybackVars[LoopDepth][mLoopIndex]
						(InStr(_each, "A_")=1) ? "" : %_each% := _value
					continue
				}
				If (Action = "[LoopEnd]")
				{
					LoopInfo := {LoopDepth: LoopDepth
							,	PlaybackVars: PlaybackVars
							,	Range: {Start: StartMark[LoopDepth], End: A_Index}
							,	Count: LoopCount[LoopDepth] + 1}
					Loop
					{
						If (BreakIt > 0)
						{
							BreakIt--
							LoopDepth--
							continue 2
						}
						If (SkipIt > 1)
						{
							SkipIt--
							continue 2
						}
						If (SkipIt > 0)
							SkipIt--
						
						LoopInfo.Increment := A_Index
					,	GoToLab := Playback(Macro_On, LoopInfo, Manual,, BreakIt, SkipIt)
						If (IsObject(GoToLab))
						{
							For _each, _value in ScopedParams
							{
								If (_value.Type = "ByRef")
								{
									ParamName := _value.ParamName
								,	_value.NewValue := %ParamName%
								}
							}
							
							For _each, _value in SVRef
							{
								If (Static_Vars[RunningFunction].HasKey(_each))
									Static_Vars[RunningFunction][_each] := %_each%
								%_each% := _value
							}
							
							For _each, _value in ScopedParams
							{
								If (_value.Type = "ByRef")
								{
									VarName := _value.VarName
								,	%VarName% := _value.NewValue
								}
							}
							
							return GoToLab
						}
						Else If (GoToLab = "_return")
							break 2
						Else If (GoToLab)
						{
							Lab := GoToLab, GoToLab := 0
							If (_Label := Playback(Lab))
								return _Label
							return
						}
						If (LoopCount[LoopDepth] = A_Index)
							break
					}
					LoopDepth--, iLoopIndex--
				; ,	PlaybackVars[LoopDepth][mLoopIndex, "A_Index"] := mLoopIndex
					continue
				}
			}
			If ((BreakIt > 0) || (SkipIt > 0))
				continue
			If ((Type = cType21) || (Type = cType44) || (Type = cType46))
			{
				Step := StrReplace(Step, "``n", "`n")
			,	Step := StrReplace(Step, "``t", "`t")
			,	Step := StrReplace(Step, "``,", ",")
			,	AssignParse(Step, VarName, Oper, VarValue)
			,	CheckVars(PlaybackVars[LoopDepth][mLoopIndex], Step, Target, Window, VarName, VarValue)
				If (Type = cType21)
				{
					If (Target = "Expression")
					{
						Loop, Parse, VarValue, `n, %A_Space%%A_Tab%
						{
							EvalResult := Eval(A_LoopField, PlaybackVars[LoopDepth][mLoopIndex])
							If (A_Index = 1)
								VarValue := EvalResult[1]
						}
					}
					Try
						AssignVar(VarName, Oper, VarValue, PlaybackVars[LoopDepth][mLoopIndex])
					Catch e
					{
						MsgBox, 20, %d_Lang007%, % "Macro" Macro_On ", " d_Lang065 " " mListRow
							.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" (InStr(e.Message, "0x800401E3") ? d_Lang088 : e.Extra) "`n`n" d_Lang035
						IfMsgBox, No
						{
							StopIt := 1
							continue
						}
					}
					Try SavedVars(VarName)
				}
				Else If ((Target != "") && (!RegExMatch(Target, "\.ahk$")))
				{
					pbParams := Target "." Action "(" VarValue ")"
					Try
					{
						VarValue := Eval(pbParams, PlaybackVars[LoopDepth][mLoopIndex])
					,	AssignVar(VarName, ":=", VarValue, PlaybackVars[LoopDepth][mLoopIndex])
					}
					Catch e
					{
						MsgBox, 20, %d_Lang007%, % "Macro" Macro_On ", " d_Lang065 " " mListRow
							.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" (InStr(e.Message, "0x800401E3") ? d_Lang088 : e.Extra) "`n`n" d_Lang035
						IfMsgBox, No
						{
							StopIt := 1
							continue
						}
					}
					Try SavedVars(VarName)
				}
				Else If ((Type = cType44) && (Target != ""))
				{
					pbParams := Eval(VarValue, PlaybackVars[LoopDepth][mLoopIndex])
					If (A_AhkPath)
					{
						Try
						{
							VarValue := RunExtFunc(Target, Action, pbParams*)
						,	AssignVar(VarName, ":=", VarValue, PlaybackVars[LoopDepth][mLoopIndex])
						}
						
						Try SavedVars(VarName)
					}
				}
				Else If (Type = cType44)
				{
					Loop, %TabCount%
					{
						TabIdx := A_Index
						If ((Action "()") = TabGetText(TabSel, A_Index))
						{
							Gui, chMacro:ListView, InputList%TabIdx%
							Loop, % ListCount%TabIdx%
							{
								LV_GetText(Row_Type, A_Index, 6)
								LV_GetText(TargetFunc, A_Index, 3)
								If ((Row_Type = cType47) && (TargetFunc = Action))
								{
									pbParams := {}
								,	FuncPars := ExprGetPars(VarValue)
								,	EvalResult := Eval(VarValue, PlaybackVars[LoopDepth][mLoopIndex])
									For _each, _value in EvalResult
										pbParams[_each] := {Name: FuncPars[_each], Value: _value}
									LastFuncRun := RunningFunction, RunningFunction := Action
								,	Func_Result := Playback(TabIdx,,, pbParams)
								,	VarValue := Func_Result[1]
								,	RunningFunction := LastFuncRun
									Try
										AssignVar(VarName, ":=", VarValue, PlaybackVars[LoopDepth][mLoopIndex])
									Catch e
									{
										MsgBox, 20, %d_Lang007%, % "Macro" Macro_On ", " d_Lang065 " " mListRow
											.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" (InStr(e.Message, "0x800401E3") ? d_Lang088 : e.Extra) "`n`n" d_Lang035
										IfMsgBox, No
										{
											StopIt := 1
											continue 3
										}
									}
									Try SavedVars(VarName)
									continue 3
								}
							}
						}
					}
					If (IsFunc(Action))
					{
						If (!Func(Action).IsBuiltIn)
							If Action not in Screenshot,Zip,UnZip
								continue
								
						pbParams := Eval(VarValue, PlaybackVars[LoopDepth][mLoopIndex])
						Try
						{
							VarValue := %Action%(pbParams*)
						,	AssignVar(VarName, ":=", VarValue, PlaybackVars[LoopDepth][mLoopIndex])
						}
						Catch e
						{
							MsgBox, 20, %d_Lang007%, % "Macro" Macro_On ", " d_Lang065 " " mListRow
								.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" (InStr(e.Message, "0x800401E3") ? d_Lang088 : e.Extra) "`n`n" d_Lang035
							IfMsgBox, No
							{
								StopIt := 1
								continue
							}
						}
						Try SavedVars(VarName)
					}
				}
				continue
			}
			If ((Type = cType15) || (Type = cType16))
			{
				Loop, Parse, Action, `,,%A_Space%
					Act%A_Index% := A_LoopField
			}
			Else
			{
				If (InStr(Step, "``n"))
					Step := StrReplace(Step, "``n", "`n")
				If (InStr(Step, "``t"))
					Step := StrReplace(Step, "``t", "`t")
				If (InStr(Step, "``,"))
					Step := StrReplace(Step, "``,", ",")
			}
			If (Type = "Return")
				break 2
			If (Type = cType29)
			{
				If (Manual)
					break 2
				If (LoopDepth = 0)
				{
					If Step is number
						BreakIt += Step
					Else
						BreakIt++
					break 2
				}
				Else
				{
					If Step is number
						BreakIt += Step
					Else
						BreakIt++
					continue
				}
			}
			If (Type = cType30)
			{
				If Step is number
					SkipIt += Step
				Else
					SkipIt++
				continue
			}
			If (Type = cType50)
				continue
			Pars := SplitStep(PlaybackVars[LoopDepth][mLoopIndex], Step, TimesX, DelayX, Type, Target, Window)
			While (TimesX)
			{
				If (StopIt)
				{
					Try Menu, Tray, Icon, %DefaultIcon%, 1
					Menu, Tray, Default, %w_Lang005%
					break 3
				}
				__PointMarker := LoopDepth
				PlayCommand(Type, Action, Step, DelayX, Target, Window, Pars)
				PlaybackVars[LoopDepth][mLoopIndex, "ErrorLevel"] := ErrorLevel
				If ((Type = cType15) || (Type = cType16))
				{
					If ((TakeAction = "Break") || ((Target = "Break") && (SearchResult = 0)))
					{
						TakeAction := 0
						break
					}
					Else If ((Target = "Continue") && (SearchResult))
						break
					Else If (Target = "")
						TimesX--
				}
				Else
					TimesX--
				If Type in Sleep,KeyWait,MsgBox
					continue
				If !(Manual)
					PlayCommand("Sleep", Action, Step, DelayX, Target, Window, Pars)
			}
			If (Manual)
				WaitFor.Key(o_ManKey[Manual], 0)
		}
		If (StopIt || BreakIt)
			break
	}
	If (UDFParams.GetCapacity())
	{
		Func_Result := [""]
	
		For _each, _value in ScopedParams
		{
			If (_value.Type = "ByRef")
			{
				ParamName := _value.ParamName
			,	_value.NewValue := %ParamName%
			}
		}
		
		For _each, _value in SVRef
		{
			If (Static_Vars[RunningFunction].HasKey(_each))
				Static_Vars[RunningFunction][_each] := %_each%
			%_each% := _value
		}
		
		For _each, _value in ScopedParams
		{
			If (_value.Type = "ByRef")
			{
				VarName := _value.VarName
			,	%VarName% := _value.NewValue
			}
		}

		ScopedVars[RunningFunction].Pop()
		
		return Func_Result
	}
	If ((MouseReturn = 1) && (MouseReset = 1))
	{
		CoordMode, Mouse, Screen
		Click, %CursorX%, %CursorY%, 0
	}
	CoordMode, Mouse, %CoordMouse%
	Progress, Off
	SplashTextOff
	SplashImage, Off
	BlockInput, MouseMoveOff
	BlockInput, Off
	CurrentRange := ""
	If !(aHK_Timer)
	{
		Try Menu, Tray, Icon, %DefaultIcon%, 1
		Menu, Tray, Default, %w_Lang005%
		PlayOSOn := 0
		tbOSC.ModifyButtonInfo(1, "Image", 48)
		If (AutoHideBar)
		{
			If (WinExist("ahk_id " PMCOSC))
				GoSub, 28GuiClose
			Else
				Gui, 28:+AlwaysOntop
		}
	}
	If (CloseAfterPlay)
		ExitApp
	If (OnFinishCode > 1)
		GoSub, OnFinishAction
}

;##### Playback Commands #####

PlayCommand(Type, Action, Step, DelayX, Target, Window, Pars)
{
	local Par1, Par2, Par3, Par4, Par5, Par6, Par7, Par8, Par9, Par10, Par11, Win
	For _each, _value in Pars
		Par%_each% := _value
	
	GoSub, pb_%Type%
	return
	
	pb_Send:
		If (WinActive("ahk_id " PMCWinID))
		{
			StopIt := 1
			return
		}
		Send, %Step%
	return
	pb_ControlSend:
		Win := SplitWin(Window)
		ControlSend, %Target%, %Step%, % Win[1], % Win[2], % Win[3], % Win[4]
	return
	pb_Click:
		If (WinActive("ahk_id " PMCWinID))
		{
			StopIt := 1
			return
		}
		Click, %Step%
	return
	pb_ControlClick:
		Win := SplitWin(Window)
		ControlClick, %Target%, % Win[1], % Win[2], %Par1%, %Par2%, %Par3%, % Win[3], % Win[4]
	return
	pb_SendEvent:
		If (WinActive("ahk_id " PMCWinID))
		{
			StopIt := 1
			return
		}
		If (Action = "[Text]")
			SetKeyDelay, %DelayX%
		SendEvent, %Step%
	return
	pb_Sleep:
		If ((Type = cType5) && (Step = "Random"))
			SleepRandom(, DelayX, Target)
		Else
		{
			If ((RandomSleeps) && (Step != "NoRandom"))
				SleepRandom(DelayX,,, RandPercent)
			Else If (SlowKeyOn)
				Sleep, (DelayX*SpeedDn)
			Else If (FastKeyOn)
				Sleep, (DelayX/SpeedUp)
			Else If ((Type = cType13) && (Action = "[Text]"))
				return
			Else
				Sleep, %DelayX%
		}
	return
	pb_MsgBox:
		Step := StrReplace(Step, "``n", "`n")
		Step := StrReplace(Step, "``,", ",")
		Try Menu, Tray, Icon, %ResDllPath%, 77
		ChangeProgBarColor("Blue", "OSCProg", 28)
		MsgBox, % Target, % (Window != "") ? Window : AppName, %Step%, %DelayX%
		Try Menu, Tray, Icon, %ResDllPath%, 46
		ChangeProgBarColor("20D000", "OSCProg", 28)
	return
	pb_SendRaw:
		If (WinActive("ahk_id " PMCWinID))
		{
			StopIt := 1
			return
		}
		SendRaw, %Step%
	return
	pb_ControlSendRaw:
		Win := SplitWin(Window)
		ControlSendRaw, %Target%, %Step%, % Win[1], % Win[2], % Win[3], % Win[4]
	return
	pb_ControlSetText:
		Win := SplitWin(Window)
		ControlSetText, %Target%, %Step%, % Win[1], % Win[2], % Win[3], % Win[4]
	return
	pb_Run:
		If (Par4 != "")
		{
			Run, %Par1%, %Par2%, %Par3%, %Par4%
			Try SavedVars(Par4)
		}
		Else
			Run, %Par1%, %Par2%, %Par3%
	return
	pb_RunWait:
		Try Menu, Tray, Icon, %ResDllPath%, 77
		ChangeProgBarColor("Blue", "OSCProg", 28)
		If (Par4 != "")
		{
			RunWait, %Par1%, %Par2%, %Par3%, %Par4%
			Try SavedVars(Par4)
		}
		Else
			RunWait, %Par1%, %Par2%, %Par3%
		Try Menu, Tray, Icon, %ResDllPath%, 46
		ChangeProgBarColor("20D000", "OSCProg", 28)
	return
	pb_RunAs:
		RunAs, %Par1%, %Par2%, %Par3%
	return
	pb_Process:
		Process, %Par1%, %Par2%, %Par3%
	return
	pb_Shutdown:
		Shutdown, %Step%
	return
	pb_GetKeyState:
		GetKeyState, %Par1%, %Par2%, %Par3%
		Try SavedVars(Par1)
	return
	pb_MouseGetPos:
		Loop, 4
		{
			If (Par%A_Index% = "")
				Par%A_Index% := "Null"
		}
		MouseGetPos, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
		Null := ""
		Try SavedVars(Par1)
	return
	pb_PixelGetColor:
		PixelGetColor, %Par1%, %Par2%, %Par3%, %Par4%
		Try SavedVars(Par1)
	return
	pb_SysGet:
		SysGet, %Par1%, %Par2%, %Par3%
		Try SavedVars(Par1)
	return
	pb_SetCapsLockState:
		SetCapsLockState, %Par1%
	return
	pb_SetNumLockState:
		SetNumLockState, %Par1%
	return
	pb_SetScrollLockState:
		SetScrollLockState, %Par1%
	return
	pb_EnvAdd:
		EnvAdd, %Par1%, %Par2%, %Par3%
	return
	pb_EnvSub:
		EnvSub, %Par1%, %Par2%, %Par3%
	return
	pb_EnvDiv:
		EnvDiv, %Par1%, %Par2%
	return
	pb_EnvMult:
		EnvMult, %Par1%, %Par2%
	return
	pb_EnvGet:
		EnvGet, %Par1%, %Par2%
		Try SavedVars(Par1)
	return
	pb_EnvSet:
		EnvSet, %Par1%, %Par2%
	return
	pb_EnvUpdate:
		EnvUpdate
	return
	pb_FormatTime:
		FormatTime, %Par1%, %Par2%, %Par3%
		Try SavedVars(Par1)
	return
	pb_Transform:
		Transform, %Par1%, %Par2%, %Par3%, %Par4%
		Try SavedVars(Par1)
	return
	pb_Random:
		Random, %Par1%, %Par2%, %Par3%
		Try SavedVars(Par1)
	return
	pb_FileAppend:
		FileAppend, %Par1%, %Par2%, %Par3%
	return
	pb_FileCopy:
		FileCopy, %Par1%, %Par2%, %Par3%
	return
	pb_FileCopyDir:
		FileCopyDir, %Par1%, %Par2%, %Par3%
	return
	pb_FileCreateDir:
		FileCreateDir, %Step%
	return
	pb_FileDelete:
		FileDelete, %Step%
	return
	pb_FileGetAttrib:
		FileGetAttrib, %Par1%, %Par2%
		Try SavedVars(Par1)
	return
	pb_FileGetSize:
		FileGetSize, %Par1%, %Par2%, %Par3%
		Try SavedVars(Par1)
	return
	pb_FileGetTime:
		FileGetTime, %Par1%, %Par2%, %Par3%
		Try SavedVars(Par1)
	return
	pb_FileGetVersion:
		FileGetVersion, %Par1%, %Par2%
		Try SavedVars(Par1)
	return
	pb_FileMove:
		FileMove, %Par1%, %Par2%, %Par3%
	return
	pb_FileMoveDir:
		FileMoveDir, %Par1%, %Par2%, %Par3%
	return
	pb_FileRead:
		FileRead, %Par1%, %Par2%
		Try SavedVars(Par1)
	return
	pb_FileReadLine:
		FileReadLine, %Par1%, %Par2%, %Par3%
		Try SavedVars(Par1)
	return
	pb_FileRecycle:
		FileRecycle, %Step%
	return
	pb_FileRecycleEmpty:
		FileRecycleEmpty, %Step%
	return
	pb_FileRemoveDir:
		FileRemoveDir, %Par1%, %Par2%
	return
	pb_FileSelectFile:
		FileSelectFile, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
		Try SavedVars(Par1)
	return
	pb_FileSelectFolder:
		FileSelectFolder, %Par1%, %Par2%, %Par3%, %Par4%
		Try SavedVars(Par1)
	return
	pb_FileSetAttrib:
		FileSetAttrib, %Par1%, %Par2%, %Par3%, %Par4%
	return
	pb_FileSetTime:
		FileSetTime, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
	return
	pb_Drive:
		Drive, %Par1%, %Par2%, %Par3%
	return
	pb_DriveGet:
		DriveGet, %Par1%, %Par2%, %Par3%
		Try SavedVars(Par1)
	return
	pb_DriveSpaceFree:
		DriveSpaceFree, %Par1%, %Par2%
		Try SavedVars(Par1)
	return
	pb_Sort:
		Sort, %Par1%, %Par2%
		Try SavedVars(Par1)
	return
	pb_StringGetPos:
		StringGetPos, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
		Try SavedVars(Par1)
	return
	pb_StringLeft:
		StringLeft, %Par1%, %Par2%, %Par3%
		Try SavedVars(Par1)
	return
	pb_StringRight:
		StringRight, %Par1%, %Par2%, %Par3%
		Try SavedVars(Par1)
	return
	pb_StringLen:
		StringLen, %Par1%, %Par2%
		Try SavedVars(Par1)
	return
	pb_StringLower:
		StringLower, %Par1%, %Par2%, %Par3%
		Try SavedVars(Par1)
	return
	pb_StringUpper:
		StringUpper, %Par1%, %Par2%, %Par3%
		Try SavedVars(Par1)
	return
	pb_StringMid:
		StringMid, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
		Try SavedVars(Par1)
	return
	pb_StringReplace:
		StringReplace, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
		Try SavedVars(Par1)
	return
	pb_StringSplit:
		StringSplit, %Par1%, %Par2%, %Par3%, %Par4%
		CGN := Par1 . "0"
		Loop, % %CGN%
		{
			CGP := Par1 . A_Index
			Try SavedVars(CGP)
		}
	return
	pb_StringTrimLeft:
		StringTrimLeft, %Par1%, %Par2%, %Par3%
		Try SavedVars(Par1)
	return
	pb_StringTrimRight:
		StringTrimRight, %Par1%, %Par2%, %Par3%
		Try SavedVars(Par1)
	return
	pb_SplitPath:
		Loop, 6
		{
			If (Par%A_Index% = "")
				Par%A_Index% := "Null"
		}
		SplitPath, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%
		Null := ""
		Loop, 5
			Try SavedVars(Par%A_Index%)
	return
	pb_InputBox:
		InputBox, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%, %Par7%, %Par8%,, %Par10%, %Par11%
		Try SavedVars(Par1)
	return
	pb_ToolTip:
		ToolTip, %Par1%, %Par2%, %Par3%, %Par4%
	return
	pb_TrayTip:
		TrayTip, %Par1%, %Par2%, %Par3%, %Par4%
	return
	pb_Progress:
		Progress, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
	return
	pb_SplashImage:
		SplashImage, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%
	return
	pb_SplashTextOn:
		SplashTextOn, %Par1%, %Par2%, %Par3%, %Par4%
	return
	pb_SplashTextOff:
		SplashTextOff
	return
	pb_RegRead:
		RegRead, %Par1%, %Par2%, %Par3%, %Par4%
		Try SavedVars(Par1)
	return
	pb_RegWrite:
		RegWrite, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
	return
	pb_RegDelete:
		RegDelete, %Par1%, %Par2%, %Par3%
	return
	pb_SetRegView:
		SetRegView, %Par1%
	return
	pb_IniRead:
		IniRead, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
		Try SavedVars(Par1)
	return
	pb_IniWrite:
		IniWrite, %Par1%, %Par2%, %Par3%, %Par4%
	return
	pb_IniDelete:
		IniDelete, %Par1%, %Par2%, %Par3%
	return
	pb_SoundBeep:
		SoundBeep, %Par1%, %Par2%
	return
	pb_SoundGet:
		SoundGet, %Par1%, %Par2%, %Par3%, %Par4%
		Try SavedVars(Par1)
	return
	pb_SoundGetWaveVolume:
		SoundGetWaveVolume, %Par1%, %Par2%
		Try SavedVars(Par1)
	return
	pb_SoundPlay:
		SoundPlay, %Par1%, %Par2%
	return
	pb_SoundSet:
		SoundSet, %Par1%, %Par2%, %Par3%, %Par4%
	return
	pb_SoundSetWaveVolume:
		SoundSetWaveVolume, %Par1%, %Par2%
	return
	pb_ClipWait:
		Try Menu, Tray, Icon, %ResDllPath%, 77
		ChangeProgBarColor("Blue", "OSCProg", 28)
		ClipWait, %Par1%, %Par2%
		Try Menu, Tray, Icon, %ResDllPath%, 46
		ChangeProgBarColor("20D000", "OSCProg", 28)
	return
	pb_BlockInput:
		BlockInput, %Step%
	return
	pb_UrlDownloadToFile:
		UrlDownloadToFile, %Par1%, %Par2%
	return
	pb_CoordMode:
		CoordMode, %Par1%, %Par2%
	return
	pb_OutputDebug:
		OutputDebug, %Step%
	return
	pb_WinMenuSelectItem:
		WinMenuSelectItem, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%, %Par7%, %Par8%, %Par9%, %Par10%, %Par11%
	return
	pb_SendLevel:
		SendLevel, %Step%
	return
	pb_SetKeyDelay:
		SetKeyDelay, %Par1%, %Par2%, %Par3%
	return
	pb_Pause:
		ToggleIcon()
		Pause
	return
	pb_ExitApp:
		ExitApp
	return
	pb_ListVars:
		GoSub, ListVars
	return
	pb_StatusBarGetText:
		StatusBarGetText, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%
		Try SavedVars(Par1)
	return
	pb_StatusBarWait:
		Try Menu, Tray, Icon, %ResDllPath%, 77
		ChangeProgBarColor("Blue", "OSCProg", 28)
		StatusBarWait, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%
		Try Menu, Tray, Icon, %ResDllPath%, 46
		ChangeProgBarColor("20D000", "OSCProg", 28)
	return
	pb_Clipboard:
		SavedClip := ClipboardAll
		If (Step != "")
		{
			Clipboard =
			Clipboard := Step
			Sleep, 333
		}
		If (Target != "")
		{
			Win := SplitWin(Window)
			ControlSend, %Target%, {Control Down}{v}{Control Up}, % Win[1], % Win[2], % Win[3], % Win[4]
		}
		Else
			Send, {Control Down}{v}{Control Up}
		Clipboard := SavedClip
		SavedClip := ""
	return
	pb_Control:
		Win := SplitWin(Window)
		Control, % RegExReplace(Step, "(^\w*).*", "$1")
		, % RegExReplace(Step, "^\w*, ?(.*)", "$1")
		, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
	return
	pb_ControlFocus:
		Win := SplitWin(Window)
		ControlFocus, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
	return
	pb_ControlMove:
		Win := SplitWin(Window)
		ControlMove, %Target%, %Par1%, %Par2%, %Par3%, %Par4%, % Win[1], % Win[2], % Win[3], % Win[4]
	return
	pb_PixelSearch:
		CoordMode, Pixel, %Window%
		PixelSearch, FoundX, FoundY, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%, %Par7%
		SearchResult := ErrorLevel
		GoSub, TakeAction
	return
	pb_ImageSearch:
		CoordMode, Pixel, %Window%
		ImageSearch, FoundX, FoundY, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
		SearchResult := ErrorLevel
		GoSub, TakeAction
	return
	pb_SendMessage:
		Win := SplitWin(Window)
		SendMessage, %Par1%, %Par2%, %Par3%, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
	return
	pb_PostMessage:
		Win := SplitWin(Window)
		PostMessage, %Par1%, %Par2%, %Par3%, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
	return
	pb_KeyWait:
		Try Menu, Tray, Icon, %ResDllPath%, 77
		ChangeProgBarColor("Blue", "OSCProg", 28)
		If (Action = "KeyWait")
			KeyWait, %Par1%, %Par2%
		Else
			WaitFor.Key(Step, DelayX / 1000)
		Try Menu, Tray, Icon, %ResDllPath%, 46
		ChangeProgBarColor("20D000", "OSCProg", 28)
	return
	pb_Input:
		Input, %Par1%, %Par2%, %Par3%, %Par4%
		Try SavedVars(Par1)
	return
	pb_ControlEditPaste:
		Win := SplitWin(Window)
		Control, EditPaste, %Step%, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
	return
	pb_ControlGetText:
		Win := SplitWin(Window)
		ControlGetText, %Step%, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
		Try SavedVars(Step)
	return
	pb_ControlGetFocus:
		Win := SplitWin(Window)
		ControlGetFocus, %Step%, % Win[1], % Win[2], % Win[3], % Win[4]
		Try SavedVars(Step)
	return
	pb_ControlGet:
		Win := SplitWin(Window)
		ControlGet, %Par1%, %Par2%, %Par3%, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
		Try SavedVars(Par1)
	return
	pb_ControlGetPos:
		Win := SplitWin(Window)
		ControlGetPos, %Step%X, %Step%Y, %Step%W, %Step%H, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
		CGPPars := "X|Y|W|H"
		Loop, Parse, CGPPars, |
		{
			CGP := Step . A_LoopField
			Try SavedVars(CGP)
		}
	return
	pb_WinActivate:
		Win := SplitWin(Window)
		WinActivate, % Win[1], % Win[2], % Win[3], % Win[4]
	return
	pb_WinActivateBottom:
		Win := SplitWin(Window)
		WinActivateBottom, % Win[1], % Win[2], % Win[3], % Win[4]
	return
	pb_WinClose:
		Win := SplitWin(Window)
		WinClose, % Win[1], % Win[2], % Win[3], % Win[4]
	return
	pb_WinHide:
		Win := SplitWin(Window)
		WinHide, % Win[1], % Win[2], % Win[3], % Win[4]
	return
	pb_WinKill:
		Win := SplitWin(Window)
		WinKill, % Win[1], % Win[2], % Win[3], % Win[4], % Win[5]
	return
	pb_WinMaximize:
		Win := SplitWin(Window)
		WinMaximize, % Win[1], % Win[2], % Win[3], % Win[4]
	return
	pb_WinMinimize:
		Win := SplitWin(Window)
		WinMinimize, % Win[1], % Win[2], % Win[3], % Win[4]
	return
	pb_WinMinimizeAll:
		WinMinimizeAll, %Window%
	return
	pb_WinMinimizeAllUndo:
		WinMinimizeAllUndo, %Window%
	return
	pb_WinMove:
		Win := SplitWin(Window)
		WinMove, % Win[1], % Win[2], %Par1%, %Par2%, %Par3%, %Par4%, % Win[3], % Win[4]
	return
	pb_WinRestore:
		Win := SplitWin(Window)
		WinRestore, % Win[1], % Win[2], % Win[3], % Win[4]
	return
	pb_WinSet:
		Win := SplitWin(Window)
		WinSet, %Par1%, %Par2%, % Win[1], % Win[2], % Win[3], % Win[4]
	return
	pb_WinShow:
		Win := SplitWin(Window)
		WinShow, % Win[1], % Win[2], % Win[3], % Win[4]
	return
	pb_WinSetTitle:
		Win := SplitWin(Window)
		WinSetTitle, % Win[1], % Win[2], % Win[3], % Win[4], % Win[5]
	return
	pb_WinWait:
		Try Menu, Tray, Icon, %ResDllPath%, 77
		ChangeProgBarColor("Blue", "OSCProg", 28)
	,	WaitFor.WinExist(SplitWin(Window), Step)
		Try Menu, Tray, Icon, %ResDllPath%, 46
		ChangeProgBarColor("20D000", "OSCProg", 28)
	return
	pb_WinWaitActive:
		Try Menu, Tray, Icon, %ResDllPath%, 77
		ChangeProgBarColor("Blue", "OSCProg", 28)
	,	WaitFor.WinActive(SplitWin(Window), Step)
		Try Menu, Tray, Icon, %ResDllPath%, 46
		ChangeProgBarColor("20D000", "OSCProg", 28)
	return
	pb_WinWaitNotActive:
		Try Menu, Tray, Icon, %ResDllPath%, 77
		ChangeProgBarColor("Blue", "OSCProg", 28)
	,	WaitFor.WinNotActive(SplitWin(Window), Step)
		Try Menu, Tray, Icon, %ResDllPath%, 46
		ChangeProgBarColor("20D000", "OSCProg", 28)
	return
	pb_WinWaitClose:
		Try Menu, Tray, Icon, %ResDllPath%, 77
		ChangeProgBarColor("Blue", "OSCProg", 28)
	,	WaitFor.WinClose(SplitWin(Window), Step)
		Try Menu, Tray, Icon, %ResDllPath%, 46
		ChangeProgBarColor("20D000", "OSCProg", 28)
	return
	pb_WinGet:
		Win := SplitWin(Window)
		WinGet, %Par1%, %Par2%, % Win[1], % Win[2], % Win[3], % Win[4]
		Try SavedVars(Par1)
	return
	pb_WinGetTitle:
		Win := SplitWin(Window)
		WinGetTitle, %Step%, % Win[1], % Win[2], % Win[3], % Win[4]
		Try SavedVars(Step)
	return
	pb_WinGetClass:
		Win := SplitWin(Window)
		WinGetClass, %Step%, % Win[1], % Win[2], % Win[3], % Win[4]
		Try SavedVars(Step)
	return
	pb_WinGetText:
		Win := SplitWin(Window)
		WinGetText, %Step%, % Win[1], % Win[2], % Win[3], % Win[4]
		Try SavedVars(Step)
	return
	pb_WinGetpos:
		Win := SplitWin(Window)
		WinGetPos, %Step%X, %Step%Y, %Step%W, %Step%H, % Win[1], % Win[2], % Win[3], % Win[4]
		CGPPars := "X|Y|W|H"
		Loop, Parse, CGPPars, |
		{
			CGP := Step . A_LoopField
			Try SavedVars(CGP)
		}
	return
	pb_GroupAdd:
		GroupAdd, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%
	return
	pb_GroupActivate:
		GroupActivate, %Par1%, %Par2%
	return
	pb_GroupDeactivate:
		GroupDeactivate, %Par1%, %Par2%
	return
	pb_GroupClose:
		GroupClose, %Par1%, %Par2%
	return

	;##### Playback COM Commands #####

	pb_IECOM_Set:
		StringSplit, Act, Action, :
		StringSplit, El, Target, :
		IeIntStr := IEComExp(Act2, Step, El1, El2, "", Act3, Act1)
	,	IeIntStr := SubStr(IeIntStr, 4)

		Try
			o_ie.readyState
		Catch
		{
			If (ComAc)
				o_ie := WBGet()
			Else
			{
				o_ie := ComObjCreate("InternetExplorer.Application")
			,	o_ie.Visible := true
			}
		}
		If (!IsObject(o_ie))
		{
			o_ie := ComObjCreate("InternetExplorer.Application")
		,	o_ie.Visible := true
		}
		
		Try
			COMInterface(IeIntStr, o_ie)
		Catch e
		{
			MsgBox, 20, %d_Lang007%, % d_Lang064 " Macro" Macro_On ", " d_Lang065 " " mListRow
				.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" (InStr(e.Message, "0x800401E3") ? d_Lang088 : e.Extra) "`n`n" d_Lang035
			IfMsgBox, No
			{
				StopIt := 1
				return
			}
		}
		
		If (Window = "LoadWait")
		{
			Try Menu, Tray, Icon, %ResDllPath%, 77
			ChangeProgBarColor("Blue", "OSCProg", 28)
			Try
				IELoad(o_ie)
			Try Menu, Tray, Icon, %ResDllPath%, 46
			ChangeProgBarColor("20D000", "OSCProg", 28)
		}
	return

	pb_IECOM_Get:
		If (RegExMatch(Step, "^(\w+)(\[\S+\]|\.\w+)+", lMatch))
		{
			Try
				z_Check := VarSetCapacity(%lMatch1%)
			Catch
			{
				MsgBox, 16, %d_Lang007%, %d_Lang041%
				return
			}
		}
		Else
		{
			Try
				z_Check := VarSetCapacity(%Step%)
			Catch
			{
				MsgBox, 16, %d_Lang007%, %d_Lang041%
				StopIt := 1
				return
			}
		}
		
		StringSplit, Act, Action, :
		StringSplit, El, Target, :
		IeIntStr := IEComExp(Act2, "", El1, El2, Step, Act3, Act1)
	,	IeIntStr := SubStr(IeIntStr, InStr(IeIntStr, "ie.") + 3)
		
		Try
			o_ie.readyState
		Catch
		{
			If (ComAc)
				o_ie := WBGet()
			Else
			{
				o_ie := ComObjCreate("InternetExplorer.Application")
			,	o_ie.Visible := true
			}
		}
		If (!IsObject(o_ie))
		{
			o_ie := ComObjCreate("InternetExplorer.Application")
		,	o_ie.Visible := true
		}
		
		Try
		{
			COMInterface(IeIntStr, o_ie, lResult)
		,	AssignVar(Step, ":=", lResult, __PointMarker)
		}
		Catch e
		{
			MsgBox, 20, %d_Lang007%, % d_Lang064 " Macro" Macro_On ", " d_Lang065 " " mListRow
				.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" (InStr(e.Message, "0x800401E3") ? d_Lang088 : e.Extra) "`n`n" d_Lang035
			IfMsgBox, No
			{
				StopIt := 1
				return
			}
		}
		Try SavedVars(Step)
		
		If (Window = "LoadWait")
		{
			Try Menu, Tray, Icon, %ResDllPath%, 77
			ChangeProgBarColor("Blue", "OSCProg", 28)
			Try
				IELoad(o_ie)
			Try Menu, Tray, Icon, %ResDllPath%, 46
			ChangeProgBarColor("20D000", "OSCProg", 28)
		}
	return

	pb_VBScript:
	pb_JScript:
	VB := "", JS := ""
	Step := StrReplace(Step, "`n", "``n")
	Step := "Language := " Type "`nExecuteStatement(" Step ")"

	pb_COMInterface:
		Step := StrReplace(Step, "ø", "`n")
		Loop, Parse, Step, `n, %A_Space%%A_Tab%`r
		{
			LoopField := StrReplace(A_LoopField, "``n", "`n")
			Try
			{
				Eval(LoopField, __PointMarker)
			; ,	lResult := StrJoin(EvalResult)
				; If (!IsObject(%Act1%))
					; %Act1% := COMInterface(LoopField, %Act1%, lResult, Target)
				; Else
					; COMInterface(LoopField, %Act1%, lResult, Target)
				; If (lResult != "")
					; AssignVar(Act2, ":=", lResult, __PointMarker)
			}
			Catch e
			{
				MsgBox, 20, %d_Lang007%, % d_Lang064 " Macro" Macro_On ", " d_Lang065 " " mListRow
					.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" (InStr(e.Message, "0x800401E3") ? d_Lang088 : e.Extra) "`n`n" d_Lang035
				IfMsgBox, No
				{
					StopIt := 1
					return
				}
			}
		}
		If (Window = "LoadWait")
		{
			Try Menu, Tray, Icon, %ResDllPath%, 77
			ChangeProgBarColor("Blue", "OSCProg", 28)
			Try
				IELoad(%Act1%)
			Try Menu, Tray, Icon, %ResDllPath%, 46
			ChangeProgBarColor("20D000", "OSCProg", 28)
		}
	return
}

SplitStep(CustomVars, ByRef Step, ByRef TimesX, ByRef DelayX, ByRef Type, ByRef Target, ByRef Window)
{
	local Pars := [], LoopField, _Step, _key, _value
	If (Type = cType34)
		Step := StrReplace(Step, "`n", "ø")
	If (Type = cType39)
		Step := RegExReplace(Step, "\w+", "%$0%", "", 1)
	EscCom(true, Step, TimesX, DelayX, Target, Window)
,	Step := StrReplace(Step, "%A_Space%", "ⱥ")
	If (InStr(FileCmdList, Type "|"))
	{
		If (RegExMatch(Step, "sU)%\s([\w%]+)\((.*)\)"))
			EscCom(true, Step)
		_Step := ""
		Loop, Parse, Step, `,, %A_Space%
		{
			LoopField := A_LoopField
		,	CheckVars(CustomVars, LoopField)
		,	LoopField := StrReplace(LoopField, ",", _x)
		,	_Step .= LoopField ", "
		}
		Step := RTrim(_Step, ", ")
	}
	CheckVars(CustomVars, Step, TimesX, DelayX, Target, Window)
,	Step := StrReplace(Step, "``,", _x)
,	Step := StrReplace(Step, "``n", "`n")
,	Step := StrReplace(Step, "``r", "`r")
,	Step := StrReplace(Step, "``t", "`t")
	Loop, Parse, Step, `,, %A_Space%
	{
		LoopField := A_LoopField
	,	CheckVars(CustomVars, LoopField)
		If ((InStr(Type, "String") = 1) || (Type = "SplitPath"))
		{
			For _key, _value in CustomVars
				If (LoopField = _key)
					LoopField := _value
		}
		Pars[A_Index] := LoopField
,		Pars[A_Index] := StrReplace(Pars[A_Index], "``n", "`n")
,		Pars[A_Index] := StrReplace(Pars[A_Index], "``r", "`r")
,		Pars[A_Index] := StrReplace(Pars[A_Index], _x, ",")
,		Pars[A_Index] := StrReplace(Pars[A_Index], "ⱥ", A_Space)
,		Pars[A_Index] := StrReplace(Pars[A_Index], "``")
	}
	Step := StrReplace(Step, _x, ",")
,	Step := StrReplace(Step, "ⱥ", A_Space)
,	Step := StrReplace(Step, "``")
	If (Type = cType34)
	{
		Step := StrReplace(Step, "`n", "``n")
	,	Step := StrReplace(Step, "ø", "`n")
	}
	return Pars
}

IfEval(_Name, _Operator, _Value)
{
	If (_Operator = "=")
		result := (%_Name% = _Value) ? true : false
	Else If (_Operator = "==")
		result := (%_Name% == _Value) ? true : false
	Else If (_Operator = "!=")
		result := (%_Name% != _Value) ? true : false
	Else If (_Operator = ">")
		result := (%_Name% > _Value) ? true : false
	Else If (_Operator = "<")
		result := (%_Name% < _Value) ? true : false
	Else If (_Operator = ">=")
		result := (%_Name% >= _Value) ? true : false
	Else If (_Operator = "<=")
		result := (%_Name% <= _Value) ? true : false
	return result
}

DoAction(X, Y, Action1, Action2, Coord, Error)
{
	CoordMode, Mouse, %Coord%
	If (Error = 0)
	{
		If (Action1 = "Move")
		{
			Click, %X%, %Y%, 0
			return ""
		}
		If (InStr(Action1, "Click"))
		{
			Loop, Parse, Action1, %A_Space%
				Act%A_Index% := A_LoopField
			Click, %X%, %Y% %Act1%, 1
			return ""
		}
		Else
			return Action1
	}
	If (Error = 1 || Error = 2)
		return Action2
}

RunExtFunc(File, FuncName, Params*)
{
	TempFile := A_Temp "\TempFile.ahk"
	For _key, _value in Params
		Pars .= """" _value """, "
	Pars := RTrim(Pars, " ,")
	SplitPath, File,, WorkDir
	
	TempScript =
	(LTrim
		#NoEnv
		SetWorkingDir %WorkDir%
		OutVar := %FuncName%(%Pars%)
		FileAppend, `%OutVar`%, `%A_ScriptFullPath`%, UTF-8
		ExitApp
		#SingleInstance, Force
		#NoTrayIcon
		#Include %File%
		
	)
	
	FileDelete, %TempFile%
	FileAppend, %TempScript%, %TempFile%, UTF-8
	RunWait, %TempFile%
	Loop, Read, %TempFile%
	{
		If (A_Index < 9)
			continue
		Result .= A_LoopReadLine "`n"
	}
	FileDelete, %TempFile%
	return SubStr(Result, 1, -1)
}

IfStatement(ThisError, CustomVars, Action, Step, TimesX, DelayX, Type, Target, Window)
{
	local Pars, VarName, Oper, VarValue, lMatch
	
	If (Step = "EndIf")
	{
		If (ThisError > 0)
			ThisError--
		Else
			ThisError := 0
		return ThisError
	}
	If ((BreakIt > 0) || (SkipIt > 0))
		return ThisError
	If (Step = "Else")
	{
		If (ThisError = 1)
			ThisError := 0
		Else If (ThisError = 0)
			ThisError := 1
		return ThisError
	}
	If (ThisError > 0)
	{
		ThisError++
		return ThisError
	}
	Else
	{
		Tooltip
		CheckVars(CustomVars, Step, Target, Window)
		EscCom(true, Step, TimesX, DelayX, Target, Window)
		Step := StrReplace(Step, _z, A_Space)
		Target := StrReplace(Target, _z, A_Space)
		Window := StrReplace(Window, _z, A_Space)
		If (ThisError > 0)
		{
			ThisError++
			return
		}
		Else If (Action = If1)
		{
			IfWinActive, %Step%
				ThisError := 0
			Else
				ThisError++
		}
		Else If (Action = If2)
		{
			IfWinNotActive, %Step%
				ThisError := 0
			Else
				ThisError++
		}
		Else If (Action = If3)
		{
			IfWinExist, %Step%
				ThisError := 0
			Else
				ThisError++
		}
		Else If (Action = If4)
		{
			IfWinNotExist, %Step%
				ThisError := 0
			Else
				ThisError++
		}
		Else If (Action = If5)
		{
			IfExist, %Step%
				ThisError := 0
			Else
				ThisError++
		}
		Else If (Action = If6)
		{
			IfNotExist, %Step%
				ThisError := 0
			Else
				ThisError++
		}
		Else If (Action = If7)
		{
			ClipContents := Clipboard
			If (ClipContents = Step)
				ThisError := 0
			Else
				ThisError++
		}
		Else If (Action = If8)
		{
			If (CustomVars["A_Index"] = Step)
				ThisError := 0
			Else
				ThisError++
		}
		Else If (Action = If9)
		{
			If (SearchResult = 0)
				ThisError := 0
			Else
				ThisError++
		}
		Else If (Action = If10)
		{
			If (SearchResult != 0)
				ThisError := 0
			Else
				ThisError++
		}
		Else If (Action = If11)
		{
			Pars := SplitStep(CustomVars, Step, TimesX, DelayX, Type, Target, Window)
			For _key, _value in CustomVars
				If (Pars[1] = _key)
					Pars[1] := _value
			If (InStr(Pars[1], Pars[2]))
				ThisError := 0
			Else
				ThisError++
		}
		Else If (Action = If12)
		{
			Pars := SplitStep(CustomVars, Step, TimesX, DelayX, Type, Target, Window)
			For _key, _value in CustomVars
				If (Pars[1] = _key)
					Pars[1] := _value
			If (!InStr, Pars[1], Pars[2])
				ThisError := 0
			Else
				ThisError++
		}
		Else If (Action = If13)
		{
			IfMsgBox, %Step%
				ThisError := 0
			Else
				ThisError++
		}
		Else If (Action = If14)
		{
			AssignParse(Step, VarName, Oper, VarValue)
		,	CheckVars(CustomVars, VarName, VarValue)
		,	EscCom(true, VarValue, VarName)
			For _key, _value in CustomVars
				If (VarName = _key)
					VarName := _value
			For _key, _value in CustomVars
				If (VarValue = _key)
					VarValue := _value
			If (IfEval(VarName, Oper, VarValue))
				ThisError := 0
			Else
				ThisError++
		}
		Else If (Action = If15)
		{
			EvalResult := Eval(Step, CustomVars)
			If (EvalResult[1])
				ThisError := 0
			Else
				ThisError++
		}
	}
	return ThisError
}

class WaitFor
{
	Key(Key, Delay := 0)
	{
		global StopIt, d_Lang039
		
		Loop
		{
			KeyWait, %Key%
			KeyWait, %Key%, % (Delay > 0) ? "D T" Delay : "D T0.5"
			Sleep, 10
		}
		Until ((ErrorLevel = 0)
		|| ((ErrorLevel = 1) && Delay > 0)
		|| (StopIt))
		If (StopIt = 1)
			return
		If (ErrorLevel)
		{
			MsgBox %d_Lang039%
			StopIt := 1
			return
		}
	}
	
	WinExist(Window, Seconds)
	{
		global StopIt
		
		Seconds *= 1000
		ini_Time := A_TickCount
		Loop
		{
			pass_time := A_TickCount - ini_Time
			Sleep, 10
		}
		Until (((WinExist(Window*)) || (StopIt))
			|| ((Seconds > 0) && (pass_Time > Seconds)))
	}
	
	WinActive(Window, Seconds)
	{
		global StopIt
		
		Seconds *= 1000
		ini_Time := A_TickCount
		Loop
		{
			pass_Time := A_TickCount - ini_Time
			Sleep, 10
		}
		Until (((WinActive(Window*)) || (StopIt))
			|| ((Seconds > 0) && (pass_Time > Seconds)))
	}
	
	WinNotActive(Window, Seconds)
	{
		global StopIt
		
		Seconds *= 1000
		ini_Time := A_TickCount
		Loop
		{
			pass_Time := A_TickCount - ini_Time
			Sleep, 10
		}
		Until (((!WinActive(Window*)) || (StopIt))
			|| ((Seconds > 0) && (pass_Time > Seconds)))
	}
	
	WinClose(Window, Seconds)
	{
		global StopIt
		
		Seconds *= 1000
		ini_Time := A_TickCount
		Loop
		{
			pass_Time := A_TickCount - ini_Time
			Sleep, 10
		}
		Until (((!WinExist(Window*)) || (StopIt))
			|| ((Seconds > 0) && (pass_Time > Seconds)))
	}
	
}

SplitWin(Window)
{
	Static _x := Chr(2), _y := Chr(3), _z := Chr(4)
	
	WinPars := []
	Window := StrReplace(Window, "``,", _x)
	Loop, Parse, Window, `,, %A_Space%
	{
		LoopField := StrReplace(A_LoopField, _x, ",")
		WinPars.Push(LoopField)
	}
	return WinPars
}

AssignVar(_Name, _Operator, _Value, CustomVars)
{
	local _content, _ObjItems
	
	If (_Name == "_null")
		return
	
	If (!IsObject(_Value))
	{
		_Value := StrReplace(_Value, _z, A_Space)
		If (_Name = "Clipboard")
			_Value := StrReplace(_Value, "````,", ",")
		If (InStr(_Value, "!") = 1)
			_Value := !SubStr(_Value, 2)
	}
	
	Try _content := %_Name%
	
	While (RegExMatch(_Name, "(\w+)(\[\S+\]|\.\w+)+", lFound))
	{
		If (RegExMatch(lFound1, "^-?\d+$"))
			break
		_content := ParseObjects(_Name, CustomVars, _ObjItems)
	,	_Name := lFound1
	}
	
	If (_Operator = ":=")
		_content := _Value
	Else If (_Operator = "+=")
		_content += _Value
	Else If (_Operator = "-=")
		_content -= _Value
	Else If (_Operator = "*=")
		_content *= _Value
	Else If (_Operator = "/=")
		_content /= _Value
	Else If (_Operator = "//=")
		_content //= _Value
	Else If (_Operator = ".=")
		_content .= _Value
	Else If (_Operator = "|=")
		_content |= _Value
	Else If (_Operator = "&=")
		_content &= _Value
	Else If (_Operator = "^=")
		_content ^= _Value
	Else If (_Operator = ">>=")
		_content >>= _Value
	Else If (_Operator = "<<=")
		_content <<= _Value

	Try
	{
		If (IsObject(_ObjItems))
		{
			%_Name%[_ObjItems*] := _content
		}
		Else
			%_Name% := _content
	}
	
	Try SavedVars(_Name)
}

CheckVars(CustomVars, ByRef CheckVar1 := "", ByRef CheckVar2 := "", ByRef CheckVar3 := "", ByRef CheckVar4 := "", ByRef CheckVar5 := "")
{
	Loop, 5
	{
		If (!IsByRef(CheckVar%A_Index%))
			continue
		_i := A_Index
		For _key, _value in CustomVars
		{
			While (RegExMatch(CheckVar%_i%, "i)%" _key "%", lMatch))
				CheckVar%_i% := RegExReplace(CheckVar%_i%, "U)" lMatch, _value)
		}
		CheckVar%_i% := DerefVars(CheckVar%_i%)
		
		If (RegExMatch(CheckVar%_i%, "sU)^%\s+(.+)$", lMatch))  ; Expressions
			EvalResult := Eval(lMatch1, CustomVars), CheckVar%_i% := EvalResult[1]
	}
}

DerefVars(v_String)
{
	global
	
	v_String := StrReplace(v_String, "%A_Space%", "%_z%")
	v_String := StrReplace(v_String, "``%", _y)
	While (RegExMatch(v_String, "%(\w+)%", rMatch))
	{
		FoundVar := StrReplace(%rMatch1%, "%", _y)
	,	FoundVar := StrReplace(FoundVar, ",", "``,")
	,	v_String := StrReplace(v_String, rMatch, FoundVar)
	}
	return StrReplace(v_String, _y, "%")
}

ExprGetPars(Expr)
{
	Expr := RegExReplace(Expr, "\[.*?\]", "[A]")
,	Expr := RegExReplace(Expr, "\(([^()]++|(?R))*\)", "[P]")
,	Expr := RegExReplace(Expr, """.*?""", "[T]")
,	ExprPars := StrSplit(Expr, ",", A_Space)
	return ExprPars
}
