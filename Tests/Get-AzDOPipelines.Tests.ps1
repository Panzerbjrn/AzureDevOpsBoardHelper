Describe 'Getting Azure Pipelines' -Tag 'AzureDevOps' {

    Context 'When getting Azure Pipelines' {
        BeforeAll {
            Get-AzDoAccessToken @GetAzDoAccessTokenSplat

            Get-AzDOPipelines -OutVariable Output
        }

        It 'Output should be greater than 0' {

            $Output.Count | Should -BeGreaterThan 0
        }
    }
}