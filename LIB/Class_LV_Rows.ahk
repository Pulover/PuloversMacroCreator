;=======================================================================================
;
;                    Class LV_Rows
;
; Author:            Pulover [Rodolfo U. Batista]
; AHK version:       1.1.23.01
;
;                    Additional functions for ListView controls
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
;    Paste([Row, Multiline])
;    Duplicate()
;    Delete()
;    Move([Up])
;    Drag([DragButton, AutoScroll, ScrollDelay, LineThick, Color])
;
; History Functions:
;    Add()
;    Undo()
;    Redo()
;    ClearHistory()
;
; Group Functions:
;    EnableGroups([Enable, FirstName, Collapsible, StartCollapsed])
;    InsertGroup([Row, GroupName])
;    RemoveGroup([Row])
;    InsertAtGroup([Count, Rows*])
;    RemoveAtGroup([Count, Rows*])
;    SetGroups(Groups)
;    GetGroups([AsObject])
;    SetGroupCollapisable([Collapsible])
;    RemoveAllGroups([FirstName])
;    CollapseAll([Collapse])
;    RefreshGroups([Collapsed])
;
; Management Functions:
;    InsertHwnd(Hwnd)
;    RemoveHwnd(Hwnd)
;    SetHwnd(Hwnd [, NewData])
;    GetData([Hwnd])
;    SetCallback(Func)
;
;=======================================================================================
;
; Usage:
;
;    You can call the function by preceding them with LV_Rows. For example:
;        LV_Rows.Copy()                     <--   Calls function on active ListView.
;
;    Or with a handle initialized via New meta-function. For example:
;        MyListHandle := New LV_Rows()      <--   Creates a new handle.
;        MyListHandle.Add()                 <--   Calls function for that Handle.
;
;    Like AutoHotkey built-in functions, these functions operate on the default gui,
;        and active ListView control. When usingle handles, SetHwnd will attempt to set
;        the selected ListView as active, but it's recommend to call Gui, Listview on
;        your script too.
;
;    Initializing is required for History and Group functions and in case your ListView
;        has icons to be moved during Drag().
;        Gui, Add, ListView, hwndhLV, Columns
;        MyListHandle := New LV_Rows(hLV)  <--   Creates a new handle with Hwnd.
;
;        Gui, Add, ListView, hwndhLV1, Columns
;        Gui, Add, ListView, hwndhLV2, Columns
;        MyListHandle := New LV_Rows(hLV1, hLV2)
;
;        You can also use the same handle for the Edit functions.
;        You can create more handles or pass the ListView's Hwnd to operate on different
;        lists with the same handle.
;
;    In order to keep row's icons you need to initialize the class passing the
;        ListView's Hwnd. For example:
;        Gui, Add, ListView, hwndhLV, Columns
;        MyListHandle := New LV_Rows(hLV)
;
;=======================================================================================
Class LV_Rows extends LV_Rows.LV_EX
{
;=======================================================================================
;    Meta-Functions     Pass the Hwnd of one or more Listiviews when initializing it to
;                            manage history, groups and keep row's icons during Drag().
;                       Use InsertHwnd() to add more lists and SetHwnd() to switch between them.
;
;    Properties:
;        ActiveSlot:    Contains the current entry position in the ListView History.
;        HasChanged:    The HasChanged property may optionally be used to check if the
;                            ListView has been changed. For this you must use a handle
;                            for all functions.
;                        Every time a function (except Copy) is called it will be set
;                            to true. The user may consult Handle.HasChanged to show
;                            a save dialog and set it to False after saving.
;=======================================================================================
    __New(Hwnd*)
    {
        this.hArray := {}
        If (Hwnd.Length())
        {
            For e, h in Hwnd
            {
                this.hArray[h] := { Hwnd: h
                                  , GroupsArray: []
                                  , Slot: []
                                  , ActiveSlot: 1}
            ,   this.hArray[h].GroupsArray.Push({Name: "Start", Row: 1})
            }
            this.LVHwnd := this.hArray[Hwnd[1]].Hwnd
        ,   this.Handle := this.hArray[Hwnd[1]]
        }
        Else
        {
            this.hArray["default"] := { Hwnd: ""
                                      , GroupsArray: []
                                      , Slot: []
                                      , ActiveSlot: 1}
        ,   this.Handle := this.hArray["default"]
        ,   this.Handle.GroupsArray.Push({Name: "Start", Row: 1})
        }
    }

    __Call(Func)
    {        
        Callback := this.Callback
        If (IsFunc(Callback))
        {
            If (!%Callback%(Func, this.LVHwnd))
                return
        }
        
        If Func in Cut,Paste,Duplicate,Delete,Move,Drag,Undo,Redo
            this.HasChanged := true
    }

    __Delete()
    {
        this.RemoveAt(1, this.Length())
    ,   this.SetCapacity(0)
    ,   this.base := ""
    }
;=======================================================================================
;    Management Functions: Set, Insert and Remove ListView Hwnd's.
;=======================================================================================
;    Function:           Handle.InsertHwnd()
;    Description:        Inserts one or more ListView Hwnd's to be managed.
;    Parameters:
;        Hwnd:           One or more ListView Hwnd's.
;    Return:             No return value.
;=======================================================================================
    InsertHwnd(Hwnd*)
    {
        If (Hwnd.Length())
        {
            For e, h in Hwnd
            {
                If (this.hArray.HasKey(h))
                    continue
                this.hArray[h] := { Hwnd: h
                                  , GroupsArray: []
                                  , Slot: []
                                  , ActiveSlot: 1}
            ,   this.hArray[h].GroupsArray.Push({Name: "Start", Row: 1})
            }
        }
    }
;=======================================================================================
;    Function:           Handle.RemoveHwnd()
;    Description:        Removes a ListView Hwnd.
;    Parameters:
;        Hwnd:           Hwnd of the ListView to be removed.
;    Return:             No return value.
;=======================================================================================
    RemoveHwnd(Hwnd)
    {
        If (this.hArray.HasKey(Hwnd))
        {
            this.hArray[Hwnd].RemoveAt(1, this.Length())
        ,   this.hArray[Hwnd].SetCapacity(0)
        ,   this.hArray[Hwnd].base := ""
        }
    }
;=======================================================================================
;    Function:           Handle.SetHwnd()
;    Description:        Selects a previously inserted ListView or adds it to the handle
;                            and selects it, optionally copying the data, history and
;                            groups from another Hwnd.
;    Parameters:
;        Hwnd:           Hwnd of a ListView to be selected. If the hwnd is not found, it
;                            will be added to the handle and selected.
;        NewData:        Hwnd of a previously inserted ListView whose data, history and groups
;                            will be copied to the one being selected.
;    Return:             No return value.
;=======================================================================================
    SetHwnd(Hwnd, NewData := "")
    {
        If (this.hArray.HasKey(Hwnd))
        {
            this.LVHwnd := this.hArray[Hwnd].Hwnd
        ,   this.Handle := this.hArray[Hwnd]
            Gui, Listview, % this.LVHwnd
        
            If (NewData != "")
            {
                If (IsObject(NewData))
                {
                    this.hArray[Hwnd].GroupsArray := NewData.GroupsArray
                ,   this.hArray[Hwnd].Slot := NewData.Slot
                ,   this.hArray[Hwnd].ActiveSlot := NewData.ActiveSlot
                ,   this.Load()
                }
                Else If (this.hArray.HasKey(NewData))
                {
                    this.hArray[Hwnd].GroupsArray := this.hArray[NewData].GroupsArray.Clone()
                ,   this.hArray[Hwnd].Slot := this.hArray[NewData].Slot.Clone()
                ,   this.hArray[Hwnd].ActiveSlot := this.hArray[NewData].ActiveSlot
                ,   this.Load()
                }
            }
            return
        }
        
        this.hArray[Hwnd] := { Hwnd: Hwnd
                             , GroupsArray: []
                             , Slot: []
                             , ActiveSlot: 1}
        this.LVHwnd := Hwnd
    ,   this.Handle := this.hArray[Hwnd]
    ,   this.Handle.GroupsArray.Push({Name: "Start", Row: 1})
        Gui, Listview, % this.LVHwnd
        
        If (NewData != "")
        {
            If (IsObject(NewData))
            {
                this.hArray[Hwnd].GroupsArray := NewData.GroupsArray
            ,   this.hArray[Hwnd].Slot := NewData.Slot
            ,   this.hArray[Hwnd].ActiveSlot := NewData.ActiveSlot
            ,   this.Load()
            }
            Else If (this.hArray.HasKey(NewData))
            {
                this.hArray[Hwnd].GroupsArray := this.hArray[NewData].GroupsArray.Clone()
            ,   this.hArray[Hwnd].Slot := this.hArray[NewData].Slot.Clone()
            ,   this.hArray[Hwnd].ActiveSlot := this.hArray[NewData].ActiveSlot
            ,   this.Load()
            }
        }
    }
;=======================================================================================
;    Function:           Handle.GetData()
;    Description:        Retrieves the data, history and groups of a previously inserted
;                            ListView.
;    Parameters:
;        Hwnd:           Hwnd of a previously inserted ListView. If left blank, the
;                            current active ListView will be returned.
;    Return:             An object with data, history and groups of a ListView.
;=======================================================================================
    GetData(Hwnd := "")
    {
        If (Hwnd = "")
            Hwnd := this.LVHwnd
        If (this.hArray.HasKey(Hwnd))
            return this.hArray[Hwnd].Clone()
    }
;=======================================================================================
;    Function:           LV_Rows.SetCallback()
;    Description:        Sets a callback function where the user can take actions based
;                            on the function being called called. The Callback function
;                            must return true for the operation to be completed.
;    Parameters:
;        Func:           Name of a user-defined function that should receive 2 parameters:
;                            The name of the function being called and the Hwnd of the
;                            current set ListView.
;    Return:             No return value.
;=======================================================================================
    SetCallback(Func)
    {
        this.Callback := Func
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
        this.CopyData := [], LV_Row := 0
        Loop
        {
            LV_Row := LV_GetNext(LV_Row)
            If (!LV_Row)
                break
            RowData := this.RowText(LV_Row)
        ,   Row := [RowData*]
        ,   this.CopyData.Push(Row)
        ,   CopiedLines := A_Index
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
        this.CopyData := [], LV_Row := 0
        Loop
        {
            LV_Row := LV_GetNext(LV_Row)
            If (!LV_Row)
                break
            RowData := this.RowText(LV_Row)
        ,   Row := [RowData*]
        ,   this.CopyData.Push(Row)
        ,   CopiedLines := A_Index
        }
        this.Delete()
        this.RefreshGroups()
        return CopiedLines
    }
;=======================================================================================
;    Function:           LV_Rows.Paste()
;    Description:        Paste copied rows at selected position.
;    Parameters:
;        Row:            If non-zero pastes memory contents at the specified row.
;        Multiline:      If true pastes the contents at every selected row.
;    Return:             True if memory contains data or false if not.
;=======================================================================================
    Paste(Row := 0, Multiline := false)
    {
        If (!this.CopyData.Length())
            return false
        TargetRow := Row ? Row : LV_GetNext()
        If (!TargetRow)
        {
            For each, Row in this.CopyData
                LV_Add(Row*)
        }
        Else
        {
            If ((!Row) && (Multiline))
            {
                LV_Row := 0
                Loop
                {
                    LV_Row := LV_GetNext(LV_Row - 1)
                    If (!LV_Row)
                        break
                    For e, g in this.Handle.GroupsArray
                    {
                        If ((g.Row > 1) && (LV_Row < g.Row))
                            g.Row += this.CopyData.Length()
                    }
                    For each, Row in this.CopyData
                        LV_Insert(LV_Row, Row*), LV_Row += 1
                    LV_Row += 1
                }
            }
            Else
            {
                LV_Row := TargetRow - 1
                For e, g in this.Handle.GroupsArray
                {
                    If ((g.Row > 1) && ((LV_Row+1) < g.Row))
                        g.Row += this.CopyData.Length()
                }
                For each, Row in this.CopyData
                    LV_Insert(LV_Row+A_Index, Row*)
            }
        }
        this.RefreshGroups()
        return true
    }
;=======================================================================================
;    Function:           LV_Rows.Duplicate()
;    Description:        Duplicates selected rows.
;    Return:             Number of duplicated rows.
;=======================================================================================
    Duplicate()
    {
        CopyData := this.CopyData.Clone()
    ,   DupLines := this.Copy()
    ,   this.Paste()
    ,   this.CopyData := CopyData.Clone()
    ,   CopyData.RemoveAt(1, CopyData.Length())
    ,   CopyData := ""
    ,   this.RefreshGroups()
        return DupLines
    }
;=======================================================================================
;    Function:           LV_Rows.Delete()
;    Description:        Delete selected rows.
;    Return:             Number of removed rows.
;=======================================================================================
    Delete()
    {
        If (LV_GetCount("Selected") = 0)
            return false
        LV_Row := 0
        Loop
        {
            LV_Row := LV_GetNext(LV_Row - 1)
            If (!LV_Row)
                break
            LV_Delete(LV_Row)
        ,   DeletedLines := A_Index
            For e, g in this.Handle.GroupsArray
            {
                If ((g.Row > 1) && (LV_Row < g.Row))
                    g.Row--
            }
        }
        this.RefreshGroups()
        return DeletedLines
    }
;=======================================================================================
;    Function:           LV_Rows.Move()
;    Description:        Move selected rows down or up.
;    Parameters:
;        Up:             If false or omitted moves rows down. If true moves rows up.
;    Return:             Number of rows moved.
;=======================================================================================
    Move(Up := false)
    {
        Selections := [], LV_Row := 0
        Critical
        If (Up)
        {
            Loop
            {
                LV_Row := LV_GetNext(LV_Row)
                If (!LV_Row)
                    break
                If (LV_Row = 1)
                    return
                Selections.Push(LV_Row)
            }
            For each, Row in Selections
            {
                RowData := this.RowText(Row)
            ,   LV_Insert(Row-1, RowData*)
            ,   LV_Delete(Row+1)
            ,   LV_Modify(Row-1, "Select")
                If (A_Index = 1)
                    LV_Modify(Row-1, "Focus Vis")
            }
            this.RefreshGroups()
            return Selections.Length()
        }
        Else
        {
            Loop
            {
                LV_Row := LV_GetNext(LV_Row)
                If (!LV_Row)
                    break
                If (LV_Row = LV_GetCount())
                    return
                Selections.InsertAt(1, LV_Row)
            }
            For each, Row in Selections
            {
                RowData := this.RowText(Row+1)
            ,   LV_Insert(Row, RowData*)
            ,   LV_Delete(Row+2)
                If (A_Index = 1)
                    LV_Modify(Row+1, "Focus Vis")
            }
            this.RefreshGroups()
            return Selections.Length()
        }
    }
;=======================================================================================
;    Function:           LV_Rows.Drag()
;    Description:        Drag-and-Drop selected rows showing a destination bar.
;                            Must be called in the ListView G-Label subroutine when
;                            A_GuiEvent returns "D" or "d".
;    Parameters:
;        DragButton:     If it is a lower case "d" it will be recognized as a Right-Click
;                            drag and won't actually move any row, only return the
;                            destination, otherwise it will be recognized as a Left-Click
;                            drag. You may pass A_GuiEvent as the parameter.
;        AutoScroll:     If true or omitted the ListView will automatically scroll
;                            up or down when the cursor is above or below the control.
;        ScrollDelay:    Delay in miliseconds for AutoScroll. Default is 100ms.
;        LineThick:      Thickness of the destination bar in pixels. Default is 2px.
;        Color:          Color of destination bar. Default is "Black".
;    Return:             The destination row number.
;=======================================================================================
    Drag(DragButton := "D", AutoScroll := true, ScrollDelay := 100, LineThick := 2, Color := "Black")
    {
        Static LVIR_LABEL          := 0x0002
        Static LVM_GETITEMCOUNT    := 0x1004
        Static LVM_SCROLL          := 0x1014
        Static LVM_GETTOPINDEX     := 0x1027
        Static LVM_GETCOUNTPERPAGE := 0x1028
        Static LVM_GETSUBITEMRECT  := 0x1038
        Static LV_currColHeight    := 0
        RestoreGroups := false

        If (this.IsGroupViewEnabled())
        {
            RestoreGroups := true
        ,   this.EnableGroupView(false)
        }
        
        SysGet, SM_CXVSCROLL, 2

        If (InStr(DragButton, "d", true))
            DragButton := "RButton"
        Else
            DragButton := "LButton"

        CoordMode, Mouse, Window
        MouseGetPos,,, LV_Win, LV_LView, 2
        WinGetPos, Win_X, Win_Y, Win_W, Win_H, ahk_id %LV_Win%
        ControlGetPos, LV_lx, LV_ly, LV_lw, LV_lh, , ahk_id %LV_LView%
        LV_lw := LV_lw * 96 / A_ScreenDPI
    ,   VarSetCapacity(LV_XYstruct, 16, 0)

        While (GetKeyState(DragButton, "P"))
        {
            MouseGetPos, LV_mx, LV_my,, CurrCtrl, 2
            LV_mx -= LV_lx, LV_my -= LV_ly

            If (AutoScroll)
            {
                If (LV_my < 0)
                {
                    SendMessage, LVM_SCROLL, 0, -LV_currColHeight,, ahk_id %LV_LView%
                    Sleep, %ScrollDelay%
                }
                If (LV_my > LV_lh)
                {
                    SendMessage, LVM_SCROLL, 0, LV_currColHeight,, ahk_id %LV_LView%
                    Sleep, %ScrollDelay%
                }
            }

            If (CurrCtrl != LV_LView)
            {
                LV_currRow := ""
                Gui, MarkLine:Cancel
                continue
            }

            SendMessage, LVM_GETITEMCOUNT, 0, 0,, ahk_id %LV_LView%
            LV_TotalNumOfRows := ErrorLevel
            SendMessage, LVM_GETCOUNTPERPAGE, 0, 0,, ahk_id %LV_LView%
            LV_NumOfRows := ErrorLevel
            SendMessage, LVM_GETTOPINDEX, 0, 0,, ahk_id %LV_LView%
            LV_topIndex := ErrorLevel
        ,   Line_W := (LV_TotalNumOfRows > LV_NumOfRows) ? LV_lw - SM_CXVSCROLL : LV_lw

            Loop, % LV_NumOfRows + 1
            {    
                LV_which := LV_topIndex + A_Index - 1
                NumPut(LVIR_LABEL, LV_XYstruct, 0, "UInt")
            ,   NumPut(A_Index - 1, LV_XYstruct, 4, "UInt")
                SendMessage, LVM_GETSUBITEMRECT, LV_which, &LV_XYstruct,, ahk_id %LV_LView%
                LV_RowY := NumGet(LV_XYstruct, 4, "UInt")
            ,   LV_RowY2 := NumGet(LV_XYstruct, 12, "UInt")
            ,   LV_currColHeight := LV_RowY2 - LV_RowY
                If (LV_my <= LV_RowY + LV_currColHeight)
                {    
                    LV_currRow  := LV_which + 1
                ,   LV_currRow0 := LV_which
                ,   Line_Y := Win_Y + LV_ly + LV_RowY
                ,   Line_X := Win_X + LV_lx
                    If (LV_currRow > (LV_TotalNumOfRows+1))
                    {
                        Gui, MarkLine:Cancel
                        LV_currRow := ""
                    }
                    Break
                }
            }

            If (LV_currRow)
            {
                Gui, MarkLine:Color, %Color%
                Gui, MarkLine:+LastFound +AlwaysOnTop +Toolwindow -Caption +HwndLineMark
                Gui, MarkLine:Show, W%Line_W% H%LineThick% Y%Line_Y% X%Line_X% NoActivate
            }
        }

        If (DragButton = "LButton" && LV_currRow)
        {
            Gui, MarkLine:Cancel
            CopyData := this.CopyData.Clone()
            Lines := this.Copy()
        ,   this.Paste(LV_currRow)
            If (LV_GetNext() < LV_currRow)
                o := Lines+1, FocusedRow := LV_currRow-1
            Else
                o := 1, FocusedRow := LV_currRow
            this.Delete()
            Loop, %Lines%
            {
                i := A_Index-o
            ,   LV_Modify(LV_currRow+i, "Select")
            }
            LV_Modify(FocusedRow, "Focus")
        ,   this.CopyData := CopyData.Clone()
        ,   CopyData.RemoveAt(1, CopyData.Length())
        ,   CopyData := ""
        }
        
        If (RestoreGroups)
            this.EnableGroupView()
        
        return LV_currRow
    }
;=======================================================================================
;    History Functions:  Keep a history of ListView changes and allow Undo and Redo.
;                            These functions operate on the currently selected ListView.
;=======================================================================================
;    Function:           Handle.Add()
;    Description:        Adds an entry on History. This function requires
;                            initializing: MyListHandle := New LV_Rows()
;    Return:             The total number of entries in history.
;=======================================================================================
    Add()
    {
        Rows := []
        If (this.Handle.ActiveSlot < this.Handle.Slot.Length())
            this.Handle.Slot.RemoveAt(this.Handle.ActiveSlot+1, this.Handle.Slot.Length())
        Loop, % LV_GetCount()
        {
            RowData := this.RowText(A_Index)
        ,   Rows[A_Index] := [RowData*]
        }
        
        Groups := []
        For e, g in this.Handle.GroupsArray
            Groups[e] := {Name: g.Name, Row: g.Row}
        
        this.Handle.Slot.Push({Rows: Rows, Groups: Groups})
        this.Handle.ActiveSlot := this.Handle.Slot.Length()
        return this.Handle.Slot.Length()
    }
;=======================================================================================
;    Function:           Handle.Undo()
;    Description:        Replaces ListView contents with previous entry state, if any.
;    Return:             New entry position or false if it's already the first entry.
;=======================================================================================
    Undo()
    {
        If (this.Handle.ActiveSlot = 1)
            return false
        this.Handle.ActiveSlot -= 1
    ,   this.Load()
        return this.Handle.ActiveSlot
    }
;=======================================================================================
;    Function:           Handle.Redo()
;    Description:        Replaces ListView contents with next entry state, if any.
;    Return:             New entry position or false if it's already the last entry.
;=======================================================================================
    Redo()
    {
        If (this.Handle.ActiveSlot = (this.Handle.Slot.Length()))
            return false
        this.Handle.ActiveSlot += 1
    ,   this.Load()
        return this.Handle.ActiveSlot
    }
;=======================================================================================
;    Function:           Handle.ClearHistory()
;    Description:        Removes all history entries from the ListView.
;    Return:             New entry position or false if it's already the last entry.
;=======================================================================================
    ClearHistory()
    {
        this.Handle.Slot := []
    ,   this.Handle.ActiveSlot := 1
    }
;=======================================================================================
;    Group Functions:    Set, add and remove Listview Groups.
;                        These functions are based on just me's LV_EX library:
;                        http://autohotkey.com/boards/viewtopic.php?t=1256
;=======================================================================================
;    Function:           Handle.EnableGroups()
;    Description:        Enables or disables Groups in the currently selected ListView
;                            initializing: MyListHandle := New LV_Rows()
;    Parameters:
;        Enable:         If TRUE enables GroupView in the selected ListView. If FALSE
;                            disables it.
;        FirstName:      Name for the first (mandatory) group at row 1.
;        Collapsible:    If TRUE makes the groups collapsible.
;        StartCollapsed: If TRUE starts all groups collapsed.
;    Return:             No return value.
;=======================================================================================
    EnableGroups(Enable := true, FirstName := "New Group", Collapsible := true, StartCollapsed := false)
    {
        Gui, Listview, % this.LVHwnd
        ListCount := LV_GetCount()
     ,  this.Collapsible := Collapsible
     ,  this.EnableGroupView(Enable)
        If (Enable)
        {
            If (!this.Handle.GroupsArray.Length())
                this.Handle.GroupsArray := [{Name: FirstName, Row: 1}]
            this.RefreshGroups(StartCollapsed)
        }
    }
;=======================================================================================
;    Function:           Handle.InsertGroup()
;    Description:        Inserts or renames a group on top of the specified row.
;    Parameters:
;        Row:            Number of the row for the group to be inserted. If left blank
;                            the first selected row will be used.
;        GroupName:      Name of the new group or new name for an existing group.
;    Return:             TRUE if Row is bigger than 0 or FALSE otherwise.
;=======================================================================================
    InsertGroup(Row := "", GroupName := "New Group")
    {
        If (Row = "")
            Row := LV_GetNext()
        If (Row =< 0)
            return false
        
        For e, g in this.Handle.GroupsArray
        {
            If (Row = g.Row)
            {
                this.Handle.GroupsArray[e] := {Name: GroupName, Row: Row}
                break
            }
            If (Row < g.Row)
            {
                this.Handle.GroupsArray.InsertAt(e, {Name: GroupName, Row: Row})
                break
            }
            If (e = this.Handle.GroupsArray.Length())
            {
                this.Handle.GroupsArray.Push({Name: GroupName, Row: Row})
                break
            }
        }
        If (!this.Handle.GroupsArray.Length())
        {
            this.Handle.GroupsArray.Push({Name: "New Group", Row: 1})
            If (Row > 1)
                this.Handle.GroupsArray.Push({Name: GroupName, Row: Row})
        }
        this.RefreshGroups()
        return true
    }
;=======================================================================================
;    Function:           Handle.RemoveGroup()
;    Description:        Removes the group the indicated row belongs to.
;    Parameters:
;        Row:            Number of a row the group belongs to. If left blank the first
;                            selected row will be used.
;    Return:             TRUE if Row is bigger than 0 or FALSE otherwise.
;=======================================================================================
    RemoveGroup(Row := "")
    {
        If (Row = "")
            Row := LV_GetNext()
        If (Row =< 0)
            return false
        
        For e, g in this.Handle.GroupsArray
        {
            If (Row = g.Row)
            {
                If (g.Row = 1)
                    return
                this.Handle.GroupsArray.RemoveAt(e)
                break
            }
            If (Row < g.Row)
            {
                If (e = 2)
                    return
                this.Handle.GroupsArray.RemoveAt(e - 1)
                break
            }
            If (e = this.Handle.GroupsArray.Length())
            {
                If (g.Row = 1)
                    return
                this.Handle.GroupsArray.RemoveAt(e)
                break
            }
        }
        this.RefreshGroups()
        return true
    }
;=======================================================================================
;    Function:           Handle.InsertAtGroup()
;    Description:        Inserts a row at indicated position, moving groups after it one
;                            row down.
;    Parameters:
;        Row:            Number of the row where to insert.
;    Return:             No return value.
;=======================================================================================
    InsertAtGroup(Row)
    {
        For e, g in this.Handle.GroupsArray
        {
            If ((Row > 0) && (Row < g.Row))
                g.Row++
        }
    }
;=======================================================================================
;    Function:           Handle.RemoveAtGroup()
;    Description:        Removes a row from indicated position, moving groups after it one
;                            row up.
;    Parameters:
;        Row:            Number of the row where to insert.
;    Return:             No return value.
;=======================================================================================
    RemoveAtGroup(Row)
    {
        For e, g in this.Handle.GroupsArray
        {
            If ((Row > 0) && (Row < g.Row))
                g.Row--
        }
    }
;=======================================================================================
;    Function:           Handle.SetGroups()
;    Description:        Sets one or more groups in the selected ListView.
;    Parameters:
;        Groups:         A list of groups in the format "GroupName:RowNumber" separated
;                            by comma. You can use GetGroups() to save a valid String or
;                            Object to be used with this function.
;    Return:             No return value.
;=======================================================================================
    SetGroups(Groups)
    {
        this.Handle.GroupsArray := []
        If (!Groups.Length())
        {
            Loop, Parse, Groups, `,, %A_Space%
            {
                Pars := StrSplit(A_LoopField, ":", A_Space)
            ,   this.Handle.GroupsArray.Push({Name: Pars[1], Row: Pars[2]})
            }
        }
        Else
            this.Handle.GroupsArray := Groups
        this.RefreshGroups()
    }
;=======================================================================================
;    Function:           Handle.GetGroups()
;    Description:        Returns a string or object representing the current groups in
;                            the selected ListView.
;    Parameters:
;        AsObject:       If TRUE returns an object with the groups, otherwise an string.
;                            Both can be used with SetGroups().
;    Return:             No return value.
;=======================================================================================
    GetGroups(AsObject := false)
    {
        If (AsObject)
            return this.Handle.GroupsArray.Clone()
        For e, g in this.Handle.GroupsArray
            GroupsString .= g.Name ":" g.Row ","
        return RTrim(GroupsString, ",")
    }
;=======================================================================================
;    Function:           Handle.SetGroupCollapisable()
;    Description:        Enables or disables Groups Collapsible style.
;    Parameters:
;        Collapsible:    If TRUE enables Collapsible style in the selected ListView.
;                            If FALSE disables it.
;    Return:             No return value.
;=======================================================================================
    SetGroupCollapisable(Collapsible := true)
    {
        this.Collapsible := Collapsible
    ,   this.RefreshGroups()
    }
;=======================================================================================
;    Function:           Handle.RemoveAllGroups()
;    Description:        Removes all groups in the selected ListView.
;    Parameters:
;        FirstName:      Name for the first (mandatory) group at row 1.
;    Return:             No return value.
;=======================================================================================
    RemoveAllGroups(FirstName := "New Group")
    {
        If (!this.Handle.GroupsArray.Length())
            this.Handle.GroupsArray.Push({Name: FirstName, Row: 1})
        Else
        {
            this.Handle.GroupsArray[1] := {Name: FirstName, Row: 1}
        ,    this.Handle.GroupsArray.RemoveAt(2, this.Handle.GroupsArray.Length())
        }
        this.RefreshGroups()
    }
;=======================================================================================
;    Function:           Handle.CollapseAll()
;    Description:        Collapses or expands all groups.
;    Parameters:
;        Collapse:       If TRUE collapses all groups in the selected ListView. If FALSE
;                            expands all groups in the selected ListView.
;    Return:             No return value.
;=======================================================================================
    CollapseAll(Collapse := true)
    {
        this.RefreshGroups(Collapse)
    }
;=======================================================================================
;    Function:           Handle.RefreshGroups()
;    Description:        Reloads the ListView to update groups. This function is called
;                            automatically in from other functions, usually it's not
;                            necessary to use it in your script.
;    Parameters:
;        Collapsed:      If TRUE collapses all groups in the selected ListView.
;    Return:             No return value.
;=======================================================================================
    RefreshGroups(Collapsed := false)
    {
        GroupStates := []
        Gui, Listview, % this.LVHwnd
        For e, g in this.Handle.GroupsArray
        {
            this.GroupGetState(A_Index + 9, IsCollapsed)
        ,    GroupStates.Push(IsCollapsed ? "Collapsed" : "")
        }
        ListCount := LV_GetCount()
    ,   this.GroupRemoveAll(), GrNum := 1
        Loop, %ListCount%
        {
            If (this.Handle.GroupsArray[GrNum].Row = A_Index)
            {
                this.GroupInsert(GrNum + 9, this.Handle.GroupsArray[GrNum].Name)
            ,   Styles := Collapsed ? ["Collapsible", "Collapsed"] : this.Collapsible ? ["Collapsible", GroupStates[GrNum]] : []
            ,   this.GroupSetState(GrNum + 9, Styles*)
            ,   GrNum++
            }
            this.SetGroup(A_Index, GrNum + 8)
        }
    }
;=======================================================================================
;    Internal Functions: These functions are meant for internal use but can also
;                            be called if necessary.
;=======================================================================================
;    Function:           Handle.Load()
;    Description:        Loads a specified entry in History into ListView.
;    Parameters:
;        Position:       Number of entry position to be loaded.
;    Return:             false if entry exists, false otherwise.
;=======================================================================================
    Load(Position := "")
    {
        If (Position = "")
            Position := this.Handle.ActiveSlot
        If (!IsObject(this.Handle.Slot[Position]))
            return false
        LV_Delete()
        For each, Row in this.Handle.Slot[Position].Rows
            LV_Add(Row*)
        this.Handle.GroupsArray := []
        For e, g in this.Handle.Slot[Position].Groups
            this.Handle.GroupsArray.Push(g)
        this.RefreshGroups()
        return true
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
    ,   iIcon := this.GetIconIndex(this.LVHwnd, Index)
    ,   Data.Push("Icon" iIcon " Check" ckd)
        Loop, % LV_GetCount("Col")
        {
            LV_GetText(Cell, Index, A_Index)
        ,   Data.Push(Cell)
        }
        return Data
    }
;=======================================================================================
;    Function:           LV_Rows.GetIconIndex()
;    Description:        Retrieves the row's icon index.
;    Parameters:
;        Hwnd:           Hwnd of the ListView.
;        Row:            1-based Row number.
;    Return:             The 1-based icon index from specified row.
;=======================================================================================
    GetIconIndex(Hwnd, Row)
    {
        Static LVIF_IMAGE   := 0x00000002
        Static LVM_GETITEMA := 0x1005
        Static LVM_GETITEMW := 0x104B
        Static LVM_GETITEM  := A_IsUnicode ? LVM_GETITEMW : LVM_GETITEMA

        VarSetCapacity(LVITEM, 6 * 4 + (A_PtrSize * 2), 0)
    ,   NumPut(LVIF_IMAGE, LVITEM, 0, "UInt") ; mask
    ,   NumPut(Row-1, LVITEM, 4, "Int") ; iItem
        SendMessage, LVM_GETITEM, 0, &LVITEM,, ahk_id %Hwnd%
        return NumGet(LVITEM, 5 * 4 + (A_PtrSize * 2), "Int") + 1 ; iImage
    }
; ======================================================================================================================
; Namespace:      LV_EX
; Function:       Some additional functions to use with AHK ListView controls.
; Tested with:    AHK 1.1.20.03 (A32/U32/U64)
; Tested on:      Win 8.1 (x64)
; Note:           This version has been modified to include only Group related functions, the complete
;                     library can be found at https://autohotkey.com/boards/viewtopic.php?t=1256
; Changelog:
;     1.1.00.00/2015-03-13/just me     -  added basic tile view support (suggested by toralf),
;                                         added basic (XP compatible) group view support,
;                                         revised code and made some minor changes.
;     1.0.00.00/2013-12-30/just me     -  initial release.
; Notes:
;     In terms of Microsoft
;        Item     stands for the whole row or the first column of the row
;        SubItem  stands for the second to last column of a row
;     All functions require the handle of the ListView (HWND). You get this handle using the 'Hwnd' option when
;     creating the control per 'Gui, Add, HwndHwndOfLV ...' or using 'GuiControlGet, HwndOfLV, Hwnd, MyListViewVar'
;     after control creation.
; Credits:
;     LV_EX tile view functions:
;        Initial idea by segalion (old forum: /board/topic/80754-listview-with-multiline-in-report-mode-help/)
;        based on code from Fabio Lucarelli (http://users.skynet.be/oleole/ListView_Tiles.htm).
; ======================================================================================================================
; This software is provided 'as-is', without any express or implied warranty.
; In no event will the authors be held liable for any damages arising from the use of this software.
; ======================================================================================================================
    Class LV_EX
    {
; ======================================================================================================================
; LV_EX_EnableGroupView - Enables or disables whether the items in a list-view control display as a group.
; ======================================================================================================================
        EnableGroupView(Enable := true)
        {
           ; LVM_ENABLEGROUPVIEW = 0x109D -> msdn.microsoft.com/en-us/library/bb774900(v=vs.85).aspx
           SendMessage, 0x109D, % (!!Enable), 0, , % "ahk_id " . this.LVHwnd
           Return (ErrorLevel >> 31) ? 0 : 1
        }
; ======================================================================================================================
; LV_EX_GetGroup - Gets the ID of the group the list-view item belongs to.
; ======================================================================================================================
        GetGroup(Row)
        {
           ; LVM_GETITEMA = 0x1005 -> http://msdn.microsoft.com/en-us/library/bb774953(v=vs.85).aspx
           Static OffGroupID := 28 + (A_PtrSize * 3)
           this.LVITEM(LVITEM, 0x00000100, Row) ; LVIF_GROUPID
           SendMessage, 0x1005, 0, % &LVITEM, , % "ahk_id " . this.LVHwnd
           Return NumGet(LVITEM, OffGroupID, "UPtr")
        }
; ======================================================================================================================
; LV_EX_GroupGetHeader - Gets the header text of a group by group ID
; ======================================================================================================================
        GroupGetHeader(GroupID, MaxChars := 1024)
        {
            ; LVM_GETGROUPINFO = 0x1095
            Static SizeOfLVGROUP := (4 * 6) + (A_PtrSize * 4)
            Static LVGF_HEADER := 0x00000001
            Static OffHeader := 8
            Static OffHeaderMax := 8 + A_PtrSize
            VarSetCapacity(HeaderText, MaxChars * 2, 0)
            VarSetCapacity(LVGROUP, SizeOfLVGROUP, 0)
            NumPut(SizeOfLVGROUP, LVGROUP, 0, "UInt")
            NumPut(LVGF_HEADER, LVGROUP, 4, "UInt")
            NumPut(&HeaderText, LVGROUP, OffHeader, "Ptr")
            NumPut(MaxChars, LVGROUP, OffHeaderMax, "Int")
            SendMessage, 0x1095, %GroupID%, % &LVGROUP, , % "ahk_id " . HLV
            Return StrGet(&HeaderText, MaxChars, "UTF-16")
        }
; ======================================================================================================================
; LV_EX_GroupGetState - Get group states (requires Win Vista+ for most states).
; ======================================================================================================================
        GroupGetState(GroupID, ByRef Collapsed := "", ByRef Collapsible := "", ByRef Focused := "", ByRef Hidden := ""
                        , ByRef NoHeader := "", ByRef Normal := "", ByRef Selected := "")
        {
            ; LVM_GETGROUPINFO = 0x1095 -> msdn.microsoft.com/en-us/library/bb774932(v=vs.85).aspx
            Static OS := DllCall("GetVersion", "UChar")
            Static LVGS5 := {Collapsed: 0x01, Hidden: 0x02, Normal: 0x00}
            Static LVGS6 := {Collapsed: 0x01, Collapsible: 0x08, Focused: 0x10, Hidden: 0x02, NoHeader: 0x04, Normal: 0x00, Selected: 0x20}
            Static LVGF := 0x04 ; LVGF_STATE
            Static SizeOfLVGROUP := (4 * 6) + (A_PtrSize * 4)
            Static OffStateMask := 8 + (A_PtrSize * 3) + 8
            Static OffState := OffStateMask + 4
            SetStates := 0
            LVGS := OS > 5 ? LVGS6 : LVGS5
            For Each, State In LVGS
                SetStates |= State
            VarSetCapacity(LVGROUP, SizeOfLVGROUP, 0)
            NumPut(SizeOfLVGROUP, LVGROUP, 0, "UInt")
            NumPut(LVGF, LVGROUP, 4, "UInt")
            NumPut(SetStates, LVGROUP, OffStateMask, "UInt")
            SendMessage, 0x1095, %GroupID%, &LVGROUP, , % "ahk_id " . this.LVHwnd
            States := NumGet(&LVGROUP, OffState, "UInt")
            For Each, State in LVGS
                %Each% := States & State ? True : False
            Return ErrorLevel
        }
; ======================================================================================================================
; LV_EX_GroupInsert - Inserts a group into a list-view control.
; ======================================================================================================================
        GroupInsert(GroupID, Header, Align := "", Index := -1)
        {
           ; LVM_INSERTGROUP = 0x1091 -> msdn.microsoft.com/en-us/library/bb761103(v=vs.85).aspx
           Static Alignment := {1: 1, 2: 2, 4: 4, C: 2, L: 1, R: 4}
           Static SizeOfLVGROUP := (4 * 6) + (A_PtrSize * 4)
           Static OffHeader := 8
           Static OffGroupID := OffHeader + (A_PtrSize * 3) + 4
           Static OffAlign := OffGroupID + 12
           Static LVGF := 0x11 ; LVGF_GROUPID | LVGF_HEADER | LVGF_STATE
           Static LVGF_ALIGN := 0x00000008
           Align := (A := Alignment[SubStr(Align, 1, 1)]) ? A : 0
           Mask := LVGF | (Align ? LVGF_ALIGN : 0)
           PHeader := A_IsUnicode ? &Header : this.PWSTR(Header, WHeader)
           VarSetCapacity(LVGROUP, SizeOfLVGROUP, 0)
           NumPut(SizeOfLVGROUP, LVGROUP, 0, "UInt")
           NumPut(Mask, LVGROUP, 4, "UInt")
           NumPut(PHeader, LVGROUP, OffHeader, "Ptr")
           NumPut(GroupID, LVGROUP, OffGroupID, "Int")
           NumPut(Align, LVGROUP, OffAlign, "UInt")
           SendMessage, 0x1091, %Index%, % &LVGROUP, , % "ahk_id " . this.LVHwnd
           Return ErrorLevel
        }
; ======================================================================================================================
; LV_EX_GroupRemove - Removes a group from a list-view control.
; ======================================================================================================================
        GroupRemove(GroupID)
        {
           ; LVM_REMOVEGROUP = 0x1096 -> msdn.microsoft.com/en-us/library/bb761149(v=vs.85).aspx
           SendMessage, 0x10A0, %GroupID%, 0, , % "ahk_id " . this.LVHwnd
           Return ErrorLevel
        }
; ======================================================================================================================
; LV_EX_GroupRemoveAll - Removes all groups from a list-view control.
; ======================================================================================================================
        GroupRemoveAll()
        {
           ; LVM_REMOVEALLGROUPS = 0x10A0 -> msdn.microsoft.com/en-us/library/bb761147(v=vs.85).aspx
           SendMessage, 0x10A0, 0, 0, , % "ahk_id " . this.LVHwnd
           Return ErrorLevel
        }
; ======================================================================================================================
; LV_EX_GroupSetState - Sets the state of the specified group (requires Win Vista+ for most states).
; ======================================================================================================================
        GroupSetState(GroupID, States*)
        {
           ; LVM_SETGROUPINFO = 0x1093 -> msdn.microsoft.com/en-us/library/bb761167(v=vs.85).aspx
           Static OS := DllCall("GetVersion", "UChar")
           Static LVGS5 := {Collapsed: 0x01, Hidden: 0x02, Normal: 0x00, 0: 0, 1: 1, 2: 2}
           Static LVGS6 := {Collapsed: 0x01, Collapsible: 0x08, Focused: 0x10, Hidden: 0x02, NoHeader: 0x04, Normal: 0x00
                         , Selected: 0x20, 0: 0, 1: 1, 2: 2, 4: 4, 8: 8, 16: 16, 32: 32}
           Static LVGF := 0x04 ; LVGF_STATE
           Static SizeOfLVGROUP := (4 * 6) + (A_PtrSize * 4)
           Static OffStateMask := 8 + (A_PtrSize * 3) + 8
           Static OffState := OffStateMask + 4
           SetStates := 0
           LVGS := OS > 5 ? LVGS6 : LVGS5
           For Each, State In States {
              If (State = "")
                 continue
              If !LVGS.HasKey(State)
                 Return false
              SetStates |= LVGS[State]
           }
           VarSetCapacity(LVGROUP, SizeOfLVGROUP, 0)
           NumPut(SizeOfLVGROUP, LVGROUP, 0, "UInt")
           NumPut(LVGF, LVGROUP, 4, "UInt")
           NumPut(SetStates, LVGROUP, OffStateMask, "UInt")
           NumPut(SetStates, LVGROUP, OffState, "UInt")
           SendMessage, 0x1093, %GroupID%, % &LVGROUP, , % "ahk_id " . this.LVHwnd
           Return ErrorLevel
        }
; ======================================================================================================================
; LV_EX_HasGroup - Determines whether the list-view control has a specified group.
; ======================================================================================================================
        HasGroup(GroupID)
        {
           ; LVM_HASGROUP = 0x10A1 -> msdn.microsoft.com/en-us/library/bb761097(v=vs.85).aspx
           SendMessage, 0x10A1, %GroupID%, 0, , % "ahk_id " . this.LVHwnd
           Return ErrorLevel
        }
; ======================================================================================================================
; LV_EX_IsGroupViewEnabled - Checks whether the list-view control has group view enabled.
; ======================================================================================================================
        IsGroupViewEnabled()
        {
           ; LVM_ISGROUPVIEWENABLED = 0x10AF -> msdn.microsoft.com/en-us/library/bb761133(v=vs.85).aspx
           SendMessage, 0x10AF, 0, 0, , % "ahk_id " . this.LVHwnd
           Return ErrorLevel
        }
; ======================================================================================================================
; LV_EX_SetGroup - Assigns a list-view item to an existing group.
; ======================================================================================================================
        SetGroup(Row, GroupID)
        {
           ; LVM_SETITEMA = 0x1006 -> http://msdn.microsoft.com/en-us/library/bb761186(v=vs.85).aspx
           Static OffGroupID := 28 + (A_PtrSize * 3)
           this.LVITEM(LVITEM, 0x00000100, Row) ; LVIF_GROUPID
           NumPut(GroupID, LVITEM, OffGroupID, "UPtr")
           SendMessage, 0x1006, 0, % &LVITEM, , % "ahk_id " . this.LVHwnd
           Return ErrorLevel
        }
; ======================================================================================================================
; ======================================================================================================================
; Function for internal use ============================================================================================
; ======================================================================================================================
; ======================================================================================================================
        LVITEM(ByRef LVITEM, Mask := 0, Row := 1, Col := 1)
        {
           Static LVITEMSize := 48 + (A_PtrSize * 3)
           VarSetCapacity(LVITEM, LVITEMSize, 0)
           NumPut(Mask, LVITEM, 0, "UInt"), NumPut(Row - 1, LVITEM, 4, "Int"), NumPut(Col - 1, LVITEM, 8, "Int")
        }
; ----------------------------------------------------------------------------------------------------------------------
        PWSTR(Str, ByRef WSTR)
        { ; ANSI to Unicode
           VarSetCapacity(WSTR, StrPut(Str, "UTF-16") * 2, 0)
           StrPut(Str, &WSTR, "UTF-16")
           Return &WSTR
        }
    }
}
