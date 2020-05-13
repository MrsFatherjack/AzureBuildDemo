#[cmdletbinding()]
# These are the parameters that need to be passed in

<#
Install-Module -Name AzureRM -AllowClobber 
#>
param(
    $EnvironmentID = 1, # the Project ID you want to be
    $SourceDirectory = "c:\gitdemo\azurebuilddemo", #Your local Repo
    $SourceDataProjectID = 1, #Copies data from test - if the project has data set to 0
    $SourceDatabase = "demo",
    $SourceServer = "babydell\monza", 
    $DoubleCheck = "",
    $Database = "Demo"
)
# Everything from here on is created for you
cls

#try {
    ###################### load all required functionsl #########################################
    $Functions = $SourceDirectory + "\functions\*.ps1"
    Get-ChildItem $Functions | %{.$_} | Out-GridView

   

    write-output "Source Server: $SourceServer, SourceDatabase $SourceDatabase EnvID: $EnvironmentID"


    ###################### Get data stored in the database pertaining to this project #########################################
    write-output "Getting project specific details"

    $Svr = Get-EnvironmentSpecificDetails -SourceServer "$SourceServer" -SourceDatabase "$SourceDatabase" -EnvironmentID $EnvironmentID
    $Username = $svr.UserName
    $Subscription = $Svr.Subscription
    $ResourceGroupName = $svr.ResourceGroupName
    $AzureRegion = $svr.AzureRegion
    $FullServerName = $Svr.fullservername
    $ServerName = $Svr.ServerName
    $SubscriptionID = $Svr.subscriptionID
    $Tier = $Svr.Tier
    $AppInsightsLocation = $Svr.AppInsightsRegion
    $SupportUserName = $Svr.SupportUserName
    $AbbreviatedName = $Svr.AbbreviatedName
    $ProjectUri = $Svr.ProjectUri
    $Location = $AzureRegion
    $IsLive = $Svr.IsLive
    $TenantID = $svr.TenantID
                
    write-host "UserName: $UserName, ServerName: $ServerName, AbbreviatedName: $AbbreviatedName"

    $Directory = $SourceDirectory + "\passwords\"
    $azureAccountName = 'annetteallen69@gmail.com'
    $AdminPasswordFile = Join-Path $Directory "$username.txt"
    $AdminKeyFile = join-path $Directory "$username.key"
    $CopiedData = $CopiedFromTest
     
    $DBPassword = get-securepassword -Username $Username -SourceDirectory $SourceDirectory
    $Password = convertto-securestring -string $DBPassword -AsPlainText -Force
    $Credential = New-Object -TypeName system.management.automation.pscredential -ArgumentList $Username, $Password
    $AdminPassword = $Password
    $AdminPassword = convertto-securestring -string $AdminPassword -AsPlainText -Force
    $AdminCredential = New-Object -TypeName system.management.automation.pscredential -ArgumentList $azureAccountName, $AdminPassword

    write-verbose "UserName: $UserName, ServerName: $ServerName"

    $LowerAbbreviatedName = $AbbreviatedName.ToLower()
    #$AppservicePlanName = "WebAppServicePlan_$AbbreviatedName" 
    #$WebAppName = "WebApp-$AbbreviatedName" 
    #$AppInsightsName = "AppInsights_$AbbreviatedName" 
    #$KeyVaultName ="KeyVault-$AbbreviatedName" 
    #$KeyVaultKeyName = "ProtectSecretKey"
    #$StorageAccountName = "storageacc$LowerAbbreviatedName" 
    #$JobCollectionName = "DeletePartialRegistrations"

    ###########################################################
    # Prompt to check building the right environment
     if ($DoubleCheck -ne 0) {    
         $no = New-Object System.Management.Automation.Host.ChoiceDescription '&No', 'It is not the right environment and will cancel the build'
         $yes = New-Object System.Management.Automation.Host.ChoiceDescription '&Yes', 'It is the right environment'
         $options = [System.Management.Automation.Host.ChoiceDescription[]]($no, $yes)
         $result = $host.ui.PromptForChoice('Environment Check', "You are building the $AbbreviatedName environment, is this expected?", $options, 1)
         write-host "Result is: $result"
                if ($Result -eq 0) {
                 $Exception = "You have cancelled this build as not the correct environment." 
                 write-host $Exception
                 throw $Exception
                  }
    }

    ############################################################################################################
    # Read the secure password from a password file and decrypt it to a normal readable string
   
    $AdminSecurePassword = ( (Get-Content $AdminPasswordFile) | ConvertTo-SecureString -Key (Get-Content $AdminKeyFile) )        # Convert the standard encrypted password stored in the password file to a secure string using the AES key file
    $AdminSecurePasswordInMemory = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($AdminSecurePassword);             # Write the secure password to unmanaged memory (specifically to a binary or basic string) 
    $AdminPasswordAsString = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($AdminSecurePasswordInMemory);              # Read the plain-text password from memory and store it in a variable
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($AdminSecurePasswordInMemory); 

    $AzurePassword = $AdminPasswordAsString | ConvertTo-SecureString -AsPlainText -Force

    $psCred = New-Object System.Management.Automation.PSCredential($Username, $AzurePassword)

    Login-AzureRmAccount -Credential $psCred -Subscription $SubscriptionID -TenantId $TenantID
    Connect-AzureRmAccount -Credential $pscred -Subscription $Subscriptionid -TenantId $TenantID
    
    #Connect-AzureAccount -SourceDirectory $SourceDirectory -Subscription $SubscriptionID

    $DBPassword = get-securepassword -Username $Username -SourceDirectory $SourceDirectory
    $Password = convertto-securestring -string $DBPassword -AsPlainText -Force
    $Credential = New-Object -TypeName system.management.automation.pscredential -ArgumentList $Username, $Password

    write-verbose "$SubscriptionID SubscriptionID"

    ############################################################################################################
    
    <#
    write-host "supportusername encrypted password"

    $Directory = $SourceDirectory + "\scripts\passwords"
    $KeyFile = Join-Path $Directory  "$SupportUserName.key"
    $PasswordFile = Join-Path $Directory "$SupportUserName.txt"

    # Read the secure password from a password file and decrypt it to a normal readable string
    $SecurePassword = ( (Get-Content $PasswordFile) | ConvertTo-SecureString -Key (Get-Content $KeyFile) )        # Convert the standard encrypted password stored in the password file to a secure string using the AES key file
    $SecurePasswordInMemory = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword);             # Write the secure password to unmanaged memory (specifically to a binary or basic string) 
    $PasswordAsString = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($SecurePasswordInMemory);              # Read the plain-text password from memory and store it in a variable
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($SecurePasswordInMemory);          
    $supportPassword = $PasswordAsString
    #>
    ##########################################################################################################  
    if([string]::IsNullOrEmpty($SubscriptionID)){
        Write-Verbose "Subscription does not exist and must be created before running this script"
        return
    }
  
    ##########################################################################################################
    write-host "Resource Group"
    
    Get-AzureRmResourceGroup -Name $ResourceGroupName -ErrorVariable notPresent -ErrorAction SilentlyContinue
    if ($notPresent)    {
        new-azurermresourcegroup -name $ResourceGroupName -location $Location
    }

    ##########################################################################################################
    write-host "Database build  and populate"

    Build-RegionalDatabases -EnvironmentID $EnvironmentID -SourceDirectory $SourceDirectory -SourceServer $SourceServer -SourceDatabase $SourceDatabase -Database $Database

    ##########################################################################################################
    function GetResource($resourceName){
        return Get-AzureRmResource -ResourceName $resourceName -ResourceGroupName $ResourceGroupName

    }
<#

 
catch
{
    Write-Error -Exception $_.Exception
}

#>