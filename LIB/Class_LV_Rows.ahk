;=======================================================================================
;
;                 Class LV_Rows
;
; Author:        Pulover [Rodolfo U. Batista]
;                rodolfoub@gmail.com
;
;                Additional functions for ListView controls
;=======================================================================================
;
; This class provides an easy way to add functionalities to ListViews that are not
;    supported by AutoHotkey built-in functions such as Copy, Cut, Paste, Drag and more.
;
;=======================================================================================
;
; Edit Functions:
;    Copy()
;    Cut()
;    Paste(Row=0)
;    Delete()
;    Move(Up=False)
;    Drag(DragButton="D", AutoScroll=True, ScrollDelay=100, LineThick=2, Color="Black")
;
; History Functions:
;    Add()
;    Undo()
;    Redo()
;
;=======================================================================================
;
; Usage:
;
;    You can call the function by preceding them with LV_Rows. For example:
;        LV_Rows.Copy()                   <-- Calls function on active ListView.
;
;    Or with a handle initialized via New meta-function. For example:
;        MyListHandle := New LV_Rows()    <-    Creates a new handle.
;        MyListHandle.Add()               <-    Calls function for that Handle.
;
;    Like AutoHotkey built-in functions, these functions operate on the default gui,
;        and active ListView control.
;
;    Initializing is only required for History functions, but you can also use the
;        same handle for the Edit functions or use different handles for extra
;        copy and paste actions keeping independent data in memory.
;
;    You may keep an individual history of each ListView using different handles.
;
;=======================================================================================

