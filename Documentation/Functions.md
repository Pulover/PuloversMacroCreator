# Functions

## Table of Contents

* [Introduction](#introduction)
* [Calling Functions](#calling-functions)
* [Function parameters](#function-parameters)
* [Array/Object Methods](#array/object-methods)
* [User-Defined Functions](#user-defined-functions)
* [Run Function from External AHK File](#run-function-from-external-ahk-file)

## Introduction

Similarly to Variables it's also possible to do function calls and use their outputs in Playback. A function is similar to a subroutine (like calling a macro tab with Gosub) except that it can accept parameters (inputs) from its caller. In addition, a function may optionally return a value to its caller. PMC supports most every AHK built-in function and, just like in AHK scripts, you can define your own functions, with return values, ByRef parameters, local/global/static variables. Even recursive calls are supported. A detailed explanation can be found at [AHK documentation](https://www.autohotkey.com/docs/Functions.htm)

## Calling Functions

To call a function, you can go to the *Functions* command window and select the name of the function to be called in the combobox. Type the parameters (if any) in the last field separated by commas in AHK Expressions syntax (do not enclose variables in percent signs and enclose literal strings in quotes). You can optionally type in a variable to receive the functions return value.

To call a Function inside a command's parameter you have to use the same method as Dynamic Variables, preceding the parameter with a percent sign and a space or tab:

> % StrLen("Some Text")
> % SubStr(MyVar, 3, 7)
> % "Result is: " RegExReplace(Variable, "_", A_Space)

Download Example: [Using Functions inside Command Parameters](Examples/Functions.pmc)

## Function parameters

A Function parameter can be a variable, a number, a string enclosed in quotes or an expression. In expressions variables must not be enclosed in percent signs (except to deference) and literal strings must be enclosed in quotes. You can even use another function call as a function parameter. A complete explanation can be found at [AHK documentation](https://www.autohotkey.com/docs/Variables.htm#Expressions)

## Array/Object Methods

Default [object methods](https://www.autohotkey.com/docs/objects/Object.htm) are supported, To call a method for an array object, go to *Functions* window and check the *Array Object* option. In that field, enter the name of an object. Select the method and enter the parameters (if any). You can enter an output variable for the returned value.  

You can also call object methods inside a command's parameter:

> % MyArray.Length()
> % MyArray.Push(Var1, Var2)

## User-Defined Functions

You can create your own functions inside PMC. They should work consistent with user-defined functions in AHK in most cases. That means you can execute commands inside them, create and change variables and objects and, most important, return values from it to be used in your scripts. ByRef parameters are supported, as well as local/global/static variables and recursive calls.  

To create a function, click the *Create Function* button on the toolbar. You'll be prompted to choose a name for your function. In the same you window you can define the scope (local or global), a few parameters with optional default values for them and global/local and static variables. After pressing OK a new tab will be created as a function, where you can add more parameters using the *Add Parameter* button and the commands below the Function line. You can also go to Function menu > *Convert Macro To Function* (the selected macro must not contain any Label, Goto or Gosub commands).  

### Remarks

In PMC default values of local and static variables must be one of the following: `True`, `False`, a string or a number (integer or float). Variables and objects are not supported.

### Parameters

In the *Add Parameters* window you can insert more parameters with default values. Adding a default value to a parameter makes it optional, which means it can be skipped in the call and the default value will be used.  
If one parameter is made optional, all following parameters must be optional too.  
A parameter default value must be one of the following: `True`, `False`, a string or a number (integer or float). To set a blank string as the default value, select `_blank` in the list.  
No need to quote strings. Variables are not allowed as default values.  
Check the *[ByRef](https://www.autohotkey.com/docs/Functions.htm#ByRef)* option to make the parameter behave as an alias for the variable passed in from the caller.

Function parameters can only be added **above** the *[FunctionStart]* row.

### Return

Use the *Add Return* button to define return values for the function.  
The return value must be an [expression](https://www.autohotkey.com/docs/Variables.htm#Expressions).  
To return more than one value, use ByRef parameters or an [Array/Object](Variables.html#assigning-and-retrieving-arrays).

Function return can only be added **below** the *[FunctionStart]* row.

Download Example: [User-Defined Functions](Examples/UserFunctions.pmc)  
Download Example: [Display random array element from a function call](Examples/RandomFunction.pmc)

### Remarks

In AutoHotkey scripts it's possible to use Labels, Goto and Gosub inside functions, however in Macro Creator those commands are simulated within the playback internal function, so to avoid loss of information those commands are not allowed inside functions.

## Run Function from External AHK File

If you have AutoHotkey installed, you can call a function from an external .ahk file. Go to *Funtions* window and check the *Use Function from External File* option. Choose the file containing the funtions and select the name of the function, its parameters and a variable to receive the return value.

**Note**: This feature is very limited as it can only receive one return value and it does not support objects or ByRef parameters. It's recommended to rewrite the function using an User-Defined function whenever possible.


