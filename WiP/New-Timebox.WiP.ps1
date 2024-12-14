Function New-AzDoTimeBox{

	[CmdletBinding()]
	Param (
			[Parameter(Mandatory)]
			[Alias('PAT')]
			[string]$PersonalAccessToken,

			[Parameter(Mandatory)]
			[Alias('Company')]
			[string]$Organisation = $Script:Organisation,

			[Parameter(Mandatory)]
			[Alias('TeamName')]
			[string]$Project = $Script:Project,

			[Parameter()][string]$Board,

			[Parameter()][string]$WorkItemToCopy,

			[Parameter()][string[]]$Users
	)

	$AZDOSplat = @{
		PAT = $PersonalAccessToken
		Project = $Project
		Organisation = $Organisation
		Board = $Board
	}

	$WItem = Get-AzDoUserStoryWorkItem @AZDOSplat -WorkItemID $WorkItemToCopy

	$Description = "
		Acceptance criteria: SEE TASK ITEMS
		Requestor: ITBIT Team
		Source of the data: N/A
		Delivery of Request (dashboard, data feed, etc.): Weekly ADMIN tasks that need attention to ensure maintenance of our estate.
	"


	$NewAzDoUserStoryWorkItemSplat = @{
		Title = "Admin Support Timebox - $($WItem.fields.'System.IterationPath'.Split('\')[-1].split('(')[0])"
		Description = $WItem.fields.'System.description'
		Tags = $WItem.fields.'System.Tags'
		Iteration = $WItem.fields.'System.IterationPath'
	}
	ForEach ($User in $Users){
		$NewAzDoUserStoryWorkItemSplat.AssignedTo = $User
		$NewWItem = New-AzDoUserStoryWorkItem @AZDOSplat @NewAzDoUserStoryWorkItemSplat
		$NewWItem.id
	}
}