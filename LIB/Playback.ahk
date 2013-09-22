Playback(Macro_On, Skip_Line=0, Manual="")
{
	local IfError := 0, PointMarker := 0, LoopCount := 0
	, m_ListCount := ListCount%Macro_On%, mLoopIndex, _Label

	CoordMode, Mouse, Screen
	MouseGetPos, CursorX, CursorY
	CoordMode, Mouse, %CoordMouse%
	If Record = 1
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
		If !WinExist("ahk_id " PMCOSC)
			GoSub, ShowControls
		Else
			Gui, 28:+AlwaysOntop
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
		Loop, % (Manual) ? 1 : ((o_TimesG[Macro_On] = 0) ? 1 : o_TimesG[Macro_On])
		{
			If StopIt
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
				If StopIt
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
				If (IsChecked <> A_Index)
					continue
				If (pb_Sel)
				{
					IsSelected := LV_GetNext(A_Index-1)
					If (IsSelected <> A_Index)
						continue
				}
				If ((Type = cType3) OR (Type = cType13))
					MouseReset := 1
				If (Type = cType17)
				{
					IfError := IfStatement(IfError, PointMarker)
					continue
				}
				If IfError > 0
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
								_Label := (Playback(A_Index, 0, Manual))
								If IsObject(_Label)
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
										If IsObject(_Label)
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
				If (Manual)
				{
					If Type in %cType5%,%cType7%,%cType38%,%cType39%,%cType40%,%cType41%
						continue
				}
				If ((Type = cType7) || (Type = cType38) || (Type = cType39)
				|| (Type = cType40) || (Type = cType41))
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
						GoSub, SplitStep
						LoopIndex := 1
						If (Type = cType38)
						{
							o_Loop%PointMarker% := []
							Loop, Read, %Par1%
							{
								If StopIt
								{
									o_Loop%PointMarker% := ""
									break 3
								}
								o_Loop%PointMarker%[A_Index, "LoopReadLine"] := A_LoopReadLine
							}
							LoopCount%PointMarker% := o_Loop%PointMarker%.MaxIndex()
						}
						Else If (Type = cType39)
						{
							o_Loop%PointMarker% := []
							Loop, Parse, Par1, %Par2%, %Par3%
							{
								If StopIt
								{
									o_Loop%PointMarker% := ""
									break 3
								}
								o_Loop%PointMarker%[A_Index, "LoopField"] := A_LoopField
							}
							LoopCount%PointMarker% := o_Loop%PointMarker%.MaxIndex()
						}
						Else If (Type = cType40)
						{
							o_Loop%PointMarker% := []
							Loop, %Par1%, %Par2%, %Par3%
							{
								If StopIt
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
							LoopCount%PointMarker% := o_Loop%PointMarker%.MaxIndex()
						}
						Else If (Type = cType41)
						{
							o_Loop%PointMarker% := []
							Loop, %Par1%, %Par2%, %Par3%, %Par4%
							{
								If StopIt
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
							LoopCount%PointMarker% := o_Loop%PointMarker%.MaxIndex()
						}
						Else
							LoopCount%PointMarker% := TimesX
						If (LoopCount%PointMarker% = "")
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
						If SkipIt > 1
						{
							SkipIt--
							continue
						}
						If (SkipIt > 0)
							SkipIt--
						End%PointMarker% := A_Index, aHK_Or := Macro_On
						GoToLab := LoopSection(Start%PointMarker%, End%PointMarker%, LoopCount%PointMarker%, Macro_On
						, PointMarker, mLoopIndex, o_TimesG[Macro_On])
						o_Loop%PointMarker% := ""
						If IsObject(GoToLab)
							return GoToLab
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
				If ((Type = cType21) || (Type = cType44))
				{
					StringReplace, Step, Step, ``n, `n, All
					StringReplace, Step, Step, ``t, `t, All
					AssignReplace(Step)
					CheckVars("Step|Target|Window|VarName|VarValue", PointMarker)
					If (Type = cType21)
					{
						If RegExMatch(VarValue, "U)%\s([\w%]+)\((.*)\)")  ; Functions
							StringReplace, VarValue, VarValue, `,, ```,, All
						CheckVars("VarValue", PointMarker)
						If (Target = "Expression")
						{
							If IsFunc("Eval")
							{
								Monster := "Eval"
							,	VarValue := %Monster%(VarValue, PointMarker)
							}
						}
						AssignVar(VarName, Oper, VarValue)
					}
					Else If IsFunc(Action)
					{
						Params := Object()
						StringReplace, VarValue, VarValue, ```,, ¢, All
						Loop, Parse, VarValue, `,, %A_Space%""
						{
							LoopField := DerefVars(A_LoopField)
							StringReplace, LoopField, LoopField, ¢, `,, All
							Params.Insert(LoopField)
						}
						Try
							%VarName% := %Action%(Params*)
						Catch e
						{
							MsgBox, 20, %d_Lang007%, % "Macro" mMacroOn ", " d_Lang065 " " mListRow
								.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" e.Extra "`n`n" d_Lang035
							IfMsgBox, No
							{
								StopIt := 1
								return
							}
						}
					}
					Else If (Target <> "")
					{
						Params := Object()
						StringReplace, VarValue, VarValue, ```,, ¢, All
						Loop, Parse, VarValue, `,, %A_Space%""
						{
							LoopField := DerefVars(A_LoopField)
							StringReplace, LoopField, LoopField, `r`n, ``n, All
							StringReplace, LoopField, LoopField, `n, ``n, All
							StringReplace, LoopField, LoopField, ¢, `,, All
							Params.Insert(LoopField)
						}
						If (A_AhkPath)
							%VarName% := RunExtFunc(Target, Action, Params*)
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
					If InStr(Step, "``n")
						StringReplace, Step, Step, ``n, `n, All
					If InStr(Step, "``t")
						StringReplace, Step, Step, ``t, `t, All
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
				GoSub, SplitStep
				While, TimesX
				{
					If StopIt
					{
						Try Menu, Tray, Icon, %DefaultIcon%, 1
						Menu, Tray, Default, %w_Lang005%
						break 3
					}
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
			If WinExist("ahk_id " PMCOSC)
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

LoopSection(Start, End, lcX, lcL, PointO, mainL, mainC)
{
	local lCount, lIdx, L_Index, mLoopIndex, _Label, IfError := 0

	f_Loop:
	CoordMode, Mouse, %CoordMouse%
	lCount := End - Start - 1, PointMarker := PointO, x_Loop := (lcX = 0) ? 1 : lcX - 1
	Loop
	{
		mLoopIndex := A_Index + 1, LoopIndex := A_Index + 1
		Loop, %x_Loop%
		{
			mListRow := A_Index + 1
			If StopIt
				break
			If (SkipIt > 0)
				SkipIt--
			If (lcX > 0)
				mLoopIndex := A_Index + 1, LoopIndex := A_Index + 1
			Loop, %lCount%
			{
				If StopIt
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
				If (IsChecked <> lIdx)
					continue
				If (pb_Sel)
				{
					IsSelected := LV_GetNext(lIdx-1)
					If (IsSelected <> lIdx)
						continue
				}
				If (Type = cType17)
				{
					IfError := IfStatement(IfError, PointMarker)
					continue
				}
				If IfError > 0
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
				If ((Type = cType7) || (Type = cType38) || (Type = cType39)
				|| (Type = cType40) || (Type = cType41))
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
						GoSub, SplitStep
						LoopIndex := 1
						If (Type = cType38)
						{
							o_Loop%PointMarker% := []
							Loop, Read, %Par1%, %Par2%, %Par3%, %Par4%
							{
								If StopIt
								{
									o_Loop%PointMarker% := ""
									break 2
								}
								o_Loop%PointMarker%[A_Index, "LoopReadLine"] := A_LoopReadLine
							}
							LoopCount%PointMarker% := o_Loop%PointMarker%.MaxIndex()
						}
						Else If (Type = cType39)
						{
							o_Loop%PointMarker% := []
							Loop, Parse, Par1, %Par2%, %Par3%, %Par4%
							{
								If StopIt
								{
									o_Loop%PointMarker% := ""
									break 2
								}
								o_Loop%PointMarker%[A_Index, "LoopField"] := A_LoopField
							}
							LoopCount%PointMarker% := o_Loop%PointMarker%.MaxIndex()
						}
						Else If (Type = cType40)
						{
							o_Loop%PointMarker% := []
							Loop, %Par1%, %Par2%, %Par3%
							{
								If StopIt
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
							LoopCount%PointMarker% := o_Loop%PointMarker%.MaxIndex()
						}
						Else If (Type = cType41)
						{
							o_Loop%PointMarker% := []
							Loop, %Par1%, %Par2%, %Par3%, %Par4%
							{
								If StopIt
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
							LoopCount%PointMarker% := o_Loop%PointMarker%.MaxIndex()
						}
						Else
							LoopCount%PointMarker% := TimesX
						If (LoopCount%PointMarker% = "")
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
						If SkipIt > 1
						{
							SkipIt--
							continue
						}
						If (SkipIt > 0)
							SkipIt--
						End%PointMarker% := Start + A_Index
					,	GoToLab := LoopSection(Start%PointMarker%, End%PointMarker%, LoopCount%PointMarker%, lcL
						, PointMarker, mainL, mainC)
					,	o_Loop%PointMarker% := ""
						If (GoToLab = "_return")
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
				If ((Type = cType21) || (Type = cType44))
				{
					StringReplace, Step, Step, ``n, `n, All
					StringReplace, Step, Step, ``t, `t, All
					AssignReplace(Step)
					CheckVars("Step|Target|Window|VarName|VarValue", PointMarker)
					If (Type = cType21)
					{
						If RegExMatch(VarValue, "U)%\s([\w%]+)\((.*)\)")  ; Functions
							StringReplace, VarValue, VarValue, `,, ```,, All
						CheckVars("VarValue", PointMarker)
						If (Target = "Expression")
						{
							If IsFunc("Eval")
							{
								Monster := "Eval"
							,	VarValue := %Monster%(VarValue, PointMarker)
							}
						}
						AssignVar(VarName, Oper, VarValue)
					}
					Else If IsFunc(Action)
					{
						Params := Object()
						StringReplace, VarValue, VarValue, ```,, ¢, All
						Loop, Parse, VarValue, `,, %A_Space%""
						{
							LoopField := DerefVars(A_LoopField)
							StringReplace, LoopField, LoopField, ¢, `,, All
							Params.Insert(LoopField)
						}
						Try
							%VarName% := %Action%(Params*)
						Catch e
						{
							MsgBox, 20, %d_Lang007%, % "Macro" mMacroOn ", " d_Lang065 " " mListRow
								.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" e.Extra "`n`n" d_Lang035
							IfMsgBox, No
							{
								StopIt := 1
								return
							}
						}
					}
					Else If (Target <> "")
					{
						Params := Object()
						StringReplace, VarValue, VarValue, ```,, ¢, All
						Loop, Parse, VarValue, `,, %A_Space%""
						{
							LoopField := DerefVars(A_LoopField)
							StringReplace, LoopField, LoopField, `r`n, ``n, All
							StringReplace, LoopField, LoopField, `n, ``n, All
							StringReplace, LoopField, LoopField, ¢, `,, All
							Params.Insert(LoopField)
						}
						If (A_AhkPath)
							%VarName% := RunExtFunc(Target, Action, Params*)
					}
					continue
				}
				If ((Type = cType15) || (Type = cType16))
				{
					Loop, Parse, Action, `,,%A_Space%
						Act%A_Index% := A_LoopField
				}
				If InStr(Step, "``n")
					StringReplace, Step, Step, ``n, `n, All
				If InStr(Step, "``t")
					StringReplace, Step, Step, ``t, `t, All
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
				GoSub, SplitStep
				While, TimesX
				{
					If StopIt
						break 3
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
	Else If (Operator = "<>")
		result := (%Name% <> Value) ? true : false
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
		If InStr(Action1, "Click")
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
	global
	
	If Step = EndIf
	{
		If ThisError > 0
			ThisError--
		Else
			ThisError := 0
		return ThisError
	}
	If ((BreakIt > 0) || (SkipIt > 0))
		return ThisError
	If Step = Else
	{
		If ThisError > 0
			ThisError--
		Else
			ThisError++
		return ThisError
	}
	If ThisError > 0
	{
		ThisError++
		return ThisError
	}
	Else
	{
		Tooltip
		CheckVars("Step|Target|Window", PointMarker)
		EscCom("Step|TimesX|DelayX|Target|Window", 1)
		If ThisError > 0
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
			If SearchResult = 0
				ThisError := 0
			Else
				ThisError++
		}
		Else If (Action = If10)
		{
			If SearchResult <> 0
				ThisError := 0
			Else
				ThisError++
		}
		Else If (Action = If11)
		{
			This_Point := l_Point
			GoSub, SplitStep
			If RegExMatch(Par1, "A_Loop\w+")
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
			GoSub, SplitStep
			If RegExMatch(Par1, "A_Loop\w+")
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
			If (VarName = "A_Index")
				VarName := "LoopIndex"
			If IfEval(VarName, Oper, VarValue)
				ThisError := 0
			Else
				ThisError++
		}
		Else If (Action = If15)
		{
			If IsFunc("Eval")
			{
				Monster := "Eval"
				If %Monster%(Step, PointMarker)
					ThisError := 0
				Else
					ThisError++
			}
			Else
			{
				MsgBox, 17, %d_Lang007%, %d_Lang044%
				IfMsgBox, OK
					Run, http://www.autohotkey.com/board/topic/15675-monster
				return 0
			}
		}
	}
	return ThisError
}

class WaitFor
{
	Key(Key, Delay=0)
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
		If ErrorLevel
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
			Sleep, 10
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
	WinPars := []
	StringReplace, Window, Window, ```,, ¢, All
	Loop, Parse, Window, `,, %A_Space%
	{
		StringReplace, LoopField, A_LoopField, ¢, `,, All
		WinPars.Insert(LoopField)
	}
	return WinPars
}

CheckVars(Match_List, l_Point="")
{
	global
	Loop, Parse, Match_List, |
	{
		If InStr(%A_LoopField%, "%A_Index%")
			StringReplace, %A_LoopField%, %A_LoopField%, `%A_Index`%, `%LoopIndex`%, All
		If InStr(%A_LoopField%, "%ErrorLevel%")
			StringReplace, %A_LoopField%, %A_LoopField%, `%ErrorLevel`%, `%LastError`%, All
		While, RegExMatch(%A_LoopField%, "i)%(A_Loop\w+)%", lMatch)
		{
			I := DerefVars(LoopIndex), L := SubStr(lMatch1, 3)
		,	%A_LoopField% := RegExReplace(%A_LoopField%, "U)" lMatch, o_Loop%l_Point%[I][L])
		}
		If RegExMatch(%A_LoopField%, "sU)%\s([\w%]+)\((.*)\)")  ; Functions
		{
			While, RegExMatch(%A_LoopField%, "sU)%\s([\w%]+)\((.*)\)", Funct)
			{
				If IsFunc(Funct1)
				{
					Params := Object()
					StringReplace, Funct2, Funct2, ```,, ¢, All
					Loop, Parse, Funct2, `,, %A_Space%``""
					{
						LoopField := DerefVars(A_LoopField)
						StringReplace, LoopField, LoopField, ```,, `,, All
						StringReplace, LoopField, LoopField, ¢, `,, All
						Params.Insert(LoopField)
					}
					FuncResult := %Funct1%(Params*)
					StringReplace, FuncResult, FuncResult, `,, ```, 
					StringReplace, %A_LoopField%, %A_LoopField%, %Funct%, %FuncResult%
					FuncResult := ""
				}
				Else
					break
			}
		}
		%A_LoopField% := DerefVars(%A_LoopField%)
		If RegExMatch(%A_LoopField%, "U)^%\s+[\w\d_\[\]\(\)]+$")  ; DynamicVars
		{
			While, RegExMatch(%A_LoopField%, "mU)%\s+([\w%]*)(``,|$)", Found)
				%A_LoopField% := RegExReplace(%A_LoopField%, Found, %Found1%)
			While, RegExMatch(%A_LoopField%, "mU)%\s+(\S+)\[(\S+)\]", Found) ; Arrays
			{
				Found := RegExReplace(Found, "[\[|\]]", "\$0")
				If Found2 is not Number
				{
					If InStr(Found2, "A_")=1
					{
						If (Found2 = "A_Index")
							Found2 := LoopIndex
						While, RegExMatch(Found2, "i)(A_Loop\w+)", lMatch)
						{
							I := DerefVars(LoopIndex), L := SubStr(lMatch1, 3)
						,	Found2 := RegExReplace(Found2, "U)" lMatch, o_Loop%l_Point%[I][L])
						}
					}
					Else
						Found2 := DerefVars("%" Found2 "%")
				}
				Try
					%A_LoopField% := RegExReplace(%A_LoopField%, Found, %Found1%[Found2])
				Catch
					%A_LoopField% := RegExReplace(%A_LoopField%, Found)
			}
		}
	}
}

DerefVars(v_String)
{
	global
	
	StringReplace, v_String, v_String, ```%, ¤, All
	While, RegExMatch(v_String, "%(\w+)%", rMatch)
	{
		If rMatch1 in Temp,AppData,WinDir
			rMatch1 := RegExReplace(rMatch1, "\V+", "A_$0")
		FoundVar := RegExReplace(%rMatch1%, "%", "¤")
	,	FoundVar := RegExReplace(FoundVar, "\$", "$$$$")
	,	FoundVar := RegExReplace(FoundVar, ",", "``,")
	,	v_String := RegExReplace(v_String, rMatch, FoundVar)
	}
	return RegExReplace(v_String, "¤", "%")
}

