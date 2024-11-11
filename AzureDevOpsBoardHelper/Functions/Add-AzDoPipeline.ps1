Function Add-AzDoPipeline{
<#
	.SYNOPSIS
		Creates a work item of the type Task

	.DESCRIPTION
		Creates a work item of the type Task

	.EXAMPLE
		New-AzDoPipeline -PersonalAccessToken $PAT -PipelineName "Test_Pipe" -Project "CI Team" -RepositoryName CoolRepo

	.PARAMETER PipelineName
		The name of pipeline you wish to create

	.PARAMETER ProjectName
		The name of your Azure Devops Project or Team

	.PARAMETER RepositoryId
		The ID of your Repository

	.PARAMETER FolderPath
		If you use folders to organise your Pipelines, this can be added here.

	.PARAMETER YAMLPath
		The path to the yaml file the pipeline should use.

	.INPUTS
		Input is from command line or called from a script.

	.NOTES
		Author:			Lars Panzerbjørn
		Creation Date:	2024.11.09
		Purpose/Change: Initial script development
#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[string]$PipelineName,

		[Parameter(Mandatory)]
		[Alias('TeamName')]
		[string]$Project,

		[Parameter(Mandatory)]
		[string]$RepositoryId,

		[Parameter()][string]$FolderPath,

		[Parameter(Mandatory)]
		[string]$YAMLPath
	)

	BEGIN{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
		$Uri = $BaseUri + "$Project/_apis/pipelines?api-version=7.0"
	}

	PROCESS{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"

		$Body = @{
			name = $pipelineName
			configuration = @{
				type = "yaml"
				path = $yamlPath
				repository = @{
					id = $repositoryId
					name = $repositoryId
					type = "azureReposGit"
				}
			}
		}
		$Body

		IF($FolderPath){
			$Body.FolderPath = $FolderPath
		}

		$Result = Invoke-RestMethod -Uri $uri -Method POST -Headers $Header -ContentType "application/json" -Body $Body


	}
	END{
		Write-Verbose "Ending $($MyInvocation.Mycommand)"
		$Result #| Select-Onject -Property id, name, url
	}
}
