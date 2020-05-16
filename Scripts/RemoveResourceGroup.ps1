AZresourcegroup-azurermresourcegroup -name "BuildDemo"
remove-AZresourcegroup -name "Training"

remove-AZresourcegroup -name "EUSLive"
remove-AZresourcegroup -name "EUSTest"
remove-AZresourcegroup -name "E_US_TST"
remove-AZresourcegroup -name "E_US_Tst"

remove-AZresourcegroup -name "EastUSTST"
remove-AZresourcegroup -name "AustraliaEastLive"



Get-AzureRmLocation |Format-Table