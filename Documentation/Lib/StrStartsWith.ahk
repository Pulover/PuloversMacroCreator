;
; File encoding:  UTF-8
;

StrStartsWith(ByRef v, ByRef w)
{
	return SubStr(v, 1, StrLen(w)) = w
}
