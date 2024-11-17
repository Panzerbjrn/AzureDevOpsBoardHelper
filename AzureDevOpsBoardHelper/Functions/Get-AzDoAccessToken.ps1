Function Get-AzDoAccessToken{
<#
	.SYNOPSIS
		Gets the bearer token needed for REST API calls.

	.DESCRIPTION
		Gets the bearer token needed for REST API calls. This token is saved to the script scope.

	.EXAMPLE
		$PersonalAccessToken = "c123456f-a1cd-6fv7-bh73-123r5t6y7u8i9"
		$Organisation = 'CentralIndustrial'
		$Project = 'TeamDevOps'

		Get-AzDoAccessToken -PersonalAccessToken $PersonalAccessToken -Organisation $Organisation -Project $Project

		This command will produce an access token which is added as a script scope variable.

	.EXAMPLE
		$PersonalAccessToken = "c123456f-a1cd-6fv7-bh73-123r5t6y7u8i9"
		$Organisation = 'CentralIndustrial'
		$Project = 'TeamDevOps'

		Get-AzDoAccessToken -PersonalAccessToken $PersonalAccessToken -Organisation $Organisation -Project $Project -Verbose
		$AccessToken

		This command will produce an access token which is added as a script scope variable. It then displays the token on screen

	.PARAMETER PersonalAccessToken
		This is your Personal Access Token you get from Azure DevOps

	.PARAMETER Organisation
		This is the Organisation your Azure DevOps Project is in.

	.PARAMETER Project
		This is the Project/Team your resources are in.

	.INPUTS
		Input is from command line or called from a script.

	.OUTPUTS
		This will create a bearer token that will be used in future API calls.

	.NOTES
		Author:				Lars Panzerbjørn
		Creation Date:		2021.07.30
#>
	[CmdletBinding()]
	param
	(
        [Parameter(Mandatory)]
		[Alias('PAT')]
		[string]$PersonalAccessToken,

		[Parameter(Mandatory)]
		[Alias('Company')]
		[string]$Organisation,

		[Parameter(Mandatory)]
		[Alias('TeamName')]
		[string]$Project
	)

		Write-Verbose "Starting $($MyInvocation.Mycommand)"

		$Script:BaseUri			= "https://dev.azure.com/$($Organisation)/"
		$Script:Organisation	= $Organisation
		$Script:Project			= $Project
		$Script:JsonContentType = 'application/json'
		$Script:Token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($PersonalAccessToken)"))
		$Script:Header = @{Authorization = 'Basic ' + $Token;accept=$JsonContentType}
		Write-Verbose "Token is: $($Token)"
}
