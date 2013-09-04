﻿# Main Window

**Note**: Right-click on a Button in the Main Window or anywhere on a Command Window to display links to AutoHotkey online help.

## Table of Contents

* [Files](#files)
* [Record & Play](#record-&-play)
* [Options](#options)
* [Edit Commands](#edit-commands)
* [Modify / Insert](#modify-/-insert)
* [Macros](#macros)
* [Command Line Parameters](#command-line-parameters)
* [Keyboard Shortcuts](#keyboard-shortcuts)

## Files

**New**: Starts a new Project.

**Open**: Opens a Project (it can be a PMC file or an AHK file containing a PMC Code).

**Save / Save As**: Saves current Project in a PMC file including all non-empty Macros.

**Export**: Opens the [Export Window](p5-Export.html) to save Macros in AHK Script Format.

**Preview**: Opens the [Preview Window](p6-Preview.html) which shows the current Macro in AHK Script.

**Options**: Opens the [Settings Window](p7-Settings.html) where it's possible to configure various options.

**List Variables**: Displays both internal and user-defined variables and their current contents.

## Record & Play

**Record**: Activates [Recording](p2-Record.html) Hotkeys.

**Activate Macros**: Activates [Playback](p3-Playback.html) Hotkeys.  

**Play Current Macro**: Runs currently selected Macro immediately without Hotkeys.  
*Note*: An *AutoPlay* feature is available via command line with the -a parameter: add -a or -a*N* (where *N* is the number of the Macro to run) as a parameter to run a Macro on program start-up. The example below would execute the second Macro in the project file.

> MacroCreator.exe SavedFile.pmc -a2

**Timer**: *Play once* runs currently selected Macro one time after the specified time. *Play every X (mili)seconds* runs it automatically and repeatedly at the specified time interval.  
The Abort Hotkey can be used to turn the Timer off.  
To have other Macros active during Timer check the *Always Active* option or right-click the TrayMenu icon and select **Play**.  

**Play From Selected Row**: If checked Playback will run each Macro from the first selected row in its list. Valid for all Playback commands.

**Play Until Selected Row**: If checked Playback will stop each Macro when the first selected row in its list is reached. Valid for all Playback commands.

**Play Selected Rows**: If checked Playback will only execute selected rows in each Macro. Valid for all Playback commands.

## Options

**Loop**: Number of loops to execute the currently selected Macro. If set to 0, the loop continues indefinitely until a break or return is encountered, or the Stop Key is pressed.

**Minimize to Tray**: If checked will hide the main window when *Record* or *Play* button is pressed. You can show the window again from the Tray Menu or the button in the Controls Bar.

**Display Controls**: If checked will display the [Controls Toolbar](p3-Playback.html#controls-toolbar) window when *Record* or *Play* button is pressed. It's a smaller window with Playback and Record buttons allow these commands using the mouse. You can also open it from the Macro Menu and TrayIcon.

**Capture Keys**: Enables Capturing of Key Presses on currently selected Macro List on the Main Window (this option does not affect Recording).

**Always Active**: Keeps all valid Hotkeys always activated (including Record & Playback).

**Shutdown options**: Selects an optional action to execute when Playback finishes.

**Context Sensitive Hotkeys**: Makes hotkeys work depending on the type of window that is active or exists. For more information see [AutoHotkey documentation](http://l.autohotkey.net/docs).

**Windows**: If checked adds the Windows Key as modifier to the Play Hotkey.

**Joystick**: Sets a joystick button to run the Macro. When activated the Play Hotkey box will switch to accept only joystick buttons. Only buttons are detected (axis, pov and others are not). The number before "Joy" is the joystick number and the number after it is the button number, so 2Joy1 is the second joystick's first button.

## Hotkeys

**Play**: Selects the Automatic Hotkey to execute the currently selected Macro

**Manual**: Selects the Manual Hotkey to execute the currently selected Macro step-by-step.

**Stop**: Selects the Hotkey to stop execution

**Pause**: Selects the Hotkey to pause execution

## Edit Commands

**Edit**: When only one row is selected it has tha same behavior as a double-click on a row to enter the command's window for editing. If more then one or no row is selected it will open an edit window where you change the target Control and Window, Repeat Loops or Delay for selected rows (or all rows if none is selected). If the all checkboxes are left unchecked it will remove Control and Window from selected rows. Control and Window will only affect Send, Click and Control commands.

**Cut Rows**: Cut selected Rows.

**Copy Rows**: Copy selected Rows.

**Paste Rows**: Paste copied Rows.

**Delete Rows**: Deletes selected Rows.

**Undo**: Undo one step in History of current Macro. History is individual for each Macro.

**Redo**: Redo one step in History of current Macro. History is individual for each Macro.

**Move Up**: Moves selected rows Up.

**Move Down**: Moves selected rows Down.

**Duplicate Rows**: Duplicates selected rows in the same list.

**Copy to...**: Copies selected rows to a different Macro tab.

**Edit Color Mark**: Opens a Color-Pick dialog to add or change a custom color mark in the first column cell of selected rows. Customized colors can be saved as a custom palette.

**Edit Comment**: Adds / Changes the comment to be displayed to the right of the line in Exported AHK Scripts on selected rows.

**Find / Replace**: This window helps finding and replacing parts of the commands in the *Details*, *Repeat*, *Delay*, *Control* and *Window* columns only. To select similar Command Types use the Select Menu.  
Note: Changing parameters of certain commands may cause misbehavior in Playback. Replace should be used only when and where necessary.

## Modify / Insert

**Insert from Box**: Inserts the command in the Hotkey box at the bottom in the current selected row (or at the end of the list if no row is selected).

**Repeat**: This field is used as a quick-edit to set the Repeat number to selected rows using the Apply buttons on the right.

**Delay (ms)**: Default delay between commands. The number set in this box will be automatically applied to a new added command (except for Mouse and Window commands which have individual default values that can be set in the [Settings Window](p7-Settings.html#defaults)). This field is also used as a quick-edit to set the Delay to selected rows using the Apply buttons on the right.

**Insert Box**: This box can be used to add commands to the list. Click in the box and press the buttons to add on the keyboard then press the Insert button to add them to the list (you can also use the Insert key as a shortcut when the focus is on the ListView).

**Insert Keystroke**: Alternative to the *Insert Box*. Opens a window where you can choose a keyboard key from a list. Double-click or click *Insert* to insert the key into the selected position. You can also choose to hold (Down) or release (Up) the key.

### General Remarks

When you click the Delete or Apply button (for Repeat or Delay) it will affect all selected rows, and if no row is selected it will apply to all rows in the current list.

When adding a new command either by Command Window, Capturing keys or the Insert button if no row is selected they will be added to the end of the list, if one row is selected they will be added on top of that row, and if more then one row is selected a new copy of the command will be added on top of each selected row, except for Loop, and If Statements which will add a Start on top of the first selected row and an End below the last selected row, and for Goto, Label, Break, Continue, Variable Assignment and Functions, which will add only one row on top of the first selected.

## Macros

**Add Macro**: Creates a new Macro tab.

**Close Macro**: Closes the currently selected Macro tab.

**Duplicate Macro**: Copies all commands from currently selected Macro to a new tab.

**Import Macro**: Imports a Project without erasing the current one. All found Macros will be appended to the tab list.

**Save Current Macro**: Saves the currently selected Macro to a PMC file.

**Edit Macros**: Opens the *Edit Macros* window where you can reorder and rename macros. Double click an item to change also hotkeys and loops.

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
* *Color*: Saves the color for the Color Mark set to the row (if any).

**Quick Select**: This feature allows you to select similar rows based on any column from *Details* to *Comment*. Select any row (if more then one row is selected the first one will be used) and click on a column header to select similar rows based on the cell's text from that column.

**Show Colors && Help Marks for Loops and Statements**: Click on the *Index* Column Header or use the *View menu* to turn this option On/Off. When activated rows inside Loops and text of rows inside Statements will be shown in colors, also braces and wildcards will be placed in front of command's index as representation to help visualize which rows are nested. Braces represent Loops and Wildcards represent If Statements, so for example *N* \*{\*{ is equivalent to:  
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

**Show Indentation for Loops and Statements**: Double-Click on the *Action* Column Header or use the *View menu* to turn this option On/Off. When activated Actions inside Loops or Statements will be shown with indentation.  
You can change the default colors in Settings > Misc.

## Command Line Parameters

Macro Creator supports command line parameters. The format is:

> MacroCreator.exe [Filenames] [Parameters]

**Parameters**:  

-p -- *Play*: Activate Playback Hotkeys on program start-up.

> MacroCreator.exe SavedFile.pmc -p

-a or -a*N* -- *AutoPlay*: Runs a Macro on program start-up. *N* is the number of the Macro to run. The example below would execute the second Macro in the project file.

> MacroCreator.exe SavedFile.pmc -a2

-t or -t*N* -- *Timer*: Runs a Macro automatically and repeatedly at the specified time interval. *N* is the interval in miliseconds, if not present defaults to 250ms. This paramter may be combined with the -a*N* to select which Macro to run.

> MacroCreator.exe SavedFile.pmc -t -a4

To run the first iteration immediately append an ! to the interval value, e.g. *-t5000!*.

-c -- *Close*: Exits the program after the first Macro is executed (normally used with the -a option).

> MacroCreator.exe SavedFile.pmc -a -c

-h -- *Hide*: Hide Main Window on program start-up (right-click the tray icon to show it).

> MacroCreator.exe SavedFile.pmc -h

-s or -s*N* -- *Silent*: Combines -a, -h and -c parameters.

> MacroCreator.exe SavedFile.pmc -s3

-b -- *Toolbar*: Shows Controls Toolbar on start-up.

> MacroCreator.exe -b

You can load multiple files with multiple parameters.

> MacroCreator.exe File1.pmc File2.pmc File3.pmc -h -p -a3

## Keyboard Shortcuts

**Ctrl+Enter**: Play

**Ctrl+Shift+Enter**: Play Current Macro

**Ctrl+Shift+T**: Timer

**Ctrl+R**: Record

**Ctrl+B**: Display / Hides Controls Toolbar

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

**Ctrl+[** or **Shift+WheelUp**: Move selection up

**Ctrl+]** or **Shift+WheelDown**: Move selection down

**Ctrl+C**: Copy Selected Rows

**Ctrl+X**: Cut Selected Rows

**Ctrl+V**: Paste Copied Rows

**Ctrl+D**: Duplicate Row(s)

**Ctrl+T**: Add New Macro

**Ctrl+W**: Close Macro

**Ctrl+Shift+D**: Duplicate Macro

**Ctrl+Shift+E**: Edit Macros

**Ctrl+F**: Find / Replace (By Column)

**Ctrl+U**: Find (Multiple Columns)

**Ctrl+L**: Edit Comment

**Ctrl+M**: Edit Color Mark

**Shift+1 to 0**: Paint selected rows with one of the first 10 colors from the custom palette

**Ctrl+PageUp** or **Ctrl+Shift+Up** or **Ctrl+WheelUp**: Move Selected Row(s) Up

**Ctrl+PageDown** or **Ctrl+Shift+Down** or **Ctrl+WheelDown**: Move Selected Row(s) Down

**Ctrl+Z**: Undo one step in History of current Macro

**Ctrl+Y**: Redo one step in History of current Macro

**Ctrl+1 to 0**: Select Macro

**Enter**: Edit selected Row(s)

**Insert**: Insert Key(s) from Insert Box

**Ctrl+Insert**: Insert Keystroke

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

**Alt+F8**: Load Basic Layout

**Alt+F9**: Load Default Layout

**Ctrl+Shift+F**: Find a Command

**F1**: Help

**F2**: Mouse

**F3**: Text

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

**Ctrl+F11**: Run Scriptlet

**F12**: Windows Messages
