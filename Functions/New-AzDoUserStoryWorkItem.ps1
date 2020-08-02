Function New-AzDoUserStoryWorkItem
{
<#
	.SYNOPSIS
		Creates a work item of the type, User Story

	.DESCRIPTION
		Creates a work item of the type, User Story

	.EXAMPLE
		Give an example of how to use it

	.EXAMPLE
		Give another example of how to use it

	.PARAMETER PersonalAccessToken
		This is your personal access token from Azuree Devops.

	.PARAMETER OrganizationName
		The name of your Azure Devops Organisation

	.PARAMETER ProjectName
		The name of your Azure Devops Project or Team

	.INPUTS
		Input is from command line or called from a script.

	.OUTPUTS
		This will output the logfile.

	.NOTES
		Version:			0.1
		Author:				Lars Panzerbjørn
		Creation Date:		2020.05.12
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
		[Alias('WorkItemTitle')]
		[string]$Title,

		[Parameter(Mandatory)]
		[string]$Board,

		[Parameter][string]$Description,
		
		[Parameter][ValidateSet(1,2,3,4)][string]$Priority = 3,

		[Parameter][string]$AssignedTo

	)

	BEGIN
	{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"

		$BaseUri = "https://dev.azure.com/$($Organisation)/"
		$Uri = $BaseUri + "$TeamName/_apis/wit/workitems/$" + $WorkItemType + "?api-version=5.1"

		$Token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($PersonalAccessToken)"))
		$Header = @{Authorization = 'Basic ' + $Token;accept=$JsonContentType}
		$Body = @([pscustomobject]@{
				op = "add"
				path = '/fields/System.Title'
				value = $WorkItemTitle
			}
		)
	}

	PROCESS
	{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"

		$Item = @([pscustomobject]@{
				op = "add"
				path = '/fields/System.AreaPath'
				value = $Board
			}
		)
				#value = $Project + '\Plan\' + $Board
		$Body += $Item
		
		$Item = @([pscustomobject]@{
				op = "add"
				path = '/fields/Microsoft.VSTS.Common.Priority'
				value = $Project + '\Plan\' + $Priority
			}
		)
		$Body += $Item
		
		$Item = @([pscustomobject]@{
				op = "add"
				path = '/fields/System.AssignedTo/displayName'
				value = $Project + '\Plan\' + $AssignedTo
			}
		)
		$Body += $Item
		
		IF ($Description)
		{
			$Item = @([pscustomobject]@{
					op = "add"
					path = '/fields/System.Description'
					value = $Project + '\Plan\' + $Description
				}
			)
			$Body += $Item
		}
		$Body = ConvertTo-Json $Body
		$Body
		#$Result = Invoke-RestMethod -Uri $uri -Method POST -Headers $Header -ContentType "application/json-patch+json" -Body $Body

	}
	END
	{
		Write-Verbose "Ending $($MyInvocation.Mycommand)"
		$Body
		#$Result
	}
}
