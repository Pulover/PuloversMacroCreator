; MONSTER Version 1.2 to EVALUATE ARITHMETIC EXPRESSIONS in strings (needs AHK 1.0.48+)
; Containing HEX, Signed Binary ('11 = -1, '011 = 3), scientific numbers (1.2e+5)
; Assignments :=, preceding an expression. E.g: a:=1; b:=2; a+b
; User defined functions: f(x) := expr;
; AHK Functions Abs|Ceil|Exp|Floor|Log|Ln|Round|Sqrt|Sin|Cos|Tan|ASin|ACos|ATan
; Predefined functions: SGN|Fib|Fac (sign, Fibonacci numbers, Factorials)
; '(',')'; Variables; Predefined operators GCD,MIN,MAX,Choose (2-parameter functions)
; Predefined constants: e, pi, inch, foot, mile, ounce, pint, gallon, oz, lb;
; Logic operators: !, ||, &&; ternary operator: (_?_:_);
; Relations: =,<>; <,>,<=,>=
; Binary operators: ~; |, ^, &, <<, >>
; Arithmetic operators: +, -; *, /, \ (or % = mod); ** (or @ = power)
; Output FORMAT: $x,$h: Hex; $b{W}: W-bit binary;
;    ${k}: k-digit fixpoint,  ${k}e,${k}g: k-digit scientific (Default $6g)

#SingleInstance Force
#NoEnv
SetBatchLines -1
Process Priority,,High

xe := 2.718281828459045, xpi := 3.141592653589793      ; referenced as "e", "pi"
xinch := 2.54, xfoot := 30.48, xmile := 1.609344       ; [cm], [cm], [Km]
xounce := 0.02841, xpint := 0.5682, xgallon := 4.54609 ; liters
xoz := 28.35, xlb := 453.59237                         ; gramms

/* -test cases
MsgBox % Eval("1e1")                                               ; 10
MsgBox % Eval("0x1E")                                              ; 30
MsgBox % Eval("ToBin(35)")                                         ; 100011
MsgBox % Eval("$b 35")                                             ; 0100011
MsgBox % Eval("'10010")                                            ; -14
MsgBox % Eval("2>3 ? 9 : 7")                                       ; 7
MsgBox % Eval("$2E 1e3 -50.0e+0 + 100.e-1")                        ; 9.60E+002
MsgBox % Eval("fact(x) := x < 2 ? 1 : x*fact(x-1); fact(5)")       ; 120
MsgBox % Eval("f(ab):=sqrt(ab)/ab; y:=f(2); ff(y):=y*(y-1)/2/x; x := 2; y+ff(3)/f(16)") ; 6.70711
MsgBox % Eval("x := qq:1; x := 5*x; y := x+1")                     ; 6 [if y empty, x := 1...]
MsgBox % Eval("x:=-!0; x<0 ? 2*x : sqrt(x)")                       ; -2
MsgBox % Eval("tan(atan(atan(tan(1))))-exp(sqrt(1))")              ; -1.71828
MsgBox % Eval("---2+++9 + ~-2 --1 -2*-3")                          ; 15
MsgBox % Eval("x1:=1; f1:=sin(x1)/x1; y:=2; f2:=sin(y)/y; f1/f2")  ; 1.85082
MsgBox % Eval("Round(fac(10)/fac(5)**2) - (10 choose 5) + Fib(8)") ; 21
MsgBox % Eval("1 min-1 min-2 min 2")                               ; -2
MsgBox % Eval("(-1>>1<=9 && 3>2)<<2>>1")                           ; 2
MsgBox % Eval("(1 = 1) + (2<>3 || 2 < 1) + (9>=-1 && 3>2)")        ; 3
MsgBox % Eval("$b6 -21/3")                                         ; 111001
MsgBox % Eval("$b ('1001 << 5) | '01000")                          ; 100101000
MsgBox % Eval("$0 194*lb/1000")                                    ; 88 [Kg]
MsgBox % Eval("$x ~0xfffffff0 & 7 | 0x100 << 2")                   ; 0x407
MsgBox % Eval("- 1 * (+pi -((3%5))) +pi+ 1-2 + e-ROUND(abs(sqrt(floor(2)))**2)-e+pi $9") ; 3.141592654
MsgBox % Eval("(20+4 GCD abs(2**4)) + (9 GCD (6 CHOOSE 2))")       ; 11
t := A_TickCount
Loop 1000
   r := Eval("x:=" A_Index/1000 ";atan(x)-exp(sqrt(x))")           ; simulated plot
t := A_TickCount - t
MsgBox Result = %r%`nTime = %t%                                    ; -1.93288: ~400 ms [on Inspiron 9300]
*/

