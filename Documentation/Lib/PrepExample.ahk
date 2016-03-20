;
; File encoding:  UTF-8
;

PrepExample(src)
{
	if RegExMatch(src, "i)^@file:(.+)$", o)
	{
		global filedir
		oldw := A_WorkingDir
		SetWorkingDir, %filedir%
		FileRead, src, %o1%
		SetWorkingDir, %oldw%
		return "<pre class=""NoIndent"">" HighlightCode(_HTML(src)) "</pre>"
	}
	return Markdown2HTML(src)
}

PrepPage(src)
{
	if RegExMatch(src, "i)^@file:(.+)$", o)
	{
		global filedir
		oldw := A_WorkingDir
		SetWorkingDir, %filedir%
		FileRead, src, %o1%
		SetWorkingDir, %oldw%
	}
	return Markdown2HTML(src)
}
