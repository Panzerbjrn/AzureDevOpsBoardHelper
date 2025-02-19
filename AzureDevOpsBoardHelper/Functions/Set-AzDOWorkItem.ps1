Function Set-AzDOWorkItem {
<#
	.SYNOPSIS
		Sets various values for a work item

	.DESCRIPTION
		Sets various values for a work item

	.EXAMPLE
		Set-AzDOWorkItem -Project "Alpha Devs" -WorkItemID 123456 -Status Active

	.PARAMETER Project
		The name of your Azure Devops Project or Team

	.PARAMETER WorkItemID
		The ID number of the work item you wish to delete

	.PARAMETER Status
		The desired status to set the work item to.

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
		[Alias('')]
		[string]$Project = $Script:Project,

		[Parameter(Mandatory)]
		[Alias('WorkItem','ID')]
		[string]$WorkItemID,

		[Parameter()][int]$OriginalEstimate,
		[Parameter()][int]$RemainingWork,
		[Parameter()][int]$CompletedWork,
		[Parameter()][string]$Status = "Active"
	)

	BEGIN{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
		$Uri = $BaseUri + "$Project/_apis/wit/workitems/$workItemId`?api-version=7.0"
	}

	PROCESS{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"

        $Body = @(
            @{
                op = "replace"
                path = "/fields/System.State"
                value = $Status
            }
        )
        $Body = ConvertTo-Json -InputObject $Body

		Write-Verbose -Message $Body
		Write-Verbose -Message $Uri
		$Result = Invoke-RestMethod -Uri $uri -Method PATCH -Headers $Header -ContentType "application/json-patch+json" -Body $Body
	}
	END{
		Write-Verbose -Message "Ending $($MyInvocation.Mycommand)"
		$Result
	}
}
