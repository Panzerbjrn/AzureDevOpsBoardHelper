Function Get-AzDoAccessToken{
<#
	.SYNOPSIS
		Gets the bearer token needed for REST API calls.

	.DESCRIPTION
		Gets the bearer token needed for REST API calls. This token is saved to the script scope.

	.EXAMPLE
		$TenantId = "c123456f-a1cd-6fv7-bh73-123r5t6y7u8i9"
		$ClientId = '1a2s3d4d4-dfhg-4567-d5f6-h4f6g7k933ae'
		$ClientSecret = '36._ERF567.6FB.XFGY75D-35TGasdrvk467'

		Get-AzDoAccessToken -TenantID $TenantID -ClientID $ClientId -ClientSecret $ClientSecret
		
		This command will produce an access token.

	.EXAMPLE
		$TenantId = "c123456f-a1cd-6fv7-bh73-123r5t6y7u8i9"
		$ClientId = '1a2s3d4d4-dfhg-4567-d5f6-h4f6g7k933ae'
		$ClientSecret = '36._ERF567.6FB.XFGY75D-35TGasdrvk467'

		$AccessToken = Get-AzDoAccessToken -TenantID $TenantID -ClientID $ClientId -ClientSecret $ClientSecret
		$AccessToken
		
		This command will produce an access token and save it to a variable. It then displays the token on screen

	.PARAMETER TenantID
		This is the tenant ID of your Azure subscription.

	.PARAMETER ClientID
		This is the ClientID of the Service Principal. Also called Application ID.

	.PARAMETER ClientSecret
		This is the Client Secret/Password that was generated when you secured the Service Principal

	.INPUTS
		Input is from command line or called from a script.

	.OUTPUTS
		This will output a bearer token that can be used in future API calls.

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
#		$Script:JsonContentType = 'application/json-patch+json' 	## This did not seem to work even though it used to.
		$Script:Token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($PersonalAccessToken)"))
		$Script:Header = @{Authorization = 'Basic ' + $Token;accept=$JsonContentType}
		Write-Verbose "Token is: $($Token)"
}

