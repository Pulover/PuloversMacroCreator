;###########################################################
; Title: Scintilla Wrapper for AHK
; Original by RaptorX
; http://www.autohotkey.com/board/topic/85928-wrapper-scintilla-wrapper
; Modified by Pulover to work with Gui Custom Controls.
;###########################################################
class scintilla {
    hwnd            := 0        ; Component Handle
    notify          := ""       ; Name of the function that will handle the window messages sent by the control

                                ; Messages which set this variables.
                                ; ---------------------------------------------------------------------------------------------------------------
    idFrom          := 0        ; The handle from which the notification was sent
    scnCode         := 0        ; The SCN_* notification code
    position        := 0        ; SCN_STYLENEEDED, SCN_DOUBLECLICK, SCN_MODIFIED, SCN_MARGINCLICK
                                ; SCN_NEEDSHOWN, SCN_DWELLSTART, SCN_DWELLEND, SCN_CALLTIPCLICK
                                ; SCN_HOTSPOTCLICK, SCN_HOTSPOTDOUBLECLICK, SCN_HOTSPOTRELEASECLICK
                                ; SCN_INDICATORCLICK, SCN_INDICATORRELEASE
                                ; SCN_USERLISTSELECTION, SCN_AUTOCSELECTION

    ch              := 0        ; SCN_CHARADDED, SCN_KEY
    modifiers       := 0        ; SCN_KEY, SCN_DOUBLECLICK, SCN_HOTSPOTCLICK, SCN_HOTSPOTDOUBLECLICK
                                ; SCN_HOTSPOTRELEASECLICK, SCN_INDICATORCLICK, SCN_INDICATORRELEASE

    modType         := 0        ; SCN_MODIFIED
    text            := 0        ; SCN_MODIFIED, SCN_USERLISTSELECTION, SCN_AUTOCSELECTION, SCN_URIDROPPED
    length          := 0        ; SCN_MODIFIED
    linesAdded      := 0        ; SCN_MODIFIED
    macMessage      := 0        ; SCN_MACRORECORD
    macwParam       := 0        ; SCN_MACRORECORD
    maclParam       := 0        ; SCN_MACRORECORD
    line            := 0        ; SCN_MODIFIED
    foldLevelNow    := 0        ; SCN_MODIFIED
    foldLevelPrev   := 0        ; SCN_MODIFIED
    margin          := 0        ; SCN_MARGINCLICK
    listType        := 0        ; SCN_USERLISTSELECTION
    x               := 0        ; SCN_DWELLSTART, SCN_DWELLEND
    y               := 0        ; SCN_DWELLSTART, SCN_DWELLEND
    token           := 0        ; SCN_MODIFIED with SC_MOD_CONTAINER
    annotLinesAdded := 0        ; SCN_MODIFIED with SC_MOD_CHANGEANNOTATION
    updated         := false    ; SCN_UPDATEUI

    __new(hwnd){
        ; if (params.MaxIndex())
            __SCI(this.hwnd := hwnd, this)
        ; else
            ; return this
        __sendEditor(this.hwnd)               ; initialize sendEditor function
    }

    __call(msg, wParam := 0, lParam := 0, params*){

		if (msg = "Add")
            __SCI(this.hwnd := __Add(wParam, lParam, params*), this)
        else
        {
            (wParam && !(wParam+0) && !isObject(wParam)) ? (VarSetCapacity(wParamA, StrPut(wParam, scintilla.encoding))
                                                           ,StrPut(wParam, &wParamA, scintilla.encoding)
                                                           ,wParam:=&wParamA) : null

            (lParam && !(lParam+0) && !isObject(lParam)) ? (VarSetCapacity(lParamA, StrPut(lParam, scintilla.encoding))
                                                           ,StrPut(lParam, &lParamA, scintilla.encoding)
                                                           ,lParam:=&lParamA) : null

            /*
              Special Operations
              Due to the fact that some functions require the user to manually prepare bufferst to store text
              I decided to make most of those operations internally to have cleaner code later on.
            */

            (msg = "GetText") ? (VarSetCapacity(lParam, wParam * (a_isunicode ? 2 : 1)+8), lParam := &lParam, buf:=true) : null
            (msg = "GetLine") ? (VarSetCapacity(lParam, this.linelength(wParam)+1 * (a_isunicode ? 2 : 1)),lParam := &lParam, buf:=true) : null
	    (msg = "GetCurLine") ? (VarSetCapacity(lParam, this.linelength(wParam)+1 * (a_isunicode ? 2 : 1)), lParam := &lParam, buf:=true) : null
            (msg = "GetTextRange") ? (range:=abs(wParam.1 - wParam.2)+1, dSize :=  __sendEditor(this.hwnd, "GetLength")
                                     ,VarSetCapacity(lParam, range > dSize ? (dSize, wParam.2 := dSize) : range)
                                     ,VarSetCapacity(textRange, 12, 0)
                                     ,NumPut(wParam.1,textRange,0,"UInt")
                                     ,NumPut(wParam.2,textRange,4,"UInt")
                                     ,NumPut(&lParam,textRange,8,"UInt")
                                     ,blParam := &lParam, wParam := false,lParam := &textRange, buf:=true) : null

            __isHexColor(lParam, msg) ? lParam := (lParam & 0xFF) <<16 | (lParam & 0xFF00) | (lParam >>16) : null
            __isHexColor(wParam, msg) ? wParam := (wParam & 0xFF) <<16 | (wParam & 0xFF00) | (wParam >>16) : null

            res := __sendEditor(this.hwnd, msg, wParam, lParam)

			; Retrieve Text from buffer
            ; I must switch lParam to another variable when using GetTextRange because lParam cant be overwriten
            ; It has the pointer to the TextRange Structure
            buf ? (lParam := StrGet((msg = "GetTextRange") ? blParam : &lParam, "CP0"), buf:=false) : null ; convert the text from ANSI
            return (msg = "GetText") ? lParam : res
        }
    }
}

class sciCharRange {

    __new(_cMin := 0, _cMax := 0){

        this.cMin := _cMin
        this.cMax := _cMax
    }
}
class sciTextRange {

    __new(_chrg := 0, _pStr := 0){

        if (!isObject(_chrg)){
            Msgbox % 0x0
                   , % "sciTextRange Object Error"
                   , % "The first parameter must match a sciCharRange object"
            Exit
        }

        this.chrg := _chrg ? _chrg : new sciCharRange
        this.pStr := _pStr
    }
}
class sciTextToFind {

    __new(_chrg := 0, _text := "", _found := 0){

        if (!isObject(_chrg) || !isObject(_found)) {
            Msgbox % 0x0
                   , % "sciTextToFind Object Error"
                   , % "The first and last parameters must match a sciCharRange object"
            Exit
        }

        this.chrg   := _chrg ? _chrg : new sciCharRange
        this.text   := _text
        this.found  := _found ? _found : new sciCharRange
    }
}
class sciRectangle {

    __new(_left := 0, _top := 0, _right := 0, _bottom := 0){

        this.left    := _left
        this.top     := _top
        this.right   := _right
        this.bottom  := _bottom
    }
}
class sciRangeToFormat {

