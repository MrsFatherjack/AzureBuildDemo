$ServerName = "demoserver.database.windows.net"
$ResourceGroupName = "demo"


get-AzureRmResource -ResourceGroupName "demo" -ResourceType resourcegroup


import-module -name az

uninstall-azurerm