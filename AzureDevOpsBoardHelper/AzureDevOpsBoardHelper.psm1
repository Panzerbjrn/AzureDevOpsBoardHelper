[CmdletBinding()]
param()

Write-Verbose $PSScriptRoot

#Get Functions and Helpers function definition files.
$Functions	= @( Get-ChildItem -Path $PSScriptRoot\Functions\*.ps1 -ErrorAction SilentlyContinue )
$Helpers = @( Get-ChildItem -Path $PSScriptRoot\Helpers\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
ForEach ($Import in @($Functions + $Helpers)){
	Try{
		. $Import.Fullname
	}
	Catch{
		Write-Error -Message "Failed to Import function $($Import.Fullname): $_"
	}
}

Export-ModuleMember -Function $Functions.Basename

Set-Alias -Name Run-AzDOPipeline -Value Start-AzDOPipeline
Export-ModuleMember -Function Start-AzDOPipeline -Alias Run-AzDOPipeline