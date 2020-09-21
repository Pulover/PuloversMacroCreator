;###########################################################
; Script:    Vis2.ahk
; Author:    iseahound
; Date:      2017-08-19
; Recent:    2018-04-04
; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=36047
; Modified by Pulover
;###########################################################


; OCR() - Convert pictures of text into text.
OCR(image:="", language:="", options:=""){
   return Vis2.OCR(image, language, options)
}

class Vis2 {

   class ImageIdentify extends Vis2.functor {
      call(self, image:="", search:="", options:=""){
         return (image != "") ? (new Vis2.provider.GoogleCloudVision()).ImageIdentify(image, search, options)
            : Vis2.core.returnText({"provider":(new Vis2.provider.GoogleCloudVision(search)), "tooltip":"Image Identification Tool", "splashImage":true})
      }
   }

   class OCR extends Vis2.functor {
      call(self, image:="", language:="", options:=""){
         return (image != "") ? (new Vis2.provider.Tesseract()).OCR(image, language, options)
            : Vis2.core.returnText({"provider":(new Vis2.provider.Tesseract(language)), "tooltip":"Optical Character Recognition Tool", "textPreview":true})
      }
   }

   class core {

      ; returnText() is a wrapper function of Vis2.core.ux.start()
      ; Unlike Vis2.core.ux.start(), this function will return a string of text.
      returnText(obj := ""){
         obj := IsObject(obj) ? obj : {}
         obj.callback := "returnText"
         if (Vis2.core.ux.start(obj) == "") {
            while !(EXITCODE := Vis2.obj.EXITCODE)
               Sleep 1
            text := Vis2.obj.database
            Vis2.obj.callbackConfirmed := true
            text.base.google := ObjBindMethod(Vis2.Text, "google")
            text.base.clipboard := ObjBindMethod(Vis2.Text, "clipboard")
            return (EXITCODE > 0) ? text : ""
         }
      }
   }

   class functor {

      __Call(method, ByRef arg := "", args*) {
      ; When casting to Call(), use a new instance of the "function object"
      ; so as to avoid directly storing the properties(used across sub-methods)
      ; into the "function object" itself.
      ; Thanks to coco for this code. Modified by iseahound.
         if IsObject(method)
            return (new this).Call(method, arg, args*)
         else if (method == "")
            return (new this).Call(arg, args*)
      }
   }

   class Graphics {

      static pToken, Gdip := 0

      Startup(){
         global pToken
         return Vis2.Graphics.pToken := (Vis2.Graphics.Gdip++ > 0) ? Vis2.Graphics.pToken : (pToken) ? pToken : Gdip_Startup()
      }

      Shutdown(){
         global pToken
         return Vis2.Graphics.pToken := (--Vis2.Graphics.Gdip <= 0) ? ((pToken) ? pToken : Gdip_Shutdown(Vis2.Graphics.pToken)) : Vis2.Graphics.pToken
      }

      Name(){
         VarSetCapacity(UUID, 16, 0)
         if (DllCall("rpcrt4.dll\UuidCreate", "ptr", &UUID) != 0)
             return (ErrorLevel := 1) & 0
         if (DllCall("rpcrt4.dll\UuidToString", "ptr", &UUID, "uint*", suuid) != 0)
             return (ErrorLevel := 2) & 0
         return A_TickCount "n" SubStr(StrGet(suuid), 1, 8), DllCall("rpcrt4.dll\RpcStringFree", "uint*", suuid)
      }
   }

   class provider {

      class Tesseract {

         static leptonica := A_ScriptDir "\bin\leptonica_util\leptonica_util.exe"
         static tesseract := A_ScriptDir "\bin\tesseract\tesseract.exe"
         static tessdata_best := A_ScriptDir "\bin\tesseract\tessdata_best"
         static tessdata_fast := A_ScriptDir "\bin\tesseract\tessdata_fast"

         uuid := Vis2.stdlib.CreateUUID()
         file := A_Temp "\Vis2_screenshot" this.uuid ".bmp"
         fileProcessedImage := A_Temp "\Vis2_preprocess" this.uuid ".tif"
         fileConvertedText := A_Temp "\Vis2_text" this.uuid ".txt"

         ; public OCR()
         ; public preprocess()
         ; public convert()
         ; public cleanup()
         ; public getPreprocessImage()
         ; public getText()
         ; private convert_best()
         ; private convert_fast()
         ; private getTextLines()

