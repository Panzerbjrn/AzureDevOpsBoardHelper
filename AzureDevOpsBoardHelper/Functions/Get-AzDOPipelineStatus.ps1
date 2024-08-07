Function Get-AzDOPipelineStatus {
    param (
        [string]$project,
        [string]$pipelineId,
        [string]$runId
    )

    $Uri = $BaseUri + "$Project/_apis/pipelines/$pipelineId/runs/$runId`?api-version=7.0"
    $Response = Invoke-RestMethod -Uri $Uri -Method Get -Headers $Header
    return $Response
}
