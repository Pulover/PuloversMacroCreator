/*!
	Library: Pulover's Macro Creator
		
		# Version: 5.4.1
		[www.macrocreator.com](https://www.macrocreator.com)  
		[Forum](https://www.autohotkey.com/boards/viewforum.php?f=63)
		
		Author: Pulover [Rodolfo U. Batista]  
		©2012-2021 Cloversoft Serviços de Informática Ltda
		
		Software License: [GNU General Public License](License.html)
		
		[AutoHotkey Online Documentation](https://www.autohotkey.com/docs)
		
		**Support Open Source software: [Donate](https://www.macrocreator.com/donate)**
		
*/

/*!
	Page: Quick Tutorial & Examples
	Filename: Tutorial
	Contents: @file:Tutorial.md
*/

/*!
	Page: FAQ - Frequently Asked Questions
	Filename: Faq
	Contents: @file:Faq.md
*/

/*!
	Page: Main Window
	Filename: Main
	Contents: @file:Main.md
*/

/*!
	Page: Record
	Filename: Record
	Contents: @file:Record.md
*/

/*!
	Page: Playback
	Filename: Playback
	Contents: @file:Playback.md
*/

/*!
	Page: Command Windows
	Filename: Commands
	Contents: @file:Commands.md
*/

/*!
	Page: Variables & Arrays/Objects
	Filename: Variables
	Contents: @file:Variables.md
*/

/*!
	Page: Functions
	Filename: Functions
	Contents: @file:Functions.md
*/

/*!
	Page: Export Window
	Filename: Export
	Contents: @file:Export.md
*/

/*!
	Page: Preview Window
	Filename: Preview
	Contents: @file:Preview.md
*/

/*!
	Page: Settings
	Filename: Settings
	Contents: @file:Settings.md
*/

/*!
	Page: About & Changes
	Filename: About
	Contents: @file:About.md
*/

/*!
	Function: Mouse(F2)
		Clicks a mouse button at the specified coordinates. It can also hold down a mouse button, turn the mouse wheel, or move the mouse.

	Parameters:
		Action - Selects the Mouse action to execute.
		Coordinates - Defines the coordinates of the window or screen where the action will be executed. This field accepts [Variables](../Variables.html), functions and expressions are not supported.  
			**Note**: Mouse Actions are affected by [Mouse Coordinates Settings](Settings.html#defaults).
		Click - Uses the *Click*. This usually works for most cases.
		Send - Uses *SendEvent*. Use this in case the Click Command doesn't work.
		Random coordinates - If checked coordinates of X and Y during playback will be a random value of more or less of the defined offset in pixels.
		Offset - Set the offset for the random coordinates in pixels.
		Relative - **If not used with Control**: Coordinates will be treated as an offset from mouse current position.  
			**If used with Control**: *Unchecked*: Click coordinates relative to the target window. *Checked*: Click coordinates relative to Control's position.
		Button - Selects the Mouse Button to send and the event type.  
			**Normal**: Sends a normal click.  
			**Hold**: Clicks and holds the button.  
			**Release**: Releases the button.
		Click Count - The number of times to click the mouse. This is not affected by Delay. This field accepts [Variables](../Variables.html).

	Extra:
		### Related
			[Click](https://www.autohotkey.com/docs/commands/Click.htm), [ControlClick](https://www.autohotkey.com/docs/commands/ControlClick.htm), [MouseClickDrag](https://www.autohotkey.com/docs/commands/MouseClickDrag.htm)
*/

/*!
	Function: Text(F3)
		Sends simulated keystrokes to a window. It may be used to send raw text or commands. This field accepts [Variables & Expressions](../Variables.html).

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
			[Send / SendRaw](https://www.autohotkey.com/docs/commands/Send.htm), [ControlSend](https://www.autohotkey.com/docs/commands/ControlSend.htm), [ControlSetText](https://www.autohotkey.com/docs/commands/ControlSetText.htm), [Clipboard](https://www.autohotkey.com/docs/misc/Clipboard.htm)
*/

/*!
	Function: Control(F4)
		Gathers various control commands. Please refer to [AutoHotkey documentation](https://www.autohotkey.com/docs) for details on each one.

	Parameters:
		Value - Second parameter of a Control Command when available. This field accepts [Variables & Expressions](../Variables.html).
		Output Variable - The name of the variable in which to store the result of Cmd. For *ControlGetPos* the variable you choose will be a prefix to the 4 outputvars. E.g. if you type a variable named "Pos_" the output will be saved to *Pos_X*, *Pos_Y*, *Pos_W* and *Pos_H*.
		Position/Size - Coordinates and sizes to move a control with ControlMove.

	Extra:
		### Related
			[Control](https://www.autohotkey.com/docs/commands/Control.htm), [ControlFocus](https://www.autohotkey.com/docs/commands/ControlFocus.htm), [ControlGet](https://www.autohotkey.com/docs/commands/ControlGet.htm), [ControlGetFocus](https://www.autohotkey.com/docs/commands/ControlGetFocus.htm), [ControlGetPos](https://www.autohotkey.com/docs/commands/ControlGetPos.htm), [ControlGetText](https://www.autohotkey.com/docs/commands/ControlGetText.htm), [ControlMove](https://www.autohotkey.com/docs/commands/ControlMove.htm), [ControlSetText](https://www.autohotkey.com/docs/commands/ControlSetText.htm)
		
		### Download Example
			[Using Control Commands to Read and Set Text](Examples/ControlCmd.pmc)
*/