         __New(language:=""){
            this.language := language
         }

         OCR(image, language:="", options:=""){
            this.language := language
            try {
               screenshot := Vis2.stdlib.toFile(image, this.file, options)
               this.preprocess(screenshot, this.fileProcessedImage)
               this.convert_best(this.fileProcessedImage, this.fileConvertedText)
               text := this.getText(this.fileConvertedText)
            } catch e {
               MsgBox, 16,, % "Exception thrown!`n`nwhat: " e.what "`nfile: " e.file
                  . "`nline: " e.line "`nmessage: " e.message "`nextra: " e.extra
            }
            finally {
               this.cleanup()
            }
            return text
         }

         cleanup(){
            FileDelete, % this.file
            FileDelete, % this.fileProcessedImage
            FileDelete, % this.fileConvertedText
         }

         convert(in:="", out:="", fast:=1){
            in := (in) ? in : this.fileProcessedImage
            out := (out) ? out : this.fileConvertedText
            fast := (fast) ? this.tessdata_fast : this.tessdata_best

            if !(FileExist(in))
               throw Exception("Input image for conversion not found.",, in)

            if !(FileExist(this.tesseract))
               throw Exception("Tesseract not found",, this.tesseract)

            static q := Chr(0x22)
            _cmd .= q this.tesseract q " --tessdata-dir " q fast q " " q in q " " q SubStr(out, 1, -4) q
            _cmd .= (this.language) ? " -l " q this.language q : ""
            _cmd := ComSpec " /C " q _cmd q
            RunWait % _cmd,, Hide

            if !(FileExist(out))
               throw Exception("Tesseract failed.",, _cmd)

            return out
         }

         convert_best(in:="", out:=""){
            return this.convert(in, out, 0)
         }

         convert_fast(in:="", out:=""){
            return this.convert(in, out, 1)
         }

         getPreprocessImage(){
            return this.fileProcessedImage
         }

         getText(in:="", lines:=""){
            in := (in) ? in : this.fileConvertedText

            if !(database := FileOpen(in, "r`n", "UTF-8"))
               throw Exception("Text file could not be found or opened.",, in)

            if (lines == "") {
               text := RegExReplace(database.Read(), "^\s*(.*?)\s*$", "$1")
               text := RegExReplace(text, "(?<!\r)\n", "`r`n")
            } else {
               while (lines > 0) {
                  data := database.ReadLine()
                  data := RegExReplace(data, "^\s*(.*?)\s*$", "$1")
                  if (data != "") {
                     text .= (text) ? ("`n" . data) : data
                     lines--
                  }
                  if (!database || database.AtEOF)
                     break
               }
            }
            database.Close()
            return text
         }

         getTextLines(lines){
            return this.read(, lines)
         }

         preprocess(in:="", out:=""){
            static ocrPreProcessing := 1
            static negateArg := 2
            static performScaleArg := 1
            static scaleFactor := 3.5

            in := (in != "") ? in : this.file
            out := (out != "") ? out : this.fileProcessedImage

            if !(FileExist(in))
               throw Exception("Input image for preprocessing not found.",, in)

            if !(FileExist(this.leptonica))
               throw Exception("Leptonica not found",, this.leptonica)

            static q := Chr(0x22)
            _cmd .= q this.leptonica q " " q in q " " q out q
            _cmd .= " " negateArg " 0.5 " performScaleArg " " scaleFactor " " ocrPreProcessing " 5 2.5 " ocrPreProcessing  " 2000 2000 0 0 0.0"
            _cmd := ComSpec " /C " q _cmd q
            RunWait, % _cmd,, Hide

            if !(FileExist(out))
               throw Exception("Preprocessing failed.",, _cmd)

            return out
         }
      }
   }

   class stdlib {

      isBinaryImageFormat(data){
         Loop 12
            bytes .= Chr(NumGet(data, A_Index-1, "uchar"))

         ; Null bytes are not passed, so they have been omitted below

         if (bytes ~= "^BM")
            return "bmp"
         if (bytes ~= "^(GIF87a|GIF89a)")
            return "gif"
         if (bytes ~= "^ÿØÿÛ")
            return "jpg"
         if (bytes ~= "s)^ÿØÿà..\x4A\x46\x49\x46") ;\x00\x01
            return "jfif"
         if (bytes ~= "^\x89\x50\x4E\x47\x0D\x0A\x1A\x0A")
            return "png"
         if (bytes ~= "^(\x49\x49\x2A|\x4D\x4D\x2A)") ; 49 49 2A 00, 4D 4D 00 2A
            return "tif"
         return
      }

