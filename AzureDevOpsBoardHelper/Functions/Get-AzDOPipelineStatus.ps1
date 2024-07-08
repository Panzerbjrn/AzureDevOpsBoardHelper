Function Get-AzDOPipelineStatus {
    param (
        [string]$organization,
        [string]$project,
        [string]$pipelineId,
        [string]$runId,
        [string]$authHeader
    )

    $Uri = $BaseUri + "$Project/_apis/pipelines/$pipelineId/runs/$runId`?api-version=7.0"
    $Response = Invoke-WebRequest -Uri $Uri -Method Get -Headers $Header
    #$Response = Invoke-RestMethod -Uri $Uri -Method Get -Headers $Header
    return $Response
}