    __new(_hdc := 0, _hdcTarget := 0, _rc := 0, _rcPage := 0, _chrg := 0){
        this.hdc         := _hdc                                        ; The Surface ID we print to
        this.hdcTarget   := _hdcTarget                                  ; The Surface ID we use for measuring (may be same as hdc)
        this.rc          := _rc ? _rc : new sciRectangle                ; Rectangle in which to print
        this.rcPage      := _rcPage ? _rcPage : new sciRectangle        ; Physically printable page size
        this.chrg        := _chrg ? _chrg : new sciCharRange            ; Range of characters to print
    }
}

; | Internal Functions |

/*
    Function: __Add
    Creates a Scintilla component and adds it to the Parent GUI.

    This function initializes the Scintilla Component.
    See <http://www.scintilla.org/Steps.html> for more information on how to add the component to a GUI/Control.

    Parameters:
    __Add(hParent, [x, y, w, h, DllPath, Styles])

    hParent     -   Hwnd of the parent control who will host the Scintilla Component
    x           -   x position for the control (default 5)
    y           -   y position for the control (default 5)
    w           -   Width of the control (default 590)
    h           -   Height of the control (default 390)
    DllPath     -   Path to the SciLexer.dll file, if omitted the function looks for it in *a_scriptdir*.
    Styles      -   List of window style variable names separated by spaces.
                    The WS_ prefix for the variables is optional.
                    Full list of Style names can be found at
                    <http://msdn.microsoft.com/en-us/library/czada357.aspx>.

    Returns:
    HWND        -   Component handle.

    Examples:
    (start code)
    #include ..\SCI.ahk
    #singleinstance force

    ;---------------------
    ; This script adds a component with default values.
    ; If no path was specified when creating the object it expects scilexer.dll to be on the script's location.
    ; The default values are calculated to fit optimally on a 600x400 GUI/Control

    Gui +LastFound
    sci := new scintilla(WinExist())

    Gui, show, w600 h400
    return

    GuiClose:
        exitapp

    ;---------------------
    #include ..\SCI.ahk
    #singleinstance force

    ; Add multiple components.

    Gui +LastFound
    hwnd:=WinExist()

    sci1 := new scintilla(hwnd, 0, 0, 590, 190) ; you can put the parameters here
    sci2 := new scintilla

    sci2.add(hwnd, 0, 200, 590, 190) ; or you can use the add function like this

    Gui, show, w600 h400
    return

    GuiClose:
        exitapp

    ;---------------------
    #include ..\SCI.ahk
    #singleinstance force

    ; Here we add a component embedded in a tab.
    ; If the variables "x,w,h" are empty the default values are used.

    Gui, add, Tab2, HWNDhwndtab x0 y0 w600 h420 gtabHandler vtabLast,one|two

    sci := new scintilla
    sci.Add(hwndtab, x, 25, w, h, a_scriptdir "\scilexer.dll")

    Gui, show, w600 h420
    return

    ; This additional code is for hiding/showing the component depending on which tab is open
    ; In this example the Tab named "one" is the one that contains the control.
    ; If you switch the words "show" and "hide" the component will be shown when the tab called "two" is active.

    tabHandler:                                 ; Tab Handler for the Scintilla Control
    Gui, submit, Nohide
    action := tabLast = "one" ? "Show" : "Hide" ; decide which action to take
    Control,%action%,,, % "ahk_id " sci.hwnd
    return

    GuiClose:
        exitapp
    (end)
*/
__Add(hParent := 0, x := 5, y := 5, w := 590, h := 390, DllPath := "", Styles := ""){
    static WS_OVERLAPPED:=0x00000000,WS_POPUP:=0x80000000,WS_CHILD:=0x40000000,WS_MINIMIZE:=0x20000000
    ,WS_VISIBLE:=0x10000000,WS_DISABLED:=0x08000000,WS_CLIPSIBLINGS:=0x04000000,WS_CLIPCHILDREN:=0x02000000
    ,WS_MAXIMIZE:=0x01000000,WS_CAPTION:=0x00C00000,WS_BORDER:=0x00800000,WS_DLGFRAME:=0x00400000
    ,WS_VSCROLL:=0x00200000,WS_HSCROLL:=0x00100000,WS_SYSMENU:=0x00080000,WS_THICKFRAME:=0x00040000
    ,WS_GROUP:=0x00020000,WS_TABSTOP:=0x00010000,WS_MINIMIZEBOX:=0x00020000,WS_MAXIMIZEBOX:=0x00010000
    ,WS_TILED:=0x00000000,WS_ICONIC:=0x20000000,WS_SIZEBOX:=0x00040000,WS_EX_CLIENTEDGE:=0x00000200
    ,GuiID:=311210,init:=false, null:=0

    DllPath := !DllPath ? "SciLexer.dll" : inStr(DllPath, ".dll") ? DllPath : DllPath "\SciLexer.dll"
    if !init        ;  WM_NOTIFY = 0x4E
        old:=OnMessage(0x4E,"__sciNotify"),init:=true
    __sendEditor(hSci)                    ; initialize sendEditor function

    ; if !SCIModule:=DllCall("LoadLibrary", "Str", DllPath)
        ; return debug ? A_ThisFunc "> Could not load library: " DllPath : 1

    hStyle := WS_CHILD | (VISIBILITY := InStr(Styles, "Hidden") ? 0 : WS_VISIBLE) | WS_TABSTOP

    if Styles
        Loop, Parse, Styles, %a_tab%%a_space%, %a_tab%%a_space%
            hStyle |= %a_loopfield%+0 ? %a_loopfield% : WS_%a_loopfield% ? WS_%a_loopfield% : 0

    ; hSci:=DllCall("CreateWindowEx"
                 ; ,Uint ,WS_EX_CLIENTEDGE                ; Ex Style
                 ; ,Str  ,"Scintilla"                     ; Class Name
                 ; ,Str  ,""                              ; Window Name
                 ; ,UInt ,hStyle                          ; Window Styles
                 ; ,Int  ,x ? x : 5                       ; x
                 ; ,Int  ,y ? y : 5                       ; y
                 ; ,Int  ,w ? w : 590                     ; Width
                 ; ,Int  ,h ? h : 390                     ; Height
                 ; ,UInt ,hParent ? hParent : WinExist()  ; Parent HWND
                 ; ,UInt ,GuiID                           ; (HMENU)GuiID
                 ; ,UInt ,null                            ; hInstance
                 ; ,UInt ,null, "UInt")                   ; lpParam

                 ,__sendEditor(hSci)                    ; initialize sendEditor function

    return hSci
}

