Function Get-AzDOPipelines{
<#
	.SYNOPSIS
		This will get a list of Pipelines in your organisation.

	.DESCRIPTION
		This will get a list of Pipelines in your organisation.

	.EXAMPLE
		Get-AzDOPipelines -Project "Alpha Devs"

	.PARAMETER Project
		The name of your Azure Devops project. Is also often a team name.

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
		[string]$Project
	)

	BEGIN{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
        $Uri = $BaseUri + "$Project/_apis/pipelines?api-version=7.0"
	}

	PROCESS{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"
		$Pipelines = Invoke-RestMethod -Uri $Uri -Method get -Headers $Header		#Retrieves list of Pipelines
	}
	END{
		Write-Verbose "Ending $($MyInvocation.Mycommand)"
		$Pipelines.Value
	}
}
