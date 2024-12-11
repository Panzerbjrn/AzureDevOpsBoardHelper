Function Add-AzDoUserStoryComment{
<#
	.SYNOPSIS
		Adds a comment to a user story

	.DESCRIPTION
		Creates a work item of the type User Story

	.EXAMPLE
		New-AzDoUserStoryWorkItem -Organisation panzerbjrn -Project "Alpha Devs" -Title "New Story Item"

	.EXAMPLE
		This example first get details from another work item, and uses those to place a new item on the same board.
		This also uses <br> to break lines in the descrption field.

		$WItem = Get-AzDoUserStoryWorkItem -Organisation $OrganizationName -Project $TeamName -WorkItemID 123456
		New-AzDoUserStoryWorkItem  -Organisation $$Organisation -Project $TeamName -Title "Important Scripting work" -Board $WItem.fields.'System.AreaPath' -Description "Important work <br> Line 2" -AssignedTo $WItem.fields.'System.AssignedTo'.displayName -Verbose -Tags "Tag1","Tag2" -AcceptanceCriteria "Accepted"

	.PARAMETER OrganizationName
		The name of your Azure Devops Organisation

	.PARAMETER ProjectName
		The name of your Azure Devops Project or Team

	.PARAMETER WorkItemTitle
		The name of your Azure Devops Project or Team

	.PARAMETER Board
		The name of your Azure Devops Board you want to add the item to

	.PARAMETER Board
		The name of your Azure Devops Board you want to add the item to

	.PARAMETER Description
		The content of the description field. Lines can be broken by adding <br>

	.PARAMETER AcceptanceCriteria
		The content of the Acceptance Criteria field. Lines can be broken by adding <br>

	.PARAMETER Priority
		This is the priority of the item. Default is 3.

	.PARAMETER AssignedTo
		This is the person the item is assigned to.

	.PARAMETER Tags
		Tags assigned to the work item. These are separated by commas, i.e. "Tag1","Tag2"

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
	[CmdletBinding()]
	param(
		[Parameter()]
		[Alias('Company')]
		[string]$Organisation,

		[Parameter()]
		[Alias('TeamName')]
		[string]$Project,

		[Parameter(Mandatory)]
		[Alias('WorkItem','ID')]
		[string]$WorkItemID,

		[Parameter()]
		[string]$Board,

		[Parameter(Mandatory)]
		[string]$Comment
	)

	BEGIN{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
		$Uri = $BaseUri + "$Project/_apis/wit/workitems/$WorkItemID`?api-version=7.0"
	}

	PROCESS{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"

		$Body = @([pscustomobject]@{
			op = "add"
			path = '/fields/System.History'
			value = $Comment
		})
		$Body = ConvertTo-Json $Body
		$Body
		$Result = Invoke-RestMethod -Uri $uri -Method PATCH -Headers $Header -ContentType $JsonContentType -Body $Body
	}
	END{
		Write-Verbose "Ending $($MyInvocation.Mycommand)"
		#$Body
		$Result
	}
}
