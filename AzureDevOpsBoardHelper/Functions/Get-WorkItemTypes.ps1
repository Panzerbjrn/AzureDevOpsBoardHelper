Function Get-WorkItemTypes{
<#
	.SYNOPSIS
		This will get the work item types available in your Azure DevOps project.

	.DESCRIPTION
		This will get the work item types available in your Azure DevOps project.

	.EXAMPLE
		Get-WorkItemTypes -Project "Alpha Devs"

	.PARAMETER Project
		The name of your Azure Devops project. Is also often a team name.

	.INPUTS
		Input is from command line or called from a script.

	.NOTES
		Author:				Lars Panzerbjørn
		Creation Date:		2022.06.21
#>
	[CmdletBinding()]
	param(
		[Parameter()]
		[Alias('TeamName')]
		[string]$Project
	)

	BEGIN{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
		$Uri = $BaseUri + "$Project/_apis/wit/workitemtypes?api-version=7.0"
	}

	PROCESS{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"
		IF ($PSVersionTable.PSVersion.Major -eq 5){$Result = Invoke-RestMethod -Uri $Uri -Method Get -Headers $Header | ConvertFrom-Json}
        IF ($PSVersionTable.PSVersion.Major -eq 7){$Result = Invoke-RestMethod -Uri $Uri -Method Get -Headers $Header | ConvertFrom-Json -AsHashtable}
	}
	END{
		Write-Verbose "Ending $($MyInvocation.Mycommand)"
		$Result
	}
}

