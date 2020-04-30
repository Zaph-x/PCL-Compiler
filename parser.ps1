<# 
This is a proof of concept powershell compiler.
This project is for fun and does not serve any real world purpose.

This is parser.ps1 - The parser in the compiler

Zaph-x @ 30-apr 2020, 11:04 AM
#>

function Parse {
    $global:index = 0
    $global:currtoken
    $line = @()
    $currentLine = ""

    function Check-FollowExpression-Follow {
        $Global:tokens[$global:index]
        if ($Global:tokens[$global:index].Type -in @("INT", "FLOAT", "VAR")) {
            $global:index++
            Check-Assignment-Follow $Global:tokens[$global:index]
        }
    }

    function Check-Expression-Follow {
        $Global:tokens[$global:index]
        if ($Global:tokens[$global:index].Type -eq "OPERATOR") {
            $global:index++
            Check-FollowExpression-Follow 
        }
        elseif ($Global:tokens[$global:index].Type -eq "ENDING") {
            $global:index++
        }
    }

    function Get-SymtableEquivalent {
        param($Token)
        return ($global:symtable | where { $Token.Value.Equals($_.Value) })
    }

   

    function Check-Assignment-Follow {
        $Global:tokens[$global:index]
        if ($Global:tokens[$global:index].Type -in @("INT", "FLOAT", "VAR")) {
            $global:index++
            Check-Expression-Follow 
        }
        elseif ($Global:tokens[($global:index - 1)].Type -in @("INT", "FLOAT", "VAR") -and $Global:tokens[$global:index].Type -eq "ENDING") {
            $global:index++
        }

    }

    function Check-Var-Follow {
        $Global:tokens[$global:index]
        if ($Global:tokens[$global:index].Type -eq "ASSIGNMENT") {
            $global:currtoken = $global:symtable | where { $Global:tokens[($global:index - 1)].Value.Equals($_.Value) }
            $global:currtoken.SymbolType = $Global:tokens[($global:index - 2)].Value.ToUpper()
            $global:index++
            Check-Assignment-Follow
        }
        elseif ($Global:tokens[$global:index].Type -eq "ENDING") {
            $global:index++
        }
    }

    function Check-Keyword-Follow {
        $Global:tokens[$global:index]
        if ($Global:tokens[$global:index].Type -eq "VAR") {
            $global:index++
            Check-Var-Follow
        }
        else {
            Write-Error "Every keyword must be followed by a value."
            write-host $Global:tokens[$global:index]
        } 
    }

    while ($global:index -lt $Global:tokens.Count) {
        $Global:tokens[$global:index]
        if ($Global:tokens[$global:index].Type -eq "KEYWORD") {
            $global:index++
            Check-Keyword-Follow
        }
        else {
            Write-Error "Unexpected token."
            $Global:tokens[$global:index]
            return
        }
    }
}

Parse