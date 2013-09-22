/*!
	Library: Pulover's Macro Creator
		*The Complete Automation Tool*
		
		Version: 4.0.0  
		
		[www.macrocreator.com](http://www.macrocreator.com)  
		[Forum Thread](http://www.autohotkey.com/board/topic/79763-macro-creator)  
		
		Author: Pulover \[Rodolfo U. Batista\]  
		[pulover@macrocreator.com](mailto:pulover@macrocreator.com)  
		Copyright © 2012-2013 Rodolfo U. Batista  
		
		Software License: [GNU General Public License](License.html)  
		
		[AutoHotkey Online Documentation](http://l.autohotkey.net/docs)  
		
		**Support Open Source software: [Donate](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=rodolfoub%40gmail%2ecom&lc=US&item_name=Pulover%27s%20Macro%20Creator&item_number=App%2ePMC&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted)**
*/

/*!
	Page: FAQ - Frequently Asked Questions
	Filename: p0-Faq
	Contents: @file:Faq.md
*/

/*!
	Page: Main Window
	Filename: p1-Main
	Contents: @file:Main.md
*/

/*!
	Page: Record
	Filename: p2-Record
	Contents: @file:Record.md
*/

/*!
	Page: Playback
	Filename: p3-Playback
	Contents: @file:Playback.md
*/

/*!
	Page: Command Windows
	Filename: p4-Commands
	Contents: @file:Commands.md
*/

/*!
	Page: Export Window
	Filename: p5-Export
	Contents: @file:Export.md
*/

/*!
	Page: Preview Window
	Filename: p6-Preview
	Contents: @file:Preview.md
*/

/*!
	Page: Settings
	Filename: p7-Settings
	Contents: @file:Settings.md
*/

/*!
	Page: Variables & Functions
	Filename: p8-Variables
	Contents: @file:Variables.md
*/

/*!
	Page: About & Changes
	Filename: p9-About
	Contents: @file:About.md
*/

/*!
	Function: Common_Fields()
		The following fields appear on some of the Command Windows below and will behave the same for all, therefore will be omitted from their parameters.

	Parameters:
		Repeat - How many times to execute action.  
			This field accepts [Variables & Functions](p8-Variables.html).
		Delay - Time to wait before the next command line.  
			This field accepts [Variables & Functions](p8-Variables.html).
		Control - Selects the target control to send the command. Use the Get button to easily find a control's name: Point the mouse to its location and Right-Click on it. To operate upon a control's HWND (window handle), leave the Control parameter blank and specify ahk_id %ControlHwnd% for the WinTitle parameter.  
			This field accepts [Variables & Functions](p8-Variables.html).
		Window - Title/Class/Process/ID/ProcessID of target window for control command. The DropdowndList defines which information will be taken from a windown when using the *Get* button.  
			**Extra Parameters**: The first parameter is WinTitle, you can add one or more extra parameters separating them by commas:
			> WinTitle, WinText, ExcludeTitle, ExcludeText.
			You can omit any of those parameters, including WinTitle.  
			This field accepts [Variables & Functions](p8-Variables.html).
*/

/*!
	Function: Find_a_Command()
		This window allows you to easily search for a command or function.  
		Simply type a keyword and the results will be displayed in the box below. Double-Click an item or press Enter to open the target window.
*/

/*!
	Function: Mouse()
		Clicks a mouse button at the specified coordinates. It can also hold down a mouse button, turn the mouse wheel, or move the mouse.

	Parameters:
		Actions - Selects the Mouse action to execute.
		Coordinates - Defines the coordinates of the window or screen where the action will be executed.
			This field accepts [Variables](p8-Variables.html), functions may also work but are not recommended due to incompatibility with exported scripts.  
			**Note**: Mouse Actions are affected by [Mouse Coordinates Settings](p7-Settings.html#defaults).  
		Click - Uses the *Click*. This usually works for most cases.
		Send - Uses *SendEvent*. Use this in case the Click Command doesn't work.
		Relative - **If not used with Control**: Coordinates will be treated as an offset from mouse current position.  
			**If used with Control**: *Unchecked*: Click coordinates relative to the target window. *Checked*: Click coordinates relative to Control's position.
		Button - Selects the Mouse Button to send.
		Hold/Release - *Unchecked*: Send a normal click.  
			*First check*: Click and hold.  
			*Second check*: Release button.
		Click Count - The number of times to click the mouse.  
			This is not affected by Delay.

	Extra:
		### Related
			[Click](http://l.autohotkey.net/docs/commands/Click.htm), [ControlClick](http://l.autohotkey.net/docs/commands/ControlClick.htm), [MouseClickDrag](http://l.autohotkey.net/docs/commands/MouseClickDrag.htm)
*/

