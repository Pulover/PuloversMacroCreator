# Pulover's Macro Creator #

Pulover's Macro Creator is a Free Automation and Script Writting Tool with a graphic interface, based on AutoHotkey language. It features a large range of automation commands, has a built-in recorder and can capture inputs in its interface. The macros can be executed from the program itself or you can export them to AutoHotkey Script format.

http://www.autohotkey.net/~Pulover

**Version 4 development branch**

## For developers ##

Source requires the latest version of [AutoHotkey](http://l.autohotkey.net/) to run.

Installer is created with [Inno Setup](http://www.jrsoftware.org/).

If you need to compile you may run the Compile.ahk script which generates the necessary files locally to create MacroCreator.exe, MacroCreator-x64.exe, MacroCreator_Help.chm and MacroCreator-setup.exe.

To compile you'll need:
* mpress.exe in %ProgramFiles%\AutoHotkey\Compiler directory.
* hhc.exe and hha.dll in Documentation\MacroCreator_Help-doc directory.
* Inno Setup (5.5.2 or higher) installed.

Note: Execute MacroCreator.ahk at least once to create the .ini file with the current version.

Language files should be edited in Languages.xls. Run ExtractLangFiles.ahk to create the .Lang files in the Lang directory.

