Function Get-AzDOPipelineVariables{
<#
	.SYNOPSIS
		This will get a list of variables for a pipeline.

	.DESCRIPTION
		This will get a list of variables for a pipeline.

	.EXAMPLE
		Get-AzDOPipelineVariables -Project "Alpha Devs" -PipelineID 157

	.PARAMETER Project
		The name of your Azure Devops project. Is also often a team name.

	.PARAMETER PipelineID
		The ID of the pipeline you want to see variables for.

	.INPUTS
		Input is from command line or called from a script.

	.OUTPUTS
		This will output a list of Pipeline variables.

	.NOTES
		Author:				Lars Panzerbjørn
		Creation Date:		2024.09.22
#>
	[CmdletBinding()]
	param(
		[Parameter()]
		[Alias('TeamName')]
		[string]$Project,

		[Parameter(Mandatory)]
		[string]$PipelineID
	)

	BEGIN{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
		$Uri = $BaseUri + "$Project/_apis/pipelines/$PipelineId`?api-version=7.0"
	}

	PROCESS{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"
		$Response = Invoke-RestMethod -Uri $Uri -Method get -Headers $Header		#Retrieves list of Variables

		$PipelineVariables = @()
		ForEach ($Variable in $Response.configuration.variables.PSObject.Properties) { $PipelineVariables += $Variable.Name }
	}

	END{
		Write-Verbose "Ending $($MyInvocation.Mycommand)"
		$PipelineVariables
	}
}
