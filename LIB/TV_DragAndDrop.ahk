;=======================================================================================
;
;                    TV_DragAndDrop
;
; Author:            Pulover [Rodolfo U. Batista]
; AHK version:       1.1.32.00
;
;                    Drag & Drop function for TreeView controls
;=======================================================================================
;
; Usage:
;
;    Call TV_Drag() from the TreeView's G-Label when A_GuiEvent contains "D" or "d".
;    A line will show across the TreeView while holding the button to indicate the
;        destination where the selected node will be dropped with its children. If you
;        point the mouse cursor to the half bottom part of the node text it will be
;        dropped as a child of the pointed node. If you point it to the upper part it
;        will drop it as sibling right below the pointed node.
;        
;    TV_Drag() returns the target node id (if valid) which you can use to call TV_Drop()
;        and effectively move the selection. Alternatively you can set AutoDrop option
;        on as a shorthand.
;
;    TV_Drop() may be called directly to move or copy nodes programmatically. You may
;        pass the TreeView control's hwnd to keep icons and set Copy parameter to true
;        if you want to copy nodes instead of moving.
;=======================================================================================
TV_Drag(Origin, DragButton := "D", AutoDrop := False, LineThick := 2, Color := "Black")
{
    Static TVM_HITTEST     := 0x1111
    Static TVM_SELECTITEM  := 0x110B
    Static TVGN_DROPHILITE := 0x8
    Static TVM_GETITEMRECT := 0x1104

    BlockedIds := []

    If (InStr(DragButton, "d", true))
        DragButton := "RButton"
    Else
        DragButton := "LButton"

    CoordMode, Mouse, Window
    MouseGetPos,,, TV_Win, TV_TView, 2
    WinGetPos, Win_X, Win_Y, Win_W, Win_H, ahk_id %TV_Win%
    ControlGetPos, TV_lx, TV_ly, TV_lw, TV_lh, , ahk_id %TV_TView%
    TV_lw := TV_lw * 96 // A_ScreenDPI

    While (GetKeyState(DragButton, "P"))
    {
        MouseGetPos, TV_mx, TV_my,, CurrCtrl, 2

        If (CurrCtrl != TV_TView)
        {
            Gui, MarkLine:Cancel
            continue
        }

        VarSetCapacity(TV_HitInfoStruct, 16, 0)
    ,   NumPut(TV_mx, TV_HitInfoStruct, 0, "int")
    ,   NumPut(TV_my-TV_ly, TV_HitInfoStruct, 4, "int")
        SendMessage, TVM_HITTEST, 0, &TV_HitInfoStruct,, ahk_id %TV_TView%
        If (HitTarget := ErrorLevel)
        {
            If (HasVal(BlockedIds, HitTarget))
            {
                HitTarget := 0
                continue
            }
            If (IsTargetChild(Origin, HitTarget))
            {
                BlockedIds.Push(HitTarget), HitTarget := 0
                continue
            }
            VarSetCapacity(TV_XYstruct, 16, 0)
        ,   NumPut(HitTarget, TV_XYstruct, 0, "UInt")
            SendMessage, TVM_GETITEMRECT, 1, &TV_XYstruct,, ahk_id %TV_TView%
            TV_NodeX := NumGet(TV_XYstruct, 0, "UInt")
            TV_NodeY := NumGet(TV_XYstruct, 4, "UInt")
            TV_NodeX2 := NumGet(TV_XYstruct, 8, "UInt")
        ,   TV_NodeY2 := NumGet(TV_XYstruct, 12, "UInt")
        ,   Line_H := TV_NodeY2 - TV_NodeY
        ,   Line_Y := Win_Y + TV_ly + TV_NodeY + Line_H
        ,   Line_P := (TV_my - TV_NodeY - TV_ly) > (Line_H // 2) ? "Child" : "Sibling"
        ,   Line_W := Line_P = "Child" ? TV_lw - TV_NodeX : TV_lw
        ,   Line_X := Line_P = "Child" ? Win_X + TV_lx + TV_NodeX : Win_X + TV_lx
        ,   TV_Modify(Line_P = "Child" ? HitTarget : 0)
            Gui, MarkLine:Color, %Color%
            Gui, MarkLine:+LastFound +AlwaysOnTop +Toolwindow -Caption +HwndLineMark
            Gui, MarkLine:Show, W%Line_W% H%LineThick% Y%Line_Y% X%Line_X% NoActivate
        }
    }

    Gui, MarkLine:Cancel

    If (CurrCtrl != TV_TView)
        return 0
    
    If (AutoDrop)
        TV_Drop(Origin, HitTarget)
    
    return Line_P = "Child" ? HitTarget : -HitTarget
}
;=======================================================================================
TV_Drop(Origin, Target, Hwnd := "", Copy := False, FirstChild := False)
{
    If (!Hwnd)
        MouseGetPos,,,, Hwnd, 2
    TargetID := Target < 0 ? Target * -1 : Target
    If ((Target) && (Origin != TargetID))
    {
        NewNodeId := MoveNodes(Origin, Target, Hwnd, FirstChild ? "First " : "")
        TV_Modify(Target, "Expand")
        If (!Copy)
            TV_Delete(Origin)
    }
    return NewNodeId
}
;=======================================================================================
;    Internal Functions: These functions are meant for internal use but can also
;                            be called if necessary.
;=======================================================================================
IsTargetChild(Origin, Target)
{
    ParentID := Target
    While (ParentID := TV_GetParent(ParentID))
    {
        If (ParentID = Origin)
            return ParentID
    }
    return False
}
;=======================================================================================
MoveNodes(Node, Target, TreeViewId, FirstChild := "")
{
    IsSibling := Target < 0
,   TV_GetText(NodeText, Node)
,   chk := TV_Get(Node, "C") = Node
,   iIcon := GetIconIndex(TreeViewId, Node)
    If (IsSibling)
    {
        Target := Target * -1, ParentId := TV_GetParent(Target), SiblingId := ParentId
        While (SiblingId)
        {
            SiblingId := TV_GetNext(SiblingId, "Full")
            If (SiblingId = Target)
                break
        }
        If (!SiblingId)
            SiblingId := Target
        NodeId := TV_Add(NodeText, ParentId, SiblingId " Expand Vis Icon" iIcon " Check" chk)
    }
    Else
        NodeId := TV_Add(NodeText, Target, FirstChild "Expand Vis Icon" iIcon " Check" chk)
    If (Child := TV_GetChild(Node))
    {
        MoveNodes(Child, NodeId, TreeViewId)
        While (Child := TV_GetNext(Child))
            MoveNodes(Child, NodeId, TreeViewId)
    }
    return NodeId
}
;=======================================================================================
GetIconIndex(Hwnd, Node)
{
    Static TVIF_IMAGE   := 0x0002
    Static TVM_GETITEMA := 0x110C
    Static TVM_GETITEMW := 0x113E
    Static TVM_GETITEM  := A_IsUnicode ? TVM_GETITEMW : TVM_GETITEMA

    VarSetCapacity(TVITEM, 6 * 4 + (A_PtrSize * 4), 0)
,   NumPut(TVIF_IMAGE, TVITEM, 0, "UInt") ; mask
,   NumPut(Node, TVITEM, A_PtrSize, "Int") ; hItem
,   NumPut(Node, TVITEM, 3 * 4 + (A_PtrSize * 3), "Int") ; iImage
    SendMessage, TVM_GETITEM, 0, &TVITEM,, ahk_id %Hwnd%
    return NumGet(TVITEM, 3 * 4 + (A_PtrSize * 3), "Int") + 1 ; iImage
}
;=======================================================================================
;    Author: jNizM
;=======================================================================================
HasVal(haystack, needle) {
    for index, value in haystack
        if (value = needle)
            return index
    if !(IsObject(haystack))
        throw Exception("Bad haystack!", -1, haystack)
    return 0
}