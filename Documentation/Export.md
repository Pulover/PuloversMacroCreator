# Export

## Table of Contents

* [Introduction](#introduction)
* [Macros](#macros)
* [Context Sensitive Hotkeys](#context-sensitive-hotkeys)
* [Destination File](#destination-file)
* [Options](#options)

## Introduction

Exports selected Macros to a working AutoHotkey Script file (*.ahk), optionally converting the script to an executable (EXE) file (requires the latest version of [AutoHotkey](https://www.autohotkey.com/) installed).

## Macros

Select Macros to be exported. Empty Macros and unchecked rows will be ignored. You can click and drag items and double-click to open the edit window.

### Macro

Name of the label used for the macro (leave blank to remove it from the exported script).

### Hotkey

Selects the Hotkey (AutoHotkey format) to execute the Macro. Here you can use Hotkeys that are not allowed for playback like RButton. You also edit the Hotkey directly in the list by either selecting the row and pressing F2 or you can click a row once to select it, wait at least half a second, then click the same row again to edit it.

### Loop

Number of times to execute this Macro.

### Block Mouse

AddslockInput, MouseMove`. The mouse cursor will not move in response to the user's physical movement of the mouse during execution.

### Stop

Adds a Hotkey with the ÈxitApp`command.

### Pause

Adds a Hotkey with the `Pause`command.

## Destination File

### Export to

Selects the destination file to export selected Macros.

### Indentation

Use Tab-Indentation for Loops and If Statements.

### Comment out unchecked rows

Keeps unchecked rows in the macro as commented out script, instead of not exporting them.

### Do not concatenate Send commands

Exports sequences of Send commands in one line each and uses Loop for repeats.

### Convert line breaks

Converts line break symbols (\`n) in command parameters to real line breaks.

### Include PMC Code

Includes a copy of the PMC code for each selected Macro at the end of the exported script to allow them to be loaded in **Macro Creator** by opening the ahk file from it. This will not affect the exported script execution.

### Create EXE File

Runs Ahk2Exe Compiler after exporting the script to create an Executable File. The EXE file will be saved to the same folder as the script.  
Once a script is compiled, it becomes a standalone executable; that is, it can be used even on machines where AutoHotkey is not installed (and such EXEs can be distributed or sold with no restrictions).  
*Note*: This feature requires the latest version of [AutoHotkey](https://www.autohotkey.com/) installed. The Ahk2Exe file must be present in the Compiler folder inside AutoHotkey installation folder, if the file is not found the EXE will not be created (no error will be shown).

### Custom icon

Optional *.ico file to be used as the exported EXE file custom icon.

## Context Sensitive Hotkeys

Makes hotkeys and hotstrings work depending on the type of window that is active or exists, or if an expression evaluates to true. For more information see [Playback](Playback.html#context-sensitive-hotkeys).

### Related

[#IfWinActive](https://www.autohotkey.com/docs/commands/_IfWinActive.htm), [#If](https://www.autohotkey.com/docs/commands/_If.htm)

## Options

Changes various options for the exported script's Auto-Execute Section. For more information see [AutoHotkey documentation](https://www.autohotkey.com/docs).

### #Include

Includes in the script files with external functions using the #Include directive, when they are present in one of the exported macros.

### Global Variables

If you have defined [User Global Variables](Settings.html#user-global-variables) you can select which of them will be included in the exported file. They will be added to the Auto-execute section.

### Speed

Increases or decreases the delay of Sleep (Pause) commands in exported scripts.

### COM Objects

Default behavior for the *Automatically create COM object* option in **Expression** window. [ComObjCreate](https://www.autohotkey.com/docs/commands/ComObjCreate.htm) will create a new COM object based with the given CLSID, while [ComObjActive](https://www.autohotkey.com/docs/commands/ComObjActive.htm) will try to connect to an existing instance of the application.

### Related

[Hotkeys](https://www.autohotkey.com/docs/Hotkeys.htm), [Hotstrings](https://www.autohotkey.com/docs/Hotstrings.htm), [List of Keys](https://www.autohotkey.com/docs/KeyList.htm), [ComObjCreate](https://www.autohotkey.com/docs/commands/ComObjCreate.htm), [ComObjActive](https://www.autohotkey.com/docs/commands/ComObjActive.htm), [Auto-execute Section](https://www.autohotkey.com/docs/Scripts.htm#auto), [#IfWinActive / #IfWinExist](https://www.autohotkey.com/docs/commands/_IfWinActive.htm), [#If](https://www.autohotkey.com/docs/commands/_If.htm)