/*!
	Function: Pause(F5)
		Waits the specified amount of time before continuing.

	Parameters:
		Add Pause - The amount of time to pause (choose format in the options below). This field accepts [Variables & Expressions](../Variables.html).
		Miliseconds / Seconds / Minutes - Sets format of time (seconds and minutes will be converted to miliseconds when the command is added).
		Random delay - Sets the command use a random value between Minimum and Maximum instead of a predefined value.
		Disable random delays for this command - If the global option for *Random delays" is active the command won't be affected.

	Extra:
		### Related
			[Sleep](https://www.autohotkey.com/docs/commands/Sleep.htm)
*/

/*!
	Function: Message_Box(Shift+F5)
		Displays the specified text in a small window containing two default buttons (OK and Cancel).

	Parameters:
		Message - Text to display in the message. If the Cancel button is pressed, execution will stop. This field accepts [Variables & Expressions](../Variables.html).
		Title - The title of the message box window. This field accepts [Variables & Expressions](../Variables.html).
		Icon - Sets the icon to be shown on the Message Box.
		Buttons - Sets which buttons will be shown on the message box.
		Default - Sets the default button.
		Always On Top - Sets the message to stay on top of other windows.
		Right justified - Make the text right-justified.
		Right to Left - Right-to-left reading order for Hebrew/Arabic.
		Timeout - Timeout in seconds.
		Add "If Statement" - Automatically adds an *If Message Box* statement below the command. You may select a range of rows to be wrapped by the statement block.

	Extra:
		### Related
			[MsgBox](https://www.autohotkey.com/docs/commands/MsgBox.htm)
*/

/*!
	Function: KeyWait(Ctrl+F5)
		Waits for a key pressed down.

	Parameters:
		Wait for Key - Single key to wait for. Macro will remain in sleep state until the selected key is pressed.
		Select from list - List of keyboard keys.
		Wait Timeout - Defines the limit of time to wait for the input.

	Extra:
		### Related
			[KeyWait](https://www.autohotkey.com/docs/commands/KeyWait.htm)
*/

/*!
	Function: Window(F6)
		Gathers various Window commands. Please refer to [AutoHotkey documentation](https://www.autohotkey.com/docs) for details on each one.
	Parameters:
		Value - Second parameter of a Window Command when available. This field accepts [Variables & Expressions](../Variables.html).
		Seconds - Seconds to wait for a Window Command when available. This field accepts [Variables & Expressions](../Variables.html).
		Output Variable - The name of the variable in which to store the result of Cmd. For *WinGetPos* the variable you choose will be a prefix to the 4 outputvars. E.g. if you type a variable named "Pos_" the output will be saved to *Pos_X*, *Pos_Y*, *Pos_W* and *Pos_H*.
		Position/Size - Coordinates and sizes to move a control with WinMove.

	Extra:
		### Related
			[WinActivate](https://www.autohotkey.com/docs/commands/WinActivate.htm), [WinActivateBottom](https://www.autohotkey.com/docs/commands/WinActivateBottom.htm), [WinClose](https://www.autohotkey.com/docs/commands/WinClose.htm), [WinGet](https://www.autohotkey.com/docs/commands/WinGet.htm), [WinGetClass](https://www.autohotkey.com/docs/commands/WinGetClass.htm), [WinGetText](https://www.autohotkey.com/docs/commands/WinGetText.htm), [WinGetTitle](https://www.autohotkey.com/docs/commands/WinGetTitle.htm), [WinGetPos](https://www.autohotkey.com/docs/commands/WinGetPos.htm), [WinHide](https://www.autohotkey.com/docs/commands/WinHide.htm), [WinKill](https://www.autohotkey.com/docs/commands/WinKill.htm), [WinMaximize](https://www.autohotkey.com/docs/commands/WinMaximize.htm), [WinMinimize](https://www.autohotkey.com/docs/commands/WinMinimize.htm), [WinMinimizeAll / WinMinimizeAllUndo](https://www.autohotkey.com/docs/commands/WinMinimizeAll.htm), [WinMove](https://www.autohotkey.com/docs/commands/WinMove.htm), [WinRestore](https://www.autohotkey.com/docs/commands/WinRestore.htm), [WinSet](https://www.autohotkey.com/docs/commands/WinSet.htm), [WinShow](https://www.autohotkey.com/docs/commands/WinShow.htm), [WinWait](https://www.autohotkey.com/docs/commands/WinWait.htm), [WinWaitActive / WinWaitNotActive](https://www.autohotkey.com/docs/commands/WinWaitActive.htm), [WinWaitClose](https://www.autohotkey.com/docs/commands/WinWaitClose.htm)
*/

