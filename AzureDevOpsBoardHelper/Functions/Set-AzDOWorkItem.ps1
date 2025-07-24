Function Set-AzDOWorkItem {
<#
	.SYNOPSIS
		Sets various values for a work item

	.DESCRIPTION
		Sets various values for a work item

	.EXAMPLE
		Set-AzDOWorkItem -Project "Alpha Devs" -WorkItemID 123456 -Status Active

	.EXAMPLE
		This example edits an item on the same board.

		Set-AzDOWorkItem -Project $TeamName -WorkItemID 123456 -Status Active -OriginalEstimate 10 -RemainingWork 5 -CompletedWork 3

	.EXAMPLE
		This example edits an item on the same board.

		Set-AzDOWorkItem -Project $TeamName -WorkItemID 123456 -Status Active -OriginalEstimate 10 -RemainingWork 5 -CompletedWork 3 -AddToCompletedWork

	.PARAMETER Project
		The name of your Azure Devops Project or Team

	.PARAMETER WorkItemID
		The ID number of the work item you wish to delete

	.PARAMETER Status
		The desired status to set the work item to.

	.PARAMETER Reason
		The reason for the status.

	.PARAMETER OriginalEstimate
		How much time is the task expected to take

	.PARAMETER RemainingWork
		How much time is left on the task

	.PARAMETER CompletedWork
		How much time has been spent on the task

	.PARAMETER WorkItemTitle
		The title of the work item

	.PARAMETER CalculateRemainingWork
		Calculates the remaining work based on the original estimate and completed work.

	.PARAMETER AddToCompletedWork
		Adds the completed work to the existing completed work.

	.PARAMETER Tags
		Tags assigned to the work item. These are separated by commas, i.e. "Tag1","Tag2"

	.INPUTS
		Input is from command line or called from a script.

	.OUTPUTS
		This will output the response from the server.

	.NOTES
		Author:				Lars Panzerbjørn
		Creation Date:		2024.12.08
#>
	[CmdletBinding()]
	param(
		[Parameter()]
		[string]$Project = $Script:Project,

		[Parameter(Mandatory)]
		[Alias('WorkItem','ID')]
		[string]$WorkItemID,

		[Parameter()][int]$OriginalEstimate,
		[Parameter()][int]$RemainingWork,
		[Parameter()][int]$CompletedWork,
		[Parameter()][string]$Status,
		[Parameter()][string]$Reason,
		[Parameter()][string]$WorkItemTitle,
		[Parameter()][switch]$CalculateRemainingWork,
		[Parameter()][switch]$AddToCompletedWork,
		[Parameter()][switch]$AddTags,
		[Parameter()][switch]$ReplaceTags,
		[Parameter()][string[]]$Tags
	)

	BEGIN{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
		$Uri = $BaseUri + "$Project/_apis/wit/workitems/$workItemId`?api-version=7.0"
	}

	PROCESS{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"

		$updateParams = @('Status','Reason','OriginalEstimate','RemainingWork','CompletedWork','WorkItemTitle','CalculateRemainingWork','AddToCompletedWork','AddTags','ReplaceTags','Tags')
		$hasUpdate = $false
		foreach ($param in $updateParams) {
			if ($PSBoundParameters.ContainsKey($param) -and ($PSBoundParameters[$param] -or $PSBoundParameters[$param] -is [switch])) {
			$hasUpdate = $true
			break
			}
		}
		if (-not $hasUpdate) {
			Write-Error "At least one parameter to update must be specified." -ErrorAction Stop
			return
		}


		IF(!(Get-AzDoUserStoryWorkItem -WorkItemID $workItemId)) {
			Write-Error -Message "Work item with ID $workItemId not found." -erroraction Stop
			RETURN
		}

		IF($AddToCompletedWork) {
			$CompletedWork = (Get-AzDoUserStoryWorkItem -WorkItemID $WorkItemID).fields.'Microsoft.VSTS.Scheduling.CompletedWork' + $CompletedWork
		}

		IF($CalculateRemainingWork) {
			$OriginalEstimate = (Get-AzDoUserStoryWorkItem -WorkItemID $WorkItemID).fields.'Microsoft.VSTS.Scheduling.OriginalEstimate'
			$RemainingWork = $OriginalEstimate - $CompletedWork
		}

		IF($Status) {
			$Body += @([pscustomobject]@{
					op = "replace"
					path = "/fields/System.State"
					value = $Status
				}
			)
		}
		IF($Reason) {
			$Body += @([pscustomobject]@{
					op = "add"
					path = "/fields/System.Reason"
					value = $Reason
				}
			)
		}
		IF($OriginalEstimate) {
			$Body += @([pscustomobject]@{
					op = "add"
					path = '/fields/Microsoft.VSTS.Scheduling.OriginalEstimate'
					value = $OriginalEstimate
				}
			)
		}
		IF($RemainingWork) {
			$Body += @([pscustomobject]@{
					op = "add"
					path = '/fields/Microsoft.VSTS.Scheduling.RemainingWork'
					value = $RemainingWork
				}
			)
		}
		IF($CompletedWork) {
			$Body += @([pscustomobject]@{
					op = "add"
					path = '/fields/Microsoft.VSTS.Scheduling.CompletedWork'
					value = $CompletedWork
				}
			)
		}
		IF($WorkItemTitle) {
			$Body += @([pscustomobject]@{
					op = "add"
					path = '/fields/System.Title'
					value = $WorkItemTitle
				}
			)
		}
		IF($AddTags) {$CurrentTags = ((Get-AzDoUserStoryWorkItem -WorkItemID $WorkItemID).Fields.'System.Tags' -split ';').Trim()}
		IF ($Tags) {
			$CombiTag = ""
			ForEach ($Tag in $Tags+$CurrentTags) { $CombiTag += "$Tag;" }
			$CombiTag = $CombiTag.TrimEnd(';')
			$Body += @([pscustomobject]@{
					op = "replace"
					path = '/fields/System.Tags'
					value = $CombiTag
				}
			)
		}

        $Body = ConvertTo-Json -InputObject $Body

		Write-Verbose -Message $Body
		Write-Verbose -Message $Uri
		$Result = Invoke-RestMethod -Uri $Uri -Method PATCH -Headers $Header -ContentType "application/json-patch+json" -Body $Body
	}
	END{
		Write-Verbose -Message "Ending $($MyInvocation.Mycommand)"
		$Result
	}
}
