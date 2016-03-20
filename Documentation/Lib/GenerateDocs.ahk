;
; File encoding:  UTF-8
;

#Include <Markdown2HTML>
#Include <PrepExample>

GenerateDocs(file, docs)
{
	SplitPath, file,, filedir,, name
	docudir := filedir "\" name "-doc"
	IfNotExist, %docudir%\
		FileCreateDir, %docudir%
	
	libname := docs.name
	libdesc := docs.description
	if docs.version
		libextra .= " - Version " _HTML(docs.version)
	if docs.author
		libextra .= " - by " _HTML(docs.author)
	if docs.license
		libextra .= " - released under the " _HTML(docs.license)
	
	filetext =
	(LTrim
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
	"http://www.w3.org/TR/html4/loose.dtd">
	<html>
	<head>
	<title>%libname%</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<link href="default.css" rel="stylesheet" type="text/css">
	</head>
	<body>

	<h1>%libname%%libextra%</h1>
	)
	if libdesc
		filetext .= "`n" PrepPage(libdesc)
	filetext .= "`n<h2>Table of Contents</h2>`n<ul>"
	
	oldw := A_WorkingDir
	SetWorkingDir, %docudir%
	
	try
	{
		FileCopy, %A_ScriptDir%\default.css, %docudir%\default.css, 1
		
		for each,item in docs.contents
		{
			type := item.type
			q := Generate_%type%(item)
			if type != Page
			{
				filetext .= "`n  <li><a href=""" q ".html"">"
				q := SubStr(q, StrLen(w)+1)
				if type = Function
					filetext .= q "() Function"
				else if type = Class
					filetext .= q " Class"
				else if type = Page
					filetext .= _HTML(q)
				filetext .= "</a></li>"
			}else
				filetext .= "`n  <li><a href=""" item.filename ".html"">" _HTML(item.name) "</a></li>"
		}
		filetext .= "`n</ul>`n`n</body>`n</html>"
		IfExist, index.html
			FileDelete, index.html
		FileAppend, % filetext, index.html
		
		SetWorkingDir, %filedir%
		global imglist
		for k,img in imglist
			FileCopy, %img%, %docudir%\%img%, 1
	}catch e
	{
		SetWorkingDir, %oldw%
		Util_Status("An error happened (" e.what ")! " e.message " | " e.extra, 1)
		Exit
	}
	SetWorkingDir, %oldw%
}

Generate_Function(item, prefix="")
{
	Util_Status("Generating documentation for function " prefix item.name "...")
	return Generate_Common(item, prefix)
}

Generate_Method(item, prefix="")
{
	if !prefix
		throw Exception("Methods must be inside classes!")
	Util_Status("Generating documentation for method " prefix item.name "...")
	return Generate_Common(item, prefix)
}

Generate_Property(item, prefix)
{
	if !prefix
		throw Exception("Properties must be inside classes!")
	Util_Status("Generating documentation for property " prefix item.name "...")
	return Generate_Common(item, prefix)
}

Generate_Constructor(item, prefix)
{
	if !prefix
		throw Exception("Constructors must be inside classes!")
	Util_Status("Generating documentation for constructor " prefix "__New" item.name "...")
	return Generate_Common(item, prefix)
}