/*!
	Function: Image_Search(F7)
		Searches a region of the screen for an image.

	Parameters:
		Start X/Y / End X/Y - Defines the Search area of the screen/window.
		Make Screenshot - Use this tool to take a screenshot of an area of the screen (see [Instructions](#make-screenshot-tool-instructions) for details on usage).
		File - Path for the image file, which is assumed to be in the same folder as MacroCreator.exe if an absolute path isn't specified. This field accepts [Variables & Expressions](../Variables.html).
		Search - Opens the File Select dialog to select an Image File.
		If found - Selects an action to execute when an image/pixel is found.  
			To execute a different action Select 'Continue' (or 'Break' to exit the command's loop) and use the 'If Image/Pixel Found' option in the If Statements window.
		If not found / Error - Selects an action to execute when an image/pixel is not found or if the command finds an error.  
			To execute a different action Select 'Continue' (or 'Break' to exit the command's loop) and use the 'If Image/Pixel Not Found' option in the If Statements window.
		Add "If Statement" - Automatically adds an *If Image/Pixel Found* statement below the command. You may select a range of rows to be wrapped by the statement block.
		Preview - Previews the selected image.  
			Double-Click an image to open the file with the associated application.
		Variables - Names of the Output variables where to store the X and Y coordinates when found.
		Adjust coordinates to the center of the image - Check this option to automatically correct the coordinates in the output variables to the center of the image, instead of the upper-left corner.
		Coord - Sets coordinate mode for the search to be relative to either the active window or the screen.
		Variations - Specify for n a number between 0 and 255 (inclusive) to indicate the allowed number of shades of variation in either direction for the intensity of the red, green, and blue components of each pixel's color.
		Icon - Specify for n a number between 0 and 255 (inclusive) to indicate the allowed number of shades of variation in either direction for the intensity of the red, green, and blue components of each pixel's color.
		Transparent - Specify one color within the image that will match any color on the screen.
		Scale - Width and height to which to scale the image (this width and height also determines which icon to load from a multi-icon .ICO file).
		Repeat until - Loops the command until the image is found or not found, according to the option selected.  
			When this option is checked you can use the Repeat counter to define the maximum number of times to search. If Repeat is 1, it will loop indefinitely until the image is found/not found or the user stops execution. And if it's a number higher than 1 or a variable, it will loop until the image is found/not found but no more than that number.
			

	Remarks:
		You may use the variables %FoundX% and %FoundY% (or the ones defined by you) in other commands like Mouse Move & Click when the image/pixel is found. To save the values to a different variable or increment the values, use the [Variables](Commands\../Variables.html) window.

	Extra:
		### Related
			[ImageSearch](https://www.autohotkey.com/docs/commands/ImageSearch.htm)
		
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
		
		### Set Region to the same area of the Screenshot
			* Hold the Alt key in the keyboard right before releasing the mouse button, or pressing Enter, to automatically set the Region area to the same as the area of the screenshot taken.
*/

/*!
	Function: Pixel_Search(F7)
		Searches a region of the screen for a pixel color.

	Parameters:
		Start X/Y / End X/Y - Defines the Search area of the screen/window.
		Color Picker - Opens the Color Picker Tool. Point the mouse to the desired location and Right-Click to get the pixel code (in RGB format).
		ColorID - The decimal or hexadecimal color ID to search for, in Blue-Green-Red (BGR) format. This field accepts [Variables & Expressions](../Variables.html).
		Search - Opens the Windows Color Pick dialog to select a pixel color.
		If found - Selects an action to execute when an image/pixel is found.  
			To execute a different action Select 'Continue' (or 'Break' to exit the command's loop) and use the 'If Image/Pixel Found' option in the If Statements window.
		If not found / Error - Selects an action to execute when an image/pixel is not found or if the command finds an error.  
			To execute a different action Select 'Continue' (or 'Break' to exit the command's loop) and use the 'If Image/Pixel Not Found' option in the If Statements window.
		Add "If Statement" - Automatically adds an *If Image/Pixel Found* statement below the command. You may select a range of rows to be wrapped by the statement block.
		Preview - Previews the selected pixel to search.
		Variables - Names of the Output variables where to store the X and Y coordinates when found.
		Adjust coordinates to the center of the image - Check this option to automatically correct the coordinates in the output variables to the center of the image, instead of the upper-left corner.
		Coord - Sets coordinate mode for the search to be relative to either the active window or the screen.
		Variations - Specify for n a number between 0 and 255 (inclusive) to indicate the allowed number of shades of variation in either direction for the intensity of the red, green, and blue components of each pixel's color.
		Fast - Uses a faster searching method that in most cases dramatically reduces the amount of CPU time used by the search.
		RGB - Causes ColorID to be interpreted as an RGB value instead of BGR. This option affects the Color Picker Tool but the retrieved color will be reversed in preview and Color Pick Dialog.
		Repeat until - Loops the command until the image is found or not found, according to the option selected.  
			When this option is checked you can use the Repeat counter to define the maximum number of times to search. If Repeat is 1, it will loop indefinitely until the image is found/not found or the user stops execution. And if it's a number higher than 1 or a variable, it will loop until the image is found/not found but no more than that number.

	Remarks:
		You may use the variables %FoundX% and %FoundY% (or the ones defined by you) in other commands like Mouse Move & Click when the image/pixel is found. To save the values to a different variable or increment the values, use the [Variables](Commands\../Variables.html) window.

	Extra:
		### Related
			[PixelSearch](https://www.autohotkey.com/docs/commands/PixelSearch.htm)
*/

