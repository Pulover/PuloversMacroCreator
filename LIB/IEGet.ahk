;###########################################################
; Original by Jethrow
; http://www.autohotkey.com/board/topic/47052-basic-webpage-control
;###########################################################
IEGet(Name := ""){      ;Retrieve pointer to existing IE window/tab
   IfEqual, Name,, WinGetTitle, Name, ahk_class IEFrame
      Name := ( Name="New Tab - Windows Internet Explorer" ) ? "about:Tabs" 
      : RegExReplace( Name, " - (Windows |Microsoft )?Internet Explorer.*" )
   For Pwb in ComObjCreate( "Shell.Application" ).Windows
      If ( Pwb.LocationName = Name ) && InStr( Pwb.FullName, "iexplore.exe" )
         Return Pwb
}