/*!
	Function: Text()
		Sends simulated keystrokes to a window. It may be used to send raw text or commands. This field accepts [Variables & Functions](p8-Variables.html).

	Parameters:
		Plain Text (Raw) - Uses *SendRaw*. The SendRaw command interprets all characters literally rather than translating {Enter} to an ENTER keystroke, ^c to Control-C, etc.
		Text with commands - Uses *SendInput*. When not in raw mode, the following characters are treated as modifiers (these modifiers affect only the very next key): !, +, ^, #.
		Set key delay - Uses *SendEvent*. The rate at which keystrokes are sent is determined by Key Delay.
		Paste from Clipboard - Temporarily uses Clipboard to send the text. When the operation is completed, the script restores the original clipboard contents.
		Paste on Control - Uses *Control, EditPaste*. Pastes String at the caret/insert position in an Edit control (this does not affect the contents of the clipboard).
		SetText - Uses *ControlSetText*. Changes the text of a control.
		Key delay - Sets the delay that will occur after each keystroke sent in *Text with commands* mode.
		Insert KeyStroke - Opens the Insert Keystroke window where you can choose a keyboard key from a list. Double-click or click *Insert* to insert the key in the current cursor postion. The key will be inserted in AutoHotkey *Send* format, only valid for *Text with commands* option.

	Extra:
		### Related
			[Send / SendRaw](http://l.autohotkey.net/docs/commands/Send.htm), [ControlSend](http://l.autohotkey.net/docs/commands/ControlSend.htm), [ControlSetText](http://l.autohotkey.net/docs/commands/ControlSetText.htm), [Clipboard](http://l.autohotkey.net/docs/misc/Clipboard.htm)
*/

/*!
	Function: Control()
		Gathers various control commands. Please refer to [AutoHotkey documentation](http://l.autohotkey.net/docs) for details on each one.

	Parameters:
		Value - Second parameter of a Control Command when available. This field accepts [Variables & Functions](p8-Variables.html).
		Output Variable - The name of the variable in which to store the result of Cmd. For *ControlGetPos* the variable you choose will be a prefix to the 4 outputvars. E.g. if you type a variable named "Pos_" the output will be saved to *Pos_X*, *Pos_Y*, *Pos_W* and *Pos_H*.
		Position/Size - Coordinates and sizes to move a control with ControlMove.

	Extra:
		### Related
			[Control](http://l.autohotkey.net/docs/commands/Control.htm), [ControlFocus](http://l.autohotkey.net/docs/commands/ControlFocus.htm), [ControlGet](http://l.autohotkey.net/docs/commands/ControlGet.htm), [ControlGetFocus](http://l.autohotkey.net/docs/commands/ControlGetFocus.htm), [ControlGetPos](http://l.autohotkey.net/docs/commands/ControlGetPos.htm), [ControlGetText](http://l.autohotkey.net/docs/commands/ControlGetText.htm), [ControlMove](http://l.autohotkey.net/docs/commands/ControlMove.htm), [ControlSetText](http://l.autohotkey.net/docs/commands/ControlSetText.htm)
		
		### Download Example
			[Using Control Commands to Read and Set Text](Examples\ControlCmd.pmc).
*/

/*!
	Function: Pause()
		Waits the specified amount of time before continuing.

	Parameters:
		Add Pause - The amount of time to pause (choose format in the options below).
		Miliseconds / Seconds / Minutes - Sets format of time (seconds and minutes will be converted to miliseconds when the command is added).
		Random delay - Sets the command use a random value between Minimum and Maximum instead of a predefined value.
		Disable random delays for this command - If the global option for *Random delays" is active the command won't be affected.

	Extra:
		### Related
			[Sleep](http://l.autohotkey.net/docs/commands/Sleep.htm)
*/

/*!
	Function: Message_Box()
		Displays the specified text in a small window containing two default buttons (OK and Cancel).

	Parameters:
		Message - Text to display in the message. If the Cancel button is pressed, execution will stop.  
			This field accepts [Variables & Functions](p8-Variables.html).
		Timeout - Timeout in seconds.
		Title - The title of the message box window.
		Icon - Sets the icon to be shown on the Message Box.
		Always On Top - Sets the message to stay on top of other windows.
		Buttons - Sets which buttons will be shown on the message box.
		Add "If Statement" - Automatically adds an *If Message Box* statement below the command. You may select a range of rows to be wrapped by the statement block.

	Extra:
		### Related
			[MsgBox](http://l.autohotkey.net/docs/commands/MsgBox.htm)
*/

