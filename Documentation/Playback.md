# Playback

## Table of Contents

* [Introduction](#introduction)
* [Hotkeys](#hotkeys)
* [Controls Toolbar](#controls-toolbar)
* [Context Sensitive Hotkeys](#context-sensitive-hotkeys)
* [Playback Options](#playback-options)

## Introduction

To activate the Playback Hotkeys you have to press the Play Button (unless the *Always Active* option is on, which will activate all hotkeys when the program window is not active). **Playback will not start immediately after pressing the Play Button, it will start when you press one of the Active Hotkeys**. This behavior is intended to allow the user to select the desired starting window/control/mouse position before start playing.  
You can also activate Playback Hotkeys by double-clicking the TrayIcon or right-clicking on it and selecting *Play*.  
Unchecked rows will be ignored during playback.
The *Play Current Macro* button will run the active Macro immediately without activating Hotkeys.

## Hotkeys

The Playback Hotkeys are selected in the boxes at the top-right of the main window.

**Play** (Auto Hotkey): Selects the Hotkey to reproduce the currently selected Macro the amount of times set in the Repeat box at the bottom. The Win option add Win key as a modifier. During playback the tray icon will change to playing state. The executing Macro must be finished or stopped before you can execute a new one.

**Manual** (Manual Hotkey): Selects the Hotkey to reproduce the currently selected Macro step-by-step. This is usually used to debug the Macro. If Show Info option is on a tooltip show the last and next steps will be shown next to the mouse pointer.

**Stop**: Selects the Hotkey to stop execution and return it to start. You can also stop Playback by double-clicking the TrayIcon or right-clicking on it and selecting *Stop*.  

**Pause**: Selects the Hotkey to pause execution, press it again to resume. You can also pause/unpause Playback by Middle-Clicking the TrayIcon.  

*Note*: Mouse Actions are affected by [Mouse Coordinates Settings](p7-Settings.html#defaults).  

## Controls Toolbar

This small window allows you to control Playback and Recording using an interface in addition to the Hotkeys. It will be displayed when the *Playback* or *Record* button is pressed and the *Show Controls* option is checked or you can open it manually from the Macro Menu, Tray Menu and pressing Ctrl+B on the main window.

### Multiple Macros

Macro Creator supports multiple Macros / Hotkeys. Each Macro will have its own Auto and Manual Hotkey that are shown when you add/select a Macro tab.

When you press the Play Button (or when the main window is not active if "Always Active" option is on) all valid Hotkeys will be activated for all non-empty Macros. A traytip will be displayed (if *Show Info* is on) showing how many Play Hotkeys were activated. If any duplicate is found NO Hotkey will be activated.

### Debugging Macros

In addition to the Manual Hotkey you can select one of these options from the Macro menu:

**Play From Selected Row**: If checked Playback will run each Macro from the first selected row in its list. Valid for all Playback commands.

**Play Until Selected Row**: If checked Playback will stop each Macro when the first selected row in its list is reached. Valid for all Playback commands.

**Play Selected Rows**: If checked Playback will only execute selected rows in each Macro. Valid for all Playback commands.

You can also view the list of variables and contents from the File menu and Tray Icon menu.

## Context Sensitive Hotkeys

Makes all Hotkeys context-sensitive. Such hotkeys perform a different action (or none at all) depending on the type of window that is active or exists.

This option affects ALL Hotkeys and will be saved to the programs settings when it's closed. There's a text tip at the bottom-right of the main window to show if it's active. To deactivate this option select *None* in the list.

For more information see [AutoHotkey Help](http://ahkscript.org/docs/commands/_IfWinActive.htm).

## Playback Options

To change options click the Options button on the main window or select Options Menu > Settings. Some of the options can also be accessible from the *Playback Options* button on the [Controls Toolbar](#controls-toolbar).

**Speed Up**: Selects the hotkey to toggle playback speed Up/Normal. When this option is on delay values will be cut by value set. Does not work when *Random Sleeps* is activated.

**Slow Down**: Selects the hotkey to toggle playback speed Down/Normal. When this option is on delay values will be multiplied by value set. Does not work when *Random Sleeps* is activated.

**Display balloon tips**: Enables displaying of tooltips and traytips during Recording/Playback.

**Return Mouse after playback**: If checked will return the mouse to the initial position after each Macro Playback that uses mouse movement. This will not work for Manual Playback.

**Display Controls Bar on startu-up**: If checked will display the Controls bar upon every start.

**Auto Hide Controls Toolbar**: If checked the Controls Toolbar will be automatically shown when a Playback hotkey is pressed and hidden when execution finishes.

**Random Sleeps**: If checked all delays during playback will be a random value for more or less of the defined percentage, e.g.: if percentage is set to 50, a command with a delay of 300ms will be set to any value between 150ms and 450ms. Percentage can be set in the counter.