; ======================================================================================================================
; Function:         Additional functions for ImageLists.
; Tested with:      AHK 1.1.13.01 (A32/U32/U64)
; Tested on:        Win 7 (x64)
; Changelog:
;     1.0.00.00/2014-01-04/just me
; Common Parameters:
;     ILID  -  The unique ID (HIMAGELIST) of the image list returned by IL_Create().
;     Index -  The 1-based index of the image in the image list.
; ======================================================================================================================
; This software is provided 'as-is', without any express or implied warranty.
; In no event will the authors be held liable for any damages arising from the use of this software.
; ======================================================================================================================
; IL_EX_Copy(ILID, From, To)
; Function:       Copies images within this image list.
; Parameters:     From     -  1-based source index of the image.
;                 To       -  1-based target index of the image.
; Return values:  Returns nonzero if successful, or zero otherwise.
; MSDN:           http://msdn.microsoft.com/en-us/library/bb761520(VS.85).aspx
; ======================================================================================================================
IL_EX_Copy(ILID, From, To) {
   Static ILCF_MOVE := 0x00000000
   Return DllCall("ComCtl32.dll\ImageList_Copy", "Ptr", ILID, "Int", --To, "Ptr", ILID, "Int", --From, "UInt", 0, "Int")
}
; ======================================================================================================================
; IL_EX_Draw(ILID, Index, HWND[, X := 0[, Y := 0[, Styles := 0x00]]])
; Function:       Draws an image list item in the specified control's device context.
; Parameters:     HWND     -  Handle of the destination control or GUI.
;                 Optional -
;                 X        -  The x-coordinate at which to draw within the specified control's device context.
;                             Default: 0
;                 Y        -  The y-coordinate at which to draw within the specified control's device context.
;                             Default: 0
;                 Styles   -  A combination of drawing styles.
;                             Default: 0x00 (ILD_IMAGE)
; Return values:  Returns nonzero if successful, or zero otherwise.
; MSDN:           http://msdn.microsoft.com/en-us/library/bb761533(VS.85).aspx
; Drawing styles:
;     ILD_ASYNC         := 0x00008000  ; Vista+
;     ILD_DPISCALE      := 0x00004000
;     ILD_FOCUS         := 0x00000002  ; ILD_BLEND25
;     ILD_IMAGE         := 0x00000020
;     ILD_MASK          := 0x00000010
;     ILD_NORMAL        := 0x00000000
;     ILD_OVERLAYMASK   := 0x00000F00
;     ILD_PRESERVEALPHA := 0x00001000  ; This preserves the alpha channel in dest
;     ILD_ROP           := 0x00000040
;     ILD_SCALE         := 0x00002000  ; Causes the image to be scaled to cx, cy instead of clipped
;     ILD_SELECTED      := 0x00000004  ; ILD_BLEND, ILD_BLEND50
;     ILD_TRANSPARENT   := 0x00000001
;     To add an overlay image shift the one-based index of the overlay image by 16 (<<16) and use the OR operator (|)
;     to combine the two values.
; ======================================================================================================================
IL_EX_Draw(ILID, Index, HWND, X := 0, Y := 0, Styles := 0x20) {
   HDC := DllCall("User32.dll\GetDC", "Ptr", HWND, "UPtr")
   Result := DllCall("ComCtl32.dll\ImageList_Draw", "Ptr", ILID, "Int", Index - 1, "Ptr", HDC
                   , "Int", X, "Int", Y, "UInt", Styles, "UInt")
   DllCall("User32.dll\ReleaseDC", "Ptr", HWND, "Ptr", HDC)
   Return Result
}
; ======================================================================================================================
; IL_EX_Duplicate(ILID)
; Function:       Creates a duplicate of an existing image list.
; Return values:  Returns the handle to the new duplicate image list if successful, or NULL otherwise.
; MSDN:           http://msdn.microsoft.com/en-us/library/bb761540(v=vs.85).aspx
; Remarks:        All information contained in the original image list for normal images is copied to the new
;                 image list. Overlay images are not copied.
; ======================================================================================================================
IL_EX_Duplicate(ILID) {
   Return DllCall("Comctl32.dll\ImageList_Duplicate", "Ptr", HIML, "UPtr")
}
; ======================================================================================================================
; IL_EX_GetHICON(ILID, Index[, Styles := 0x00])
; Function:       Creates an icon from an image in an image list.
; Parameters:     Styles   -  A combination of drawing styles (see IL_EX_Draw()).
;                             Default: 0x20 (ILD_IMAGE)
; Return values:  Returns the handle to the icon if successful, or NULL otherwise.
; MSDN:           http://msdn.microsoft.com/en-us/library/bb761548(VS.85).aspx
; ======================================================================================================================
IL_EX_GetHICON(ILID, Index, Styles := 0x20) {
   Return DllCall("ComCtl32.dll\ImageList_GetIcon", "Ptr", ILID, "Int", Index - 1, "UInt", Styles, "UPtr")
}
; ======================================================================================================================
; IL_EX_GetImageCount(ILID)
; Function:       Retrieves the number of images in an image list.
; Return values:  Returns the number of images.
; MSDN:           http://msdn.microsoft.com/en-us/library/bb761552(VS.85).aspx
; ======================================================================================================================
IL_EX_GetImageCount(ILID) {
   Return DllCall("ComCtl32.dll\ImageList_GetImageCount", "Ptr", ILID, "Int")
}
; ======================================================================================================================
; IL_EX_GetSize(ILID, W, H)
; Function:       Retrieves the dimensions of images in an image list.
; Parameters:     W        -  Integer variable that receives the width, in pixels, of each image.
;                 H        -  Integer variable that receives the height, in pixels, of each image.
; Return values:  Returns nonzero if successful, or zero otherwise.
; MSDN:           http://msdn.microsoft.com/en-us/library/bb761550(v=vs.85).aspx
; ======================================================================================================================
IL_EX_GetSize(ILID, ByRef W, ByRef H) {
   Return DllCall("ComCtl32.dll\ImageList_GetIconSize", "Ptr", ILID, "IntP", W, "IntP", H, "UPtr")
}
; ======================================================================================================================
; IL_EX_Remove(ILID, Index)
; Function:       Removes an image from an image list.
; Parameters:     Index    -  If this parameter is 0, the function removes all images.
; Return values:  Returns nonzero if successful, or zero otherwise.
; MSDN:           http://msdn.microsoft.com/en-us/library/bb761564(VS.85).aspx
; Remarks:        When an image is removed, the indexes of the remaining images are adjusted so that the image indexes
;                 always range from zero to one less than the number of images in the image list. For example, if you
;                 remove the image at index 0, then image 1 becomes image 0, image 2 becomes image 1, and so on.
; ======================================================================================================================
IL_EX_Remove(ILID, Index) {
   Return DllCall("ComCtl32.dll\ImageList_Remove", "Ptr", ILID, "Int", Index - 1, "UInt")
}
; ======================================================================================================================
; IL_EX_Replace(ILID, Index, HBITMAP[, HMASK := 0])
; Function:       Replaces an image in an image list with a new image.
; Parameters:     HBITMAP  -  A handle to the bitmap that contains the image.
;                 HMASK    -  A handle to the bitmap that contains the mask. If no mask is used with the image list,
;                             this parameter is ignored.
;                             Default: 0 (no mask)
; Return values:  Returns nonzero if successful, or zero otherwise.
; MSDN:           http://msdn.microsoft.com/en-us/library/bb775213(v=vs.85).aspx
; Ramarks:        The function copies the bitmap to an internal data structure. Be sure to use the DeleteObject()
;                 function to delete HBITMAP and HMASK after the function returns.
; ======================================================================================================================
IL_EX_Replace(ILID, Index, HBITMAP, HMASK := 0) {
   Return DllCall("ComCtl32.dll\ImageList_Replace", "Ptr", ILID, "Int", Index - 1, "Ptr", HBITMAP, "Ptr", HMASK, "UInt")
}
; ======================================================================================================================
; IL_EX_ReplaceIcon(ILID, Index, HICON)
; Function:       Replaces an image with an icon or cursor.
; Parameters:     HICON    -  The handle to the icon or cursor that contains the bitmap and mask for the new image.
; Return values:  Returns nonzero if successful, or zero otherwise.
; MSDN:           http://msdn.microsoft.com/en-us/library/bb775215(v=vs.85).aspx
; Ramarks:        Because the system does not save HICON, you can destroy it after the function returns.
; ======================================================================================================================
IL_EX_ReplaceIcon(ILID, Index, HICON) {
   Return DllCall("ComCtl32.dll\ImageList_ReplaceIcon", "Ptr", ILID, "Int", Index - 1, "Ptr", HICON, "UInt")
}
; ======================================================================================================================
; IL_EX_SetBkColor(ILID[, BkColor := 0xFFFFFF])
; Function:       Sets the background color for an image list.
; Parameters:     BkColor  -  The background color to set as RGB integer.
;                             This parameter can be the CLR_NONE (0xFFFFFFFF) value; in that case, images are drawn
;                             transparently using the mask.
;                             Default: 0xFFFFFF (white)
; Return values:  Returns the previous background color if successful, or CLR_NONE (0xFFFFFFFF) otherwise.
; MSDN:           http://msdn.microsoft.com/en-us/library/bb775217(VS.85).aspx
; Remarks:        This function only works if you add an icon or use ImageList_AddMasked with a black and white bitmap.
;                 Without a mask, the entire image is drawn; hence the background color is not visible.
; ======================================================================================================================
IL_EX_SetBkColor(ILID, BkColor := 0xFFFFFF) {
   If (BkColor <> 0xFFFFFF) && (BkColor <> 0xFFFFFFFF) && (BkColor <> 0xFF000000)
      Color := ((BkColor & 0xFF0000) >> 16) | (BkColor & 0x00FF00) | ((BkColor & 0x0000FF) << 16)
   Return DllCall("ComCtl32.dll\ImageList_SetBkColor", "Ptr", ILID, "UInt", BkColor, "UInt")
}
; ======================================================================================================================
; IL_EX_SetImageCount(ILID, NewCount)
; Function:       Resizes an existing image list.
; Parameters:     NewCount -  A value specifying the new size of the image list.
; Return values:  Returns nonzero if successful, or zero otherwise.
; MSDN:           http://msdn.microsoft.com/en-us/library/bb775226(v=vs.85).aspx
; Remarks:        If an application expands an image list with this function, it must add new images by using the
;                 IL_EX_Replace() function. If your application does not add valid images at the new indexes, draw
;                 operations that use the new indexes will be unpredictable.
;                 If you decrease the size of an image list by using this function, the truncated images are freed.
; ======================================================================================================================
IL_EX_SetImageCount(ILID, NewCount) {
   Return DllCall("ComCtl32.dll\ImageList_SetImageCount", "Ptr", ILID, "UInt", NewCount, "UInt")
}
; ======================================================================================================================
; IL_EX_SetSize(ILID, W, H)
; Function:       Sets the dimensions of images in an image list and removes all images from the list.
; Parameters:     W        -  The width, in pixels, of all images in the image list.
;                 H        -  The height, in pixels, of all images in the image list.
; Return values:  Returns nonzero if successful, or zero otherwise.
; MSDN:           http://msdn.microsoft.com/en-us/library/bb775224(VS.85).aspx
; Remarks:        All images in an image list have the same dimensions.
; ======================================================================================================================
IL_EX_SetSize(ILID, W, H) {
   Return DllCall("ComCtl32.dll\ImageList_SetIconSize", "Ptr", ILID, "Int", W, "Int", H, "Int")
}
; ======================================================================================================================