/*!
	Function: KeyWait()
		Waits for a key pressed down.

	Parameters:
		Wait for Key - Single key to wait for. Macro will remain in sleep state until the selected key is pressed.
		Select from list - List of keyboard keys.
		Wait Timeout - Defines the limit of time to wait for the input.

	Extra:
		### Related
			[KeyWait](http://l.autohotkey.net/docs/commands/KeyWait.htm)
*/

/*!
	Function: Window()
		Gathers various Window commands. Please refer to [AutoHotkey documentation](http://l.autohotkey.net/docs) for details on each one.
	Parameters:
		Value - Second parameter of a Window Command when available.  
			This field accepts [Variables & Functions](p8-Variables.html).
		Seconds - Seconds to wait for a Window Command when available.  
			This field accepts [Variables & Functions](p8-Variables.html).
		Output Variable - The name of the variable in which to store the result of Cmd. For *WinGetPos* the variable you choose will be a prefix to the 4 outputvars. E.g. if you type a variable named "Pos_" the output will be saved to *Pos_X*, *Pos_Y*, *Pos_W* and *Pos_H*.
		Position/Size - Coordinates and sizes to move a control with WinMove.

	Extra:
		### Related
			[WinActivate](http://l.autohotkey.net/docs/commands/WinActivate.htm), [WinActivateBottom](http://l.autohotkey.net/docs/commands/WinActivateBottom.htm), [WinClose](http://l.autohotkey.net/docs/commands/WinClose.htm), [WinGet](http://l.autohotkey.net/docs/commands/WinGet.htm), [WinGetClass](http://l.autohotkey.net/docs/commands/WinGetClass.htm), [WinGetText](http://l.autohotkey.net/docs/commands/WinGetText.htm), [WinGetTitle](http://l.autohotkey.net/docs/commands/WinGetTitle.htm), [WinGetPos](http://l.autohotkey.net/docs/commands/WinGetPos.htm), [WinHide](http://l.autohotkey.net/docs/commands/WinHide.htm), [WinKill](http://l.autohotkey.net/docs/commands/WinKill.htm), [WinMaximize](http://l.autohotkey.net/docs/commands/WinMaximize.htm), [WinMinimize](http://l.autohotkey.net/docs/commands/WinMinimize.htm), [WinMinimizeAll / WinMinimizeAllUndo](http://l.autohotkey.net/docs/commands/WinMinimizeAll.htm), [WinMove](http://l.autohotkey.net/docs/commands/WinMove.htm), [WinRestore](http://l.autohotkey.net/docs/commands/WinRestore.htm), [WinSet](http://l.autohotkey.net/docs/commands/WinSet.htm), [WinShow](http://l.autohotkey.net/docs/commands/WinShow.htm), [WinWait](http://l.autohotkey.net/docs/commands/WinWait.htm), [WinWaitActive / WinWaitNotActive](http://l.autohotkey.net/docs/commands/WinWaitActive.htm), [WinWaitClose](http://l.autohotkey.net/docs/commands/WinWaitClose.htm)
*/

/*!
	Function: Image_Search()
		Searches a region of the screen for an image.

	Parameters:
		Start X/Y / End X/Y - Defines the Search area of the screen/window.
		Make Screenshot - Use this tool to take a screenshot of an area of the screen (see [Instructions](#make-screenshot-tool-instructions) for details on usage).
		Search - Opens the File Select dialog to select an Image File.
		If found - Selects an action to execute when an image/pixel is found.  
			To execute a different action Select 'Continue' (or 'Break' to exit the command's loop) and use the 'If Image/Pixel Found' option in the If Statements window.
		If not found / Error - Selects an action to execute when an image/pixel is not found or if the command finds an error.  
			To execute a different action Select 'Continue' (or 'Break' to exit the command's loop) and use the 'If Image/Pixel Not Found' option in the If Statements window.
		Add "If Statement" - Automatically adds an *If Image/Pixel Found* statement below the command. You may select a range of rows to be wrapped by the statement block.
		Preview - Previews the selected image.  
			Double-Click an image to open the file with the associated application.
		Coord - Sets coordinate mode for the search to be relative to either the active window or the screen.
		Variations - Specify for n a number between 0 and 255 (inclusive) to indicate the allowed number of shades of variation in either direction for the intensity of the red, green, and blue components of each pixel's color.
		Icon - Specify for n a number between 0 and 255 (inclusive) to indicate the allowed number of shades of variation in either direction for the intensity of the red, green, and blue components of each pixel's color.
		Transparent - Specify one color within the image that will match any color on the screen.
		Scale - Width and height to which to scale the image (this width and height also determines which icon to load from a multi-icon .ICO file).
		Repeat until - Loops the command until the image is found or not found, according to the option selected.

	Remarks:
		You may use the variables %FoundX% and %FoundY% on other commands like Mouse Move & Click when the image/pixel is found. To save the values to a different variable or increment the values, use the [Assign Variable](Commands\Assign_Variable.html) tab of 'If Statements' window.

	Extra:
		### Related
			[ImageSearch](http://l.autohotkey.net/docs/commands/ImageSearch.htm)
		
		## Make Screenshot Tool Instructions
		
		### Make Screenshot
			* Click and hold the Draw Button (button can be changed in options) and drag to create a rectangle of the area.
			* Release (or press Enter if set in options) to make the screenshot.
		
		### Make Screenshot of a Control
			* Point the mouse to the control area (the control's name should be showing in the tooltip).
			* Click and release the button without moving.
		
		### Make Screenshot of Window
			* Point the mouse to an area where no control name is shown.
			* Click and release the button without moving.
		
		### Adjust the area of the Screenshot
			* Go to *Settings* > *Screenshots* (you can use the *Options* button in the *Image/Pixel Search* command window) and check the option *Press Enter to capture*.
			* Follow on of the instructions above. Now when you draw a rectangle it will remain visible in the screen until you press Enter.
			* Use the hotkeys **Ctrl + Arrow keys** to move the selection area and **Shift + Arrow keys** to resize it.
*/

