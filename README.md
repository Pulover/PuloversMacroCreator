# Pulover's Macro Creator #

Pulover's Macro Creator is a Free Automation Tool and Script Generator based on AutoHotkey language. It features a large range of automation commands, has a built-in recorder and can capture inputs in its interface. The macros can be executed from the program itself or you can export them to AutoHotkey Script format.

[www.macrocreator.com](http://www.macrocreator.com)

**Current Version:** 5.0.0

### Supported platforms

Windows 7, 8, 8.1, 10

(NOT tested on Windows XP, Vista)

## For developers ##

Source requires the latest version of [AutoHotkey](http://ahkscript.org/) to run.

The source for SciLexer.dll can be found at [fincs/SciTE4AutoHotkey](https://github.com/fincs/SciTE4AutoHotkey).

Installer is created with [Inno Setup](http://www.jrsoftware.org/).

If you need to compile you may run the Compile.ahk script which generates the necessary files locally to create MacroCreator.exe, MacroCreator-x64.exe, MacroCreator_Help.chm and MacroCreator-setup.exe.

To compile you'll need:
* The latest version of Auto-Hotkey installed.
* hhc.exe and hha.dll in Documentation\MacroCreator_Help-doc directory.
* Inno Setup (5.5.2 or higher) installed.

Notes:
* Execute MacroCreator.ahk at least once to create the .ini file with the current version. You might need to copy it from %AppData% to the script folder.
* Language files may be edited in Languages.xls. Run ExtractLangFiles.ahk to create the .lang files in the Lang directory.

