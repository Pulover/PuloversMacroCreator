SyHi_Com =
(
#allowsamelinecomments #clipboardtimeout #commentflag #errorstdout #escapechar #hotkeyinterval
#hotkeymodifiertimeout #hotstring #if #iftimeout #ifwinactive #ifwinexist #include #includeagain
#inputlevel #installkeybdhook #installmousehook #keyhistory #ltrim #maxhotkeysperinterval #maxmem
#maxthreads #maxthreadsbuffer #maxthreadsperhotkey #menumaskkey #noenv #notrayicon #persistent
#singleinstance #usehook #warn #winactivateforce autotrim blockinput break catch click clipwait
continue control controlclick controlfocus controlget controlgetfocus controlgetpos controlgettext
controlmove controlsend controlsendraw controlsettext coordmode critical detecthiddentext
detecthiddenwindows drive driveget drivespacefree edit else endrepeat envadd envdiv envget envmult
envset envsub envupdate exit exitapp fileappend filecopy filecopydir filecreatedir
filecreateshortcut filedelete fileencoding filegetattrib filegetshortcut filegetsize filegettime
filegetversion fileinstall filemove filemovedir fileread filereadline filerecycle filerecycleempty
fileremovedir fileselectfile fileselectfolder filesetattrib filesettime for formattime getkeystate
gosub goto groupactivate groupadd groupclose groupdeactivate gui guicontrol guicontrolget
hideautoitwin hotkey if ifequal ifexist ifgreater ifgreaterorequal ifinstring ifless iflessorequal
ifmsgbox ifnotequal ifnotexist ifnotinstring ifwinactive ifwinexist ifwinnotactive ifwinnotexist
imagesearch inidelete iniread iniwrite input inputbox inputlevel keyhistory keywait listhotkeys
listlines listvars loop menu mouseclick mouseclickdrag mousegetpos mousemove msgbox onexit
outputdebug pause pixelgetcolor pixelsearch postmessage process progress random regdelete regread
regwrite reload repeat return run runas runwait send sendevent sendinput sendlevel sendmessage sendmode
sendplay sendraw setbatchlines setcapslockstate setcontroldelay setdefaultmousespeed setenv
setformat setkeydelay setmousedelay setnumlockstate setregview setscrolllockstate setstorecapslockmode
settimer settitlematchmode setwindelay setworkingdir shutdown sleep sort soundbeep soundget
soundgetwavevolume soundplay soundset soundsetwavevolume splashimage splashtextoff splashtexton
splitpath statusbargettext statusbarwait stringcasesense stringgetpos stringleft stringlen
stringlower stringmid stringreplace stringright stringsplit stringtrimleft stringtrimright
stringupper suspend sysget thread throw tooltip transform traytip try until urldownloadtofile while
winactivate winactivatebottom winclose winget wingetactivestats wingetactivetitle wingetclass
wingetpos wingettext wingettitle winhide winkill winmaximize winmenuselectitem winminimize
winminimizeall winminimizeallundo winmove winrestore winset winsettitle winshow winwait
winwaitactive winwaitclose winwaitnotactive
)

SyHi_Fun =
(
_addref _clone _getaddress _getcapacity _insert _maxindex _minindex _newenum _release _remove
_setcapacity abs acos array asc asin atan ceil chr comobjactive comobjarray comobjconnect
comobjcreate comobjenwrap comobjerror comobjflags comobjget comobjmissing comobjparameter
comobjquery comobjtype comobjunwrap comobjvalue cos dllcall exp fileexist fileopen floor func
getaddress getcapacity getkeyname getkeysc getkeystate getkeyvk haskey il_add il_create il_destroy
insert instr isbyref isfunc islabel isobject ln log ltrim lv_add lv_delete lv_deletecol lv_getcount
lv_getnext lv_gettext lv_insert lv_insertcol lv_modify lv_modifycol lv_setimagelist maxindex
minindex mod newenum next numget numput objaddref objclone object objgetaddress objgetcapacity
objinsert objmaxindex objminindex objnewenum objrelease objremove objsetcapacity onmessage
processpath rawread rawwrite readline regexmatch regexreplace registercallback remove round rtrim
sb_seticon sb_setparts sb_settext seek setcapacity sin sqrt strget strlen strput substr tan tell
trim tv_add tv_delete tv_get tv_getchild tv_getcount tv_getnext tv_getparent tv_getprev
tv_getselection tv_gettext tv_modify varsetcapacity varsetcapcity winactive winexist write writeline
)

