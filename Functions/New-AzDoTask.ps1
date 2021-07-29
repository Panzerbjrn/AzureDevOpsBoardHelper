Function New-AzDoTask
{
<#
	.SYNOPSIS
		Creates a work item of the type Task

	.DESCRIPTION
		Creates a work item of the type Task

	.EXAMPLE
		New-AzDoTask -PersonalAccessToken $PAT -Organisation $Organisation -Project $Project -TaskTitle "Test Task" -Board $Board -Description "Test Description"

	.PARAMETER PersonalAccessToken
		This is your personal access token from Azuree Devops.

	.PARAMETER OrganizationName
		The name of your Azure Devops Organisation

	.PARAMETER ProjectName
		The name of your Azure Devops Project or Team

	.PARAMETER Title
		The title of the task

	.PARAMETER Board
		The name of your Azure Devops Board you want to add the item to

	.PARAMETER AssignedTo
		This is the person the item is assigned to.

	.PARAMETER Description
		The content of the description field. Lines can be broken by adding <br>

	.INPUTS
		Input is from command line or called from a script.

	.OUTPUTS
		This will output the logfile.

	.NOTES
		Version:			1.1
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
		[Alias('Title')]
		[string]$TaskTitle,

		[Parameter()][string]$Board,

		[Parameter()][string]$AssignedTo,

		[Parameter()][string]$Description,

		[Parameter(Mandatory)]
		[string]$ParentItemID
	)

	BEGIN
	{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
		$JsonContentType = 'application/json-patch+json'
		$BaseUri = "https://dev.azure.com/$($Organisation)/"
		$Uri = $BaseUri + "$Project/_apis/wit/workitems/`$Task?api-version=6.0"

		$Token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($PersonalAccessToken)"))
		$Header = @{Authorization = 'Basic ' + $Token;accept=$JsonContentType}
	}

	PROCESS
	{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"

		$Body = @([pscustomobject]@{
				op = "add"
				path = '/fields/System.Title'
				from = $Null
				value = $TaskTitle
			}
		)

		IF ($Board){$BoardValue = $Board}
		ELSE {$BoardValue = (Get-AzDoUserStoryWorkItem -Organisation $Organisation -WorkItemID $ParentID -PersonalAccessToken $PersonalAccessToken -Project $Project).Fields.'System.AreaPath'}
		$Body += @([pscustomobject]@{
				op = "add"
				path = '/fields/System.AreaPath'
				value = $BoardValue
			}
		)


		IF ($AssignedTo){$AssignedToValue = $AssignedTo}
		ELSE {$AssignedToValue = (Get-AzDoUserStoryWorkItem -Organisation $Organisation -WorkItemID $ParentID -PersonalAccessToken $PersonalAccessToken -Project $Project).Fields.'System.Assignedto'.displayName}
		$Body += @([pscustomobject]@{
				op = "add"
				path = '/fields/System.AssignedTo'
				value = $AssignedToValue
			}
		)

		IF ($Description)
		{
			$Body += @([pscustomobject]@{
					op = "add"
					path = '/fields/System.Description'
					value = $Description
				}
			)
		}

		$Body = ConvertTo-Json $Body
		$Body
		$Result = Invoke-RestMethod -Uri $uri -Method POST -Headers $Header -ContentType "application/json-patch+json" -Body $Body

		IF (($ParentItemID) -and ($Result.id)){
			Link-AzDoItems -PersonalAccessToken $PersonalAccessToken -Organisation $Organisation -Project $Project -ParentItemID $ParentItemID -ChildItemID $Result.id -Verbose
		}

	}
	END
	{
		Write-Verbose "Ending $($MyInvocation.Mycommand)"
		#$Body
		$Result
	}
}