^#-::                                  ; Replace selection or `expression with result
^#=::                                  ; Append result to selection or `expression
   ClipBoard =
   SendInput ^c                        ; copy selection
   ClipWait 0.5
   If (ErrorLevel) {
      SendInput +{HOME}^c              ; copy, keep selection to overwrite (^x for some apps)
      ClipWait 1
      IfEqual ErrorLevel,1, Return
      If RegExMatch(ClipBoard, "(.*)(``)(.*)", y)
         SendInput %  "{RAW}" y1 . (A_ThisHotKey="^#=" ? y3 . " = "  : "") . Eval(y3)
   } Else
      SendInput % "{RAW}" . (A_ThisHotKey="^#=" ? ClipBoard . " = "  : "") . Eval(ClipBoard)
Return

Eval(x) {                              ; non-recursive PRE/POST PROCESSING: I/O forms, numbers, ops, ";"
   Local FORM, FormF, FormI, i, W, y, y1, y2, y3, y4
   FormI := A_FormatInteger, FormF := A_FormatFloat

   SetFormat Integer, D                ; decimal intermediate results!
   RegExMatch(x, "\$(b|h|x|)(\d*[eEgG]?)", y)
   FORM := y1, W := y2                 ; HeX, Bin, .{digits} output format
   SetFormat FLOAT, 0.16e              ; Full intermediate float precision
   StringReplace x, x, %y%             ; remove $..
   Loop
      If RegExMatch(x, "i)(.*)(0x[a-f\d]*)(.*)", y)
         x := y1 . y2+0 . y3           ; convert hex numbers to decimal
      Else Break
   Loop
      If RegExMatch(x, "(.*)'([01]*)(.*)", y)
         x := y1 . FromBin(y2) . y3    ; convert binary numbers to decimal: sign = first bit
      Else Break
   x := RegExReplace(x,"(^|[^.\d])(\d+)(e|E)","$1$2.$3") ; add missing '.' before E (1e3 -> 1.e3)
                                       ; literal scientific numbers between ‘ and ’ chars
   x := RegExReplace(x,"(\d*\.\d*|\d)([eE][+-]?\d+)","‘$1$2’")

   StringReplace x, x,`%, \, All       ; %  -> \ (= MOD)
   StringReplace x, x, **,@, All       ; ** -> @ for easier process
   StringReplace x, x, +, ±, All       ; ± is addition
   x := RegExReplace(x,"(‘[^’]*)±","$1+") ; ...not inside literal numbers
   StringReplace x, x, -, ¬, All       ; ¬ is subtraction
   x := RegExReplace(x,"(‘[^’]*)¬","$1-") ; ...not inside literal numbers

   Loop Parse, x, `;
      y := Eval1(A_LoopField)          ; work on pre-processed sub expressions
                                       ; return result of last sub-expression (numeric)
   If FORM = b                         ; convert output to binary
      y := W ? ToBinW(Round(y),W) : ToBin(Round(y))
   Else If (FORM="h" or FORM="x") {
      SetFormat Integer, Hex           ; convert output to hex
      y := Round(y) + 0
   }
   Else {
      W := W="" ? "0.6g" : "0." . W    ; Set output form, Default = 6 decimal places
      SetFormat FLOAT, %W%
      y += 0.0
   }
   SetFormat Integer, %FormI%          ; restore original formats
   SetFormat FLOAT,   %FormF%
   Return y
}