/*!
	Function: Image_To_Text(F7)
		Convert images on screen, image files, or an image URL to text. This feature relies on tesseract.exe and leptonica_util.exe which are bundled with PMC. The installer is also bundled with English OCR language, and you can download more languages from this command window by clicking the [...] button while this command is selected.

	Parameters:
		Start X/Y / End X/Y - Defines the Search area of the screen/window.
		Output Variable - Name of the Variable in which to store the contents. This field accepts Object references such as Array[1] or Obj.Name.
		Languages - Selects the languages to be used in OCR among the available ones. You can also download more languages here.

	Remarks:
		You can also call this function - OCR() - from the [Function command window](Commands/Functions.html).

	Extra:
		### Related
			[Vis2](https://github.com/iseahound/Vis2)
*/

/*!
	Function: Run(F8)
		Gathers various AutoHotkey commands to execute different types of tasks. To get help on each command **right-click anywhere on the window** and select the corresponding link. For a complete list of commands refer to [AutoHotkey documentation](https://www.autohotkey.com/docs/).

	Parameters:
		Parameters Fields - Parameters will vary according to the selected command. All fields should accept [Variables & Expressions](../Variables.html) except for InputVar and OutputVar.

	Remarks:
		Don't use percent signs (%) for variables when the fields name is OutputVar or InputVar, for they should expect a variable already.

	Extra:
		### Related
			[Command and Function Index](https://www.autohotkey.com/docs/commands/index.htm)
*/

/*!
	Function: Loop(F9)
		Loops a section of the Macro enclosed within *LoopStart* and *LoopEnd*. Nested Loops are accepted.

	Parameters:
		Repeat - How many times to execute the loop section. If set to 0, the loop continues indefinitely until a break or return is encountered, or the Stop Key is pressed. This field accepts [Variables & Expressions](../Variables.html).

	Remarks:
		The built-in variable **A_Index** contains the number of the current loop iteration. It contains 1 the first time the loop's body is executed. For the second time, it contains 2; and so on. If an inner loop is enclosed by an outer loop, the inner loop takes precedence.
		
		A Loop command in Playback may perform different then an exported script duo to the method used internally by Macro Creator.

	Extra:
		### Related
			[Loop](https://www.autohotkey.com/docs/commands/Loop.htm)

		### Download Example
			[Examples of Loop commands](Examples/LoopTypes.pmc)
*/

/*!
	Function: Loop_FilePattern(F9)
		Retrieves the specified files or folders, one at a time.

	Parameters:
		File Pattern - The name of a single file or folder, or a wildcard pattern such as C:\Temp\*.tmp.
		Files - If checked will include files.
		Directories - If checked will include directories (folders).
		Recurse - If checked will recurse into subdirectories (subfolders).

	Remarks:
		The following variables exist within any file-loop. If an inner file-loop is enclosed by an outer file-loop, the innermost loop's file will take precedence:
		* A_LoopFileName, A_LoopFileExt, A_LoopFileFullPath, A_LoopFileLongPath, A_LoopFileShortPath, A_LoopFileShortName, A_LoopFileDir, A_LoopFileTimeModified, A_LoopFileTimeCreated, A_LoopFileTimeAccessed, A_LoopFileAttrib, A_LoopFileSize, A_LoopFileSizeKB, A_LoopFileSizeMB
		
		For a description of each variable follow the link in the **Related** section below.

		A Loop command in Playback may perform different then an exported script duo to the method used internally by Macro Creator.
		
		In Playback all iterations will be performed prior to any commands in the Loop section.

	Extra:
		### Related
			[Loop FilePattern](https://www.autohotkey.com/docs/commands/LoopFile.htm)
		
		### Download Example
			[Examples of Loop commands](Examples/LoopTypes.pmc)
*/

/*!
	Function: Loop_Parse(F9)
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
			[Loop Parse](https://www.autohotkey.com/docs/commands/LoopParse.htm)
		
		### Download Example
			[Examples of Loop commands](Examples/LoopTypes.pmc)
*/

/*!
	Function: Loop_Read(F9)
		Retrieves the lines in a text file, one at a time.

	Parameters:
		Input File - The name of the text file whose contents will be read by the loop.

	Remarks:
		The built-in variable **A_LoopReadLine** exists within any file-reading loop. It contains the contents of the current line excluding the carriage return and linefeed (`r`n) that marks the end of the line. If an inner file-reading loop is enclosed by an outer file-reading loop, the innermost loop's file-line will take precedence.
		
		A Loop command in Playback may perform different then an exported script duo to the method used internally by Macro Creator.
		
		In Playback all iterations will be performed prior to any commands in the Loop section.

	Extra:
		### Related
			[Loop Read File](https://www.autohotkey.com/docs/commands/LoopReadFile.htm)
		
		### Download Example
			[Examples of Loop commands](Examples/LoopTypes.pmc)
*/

