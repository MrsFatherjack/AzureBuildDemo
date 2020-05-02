


Function Populate-SetupData {
#[CmdletBinding()]
Param(
$LocaleID,
$SourceServer,
$SourceDatabase,
$DestServer,
$SourceDirectory,
$DestDB,
$SourceDataLocaleID,
$Directory
)

try {

    <#

    $LocaleID = 2
    $SourceServer = "babydell\monza"
    $SourceDatabase = "hub"
    $SourceDirectory = "C:\GitDemo\azurebuilddemo\"
    $DestDB = "MySports"
    $SourceDataLocaleID = 5
    $Directory = "c:\azure\passwords\"
    #>

    if ($SourceDataLocaleID -ne 0) {
        $SourceLocaleID = $SourceDataLocaleID}

    ###################### Load required functions #########################################

    $FunctionDir="$SourceDirectory\functions\"
    Get-ChildItem "${FunctionDir}\*.ps1" | %{.$_} | Out-GridView


    ###################### Get Locale specific information #########################################
    $Svr = Get-LocaleSpecificDetails -SourceServer $SourceServer -SourceDatabase $SourceDatabase -SourceDirectory $SourceDirectory -LocaleID $LocaleID 

    $LocaleName = $Svr.LocaleName
    $AbrName = $LocaleName.replace(' ','')
    $SubscriptionID = $Svr.subscriptionID
    $TenantID = $Svr.TenantID
    $ServerName = "$abrname" + "Server"
    $FullServerName = $ServerName + '.database.windows.net'
    $AdminUser =  "AdminUser"
    $Servername = $Servername.ToLower()
    $AzureServerName = "tcp:" + $Fullservername + ",1433"

    ###################### get credential information #########################################

    $DBPassword = get-securepassword -username "Adminuser" -Directory $Directory
    $Password = convertto-securestring -string $DBPassword -AsPlainText -Force
    $Credential = New-Object -TypeName system.management.automation.pscredential -ArgumentList $adminuser, $Password

    $PasswordUser = get-content c:\azure\passworduser.txt
    $PortalUser = get-content c:\azure\portaluser.txt

    $PortalPassword = get-securepassword -Username $PasswordUser -Directory $Directory
    $PortalUserPassword = convertto-securestring -string $PortalPassword -AsPlainText -Force
    $PortalCredential = New-Object -TypeName system.management.automation.pscredential -ArgumentList $PortalUser, $PortalUserPassword


    ###################### connect and login to portal #########################################
    #$SourceDir = "$SourceDirectory\"
    Check-AzureLogin -TenantID $TenantID -SubscriptionID $SubscriptionID -credential $PortalCredential

    ###################### Get current IP Address #########################################
    $IPAddress = Test-Connection -ComputerName $env:computername -count 1 | Select-Object ipv4address
    $IPAdd = $IPAddress.IPV4Address.ToString()
    $IPQuery = "EXECUTE sp_set_database_firewall_rule N'Allow Azure', '$IPAdd', '$IPAdd'";
    Invoke-Sqlcmd -ServerInstance $AzureServerName -Database "Master" -Query $IPQuery -username $adminuser -Password $DBPassword

    #####  Creates the connection to the source database ready to get the data 
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = "Server=$SourceServer;Database=$SourceDatabase; integrated security = true;"
    $connection.Open()

    ##### Loops through all the tables to get the list of what's required
    $TableList = get-tables -Database $SourceDatabase -ServerName $SourceServer 

    foreach ($Table in $TableList){

        $TableCaps = $table.ToUpper()

        # sets the name of the stored procedure required to get the table data
        $Proc = $TableCaps.replace("BUILD.","Build.Get_Build_")
        $Proc = $Proc + " @LocaleID = '$SourceLocaleID'"

        # Gets the table data and stores ready for transfer
        $sqlcommand = New-Object System.Data.SqlClient.SqlCommand($Proc,$connection)
        $adapter = New-Object System.Data.SqlClient.SqlDataAdapter $sqlcommand
        $DataSet = New-Object System.Data.DataSet
        $adapter.Fill($DataSet) | out-null
        $Result =$DataSet.Tables[0]  

        # Not needed but a nice bit of sense checking
        $Count = $Result.Rows.Count
        write-output "Number of rows in table $Table is $Count"

          # Gets just the table name ready for us to create it in the Copied schema
          $BuildTable = $TableCaps.Replace("BUILD.","")

        # Drops the copied table if it already exists in case the schema has changed.
        $DropQuery = "
        IF EXISTS (
        SELECT 1 FROM sys.tables t
        INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
        wHERE t.name = '$BuildTable'
        AND s.name = 'Copied')
        BEGIN
        drop table Copied.$BuildTable
        end"

        Invoke-Sqlcmd -ServerInstance $AzureServerName -Database $DestDB -Query $DropQuery -UserName $AdminUser -Password $DBPassword

        # Create and populate the copied table
        # Gets just the table name ready for us to create it in the Copied schema
        Write-SqlTableData -DatabaseName $DestDB -schema "Copied" -TableName $BuildTable -Force -InputData $Result -ServerInstance $AzureServerName -Credential $Credential


        # Takes the data from the copied table and compares to the destination table so that it only
        # Inserts new rows and updates changes to rows
        # Rows that have been deleted from source are not deleted from the destination
        $UpdateQuery = "
        declare @TableName varchar(100) = '$BuildTable'
        declare @Columns nvarchar(4000)
        declare @DropCopiedTable nvarchar(4000)
        declare @PreCount table (Precount int)
        declare @PostCount table (PostCount int)
        declare @PreCountQuery nvarchar(1000)
        declare @PostCountQuery nvarchar(1000)
        declare @ColumnInsert nvarchar(1000)
        declare @Pre int
        declare @Post int
        declare @IDColumns varchar(200) = ''
        declare @Where varchar(4000)
        declare @WhereCount int
        declare @first bit = 1
        declare @Join nvarchar(1000)
        declare @DataIssues nvarchar(4000)
        Declare @Error bit
        declare @UpdateWhereColumns nvarchar(4000) = ''
        declare @UpdateColumns nvarchar(4000) = ''
        declare @Update nvarchar(4000)
        declare @FirstUpdate bit = 1


        IF OBJECT_ID('tempdb..#Hold') IS NOT NULL
        Begin
        DROP TABLE #Hold
        end

        IF OBJECT_ID('tempdb..#Update') IS NOT NULL
        Begin
        DROP TABLE #Update
        end

        /***************************************************************************
        Disable constraints
        ****************************************************************************/
        /***************************************************************************
        Gets all the columns from the copied table 
        ****************************************************************************/
        select @Columns = coalesce(@Columns + ',', '') +  convert(varchar(1000),c.name)
        from sys.tables t
        inner join sys.columns c on c.object_id = t.object_id
        inner join sys.schemas s on s.schema_id = t.schema_id
        where (s.name  = 'Copied' and t.name = @Tablename )
        and c.name not in ('validfrom','validto')

        /***************************************************************************
        Gets all the required code for the Inserts where the row is missing
        in the destination
        ****************************************************************************/

        /***************************************************************************
        Get's the primary keys to join on 
        ****************************************************************************/
        select column_name
        into #Hold
        FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
        WHERE OBJECTPROPERTY(OBJECT_ID(CONSTRAINT_SCHEMA + '.' + QUOTENAME(CONSTRAINT_NAME)), 'IsPrimaryKey') = 1
        AND TABLE_NAME = @TableName AND TABLE_SCHEMA = 'build'

        set @WhereCount = (select count(*) from #Hold)

        /***************************************************************************
        If there is no primary keys just join on the first column
        ****************************************************************************/
        if not exists (select 1 from #Hold)
        begin
        set @Join = (select top 1 c.name from sys.tables t
        inner join sys.columns c on c.object_id = t.object_id
        inner join sys.schemas s on s.schema_id = t.schema_id
        where (s.name  = 'Copied' and t.name = @Tablename )
        and c.name not in ('validfrom','validto')) 

        set @IDColumns =  'a.' + @Join + ' = b.' + @Join

        set @Where = ' where b.' + @Join + ' is null'
        end


        /***************************************************************************
        Use a cursor (yuck) to loop through and build the primary key columns
        ****************************************************************************/

        declare JoinCursor cursor for
        select column_name from #Hold

        open JoinCursor  
        fetch next from JoinCursor into @Join

        while @@fetch_status = 0
        begin

        if @first = 0
        begin
        set @IDColumns = @IDColumns + ' and a.' + @Join + ' = b.' + @Join
        set @Where = ' where b.' + @Join + ' is null'

        end

        if @first = 1
        begin
        set @IDColumns = 'a.' + @Join + ' = b.' + @Join
        set @Where = ' where b.' + @Join + ' is null'
        set @first = 0
        end

        fetch next from JoinCursor into @Join

        end
        close JoinCursor
        deallocate JoinCursor

        /***************************************************************************
        The insert script to populate the build table
        ****************************************************************************/
        set @ColumnInsert = 'Insert into build.' + @TableName + ' (' + @Columns + ')'
        set @ColumnInsert = @ColumnInsert + ' select distinct a.' + replace(@Columns,',',',a.') + ' from Copied.' + @TableName + ' a left outer join build.' + 
        @TableName + ' b on ' + isnull(@IDColumns,'') + isnull(@Where,'')


        --select @ColumnInsert as FullInsertScript
        exec sp_executesql @ColumnInsert

        /***************************************************************************
        Gets the code to do an update where the data exists but is different
        ****************************************************************************/
        /***************************************************************************
        Get the columns for the update where clause
        ****************************************************************************/

        select c.name as UpdateName
        into #Update
        from sys.tables t
        inner join sys.columns c on c.object_id = t.object_id
        inner join sys.schemas s on s.schema_id = t.schema_id
        where (s.name  = 'Copied' and t.name = @Tablename )
        and c.name not in ('validfrom','validto')

        delete from #Update where UpdateName in (select COLUMN_NAME from #Hold)

        /***************************************************************************
        Use a cursor (yuck) to loop through and build the Where clause
        ****************************************************************************/

        declare UpdateWhereCursor cursor for
        select Updatename from #Update

        open UpdateWhereCursor  
        fetch next from UpdateWhereCursor into @Update

        while @@fetch_status = 0
        begin


        if @firstUpdate = 0
        begin
        set @UpdateWhereColumns = @UpdateWhereColumns + ' or (a.' + @Update + ' != b.' + @Update + ' or b.' +  @update +' is null) '
        set @UpdateColumns = @UpdateColumns + ', ' + @Update + ' = a.' + @Update

        end

        if @firstUpdate = 1
        begin
        set @UpdateWhereColumns = @UpdateWhereColumns + ' where (a.' + @Update + ' != b .' + @Update + ' or b.' +  @update +' is null) '
        set @UpdateColumns = @UpdateColumns + ' set ' + @Update + ' = a.' + @Update 
        set @firstUpdate = 0
        end

        --	select @UpdateWhereColumns UpdateWhereColumns, @UpdateColumns UpdateColumns

        fetch next from UpdateWhereCursor into @Update

        end
        close UpdateWhereCursor
        deallocate UpdateWhereCursor

        --select @UpdateColumns


        /***************************************************************************
        Finish the update script and execute
        ****************************************************************************/
        set @UpdateColumns = 'update build.' + @TableName + @UpdateColumns +  + ' from Copied.' + @TableName + ' a inner join build.' + 
        @TableName + ' b on ' + isnull(@IDColumns,'') + @UpdateWhereColumns

        exec sp_executesql @UpdateColumns

        --	select @UpdateColumns as FullUpdateScript

        /***************************************************************************
        Validata data matches before deleting
        Although need to consider how this works when data is deleted from source
        and not the destination
        ****************************************************************************/
        declare @PreQuery nvarchar(max) = 'select distinct * into #Hold from copied.' + @TableName
        exec sp_executesql @PreQuery

        set @PreCountQuery = 'select count(*) from #Hold'
        set @PostCountQuery = 'select count(*) from build.' + @TableName

        insert into @PreCount
        (
        Precount
        )
        exec sp_executesql @PreCountQuery

        INSERT INTO @PostCount
        (
        PostCount
        )

        exec sp_executesql @PostCountQuery

        set @DropCopiedTable = 'drop table Copied.' + @TableName
        exec sp_executesql @DropCopiedTable

        Drop schema copied


        declare @EnableQuery nvarchar(4000) = 'alter table build.' + @TableName + ' with check check constraint all'
        execute sp_executesql @EnableQuery

        select isnull(@Error,0) as error, @DataIssues as DataIssues  

        "

        
        # Run the Update script
        Invoke-Sqlcmd -ServerInstance $AzureServerName -Database $DestDB -Query $UpdateQuery -username $Adminuser -Password $DBPassword


        $connection.Close()
    }

}

catch {

Write-Error -Exception $_.Exception


}



}