Eval1(x) {                             ; recursive PREPROCESSING of :=, vars, (..) [decimal, no ";"]
   Local i, y, y1, y2, y3
                                       ; save function definition: f(x) := expr
   If RegExMatch(x, "(\S*?)\((.*?)\)\s*:=\s*(.*)", y) {
      f%y1%__X := y2, f%y1%__F := y3
      Return
   }
                                       ; execute leftmost ":=" operator of a := b := ...
   If RegExMatch(x, "(\S*?)\s*:=\s*(.*)", y) {
      y := "x" . y1                    ; user vars internally start with x to avoid name conflicts
      Return %y% := Eval1(y2)
   }
                                       ; here: no variable to the left of last ":="
   x := RegExReplace(x,"([\)’.\w]\s+|[\)’])([a-z_A-Z]+)","$1«$2»")  ; op -> «op»

   x := RegExReplace(x,"\s+")          ; remove spaces, tabs, newlines

   x := RegExReplace(x,"([a-z_A-Z]\w*)\(","'$1'(") ; func( -> 'func'( to avoid atan|tan conflicts

   x := RegExReplace(x,"([a-z_A-Z]\w*)([^\w'»’]|$)","%x$1%$2") ; VAR -> %xVAR%
   x := RegExReplace(x,"(‘[^’]*)%x[eE]%","$1e") ; in numbers %xe% -> e
   x := RegExReplace(x,"‘|’")          ; no more need for number markers
   Transform x, Deref, %x%             ; dereference all right-hand-side %var%-s

   Loop {                              ; find last innermost (..)
      If RegExMatch(x, "(.*)\(([^\(\)]*)\)(.*)", y)
         x := y1 . Eval@(y2) . y3      ; replace (x) with value of x
      Else Break
   }
   Return Eval@(x)
}

Eval@(x) {                             ; EVALUATE PRE-PROCESSED EXPRESSIONS [decimal, NO space, vars, (..), ";", ":="]
   Local i, y, y1, y2, y3, y4

   If x is number                      ; no more operators left
      Return x
                                       ; execute rightmost ?,: operator
   RegExMatch(x, "(.*)(\?|:)(.*)", y)
   IfEqual y2,?,  Return Eval@(y1) ? Eval@(y3) : ""
   IfEqual y2,:,  Return ((y := Eval@(y1)) = "" ? Eval@(y3) : y)

   StringGetPos i, x, ||, R            ; execute rightmost || operator
   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i)) || Eval@(SubStr(x,3+i))
   StringGetPos i, x, &&, R            ; execute rightmost && operator
   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i)) && Eval@(SubStr(x,3+i))
                                       ; execute rightmost =, <> operator
   RegExMatch(x, "(.*)(?<![\<\>])(\<\>|=)(.*)", y)
   IfEqual y2,=,  Return Eval@(y1) =  Eval@(y3)
   IfEqual y2,<>, Return Eval@(y1) <> Eval@(y3)
                                       ; execute rightmost <,>,<=,>= operator
   RegExMatch(x, "(.*)(?<![\<\>])(\<=?|\>=?)(?![\<\>])(.*)", y)
   IfEqual y2,<,  Return Eval@(y1) <  Eval@(y3)
   IfEqual y2,>,  Return Eval@(y1) >  Eval@(y3)
   IfEqual y2,<=, Return Eval@(y1) <= Eval@(y3)
   IfEqual y2,>=, Return Eval@(y1) >= Eval@(y3)
                                       ; execute rightmost user operator (low precedence)
   RegExMatch(x, "i)(.*)«(.*?)»(.*)", y)
   If IsFunc(y2)
      Return %y2%(Eval@(y1),Eval@(y3)) ; predefined relational ops

   StringGetPos i, x, |, R             ; execute rightmost | operator
   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i)) | Eval@(SubStr(x,2+i))
   StringGetPos i, x, ^, R             ; execute rightmost ^ operator
   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i)) ^ Eval@(SubStr(x,2+i))
   StringGetPos i, x, &, R             ; execute rightmost & operator
   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i)) & Eval@(SubStr(x,2+i))
                                       ; execute rightmost <<, >> operator
   RegExMatch(x, "(.*)(\<\<|\>\>)(.*)", y)
   IfEqual y2,<<, Return Eval@(y1) << Eval@(y3)
   IfEqual y2,>>, Return Eval@(y1) >> Eval@(y3)
                                       ; execute rightmost +- (not unary) operator
   RegExMatch(x, "(.*[^!\~±¬\@\*/\\])(±|¬)(.*)", y) ; lower precedence ops already handled
   IfEqual y2,±,  Return Eval@(y1) + Eval@(y3)
   IfEqual y2,¬,  Return Eval@(y1) - Eval@(y3)
                                       ; execute rightmost */% operator
   RegExMatch(x, "(.*)(\*|/|\\)(.*)", y)
   IfEqual y2,*,  Return Eval@(y1) * Eval@(y3)
   IfEqual y2,/,  Return Eval@(y1) / Eval@(y3)
   IfEqual y2,\,  Return Mod(Eval@(y1),Eval@(y3))
                                       ; execute rightmost power
   StringGetPos i, x, @, R
   IfGreaterOrEqual i,0, Return Eval@(SubStr(x,1,i)) ** Eval@(SubStr(x,2+i))
                                       ; execute rightmost function, unary operator
   If !RegExMatch(x,"(.*)(!|±|¬|~|'(.*)')(.*)", y)
      Return x                         ; no more function (y1 <> "" only at multiple unaries: --+-)
   IfEqual y2,!,Return Eval@(y1 . !y4) ; unary !
   IfEqual y2,±,Return Eval@(y1 .  y4) ; unary +
   IfEqual y2,¬,Return Eval@(y1 . -y4) ; unary - (they behave like functions)
   IfEqual y2,~,Return Eval@(y1 . ~y4) ; unary ~
   If IsFunc(y3)
      Return Eval@(y1 . %y3%(y4))      ; built-in and predefined functions(y4)
   Return Eval@(y1 . Eval1(RegExReplace(f%y3%__F, f%y3%__X, y4))) ; LAST: user defined functions
}

