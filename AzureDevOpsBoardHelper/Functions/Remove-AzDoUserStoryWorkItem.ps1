Function Remove-AzDoUserStoryWorkItem{
<#
	.SYNOPSIS
		This will delete a work item.

	.DESCRIPTION
		This will delete a work item. The item is moved to the recycle binn in case it needs to be restored.
		The REST API has an option to delete fully, without being able to restore from recycle bin, but that is not implemented here.

	.EXAMPLE
		Remove-AzDoUserStoryWorkItem -Project "Alpha Devs" -WorkItemID 60505

	.EXAMPLE
		$TeamName = "Alpha Devs"
		Remove-AzDoUserStoryWorkItem -Project $TeamName -WorkItemID 60505

	.PARAMETER PersonalAccessToken
		This is your personal access token from Azuree Devops.

	.PARAMETER OrganisationName
		The name of your Azure Devops Organisation

	.PARAMETER Project
		The name of your Azure Devops project. Is also often a team name.

	.PARAMETER WorkItemID
		The ID number of the work item you wish to delete

	.INPUTS
		Input is from command line or called from a script.

	.OUTPUTS
		This will output the item being deleted.

	.NOTES
		Author:				Lars Panzerbjørn
		Creation Date:		2020.07.31
#>
	[CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]
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
		$Uri = $BaseUri + "$Project/_apis/wit/workitems/$($workItemId)?api-version=7.0"
	}

	PROCESS{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"
		IF($PSCmdlet.ShouldProcess()){
			$WItem = Invoke-RestMethod -Uri $uri -Method DELETE -Headers $Header	#This deletes the Work item
		}
	}
	END{
		Write-Verbose "Ending $($MyInvocation.Mycommand)"
		$WItem
	}
}
