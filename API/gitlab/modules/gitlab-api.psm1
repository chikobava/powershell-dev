<#
    .Synopsis
	This module contains many gitlab-api functions, like:
    - Get-ProjectId 
    - Get-GroupId
    - Get-UserId
    and so forth. 
    It uses a gitlab token stored in an environment variable GITLAB_TOKEN.

	.EXAMPLE
    Get-ProjectId enzian-betrieb

    .EXAMPLE
    Get-GroupId your_group

    .EXAMPLE
    Get-UserId your_user
#>

function Get-GitlabProjectId {
    <#
        .Synopsis
        Provides ProjectID for a given project name.

        .Description
        Gitlab can have multiple projects with the same name, but with a different path.
        This functions returns all projects with the given name, so you have to look at the path, 
        to make sure, you get the right project.
        
        .Example
        Get-ProjectId enzian-betrieb
    #>
    param (
        $Path
    )

    $url = "https://$env:gitServer/api/v4/projects?search=$Path" 

    $headers = @{
        'PRIVATE-TOKEN' = $env:GITLAB_TOKEN
    }
    $response = Invoke-RestMethod $url -Method GET -Headers $headers
    $response
    
}
function Get-GitlabProject {
    <#
        .Synopsis
        Returns json with project information

        .Description
         
        .Example
        Get-GitabProject 479
    #>
    param (
        $projectId
    )

    $url = "https://$env:gitServer/api/v4/projects/$projectId"

    $headers = @{
        'PRIVATE-TOKEN' = $env:GITLAB_TOKEN
    }

    $response = Invoke-RestMethod $url -Method GET -Headers $headers
    $response
    
}

function Get-GitlabProjectMembers {
    <#
        .Synopsis
        Returns json with project members

        .Example
        Get-GitlabProjectMembers 479
    #>
    param (
        $projectId
    )

    $url = "https://$env:gitServer/api/v4/projects/$projectId/members"

    $headers = @{
        'PRIVATE-TOKEN' = $env:GITLAB_TOKEN
    }

    $response = Invoke-RestMethod $url -Method GET -Headers $headers
    $response
    
}
function Get-GitlabGroupId {
    <#
        .Synopsis
        Returns group ID for a specified path
    #>
    param (
        $path
    )

    $url = "https://$env:gitServer/api/v4/groups?search=$path" 

    $headers = @{
        'PRIVATE-TOKEN' = $env:GITLAB_TOKEN
    }

    $response = Invoke-RestMethod $url -Method GET -Headers $headers
    foreach ($group in $response) {
        "ID: $($group.Id) path: $($group.path)"
    }
    
}

function Get-GitlabGroups {
    <#
        .Synopsis
        Prints all gitlab groups
    #>
    param (
        $path
    )

    $url = "https://$env:gitServer/api/v4/groups?search=$path" 

    $headers = @{
        'PRIVATE-TOKEN' = $env:GITLAB_TOKEN
    }

    $response = Invoke-RestMethod $url -Method GET -Headers $headers
    foreach ($group in $response) {
        $group
    }
    
}

function Get-GitlabUserId {
    <#
        .Synopsis
        Returns a user id for specified username. This may be helpful, since 
        gitlab uses user ids for api requests and not usernames.
    #>
    param (
        $username
    )

    $url = "https://$env:gitServer/api/v4/users?username=$username"

    $headers = @{
        'PRIVATE-TOKEN' = $env:GITLAB_TOKEN
    }

    
    $response = Invoke-RestMethod  $url -Method GET -Headers $headers
    $response
}
function Get-GitlabNamespaces {
    <#
        .Synopsis
        Returns a json with all gitlab namespaces
    #>

    $url = "https://$env:gitServer/api/v4/namespaces"

    $headers = @{ 
        'Content-Type'  = 'application/json';
        'PRIVATE-TOKEN' = $env:GITLAB_TOKEN
    }
    $response = Invoke-RestMethod $url -Method Get -Headers $headers
    $response
}
function Get-GitlabNamespaceByName {
    <#
        .Synopsis
        Returns json with details for a specific namespace
    #>
    param (
        $Name
    )
    $url = "https://$env:gitServer/api/v4/namespaces?search=$Name"

    $headers = @{ 
        'Content-Type'  = 'application/json';
        'PRIVATE-TOKEN' = $env:GITLAB_TOKEN
    }
    $response = Invoke-RestMethod $url -Method Get -Headers $headers
    $response
}

function Add-GitlabProjectMembers {
    <#
        .Synopsis
        Adds specified users (by id) to a specified project (by id) with corresponding
        user access.
    #>
    param (
        $projectId,
        $userId,
        $accessLevel 
    )

    $url = "https://$env:gitServer/api/v4/projects/$projectId/members"

    $headers = @{ 
        'Content-Type'  = 'application/json';
        'PRIVATE-TOKEN' = $env:GITLAB_TOKEN
    }
    
    $body = @{
        "user_id"      = $userId
        "access_level" = $accessLevel 
    } | ConvertTo-Json

    $response = Invoke-RestMethod $url -Method Post -Body $body -Headers $headers
    $response
}

function Add-GitlabGroupMembers {
    <#
        .Synopsis
        Adds users to a group. A group can have access to multiple projects,
        so be careful with permissions.
    #>
    param (
        $groupId,
        $userId,
        $accessLevel 
    )

    $url = "https://$env:gitServer/api/v4/groups/$groupId/members"

    $headers = @{ 
        'Content-Type'  = 'application/json'
        'PRIVATE-TOKEN' = $env:GITLAB_TOKEN
    }
    
    $body = @{
        "user_id"      = $userId
        "access_level" = $accessLevel 
    } | ConvertTo-Json

    $response = Invoke-RestMethod $url -Method Post -Body $body -Headers $headers
    $response
}

function Update-GitlabGroupMemberAccess {
    <#
        .Synopsis
        Updates access level for a user in a specified group.
    #>

    param (
        $groupId,
        $userId,
        $accessLevel 
    )

    $url = "https://$env:gitServer/api/v4/groups/$groupId/members/$userId"

    $headers = @{ 
        'Content-Type'  = 'application/json'
        'PRIVATE-TOKEN' = $env:GITLAB_TOKEN
    }
    
    $body = @{
        "access_level" = $accessLevel 
    } | ConvertTo-Json

    $response = Invoke-RestMethod $url -Method Put -Body $body -Headers $headers
    $response
}


function New-GitlabProject {
    <#
        .Synopsis
        Creates a new Gitlab Project
    #>
    param (
        $Name,
        $NamespaceId
    )
    $url = "https://$env:gitServer/api/v4/projects"

    $headers = @{ 
        'Content-Type'  = 'application/json'
        'PRIVATE-TOKEN' = $env:GITLAB_TOKEN
    }

    $body = @{
        "path"         = $Name
        "namespace_id" = $NamespaceId
    } | ConvertTo-Json

    $response = Invoke-RestMethod $url -Method Post -Body $body -Headers $headers
    $response
}
