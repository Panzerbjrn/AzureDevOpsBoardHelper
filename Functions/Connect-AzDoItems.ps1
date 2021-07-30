Function Connect-AzDoItems{
<#
	.SYNOPSIS
		Links two Azure Devops item in a parent/child relationship

	.DESCRIPTION
		Links two Azure Devops item in a parent/child relationship

	.EXAMPLE


	.PARAMETER PersonalAccessToken
		This is your personal access token from Azure Devops.

	.PARAMETER OrganizationName
		The name of your Azure Devops Organisation

	.PARAMETER ProjectName
		The name of your Azure Devops Project or Team

	.PARAMETER ParentItemID
		The name of your Azure Devops Project or Team

	.PARAMETER ChildItemID
		The name of your Azure Devops Project or Team

	.INPUTS
		Input is from command line or called from a script.

	.OUTPUTS
		This will output the logfile.

	.NOTES
		Version:			0.1
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

		[Parameter(Mandatory)][string]$ParentItemID,
		[Parameter(Mandatory)][string]$ChildItemID
	)

	BEGIN
	{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
		$JsonContentType = 'application/json-patch+json'
		$BaseUri = "https://dev.azure.com/$($Organisation)/"
		$Uri = $BaseUri + "$Project/_apis/wit/workitems/$ChildItemID`?api-version=6.1-preview.3"


		$Token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($PersonalAccessToken)"))
		$Header = @{Authorization = 'Basic ' + $Token;accept=$JsonContentType}
	}

	PROCESS
	{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"
		$Value = @{
			rel = "System.LinkTypes.Hierarchy-Reverse"
			url = "https://dev.azure.com/$Organisation/$Project/_apis/wit/workItems/$ParentItemID"
			}
		$Attributes = @{
			isLocked = $False
			name = "Parent"
		}


		$Body = @([pscustomobject]@{
				op = "add"
				path = '/relations/-'
				value = $Value
				Attributes = $Attributes
			}
		)

		$Body = ConvertTo-Json $Body
		$Body
		$Result = Invoke-RestMethod -Uri $uri -Method PATCH -Headers $Header -ContentType $JsonContentType -Body $Body

	}
	END
	{
		Write-Verbose "Ending $($MyInvocation.Mycommand)"
		#$Body
		$Result
	}
}
