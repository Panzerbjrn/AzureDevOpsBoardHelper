cls
$ProjectRoot 	= (Resolve-Path "$PSScriptRoot\..").path
$ModuleName 	= Split-Path $ProjectRoot -Leaf
$ModuleRoot 	= Join-Path -Path $ProjectRoot -ChildPath $ModuleName -AdditionalChildPath "$ModuleName.psm1"
$ManifestRoot 	= Join-Path -Path $ProjectRoot -ChildPath $ModuleName -AdditionalChildPath "$ModuleName.psd1"
$Functions		= Join-Path -Path $ProjectRoot -ChildPath $ModuleName -AdditionalChildPath Functions
$Helpers		= Join-Path -Path $ProjectRoot -ChildPath $ModuleName -AdditionalChildPath Helpers
$AllFunctions 	= Get-ChildItem -Path $Functions -Include *.ps1 -Recurse
$AllHelpers 	= Get-ChildItem -Path $Helpers -Include *.ps1 -Recurse

$ProjectRoot
$ModuleName
$ModuleRoot
$ManifestRoot
$Functions
$Helpers

"AllFunctions:"
$AllFunctions
#$AllFunctions.Fullname
"AllHelpers"
$AllHelpers
$AllHelpers.Fullname
#$AllFunctions | Foreach-Object {@{file=$_}}
$AllFunctions | Foreach-Object {@{file=$_}}
$AllHelpers | Foreach-Object {@{file=$_}}
