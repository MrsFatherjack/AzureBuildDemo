function Get-Tables
{
    param(
    $Database, # = "Management",
    $ServerName # = "babydell\monza"
    
    )

    Process
    {

 
        $SQL ="exec Build.Get_TableNames"

        $Table = Invoke-Sqlcmd -ServerInstance $ServerName -Database $Database -Query $SQL
        
        foreach ($Row in $Table)
                {
                    write-output $Row.Item("TableName");
                }

    }
}

