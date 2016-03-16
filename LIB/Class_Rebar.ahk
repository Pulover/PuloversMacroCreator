;=======================================================================================
;
;                    Class Rebar
;
; Author:            Pulover [Rodolfo U. Batista]
; AHK version:       1.1.23.01
;
;                    Class for AutoHotkey Rebar custom controls
;=======================================================================================
;
; This class provides intuitive methods to work with Rebar controls created via
;    Gui, Add, Custom, ClassReBarWindow32.
;
;=======================================================================================
;
; Rebar Methods:
;    DeleteBand(Band)
;    GetBand(Band [, ID, Text, Size, Image, Background, Style, Child])
;    GetBandCount()
;    GetBarHeight()
;    GetLayout()
;    GetRowCount()
;    GetRowHeight(Band)
;    IDToIndex(ID)
;    InsertBand(hChild [, Position, Options, ID, Text, Size, Image, Background, MinHeight
;               , MinWidth, IdealSize])
;    MaximizeBand(Band [, IdealWidth])
;    MinimizeBand(Band)
;    ModifyBand(Band, Property, Value [, SetStyle])
;    MoveBand(Band, Target)
;    OnNotify(Param [, MenuXPos, MenuYPos, ID)
;    SetBandStyle(Band, Value)
;    SetBandWidth(Band, Width)
;    SetImageList(ImageList)
;    SetMaxRows([Rows])
;    SetLayout(Layout)
;    ShowBand(Band [, Show])
;    ToggleStyle(Style)
;
;=======================================================================================
;
; Useful Rebar Styles:     Styles can be applied to Gui command options, e.g.:
;                              Gui, Add, Custom, ClassReBarWindow32 0x0800 0x0100
;
; RBS_BANDBORDERS   := 0x0400 - Add a separator border between bands in different rows.
; RBS_DBLCLKTOGGLE  := 0x8000 - Toggle maximize/minimize with double-click instead of single.
; RBS_FIXEDORDER    := 0x0800 - Always displays bands in the same order.
; RBS_VARHEIGHT     := 0x0200 - Allow bands to have different heights.
; CCS_NODIVIDER     := 0x0040 - Removes the separator line above the rebar.
; CCS_NOPARENTALIGN := 0x0008 - Allows positioning and moving rebars.
; CCS_NORESIZE      := 0x0004 - Allows resizing rebars.
; CCS_VERT          := 0x0080 - Creates a vertical rebar.
;
;=======================================================================================
Class Rebar extends Rebar.Private
{
;=======================================================================================
;    Method:             Delete
;    Description:        Deletes a band from a rebar control.
;    Parameters:
;        Band:           1-based index of the band to be deleted.
;    Return:             TRUE if successful, FALSE if there was a problem.
;=======================================================================================
    DeleteBand(Band)
    {
        SendMessage, this.RB_DELETEBAND, Band-1, 0,, % "ahk_id " this.rbHwnd
        return (ErrorLevel = "FAIL") ? false : true
    }
;=======================================================================================
;    Method:             GetBand
;    Description:        Retrieves information from a rebar band.
;    Parameters:
;        Band:           1-based index of the band.
;        ID:             OutputVar to store the band's ID.
;        Text:           OutputVar to store the band's text.
;        Size:           OutputVar to store the band's size.
;        Image:          OutputVar to store the band's image index.
;        Background:     OutputVar to store a handle to the band's background bitmap.
;        Style:          OutputVar to store the band's style numeric value.
;        Child:          OutputVar to store a handle to the band's child control.
;    Return:             TRUE if successful, FALSE if there was a problem.
;=======================================================================================
    GetBand(Band, ByRef ID := "", ByRef Text := "", ByRef Size := "", ByRef Image := ""
    ,   ByRef Background := "", ByRef Style := "", ByRef Child := "")
    {
        Static cbSize := 48 + (8 * A_PtrSize)
        fMask := (IsByRef(Style) ? this.RBBIM_STYLE : 0)
               | (IsByRef(Text) ? this.RBBIM_TEXT : 0)
               | (IsByRef(Image) ? this.RBBIM_IMAGE : 0)
               | (IsByRef(Child) ? this.RBBIM_CHILD : 0)
               | (IsByRef(Size) ? this.RBBIM_SIZE : 0)
               | (IsByRef(Background) != "" ? this.RBBIM_BACKGROUND : 0)
               | (IsByRef(ID) ? this.RBBIM_ID : 0)
    ,   VarSetCapacity(rbBand, cbSize, 0)
    ,   NumPut(cbSize, rbBand, 0, "UInt"), NumPut(fMask, rbBand, 4, "UInt")
    ,   VarSetCapacity(bText, 64, 0)
    ,   NumPut(&bText, rbBand, 16 + A_PtrSize, "UPtr"), NumPut(64, rbBand, 16 + (A_PtrSize * 2), "UInt")
        
        SendMessage, this.RB_GETBANDINFO, Band-1, &rbBand,, % "ahk_id " this.rbHwnd
        Style := NumGet(&rbBand, 8, "UInt"), Text := StrGet(&bText)
    ,   Image := NumGet(&rbBand, 20 + (A_PtrSize * 2), "Int")+1
    ,   Child := NumGet(&rbBand, 24 + (A_PtrSize * 2), "UPtr")
    ,   Size := NumGet(&rbBand, 32 + (A_PtrSize * 3), "UInt")
    ,   Background := NumGet(&rbBand, 32 + (A_PtrSize * 4), "UPtr")
    ,   ID := NumGet(&rbBand, 32 + (A_PtrSize * 5), "UInt")
        return (ErrorLevel = "FAIL") ? false : true
    }
;=======================================================================================
;    Method:             GetBandCount
;    Description:        Retrieves the count of bands currently in the rebar control.
;    Return:             The number of bands in the rebar control.
;=======================================================================================
    GetBandCount()
    {
        SendMessage, this.RB_GETBANDCOUNT, 0, 0,, % "ahk_id " this.rbHwnd
        return ErrorLevel
    }
;=======================================================================================
;    Method:             GetBarHeight
;    Description:        Retrieves the height of the rebar control.
;    Return:             The height of the rebar control in pixels.
;=======================================================================================
    GetBarHeight()
    {
        SendMessage, this.RB_GETBARHEIGHT, 0, 0,, % "ahk_id " this.rbHwnd
        return ErrorLevel
    }
;=======================================================================================
;    Method:             GetLayout
;    Description:        Retrieves the current layout of bands in the rebar control.
;    Return:             A string containing information about the current bands.
;                            String format is: ID1,Size1,Style1|ID2,Size2,Style2|...
;=======================================================================================
    GetLayout()
    {
        Loop % this.GetBandCount()
        {
            this.GetBand(A_Index, ID, "", Size, "", "", Style)
            Layout .= ID "," Size "," Style "|"
        }
        return Layout
    }
;=======================================================================================
;    Method:             GetRowCount
;    Description:        Retrieves the number of rows of bands in a rebar control.
;    Return:             The number of rows in the rebar control.
;=======================================================================================
    GetRowCount()
    {
        SendMessage, this.RB_GETROWCOUNT, 0, 0,, % "ahk_id " this.rbHwnd
        return ErrorLevel
    }
;=======================================================================================
;    Method:             GetRowHeight
;    Description:        Retrieves the number of rows of bands in a rebar control.
;    Parameters:
;        Band:           1-based index of a band to retrieve the height from.
;    Return:             The height of the row from the corresponding band in pixels.
;=======================================================================================
    GetRowHeight(Band)
    {
        SendMessage, this.RB_GETROWHEIGHT, Band-1, 0,, % "ahk_id " this.rbHwnd
        return ErrorLevel
    }
;=======================================================================================
;    Method:             IDToIndex
;    Description:        Converts a band identifier to a band index in a rebar control.
;    Parameters:
;        ID:             The application-defined identifier of the band in question.
;    Return:             The 1-based band index if successful, or 0 otherwise.
;=======================================================================================
    IDToIndex(ID)
    {
        SendMessage, this.RB_IDTOINDEX, ID, 0,, % "ahk_id " this.rbHwnd
        return ErrorLevel+1
    }
;=======================================================================================
;    Method:             InsertBand
;    Description:        Inserts a new band in a rebar control.
;    Parameters:
;        hChild:         Handle to the control contained in the band, if any.
;        Position:       1-based index of the location where the band will be inserted.
;                            If you set this parameter to 0, the control will add the
;                            new band at the last location.
;        Options:        Enter zero or more words, separated by space or tab, from the
;                            following list to set the band's initial styles:
;                            Break, FixedBmp, FixedSize, Hidden, HideTitle, NoGripper,
;                            NoVert, TopAlign, VariableHeight.
;                        The following styles are applied by default: ChildEdge,
;                            GripperAlways (can be disabled with NoGripper), UseChevron
;                            (only valid if IdealSize is set).
;        ID:             Integer value that the control uses to identify this band.
;                            This parameter is required to retrieve and set layouts.
;        Text:           The display text for the band.
;        Size:           Length of the band, in pixels.
;        Image:          1-based index of any image that should be displayed in the band.
;                            SetImageList method must be called prior to this.
;        Background:     Path of a bitmap file that is used as the background for this band.
;        MinHeight:      Minimum height of the control, in pixels.
;        MinWidth:       Minimum width of the control, in pixels.
;        IdealSize:      Ideal width of the band, in pixels. If the band is maximized to
;                            the ideal width (see MaximizeBand method), the rebar control
;                            will attempt to make the band this width.
;    Return:             TRUE if successful, FALSE if there was a problem.
;=======================================================================================
    InsertBand(hChild, Position := 0, Options := "", ID := "", Text := "", Size := "", Image := 0, Background := ""
        , MinHeight := 23, MinWidth := 25, IdealSize := "")
    {
        Options := "ChildEdge GripperAlways UseChevron " Options
    ,   this.DefineBandStruct(rbBand, Options, ID, Text, Size, Image, Background
            , MinWidth, MinHeight, IdealSize, hChild)
        SendMessage, this.RB_INSERTBAND, Position-1, &rbBand,, % "ahk_id " this.rbHwnd
        return (ErrorLevel = "FAIL") ? false : true
    }
;=======================================================================================
;    Method:             MaximizeBand
;    Description:        Resizes a band to either its ideal or largest size.
;    Parameters:
;        Band:           1-based index of a band to be maximized.
;        IdealWidth:     If TRUE the ideal width of the band will be used to maximize
;    Return:             TRUE if successful, FALSE if there was a problem.
;=======================================================================================
    MaximizeBand(Band, IdealWidth := false)
    {
        SendMessage, this.RB_MAXIMIZEBAND, Band-1, IdealWidth,, % "ahk_id " this.rbHwnd
        return (ErrorLevel = "FAIL") ? false : true
    }
;=======================================================================================
;    Method:             MinimizeBand
;    Description:        Resizes a band to its smallest size.
;    Parameters:
;        Band:           1-based index of a band to be minimized.
;    Return:             TRUE if successful, FALSE if there was a problem.
;=======================================================================================
    MinimizeBand(Band)
    {
        SendMessage, this.RB_MINIMIZEBAND, Band-1, 0,, % "ahk_id " this.rbHwnd
        return (ErrorLevel = "FAIL") ? false : true
    }
;=======================================================================================
;    Method:             ModifyBand
;    Description:        Sets band parameters such as Text and Size.
;    Parameters:
;        Band:           1-based index of a band to be modified.
;        Property:       Enter one word from the following list to select the Property
;                            to be set: Style, ID, Text, Size, Image, Background,
;                            MinWidth, MinHeight, IdealSize, Child (handle of control).
;        Value:          The value to be set in the selected Property.
;                            If Property is Style you can enter named values as
;                            in the InsertBand options, or an integer value.
;        SetStyle:       Only valid if Property is Style. Determines whether to add or
;                            remove the styles.
;    Return:             TRUE if successful, FALSE if there was a problem.
;=======================================================================================
    ModifyBand(Band, Property, Value, SetStyle := true)
    {
        If (Property = "Style")
        {
            If Value is Integer
                Value := Value
            Else
            {
                Loop, Parse, Value, %A_Space%%A_Tab%
                {
                    If (this[ "RBBS_" A_LoopField ])
                        rbStyle += this[ "RBBS_" A_LoopField ]
                }
                Value := rbStyle
            }
            this.GetBand(Band, "", "", "", "", "", bdStyle)
            If (SetStyle)
                Value |= bdStyle
            Else
                Value ^= bdStyle
        }
        If ((this[ "RBBIM_" Property ]) || (Property = "MinWidth") || (Property = "MinHeight"))
            %Property% := Value
        this.DefineBandStruct(rbBand, Style, ID, Text, Size, Image, Background
                            , MinWidth, MinHeight, IdealSize, Child)
        SendMessage, this.RB_SETBANDINFO, Band-1, &rbBand,, % "ahk_id " this.rbHwnd
        return (ErrorLevel = "FAIL") ? false : true
    }
;=======================================================================================
;    Method:             MoveBand
;    Description:        Moves a band from one index to another.
;    Parameters:
;        Band:           1-based index of a band to be moved.
;        Target:         1-based index of a the new band position.
;    Return:             TRUE if successful, FALSE if there was a problem.
;=======================================================================================
    MoveBand(Band, Target)
    {
        SendMessage, this.RB_MOVEBAND, Band-1, Target-1,, % "ahk_id " this.rbHwnd
        this.ShowBand(Band)
        return (ErrorLevel = "FAIL") ? false : true
    }
;=======================================================================================
;    Method:             OnNotify
;    Description:        Handles rebar notifications.
;                        This method should be called from the rebar's G-Label.
;                            If A_GuiEvent is "N", pass it A_EventInfo as the Param.
;                        You can also call it from a function monitoring the WM_NOTIFY
;                            message, pass it lParam as the Param.
;                        Currently this method is used to retrieve the position for
;                            a menu when the Chevron button is pushed and prevent a number
;                            of rows higher then the one set by SetMaxRows method.
;    Parameters:
;        Param:          The lParam from WM_NOTIFY message.
;        MenuXPos:       OutputVar to store the horizontal position for a menu.
;        MenuYPos:       OutputVar to store the vertical position for a menu.
;        ID:             OutputVar to store the band's ID.
;    Return:             If the ChevronPushed notification is passed returns the index
;                            of the band it is from.
;=======================================================================================
    OnNotify(ByRef Param, ByRef MenuXPos := "", ByRef MenuYPos := "", ByRef ID := "")
    {
        nCode  := NumGet(Param + (A_PtrSize * 2), 0, "Int"), rbHwnd := NumGet(Param + 0, 0, "UPtr")
        If (rbHwnd != this.rbHwnd)
            return ""
        If (nCode = this.RBN_CHEVRONPUSHED)
        {
            ControlGetPos, RBX, RBY,,,, % "ahk_id " this.rbHwnd
            ID := NumGet(Param + (4 + (A_PtrSize * 3)), 0, "Int")
        ,   MenuXPos := RBX + NumGet(Param + (A_PtrSize * 4 - 4), 12, "Int")
        ,   MenuYPos := RBY + NumGet(Param + (A_PtrSize * 4 - 4), 24, "Int")
            return NumGet(Param + (A_PtrSize * 3), 0, "Int") + 1
        }
        If ((nCode = this.RBN_HEIGHTCHANGE) && (this.MaxRows))
        {
            Loop, % this.GetBandCount()
            {
                this.GetBand(A_Index, "", "", "", "", "", Style)
                If (Style & 0x0001)
                    LastBrkBand := A_Index
            }
            If (this.GetRowCount() > this.MaxRows)
                this.ModifyBand(LastBrkBand, "Style", "Break", false)
        }
        return ""
    }
;=======================================================================================
;    Method:             SetBandStyle
;    Description:        Sets the style of a band.
;    Parameters:
;        Band:           1-based index of the band.
;        Value:          Named values as in the InsertBand options, or an integer value.
;    Return:             TRUE if successful, FALSE if there was a problem.
;=======================================================================================
    SetBandStyle(Band, Value)
    {
        this.DefineBandStruct(rbBand, Value)
        SendMessage, this.RB_SETBANDINFO, Band-1, &rbBand,, % "ahk_id " this.rbHwnd
        return (ErrorLevel = "FAIL") ? false : true
    }
;=======================================================================================
;    Method:             SetBandWidth
;    Description:        Sets the width for a docked band.
;    Parameters:
;        Band:           1-based index of the band.
;        Width:          New width in pixels.
;    Return:             TRUE if successful, FALSE if there was a problem.
;=======================================================================================
    SetBandWidth(Band, Width)
    {
        this.DefineBandStruct(rbBand, "", "", "", Width)
        SendMessage, this.RB_SETBANDINFO, Band-1, &rbBand,, % "ahk_id " this.rbHwnd
        return (ErrorLevel = "FAIL") ? false : true
    }
;=======================================================================================
;    Method:             SetImageList
;    Description:        Sets an ImageList to the rebar control.
;    Parameters:
;        ImageList:      ImageList ID.
;    Return:             TRUE if successful, FALSE if there was a problem.
;=======================================================================================
    SetImageList(ImageList)
    {
        this.DefineBarStruct(rBarInfo, ImageList)
        SendMessage, this.RB_SETBARINFO, 0, &rBarInfo,, % "ahk_id " this.rbHwnd
        return (ErrorLevel = "FAIL") ? false : true
    }
;=======================================================================================
;    Method:             SetLayout
;    Description:        Sets a layout of bands in the rebar control.
;    Parameters:
;        Layout:         A string containing information about the current bands.
;                            String format is: ID1,Size1,Style1|ID2,Size2,Style2|...
;    Return:             TRUE if a valid layout was passed, or FALSE otherwise.
;=======================================================================================
    SetLayout(Layout)
    {
        Loop, Parse, Layout, |, %A_Space%
        {
            StringSplit, Par, A_LoopField, `,, %A_Space%
            Index := this.IDToIndex(Par1), this.SetBandStyle(Index, Par3)
        ,   this.SetBandWidth(Index, Par2), this.MoveBand(Index, A_Index)
        }
        return Par0 ? true : false
    }
;=======================================================================================
;    Method:             SetMaxRows
;    Description:        Sets the maximum number of rows allowed in a rebar control.
;                        This method requires the OnNotify method to be implemented.
;    Parameters:
;        Rows:           Number of maximum rows allowed. Set it to 0 to disable limit.
;    Return:             The number of rows previously allowed.
;=======================================================================================
    SetMaxRows(Rows := 0)
    {
        LastValue := this.MaxRows, this.MaxRows := Rows
        return LastValue
    }
;=======================================================================================
;    Method:             ShowBand
;    Description:        Shows or hides a given band in a rebar control.
;    Parameters:
;        Band:           1-based index of the band.
;        Show:           Set to TRUE to show the band or FALSE to hide it.
;    Return:             TRUE if successful, FALSE if there was a problem.
;=======================================================================================
    ShowBand(Band, Show := true)
    {
        SendMessage, this.RB_SHOWBAND, Band-1, %Show%,, % "ahk_id " this.rbHwnd
        return (ErrorLevel = "FAIL") ? false : true
    }
;=======================================================================================
;    Method:             ToggleStyle
;    Description:        Toggles rebar's style.
;    Parameters:
;        Style:          Enter one or more words, separated by space or tab, from the
;                            following list to toggle toolbar's styles:
;                            AutoSize, BandBorders, DblClkToggle, FixedOrder,
;                            RegisterDropdown, VarHeight, VerticalGripper.
;                        You may also enter an integer value to define the style.
;    Return:             TRUE if a valid style is passed, or FALSE otherwise.
;=======================================================================================
    ToggleStyle(Style)
    {
        If Style is Integer
            rbStyle := Style
        Else
        {
            Loop, Parse, Style, %A_Space%%A_Tab%
            {
                If (this[ "RBS_" A_LoopField ] )
                    rbStyle += this[ "RBS_" A_LoopField ]
            }
        }
        If (rbStyle != "")
        {
            WinSet, Style, ^%rbStyle%, % "ahk_id " this.rbHwnd
            return true
        }
        Else
            return false
    }
;=======================================================================================
;    Private Class       This class is used internally.
;=======================================================================================
    Class Private
    {
;=======================================================================================
;    Private Properties
;=======================================================================================
        ; Messages
        Static RB_DELETEBAND          := 0x0402
        Static RB_GETBARINFO          := 0x0403
        Static RB_SETBARINFO          := 0x0404
        Static RB_GETBANDINFO         := 0x0405
        Static RB_GETRECT             := 0x0409
        Static RB_INSERTBAND          := A_IsUnicode ? 0x040A : 0x0401
        Static RB_SETBANDINFO         := A_IsUnicode ? 0x040B : 0x0406
        Static RB_GETBANDCOUNT        := 0x040C
        Static RB_GETROWCOUNT         := 0x040D
        Static RB_GETROWHEIGHT        := 0x040E
        Static RB_IDTOINDEX           := 0x0410
        Static RB_GETBARHEIGHT        := 0x041B
        Static RB_GETBANDINFOW        := 0x041C
        Static RB_GETBANDINFOA        := 0x041D
        Static RB_MINIMIZEBAND        := 0x041E
        Static RB_MAXIMIZEBAND        := 0x041F
        Static RB_SHOWBAND            := 0x0423
        Static RB_MOVEBAND            := 0x0427
        Static RB_GETBANDMARGINS      := 0x0428
        Static RB_SETEXTENDEDSTYLE    := 0x0429
        Static RB_GETEXTENDEDSTYLE    := 0x042A
        Static RB_SETBANDWIDTH        := 0x042C
        ; Notifications
        Static RBN_AUTOBREAK          := -853
        Static RBN_AUTOSIZE           := -834
        Static RBN_BEGINDRAG          := -835
        Static RBN_CHEVRONPUSHED      := -841
        Static RBN_CHILDSIZE          := -839
        Static RBN_DELETEDBAND        := -838
        Static RBN_DELETINGBAND       := -837
        Static RBN_ENDDRAG            := -836
        Static RBN_GETOBJECT          := -832
        Static RBN_HEIGHTCHANGE       := -831
        Static RBN_LAYOUTCHANGED      := -833
        Static RBN_MINMAX             := -852
        Static RBN_SPLITTERDRAG       := -842
        ; Styles
        Static RBS_AUTOSIZE           := 0x2000
        Static RBS_BANDBORDERS        := 0x0400
        Static RBS_DBLCLKTOGGLE       := 0x8000
        Static RBS_FIXEDORDER         := 0x0800
        Static RBS_REGISTERDROP       := 0x1000
        Static RBS_TOOLTIPS           := 0x0100
        Static RBS_VARHEIGHT          := 0x0200
        Static RBS_VERTICALGRIPPER    := 0x4000 ; // this always has the vertical gripper (default for horizontal mode)
        ; REBARBANDINFO fMask
        Static RBBIM_BACKGROUND       := 0x0080
        Static RBBIM_CHEVRONLOCATION  := 0x1000 ; >= Vista
        Static RBBIM_CHEVRONSTATE     := 0x2000 ; >= Vista
        Static RBBIM_CHILD            := 0x0010
        Static RBBIM_CHILDSIZE        := 0x0020
        Static RBBIM_COLORS           := 0x0002
        Static RBBIM_HEADERSIZE       := 0x0800 ; // control the size of the header
        Static RBBIM_ID               := 0x0100
        Static RBBIM_IDEALSIZE        := 0x0200
        Static RBBIM_IMAGE            := 0x0008
        Static RBBIM_LPARAM           := 0x0400
        Static RBBIM_SIZE             := 0x0040
        Static RBBIM_STYLE            := 0x0001
        Static RBBIM_TEXT             := 0x0004
        ; REBARBANDINFO fStyle
        Static RBBS_BREAK             := 0x0001 ; // break to new line
        Static RBBS_CHILDEDGE         := 0x0004 ; // edge around top & bottom of child window
        Static RBBS_FIXEDBMP          := 0x0020 ; // bitmap doesn't move during band resize
        Static RBBS_FIXEDSIZE         := 0x0002 ; // band can't be sized
        Static RBBS_GRIPPERALWAYS     := 0x0080 ; // always show the gripper
        Static RBBS_HIDDEN            := 0x0008 ; // don't show
        Static RBBS_HIDETITLE         := 0x0400 ; // keep band title hidden
        Static RBBS_NOGRIPPER         := 0x0100 ; // never show the gripper
        Static RBBS_NOVERT            := 0x0010 ; // don't show when vertical
        Static RBBS_TOPALIGN          := 0x0800 ; // keep band in top row
        Static RBBS_USECHEVRON        := 0x0200 ; // display drop-down button for this band if it's sized smaller than ideal width
        Static RBBS_VARIABLEHEIGHT    := 0x0040 ; // allow autosizing of this child vertically
;=======================================================================================
;    Meta-Functions
;
;    Properties:
;        rbHwnd:            Rebar's Hwnd.
;        MaxRows:           Maximum number of rows allowed. Initially set to "no limit".
;=======================================================================================
        __New(hRebar)
        {
            this.rbHwnd := hRebar
        ,   this.MaxRows := 0
        }
;=======================================================================================
        __Delete()
        {
            this.RemoveAt(1, this.Length())
        ,   this.SetCapacity(0)
        ,   this.base := ""
        }
;=======================================================================================
;    Private Methods
;=======================================================================================
;    Method:             DefineBandStruct
;    Description:        Creates a REBARBANDINFO structure.
;=======================================================================================
        DefineBandStruct(ByRef BandVar, Options := "", wID := "", ByRef lpText := "", cx := "", iImage := "", hbmBack := ""
        , cxMinChild := "", cyMinChild := "", cxIdeal := "", hwndChild := "")
        {
            Static cbSize := 48 + (8 * A_PtrSize)
            
            If Options is Integer
                fStyle := Options
            Else
            {
                Loop, Parse, Options, %A_Space%%A_Tab%
                {
                    If (this[ "RBBS_" A_LoopField ])
                        fStyle += this[ "RBBS_" A_LoopField ]
                }
            }
            If (hbmBack)
                hbmBack := DllCall("LoadImage", "UPtr", 0, "Str", hbmBack, "UInt", 0, "UInt", 0, "UInt", 0, "UInt", 0x10)
            
            fMask := (Options != "" ? this.RBBIM_STYLE : 0)
                    | (lpText != "" ? this.RBBIM_TEXT : 0)
                    | (iImage ? this.RBBIM_IMAGE : 0)
                    | (hwndChild ? this.RBBIM_CHILD | this.RBBIM_SIZE | this.RBBIM_IDEALSIZE : 0)
                    | (cx ? this.RBBIM_SIZE : 0)
                    | (hbmBack != "" ? this.RBBIM_BACKGROUND : 0)
                    | (wID ? this.RBBIM_ID : 0)
                    | (cxMinChild || cyMinChild ? this.RBBIM_CHILDSIZE : 0)
                    | (cxIdeal ? this.RBBIM_IDEALSIZE : 0)
            
            VarSetCapacity(BandVar, cbSize, 0)
        ,   NumPut(cbSize, BandVar, 0, "UInt")
        ,   NumPut(fMask, BandVar, 4, "UInt")
        ,   NumPut(fStyle, BandVar, 8, "UInt")
        ,   NumPut(&lpText, BandVar, 16 + A_PtrSize, "UPtr")
        ,   NumPut(iImage-1, BandVar, 20 + (A_PtrSize * 2), "Int")
        ,   NumPut(hwndChild, BandVar, 24 + (A_PtrSize * 2), "UPtr")
        ,   NumPut(cxMinChild, BandVar, 24 + (A_PtrSize * 3), "UInt")
        ,   NumPut(cyMinChild, BandVar, 28 + (A_PtrSize * 3), "UInt")
        ,   NumPut(cx, BandVar, 32 + (A_PtrSize * 3), "UInt")
        ,   NumPut(hbmBack, BandVar, 32 + (A_PtrSize * 4), "UPtr")
        ,   NumPut(wID, BandVar, 32 + (A_PtrSize * 5), "UInt")
        ,   NumPut(cxIdeal, BandVar, 48 + (A_PtrSize * 5), "UInt")
        }
;=======================================================================================
;    Method:             DefineBarStruct
;    Description:        Creates a REBARINFO structure.
;=======================================================================================
        DefineBarStruct(ByRef BandVar, himl)
        {
            Static cbSize := 8 + A_PtrSize
            Static fMask := 0x0001
            
            VarSetCapacity(BandVar, cbSize, 0)
        ,   NumPut(cbSize, BandVar, 0, "UInt")
        ,   NumPut(fMask, BandVar, 4, "UInt")
        ,   NumPut(himl, BandVar, 8, "UPtr")
        }
    }
}