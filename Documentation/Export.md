# Export

## Table of Contents

* [Introduction](#introduction)
* [Macros](#macros)
* [Context Sensitive Hotkeys](#context-sensitive-hotkeys)
* [Options](#options)
* [Destination File](#destination-file)

## Introduction

Exports selected Macros to a working AutoHotkey Script file (*.ahk).

## Macros

Select Macros to be exported. Empty Macros and unchecked rows will be ignored. You can click and drag items and double-click to open the edit window.

**Macro**: Name of the label used for the macro (leave blank to remove it from the exported script).

**Hotkey**: Selects the Hotkey (AutoHotkey format) to execute the Macro. Here you can use Hotkeys that are not allowed for playback like RButton. You also edit the Hotkey directly in the list by either selecting the row and pressing F2 or you can click a row once to select it, wait at least half a second, then click the same row again to edit it.

**Loop**: Number of times to execute this Macro.

**Block Mouse**: Adds *BlockInput, MouseMove*. The mouse cursor will not move in response to the user's physical movement of the mouse during execution.

**Stop**: Adds a Hotkey with the *ExitApp* command.

**Pause**: Adds a Hotkey with the *Pause* command.

## Destination File

**Export to**: Selects the destination file to export selected Macros.

**Indentation**: Use Tab-Indentation for Loops and If Statements.

**Include PMC Code**: Includes a copy of the PMC code for each selected Macro at the end of the exported script to allow them to be loaded in **Macro Creator** by opening the ahk file from it. This will not affect the exported script execution.

**Do not concatenate Send commands**: Exports sequences of Send commands in one line each and uses Loop for repeats.

**Create EXE File**: Runs Ahk2Exe Compiler after exporting the script to create an Executable File. The EXE file will be saved to the same folder as the script.  
Once a script is compiled, it becomes a standalone executable; that is, it can be used even on machines where AutoHotkey is not installed (and such EXEs can be distributed or sold with no restrictions).  
*Note*: This feature requires [AutoHotkey](http://www.autohotkey.com/) installed. The Ahk2Exe file must be present in the Compiler folder inside AutoHotkey installation folder, if the file is not found the EXE will not be created (no error will be shown).

## Context Sensitive Hotkeys

Makes hotkeys and hotstrings work depending on the type of window that is active or exists. For more information see [AutoHotkey documentation](http://auto-hotkey.com/docs).

## Options

Changes various options for the exported script's Auto-Execute Section. For more information see [AutoHotkey documentation](http://auto-hotkey.com/docs).

## Global Variables

If you have defined [User Global Variables](p7-Settings.html#user-global-variables) you can select which of them will be included in the exported file. They will be added to the Auto-execute section.

### Related

[Hotkeys](http://auto-hotkey.com/docs/Hotkeys.htm), [Hotstrings](http://auto-hotkey.com/docs/Hotstrings.htm), [List of Keys](http://auto-hotkey.com/docs/KeyList.htm), [ComObjCreate](http://auto-hotkey.com/docs/commands/ComObjCreate.htm), [ComObjActive](http://auto-hotkey.com/docs/commands/ComObjActive.htm), [Auto-execute Section](http://auto-hotkey.com/docs/Scripts.htm#auto), [#ifwinactive / #ifwinexist](http://auto-hotkey.com/docs/commands/_ifwinactive.htm)
