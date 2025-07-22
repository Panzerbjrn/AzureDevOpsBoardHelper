Function Add-AzDoUserStoryWorkItem{
<#
	.SYNOPSIS
		Creates a work item of the type User Story

	.DESCRIPTION
		Creates a work item of the type User Story

	.EXAMPLE
		Add-AzDoUserStoryWorkItem -Project "Alpha Devs" -Title "New Story Item"

	.EXAMPLE
		This example first get details from another work item, and uses those to place a new item on the same board.
		This also uses <br> to break lines in the descrption field.

		$WItem = Get-AzDoUserStoryWorkItem -Project $TeamName -WorkItemID 123456
		Add-AzDoUserStoryWorkItem -Project $TeamName -Title "Important Scripting work" -Board $WItem.fields.'System.AreaPath' -Description "Important work <br> Line 2" -AssignedTo $WItem.fields.'System.AssignedTo'.displayName -Verbose -Tags "Tag1","Tag2" -AcceptanceCriteria "Accepted"


	.PARAMETER Project
		The name of your Azure Devops Project or Team

	.PARAMETER WorkItemTitle
		The name of your Azure Devops Project or Team

	.PARAMETER Board
		The name of your Azure Devops Board you want to add the item to

	.PARAMETER StoryType
		The type of work item to create. Valid values can be retrieved by running the Get-AzDoWorkItemTypes command.

	.PARAMETER Iteration
		The name of the iteration path to assign the work item to. This is often in the format "Project\IterationName". If not specified, the work item will not be assigned to any iteration.

	.PARAMETER Description
		The content of the description field. Lines can be broken by adding <br>

	.PARAMETER AcceptanceCriteria
		The content of the Acceptance Criteria field. Lines can be broken by adding <br>

	.PARAMETER Priority
		This is the priority of the item. Default is 3.

	.PARAMETER AssignedTo
		This is the person the item is assigned to.

	.PARAMETER OriginalEstimate
		How much time is the task expected to take

	.PARAMETER Tags
		Tags assigned to the work item. These are separated by commas, i.e. "Tag1","Tag2"

	.INPUTS
		Input is from command line or called from a script.

	.OUTPUTS
		This will output the logfile.

	.LINK
		https://learn.microsoft.com/en-us/rest/api/azure/devops/wit/work-items/create

	.NOTES
		Author:				Lars Panzerbjørn
		Creation Date:		2020.07.31
#>
	[CmdletBinding()]
	param(
		[Parameter()]
		[Alias('TeamName')]
		[string]$Project = $Script:Project,

		[Parameter(Mandatory)]
		[Alias('Title')]
		[string]$WorkItemTitle,

		[Parameter(Mandatory)]
		[string]$Board,

		[Parameter(Mandatory,
			HelpMessage = "The type of work item to create. Valid values can be retrieved by running the Get-AzDoWorkItemTypes command.")]
		[Alias('StoryType')]
		[string]$WorkItemType,

		[Parameter()][string]$Iteration,

		[Parameter()][string]$Description,

		[Parameter()][string]$AcceptanceCriteria,

		[Parameter()][ValidateSet(1,2,3,4)][string]$Priority = 3,

		[Parameter()][string]$AssignedTo,

		[Parameter()][int]$OriginalEstimate,

		[Parameter()][string[]]$Tags
	)

	BEGIN{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
		$Uri = $BaseUri + "$Project/_apis/wit/workitems/`$$($WorkItemType)?api-version=7.1"
		Write-Verbose "URI is $Uri"
	}

	PROCESS{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"

		$Body = @([pscustomobject]@{
				op = "add"
				path = '/fields/System.Title'
				value = $WorkItemTitle
			}
		)
		$Body += @([pscustomobject]@{
				op = "add"
				path = '/fields/System.AreaPath'
				value = $Board
			}
		)

		$Body += @([pscustomobject]@{
				op = "add"
				path = '/fields/Microsoft.VSTS.Common.Priority'
				value = $Priority
			}
		)

		$Body += @([pscustomobject]@{
				op = "add"
				path = '/fields/System.AssignedTo'
				value = $AssignedTo
			}
		)

		#This may need to have project added in front of the iteration.
		IF ($Iteration)
		{
			$Body += @([pscustomobject]@{
					op = "add"
					path = '/fields/System.IterationPath'
					value = $Iteration
				}
			)
		}

		IF ($Description)
		{
			$Body += @([pscustomobject]@{
					op = "add"
					path = '/fields/System.Description'
					value = $Description
				}
			)
		}

		IF ($AcceptanceCriteria)
		{
			$Body += @([pscustomobject]@{
					op = "add"
					path = '/fields/Microsoft.VSTS.Common.AcceptanceCriteria'
					value = $AcceptanceCriteria
				}
			)
		}

		IF ($OriginalEstimate)
		{
			$Body += @([pscustomobject]@{
					op = "add"
					path = '/fields/Microsoft.VSTS.Scheduling.OriginalEstimate'
					value = $OriginalEstimate
				}
			)
		}

		IF ($Tags)
		{
			ForEach ($Tag in $Tags) {$CombiTag += "$Tag;"}
			$Body += @([pscustomobject]@{
					op = "add"
					path = '/fields/System.Tags'
					value = $CombiTag
				}
			)
		}
		$Body = ConvertTo-Json $Body
		Write-Verbose -Message $Body
		Write-Verbose -Message "$Uri"
		$Result = Invoke-RestMethod -Uri $Uri -Method POST -Headers $Header -ContentType "application/json-patch+json" -Body $Body
	}
	END{
		Write-Verbose -Message "Ending $($MyInvocation.Mycommand)"
		$Result
	}
}
