# FAQ - "Frequently asked", "Not so frequently asked" and "Just in case you're wondering..." questions.

**Note**: Right-click on a Button in the Main Window or anywhere on a Command Window to display links to AHK online help.

* [Syntax differences from AutoHotkey](#Syntax-differences-from-AutoHotkey)
* [How do I start Recording / Playback?](#How-do-I-start-Recording-/-Playback)
* [Can I make playback go faster/slower?](#Can-I-make-playback-go-faster/slower)
* [Can I execute a custom action based on Pixel/Image search result?](#Can-I-execute-a-custom-action-based-on-Pixel/Image-search-result)
* [Can I run a Macro in a timed interval?](#Can-I-run-a-Macro-in-a-timed-interval)
* [Can I schedule a Macro to run when I want?](#Can-I-schedule-a-Macro-to-run-when-I-want)
* [Which command line parameters are supported?](#Which-command-line-parameters-are-supported)
* [Can I execute an action every time a certain event occurs?](#Can-I-execute-an-action-every-time-a-certain-event-occurs)
* [Can I play other Macros while Timer is running?](#Can-I-play-other-Macros-while-Timer-is-running)
* [Can I save my Macros as EXE to run on any computer?](#Can-I-save-my-Macros-as-EXE-to-run-on-any-computer)
* [How can I use an active Internet Explorer window without editing the command every time I start PMC?](#How-can-I-use-an-active-Internet-Explorer-window-without-editing-the-command-every-time-I-start-PMC)
* [What is COM and how do I use it?](#What-is-COM-and-how-do-I-use-it)
* [Can I take Screenshots during playback?](#Can-I-take-Screenshots-during-playback)
* [When I take a screenshot of a window area it cuts part of the boarders.](#When-I-take-a-screenshot-of-a-window-area-it-cuts-part-of-the-boarders.)
* [Can I record keys when pressed down and released separately?](#Can-I-record-keys-when-pressed-down-and-released-separately)
* [Why won't the mouse stay where I recorded it when I play a Macro?](#Why-wont-the-mouse-stay-where-I-recorded-it-when-I-play-a-Macro)
* [Can I keep all Hotkeys always active?](#Can-I-keep-all-Hotkeys-always-active)
* [Can I open an .ahk file in PMC to edit it?](#Can-I-open-an-.ahk-file-in-PMC-to-edit-it)
* [Can I use another AHK script to record / play Macros in PMC?](#Can-I-use-another-AHK-script-to-record-/-play-Macros-in-PMC)
* [Can I use Functions from my own AutoHotkey Scripts?](#Can-I-use-Functions-from-my-own-AutoHotkey-Scripts)
* [Can I make the Playback Hotkeys work on a certain windown only?](#Can-I-make-the-Playback-Hotkeys-work-on-a-certain-windown-only)
* [Why am I getting wrong mouse coordinates?](#Why-am-I-getting-wrong-mouse-coordinates)
* [I can run the program but Macros won't work / cannot take screenshots.](#I-can-run-the-program-but-Macros-wont-work-/-cannot-take-screenshots.)
* [I'm getting "Error: Invalid hotkey." when I try to launch the program.](#Im-getting-"Error:-Invalid-hotkey."-when-I-try-to-launch-the-program.)

### Syntax differences from AutoHotkey

* Since Playback uses a function to dereference variables they should always be enclosed in percent signs even for functions or assignments, execpt when the command parameter is OuputVar or InputVar. The syntax will be corrected for the exported script.  
* It's not necessary to use "quotes" for string parameters in functions or COM commands except for blank parameters.  

### How do I start Recording / Playback?

* To start recording you need to press the Record button and then press the recording hotkey (default is F9). For more details see [Record](p2-Record.html).  
* To play a Macro you have to press the Play Button to activate the Hotkeys and use them to play each Macro. For more details see [Playback](p3-Playback.html).  

### Can I make playback go faster/slower?

You can use the Speed Up and Slow Down keys (defaults are Insert and Pause at 2x). To change the keys and speed multiplier see [Playback Options](p3-Playback.html#playback-options).  

### Can I execute a custom action based on Pixel/Image search result?

Follow these steps to execute an action for Pixel/Image search based on a condition:  

1. Add the Pixel or Image Search. Use the Make Screenshot button or Search for the file and set the area to search.
2. Leave the "If found" option set to "Continue".
3. Add the If Statement right below the ImageSearch.
4. In the If Statements window select "If Image/Pixel Found" and click OK. It will add an 'If' and 'End If'.
5. Click on the 'End If' line to select it so that the actions will be added right above it.
6. Any actions you add between the 'If' and 'End If' lines will only be executed if the image/pixel was found.

### Can I run a Macro in a timed interval?

Yes, use the [Timer](p1-Main.html#buttons-&-menus).  

### Can I schedule a Macro to run when I want?

You can use Window's Task Scheduler to run Macro Creator from a command line using the *AutoPlay* parameter:

> MacroCreator.exe SavedFile.pmc -a

You can also export the Macro to an AutoHotkey script and run it using Window's Task Scheduler (you must have AutoHotkey installed).  

### Which command line parameters are supported?

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

### Can I execute an action every time a certain event occurs?

It's possible using the [Timer](p1-Main.html#buttons-&-menus) and some If Statements.  

### Can I play other Macros while Timer is running?

Although the Timer is limited to run one Macro at a time, you can still activate the other Hotkeys by checking the *Always Active* option or right-clicking the TrayMenu icon and selecting **Play**.

### Can I save my Macros as EXE to run on any computer?

Macro Creator has an option to convert exported scripts to EXE using Ahk2Exe that is installed with AutoHotkey:  
1. Download and install [AutoHotkey](http://www.autohotkey.com).  
2. Go to [Export](p5-Export.html#destination-file) in PMC and check *Create EXE File* option.  
3. Click the *Export* button.  

The EXE file will be saved to the same directory as the script file.

### How can I use an active Internet Explorer window without editing the command every time I start PMC?

There are two methods:
* Open the *Export* window and change the option *COM Objects* to ComObjActive. This is used for convenience and works in Playback only. ComObjActive doesn't really work with Internet Explorer but you can use external functions to connect to existing IE windows such as IEGet and WBGet found in the links below.  
* Open the *Functions* window and type *o_ie* in the *Output Variable* field and IEGet in the *Function Name* field. IEGet is used internally by PMC and *o_ie* is the internal handle for IE commands.

### What is COM and how do I use it?

COM stands for [Component Object Model](http://en.wikipedia.org/wiki/Component_Object_Model) and it's a method to allow interaction of a script with other programs. The Internet Explorer command window offers a basic simplified interface to add COM commands to IE. If you want to use the advanced features you'll need to know about the COM methods and properties for the program you want to interact with. You can find some useful tutorials in the AutoHotkey Forum.

* [Basic Webpage Controls with JavaScript / COM](http://www.autohotkey.com/board/topic/47052-basic-webpage-controls-with-javascript-com-tutorial/)
* [Basic Ahk_L COM Tutorial for Excel](http://www.autohotkey.com/board/topic/69033-basic-ahk-l-com-tutorial-for-excel/)
* [Mickers Outlook COM MSDN for Ahk_L](http://www.autohotkey.com/board/topic/71335-mickers-outlook-com-msdn-for-ahk-l/)

### Can I take Screenshots during playback?

Macro Creator has the [GDI+ Library](http://www.autohotkey.com/board/topic/29449-gdi-standard-library) integrated so you can make use of its functions.

The example file below allows you to save a png from the clipboard in your Documents folder. The first macro sends PrintScreen, the second sends Alt+PrintScreen, the third are the functions to save the file (you can change the destination folder in the 3rd line).

Download Example: [Save PNG screenshots](Examples\SaveScreenshot.pmc).  

There is also an an internal function that uses GDI+ functions to make a screenshot of part of the screen.  

* Go to Functions and type any name for the OutputVar and type **Screenshot** in the *Function Name*.
* The first parameter is the name of the file which can be an absolute or relative path and a file with a png extension. You can use variables to have them dynamically named, e.g.: Screen_%A_Now%.png
* The second parameter is the pipe separated coordinates in the screen, e.g. 100|200|50|100 (where the 1st is the X position, 2nd is Y position, 3rd is width and 4th is the height, all in pixels).

Example of PMC file:

>  1|Screenshot|sc := %A_MyDocuments%\Screen_%A_Now%.png, 100¢200¢50¢100|1|0|Variable||||

The ¢ symbol replaces the | in .pmc files and is converted when loaded.  

### When I take a screenshot of a window area it cuts part of the boarders.

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

### Can I open an .ahk file in PMC to edit it?

Parsing an .ahk script is not possible but you have the option to *Include PMC Code* for exported scripts so you can read it back from the .ahk file using PMC.  

### Can I use another AHK script to record / play Macros in PMC?

Your script must use the Send command with a higher level to execute the Hotkeys in PMC. Put these two lines on top of it.  

> #InputLevel, 1
> SendLevel, 1

#InputLevel makes it possible to use Send command from a hotkey in another script and SendLevel allows to use Send command from a subroutine such as a gLabel.  

### Can I use Functions from my own AutoHotkey Scripts?

Yes. You can load an external .ahk file in the *Functions* command window to run functions from it and save the results to the Output Variable. You can set a Standard Library File containing your functions in Settings > Misc., this file will be automatically selected when you enter the Function command window.   

### Can I make the Playback Hotkeys work on a certain windown only?

Yes, use the *Context Sensitive Hotkeys* button in the main window.  

### Why am I getting wrong mouse coordinates?

The default settings for mouse coords are relative to the active window to make clicks point correctly even when the window is in a different position of when Macro was created. When working with multiple windows it may be best to adjust or maximize all windows and change CoordMode to screen (Settings > [Defaults](p7-Settings.html#Defaults)).  

### I can run the program but Macros won't work / cannot take screenshots.

Macro Creator requires administrator privileges in order to work properly. Enter the program or shortcut's Properties, select the Compatibility tab (click the Advanced button, if it's a shortcut) and check the "Run as administrator" option. 

### I'm getting "Error: Invalid hotkey." when I try to launch the program.

This is a keyboard language issue. Change the default keyboard layout of your system (global settings) to English and open MacroCreator.  
