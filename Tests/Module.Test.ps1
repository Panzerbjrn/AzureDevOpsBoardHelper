$ProjectRoot = Resolve-Path "$PSScriptRoot\.."
$ModuleRoot = Resolve-Path "$ProjectRoot\*.psm1"
$ModuleName = Split-Path $ModuleRoot -Leaf

Describe "General project validation: $ModuleName" {
	$Scripts = Get-ChildItem $ProjectRoot -Include *.ps1,*.psm1,*.psd1 -Exclude *WiP.ps1 -Recurse

	# TestCases are splatted to the script so we need hashtables
	$TestCase = $Scripts | Foreach-Object {@{file=$_}}
	It "Script <file> should be valid powershell" -TestCases $TestCase {
		param($File)

		$File.Fullname | Should Exist

		$Contents = Get-Content -Path $File.Fullname -ErrorAction Stop
		$Errors = $null
		$null = [System.Management.Automation.PSParser]::Tokenize($Contents, [ref]$Errors)
		$Errors.Count | Should Be 0
	}

	It "Module '$ModuleName' can import cleanly" {
		{Import-Module $ModuleRoot -force } | Should Not Throw
	}
}
