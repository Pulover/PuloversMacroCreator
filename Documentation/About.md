# Pulover's Macro Creator
*The Complete Automation Tool*

[www.macrocreator.com](https://www.macrocreator.com)  
[Forum](https://www.autohotkey.com/boards/viewforum.php?f=63)  

Author: Pulover \[Rodolfo U. Batista\]  
Copyright © 2012-2021 Cloversoft Serviços de Informática Ltda  

Version: 5.4.1  
Release Date: September, 2021  
AutoHotkey Version: 1.1.33.09  

Software License: [GNU General Public License](License.html)  

## Thanks to

Chris and Lexikos for [AutoHotkey](https://www.autohotkey.com/).  
tic (Tariq Porter) for his [GDI+ Library](https://www.autohotkey.com/boards/viewtopic.php?t=6517).  
tkoi & majkinetor for the [ILButton function](http://autohotkey.com/board/topic/37147-ilbutton-image-buttons).  
just me for [LV_Colors Class](https://www.autohotkey.com/boards/viewtopic.php?f=6&t=1081), [LV_EX](https://www.autohotkey.com/boards/viewtopic.php?t=1256)/[IL_EX](https://www.autohotkey.com/boards/viewtopic.php?f=6&t=1273) libraries and for updating ILButton to 64bit.  
Micahs for the [base code](http://autohotkey.com/board/topic/30486-listview-tooltip-on-mouse-hover/?p=280843) of the Drag-Rows function.  
jaco0646 for the [function](http://autohotkey.com/board/topic/47439-user-defined-dynamic-hotkeys) to make hotkey controls detect other keys.  
Uberi for the [ExprEval function](http://autohotkey.com/board/topic/64167-expreval-evaluate-expressions) to solve expressions.  
Jethrow for the [IEGet & WBGet functions](http://autohotkey.com/board/topic/47052-basic-webpage-controls).  
RaptorX for the [Scintilla Wrapper for AHK](http://autohotkey.com/board/topic/85928-wrapper-scintilla-wrapper).  
majkinetor for the [Dlg_Color function](http://autohotkey.com/board/topic/49214-ahk-ahk-l-forms-framework-08/).  
rbrtryn for the [ChooseColor function](http://autohotkey.com/board/topic/91229-windows-color-picker-plus/).  
PhiLho and skwire for the [function](http://autohotkey.com/board/topic/11926-can-you-move-a-listview-column-programmatically/#entry237340) to Get/Set the order of columns.  
fincs for [GenDocs](http://autohotkey.com/board/topic/71751-gendocs-v30-alpha002) and [SciLexer.dll custom builds](http://autohotkey.com/board/topic/54431-scite4autohotkey-v3004-updated-aug-14-2013/page-58#entry566139).  
tmplinshi for the [CreateFormData function](https://www.autohotkey.com/boards/viewtopic.php?f=6&t=7647).  
iseahound (Edison Hua) for the [Vis2 function](https://www.autohotkey.com/boards/viewtopic.php?f=6&t=36047) used for OCR.  
Coco for [JSON class](https://www.autohotkey.com/boards/viewtopic.php?f=6&t=627).  
Thiago Talma for some improvements to the code, debugging and many suggestions.  
chosen1ft for suggestions and testing.  
[Translation revisions](https://www.macrocreator.com/project/).  


# Change Log

## Version 5.4.1
* Added a sleep when collecting data to save project to improve reliability.
* Fixed bug with escaped characters in expressions.
* Fixed *Until* option unchecked when editting a loop command.
* Fixed bug when selecting some options in the Speed Up/Down menus.

## Version 5.4.0
* Fixed missing or mixed rows when importing files.
* Automatically adding escape char in delimiter em omit chars in Loop window.

## Version 5.3.9
* Fixed bug in Get-Area button in Image/Pixel Search window.

## Version 5.3.8
* Fixed bug with named operators.
* Fixed scroll bug during operations with groups enabled.

## Version 5.3.7
* Fixed *A_* variables not accessible in nested Loop commands.
* Fixed bugs with quotes in expressions.

## Version 5.3.6
* Fixed bug with multiple compare operators.
* Fixed issue with variables and strings in expressions.
* Fixed other groups expanding when inserting new group.
* Small bug fixes.

## Version 5.3.5
* Updated max value for *Pause (Sleep)* command.
* Project's exe custom icon path is now saved to PMC file.
* Fixed bugs with objects and strings inside objects.
* Fixed small bugs.

## Version 5.3.4
* Fixed strings being evaluated as math operations in expressions.

## Version 5.3.3
* Fixed bug in *Else If* statements nested in other statements.
* Fixed empty return value from **Object/Array** method call from *Function* window.

## Version 5.3.2
* Fixed bug in Function Return.

## Version 5.3.1
* Added **Random coordinates** option in *Mouse* command window.
* Added **Custom icon** option for exported EXE in *Export* window.
* Fixed bug in *Compare variables* of *If Statements* window with built-in variables.
* Fixed bugs in subtraction operations in expressions.
* Fixed bug in scoped variables in functions.
* Fixed **ListVars** not showing local variables inside functions.
* Fixed OutputVars of **MouseGetPos** not showing in **ListVars**.

## Version 5.3.0
* Fixed bug in *Compare variables* of *If Statements* window.

## Version 5.2.9
* Updated *Compare variables* in *If Statements* window to use expressions with symbols operators only.
* Fixed bugs in duplicate and paste in groups.
* Fixed mixed history when adding slots after using undo.
* Fixed escaped percent signs in strings (`%) being wrongly converted to variables during playback.

## Version 5.2.8
* Added option to show Group names as comments in *View menu* > *Preview Script* and Preview toolbar.
* Fixed `A_` variables not working as `InputVar` parameter for commands.
* Fixed *Expand all groups* not working.
* Fixed some hotkeys not updating the Play hotkey.
* Fixed problem with subtraction in expressions.
* Fixed global context condition being set to macro context.

## Version 5.2.7
* Added support for `&`, `*`, `~` and `Up` as modifier symbols for Play hotkey.
* Added support for setting Hotstrings to execute macros in *Edit Macros* window.
* Added support for **Image to Text** from image file in *Image Search* command window.
* Fixed blank ListViews after adding a macro with groups enabled.
* Fixed groups not showing in duplicated macros.
* Fixed mixing content when editing macros after duplicating a list.
* Fixed bug with commas in *WinTitle* (must be escaped).
* Fixed small bugs.

## Version 5.2.6
* Fixed error when exporting to exe.
* Fixed hotkeys not being activated.

## Version 5.2.3
* Updated exported *Compare variables* from *If Statements* window to use expression.
* Global Context Hotkey is now saved in project file instead of ini file.
* Fixed *Function Return* ignoring if statements.
* Fixed bug with similar numeric Play hotkeys.
* Fixed bugs in Expressions.
* Fixed various bugs.

## Version 5.2.1
* Fixed inconsistency in exported OCR() function from Image To Text.
* Fixed bug when using Apply button in command windows.

## Version 5.2.0
* Added new feature: **Image to Text (OCR)** in *Image Search* command window.
* Added support for defining *any* hotkey for **Play** manually in Edit Macros window.
* Added *Go to* command in edit menu.
* Added font size setting for macro list in view menu.
* Added font size setting for preview panel.
* Fixed bug when closing macro tab.
* Fixed bugs.

## Version 5.1.3
* Fixed bugs in *Capture key presses* feature.
* Fixed bugs when recording keystrokes.

## Version 5.1.2
* Added *Go to selected line* button and *Auto-select code* on **Preview window**.
* Added per-macro Context Sensitve Hotkeys.
* Added support for *OutputVar* in **Function** window for `RegExMatch`, `RegExReplace` and `StrReplace`.
* Improved performance of Text::Paste from Clipboard.
* Fixed INI and REG commands not working when omitting optional parameters.
* Fixed bug in *Adjust coordinates to the center of the image* option in Image Search.
* Fixed mixing rows bug when saving a project (thanks to chosen1ft).
* Fixed reordered macros exported in the wrong order.
* Fixed bug when closing macro tab.
* Fixed bugs and crashes.

## Version 5.0.5

* Fixed bug in expressions when assigning a variable to a ternary operation.

## Version 5.0.4

* Fixed wrong options set for *Message Box* when editing the command.

## Version 5.0.3

* Fixed wrong rows executed in loops after gosub or goto.
* Fixed missing value field in exported `Control` and `ControlGet` commands.
* Fixed hidden *Main Loop* band reappearing after gui resize or minimizing/maximizing.
* Fixed bug in *Copy to...* feature.
* Fixed *Delete* key not working as hotkey.

## Version 5.0.2

* Improved performance when Groups are enabled.
* Changed behavior of *Repeat Until* option in Image/Pixel Search to allow max repeat number.
* Fixed global variables cleared after user-defined function calls inside expressions.
* Fixed local function variables not restored to global scope after call.
* Fixed expressions being executed twice in commands.
* Fixed identical function or object calls in expressions being executed only once.
* Fixed mixed rows data after closing a Macro tab.
* Fixed some fields of *Send Email*, *Download Files* and *Zip/Unzip Files* not working with variables.
* Fixed Macro Lists being cleared after reordering function tabs by drag-and-drop or from the *Edit Macros* window.
* Fixed hotkeys sometimes not activated.
* Fixed some rows eventually not executed due to thread issue.
* Fixed collapsed groups expanded after editing the Macro list.
* Fixed error message when submitting translation revisions.
* Boolean assignment is only supported with *Expression* option now.
* Reverted *SciLexer.dll* to previous version due to crashes.

## Version 5.0.1

* Improved performance of Macro List operations.
* Increased max *Speed* settings for playback and export to 256x.
* Added *Incremental* option to delay in the *Multi-Edit* window.
* Fixed application not responsive when loading large project files.
* Fixed *If string [not] contains* statement not working with *A_Loop* variables.
* Fixed context menus not showing in main window after drag-and-drop operation.
* Fixed Recording Options menu not updating.
* Fixed problems saving projects with large macros.
* Fixed *Save as* not working.
* Fixed *Target Label not found* error.
* Fixed *Goto*, *Gosub* and *Set Timer* commands not accepting force expression syntax.
* Fixed Speed settings not corrected exported when using *Indentation*.

## Version 5.0.0

* New feature: **User Defined Functions**.
* New feature: **SetTimer** command.
* New feature: **While-Loop** in Loop Command window.
* New feature: **For-Loop** in Loop Command window.
* New feature: **Until** in Loop Command window.
* New feature: **Send Email** function.
* New feature: **Download Files** function.
* New feature: **Zip / Unzip Files** function.
* New feature: **Listview Groups** (+WinVista).
* Implemented real AutoHotkey format expressions in Functions, Methods, Variable Assignment, Evaluate Expression, COM Interface and command parameters started with % .
* Multiple If Statements are now supported in *Evaluate Expression* (e.g.: `var = 5 || var = "a"`).
* Function parameter can now be another function, array, array element or expression.
* Added *Else If* Statement option.
* Loops now work in Manual Playback.
* Added support for array assignment.
* Added support for Associative Arrays assignment.
* Added support for array methods in Functions window.
* Added support for Multi-Dimensional Arrays.
* Added support for named keys in arrays (e.g.: `N["key"]` or `N.key`, `MyArray.1 := OtherArray.Name`).
* Added support for array methods.
* Added support for *#If Expression* in Context Sensitive Hotkeys.
* Added *GetElementsByClassName* option in InternetExplorer/COM *Get Element Tool*.
* Added var [not] in, var [not] contains, var [not] between and var is in Compare Variables If Statement.
* Added WinTitle, WinText, ExcludeTitle and ExcludeText to *If Window...* statements.
* Added options to set TitleMatchMode, DetectHiddenWindows and DetectHiddenText.
* Added options to set SendMode, KeyDelay, MouseDelay and ControlDelay.
* Added *Client* mode for Mouse and Pixel/Image Search coordinates.
* Added option to center coordinates of *ImageSearch* results.
* Added option to change color of the rectangle of Image/Pixel Search area and Screenshots tool.
* Added *Insert Comment Block* to "Edit Comment" window.
* Added option to comment out unchecked rows in Preview/Exported scripts.
* Added new translations.
* Added Language editor in *Settings* window with submit form.
* Languages files are now kept in the Lang folder and can be added, modified or removed.
* Updated *Loop, File* and *Loop, Reg* to new format with *Mode* parameter.
* Changed *List Variables* to display User-Defined variables only.
* Extended Backup system to update backup file with every change.
* Fixed corrupted pmc files saved on exit.
* Fixed hotkeys not being automatically disabled when changed.
* Fixed bug with recording of mouse buttons.
* Fixed bug with WinWait timeout.
* Fixed bugs with IE/COM Interface.
* Fixed bugs with commas in command parameters.
* Fixed issues with *Schedule Macros*.
* Fixed default editor not set correctly on first run.

## Version 4.1.3

* Fixed Macro List redrawing issue.
* Fixed wrong *Invalid address* message on export.

## Version 4.1.2

* Added Options toolbar items to Options Menu.
* Added support for *WinHttp.WinHttpRequest.5.1* object methods in *COM Interface*.
* Added debugging messages for missing "End Loop" and "End If" statements (highlighting must be enabled).
* Added *Deactivate Macros* command to Macro, Play Button and Tray Icon menus.
* Changed commands, except Send and Click, to not stop playback when main window is active.
* Fixed bug with *Pause* button of Controls Toolbar.
* Fixed bug with *Gosub* command inside loops.
* Fixed bug with A_Loop variables in *Compare Variables* statement.
* Fixed bug with A_Space variable in Functions.
* Fixed escaped comma bug in *Assign Variable* command.
* Fixed *Get Coordinates* tool in *Image/Pixel Search* window not getting correct values in Window Coord mode.
* Fixed *Copy to* command not copying Comment and Color fields.
* Fixed some minor bugs.

## Version 4.1.1

* Detects default AHK editor on first run.
* Fixed command line parameters not working for MacroCreatorPortable.exe.
* Fixed bugs.

## Version 4.1.0

* Added tool to schedule macros in Windows Task Scheduler.
* Added shortcuts to insert built-in variables in command windows context-menu.
* Added *Filter by type* button in *Run* command window.
* Added Right-Click-Drag Move/Copy menu.
* Added *Play Sound* option to *Image/Pixel Search* result actions.
* Added Launcher to portable version (automatically updates INI and selects between x86 and x64 based on Windows version).
* Fixed issues with command line parameters.
* Fixed bugs.

## Version 4.0.0

* New Interface with customizable toolbars.
* New *Preview* window with syntax highlighting.
* Added *Find a command* window.
* Added tips in command windows.
* Added more options to *Message* window.
* Added *Edit Macros* window.
* Added Drag-Macros feature.
* Added Close and Edit menu when clicking over a Macro tab.
* Added Close with Mouse Middle click over a Macro tab.
* Added *Loop until* option in *Image/Pixel Search* (replaces "Break if found").
* Added individual *Pause* hotkey.
* Added *Multiple Column* search in *Find/Replace* window.
* Added *Set key delay* option in *Text* command window.
* Added *Random delays* and *Disable random delays* options to *Pause* command window.
* Added *Edit Script* button in *Preview* window.
* Added support for basic Arrays using the built-in function *Array*.
* Added support for functions in *Assign Variable* window when using the *Expression* option.
* Added automatic backups.
* Added translations to Malay and Vietnamese.
* Added *Portable Install* option in installer.
* Paste command now works on mutiple selections.
* Main window size, position and columns order are remembered.
* Removed *MsgBox* command from *Run* command window.
* Removed automatic *Cancel* button handling for *MsgBox* for compatibility with new options.
* Fixed *ErrorLevel* variable results for commands in playback.
* Fixed automatic comma escaping in *Run* command window.
* Fixed Media keys not being recorded/captured.
* Fixed various bugs and issues.

## Version 3.8.4

* Switched functionality of *Color Picker* and *Search* buttons in *PixelSearch* for a more intuitive behavior.
* Removed *Special Keys* window. Replaced by *Insert Keystroke*.
* Fixed some minor issues.

## Version 3.8.3

* Added translations to Indonesian, Slovak and Slovenian.
* Added portable settings support by copying INI files to installation folder.
* Fixed *Text* window toolbar buttons not working.
* Fixed incorrect "Duplicate Keys" error message when exporting Macros without hotkeys.
* Fixed incorrect "Expressions" error message when using variables inside *Mouse* commands.

## Version 3.8.2

* Fixed *Break* option of *Image/Pixel Search* command not working for loops.
* Fixed *Duplicate Macro* not updating Loop counter.
* Fixed wrong repeat value when editing *Loop* commands with variable in delay.

## Version 3.8.1

* Added exclamation as parameter to run Timer immediately in command line (e.g.: -t5000!).
* Fixed issues with higher DPI settings.
* Fixed an issue with Timer command line parameter.

## Version 3.8.0

* Added *Insert Keystroke* command.
* Added *Run immediately* option in Timer.
* Added *Random delays* option for Playback in *Options* window.
* Added shortcuts to paint selected rows with custom colors (Shift+1 to 0).
* Fixed some issues with main window controls sizes.
* Fixed color dialog not saving custom colors when canceled.
* Fixed comments and colors not copied with Duplicate Macro command.
* Made InputVar parameters in *Run* window mandatory.
* Made OutputVar parameters of SplitPath and MouseGetPos in *Run* window optional.

## Version 3.7.9

* Working Directory is now automatically set to the path of currently open file.
* Fixed Goto command not working in Timer.
* Fixed wrong controls position when window started maximized.

## Version 3.7.8

* Fixed bug: Controls not showing when selecting Macros.

## Version 3.7.7

* Fixed wrong global Mouse Coordinates after Image/Pixel Search.
* Fixed wrong controls position in monitors with DPI different from 100%.

## Version 3.7.6

* Added more search options to *ImageSearch* command.
* Added *Add "If Statement"* option to *ImageSearch* and *PixelSearch* commands.
* Added *Color Mark* feature for rows.
* Fixed memory leak in Timer.

## Version 3.7.5

* Added *Run Scriptlet* command for VBScript and JScript in IE command window.
* Added Controls Toolbar Right-Click menu.
* Drag Controls Toolbar clicking in an empty area.
* Included Shutdown options in PMC files.
* Fixed problems with ScriptControl in *COM Interface*.

## Version 3.7.4

* Added *Shutdown options* in Main Window.
* Added *Speed Control* for exported scripts.
* Improved *Drag-Rows* function.
* Fixed crash by stack overflow in Goto-based loops.
* Fixed escaped commas not showing in command parameters of the *Run* window.
* Fixed Controls Toolbar Play button not switching when using Hotkeys.

## Version 3.7.3

* Added support for Joystick Hotkeys in Playback.
* Added *Tips on Start-up*.
* Fixed bug with *Break* command.
* Fixed bug with *Continue, LoopNumber* command.
* Fixed bug with *String* commands with *A_Loop* variables as InputVar.
* Fixed commas not being escaped in exported *MsgBox* command.

## Version 3.7.2

* Added option to define *User Global Variables* in Settings.
* Added support to set an infinite loop in *Loop Command*.
* Added support for Loop Number parameter in *Break* and *Continue*.
* Added handler for *COM* errors in Playback.
* Added support for self-references inside parameters in *COM Interface*.
* Added *Toolbar* command line parameter: -b (Shows *Controls Toolbar* on start-up).
* Added support for escaping percent signs (`%).
* Fixed error on start-up on Windows Vista.
* Fixed Screenshots not working in 64-bit version.
* Fixed *WinWait* Timeout parameter not working in Playback.
* Fixed issues with *If Statements*.

## Version 3.7.1

* Added selected Macro hotkey to *Preview Window* status bar.
* Fixed error on start-up on Windows XP.
* Fixed missing/wrong icons on Windows 8.
* Fixed wrong default values set to Export Options on first run.
* Fixed *Save Macro* dialog being displayed for unchanged projects.
* Fixed Progress Bar displaying wrong Range during playback.
* Fixed *Auto-Hotkey* not loading correctly when *Win* option was selected.
* Fixed translation errors.

## Version 3.7.0

* Added new Loop commands: *FilePattern*, *Parse*, *Read* and *Registry*.
* Added *Break* to Image/Pixel Search options.
* Added *Break loop if image is found* option to Image/Pixel Search.
* Added support to set an infinite Loop for Macros.
* Added *Controls Toolbar*.
* Added *Clear List* option for *Record New Macro* to restart the current Macro.
* Added *Play Selected Rows* option.
* Added *Apply* button to command windows.
* Added *Icon*, *Always On Top* and *Cancel* options to *Message* command.
* Added *Check for updates* feature.
* Added Help button and F1 Help to Command windows.
* Added *Quick Select* to *Action* column (double-click for indentation).
* Added option to choose between 64-bit and 32-bit versions during setup.
* Added more icons and shortcuts.
* Added translations to Croatian, Catalan, Greek, Serbian, Ukrainian and Traditional Chinese.
* Fixed bug: *Goto* command not working inside Loops.
* Fixed an error with *A_Index* variable inside loops.
* Fixed some translation errors.
* Macro Loop counter is now independent of Quick-Edit Repeat counter in the Main Window.
* Corrected Version format to comply with software standards.
* Improved Help File.

## Version 3.6.3

* Added Dragging Rows with mouse.
* Added hotkeys (Ctrl/Shift + Arrow keys) to adjust search/screenshot area when *Press Enter to capture* option is selected.
* Added Screenshot Options button to *Image/Pixel Search* command window.
* Added *Recent Files* submenu in *File Menu*.
* *Repeat* and *Delay* fields now accept variables and functions for all commands.
* Improved handling of associated files.
* Fixed a bug with *GetElementByID* method of *Internet Explorer*.
* Fixed an issue with wrong coordinates recorded in background windows clicks.
* Fixed an issue with *Set as Default Hotkeys* option.
* Fixed *External Functions* not working inside loops.
* Fixed syntax errors in Expressions and Functions.
* Fixed some redrawing issues with listviews.
* Fixed various glitches and issues.
* Changed location of settings file (MacroCreator.ini) to AppData folder.
* Changed default location of Screenshots folder to AppData folder.
* Removed auto-escape commas for *Mouse* actions due to incompatibility with expressions.

## Version 3.6.2

* Added *Gosub* command to *Loop* command Window.
* Added *ExitApp* and *SendLevel* commands to *Run* command Window.
* Added *Copy* button to *Preview* window.
* Added *Create EXE File* option in *Export* window (requires AutoHotkey installed).
* *Label* and *Goto/Gosub* are now editable.
* Repeat field of *Loop* commands now accept variables and functions.
* Commas are now automatically escaped inside all commands.
* Restored *Windows Messages* button to Main Window.
* Reduced Memory Usage.
* Fixed a bug when adding *If Statements* on multiple rows.
* Fixed a bug when capturing Up Keys in Main Window.
* Fixed a bug when editing multiple commands.
* Fixed some issues with Functions inside commands.

## Version 3.6.1

* Added *Quick Select*: Select a row and click a column header to select similar rows.
* Fixed *Pixel Search* button not working for languages other then English.
* Fixed an issue when editing comments.
* Fixed some issues with Hotkeys.
* Fixed some issues with exported scripts.
* Fixed some gui issues.

## Version 3.6.0

* Added support to use Functions from external files (requires AutoHotkey installed).
* Added *Play From* and *Play Until Selected Row* options in *Macro* menu.
* Added support for WinText, ExcludeTitle and ExcludeText in the *Window* field.
* Added *WinSetTitle* command.
* Added *Timer* command line parameter: -t*N* (*N* = Time Interval in miliseconds).
* *Pause Key* can now be used to Pause/Resume Recording.
* Editing the *Window* of multiple commands now affects *Win* commands.
* Fixed a syntax error of WinSet command in exported scripts.
* Fixed syntax errors of Functions in exported scripts.
* Fixed issues with command line parameters.
* Fixed Change History not updating after adding commands to selected rows.
* Fixed an issue when recording accents.
* Removed accents from default *Virtual Keys* to prevent recording issues.

## Version 3.5.3

* Added Indentation option to the *Action* column in the Main Window.
* Added option in *Settings* to display a Progress Bar during Playback.
* Added *Env* commands to the *Run* command window.
* Added *Close* command line parameter: -c (Exits program after Macro execution).
* Added *Silent* command line parameter: -s (Combines -a, -h and -c parameters).
* *Save Macro* dialog will no longer prompt for unchanged projects.
* Fixed Change History not updating after editing an existing command.

## Version 3.5.2

* Added *Play* command line parameter: -p (Activate Hotkeys on start-up).
* Added *AutoPlay* command line parameter: -a*N* (*N* = Number of the Macro to run on start-up).
* Added *Hide* command line parameter: -h (Hide Main Window on start-up).
* Fixed an issue when resizing columns.
* Fixed a syntax error in recorded Click commands.

## Version 3.5.1

* Fixed bug: Variables not working.
* Fixed an issue with *Wait for page to load* function.
* Fixed some glitches in GUI's.

## Version 3.5.0

* Added *unverified* translations to Spanish, German, French, Italian, Russian, Polish, Dutch, Danish, Norwegian, Finnish, Swedish, Czech, Turkish, Hungarian, Bulgarian, Chinese, Japanese and Korean.
* Updated *Internet Explorer* COM functions to allow JavaScript calls via Navigate Method.
* *Stop*, *Speed Up* and *Slow Down* keys are now activated when using *Play Current Macro*.

## Version 3.4.2

* Fixed a bug with *Apply* buttons in the Main Window.
* Fixed a bug with *Duplicate Rows* function.

## Version 3.4.1

* Added Colors to *Loops* and *Statements* rows when Help Marks are activated.
* Added a list to select target window in *Internet Explorer* command window.
* Improved performance of the *Recorder*.

## Version 3.4.0

* Added *Play Current Macro* button to Main Window (run w/o hotkey).
* Added *Timer* button to Main Window (run current macro in a repeated interval).
* Added *Hide/Show Window* in TrayIcon Menu.
* Added *Regular Expression* option to *Find/Replace* window.
* Changed behavior of *Connect* button in *COM Interface (Advanced)* to allow user to select IE or Excel window to connect to.
* *Get* Button of *Internet Explorer* command window can now fetch elements and return the script for *COM Interface (Advanced)* as well.
* Added a help button to the list of functions in *Functions*.
* Fixed some issues with commas inside commands.
* Fixed switched order of *Pause* and *Control* buttons in the main window.
* Added a [FAQ](Faq.html) to the Help file.

## Version 3.3.4

* Added *Evaluate Expression* to *If Statements* list (uses [Eval()](http://www.autohotkey.com/board/topic/15675-monster)).
* Improved performance of *Duplicate* command.
* Fixed some minor issues.
* Revised and reorganized Language files.

## Version 3.3.3

* Fixed Hotkeys not being deactivated when main window was active.
* Fixed a bug with Comments column during saving and paste.

## Version 3.3.2

* Added *Undo/Redo* commands with individual history per Macro.
* Added more options to *Find/Replace* window.
* Added more options to *Multi-Edit* window.
* Added option to show *Loop* and *If Statement* Help Marks in row index.
* Added a message warning about Record/Playback Hotkeys.
* Fixed a bug when closing Macros.
* Fixed an issue with *Break* command inside loops.

## Version 3.3.1

* Added buttons for Cut/Copy/Paste in main window.
* Fixed Manual Key stop working when Auto Key was pressed.
* Fixed an issue with *Break* command not working in the main loop.
* Fixed *A_Index* variable returning wrong value in nested loops.

## Version 3.3.0

* Added checkboxes to Macros rows to disable/enable specific actions.
* Added *Labels* and *Goto* command to *Loop* command Window.
* Added new edit commands: Copy, Cut and Paste.
* Added new *Select* menu.
* Fixed an issue with the InputBox command stopping execution.

## Version 3.2.6

* Fixed an issue that was causing the main window to freeze randomly.
* Added a PayPal Donation link in the menu bar.

## Version 3.2.5

* Added support for Multi-Line commands in COM Interface (Advanced). You can enter a sequence of COM commands in a single Action.
* Fixed an issue with Variables Assignment.

## Version 3.2.4

* Fixed an issue with exported scripts when parsing parameters from COM commands.

## Version 3.2.3

* Added *Connect* button to COM Interface (Advanced): Tries to connect to an Active COM Object.
* Fixed an issue when recording RAlt key in some keyboards.

## Version 3.2.2

* Fixed a bug with COM Interface in playback.
* *Get Button* in Internet Explorer Command window will try to connect to the last IE window instead of creating a new instance.

## Version 3.2.1

* Added more properties to Internet Explorer COM list.
* Fixed error when using IE Elements without index in Internet Explorer commands.
* Fixed some bugs.

## Version 3.2.0

* Added COM Interface support for any application in dotted syntax (IE command window).
* Fixed font size to avoid overlapping on different DPI sizes.
* Fixed some bugs with Variables.

## Version 3.1.0

* Added Internet Explorer command window with IE COM automation commands.
* Words enclosed in percent signs inside variables are no longer dereferenced.
* Changed some icons for better compatibility.
* Fixed some bugs.

## Version 3.0.5

* Added *Pause* and *Set[Caps/Num/Scroll]LockState* commands to Run Command Window.
* Fixed bug when editing Hotkeys in Export Window.

## Version 3.0.4

* Added *Input* and *KeyWait* commands to Run Command Window.

## Version 3.0.3

* Fixed an issue when saving project during Playback.

## Version 3.0.2

* Fixed problem with *Always Active* option.
* Added function to Pause Execution/Recording by Middle-Clicking the TrayIcon.

## Version 3.0.1

* Fixed problem with *Set As Default Hotkeys* option.
* Fixed unpausing when TrayIcon was clicked.

## Version 3.0.0

* Added support for multiple Macros & HotKeys.
* Added support for Functions Assignment.
* Added support for Functions inside command parameters (e.g.: *% SubStr(AHK, 2)*).
* Added support for Math Expressions in Variables Assignment using *Eval()*.
* Added Button to make Hotkeys Window Sensitive (optionally).
* Added option to Keep Hotkeys Active.
* Added Hotkey to Start New Record on a different Tab.
* Added more commands to the Run Window.
* Added option to keep Default Hotkeys.
* Added option to set Default Project File.
* Added option to Pause script with the StopKey.
* StopKey no longer deactivates Hotkeys.
* Playback Speed Buttons will now toggle On/Off.
* New *Import* command in File Menu.
* Fixed some issues with *Loop*, *Break* and *Continue*.
* Added an optional installer for download.
* Help File is now available for download and included in installer.

## Version 2.5.4

* Fixed Settings not being saved on exit.

## Version 2.5.3

* Fixed: Variables not working on some commands.
* Fixed and improved DynamicVars references.
* Fixed some issues with capture/record of Alt keys.

## Version 2.5.2

* Added option record/capture Down & Up state for all keys (it must be activated in options window).
* Fixed some parameters for better working of variables.

## Version 2.5.1

* Added support for Nested Loops in Playback.
* Added support for Dynamic Variables references in Playback (e.g. *% Var%counter%*). Field must start with "% " and must contain only ONE reference.
* Fixed some minor issues.

## Version 2.5.0

* Added new commands to Run Window. It now features also 20 File Commands.
* Added ProcessID (ahk_PID) identifier for Window selections.
* Fixed missing parameters for some commands in exported script.

## Version 2.4.0

* Added new commands: ControlGetPos, Break, Continue & more Window Commands.
* Added shortcuts to Command Windows (F2-F12).
* Added option to include PMC code in exported scripts (import them by opening the ahk file).
* Added option to disable shortcuts in Options (Misc. tab).

## Version 2.3.4

* Fixed: Pressing RButton while recording would send a Left Click down.

## Version 2.3.3

* Fixed: Playback Speed Controls not working for Sleep Commands.

## Version 2.3.2

* Added option to define line width for screenshots.
* Fixed some issues adding Mouse Commands.

## Version 2.3.1

* Added Indentation Option for Preview and Export.
* Fixed/improved some minor things in the script.

## Version 2.3.0

* Fixed and Improved Mouse Recording.
* Modified Wait commands to allow abort waiting in Playback.
* Added option to change Draw Button (to define search/screenshot area).
* Added option to press Enter to take screenshot.
* Added *ConrolSetText*, *ControlGet*, *ControlGetText* and *ControlGetFocus* to *Control Commands* window
* Moved *ControlGetText* from *Variables* window to *Control Commands* window.
* Changed *Start Record* & *Stop Record* keys to *Start/Stop Record* key.

## Version 2.2.2

* Fixed: Sleep commands taking twice the specified time.

## Version 2.2.1

* Fixed some issues with Mouse Recording.

## Version 2.2.0

* Added New Command Window: *Control Commands* with *Control*, *ControlFocus* and *ControlMove*.
* Added *ControlGetText* to *If / Variables* window.
* Fixed *Control, EditPaste* playback error.
* Fixed a bug when setting up a Control Command with a blank control.
* Fixed some other bugs.

## Version 2.1.5

* Added *Control, EditPaste* to send options in Text command window.
* Fixed and Improved Variables Translation in Playback.

## Version 2.1.4

* Changed error message when using ControlSend/Click without the control name to a warning to allow use of control's HWND in window's title.

## Version 2.1.3

* Fixed: Program's hotkeys being triggered when window is not active.
* Fixed: Duplicate hotkey not working properly.

## Version 2.1.2

* Fixed: Playback not matching variables names with less than 4 characters.
* Remove input limits for some edit controls to allow variables.
* *Get Control Button* now auto gets window's class.

## Version 2.1.1

* Added support for Boolean Assignment. Variable must be enclosed in percent signs (e.g. *MyVar := !%MyVar%*).
* Extended the use of variables to the Control and Window columns.
* Fixed: Trying to compare built-in variables would show an error.
* Added more shortcuts (see help window).

## Version 2.1.0

* Added Make Screenshot button to ImageSearch.
* Assign Variables: The *If* button can be used to assign and compare variables.
* Send Variables: Use percent signs in Text command to send variables.
* Show Variables: Use percent signs in MsgBox Prompt option of the Pause menu to show variables values.
* Changed the Post/SendMessage command window to allow the use of any message number.
* Added shortcut to *ListVars* command in File menu.
* Fixed: Wrong window activated when marking search area.
* Fixed: Last window not activated after selection target window for control commands.
* Fixed: No line feed in MsgBox prompt of Pause menu.

## Version 2.0.5

* Fixed syntax problems in Image/Pixel search.

## Version 2.0.4

* Made some minor changes in gui.

## Version 2.0.3

* Updated Graphic Buttons function to work with AHK_L 64bit (thanks to just me)
* Added Auto-execute Section to context help of Export Window.

## Version 2.0.2

* Added NoActivate (NA) option to ControlClick relative to window.
* Fixed PostMessage/SendMessage syntax error in exported scripts.

## Version 2.0.1

* Fixed some issues.

## Version 2.0.0

* Added SearchImage and SearchPixel commands.
* Added some If Statements commands.
* Added SendMessage and PostMessage commands.
* Added KeyWait option in Pause.
* Added Window-Sensitive Hotkey option in Export Menu.
* Added Clipboard Send in Text Command (removed Script option).
* Added option to return Mouse to initial position after playback.
* Added Context-Menu Help: Right-Click on a button or window to show links to AHK Online Help.
* ControlClick can now be used with position in window.
* Improved Mouse and Key Recording reliability.
* Loop now works for Playblack (Nested Loops won't work).
* Control Records can now record Window Title and Classes.
* Fixed: Control Record issues.
* Fixed: Up Keys not being recorded sometimes.
* Fixed: Program consuming too much CPU.
* Fixed some other issues.

## Version 1.6.4

* Added option to create Step-By-Step Macros: Each command of the list will be executed in sequence everytime you press the Hotkey (as in manual playback).

## Version 1.6.3

* Added option to select between Relative and Screen Mouse CoordMode.
* Fixed various issues.

## Version 1.6.2

* Corrected Sintax error in ControlClick.

## Version 1.6.1

* Added some tooltips with help from documentation.
* Added RunWait option in Run Command.

## Version 1.6.0

* Fixed not recording accurate mouse movements and intervals.
* Removed WinWaitActive from Window Recording.

## Version 1.5.3

* Fixed minor issues.

## Version 1.5.2

* Added option to use hotstrings in Export menu.
* Changed exported scripts to normal hotkeys (::) instead of the Hotkey command.
* Added option to select Speed Multiplier.
* Added Process (ahk_exe) identifier for Window selections.

## Version 1.5.1

* Added Playback Speed Control: Fast Forward & Slow Down keys.
* Added WinMove command.
* Fixed WinSet Top not working.

## Version 1.5.0

* Added Join option in Export window: it can append the current macro to another with different hotkeys.
* Added Record Controls Options.
* Added Find/Replace function in Edit Menu (Ctrl+F will open it too if Capture is off).
* Added Hotkeys to move rows: PageUp/PageDown can be used to move rows when Capture is off.
* Fixed an issue with the Hotkey insert box.
* Fixed: Tooltip not showing Previous Step in Manual Playback.
* Changed *Duplicate* behavior: Selected rows will now be duplicated right after the last selected row.

## Version 1.4.2

* Fixed line breaks in exported scripts with Text/Script lines.

## Version 1.4.1

* Fixed an issue with Run command.
* Fixed an issue with delete key when Capture is off.
* Changed AborKey command in export from *Reload* to *ExitApp*.

## Version 1.4.0

* Added Ini Support: Current Settings will be saved on exit.
* Added Click Down/Up record option: It allows movement recording while holding a button (useful for Hand-Drawing).
* Added option to use Key Toggle State to set Relative Recording On/Off.
* Added Timed Interval Recording.
* Fixed: Minimum interval for mouse movement recording.

## Version 1.3.0

* Added Relative Mouse Clicks Recording (Hold CapsLock to record clicks and drags relative to the initial position).
* Added Window Class and Title recording.
* Added Window default delay (can be changed in Options Menu).
* Fixed: Record Mouse Movement bug.

## Version 1.2.1

* Fixed: Modification Keys not updating list correctly.

## Version 1.2.0

* Added Beta Recording Function (settings can be changed in Options Menu).
* Made Mouse Actions editable.
* Changed *Loop* function behavior. It will now automatically create the loop start and end around selected rows.
* Added Icons to ListView.
* Changed default Delay value back to 0 and created a separate value for Mouse Delay. It can be changed in Options Menu.
* Fixed: Holding a modification key would cause a false input.
* Changed Column name *Command* to *Action*.
* Changed File Extension to *pmc* to allow future association with the Macro Creator.

## Version 1.1.0

* Fixed delay for entering combinations with Ctrl, Shift and Alt. Direct input no longer depends on the hotkey box but it can still be used with the Insert button.

## Version 1.0.1

* Changed default AbortKey to F9 because pressing the Ctrl key during execution would interfere with macro.
* Changed default Delay value to 1 for mouse performance reasons.
* Corrected some minor mistakes in guis.