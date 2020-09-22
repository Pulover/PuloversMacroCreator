# FAQ - "Frequently asked", "Not so frequently asked" and "Just in case you're wondering..." questions.

**Tip**: Right-click on an empty area of a Command Window to display links to AutoHotkey online documentation and related contents.

* [How do I start Recording / Playback?](#how-do-i-start-recording-/-playback)
* [Can I import AHK scripts to Macro Creator and edit them?](#can-i-import-ahk-scripts-to-macro-creator-and-edit-them)
* [How do create a random number/command?](#how-do-create-a-random-number/command)
* [Can I create Graphic User Interface/Gui with Macro Creator?](#can-i-create-graphic-user-interface/gui-with-macro-creator)
* [Can Macro Creator automate Firefox or Chrome as it does with Internet Explorer?](#can-macro-creator-automate-firefox-or-chrome-as-it-does-with-internet-explorer)
* [Where is the backup file located?](#where-is-the-backup-file-located)
* [Can I make playback go faster/slower?](#can-i-make-playback-go-faster/slower)
* [Can I execute a custom action based on Pixel/Image search result?](#can-i-execute-a-custom-action-based-on-pixel/image-search-result)
* [Can I run a Macro in a timed interval?](#can-i-run-a-macro-in-a-timed-interval)
* [Can I run a Macro in a background window?](#can-i-run-a-macro-in-a-background-window)
* [Can I schedule a Macro to run when I want?](#can-i-schedule-a-macro-to-run-when-i-want)
* [How do I increment/add a value in a variable on every loop iteration?](#how-do-i-increment/add-a-value-in-a-variable-on-every-loop-iteration)
* [How can I make an exported script auto-execute without a hotkey?](#how-can-i-make-an-exported-script-auto-execute-without-a-hotkey)
* [Is Macro Creator Portable?](#is-macro-creator-portable)
* [Which command line parameters are supported?](#which-command-line-parameters-are-supported)
* [Can I execute an action every time a certain event occurs?](#can-i-execute-an-action-every-time-a-certain-event-occurs)
* [Can I play other Macros while Timer is running?](#can-i-play-other-macros-while-timer-is-running)
* [Can I save my Macros as EXE to run on any computer?](#can-i-save-my-macros-as-exe-to-run-on-any-computer)
* [How can I avoid/bypass error messages during playback?](#how-can-i-avoid/bypass-error-messages-during-playback)
* [How can I use an active Internet Explorer window without editing the command every time I start PMC?](#how-can-i-use-an-active-internet-explorer-window-without-editing-the-command-every-time-i-start-pmc)
* [What is COM and how do I use it?](#what-is-com-and-how-do-i-use-it)
* [Can I take Screenshots during playback?](#can-i-take-screenshots-during-playback)
* [When I take a screenshot of a window area it cuts part of the boarders](#when-i-take-a-screenshot-of-a-window-area-it-cuts-part-of-the-boarders)
* [Can I record keys when pressed down and released separately?](#can-i-record-keys-when-pressed-down-and-released-separately)
* [Why won't the mouse stay where I recorded it when I play a Macro?](#why-wont-the-mouse-stay-where-i-recorded-it-when-i-play-a-macro)
* [Can I keep all Hotkeys always active?](#can-i-keep-all-hotkeys-always-active)
* [Can I use another AHK script to record / play Macros in PMC?](#can-i-use-another-ahk-script-to-record-/-play-macros-in-pmc)
* [Can I use Functions from my own AutoHotkey Scripts?](#can-i-use-functions-from-my-own-autohotkey-scripts)
* [Can I make the Playback Hotkeys work on a certain windown only?](#can-i-make-the-playback-hotkeys-work-on-a-certain-windown-only)
* [Why am I getting wrong mouse coordinates?](#why-am-i-getting-wrong-mouse-coordinates)
* [I can run the program but Macros won't work / cannot take screenshots](#i-can-run-the-program-but-macros-wont-work-/-cannot-take-screenshots)
* [I'm getting "Error: Invalid hotkey" when I try to launch the program](#im-getting-"error:-invalid-hotkey"-when-i-try-to-launch-the-program)

### How do I start Recording / Playback?

* To start recording you need to press the Record button and then press the recording hotkey (default is F9). For more details see [Record](Record.html).  
* To play a Macro you have to press the Play Button to activate the Hotkeys and use them to play each Macro. For more details see [Playback](Playback.html).  

### Can I import AHK scripts to Macro Creator and edit them?

No. AHK scripts are too complex to be parsed and the conversion would never be perfect. You can, however, include the original PMC code into the exported scripts by checking this option in the [Export Window](Export.html).

### How do create a random number/command?

Use the Random command in the Run / File / String / Misc. window to generate a random number. The command will save the number inside a variable of your choice. Use this variable inside commands like Sleep enclosed in percent signs, e.g. %Rand% and directly inside functions and expressions, e.g. MyArray[Rand].

Download Example: [Call array element using a random function](Examples/RandomFunction.pmc)

### Can I create Graphic User Interface/Gui with Macro Creator?

No, creating Guis is not in the scope of this project. But you can find some nice tools to design Gui in the [AHK forum](https://www.autohotkey.com/boards/viewforum.php?f=60). You can use the generated script along with exported scripts from PMC (the Gui's gLabel must point to a Label in the script).

### Can Macro Creator automate Firefox or Chrome as it does with Internet Explorer?

No. Macro Creator can connect to IE because its controls are exposed via [COM](Commands/Expression.html), but that type of interaction is not possible with other browsers in the same way. Control Commands won't work either, so you might have more luck with mouse, keystrokes and Image Search.

### Where is the backup file located?

It's located at `%AppData%\MacroCreator\~ActiveProject.pmc` or at the application's own folder in case it's running as portable (when `MacroCreator.ini` is in the same folder as `MacroCreator.exe`).

### Can I make playback go faster/slower?

You can use the Speed Up and Slow Down keys (defaults are Insert and Pause at 2x). To change the keys and speed multiplier see [Playback Options](Playback.html#playback-options).  

### Can I execute a custom action based on Pixel/Image search result?

Follow these steps to execute an action for Pixel/Image search based on a condition:  

1. Add the Pixel or Image Search. Use the Make Screenshot button or Search for the file and set the area to search.
2. Leave the "If found" option set to "Continue".
3. Add the If Statement right below the ImageSearch.
4. In the If Statements window select "If Image/Pixel Found" and click OK. It will add an 'If' and 'End If'.
5. Click on the 'End If' line to select it so that the actions will be added right above it.
6. Any actions you add between the 'If' and 'End If' lines will only be executed if the image/pixel was found.

### Can I run a Macro in a timed interval?

Yes, use the [Timer](Main.html#timer) or the [SetTimer](Commands/Set_Timer.html) command.  

### Can I run a Macro in a background window?

If the window is a Win32 application with exposed controls you might be able to use Control commands to interact with it without needing to have it active in the foreground. For more info check the [video tutorial for control commands](https://www.macrocreator.com/help/).

### Can I schedule a Macro to run when I want?

You can use Window's Task Scheduler to run Macro Creator from a command line using the *AutoPlay* parameter:

> MacroCreator.exe SavedFile.pmc -a

You can also export the Macro to an AutoHotkey script and run it using Window's Task Scheduler (you must have AutoHotkey installed).  

### How do I increment/add a value in a variable on every loop iteration?

You can use the [Variables](Commands/Variables.html) window and the **+=** operator o the **:=** operator and the Expression option if you need to sum it to another value like the built-in variable A_Index, which contains the number of the current loop iteration.  
The code below is a PMC file (you can copy and save it using any text editor).

> [PMC Code v5.0.0]|F3||1|Window,2,Fast,0,1|1|Macro1
> Groups=
> 1|[Assign Variable]|Var := 0|1|0|Variable|||||
> 2|[LoopStart]|LoopStart|10|0|Loop|||||
> 3|[Assign Variable]|Var += 1|1|0|Variable|||||
> 4|[MsgBox]|%Var%|1|0|MsgBox|262208||||
> 5|[LoopEnd]|LoopEnd|1|0|Loop|||||
> 6|[LoopStart]|LoopStart|10|0|Loop|||||
> 7|[Assign Variable]|Var := 100 + A_Index|1|0|Variable|Expression||||
> 8|[MsgBox]|%Var%|1|0|MsgBox|262208||||
> 9|[LoopEnd]|LoopEnd|1|0|Loop|||||
> 
> 

A_Index is only valid inside a Loop, but in PMC all macros are considered loops since you can set the number of repetitions for the whole macro.

### How can I make an exported script auto-execute without a hotkey?

To make the first macro auto-execute when running an exported script, remove the hotkey associated with it in the [Export Window](Export.html) "Macros" section.

### Is Macro Creator Portable?

All settings are saved to *MacroCreator.ini* and User Global Variables are saved to *UserGlobalVars.ini*, both files are located inside *AppData\MacroCreator* by default. To make **Macro Creator** portable you can copy those files to the same directory of *MacroCreator.exe* and it will use its own folder instead of AppData.

### Which command line parameters are supported?

[Command line parameters](Main.html#command-line-parameters)

### Can I execute an action every time a certain event occurs?

It's possible using the [Timer](Main.html#timer) and some If Statements.  

### Can I play other Macros while Timer is running?

Although the Timer is limited to run one Macro at a time, you can still activate the other Hotkeys by checking the *Always Active* option or right-clicking the TrayMenu icon and selecting **Play**. The [SetTimer](Commands/Set_Timer.html) command is more flexible.

### Can I save my Macros as EXE to run on any computer?

Macro Creator has an option to convert exported scripts to EXE using Ahk2Exe that is installed with AutoHotkey:  
1. Download and install [AutoHotkey](https://www.autohotkey.com/).  
2. Go to Export in PMC and check *[Create EXE File](Export.html#create-exe-file)* option.  
3. Click the *Export* button.  

The EXE file will be saved to the same directory as the script file.

### How can I avoid/bypass error messages during playback?

To bypass error messages go to Options > Settings > Playback and check the "Do not display errors" option.

### How can I use an active Internet Explorer window without editing the command every time I start PMC?

There are two methods:
* Open the *Export* window and change the option *COM Objects* to ComObjActive. This is used for convenience and works in Playback only. ComObjActive doesn't really work with Internet Explorer but you can use external functions to connect to existing IE windows such as IEGet and WBGet found in the links below.  
* Open the *Functions* window and type *ie* in the *Output Variable* field and WBGet in the *Function Name* field. WBGet is used internally by PMC and *o_ie* is the internal handle for IE commands.

### What is COM and how do I use it?

COM stands for [Component Object Model](https://en.wikipedia.org/wiki/Component_Object_Model) and it's a method to allow interaction of a script with other programs. The Internet Explorer command window offers a basic simplified interface to add COM commands to IE. If you want to use the advanced features you'll need to know about the COM methods and properties for the program you want to interact with. You can find some useful tutorials in the AutoHotkey Forum.

* [Basic Webpage Controls with JavaScript / COM](http://www.autohotkey.com/board/topic/47052-basic-webpage-controls-with-javascript-com-tutorial/)
* [Basic Ahk_L COM Tutorial for Excel](http://www.autohotkey.com/board/topic/69033-basic-ahk-l-com-tutorial-for-excel/)
* [COM Object Reference](http://autohotkey.com/boards/viewtopic.php?t=77)
* [Mickers Outlook COM MSDN for Ahk_L](http://www.autohotkey.com/board/topic/71335-mickers-outlook-com-msdn-for-ahk-l/)

### Can I take Screenshots during playback?

Macro Creator has the [GDI+ Library](https://www.autohotkey.com/boards/viewtopic.php?t=6517) integrated so you can make use of its functions.

The example file below allows you to save a png from the clipboard in your Documents folder. The first macro sends PrintScreen, the second sends Alt+PrintScreen, the third are the functions to save the file (you can change the destination folder in the 3rd line).

Download Example: [Save PNG screenshots](Examples/SaveScreenshot.pmc)

There is also an an internal function that uses GDI+ functions to make a screenshot of part of the screen.

* Go to Functions and type any name for the OutputVar and type **Screenshot** in the *Function Name*.
* The first parameter is the name of the file which can be an absolute or relative path and a file with a png extension. You can use variables to have them dynamically named, e.g.: Screen_%A_Now%.png
* The second parameter are the pipe-separated coordinates in the screen, e.g. 100|200|50|100 (where the 1st is the X position, 2nd is Y position, 3rd is width and 4th is the height, all in pixels).

Example of PMC file:

>  1|Screenshot|_null := A_MyDocuments "\Screen_" A_Now ".png", "100¢200¢50¢100"|1|0|Function||||
> 
> 

The ¢ symbol replaces the | in .pmc files and is converted when loaded.  

### When I take a screenshot of a window area it cuts part of the boarders

The visible area of a window can be affected by your current Theme, but you can adjust the selection to fit the correct area:

* Go to *Settings* > *Screenshots* (you can use the *Options* button in the *Image/Pixel Search* command window).
* Check the option *Press Enter to capture*. Now when you draw a rectangle it will remain visible in the screen until you press Enter.
* Use the hotkeys **Ctrl + Arrow keys** to move the selection area and **Shift + Arrow keys** to resize it.

### Can I record keys when pressed down and released separately?

Yes. To activate recording Key down/up for all keys go to Options > Recording.  

### Why won't the mouse stay where I recorded it when I play a Macro?

Go to Settings > Playback and make sure that the option *Return Mouse to initial position after playback* is unchecked.

### Can I keep all Hotkeys always active?

Yes, just check the *Always Active* option in the main window.  

### Can I use another AHK script to record / play Macros in PMC?

Your script must use the Send command with a higher level to execute the Hotkeys in PMC. Put these two lines on top of it.  

> #InputLevel, 1
> SendLevel, 1

\#InputLevel makes it possible to use Send command from a hotkey in another script and SendLevel allows to use Send command from a subroutine such as a gLabel.  

### Can I use Functions from my own AutoHotkey Scripts?

Yes. You can load an external .ahk file in the *Functions* command window to run functions from it and save the results to the Output Variable. You can set a Standard Library File containing your functions in Settings > Misc., this file will be automatically selected when you enter the Function command window.   

This feature is limited and can only return 1 string/number value. It's recommended to use [User-Defined Functions](Functions.html#user-defined-functions) instead.

### Can I make the Playback Hotkeys work on a certain windown only?

Yes, use the *Context Sensitive Hotkeys* button in the main window.  

### Why am I getting wrong mouse coordinates?

The default settings for mouse coords are relative to the active window to make clicks point correctly even when the window is in a different position of when Macro was created. When working with multiple windows it may be best to adjust or maximize all windows and change CoordMode to screen (Settings > [Defaults](Settings.html#defaults)).  

### I can run the program but Macros won't work / cannot take screenshots

Jn some systems Macro Creator requires administrator privileges in order to work properly. Enter the program or shortcut's Properties, select the Compatibility tab (click the Advanced button, if it's a shortcut) and check the "Run as administrator" option. 

### I'm getting "Error: Invalid hotkey" when I try to launch the program

This is a keyboard language issue. Change the default keyboard layout of your system (global settings) to English and open MacroCreator.  