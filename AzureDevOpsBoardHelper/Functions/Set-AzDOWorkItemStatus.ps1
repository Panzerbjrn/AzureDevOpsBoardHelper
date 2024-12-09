Function Set-AzDOWorkItemStatus {
<#
	.SYNOPSIS
		Sets the status of a work item

	.DESCRIPTION
		Sets the status of a work item

	.EXAMPLE
		Set-AzDOWorkItemStatus -Project "Alpha Devs" -WorkItemID 123456 -Status Active

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
		[Parameter(Mandatory)]
		[Alias('TeamName')]
		[string]$Project,

		[Parameter(Mandatory)]
		[Alias('WorkItem','ID')]
		[string]$WorkItemID,

		[Parameter()][string]$Status = "Active"
	)

	BEGIN{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
		$Uri = $BaseUri + "$Project/_apis/wit/workitems/`$workItemId`?api-version=7.0"
	}

	PROCESS{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"

        $Body = @(
            @{
                op = "replace"
                path = "/fields/System.State"
                value = "$Status"
            }
        )
        $Body = ConvertTo-Json -InputObject $Body

		Write-Verbose -Message $Body
		Write-Verbose -Message $Uri
		$Result = Invoke-RestMethod -Uri $uri -Method PATCH -Headers $Header -ContentType "application/json-patch+json" -Body $Body
                  #Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body -OutVariable Response
	}
	END{
		Write-Verbose -Message "Ending $($MyInvocation.Mycommand)"
		$Result
	}
}
