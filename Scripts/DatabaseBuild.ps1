##########################################################################################################
write-host "Database build  and populate"

$EnvironmentID = 1
$SourceDirectory = "C:\GitDemo\AzureBuildDemo"
$SourceServer = "babydell\monza"
$SourceDatabase = "Management"
$Database = "Company"

Build-RegionalDatabases -EnvironmentID $EnvironmentID -SourceDirectory $SourceDirectory -SourceServer $SourceServer -SourceDatabase $SourceDatabase -Database $Database
