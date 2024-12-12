# Run-AzDOPipeline.Tests.ps1
Describe "Run-AzDOPipeline Tests" {

    # Mock the Invoke-RestMethod cmdlet to prevent actual API calls
    Mock -CommandName Invoke-RestMethod {
        return @{ status = 'Mocked Run' }
    }

    # Mock or set $BaseUri to a valid value
    BeforeAll {
        # You can either mock or assign the base URI
        $script:BaseUri = "https://dev.azure.com/"
    }

    # Test case: Running with default branch (i.e., no BranchName supplied)
    Context "When running the pipeline with default branch" {
        It "should construct the correct URI and JsonBody" {
            $Project = "Ursus Devs"
            $PipelineID = "1"

            # Run the function
            $result = Run-AzDOPipeline -Project $Project -PipelineID $PipelineID

            # Assert the URI construction
            $expectedUri = "$BaseUri$Project/_apis/pipelines/$PipelineID/runs?api-version=7.0"
            Assert-MockCalled -CommandName Invoke-RestMethod -Exactly 1 -Scope It -ParameterFilter { $Uri -eq $expectedUri }

            # Assert the JsonBody structure
            $expectedJsonBody = @{
                resources = @{
                    repositories = @{
                        self = @{
                            refName = "refs/heads/master"
                        }
                    }
                }
            } | ConvertTo-Json -Depth 10

            # The function should have passed this JSON body to Invoke-RestMethod
            Assert-MockCalled -CommandName Invoke-RestMethod -Exactly 1 -Scope It -ParameterFilter { $Body -eq $expectedJsonBody }
        }
    }

    # Test case: Running with a specific branch
    Context "When running the pipeline with a specific branch" {
        It "should construct the correct JsonBody for the branch" {
            $Project = "Ursus Devs"
            $PipelineID = "1"
            $BranchName = "feature-321"

            # Run the function
            $result = Run-AzDOPipeline -Project $Project -PipelineID $PipelineID -BranchName $BranchName

            # Assert the JsonBody structure with the specified branch
            $expectedJsonBody = @{
                resources = @{
                    repositories = @{
                        self = @{
                            refName = "refs/heads/$BranchName"
                        }
                    }
                }
            } | ConvertTo-Json -Depth 10

            Assert-MockCalled -CommandName Invoke-RestMethod -Exactly 1 -Scope It -ParameterFilter { $Body -eq $expectedJsonBody }
        }
    }
}
