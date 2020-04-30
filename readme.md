# I made a compiler in PowerShell, so you don't have to

DISCLAIMER: This is a proof of concept PowerShell compiler.
This project is for fun and does not serve any real world purpose.
It started as a fun challenge, to explore the capabilities of PowerShell and as a way to find out if a shell scripting language could be used as a compiler.

## Prerequisites

In order to run this compiler, you must have the Gnu C Compiler (GCC) installed on your machine, and it must be added to your path variables.

## The language

The PowerShell Compiled Language is a small language similar to ACL. The language is compiled to C, where after it is compiled to assembly on a given machine.

### The syntax

The language supports two datatypes `int` and `float`, and the operations `+-*/`. Assignment is done, using the `=` operator.
A program can look as follows.

```pcl
int i = 3;
int j = 5;
int k = i + j;
print k;
```

This will produce the output `8`.

## Expanding the language

If you feel confident and want to expand on the PowerShell Compiled Language or feel like something could be improved, don't wait with creating a pull request!
