# Main Window

**Tip**: Right-click on an empty area of a Command Window to display links to AutoHotkey online documentation and related contents.

## Table of Contents

* [File Menu](#file-menu)
* [Macro Menu](#macro-menu)
* [Commands Menu](#commands-menu)
* [Function Menu](#function-menu)
* [Edit Menu](#edit-menu)
* [Select Menu](#select-menu)
* [View Menu](#view-menu)
* [Options Menu](#options-menu)
* [Macro List](#macro-list)
* [Command Search Bar](#command-search-bar)
* [Insert / Modify](#insert-/-modify)
* [Command Line Parameters](#command-line-parameters)

## File Menu

### New

Starts a new Project.

### Open

Opens a Project (it can be a PMC file or an AHK file containing a PMC Code).

### Save / Save As

Saves current Project in a PMC file including all non-empty Macros.

### Recent Files

List of recent PMC files from the windows Recent directory.

### Export

Opens the [Export Window](Export.html) to save Macros in AHK Script Format.

### Preview Script

Opens the [Preview Window](Preview.html) which shows the current Macro in AHK Script.

### Edit Script

Exports the current preview to a script in the Temp folder and opens it in the default editor.  
**Note**: This feature is only meant as a quick export function. PMC is not designed to be an AHK script editor.

### Schedule Macros

In this window you can schedule a macro on Windows Task Scheduler. You can select the time to start and how frequent it will run. When select to target the PMC file, it will launch Macro Creator with the selected file and run it automatically in [Silent Mode](#command-line-parameters) (you can select the target macro to run from your project). When you select to target the AHK file, it will write an ahk script with the current project in the same directory of the pmc file, this script will have no hotkeys which means it will run the first macro automatically (you can run other macros in the same project using [Goto/Gosub](Commands/Goto_and_GoSub.html)).

### List Variables

Displays user-defined variables and their current contents.

### Exit

Closes the application (same effect as the window's Close Button).

## Macro Menu

### Record

Activates [Recording](Record.html) Hotkeys. You can change the hotkeys in the [Recording options](Record.html#recording-options)

### Recording options

See [Record](Record.html).

### Activate Macros

Activates [Playback](Playback.html) Hotkeys. You can change the hotkeys for Play, Manual for each macro, as well as Stop and Pause, in the Hotkey Toolbars.

### Playback options

See [Playback](Playback.html).

### Play Current Macro

Runs currently selected Macro immediately without Hotkeys.  

**Note**: An *AutoPlay* feature is available via command line with the -a parameter: add -a or -a*N* (where *N* is the number of the Macro to run) as a parameter to run a Macro on program start-up. The example below would execute the second Macro in the project file.

> MacroCreator.exe SavedFile.pmc -a2

### Timer

In this window you can run the currently selected Macro repeatedly in a timed interval.

**Play once**: Runs currently selected Macro one time after the specified time.

**Play every X (mili)seconds**: Runs it automatically and repeatedly at the specified time interval.  

**Run immediately**: Runs the first time immediately instead of waiting the specified time to start.

The Abort Hotkey can be used to turn the Timer off.  
To have other Macros active during Timer check the *Always Active* option or right-click the TrayMenu icon and select **Play**.  

### Deactivate Macros

Disables all hotkeys.

### Play From Selected Row

If checked Playback will run each Macro from the first selected row in its list. Valid for all Playback commands.

### Play Until Selected Row

If checked Playback will stop each Macro when the first selected row in its list is reached. Valid for all Playback commands.

### Play Selected Rows

If checked Playback will only execute selected rows in each Macro. Valid for all Playback commands.

### Context Sensitve Hotkeys

Opens the Context Sensitive Hotkeys window. See [Playback](Playback.html#context-sensitive-hotkeys).

### Add Macro

Creates a new Macro tab.

### Close Macro

Closes the currently selected Macro tab.

### Duplicate Macro

Copies all commands from currently selected Macro to a new tab.

### Edit Macros

Opens the *Edit Macros* window where you can reorder and rename macros. Double click an item to change hotkeys and loops as well. Here you can set hotkeys not supported by the control in the main window, including mouse buttons, for the Play hotkey.

### Import Macro

Imports a Project without erasing the current one. All found Macros will be appended to the tab list.

### Save Current Macro

Saves the currently selected Macro to a PMC file.

## Commands Menu

Opens the [Command Windows](Commands.html) to insert commands, functions and statements.

## Function Menu

Used for [User-Defined Functions](Functions.html#user-defined-functions).

### Create Function

Creates a new Function tab.

### Add Parameter

Adds a new Function Parameter to the currently selected Function tab. Function parameters can only be added **above** the *[FunctionStart]* row.

### Add Return

Adds a Function Return to the currently selected Function tab. Function returns can only be added **below** the *[FunctionStart]* row.

### Convert Macro To Function

Converts the currently selected Macro tab into a Function tab. The selected Macro must not contain any Label, Goto or Gosub commands.

## Edit Menu

This menu can also be open by right-clicking on the [Macro List](#macro-list).

### Edit

When only one row is selected it has tha same behavior as a double-click on a row to enter the command's window for editing. If more then one or no row is selected it opens the **Multi-Edit** window where you change the target Control and Window, Repeat Loops or Delay for selected rows, and if no row is selected, it applies to all rows. If all checkboxes in the Multi-Edit window are left unchecked it will remove Control and Window from selected (or all) rows. Control and Window will only affect commands that use this column.

### Cut Rows

Cut selected Rows.

### Copy Rows

Copy selected Rows.

### Paste Rows

Paste copied Rows on top of selected rows. Notice that if more than one row is selected, copied content will be pasted on top of each selected row.

### Delete Rows

Deletes selected Rows.

### Duplicate

Duplicates selected rows in the same list.

### Select All

Selects all rows in the current list.

### Copy to...

Copies selected rows to a different Macro tab.

### Groups

Enables, disables, add and removes groups in Macro lists. To add a new group, select a row, click *Add group* (you can use the small arrow beside the Groups button in the Edit toolbar), enter a name for the group and press OK. The new group will be added above the first selected row. To rename a group, select the row immediately below it and repeat the same steps.

### Move Up

Moves selected rows up.

### Move Down

Moves selected rows down.

### Undo

*Undo* one step in History of current Macro.

### Redo

*Redo* one step in History of current Macro.

### Find / Replace

This window helps finding and replacing parts of the commands in the Macro List columns. Replacing can be performed in *Details*, *Repeat*, *Delay*, *Control*, *Window*, *Comment* and *Color* columns only.  
To select similar Command Types use the Select Menu.  
You can also select rows with the same content in a certain column: select a row and click on the **Column Header** of the column you want to search and all rows with the same text in it will be selected.  
**Note**: Changing parameters of certain commands may cause misbehavior in Playback. Replace should be used only when and where necessary.

### Go to...

Go directly to any macro in the project optionally selecting a line in the list.

### Edit Comment

Adds / Changes the comment to be displayed to the right of the line in Exported AHK Scripts on selected rows. Click *Insert* to add a Comment Block.

### Edit Color Mark

Opens a Color-Pick dialog to add or change a custom color mark in the first column cell of selected rows. Customized colors can be saved as a custom palette. To remove a color mark, select *White* (#FFFFFF).

### Insert from Box

See [Insert / Modify](#insert-/-modify) below.

### Insert Keystroke

See [Insert / Modify](#insert-/-modify) below.

## Select Menu

### Select All

Selects all rows in the current list.

### Select None

Deselects all rows in the current list.

### Invert Selection

Switches selected rows with not selected.

### Check Selected

Checks (activates) selected rows.

### Uncheck Selected

Unchecks (deactivates) selected rows.

### Invert Checks

Switches checked rows with unchecked in the selection.

### Move Selection Up

Moves the selection of rows up (without moving the rows).

### Move Selection Down

Moves the selection of rows down (without moving the rows).

### Selected Type

Selects every row with the same *Type* of the first selected row in the current list.

### Command type

Selects every row with a specific *Type* in the current list.

## View Menu

### Always On Top

Sets the main window to stay always on top.

### Highlight Rows

Enables or disables highlighting for loops and statements. See [Macro List](#highlight-loops-and-statements) below for more information.

### Indentation

Double-Click on the *Action* Column Header or use the *View menu* to turn this option On/Off. When activated Actions inside Loops or Statements will be shown with indentation.  
You can change the default colors in Settings > Misc.

### Controls Toolbar

Shows or hides the [Controls Toolbar](Playback.html#controls-toolbar).

### Preview Script

[Preview panel](Preview.html) options.

### Toolbars

Shows or hides and customizes Toolbars.

### Hotkeys

Shows or hides the Hotkey controls.

### Search Bar

Shows or hides the [Command Search Bar](#command-search-bar).

### Font Size

Selects the size of the font for the Macros Listviews only.

### Reset Columns Size

Resets default column sizes (default sizes are different for maximized and window mode).

### Icons Size

Selects the size of the icons on the toolbar. Requires restarting the application.

### Reset Layout

Selects/resets one of the standard toolbar layouts.

## Options Menu

### Settings

Opens the [Settings Window](Settings.html) where it's possible to configure various options.

### Minimize to Tray

If checked will hide the main window when *Record* or *Play* button is pressed. You can show the window again from the Tray Menu or the button in the Controls Bar.

### Display controls toolbar

If checked will display the [Controls Toolbar](Playback.html#controls-toolbar) window when *Record* or *Play* button is pressed. It's a smaller window with Playback and Record buttons allow these commands using the mouse. You can also open it from the Macro Menu and TrayIcon.

### Capture key presses in this window

Enables or disables capturing of key presses on currently selected Macro List on the Main Window (this option does not affect Recording).

### Hotkeys Always Active

Keeps all valid Hotkeys always activated (including Record & Playback).

### Shutdown options

Selects an optional action to execute when Playback finishes.

### Add the Windows key to *Play* hotkey

If checked adds the Windows Key as modifier to the Play Hotkey. This means that if the Play hotkey is `G` the actual hotkey will be `Win + G`.

### Joystick

Sets a joystick button to run the Macro. When activated the Play Hotkey box will switch to accept only joystick buttons. Only buttons are detected (axis, pov and others are not). The number before "Joy" is the joystick number and the number after it is the button number, so 2Joy1 is the second joystick's first button.

### Set as Default Hotkeys

Sets the currently selected *Play* hotkeys as default for new projects. You can view the hotkeys in Settings > Playback.

### Set as Default File

Sets the currently open project as the file to be opened when the program starts. You can select the file manually in Settings > Defaults.

### Remove Default File

Removes the default file currently set (if any).

### Default Hotkeys

Resets all *Play* hotkeys in the current project to default, which are F3|F4|F5|F6|F7.

### Default Settings

Resets all settings to default (cannot be undone).

## Macro List

All commands of the Macros are displayed in the Macro List (ListView).  
They can be added using the Command Windows, by recording your actions or by duplicating items.  
To edit an item double-click on it or select the ones you want and press the Edit button at the bottom of the window.  
Use the buttons on the edit toolbar (or their shortcuts) to move, delete, duplicate the selected items.  
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
* *Code line*: Line of code in the [Preview Window](Preview.html).

**Note**: The content of each column may vary on certain type of commands.

### Quick Select

This feature allows you to select similar rows based on any column from *Action* to *Color*. Select any row (if more then one row is selected the first one will be used) and click on a **column header** to select similar rows based on the cell's text from that column.

### Highlight Loops and Statements

Click on the **Index** Column Header or use the *View menu* to turn this option On/Off.  
When activated, rows inside Loops and text of rows inside Statements will be shown in colors. Also `>` and `\*` will be placed in front of command's index as representation to help visualize which rows are nested.  
`>` represents Loops and `\*` represents If Statements, so for example `*N* \*>\*>` is equivalent to:  
> [If]
> {
>     [Loop]
>     {
> 		[If]
>         {
>             [Loop]
>             {
>                 [...]
>             }
>         }
>     }
> }

You can change the default colors in Settings > General.

### Macro Tabs

**Pulover's Macro Creator** supports multiple Macros / Hotkeys. To create a new Macro, click the **+** button (Add Macro / Ctrl+T).

When you add or select a Macro in the tab list, the current Hotkeys and Repeat counter for it are displayed on the top-right part of the window.

Macros which have no Hotkey or no line of command will not be activated for Playback.

You can edit the names and order of the tabs in Macro Menu > Edit Macros (Ctrl+Shift+M). You can also drag-and-drop the tab buttons.

### Main Loop

The *Loop* counter at the top-right of the main window sets the number of loops to execute the currently selected Macro. If set to 0, the loop continues indefinitely until a break or return is encountered, or the Stop Key is pressed.

## Command Search Bar

Use the search bar to look for a command, function or description. Press `Enter` to go to result.  
If you select one of the entries in the list the corresponding window will be shown. If more than one result or no specific command/function is found the [Find a Command](Commands.html#find-a-command) window will be show with the results.

## Insert / Modify

The edit controls at the bottom of the main window can be used to make quick changes to the rows in the Macro List.

### Repeat

This field is used as a quick-edit to set the Repeat number to selected rows using the Apply buttons on the right.

### Delay (ms)

Default delay between commands. The number set in this box will be automatically applied to a new added command (except for Mouse and Window commands which have individual default values that can be set in the [Settings Window](Settings.html#defaults) and commands that ignore this parameter).  
This field is also used as a quick-edit to set the Delay to selected rows using the Apply buttons on the right.

### Insert Box

This box can be used to add key (`Send`) commands to the list. Click in the box and press the keys or combinations then press the *Insert* button to add them to the list. You can also use the Insert key as a shortcut when the focus is on the ListView or *Insert from Box* in the *Edit* menu. Use `Backspace` to clear the hotkeys. Press it twice to set `Backspace` as the hotkey.

### Insert Keystroke

Alternative to the *Insert Box*. Opens a window where you can choose a keyboard key from a list. Double-click or click *Insert* to insert the key into the selected position. You can also choose to hold (Down) or release (Up) the key.

### General Remarks

When you click the Delete or Apply button (for Repeat or Delay) it will affect all selected rows, and if no row is selected it will apply to all rows in the current list.

When adding a new command either by Command Window, Capturing keys or the Insert button if no row is selected they will be added to the end of the list, if one row is selected they will be added on top of that row, and if more then one row is selected a new copy of the command will be added on top of each selected row, except for Loop, and If Statements which will add a Start on top of the first selected row and an End below the last selected row, and for Goto, Label, Break, Continue, Variable Assignment and Functions, which will add only one row on top of the first selected.

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

-r -- *Record*: Starts PMC in Recording Mode with current settings.

> MacroCreator.exe -b

-b -- *Toolbar*: Shows Controls Toolbar on start-up.

> MacroCreator.exe -b

You can load multiple files with multiple parameters.

> MacroCreator.exe File1.pmc File2.pmc File3.pmc -h -p -a3

