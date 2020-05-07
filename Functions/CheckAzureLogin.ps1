
function Check-AzureLogin
{    param(
    $TenantID,
    $SubscriptionID
    )
    $needLogin = $true
    Try 
    {
        $content = Get-AzContext
        if ($content) 
        {
            $needLogin = ([string]::IsNullOrEmpty($content.Account))
        } 
    } 
    Catch 
    {
        if ($_ -like "*Login-AZAccount to login*") 
        {
            $needLogin = $true
        } 
        else 
        {
            throw
        }
    }

    if ($needLogin)
    {
        #Login-AzureRmAccount -TenantId $TenantID -Subscription $SubscriptionID
        Connect-AzureRmAccount -TenantId $TenantID -Subscription $SubscriptionID
    }
}