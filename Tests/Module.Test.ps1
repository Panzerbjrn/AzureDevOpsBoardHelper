$ProjectRoot 	= (Resolve-Path "$PSScriptRoot\..").path
$ModuleName 	= Split-Path $ProjectRoot -Leaf
$ModuleRoot 	= Join-Path -Path $ProjectRoot -ChildPath $ModuleName -AdditionalChildPath "$ModuleName.psm1"
$ManifestRoot 	= Join-Path -Path $ProjectRoot -ChildPath $ModuleName -AdditionalChildPath "$ModuleName.psd1"
$Functions		= Join-Path -Path $ProjectRoot -ChildPath $ModuleName -AdditionalChildPath Functions
$Helpers		= Join-Path -Path $ProjectRoot -ChildPath $ModuleName -AdditionalChildPath Helpers

BeforeAll {
	#Write-Host 'BeforeAll'
	Try{
		Import-module PSScriptAnalyzer -ErrorAction STOP
	}
	Catch{
		Install-Module -Name PSScriptAnalyzer
	}
	IF(!(Get-Module PSScriptAnalyzer)){
		Install-Module -Name PSScriptAnalyzer -Force
	}

	$ProjectRoot 	= (Resolve-Path "$PSScriptRoot\..").path
	$ModuleName 	= Split-Path $ProjectRoot -Leaf
	$ModuleRoot 	= Join-Path -Path $ProjectRoot -ChildPath $ModuleName -AdditionalChildPath "$ModuleName.psm1"
	$ManifestRoot 	= Join-Path -Path $ProjectRoot -ChildPath $ModuleName -AdditionalChildPath "$ModuleName.psd1"
	$Functions		= Join-Path -Path $ProjectRoot -ChildPath $ModuleName -AdditionalChildPath Functions
	$Helpers		= Join-Path -Path $ProjectRoot -ChildPath $ModuleName -AdditionalChildPath Helpers
}

Describe "General project validation: $ModuleName" -Tag 'Module_Validation' {

	Context 'Project should be viable' {

		#Write-Host 'Context: Project should be viable'

		It "Test-Path $ProjectRoot should be True" {
			Test-Path $ProjectRoot | Should -Be $True
		}

		It "Test-Path $Moduleroot should be True" {
			Test-Path $Moduleroot | Should -Be $True
		}

		It "Test-Path $ManifestRoot should be True" {
			Test-Path $ManifestRoot | Should -Be $True
		}

		it 'Passes all default PSScriptAnalyzer rules' {
			Invoke-ScriptAnalyzer -Path $ManifestRoot -ExcludeRule PSUseToExportFieldsInManifest | should -BeNullOrEmpty
		}
	}
}

Describe "Validating commands are viable" -Tag 'Command_Validation' {

	Context 'Public functions should be viable' {
		#Write-Host 'Context: Public functions should be viable'

		#Write-Host "Functions path: $Functions"
		$AllFunctions 	= Get-ChildItem -Path $Functions -Include *.ps1 -Recurse
		$TestCase = $AllFunctions | Foreach-Object {@{file=$_}}
		#Write-Host "Test cases generated: $($TestCase | Out-String)"

		It "Script <file> should be valid powershell" -TestCases $TestCase {
			param($File)

			$File.Fullname | Should -Exist

			$Contents = Get-Content -Path $File.Fullname -ErrorAction Stop
			$Errors = $null
			$null = [System.Management.Automation.PSParser]::Tokenize($Contents, [ref]$Errors)
			$Errors.Count | Should -Be 0

		}

		It "Script <file> should exist" -TestCases $TestCase {
			param($File)
			Test-Path $File.Fullname | Should -Be $True
		}

		It "Script <file> should have help block" -TestCases $TestCase {
			param($File)
			$File.Fullname | Should -FileContentMatch '<#'
			$File.Fullname | Should -FileContentMatch '#>'
		}

		It "Script <file> should have Synopsis" -TestCases $TestCase {
			param($File)
			$File.Fullname | Should -FileContentMatch '.SYNOPSIS'
		}

		It "Script <file> should have help DESCRIPTION" -TestCases $TestCase {
			param($File)
			$File.Fullname | Should -FileContentMatch 'DESCRIPTION'
		}

		It "Script <file> should have help EXAMPLE" -TestCases $TestCase {
			param($File)
			$File.Fullname | Should -FileContentMatch 'EXAMPLE'
		}

	}

	Context 'Private helpers should be viable' {

		#Write-Host 'Context: Private helpers should be viable'
		$AllHelpers = Get-ChildItem -Path $Functions -Include *.ps1 -Recurse
		$TestCase 	= $AllHelpers | Foreach-Object {@{file=$_}}
		#Write-Host "Test cases generated: $($TestCase | Out-String)"

		It "Script <file> should be valid powershell" -TestCases $TestCase {
			param($File)

			$File.Fullname | Should -Exist

			$Contents = Get-Content -Path $File.Fullname -ErrorAction Stop
			$Errors = $null
			$null = [System.Management.Automation.PSParser]::Tokenize($Contents, [ref]$Errors)
			$Errors.Count | Should -Be 0

		}

		It "Script <file> should exist" -TestCases $TestCase {
			param($File)
			Test-Path $File.Fullname | Should -Be $True
		}
	}
}