Parse_Common(item, prefix, ByRef type, ByRef syntax, ByRef name, ByRef isConstr, ByRef isGet, ByRef isSet)
{
	if type = Method
		type = Function
	else if type = Constructor
		type := "Function", isConstr := 1
	if type = Function
	{
		syntax := item.name
		if !isConstr
		{
			if not pos := InStr(syntax, "(")
				throw Exception("Invalid syntax!")
			name := prefix SubStr(syntax, 1, pos-1)
			if InStr(name, " ")
				throw Exception("Invalid syntax!")
			syntax := prefix syntax
		}else
		{
			syntax := "obj := new " RTrim(prefix,".") syntax 
			name := prefix "__New"
		}
	}else if type = Property
	{
		name := prefix item.name
		StringReplace, name, name, [get],, UseErrorLevel
		if not isGet := !!ErrorLevel
		{
			StringReplace, name, name, [set],, UseErrorLevel
			if not isSet := !!ErrorLevel
			{
				StringReplace, name, name, [get/set],, UseErrorLevel
				if not isGet := isSet := !!ErrorLevel
					throw Exception("You must specify [get], [set] or [get/set]!")
			}else isGet := 0
		}else isSet := 0
		pos := InStr(name, "[")
		if pos
		{
			extra := SubStr(name, pos)
			name := SubStr(name, 1, pos - 1)
		}
		name := Trim(name), extra := Trim(extra)
		syntax := ""
		if isGet
			syntax .= "OutputVar := " name extra "`n"
		if isSet
			syntax .= name extra " := Value`n"
		StringTrimRight, syntax, syntax, 1
		StringReplace, syntax, syntax, `r, <br/>
	}
}

Generate_Common(item, prefix="")
{
	type := item.type
	Parse_Common(item, prefix, type, syntax, name, isConstr, isGet, isSet)
	
	prettyname := type = "Function" ? name "()" : name
	
	filetext =
	(LTrim
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
	"http://www.w3.org/TR/html4/loose.dtd">
	<html>
	<head>
	<title>%prettyname%</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<link href="default.css" rel="stylesheet" type="text/css">
	</head>
	<body>

	<h1>%prettyname%</h1>
	)
	if item.description
		filetext .= "`n" Markdown2HTML(item.description)
	filetext .= "`n`n<pre class=""Syntax"">" _HTML(syntax) "</pre>"
	if params := item.parameters
	{
		filetext .= "`n<h3>Parameters</h4>`n<dl>"
		params := RegExReplace(params, "`n\s+", "`r")
		Loop, Parse, params, `n
		{
			if not pos := InStr(A_LoopField, "-")
				throw Exception("Invalid parameter syntax!")
			pname := RTrim(SubStr(A_LoopField, 1, pos-1))
			pval := LTrim(SubStr(A_LoopField, pos+1))
			StringReplace, pval, pval, `r, `n, All
			filetext .= "`n  <dt>" pname "</dt>`n  <dd>" Markdown2HTML(pval,1) "</dd>"
		}
		filetext .= "`n</dl>"
	}
	if returns := item.returns
		filetext .= "`n<h3>Returns</h3>`n" Markdown2HTML(returns)
	if value := item.value
		filetext .= "`n<h3>Value</h3>`n" Markdown2HTML(value)
	if throws := item.throws
		filetext .= "`n<h3>Throws</h3>`n" Markdown2HTML(throws)
	if remarks := item.remarks
		filetext .= "`n<h3>Remarks</h3>`n" Markdown2HTML(remarks)
	if extra := item.extra
		filetext .= "`n" PrepPage(extra)
	if example := item.example
		filetext .= "`n<h3>Example</h3>`n" PrepExample(example)
	
	filetext .= "`n`n</body>`n</html>"
	
	IfExist, %name%.html
		FileDelete, %name%.html
	FileAppend, % filetext, %name%.html
	return name
}

Generate_Page(item, prefix="")
{
	Util_Status("Generating page " item.name "...")
	
	name := _HTML(item.name)
	filename := item.filename
	contents := PrepPage(item.contents)
	
	filetext =
	(LTrim
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
	"http://www.w3.org/TR/html4/loose.dtd">
	<html>
	<head>
	<title>%name%</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<link href="default.css" rel="stylesheet" type="text/css">
	</head>
	<body>
	%contents%
	</body>
	</html>
	)
	
	IfExist, %filename%.html
		FileDelete, %filename%.html
	FileAppend, % filetext, %filename%.html
}

Generate_Class(item, prefix="")
{
	Util_Status("Generating documentation for class " prefix item.name "...")
	
	isShort := item.attr_UseShortForm
	name := prefix item.name
	
	filetext =
	(LTrim
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
	"http://www.w3.org/TR/html4/loose.dtd">
	<html>
	<head>
	<title>%name% Class</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<link href="default.css" rel="stylesheet" type="text/css">
	</head>
	<body>

	<h1>%name% Class</h1>
	)
	if item.inherits
		filetext .= "`n<p>(Inherits from <a href=""" item.inherits ".html"">" item.inherits "</a>)</p>"
	filetext .= "`n" Markdown2HTML(item.description)
	
	if !isShort
	{
		filetext .= "`n<h2>Members</h2>`n<ul>"
		for each,it in item.contents
		{
			t := it.type
			q := Generate_%t%(it, w := name ".")
			filetext .= "`n  <li><a href=""" q ".html"">"
			q := SubStr(q, StrLen(w)+1)
			if (t = "Function") || (t = "Method")
				filetext .= q "() Method"
			else if t = Property
				filetext .= q " Property"
			else if t = Constructor
				filetext .= "Constructor"
			else if t = Class
				filetext .= q " Class"
			filetext .= "</a></li>"
		}
		filetext .= "`n</ul>"
	}else
	{
		for each,it in item.contents
		{
			t := it.type
			GenerateShort_%t%(filetext, it, name ".")
		}
	}
	
	if extra := item.extra
		filetext .= "`n" PrepPage(extra)
	if example := item.example
		filetext .= "`n<h2>Example</h2>`n" PrepExample(example)
	
	filetext .= "`n`n</body>`n</html>"
	
	IfExist, %name%.html
		FileDelete, %name%.html
	FileAppend, % filetext, %name%.html
	return name
}

GenerateShort_Method(ByRef filetext, item, prefix)
{
	GenerateShort_Common(filetext, item, prefix)
}

GenerateShort_Property(ByRef filetext, item, prefix)
{
	GenerateShort_Common(filetext, item, prefix)
}

GenerateShort_Constructor(ByRef filetext, item, prefix)
{
	GenerateShort_Common(filetext, item, prefix)
}

GenerateShort_Common(ByRef filetext, item, prefix)
{
	type := item.type
	Parse_Common(item, prefix, type, syntax, name, isConstr, isGet, isSet)
	name2 := SubStr(name, StrLen(prefix)+1)
	prettyname := type = "Function" ? name2 "()" : name2
	filetext .= "`n`n<div class=""methodShort"" id=""" name2 """><h2>" prettyname "</h2>"
	if item.description
		filetext .= "`n" Markdown2HTML(item.description)
	filetext .= "`n`n<pre class=""Syntax"">" _HTML(syntax) "</pre>"
	if item.value || item.parameters || items.value || item.returns || item.throws
	{
		filetext .= "`n<table class=""info"">"
		if q := item.value
			filetext .= "`n  <tr><td width=""15%""><strong>Value</strong></td><td width=""85%"">" Markdown2HTML(q,1) "</td></tr>"
		if params := item.parameters
		{
			params := RegExReplace(params, "`n\s+", "`r")
			Loop, Parse, params, `n
			{
				if not pos := InStr(A_LoopField, "-")
					throw Exception("Invalid parameter syntax!")
				pname := RTrim(SubStr(A_LoopField, 1, pos-1))
				pval := LTrim(SubStr(A_LoopField, pos+1))
				StringReplace, pval, pval, `r, `n, All
				filetext .= "`n<tr><td width=""15%"">" pname "</td><td width=""85%"">" Markdown2HTML(pval,1) "</td></tr>"
			}
		}
		if q := item.returns
			filetext .= "`n  <tr><td width=""15%""><strong>Returns</strong></td><td width=""85%"">" Markdown2HTML(q,1) "</td></tr>"
		if q := item.throws
			filetext .= "`n  <tr><td width=""15%""><strong>Throws</strong></td><td width=""85%"">" Markdown2HTML(q,1) "</td></tr>"
		filetext .= "`n</table>"
	}
	if item.remarks
		filetext .= "`n" Markdown2HTML(item.remarks)
	if item.extra
		filetext .= "`n" PrepPage(item.extra)
	if item.example
		filetext .= "`n" PrepExample(item.example)
	filetext .= "`n</div>"
}

GenerateShort_Class(ByRef filetext, item, prefix)
{
	name := item.name
	filetext .= "`n`n<div class=""methodShort"" id=""" name """><h2>" name " Class</h2>"
	if item.inherits
		filetext .= "`n<p>(Inherits from <a href=""" item.inherits ".html"">" item.inherits "</a>)</p>"
	filetext .= "`n" Markdown2HTML(item.description)
	for each,it in item.contents
	{
		t := it.type
		GenerateShort_%t%(filetext, it, prefix name ".")
	}
	if item.example
		filetext .= "`n" PrepExample(item.example)
	filetext .= "`n</div>"
}
