# Functions

## Table of Contents

* [Using Functions](#using-functions)
* [Function parameters](#function-parameters)
* [User-Defined Functions](#user-defined-functions)

## Using Functions

Similarly to Variables it's also possible to do function calls and use their outputs in Playback. To call a Function inside a command's parameter you have to use the same method as Dynamic Variables by preceding each Function with a percent sign and a space or tab.  

> % StrLen("Some Text")
> % SubStr(MyVar, 3, 7)
> Result is: % RegExReplace(Variable, "_", A_Space)

Download Example: [Using Functions inside Command Parameters](Examples/Functions.pmc).

## Function parameters

Function parameters can be a variable, a number, a string enclosed in quotes or an expression. In expressions variables must not be enclosed in percent signs (except to deference) and literal strings must be enclosed in quotes. You can even use another function call as a function parameter. A complete explanation can be found at [AHK documentation](http://autohotkey.com/docs/Variables.htm#Expressions)

