Function Get-AzDoUserStoryWorkItem
{
<#
	.SYNOPSIS
		This will get a work item.

	.DESCRIPTION
		This will get a work item.

	.EXAMPLE
		Get-AzDOProjects -PersonalAccessToken gh5553hiih5lfewahq7n3g7x7oieuothushimanuoch8szn3u2sq -Organisation panzerbjrn

	.EXAMPLE
		$Projects = (Get-AzDOProjects -PersonalAccessToken $personalToken -Organisation $OrganizationName).value

	.PARAMETER PersonalAccessToken
		This is your personal access token from Azuree Devops.

	.PARAMETER OrganisationName
		The name of your Azure Devops Organisation

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
		[string]$WorkItemID

	)

	BEGIN
	{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
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
