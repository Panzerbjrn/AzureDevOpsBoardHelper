# Variables
$Organization = "https://dev.azure.com/YourOrganizationName"
$Project = "YourProjectName"
$RepoName = "YourRepoName"
$SourceBranch = "refs/heads/your-source-branch"
$TargetBranch = "refs/heads/your-target-branch"
$Title = "Pull Request Title"
$Description = "Pull Request Description"
$PAT = "YourPersonalAccessToken"

# Prepare API endpoint
$Url = "$Organization/$Project/_apis/git/repositories/$RepoName/pullrequests?api-version=7.1-preview.1"

# Request body
$Body = @{
    sourceRefName = $SourceBranch
    targetRefName = $TargetBranch
    title = $Title
    description = $Description
    reviewers = @()  # Add reviewers here if required
} | ConvertTo-Json -Depth 10

# Headers
$Headers = @{
    Authorization = "Basic $( [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes(":$PAT")) )"
    "Content-Type" = "application/json"
}

# Create pull request
$response = Invoke-RestMethod -Uri $Url -Method Post -Headers $Headers -Body $Body

# Output response
$response
