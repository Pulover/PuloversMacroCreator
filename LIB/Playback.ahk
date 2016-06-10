Playback(Macro_On, LoopInfo := "", ManualKey := "", UDFParams := "", RunningFunction := "", FlowControl := "")
{
	local PlaybackVars := [], LVData := [], LoopDepth := 0, LoopCount := [0], StartMark := []
	, m_ListCount := ListCount%Macro_On%, mLoopIndex, cLoopIndex, iLoopIndex := 0, mLoopLength, mLoopSize, mListRow
	, Action, Step, TimesX, DelayX, Type, Target, Window, TimesR, Loop_Start := 0, Loop_End, Lab, _Label, _i, Pars, _Count, TimesLoop, FieldsData
	, NextStep, NStep, NTimesX, NType, NTarget, NWindow, _each, _value, _key, _depth, _pair, _index, _point
	, pbParams, VarName, VarValue, Oper, RowData, ActiveRows, Increment := 0, TabIdx, RowIdx, LabelFound, Row_Type, TargetLabel, TargetFunc
	, ScopedParams := [], UserGlobals, GlobalList, VarsList, CursorX, CursorY, TakeAction, PbCoordModes
	, Func_Result, SVRef, FuncPars, ParamIdx := 1, EvalResult, IsUserFunc := false

	Gui, 1:-OwnDialogs
	
	If (LoopInfo.GetCapacity())
	{
		LoopDepth := LoopInfo.LoopDepth
	,	PlaybackVars := LoopInfo.PlaybackVars
	,	Loop_Start := LoopInfo.Range.Start
	,	Loop_End := LoopInfo.Range.End
	,	mLoopSize := LoopInfo.Count
	,	Increment := LoopInfo.Increment
	,	PbCoordModes := LoopInfo.CoordModes
	,	PbSendModes := LoopInfo.SendModes
	,	IsUserFunc := LoopInfo.UserFunc
	}
	Else
	{
		If (LoopInfo > 0)
			Loop_Start := LoopInfo
		PbCoordModes := {Mouse: CoordMouse, Tooltip: "Window", Pixel: "Window", Caret: "Window", Menu: "Window"}
		PbSendModes := {Mode: KeyMode, Key: KeyDelay, Duration: "", Play: "", Mouse: MouseDelay, MPlay: "", Control: ControlDelay}
		CoordMode, Mouse, Screen
		MouseGetPos, CursorX, CursorY
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
		If ((ShowProgBar = 1) && (RunningFunction = ""))
			GuiControl, 28:+Range0-%m_ListCount%, OSCProg
		mLoopSize := o_TimesG[Macro_On]
		If (UDFParams.GetCapacity())
			IsUserFunc := true
	}
	SetTitleMatchMode, %TitleMatch%
	SetTitleMatchMode, %TitleSpeed%
	DetectHiddenWindows, %HiddenWin%
	DetectHiddenText, %HiddenText%
	If (!FlowControl.GetCapacity())
		FlowControl := {Break: 0, Continue: 0, If: 0, ErrorLevel: 0}
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
,	mLoopLength := (UDFParams.GetCapacity() || ManualKey || Increment) ? 1 : o_TimesG[Macro_On]
	While (mLoopLength = 0 || A_Index <= mLoopLength)
	{
		If (StopIt)
			break
		cLoopIndex := A_Index + Increment
		Loop, %m_ListCount%
		{
			mListRow := A_Index + Loop_Start
			If (mListRow > m_ListCount)
				break
			If (StopIt)
				break 2
			If (Loop_End = mListRow)
				return
			If (!ActiveRows.Checked[mListRow])
				continue
			If (!IsUserFunc)
			{
				If ((pb_From) && (mListRow < ActiveRows.FirstSel))
					continue
				If ((pb_To) && (mListRow > ActiveRows.FirstSel))
					break
				If ((pb_Sel) && (!ActiveRows.Selected[mListRow]))
					continue
			}
			
			CoordMode, Mouse, % PbCoordModes["Mouse"]
			CoordMode, ToolTip, % PbCoordModes["Tooltip"]
			CoordMode, Pixel, % PbCoordModes["Pixel"]
			CoordMode, Caret, % PbCoordModes["Caret"]
			CoordMode, Menu, % PbCoordModes["Menu"]
			
			SendMode, % PbSendModes["Mode"]
			SetKeyDelay, % PbSendModes["Key"], % PbSendModes["Duration"], % PbSendModes["Play"]
			SetMouseDelay, % PbSendModes["Mouse"], % PbSendModes["MPlay"]
			SetControlDelay, % PbSendModes["Control"]
			
			mLoopIndex := iLoopIndex ? 1 : cLoopIndex
		,	PlaybackVars[LoopDepth][mLoopIndex, "A_Index"] := mLoopIndex
		,	PlaybackVars[LoopDepth][mLoopIndex, "ErrorLevel"] := FlowControl.ErrorLevel
			
			For _each, _value in PlaybackVars[LoopDepth][mLoopIndex]
				(InStr(_each, "A_")=1) ? "" : %_each% := _value
			
			Data_GetTexts(LVData, mListRow, Action, Step, TimesX, DelayX, Type, Target, Window)
			
			If ((ShowProgBar = 1) && (RunningFunction = "") && (FlowControl.Break = 0) && (FlowControl.Continue = 0) && (FlowControl.If = 0))
			{
				If Type not in %cType7%,%cType17%,%cType21%,%cType35%,%cType38%,%cType39%,%cType40%,%cType41%,%cType44%,%cType45%,%cType46%,%cType47%,%cType48%,%cType49%,%cType42%
				{
					GuiControl, 28:, OSCProg, %mListRow%
					GuiControl, 28:, OSCProgTip, % "M" Macro_On " [Loop: " (iLoopIndex ? 1 "/" (LoopCount[LoopDepth][1] + 1) : mLoopIndex "/" mLoopSize) " | Row: " A_Index "/" m_ListCount "]"
				}
				Else If (ManualKey)
				{
					GuiControl, 28:, OSCProg, %mListRow%
					GuiControl, 28:, OSCProgTip, % "M" Macro_On " [Loop: " (iLoopIndex ? 1 "/" (LoopCount[LoopDepth][1] + 1) : mLoopIndex "/" mLoopSize) " | Row: " A_Index "/" m_ListCount "]"
				}
			}
			
			If ((ManualKey) && (ShowStep))
			{
				NextStep := mListRow + 1
				If (NextStep > LVData.Length())
					NextStep := 1
				While ((!ActiveRows.Checked[NextStep]) || (LVData[NextStep, 8] = cType42))
				{
					NextStep++
					If (mListRow > m_ListCount)
						return
				}
				Data_GetTexts(LVData, NextStep,, NStep, NTimesX,, NType, NTarget, NWindow)
				ToolTip, 
				(LTrim
				%d_Lang021%: %NextStep%
				%NType%, %NStep%   [x%NTimesX% @ %NWindow%|%NTarget%]

				%d_Lang022%: %mListRow%
				%Type%, %Step%   [x%TimesX% @ %Window%|%Target%]
				)
			}
			If (WinExist("ahk_id " PMCOSC))
				Gui, 28:+AlwaysOntop
			If (Type = cType48)
			{
				AssignParse(Step, VarName, Oper, VarValue)
				
				If (VarName = "")
					VarName := Step, VarValue := UDFParams[ParamIdx].Value
				Else If (UDFParams.HasKey(ParamIdx))
					VarValue := (IsObject(UDFParams[ParamIdx].Value)) ? UDFParams[ParamIdx].Value
							:	(UDFParams[ParamIdx].IsMissing) ? VarValue : UDFParams[ParamIdx].Value
				
				VarValue := (IsObject(VarValue)) ? VarValue
						: (VarValue = "true") ? 1
						: (VarValue = "false") ? 0
						: Trim(VarValue, """")
			,	ScopedParams[ParamIdx] := {ParamName: VarName
										, VarName: UDFParams[ParamIdx].Name
										, Value: %VarName%
										, NewValue: VarValue
										, Type: (Target = "ByRef") ? "ByRef" : "Param"}
			,	ParamIdx++
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
									Static_Vars[RunningFunction][VarName] := (VarValue = "true") ? 1
																			: (VarValue = "false") ? 0
																			: Trim(VarValue, """")
							}
						}
					}
				}
				IsUserFunc := Target
				GlobalList := ""
				If (Target = "Global")
				{
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
									SVRef[VarName] := %VarName%, %VarName% := (VarValue = "true") ? 1
																			: (VarValue = "false") ? 0
																			: Trim(VarValue, """")
							}
						}
					}
				}
				Else If (Target = "Local")
				{
					Loop, Parse, Window, /, %A_Space%
					{
						If (A_Index = 1)
							Loop, Parse, A_LoopField, `,, %A_Space%
								GlobalList .= A_LoopField ","
					}
					UserGlobals := User_Vars.Get(true)
					For each, Section in UserGlobals
						For _key, _value in Section
							GlobalList .= _key ","
					UserGlobals := ""
					
					SavedVars(, VarsList, true)
					For _each, _value in VarsList
					{
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
					If (!HideErrors)
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
				
				If (IsUserFunc = "Local")
				{
					SavedVars(, VarsList, true, RunningFunction)
					For _each, _value in VarsList
					{
						If _value in %GlobalList%
							continue
						%_value% := SVRef[_value]
					}
					SavedVars(,,, RunningFunction, true)
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
				FlowControl.If := IfStatement(FlowControl.If, PlaybackVars[LoopDepth][mLoopIndex]
							, Action, Step, TimesX, DelayX, Type, Target, Window, FlowControl)
				If (ManualKey)
					WaitFor.Key(o_ManKey[ManualKey])
				continue
			}
			If (FlowControl.If != 0)
				continue
			If ((Type = cType36) || (Type = cType37) || (Type = cType50))
			{
				If ((FlowControl.Break > 0) || (FlowControl.Continue > 0))
					continue
				CheckVars(PlaybackVars[LoopDepth][mLoopIndex], Step, DelayX)
			,	TabIdx := 0, RowIdx := 0, LabelFound := false
				Loop, %TabCount%
				{
					TabIdx := A_Index
					If (Step = TabGetText(TabSel, A_Index))
					{
						LabelFound := true
						break
					}
					Gui, chMacro:Default
					Gui, chMacro:Submit, NoHide
					Gui, chMacro:ListView, InputList%TabIdx%
					Loop, % ListCount%A_Index%
					{
						LV_GetText(Row_Type, A_Index, 6)
					,	LV_GetText(TargetLabel, A_Index, 3)
						If ((Row_Type = cType35) && (TargetLabel = Step))
						{
							RowIdx := A_Index, LabelFound := true
							break 2
						}
					}
				}
				If (!LabelFound)
				{
					If (!HideErrors)
					{
						MsgBox, 20, %d_Lang007%, % "Macro" Macro_On ", " d_Lang065 " " mListRow
							. "`n" d_Lang007 ":`t`t" d_Lang109 "`n" d_Lang066 ":`t" Step
						IfMsgBox, No
							StopIt := 1
					}
					continue
				}
				If (Type = cType36)
				{
					_Label := [TabIdx, RowIdx, ManualKey]
					return _Label
				}
				If (Type = cType37)
				{
					_Label := Playback(TabIdx, RowIdx, ManualKey)
					If (IsObject(_Label))
						return _Label
					Else If (_Label)
					{
						Lab := _Label, _Label := 0
						If (_Label := Playback(Lab,, ManualKey))
							return _Label
					}
				}
				If (Type = cType50)
				{
					Action := RegExReplace(Action, ".*\s")
					For _each, _key in RegisteredTimers
					{
						If (_key = Step)
						{
							aHK_Timer%_each% := TabIdx, aHK_Label%_Label% := RowIdx
							If (Action = "Once")
							{
								DelayX := DelayX > 0 ? DelayX * -1 : -1
								SetTimer, RunTimerOn%_each%, %DelayX%
							}
							Else If (Action = "Period")
								SetTimer, RunTimerOn%_each%, %DelayX%
							Else If (Action = "Delete")
							{
								SetTimer, RunTimerOn%_each%, Delete
								RegisteredTimers.Delete(_each)
							}
							Else
								SetTimer, RunTimerOn%_each%, %Action%
							If (ManualKey)
								WaitFor.Key(o_ManKey[ManualKey], 0)
							If ((ShowProgBar = 1) && (RunningFunction = ""))
								GuiControl, 28:+Range0-%m_ListCount%, OSCProg
							continue 2
						}
					}
					For _each, _key in RegisteredTimers
					{
						If (_each != A_Index)
						{
							RegisteredTimers[_each] := Step
						,	aHK_Timer%_each% := TabIdx, aHK_Label%_Label% := RowIdx
							If (Action = "Once")
							{
								DelayX := DelayX > 0 ? DelayX * -1 : -1
								SetTimer, RunTimerOn%_each%, %DelayX%
							}
							Else If (Action = "Period")
								SetTimer, RunTimerOn%_each%, %DelayX%
							Else If (Action = "Delete")
							{
								SetTimer, RunTimerOn%_each%, Delete
								RegisteredTimers.Delete(_each)
							}
							Else
								SetTimer, RunTimerOn%_each%, %Action%
							If (ManualKey)
								WaitFor.Key(o_ManKey[ManualKey], 0)
							If ((ShowProgBar = 1) && (RunningFunction = ""))
								GuiControl, 28:+Range0-%m_ListCount%, OSCProg
							continue 2
						}
					}
					If (RegisteredTimers.Length() < 10)
					{
						_Label := RegisteredTimers.Push(Step)
					,	aHK_Timer%_Label% := TabIdx, aHK_Label%_Label% := RowIdx
						If (Action = "Once")
						{
							DelayX := DelayX > 0 ? DelayX * -1 : -1
							SetTimer, RunTimerOn%_Label%, %DelayX%
						}
						Else If (Action = "Period")
							SetTimer, RunTimerOn%_Label%, %DelayX%
						Else If (Action = "Delete")
						{
							SetTimer, RunTimerOn%_Label%, Delete
							RegisteredTimers.Delete(_Label)
						}
						Else
							SetTimer, RunTimerOn%_Label%, %Action%
					}
					Else
						TrayTip, %d_Lang107% %Step%, %d_Lang108%,, 19
				}
				If (ManualKey)
					WaitFor.Key(o_ManKey[ManualKey], 0)
				If ((ShowProgBar = 1) && (RunningFunction = ""))
					GuiControl, 28:+Range0-%m_ListCount%, OSCProg
				continue
			}
			If (Type = cType35)
				continue
			If ((ManualKey) && (Type = cType5))
					continue
			If ((Type = cType7) || (Type = cType38) || (Type = cType39)
			|| (Type = cType40) || (Type = cType41) || (Type = cType45) || (Type = cType51))
			{
				If (Action = "[LoopStart]")
				{
					If (FlowControl.Break > 0)
					{
						FlowControl.Break++
						continue
					}
					If (FlowControl.Continue > 0)
					{
						FlowControl.Continue++
						continue
					}
					Pars := SplitStep(PlaybackVars[LoopDepth][mLoopIndex], Step)
				,	CheckVars(PlaybackVars[LoopDepth][mLoopIndex], TimesX)
				,	LoopDepth++
				,	PlaybackVars[LoopDepth] := []
				,	iLoopIndex++, StartMark[LoopDepth] := mListRow
				,	PlaybackVars[LoopDepth][mLoopIndex, "A_Index"] := 1
				,	PlaybackVars[LoopDepth][mLoopIndex, "ErrorLevel"] := FlowControl.ErrorLevel
				,	LoopCount[LoopDepth] := ""
				
					If Type not in %cType45%,%cType51%
					{
						For _each, _value in Pars
						{
							CheckVars(CustomVars, _value)
						,	Pars[_each] := _value
						}
					}
					
					For _depth, _pair in PlaybackVars
					{
						If (_depth = LoopDepth)
							break
						For _index, _point in _pair[mLoopIndex]
							For _each, _value in PlaybackVars[LoopDepth - 1]
								PlaybackVars[LoopDepth][_each, _index] := _point
					}
					
					If (Type = cType38)
					{
						Loop, Read, % Pars[1]
						{
							If (StopIt)
								break 3
							PlaybackVars[LoopDepth][A_Index, "A_LoopReadLine"] := A_LoopReadLine
						,	LoopCount[LoopDepth] := [A_Index - 1, "", Target]
						}
					}
					Else If (Type = cType39)
					{
						If (RegExMatch(Trim(Pars[1]), "%\s+(.+)", _Match) = 1)
							Step := Eval(_Match1, PlaybackVars[LoopDepth][mLoopIndex])[1]
						Else
						{
							Step := RegExReplace(Pars[1], "\w+", "%$0%", "", 1)
						,	CheckVars(PlaybackVars[LoopDepth][mLoopIndex], Step)
						}
						Loop, Parse, Step, % Pars[2], % Pars[3]
						{
							If (StopIt)
								break 3
							PlaybackVars[LoopDepth][A_Index, "A_LoopField"] := A_LoopField
						,	LoopCount[LoopDepth] := [A_Index - 1, "", Target]
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
						,	LoopCount[LoopDepth] := [A_Index - 1, "", Target]
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
						,	LoopCount[LoopDepth] := [A_Index - 1, "", Target]
						}
					}
					Else If (Type = cType45)
					{
						VarName := Eval(Pars[1], PlaybackVars[LoopDepth][mLoopIndex])[1]
						For _each, _value in VarName
						{
							If (StopIt)
								break 3
							PlaybackVars[LoopDepth][A_Index, Pars[2]] := _each
						,	PlaybackVars[LoopDepth][A_Index, Pars[3]] := _value
						,	LoopCount[LoopDepth] := [A_Index - 1, "", Target]
						}
					}
					Else If (Type = cType51)
					{
						If (!Eval(Step, PlaybackVars[LoopDepth][mLoopIndex])[1])
						{
							PlaybackVars[LoopDepth][mLoopIndex, "A_Index"] := mLoopIndex
						,	FlowControl.Break++
							continue
						}
						LoopCount[LoopDepth] := [0, Step]
					}
					Else
						LoopCount[LoopDepth] := [TimesX - 1, "", Target]
					If (!IsObject(LoopCount[LoopDepth]))
					{
						PlaybackVars[LoopDepth][mLoopIndex, "A_Index"] := mLoopIndex
					,	FlowControl.Break++
					}
					continue
				}
				If (Action = "[LoopEnd]")
				{
					_Count := LoopCount[LoopDepth][1]
				,	LoopInfo := {LoopDepth: LoopDepth
							,	PlaybackVars: PlaybackVars
							,	Range: {Start: StartMark[LoopDepth], End: mListRow }
							,	Count: _Count + 1
							,	CoordModes: PbCoordModes
							,	SendModes: PbSendModes
							,	UserFunc: IsUserFunc}
					If (LoopCount[LoopDepth][3] != "")
					{
						If (Eval(LoopCount[LoopDepth][3], PlaybackVars[LoopDepth][mLoopIndex])[1])
							_Count := 0
					}
					Loop
					{
						PlaybackVars[LoopDepth][A_Index + 1, "A_Index"] := A_Index + 1
					,	PlaybackVars[LoopDepth][A_Index + 1, "ErrorLevel"] := FlowControl.ErrorLevel
						If (StopIt)
							break 3
						If (FlowControl.Break > 0)
						{
							FlowControl.Break--
							break
						}
						If (FlowControl.Continue > 1)
						{
							FlowControl.Continue--
							break
						}
						If (FlowControl.Continue > 0)
							FlowControl.Continue--
						If (LoopCount[LoopDepth][2] != "") ; While-Loop
						{
							If (!Eval(LoopCount[LoopDepth][2], PlaybackVars[LoopDepth][A_Index + 1])[1])
								break
						}
						Else If (_Count = 0)
							break
						
						LoopInfo.Increment := A_Index
					,	GoToLab := Playback(Macro_On, LoopInfo, ManualKey,,, FlowControl)
						If (IsObject(GoToLab))
							return GoToLab
						Else If (GoToLab = "_return")
							break 3
						Else If (GoToLab)
						{
							Lab := GoToLab, GoToLab := 0
							If (_Label := Playback(Lab,, ManualKey,,, FlowControl))
								return _Label
							return
						}
						If (_Count = A_Index)
						{
							If (FlowControl.Break > 0)
								FlowControl.Break--
							If (FlowControl.Continue > 0)
								FlowControl.Continue--
							break
						}
						If (LoopCount[LoopDepth][3] != "") ; Until-Loop
						{
							If (Eval(LoopCount[LoopDepth][3], PlaybackVars[LoopDepth][A_Index + 1])[1])
							{
								If (FlowControl.Break > 0)
									FlowControl.Break--
								If (FlowControl.Continue > 1)
									FlowControl.Continue--
								If (FlowControl.Continue > 0)
									FlowControl.Continue--
								break
							}
						}
					}
					LoopCount[LoopDepth] := "", LoopDepth--, iLoopIndex--
					If (ManualKey)
						WaitFor.Key(o_ManKey[ManualKey], 0)
					continue
				}
			}
			If ((FlowControl.Break > 0) || (FlowControl.Continue > 0))
				continue
			If ((Type = cType21) || (Type = cType44) || (Type = cType46))
			{
				Step := StrReplace(Step, "``a", "`a")
			,	Step := StrReplace(Step, "``b", "`b")
			,	Step := StrReplace(Step, "``f", "`f")
			,	Step := StrReplace(Step, "``n", "`n")
			,	Step := StrReplace(Step, "``r", "`r")
			,	Step := StrReplace(Step, "``t", "`t")
			,	Step := StrReplace(Step, "``v", "`v")
			,	Step := StrReplace(Step, "``,", ",")
			,	Step := StrReplace(Step, "``%", "%")
			,	Step := StrReplace(Step, "``;", ";")
			,	Step := StrReplace(Step, "``::", "::")
			,	Step := StrReplace(Step, "````", "``")
			,	AssignParse(Step, VarName, Oper, VarValue)
			,	CheckVars(PlaybackVars[LoopDepth][mLoopIndex], Step, Target, Window, VarName, VarValue)
				If (Type = cType21)
				{
					If (Target = "Expression")
					{
						EvalResult := Eval(VarValue, PlaybackVars[LoopDepth][mLoopIndex])
					,	VarValue := EvalResult[1]
					}
					Try
						AssignVar(VarName, Oper, VarValue, PlaybackVars[LoopDepth][mLoopIndex], RunningFunction)
					Catch e
					{
						If (!HideErrors)
						{
							MsgBox, 20, %d_Lang007%, % "Macro" Macro_On ", " d_Lang065 " " mListRow
								.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" (InStr(e.Message, "0x800401E3") ? d_Lang088 : e.Extra) "`n`n" d_Lang035
							IfMsgBox, No
							{
								StopIt := 1
								continue
							}
						}
					}
					If (Target != "Expression")
					{
						FlowControl.ErrorLevel := ErrorLevel
					,	PlaybackVars[LoopDepth][mLoopIndex, "ErrorLevel"] := FlowControl.ErrorLevel
					}
					Try SavedVars(VarName,,, RunningFunction)
				}
				Else If ((Target != "") && (!RegExMatch(Target, "\.ahk$")))
				{
					pbParams := Target "." Action "(" VarValue ")"
					Try
					{
						VarValue := Eval(pbParams, PlaybackVars[LoopDepth][mLoopIndex])
					,	AssignVar(VarName, ":=", VarValue, PlaybackVars[LoopDepth][mLoopIndex], RunningFunction)
					}
					Catch e
					{
						If (!HideErrors)
						{
							MsgBox, 20, %d_Lang007%, % "Macro" Macro_On ", " d_Lang065 " " mListRow
								.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" (InStr(e.Message, "0x800401E3") ? d_Lang088 : e.Extra) "`n`n" d_Lang035
							IfMsgBox, No
							{
								StopIt := 1
								continue
							}
						}
					}
					Try SavedVars(VarName,,, RunningFunction)
				}
				Else If ((Type = cType44) && (Target != ""))
				{
					pbParams := Eval(VarValue, PlaybackVars[LoopDepth][mLoopIndex])
					If (A_AhkPath)
					{
						VarValue := RunExtFunc(Target, Action, pbParams*)
					,	AssignVar(VarName, ":=", VarValue, PlaybackVars[LoopDepth][mLoopIndex], RunningFunction)
						
						Try SavedVars(VarName,,, RunningFunction)
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
									pbParams := {Null: ""}
								,	FuncPars := ExprGetPars(VarValue)
								,	EvalResult := Eval(VarValue, PlaybackVars[LoopDepth][mLoopIndex])
									Loop, % EvalResult.Length()
										pbParams[A_Index] := {Name: FuncPars[A_Index], Value: EvalResult[A_Index], IsMissing: !EvalResult.HasKey(A_Index)}
									Func_Result := Playback(TabIdx,,, pbParams, Action)
								,	VarValue := Func_Result[1]
									Try
										AssignVar(VarName, ":=", VarValue, PlaybackVars[LoopDepth][mLoopIndex], RunningFunction)
									Catch e
									{
										If (!HideErrors)
										{
											MsgBox, 20, %d_Lang007%, % "Macro" Macro_On ", " d_Lang065 " " mListRow
												.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" (InStr(e.Message, "0x800401E3") ? d_Lang088 : e.Extra) "`n`n" d_Lang035
											IfMsgBox, No
											{
												StopIt := 1
												continue 3
											}
										}
									}
									Try SavedVars(VarName,,, RunningFunction)
									continue 3
								}
							}
						}
					}
					If (!Func(Action).IsBuiltIn)
					{
						If (!HideErrors)
						{
							If Action not contains %FuncWhiteList%
							{
								MsgBox, 20, %d_Lang007%, % "Macro" Macro_On ", " d_Lang065 " " mListRow
									.	"`n" d_Lang007 ":`t`t" d_Lang031 "`n" d_Lang066 ":`t" Action "`n`n" d_Lang035
								IfMsgBox, No
									StopIt := 1
								continue
							}
						}
					}
							
					pbParams := Eval(VarValue, PlaybackVars[LoopDepth][mLoopIndex])
					Try
					{
						VarValue := %Action%(pbParams*)
					,	AssignVar(VarName, ":=", VarValue, PlaybackVars[LoopDepth][mLoopIndex], RunningFunction)
					}
					Catch e
					{
						If (!HideErrors)
						{
							MsgBox, 20, %d_Lang007%, % "Macro" Macro_On ", " d_Lang065 " " mListRow
								.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" (InStr(e.Message, "0x800401E3") ? d_Lang088 : e.Extra) "`n`n" d_Lang035
							IfMsgBox, No
							{
								StopIt := 1
								continue
							}
						}
					}
					Try SavedVars(VarName,,, RunningFunction)
				}
				If (ManualKey)
					WaitFor.Key(o_ManKey[ManualKey], 0)
				continue
			}
			If (Type = "Return")
			{
				If (LoopInfo.GetCapacity())
					return "_return"
				break 2
			}
			If (Type = cType29)
			{
				If (LoopDepth = 0)
					break 2
				Else
				{
					If Step is number
						FlowControl.Break += Step
					Else
						FlowControl.Break++
					continue
				}
			}
			If (Type = cType30)
			{
				If Step is number
					FlowControl.Continue += Step
				Else
					FlowControl.Continue++
				continue
			}
			If (Type = cType42)
				continue
			TimesLoop := TimesX > 1
		,	CheckVars(PlaybackVars[LoopDepth][mLoopIndex], TimesX)
		,	FieldsData := {Action: Action, Step: Step, DelayX: DelayX, Type: Type, Target: Target, Window: Window}
			While (TimesX)
			{
				Data_GetTexts(LVData, mListRow, Action, Step, TimesR, DelayX,, Target, Window)
			,	PlaybackVars[LoopDepth][mLoopIndex, "A_Index"] := TimesLoop ? A_Index : mLoopIndex
			,	PlaybackVars[LoopDepth][mLoopIndex, "ErrorLevel"] := FlowControl.ErrorLevel
			,	Pars := SplitStep(PlaybackVars[LoopDepth][mLoopIndex], Step)
			,	CheckVars(PlaybackVars[LoopDepth][mLoopIndex], TimesR, DelayX, Target, Window)
				If (StopIt)
				{
					Try Menu, Tray, Icon, %DefaultIcon%, 1
					Menu, Tray, Default, %w_Lang005%
					break 3
				}
				If Type in %cType12%,%cType32%,%cType33%,%cType34%,%cType43%,%cType52%,%cType53%,%cType54%,%cType55%
				{
					Try
						TakeAction := PlayCommand(Type, Action, Step, TimesR, DelayX, Target, Window, Pars, FlowControl
												, PlaybackVars[LoopDepth][mLoopIndex], PbCoordModes, PbSendModes, RunningFunction)
					Catch e
					{
						If (!HideErrors)
						{
							MsgBox, 20, %d_Lang007%, % d_Lang064 " Macro" Macro_On ", " d_Lang065 " " mListRow
								.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" (InStr(e.Message, "0x800401E3") ? d_Lang088 : e.Extra "`n" e.What) "`n`n" d_Lang035
							IfMsgBox, No
								StopIt := 1
						}
					}
				}
				Else
					TakeAction := PlayCommand(Type, Action, Step, TimesR, DelayX, Target, Window, Pars, FlowControl
											, PlaybackVars[LoopDepth][mLoopIndex], PbCoordModes, PbSendModes, RunningFunction)
				PlaybackVars[LoopDepth][mLoopIndex, "ErrorLevel"] := FlowControl.ErrorLevel
				If ((Type = cType15) || (Type = cType16))
				{
					If (((Target = "UntilFound") && (SearchResult))
					|| ((Target = "UntilNotFound") && (SearchResult = 0)))
					{
						For _each, _value in FieldsData
							%_each% := _value
						If !(ManualKey)
							PlayCommand(cType5, "", "", "", DelayX, "", "", Pars, FlowControl
										, PlaybackVars[LoopDepth][mLoopIndex], PbCoordModes, PbSendModes, RunningFunction)
						If (TimesR > 1)
							TimesX--
						continue
					}
					If (((Target = "UntilFound") && (SearchResult = 0))
					|| ((Target = "UntilNotFound") && (SearchResult))
					|| (TakeAction = "Break"))
						TimesX := 1, TakeAction := ""
					TimesX--
				}
				Else
					TimesX--
				For _each, _value in FieldsData
					%_each% := _value
				If (Action = "[" cType20 "]")
					continue
				If ((Type = cType13) && (Action = "[Text]"))
					continue
				If Type in %cType5%,%cType6%,%cType20%,%cType50%
					continue
				If !(ManualKey)
					PlayCommand(cType5, "", "", "", DelayX, "", "", Pars, FlowControl
							, PlaybackVars[LoopDepth][mLoopIndex], PbCoordModes, PbSendModes, RunningFunction)
			}
			If (ManualKey)
				WaitFor.Key(o_ManKey[ManualKey], 0)
		}
		If (StopIt || FlowControl.Break)
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
		
		If (IsUserFunc = "Local")
		{
			SavedVars(, VarsList, true, RunningFunction)
			For _each, _value in VarsList
			{
				If _value in %GlobalList%
					continue
				%_value% := SVRef[_value]
			}
			SavedVars(,,, RunningFunction, true)
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
	If !(aHK_Timer0)
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
}

;##### Playback Commands #####

PlayCommand(Type, Action, Step, TimesX, DelayX, Target, Window, Pars, Flow, CustomVars, CoordModes, SendModes, RunningFunction)
{
	local Par1, Par2, Par3, Par4, Par5, Par6, Par7, Par8, Par9, Par10, Par11, Win
		, _each, _value, _Section, SelAcc, IeIntStr, lMatch, lMatch1, lResult, TakeAction := ""
	
	
	If Type in %cType1%,%cType2%,%cType3%,%cType13%,%cType5%,%cType6%,%cType8%,%cType9%
	,%cType10%,%cType12%,%cType24%,%cType22%,%cType23%,%cType25%,%cType31%,WinWait,WinWaitActive
	,WinWaitNotActive,WinWaitClose,WinGetTitle,WinGetClass,WinGetText,WinGetPos,%cType52%,%cType53%
	,%cType54%,%cType55%,%cType32%,%cType33%
		CheckVars(CustomVars, Step)
	Else If Type not in %cType34%,%cType43%
	{
		For _each, _value in Pars
		{
			CheckVars(CustomVars, _value)
		,	Par%_each% := _value
		}
	}
	
	Goto, pb_%Type%
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
		Flow.ErrorLevel := ErrorLevel
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
		Flow.ErrorLevel := ErrorLevel
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
		Flow.ErrorLevel := ErrorLevel
	return
	pb_ControlSetText:
		Win := SplitWin(Window)
		ControlSetText, %Target%, %Step%, % Win[1], % Win[2], % Win[3], % Win[4]
		Flow.ErrorLevel := ErrorLevel
	return
	pb_Run:
		If (Par4 != "")
		{
			Run, %Par1%, %Par2%, %Par3%, %Par4%
			Flow.ErrorLevel := ErrorLevel
			Try SavedVars(Par4,,, RunningFunction)
		}
		Else
		{
			Run, %Par1%, %Par2%, %Par3%
			Flow.ErrorLevel := ErrorLevel
		}
	return
	pb_RunWait:
		Try Menu, Tray, Icon, %ResDllPath%, 77
		ChangeProgBarColor("Blue", "OSCProg", 28)
		If (Par4 != "")
		{
			RunWait, %Par1%, %Par2%, %Par3%, %Par4%
			Flow.ErrorLevel := ErrorLevel
			Try SavedVars(Par4,,, RunningFunction)
		}
		Else
		{
			RunWait, %Par1%, %Par2%, %Par3%
			Flow.ErrorLevel := ErrorLevel
		}
		Try Menu, Tray, Icon, %ResDllPath%, 46
		ChangeProgBarColor("20D000", "OSCProg", 28)
	return
	pb_RunAs:
		RunAs, %Par1%, %Par2%, %Par3%
		Flow.ErrorLevel := ErrorLevel
	return
	pb_Process:
		Process, %Par1%, %Par2%, %Par3%
		Flow.ErrorLevel := ErrorLevel
	return
	pb_Shutdown:
		Shutdown, %Par1%
	return
	pb_GetKeyState:
		GetKeyState, %Par1%, %Par2%, %Par3%
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_MouseGetPos:
		Loop, 4
		{
			If (Par%A_Index% = "")
				Par%A_Index% := "_null"
		}
		MouseGetPos, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
		_null := ""
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_PixelGetColor:
		PixelGetColor, %Par1%, %Par2%, %Par3%, %Par4%
		Flow.ErrorLevel := ErrorLevel
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_SysGet:
		SysGet, %Par1%, %Par2%, %Par3%
		Try SavedVars(Par1,,, RunningFunction)
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
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_EnvSet:
		EnvSet, %Par1%, %Par2%
	return
	pb_EnvUpdate:
		EnvUpdate
	return
	pb_FormatTime:
		FormatTime, %Par1%, %Par2%, %Par3%
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_Transform:
		Transform, %Par1%, %Par2%, %Par3%, %Par4%
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_Random:
		Random, %Par1%, %Par2%, %Par3%
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_FileAppend:
		FileAppend, %Par1%, %Par2%, %Par3%
		Flow.ErrorLevel := ErrorLevel
	return
	pb_FileCopy:
		FileCopy, %Par1%, %Par2%, %Par3%
		Flow.ErrorLevel := ErrorLevel
	return
	pb_FileCopyDir:
		FileCopyDir, %Par1%, %Par2%, %Par3%
		Flow.ErrorLevel := ErrorLevel
	return
	pb_FileCreateDir:
		FileCreateDir, %Par1%
		Flow.ErrorLevel := ErrorLevel
	return
	pb_FileCreateShortcut:
		FileCreateShortcut, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%, %Par7%, %Par8%, %Par9%
		Flow.ErrorLevel := ErrorLevel
	return
	pb_FileDelete:
		FileDelete, %Par1%
		Flow.ErrorLevel := ErrorLevel
	return
	pb_FileGetAttrib:
		FileGetAttrib, %Par1%, %Par2%
		Flow.ErrorLevel := ErrorLevel
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_FileGetShortcut:
		Loop, 8
		{
			If (Par%A_Index% = "")
				Par%A_Index% := "_null"
		}
		FileGetShortcut, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%, %Par7%, %Par8%
		Flow.ErrorLevel := ErrorLevel
		_null := ""
		Loop, 7
		{
			AI := A_Index + 1
			Try SavedVars(Par%AI%)
		}
	return
	pb_FileGetSize:
		FileGetSize, %Par1%, %Par2%, %Par3%
		Flow.ErrorLevel := ErrorLevel
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_FileGetTime:
		FileGetTime, %Par1%, %Par2%, %Par3%
		Flow.ErrorLevel := ErrorLevel
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_FileGetVersion:
		FileGetVersion, %Par1%, %Par2%
		Flow.ErrorLevel := ErrorLevel
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_FileMove:
		FileMove, %Par1%, %Par2%, %Par3%
		Flow.ErrorLevel := ErrorLevel
	return
	pb_FileMoveDir:
		FileMoveDir, %Par1%, %Par2%, %Par3%
		Flow.ErrorLevel := ErrorLevel
	return
	pb_FileRead:
		FileRead, %Par1%, %Par2%
		Flow.ErrorLevel := ErrorLevel
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_FileReadLine:
		FileReadLine, %Par1%, %Par2%, %Par3%
		Flow.ErrorLevel := ErrorLevel
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_FileRecycle:
		FileRecycle, %Par1%
		Flow.ErrorLevel := ErrorLevel
	return
	pb_FileRecycleEmpty:
		FileRecycleEmpty, %Par1%
		Flow.ErrorLevel := ErrorLevel
	return
	pb_FileRemoveDir:
		FileRemoveDir, %Par1%, %Par2%
		Flow.ErrorLevel := ErrorLevel
	return
	pb_FileSelectFile:
		FileSelectFile, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
		Flow.ErrorLevel := ErrorLevel
		FreeMemory()
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_FileSelectFolder:
		FileSelectFolder, %Par1%, %Par2%, %Par3%, %Par4%
		Flow.ErrorLevel := ErrorLevel
		FreeMemory()
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_FileSetAttrib:
		FileSetAttrib, %Par1%, %Par2%, %Par3%, %Par4%
		Flow.ErrorLevel := ErrorLevel
	return
	pb_FileSetTime:
		FileSetTime, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
		Flow.ErrorLevel := ErrorLevel
	return
	pb_Drive:
		Drive, %Par1%, %Par2%, %Par3%
		Flow.ErrorLevel := ErrorLevel
	return
	pb_DriveGet:
		DriveGet, %Par1%, %Par2%, %Par3%
		Flow.ErrorLevel := ErrorLevel
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_DriveSpaceFree:
		DriveSpaceFree, %Par1%, %Par2%
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_Sort:
		Sort, %Par1%, %Par2%
		Flow.ErrorLevel := ErrorLevel
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_StringGetPos:
		StringGetPos, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
		Flow.ErrorLevel := ErrorLevel
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_StringLeft:
		StringLeft, %Par1%, %Par2%, %Par3%
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_StringRight:
		StringRight, %Par1%, %Par2%, %Par3%
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_StringLen:
		StringLen, %Par1%, %Par2%
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_StringLower:
		StringLower, %Par1%, %Par2%, %Par3%
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_StringUpper:
		StringUpper, %Par1%, %Par2%, %Par3%
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_StringMid:
		StringMid, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_StringReplace:
		StringReplace, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
		Flow.ErrorLevel := ErrorLevel
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_StringSplit:
		StringSplit, %Par1%, %Par2%, %Par3%, %Par4%
		CGN := Par1 . "0"
		Loop, % %CGN%
		{
			CGP := Par1 . A_Index
			Try SavedVars(CGP,,, RunningFunction)
		}
	return
	pb_StringTrimLeft:
		StringTrimLeft, %Par1%, %Par2%, %Par3%
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_StringTrimRight:
		StringTrimRight, %Par1%, %Par2%, %Par3%
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_SplitPath:
		Loop, 6
		{
			If (Par%A_Index% = "")
				Par%A_Index% := "_null"
		}
		SplitPath, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%
		_null := ""
		Loop, 5
		{
			AI := A_Index + 1
			Try SavedVars(Par%AI%)
		}
	return
	pb_InputBox:
		InputBox, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%, %Par7%, %Par8%,, %Par10%, %Par11%
		Flow.ErrorLevel := ErrorLevel
		Try SavedVars(Par1,,, RunningFunction)
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
		Flow.ErrorLevel := ErrorLevel
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_RegWrite:
		RegWrite, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
		Flow.ErrorLevel := ErrorLevel
	return
	pb_RegDelete:
		RegDelete, %Par1%, %Par2%, %Par3%
		Flow.ErrorLevel := ErrorLevel
	return
	pb_SetRegView:
		SetRegView, %Par1%
	return
	pb_IniRead:
		IniRead, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
		Flow.ErrorLevel := ErrorLevel
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_IniWrite:
		IniWrite, %Par1%, %Par2%, %Par3%, %Par4%
		Flow.ErrorLevel := ErrorLevel
	return
	pb_IniDelete:
		IniDelete, %Par1%, %Par2%, %Par3%
		Flow.ErrorLevel := ErrorLevel
	return
	pb_SoundBeep:
		SoundBeep, %Par1%, %Par2%
	return
	pb_SoundGet:
		SoundGet, %Par1%, %Par2%, %Par3%, %Par4%
		Flow.ErrorLevel := ErrorLevel
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_SoundGetWaveVolume:
		SoundGetWaveVolume, %Par1%, %Par2%
		Flow.ErrorLevel := ErrorLevel
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_SoundPlay:
		SoundPlay, %Par1%, %Par2%
		Flow.ErrorLevel := ErrorLevel
	return
	pb_SoundSet:
		SoundSet, %Par1%, %Par2%, %Par3%, %Par4%
		Flow.ErrorLevel := ErrorLevel
	return
	pb_SoundSetWaveVolume:
		SoundSetWaveVolume, %Par1%, %Par2%
		Flow.ErrorLevel := ErrorLevel
	return
	pb_ClipWait:
		Try Menu, Tray, Icon, %ResDllPath%, 77
		ChangeProgBarColor("Blue", "OSCProg", 28)
		ClipWait, %Par1%, %Par2%
		Flow.ErrorLevel := ErrorLevel
		Try Menu, Tray, Icon, %ResDllPath%, 46
		ChangeProgBarColor("20D000", "OSCProg", 28)
	return
	pb_BlockInput:
		BlockInput, %Par1%
	return
	pb_UrlDownloadToFile:
		UrlDownloadToFile, %Par1%, %Par2%
		Flow.ErrorLevel := ErrorLevel
	return
	pb_CoordMode:
		CoordModes[Par1] := Par2
	return
	pb_OutputDebug:
		OutputDebug, %Par1%
	return
	pb_WinMenuSelectItem:
		WinMenuSelectItem, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%, %Par7%, %Par8%, %Par9%, %Par10%, %Par11%
		Flow.ErrorLevel := ErrorLevel
	return
	pb_SendMode:
		SendModes["Mode"] := Par1
	return
	pb_SetKeyDelay:
		SendModes["Key"] := Par1
	,	SendModes["Duration"] := Par2 ? Par2 : SendModes["Duration"]
	,	SendModes["Play"] :=  Par3 ? Par3 : SendModes["Play"]
	return
	pb_SetMouseDelay:
		SendModes["Mouse"] := Par1
	,	SendModes["MPlay"] :=  Par2 ? Par2 : SendModes["MPlay"]
	return
	pb_SetControlDelay:
		SendModes["Control"] := Par1
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
		Flow.ErrorLevel := ErrorLevel
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_StatusBarWait:
		Try Menu, Tray, Icon, %ResDllPath%, 77
		ChangeProgBarColor("Blue", "OSCProg", 28)
		StatusBarWait, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%
		Flow.ErrorLevel := ErrorLevel
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
		Flow.ErrorLevel := ErrorLevel
	return
	pb_ControlFocus:
		Win := SplitWin(Window)
		ControlFocus, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
		Flow.ErrorLevel := ErrorLevel
	return
	pb_ControlMove:
		Win := SplitWin(Window)
		ControlMove, %Target%, %Par1%, %Par2%, %Par3%, %Par4%, % Win[1], % Win[2], % Win[3], % Win[4]
		Flow.ErrorLevel := ErrorLevel
	return
	pb_PixelSearch:
		Loop, 5
			Act%A_Index% := ""
		Loop, Parse, Action, `,,%A_Space%
			Act%A_Index% := A_LoopField
		CoordMode, Pixel, %Window%
		PixelSearch, FoundX, FoundY, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%, %Par7%
		Flow.ErrorLevel := ErrorLevel, SearchResult := ErrorLevel
		Try %Act3% := FoundX, %Act4% := FoundY
		GoSub, TakeAction
	return TakeAction
	pb_ImageSearch:
		Loop, 5
			Act%A_Index% := ""
		Loop, Parse, Action, `,,%A_Space%
			Act%A_Index% := A_LoopField
		CoordMode, Pixel, %Window%
		ImageSearch, FoundX, FoundY, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%
		Flow.ErrorLevel := ErrorLevel, SearchResult := ErrorLevel
		If ((Act5) && (ErrorLevel = 0))
			CenterImgSrchCoords(Par5, FoundX, FoundY)
		Try %Act3% := FoundX, %Act4% := FoundY
		GoSub, TakeAction
	return TakeAction
	pb_SendMessage:
		Win := SplitWin(Window)
		SendMessage, %Par1%, %Par2%, %Par3%, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
		Flow.ErrorLevel := ErrorLevel
	return
	pb_PostMessage:
		Win := SplitWin(Window)
		PostMessage, %Par1%, %Par2%, %Par3%, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
		Flow.ErrorLevel := ErrorLevel
	return
	pb_KeyWait:
		Try Menu, Tray, Icon, %ResDllPath%, 77
		ChangeProgBarColor("Blue", "OSCProg", 28)
		If (Action = "KeyWait")
		{
			KeyWait, %Par1%, %Par2%
			Flow.ErrorLevel := ErrorLevel
		}
		Else
			WaitFor.Key(Par1, DelayX / 1000)
		Try Menu, Tray, Icon, %ResDllPath%, 46
		ChangeProgBarColor("20D000", "OSCProg", 28)
	return
	pb_Input:
		Input, %Par1%, %Par2%, %Par3%, %Par4%
		Flow.ErrorLevel := ErrorLevel
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_ControlEditPaste:
		Win := SplitWin(Window)
		Control, EditPaste, %Step%, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
		Flow.ErrorLevel := ErrorLevel
	return
	pb_ControlGetText:
		Win := SplitWin(Window)
		ControlGetText, %Step%, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
		Flow.ErrorLevel := ErrorLevel
		Try SavedVars(Step,,, RunningFunction)
	return
	pb_ControlGetFocus:
		Win := SplitWin(Window)
		ControlGetFocus, %Step%, % Win[1], % Win[2], % Win[3], % Win[4]
		Flow.ErrorLevel := ErrorLevel
		Try SavedVars(Step,,, RunningFunction)
	return
	pb_ControlGet:
		Win := SplitWin(Window)
		ControlGet, %Par1%, %Par2%, %Par3%, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
		Flow.ErrorLevel := ErrorLevel
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_ControlGetPos:
		Win := SplitWin(Window)
		ControlGetPos, %Step%X, %Step%Y, %Step%W, %Step%H, %Target%, % Win[1], % Win[2], % Win[3], % Win[4]
		Flow.ErrorLevel := ErrorLevel
		CGPPars := "X|Y|W|H"
		Loop, Parse, CGPPars, |
		{
			CGP := Step . A_LoopField
			Try SavedVars(CGP,,, RunningFunction)
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
		Flow.ErrorLevel := ErrorLevel
	return
	pb_WinShow:
		Win := SplitWin(Window)
		WinShow, % Win[1], % Win[2], % Win[3], % Win[4]
	return
	pb_WinSetTitle:
		Win := SplitWin(Window)
		WinSetTitle, % Win[1], % Win[2], %Par1%, % Win[3], % Win[4]
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
		Try SavedVars(Par1,,, RunningFunction)
	return
	pb_WinGetTitle:
		Win := SplitWin(Window)
		WinGetTitle, %Step%, % Win[1], % Win[2], % Win[3], % Win[4]
		Try SavedVars(Step,,, RunningFunction)
	return
	pb_WinGetClass:
		Win := SplitWin(Window)
		WinGetClass, %Step%, % Win[1], % Win[2], % Win[3], % Win[4]
		Try SavedVars(Step,,, RunningFunction)
	return
	pb_WinGetText:
		Win := SplitWin(Window)
		WinGetText, %Step%, % Win[1], % Win[2], % Win[3], % Win[4]
		Flow.ErrorLevel := ErrorLevel
		Try SavedVars(Step,,, RunningFunction)
	return
	pb_WinGetpos:
		Win := SplitWin(Window)
		WinGetPos, %Step%X, %Step%Y, %Step%W, %Step%H, % Win[1], % Win[2], % Win[3], % Win[4]
		CGPPars := "X|Y|W|H"
		Loop, Parse, CGPPars, |
		{
			CGP := Step . A_LoopField
			Try SavedVars(CGP,,, RunningFunction)
		}
	return
	pb_GroupAdd:
		GroupAdd, %Par1%, %Par2%, %Par3%, %Par4%, %Par5%, %Par6%
	return
	pb_GroupActivate:
		GroupActivate, %Par1%, %Par2%
		Flow.ErrorLevel := ErrorLevel
	return
	pb_GroupDeactivate:
		GroupDeactivate, %Par1%, %Par2%
	return
	pb_GroupClose:
		GroupClose, %Par1%, %Par2%
	return

	TakeAction:
		TakeAction := DoAction(FoundX, FoundY, Act1, Act2, SearchResult)
		If (TakeAction = "Continue")
			TakeAction := ""
		Else If (TakeAction = "Stop")
			StopIt := 1
		Else If (TakeAction = "Break") && (Target = "") && (TimesX = 1)
			Flow.Break++
		Else If (TakeAction = "Prompt")
		{
			If (SearchResult = 0)
				MsgBox, 49, %d_Lang035%, %d_Lang036% %FoundX%x%FoundY%.`n%d_Lang038%
			Else
				MsgBox, 49, %d_Lang035%, %d_Lang037%`n%d_Lang038%
			IfMsgBox, Cancel
				StopIt := 1
		}
		Else If (TakeAction = "Play Sound")
		{
			If (SearchResult = 0)
				SoundBeep
			Else
				Loop, 2
					SoundBeep
		}
		CoordMode, Mouse, %CoordMouse%
	return

	;##### Playback COM Commands #####

	pb_SendEmail:
		StringSplit, Act, Action, :
		Action := SubStr(Action, StrLen(Act1) + 2)
		StringSplit, Tar, Target, /
		CDO_To := SubStr(Tar1, 4)
	,	CDO_Sub := Action
	,	CDO_Msg := SubStr(Step, 3)
	,	CDO_Html := SubStr(Step, 1, 1)
	,	CDO_Att := Window
	,	CDO_CC := SubStr(Tar2, 4)
	,	CDO_BCC := SubStr(Tar3, 5)
		
	,	User_Accounts := UserMailAccounts.Get(true)
		For _each, _Section in User_Accounts
		{
			If (Act1 = _Section.email)
			{
				SelAcc := _Section
				break
			}
		}
		If (!IsObject(SelAcc))
		{
			Throw Exception(d_Lang112,, Act1)
			return
		}
		
		CDO(SelAcc, CDO_To, CDO_Sub, CDO_Msg, CDO_Html, CDO_Att, CDO_CC, CDO_BCC)
	return
	
	pb_DownloadFiles:
		WinHttpDownloadToFile(Step, Target)
	return
	
	pb_Zip:
		Zip(Step, Target, Window)
	return
	
	pb_Unzip:
		Unzip(Step, Target, Window)
	return
	
	pb_IECOM_Set:
		StringSplit, Act, Action, :
		StringSplit, El, Target, :
		IeIntStr := IEComExp(Act2, Step, El1, El2, "", Act3, Act1)

		Try
			ie.readyState
		Catch
		{
			If (ComAc)
				ie := WBGet()
			Else
			{
				ie := ComObjCreate("InternetExplorer.Application")
			,	ie.Visible := true
			}
		}
		If (!IsObject(ie))
		{
			ie := ComObjCreate("InternetExplorer.Application")
		,	ie.Visible := true
		}
		
		Eval(IeIntStr, CustomVars)
		
		If (Window = "LoadWait")
		{
			Try Menu, Tray, Icon, %ResDllPath%, 77
			ChangeProgBarColor("Blue", "OSCProg", 28)
			Try
				IELoad(ie)
			Try Menu, Tray, Icon, %ResDllPath%, 46
			ChangeProgBarColor("20D000", "OSCProg", 28)
		}
	return

	pb_IECOM_Get:
		StringSplit, Act, Action, :
		StringSplit, El, Target, :
		IeIntStr := IEComExp(Act2, "", El1, El2, Step, Act3, Act1)
		
		Try
			ie.readyState
		Catch
		{
			If (ComAc)
				ie := WBGet()
			Else
			{
				ie := ComObjCreate("InternetExplorer.Application")
			,	ie.Visible := true
			}
		}
		If (!IsObject(ie))
		{
			ie := ComObjCreate("InternetExplorer.Application")
		,	ie.Visible := true
		}
		
		lResult := Eval(IeIntStr, CustomVars)[1]
	,	AssignVar(Step, ":=", lResult, CustomVars, RunningFunction)
		Try SavedVars(Step,,, RunningFunction)
		
		If (Window = "LoadWait")
		{
			Try Menu, Tray, Icon, %ResDllPath%, 77
			ChangeProgBarColor("Blue", "OSCProg", 28)
			Try
				IELoad(ie)
			Try Menu, Tray, Icon, %ResDllPath%, 46
			ChangeProgBarColor("20D000", "OSCProg", 28)
		}
	return

	pb_COMInterface:
		If (Target != "")
		{
			If (!IsObject(%Action%))
				%Action% := ComObjCreate(Target)
		}
	pb_Expression:
		Step := GetRealLineFeeds(Step)
	,	Step := StrReplace(Step, "`n", ",")
	,	Eval(Step, CustomVars)
		
		If (Window = "LoadWait")
		{
			Try Menu, Tray, Icon, %ResDllPath%, 77
			ChangeProgBarColor("Blue", "OSCProg", 28)
			Try
				IELoad(%Action%)
			Try Menu, Tray, Icon, %ResDllPath%, 46
			ChangeProgBarColor("20D000", "OSCProg", 28)
		}
	return
}

SplitStep(CustomVars, Step)
{
	local Pars := [], LoopField, _Step, _key, _value, _each, _par, _elements, pd
	If (InStr(FileCmdList, Type "|"))
		Step := StrReplace(Step, "````,", _x)
	Step := StrReplace(Step, "%A_Space%", _y)
,	Step := StrReplace(Step, "%A_Tab%", _z)
,	EscCom(true, Step)
,	Step := StrReplace(Step, "``,", _x)
,	Step := StrReplace(Step, "``a", "`a")
,	Step := StrReplace(Step, "``b", "`b")
,	Step := StrReplace(Step, "``f", "`f")
,	Step := StrReplace(Step, "``n", "`n")
,	Step := StrReplace(Step, "``r", "`r")
,	Step := StrReplace(Step, "``t", "`t")
,	Step := StrReplace(Step, "``v", "`v")
,	Step := StrReplace(Step, "``%", "%")
,	Step := StrReplace(Step, "``;", ";")
,	Step := StrReplace(Step, "``::", "::")
,	Step := StrReplace(Step, "````", "``")
,	Pars := GetPars(Step)
	For, _each, _par in Pars
	{
		_par := StrReplace(_par, _x, ",")
	,	_par := StrReplace(_par, _y, A_Space)
	,	_par := StrReplace(_par, _z, A_Tab)
		If ((InStr(Type, "String") = 1) || (Type = "SplitPath"))
		{
			For _key, _value in CustomVars
				If (_par = _key)
					_par := _value
		}
		Pars[A_Index] := _par
	}
	return Pars
}

IfEval(_Name, _Operator, _Value)
{
	If (_Operator = "=")
		result := (_Name = _Value) ? true : false
	Else If (_Operator = "==")
		result := (_Name == _Value) ? true : false
	Else If ((_Operator = "!=") || (_Operator = "<>"))
		result := (_Name != _Value) ? true : false
	Else If (_Operator = ">")
		result := (_Name > _Value) ? true : false
	Else If (_Operator = "<")
		result := (_Name < _Value) ? true : false
	Else If (_Operator = ">=")
		result := (_Name >= _Value) ? true : false
	Else If (_Operator = "<=")
		result := (_Name <= _Value) ? true : false
	Else If (_Operator = "in")
	{
		If _Name in %_Value%
			result := true
		Else
			result := false
	}
	Else If (_Operator = "not in")
	{
		If _Name not in %_Value%
			result := true
		Else
			result := false
	}
	Else If (_Operator = "contains")
	{
		If _Name contains %_Value%
			result := true
		Else
			result := false
	}
	Else If (_Operator = "not contains")
	{
		If _Name not contains %_Value%
			result := true
		Else
			result := false
	}
	Else If (_Operator = "between")
	{
		_Val1 := "", _Val2 := ""
		StringSplit, _Val, _Value, `n, %A_Space%%A_Tab%
		If _Name between %_Val1% and %_Val2%
			result := true
		Else
			result := false
	}
	Else If (_Operator = "not between")
	{
		_Val1 := "", _Val2 := ""
		StringSplit, _Val, _Value, `n, %A_Space%%A_Tab%
		If _Name not between %_Val1% and %_Val2%
			result := true
		Else
			result := false
	}
	Else If (_Operator = "is")
	{
		If _Name is %_Value%
			result := true
		Else
			result := false
	}
	Else If (_Operator = "is not")
	{
		If _Name is not %_Value%
			result := true
		Else
			result := false
	}
	return result
}

DoAction(X, Y, Action1, Action2, Error)
{
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
	If (Error)
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

IfStatement(ThisError, CustomVars, Action, Step, TimesX, DelayX, Type, Target, Window, Flow)
{
	local Pars, VarName, Oper, VarValue, lMatch, Win, ClipContents
	
	If (Step = "EndIf")
		return ThisError < 1 ? 0 : --ThisError
	If ((Flow.Break > 0) || (Flow.Continue > 0))
		return ThisError
	If (Action = "[Else]")
	{
		If (ThisError = 1)
			return 0
		Else If (ThisError = 0)
			return 1
		Else
			return ThisError
	}
	If (InStr(Action, "[ElseIf]"))
	{
		If ((ThisError = 0) || (ThisError = -1))
			return -1
		If (ThisError = 1)
			ThisError := 0
		Action := SubStr(Action, 10)
	}
	If (ThisError > 0)
		return ++ThisError
	If (ThisError = -1)
		return -1
	Tooltip
	CheckVars(CustomVars, Step, Target, Window)
,	EscCom(true, Step, Target, Window)
,	Step := StrReplace(Step, _z, A_Space)
,	Target := StrReplace(Target, _z, A_Space)
,	Window := StrReplace(Window, _z, A_Space)
,	Win := SplitWin(Step)
	If (Action = If1)
	{
		IfWinActive, % Win[1], % Win[2], % Win[3], % Win[4]
			return 0
	}
	Else If (Action = If2)
	{
		IfWinNotActive, % Win[1], % Win[2], % Win[3], % Win[4]
			return 0
	}
	Else If (Action = If3)
	{
		IfWinExist, % Win[1], % Win[2], % Win[3], % Win[4]
			return 0
	}
	Else If (Action = If4)
	{
		IfWinNotExist, % Win[1], % Win[2], % Win[3], % Win[4]
			return 0
	}
	Else If (Action = If5)
	{
		IfExist, %Step%
			return 0
	}
	Else If (Action = If6)
	{
		IfNotExist, %Step%
			return 0
	}
	Else If (Action = If7)
	{
		Try ClipContents := Clipboard
		If (ClipContents = Step)
			return 0
	}
	Else If (Action = If8)
	{
		If (CustomVars["A_Index"] = Step)
			return 0
	}
	Else If (Action = If9)
	{
		If (SearchResult = 0)
			return 0
	}
	Else If (Action = If10)
	{
		If (SearchResult != 0)
			return 0
	}
	Else If (Action = If11)
	{
		Pars := SplitStep(CustomVars, Step)
		For _each, _value in Pars
		{
			CheckVars(CustomVars, _value)
		,	Pars[_each] := _value
		}
		CheckVars(CustomVars, TimesX, DelayX)
		If (CustomVars.HasKey(Pars[1]))
			VarName := CustomVars[Pars[1]]
		Else
			VarName := Pars[1], VarName := %VarName%
		If (InStr(VarName, Pars[2]))
			return 0
	}
	Else If (Action = If12)
	{
		Pars := SplitStep(CustomVars, Step)
		For _each, _value in Pars
		{
			CheckVars(CustomVars, _value)
		,	Pars[_each] := _value
		}
		CheckVars(CustomVars, TimesX, DelayX)
		If (CustomVars.HasKey(Pars[1]))
			VarName := CustomVars[Pars[1]]
		Else
			VarName := Pars[1], VarName := %VarName%
		If (!InStr(VarName, Pars[2]))
			return 0
	}
	Else If (Action = If13)
	{
		IfMsgBox, %Step%
			return 0
	}
	Else If (Action = If14)
	{
		CompareParse(Step, VarName, Oper, VarValue)
	,	CheckVars(CustomVars, VarName, VarValue)
	,	EscCom(true, VarValue)
		If (CustomVars.HasKey(VarName))
			VarName := CustomVars[VarName]
		Else
			VarName := %VarName%
		VarValue := StrReplace(VarValue, "``n", "`n")
		If (IfEval(VarName, Oper, VarValue))
			return 0
	}
	Else If (Action = If15)
	{
		EvalResult := Eval(Step, CustomVars)
		If (EvalResult[1])
			return 0
	}
	return 1
}

class WaitFor
{
	Key(Key, Delay := 0)
	{
		global StopIt
		
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
			return
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
	Static _w := Chr(2), _x := Chr(3), _y := Chr(4), _z := Chr(5)
	
	WinPars := []
	Window := StrReplace(Window, "``,", _x)
	Loop, Parse, Window, `,, %A_Space%
	{
		LoopField := StrReplace(A_LoopField, _x, ",")
		WinPars.Push(LoopField)
	}
	return WinPars
}

AssignVar(_Name, _Operator, _Value, CustomVars, RunningFunction)
{
	local _content, _ObjItems
	
	If (_Name == "_null")
		return
	
	If (!IsObject(_Value))
	{
		_Value := StrReplace(_Value, _z, A_Space)
		If (_Name = "Clipboard")
			_Value := StrReplace(_Value, "````,", ",")
	}
	
	Try _content := %_Name%
	
	While (RegExMatch(_Name, "(\w+)(\[\S+\]|\.\w+)+", lFound))
	{
		If lFound1 is Number
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
	
	Try SavedVars(_Name,,, RunningFunction)
}

CheckVars(CustomVars, ByRef CheckVar1 := "", ByRef CheckVar2 := "", ByRef CheckVar3 := "", ByRef CheckVar4 := "", ByRef CheckVar5 := "")
{
	global d_Lang007, d_Lang035, d_Lang065, d_Lang066, d_Lang088, StopIt
	Loop, 5
	{
		If (!IsByRef(CheckVar%A_Index%))
			continue
		EscCom(true, CheckVar%A_Index%), _i := A_Index
	,	CheckVar%A_Index% := StrReplace(CheckVar%A_Index%, "``a", "`a")
	,	CheckVar%A_Index% := StrReplace(CheckVar%A_Index%, "``b", "`b")
	,	CheckVar%A_Index% := StrReplace(CheckVar%A_Index%, "``f", "`f")
	,	CheckVar%A_Index% := StrReplace(CheckVar%A_Index%, "``n", "`n")
	,	CheckVar%A_Index% := StrReplace(CheckVar%A_Index%, "``r", "`r")
	,	CheckVar%A_Index% := StrReplace(CheckVar%A_Index%, "``t", "`t")
	,	CheckVar%A_Index% := StrReplace(CheckVar%A_Index%, "``v", "`v")
	,	CheckVar%A_Index% := StrReplace(CheckVar%A_Index%, "``%", "%")
	,	CheckVar%A_Index% := StrReplace(CheckVar%A_Index%, "``;", ";")
	,	CheckVar%A_Index% := StrReplace(CheckVar%A_Index%, "``::", "::")
	,	CheckVar%A_Index% := StrReplace(CheckVar%A_Index%, "````", "``")
		If (RegExMatch(CheckVar%_i%, "sU)^\s*%\s+(.+)$", lMatch))  ; Expressions
		{
			Try
				EvalResult := Eval(lMatch1, CustomVars), CheckVar%_i% := EvalResult[1]
			Catch e
			{
				If (!HideErrors)
				{
					MsgBox, 20, %d_Lang007%, % "Macro" Macro_On ", " d_Lang065 " " mListRow
						.	"`n" d_Lang007 ":`t`t" e.Message "`n" d_Lang066 ":`t" (InStr(e.Message, "0x800401E3") ? d_Lang088 : e.Extra) "`n`n" d_Lang035
					IfMsgBox, No
					{
						StopIt := 1
						continue
					}
				}
			}
			continue
		}
		For _key, _value in CustomVars
		{
			While (RegExMatch(CheckVar%_i%, "i)%" _key "%", lMatch))
				CheckVar%_i% := RegExReplace(CheckVar%_i%, "U)" lMatch, _value)
		}
		CheckVar%_i% := DerefVars(CheckVar%_i%)
	,	EscCom(true, CheckVar%_i%)
	,	CheckVar%_i% := StrReplace(CheckVar%_i%, "``a", "`a")
	,	CheckVar%_i% := StrReplace(CheckVar%_i%, "``b", "`b")
	,	CheckVar%_i% := StrReplace(CheckVar%_i%, "``f", "`f")
	,	CheckVar%_i% := StrReplace(CheckVar%_i%, "``n", "`n")
	,	CheckVar%_i% := StrReplace(CheckVar%_i%, "``r", "`r")
	,	CheckVar%_i% := StrReplace(CheckVar%_i%, "``t", "`t")
	,	CheckVar%_i% := StrReplace(CheckVar%_i%, "``v", "`v")
	,	CheckVar%_i% := StrReplace(CheckVar%_i%, "``%", "%")
	,	CheckVar%_i% := StrReplace(CheckVar%_i%, "``;", ";")
	,	CheckVar%_i% := StrReplace(CheckVar%_i%, "``::", "::")
	,	CheckVar%_i% := StrReplace(CheckVar%_i%, "````", "``")
	}
}

DerefVars(v_String)
{
	global
	
	v_String := StrReplace(v_String, "%A_Space%", "%_z%")
,	v_String := StrReplace(v_String, "``%", _w)
	While (RegExMatch(v_String, "%(\w+)%", rMatch))
	{
		FoundVar := StrReplace(%rMatch1%, "%", _w)
	,	FoundVar := StrReplace(FoundVar, ",", "``,")
	,	v_String := StrReplace(v_String, rMatch, FoundVar)
	}
	return StrReplace(v_String, _w, "%")
}

ExprGetPars(Expr)
{
	Expr := RegExReplace(Expr, "\[.*?\]", "[A]")
,	Expr := RegExReplace(Expr, "\(([^()]++|(?R))*\)", "[P]")
,	Expr := RegExReplace(Expr, """.*?""", "[T]")
,	ExprPars := StrSplit(Expr, ",", " `t")
	return ExprPars
}
