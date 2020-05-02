function Get-EnvironmentSpecificDetails {
    param (
        $SourceServer,
        $SourceDatabase,
        $EnvironmentID
    )

    $Query = "Select LocaleName, AzureRegion,  username, subscriptionID, Tier,TenantID,  AbbreviatedName, IsLive from Build.Locale 
    where Environmentid = $EnvironmentID"
    write-output $Query
    $QueryResults = Invoke-Sqlcmd -ServerInstance $SourceServer -Database $SourceDatabase -Query $Query
    $QueryResults
}

