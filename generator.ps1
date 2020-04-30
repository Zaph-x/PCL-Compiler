<# 
This is a proof of concept powershell compiler.
This project is for fun and does not serve any real world purpose.

This is generator.ps1 - The generator in the compiler

Zaph-x @ 30-apr 2020, 6:05 PM
#>

$name = $args[0].Replace(".pcl", "")

$template = "
#include <stdio.h>`n
`n
int main(void) {`n
%CODE%
}
"
$codeblock = ""
foreach ($token in $Global:tokens) {
    switch ($token.Type) {
        "KEYWORD" { 
            if ($token.Value -eq "int") {
                $codeblock += "    int "
            } elseif ($token.Value -eq "float") {
                $codeblock += "    float "
            } elseif ($token.Value -eq "print") {
                $codeblock += "    printf(%REPLACE%)"
            }
         }
        "VAR" {
            if ($codeblock.EndsWith("%REPLACE%)")) {
                if (($global:symtable | where {$token.Value.Equals($_.Value)}).SymbolType -eq "INT") {
                    $codeblock = $codeblock.Replace("%REPLACE%", """%d\n"",$($token.Value)")
                } elseif (($global:symtable | where {$token.Value.Equals($_.Value)}).SymbolType -eq "FLOAT") {
                    $codeblock = $codeblock.Replace("%REPLACE%", """%f\n"",$($token.Value)")
                }
            } else {
                $codeblock += $token.Value
            }
        }
        "ASSIGNMENT" {
            $codeblock += "= "
        }
        "OPERATOR" {
            $codeblock += "$($token.Value) "
        }
        "INT" {
            $codeblock += "$($token.Value) "
        }
        "FLOAT" {
            $codeblock += "$($token.Value) "
        }
        "ENDING" {
            $codeblock += ";`n"
        }
        Default {}
    }
}
$template = $template.Replace("%CODE%", $codeblock)
$template > ".\test.c"
gcc .\test.c -o $name
rm .\test.c