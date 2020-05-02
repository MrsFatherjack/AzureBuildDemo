remove-azurermresourcegroup -name "BuildDemo"
remove-azurermresourcegroup -name "Training"

remove-azurermresourcegroup -name "EUSLive"
remove-azurermresourcegroup -name "EUSTest"
remove-azurermresourcegroup -name "E_US_TST"
remove-azurermresourcegroup -name "E_US_Tst"

remove-azurermresourcegroup -name "EastUSTST"
remove-azurermresourcegroup -name "AustraliaEastLive"



Get-AzureRmLocation |Format-Table