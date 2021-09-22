#NoEnv
SetWorkingDir %A_ScriptDir%

;##### Inno Setup #####

AutoTrim, Off
IniRead, PMCVer, MacroCreator.ini, Application, Version
If (PMCVer = "Error")
{
	MsgBox, 0, Error!, INI file is missing!
	ExitApp, 2
}
FileDelete, Compiled\MacroCreator.ini
IniWrite, %PMCVer%, Compiled\MacroCreator.ini, Application, Version

IfExist, Compiled\MacroCreator_Help_zh.chm
	CNHelp := "Source: ""{#WorkDir}\Compiled\MacroCreator_Help_zh.chm""`; DestDir: ""{app}""`; Flags: ignoreversion"
Else IfExist, Compiled\MacroCreator_Help_zh_CN.chm
	CNHelp := "Source: ""{#WorkDir}\Compiled\MacroCreator_Help_zh_CN.chm""`; DestDir: ""{app}""`; Flags: ignoreversion"

Script =
(
#define PmcName "Pulover's Macro Creator"
#define PmcVersion "%PMCVer%"
#define PmcCompany "Cloversoft Serviços de Informática Ltda"
#define PmcURL "https://www.macrocreator.com"
#define PmcCopyright "Copyright (C) 2012-2021 Cloversoft Serviços de Informática Ltda"
#define PmcExeName "MacroCreator.exe"
#define PmcExt "pmc"
#define WorkDir "%A_ScriptDir%"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{223FFB42-2D49-4AF6-9EF2-82B7D0CAF8B4}
AppName={#PmcName}
AppVersion={#PmcVersion}
VersionInfoVersion={#PmcVersion}
;AppVerName={#PmcName} {#PmcVersion}
AppPublisher={#PmcCompany}
AppPublisherURL={#PmcURL}
AppCopyright={#PmcCopyright}
AppSupportURL={#PmcURL}
AppUpdatesURL={#PmcURL}
WizardStyle=modern
DisableWelcomePage=no
DefaultDirName={commonpf}\MacroCreator
DefaultGroupName={#PmcName}
AllowNoIcons=yes
LicenseFile={#WorkDir}\License.txt
OutputDir={#WorkDir}\Compiled
OutputBaseFilename=MacroCreator-setup
WizardImageFile={#WorkDir}\Resources\SetupLogo.bmp
WizardSmallImageFile={#WorkDir}\Resources\SetupIcon.bmp
Compression=lzma
SolidCompression=yes
ChangesAssociations=yes
ArchitecturesInstallIn64BitMode=x64
Uninstallable=not WizardIsTaskSelected('portableinstall')

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "armenian"; MessagesFile: "compiler:Languages\Armenian.isl"
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "catalan"; MessagesFile: "compiler:Languages\Catalan.isl"
Name: "corsican"; MessagesFile: "compiler:Languages\Corsican.isl"
Name: "czech"; MessagesFile: "compiler:Languages\Czech.isl"
Name: "danish"; MessagesFile: "compiler:Languages\Danish.isl"
Name: "dutch"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "finnish"; MessagesFile: "compiler:Languages\Finnish.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "hebrew"; MessagesFile: "compiler:Languages\Hebrew.isl"
Name: "icelandic"; MessagesFile: "compiler:Languages\Icelandic.isl"
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"
Name: "norwegian"; MessagesFile: "compiler:Languages\Norwegian.isl"
Name: "polish"; MessagesFile: "compiler:Languages\Polish.isl"
Name: "portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "slovak"; MessagesFile: "compiler:Languages\Slovak.isl"
Name: "slovenian"; MessagesFile: "compiler:Languages\Slovenian.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "turkish"; MessagesFile: "compiler:Languages\Turkish.isl"
Name: "ukrainian"; MessagesFile: "compiler:Languages\Ukrainian.isl"

[Tasks]
Name: "install64bit"; Description: "{cm:NameAndVersion,[{#PmcExeName}],{#PmcVersion} - 64-bit (x64)}"; Flags: exclusive unchecked; Check: Is64BitInstallMode
Name: "install32bit"; Description: "{cm:NameAndVersion,[{#PmcExeName}],{#PmcVersion} - 32-bit (x86)}"; Flags: exclusive unchecked
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1
Name: "pmcAssociation"; Description: "{cm:AssocFileExtension,{#PmcName},""{#PmcExt}""}"; GroupDescription: File extensions:
Name: "portableinstall"; Description: "Don't use `%AppData`%. Settings will be saved in the installation folder."; GroupDescription: "Portable Install:"; Flags: unchecked

[Registry]
Root: HKCR; Subkey: ".{#PmcExt}"; ValueType: string; ValueName: ""; ValueData: "MacroCreatorFile"; Flags: uninsdeletevalue; Tasks: pmcAssociation
Root: HKCR; Subkey: "MacroCreatorFile"; ValueType: string; ValueName: ""; ValueData: "Macro Creator File"; Flags: uninsdeletekey; Tasks: pmcAssociation
Root: HKCR; Subkey: "MacroCreatorFile\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\MacroCreator.exe,0"; Tasks: pmcAssociation
Root: HKCR; Subkey: "MacroCreatorFile\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\MacroCreator.exe"" ""`%1"""; Tasks: pmcAssociation

[Files]
Source: "{#WorkDir}\Compiled\MacroCreator-x64.exe"; DestDir: "{app}"; DestName: "MacroCreator.exe"; Flags: ignoreversion; Tasks: install64bit
Source: "{#WorkDir}\Compiled\MacroCreator.exe"; DestDir: "{app}"; DestName: "MacroCreator.exe"; Flags: ignoreversion; Tasks: install32bit
Source: "{#WorkDir}\Compiled\SciLexer-x64.dll"; DestDir: "{app}"; DestName: "SciLexer.dll"; Flags: ignoreversion; Tasks: install64bit
Source: "{#WorkDir}\Compiled\SciLexer-x86.dll"; DestDir: "{app}"; DestName: "SciLexer.dll"; Flags: ignoreversion; Tasks: install32bit
Source: "{#WorkDir}\Compiled\MacroCreator.ini"; DestDir: "{app}"; Flags: ignoreversion; Tasks: portableinstall
Source: "{#WorkDir}\Compiled\Resources.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#WorkDir}\Compiled\MacroCreator_Help.chm"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#WorkDir}\Compiled\Lang\*.lang"; DestDir: "{userappdata}\MacroCreator\Lang"; Flags: ignoreversion; Tasks: not portableinstall
Source: "{#WorkDir}\Compiled\Lang\*.lang"; DestDir: "{app}\Lang"; Flags: ignoreversion; Tasks: portableinstall
Source: "{#WorkDir}\Compiled\Demo.pmc"; DestDir: "{userappdata}\MacroCreator"; Flags: ignoreversion; Tasks: not portableinstall
Source: "{#WorkDir}\Compiled\Demo.pmc"; DestDir: "{app}"; Flags: ignoreversion; Tasks: portableinstall
Source: "{#WorkDir}\Bin\leptonica_util\*.*"; DestDir: "{app}\Bin\leptonica_util"; Flags: ignoreversion
Source: "{#WorkDir}\Bin\tesseract\tesseract.exe"; DestDir: "{app}\Bin\tesseract"; Flags: ignoreversion
Source: "{#WorkDir}\Bin\tesseract\tessdata_best\eng.traineddata"; DestDir: "{app}\Bin\tesseract\tessdata_best"; Flags: ignoreversion; Tasks: portableinstall
Source: "{#WorkDir}\Bin\tesseract\tessdata_fast\eng.traineddata"; DestDir: "{app}\Bin\tesseract\tessdata_fast"; Flags: ignoreversion; Tasks: portableinstall
Source: "{#WorkDir}\Bin\tesseract\tessdata_best\eng.traineddata"; DestDir: "{userappdata}\MacroCreator\Bin\tesseract\tessdata_best"; Flags: ignoreversion; Tasks: not portableinstall
Source: "{#WorkDir}\Bin\tesseract\tessdata_fast\eng.traineddata"; DestDir: "{userappdata}\MacroCreator\Bin\tesseract\tessdata_fast"; Flags: ignoreversion; Tasks: not portableinstall
%CNHelp%
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{#PmcName}"; Filename: "{app}\{#PmcExeName}"
Name: "{group}\{cm:ProgramOnTheWeb,{#PmcName}}"; Filename: "{#PmcURL}"
Name: "{group}\{cm:UninstallProgram,{#PmcName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#PmcName}"; Filename: "{app}\{#PmcExeName}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#PmcName}"; Filename: "{app}\{#PmcExeName}"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\{#PmcExeName}"; Description: "{cm:LaunchProgram,{#StringChange(PmcName, '&', '&&')}}"; Flags: nowait postinstall

[InstallDelete]
Type: "filesandordirs"; Name: "{app}\Lang"; Tasks: not portableinstall

[UninstallDelete]
Type: "filesandordirs"; Name: "{userappdata}\MacroCreator"



)

FileDelete, Installer.iss
FileAppend, %Script%, Installer.iss

;##### Help Project Files #####

HelpIndex := "index.html`n"
Loop, Read, %A_ScriptDir%\Documentation\MacroCreator_Help.ahk
	If (RegExMatch(A_LoopReadLine, "`tFilename: (.*)", Page)=1)
		HelpIndex .= Page1 ".html`n"
HelpIndex := RTrim(HelpIndex, "`n")

Head =
(
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<HTML>
<BODY>
)

Head2 =
(
<OBJECT type="text/site properties">
	<param name="Window Styles" value="0x800025">
	<param name="ImageType" value="Folder">
</OBJECT>
)

Head3 =
(

<UL>

)

Foot =
(
</UL>
</BODY></HTML>
)


HHC := Head . Head2 . Head3, HHK := Head . Head3
Loop, Parse, HelpIndex, `n
{
	FileReadLine, Title, %A_ScriptDir%\Documentation\MacroCreator_Help-doc\%A_LoopField%, 5
	Title := RegExReplace(Title, "U)<.*>")
thisline =
(
	`t<LI><OBJECT type="text/sitemap">
		<param name="Name" value="%Title%">
		<param name="Local" value="%A_LoopField%">
		</OBJECT>

)
	HHC .= thisline, HHK .= thisline
	If (Title = "Command Windows")
		GoSub, AddCmd
}

HHC .= Foot, HHK .= Foot

HHP =
(
[OPTIONS]
Auto Index=Yes
Binary Index=No
Compatibility=1.1 or later
Compiled file=MacroCreator_Help.chm
Contents file=MacroCreator_Help.hhc
Default Font=Arial,8,0
Default Window=GlavniWintype
Default topic=index.html
Display compile progress=Yes
Full-text search=Yes
Index file=MacroCreator_Help.hhk
Language=0x409 English (United States)
Title=Pulover's Macro Creator Help

[WINDOWS]
GlavniWintype="Pulover's Macro Creator Help","MacroCreator_Help.hhc","MacroCreator_Help.hhk","index.html","index.html",,,,,0x63520,,0x200e,[200,0,1080,700],,,,,,,0


[FILES]
%HelpIndex%
License.html
)

FileDelete, Documentation\MacroCreator_Help-doc\MacroCreator_Help.hhc
FileDelete, Documentation\MacroCreator_Help-doc\MacroCreator_Help.hhk
FileDelete, Documentation\MacroCreator_Help-doc\MacroCreator_Help.hhp
FileAppend, %HHC%, Documentation\MacroCreator_Help-doc\MacroCreator_Help.hhc
FileAppend, %HHK%, Documentation\MacroCreator_Help-doc\MacroCreator_Help.hhk
FileAppend, %HHP%, Documentation\MacroCreator_Help-doc\MacroCreator_Help.hhp

ExitApp

AddCmd:
HHC .= "`t<UL>`n"

Loop, Files, %A_ScriptDir%\Documentation\MacroCreator_Help-doc\Commands\*.html
{
	FileReadLine, Title, %A_LoopFileFullPath%, 5
	Title := RegExReplace(Title, "U)<.*>")
thisline =
(
	`t`t<LI> <OBJECT type="text/sitemap">
			<param name="Name" value="%Title%">
			<param name="Local" value="Commands\%A_LoopFileName%">
			</OBJECT>

)
	HHC .= thisline, HHK .= thisline
}

HHC .= "`t</UL>`n", HHK .= "`t</UL>`n"
return