/*!
	Function: Pixel_Search()
		Searches a region of the screen for a pixel color.

	Parameters:
		Start X/Y / End X/Y - Defines the Search area of the screen/window.
		Color Picker - Opens the Color Picker Tool. Point the mouse to the desired location and Right-Click to get the pixel code (in RGB format).  
		Search - Opens the Windows Color Pick dialog to select a pixel color.  
		If found - Selects an action to execute when an image/pixel is found.  
			To execute a different action Select 'Continue' (or 'Break' to exit the command's loop) and use the 'If Image/Pixel Found' option in the If Statements window.
		If not found / Error - Selects an action to execute when an image/pixel is not found or if the command finds an error.  
			To execute a different action Select 'Continue' (or 'Break' to exit the command's loop) and use the 'If Image/Pixel Not Found' option in the If Statements window.
		Add "If Statement" - Automatically adds an *If Image/Pixel Found* statement below the command. You may select a range of rows to be wrapped by the statement block.
		Preview - Previews the selected pixel to search.
		Coord - Sets coordinate mode for the search to be relative to either the active window or the screen.
		Variations - Specify for n a number between 0 and 255 (inclusive) to indicate the allowed number of shades of variation in either direction for the intensity of the red, green, and blue components of each pixel's color.
		Fast - Uses a faster searching method that in most cases dramatically reduces the amount of CPU time used by the search.
		RGB - Causes ColorID to be interpreted as an RGB value instead of BGR. This option affects the Color Picker Tool but the retrieved color will be reversed in preview and Color Pick Dialog.
		Repeat until - Loops the command until the image is found or not found, according to the option selected.

	Remarks:
		You may use the variables %FoundX% and %FoundY% on other commands like Mouse Move & Click when the image/pixel is found. To save the values to a different variable or increment the values, use the [Assign Variable](Commands\Assign_Variable.html) tab of 'If Statements' window.

	Extra:
		### Related
			[PixelSearch](http://l.autohotkey.net/docs/commands/PixelSearch.htm)
*/

/*!
	Function: Run()
		Gathers various AutoHotkey commands to execute different types of tasks. To get help on each command **right-click anywhere on the window** and select the corresponding link. For a complete list of commands refer to [AutoHotkey documentation](http://l.autohotkey.net/docs/).

	Parameters:
		Parameters Fields - Parameters will vary according to the selected command.  
				All fields should accept [Variables & Functions](p8-Variables.html).  

	Remarks:
		Don't use percent signs (%) for variables when the fields name is OutputVar or InputVar, for they should expect a variable already.

	Extra:
		### Related
			[Command and Function Index](http://l.autohotkey.net/docs/commands/index.htm)
*/

/*!
	Function: Loop()
		Loops a section of the Macro enclosed within *LoopStart* and *LoopEnd*. Nested Loops are accepted.

	Parameters:
		Repeat - How many times to execute the loop section. If set to 0, the loop continues indefinitely until a break or return is encountered, or the Stop Key is pressed.
			This field accepts [Variables & Functions](p8-Variables.html).

	Remarks:
		The built-in variable **A_Index** contains the number of the current loop iteration. It contains 1 the first time the loop's body is executed. For the second time, it contains 2; and so on. If an inner loop is enclosed by an outer loop, the inner loop takes precedence.
		
		A Loop command in Playback may perform different then an exported script duo to the method used internally by Macro Creator.

	Extra:
		### Related
			[Loop](http://l.autohotkey.net/docs/commands/Loop.htm)
*/

