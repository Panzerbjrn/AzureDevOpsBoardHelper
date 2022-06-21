Function Get-WorkItemTypes{
<#
	.SYNOPSIS
		This will get the work item types available in your Azure DevOps project.

	.DESCRIPTION
		This will get the work item types available in your Azure DevOps project.

	.EXAMPLE
		Get-WorkItemTypes -PersonalAccessToken gh5553hiih5lfewahq7n3g7x7oieuothushimanuoch8szn3u2sq -Organisation panzerbjrn -Project "Alpha Devs"

    .PARAMETER PersonalAccessToken
		This is your personal access token from Azure Devops.

	.PARAMETER OrganisationName
		The name of your Azure Devops Organisation

	.PARAMETER Project
		The name of your Azure Devops project. Is also often a team name.

	.INPUTS
		Input is from command line or called from a script.

	.OUTPUTS
		This will output a list of projects.

	.NOTES
		Author:				Lars Panzerbjørn
		Creation Date:		2022.06.21
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
		[string]$Project
	)

	BEGIN{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
		$JsonContentType = 'application/json-patch+json'
		$Token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($PersonalAccessToken)"))
		$AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + $Token;accept=$JsonContentType}
        $Uri = "https://dev.azure.com/$Organisation/$Project/_apis/wit/workitemtypes?api-version=6.0"
	}

	PROCESS{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"
		IF ($PSVersionTable.PSVersion.Major -eq 5){$Result = Invoke-RestMethod -Uri $Uri -Method Get -Headers $AzureDevOpsAuthenicationHeader | ConvertFrom-Json}
        IF ($PSVersionTable.PSVersion.Major -eq 7){$Result = Invoke-RestMethod -Uri $Uri -Method Get -Headers $AzureDevOpsAuthenicationHeader | ConvertFrom-Json -AsHashtable}
	}
	END{
		Write-Verbose "Ending $($MyInvocation.Mycommand)"
		$Result
	}
}
