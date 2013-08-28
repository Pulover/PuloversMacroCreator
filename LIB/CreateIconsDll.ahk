;=======================================================================================
;
; Function:      CreateIconsDll
; Description:   Creates an Icon Resources Dll from ico files in a folder.
;
; Author:        Pulover [Rodolfo U. Batista] (rodolfoub@gmail.com)
; Credits:       DllCreateEmpty() by SKAN
;                ReplaceIcon() based on ReplaceAhkIcon() by fincs
;
;=======================================================================================
;
; Usage example:
;
;    CreateIconsDll("MyDll.dll", "C:\MyIcons")
;
;=======================================================================================

CreateIconsDll(File, Folder)
{
    IfNotExist, %File%
        DllCreateEmpty(File)

    Index := 1, Counter := 0
    module := DllCall("BeginUpdateResource", "str", File, "uint", 0, "ptr")
    Loop, %Folder%\*.ico
    {
        Counter++, Index := ReplaceIcon(module, A_LoopFileLongPath, Index)
        If Counter = 40
        {
            DllCall("EndUpdateResource", "ptr", module, "uint", 0)
        ,   module := DllCall("BeginUpdateResource", "str", File, "uint", 0, "ptr")
        ,   Counter := 0
        }
    }
    DllCall("EndUpdateResource", "ptr", module, "uint", 0)
    return Index - 1
}

ReplaceIcon(re, IcoFile, iconID)
{
    f := FileOpen(IcoFile, "r")
    if !IsObject(f)
        return false
    
    VarSetCapacity(igh, 8), f.RawRead(igh, 6)
    if NumGet(igh, 0, "UShort") != 0 || NumGet(igh, 2, "UShort") != 1
        return false
    
    wCount := NumGet(igh, 4, "UShort")
    
,   VarSetCapacity(rsrcIconGroup, rsrcIconGroupSize := 6 + wCount*14)
,   NumPut(NumGet(igh, "Int64"), rsrcIconGroup, "Int64") ; fast copy
    
,   ige := &rsrcIconGroup + 6
    
    Loop, %wCount%
    {
        thisID := (iconID-1) + A_Index
        
    ,   f.RawRead(ige+0, 12) ; read all but the offset
    ,   NumPut(thisID, ige+12, "UShort")
    ,   imgOffset := f.ReadUInt()
    ,   oldPos := f.Pos
    ,   f.Pos := imgOffset
        
    ,   VarSetCapacity(iconData, iconDataSize := NumGet(ige+8, "UInt"))
    ,   f.RawRead(iconData, iconDataSize)
    ,   f.Pos := oldPos
        
    ,   DllCall("UpdateResource", "ptr", re, "ptr", 3, "ptr", thisID, "ushort", 0x409, "ptr", &iconData, "uint", iconDataSize, "uint")
        
    ,   ige += 14
    }
    
    return thisID + 1, DllCall("UpdateResource", "ptr", re, "ptr", 14, "ptr", iconID, "ushort", 0x409, "ptr", &rsrcIconGroup, "uint", rsrcIconGroupSize, "uint")
}

DllCreateEmpty(F="empty.dll") { ; www.autohotkey.com/forum/viewtopic.php?p=381161#381161       
;Creates Empty Resource-Only DLL (1536 bytes)  / CD:05-Sep-2010 | LM:25-Oct-2010 - by SKAN
 IfNotEqual,A_Tab, % TS:=A_NowUTC, EnvSub,TS,1970,S  ;
 Src := "0X5A4DY3CXB8YB8X4550YBCX2014CYCCX210E00E0YD0X7010BYD8X400YE4X1000YE8X1000YECX78A"
 . "E0000YF0X1000YF4X200YF8X10005YFCX10005Y100X4Y108X3000Y10CX200Y114X2Y118X40000Y11CX200"
 . "0Y120X100000Y124X1000Y12CX10Y140X1000Y144X10Y158X2000Y15CX8Y1B0X7273722EY1B4X63Y1B8X1"
 . "0Y1BCX1000Y1C0X200Y1C4X200Y1D4X40000040Y1D8X6C65722EY1DCX636FY1E0X8Y1E4X2000Y1E8X200Y"
 . "1ECX400Y1FCX42000040", VarSetCapacity(Trg,1536,0), Numput(TS,Trg,192),AC := 0x40000000
 Loop, Parse, Src, XY
   Mod(A_Index,2) ? O := "0x" A_LoopField : NumPut("0x" A_LoopField, Trg, O)
 If (hF := DllCall("CreateFile", Str,F, UInt,AC,UInt,2,Ptr,0,UInt,2,Int,0,Int,0)) > 0
   B := DllCall("_lwrite", Ptr,hF,Ptr,&Trg,UInt,1536),  DllCall("CloseHandle",Ptr,hF)
Return B ? F :
}

