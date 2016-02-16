;###########################################################
; Original by PhiLho
; Modified by skwire
; http://www.autohotkey.com/board/topic/11926-can-you-move-a-listview-column-programmatically/#entry237340
;###########################################################
LVOrder_Set(_Num_Of_Columns, _New_Column_Order, _lvID, Delim := ",")
{
	Static LVM_FIRST               := 0x1000
	Static LVM_REDRAWITEMS         := 21
	Static LVM_SETCOLUMNORDERARRAY := 58
	
	VarSetCapacity( colOrder, _Num_Of_Columns * 4, 0 )
	
	Loop, Parse, _New_Column_Order, %Delim%
	{
		pos := A_Index - 1
		NumPut( A_LoopField - 1, colOrder, pos * 4, "UInt" )
	}
	
	SendMessage, LVM_FIRST + LVM_SETCOLUMNORDERARRAY
			   , _Num_Of_Columns, &colOrder,, ahk_id %_lvID%   ; LVM_SETCOLUMNORDERARRAY
	
	SendMessage, LVM_FIRST + LVM_REDRAWITEMS		
			   , 0, _Num_Of_Columns - 1,, ahk_id %_lvID%   ; LVM_REDRAWITEMS
	
	VarSetCapacity( colOrder, 0 ) ; Clean up.
}


LVOrder_Get( _Num_Of_Columns, _lvID, Delim := "," )
{
	Static LVM_FIRST               := 0x1000
	Static LVM_GETCOLUMNORDERARRAY := 59

	Output := ""
	VarSetCapacity( colOrder, _Num_Of_Columns * 4, 0 )
	
	SendMessage, LVM_FIRST + LVM_GETCOLUMNORDERARRAY
			   , _Num_Of_Columns, &colOrder,, ahk_id %_lvID%   ; LVM_GETCOLUMNORDERARRAY

	Loop, % _Num_Of_Columns
	{
		pos := A_Index - 1
		Col := NumGet( colOrder, pos * 4, "UInt"  ) + 1 ; Array is zero-based so we add one.
		Output .= Col . Delim
	}
	StringTrimRight, Output, Output, 1 ; Trim trailing delimiter.
	VarSetCapacity( colOrder, 0 ) ; Clean up.
	Return, Output
}

