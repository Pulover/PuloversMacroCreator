# Record

## Table of Contents

* [Introduction](#introduction)
* [Hotkeys](#hotkeys)
* [Controls Toolbar](#controls-toolbar)
* [Recording Options](#recording-options)

## Introduction

To activate the Recording Hotkeys you have to press the Record Button (unless the "Always Active" option is on, which will activate all hotkeys when the program window is not active). **Recording will not start immediately after pressing the Record Button, it will start when you press one of the Hotkeys**. This behavior is intended to allow the user to select the desired starting window/control/mouse position before start recording.  
You can also activate Recording Hotkeys by right-clicking on the TrayIcon and selecting *Record*.

## Hotkeys

Hotkeys are sometimes referred to as shortcut keys and are used to run/play the macros. Recording Hotkeys are set in the Options > Settings > Recording.

Use `Backspace` to clear the hotkeys. Press it twice to set `Backspace` as the hotkey.

### Start/Stop Record

Starts recording a Macro using the selected settings (the tray icon will change to) recording state). While recording press this Hotkey again to stop (the tray icon will change to normal state). You can resume and stop recording anytime while the Hotkey is active. The default Hotkey is **F9**, it can be changed in the [Settings Window](#recording-options).  
You can also stop Recording by double-clicking the TrayIcon or right-clicking on it and selecting *Stop*. You can pause/unpause Recording by Middle-Clicking the TrayIcon.

### Record New Macro

Creates a new tab on the current project and start a new recording there. If a Macro was being recorded it will be interrupted and started in the new one (without erasing the previously recorded actions). If the *Clear List* option is on it will clear the current list and start over recording in the same Macro. The default Hotkey is **F10**, it can be changed in the [Settings Window](#recording-options).

### Clear List

Sets *Record New Macro* key to clear the current list instead of creating a new Macro tab.

## Controls Toolbar

This small window allows you to control Playback and Recording using an interface in addition to the Hotkeys. It will be displayed when the *Playback* or *Record* button is pressed and the *Show Controls* option is checked or you can open it manually from the Macro Menu, Tray Menu and pressing Ctrl+B on the main window.

## Recording Options

To change options click the Options button on the main window or select Options Menu > Settings. Some of the options can also be accessible from the *Record Options* button on the [Controls Toolbar](#controls-toolbar).

### Keystrokes

Records Keyboard presses.  
*Note*: You can add or remove the keys (except A-Z) that will be captured in the Misc. tab > Virtual Keys.

### Capture key state (Down / Up)

If enabled will capture Key Down and Key Up for every key, instead of only the keystroke, so if you hold the key it will record only one stroke. Control, Shift, Alt and Windows key are recorded as Down/Up regardless of this option.

### Record ControlSend

Attempts to record ControlSend instead of normal strokes. This should be tested before making large recordings for it cannot always detect when focus has changed, for example when you use Alt key to access a window's menu.  
**Note**: Recording Control is useful to reproduce actions in the background without moving mouse or losing focus, but it might not work on some windows.

### Mouse Clicks

Records Mouse Clicks for Left, Right, Middle, X1 and X2 buttons.

### Mouse Wheel

Records Mouse Wheel Up/Down.

### Mouse Moves

Records Mouse movements. The Minimum delay sets the amount of idle time (ms) of the mouse to wait before recording the last move (this option should not me changed in most cases).  
**Note**: Recorded Mouse Actions are affected by [Mouse Coordinates Settings](Settings.html#defaults).

### Record ControlClick

Attempts to record ControlClick instead of normal clicks. If a control is found on the click position of the active window it will record the Control and the position relative to the control. If no control is found it will record ControlClick relative to the window.

### Relative Record Key

When the selected key is held (or on if the Toggle option is selected) mouse movements and clicks will be recorded relative to initial position. This is useful to reproduce actions based on mouse current position on a window or screen like moving a file or drawing.

### Timed Intervals

Records idle time between user actions. This is useful to recreate precise mouse movements and keystrokes. The Minimum delay sets the minimum time (ms) to wait before recording the sleep (this option should not me changed in most cases).  
**Note**: If this option is unchecked the default delay between recorded actions will be set by Delay (ms) box in the main window for Keystrokes and by the Default Settings in Options for Mouse and Windows.

### Window Classes

Records the Class of the active window.

### Window Titles

Records the Title of the active window.