/*!
	Function: Loop_Registry(F9)
		Retrieves the contents of the specified registry subkey, one item at a time.
		Key must be separated from RootKey by a slash instead of a comma, and both can be contained within a single variable. For example, Loop, Reg, HKLM\Software or Loop, Reg, %FullPathOfKey%.

	Parameters:
		Root Key - Must be either HKEY_LOCAL_MACHINE (or HKLM), HKEY_USERS (or HKU), HKEY_CURRENT_USER (or HKCU), HKEY_CLASSES_ROOT (or HKCR), or HKEY_CURRENT_CONFIG (or HKCC).  
			To access a remote registry, prepend the computer name and a colon, as in this example: \\workstation01:HKEY_LOCAL_MACHINE
		Key - The name of the key (e.g. Software\SomeApplication). If blank or omitted, the contents of RootKey will be retrieved.
		Values - If checked will include Values.
		Keys - If checked will include keys.
		Recurse - If checked will recurse into subkeys.

	Remarks:
		The following variables exist within any registry-loop. If an inner registry-loop is enclosed by an outer registry-loop, the innermost loop's registry item will take precedence:
		* A_LoopRegName, A_LoopRegType, A_LoopRegKey, A_LoopRegSubKey, A_LoopRegTimeModified
		
		For a description of each variable follow the link in the **Related** section below.

		A Loop command in Playback may perform different then an exported script duo to the method used internally by Macro Creator.
		
		In Playback all iterations will be performed prior to any commands in the Loop section.

	Extra:
		### Related
			[Loop Registry](https://www.autohotkey.com/docs/commands/LoopReg.htm)
*/

/*!
	Function: While_Loop(F9)
		Performs a series of commands repeatedly until the specified expression evaluates to false.

	Parameters:
		Expression - Any valid expression. For example: while x < y.

	Remarks:
		The expression is evaluated once before each iteration. If the expression evaluates to true (which is any result other than an empty string or the number 0), the body of the loop is executed; otherwise, execution jumps to the line following the loop's body.

	Extra:
		### Related
			[While Loop](https://www.autohotkey.com/docs/commands/While.htm)
			
		### Download example
			[Examples of Loop commands](Examples/LoopTypes.pmc)
*/

/*!
	Function: For_Loop(F9)
		Repeats a series of commands once for each key-value pair in an object.

	Parameters:
		Key - Name of the variable in which to store the key at the beginning of each iteration.
		Value - Name of the variable in which to store the value associated with the current key.
		Array Object - An object which contains an array.

	Remarks:
		The Key and Value variables can be named to any others. Both variables will exist inside the loop (and inner loops), showing each of the values on every iteration.

	Extra:
		### Related
			[For Loop](https://www.autohotkey.com/docs/commands/For.htm)
			
		### Download example
			[Examples of Loop commands](Examples/LoopTypes.pmc)
			[Assigning and retrieving an Array inside Command Parameters](Examples/Arrays.pmc)
*/

/*!
	Function: Until(F9)
		Applies a condition to the continuation of a Loop or For-loop.

	Parameters:
		Expression - Any valid expression.

	Remarks:
		The expression is evaluated once after each iteration, and is evaluated even if continue was used. If the expression evaluates to false (which is an empty string or the number 0), the loop continues; otherwise, the loop is broken and execution continues at the line following Until.

	Extra:
		### Related
			[For Loop](https://www.autohotkey.com/docs/commands/Until.htm)
			
		### Download example
			[Examples of Loop commands](Examples/LoopTypes.pmc)
*/

/*!
	Function: Break(F8, F9)
		Exits (terminates) a loop.

	Parameters:
		LoopNumber - If specified, identifies which loop this statement should apply to by numeric nesting level. If omitted or 1, this statement applies to the innermost loop in which it is enclosed.  
			This parameter is available when editing the command or adding it from the *Run* command window. Labels are not yet supported.

	Extra:
		### Related
			[Break](https://www.autohotkey.com/docs/commands/Break.htm)
*/

/*!
	Function: Continue(F8, F9)
		Skips the rest of the current loop iteration and begins a new one.

	Parameters:
		LoopNumber - If specified, identifies which loop this statement should apply to by numeric nesting level. If omitted or 1, this statement applies to the innermost loop in which it is enclosed.  
			This parameter is available when editing the command or adding it from the *Run* command window. Labels are not yet supported.

	Extra:
		### Related
			[Continue](https://www.autohotkey.com/docs/commands/Continue.htm)
*/

/*!
	Function: Return(F8, Shift+F9)
		Returns from a subroutine to which execution had previously jumped via Gosub.

	Extra:
		### Related
			[Continue](https://www.autohotkey.com/docs/commands/Return.htm)
*/

/*!
	Function: Goto_and_Gosub(Shift+F9)
		Jump to a Label or Macro.

	Parameters:
		Go to Label - Name of a label (you can select one in the list) to jump to. This field accepts [Variables & Expressions](../Variables.html).  
			To use a Macro as label, select the corresponding Macro name in the list.
		Goto / Gosub - Sets the command to be used.  
			Goto jumps to the specified label and continues execution.  
			Gosub jumps to the specified label and continues execution until Return is encountered or the end of a Macro is reached.

	Extra:
		### Related
			[Goto](https://www.autohotkey.com/docs/commands/Goto.htm), [Gosub](https://www.autohotkey.com/docs/commands/Gosub.htm)
*/

/*!
	Function: Label(Shift+F9)
		A label identifies a line of code, and can be used as a Goto target or to form a subroutine.

	Parameters:
		Add Label - A valid name for the new label.  
			You can use Goto and Gosub to jump directly to this line from any Macro.

	Extra:
		### Related
			[Labels](https://www.autohotkey.com/docs/misc/Labels.htm)
*/

