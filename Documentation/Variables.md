# Variables & Functions

## Table of Contents

* [Built-in Variables](#built-in-variables)
* [Using Variables In Playback](#using-variables-in-playback)
* [Assigning And Comparing Variables](#assigning-and-comparing-variables)
* [Assigning And Retrieving Arrays](#assigning-and-retrieving-arrays)
* [Dynamic Variable References](#dynamic-variable-references)
* [Using Functions In Playback](#using-functions-in-playback)
* [Eval()](#eval)

## Built-in Variables

Built-in Variables can be used inside the program to reference dynamic information. A list of these Variables with their description can be found in the [AutoHotkey documentation](http://ahkscript.org/docs/Variables.htm#builtin).  
You can also insert Built-in Variables into command window fields by right-clicking on any empty area and selecting the *Built-in Variables* submenu where you'll find them divided in categories. Select one of them it will be inserted in the Carater-Insert position (already enclosed in percent signs).

## Using Variables In Playback

Any single word enclosed in percent signs (e.g. *%MyVar%*) inside a string in the Details, Control and Window columns will be converted to the variable's contents during playback. That means you can use variables in *Text* or *MsgBox* and other commands. For example you can copy a text and send it using *ControlSend* or *ControlSetText* directly from the clipboard.

> Today is %A_DDDD% and it's %A_Hour%:%A_Min%.
> Clipboard's contents are: %Clipboard%

Download Example: [Using Variables inside Command Parameters](Examples\Variables.pmc).

## Assigning And Comparing Variables

To create or modify a Variable click in the *If* button and the *Assign Variable* tab, type a valid variable name, select one of the operators and a value.

> MyVar := Some Text
> Counter += 1
> NewVar := %MyVar% and some text.

The option *Use Eval() to solve expressions* allows you to use the Eval() function (more info at the bottom of this page) to solve math expressions during assingment so that the variable's contents will be the result of the operation.

> MyVar := 30 * 100 / 200 ; This would assign 15 to MyVar
> MyVar := %Number% + 100 ; This would assign the value from variable Number + 100 to MyVar

To compare variables click the *If* button and the *If Statements* tab, you may select *Evaluate Expression* to test any valid expresssion or select *Compare Variables* in the dropdown list. In the edit box you can enter a valid syntax to create the If Statement for comparing such as:

> MyVar = 5
> Clipboard > %MyVar%

The operators accepted are:

> = == <> != > < >= <=

Download Example: [Comparing Variables in Playback](Examples\CompareVars.pmc).

*Note*: The *Compare Variables* options is limited to two arguments, *Evaluate Expression* uses the *Eval()* function so is more flexible. For *Evaluate Expression* all variables must be enclosed in percent signs.

### Remarks

In order to assign variables values to other variables (e.g. *MyVar := Clipboard*) you will have to use percent signs even though it's not the correct syntax for AHK, so the program will show *MyVar := %Clipboard%* in details but it will correct the syntax for exported scripts.

The exported script (as well as the preview window) will auto correct *MyVar := %Clipboard%* to *MyVar := Clipboard* and *MyVar := Clipboard* to *MyVar := "Clipboard"*. It should also correct the combination of both Vars and Strings like *MyVar := Today is %A_DDD%* to *MyVar := "Today is " A_DDD* EXCEPT when using the *Eval()* option in which case only math expressions and variables should be used.

You can assign *User Global Variables* with contents defined by user that will be always available in Playback and for exporting in [Settings](p7-Settings.html#user-global-variables).  

### Boolean Assignment

To switch a variable's value True <> False use an exclamation in from of the value. Variable must be enclosed in percent signs.

> MyVar := !%MyVar%

## Dynamic Variable References

*From AutoHotkey Help File*:  
**Force an expression**: An expression can be used in a parameter that does not directly support it (except an OutputVar or InputVar parameter such as those of StringLen) by preceding the expression with a percent sign and a space or tab. If a variable is enclosed in percent signs within an expression (e.g. *%Var%*), whatever that variable contains is assumed to be the name or partial name of another variable (if there is no such variable, %Var% resolves to a blank string). This is most commonly used to reference pseudo-array elements such as the following example:

> FileAppend, % MyArray%i%, My File.txt

Although **Macro Creator doesn't actually supports Expressions** in the same way it uses this method to reference a Dynamic Variable (or a Function Call) and access arrays (such as the ones created by StringSplit) in command's parameters as well.  
*Note*: Field must start with "% " and must contain only ONE reference.

Download Example: [Accessing a Pseudo-Array inside Command Parameters](Examples\DynamicVars.pmc).

## Assigning And Retrieving Arrays

**Pulover's Macro Creator** supports basic arrays usage. To assign an array you can use the *Array* function in the *Functions* window.  
To retrieve an array inside a command use the same method as *Dynamic Variable Reference* by preceding the parameter with a percent sign and the following syntax:

> % MyArray[1]
> % MyArray[X]    ; For arrays it's not necessary to enclose variables in percent signs.
> % MyArray[Var]  ; Any non-number parameter will be treated as a variable.

Download Example: [Assigning and retrieving an Array inside Command Parameters](Examples\Arrays.pmc).

## Using Functions In Playback

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

Download Example: [Using Functions inside Command Parameters](Examples\Functions.pmc).

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

The [Variables Example](Examples\Variables.pmc) has a demonstration of this usage.

**Eval()** can also be used inside command parameters as described in Functions.