ToBin(n) {      ; Binary representation of n. 1st bit is SIGN: -8 -> 1000, -1 -> 1, 0 -> 0, 8 -> 01000
   Return n=0||n=-1 ? -n : ToBin(n>>1) . n&1
}
ToBinW(n,W=8) { ; LS W-bits of Binary representation of n
   Loop %W%     ; Recursive (slower): Return W=1 ? n&1 : ToBinW(n>>1,W-1) . n&1
      b := n&1 . b, n >>= 1
   Return b
}
FromBin(bits) { ; Number converted from the binary "bits" string, 1st bit is SIGN
   n = 0
   Loop Parse, bits
      n += n + A_LoopField
   Return n - (SubStr(bits,1,1)<<StrLen(bits))
}

Sgn(x) {
   Return (x>0)-(x<0)
}

MIN(a,b) {
   Return a<b ? a : b
}
MAX(a,b) {
   Return a<b ? b : a
}
GCD(a,b) {      ; Euclidean GCD
   Return b=0 ? Abs(a) : GCD(b, mod(a,b))
}
Choose(n,k) {   ; Binomial coefficient
   p := 1, i := 0, k := k < n-k ? k : n-k
   Loop %k%                   ; Recursive (slower): Return k = 0 ? 1 : Choose(n-1,k-1)*n//k
      p *= (n-i)/(k-i), i+=1  ; FOR INTEGERS: p *= n-i, p //= ++i
   Return Round(p)
}

Fib(n) {        ; n-th Fibonacci number (n < 0 OK, iterative to avoid globals)
   a := 0, b := 1
   Loop % abs(n)-1
      c := b, b += a, a := c
   Return n=0 ? 0 : n>0 || n&1 ? b : -b
}
fac(n) {        ; n!
   Return n<2 ? 1 : n*fac(n-1)
}