/*
    Function : __sendEditor
    Posts the messages used to modify the control's behaviour.

    *This is an internal function and it is not needed in normal situations. Please use the scintilla object to call all functions.
    They call this function automatically*

    Parameters:
    __sendEditor(hwnd, msg, [wParam, lParam])

    hwnd    -   The hwnd of the control that you want to operate on. Useful for when you have more than 1
                Scintilla components in the same script. The wrapper will remember the last used hwnd,
                so you can specify it once and only specify it again when you want to operate on a different
                component.
                *Note: This is converted internally by the wrapper from the object calling method. It is recommended that you dont use this function.*
    msg     -   The message to be posted, full list can be found here:
                <http://www.scintilla.org/ScintillaDoc.html>
    wParam  -   wParam for the message
    lParam  -   lParam for the message

    Returns:
    Status code of the DllCall performed.

    Examples:
    (Start Code)
    __sendEditor(hSci1, "SCI_SETMARGINWIDTHN",0,40)  ; Set the margin 0 to 40px on the first component.
    __sendEditor(0, "SCI_SETWRAPMODE",1,0)           ; Set wrap mode to true on the last used component.
    __sendEditor(hSci2, "SCI_SETMARGINWIDTHN",0,50)  ; Set the margin 0 to 50px on the second component.
    (End)
*/
__sendEditor(hwnd, msg := 0, wParam := 0, lParam := 0){
	; Scintilla variables (made static for this modified version)
	static INVALID_POSITION := -1, unused := 0 ; Some messages dont use one of their parameters. You can use this variable for them.

	; Main Scintilla Functions
	static SCI_ADDTEXT:=2001,SCI_ADDSTYLEDTEXT:=2002,SCI_INSERTTEXT:=2003,SCI_CLEARALL:=2004,SCI_CLEARDOCUMENTSTYLE:=2005,SCI_GETLENGTH:=2006
	,SCI_GETCHARAT:=2007,SCI_GETCURRENTPOS:=2008,SCI_GETANCHOR:=2009,SCI_GETSTYLEAT:=2010,SCI_REDO:=2011,SCI_SETUNDOCOLLECTION:=2012
	,SCI_SELECTALL:=2013,SCI_SETSAVEPOINT:=2014,SCI_GETSTYLEDTEXT:=2015,SCI_CANREDO:=2016,SCI_MARKERLINEFROMHANDLE:=2017
	,SCI_MARKERDELETEHANDLE:=2018,SCI_GETUNDOCOLLECTION:=2019,SCI_GETVIEWWS:=2020,SCI_SETVIEWWS:=2021,SCI_POSITIONFROMPOINT:=2022
	,SCI_POSITIONFROMPOINTCLOSE:=2023,SCI_GOTOLINE:=2024,SCI_GOTOPOS:=2025,SCI_SETANCHOR:=2026,SCI_GETCURLINE:=2027,SCI_GETENDSTYLED:=2028
	,SCI_CONVERTEOLS:=2029,SCI_GETEOLMODE:=2030,SCI_SETEOLMODE:=2031,SCI_STARTSTYLING:=2032,SCI_SETSTYLING:=2033,SCI_GETBUFFEREDDRAW:=2034
	,SCI_SETBUFFEREDDRAW:=2035,SCI_SETTABWIDTH:=2036,SCI_GETTABWIDTH:=2121,SCI_SETCODEPAGE:=2037,SCI_SETUSEPALETTE:=2039,SCI_MARKERDEFINE:=2040
	static SCI_MARKERSETFORE:=2041,SCI_MARKERSETBACK:=2042,SCI_MARKERADD:=2043,SCI_MARKERDELETE:=2044,SCI_MARKERDELETEALL:=2045,SCI_MARKERGET:=2046
	,SCI_MARKERNEXT:=2047,SCI_MARKERPREVIOUS:=2048,SCI_MARKERDEFINEPIXMAP:=2049,SCI_MARKERADDSET:=2466,SCI_MARKERSETALPHA:=2476
	,SCI_SETMARGINTYPEN:=2240,SCI_GETMARGINTYPEN:=2241,SCI_SETMARGINWIDTHN:=2242,SCI_GETMARGINWIDTHN:=2243,SCI_SETMARGINMASKN:=2244
	,SCI_GETMARGINMASKN:=2245,SCI_SETMARGINSENSITIVEN:=2246,SCI_GETMARGINSENSITIVEN:=2247,SCI_STYLECLEARALL:=2050,SCI_STYLESETFORE:=2051
	,SCI_STYLESETBACK:=2052,SCI_STYLESETBOLD:=2053,SCI_STYLESETITALIC:=2054,SCI_STYLESETSIZE:=2055,SCI_STYLESETFONT:=2056
	,SCI_STYLESETEOLFILLED:=2057,SCI_STYLEGETFORE:=2481,SCI_STYLEGETBACK:=2482,SCI_STYLEGETBOLD:=2483,SCI_STYLEGETITALIC:=2484
	,SCI_STYLEGETSIZE:=2485,SCI_STYLEGETFONT:=2486,SCI_STYLEGETEOLFILLED:=2487,SCI_STYLEGETUNDERLINE:=2488,SCI_STYLEGETCASE:=2489
	static SCI_STYLEGETCHARACTERSET:=2490,SCI_STYLEGETVISIBLE:=2491,SCI_STYLEGETCHANGEABLE:=2492,SCI_STYLEGETHOTSPOT:=2493,SCI_STYLERESETDEFAULT:=2058
	,SCI_STYLESETUNDERLINE:=2059,SCI_STYLESETCASE:=2060,SCI_STYLESETCHARACTERSET:=2066,SCI_STYLESETHOTSPOT:=2409,SCI_SETSELFORE:=2067
	,SCI_SETSELBACK:=2068,SCI_GETSELALPHA:=2477,SCI_SETSELALPHA:=2478,SCI_SETCARETFORE:=2069,SCI_ASSIGNCMDKEY:=2070,SCI_CLEARCMDKEY:=2071
	,SCI_CLEARALLCMDKEYS:=2072,SCI_SETSTYLINGEX:=2073,SCI_STYLESETVISIBLE:=2074,SCI_GETCARETPERIOD:=2075,SCI_SETCARETPERIOD:=2076
	,SCI_SETWORDCHARS:=2077,SCI_BEGINUNDOACTION:=2078,SCI_ENDUNDOACTION:=2079,SCI_INDICSETSTYLE:=2080,SCI_INDICGETSTYLE:=2081
	,SCI_INDICSETFORE:=2082,SCI_INDICGETFORE:=2083,SCI_SETWHITESPACEFORE:=2084,SCI_SETWHITESPACEBACK:=2085,SCI_SETSTYLEBITS:=2090
	,SCI_GETSTYLEBITS:=2091,SCI_SETLINESTATE:=2092,SCI_GETLINESTATE:=2093,SCI_GETMAXLINESTATE:=2094,SCI_GETCARETLINEVISIBLE:=2095
	,SCI_SETCARETLINEVISIBLE:=2096,SCI_GETCARETLINEBACK:=2097,SCI_SETCARETLINEBACK:=2098,SCI_STYLESETCHANGEABLE:=2099,SCI_AUTOCSHOW:=2100
	,SCI_AUTOCCANCEL:=2101,SCI_AUTOCACTIVE:=2102,SCI_AUTOCPOSSTART:=2103,SCI_AUTOCCOMPLETE:=2104,SCI_AUTOCSTOPS:=2105
	,SCI_AUTOCSETSEPARATOR:=2106,SCI_AUTOCGETSEPARATOR:=2107,SCI_AUTOCSELECT:=2108,SCI_AUTOCSETCANCELATSTART:=2110
	static SCI_AUTOCGETCANCELATSTART:=2111,SCI_AUTOCSETFILLUPS:=2112,SCI_AUTOCSETCHOOSESINGLE:=2113,SCI_AUTOCGETCHOOSESINGLE:=2114
	,SCI_AUTOCSETIGNORECASE:=2115,SCI_AUTOCGETIGNORECASE:=2116,SCI_USERLISTSHOW:=2117,SCI_AUTOCSETAUTOHIDE:=2118,SCI_AUTOCGETAUTOHIDE:=2119
	,SCI_AUTOCSETDROPRESTOFWORD:=2270,SCI_AUTOCGETDROPRESTOFWORD:=2271,SCI_REGISTERIMAGE:=2405,SCI_CLEARREGISTEREDIMAGES:=2408
	,SCI_AUTOCGETTYPESEPARATOR:=2285,SCI_AUTOCSETTYPESEPARATOR:=2286,SCI_AUTOCSETMAXWIDTH:=2208,SCI_AUTOCGETMAXWIDTH:=2209
	,SCI_AUTOCSETMAXHEIGHT:=2210,SCI_AUTOCGETMAXHEIGHT:=2211,SCI_SETINDENT:=2122,SCI_GETINDENT:=2123,SCI_SETUSETABS:=2124,SCI_GETUSETABS:=2125
	,SCI_SETLINEINDENTATION:=2126,SCI_GETLINEINDENTATION:=2127,SCI_GETLINEINDENTPOSITION:=2128,SCI_GETCOLUMN:=2129,SCI_SETHSCROLLBAR:=2130
	,SCI_GETHSCROLLBAR:=2131,SCI_SETINDENTATIONGUIDES:=2132,SCI_GETINDENTATIONGUIDES:=2133,SCI_SETHIGHLIGHTGUIDE:=2134
	,SCI_GETHIGHLIGHTGUIDE:=2135,SCI_GETLINEENDPOSITION:=2136,SCI_GETCODEPAGE:=2137,SCI_GETCARETFORE:=2138,SCI_GETUSEPALETTE:=2139
	,SCI_GETREADONLY:=2140,SCI_SETCURRENTPOS:=2141,SCI_SETSELECTIONSTART:=2142,SCI_GETSELECTIONSTART:=2143,SCI_SETSELECTIONEND:=2144
	,SCI_GETSELECTIONEND:=2145,SCI_SETPRINTMAGNIFICATION:=2146,SCI_GETPRINTMAGNIFICATION:=2147,SCI_SETPRINTCOLORMODE:=2148
	,SCI_GETPRINTCOLORMODE:=2149,SCI_FINDTEXT:=2150,SCI_FORMATRANGE:=2151,SCI_GETFIRSTVISIBLELINE:=2152,SCI_GETLINE:=2153
	static SCI_GETLINECOUNT:=2154,SCI_SETMARGINLEFT:=2155,SCI_GETMARGINLEFT:=2156,SCI_SETMARGINRIGHT:=2157,SCI_GETMARGINRIGHT:=2158
	,SCI_GETMODIFY:=2159,SCI_SETSEL:=2160,SCI_GETSELTEXT:=2161,SCI_GETTEXTRANGE:=2162,SCI_HIDESELECTION:=2163,SCI_POINTXFROMPOSITION:=2164
	,SCI_POINTYFROMPOSITION:=2165,SCI_LINEFROMPOSITION:=2166,SCI_POSITIONFROMLINE:=2167,SCI_LINESCROLL:=2168,SCI_SCROLLCARET:=2169
	,SCI_REPLACESEL:=2170,SCI_SETREADONLY:=2171,SCI_NULL:=2172,SCI_CANPASTE:=2173,SCI_CANUNDO:=2174,SCI_EMPTYUNDOBUFFER:=2175,SCI_UNDO:=2176
	,SCI_CUT:=2177,SCI_COPY:=2178,SCI_PASTE:=2179,SCI_CLEAR:=2180,SCI_SETTEXT:=2181,SCI_GETTEXT:=2182,SCI_GETTEXTLENGTH:=2183
	,SCI_GETDIRECTFUNCTION:=2184,SCI_GETDIRECTPOINTER:=2185,SCI_SETOVERTYPE:=2186,SCI_GETOVERTYPE:=2187,SCI_SETCARETWIDTH:=2188
	,SCI_GETCARETWIDTH:=2189,SCI_SETTARGETSTART:=2190,SCI_GETTARGETSTART:=2191,SCI_SETTARGETEND:=2192,SCI_GETTARGETEND:=2193
	,SCI_REPLACETARGET:=2194,SCI_REPLACETARGETRE:=2195,SCI_SEARCHINTARGET:=2197,SCI_SETSEARCHFLAGS:=2198,SCI_GETSEARCHFLAGS:=2199
	,SCI_CALLTIPSHOW:=2200,SCI_CALLTIPCANCEL:=2201,SCI_CALLTIPACTIVE:=2202,SCI_CALLTIPPOSSTART:=2203,SCI_CALLTIPSETHLT:=2204
	,SCI_CALLTIPSETBACK:=2205,SCI_CALLTIPSETFORE:=2206,SCI_CALLTIPSETFOREHLT:=2207,SCI_CALLTIPUSESTYLE:=2212,SCI_VISIBLEFROMDOCLINE:=2220
	,SCI_DOCLINEFROMVISIBLE:=2221,SCI_WRAPCOUNT:=2235,SCI_SETFOLDLEVEL:=2222,SCI_GETFOLDLEVEL:=2223,SCI_GETLASTCHILD:=2224
	,SCI_GETFOLDPARENT:=2225,SCI_SHOWLINES:=2226,SCI_HIDELINES:=2227,SCI_GETLINEVISIBLE:=2228,SCI_SETFOLDEXPANDED:=2229
	static SCI_GETFOLDEXPANDED:=2230,SCI_TOGGLEFOLD:=2231,SCI_ENSUREVISIBLE:=2232,SCI_SETFOLDFLAGS:=2233,SCI_ENSUREVISIBLEENFORCEPOLICY:=2234
	,SCI_SETTABINDENTS:=2260,SCI_GETTABINDENTS:=2261,SCI_SETBACKSPACEUNINDENTS:=2262,SCI_GETBACKSPACEUNINDENTS:=2263,SCI_SETMOUSEDWELLTIME:=2264
	,SCI_GETMOUSEDWELLTIME:=2265,SCI_WORDSTARTPOSITION:=2266,SCI_WORDENDPOSITION:=2267,SCI_SETWRAPMODE:=2268,SCI_GETWRAPMODE:=2269
	,SCI_SETWRAPVISUALFLAGS:=2460,SCI_GETWRAPVISUALFLAGS:=2461,SCI_SETWRAPVISUALFLAGSLOCATION:=2462,SCI_GETWRAPVISUALFLAGSLOCATION:=2463
	,SCI_SETWRAPSTARTINDENT:=2464,SCI_GETWRAPSTARTINDENT:=2465,SCI_SETLAYOUTCACHE:=2272,SCI_GETLAYOUTCACHE:=2273,SCI_SETSCROLLWIDTH:=2274
	,SCI_GETSCROLLWIDTH:=2275,SCI_TEXTWIDTH:=2276,SCI_SETENDATLASTLINE:=2277,SCI_GETENDATLASTLINE:=2278,SCI_TEXTHEIGHT:=2279
	,SCI_SETVSCROLLBAR:=2280,SCI_GETVSCROLLBAR:=2281,SCI_APPENDTEXT:=2282,SCI_GETTWOPHASEDRAW:=2283,SCI_SETTWOPHASEDRAW:=2284
	,SCI_TARGETFROMSELECTION:=2287,SCI_LINESJOIN:=2288,SCI_LINESSPLIT:=2289,SCI_SETFOLDMARGINCOLOR:=2290,SCI_SETFOLDMARGINHICOLOR:=2291
	,SCI_ZOOMIN:=2333,SCI_ZOOMOUT:=2334,SCI_MOVECARETINSIDEVIEW:=2401,SCI_LINELENGTH:=2350,SCI_BRACEHIGHLIGHT:=2351,SCI_BRACEBADLIGHT:=2352
	static SCI_BRACEMATCH:=2353,SCI_GETVIEWEOL:=2355,SCI_SETVIEWEOL:=2356,SCI_GETDOCPOINTER:=2357,SCI_SETDOCPOINTER:=2358,SCI_SETMODEVENTMASK:=2359
	,SCI_GETEDGECOLUMN:=2360,SCI_SETEDGECOLUMN:=2361,SCI_GETEDGEMODE:=2362,SCI_SETEDGEMODE:=2363,SCI_GETEDGECOLOR:=2364,SCI_SETEDGECOLOR:=2365
	,SCI_SEARCHANCHOR:=2366,SCI_SEARCHNEXT:=2367,SCI_SEARCHPREV:=2368,SCI_LINESONSCREEN:=2370,SCI_USEPOPUP:=2371,SCI_SELECTIONISRECTANGLE:=2372
	,SCI_SETZOOM:=2373,SCI_GETZOOM:=2374,SCI_CREATEDOCUMENT:=2375,SCI_ADDREFDOCUMENT:=2376,SCI_RELEASEDOCUMENT:=2377,SCI_GETMODEVENTMASK:=2378
	,SCI_SETFOCUS:=2380,SCI_GETFOCUS:=2381,SCI_SETSTATUS:=2382,SCI_GETSTATUS:=2383,SCI_SETMOUSEDOWNCAPTURES:=2384,SCI_GETMOUSEDOWNCAPTURES:=2385
	,SCI_SETCURSOR:=2386,SCI_GETCURSOR:=2387,SCI_SETCONTROLCHARSYMBOL:=2388,SCI_GETCONTROLCHARSYMBOL:=2389,SCI_SETVISIBLEPOLICY:=2394
	,SCI_SETXOFFSET:=2397,SCI_GETXOFFSET:=2398,SCI_CHOOSECARETX:=2399,SCI_GRABFOCUS:=2400,SCI_SETXCARETPOLICY:=2402,SCI_SETYCARETPOLICY:=2403
	,SCI_SETPRINTWRAPMODE:=2406,SCI_GETPRINTWRAPMODE:=2407,SCI_SETHOTSPOTACTIVEFORE:=2410,SCI_SETHOTSPOTACTIVEBACK:=2411
	,SCI_SETHOTSPOTACTIVEUNDERLINE:=2412,SCI_SETHOTSPOTSINGLELINE:=2421,SCI_POSITIONBEFORE:=2417,SCI_POSITIONAFTER:=2418
	static SCI_COPYRANGE:=2419,SCI_COPYTEXT:=2420,SCI_SETSELECTIONMODE:=2422,SCI_GETSELECTIONMODE:=2423,SCI_GETLINESELSTARTPOSITION:=2424
	,SCI_GETLINESELENDPOSITION:=2425,SCI_SETWHITESPACECHARS:=2443,SCI_SETCHARSDEFAULT:=2444,SCI_AUTOCGETCURRENT:=2445,SCI_ALLOCATE:=2446
	,SCI_TARGETASUTF8:=2447,SCI_SETLENGTHFORENCODE:=2448,SCI_ENCODEDFROMUTF8:=2449,SCI_FINDCOLUMN:=2456,SCI_GETCARETSTICKY:=2457
	,SCI_SETCARETSTICKY:=2458,SCI_TOGGLECARETSTICKY:=2459,SCI_SETPASTECONVERTENDINGS:=2467,SCI_GETPASTECONVERTENDINGS:=2468
	,SCI_SETCARETLINEBACKALPHA:=2470,SCI_GETCARETLINEBACKALPHA:=2471,SCI_STARTRECORD:=3001,SCI_STOPRECORD:=3002,SCI_SETLEXER:=4001
	,SCI_GETLEXER:=4002,SCI_COLORISE:=4003,SCI_SETPROPERTY:=4004,SCI_SETKEYWORDS:=4005,SCI_SETLEXERLANGUAGE:=4006,SCI_LOADLEXERLIBRARY:=4007
	,SCI_GETPROPERTY:=4008,SCI_GETPROPERTYEXPANDED:=4009,SCI_GETPROPERTYINT:=4010,SCI_GETSTYLEBITSNEEDED:=4011

	; Styles, Markers and Indicators
	static MARKER_MAX:=31,STYLE_DEFAULT:=32,STYLE_LINENUMBER:=33,STYLE_BRACELIGHT:=34,STYLE_BRACEBAD:=35,STYLE_CONTROLCHAR:=36
	,STYLE_INDENTGUIDE:=37,STYLE_CALLTIP:=38,STYLE_LASTPREDEFINED:=39,STYLE_MAX:=127,INDIC_MAX:=7,INDIC_PLAIN:=0,INDIC_SQUIGGLE:=1,INDIC_TT:=2
	,INDIC_DIAGONAL:=3,INDIC_STRIKE:=4,INDIC_HIDDEN:=5,INDIC_BOX:=6,INDIC_ROUNDBOX:=7,INDIC0_MASK:=0x20,INDIC1_MASK:=0x40,INDIC2_MASK:=0x80
	,INDICS_MASK:=0xE0,SCI_START:=2000,SCI_OPTIONAL_START:=3000,SCI_LEXER_START:=4000,SCWS_INVISIBLE:=0,SCWS_VISIBLEALWAYS:=1
	,SCWS_VISIBLEAFTERINDENT:=2,SC_EOL_CRLF:=0,SC_EOL_CR:=1,SC_EOL_LF:=2,SC_CP_UTF8:=65001,SC_CP_DBCS:=1,SC_MARK_CIRCLE:=0,SC_MARK_ROUNDRECT:=1
	,SC_MARK_ARROW:=2,SC_MARK_SMALLRECT:=3,SC_MARK_SHORTARROW:=4,SC_MARK_EMPTY:=5,SC_MARK_ARROWDOWN:=6,SC_MARK_MINUS:=7,SC_MARK_PLUS:=8
	,SC_MARK_VLINE:=9,SC_MARK_LCORNER:=10,SC_MARK_TCORNER:=11,SC_MARK_BOXPLUS:=12,SC_MARK_BOXPLUSCONNECTED:=13,SC_MARK_BOXMINUS:=14
	,SC_MARK_BOXMINUSCONNECTED:=15,SC_MARK_LCORNERCURVE:=16,SC_MARK_TCORNERCURVE:=17,SC_MARK_CIRCLEPLUS:=18,SC_MARK_CIRCLEPLUSCONNECTED:=19
	,SC_MARK_CIRCLEMINUS:=20,SC_MARK_CIRCLEMINUSCONNECTED:=21,SC_MARK_BACKGROUND:=22,SC_MARK_DOTDOTDOT:=23,SC_MARK_ARROWS:=24
	,SC_MARK_PIXMAP:=25,SC_MARK_FULLRECT:=26,SC_MARK_CHARACTER:=10000,SC_MARKNUM_FOLDEREND:=25,SC_MARKNUM_FOLDEROPENMID:=26
	,SC_MARKNUM_FOLDERMIDTAIL:=27,SC_MARKNUM_FOLDERTAIL:=28,SC_MARKNUM_FOLDERSUB:=29,SC_MARKNUM_FOLDER:=30,SC_MARKNUM_FOLDEROPEN:=31
	,SC_MASK_FOLDERS:=0xFE000000,SC_MARGIN_SYMBOL:=0,SC_MARGIN_NUMBER:=1

	; Character Sets and Printing
	static SC_CHARSET_ANSI:=0,SC_CHARSET_DEFAULT:=1,SC_CHARSET_BALTIC:=186
	,SC_CHARSET_CHINESEBIG5:=136,SC_CHARSET_EASTEUROPE:=238,SC_CHARSET_GB2312:=134,SC_CHARSET_GREEK:=161,SC_CHARSET_HANGUL:=129
	,SC_CHARSET_MAC:=77,SC_CHARSET_OEM:=255,SC_CHARSET_RUSSIAN:=204,SC_CHARSET_CYRILLIC:=1251,SC_CHARSET_SHIFTJIS:=128
	,SC_CHARSET_SYMBOL:=2,SC_CHARSET_TURKISH:=162,SC_CHARSET_JOHAB:=130,SC_CHARSET_HEBREW:=177,SC_CHARSET_ARABIC:=178,SC_CHARSET_VIETNAMESE:=163
	,SC_CHARSET_THAI:=222,SC_CHARSET_8859_15:=1000, SC_CASE_MIXED:=0,SC_CASE_UPPER:=1,SC_CASE_LOWER:=2,SC_PRINT_NORMAL:=0,SC_PRINT_INVERTLIGHT:=1
	,SC_PRINT_BLACKONWHITE:=2,SC_PRINT_COLORONWHITE:=3,SC_PRINT_COLORONWHITEDEFAULTBG:=4

	; Search Flags
	static SCFIND_WHOLEWORD:=2,SCFIND_MATCHCASE:=4
	,SCFIND_WORDSTART:=0x00100000,SCFIND_REGEXP:=0x00200000,SCFIND_POSIX:=0x00400000

	; Folding
	static SC_FOLDLEVELBASE:=0x400,SC_FOLDLEVELWHITEFLAG:=0x1000
	,SC_FOLDLEVELHEADERFLAG:=0x2000,SC_FOLDLEVELBOXHEADERFLAG:=0x4000,SC_FOLDLEVELBOXFOOTERFLAG:=0x8000,SC_FOLDLEVELCONTRACTED:=0x10000
	,SC_FOLDLEVELUNINDENT:=0x20000,SC_FOLDLEVELNUMBERMASK:=0x0FFF,SC_FOLDFLAG_LINEBEFORE_EXPANDED:=0x0002,SC_FOLDFLAG_LINEBEFORE_CONTRACTED:=0x0004
	,SC_FOLDFLAG_LINEAFTER_EXPANDED:=0x0008,SC_FOLDFLAG_LINEAFTER_CONTRACTED:=0x0010,SC_FOLDFLAG_LEVELNUMBERS:=0x0040,SC_FOLDFLAG_BOX:=0x0001

	; Keys
	static SCMOD_NORM:=0, SCMOD_SHIFT:=1,SCMOD_CTRL:=2,SCMOD_ALT:=4, SCK_DOWN:=300,SCK_UP:=301,SCK_LEFT:=302,SCK_RIGHT:=303,SCK_HOME:=304,SCK_END:=305
	,SCK_PRIOR:=306,SCK_NEXT:=307,SCK_DELETE:=308,SCK_INSERT:=309,SCK_ESCAPE:=7,SCK_BACK:=8,SCK_TAB:=9,SCK_RETURN:=13,SCK_ADD:=310,SCK_SUBTRACT:=311
	,SCK_DIVIDE:=312

	; Lexing
	static SCLEX_CONTAINER:=0,SCLEX_NULL:=1,SCLEX_PYTHON:=2,SCLEX_CPP:=3,SCLEX_HTML:=4,SCLEX_XML:=5,SCLEX_PERL:=6,SCLEX_SQL:=7,SCLEX_VB:=8
	,SCLEX_PROPERTIES:=9,SCLEX_ERRORLIST:=10,SCLEX_MAKEFILE:=11,SCLEX_BATCH:=12,SCLEX_XCODE:=13,SCLEX_LATEX:=14,SCLEX_LUA:=15,SCLEX_DIFF:=16
	,SCLEX_CONF:=17,SCLEX_PASCAL:=18,SCLEX_AVE:=19,SCLEX_ADA:=20,SCLEX_LISP:=21,SCLEX_RUBY:=22,SCLEX_EIFFEL:=23,SCLEX_EIFFELKW:=24
	,SCLEX_TCL:=25,SCLEX_NNCRONTAB:=26,SCLEX_BULLANT:=27,SCLEX_VBSCRIPT:=28,SCLEX_BAAN:=31,SCLEX_MATLAB:=32,SCLEX_SCRIPTOL:=33
	,SCLEX_ASM:=34,SCLEX_CPPNOCASE:=35,SCLEX_FORTRAN:=36,SCLEX_F77:=37,SCLEX_CSS:=38,SCLEX_POV:=39,SCLEX_LOUT:=40,SCLEX_ESCRIPT:=41
	,SCLEX_PS:=42,SCLEX_NSIS:=43,SCLEX_MMIXAL:=44,SCLEX_CLW:=45,SCLEX_CLWNOCASE:=46,SCLEX_LOT:=47,SCLEX_YAML:=48,SCLEX_TEX:=49
	,SCLEX_METAPOST:=50,SCLEX_POWERBASIC:=51,SCLEX_FORTH:=52,SCLEX_ERLANG:=53,SCLEX_OCTAVE:=54,SCLEX_MSSQL:=55,SCLEX_VERILOG:=56,SCLEX_KIX:=57
	,SCLEX_GUI4CLI:=58,SCLEX_SPECMAN:=59,SCLEX_AU3:=60,SCLEX_APDL:=61,SCLEX_BASH:=62,SCLEX_ASN1:=63,SCLEX_VHDL:=64,SCLEX_CAML:=65
	,SCLEX_BLITZBASIC:=66,SCLEX_PUREBASIC:=67,SCLEX_HASKELL:=68,SCLEX_PHPSCRIPT:=69,SCLEX_TADS3:=70,SCLEX_REBOL:=71,SCLEX_SMALLTALK:=72
	static SCLEX_FLAGSHIP:=73,SCLEX_CSOUND:=74,SCLEX_FREEBASIC:=75,SCLEX_INNOSETUP:=76,SCLEX_OPAL:=77,SCLEX_SPICE:=78,SCLEX_D:=79,SCLEX_CMAKE:=80
	,SCLEX_GAP:=81,SCLEX_PLM:=82,SCLEX_PROGRESS:=83,SCLEX_ABAQUS:=84,SCLEX_ASYMPTOTE:=85,SCLEX_R:=86,SCLEX_MAGIK:=87,SCLEX_POWERSHELL:=88
	,SCLEX_MYSQL:=89,SCLEX_PO:=90,SCLEX_TAL:=91,SCLEX_COBOL:=92,SCLEX_TACL:=93,SCLEX_SORCUS:=94,SCLEX_POWERPRO:=95,SCLEX_NIMROD:=96,SCLEX_SML:=97
	,SCLEX_MARKDOWN:=98,SCLEX_TXT2TAGS:=99,SCLEX_A68K:=100,SCLEX_MODULA:=101,SCLEX_COFFEESCRIPT:=102,SCLEX_TCMD:=103,SCLEX_AVS:=104,SCLEX_ECL:=105
	,SCLEX_OSCRIPT:=106,SCLEX_VISUALPROLOG:=107,SCLEX_LITERATEHASKELL:=108,SCLEX_AHKL:=109
	,SCE_AHKL_NEUTRAL:=0,SCE_AHKL_IDENTIFIER:=1,SCE_AHKL_COMMENTDOC:=2,SCE_AHKL_COMMENTLINE:=3,SCE_AHKL_COMMENTBLOCK:=4,SCE_AHKL_COMMENTKEYWORD:=5
	,SCE_AHKL_STRING:=6,SCE_AHKL_STRINGOPTS:=7,SCE_AHKL_STRINGBLOCK:=8,SCE_AHKL_STRINGCOMMENT:=9,SCE_AHKL_LABEL:=10,SCE_AHKL_HOTKEY:=11
	,SCE_AHKL_HOTSTRING:=12,SCE_AHKL_HOTSTRINGOPT:=13,SCE_AHKL_HEXNUMBER:=14,SCE_AHKL_DECNUMBER:=15,SCE_AHKL_VAR:=16,SCE_AHKL_VARREF:=17
	,SCE_AHKL_OBJECT:=18,SCE_AHKL_USERFUNCTION:=19,SCE_AHKL_DIRECTIVE:=20,SCE_AHKL_COMMAND:=21,SCE_AHKL_PARAM:=22,SCE_AHKL_CONTROLFLOW:=23
	,SCE_AHKL_BUILTINFUNCTION:=24,SCE_AHKL_BUILTINVAR:=25,SCE_AHKL_KEY:=26,SCE_AHKL_USERDEFINED1:=27,SCE_AHKL_USERDEFINED2:=28,SCE_AHKL_ESCAPESEQ:=30
	,SCE_AHKL_ERROR:=31,AHKL_LIST_DIRECTIVES:=0,AHKL_LIST_COMMANDS:=1,AHKL_LIST_PARAMETERS:=2,AHKL_LIST_CONTROLFLOW:=3,AHKL_LIST_FUNCTIONS:=4
	,AHKL_LIST_VARIABLES:=5,AHKL_LIST_KEYS:=6,AHKL_LIST_USERDEFINED1:=7,AHKL_LIST_USERDEFINED2:=8,SCLEX_AUTOMATIC=1000

	; Notifications
	static SCEN_CHANGE:=768,SCEN_SETFOCUS:=512,SCEN_KILLFOCUS:=256, SCN_STYLENEEDED:=2000,SCN_CHARADDED:=2001
	,SCN_SAVEPOINTREACHED:=2002,SCN_SAVEPOINTLEFT:=2003,SCN_MODIFYATTEMPTRO:=2004,SCN_KEY:=2005,SCN_DOUBLECLICK:=2006,SCN_UPDATEUI:=2007
	,SCN_MODIFIED:=2008,SCN_MACRORECORD:=2009,SCN_MARGINCLICK:=2010,SCN_NEEDSHOWN:=2011,SCN_PAINTED:=2013,SCN_USERLISTSELECTION:=2014
	,SCN_URIDROPPED:=2015,SCN_DWELLSTART:=2016,SCN_DWELLEND:=2017,SCN_ZOOM:=2018,SCN_HOTSPOTCLICK:=2019,SCN_HOTSPOTDOUBLECLICK:=2020
	,SCN_CALLTIPCLICK:=2021,SCN_AUTOCSELECTION:=2022

	; Other
	static SCI_LINEDOWN:=2300,SCI_LINEDOWNEXTEND:=2301,SCI_LINEDOWNRECTEXTEND:=2426
	,SCI_LINESCROLLDOWN:=2342,SCI_LINEUP:=2302,SCI_LINEUPEXTEND:=2303,SCI_LINEUPRECTEXTEND:=2427,SCI_LINESCROLLUP:=2343,SCI_PARADOWN:=2413
	,SCI_PARADOWNEXTEND:=2414,SCI_PARAUP:=2415,SCI_PARAUPEXTEND:=2416,SCI_CHARLEFT:=2304,SCI_CHARLEFTEXTEND:=2305,SCI_CHARLEFTRECTEXTEND:=2428
	,SCI_CHARRIGHT:=2306,SCI_CHARRIGHTEXTEND:=2307,SCI_CHARRIGHTRECTEXTEND:=2429,SCI_WORDLEFT:=2308,SCI_WORDLEFTEXTEND:=2309,SCI_WORDRIGHT:=2310
	,SCI_WORDRIGHTEXTEND:=2311,SCI_WORDLEFTEND:=2439,SCI_WORDLEFTENDEXTEND:=2440,SCI_WORDRIGHTEND:=2441,SCI_WORDRIGHTENDEXTEND:=2442
	,SCI_WORDPARTLEFT:=2390,SCI_WORDPARTLEFTEXTEND:=2391,SCI_WORDPARTRIGHT:=2392,SCI_WORDPARTRIGHTEXTEND:=2393,SCI_HOME:=2312
	,SCI_HOMEEXTEND:=2313,SCI_HOMERECTEXTEND:=2430,SCI_HOMEDISPLAY:=2345,SCI_HOMEDISPLAYEXTEND:=2346,SCI_HOMEWRAP:=2349
	,SCI_HOMEWRAPEXTEND:=2450,SCI_VCHOME:=2331,SCI_VCHOMEEXTEND:=2332,SCI_VCHOMERECTEXTEND:=2431,SCI_VCHOMEWRAP:=2453,SCI_VCHOMEWRAPEXTEND:=2454
	,SCI_LINEEND:=2314,SCI_LINEENDEXTEND:=2315,SCI_LINEENDRECTEXTEND:=2432,SCI_LINEENDDISPLAY:=2347,SCI_LINEENDDISPLAYEXTEND:=2348
	static SCI_LINEENDWRAP:=2451,SCI_LINEENDWRAPEXTEND:=2452,SCI_DOCUMENTSTART:=2316,SCI_DOCUMENTSTARTEXTEND:=2317,SCI_DOCUMENTEND:=2318
	,SCI_DOCUMENTENDEXTEND:=2319,SCI_PAGEUP:=2320,SCI_PAGEUPEXTEND:=2321,SCI_PAGEUPRECTEXTEND:=2433,SCI_PAGEDOWN:=2322,SCI_PAGEDOWNEXTEND:=2323
	,SCI_PAGEDOWNRECTEXTEND:=2434,SCI_STUTTEREDPAGEUP:=2435,SCI_STUTTEREDPAGEUPEXTEND:=2436,SCI_STUTTEREDPAGEDOWN:=2437
	,SCI_STUTTEREDPAGEDOWNEXTEND:=2438,SCI_DELETEBACK:=2326,SCI_DELETEBACKNOTLINE:=2344,SCI_DELWORDLEFT:=2335,SCI_DELWORDRIGHT:=2336
	,SCI_DELLINELEFT:=2395,SCI_DELLINERIGHT:=2396,SCI_LINEDELETE:=2338,SCI_LINECUT:=2337,SCI_LINECOPY:=2455,SCI_LINETRANSPOSE:=2339
	,SCI_LINEDUPLICATE:=2404,SCI_LOWERCASE:=2340,SCI_UPPERCASE:=2341,SCI_CANCEL:=2325,SCI_EDITTOGGLEOVERTYPE:=2324,SCI_NEWLINE:=2329
	,SCI_FORMFEED:=2330,SCI_TAB:=2327,SCI_BACKTAB:=2328,SCI_SELECTIONDUPLICATE:=2469,SCI_SCROLLTOSTART:=2628,SCI_SCROLLTOEND:=2629
	,SCI_DELWORDRIGHTEND:=2518,SCI_VERTICALCENTRECARET:=2619,SCI_MOVESELECTEDLINESUP:=2620,SCI_MOVESELECTEDLINESDOWN:=2621
	,SC_TIME_FOREVER:=10000000,SC_WRAP_NONE:=0,SC_WRAP_WORD:=1,SC_WRAP_CHAR:=2,SC_WRAPVISUALFLAG_NONE:=0x0000,SC_WRAPVISUALFLAG_END:=0x0001
	static SC_WRAPVISUALFLAG_START:=0x0002,SC_WRAPVISUALFLAG_MARGIN:=0x0004, SC_WRAPVISUALFLAGLOC_DEFAULT:=0x0000,SC_WRAPVISUALFLAGLOC_END_BY_TEXT:=0x0001
	,SC_WRAPVISUALFLAGLOC_START_BY_TEXT:=0x0002,SC_CACHE_NONE:=0,SC_CACHE_CARET:=1,SC_CACHE_PAGE:=2,SC_CACHE_DOCUMENT:=3,EDGE_NONE:=0,EDGE_LINE:=1
	,EDGE_BACKGROUND:=2,SC_CURSORNORMAL:=-1,SC_CURSORWAIT:=4,VISIBLE_SLOP:=0x01,VISIBLE_STRICT:=0x04,CARET_SLOP:=0x01,CARET_STRICT:=0x04
	,CARET_JUMPS:=0x10,CARET_EVEN:=0x08,SC_SEL_STREAM:=0,SC_SEL_RECTANGLE:=1,SC_SEL_LINES:=2,SC_ALPHA_TRANSPARENT:=0,SC_ALPHA_OPAQUE:=255
	,SC_ALPHA_NOALPHA:=256,KEYWORDSET_MAX:=8,SC_MOD_INSERTTEXT:=0x1,SC_MOD_DELETETEXT:=0x2,SC_MOD_CHANGESTYLE:=0x4,SC_MOD_CHANGEFOLD:=0x8
	,SC_PERFORMED_USER:=0x10,SC_PERFORMED_UNDO:=0x20,SC_PERFORMED_REDO:=0x40,SC_MULTISTEPUNDOREDO:=0x80,SC_LASTSTEPINUNDOREDO:=0x100
	,SC_MOD_CHANGEMARKER:=0x200,SC_MOD_BEFOREINSERT:=0x400,SC_MOD_BEFOREDELETE:=0x800,SC_MULTILINEUNDOREDO:=0x1000,SC_MODEVENTMASKALL:=0x1FFF
	,SC_WEIGHT_NORMAL:=400, SC_WEIGHT_SEMIBOLD:=600, SC_WEIGHT_BOLD:=700

    hwnd := !hwnd ? oldhwnd : hwnd, oldhwnd := hwnd, msg := !(msg+0) ? "SCI_" msg : msg

    if !%hwnd%_df
	{
        SendMessage, SCI_GETDIRECTFUNCTION,0,0,,ahk_id %hwnd%
        %hwnd%_df := ErrorLevel
        SendMessage, SCI_GETDIRECTPOINTER,0,0,,ahk_id %hwnd%
        %hwnd%_dp := ErrorLevel
	}

    if !msg && !wParam && !lParam   ; called only with the hwnd param from SCI_Add
        return                      ; Exit because we did what we needed to do already.

	; The fast way to control Scintilla
    return DllCall(%hwnd%_df            ; DIRECT FUNCTION
                  ,"UInt" ,%hwnd%_dp    ; DIRECT POINTER
                  ,"UInt" ,!(msg+0) ? %msg% : msg
                  ,"Int"  ,inStr(wParam, "-") ? wParam : (%wParam%+0 ? %wParam% : wParam) ; handles negative ints
                  ,"Int"  ,%lParam%+0 ? %lParam% : lParam)
}

