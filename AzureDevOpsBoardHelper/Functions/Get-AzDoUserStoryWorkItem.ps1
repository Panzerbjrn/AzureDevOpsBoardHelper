Function Get-AzDoUserStoryWorkItem
{
<#
	.SYNOPSIS
		This will get a work item.

	.DESCRIPTION
		This will get a work item and output it to the console.

	.EXAMPLE
		Get-AzDoUserStoryWorkItem -Project "Alpha Devs" -WorkItemID 123456

	.EXAMPLE
		$WItem = Get-AzDoUserStoryWorkItem -Project $TeamName -WorkItemID 123456

	.PARAMETER Project
		The name of your Azure Devops project. Is also often a team name.

	.PARAMETER WorkItemID
		The ID number of the work item you wish to delete

	.INPUTS
		Input is from command line or called from a script.

	.OUTPUTS
		This will output a list of projects.

	.NOTES
		Version:			1
		Author:				Lars Panzerbjørn
		Creation Date:		2020.07.31
		Purpose/Change: Initial script development
#>
	[CmdletBinding()]
	param(
		[Parameter()]
		[Alias('TeamName')]
		[string]$Project,

		[Parameter(Mandatory)]
		[Alias('WorkItem','ID')]
		[string]$WorkItemID
	)

	BEGIN{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
		$Uri = $BaseUri + "$Project/_apis/wit/workitems/$WorkItemID`?api-version=7.0"
	}

	PROCESS{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"
		$WItem = Invoke-RestMethod -Uri $Uri -Method get -Headers $Header		#Retrieves Work Item
	}
	END
	{
		Write-Verbose "Ending $($MyInvocation.Mycommand)"
		$WItem
	}
}
