Function Get-AzDOPipelineStatus {
<#
	.SYNOPSIS

	.DESCRIPTION

	.PARAMETER Project

	.PARAMETER PipiLineID

	.PARAMETER RunID

    .Example

	.INPUTS
		Input is from command line or called from a script.

	.OUTPUTS

	.NOTES
		Author:				Lars Panzerbjørn
		Creation Date:		2020.07.31
#>
    param (
        [string]$Project = $Script:Project,
        [string]$pipelineId,
        [string]$RunID
    )

    $Uri = $BaseUri + "$Project/_apis/pipelines/$pipelineId/runs/$RunID`?api-version=7.0"
    $Response = Invoke-RestMethod -Uri $Uri -Method Get -Headers $Header
    return $Response
}
