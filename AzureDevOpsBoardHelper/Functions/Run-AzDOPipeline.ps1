Function Start-AzDOPipeline{
<#
	.SYNOPSIS
		This will run a pipeline.

	.DESCRIPTION
		This will run a pipeline in your organisation.

	.EXAMPLE
		# Runs with default branch
		Start-AzDOPipeline -Project "Ursus Devs"

    .EXAMPLE
		# Runs with the branch feature-321
        Start-AzDOPipeline -Project "Ursus Devs" -PipelineID "1" -BranchName "feature-321"

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
		[Parameter()]
		[Alias('TeamName')]
		[string]$Project = $Script:Project,

		[Parameter(Mandatory)]
		[string]$PipelineId,

        [Parameter()]
        [string]$BranchName,

		[Parameter()]
		[string[]]$StagesToSkip
	)

	BEGIN{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
        $Uri = $BaseUri + "$Project/_apis/pipelines/$PipelineId/runs?api-version=7.0"
	}

	PROCESS{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"

		#Creating JsonBody
		$JsonBody = @{}

        $RunParameters = @{
            resources = @{
                repositories = @{
                    self = @{}
                }
            }
        }

        IF($BranchName) {
            $RunParameters.resources.repositories.self["refName"] = "refs/heads/$BranchName"
        }
		$JsonBody.runParameters = $RunParameters

		IF($StagesToSkip) {
			$JsonBody.stagesToSkip = $StagesToSkip
		}

        #$JsonBody = $JsonBody | ConvertTo-Json
        $JsonBody = $JsonBody | ConvertTo-Json -Depth 10

		$Run = Invoke-RestMethod -Uri $Uri -Method POST -Headers $Header -ContentType $JsonContentType -Body $JsonBody
	}
	END{
		Write-Verbose "Ending $($MyInvocation.Mycommand)"
		$Run
	}
}

