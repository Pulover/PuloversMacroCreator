;###########################################################
; Created by Pulover (based on Learning one's CreateTreeView)
; https://autohotkey.com/board/topic/92863-function-createtreeview
; Part of code used from maestrith's example to hide individiual
; checkboxes in a TreeView
; https://autohotkey.com/board/topic/96840-ahk-11-hide-individual-checkboxes-in-a-treeview-x32x64/
;###########################################################
CreateTreeView(TreeViewDefinition, hwnd := "")
{
	IDs := {}

	For Key, Item in TreeViewDefinition
	{
		If (Item.Level = 0)
			IDs["Level0"] := Item.ID := TV_Add(Item.Content, 0, Item.Options)
		Else
			IDs["Level" Item.Level] := Item.ID := TV_Add(Item.Content, IDs["Level" Item.Level-1], Item.Options)
		If (Item.HideCheck)
		{
			VarSetCapacity(TvItem, 28)
			Info := A_PtrSize = 4 ? {0:8,4:IDs["Level" Item.Level],12:0xf000} : {0:8,8:IDs["Level" Item.Level],20:0xf000}
			For Offset, Value in Info
				NumPut(Value, TvItem, Offset)
			SendMessage, 4415, 0, &TvItem, SysTreeView321, ahk_id%hwnd%
		}
	}
}