SyHi_Param =
(
abort abovenormal activex add ahk_class ahk_group ahk_id ahk_pid all alnum alpha altsubmit alttab
alttabandmenu alttabmenu alttabmenudismiss alwaysontop and astr ateof autosize background
backgroundtrans base belownormal between bitand bitnot bitor bitshiftleft bitshiftright bitxor bold
border bottom bottom button buttons byref cancel cancel capacity caption caret center center char
charp check check3 checkbox checked checkedgray choose choosestring class clone close color
combobox contains controllist controllisthwnd count custom date datetime days ddl default delete
deleteall delimiter deref destroy digit disable disabled double doublep dropdownlist edit eject
enable enabled encoding error exist exit expand exstyle filesystem first flash float float floatp
focus font force fromcodepage global grid group groupbox guiclose guicontextmenu guidropfiles
guiescape guisize hdr hidden hide high hkcc hkcr hkcu hkey_classes_root hkey_current_config
hkey_current_user hkey_local_machine hkey_users hklm hku hotkey hours hscroll hwnd icon iconsmall
id idlast ignore imagelist in int int64 int64p integer integerfast interrupt intp is italic join
label lastfound lastfoundexist left length limit lines list listbox listview local
localsameasglobal lock logoff low lower lowercase ltrim mainwindow margin maximize maximizebox menu
minimize minimizebox minmax minutes monitorcount monitorname monitorprimary monitorworkarea
monthcal mouse mousemove mousemoveoff move multi na no noactivate nodefault nohide noicon
nomainwindow norm normal nosort nosorthdr nostandard not notab notimers number number off ok on or
owndialogs owner parse password password pic picture pid pixel pos pow priority processname
progress ptr radio range read readonly realtime redraw reg_binary reg_dword reg_dword_big_endian
reg_expand_sz reg_full_resource_descriptor reg_link reg_multi_sz reg_qword reg_resource_list
reg_resource_requirements_list reg_sz regex region relative reload rename report resize restore
retry rgb right rtrim screen seconds section section send sendandmouse serial setlabel shiftalttab
short shortp show shutdown single slider sortdesc standard static status statusbar statuscd str
strike style submit sysmenu tab tab2 tabstop text text theme tile time tip tocodepage togglecheck
toggleenable toolwindow top top topmost transcolor transparent tray treeview type uchar ucharp uint
uint64 uint64p uintp uncheck underline unicode unlock updown upper uppercase useerrorlevel
useunsetglobal useunsetlocal ushort ushortp vis visfirst visible vscroll wait waitclose wantctrla
wantf2 wantreturn wanttab wrap wstr xdigit xm xp xs yes ym yp ys
)

SyHi_BIVar =
(
a_ahkpath a_ahkversion a_appdata a_appdatacommon a_autotrim a_batchlines a_caretx
a_carety a_computername a_controldelay a_cursor a_dd a_ddd a_dddd a_defaultmousespeed
a_desktop a_desktopcommon a_detecthiddentext a_detecthiddenwindows a_endchar a_eventinfo
a_exitreason a_formatfloat a_fileencoding a_formatinteger a_gui a_guicontrol a_guicontrolevent
a_guievent a_guiheight a_guiwidth a_guix a_guiy a_hour a_iconfile a_iconhidden a_iconnumber a_icontip
a_index a_ipaddress1 a_ipaddress2 a_ipaddress3 a_ipaddress4 a_is64bitos a_isadmin a_iscompiled
a_iscritical a_ispaused a_issuspended a_isunicode a_keydelay a_language a_lasterror a_linefile
a_linenumber a_loopfield a_loopfileattrib a_loopfiledir a_loopfileext a_loopfilefullpath
a_loopfilelongpath a_loopfilename a_loopfileshortname a_loopfileshortpath a_loopfilesize
a_loopfilesizekb a_loopfilesizemb a_loopfiletimeaccessed a_loopfiletimecreated a_loopfiletimemodified
a_loopreadline a_loopregkey a_loopregname a_loopregsubkey a_loopregtimemodified a_loopregtype a_mday
a_min a_mm a_mmm a_mmmm a_mon a_mousedelay a_msec a_mydocuments a_now a_nowutc a_numbatchlines a_ostype
a_osversion a_priorhotkey a_priorkey a_programfiles a_programs a_programscommon a_ptrsize a_regview
a_screendpi a_screenheight a_screenwidth a_scriptdir a_scriptfullpath a_scriptname a_sec a_space
a_startmenu a_startmenucommon a_startup a_startupcommon a_stringcasesense a_tab a_temp a_thisfunc
a_thishotkey a_thislabel a_thismenu a_thismenuitem a_thismenuitempos a_tickcount a_timeidle
a_timeidlephysical a_timesincepriorhotkey a_timesincethishotkey a_titlematchmode a_titlematchmodespeed
a_username a_wday a_windelay a_windir a_workingdir a_yday a_year a_yweek a_yyyy clipboard clipboardall
comspec errorlevel false programfiles true
)

SyHi_Keys =
(
alt altdown altup appskey backspace blind browser_back browser_favorites browser_forward
browser_home browser_refresh browser_search browser_stop bs capslock click control ctrl ctrlbreak
ctrldown ctrlup del delete down end enter esc escape f1 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f2
f20 f21 f22 f23 f24 f3 f4 f5 f6 f7 f8 f9 home ins insert joy1 joy10 joy11 joy12 joy13 joy14 joy15
joy16 joy17 joy18 joy19 joy2 joy20 joy21 joy22 joy23 joy24 joy25 joy26 joy27 joy28 joy29 joy3 joy30
joy31 joy32 joy4 joy5 joy6 joy7 joy8 joy9 joyaxes joybuttons joyinfo joyname joypov joyr joyu joyv
joyx joyy joyz lalt launch_app1 launch_app2 launch_mail launch_media lbutton lcontrol lctrl left
lshift lwin lwindown lwinup mbutton media_next media_play_pause media_prev media_stop numlock
numpad0 numpad1 numpad2 numpad3 numpad4 numpad5 numpad6 numpad7 numpad8 numpad9 numpadadd
numpadclear numpaddel numpaddiv numpaddot numpaddown numpadend numpadenter numpadhome numpadins
numpadleft numpadmult numpadpgdn numpadpgup numpadright numpadsub numpadup pause pgdn pgup
printscreen ralt raw rbutton rcontrol rctrl right rshift rwin rwindown rwinup scrolllock shift
shiftdown shiftup space tab up volume_down volume_mute volume_up wheeldown wheelleft wheelright
wheelup xbutton1 xbutton2
)
