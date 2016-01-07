Playback(Macro_On, Skip_Line := 0, Manual := "", UDFParams := "")
{
	local IfError := 0, PointMarker := 0, LoopCount := [0]
	, m_ListCount := ListCount%Macro_On%, mLoopIndex, _Label, _i
	, pbParams, pbVarName, pbVarValue, pbType, pbAction
	, ScopedParams := [], LastFuncRun, UserGlobals, GlobalList
	, Func_Result, SVRef, Return_Values

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
	PlayOSOn := 1, tbOSC.ModifyButtonInfo(1, "Image", 55), LastError := ""
,	CurrentRange := m_ListCount, ChangeProgBarColor("20D000", "OSCProg", 28)
	If (ShowProgBar = 1)
	{
		GuiControl, 28:+Range0-%m_ListCount%, OSCProg
		GuiControl, 28:, OSCProgTip, % "M" Macro_On " [Loop: 0 / " o_TimesG[Macro_On] " | Row: 0 / " m_ListCount "]"
	}
	Loop
	{
		mLoopIndex := A_Index, LoopIndex := A_Index
		Loop, % (Manual) ? 1 : ((o_TimesG[Macro_On] = 0) ? 1 : ((RunningFunction != "") ? 1 : o_TimesG[Macro_On]))
		{
			If (StopIt)
			{
				Try Menu, Tray, Icon, %DefaultIcon%, 1
				Menu, Tray, Default, %w_Lang005%
				break
			}
			BreakIt := 0, SkipIt := 0
			If (o_TimesG[Macro_On] > 0)
				mLoopIndex := A_Index, LoopIndex := A_Index
			Loop, %m_ListCount%
			{
				mMacroOn := Macro_On, mListRow := A_Index
				If (StopIt)
					break 2
				If (ShowProgBar = 1)
				{
					GuiControl, 28:, OSCProg, %A_Index%
					GuiControl, 28:, OSCProgTip, % "M" Macro_On " [Loop: " mLoopIndex "/" o_TimesG[Macro_On] " | Row: " A_Index "/" m_ListCount "]"
				}
				If (Skip_Line > 0)
				{
					Skip_Line--
					continue
				}
				Gui, chMacro:Default
				Gui, chMacro:ListView, InputList%Macro_On%
				If ((pb_From) && (A_Index < LV_GetNext(0)))
					continue
				Else If ((pb_To) && ((LV_GetNext(0) > 0) && (A_Index > LV_GetNext(0))))
					break
				LV_GetTexts(A_Index, Action, Step, TimesX, DelayX, Type, Target, Window)
				If ((Manual) && (ShowStep = 1))
				{
					NextStep := (A_Index = ListCount%A_List%) ? 1 : A_Index+1
				,	LV_GetText(NStep, NextStep, 3)
				,	LV_GetText(NTimesX, NextStep, 4)
				,	LV_GetText(NType, NextStep, 6)
				,	LV_GetText(NTarget, NextStep, 7)
				,	LV_GetText(NWindow, NextStep, 8)
					ToolTip, 
					(LTrim
					%d_Lang021%: %NextStep%
					%NType%, %NStep%   [x%NTimesX% @ %NWindow%|%NTarget%]

					%d_Lang022%: %A_Index%
					%Type%, %Step%   [x%TimesX% @ %Window%|%Target%]
					)
				}
				IsChecked := LV_GetNext(A_Index-1, "Checked")
				If (IsChecked != A_Index)
					continue
				If (pb_Sel)
				{
					IsSelected := LV_GetNext(A_Index-1)
					If (IsSelected != A_Index)
						continue
				}
				If (WinExist("ahk_id " PMCOSC))
					Gui, 28:+AlwaysOntop
				If (Type = cType48)
				{
					AssignReplace(Step)
					If (VarName = "")
						VarName := Step, VarValue := UDFParams[A_Index].Value
					Else
						VarValue := (UDFParams[A_Index].Value = "") ? VarValue : UDFParams[A_Index].Value
					VarValue := (VarValue = "true") ? 1
							: (VarValue = "false") ? 0
							: Trim(VarValue, """")
				,	ScopedParams[A_Index] := {ParamName: VarName
											, VarName: UDFParams[A_Index].Name
											, Value: %VarName%
											, NewValue: VarValue
											, Type: (Target = "ByRef") ? "ByRef" : "Param"}
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
								AssignReplace(A_LoopField)
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
									AssignReplace(A_LoopField)
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
							For each, Key in Section
								GlobalList .= Key.Key ","
						UserGlobals := ""
						
						SavedVars(, VarsList, true)
						For i, v in VarsList
						{
							If (v = "##_Locals:")
								break
							If v in %GlobalList%
								continue
							SVRef[v] := %v%, %v% := ""
						}
					}
					For i, v in Static_Vars[RunningFunction]
						SVRef[i] := %v%
					,	%i% := v
					
					For i, v in ScopedParams
						SVRef[v.ParamName] := v.Value
					,	VarName := v.ParamName
					,	%VarName% := v.NewValue
					continue
				}
				If (Type = cType49)
				{
					Try
						Func_Result := Eval(Step, PointMarker)
					Catch e
					{
						MsgBox, 16, %d_Lang007%, % "Function: " RunningFunction
							.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" (InStr(e.Message, "0x800401E3") ? d_Lang088 : e.Extra)
					}
					
					Return_Values := []
				,	Return_Values.Push(Func_Result)
				
					For i, v in ScopedParams
					{
						If (v.Type = "ByRef")
						{
							ParamName := v.ParamName
						,	v.NewValue := %ParamName%
						}
					}
					
					For i, v in SVRef
					{
						If (Static_Vars[RunningFunction].HasKey(i))
							Static_Vars[RunningFunction][i] := %i%
						%i% := v
					}
					
					For i, v in ScopedParams
					{
						If (v.Type = "ByRef")
						{
							VarName := v.VarName
						,	%VarName% := v.NewValue
						}
					}
					
					ScopedVars[RunningFunction].Pop()
					return Return_Values
				}
				If ((Type = cType3) || (Type = cType13))
					MouseReset := 1
				If (Type = cType17)
				{
					IfError := IfStatement(IfError, PointMarker)
					continue
				}
				If (IfError > 0)
					continue
				If ((Type = cType36) || (Type = cType37))
				{
					If ((BreakIt > 0) || (SkipIt > 0))
						continue
					CheckVars("Step", PointMarker)
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
					If (ShowProgBar = 1)
					{
						GuiControl, 28:+Range0-%m_ListCount%, OSCProg
						GuiControl, 28:, OSCProgTip, % "M" Macro_On " [Loop: 0 / " o_TimesG[Macro_On] " | Row: 0 / " m_ListCount "]"
					}
					Gui, chMacro:ListView, InputList%Macro_On%
					continue
				}
				If (Type = cType35)
					continue
				If ((Type = cType32) || (Type = cType33) || (Type = cType34))
				{
					While (RegExMatch(Step, "\w+\[[\w\d_\[\]]*\]", lFound))
					{
						lFound := RegExReplace(lFound, "\s")
					,	lResult := ExtractArrays(lFound, l_Point)
						If (lFound = "_ArrayObject")
							lFound := %lFound%
						lFound := RegExReplace(lFound, "[\[|\]]", "\$0")
					,	Step := RegExReplace(Step, lFound, lResult)
					}
				}
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
						PointMarker++
						Start%PointMarker% := A_Index
						CheckVars("TimesX", PointMarker)
						This_Point := PointMarker - 1
						pbType := Type, pbAction := Action
						GoSub, SplitStep
						Type := pbType, Action := pbAction
						LoopIndex := 1
						If (Type = cType38)
						{
							o_Loop%PointMarker% := []
							Loop, Read, %Par1%
							{
								If (StopIt)
								{
									o_Loop%PointMarker% := ""
									break 3
								}
								o_Loop%PointMarker%[A_Index, "LoopReadLine"] := A_LoopReadLine
							}
							LoopCount[PointMarker] := o_Loop%PointMarker%.Length()
						}
						Else If (Type = cType39)
						{
							o_Loop%PointMarker% := []
							Loop, Parse, Par1, %Par2%, %Par3%
							{
								If (StopIt)
								{
									o_Loop%PointMarker% := ""
									break 3
								}
								o_Loop%PointMarker%[A_Index, "LoopField"] := A_LoopField
							}
							LoopCount[PointMarker] := o_Loop%PointMarker%.Length()
						}
						Else If (Type = cType40)
						{
							o_Loop%PointMarker% := []
							Loop, Files, %Par1%, %Par2%
							{
								If (StopIt)
								{
									o_Loop%PointMarker% := ""
									break 3
								}
								o_Loop%PointMarker%[A_Index, "LoopFileName"] := A_LoopFileName
							,	o_Loop%PointMarker%[A_Index, "LoopFileExt"] := A_LoopFileExt
							,	o_Loop%PointMarker%[A_Index, "LoopFileFullPath"] := A_LoopFileFullPath
							,	o_Loop%PointMarker%[A_Index, "LoopFileLongPath"] := A_LoopFileLongPath
							,	o_Loop%PointMarker%[A_Index, "LoopFileShortPath"] := A_LoopFileShortPath
							,	o_Loop%PointMarker%[A_Index, "LoopFileShortName"] := A_LoopFileShortName
							,	o_Loop%PointMarker%[A_Index, "LoopFileDir"] := A_LoopFileDir
							,	o_Loop%PointMarker%[A_Index, "LoopFileTimeModified"] := A_LoopFileTimeModified
							,	o_Loop%PointMarker%[A_Index, "LoopFileTimeCreated"] := A_LoopFileTimeCreated
							,	o_Loop%PointMarker%[A_Index, "LoopFileTimeAccessed"] := A_LoopFileTimeAccessed
							,	o_Loop%PointMarker%[A_Index, "LoopFileAttrib"] := A_LoopFileAttrib
							,	o_Loop%PointMarker%[A_Index, "LoopFileSize"] := A_LoopFileSize
							,	o_Loop%PointMarker%[A_Index, "LoopFileSizeKB"] := A_LoopFileSizeKB
							,	o_Loop%PointMarker%[A_Index, "LoopFileSizeMB"] := A_LoopFileSizeMB
							}
							LoopCount[PointMarker] := o_Loop%PointMarker%.Length()
						}
						Else If (Type = cType41)
						{
							o_Loop%PointMarker% := []
							Loop, Reg, %Par1%, %Par2%
							{
								If (StopIt)
								{
									o_Loop%PointMarker% := ""
									break 3
								}
								o_Loop%PointMarker%[A_Index, "LoopRegName"] := A_LoopRegName
							,	o_Loop%PointMarker%[A_Index, "LoopRegType"] := A_LoopRegType
							,	o_Loop%PointMarker%[A_Index, "LoopRegKey"] := A_LoopRegKey
							,	o_Loop%PointMarker%[A_Index, "LoopRegSubKey"] := A_LoopRegSubKey
							,	o_Loop%PointMarker%[A_Index, "LoopRegTimeModified"] := A_LoopRegTimeModified
							}
							LoopCount[PointMarker] := o_Loop%PointMarker%.Length()
						}
						Else If (Type = cType45)
						{
							$_each%PointMarker% := Par2, $_value%PointMarker% := Par3
							o_Loop%PointMarker% := [], _l := ""
							For _each, _value in % %Par1%
							{
								o_Loop%PointMarker%[A_Index, Par2] := _each
							,	o_Loop%PointMarker%[A_Index, Par3] := _value
							,	_l := A_Index
							}
							LoopCount[PointMarker] := _l
						}
						Else
							LoopCount[PointMarker] := TimesX
						If (LoopCount[PointMarker] = "")
						{
							LoopIndex := mLoopIndex
							BreakIt++
						}
						continue
					}
					If (Action = "[LoopEnd]")
					{
						If (BreakIt > 0)
						{
							BreakIt--
							PointMarker--
							continue
						}
						If (SkipIt > 1)
						{
							SkipIt--
							continue
						}
						If (SkipIt > 0)
							SkipIt--
						End%PointMarker% := A_Index, aHK_Or := Macro_On
						GoToLab := LoopSection(Start%PointMarker%, End%PointMarker%, LoopCount[PointMarker], Macro_On
						, PointMarker, mLoopIndex, o_TimesG[Macro_On], LoopCount, ScopedParams)
						o_Loop%PointMarker% := ""
						, $_each := "", $_value := ""
						If (IsObject(GoToLab))
						{
							For i, v in ScopedParams
							{
								If (v.Type = "ByRef")
								{
									ParamName := v.ParamName
								,	v.NewValue := %ParamName%
								}
							}
							
							For i, v in SVRef
							{
								If (Static_Vars[RunningFunction].HasKey(i))
									Static_Vars[RunningFunction][i] := %i%
								%i% := v
							}
							
							For i, v in ScopedParams
							{
								If (v.Type = "ByRef")
								{
									VarName := v.VarName
								,	%VarName% := v.NewValue
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
						PointMarker--
						LoopIndex := mLoopIndex, Macro_On := aHK_Or, m_ListCount := ListCount%Macro_On%
						If (ShowProgBar = 1)
						{
							GuiControl, 28:+Range0-%m_ListCount%, OSCProg
							GuiControl, 28:, OSCProgTip, % "M" Macro_On " [Loop: 0 / " o_TimesG[Macro_On] " | Row: 0 / " m_ListCount "]"
						}
						continue
					}
				}
				If ((BreakIt > 0) || (SkipIt > 0))
					continue
				If ((Type = cType21) || (Type = cType44) || (Type = cType46))
				{
					Step := StrReplace(Step, "``n", "`n")
				,	Step := StrReplace(Step, "``t", "`t")
				,	AssignReplace(Step)
				,	CheckVars("Step|Target|Window|VarName|VarValue", PointMarker)
				,	pbVarName := VarName
				,	pbVarValue := VarValue
				,	pbParams := Object()
					Loop, Parse, pbVarValue, `,, %A_Space%
						pbParams.Push({Name: A_LoopField})
					tlResult := ExtractArrays(Target, PointMarker)
				,	Target := IsObject(tlResult) ? "tlResult" : tlResult
					If (Type = cType21)
					{
						If (Target = "Expression")
						{
							pbType := Type, pbAction := Action
						,	pbVarValue := Eval(pbVarValue, PointMarker)
						,	Type := pbType, Action := pbAction
						}
						Try
							AssignVar(pbVarName, Oper, pbVarValue, PointMarker)
						Catch e
						{
							MsgBox, 20, %d_Lang007%, % "Macro" mMacroOn ", " d_Lang065 " " mListRow
								.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" (InStr(e.Message, "0x800401E3") ? d_Lang088 : e.Extra) "`n`n" d_Lang035
							IfMsgBox, No
							{
								StopIt := 1
								continue
							}
						}
						Try SavedVars(pbVarName)
					}
					Else If (IsObject(%Target%))
					{
						pbParams := Object()
					,	pbType := Type, pbAction := Action
						Loop, Parse, pbVarValue, `,, %A_Space%
						{
							LoopField := DerefVars(A_LoopField)
						,	LoopField := StrReplace(LoopField, _z, A_Space)
						,	LoopField := Eval(LoopField, PointMarker)
						,	pbParams.Push(LoopField)
						}
						Type := pbType, Action := pbAction
						Try
						{
							pbVarValue := %Target%[Action](pbParams*)
						,	AssignVar(pbVarName, ":=", pbVarValue, PointMarker)
						}
						Catch e
						{
							MsgBox, 20, %d_Lang007%, % "Macro" mMacroOn ", " d_Lang065 " " mListRow
								.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" (InStr(e.Message, "0x800401E3") ? d_Lang088 : e.Extra) "`n`n" d_Lang035
							IfMsgBox, No
							{
								StopIt := 1
								continue
							}
						}
						Try SavedVars(pbVarName)
					}
					Else If (((Type = cType44) && (IsFunc(Action))) && ((Func(Action).IsBuiltIn) || (Action = "Screenshot")))
					{
						pbParams := Object()
					,	pbType := Type, pbAction := Action
						Loop, Parse, pbVarValue, `,, %A_Space%
						{
							LoopField := DerefVars(A_LoopField)
						,	LoopField := StrReplace(LoopField, _z, A_Space)
						,	LoopField := Eval(LoopField, PointMarker)
						,	pbParams.Push(LoopField)
						}
						Type := pbType, Action := pbAction
						Try
						{
							pbVarValue := %Action%(pbParams*)
						,	AssignVar(pbVarName, ":=", pbVarValue, PointMarker)
						}
						Catch e
						{
							MsgBox, 20, %d_Lang007%, % "Macro" mMacroOn ", " d_Lang065 " " mListRow
								.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" (InStr(e.Message, "0x800401E3") ? d_Lang088 : e.Extra) "`n`n" d_Lang035
							IfMsgBox, No
							{
								StopIt := 1
								continue
							}
						}
						Try SavedVars(pbVarName)
					}
					Else If ((Type = cType44) && (Target != ""))
					{
						pbParams := Object()
					,	pbType := Type, pbAction := Action
						Loop, Parse, pbVarValue, `,, %A_Space%
						{
							LoopField := DerefVars(A_LoopField)
						,	LoopField := StrReplace(LoopField, "`r`n", "``n")
						,	LoopField := StrReplace(LoopField, "`n", "``n")
						,	LoopField := StrReplace(LoopField, _z, A_Space)
						,	LoopField := Eval(LoopField, PointMarker)
						,	pbParams.Push(LoopField)
						}
						Type := pbType, Action := pbAction
						If (A_AhkPath)
						{
							Try
							{
								pbVarValue := RunExtFunc(Target, Action, pbParams*)
							,	AssignVar(pbVarName, ":=", pbVarValue, PointMarker)
							}
							
							Try SavedVars(pbVarName)
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
										pbType := Type, pbAction := Action
										Loop, Parse, pbVarValue, `,, %A_Space%
										{
											LoopField := DerefVars(A_LoopField)
										,	LoopField := StrReplace(LoopField, _z, A_Space)
										,	LoopField := Eval(LoopField, PointMarker)
											pbParams[A_Index].Value := LoopField
										}
										Type := pbType, Action := pbAction
									,	LastFuncRun := RunningFunction, RunningFunction := Action
									,	Func_Result := Playback(TabIdx,,, pbParams)
									,	pbVarValue := Func_Result[1]
									,	RunningFunction := LastFuncRun
										Try
											AssignVar(pbVarName, ":=", pbVarValue, PointMarker)
										Catch e
										{
											MsgBox, 20, %d_Lang007%, % "Macro" mMacroOn ", " d_Lang065 " " mListRow
												.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" (InStr(e.Message, "0x800401E3") ? d_Lang088 : e.Extra) "`n`n" d_Lang035
											IfMsgBox, No
											{
												StopIt := 1
												continue
											}
										}
										Try SavedVars(pbVarName)
										break 2
									}
								}
							}
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
						StringReplace, Step, Step, ``n, `n, All
					If (InStr(Step, "``t"))
						StringReplace, Step, Step, ``t, `t, All
					If (InStr(Step, "```,"))
						StringReplace, Step, Step, ```,, `,, All
				}
				If (Type = "Return")
					break 2
				If (Type = cType29)
				{
					If (Manual)
						break 2
					If (PointMarker = 0)
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
				This_Point := PointMarker
				pbType := Type, pbAction := Action
				GoSub, SplitStep
				Type := pbType, Action := pbAction
				While (TimesX)
				{
					If (StopIt)
					{
						Try Menu, Tray, Icon, %DefaultIcon%, 1
						Menu, Tray, Default, %w_Lang005%
						break 3
					}
					__PointMarker := PointMarker
					GoSub, pb_%Type%
					LastError := ErrorLevel
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
						GoSub, pb_Sleep
				}
				If (Manual)
					WaitFor.Key(o_ManKey[Manual], 0)
			}
		}
		If (Manual || StopIt || BreakIt || !Macro_On || (o_TimesG[Macro_On] > 0))
			break
	}
	If (RunningFunction != "")
	{
		Return_Values := []
	,	Return_Values.Push("")
	
		For i, v in ScopedParams
		{
			If (v.Type = "ByRef")
			{
				ParamName := v.ParamName
			,	v.NewValue := %ParamName%
			}
		}
		
		For i, v in SVRef
		{
			If (Static_Vars[RunningFunction].HasKey(i))
				Static_Vars[RunningFunction][i] := %i%
			%i% := v
		}
		
		For i, v in ScopedParams
		{
			If (v.Type = "ByRef")
			{
				VarName := v.VarName
			,	%VarName% := v.NewValue
			}
		}

		ScopedVars[RunningFunction].Pop()
		
		return Return_Values
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

LoopSection(Start, End, lcX, lcL, PointO, mainL, mainC, ByRef LoopCount, ScopedParams)
{
	local lCount, lIdx, L_Index, mLoopIndex, _Label, IfError := 0, _l
	, pbParams, pbVarName, pbVarValue, pbType, pbAction
	, Func_Result, Return_Values, LastFuncRun

	f_Loop:
	CoordMode, Mouse, %CoordMouse%
	lCount := End - Start - 1, PointMarker := PointO, x_Loop := (lcX = 0) ? 1 : lcX - 1
	Loop
	{
		mLoopIndex := A_Index + 1, LoopIndex := A_Index + 1
		Loop, %x_Loop%
		{
			mListRow := A_Index + 1
			If (StopIt)
				break
			If (SkipIt > 0)
				SkipIt--
			If (lcX > 0)
				mLoopIndex := A_Index + 1, LoopIndex := A_Index + 1
			Loop, %lCount%
			{
				If (StopIt)
					break
				If (ShowProgBar = 1)
				{
					GuiControl, 28:, OSCProg, %A_Index%
					GuiControl, 28:, OSCProgTip, % "M" lcL " [Loop: " mainL "/" mainC " | Row: " A_Index "/" lCount " (In: " mLoopIndex "/" lcX ")]"
				}
				If (Skip_Line > 0)
				{
					Skip_Line--
					continue
				}
				Gui, chMacro:ListView, InputList%lcL%
				lIdx := Start + A_Index
			,	LV_GetTexts(lIdx, Action, Step, TimesX, DelayX, Type, Target, Window)
			,	IsChecked := LV_GetNext(lIdx-1, "Checked")
				If (IsChecked != lIdx)
					continue
				If (pb_Sel)
				{
					IsSelected := LV_GetNext(lIdx-1)
					If (IsSelected != lIdx)
						continue
				}
				If (WinExist("ahk_id " PMCOSC))
					Gui, 28:+AlwaysOntop
				If (Type = cType48)
					continue
				If (Type = cType47)
					continue
				If (Type = cType49)
				{
					Try
						Func_Result := Eval(Step, PointMarker)
					Catch e
					{
						MsgBox, 16, %d_Lang007%, % "Function: " RunningFunction
							.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" (InStr(e.Message, "0x800401E3") ? d_Lang088 : e.Extra)
					}
					
					Return_Values := []
				,	Return_Values.Push(Func_Result)
					return Return_Values
				}
				If (Type = cType17)
				{
					IfError := IfStatement(IfError, PointMarker)
					continue
				}
				If (IfError > 0)
					continue
				If ((Type = cType36) || (Type = cType37))
				{
					If ((BreakIt > 0) || (SkipIt > 0))
						continue
					CheckVars("Step", PointMarker)
					Loop, %TabCount%
					{
						If (Step = TabGetText(TabSel, A_Index))
						{
							If (Type = cType37)
							{
								L_Index := LoopIndex
								If (_Label := Playback(A_Index))
									return _Label
								LoopIndex := L_Index
								Gui, chMacro:ListView, InputList%lcL%
								break
							}
							Else
								return A_Index
						}
						Else
						{
							TabIdx := A_Index
							Gui, chMacro:ListView, InputList%TabIdx%
							Loop, % ListCount%A_Index%
							{
								LV_GetText(Row_Type, A_Index, 6)
								If ((Row_Type = cType36) || (Row_Type = cType37))
									continue
								LV_GetText(TargetLabel, A_Index, 3)
								If ((Row_Type = cType35) && (TargetLabel = Step))
								{
									If (Type = cType37)
									{
										If (_Label := Playback(TabIdx, A_Index))
											return _Label
										break
									}
									Else
									{
										_Label := [TabIdx, A_Index, 0]
										return _Label
									}
								}
							}
						}
					}
					Gui, chMacro:ListView, InputList%Macro_On%
					continue
				}
				If (Type = cType35)
					continue
				If ((Type = cType32) || (Type = cType33) || (Type = cType34))
				{
					While (RegExMatch(Step, "\w+\[[\w\d_\[\]]*\]", lFound))
					{
						lFound := RegExReplace(lFound, "\s")
					,	lResult := ExtractArrays(lFound, l_Point)
						If (lFound = "_ArrayObject")
							lFound := %lFound%
						lFound := RegExReplace(lFound, "[\[|\]]", "\$0")
					,	Step := RegExReplace(Step, lFound, lResult)
					}
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
						PointMarker++
						Start%PointMarker% := Start + A_Index
						CheckVars("TimesX", PointMarker)
						This_Point := PointMarker - 1
						pbType := Type, pbAction := Action
						GoSub, SplitStep
						Type := pbType, Action := pbAction
						LoopIndex := 1
						If (Type = cType38)
						{
							o_Loop%PointMarker% := []
							Loop, Read, %Par1%, %Par2%, %Par3%, %Par4%
							{
								If (StopIt)
								{
									o_Loop%PointMarker% := ""
									break 2
								}
								o_Loop%PointMarker%[A_Index, "LoopReadLine"] := A_LoopReadLine
							}
							LoopCount[PointMarker] := o_Loop%PointMarker%.Length()
						}
						Else If (Type = cType39)
						{
							o_Loop%PointMarker% := []
							Loop, Parse, Par1, %Par2%, %Par3%, %Par4%
							{
								If (StopIt)
								{
									o_Loop%PointMarker% := ""
									break 2
								}
								o_Loop%PointMarker%[A_Index, "LoopField"] := A_LoopField
							}
							LoopCount[PointMarker] := o_Loop%PointMarker%.Length()
						}
						Else If (Type = cType40)
						{
							o_Loop%PointMarker% := []
							Loop, Files, %Par1%, %Par2%
							{
								If (StopIt)
								{
									o_Loop%PointMarker% := ""
									break 2
								}
								o_Loop%PointMarker%[A_Index, "LoopFileName"] := A_LoopFileName
							,	o_Loop%PointMarker%[A_Index, "LoopFileExt"] := A_LoopFileExt
							,	o_Loop%PointMarker%[A_Index, "LoopFileFullPath"] := A_LoopFileFullPath
							,	o_Loop%PointMarker%[A_Index, "LoopFileLongPath"] := A_LoopFileLongPath
							,	o_Loop%PointMarker%[A_Index, "LoopFileShortPath"] := A_LoopFileShortPath
							,	o_Loop%PointMarker%[A_Index, "LoopFileShortName"] := A_LoopFileShortName
							,	o_Loop%PointMarker%[A_Index, "LoopFileDir"] := A_LoopFileDir
							,	o_Loop%PointMarker%[A_Index, "LoopFileTimeModified"] := A_LoopFileTimeModified
							,	o_Loop%PointMarker%[A_Index, "LoopFileTimeCreated"] := A_LoopFileTimeCreated
							,	o_Loop%PointMarker%[A_Index, "LoopFileTimeAccessed"] := A_LoopFileTimeAccessed
							,	o_Loop%PointMarker%[A_Index, "LoopFileAttrib"] := A_LoopFileAttrib
							,	o_Loop%PointMarker%[A_Index, "LoopFileSize"] := A_LoopFileSize
							,	o_Loop%PointMarker%[A_Index, "LoopFileSizeKB"] := A_LoopFileSizeKB
							,	o_Loop%PointMarker%[A_Index, "LoopFileSizeMB"] := A_LoopFileSizeMB
							}
							LoopCount[PointMarker] := o_Loop%PointMarker%.Length()
						}
						Else If (Type = cType41)
						{
							o_Loop%PointMarker% := []
							Loop, Reg, %Par1%, %Par2%
							{
								If (StopIt)
								{
									o_Loop%PointMarker% := ""
									break 2
								}
								o_Loop%PointMarker%[A_Index, "LoopRegName"] := A_LoopRegName
							,	o_Loop%PointMarker%[A_Index, "LoopRegType"] := A_LoopRegType
							,	o_Loop%PointMarker%[A_Index, "LoopRegKey"] := A_LoopRegKey
							,	o_Loop%PointMarker%[A_Index, "LoopRegSubKey"] := A_LoopRegSubKey
							,	o_Loop%PointMarker%[A_Index, "LoopRegTimeModified"] := A_LoopRegTimeModified
							}
							LoopCount[PointMarker] := o_Loop%PointMarker%.Length()
						}
						Else If (Type = cType45)
						{
							$_each%PointMarker% := Par2, $_value%PointMarker% := Par3
							o_Loop%PointMarker% := [], _l := ""
							For _each, _value in % %Par1%
							{
								o_Loop%PointMarker%[A_Index, Par2] := _each
							,	o_Loop%PointMarker%[A_Index, Par3] := _value
							,	_l := A_Index
							}
							LoopCount[PointMarker] := _l
						}
						Else
							LoopCount[PointMarker] := TimesX
						If (LoopCount[PointMarker] = "")
						{
							LoopIndex := mLoopIndex
							BreakIt++
						}
						continue
					}
					If (Action = "[LoopEnd]")
					{
						If (BreakIt > 0)
						{
							BreakIt--
							PointMarker--
							continue
						}
						If (SkipIt > 1)
						{
							SkipIt--
							continue
						}
						If (SkipIt > 0)
							SkipIt--
						End%PointMarker% := Start + A_Index
					,	GoToLab := LoopSection(Start%PointMarker%, End%PointMarker%, LoopCount[PointMarker], lcL
						, PointMarker, mainL, mainC, LoopCount, ScopedParams)
					,	o_Loop%PointMarker% := ""
						If (GoToLab = "_return")
							return GoToLab
						Else If (IsObject(GoToLab))
							return GoToLab
						Else If (GoToLab)
							return GoToLab
						PointMarker--
						LoopIndex := mLoopIndex
						continue
					}
				}
				If ((BreakIt > 0) || (SkipIt > 0))
					continue
				If ((Type = cType21) || (Type = cType44) || (Type = cType46))
				{
					Step := StrReplace(Step, "``n", "`n")
				,	Step := StrReplace(Step, "``t", "`t")
				,	AssignReplace(Step)
				,	CheckVars("Step|Target|Window|VarName|VarValue", PointMarker)
				,	pbVarName := VarName
				,	pbVarValue := VarValue
				,	pbParams := Object()
					Loop, Parse, pbVarValue, `,, %A_Space%""
						pbParams.Push({Name: A_LoopField})
					tlResult := ExtractArrays(Target, PointMarker)
				,	Target := IsObject(tlResult) ? "tlResult" : tlResult
					If (Type = cType21)
					{
						If (Target = "Expression")
						{
							pbType := Type, pbAction := Action
						,	pbVarValue := Eval(pbVarValue, PointMarker)
						,	Type := pbType, Action := pbAction
						}
						Try
							AssignVar(pbVarName, Oper, pbVarValue, PointMarker)
						Catch e
						{
							MsgBox, 20, %d_Lang007%, % "Macro" mMacroOn ", " d_Lang065 " " mListRow
								.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" (InStr(e.Message, "0x800401E3") ? d_Lang088 : e.Extra) "`n`n" d_Lang035
							IfMsgBox, No
							{
								StopIt := 1
								continue
							}
						}
						Try SavedVars(pbVarName)
					}
					Else If (IsObject(%Target%))
					{
						pbParams := Object()
					,	pbType := Type, pbAction := Action
						Loop, Parse, pbVarValue, `,, %A_Space%
						{
							LoopField := DerefVars(A_LoopField)
						,	LoopField := StrReplace(LoopField, _z, A_Space)
						,	LoopField := Eval(LoopField, PointMarker)
						,	pbParams.Push(LoopField)
						}
						Type := pbType, Action := pbAction
						Try
						{
							pbVarValue := %Target%[Action](pbParams*)
						,	AssignVar(pbVarName, ":=", pbVarValue, PointMarker)
						}
						Catch e
						{
							MsgBox, 20, %d_Lang007%, % "Macro" mMacroOn ", " d_Lang065 " " mListRow
								.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" (InStr(e.Message, "0x800401E3") ? d_Lang088 : e.Extra) "`n`n" d_Lang035
							IfMsgBox, No
							{
								StopIt := 1
								continue
							}
						}
						Try SavedVars(pbVarName)
					}
					Else If (((Type = cType44) && (IsFunc(Action))) && ((Func(Action).IsBuiltIn) || (Action = "Screenshot")))
					{
						pbParams := Object()
					,	pbType := Type, pbAction := Action
						Loop, Parse, pbVarValue, `,, %A_Space%
						{
							LoopField := DerefVars(A_LoopField)
						,	LoopField := StrReplace(LoopField, _z, A_Space)
						,	LoopField := Eval(LoopField, PointMarker)
						,	pbParams.Push(LoopField)
						}
						Type := pbType, Action := pbAction
						Try
						{
							pbVarValue := %Action%(pbParams*)
						,	AssignVar(pbVarName, ":=", pbVarValue, PointMarker)
						}
						Catch e
						{
							MsgBox, 20, %d_Lang007%, % "Macro" mMacroOn ", " d_Lang065 " " mListRow
								.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" (InStr(e.Message, "0x800401E3") ? d_Lang088 : e.Extra) "`n`n" d_Lang035
							IfMsgBox, No
							{
								StopIt := 1
								continue
							}
						}
						Try SavedVars(pbVarName)
					}
					Else If ((Type = cType44) && (Target != ""))
					{
						pbParams := Object()
					,	pbType := Type, pbAction := Action
						Loop, Parse, pbVarValue, `,, %A_Space%
						{
							LoopField := DerefVars(A_LoopField)
						,	LoopField := StrReplace(LoopField, "`r`n", "``n")
						,	LoopField := StrReplace(LoopField, "`n", "``n")
						,	LoopField := StrReplace(LoopField, _z, A_Space)
						,	LoopField := Eval(LoopField, PointMarker)
						,	pbParams.Push(LoopField)
						}
						Type := pbType, Action := pbAction
						If (A_AhkPath)
						{
							Try
							{
								pbVarValue := RunExtFunc(Target, Action, pbParams*)
							,	AssignVar(pbVarName, ":=", pbVarValue, PointMarker)
							}
							
							Try SavedVars(pbVarName)
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
										pbType := Type, pbAction := Action
										Loop, Parse, pbVarValue, `,, %A_Space%
										{
											LoopField := DerefVars(A_LoopField)
										,	LoopField := StrReplace(LoopField, _z, A_Space)
										,	LoopField := Eval(LoopField, PointMarker)
											pbParams[A_Index].Value := LoopField
										}
										Type := pbType, Action := pbAction
									,	LastFuncRun := RunningFunction, RunningFunction := Action
									,	Func_Result := Playback(TabIdx,,, pbParams)
									,	pbVarValue := Func_Result[1]
									,	RunningFunction := LastFuncRun
										Try
											AssignVar(pbVarName, ":=", pbVarValue, PointMarker)
										Catch e
										{
											MsgBox, 20, %d_Lang007%, % "Macro" mMacroOn ", " d_Lang065 " " mListRow
												.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" (InStr(e.Message, "0x800401E3") ? d_Lang088 : e.Extra) "`n`n" d_Lang035
											IfMsgBox, No
											{
												StopIt := 1
												continue
											}
										}
										Try SavedVars(pbVarName)
										break 2
									}
								}
							}
						}
					}
					continue
				}
				If ((Type = cType15) || (Type = cType16))
				{
					Loop, Parse, Action, `,,%A_Space%
						Act%A_Index% := A_LoopField
				}
				If (InStr(Step, "``n"))
					StringReplace, Step, Step, ``n, `n, All
				If (InStr(Step, "``t"))
					StringReplace, Step, Step, ``t, `t, All
				If (InStr(Step, "```,"))
					StringReplace, Step, Step, ```,, `,, All
				If (Type = "Return")
					return "_return"
				If (Type = cType29)
				{
					If (PointMarker = 0)
						break 2
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
				This_Point := PointMarker
				pbType := Type, pbAction := Action
				GoSub, SplitStep
				Type := pbType, Action := pbAction
				While (TimesX)
				{
					If (StopIt)
						break 3
					__PointMarker := PointMarker
					GoSub, pb_%Type%
					LastError := ErrorLevel, TimesX--
					If Type in Sleep,KeyWait
						continue
					If ((Type = cType15) || (Type = cType16))
					{
						If ((TakeAction = "Break") || ((Target = "Break") && (SearchResult = 0)))
						{
							TakeAction := 0
							break
						}
						Else If ((Target = "Continue") && (SearchResult = 0))
							TimesX := 1
					}
					GoSub, pb_Sleep
				}
			}
			If (StopIt || BreakIt)
				break
		}
		If (StopIt || BreakIt || (lcX > 0))
			break
	}
	If (BreakIt > 0)
		BreakIt--
	If (SkipIt > 0)
		SkipIt--
	return 0
}

IfEval(Name, Operator, Value)
{
	If (Operator = "=")
		result := (%Name% = Value) ? true : false
	Else If (Operator = "==")
		result := (%Name% == Value) ? true : false
	Else If (Operator = "!=")
		result := (%Name% != Value) ? true : false
	Else If (Operator = ">")
		result := (%Name% > Value) ? true : false
	Else If (Operator = "<")
		result := (%Name% < Value) ? true : false
	Else If (Operator = ">=")
		result := (%Name% >= Value) ? true : false
	Else If (Operator = "<=")
		result := (%Name% <= Value) ? true : false
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
	For k, v in Params
		Pars .= """" v """, "
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

IfStatement(ThisError, l_Point)
{
	local pbType, pbAction
	
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
		CheckVars("Step|Target|Window", PointMarker)
		EscCom("Step|TimesX|DelayX|Target|Window", 1)
		StringReplace, Step, Step, %_z%, %A_Space%, All
		StringReplace, Target, Target, %_z%, %A_Space%, All
		StringReplace, Window, Window, %_z%, %A_Space%, All
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
			If (LoopIndex = Step)
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
			This_Point := l_Point
			pbType := Type, pbAction := Action
			GoSub, SplitStep
			Type := pbType, Action := pbAction
			If (RegExMatch(Par1, "i)A_Loop\w+"))
			{
				I := DerefVars(LoopIndex), L := SubStr(Par1, 3)
			,	This_Par := o_Loop%l_Point%[I][L]
			,	Par1 := "This_Par"
			}
			IfInString, %Par1%, %Par2%
				ThisError := 0
			Else
				ThisError++
		}
		Else If (Action = If12)
		{
			This_Point := l_Point
			pbType := Type, pbAction := Action
			GoSub, SplitStep
			Type := pbType, Action := pbAction
			If (RegExMatch(Par1, "i)A_Loop\w+"))
			{
				I := DerefVars(LoopIndex), L := SubStr(Par1, 3)
			,	This_Par := o_Loop%l_Point%[I][L]
			,	Par1 := "This_Par"
			}
			IfNotInString, %Par1%, %Par2%
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
			AssignReplace(Step)
			CheckVars("VarName|VarValue", PointMarker)
			EscCom("VarValue|VarName", 1)
			This_Point := l_Point
			If (RegExMatch(VarName, "i)A_Loop\w+"))
			{
				I := DerefVars(LoopIndex), L := SubStr(VarName, 3)
			,	This_Par := o_Loop%l_Point%[I][L]
			,	VarName := "This_Par"
			}
			If (RegExMatch(VarValue, "i)A_Loop\w+"))
			{
				I := DerefVars(LoopIndex), L := SubStr(VarValue, 3)
			,	This_Par := o_Loop%l_Point%[I][L]
			,	VarValue := "This_Par"
			}
			If (VarName = "A_Index")
				VarName := "LoopIndex"
			If (IfEval(VarName, Oper, VarValue))
				ThisError := 0
			Else
				ThisError++
		}
		Else If (Action = If15)
		{
			If Eval(Step, PointMarker)
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
	StringReplace, Window, Window, ```,, %_x%, All
	Loop, Parse, Window, `,, %A_Space%
	{
		StringReplace, LoopField, A_LoopField, %_x%, `,, All
		WinPars.Push(LoopField)
	}
	return WinPars
}

AssignVar(Name, Operator, Value, l_Point)
{
	local _content, _ObjItems
	
	StringReplace, Value, Value, %_z%, %A_Space%, All
	If (Name = "Clipboard")
		StringReplace, Value, Value, `````,, `,, All
	If (InStr(Value, "!") = 1)
		Value := !SubStr(Value, 2)
	
	Try _content := %Name%
	
	While (RegExMatch(Name, "([\w%]+)\[.+\]", lFound))
	{
		_content := ExtractArrays(Name, l_Point, _ObjItems)
	,	Name := lFound1
	}
	
	If (_content = "_ArrayObject")
		_content := %_content%
	If (Operator = ":=")
		_content := Value
	Else If (Operator = "+=")
		_content += Value
	Else If (Operator = "-=")
		_content -= Value
	Else If (Operator = "*=")
		_content *= Value
	Else If (Operator = "/=")
		_content /= Value
	Else If (Operator = "//=")
		_content //= Value
	Else If (Operator = ".=")
		_content .= Value

	Try
	{
		If (IsObject(_ObjItems))
			%Name%[_ObjItems*] := _content
		Else
			%Name% := _content
	}
	
	Try SavedVars(Name)
}

CheckVars(Match_List, l_Point := "")
{
	global
	Loop, Parse, Match_List, |
	{
		If (InStr(%A_LoopField%, "%A_Index%"))
			StringReplace, %A_LoopField%, %A_LoopField%, `%A_Index`%, `%LoopIndex`%, All
		If (InStr(%A_LoopField%, "%ErrorLevel%"))
			StringReplace, %A_LoopField%, %A_LoopField%, `%ErrorLevel`%, `%LastError`%, All
		I := DerefVars(LoopIndex)
		While (RegExMatch(%A_LoopField%, "i)%(A_Loop\w+)%", lMatch))
		{
			L := SubStr(lMatch1, 3)
		,	%A_LoopField% := RegExReplace(%A_LoopField%, "U)" lMatch, o_Loop%l_Point%[I][L])
		}
		If ($_value%l_Point% != "")
		{
			_thisEach := $_each%l_Point%, %_thisEach% := o_Loop%l_Point%[I][$_each%l_Point%]
		,	_thisValue := $_value%l_Point%, %_thisValue% := o_Loop%l_Point%[I][$_value%l_Point%]
			While (RegExMatch(%A_LoopField%, "i)%" $_each%l_Point% "%", lMatch))
				%A_LoopField% := RegExReplace(%A_LoopField%, "U)" lMatch, o_Loop%l_Point%[I][$_each%l_Point%])
			While (RegExMatch(%A_LoopField%, "i)%(" $_value%l_Point% ")%", lMatch))
				%A_LoopField% := RegExReplace(%A_LoopField%, "U)" lMatch, o_Loop%l_Point%[I][$_value%l_Point%])
		}
		%A_LoopField% := DerefVars(%A_LoopField%)
		
		If (RegExMatch(%A_LoopField%, "sU)^%\s+(.+)$", lMatch))  ; Expressions
			%A_LoopField% := Eval(lMatch1, l_Point)
	}
}

ExtractArrays(v_String, l_Point, ByRef v_levels := "")
{
	global

	v_levels := []
	While (RegExMatch(v_String, "([\w\d_%]+)\[(\S+?)\]", l_Found))
	{
		l_Found := RegExReplace(l_Found, "[\[|\]]", "\$0")
		If l_Found2 is not Number
		{
			If (InStr(l_Found2, "A_")=1)
			{
				If (l_Found2 = "A_Index")
					l_Found2 := LoopIndex
				While (RegExMatch(l_Found2, "i)(A_Loop\w+)", lMatch))
				{
					I := DerefVars(LoopIndex), L := SubStr(lMatch1, 3)
				,	l_Found2 := RegExReplace(l_Found2, "U)" lMatch, o_Loop%l_Point%[I][L])
				}
			}
			Else If (RegExMatch(l_Found2, "^""(.*)""", lMatch))
				l_Found2 := lMatch1
			Else
				l_Found2 := DerefVars("%" l_Found2 "%")
		}
		v_levels.Push(l_Found2)
	,	_ArrayObject := %l_Found1%[l_Found2]
		If (IsObject(_ArrayObject))
			v_String := RegExReplace(v_String, l_Found, "_ArrayObject")
		Else
			v_String := RegExReplace(v_String, l_Found, _ArrayObject)
	}
	
	return v_String
}

DerefVars(v_String)
{
	global
	
	StringReplace, v_String, v_String, `%A_Space`%, %_z%, All
	StringReplace, v_String, v_String, ```%, %_y%, All
	While (RegExMatch(v_String, "%(\w+)%", rMatch))
	{
		FoundVar := RegExReplace(%rMatch1%, "%", _y)
	,	FoundVar := RegExReplace(FoundVar, "\$", "$$$$")
	,	FoundVar := RegExReplace(FoundVar, ",", "``,")
	,	v_String := RegExReplace(v_String, rMatch, FoundVar)
	}
	return RegExReplace(v_String, _y, "%")
}

