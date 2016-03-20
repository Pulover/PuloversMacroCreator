;
; File encoding:  UTF-8
;

MD_IsMultiP(ByRef htmQ)
{
	StringReplace, html, htmQ, <p>, <p>, UseErrorLevel
	if ErrorLevel > 1
		return true
	StringReplace, html, html, <pre, <pre, UseErrorLevel
	return !!ErrorLevel
}

Markdown2HTML(ByRef text, simplify=0)
{
	if !simplify
		return Markdown2HTML_(text)
	t := Markdown2HTML_(text)
	if !MD_IsMultiP(t)
	{
		StringReplace, t, t, <p>,, All
		StringReplace, t, t, </p>,, All
	}
	return t
}

Markdown2HTML_(ByRef text)
{
	blankLine := 1, inCode := 0, inUList := 0, inOList := 0
	Loop, Parse, text, `n, `r
	{
		isList := false
		t := LTrim(A_LoopField)
		beg := SubStr(t, 1, 2)
		if t =
		{
			blankLine ++
			if blankLine = 1
				out .= !inCode ? !inUList ? !inOList ? "</p>`n" : "</ol>`n" : "</ul>`n" : "</pre>`n"
			inCode := 0
			inUList := 0
			inOList := 0
			continue
		}else
		{
			if blankLine
			{
				if RegExMatch(t, "^(#{1,3})\s+(.+)$", o)
				{
					h := StrLen(o1)
					out .= "<h" h " id=""" _ElemID(o2) """>" _HTML(o2) "</h" h ">`n"
					continue
				}
				inCode := (beg = "> ")
				inUList := (beg = "* ")
				inOList := (t ~= "^([1-9]+|[a-z]+)\.\s+")
				if inOList
					listTag := t ~= "\d" ? "<ol>`n" : "<ol style=""list-style-type: lower-alpha"">`n", isList := true
				out .= !inCode ? !inUList ? !inOList ? "<p>`n" : listTag : "<ul>`n" : "<pre>`n"
			}
			blankLine := 0
		}
		_reprocess:
		if inCode
		{
			if (beg = "> ")
			{
				t := SubStr(t, 3)
				t := _HTML(t)
			}else
			{
				out .= "</pre>`n"
				SetStatus(out, t, inCode, inUList, inOList)
				goto _reprocess
			}
		}else if inUList
		{
			if (beg = "* ")
			{
				t := SubStr(t, 3)
				t := "<li>" _MD(t) "</li>"
			}else
			{
				out .= "</ul>`n"
				SetStatus(out, t, inCode, inUList, inOList)
				goto _reprocess
			}
		}else if inOList
		{
			if RegExMatch(t, "O)^([1-9]+|[a-z]+)\.\s+", mObj)
			{
				StringTrimLeft, t, t, % mObj.Len
				t := "<li>" _MD(t) "</li>"
			}else
			{
				out .= "</ol>`n"
				SetStatus(out, t, inCode, inUList, inOList)
				goto _reprocess
			}
		}else
		{
			if (beg != "> ") && (beg != "* ") && !isList
			{
				t := _MD(t)
				if SubStr(t, -1) = "  "
				{
					StringTrimRight, t, t, 2
					t .= "<br/>"
				}
			}else
			{
				out .= "</p>`n"
				SetStatus(out, t, inCode, inUList, inOList)
				goto _reprocess
			}
		}
		
		out .= t "`n"
	}
	if !blankLine
		out .= !inCode ? !inUList ? !inOList ? "</p>`n" : "</ol>`n" : "</ul>`n" : "</pre>`n"
	StringTrimRight, out, out, 1
	StringReplace, out, out, <p>`n, <p>, All
	StringReplace, out, out, `n</p>, </p>, All

	; Fix comments
	_s := 1
	while p := InStr(out, "<pre>", false, _s)
	{
		p2 := InStr(out, "</pre>", false, p += 5)
		code := HighlightCode(SubStr(out, p, p2-p))
		out := SubStr(out, 1, p-1) code SubStr(out, p2)
		_s := p + StrLen(code)
	}

	StringReplace, out, out, <pre>`n, <pre class="NoIndent">, All
	StringReplace, out, out, `n</pre>, </pre>, All
	
	return out
}

SetStatus(ByRef out, t, ByRef inCode, ByRef inUList, ByRef inOList)
{
	beg := SubStr(t, 1, 2)
	inCode := beg = "> "
	inUList := beg = "* "
	inOList := t ~= "^([1-9]+|[a-z]+)\.\s+"
	out .= !inCode ? !inUList ? !inOList ? "<p>`n" : "<ol>`n" : "<ul>`n" : "<pre>`n"
}

_MD(ByRef v)
{
	static pcre_callout := "_MD_Callout"
	t := _HTML(v)
	t := RegExReplace(t, "P)\*\*(.+?)\*\*(?C1)", "<strong>$1</strong>")
	t := RegExReplace(t, "P)\*(.+?)\*(?C2)", "<em>$1</em>")
	t := RegExReplace(t, "P)``(.+?)``(?C3)", "<code>$1</code>")
	t := RegExReplace(t, "P)!\[(.*?)\](?C4)\((.+?)\)", "<img src=""$2"" alt=""$1""/>")
	t := RegExReplace(t, "P)\[(.+?)\](?C5)\((.+?)\)", "<a href=""$2"">$1</a>")
	StringReplace, t, t, \*, *, All
	StringReplace, t, t, \``, ``, All
	StringReplace, t, t, \[, [, All
	StringReplace, t, t, \], ], All
	StringReplace, t, t, \!, !, All
	StringReplace, t, t, \\, \, All
	return t
}

_HTML(ByRef v)
{
	StringReplace, t, v, &, &amp;, All
	StringReplace, t, t, ", &quot;, All
	StringReplace, t, t, <, &lt;, All
	StringReplace, t, t, >, &gt;, All
	return t
}

_ElemID(ByRef v)
{
	t := Trim(_HTML(v))
	StringReplace, t, t, ',, All
	StringReplace, t, t, ",, All
	StringReplace, t, t, (,, All
	StringReplace, t, t, ),, All
	StringReplace, t, t, [,, All
	StringReplace, t, t, ],, All
	StringReplace, t, t, ?,, All
	StringReplace, t, t, %A_Space%, -, All
	StringLower, t, t
	return t
}

HighlightCode(ByRef code)
{
	Loop, Parse, code, `n, `r
	{
		line := A_LoopField
		tline := Trim(line)
		
		if StrStartsWith(tline, ";")
			line := "<em>" line "</em>"
		else line := RegExReplace(line, "(\s+)(;.*)$", "$1<em>$2</em>")
		
		StringReplace, line, line, %A_Tab%, %A_Space%%A_Space%%A_Space%%A_Space%, All
		
		out .= line "`n"
	}
	StringTrimRight, out, out, 1
	return out
}

_MD_Callout(m, cId, foundPos, haystack)
{
	; cId = 1  -> **text**
	; cId = 2  -> *text*
	; cId = 3  -> `text`
	; cId = 4  -> ![img alt text](img url)
	; cId = 5  -> [link text](link url)
	
	p := foundPos, e := 0
	while SubStr(haystack, --p, 1) = "\"
		e ++
	if e & 1
		return 1
	p := foundPos + m - 1, e := 0
	
	if cId = 1
		p --
	while SubStr(haystack, --p, 1) = "\"
		e ++
	if e & 1
		return 1
	
	if cId = 4
	{
		global imglist
		imglist.Insert(SubStr(haystack, mPos2, mLen2))
	}
	
	return 0
}
