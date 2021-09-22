# Pulover's Macro Creator

Pulover's Macro Creator is a Free Automation Tool and Script Generator based on AutoHotkey language. It features a large range of automation commands, has a built-in recorder and can capture inputs in its interface. The macros can be executed from the program itself or you can export them to AutoHotkey Script format.

[www.macrocreator.com](https://www.macrocreator.com)

**Current Version:** 5.4.1

### Supported platforms

Windows 7, 8, 8.1, 10

(NOT tested on Windows XP, Vista)

## Translations

You can make corrections to the Interface Language translations inside the application itself (Settings > Language editor).

You can submit your corrections or new translations from there too.

To translate the help file, use *Documentation\MacroCreator_Help.ahk* and the .md files in there.

Follow the compile instructions below to create a chm file.

The application is prepared to recognize a help file in the same directory of MacroCreator.exe, if named according to the .lang file of the currently selected language. For example, if the help file is for Chinese Simplified it must be named *MacroCreator_Help_Zh_CN.chm* or *MacroCreator_Help_Zh.chm*.

## Compile Instructions

Source requires the latest version of [AutoHotkey](https://www.autohotkey.com/) to run.

The source for SciLexer.dll can be found at [fincs/SciTE4AutoHotkey](https://github.com/fincs/SciTE4AutoHotkey).

The source for tesseract.exe can be found at [tesseract-ocr/tesseract](https://github.com/tesseract-ocr/tesseract).

Installer is created with [Inno Setup 6](https://jrsoftware.org/).

If you need to compile you may run the *Compile.ahk* script which generates the necessary files locally to create *MacroCreator.exe*, *MacroCreator-x64.exe*, *MacroCreator_Help.chm* and *MacroCreator-setup.exe*.

To compile you'll need:
* The latest version of AutoHotkey installed.
* Optional: upx.exe inside AutoHotkey's Compiler subfolder, in its installation folder (this can be changed in Compile.ahk).
* hhc.exe and hha.dll in *Documentation\MacroCreator_Help-doc* directory.
* Inno Setup 6 installed.

Notes:
* Execute *MacroCreator.ahk* at least once to create the .ini file with the current version. You might need to copy it from %AppData% to the script folder.
* Setup and Help project files are maintained and created by *BuildFiles.ahk*.
* Language files may be edited in Languages.xls. Run ExtractLangFiles.ahk to create the .lang files in the Lang directory.

