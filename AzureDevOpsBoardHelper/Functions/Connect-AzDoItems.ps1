Function Connect-AzDoItems{
<#
	.SYNOPSIS
		Links two Azure Devops item in a parent/child relationship

	.DESCRIPTION
		Links two Azure Devops item in a parent/child relationship

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
		Author:				Lars Panzerbjørn
		Creation Date:		2020.07.31
#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[Alias('TeamName')]
		[string]$Project,

		[Parameter(Mandatory)][string]$ParentItemID,
		[Parameter(Mandatory)][string]$ChildItemID
	)

	BEGIN{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
		$Uri = $BaseUri + "$Project/_apis/wit/workitems/$ChildItemID`?api-version=7.0"
	}

	PROCESS{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"
		$Value = @{
			rel = "System.LinkTypes.Hierarchy-Reverse"
			url = $BaseUri + "$Project/_apis/wit/workItems/$ParentItemID"
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
		$Result = Invoke-RestMethod -Uri $uri -Method PATCH -Headers $Header -ContentType "application/json-patch+json" -Body $Body

	}
	END{
		Write-Verbose "Ending $($MyInvocation.Mycommand)"
		#$Body
		$Result
	}
}
