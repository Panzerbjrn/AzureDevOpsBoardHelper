Function Get-AzDORepo{
<#
	.SYNOPSIS
		This will get This will get various details for a Repo in your Organisation.

	.DESCRIPTION
		This will get This will get various details for a Repo in your Organisation.

	.EXAMPLE
		This example will return details for all repos in the current project.
		If you have set the $Project variable, you can omit the Project parameter.
		Get-AzDORepo

	.EXAMPLE
		This example will return details for all repos in the project "Alpha Devs".
		Get-AzDORepo -Project "Alpha Devs"

	.EXAMPLE
		This example will return details for the repo named "CoolRepo" in the project "Alpha Devs".
		Get-AzDORepo -Project "Alpha Devs -RepositoryName "CoolRepo"

	.EXAMPLE
		This example will return details for the repo named "CoolRepo" in the current project.
		Get-AzDORepo -RepositoryName "CoolRepo"

	.PARAMETER RepositoryName
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
		[Alias('RepoName')]
		[string]$RepositoryName,

		[Parameter()]
		[Alias('TeamName')]
		[string]$Project = $Script:Project
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
