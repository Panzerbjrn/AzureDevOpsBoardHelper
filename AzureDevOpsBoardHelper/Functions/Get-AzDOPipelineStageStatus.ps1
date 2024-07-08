function Get-AzDOPipelineStageStatus {
    param (
        [string]$project,
        [string]$pipelineId,
        [string]$runId
    )

    $Uri = $BaseUri + "$project/_apis/pipelines/$pipelineId/runs/$runId/stages?api-version=7.0"
    $Response = Invoke-RestMethod -Uri $Uri -Method Get -Headers $Header
    return $response
}
