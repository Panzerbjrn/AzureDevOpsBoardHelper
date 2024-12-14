Function Add-AzDoTask{
<#
	.SYNOPSIS
		Creates a work item of the type Task

	.DESCRIPTION
		Creates a work item of the type Task

	.EXAMPLE
		New-AzDoTask -PersonalAccessToken $PAT -Project $Project -TaskTitle "Test Task" -Board $Board -Description "Test Description"

	.PARAMETER ProjectName
		The name of your Azure Devops Project or Team

	.PARAMETER TaskTitle
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
		Author:				Lars Panzerbjørn
		Creation Date:		2020.07.31
		Purpose/Change: Initial script development
#>
	[CmdletBinding()]
	param(
		[Parameter()]
		[Alias('TeamName')]
		[string]$Project = $Script:Project,

		[Parameter(Mandatory)]
		[Alias('Title')]
		[string]$TaskTitle,

		[Parameter()][string]$Board,

		[Parameter()][string]$AssignedTo,

		[Parameter()][string]$Description,

		[Parameter(Mandatory)]
		[string]$ParentItemID
	)

	BEGIN{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
		$Uri = $BaseUri + "$Project/_apis/wit/workitems/`$Task?api-version=7.0"
	}

	PROCESS{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"

		$Body = @([pscustomobject]@{
				op = "add"
				path = '/fields/System.Title'
				from = $Null
				value = $TaskTitle
			}
		)

		$Body += @([pscustomobject]@{
				op = "add"
				path = '/fields/System.Description'
				value = $Description
			}
		)

		IF ($Board){$BoardValue = $Board}
		ELSE {$BoardValue = (Get-AzDoUserStoryWorkItem -WorkItemID $ParentItemID -Project $Project).Fields.'System.AreaPath'}
		$Body += @([pscustomobject]@{
				op = "add"
				path = '/fields/System.AreaPath'
				value = $BoardValue
			}
		)


		# IF ($AssignedTo){$AssignedToValue = $AssignedTo}
		# ELSE {$AssignedToValue = (Get-AzDoUserStoryWorkItem -WorkItemID $ParentItemID -Project $Project).Fields.'System.Assignedto'.displayName}
		# $Body += @([pscustomobject]@{
		# 		op = "add"
		# 		path = '/fields/System.AssignedTo'
		# 		value = $AssignedToValue
		# 	}
		# )

		$Body = ConvertTo-Json $Body
		$Body
		$Result = Invoke-RestMethod -Uri $uri -Method POST -Headers $Header -ContentType "application/json-patch+json" -Body $Body

		IF (($ParentItemID) -and ($Result.id)){
			Connect-AzDoItems -Project $Project -ParentItemID $ParentItemID -ChildItemID $Result.id -Verbose
		}

	}
	END{
		Write-Verbose "Ending $($MyInvocation.Mycommand)"
		#$Body
		$Result
	}
}