/*!
	Function: Loop_FilePattern()
		Retrieves the specified files or folders, one at a time.

	Parameters:
		File Pattern - The name of a single file or folder, or a wildcard pattern such as C:\Temp\*.tmp.
		Folders? - *Unchecked*: Folders are not retrieved (only files).  
			*First Check*: All files and folders that match the wildcard pattern are retrieved.  
			*Second Check*: Only folders are retrieved (no files).
		Recurse? - *Unchecked*: Subfolders are not recursed into.  
			*Checked*: Subfolders are recursed into so that files and folders contained therein are retrieved if they match FilePattern. All subfolders will be recursed into, not just those whose names match FilePattern. 

	Remarks:
		The following variables exist within any file-loop. If an inner file-loop is enclosed by an outer file-loop, the innermost loop's file will take precedence:
		* A_LoopFileName, A_LoopFileExt, A_LoopFileFullPath, A_LoopFileLongPath, A_LoopFileShortPath, A_LoopFileShortName, A_LoopFileDir, A_LoopFileTimeModified, A_LoopFileTimeCreated, A_LoopFileTimeAccessed, A_LoopFileAttrib, A_LoopFileSize, A_LoopFileSizeKB, A_LoopFileSizeMB
		
		For a description of each variable follow the link in the **Related** section below.

		A Loop command in Playback may perform different then an exported script duo to the method used internally by Macro Creator.  
		
		In Playback all iterations will be performed prior to any commands in the Loop section.

	Extra:
		### Related
			[Loop FilePattern](http://l.autohotkey.net/docs/commands/LoopFile.htm)
		
		### Download Example
			[Loop through folders, parse and read file's contents](Examples\LoopTypes.pmc).
*/

/*!
	Function: Loop_Parse()
		Retrieves substrings (fields) from a string, one at a time.

	Parameters:
		Input Variable - The name of the variable whose contents will be analyzed. Do not enclose the name in percent signs.
		Delimiters - If this parameter is blank or omitted, each character of InputVar will be treated as a separate substring.  
			If this parameter is CSV, InputVar will be parsed in standard comma separated value format.  
			Otherwise, Delimiters contains one or more characters (case sensitive), each of which is used to determine where the boundaries between substrings occur in InputVar.
		Omit Characters - An optional list of characters (case sensitive) to exclude from the beginning and end of each substring.  
			For example, if OmitChars is %A_Space%%A_Tab%, spaces and tabs will be removed from the beginning and end (but not the middle) of every retrieved substring.

	Remarks:
		The built-in variable **A_LoopField** exists within any parsing loop. It contains the contents of the current substring (field) from InputVar. If an inner parsing loop is enclosed by an outer parsing loop, the innermost loop's field will take precedence.
		
		A Loop command in Playback may perform different then an exported script duo to the method used internally by Macro Creator.  
		
		In Playback all iterations will be performed prior to any commands in the Loop section.

	Extra:
		### Related
			[Loop Parse](http://l.autohotkey.net/docs/commands/LoopParse.htm)
		
		### Download Example
			[Loop through folders, parse and read file's contents](Examples\LoopTypes.pmc).
*/

/*!
	Function: Loop_Read()
		Retrieves the lines in a text file, one at a time.

	Parameters:
		Input File - The name of the text file whose contents will be read by the loop.

	Remarks:
		The built-in variable **A_LoopReadLine** exists within any file-reading loop. It contains the contents of the current line excluding the carriage return and linefeed (`r`n) that marks the end of the line. If an inner file-reading loop is enclosed by an outer file-reading loop, the innermost loop's file-line will take precedence.
		
		A Loop command in Playback may perform different then an exported script duo to the method used internally by Macro Creator.  
		
		In Playback all iterations will be performed prior to any commands in the Loop section.

	Extra:
		### Related
			[Loop Read File](http://l.autohotkey.net/docs/commands/LoopReadFile.htm)
		
		### Download Example
			[Loop through folders, parse and read file's contents](Examples\LoopTypes.pmc).
*/

