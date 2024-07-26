Function Get-AzDOYAMLPipelineStages {
<#
    .SYNOPSIS
        Retrieves the stages of a specified Azure DevOps YAML pipeline.

    .DESCRIPTION
        This function queries the Azure DevOps API to get the YAML content of a pipeline and extracts the stages.

    .EXAMPLE
        Get-AzDOYAMLPipelineStages -Project "Alpha Devs" -PipelineID 12

    .PARAMETER Project
        The name of your Azure DevOps project.

    .PARAMETER PipelineID
        The ID of your pipeline.

    .OUTPUTS
        This will output the stages of the specified YAML pipeline.

    .NOTES
        Author:             Lars Panzerbjørn
        Creation Date:      2024.07.25
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Project,

        [Parameter(Mandatory)]
        [string]$PipelineID
    )

    BEGIN {
        Write-Verbose "Beginning $($MyInvocation.Mycommand)"
        $Uri = $BaseUri + "$Project/_apis/pipelines/$PipelineID/definitions?api-version=7.0"
    }

    PROCESS {
        Write-Verbose "Processing $($MyInvocation.Mycommand)"
        $PipelineDefinition = Invoke-RestMethod -Uri $Uri -Method GET -Headers $Header -ContentType $JsonContentType
        
        # Extract the YAML content from the pipeline definition
        $YamlContent = $PipelineDefinition.configuration.repository.yamlFileContent
        
        # Convert YAML to PSObject
    }
}