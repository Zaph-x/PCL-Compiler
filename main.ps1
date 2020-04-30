<# 
This is a proof of concept powershell compiler.
This project is for fun and does not serve any real world purpose.

This is main.ps1 - The main file in the compiler

Zaph-x @ 29-apr 2020, 11:40 PM
#>
if ($args.Count -lt 1)
{
    Write-Error "Please provide a file to compile";
    return 1;
}
$global:symtable = @()
.\scanner.ps1 .\test.psl
.\parser.ps1
Write-Host "";