/*!
	Function: Loop_Registry()
		Retrieves the contents of the specified registry subkey, one item at a time.

	Parameters:
		Key - The name of the key (e.g. Software\SomeApplication). If blank or omitted, the contents of RootKey will be retrieved.
		Root Key - Must be either HKEY_LOCAL_MACHINE (or HKLM), HKEY_USERS (or HKU), HKEY_CURRENT_USER (or HKCU), HKEY_CLASSES_ROOT (or HKCR), or HKEY_CURRENT_CONFIG (or HKCC).  
			To access a remote registry, prepend the computer name and a colon, as in this example: \\workstation01:HKEY_LOCAL_MACHINE
		Subkeys? - *Unchecked*: Subkeys contained within Key are not retrieved (only the values).  
			*First Check*: All values and subkeys are retrieved.  
			*Second Check*: Only the subkeys are retrieved (not the values).
		Recurse - *Unchecked*: Subkeys are not recursed into.  
			*Checked*: Subkeys are recursed into, so that all values and subkeys contained therein are retrieved.

	Remarks:
		The following variables exist within any registry-loop. If an inner registry-loop is enclosed by an outer registry-loop, the innermost loop's registry item will take precedence:
		* A_LoopRegName, A_LoopRegType, A_LoopRegKey, A_LoopRegSubKey, A_LoopRegTimeModified
		
		For a description of each variable follow the link in the **Related** section below.

		A Loop command in Playback may perform different then an exported script duo to the method used internally by Macro Creator.  
		
		In Playback all iterations will be performed prior to any commands in the Loop section.

	Extra:
		### Related
			[Loop Registry](http://l.autohotkey.net/docs/commands/LoopReg.htm)
*/

/*!
	Function: Break()
		Exits (terminates) a loop.

	Parameters:
		LoopNumber - If specified, identifies which loop this statement should apply to by numeric nesting level. If omitted or 1, this statement applies to the innermost loop in which it is enclosed.  
			This parameter is available when editing the command or adding it from the *Run* command window. Labels are not yet supported.  

	Extra:
		### Related
			[Break](http://l.autohotkey.net/docs/commands/Break.htm)
*/

/*!
	Function: Continue()
		Skips the rest of the current loop iteration and begins a new one.

	Parameters:
		LoopNumber - If specified, identifies which loop this statement should apply to by numeric nesting level. If omitted or 1, this statement applies to the innermost loop in which it is enclosed.  
			This parameter is available when editing the command or adding it from the *Run* command window. Labels are not yet supported.  

	Extra:
		### Related
			[Continue](http://l.autohotkey.net/docs/commands/Continue.htm)
*/

/*!
	Function: Goto_and_Gosub()
		Jump to a Label or Macro.

	Parameters:
		Go to Label - Name of a label (you can select one in the list) to jump to.  
			To use a Macro as label select the corresponding Macro*N* in the list.  
		Goto / Gosub - Sets the command to be used.  
			Goto jumps to the specified label and continues execution.  
			Gosub jumps to the specified label and continues execution until Return is encountered or the end of a Macro is reached.

	Remarks:
		If the target label does not exist the command will be ignored during playback but exported scripts will not work.

	Extra:
		### Related
			[Goto](http://l.autohotkey.net/docs/commands/Goto.htm), [Gosub](http://l.autohotkey.net/docs/commands/Gosub.htm)
*/

/*!
	Function: Label()
		A label identifies a line of code, and can be used as a Goto target or to form a subroutine.

	Parameters:
		Add Label - A valid name for the new label.  
			You can use Goto to jump directly to this line from any Macro.

	Extra:
		### Related
			[Labels](http://l.autohotkey.net/docs/misc/Labels.htm)
*/

/*!
	Function: If_Statements()
		Creates a Control of Flow block. The commands enclosed within the If Statement and EndIf will only be executed if the evaluated statement returns TRUE.  

	Parameters:
		Options DropdownList - Selects the statement to evaluate. If the statement resolves to true the commands inside below the If Statement will be executed, otherwise they will be skipped until *EndIf* or an *Else* is reached.  
			For *Compare Variables* the VarName to the left of the operator should NOT be enclosed in percent signs, only the variables to the right of it must use them.  
			The operators accepted are:  
			> =, ==, <>, !=, >, <, >=, <=.
			*Evaluate Expression* can evaluate any valid expression as true or false. This option uses [Eval()](http://www.autohotkey.com/board/topic/15675-monster) function so all variables MUST be enclosed in percent signs.
		Add Else - Add an *Else* Statement. If the If Statement above it resolves to false the commands below it will be executed instead, otherwise they will be skipped until *EndIf* is reached. This should be placed before the *EndIf*.

	Remarks:
		To evaluate two or more statements you'll have to add them sequence in the list, each one with a corresponding EndIf.  
		
		For more details on usage with other commands see [Variables & Functions](p8-Variables.html).

	Extra:
		### Related
			[IfWinActive / IfWinNotActive](http://l.autohotkey.net/docs/commands/IfWinActive.htm), [IfWinExist / IfWinNotExist](http://l.autohotkey.net/docs/commands/IfWinExist.htm), [IfExist / IfNotExist](http://l.autohotkey.net/docs/commands/IfExist.htm), [IfInString / IfNotInString](http://l.autohotkey.net/docs/commands/IfInString.htm), [IfMsgBox](http://l.autohotkey.net/docs/commands/IfMsgBox.htm), [If Statements](http://l.autohotkey.net/docs/commands/IfEqual.htm)
*/