/*!
	Function: Set_Timer(Ctrl+F9)
		Causes a subroutine to be launched automatically and repeatedly at a specified time interval.

	Parameters:
		Label - The name of the label or hotkey label to which to jump. This field accepts [Variables & Expressions](../Variables.html).
		Period - Creates or updates a timer using the absolute value of this parameter as the approximate number of milliseconds that must pass before the timer is executed.
		Options - Select the operation to perform with the timer.

	Remarks:
		PMC can execute up to 10 simultaneous timers. Every timer started will be registered in the current session so it can be disabled and re-enabled. To free more slots use the Delete option or *Delete all timers* link in the *Set Timer* window.

	Extra:
		### Related
			[Labels](https://www.autohotkey.com/docs/misc/SetTimer.htm)
*/

/*!
	Function: If_Statements(F10)
		Creates a Control of Flow block. The commands enclosed within the If Statement and EndIf will only be executed if the evaluated statement returns TRUE, which can be a number different than 0 or a non-empty string.

	Parameters:
		Options DropdownList - Selects the statement to evaluate. If the statement resolves to true the commands inside below the If Statement will be executed, otherwise they will be skipped until *EndIf* or an *Else* is reached.  
			For *Compare Variables* the Variable (left of the operator) should NOT be enclosed in percent signs. The Value (right of operator) can be any valid expression when the operator is one of the ones below:  
			> =, ==, <>, !=, >, <, >=, <=.  
			Strings must be enclosed in quotes.  
			For the other operators you can use variables enclosed in percent signs or literal strings without quotes.  
			*Evaluate Expression* can evaluate any valid expression as true or false. Variables must NOT be enclosed in percent signs. For more information see [Expressions](../Variables.html#expressions).
		Add Else - Add an *Else* Statement. If the If Statement above it resolves to false the commands below it will be executed instead, otherwise they will be skipped until *EndIf* is reached. This should be placed before the *EndIf*.
		Else If - Creates an *Else If* statement, which means that the statement must be inside another If block and will be evaluated only if the If before it evaluates to false. When this option is checked the *EndIf* row will not be created.

	Remarks:
		To evaluate two or more statements you can use the *Evaluate Expression* option as it supports multiple statements (e.g. Var > 10 && Var < 20) or you can add them in sequence in the list, each one with a corresponding EndIf.
		
		For more details on usage with other commands see [Variables](../Variables.html).

	Extra:
		### Related
			[IfWinActive / IfWinNotActive](https://www.autohotkey.com/docs/commands/IfWinActive.htm), [IfWinExist / IfWinNotExist](https://www.autohotkey.com/docs/commands/IfWinExist.htm), [IfExist / IfNotExist](https://www.autohotkey.com/docs/commands/IfExist.htm), [IfInString / IfNotInString](https://www.autohotkey.com/docs/commands/IfInString.htm), [IfMsgBox](https://www.autohotkey.com/docs/commands/IfMsgBox.htm), [If Statements](https://www.autohotkey.com/docs/commands/IfEqual.htm)
*/

/*!
	Function: Else(F10)
		Specifies the command(s) to perform if an IF-statement evaluates to FALSE. When more than one command is present, enclose them in a block (braces). For more information see [Comparing Variables](../Variables.html#comparing-variables).

	Remarks:
		Every use of ELSE must belong to (be associated with) an IF-statement above it. An ELSE always belongs to the nearest unclaimed IF-statement above it unless a block is used to change that behavior.
		
		An ELSE can be followed immediately by any other single command on the same line. This is most often used for "else if" ladders.
		
		An *Else If* statement must be inside another *If* block and does not have an *EndIf* of its own. The pseudo-code below shows the basic *If* structure in PMC.
		> [If]
		> [...]
		> [Else If]
		> [...]
		> [Else]
		> [...]
		> [EndIf]

	Extra:
		### Related
			[Else](https://www.autohotkey.com/docs/commands/Else.htm)
		
		### Download example
			[Comparing Variables in Playback](Examples/CompareVars.pmc)
*/

/*!
	Function:Variables(Shift+F10)
		Assigns a value to a Variable using the chosen operator. You can also assign expressions and linear/associative arrays using the "Expression" option. For more information see [Variables & Arrays/Objects](../Variables.html).

	Parameters:
		Output Variable - Name of the Variable in which to store the contents. This field accepts Object references such as Array[1] or Obj.Name.
		Operator - Operator to use in the assignment.
		Value - If *Expression* is not checked, this field accepts strings, numbers and variables enclosed in percent signs. When using *Expression*, you can enter any valid expression.
			> X := A string value ; If "Expression" is not checked, you don't need to use quotes for strings.
			> X := Today is %A_DD%. ; And it's necessary to enclose variables in percent signs.
		Expression - If checked, the value will be considered an expression. You can enter any valid expression, which may contain strings enclosed in quotes, variables (not enclosed in percent signs), numbers, math operations, functions and object references, including creating arrays.
			> X := FoundX + 100 ; Assigns X to the value of FoundX + 100.
			> X := InStr("AutoHotkey", "y") + 4 ; Assigns X to 14.
			> X := [10, 20, 30, "String", Variable] ; Creates an array.
			> X := Array(1, 2, 3) ; Creates an array with the Array function.
			> Y := X[1] ; Assigns Y to the first value in the X array.
			> Y += 1 ; Increments Y by 1.
			> X := {Name: "John", Age: 25}) ; Creates an associative array.
			> X[Name] := "George" ; Sets the "Name" element of X to "George".
			> X.Age += 2 ; Adds 2 to the "Age" element of X.
			*Note*: To keep this option enabled by default go to Settings > General and check the option.
		Copy - Copies the variable's contents to the Clipboard.
		Reset - Erases the variable's contents.

	For more information, check the [Variables](../Variables.html) help page.

	Extra:
		### Related
			[Variables](https://www.autohotkey.com/docs/Variables.htm)

		### Download Example
			[Using Variables inside Command Parameters](Examples/Variables.pmc)
			[Comparing Variables in Playback](Examples/CompareVars.pmc)
			[Assigning and retrieving Arrays](Examples/Arrays.pmc)
*/