      isURL(url){
         regex .= "((https?|ftp)\:\/\/)" ; SCHEME
         regex .= "([a-z0-9+!*(),;?&=\$_.-]+(\:[a-z0-9+!*(),;?&=\$_.-]+)?@)?" ; User and Pass
         regex .= "([a-z0-9-.]*)\.([a-z]{2,3})" ; Host or IP
         regex .= "(\:[0-9]{2,5})?" ; Port
         regex .= "(\/([a-z0-9+\$_-]\.?)+)*\/?" ; Path
         regex .= "(\?[a-z+&\$_.-][a-z0-9;:@&%=+\/\$_.-]*)?" ; GET Query
         regex .= "(#[a-z_.-][a-z0-9+\$_.-]*)?" ; Anchor

         return (url ~= "i)" regex) ? true : false
      }

      b64Encode( ByRef buf, bufLen:="" ) {
         bufLen := (bufLen) ? bufLen : StrLen(buf) << !!A_IsUnicode
         DllCall( "crypt32\CryptBinaryToStringA", "ptr", &buf, "UInt", bufLen, "Uint", 1 | 0x40000000, "Ptr", 0, "UInt*", outLen )
         VarSetCapacity( outBuf, outLen, 0 )
         DllCall( "crypt32\CryptBinaryToStringA", "ptr", &buf, "UInt", bufLen, "Uint", 1 | 0x40000000, "Ptr", &outBuf, "UInt*", outLen )
         return strget( &outBuf, outLen, "CP0" )
      }

      b64Decode( b64str, ByRef outBuf ) {
         static CryptStringToBinary := "crypt32\CryptStringToBinary" (A_IsUnicode ? "W" : "A")

         DllCall( CryptStringToBinary, "ptr", &b64str, "UInt", 0, "Uint", 1, "Ptr", 0, "UInt*", outLen, "ptr", 0, "ptr", 0 )
         VarSetCapacity( outBuf, outLen, 0 )
         DllCall( CryptStringToBinary, "ptr", &b64str, "UInt", 0, "Uint", 1, "Ptr", &outBuf, "UInt*", outLen, "ptr", 0, "ptr", 0 )

         return outLen
      }

      CreateUUID() {
         VarSetCapacity(puuid, 16, 0)
         if !(DllCall("rpcrt4.dll\UuidCreate", "ptr", &puuid))
            if !(DllCall("rpcrt4.dll\UuidToString", "ptr", &puuid, "uint*", suuid))
               return StrGet(suuid), DllCall("rpcrt4.dll\RpcStringFree", "uint*", suuid)
         return ""
      }