/*!
	Function:Assign_Variable()
		Assigns a Variable to a Value using the chosen operator.

	Parameters:
		Output Variable - Name of the Variable in which to store the contents.
		Operator - Operator to use in the assignment.
		Content - Text, Variables or Function to be assigned.  
		Expression - If enabled will execute the [Eval()](http://www.autohotkey.com/board/topic/15675-monster) function on the contents to solve functions and math expressions. This is especially useful to modify variables values without the need to create more Assignments. It also allows you to assign the variable to a function result like the in the *Functions* window, or use a function inside an expression.
			> X := %FoundX% + 100 ; Assigns X to the value of FoundX + 100.
			> X := InStr(AutoHotkey, y) + 4 ; Assigns X to 14.
			> X := Array(1, 2, 3) ; Creates an array.
			> Y := X[1] ; Assigns Y to the first value in the X array.
			> Y += 1 ; Increments Y by 1.
			*Note*: To keep this option enabled by default go to Options Menu > Settings > Misc. and check the option.
		Copy - Copies the variable's contents to the Clipboard.
		Reset - Erases the variable's contents.

	Remarks:
		Since Playback uses a function to dereference variables before assigning, variables references should be enclosed in percent signs. The references will be corrected for the exported script.
		> MyVar := %A_Now%

	Extra:
		### Related
			[Variables](http://l.autohotkey.net/docs/Variables.htm)
*/

/*!
	Function: Functions()
		Executes a Function and assigns the result to a Variable.  

	Parameters:
		Output Variable (Optional) - Name of the Variable in which to store the contents.
		Use Function from External File - Check this option to select an AutoHotkey Script File (.ahk) containing one or more functions to be used. This feature requires [AutoHotkey](http://www.autohotkey.com/) installed.  
			See Remarks below for more information.  
		Function Name - A valid AHK Built-in Function name or the name of a Function in the selected external .ahk file.
		Comma separated parameters - The list of parameters for the function.  
			*Notes*:  
			* Input only the parameters values, without parenthesis.  
			* Since Playback uses a function to dereference variables before assigning, variables references should be enclosed in percent signs. The syntax will be corrected for the exported script.  
			* Literal commas should be escaped (also valid for functions inside commands).
			> SubStr(This is`, a literal comma, 13)
			* It's not necessary to use "quotes" for string values.  
			* Omitted parameters will use their default values unless they are in-between other values.  
			> RegExReplace(%Haystack%, %Needle%, , , 10)
			The function above have 6 possible parameters. In this example parameters 3 and 4 will have blank values and parameter 6 will use the default value.  

	Remarks:
		AutoHotkey's Built-in Functions are supported by default. You can also run functions from external AutoHotkey Script Files if you have [AutoHotkey](http://www.autohotkey.com/) installed.  

	Extra:
		### External Functions
			If a *Standard Library File* is configured it will be automatically loaded when a new command is added.  
			
			When you load an external file the program will try to detect possible function names and list them in *Function Name* field. If the function you want doesn't appear in the list you can still type it manually.  
			
			When this feature is used in Playback it will create a temporary .ahk file in the same directory where Macro Creator is installed and run it using AutoHotkey. The result will be copied to the Output Variable and the script will be closed.  
			
			If the ahk file containing the function have #include directives they must contain the absolute path for the included files (e.g.: #include c:\lib\myfunction.ahk).  
			
			Since those functions are not loaded with Macro Creator they may take longer to execute.
		
		### Related
			[Functions](http://l.autohotkey.net/docs/Functions.htm)
*/

