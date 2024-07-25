Function Get-AzDOPipelineStages {
<#
    .SYNOPSIS
        Retrieves the stages of a specified Azure DevOps pipeline.

    .DESCRIPTION
        This function queries the Azure DevOps API to get the stages defined in a pipeline.

    .EXAMPLE
        Get-AzDOPipelineStages -Project "Alpha Devs" -PipelineID 12

    .PARAMETER Project
        The name of your Azure DevOps project.

    .PARAMETER PipelineID
        The ID of your pipeline.

    .OUTPUTS
        This will output the stages of the specified pipeline.

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
        $Uri = $BaseUri + "$Project/_apis/pipelines/$PipelineID?api-version=7.0"
    }

    PROCESS {
        Write-Verbose "Processing $($MyInvocation.Mycommand)"
        $PipelineDefinition = Invoke-RestMethod -Uri $Uri -Method GET -Headers $Header -ContentType $JsonContentType
        
        # Extract stages from the pipeline definition
        $stages = $PipelineDefinition.stages | Select-Object -ExpandProperty name
    }

    END {
        Write-Verbose "Ending $($MyInvocation.Mycommand)"
        $stages
    }
}
