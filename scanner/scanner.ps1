<# 
This is a proof of concept powershell compiler.
This project is for fun and does not serve any real world purpose.

This is scanner.ps1 - The scanner in the compiler

Zaph-x @ 30-apr 2020, 12:02 AM
#>

$KEYWORDS = @("int", "char", "string", "print");

$global:index = 0;
$fileContent = (Get-Content -Path $args[0]).ToCharArray();

function Is-Number {
    param (
        [char]$Character
    )
    if ([char]$Character -le [char]'9' -and [char]$Character -ge [char]'0') {
        return $true
    }
    return $false
}

function Is-Letter {
    param (
        [char]$Character
    )
    if (([char]$Character -le [char]'a' -and [char]$Character -ge [char]'z') -or ([char]$Character -le [char]'A' -and [char]$Character -ge [char]'Z')) {
        return $true
    }
    return $false
}

function Scan-Word {
}

function Scan-Digit {
    $substring = "";
    while (Is-Number -Character $fileContent[$global:index]) {
        $substring += $fileContent[$global:index];
        $global:index++
    }
    if ($fileContent[$global:index] -eq [char]'.') {
        $substring += $fileContent[$global:index++]
        while (Is-Number -Character $fileContent[$global:index]) {
            $substring += $fileContent[$global:index];
            $global:index++
        }
    }
    return $substring;
}

function Scan {
    while ($global:index -lt $fileContent.Count) {
        if (Is-Number -Character $fileContent[$global:index]) { write-host $(Scan-Digit) }
        $global:index++
    }
}

Scan;