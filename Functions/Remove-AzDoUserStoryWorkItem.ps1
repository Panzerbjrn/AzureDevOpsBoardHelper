Function Remove-AzDoUserStoryWorkItem
{
<#
	.SYNOPSIS
		This will delete a work item.

	.DESCRIPTION
		This will delete a work item. The item is moved to the recycle binn in case it needs to be restored.
		The REST API has an option to delete fully, without being able to restore from recycle bin, but that is not implemented here.

	.EXAMPLE
		Remove-AzDoUserStoryWorkItem -PersonalAccessToken 'gh5553hiih5lfewahq7n3g7x7oieuothushimanuoch8szn3u2sq' -Organisation "panzerbjrn" -Project "Alpha Devs" -WorkItemID 60505

	.EXAMPLE
		$PAT = 'gh5553hiih5lfewahq7n3g7x7oieuothushimanuoch8szn3u2sq'
		$Organisation = "panzerbjrn"
		$TeamName = "Alpha Devs"
		Remove-AzDoUserStoryWorkItem -PersonalAccessToken $PAT -Organisation $Organisation -Project $TeamName -WorkItemID 60505

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
		Version:			1
		Author:				Lars Panzerbjørn
		Creation Date:		2020.07.31
		Purpose/Change: Initial script development
#>
	[CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]
	param
	(
		[Parameter(Mandatory)]
		[Alias('PAT')]
		[string]$PersonalAccessToken,

		[Parameter(Mandatory)]
		[Alias('Company')]
		[string]$Organisation,

		[Parameter(Mandatory)]
		[Alias('TeamName')]
		[string]$Project,

		[Parameter(Mandatory)]
		[Alias('WorkItem','ID')]
		[string]$WorkItemID

	)

	BEGIN
	{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
		$Token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($PersonalAccessToken)"))
		$Header = $AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + $Token;accept=$JsonContentType}

		$Uri = "https://dev.azure.com/$Organisation/$Project/_apis/wit/workitems/$($workItemId)?api-version=5.1"
	}

	PROCESS
	{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"
		$WItem = Invoke-RestMethod -Uri $uri -Method DELETE -Headers $AzureDevOpsAuthenicationHeader	#This deletes the Work item
	}
	END
	{
		Write-Verbose "Ending $($MyInvocation.Mycommand)"
		$WItem
	}
}
