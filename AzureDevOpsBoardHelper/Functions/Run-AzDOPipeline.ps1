Function Run-AzDOPipeline{
<#
	.SYNOPSIS
		This will run a pipeline.

	.DESCRIPTION
		This will run a pipelinein your organisation.

	.EXAMPLE
		# Runs with default branch
		Run-AzDOPipeline -Project "Ursus Devs"

    .EXAMPLE
		# Runs with the branch develop
        Run-AzDOPipeline -Project "Ursus Devs" -PipelineID "1" -BranchName "develop"

	.PARAMETER Project
		The name of your Azure Devops project. Is also often a team name.

	.PARAMETER PipelineID
		The ID of your pipeline.

    .PARAMETER BranchName
        The name of the branch to run the pipeline on. Defaults to the pipeline's default branch if not specified.

	.NOTES
		Author:				Lars Panzerbjørn
		Creation Date:		2020.07.31
#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[Alias('TeamName')]
		[string]$Project,

		[Parameter(Mandatory)]
		[string]$PipelineID,

        [Parameter()]
        [string]$BranchName
	)

	BEGIN{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
        $Uri = $BaseUri + "$Project/_apis/pipelines/$PipelineID/runs?api-version=7.0"
	}

	PROCESS{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"

        $runParameters = @{
            resources = @{
                repositories = @{
                    self = @{}
                }
            }
        }

        IF($BranchName) {
            $runParameters.resources.repositories.self.refName = "refs/heads/$BranchName"
        }

		$Run = Invoke-RestMethod -Uri $Uri -Method POST -Headers $Header -ContentType $JsonContentType -Body $JsonBody
	}
	END{
		Write-Verbose "Ending $($MyInvocation.Mycommand)"
		$Run
	}
}
