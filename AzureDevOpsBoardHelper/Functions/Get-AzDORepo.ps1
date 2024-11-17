Function Get-AzDORepo{
<#
	.SYNOPSIS
		This will get This will get various details for a Repo in your Organisation.

	.DESCRIPTION
		This will get This will get various details for a Repo in your Organisation.

	.EXAMPLE
		Get-AzDORepo -Project "Alpha Devs"

	.PARAMETER RepoName
		The name of your Azure Devops Repo. If Omitted, all repos are returned.

	.PARAMETER Project
		The name of your Azure Devops project. Is also often a team name.

	.INPUTS
		Input is from command line or called from a script.

	.OUTPUTS
		This will output a details for the repo.

	.NOTES
		Author:				Lars Panzerbjørn
		Creation Date:		2024.11.11
#>
	[CmdletBinding()]
	param(
		[Parameter()]
		[string]$RepoName,

		[Parameter(Mandatory)]
		[Alias('TeamName')]
		[string]$Project
	)

	BEGIN{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
	}

	PROCESS{
        IF($RepoName){
			$Uri = $BaseUri + "$Project/_apis/git/repositories/$RepoName`?api-version=7.0"
		}
		ELSE{
			$Uri = $BaseUri + "$Project/_apis/git/repositories?api-version=7.0"
		}
		Write-Verbose "Processing $($MyInvocation.Mycommand)"
		Write-Verbose "$Uri"

		$Response = Invoke-RestMethod -Uri $Uri -Method get -Headers $Header
	}
	END{
		Write-Verbose "Ending $($MyInvocation.Mycommand)"
		IF($RepoName){
			$Response
		}
		ELSE{
			$Response.value
		}
	}
}
