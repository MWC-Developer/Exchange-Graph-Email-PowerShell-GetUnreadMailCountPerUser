#PowerShell-Graph-GetUnreadMailCountPerUser.PS1

function Get-UnreadMailReport { 
    $users = Get-MgUser -All | Select-Object Id, UserPrincipalName
    $UnreadReport = @()
    foreach ($user in $users) {
        try {
              $unreadMessages = Get-MgUserMessage -UserId $user.UserPrincipalName -Filter "isRead eq false" -All
              $UnreadReport += [PSCustomObject]@{
                  UserPrincipalName = $user.UserPrincipalName
                  UnreadEmailCount =  $unreadMessages.Count
            }
        }
        catch {
            Write-Host "Erro reading count for $($user.UserPrincipalName): $_.Exception.Message"  
        }
    }
    return $UnreadReport
}

# TODO: Create an app registration in Azure. Add App flow permissions for Grant Mail.Read and User.Read. Add a client secret.  A redirect is not needed.

# Do Auth.   
$tenantId = "TODO: Set Tenant ID"
$appId = "TODO: Set Application/Client ID"
$clientSecretCredential = "TODO: Set Client Secret"

$secureClientSecret = ConvertTo-SecureString -String $clientSecretCredential -AsPlainText -Force
$clientSecretCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $appId,$secureClientSecret

#Disconnect-MgGraph
Connect-MgGraph -TenantId $tenantId -ClientSecretCredential $clientSecretCredential -Verbose 
#Get-mgcontext 


$UnreadReport = Get-UnreadMailReport 
$UnreadReport | Format-Table
