<# 
This is a proof of concept powershell compiler.
This project is for fun and does not serve any real world purpose.

This is scanner.ps1 - The scanner in the compiler

Zaph-x @ 30-apr 2020, 12:02 AM
#>

$KEYWORDS = @("int", "float", "print");

$global:index = 0;
$global:line = 1
$global:offset = 0;
$fileContent = (Get-Content -Path $args[0] -Raw).ToCharArray();

$global:tokens = @()

function Is-Number {
    param (
        [char]$Character
    )
    if ([char]$Character -le [char]'9' -and [char]$Character -ge [char]'0') {
        return $true
    }
    return $false
}

function Increment {
    $global:index++
    $global:offset++
}

function Is-Letter {
    param (
        [char]$Character
    )
    if (([char]$Character -ge [char]'a' -and [char]$Character -le [char]'z') -or ([char]$Character -ge [char]'A' -and [char]$Character -le [char]'Z')) {
        return $true
    }
    return $false
}

function Check-Newline {
    param(
        [char]$Character
    )
    if ([char]$Character -eq [char]"`n") {
        $global:line++;
        $global:offset = 0;
    }
}

function Scan-Word {
    $substring = "";
    while (Is-Letter $fileContent[$global:index] -or Is-Number $fileContent[$global:index]) {
        $substring += $fileContent[$global:index]
        Increment
    }
    if ($KEYWORDS.Contains($substring)) {
        $global:tokens += Generate-Token $substring "KEYWORD" $global:line $global:offset;
        return
    }
    $tok = Generate-Token $substring "VAR" $global:line $global:offset
    $global:tokens += $tok
    if ($null -eq ($global:symtable | Where-Object {$_.Value -eq $substring})) {
        $global:symtable += $tok
    }
}

function Scan-Digit {
    $substring = "";
    while (Is-Number -Character $fileContent[$global:index]) {
        $substring += $fileContent[$global:index];
        Increment
    }
    if ($fileContent[$global:index] -eq [char]'.') {
        $substring += $fileContent[$global:index]
        Increment
        while (Is-Number -Character $fileContent[$global:index]) {
            $substring += $fileContent[$global:index];
            Increment
        }
        $global:tokens += Generate-Token $substring "FLOAT" $global:line $global:offset;
        return
    }
    $global:tokens += Generate-Token $substring "INT" $global:line $global:offset;
    return
}

function Scan-Operator {
    switch ($fileContent[$global:index]) {
        '+' { $global:tokens += Generate-Token $fileContent[$global:index] "OPERATOR" $global:line $global:offset }
        '-' { $global:tokens += Generate-Token $fileContent[$global:index] "OPERATOR" $global:line $global:offset }
        '*' { $global:tokens += Generate-Token $fileContent[$global:index] "OPERATOR" $global:line $global:offset }
        '/' { $global:tokens += Generate-Token $fileContent[$global:index] "OPERATOR" $global:line $global:offset }
        '=' { $global:tokens += Generate-Token $fileContent[$global:index] "ASSIGNMENT" $global:line $global:offset }
        Default { }
    }
    Increment
}


function Generate-Token {
    param (
        $Value,
        $Type,
        $Line,
        $Offset
    )


    return [PSCustomObject]@{
        PSTypeName  = 'ScannedToken'
        Value       = $null -eq $Value ? "" : $Value
        Type        = $Type
        Line        = $Line
        Offset      = $Offset 
        SymbolType  = $null
        SymbolValue = $null
    }
}

function Scan-Ender {
    $global:tokens += Generate-Token ";" "ENDING" $global:line ($global:offset + 1)
    Increment
}

function Print-Scanned-Tokens {
    foreach ($tok in $global:tokens) {
        Write-Host $tok
    }
}

function Scan {
    while ($global:index -lt $fileContent.Count) {
        Check-Newline -Character $fileContent[$global:index]
        if (Is-Number -Character $fileContent[$global:index]) { Scan-Digit } 
        elseif (Is-Letter -Character $fileContent[$global:index]) { Scan-Word }
        elseif ("+-*/=".Contains($fileContent[$global:index])) { Scan-Operator }
        elseif (";".Contains($fileContent[$global:index])) { Scan-Ender }
        else { Increment }
        # Write-Host $fileContent[$global:index]

    }
    $global:tokens = $global:tokens.GetEnumerator() | sort -Property Line, Offset
    # Print-Scanned-Tokens
}
Scan