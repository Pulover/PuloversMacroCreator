# Settings

## Table of Contents

* [Introduction](#introduction)
* [General](#general)
* [Recording](#recording)
* [Playback](#playback)
* [Defaults](#defaults)
* [Screenshots](#screenshots)
* [Email accounts](#email-accounts)
* [Language](#language)
* [Language Editor](#language-editor)
* [User Global Variables](#user-global-variables)

## Introduction

All settings are saved to *MacroCreator.ini*, User Global Variables are saved to *UserGlobalVars.ini* and Email accounts are saved to *UserEmailAccounts.ini*. Those files are located inside *AppData\MacroCreator* by default. To make **Macro Creator** portable you can copy those files to the same directory of *MacroCreator.exe* and it will use its own folder instead of AppData.

## General

### Create backups automatically

If enabled the program will automatically create a backup file of the active project everytime the a change is made to one of the Macro Lists.

### Display Controls Bar on start-up

If checked will display the Controls bar upon every start.

### Allow Multiple Instances

Determines whether Macro Creator is allowed to run concurrent instances.

### Remove Theme from Toolbars

Removes the current theme colors from the main window toolbars (you must restart the application to apply the changes).

### Use Expression by default for Variables Assignment

Determines whether the *Expression* option will be enabled by default for new Variable Assignments.

### Display confirmation when closing a macro

Enables / Disables prompt before closing a macro.

### Action of main window's close button

Determines whether to close the application or minimize it to tray when the close button on the title bar is clicked or Alt+F4 is pressed.

### Hightlight Loops and Statements

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

You can change the default colors clicking on the color shown here and picking a new one from the selector.  

### Show Indentation for Loops and Statements

When activated Actions inside Loops or Statements will be shown with indentation.  
You can also double-click on the *Action* Column Header to turn this option On/Off.  

### Virtual Keys

System keys and Modifiers that will be recognized during Recording and when Capture keys is enabled. If your keyboard layout has a key that is not being captured, press it once and click the *Key History* button to see its VK and SC codes. You can add them to the list as `{VKnn}`, `{SCnn}` or `{VKnnSCnn}`.

## Recording

See [Record Page](Record.html#recording-options).

## Playback

See [Playback Page](Playback.html#playback-options).

## Defaults

### Mouse Coordinates

Sets [coordinate mode](https://www.autohotkey.com/docs/commands/CoordMode.htm) for Mouse commands and records to be relative to either the active window, screen or client area. This option is global and will affect both Recording and Playback so it should be set before adding any commands for the project.  
*Note*: This setting will be saved to the PMC file.

### Default Mouse Delay

Sets the default delay added for each new Mouse Command. This affects new commands added from the Mouse Command window and will only affect the recorder if 'Timed Intervals' is disabled.

### Default Window Delay

Sets the default delay added for each new Window (Set) Command. This affects new commands added from the Window Command window and the recorder.

### Max History per Macro

Sets the maximum History steps to keep for each macro. Changing this might have little impact in performance. It's recommended to restart Macro Creator after changing this setting.

### Clear History

Clears and resets History for all Macros.

### Default Script Editor

Sets a default editor to open Script with the *Edit Script* button in the **Preview** window.

### Default Macro File

If a valid file with a PMC code is set it will be loaded on program start up.

### Standard Library File

Sets an AutoHotkey script file to be loaded automatically in the *Functions* window to be used as [External File Function](Functions.html#run-function-from-external-ahk-file).

## Screenshots

### Draw Button

Selects the Draw Button to be used for Screenshots tool and Get Area in Image Search.

### Line Width (Px)

Defines the pixel width of the rectangle when using the Image/Pixel Search are and Screenshots tool.

### Color

Selects the color of the rectangle used to define Image/Pixel Search area and Screenshots.

### Capture on release

Captures Screenshots when the Draw button is released.

### Press Enter to capture

Waits for the user to press Enter to confirm the rectangle area of the Screenshot. Enabling this option allows you to adjust the search/capture area using hotkeys (**Ctrl + Arrow keys** to move the selection area and **Shift + Arrow keys** to resize it).

### Screenshots Directory

Selects the default folder for Screenshots taken.

## Email accounts

Here you can add and test email accounts to be used with the *Send Email* feature. The information will be saved to the file *UserEmailAccounts.ini* in AppData folder, or the application folder in Portable Mode. The fields are standard email client fields so they won't be detailed here.

You can add, edit, remove and reorder the accounts here, as well as send a test message.

### Remarks

Accounts informations are saved to *UserEmailAccounts.ini* located at %AppData%\MacroCreator or at the application folder when in Portable mode.
		
To use a Gmail account it's necessary to activate allow ["Less secure apps access"](https://www.google.com/settings/security/lesssecureapps).
		
**Warning**: Scripts exported (even if compiled) with the send email function (CDO) will have visible informations of email accounts used, including the **password**. The PMC project file does not have this information.

## Language

Here you can choose the interface language.

## Language Editor

Here you can make corrections to the translations (or even create a new one) and submit your revisions.  
A new version of the language files may be released at any time independent of application releases, so feel free to submit any number of corrections as many times as you want. Credits will be given on the [official website](https://www.macrocreator.com/project). If don't wish to be credited, just say it in the message.

## User Global Variables

Here you can define global variables that will be available during Playback. They may be used as constants so you can always call them from inside a command.  

The variables defined here will always be available inside [User-Defined Functions](Functions.html#user-defined-functions), even when scope is Local.

User defined variables are saved to an INI file in the AppData\MacroCreator folder (it can also be edited in external text editors).

Format is the same used for non-expression assignments in AutoHotkey or the one found in standard INI files.  

They can also be included in exported scripts by checking *Global Variables* option in the [Export Window](Export.html).  

You can separate your variables in groups using INI format Sections with title enclosed in brocks. Use the button in the Export Window to select which Variables or Sections will be exported.  

Example of *User Global Variables* list:

> [Section1]
> aVar1 = Value1
> aVar2 = Value3
> aVar3 = Value2
> [Section2]
> bVar1 = Value1
> bVar2 = Value3
> bVar3 = Value2