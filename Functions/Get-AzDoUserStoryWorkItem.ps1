Function Get-AzDoUserStoryWorkItem
{
<#
	.SYNOPSIS
		This will get a work item.

	.DESCRIPTION
		This will get a work item and output it to the console.

	.EXAMPLE
		Get-AzDoUserStoryWorkItem -PersonalAccessToken gh5553hiih5lfewahq7n3g7x7oieuothushimanuoch8szn3u2sq -Organisation panzerbjrn -Project "Alpha Devs" -WorkItemID 123456

	.EXAMPLE
		$WItem = Get-AzDoUserStoryWorkItem -PersonalAccessToken $PersonalToken -Organisation $OrganizationName -Project $TeamName -WorkItemID 123456

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
		This will output a list of projects.

	.NOTES
		Version:			1
		Author:				Lars Panzerbjørn
		Creation Date:		2020.07.31
		Purpose/Change: Initial script development
#>
	[CmdletBinding()]
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
		[string]$WorkItemID,

		[Parameter()]
		[string]$Board

	)

	BEGIN
	{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
		$JsonContentType = 'application/json-patch+json'
		$Token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($PersonalAccessToken)"))
		$Header = $AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + $Token;accept=$JsonContentType}
		$Uri = "https://dev.azure.com/$Organisation/$Project/_apis/wit/workitems/$WorkItemID`?api-version=5.1"


	}

	PROCESS
	{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"
		$WItem = Invoke-RestMethod -Uri $uri -Method Get -Headers $AzureDevOpsAuthenicationHeader #Retrieves Work Item
	}
	END
	{
		Write-Verbose "Ending $($MyInvocation.Mycommand)"
		$WItem
	}
}
