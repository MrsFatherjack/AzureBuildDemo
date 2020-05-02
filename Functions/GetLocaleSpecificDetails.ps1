function Get-LocaleSpecificDetails {
    param (
        $SourceServer,
        $SourceDatabase,
        $LocaleID
    )

    $Query = "Select LocaleName, AzureRegion,  username, subscriptionID, Tier,TenantID,  IsLive from Build.Locale 
    where LocaleID = $LocaleID"
    write-output $Query
    $QueryResults = Invoke-Sqlcmd -ServerInstance $SourceServer -Database $SourceDatabase -Query $Query
    $QueryResults
}

