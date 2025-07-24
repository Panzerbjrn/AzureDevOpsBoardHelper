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

	.PARAMETER Project
		The name of your Azure Devops Project or Team

	.PARAMETER Board
		The name of your Azure Devops Board you want to add the item to

	.PARAMETER WorkItemID
		The ID of the work item you want to add the comment to

	.PARAMETER Comment
		The comment you want to add to the work item

	.INPUTS
		Input is from command line or called from a script.

	.OUTPUTS
		This will output the rest api response.

	.NOTES
		Author:				Lars Panzerbjørn
		Creation Date:		2020.07.31
#>
	[CmdletBinding()]
	param(
		[Parameter()]
		[Alias('Company')]
		[string]$Organisation = $Script:Organisation,

		[Parameter()]
		[Alias('TeamName')]
		[string]$Project = $Script:Project,

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
		$Result = Invoke-RestMethod -Uri $Uri -Method PATCH -Headers $Header -ContentType $JsonContentType -Body $Body
	}
	END{
		Write-Verbose "Ending $($MyInvocation.Mycommand)"
		#$Body
		$Result
	}
}
