Function Build-AzureDatabase { #1
#[CmdletBinding()]
PARAM(
$LocaleID,# = 1,
$SourceDirectory,# = "c:\gitdemo\azurebuilddemo\",
$SourceServer,# = "babydell\monza",
$SourceDatabase,
$Database,
$Directory # Where passwords are stored
)

    try { #2
        
        Write-Verbose "Starting Build Process"
        [cmdletbinding()]
        <#
        $LocaleID = 5
        $SourceDirectory = "c:\github\azurebuilddemo\"
        $SourceServer = "babydell\monza"
        $SourceDatabase = "HUB"
        $Database = "MySports"
        $Directory = "C:\Azure\Passwords\"

        #>

        ###################### load all required functionsl #########################################

        $Functions = $SourceDirectory + "\functions\*.ps1"
        Get-ChildItem $Functions | %{.$_} | Out-GridView

        ###################### Get project specific details #########################################

        write-verbose "Getting project specific details"
       
        $Svr = Get-LocaleSpecificDetails -SourceServer $SourceServer -SourceDatabase $SourceDatabase  -LocaleID $LocaleID
        $Username = $svr.UserName
        $AzureRegion = $svr.AzureRegion
        $LocaleName = $Svr.LocaleName
        $SubscriptionID = $Svr.subscriptionID
        $TenantID = $Svr.TenantID
        $Tier = $Svr.Tier
        $Database = $database.ToLower()

        $AbrName = $LocaleName.replace(' ','')
        $ServerName = "$abrname" + "Server"
        $FullServerName = $ServerName + '.database.windows.net'
        $AdminUser =  "AdminUser"
        $Servername = $Servername.ToLower()
        $AzureServerName = "tcp:" + $Fullservername + ",1433"
        $ResourceGroupName = $AbrName
       
 
        #For demo purposes only 
        $SubscriptionID = get-content C:\azure\adminSubscriptionID.txt
        $TenantID = get-content C:\azure\adminTenantID.txt

        $PasswordUser = get-content c:\azure\passworduser.txt
        $PortalUser = get-content c:\azure\portaluser.txt

        ###################### get user password #########################################
        # Admin User credentials used for SQL Server
        $AdminPassword = get-securepassword -Username $AdminUser -Directory $Directory
        $AdminUserPassword = convertto-securestring -string $AdminPassword -AsPlainText -Force
        $AdminUserCredential = New-Object -TypeName system.management.automation.pscredential -ArgumentList $Adminuser, $AdminUserPassword


        $PortalPassword = get-securepassword -Username $PasswordUser -Directory $Directory
        $PortalUserPassword = convertto-securestring -string $PortalPassword -AsPlainText -Force
        $PortalCredential = New-Object -TypeName system.management.automation.pscredential -ArgumentList $PortalUser, $PortalUserPassword


        ###################### connect and login to portal #########################################

        Write-Verbose "Connecting to Azure Account"
        Check-AzureLogin -TenantID $TenantID -SubscriptionID $SubscriptionID -Credential $PortalCredential

        ########  Create a new resource group if it doesn't exist
        #$NotPresent = get-azurermresourcegroup -name $ResourceGroupName -erroraction silentlycontinue
        $NotPresent = get-AZResourceGroup -name $ResourceGroupName -erroraction silentlycontinue
        if (! $NotPresent) { #6
        write-verbose "Creating ResourceGroup"
            new-AZResourceGroup -name $ResourceGroupName -location $AzureRegion 
        } #6
        
        ########  Get the IP details to apply to the new server   ########
        $IPAddress = Test-Connection -ComputerName $env:computername -count 1 | Select-Object ipv4address
        $IPAdd = $IPAddress.IPV4Address.ToString()
        $IPQuery = "EXECUTE sp_set_database_firewall_rule N'Allow Azure', '$IPAdd', '$IPAdd'";
            
        $startip = $IPAdd
        $endip = $startip

        ########  Create a new server if it doesn't exist     ########
            $sql = Get-AZResource -ResourceName $ServerName -ResourceGroupName $ResourceGroupName
            write-output $SQL
            if (! $sql) { #7
                    write-verbose "Creating server"
                    New-AZSQLServer -Location $AzureRegion -ServerName $ServerName -SqlAdministratorCredentials $AdminUserCredential -ResourceGroupName $ResourceGroupName -ServerVersion "12.0"
                    New-AZSqlServerFirewallRule -ResourceGroupName $ResourceGroupName -ServerName $ServerName -FirewallRuleName "AllowedIPs" -StartIpAddress $startip -EndIpAddress $endip
                    New-AZSqlServerFirewallRule -ServerName $ServerName -ResourceGroupName $ResourceGroupName -name "AllowAllWindowsAzureIps" -StartIpAddress "0.0.0.0" -EndIpAddress "0.0.0.0"
                    New-AZSqlServerFirewallRule -ServerName $ServerName -ResourceGroupName $ResourceGroupName -name "RandomIPForSync" -StartIpAddress "185.130.158.160" -EndIpAddress "185.130.158.160"

                }
                
                Write-Verbose "Setting IP Range"
                Invoke-Sqlcmd -ServerInstance $AzureServerName -Database "Master" -Query $IPQuery -Username $AdminUser -Password $AdminPassword

            ###################### Build databases #########################################
            #write-output "Resource Group Name: $ResourceGroupName Server Name: $ServerName, Database: $Database"
            $DBExists = Get-AZSqldatabase -ServerName $Servername -ResourceGroupName $ResourceGroupname -DatabaseName $Database  -ErrorAction SilentlyContinue
            if (! $DBExists) { #10
                    New-AZSqlDatabase -ResourceGroupName $resourcegroupname -ServerName $Servername -DatabaseName $Database -RequestedServiceObjectiveName  $Tier #-ErrorAction SilentlyContinue
                    write-Verbose "Built $Database"
            } #10

            ################# Sync database schema #################

            $SourceControlRepo = "$sourcedirectory\$Database"

            $TestDB = New-DlmDatabaseConnection -ServerInstance $FullServerName -Database $Database -Username $adminuser -Password "$AdminPassword"
             $Tested = Test-DlmDatabaseConnection $TestDB 
           if ($Tested) {
                    Sync-DlmDatabaseSchema -source $SourceControlRepo -Target $TestDB -IgnoreStaticData -SQLCompareOptions "-ignoreTSQLT" 
            }

    } #2


    catch { #18

    Write-Error -Exception $_.Exception
    #exit 1

    } #18


} #1