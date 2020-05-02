        $AdminSubscriptionID = get-content C:\azure\adminSubscriptionID.txt
        $AdminTenantID = get-content C:\azure\adminTenantID.txt

        
        ###################### get user password #########################################
        # Admin User credentials used for SQL Server
        $AdminPassword = get-securepassword -Username $AdminUser -Directory $Directory
        $AdminUserPassword = convertto-securestring -string $AdminPassword -AsPlainText -Force
        $AdminUserCredential = New-Object -TypeName system.management.automation.pscredential -ArgumentList $Adminuser, $AdminUserPassword

        $Username = "admin"
                #Portal Password used for creating resources
        $KeyFile = Join-Path $Directory  "$UserName.key"
        $PasswordFile = Join-Path $Directory "$Username.txt"

        # Read the secure password from a password file and decrypt it to a normal readable string
        $SecurePassword = ( (Get-Content "$PasswordFile") | ConvertTo-SecureString -Key (Get-Content "$KeyFile") )        # Convert the standard encrypted password stored in the password file to a secure string using the AES key file
        $SecurePasswordInMemory = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword);             # Write the secure password to unmanaged memory (specifically to a binary or basic string) 
        $PasswordAsString = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($SecurePasswordInMemory);              # Read the plain-text password from memory and store it in a variable
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($SecurePasswordInMemory);          

        $PortalPassword = $PasswordAsString

        $FullUsername = "admin@annetteallen69gmailcom.onmicrosoft.com"

        $PortalPassword = get-securepassword -Username $Username -Directory $Directory
        $PortalUserPassword = convertto-securestring -string $PortalPassword -AsPlainText -Force
        $PortalCredential = New-Object -TypeName system.management.automation.pscredential -ArgumentList $FullUsername, $PortalUserPassword

#Get-AzureRmSubscription -TenantId "41d5b7d9-63d1-4082-994d-5dab27baec51"

Connect-AzureRmAccount -TenantId "41d5b7d9-63d1-4082-994d-5dab27baec51" -Credential $PortalCredential
Login-AzureRmAccount -TenantId "41d5b7d9-63d1-4082-994d-5dab27baec51" -Credential $PortalCredential