      Gdip_EncodeBitmapTo64string(pBitmap, ext, Quality=75) {

         if Ext not in BMP,DIB,RLE,JPG,JPEG,JPE,JFIF,GIF,TIF,TIFF,PNG
               return -1
         Extension := "." Ext

         DllCall("gdiplus\GdipGetImageEncodersSize", "uint*", nCount, "uint*", nSize)
         VarSetCapacity(ci, nSize)
         DllCall("gdiplus\GdipGetImageEncoders", "uint", nCount, "uint", nSize, Ptr, &ci)
         if !(nCount && nSize)
            return -2



            Loop, %nCount%
            {
                  sString := StrGet(NumGet(ci, (idx := (48+7*A_PtrSize)*(A_Index-1))+32+3*A_PtrSize), "UTF-16")
                  if !InStr(sString, "*" Extension)
                     continue

                  pCodec := &ci+idx
                  break
            }


         if !pCodec
               return -3

         if (Quality != 75)
         {
               Quality := (Quality < 0) ? 0 : (Quality > 100) ? 100 : Quality
               if Extension in .JPG,.JPEG,.JPE,.JFIF
               {
                     DllCall("gdiplus\GdipGetEncoderParameterListSize", Ptr, pBitmap, Ptr, pCodec, "uint*", nSize)
                     VarSetCapacity(EncoderParameters, nSize, 0)
                     DllCall("gdiplus\GdipGetEncoderParameterList", Ptr, pBitmap, Ptr, pCodec, "uint", nSize, Ptr, &EncoderParameters)
                     Loop, % NumGet(EncoderParameters, "UInt")
                     {
                        elem := (24+(A_PtrSize ? A_PtrSize : 4))*(A_Index-1) + 4 + (pad := A_PtrSize = 8 ? 4 : 0)
                        if (NumGet(EncoderParameters, elem+16, "UInt") = 1) && (NumGet(EncoderParameters, elem+20, "UInt") = 6)
                        {
                              p := elem+&EncoderParameters-pad-4
                              NumPut(Quality, NumGet(NumPut(4, NumPut(1, p+0)+20, "UInt")), "UInt")
                              break
                        }
                     }
               }
         }

         DllCall("ole32\CreateStreamOnHGlobal", "ptr",0, "int",true, "ptr*",pStream)
         DllCall("gdiplus\GdipSaveImageToStream", "ptr",pBitmap, "ptr",pStream, "ptr",pCodec, "uint",p ? p : 0)

         DllCall("ole32\GetHGlobalFromStream", "ptr",pStream, "uint*",hData)
         pData := DllCall("GlobalLock", "ptr",hData, "uptr")
         nSize := DllCall("GlobalSize", "uint",pData)

         VarSetCapacity(Bin, nSize, 0)
         DllCall("RtlMoveMemory", "ptr",&Bin , "ptr",pData , "uint",nSize)
         DllCall("GlobalUnlock", "ptr",hData)
         DllCall(NumGet(NumGet(pStream + 0, 0, "uptr") + (A_PtrSize * 2), 0, "uptr"), "ptr",pStream)
         DllCall("GlobalFree", "ptr",hData)
         
         DllCall("Crypt32.dll\CryptBinaryToString", "ptr",&Bin, "uint",nSize, "uint",0x01, "ptr",0, "uint*",base64Length)
         VarSetCapacity(base64, base64Length*2, 0)
         DllCall("Crypt32.dll\CryptBinaryToString", "ptr",&Bin, "uint",nSize, "uint",0x01, "ptr",&base64, "uint*",base64Length)
         Bin := ""
         VarSetCapacity(Bin, 0)
         VarSetCapacity(base64, -1)

         return base64
      }

      Gdip_BitmapFromClientHWND(hwnd) {
         VarSetCapacity(rc, 16)
         DllCall("GetClientRect", "ptr", hwnd, "ptr", &rc)
      	hbm := CreateDIBSection(NumGet(rc, 8, "int"), NumGet(rc, 12, "int"))
         VarSetCapacity(rc, 0)
         hdc := CreateCompatibleDC()
         obm := SelectObject(hdc, hbm)
      	PrintWindow(hwnd, hdc, 1)
      	pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
      	SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
      	return pBitmap
      }

      Gdip_CropBitmap(ByRef pBitmap, c, preserveOriginal:=false){
         w := Gdip_GetImageWidth(pBitmap), h := Gdip_GetImageHeight(pBitmap)
         pBitmap2 := Gdip_CloneBitmapArea(pBitmap, c.1, c.2, (c.1 + c.3 > w) ? w - c.1 : c.3 , (c.2 + c.4 > h) ? h - c.2 : c.4)
         (preserveOriginal) ? "" : Gdip_DisposeImage(pBitmap)
         pBitmap := pBitmap2
      }

      Gdip_isBitmapEqual(pBitmap1, pBitmap2, width:="", height:="") {
         ; Check if pointers are identical.
         if (pBitmap1 == pBitmap2)
            return true

         ; Assume both Bitmaps are equal in width and height.
         width := (width) ? width : Gdip_GetImageWidth(pBitmap1)
         height := (height) ? height : Gdip_GetImageHeight(pBitmap1)
         E1 := Gdip_LockBits(pBitmap1, 0, 0, width, height, Stride1, Scan01, BitmapData1)
         E2 := Gdip_LockBits(pBitmap2, 0, 0, width, height, Stride2, Scan02, BitmapData2)

         ; RtlCompareMemory preforms an unsafe comparison stopping at the first different byte.
         length := width * height * 4  ; ARGB = 4 bytes
         bytes := DllCall("RtlCompareMemory", "ptr", Scan01+0, "ptr", Scan02+0, "uint", length)

         Gdip_UnlockBits(pBitmap1, BitmapData1)
         Gdip_UnlockBits(pBitmap2, BitmapData2)
         return (bytes == length) ? true : false
      }

