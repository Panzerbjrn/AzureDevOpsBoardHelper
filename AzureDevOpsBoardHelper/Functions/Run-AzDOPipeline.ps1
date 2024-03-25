Function Run-AzDOPipeline{
<#
	.SYNOPSIS
		This will run a pipeline.

	.DESCRIPTION
		This will run a pipelinein your organisation.

	.EXAMPLE
		Run-AzDOPipeline -Project "Alpha Devs"

	.PARAMETER Project
		The name of your Azure Devops project. Is also often a team name.

	.PARAMETER PipelineID
		The ID of your pipeline.

	.INPUTS
		Input is from command line or called from a script.

	.OUTPUTS
		This will output a list of Pipelines.

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
		[string]$PipelineID
	)

	BEGIN{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
        $Uri = $BaseUri + "$Project/_apis/pipelines?api-version=7.0"
        $Uri = $BaseUri + "$Project/_apis/pipelines/$PipelineID/runs?api-version=7.0"
	}

	PROCESS{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"
		$Run = Invoke-RestMethod -Uri $Uri -Method POST -Headers $Header		#Runs a Pipeline
	}
	END{
		Write-Verbose "Ending $($MyInvocation.Mycommand)"
		$Run.Value
	}
}
