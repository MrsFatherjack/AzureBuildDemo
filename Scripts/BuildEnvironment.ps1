<#  Login to account if necessary
$SubscriptionID = get-content C:\azure\SubscriptionID.txt
$TenantID = get-content C:\azure\TenantID.txt

Connect-AzureRmAccount -Subscription $SubscriptionID -TenantId $TenantID
Login-AzureRmAccount -Subscription $SubscriptionID -TenantId $TenantID
add-azurermaccount -Subscription $SubscriptionID -TenantId $TenantID
#>

$Start = get-date

$LocaleID = 5
$SourceServer = "babydell\monza"
$SourceDatabase = "Hub"
$SourceDirectory = "C:\GitDemo\azurebuilddemo\"
$DestDB = "MySports"
$SourceDataLocaleID = 5
$Directory = "c:\azure\passwords\"

$Destdb = $DestDB.tolower()

$Functions = $SourceDirectory + "functions\*.ps1"
Get-ChildItem $Functions | %{.$_} | Out-GridView

cls 
Build-AzureDatabase -LocaleID $LocaleID -SourceDirectory $SourceDirectory -SourceServer $SourceServer -SourceDatabase $SourceDatabase -database $DestDB -Directory $Directory

$EndBuild = Get-Date 
$DiffBuild = new-timespan -Start $Start -End $EndBuild
Write-output "BUILD - Locale $LocaleID took $DiffBuild to run"

$StartPopulate = get-date

Populate-setupData  -LocaleID $LocaleID -SourceServer $SourceServer -SourceDatabase $SourceDatabase -SourceDirectory $SourceDirectory -DestDB $DestDB -SourceDataLocaleID $SourceDataLocaleID -directory $Directory

$End = Get-Date

$DiffPopulate = new-timespan -Start $StartPopulate -End $End

$Diff = new-timespan -Start $Start -End $End

Write-output "Total - Environment $LocaleID took $Diff to run"

Write-output "BUILD - Environment $LocaleID took $DiffBuild to run"
Write-output "POPULATE - Environment $LocaleID took $DiffPopulate to run"