      RPath_Absolute(AbsolutPath, RelativePath, s="\") {

         len := InStr(AbsolutPath, s, "", InStr(AbsolutPath, s . s) + 2) - 1   ;get server or drive string length
         pr := SubStr(AbsolutPath, 1, len)                                     ;get server or drive name
         AbsolutPath := SubStr(AbsolutPath, len + 1)                           ;remove server or drive from AbsolutPath
         If InStr(AbsolutPath, s, "", 0) = StrLen(AbsolutPath)                 ;remove last \ from AbsolutPath if any
            StringTrimRight, AbsolutPath, AbsolutPath, 1

         If InStr(RelativePath, s) = 1                                         ;when first char is \ go to AbsolutPath of server or drive
            AbsolutPath := "", RelativePath := SubStr(RelativePath, 2)        ;set AbsolutPath to nothing and remove one char from RelativePath
         Else If InStr(RelativePath,"." s) = 1                                 ;when first two chars are .\ add to current AbsolutPath directory
            RelativePath := SubStr(RelativePath, 3)                           ;remove two chars from RelativePath
         Else If InStr(RelativePath,".." s) = 1 {                              ;otherwise when first 3 char are ..\
            StringReplace, RelativePath, RelativePath, ..%s%, , UseErrorLevel     ;remove all ..\ from RelativePath
            Loop, %ErrorLevel%                                                    ;for all ..\
               AbsolutPath := SubStr(AbsolutPath, 1, InStr(AbsolutPath, s, "", 0) - 1)  ;remove one folder from AbsolutPath
         } Else                                                                ;relative path does not need any substitution
            pr := "", AbsolutPath := "", s := ""                              ;clear all variables to just return RelativePath

         Return, pr . AbsolutPath . s . RelativePath                           ;concatenate server + AbsolutPath + separator + RelativePath
      }

