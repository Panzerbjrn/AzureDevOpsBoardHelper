##From https://docs.microsoft.com/en-us/previous-versions/technet-magazine/hh360993(v=msdn.10)
Function Do-Something
{
<#
	.SYNOPSIS
		Describe the function here

	.DESCRIPTION
		Describe the function in more detail

	.EXAMPLE
		Give an example of how to use it

	.EXAMPLE
		Give another example of how to use it

	.PARAMETER ComputerName
		The Computer name to query. Just one.

	.PARAMETER LogName
		The name of a file to write failed Computer names to. Defaults to errors.txt.

	.INPUTS
		Input is from command line or called from a script.

	.OUTPUTS
		This will output the logfile.

	.NOTES
		Version:			0.1
		Author:				Lars Panzerbjørn
		Creation Date:		2020.05.12
		Purpose/Change: Initial script development
#>
	[CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]
	param
	(
		[Parameter(Mandatory,
			ValueFromPipeline=$True,
			ValueFromPipelineByPropertyName=$True,
			HelpMessage='What Computer name would you like to target?')]
		[Alias('host')]
		[ValidateLength(3,30)]
		[string[]]$ComputerName,

		[string]$Logname = 'errors.txt'
	)

	BEGIN
	{
		Write-Verbose "Beginning $($MyInvocation.Mycommand)"
		Write-Verbose "Deleting $Logname"
		Remove-Item $LogName -ErrorActionSilentlyContinue
	}

	PROCESS
	{
		Write-Verbose "Processing $($MyInvocation.Mycommand)"

		ForEach ($Computer in $ComputerName) {
			Write-Verbose "Processing $Computer"
			IF ($pscmdlet.ShouldProcess($Computer)) {
				# use $Computer here
			}
		}
	}
	END
	{
		Write-Verbose "Ending $($MyInvocation.Mycommand)"
	}
}
