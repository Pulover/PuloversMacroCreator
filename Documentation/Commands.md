# Command Windows

**Tip**: Right-click on an empty area of a Command Window to display links to AutoHotkey online documentation and related contents.

## Table of Contents

* [Find a Command](#find-a-command)
* [Common Fields](#common-fields)
* [Mouse](Commands/Mouse.html)
* [Text](Commands/Text.html)
* [Control](Commands/Control.html)
* [Pause](Commands/Pause.html)
* [Message Box](Commands/Message_Box.html)
* [KeyWait](Commands/KeyWait.html)
* [Window](Commands/Window.html)
* [Image Search](Commands/Image_Search.html)
* [Pixel Search](Commands/Pixel_Search.html)
* [Image to Text (OCR)](Commands/Image_to_Text.html)
* [Run / File / String / Misc.](Commands/Run.html)
* [Loop](Commands/Loop.html)
* [Loop FilePattern](Commands/Loop_FilePattern.html)
* [Loop Parse](Commands/Loop_Parse.html)
* [Loop Read](Commands/Loop_Read.html)
* [Loop Registry](Commands/Loop_Registry.html)
* [While-Loop](Commands/While_Loop.html)
* [For Loop](Commands/For_Loop.html)
* [Until](Commands/Until.html)
* [Goto / GoSub](Commands/Goto_and_GoSub.html)
* [Label](Commands/Label.html)
* [Set Timer](Commands/Set_Timer.html)
* [If Statements](Commands/If_Statements.html)
* [Variables / Arrays](Commands/Variables.html)
* [Functions / Array Methods](Commands/Functions.html)
* [Send Email](Commands/Send_Email.html)
* [Download Files](Commands/Download_Files.html)
* [Zip/Unzip Files](Commands/Zip_Files.html)
* [Internet Explorer](Commands/Internet_Explorer.html)
* [Expression / COM Interface](Commands/Expression.html)
* [PostMessage / SendMessage](Commands/PostMessage_and_SendMessage.html)

## Find a Command

This window allows you to easily search for a command or function. Simply type a keyword and the results will be displayed in the box below. Double-Click an item or press Enter to open the target window. You can also use the search bar in the main window toolbar.

## Common Fields

The following fields appear on some of the Command Windows and will behave the same for all, therefore will be omitted from their parameters.

### Repeat

How many times to execute the command. This field is ignored in some commands. This field accepts [Variables & Expressions](Variables.html).

### Delay

Time to wait before the next command line, except for the *Message box* and *KeyWait* command it sets the *Timeout*, for the *Set Timer* command it sets the Period. This field is ignored in some of the commands. This field accepts [Variables & Expressions](Variables.html).

### Control

Selects the target control to send the command. Use the *Get* button (...) to easily find a control's name: Point the mouse to its location and Right-Click on it. To operate upon a control's HWND (unique ID), leave the Control parameter blank and specify ahk_id %ControlHwnd% for the WinTitle parameter. This field accepts [Variables & Expressions](Variables.html).  
The *Get* button automatically fills the *Window* field as well, using the selected items in *WinTitle*.

### Window

Title, partial title or identifier of a target window. The first parameter is [WinTitle](https://www.autohotkey.com/docs/misc/WinTitle.htm), you can add one or more extra parameters separating them by commas: `WinTitle, WinText, ExcludeTitle, ExcludeText`. You can omit any of those parameters, including WinTitle. This field accepts [Variables & Expressions](Variables.html).

**WinTitle** matching behavior is determined by [Title Match Mode](Playback.html#title-match-mode) and [Detect Hidden Windows](Playback.html#detect-hidden-windows) settings.

The *WinTitle* button selects what informations to retrieve from a target window (Title/Class/Process/ID/ProcessID) with the *Get* tool for the WinTitle parameter. Check one or more items in the list and use the *Get* button (...) to copy the available information from the window.  
**Note**: The options checked only determine what the *Get* tool will retrieve, it does not affect the command.

Additionally to **WinTitle** you can also add the following parameters separated by commas:

* **WinText**: If present, this parameter must be a substring from a single text element of the target window (as revealed by the included Window Spy utility). Hidden text elements are detected if DetectHiddenText is ON.
* **ExcludeTitle**: Windows whose titles include this value will not be considered.
* **ExcludeText**: Windows whose text include this value will not be considered.
