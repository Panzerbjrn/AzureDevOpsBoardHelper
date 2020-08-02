##From https://docs.microsoft.com/en-us/previous-versions/technet-magazine/hh360993(v=msdn.10)
Function Verb-Noun
{
<#
	.SYNOPSIS

	.DESCRIPTION

	.EXAMPLE

	.PARAMETER

	.INPUTS

	.OUTPUTS

	.NOTES
#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory,
			ValueFromPipeline=$True,
			ValueFromPipelineByPropertyName=$True,
			HelpMessage='What?')]
		[Alias('alias')]
		[ValidateLength(3,30)]
		[ValidateNotNullOrEmpty()]
		[string[]]$ComputerName
	)

	BEGIN
	{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
	}

	PROCESS
	{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"
	}
	END
	{
		Write-Verbose "Ending $($MyInvocation.Mycommand)"
	}
}
