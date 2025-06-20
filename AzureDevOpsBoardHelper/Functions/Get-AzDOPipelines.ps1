Function Get-AzDOPipelines{
<#
	.SYNOPSIS
		This will get a list of Pipelines in your organisation.

	.DESCRIPTION
		This will get a list of Pipelines in your organisation.

	.EXAMPLE
		Get-AzDOPipelines

	.EXAMPLE
		Get-AzDOPipelines -Project "Alpha Devs"

	.PARAMETER Project
		The name of your Azure Devops project. Is also often a team name.

	.PARAMETER PipelineID
		This is the ID of your pipeline

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
		[Parameter()]
		[Alias('TeamName')]
		[string]$Project = $Script:Project,

		[Parameter()]
        [string]$PipelineId

	)

	BEGIN{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
		IF($PipelineId){
			$Uri = $BaseUri + "$Project/_apis/pipelines/$PipelineId`?api-version=7.0"

			#MarkdownBadge:
			#$MDUri = $BaseUri + "$Project/_apis/build/status/$PipelineId`?branchName=main&repoName=chuck-dev-uc1-01&api-version=6.0-preview.2"
		}
		ELSE{
			$Uri = $BaseUri + "$Project/_apis/pipelines?api-version=7.0"
		}
	}

	PROCESS{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"
		$Pipelines = Invoke-RestMethod -Uri $Uri -Method get -Headers $Header	#Retrieves list of Pipelines


	}
	END{
		Write-Verbose "Ending $($MyInvocation.Mycommand)"
		IF($PipelineId){
			$Pipelines
		}
		ELSE{
			$Pipelines.Value
	}
}
