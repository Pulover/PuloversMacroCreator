# Commands

**Tip**: Right-click on a Button in the Main Window or anywhere on a Command Window to display links to Related.

### Common_Fields

The following fields appear on some of the Command Windows below and will behave the same for all, therefore will be omitted from their parameters.

* **Repeat**: How many times to execute action. This field accepts [Variables & Expressions](Variables.html).
* **Delay**: Time to wait before the next command line. This field accepts [Variables & Expressions](Variables.html).
* **Control**: Selects the target control to send the command. Use the Get button to easily find a control's name: Point the mouse to its location and Right-Click on it. To operate upon a control's HWND (window handle), leave the Control parameter blank and specify ahk_id %ControlHwnd% for the WinTitle parameter. This field accepts [Variables & Expressions](Variables.html).
* **Window**: Title/Class/Process/ID/ProcessID of target window for control command. The DropdowndList defines which information will be taken from a windown when using the *Get* button. **Extra Parameters**: The first parameter is WinTitle, you can add one or more extra parameters separating them by commas: `WinTitle, WinText, ExcludeTitle, ExcludeText`. You can omit any of those parameters, including WinTitle. This field accepts [Variables & Expressions](Variables.html).

### Find a Command

This window allows you to easily search for a command or function. Simply type a keyword and the results will be displayed in the box below. Double-Click an item or press Enter to open the target window. You can also use the search bar in the main window toolbar.

## Table of Contents

* [Mouse](Commands/Mouse.html)
* [Text](Commands/Text.html)
* [Control](Commands/Control.html)
* [Pause](Commands/Pause.html)
* [Message Box](Commands/Message_Box.html)
* [KeyWait](Commands/KeyWait.html)
* [Window](Commands/Window.html)
* [Image Search](Commands/Image_Search.html)
* [Pixel Search](Commands/Pixel_Search.html)
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