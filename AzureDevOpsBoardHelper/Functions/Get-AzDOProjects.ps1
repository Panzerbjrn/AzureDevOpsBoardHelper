Function Get-AzDOProjects{
<#
	.SYNOPSIS
		This will get a list of Projects in your organisation.

	.DESCRIPTION
		This will get a list of Projects in your organisation.

	.EXAMPLE
		Get-AzDOProjects -Organisation CentralIndustrial

	.EXAMPLE
		$OrganizationName = CentralIndustrial
		$Projects = Get-AzDOProjects -Organisation $OrganizationName

	.PARAMETER OrganisationName
		The name of your Azure Devops Organisation

	.INPUTS
		Input is from command line or called from a script.

	.OUTPUTS
		This will output a list of projects.

	.NOTES
		Author:				Lars Panzerbjørn
		Creation Date:		2020.07.31
#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[Alias('Company')]
		[string]$Organisation
	)

	BEGIN{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
		$Uri = $BaseUri + "_apis/projects?api-version=7.0"
	}

	PROCESS{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"
		$Projects = Invoke-RestMethod -Uri $Uri -Method get -Headers $Header		#Retrieves list of Projects
	}
	END{
		Write-Verbose "Ending $($MyInvocation.Mycommand)"
		$Projects.Value
	}
}