      setSystemCursor(CursorID = "", cx = 0, cy = 0 ) { ; Thanks to Serenity - https://autohotkey.com/board/topic/32608-changing-the-system-cursor/
         static SystemCursors := "32512,32513,32514,32515,32516,32640,32641,32642,32643,32644,32645,32646,32648,32649,32650,32651"

         Loop, Parse, SystemCursors, `,
         {
               Type := "SystemCursor"
               CursorHandle := DllCall( "LoadCursor", "uInt",0, "Int",CursorID )
               %Type%%A_Index% := DllCall( "CopyImage", "uInt",CursorHandle, "uInt",0x2, "Int",cx, "Int",cy, "uInt",0 )
               CursorHandle := DllCall( "CopyImage", "uInt",%Type%%A_Index%, "uInt",0x2, "Int",0, "Int",0, "Int",0 )
               DllCall( "SetSystemCursor", "uInt",CursorHandle, "Int",A_Loopfield)
         }
      }

      ; toBase64() - Converts the input to a Base 64 string.
      ; Types of input accepted
      ; Objects: Rectangle Array (Screenshot)
      ; Strings: File, URL, Window Title (ahk_class...) OR hwnd (hex)
      ; Numbers: GDI Bitmap, GDI HBitmap
      ; Rawfile: Binary, base64
      toBase64(image, extension:="png", quality:="", crop:="", crop2:=""){
         Vis2.Graphics.Startup()

         ; Check if image is an array of 4 numbers
         if (image.1 ~= "^\d+$" && image.2 ~= "^\d+$" && image.3 ~= "^\d+$" && image.4 ~= "^\d+$") {
            pBitmap := Gdip_BitmapFromScreen(image.1 "|" image.2 "|" image.3 "|" image.4)
            base64 := Vis2.stdlib.Gdip_EncodeBitmapTo64string(pBitmap, extension, quality)
            Gdip_DisposeImage(pBitmap)
         }
         ; Check if image points to a valid file
         else if FileExist(image) {
            if !(crop) {
               file := FileOpen(image, "r")
               file.RawRead(data, file.length)
               base64 := Vis2.stdlib.b64Encode(data, file.length)
               file.Close()
            } else {
               pBitmap := Gdip_CreateBitmapFromFile(image)
               (crop) ? Vis2.stdlib.Gdip_CropBitmap(pBitmap, crop) : ""
               base64 := Vis2.stdlib.Gdip_EncodeBitmapTo64string(pBitmap, extension, quality)
               Gdip_DisposeImage(pBitmap)
            }
         }
         ; Check if image points to a valid URL
         else if Vis2.stdlib.isURL(image) {
            static req := ComObjCreate("WinHttp.WinHttpRequest.5.1")
            req.Open("GET",image)
            req.Send()

            pStream := ComObjQuery(req.ResponseStream, "{0000000C-0000-0000-C000-000000000046}")
            if !(crop) {
               DllCall("ole32\GetHGlobalFromStream", "ptr",pStream, "uint*",hData)
               pData := DllCall("GlobalLock", "ptr",hData, "uptr")
               nSize := DllCall("GlobalSize", "uint",pData)

               VarSetCapacity(Bin, nSize, 0)
               DllCall("RtlMoveMemory", "ptr",&Bin , "ptr",pData , "uint",nSize)
               DllCall("GlobalUnlock", "ptr",hData)
               DllCall(NumGet(NumGet(pStream + 0, 0, "uptr") + (A_PtrSize * 2), 0, "uptr"), "ptr",pStream)
               DllCall("GlobalFree", "ptr",hData)

               DllCall("Crypt32.dll\CryptBinaryToString", "ptr",&Bin, "uint",nSize, "uint",0x01, "ptr",0, "uint*",base64Length)
               VarSetCapacity(base64, base64Length*2, 0)
               DllCall("Crypt32.dll\CryptBinaryToString", "ptr",&Bin, "uint",nSize, "uint",0x01, "ptr",&base64, "uint*",base64Length)
               Bin := ""
               VarSetCapacity(Bin, 0)
               VarSetCapacity(base64, -1)
            } else {
               DllCall("gdiplus\GdipCreateBitmapFromStream", "ptr",pStream, "uptr*",pBitmap)
               ObjRelease(pStream)
               (crop) ? Vis2.stdlib.Gdip_CropBitmap(pBitmap, crop) : ""
               base64 := Vis2.stdlib.Gdip_EncodeBitmapTo64string(pBitmap, extension, quality)
               Gdip_DisposeImage(pBitmap)
            }
         }
         ; Check if image matches a window title OR is a valid handle to a window
         else if (DllCall("IsWindow", "ptr",image) || (hwnd := WinExist(image))) {
            hwnd := (DllCall("IsWindow", "ptr",image)) ? image : hwnd
            pBitmap := Vis2.stdlib.Gdip_BitmapFromClientHWND(hwnd)
            (crop) ? Vis2.stdlib.Gdip_CropBitmap(pBitmap, crop) : ""
            base64 := Vis2.stdlib.Gdip_EncodeBitmapTo64string(pBitmap, extension, quality)
            Gdip_DisposeImage(pBitmap)
         }
         ; Check if image is a valid GDI Bitmap
         else if DeleteObject(Gdip_CreateHBITMAPFromBitmap(image)) {
            (crop) ? Vis2.stdlib.Gdip_CropBitmap(image, crop, true) : ""
            base64 := Vis2.stdlib.Gdip_EncodeBitmapTo64string(image, extension, quality)
            (crop) ? Gdip_DisposeImage(image) : ""
         }
         ; Check if image is a valid handle to a GDI Bitmap
         else if (DllCall("GetObjectType", "ptr",image) == 7) {
            pBitmap := Gdip_CreateBitmapFromHBITMAP(image)
            (crop) ? Vis2.stdlib.Gdip_CropBitmap(pBitmap, crop) : ""
            base64 := Vis2.stdlib.Gdip_EncodeBitmapTo64string(pBitmap, extension, quality)
            Gdip_DisposeImage(pBitmap)
         }
         ; Check if image is a base64 string
         else if (image ~= "^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$") {
            base64 := image
         }
         Vis2.Graphics.Shutdown()
         return base64
      }

      ; toFile() - Saves the image as a temporary file.
      toFile(image, outputFile:="", crop:=""){
         Vis2.Graphics.Startup()
         ; Check if image is an array of 4 numbers
         if (image.1 ~= "^\d+$" && image.2 ~= "^\d+$" && image.3 ~= "^\d+$" && image.4 ~= "^\d+$") {
            pBitmap := Gdip_BitmapFromScreen(image.1 "|" image.2 "|" image.3 "|" image.4)
            Gdip_SaveBitmapToFile(pBitmap, outputFile)
            Gdip_DisposeImage(pBitmap)
         }
         ; Check if image points to a valid file
         else if FileExist(image) {
            Loop, Files, % image
            {
               if (A_LoopFileExt != "bmp" || IsObject(crop)) {
                  pBitmap := Gdip_CreateBitmapFromFile(A_LoopFileLongPath)
                  (crop) ? Vis2.stdlib.Gdip_CropBitmap(pBitmap, crop) : ""
                  Gdip_SaveBitmapToFile(pBitmap, outputFile)
                  Gdip_DisposeImage(pBitmap)
               }
               else outputFile := A_LoopFileLongPath
            }
         }
         ; Check if image points to a valid URL
         else if Vis2.stdlib.isURL(image) {
            static req := ComObjCreate("WinHttp.WinHttpRequest.5.1")
            req.Open("GET",image)
            req.Send()

            pStream := ComObjQuery(req.ResponseStream, "{0000000C-0000-0000-C000-000000000046}")
            DllCall("gdiplus\GdipCreateBitmapFromStream", "ptr",pStream, "uptr*",pBitmap)
            (crop) ? Vis2.stdlib.Gdip_CropBitmap(pBitmap, crop) : ""
            Gdip_SaveBitmapToFile(pBitmap, outputFile, 92)
            ObjRelease(pStream)
            Gdip_DisposeImage(pBitmap)
         }
         ; Check if image matches a window title OR is a valid handle to a window
         else if (DllCall("IsWindow", "ptr",image) || (hwnd := WinExist(image))) {
            hwnd := (DllCall("IsWindow", "ptr",image)) ? image : hwnd
            pBitmap := Vis2.stdlib.Gdip_BitmapFromClientHWND(hwnd)
            (crop) ? Vis2.stdlib.Gdip_CropBitmap(pBitmap, crop) : ""
            Gdip_SaveBitmapToFile(pBitmap, outputFile)
            Gdip_DisposeImage(pBitmap)
         }
         ; Check if image is a valid GDI Bitmap
         else if DeleteObject(Gdip_CreateHBITMAPFromBitmap(image)) {
            (crop) ? Vis2.stdlib.Gdip_CropBitmap(image, crop, true) : ""
            Gdip_SaveBitmapToFile(image, outputFile)
         }
         ; Check if image is a valid handle to a GDI Bitmap
         else if (DllCall("GetObjectType", "ptr",image) == 7) {
            pBitmap := Gdip_CreateBitmapFromHBITMAP(image)
            (crop) ? Vis2.stdlib.Gdip_CropBitmap(pBitmap, crop) : ""
            Gdip_SaveBitmapToFile(pBitmap, outputFile)
            Gdip_DisposeImage(pBitmap)
         }
         ; Check if image is a base64 string
         else if (image ~= "^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$") {
            nSize := Vis2.stdlib.b64Decode(image, bin)
            hData := DllCall("GlobalAlloc", "uint",0x2, "ptr",nSize)
            pData := DllCall("GlobalLock", "ptr",hData)
            DllCall("RtlMoveMemory", "ptr",pData, "ptr",&bin, "ptr",nSize)
            DllCall("GlobalUnlock", "ptr",hData)
            DllCall("ole32\CreateStreamOnHGlobal", "ptr",hData, "int",1, "uptr*",pStream)
            DllCall("gdiplus\GdipCreateBitmapFromStream", "ptr",pStream, "uptr*",pBitmap)
            (crop) ? Vis2.stdlib.Gdip_CropBitmap(pBitmap, crop) : ""
            Gdip_SaveBitmapToFile(pBitmap, outputFile, 92)
            DllCall(NumGet(NumGet(pStream + 0, 0, "uptr") + (A_PtrSize * 2), 0, "uptr"), "ptr",pStream)
            DllCall("GlobalFree", "ptr",hData)
            ObjRelease(pStream)
            Gdip_DisposeImage(pBitmap)
         }

         if !(FileExist(outputFile))
            throw Exception("Could not find source image.")

         Vis2.Graphics.Shutdown()
         return outputFile
      }
   }
}