/*!
	Function: Functions(Ctrl+F10)
		Executes a Function and assigns the result to a Variable. You can also call object methods in this window.

	Parameters:
		Output Variable (Optional) - Name of the Variable in which to store the contents.
		Array Object - If checked, the name of an Array/Object on which to call the method.
		Use Function from External File - Check this option to select an AutoHotkey Script File (.ahk) containing one or more functions to be used. This feature requires [AutoHotkey](https://www.autohotkey.com/) installed.  
			See Remarks below for more information.
		Function Name - A valid AHK Built-in Function, an existing [User-Defined function](Functions.html#user-defined-functions) or one in the selected external .ahk file.
		Comma separated parameters - The list of parameters for the function.
			*Notes*:
			* Input only the parameters values, without parenthesis.
			* Use [Expression](../Variables.html#expressions) format.
			* Do NOT enclose variables in percent signs.
			* Strings MUST be enclosed in quotes.
			* Omitted optional parameters will use their default values.
			> InStr("AutoHotkey", "o", , , 2)
			The function above have 5 possible parameters. In this example parameters 3 and 4 will use the default values.

	Remarks:
		AutoHotkey's Built-in Functions are supported by default. You can also define your own functions inside PMC in [User-Defined functions](Functions.html#user-defined-functions) window and run functions from external AutoHotkey Script Files, if you have [AutoHotkey](https://www.autohotkey.com/) installed.

	Extra:
		### External Functions
			If a *Standard Library File* is configured it will be automatically loaded when a new command is added.
			
			When you load an external file the program will try to detect possible function names and list them in *Function Name* field. If the function you want doesn't appear in the list you can still type it manually.
			
			When this feature is used in Playback it will create a temporary .ahk file in the same directory where Macro Creator is installed and run it using AutoHotkey. The result will be copied to the Output Variable and the script will be closed.
			
			If the ahk file containing the function have #include directives they must contain the absolute path for the included files (e.g.: #include c:\lib\myfunction.ahk).
			
			Since those functions are not loaded with Macro Creator they may take longer to execute.
			
			**Note**: This feature is limited and can only return 1 string/number value. It's recommended to use [User-Defined Functions](Functions.html#user-defined-functions) instead.

		
		### Related
			[Functions](https://www.autohotkey.com/docs/Functions.htm)
*/

/*!
	Function: Send_Email(F11)
		Sends emails using an user-defined account. All fields accept [variables](../Variables.html).

	Parameters:
		Message - Body of the message. It can be text or HTML.
		HTML - Check this option to use HTML format in the email body.
		Headers - Standard Email fields.
		Attachments - Add and edit file attachments. Add one file per line with the full path. You can drop files in here.

	Remarks:
		You can add and edit accounts clicking on the *Email accounts* link or in the Settings window.
		
		Accounts informations are saved to *UserEmailAccounts.ini* located at %AppData%\MacroCreator or at the application folder when in Portable mode.
		
		To use a Gmail account it's necessary to activate allow ["Less secure apps access"](https://www.google.com/settings/security/lesssecureapps).
		
		**Warning**: Scripts exported (even if compiled) with the send email function (CDO) will have visible informations of email accounts used, including the **password**. The PMC project file does not have this information.
		
		To bypass error messages go to Options > Settings > Playback and check the "Do not display errors" option.
		
	Extra:
		### Related
			[COM](https://www.autohotkey.com/docs/commands/ComObjCreate.htm), [CDO (Microsoft)](https://docs.microsoft.com/en-us/previous-versions/office/developer/exchange-server-2003/ms988614(v=exchg.65))
*/

/*!
	Function: Download_Files(Shift+F11)
		Downloads one or more files from the Internet. All fields accept [variables](../Variables.html).

	Parameters:
		Destination folder - The name of the destination folder, which is assumed to be in %A_WorkingDir% if an absolute path isn't specified.
		Download links - A list of download links to be downloaded. Separate links by semicolon, comma or line.

	Remarks:
		This function is not guaranteed to work with any Url.
		
		To bypass error messages go to Options > Settings > Playback and check the "Do not display errors" option.
		
	Extra:
		### Related
			[COM](https://www.autohotkey.com/docs/commands/ComObjCreate.htm), [WinHttpRequest object (Microsoft)](https://docs.microsoft.com/en-us/windows/win32/winhttp/winhttprequest)
*/