Class LV_Rows
{
;=======================================================================================
;    Meta-Functions
;
;    Properties:
;        ActiveSlot:    Contains the current entry position in the ListView History.
;        HasChanged:    The HasChanged property may optionally be used to check if the
;                            ListView has been changed. For this you must use a handle
;                            for all functions.
;                        Every time a function (except Copy) is called it will be set
;                            to True. The user may consult Handle.HasChanged to show
;                            a save dialog and set it to False after saving.
;=======================================================================================
    __New()
    {
        this.Slot := [], this.ActiveSlot := 1
    }

    __Call(Func)
    {
        global
        
        If (Func <> "Copy")
            SavePrompt := True
    }

    __Delete()
    {
        this.Remove("", Chr(255))
        this.SetCapacity(0)
        this.base := ""
    }
;=======================================================================================
;    Edit Functions:     Edit ListView rows.
;=======================================================================================
;    Function:           LV_Rows.Copy()
;    Description:        Copy selected rows to memory.
;    Return:             Number of copied rows.
;=======================================================================================
    Copy()
    {
        this.CopyData := {}, LV_Row := 0
        Loop
        {
            LV_Row := LV_GetNext(LV_Row)
            If !LV_Row
                break
            RowData := LV_Rows.RowText(LV_Row)
        ,   Row := [RowData*]
            this.CopyData.Insert(Row)
            CopiedLines++
        }
        return CopiedLines
    }
;=======================================================================================
;    Function:           LV_Rows.Cut()
;    Description:        Copy selected rows to memory and delete them.
;    Return:             Number of copied rows.
;=======================================================================================
    Cut()
    {
        this.CopyData := {}, LV_Row := 0
        Loop
        {
            LV_Row := LV_GetNext(LV_Row)
            If !LV_Row
                break
            RowData := LV_Rows.RowText(LV_Row)
        ,   Row := [RowData*]
            this.CopyData.Insert(Row)
            CopiedLines++
        }
        LV_Rows.Delete()
        return CopiedLines
    }
;=======================================================================================
;    Function:           LV_Rows.Paste()
;    Description:        Paste copied rows at selected position.
;    Parameters:
;        Row:            If non-zero pastes memory contents into the specified row.
;    Return:             True if memory contains data or False if not.
;=======================================================================================
    Paste(Row=0)
    {
        If !this.CopyData.MaxIndex()
            return False
        TargetRow := Row ? Row : LV_GetNext()
        If !TargetRow
        {
            For each, Row in this.CopyData
                LV_Add(Row*)
        }
        Else
        {
            LV_Row := TargetRow - 1
            For each, Row in this.CopyData
                LV_Insert(LV_Row+A_Index, Row*)
        }
        return True
    }
;=======================================================================================
;    Function:           LV_Rows.Delete()
;    Description:        Delete selected rows.
;    Return:             Number of removed rows.
;=======================================================================================
    Delete()
    {
        If (LV_GetCount("Selected") = 0)
            return False
        LV_Row := 0
        Loop
        {
            LV_Row := LV_GetNext(LV_Row - 1)
            If !LV_Row
                break
            LV_Delete(LV_Row)
            DeletedLines++
        }
        return DeletedLines
    }
;=======================================================================================
;    Function:           LV_Rows.Move()
;    Description:        Move selected rows down or up.
;    Parameters:
;        Up:             If False or omitted moves rows down. If True moves rows up.
;    Return:             Number of rows moved.
;=======================================================================================
    Move(Up=False)
    {
        Selections := [], LV_Row := 0
        Critical
        If Up
        {
            Loop
            {
                LV_Row := LV_GetNext(LV_Row)
                If !LV_Row
                    break
                If (LV_Row = 1)
                    return
                Selections.Insert(LV_Row)
            }
            For each, Row in Selections
            {
                RowData := LV_Rows.RowText(Row)
                LV_Insert(Row-1, RowData*)
                LV_Delete(Row+1)
                LV_Modify(Row-1, "Select")
                If (A_Index = 1)
                    LV_Modify(Row-1, "Focus Vis")
            }
            return Selections.MaxIndex()
        }
        Else
        {
            Loop
            {
                LV_Row := LV_GetNext(LV_Row)
                If !LV_Row
                    break
                If (LV_Row = LV_GetCount())
                    return
                Selections.Insert(1, LV_Row)
            }
            For each, Row in Selections
            {
                RowData := LV_Rows.RowText(Row+1)
                LV_Insert(Row, RowData*)
                LV_Delete(Row+2)
                If (A_Index = 1)
                    LV_Modify(Row+1, "Focus Vis")
            }
            return Selections.MaxIndex()
        }
    }
;=======================================================================================
;    Function:           LV_Rows.Drag()
;    Description:        Drag-and-Drop selected rows showing a destination bar.
;                            Must be called in the ListView G-Label subroutine when
;                            A_GuiEvent returns "D" or "d".
;    Parameters:
;        DragButton:     If it is a lower case "d" it will be recognized as a
;                            Right-Click drag, otherwise will be recognized as a
;                            Left-Click drag. You may pass A_GuiEvent as the parameter.
;        AutoScroll:     If True or omitted the ListView will automatically scroll
;                            up or down when the cursor is above or below the control.
;        ScrollDelay:    Delay in miliseconds for AutoScroll. Default is 100ms.
;        LineThick:      Thickness of the destination bar in pixels. Default is 2px.
;        Color:          Color of destination bar. Defalt is "Black".
;    Return:             The destination row number.
;=======================================================================================
    Drag(DragButton="D", AutoScroll=True, ScrollDelay=100, LineThick=2, Color="Black")
    {
        LVIR_LABEL := 0x0002
    ,   LVM_GETITEMCOUNT := 0x1004
    ,   LVM_SCROLL := 0x1014
    ,   LVM_GETTOPINDEX := 0x1027
    ,   LVM_GETCOUNTPERPAGE := 0x1028
    ,   LVM_GETSUBITEMRECT := 0x1038
    ,   LV_currColHeight := 0
        SysGet, SM_CXVSCROLL, 2

        If InStr(DragButton, "d", True)
            DragButton := "RButton"
        Else
            DragButton := "LButton"

        CoordMode, Mouse, Window
        MouseGetPos,,, LV_Win, LV_LView, 2
        WinGetPos, Win_X, Win_Y, Win_W, Win_H, ahk_id %LV_Win%
        ControlGetPos, LV_lx, LV_ly, LV_lw, LV_lh, , ahk_id %LV_LView%
        VarSetCapacity(LV_XYstruct, 4 * A_PtrSize, 0)

        While, GetKeyState(DragButton, "P")
        {
            MouseGetPos, LV_mx, LV_my,, CurrCtrl, 2
            LV_mx -= LV_lx, LV_my -= LV_ly

            If (AutoScroll)
            {
                If (LV_my < 0)
                {
                    SendMessage, LVM_SCROLL, 0, -LV_currColHeight, , ahk_id %LV_LView%
                    Sleep, %ScrollDelay%
                }
                If (LV_my > LV_lh)
                {
                    SendMessage, LVM_SCROLL, 0, LV_currColHeight, , ahk_id %LV_LView%
                    Sleep, %ScrollDelay%
                }
            }

            If (CurrCtrl <> LV_LView)
            {
                LV_currRow := ""
                Gui, MarkLine:Cancel
                continue
            }

            SendMessage, LVM_GETITEMCOUNT, 0, 0, , ahk_id %LV_LView%
            LV_TotalNumOfRows := ErrorLevel
            SendMessage, LVM_GETCOUNTPERPAGE, 0, 0, , ahk_id %LV_LView%
            LV_NumOfRows := ErrorLevel
            SendMessage, LVM_GETTOPINDEX, 0, 0, , ahk_id %LV_LView%
        ,   LV_topIndex := ErrorLevel
            Line_W := (LV_TotalNumOfRows > LV_NumOfRows) ? LV_lw - SM_CXVSCROLL : LV_lw

            Loop, % LV_NumOfRows + 1
            {    
                LV_which := LV_topIndex + A_Index - 1
                NumPut(LVIR_LABEL, LV_XYstruct, 0, "UInt")
                NumPut(A_Index - 1, LV_XYstruct, 4, "UInt")
                SendMessage, LVM_GETSUBITEMRECT, %LV_which%, &LV_XYstruct, , ahk_id %LV_LView%
                LV_RowY := NumGet(LV_XYstruct, 4, "UInt")
            ,   LV_RowY2 := NumGet(LV_XYstruct, 12, "UInt")
            ,   LV_currColHeight := LV_RowY2 - LV_RowY
                If(LV_my <= LV_RowY + LV_currColHeight)
                {    
                    LV_currRow  := LV_which + 1
            ,       LV_currRow0 := LV_which
            ,       Line_Y := Win_Y + LV_ly + LV_RowY
            ,       Line_X := Win_X + LV_lx
                    If (LV_currRow > (LV_TotalNumOfRows+1))
                    {
                        Gui, MarkLine:Cancel
                        LV_currRow := ""
                    }
                    Break
                }
            }

            If LV_currRow
            {
                Gui, MarkLine:Color, %Color%
                Gui, MarkLine:+LastFound +AlwaysOnTop +Toolwindow -Caption +HwndLineMark
                Gui, MarkLine:Show, W%Line_W% H%LineThick% Y%Line_Y% X%Line_X% NoActivate
            }
        }
        Gui, MarkLine:Cancel

        If LV_currRow
        {
            DragRows := new LV_Rows()
        ,   Lines := DragRows.Copy()
            DragRows.Paste(LV_currRow)
            If (LV_GetNext() < LV_currRow)
                o := Lines+1, FocusedRow := LV_currRow-1
            Else
                o := 1, FocusedRow := LV_currRow
            DragRows.Delete()
            DragRows := ""
            Loop, %Lines%
            {
                i := A_Index-o
                LV_Modify(LV_currRow+i, "Select")
            }
            LV_Modify(FocusedRow, "Focus")
        }
        return LV_currRow
    }
;=======================================================================================
;    History Functions:  Keep a history of ListView changes and allow Undo and Redo.
;=======================================================================================
;    Function:           Handle.Add()
;    Description:        Adds an entry on History. This function requires
;                            initializing: MyListHandle := New LV_Rows()
;    Return:             The total number of entries in history.
;=======================================================================================
    Add()
    {
        Row := []
        If (this.ActiveSlot < this.Slot.MaxIndex())
            this.Slot.Remove(this.ActiveSlot+1, this.Slot.MaxIndex())
        Loop, % LV_GetCount()
        {
            RowData := LV_Rows.RowText(A_Index)
        ,   Row[A_Index] := [RowData*]
        }
        this.Slot.Insert(Row)
        this.ActiveSlot := this.Slot.MaxIndex()
        return this.Slot.MaxIndex()
    }
;=======================================================================================
;    Function:           Handle.Undo()
;    Description:        Replaces ListView contents with previous entry state, if any.
;    Return:             Current entry position.
;=======================================================================================
    Undo()
    {
        If (this.ActiveSlot = 1)
            return this.ActiveSlot
        this.ActiveSlot -= 1
        this.Load(this.ActiveSlot)
        return this.ActiveSlot
    }
;=======================================================================================
;    Function:           Handle.Redo()
;    Description:        Replaces ListView contents with next entry state, if any.
;    Return:             Current entry position.
;=======================================================================================
    Redo()
    {
        If (this.ActiveSlot = (this.Slot.MaxIndex()))
            return this.ActiveSlot
        this.ActiveSlot += 1
        this.Load(this.ActiveSlot)
        return this.ActiveSlot
    }
;=======================================================================================
;    Internal Functions: These functions are meant for internal use but can also
;                            be called if necessary.
;=======================================================================================
;    Function:           Handle.Load()
;    Description:        Loads a specified entry in History into ListView.
;    Parameters:
;        Number:         Number of entry position to be loaded.
;    Return:             True if entry exists, False otherwise.
;=======================================================================================
    Load(Number)
    {
        If !IsObject(this.Slot[Number])
            return False

        LV_Delete()
        For each, Row in this.Slot[Number]
            LV_Add(Row*)
        return True
    }
;=======================================================================================
;    Function:           LV_Rows.RowText()
;    Description:        Creates an Array of values from each cell in a specified row.
;    Parameters:
;        Index:          Index of the row to get contents from.
;    Return:             An Array with text from the cells and the row checked status.
;=======================================================================================
    RowText(Index)
    {
        Data := []
    ,   ckd := (LV_GetNext(Index-1, "Checked")=Index) ? 1 : 0
        Data.Insert("Check" ckd)
        Loop, % LV_GetCount("Col")
        {
            LV_GetText(Cell, Index, A_Index)
            Data.Insert(Cell)
        }
        return Data
    }
}
