#region Script Header
#	Thought for the day: 
#	NAME: AzureDevOpsBoardHelper.psm1
#	AUTHOR: Lars PanzerbjÃ¸rn
#	CONTACT: Lars@Panzerbjrn.eu / GitHub: Panzerbjrn / Twitter: Panzerbjrn
#	DATE: 2020.07.31
#	VERSION: 0.1 - 2020.07.31 - Module Created with Create-NewModuleStructure by Lars Panzerbjørn
#
#	SYNOPSIS:
#
#
#	DESCRIPTION:
#	Helper module for working with Azure DevOps boards.
#
#	REQUIREMENTS:
#
#endregion Script Header

#Requires -Version 4.0

[CmdletBinding(PositionalBinding=$false)]
param()

Write-Verbose $PSScriptRoot

#Get Functions and Helpers function definition files.
$Functions	= @( Get-ChildItem -Path $PSScriptRoot\Functions\*.ps1 -ErrorAction SilentlyContinue )
$Helpers = @( Get-ChildItem -Path $PSScriptRoot\Helpers\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
ForEach ($Import in @($Functions + $Helpers))
{
	Try
	{
		. $Import.Fullname
	}
	Catch
	{
		Write-Error -Message "Failed to Import function $($Import.Fullname): $_"
	}
}

Export-ModuleMember -Function $Functions.Basename

