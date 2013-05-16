# Main Window

**Note**: Right-click on a Button in the Main Window or anywhere on a Command Window to display links to AutoHotkey online help.

## Table of Contents

* [Buttons & Menus](#Buttons-&-Menus)
* [Edit Commands](#Edit-Commands)
* [Macros](#Macros)
* [Command Line Parameters](#Command-Line-Parameters)
* [Keyboard Shortcuts](#Keyboard-Shortcuts)

## Buttons & Menus

**New**: Starts a new Project.

**Open**: Opens a Project (it can be a PMC file or an AHK file containing a PMC Code).

**Save / Save As**: Saves current Project in a PMC file including all non-empty Macros.

**Import**: Imports a Project without erasing the current one. All found Macros will be appended to the tab list.

**Save Current Macro**: Saves the currently selected Macro to a PMC file.

**Export**: Opens the [Export Window](p5-Export.html) to save Macros in AHK Script Format.

**Preview**: Opens the [Preview Window](p6-Preview.html) which shows the current Macro in AHK Script.

**Options**: Opens the [Settings Window](p7-Settings.html) where it's possible to configure various options.

**List Variables**: Displays both internal and user-defined variables and their current contents.

**Record**: Activates [Recording](p2-Record.html) Hotkeys.

**Play**: Activates [Playback](p3-Playback.html) Hotkeys.  

**Play Current Macro**: Runs currently selected Macro immediately without Hotkeys.  
*Note*: An *AutoPlay* feature is available via command line with the -a parameter: add -a or -a*N* (where *N* is the number of the Macro to run) as a parameter to run a Macro on program start up. The example below would execute the second Macro in the project file.

> MacroCreator.exe SavedFile.pmc -a2

**Play From Selected Row**: If checked Playback will run each Macro from the first selected row in its list. Valid for all Playback commands.

**Play Until Selected Row**: If checked Playback will stop each Macro when the first selected row in its list is reached. Valid for all Playback commands.

**Play Selected Rows**: If checked Playback will only execute selected rows in each Macro. Valid for all Playback commands.

**Timer**: *Play once* runs currently selected Macro one time after the specified time. *Play every X (mili)seconds* runs it automatically and repeatedly at the specified time interval.  
The Abort Hotkey can be used to turn the Timer off.  
To have other Macros active during Timer check the *Always Active* option or right-click the TrayMenu icon and select **Play**.  

**Command Buttons**: See [Command Windows](p4-Commands.html).

**Auto.**: Selects the Automatic Hotkey to execute the currently selected Macro (The Win option adds the Windows Key as modifier).

**Man.**: Selects the Manual Hotkey to execute the currently selected Macro step-by-step.

**Stop**: Selects the Hotkey to stop execution (the Pause option changes the behavior to pause execution).

**Loop**: Number of loops to execute the currently selected Macro. If set to 0, the loop continues indefinitely until a break or return is encountered, or the Stop Key is pressed.

**Show Info**: Enables displaying of tooltips and traytips during Recording/Playback.

**Show Controls**: If checked will display [On-Screen Controls](p3-Playback.html#On-Screen-Controls) window when *Record* or *Play* button is pressed. It's a smaller window with Playback and Record buttons allow these commands using the mouse. You can also open it from the Macro Menu and TrayIcon.

**Add Macro**: Adds a new Macro tab.

**Close Macro**: Closes the currently selected Macro tab.

**Duplicate Macro**: Copies the currently selected Macro to a new tab.

**Context Sensitive Hotkeys**: Makes hotkeys work depending on the type of window that is active or exists. For more information see [AutoHotkey documentation](http://l.autohotkey.net/docs).

**Capture Keys**: Enables Capturing of Key Presses on currently selected Macro List on the Main Window (this option does not affect Recording).

**Always Active**: Keeps all valid Hotkeys always activated (including Record & Playback).

**Repeat**: This field is used as a quick-edit to set the Repeat number to selected rows using the Apply buttons on the right.

**Delay (ms)**: Default delay between commands. The number set in this box will be automatically applied to a new added command (except for Mouse and Window commands which have individual default values that can be set in the [Settings Window](p7-Settings.html#Defaults)). This field is also used as a quick-edit to set the Delay to selected rows using the Apply buttons on the right.

**Insert Box**: This box can be used to add commands to the list. Click in the box and press the buttons to add on the keyboard then press the Insert button to add them to the list (you can also use the Insert key as a shortcut when the focus is on the ListView).

**Edit Button**: When only one row is selected it has tha same behavior as a double-click on a row to enter the command's window for editing. If more then one or no row is selected it will open an edit window where you change the target Control and Window, Repeat Loops or Delay for selected rows (or all rows if none is selected). If the all checkboxes are left unchecked it will remove Control and Window from selected rows. Control and Window will only affect Send, Click and Control commands.

## Edit Commands

**Add Macro**: Creates a new Macro tab.

**Close Macro**: Closes the currently selected Macro tab.

**Duplicate Macro**: Copies all commands from currently selected Macro to a new tab.

**Move Rows**: Moves selected rows Up/Down.

**Cut Rows**: Cut selected Rows.

**Copy Rows**: Copy selected Rows.

**Paste Rows**: Paste copied Rows.

**Delete Rows**: Deletes selected Rows.

**Insert from Box**: Inserts the command in the Hotkey box at the bottom in the current selected row (or at the end of the list if no row is selected).

**Undo**: Undo one step in History of current Macro. History is individual for each Macro.

**Redo**: Redo one step in History of current Macro. History is individual for each Macro.

**Duplicate Rows**: Duplicates selected rows in the same list.

**Copy to...**: Copies selected rows to a different Macro tab.

**Edit Comment**: Adds / Changes the comment to be displayed to the right of the line in Exported AHK Scripts on selected rows.

**Find / Replace**: This window helps finding and replacing parts of the commands in the *Details*, *Repeat*, *Delay*, *Control* and *Window* columns only. To select similar Command Types use the Select Menu.  
Note: Changing parameters of certain commands may cause misbehavior in Playback. Replace should be used only when and where necessary.

### General Remarks

When you click the Delete or Apply button (for Repeat or Delay) it will affect all selected rows, and if no row is selected it will apply to all rows in the current list.

When adding a new command either by Command Window, Capturing keys or the Insert button if no row is selected they will be added to the end of the list, if one row is selected they will be added on top of that row, and if more then one row is selected a new copy of the command will be added on top of each selected row, except for Loop, and If Statements which will add a Start on top of the first selected row and an End below the last selected row, and for Goto, Label, Break, Continue, Variable Assignment and Functions, which will add only one row on top of the first selected.

## Macros

**Macro Tabs**: Macro Creator supports multiple Macros / Hotkeys. To create a new Macro, click the **+** button (Add Macro / Ctrl+T). When you add or select a Macro in the tab list the current Hotkeys for it are displayed on the top-right part of the window, you can change them by clicking the box and pressing the keys on the keyboard. To remove a Hotkey click the box and press Backspace. Macros which have no Hotkey or no line of command will not be activated for Playback.

**Macro Lists**: All commands of the Macros are displayed in the ListView.  
They can be added using the Command Windows, by recording your actions or by duplicating items.  
To edit an item double-click on it or select the ones you want and press the Edit button at the bottom of the window.  
Use the buttons on the right (or their shortcuts) to move, delete, duplicate the selected items.  
Uncheck the checkboxes in the first column to disable specific actions during playback (they will also be ignored in Preview and Export).

**ListView Columns**:
* *Index*: Position of command in the list.
* *Action*: Description or name of the command.
* *Details*: Parameters or details of the command.
* *Repeat*: Number of times to execute the command.
* *Delay*: Time of pause in miliseconds before the next command or repetition.
* *Type*: Actual name of the command.
* *Control*: Name of the control to where the command will be sent.
* *Window*: Name of the window which will be affected by the command.
* *Comment*: Optional comment line to display in front of the command when the script is exported to AHK.

**Quick Select**: This feature allows you to select similar rows based on any column from *Details* to *Comment*. Select any row (if more then one row is selected the first one will be used) and click on a column header to select similar rows based on that column.

**Show Colors && Help Marks for Loops and Statements**: Click on the *Index* Column Header to turn this option On/Off. When activated rows inside Loops and text of rows inside Statements will be shown in colors, also braces and wildcards will be placed in front of command's index as representation to help visualize which rows are nested. Braces represent Loops and Wildcards represent If Statements, so for example *N* \*{\*{ is equivalent to:  
> If
> {
> 	Loop
> 	{
> 		If
> 		{
> 			Loop
> 			{
> 				N
> 			}
> 		}
> 	}
> }
You can change the default colors in Settings > Misc.

**Show Indentation for Loops and Statements**: Double-Click on the *Action* Column Header to turn this option On/Off. When activated Actions inside Loops or Statements will be shown with indentation.  
You can change the default colors in Settings > Misc.

## Command Line Parameters

Macro Creator supports command line parameters. The format is:

> MacroCreator.exe [Filenames] [Parameters]

**Parameters**:  

-p -- *Play*: Activate Playback Hotkeys on program start up.

> MacroCreator.exe SavedFile.pmc -p

-a or -a*N* -- *AutoPlay*: Runs a Macro on program start up. *N* is the number of the Macro to run. The example below would execute the second Macro in the project file.

> MacroCreator.exe SavedFile.pmc -a2

-t or -t*N* -- *Timer*: Runs a Macro automatically and repeatedly at the specified time interval. *N* is the interval in miliseconds, if not present defaults to 250ms. This paramter may be combined with the -a*N* to select which Macro to run.

> MacroCreator.exe SavedFile.pmc -t -a4

-c -- *Close*: Exits the program after the first Macro is executed (normally used with the -a option).

> MacroCreator.exe SavedFile.pmc -a -c

-h -- *Hide*: Hide Main Window on program start up (right-click the tray icon to show it).

> MacroCreator.exe SavedFile.pmc -h

-s or -s*N* -- *Silent*: Combines -a, -h and -c parameters.

> MacroCreator.exe SavedFile.pmc -s3

You can load multiple files with multiple parameters.

> MacroCreator.exe File1.pmc File2.pmc File3.pmc -h -p -a3

## Keyboard Shortcuts

**Ctrl+Enter**: Play

**Ctrl+Shift+Enter**: Play Current Macro

**Ctrl+Shift+T**: Timer

**Ctrl+R**: Record

**Ctrl+B**: Display Controls Toolbar

**Ctrl+N**: New

**Ctrl+O**: Open

**Ctrl+S**: Save

**Ctrl+Shift+S**: Save As

**Ctrl+I**: Import

**Ctrl+Alt+S**: Save Current Macro

**Ctrl+E**: Open Export Window

**Ctrl+P**: Open Preview Window

**Ctrl+A**: Select All Rows

**Ctrl+Shift+A**: Unselect All Rows

**Ctrl+Alt+A**: Invert Selection

**Ctrl+Q**: Check Selected Rows

**Ctrl+Shift+Q**: Uncheck Selected Rows

**Ctrl+Alt+Q**: Invert Checks in Selected Rows

**Ctrl+C**: Copy Selected Rows

**Ctrl+X**: Cut Selected Rows

**Ctrl+V**: Paste Copied Rows

**Ctrl+D**: Duplicate Row(s)

**Ctrl+T**: Add New Macro

**Ctrl+W**: Close Macro

**Ctrl+Shift+D**: Duplicate Macro

**Ctrl+F**: Find / Replace

**Ctrl+PageUp** or **Ctrl+WheelUp**: Move Selected Row(s) Up

**Ctrl+PageDown** or **Ctrl+WheelDown**: Move Selected Row(s) Down

**Ctrl+Z**: Undo one step in History of current Macro

**Ctrl+Y**: Redo one step in History of current Macro

**Ctrl+1 to 0**: Select Macro

**Enter**: Edit selected Row(s)

**Insert**: Insert Key(s) from Insert Box

**Delete**: Delete Row(s)

**Ctrl+G**: Options

**Ctrl+H**: Context Sensitive Hotkeys

**Alt+1**: Play from Selected Row

**Alt+2**: Play until Selected Row

**Alt+3**: Play Selected Rows

**Alt+F3**: List Variables

**Alt+F4**: Exit

**Alt+F5**: Reset Columns Size

**Alt+F6**: Default Hotkeys

**Alt+F7**: Default Settings

**F1**: Help

**F2**: Mouse

**F3**: Text

**Shift+F3**: Special Keys

**F4**: Control

**F5**: Pause

**Shift+F5**: Message

**Control+F5**: Key Wait

**F6**: Window

**F7**: Image Search / Pixel Search

**F8**: Run / File / String / Misc.

**F9**: Loop

**Shift+F9**: Goto

**Ctrl+F9**: Label

**F10**: If Statements

**Shift+F10**: Variables

**Ctrl+F10**: Functions

**F11**: Internet Explorer

**Shift+F11**: COM Interface (Advanced)

**F12**: Windows Messages
