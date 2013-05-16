;##### Inno Setup #####

AutoTrim, Off
IniRead, PMCVer, MacroCreator.ini, Application, Version
If PMCVer = Error
{
	MsgBox, 0, Error!, INI file is missing!
	return
}

Script =
(
#define PmcName "Pulover's Macro Creator"
#define PmcVersion "%PMCVer%"
#define PmcCompany "Rodolfo U. Batista"
#define PmcURL "http://www.autohotkey.net/~Pulover"
#define PmcCopyright "(C) 2012-2013 Rodolfo U. Batista"
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
DefaultDirName={pf}\MacroCreator
DefaultGroupName={#PmcName}
AllowNoIcons=yes
LicenseFile={#WorkDir}\License.txt
OutputDir={#WorkDir}\Compiled
OutputBaseFilename=MacroCreator-setup
WizardImageFile={#WorkDir}\Images\SetupLogo.bmp
Compression=lzma
SolidCompression=yes
ChangesAssociations=yes
ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "catalan"; MessagesFile: "compiler:Languages\Catalan.isl"
Name: "czech"; MessagesFile: "compiler:Languages\Czech.isl"
Name: "danish"; MessagesFile: "compiler:Languages\Danish.isl"
Name: "dutch"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "finnish"; MessagesFile: "compiler:Languages\Finnish.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "greek"; MessagesFile: "compiler:Languages\Greek.isl"
Name: "hebrew"; MessagesFile: "compiler:Languages\Hebrew.isl"
Name: "hungarian"; MessagesFile: "compiler:Languages\Hungarian.isl"
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"
Name: "norwegian"; MessagesFile: "compiler:Languages\Norwegian.isl"
Name: "polish"; MessagesFile: "compiler:Languages\Polish.isl"
Name: "portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "serbiancyrillic"; MessagesFile: "compiler:Languages\SerbianCyrillic.isl"
Name: "serbianlatin"; MessagesFile: "compiler:Languages\SerbianLatin.isl"
Name: "slovenian"; MessagesFile: "compiler:Languages\Slovenian.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "ukrainian"; MessagesFile: "compiler:Languages\Ukrainian.isl"

[Tasks]
Name: "install64bit"; Description: "{cm:NameAndVersion,[{#PmcExeName}],{#PmcVersion} - 64-bit (x64)}"; Flags: exclusive unchecked; Check: Is64BitInstallMode
Name: "install32bit"; Description: "{cm:NameAndVersion,[{#PmcExeName}],{#PmcVersion} - 32-bit (x86)}"; Flags: exclusive unchecked
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1
Name: pmcAssociation; Description: "{cm:AssocFileExtension,{#PmcName},""{#PmcExt}""}"; GroupDescription: File extensions:

[Registry]
Root: HKCR; Subkey: ".{#PmcExt}"; ValueType: string; ValueName: ""; ValueData: "MacroCreatorFile"; Flags: uninsdeletevalue; Tasks: pmcAssociation
Root: HKCR; Subkey: "MacroCreatorFile"; ValueType: string; ValueName: ""; ValueData: "Macro Creator File"; Flags: uninsdeletekey; Tasks: pmcAssociation
Root: HKCR; Subkey: "MacroCreatorFile\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\MacroCreator.exe,0"; Tasks: pmcAssociation
Root: HKCR; Subkey: "MacroCreatorFile\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\MacroCreator.exe"" ""`%1"""; Tasks: pmcAssociation

[Files]
Source: "{#WorkDir}\Compiled\MacroCreator-x64.exe"; DestDir: "{app}"; DestName: "MacroCreator.exe"; Flags: ignoreversion; Tasks: install64bit
Source: "{#WorkDir}\Compiled\MacroCreator.exe"; DestDir: "{app}"; DestName: "MacroCreator.exe"; Flags: ignoreversion; Tasks: install32bit
Source: "{#WorkDir}\Compiled\MacroCreator_Help.chm"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{#PmcName}"; Filename: "{app}\{#PmcExeName}"
Name: "{group}\{cm:ProgramOnTheWeb,{#PmcName}}"; Filename: "{#PmcURL}"
Name: "{group}\{cm:UninstallProgram,{#PmcName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#PmcName}"; Filename: "{app}\{#PmcExeName}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#PmcName}"; Filename: "{app}\{#PmcExeName}"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\{#PmcExeName}"; Description: "{cm:LaunchProgram,{#StringChange(PmcName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

)

FileDelete, Installer.iss
FileAppend, %Script%, Installer.iss

;##### Help Project Files #####

Head =
(
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<HTML>
<HEAD>
<meta name="GENERATOR" content="Microsoft&reg; HTML Help Workshop 4.1">
<!-- Sitemap 1.0 -->
</HEAD><BODY>
)

Head2 =
(
<OBJECT type="text/site properties">
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
Loop, %A_ScriptDir%\Documentation\MacroCreator_Help-doc\*.html, 0, 0
{
	IfInString, A_LoopFileName, License
		Continue
	FileReadLine, Title, %A_LoopFileFullPath%, 5
	Title := RegExReplace(Title, "U)<.*>")
	Location := A_LoopFileFullPath
thisline =
(
	`t<LI><OBJECT type="text/sitemap">
		<param name="Name" value="%Title%">
		<param name="Local" value="%Location%">
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
Binary TOC=Yes
Compatibility=1.1 or later
Compiled file=%A_ScriptDir%\Documentation\MacroCreator_Help-doc\MacroCreator_Help.chm
Contents file=%A_ScriptDir%\Documentation\MacroCreator_Help-doc\MacroCreator_Help.hhc
Default Font=Arial,8,0
Default Window=GlavniWintype
Default topic=%A_ScriptDir%\Documentation\MacroCreator_Help-doc\index.html
Display compile progress=Yes
Enhanced decompilation=Yes
Full-text search=Yes
Index file=%A_ScriptDir%\Documentation\MacroCreator_Help-doc\MacroCreator_Help.hhk
Language=0x409 English_United_States
Title=Pulover's Macro Creator Help

[WINDOWS]
GlavniWintype=,"%A_ScriptDir%\Documentation\MacroCreator_Help-doc\MacroCreator_Help.hhc","%A_ScriptDir%\Documentation\MacroCreator_Help-doc\MacroCreator_Help.hhk","%A_ScriptDir%\Documentation\MacroCreator_Help-doc\index.html",,,,,,0x23520,,0x387e,,,,,,,,0


[FILES]
%A_ScriptDir%\Documentation\MacroCreator_Help-doc\index.html
%A_ScriptDir%\Documentation\MacroCreator_Help-doc\License.html
%A_ScriptDir%\Documentation\MacroCreator_Help-doc\p0-Faq.html
%A_ScriptDir%\Documentation\MacroCreator_Help-doc\p1-Main.html
%A_ScriptDir%\Documentation\MacroCreator_Help-doc\p2-Record.html
%A_ScriptDir%\Documentation\MacroCreator_Help-doc\p3-Playback.html
%A_ScriptDir%\Documentation\MacroCreator_Help-doc\p4-Commands.html
%A_ScriptDir%\Documentation\MacroCreator_Help-doc\p5-Export.html
%A_ScriptDir%\Documentation\MacroCreator_Help-doc\p6-Preview.html
%A_ScriptDir%\Documentation\MacroCreator_Help-doc\p7-Settings.html
%A_ScriptDir%\Documentation\MacroCreator_Help-doc\p8-Variables.html
%A_ScriptDir%\Documentation\MacroCreator_Help-doc\p9-About.html
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

Loop, %A_ScriptDir%\Documentation\MacroCreator_Help-doc\Commands\*.html, 0, 0
{
	FileReadLine, Title, %A_LoopFileFullPath%, 5
	Title := RegExReplace(Title, "U)<.*>")
	Location := A_LoopFileFullPath
thisline =
(
	`t`t<LI> <OBJECT type="text/sitemap">
			<param name="Name" value="%Title%">
			<param name="Local" value="%Location%">
			</OBJECT>

)
	HHC .= thisline, HHK .= thisline
}

HHC .= "`t</UL>`n", HHK .= "`t</UL>`n"
return

