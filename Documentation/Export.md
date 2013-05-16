# Export

## Table of Contents

* [Introduction](#Introduction)
* [Macros](#Macros)
* [Context Sensitive Hotkeys](#Context-Sensitive-Hotkeys)
* [Options](#Options)
* [Destination File](#Destination-File)

## Introduction

Exports selected Macros to a working AutoHotkey Script file (*.ahk).

## Macros

Select Macros to be exported. Empty Macros and unchecked rows will be ignored.

### Hotkeys

Double-Click on an item in the list to display the options for each Macro.

**Hotkey**: Selects the Hotkey (AutoHotkey format) to execute the Macro. Here you can use Hotkeys that are not allowed for playback like RButton. You also edit the Hotkey directly in the list by either selecting the row and pressing F2 or you can click a row once to select it, wait at least half a second, then click the same row again to edit it.

**Loops**: Number of times to execute this Macro.

**Use Hotstring**: Adds :: before the Hotkey which makes it a [Hotstring](http://l.autohotkey.net/docs/Hotstrings.htm).

**Block Mouse**: Adds *BlockInput, MouseMove*. The mouse cursor will not move in response to the user's physical movement of the mouse during execution.

**Stop**: Adds a Hotkey with the *ExitApp* command.

**Pause**: Makes the Stop Hotkey with the *Pause* command instead.

## Context Sensitive Hotkeys

Makes hotkeys and hotstrings work depending on the type of window that is active or exists. For more information see [AutoHotkey documentation](http://l.autohotkey.net/docs).

## Options

Changes various options for the exported script's Auto-Execute Section. For more information see [AutoHotkey documentation](http://l.autohotkey.net/docs).

## Destination File

**Export to**: Selects the destination file to export selected Macros.

**Indentation**: Use Tab-Indentation for Loops and If Statements.

**Include PMC Code**: Includes a copy of the PMC code for each selected Macro at the end of the exported script to allow them to be loaded in **Macro Creator** by opening the ahk file from it. This will not affect the exported script execution.

**Do not concatenate Send commands**: Exports sequences of Send commands in one line each and uses Loop for repeats.

**Create EXE File**: Runs Ahk2Exe Compiler after exporting the script to create an Executable File. The EXE file will be saved to the same folder as the script.  
Once a script is compiled, it becomes a standalone executable; that is, it can be used even on machines where AutoHotkey is not installed (and such EXEs can be distributed or sold with no restrictions).  
*Note*: This feature requires [AutoHotkey](http://www.autohotkey.com/) installed. The Ahk2Exe file must be present in the Compiler folder inside AutoHotkey installation folder, if the file is not found the EXE will not be created (no error will be shown).

### Related

[Hotkeys](http://l.autohotkey.net/docs/Hotkeys.htm), [Hotstrings](http://l.autohotkey.net/docs/Hotstrings.htm), [List of Keys](http://l.autohotkey.net/docs/KeyList.htm), [ComObjCreate](http://l.autohotkey.net/docs/commands/ComObjCreate.htm), [ComObjActive](http://l.autohotkey.net/docs/commands/ComObjActive.htm), [Auto-execute Section](http://l.autohotkey.net/docs/Scripts.htm#auto), [#IfWinActive / #IfWinExist](http://l.autohotkey.net/docs/commands/_IfWinActive.htm)