/*
    Function : __sciNotify
    This is the default function which will be called when the WM_NOTIFY message has been received. The message is tracked as soon as you
    add a new scintilla component.


    Parameters:
    __sciNotify(wParam, lParam, msg, hwnd)

    wParam  -   wParam for the message
    lParam  -   lParam for the message
    msg     -   The message which triggered this function
    hwnd    -   The hwnd of the control which sent the message

    Returns:
    This function sets some variables on the sciObject to which the component belongs to and procedes to call your user defined notify function
    which can be set in sciObj.notify.

    It will pass wParam, lParam, msg and hwnd 
	to that function so make sure you define it that way.
    Returns nothing.

    Examples:
*/
__sciNotify(wParam, lParam, msg, hwnd){

    ; fix int for x64 bit systems
    __sciObj                 := __SCI(NumGet(lParam + A_PtrSize*0 +  0,  "ptr"))               ; Returns original object
    __sciObj.idFrom          := NumGet(lParam + A_PtrSize*1 +  0, "uptr")
    __sciObj.scnCode         := NumGet(lParam + A_PtrSize*2 +  0, "uint")

    __sciObj.position        := NumGet(lParam + A_PtrSize*3 +  0,  "int")
    __sciObj.ch              := NumGet(lParam + A_PtrSize*3 +  4,  "int")
    __sciObj.modifiers       := NumGet(lParam + A_PtrSize*3 +  8,  "int")
    __sciObj.modType         := NumGet(lParam + A_PtrSize*3 + 12,  "int")
    __sciObj.text            := NumGet(lParam + A_PtrSize*3 + 16,  "str")
    __sciObj.length          := NumGet(lParam + A_PtrSize*4 + 16,  "int")
    __sciObj.linesAdded      := NumGet(lParam + A_PtrSize*4 + 20,  "int")

    __sciObj.macMessage      := NumGet(lParam + A_PtrSize*4 + 24,  "int")
    __sciObj.macwParam       := NumGet(lParam + A_PtrSize*5 + 24, "uptr")
    __sciObj.maclParam       := NumGet(lParam + A_PtrSize*6 + 24,  "ptr")

    __sciObj.line            := NumGet(lParam + A_PtrSize*7 + 24,  "int")
    __sciObj.foldLevelNow    := NumGet(lParam + A_PtrSize*7 + 28,  "int")
    __sciObj.foldLevelPrev   := NumGet(lParam + A_PtrSize*7 + 32,  "int")
    __sciObj.margin          := NumGet(lParam + A_PtrSize*7 + 36,  "int")
    __sciObj.listType        := NumGet(lParam + A_PtrSize*7 + 40,  "int")
    __sciObj.x               := NumGet(lParam + A_PtrSize*7 + 44,  "int")
    __sciObj.y               := NumGet(lParam + A_PtrSize*7 + 48,  "int")

    __sciObj.token           := NumGet(lParam + A_PtrSize*7 + 52,  "int")
    __sciObj.annotLinesAdded := NumGet(lParam + A_PtrSize*7 + 56,  "int")
    __sciObj.updated         := NumGet(lParam + A_PtrSize*7 + 60,  "int")

    __sciObj.notify(wParam, lParam, msg, hwnd, __sciObj)                ; Call user defined Notify Function and passes object to it as last parameter
    return __sciObj := ""                                               ; free object
}

__isHexColor(hex, msg){
    if (RegexMatch(hex, "^0x[0-9a-fA-F]{6}$"))
        return true
    else
        return false
}

__SCI(var, val := ""){
    static

    if (RegExMatch(var,"i)[ `n-\.%,(\\\/=&^]")) ; Check if it is a valid variable name
        return

	lvar := %var%, val ? %var% := val : null
    return lvar
}
