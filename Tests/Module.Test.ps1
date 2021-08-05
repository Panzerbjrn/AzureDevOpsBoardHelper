$ProjectRoot = (Resolve-Path "$PSScriptRoot\..").path
$ModuleName = Split-Path $ProjectRoot -Leaf
$ModuleRoot = "$ProjectRoot\$ModuleName.psm1"
$ModuleRoot = $(gci $ModuleRoot).Fullname
$ManifestRoot = "$ProjectRoot\$ModuleName.psd1"

BeforeAll {
	Try{
		Import-module PSScriptAnalyzer -ErrorAction STOP
	}
	Catch{
		Install-Module -Name PSScriptAnalyzer
	}
	IF(!(Get-Module PSScriptAnalyzer)){
		Install-Module -Name PSScriptAnalyzer -Force
	}
	
	#$Scripts = Get-ChildItem -Include *.ps1 -Exclude *WiP.ps1 -Recurse
	$ProjectRoot = (Resolve-Path "$PSScriptRoot\..").path
	$ModuleName = Split-Path $ProjectRoot -Leaf
	$ModuleRoot = "$ProjectRoot\$ModuleName.psm1"
	$ManifestRoot = "$ProjectRoot\$ModuleName.psd1"
}

Describe "General project validation: $ModuleName" {
	It "Test-Path $Moduleroot should be True" {
		Test-Path $Moduleroot | Should -Be $True
	}
	
	It "Test-Path $ManifestRoot should be True" {
		Test-Path $ManifestRoot | Should -Be $True
	}

	it 'Passes all default PSScriptAnalyzer rules' {
		Invoke-ScriptAnalyzer -Path $(gci $ModuleRoot).Fullname | should -BeNullOrEmpty
	}
}

Describe "General function validation: $ModuleName" {
	$Scripts = Get-ChildItem $ProjectRoot -Include *.ps1 -Exclude *WiP.ps1,*test.ps1 -Recurse

	# TestCases are splatted to the script
	$TestCase = $Scripts | Foreach-Object {@{file=$_}}
	It "Script <file.Name> should be valid powershell" -TestCases $TestCase {
		param($File)

		$File.Fullname | Should -Exist

		$Contents = Get-Content -Path $File.Fullname -ErrorAction Stop
		$Errors = $null
		$null = [System.Management.Automation.PSParser]::Tokenize($Contents, [ref]$Errors)
		$Errors.Count | Should -Be 0
		
	}
	It "Script <file.Name> should exist" -TestCases $TestCase {
		param($File)
		Test-Path $File.Fullname | Should -Be $True
	}
	It "Script <file.Name> should have help block" -TestCases $TestCase {
		param($File)
		$File.Fullname | Should -FileContentMatch '<#'
		$File.Fullname | Should -FileContentMatch '#>'
	}

	It "Script <file.Name> should have Synopsis" -TestCases $TestCase {
		param($File)
		$File.Fullname | Should -FileContentMatch '.SYNOPSIS'
	}

	It "Script <file.Name> should have help DESCRIPTION" -TestCases $TestCase {
		param($File)
		$File.Fullname | Should -FileContentMatch 'DESCRIPTION'
	}

	It "Script <file.Name> should have help EXAMPLE" -TestCases $TestCase {
		param($File)
		$File.Fullname | Should -FileContentMatch 'EXAMPLE'
	}

	It "Script <file.Name> passes all default PSScriptAnalyzer rules" -TestCases $TestCase {
		param($File)
		$File.Fullname | Should -FileContentMatch 'EXAMPLE'
		Invoke-ScriptAnalyzer -Path $($File.Fullname) -ExcludeRule PSReviewUnusedParameter,PSUseDeclaredVarsMoreThanAssignments | should -BeNullOrEmpty
	}
}
