# Load the function to test
$functionPath = "$PSScriptRoot\..\AzureDevOpsBoardHelper\Functions\Get-AzDoAccessToken.ps1"
if (Test-Path $functionPath) {
    . $functionPath
} else {
    throw "Function script not found: $functionPath"
}

Describe "Get-AzDoAccessToken" {

    # Sample input data for testing
    $samplePersonalAccessToken = 'gsbc424qhoya6j2g6u6kbvugx6ptehqnid2b5zyqcy37bkxrp53q'
    $sampleOrganisation = "Panzerbjrn"
    $sampleProject = "Panzerbjrn"

    BeforeAll {
        # Setup any pre-requisites here if necessary
    }

    AfterAll {
        # Cleanup actions here if necessary
    }

    Context "Parameter Validation" {
        It "Should throw an error if PersonalAccessToken is not provided" {
            { Get-AzDoAccessToken -Organisation $sampleOrganisation -Project $sampleProject } | Should -Throw
        }

        It "Should throw an error if Organisation is not provided" {
            { Get-AzDoAccessToken -PersonalAccessToken $samplePersonalAccessToken -Project $sampleProject } | Should -Throw
        }

        It "Should throw an error if Project is not provided" {
            { Get-AzDoAccessToken -PersonalAccessToken $samplePersonalAccessToken -Organisation $sampleOrganisation } | Should -Throw
        }
    }

    Context "Function Logic" {
        BeforeEach {
            # Clear script scope variables before each test
            Remove-Variable -Name Script -Scope Script -ErrorAction SilentlyContinue
        }

        It "Should correctly set the BaseUri variable" {
            Get-AzDoAccessToken -PersonalAccessToken $samplePersonalAccessToken -Organisation $sampleOrganisation -Project $sampleProject
            $Script:BaseUri | Should -BeExactly "https://dev.azure.com/$sampleOrganisation/"
        }

    #     It "Should correctly set the JsonContentType variable" {
    #         Get-AzDoAccessToken -PersonalAccessToken $samplePersonalAccessToken -Organisation $sampleOrganisation -Project $sampleProject
    #         $Script:JsonContentType | Should -BeExactly 'application/json'
    #     }

    #     It "Should correctly convert the PersonalAccessToken to Base64" {
    #         $expectedToken = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$samplePersonalAccessToken"))
    #         Get-AzDoAccessToken -PersonalAccessToken $samplePersonalAccessToken -Organisation $sampleOrganisation -Project $sampleProject
    #         $Script:Token | Should -BeExactly $expectedToken
    #     }

    #     It "Should correctly set the Header variable" {
    #         $expectedToken = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$samplePersonalAccessToken"))
    #         $expectedHeader = @{Authorization = 'Basic ' + $expectedToken; accept = 'application/json'}
    #         Get-AzDoAccessToken -PersonalAccessToken $samplePersonalAccessToken -Organisation $sampleOrganisation -Project $sampleProject
    #         $Script:Header | Should -BeExactly $expectedHeader
    #     }

    #     It "Should output Verbose messages if Verbose switch is used" {
    #         $verboseOutput = {
    #             Get-AzDoAccessToken -PersonalAccessToken $samplePersonalAccessToken -Organisation $sampleOrganisation -Project $sampleProject -Verbose
    #         } | & { param ($cmd) & $cmd 4>&1 }
    #         $verboseOutput | Should -Contain "Starting Get-AzDoAccessToken"
    #         $verboseOutput | Should -Contain "Token is: $([System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$samplePersonalAccessToken")))"
    #     }
    }
}


# # Load the function to test
# . "C:\ReposLP\AzureDevOpsBoardHelper\AzureDevOpsBoardHelper\Functions\Get-AzDoAccessToken.ps1"

# Describe "Get-AzDoAccessToken" {

#     # Sample input data for testing
#     $samplePersonalAccessToken = 'gsbc424qhoya6j2g6u6kbvugx6ptehqnid2b5zyqcy37bkxrp53q'
#     $sampleOrganisation = "Panzerbjrn"
#     $sampleProject = "Panzerbjrn"

#     BeforeAll {
#         # Setup any pre-requisites here if necessary
#     }

#     AfterAll {
#         # Cleanup actions here if necessary
#     }

#     Context "Parameter Validation" {
#         It "Should throw an error if PersonalAccessToken is not provided" {
#             { Get-AzDoAccessToken -Organisation $sampleOrganisation -Project $sampleProject } | Should -Throw
#         }

#         It "Should throw an error if Organisation is not provided" {
#             { Get-AzDoAccessToken -PersonalAccessToken $samplePersonalAccessToken -Project $sampleProject } | Should -Throw
#         }

#         It "Should throw an error if Project is not provided" {
#             { Get-AzDoAccessToken -PersonalAccessToken $samplePersonalAccessToken -Organisation $sampleOrganisation } | Should -Throw
#         }
#     }

#     Context "Function Logic" {
#         BeforeEach {
#             # Clear script scope variables before each test
#             Remove-Variable -Name Script -Scope Script -ErrorAction SilentlyContinue
#         }
#         It "Should correctly set the BaseUri variable" {
#             Get-AzDoAccessToken -PersonalAccessToken $samplePersonalAccessToken -Organisation $sampleOrganisation -Project $sampleProject
#             $Script:BaseUri | Should -BeExactly "https://dev.azure.com/$sampleOrganisation/"
#         }

#         # It "Should correctly set the JsonContentType variable" {
#         #     Get-AzDoAccessToken -PersonalAccessToken $samplePersonalAccessToken -Organisation $sampleOrganisation -Project $sampleProject
#         #     $Script:JsonContentType | Should -BeExactly 'application/json'
#         # }

#         # It "Should correctly convert the PersonalAccessToken to Base64" {
#         #     $expectedToken = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$samplePersonalAccessToken"))
#         #     Get-AzDoAccessToken -PersonalAccessToken $samplePersonalAccessToken -Organisation $sampleOrganisation -Project $sampleProject
#         #     $Script:Token | Should -BeExactly $expectedToken
#         # }

#         # It "Should correctly set the Header variable" {
#         #     $expectedToken = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$samplePersonalAccessToken"))
#         #     $expectedHeader = @{Authorization = 'Basic ' + $expectedToken; accept = 'application/json'}
#         #     Get-AzDoAccessToken -PersonalAccessToken $samplePersonalAccessToken -Organisation $sampleOrganisation -Project $sampleProject
#         #     $Script:Header | Should -BeExactly $expectedHeader
#         # }

#         # It "Should output Verbose messages if Verbose switch is used" {
#         #     $verboseOutput = {
#         #         Get-AzDoAccessToken -PersonalAccessToken $samplePersonalAccessToken -Organisation $sampleOrganisation -Project $sampleProject -Verbose
#         #     } | & { param ($cmd) & $cmd 4>&1 }
#         #     $verboseOutput | Should -Contain "Starting Get-AzDoAccessToken"
#         #     $verboseOutput | Should -Contain "Token is: $([System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$samplePersonalAccessToken")))"
#         # }
#     }
# }