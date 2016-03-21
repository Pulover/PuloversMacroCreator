# Variables & Functions

## Table of Contents

* [Using Variables](#using-variables)
* [Assigning Variables](#assigning-variables)
* [Comparing Variables](#comparing-variables)
* [Assigning And Retrieving Arrays](#assigning-and-retrieving-arrays)
* [Built-in Variables](#built-in-variables)
* [Dynamic Variable References](#dynamic-variable-references)

## Using Variables

Any single word enclosed in percent signs (e.g. *%MyVar%*) inside a string will be converted to the variable's contents during playback. That means you can use variables in *Text* or *MsgBox* and other commands. For example you can copy a text and send it using *ControlSend* or *ControlSetText* directly from the clipboard.

> Today is %A_DDDD% and it's %A_Hour%:%A_Min%.
> Clipboard's contents are: %Clipboard%

Download Example: [Using Variables inside Command Parameters](Examples/Variables.pmc).

## Assigning Variables

Most commands and functions outputs variables with the result of its operation. You can also create and modify variables in the *Variables* window. Type a valid variable name, select one of the operators and input a value.

> MyVar := Some Text
> Counter += 1
> NewVar := %MyVar% and some text.

Check the option *Expression* to use Auto-Hotkey Expressions format in the value field. With expressions you can execute math operations, functions, assignments and object calls.  
In expressions variables must not be enclosed in percent signs (except to deference) and literal strings must be enclosed in quotes. A complete explanation can be found at [AHK documentation](http://autohotkey.com/docs/Variables.htm#Expressions).

> MyVar := 30 * 100 / 200 ; This would assign 15 to MyVar
> MyVar := Number + 100 ; This would assign the value from variable Number + 100 to MyVar
> MyVar := StrLen("Some string") ; This would assign 11 to MyVar

### Boolean Assignment

To switch a variable's value True <> False use an exclamation in from of the value. Variable must be enclosed in percent signs.

> MyVar := !%MyVar%

## Dynamic Variable References

*From AutoHotkey Help File*:  
**Force an expression**: An expression can be used in a parameter that does not directly support it (except an OutputVar or InputVar parameter such as those of StringLen) by preceding the expression with a percent sign and a space or tab. If a variable is enclosed in percent signs within an expression (e.g. *%Var%*), whatever that variable contains is assumed to be the name or partial name of another variable (if there is no such variable, %Var% resolves to a blank string). This is most commonly used to reference pseudo-array elements such as the following example:

> FileAppend, % MyArray%i%, My File.txt

Download Example: [Accessing a Pseudo-Array inside Command Parameters](Examples/DynamicVars.pmc).

### Remarks

You can assign *User Global Variables* with pre-defined contents that will be always available in Playback and for exporting in [Settings](p7-Settings.html#user-global-variables).  

## Comparing Variables

To compare variables click the *If Statements* button, you may select *Evaluate Expression* to test any valid expresssion or select *Compare Variables* in the dropdown list. In the edit box you can enter a valid syntax to create the If Statement for comparing such as:

> MyVar = 5
> Clipboard > %MyVar%

In the *Compare Variables* option the *Variable* field must be a single variable word (not in percent signs) and the *Value* field you can enter any literal value and variables enclosed in percent signs.  

The operators accepted are:

> = == <> != > < >= <=

In the *Evaluate Expression* option you can enter any valid expression, including multiple statements and ternary.  
In expressions variables must not be enclosed in percent signs (except to deference) and literal strings must be enclosed in quotes. A complete explanation can be found at [AHK documentation](http://autohotkey.com/docs/Variables.htm#Expressions)

Download Example: [Comparing Variables in Playback](Examples/CompareVars.pmc).

## Assigning And Retrieving Arrays

**Pulover's Macro Creator** supports objects/arrays. To assign an array you can either go the *Variables* window, check "Expression" option and add comma separated values inside brackets:

> MyArray := [10,20,aVariable,"aString"])  ; Inside the Variables Assignment window

Or use the *Array* function in the *Functions* window.  

You can also assign Associative arrays in the *Variables* window. With the "Expression" option checked, enter keys and values in the following format:

> {key1: "string value", key2: varValue}

To retrieve an array inside a command use the same method as *Dynamic Variable Reference* by preceding the parameter with a percent sign and the following syntax:

> % MyArray[1]
> % MyArray[X]    ; For arrays it's not necessary to enclose variables in percent signs.
> % MyArray[Var]  ; The key/index can be a variable or expression.

You can also use dotted syntax:

> % MyArray.5

You can access the number of items inside the array using the MaxIndex() method in the Variables Assignment window when the "Expression" option is checked:

> MyArray := [10,20,30]                 ; Assign an array inside
> ArrayCount := MyArray.MaxIndex()      ; Returns 3
> ArrayCount := MyArray.MaxIndex() + 1  ; Returns 4

You can also get a reference to MaxIndex inside a Dynamic References, but you cannot combine it with other expressions such as Array.MaxIndex + 1.

> % MyArray.MaxIndex()  ; Inside any command, but without math operations.

A [For-Loop](Commands/For_Loop.html) can be used to retrieve the values one by one (an example is included in the link below).

Download Example: [Assigning and retrieving an Array inside Command Parameters](Examples/Arrays.pmc).  

## Built-in Variables

Built-in Variables can be used inside the program to reference dynamic information. A list of these Variables with their description can be found in the [AutoHotkey documentation](http://ahkscript.org/docs/Variables.htm#builtin).  
You can also insert Built-in Variables into command window fields by right-clicking on any empty area and selecting the *Built-in Variables* submenu where you'll find them divided in categories. Select one of them it will be inserted in the Carater-Insert position (already enclosed in percent signs).

## Using Functions

Similarly to Variables it's also possible to use built-In Function results in Playback. To use a Function Call inside a command's parameter you have to use the same method as Dynamic Variables by preceding each Function with a percent sign and a space or tab.  

> % StrLen(Some Text)
> % SubStr(%MyVar%, 3, 7)
> Result is: % RegExReplace(%Variable%, _, %A_Space%)

*Notes*:  
* Since Playback uses a function to dereference variables before assigning, variables references should be enclosed in percent signs. The syntax will be corrected for the exported script.  
* Literal commas should be escaped.  
> % SubStr(This is`, a literal comma, 13)
* It's not necessary to use "quotes" for string parameters EXCEPT for blank parameters.  
* Omitted parameters will use their default values just like a normal Function Call.  

Download Example: [Using Functions inside Command Parameters](Examples/Functions.pmc).

### Remarks

Because **Macro Creator** uses a function that recognizes patterns using RegExMatch in order to convert Variables and Functions to their results it will allow some non-standard usage of Function Calls like in this example:

> % SubStr(AutoHotkey, 1, 1)% SubStr(AutoHotkey, 5, 1)K

If you put this into a Message Box command for Playback it will show "AHK", but the generated AHK script for this (in Preview or Export) would throw an error when you run it from an .ahk file since it has two leading percent signs and the K should be enclosed in quotes to be recognized as a string and not a variable.

## eval()

**Eval()** is a function written by **Laszlo** to solve Math Expressions in Strings. It can be found at AHK Forum [Monster: evaluate math expressions in strings](http://www.autohotkey.com/board/topic/15675-monster).

This function has been integrated into **Macro Creator** to allow it to solve math expressions when assigning variables during playback (if Use Eval() option is enabled).

**Example**: When you use the Image Search (or Pixel Search) command, the found coordinates are saved to the variables *%FoundX%* and *%FoundY%* that would point to the top-left corner of the image.  
Now suppose we want to move the mouse 100 pixels right and 100 pixels down to click on an offset from the image position (Mouse coordinates accept variables). Without this function you'd have to first assign new variables:

> NewVarX := %FoundX%
> NewVarY := %FoundY%

And then add another assignment for those variables with:

> NewVarX += 100
> NewVarY += 100

If you check the *Use Eval()* option you can use the following directly in the first assignments to get the same results:

> NewVarX := %FoundX% + 100
> NewVarX := %FoundY% + 100

The [Variables Example](Examples/Variables.pmc) has a demonstration of this usage.

**Eval()** can also be used inside command parameters as described in Functions.