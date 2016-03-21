# Functions

## Table of Contents

* [Using Functions](#using-functions)
* [Function parameters](#function-parameters)
* [Array / Objects](#array-/-objects)
* [User-Defined Functions](#user-defined-functions)
* [Run Function from External AHK File](#run-function-from-external-ahk-file)

## Using Functions

Similarly to Variables it's also possible to do function calls and use their outputs in Playback. To call a function, you can go to the *Functions* command window and select the name of the function to be called in the combobox. Type the parameters (if any) in the last field separated by commas in AHK Expressions syntax (do not enclose variables in percent signs and enclose literal strings in quotes). You can optionally type in a variable to receive the functions return value.

To call a Function inside a command's parameter you have to use the same method as Dynamic Variables, preceding the parameter with a percent sign and a space or tab.  

> % StrLen("Some Text")
> % SubStr(MyVar, 3, 7)
> % "Result is: " RegExReplace(Variable, "_", A_Space)

Download Example: [Using Functions inside Command Parameters](Examples/Functions.pmc).

## Function parameters

A Function parameter can be a variable, a number, a string enclosed in quotes or an expression. In expressions variables must not be enclosed in percent signs (except to deference) and literal strings must be enclosed in quotes. You can even use another function call as a function parameter. A complete explanation can be found at [AHK documentation](http://autohotkey.com/docs/Variables.htm#Expressions)


## User-Defined Functions

You can create your own functions inside PMC. A function is similar to a subroutine (like calling a macro tab with Gosub) except that it can accept parameters (inputs) from its caller. In addition, a function may optionally return a value to its caller.

## Run Function from External AHK File