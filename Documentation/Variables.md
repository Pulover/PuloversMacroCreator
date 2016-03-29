# Variables & Arrays/Objects

## Table of Contents

* [Introduction](#introduction)
* [Using Variables](#using-variables)
* [Assigning Variables](#assigning-variables)
* [Expressions](#expressions)
* [Comparing Variables](#comparing-variables)
* [Assigning And Retrieving Arrays](#assigning-and-retrieving-arrays)
* [Built-in Variables](#built-in-variables)
* [Expressions in command parameters](#expressions-in-command-parameters)

## Introduction

Variables are used to hold data. Whether it's a text, number or any other, you can assign a value to a variable and use it with commands and functions. Most commands and functions will output a value as the result of its operation into a variable of your choice, for example the OutputVar of the `Random` command will be used to hold the randomly gererated number.

> Random, Rand, 10, 50 ; The Rand variable will have a number between 10 and 50 after the command executes.

You can use this variable inside another command by enclosing it in percent signs.

> Click, 300, %Rand% Left, 1 ; The Y coordinate will be a random number.

To use a variable inside a function parameter or expression, do not enclose it in percent signs.

> MyVar := "AutoHotkey"
> HK := SubStr(MyVar, 6)

A detailed explanation about Variables can be found at the [AHK documentation](http://autohotkey.com/docs/Variables.htm).

### Remarks

**Pulover's Macro Creator** is written in AutoHotkey language, and so it has internal variables in the same environment as user-defined variables. Therefore if you choose a variable name that's used by internally by PMC you may run into inconsistencies and even crash the program.  
PMC will warn you with a traytip if it notices you are using some of its reserved words, but it's impossible to monitor every single situation where and variable to avoid such conflicts, so it's recommended to follow these guidelines when choosing a variable name:

* Do not use very short words, such as "a" or "vr". Use variable names that are at least 3 characters long.
* Do not use variable names starting with numbers or symbols like "_" or "$".
* Avoid commonly used words like "var", "par", "func", etc.

## Using Variables

Any single word enclosed in percent signs (e.g. `%MyVar%`) inside a string will be converted to the variable's contents during playback. That means you can use variables in `Text` or `MsgBox` and other commands. For example you can copy a text and send it using `ControlSend` or `ControlSetText` directly from the clipboard.

> Today is %A_DDDD% and it's %A_Hour%:%A_Min%.
> Clipboard's contents are: %Clipboard%

Download Example: [Using Variables inside Command Parameters](Examples/Variables.pmc).

## Assigning Variables

Most commands and functions outputs variables with the result of its operation. You can also create and modify variables in the **Variables** window. Type a valid variable name, select one of the operators and input a value.

> MyVar := "Some Text"
> Counter += 1
> NewVar := MyVar " and some text."

**Note**: This is the correct syntax in AHK, but if you don't have the *Expression* option checked you can enter values without quotes and use percent signs for variables, e.g.: %MyVar% and some text, and it will be converted for preview and export.

## Expressions

Check the option *Expression* to use AutoHotkey Expressions format in the value field. With expressions you can execute math operations, functions, assignments and object calls.  
In expressions variables must not be enclosed in percent signs (except to deference) and literal strings must be enclosed in quotes. A complete explanation can be found at [AHK documentation](http://autohotkey.com/docs/Variables.htm#Expressions).

> MyVar := 30 * 100 / 200 ; This would assign 15 to MyVar
> MyVar := Number + 100 ; This would assign the value from variable Number + 100 to MyVar
> MyVar := StrLen("Some string") ; This would assign 11 to MyVar

Since version 5.0.0, Expression format must be used for Function parameters and COM expressions.

### Boolean Assignment

To switch a variable's value True <> False use an exclamation in from of the value. Variable must be enclosed in percent signs.

> MyVar := !MyVar ; Or !%MyVar% without Expression checked

## Expressions in command parameters

*From AutoHotkey Help File*:  
**Force an expression**: An expression can be used in a parameter that does not directly support it (except an OutputVar or InputVar parameter such as those of StringLen) by preceding the expression with a percent sign and a space or tab. If a variable is enclosed in percent signs within an expression (e.g. `%Var`*), whatever that variable contains is assumed to be the name or partial name of another variable (if there is no such variable, %Var% resolves to a blank string). This is most commonly used to reference pseudo-array elements such as the following example:

> FileAppend, % MyArray%i%, My File.txt

Download Example: [Accessing a Pseudo-Array inside Command Parameters](Examples/DynamicVars.pmc).

### Remarks

You can assign *User Global Variables* with pre-defined contents that will be always available in Playback and for exporting in [Settings](Settings.html#user-global-variables).  

## Comparing Variables

To compare variables click the *If Statements* button, you may select *Evaluate Expression* to test any valid expresssion or select *Compare Variables* in the dropdown list. In the edit box you can enter a valid syntax to create the If Statement for comparing such as:

> MyVar = 5
> Clipboard > %MyVar%

If the result is blank or 0 it's evaluated as false. Any other value, number or string, is evaluated as true.  

In the *Compare Variables* option the *Variable* field must be a single variable word (not in percent signs) and the *Value* field you can enter any literal value and variables enclosed in percent signs.  

The operators accepted are:

> = == <> != > < >= <=

In the *Evaluate Expression* option you can enter any valid expression, including multiple statements.

> MyVar > 10 && MyVar < 20

In expressions variables must not be enclosed in percent signs (except to deference) and literal strings must be enclosed in quotes. A complete explanation can be found at [AHK documentation](http://autohotkey.com/docs/Variables.htm#Expressions)

Download Example: [Comparing Variables in Playback](Examples/CompareVars.pmc).

## Assigning And Retrieving Arrays

**Pulover's Macro Creator** supports objects/arrays. To assign an array you can either go the *Variables* window, check "Expression" option and add comma separated values inside brackets:

> MyArray := [10, 20, aVariable, "aString"])  ; Inside the Variables Assignment window

Or use the *Array* function in the *Functions* window. More information about objects can be found at the [AHK Documentaion](http://autohotkey.com/docs/Objects.htm).  

You can also assign Associative arrays in the *Variables* window. With the "Expression" option checked, enter keys and values in the following format:

> {key1: "string value", key2: varValue}

To retrieve an array inside a command use the same method as *Dynamic Variable Reference* by preceding the parameter with a percent sign and the following syntaxes:

> % MyArray[1]
> % MyArray[X] ; For arrays it's not necessary to enclose variables in percent signs.
> % MyArray[Var] ; The key/index can be a variable, number, string or expression.
> % MyArray["Type"]
> % MyArray.Name ; Dotted syntax is also supported, and you can mix both brackets and dots too.

You can access the number of items inside the array using the Length() method in the Variables Assignment window when the "Expression" option is checked:

> MyArray := [10, 20, 30] ; Assign an array inside
> ArrayCount := MyArray.Length() ; Returns 3
> ArrayCount := MyArray.Length() + 1 ; Returns 4

The *Output Variable* field in Variables and Functions window, and the *Object Array* field in Functions window also accept array elements:

> MyArray[1] := "New value"
> Family.Father.Name := "John"

You can also get a reference to Length inside a Dynamic References:

> % MyArray.Length() ; Inside any command.

A [For-Loop](Commands/For_Loop.html) can be used to retrieve the values one by one (an example is included in the link below).

Download Example: [Assigning and retrieving Arrays](Examples/Arrays.pmc).  

## Built-in Variables

Built-in Variables can be used inside the program to reference dynamic information. A list of these Variables with their description can be found in the [AutoHotkey documentation](http://ahkscript.org/docs/Variables.htm#builtin).  
You can also insert Built-in Variables into command window fields by right-clicking on any empty area and selecting the *Built-in Variables* submenu where you'll find them divided in categories. Select one of them it will be inserted in the Carater-Insert position (already enclosed in percent signs).