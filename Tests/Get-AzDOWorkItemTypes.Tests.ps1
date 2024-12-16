Describe 'Getting Work Item Types' -Tag 'AzureDevOps' {

    Context 'When getting available work item types' {
        BeforeAll {
            Get-AzDoAccessToken @GetAzDoAccessTokenSplat

            Get-AzDOWorkItemTypes -OutVariable Output
        }

        It 'Output should be greater than 0' {

            $Output.Count | Should -BeGreaterThan 0
        }
    }
}