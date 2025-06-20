Function Add-AzDoRepo{
<#
	.SYNOPSIS
		Creates a work item of the type Task

	.DESCRIPTION
		Creates a work item of the type Task

	.EXAMPLE
		New-AzDoRepo -PersonalAccessToken $PAT -Organisation $Organisation -Project $Project -RepositoryName NewCoolRepo

	.PARAMETER OrganizationName
		The name of your Azure Devops Organisation

	.PARAMETER ProjectName
		The name of your Azure Devops Project or Team

	.PARAMETER RepositoryName
		The name of your new Repository

	.INPUTS
		Input is from command line or called from a script.

	.NOTES
		Author:			Lars Panzerbjørn
		Creation Date:	2024.11.09
		Purpose/Change: Initial script development
#>
	[CmdletBinding()]
	param(
		[Parameter()]
		[Alias('TeamName')]
		[string]$Project = $Script:Project,

		[Parameter()][string]$RepositoryName
	)

	BEGIN{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
		$Uri = $BaseUri + "$Project/_apis/git/repositories?api-version=7.0"
	}

	PROCESS{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"

		$Body = @{
			name = $RepositoryName
			#TODO - Add Optionals
			# Optional: Add additional settings here if needed
		} | ConvertTo-Json

		Write-Verbose $Uri
		Write-Verbose $Body
		$Result = Invoke-RestMethod -Uri $Uri -Method POST -Headers $Header -ContentType "application/json" -Body $Body


	}
	END{
		Write-Verbose "Ending $($MyInvocation.Mycommand)"
		if ($Result.name -eq $RepositoryName) {
			#Write-Output "Repository '$($Result.name)' created successfully in project '$Project'."
			$Result
		} else {
			Write-Output "Failed to create repository. Response:"
			Write-Output $Result
		}
	}
}
