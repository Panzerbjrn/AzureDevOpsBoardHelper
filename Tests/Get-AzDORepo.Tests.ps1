Describe 'Getting Azure Repos' -Tag 'AzureDevOps' {

    Context 'When getting Azure Repos' {
        BeforeAll {
            Get-AzDoAccessToken @GetAzDoAccessTokenSplat

            Get-AzDORepo -OutVariable Output
        }

        It 'Output should be greater than 0' {
            $Output.Count | Should -BeGreaterThan 0
        }

        It 'Name should not be empty' {
            $Output[0].name | Should -Not -BeNullOrEmpty
        }

        It 'URL should not be empty' {
            $Output[0].url | Should -Not -BeNullOrEmpty
        }
        It 'URL should not be empty' {
            $Output[0].defaultBranch | Should -Not -BeNullOrEmpty
        }
    }
}