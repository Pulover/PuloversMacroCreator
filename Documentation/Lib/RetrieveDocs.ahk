;
; File encoding:  UTF-8
;

RetrieveDocs(file)
{
	Util_Status("Parsing AutoHotkey script...")
	o := { contents: [] }
	SplitPath, file,, fileDir
	tmpWD := A_WorkingDir
	SetWorkingDir, %fileDir%
	files := [file]
	try
	{
		while files.MaxIndex()
		{
			file := FileOpen(q :=files.Remove(1), "r")
			
			while !file.AtEOF
			{
				line := RTrim(file.ReadLine(), " `t`r`n")
				tline := LTrim(line)
				if StrStartsWith(tline, "/*!")
				{
					indent := SubStr(line, 1, InStr(line, "/*!")-1)
					ReadChunk(file, o, indent)
				}
				if RegExMatch(tline, "i)^;!GenDocs-Import\s+(.+)$", tmp)
				{
					IfNotExist, %tmp1%
						throw Exception("File does not exist!", 1, tmp1)
					files.Insert(tmp1)
				}
			}
		}
		PackClasses(o.contents)
		SetWorkingDir, %tmpWD%
		return o
	}catch e
	{
		Util_Status("An error happened (" e.what ")! " e.message " | " e.extra, 1)
		SetWorkingDir, %tmpWD%
		Exit
	}
}

ReadChunk(file, lib, beg_indent)
{
	ent := {}, type := ""
	while !file.AtEOF
	{
		line := RTrim(file.ReadLine(), " `t`r`n")
		tline := LTrim(line)
		if tline =
			continue
		else if StrStartsWith(tline, "*/")
			break
		else if !StrStartsWith(line, beg_indent)
			throw Exception("Line with wrong indentation!")
		else if StrStartsWith(tline, "@")
			ent["attr_" SubStr(tline,2)] := 1
		else if tline = End of class
			type := "EndClass"
		else if RegExMatch(line, "^" beg_indent "(\s+)([a-zA-Z]+):\s*(.*)$", o)
		{
			if o2 in Library,Function,Constructor,Class,Method,Property,Page
			{
				type := o2, o2 := ""
				if type = Library
					ent := lib
			}
			;value := o3
			ReadValue(value := "", file, beg_indent o1 o1)
			if o2 !=
			{
				if o3
					value := o3 "`n" value
				StringTrimRight, value, value, 1
				ent[o2] := value
			}else
			{
				StringTrimRight, value, value, 1
				ent.name := o3, ent.description := value
			}
		}
	}
	
	if type =
		throw Exception("Element type not specified!")
	
	ent.type := type
	if type != Library
		lib.contents.Insert(ent)
}

ReadValue(ByRef value, file, indent)
{
	while !file.AtEOF
	{
		pos := file.Pos
		line := RTrim(file.ReadLine(), "`r`n")
		tline := LTrim(line)
		if !StrStartsWith(line, indent)
		{
			file.Pos := pos
			break
		}
		value .= SubStr(line, StrLen(indent)+1) "`n"
	}
}

PackClasses(cont)
{
	i := 1
	while i <= cont.MaxIndex()
	{
		if cont[i].type != "Class"
			goto _PC_cont
		last := "", depth := 1, j := i
		while j <= cont.MaxIndex()
		{
			j ++
			if cont[j].type = "EndClass"
			  && !--depth
			{
				last := j
				break
			}else if cont[j].type = "Class"
				depth ++
		}
		if !last || depth
			throw Exception("Endless class!")
		arr := (cont[i].contents := [])
		i ++
		if count := last-i
		{
			Loop, %count%
				arr.Insert(cont[i+A_Index-1])
			PackClasses(arr)
			cont.Remove(i, last-1)
		}
		cont.Remove(i)
		continue
		_PC_cont:
		i ++
	}
}