/*!
	Function: Internet_Explorer()
		Creates an Internet Explorer COM Object and adds automation commands for it.

	Parameters:
		Commands - The dropdown list contains some of the most used IE Methods and Properties. Select the correct one to manipulate the browser window or page elements.
		Set / Get - Chooses whether to set a value to the object or to copy the element's value to a variable.
		Method / Property - If you type a command that is not recognized by the program you have to select whether it's a Method or a Property.
		Value - Value to be used by a Method or to be set to a Property. This field accepts [Variables & Functions](p8-Variables.html).
		Output Variable - The name of the variable in which to store the value of a Property.
		Page Element / Index - Sets the page element and index on which to perform the action. The dropdown list selects the method to be used to identify the element. Use the *Get* button to easily identify elements of the page.
		Wait for page to load - Check this option when you expect the page to change after the command. This will execute a function after it to wait for the new page to be completely loaded before continuing, avoiding errors.

	Remarks:
		When you close the application, all references to Active Windows will be lost, to continue working using saved project files edit one of the lines and use the dropdown list to select the window you'll work with.

		It might be necessary to set *Focus* to an object before performing and action like *Click*.  
		
		Although not all Methods and Properties are listed it may still be possible to use them with the correct syntax. For more information on methods and properties please check Microsoft MSDN website.  
		
		To set a blank value use a pair of quotes: ""

	Extra:
		### Related
			[COM](http://l.autohotkey.net/docs/commands/ComObjCreate.htm), [Basic Webpage COM Tutorial](http://www.autohotkey.com/board/topic/47052-basic-webpage-controls), [IWebBrowser2 Interface (MSDN)](http://msdn.microsoft.com/en-us/library/aa752127)
*/

/*!
	Function: COM_Interface()
		Select Application (Advanced) allows to create any COM Object and add commands in AutoHotkey's dotted syntax format.

	Parameters:
		CLSID - CLSID or human-readable Prog ID of the COM object to create.
		Connect - Tries to connect to the Last Active COM Object registered to the selected CLSID to be used for the current session.
		Handle - Name of a Handle that will point to the object.
		Output Variable (Optional) - Name of the variable in which to store the result of COM Script.
		COM Script - Command line in AutoHotkey's dotted syntax to execute using the object. **Ommit the Handle from the beginning of the string**.  

	Remarks:
		You can enter multiple commands one by line (you can't assign variables this way).  
		
		The syntax for COM commands is the same as in AutoHotkey scripts except for:  
			* Variables MUST be enclosed in percent signs.
			* Strings must NOT be enclosed in quotes.
		
		To set a blank value use a pair of quotes: ""
		
		When you close the application, all references to Active Objects will be lost. To continue working using saved project files you must reconnect to the application by either editing one of the lines containing each handle and use the *Connect* button to re-create all references, or assigning the Handle to a ComObj function, usually ComObjActive(), though it will not work on all applications.
		
		To assign a value to the command use the *:=* operator. For example:
		> ActiveCell.Value := 100
		
		Self-references inside parameters are supported. In such cases **you must NOT ommit the Handle** from the parameter.
		> Range(Xl.Selection, Xl.Selection.Offset(5, 5)).Select
		
		To create a SafeArray enclose the values in blocks [].
		> Selection.Subtotal(2, -4157, [4, 5], 1, 0, 1)
		
		To use *ComObjMissing()* leave the parameter blank:
		> Function(1, 2, , 3, , 5)
		An exported script from the above example would be like:
		> Function(1, 2, ComObjMissing(), 3, ComObjMissing(), 5)
	
	Extra:
		### Related
			[COM](http://l.autohotkey.net/docs/commands/ComObjCreate.htm), [Basic Webpage COM Tutorial](http://www.autohotkey.com/board/topic/47052-basic-webpage-controls), [IWebBrowser2 Interface (MSDN)](http://msdn.microsoft.com/en-us/library/aa752127)
*/

/*!
	Function: Run_Scriptlet()
		Executes a VB or JScript scriptlet using COM ScriptControl. Does not work in 64-bit version.

	Parameters:
		Script - Script string in selected language format.  
		Script Language - Sets command to be executed using VBScript or JScript Language.

	Remarks:
		This command uses the ScriptControl COM Object. Some scripts may not work.  
		
		The ScriptControl Object is not compatible with 64-bit.  
	
	Extra:
		### Related
			[COM Object Reference](http://www.autohotkey.com/board/topic/56987-com-object-reference-autohotkey-l/)
*/

/*!
	Function: PostMessage_and_SendMessage()
		Sends a message to a window or control (SendMessage additionally waits for acknowledgement).

	Parameters:
		Message Number - The message number to send.
		wParam - The first component of the message.
		lParam - The second component of the message.

	Extra:
		### Related
			[PostMessage / SendMessage](http://l.autohotkey.net/docs/commands/PostMessage.htm), [Message List](http://l.autohotkey.net/docs/misc/SendMessageList.htm), [Microsoft MSDN](http://msdn.microsoft.com)
*/

