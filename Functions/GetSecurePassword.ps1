function Get-SecurePassword {
param(
$Username, # = "Adminuser",
$Directory# = "C:\GitDemo\AzureBuildDemo"

)

###################### get user password #########################################


$KeyFile = Join-Path $Directory  "$Username.key"
$PasswordFile = Join-Path $Directory "$Username.txt"

# Read the secure password from a password file and decrypt it to a normal readable string
$SecurePassword = ( (Get-Content $PasswordFile) | ConvertTo-SecureString -Key (Get-Content $KeyFile) )        # Convert the standard encrypted password stored in the password file to a secure string using the AES key file
$SecurePasswordInMemory = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword);             # Write the secure password to unmanaged memory (specifically to a binary or basic string) 
$PasswordAsString = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($SecurePasswordInMemory);              # Read the plain-text password from memory and store it in a variable
[Runtime.InteropServices.Marshal]::ZeroFreeBSTR($SecurePasswordInMemory);          

$DBPassword = $PasswordAsString

return $DBPassword

}