/*!
	Function: Zip_Files(Ctrl+F11)
		Compress or uncompress one or more zip files. All fields accept [variables](../Variables.html).

	Parameters:
		Zip files / Unzip files - Select the desired operation.
		Destination file/folder - The name of the destination, which is assumed to be in %A_WorkingDir% if an absolute path isn't specified.
		Files - A list of files or patterns to be compressed or uncompressed. Separate files by semicolon, comma or line. You can drop files in here.
		Compress/Extract each file to different archive/folder - Check this option to have each file/folder compressed or extracted to an individual file/folder.

	Remarks:
		For *Zip* command you can use file patterns in *Files*, e.g.: C:\File\*.*.
		
		You can extract multiple zip files in the same command.
		
		This function does not support other types of compressed files. For other formats, use the `Run` command to execute an adequate application.
		
		To bypass error messages go to Options > Settings > Playback and check the "Do not display errors" option.
		
	Extra:
		### Related
			[COM](https://www.autohotkey.com/docs/commands/ComObjCreate.htm), [Shell object (Microsoft)](https://docs.microsoft.com/en-us/windows/win32/shell/shell)
*/

/*!
	Function: Internet_Explorer(F12)
		Creates an Internet Explorer COM Object and adds automation commands for it. All fields accept [variables](../Variables.html), except *Commands*.

	Parameters:
		Commands - The dropdown list contains some of the most used IE Methods and Properties. Select the correct one to manipulate the browser window or page elements.
		Set / Get - Chooses whether to set a value to the object or to copy the element's value to a variable.
		Method / Property - If you type a command that is not recognized by the program you have to select whether it's a Method or a Property.
		Value - Value to be used by a Method or to be set to a Property. This field accepts [Variables & Expressions](../Variables.html).
		Output Variable - The name of the variable in which to store the value of a Property.
		Page Element / Index - Sets the page element and index on which to perform the action. The dropdown list selects the method to be used to identify the element. Use the *Get* button to easily identify elements of the page.
		Wait for page to load - Check this option when you expect the page to change after the command. This will execute a function after it to wait for the new page to be completely loaded before continuing, avoiding errors.

	Remarks:
		When you close the application, all references to Active Windows will be lost, to continue working using saved project files edit one of the lines and use the dropdown list to select the window you'll work with.

		It might be necessary to set *Focus* to an object before performing and action like *Click*.
		
		Although not all Methods and Properties are listed it may still be possible to use them with the correct syntax. For more information on methods and properties please check Microsoft MSDN website.
		
		To bypass error messages go to Options > Settings > Playback and check the "Do not display errors" option.
		
	Extra:
		### Related
			[COM](https://www.autohotkey.com/docs/commands/ComObjCreate.htm), [Basic Webpage COM Tutorial](http://www.autohotkey.com/board/topic/47052-basic-webpage-controls), [IWebBrowser2 Interface (Microsoft)](https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/platform-apis/aa752127(v=vs.85))
*/

/*!
	Function: Expression(Shift+F12)
		Performs one or more operations upon a series of variables, literal strings, and/or literal numbers. For more information see [Expressions](../Variables.html#expressions).

	Parameters:
		Automatically create COM object - Check this option let PMC create (if not yet created) a COM object using the defined CLSID.
		Handle - Name of a Handle that will point to the object. You still need to use this Handle in the script to access methods and properties.
		CLSID - CLSID or human-readable Prog ID of the COM object to create.
		Connect - Attempts to connect the selected Handle with an existing instance of the selected CLSID.
		Expression / COM Script - One or more expressions to be executed. You can make assingments, function and object calls, etc. You can enter multiple expressions separated by lines or commas. For details see [AHK documentation](https://www.autohotkey.com/docs/Variables.htm#Expressions).
		Page Element / Index - Searches for a page element and index on an IE window.
		Wait for page to load - Check this option when you expect the page to change after the command when running IE COM scripts. This will execute a function after it to wait for the new page to be completely loaded before continuing, avoiding errors.

	Remarks:
		You can enter multiple expressions separated by line or commas.
		
		You can make math operations, variables and object assignments, as well as function and object calls.
		
		Nearly all operators are supported, including ternary.
		
		The syntax for COM/object calls is the same as in AutoHotkey scripts:
			* Variables must NOT be enclosed in percent signs.
			* Strings MUST be enclosed in quotes.
		
		When you close the application, all references to Active Objects will be lost. To continue working using saved project files you must reconnect to the application by either editing one of the lines containing each handle and use the *Connect* button to re-create all references, or assigning the Handle to a ComObj function, usually ComObjActive(), though it will not work on all applications.
		
		To bypass error messages go to Options > Settings > Playback and check the "Do not display errors" option.
					
	Extra:
		### Related
			[Expressions](https://www.autohotkey.com/docs/Variables.htm#Expressions), [Operators in Expressions](https://www.autohotkey.com/docs/Variables.htm#Operators), [COM](https://www.autohotkey.com/docs/commands/ComObjCreate.htm), [Basic Webpage COM Tutorial](http://www.autohotkey.com/board/topic/47052-basic-webpage-controls), [IWebBrowser2 Interface (Microsoft)](https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/platform-apis/aa752127(v=vs.85))
*/

/*!
	Function: PostMessage_and_SendMessage(Ctrl+F12)
		Sends a message to a window or control (SendMessage additionally waits for acknowledgement). All fields accept [variables](../Variables.html).

	Parameters:
		Message Number - The message number to send.
		wParam - The first component of the message.
		lParam - The second component of the message.

	Extra:
		### Related
			[PostMessage / SendMessage](https://www.autohotkey.com/docs/commands/PostMessage.htm), [Message List](https://www.autohotkey.com/docs/misc/SendMessageList.htm), [Microsoft Docs](https://docs.microsoft.com/)
*/