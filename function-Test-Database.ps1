function Test-Database
{
 <#
  .SYNOPSIS
    Run a DBCC check
  .DESCRIPTION
    Run a DBCC CHECKDB against a specified database on a specified SQL Server instance. 

    If all is OK, returns True, or returns messages if set to Verbose
    Returns False and all errors if there's a problem
  .EXAMPLE
    Test-Database -RestoreSQLServer $sqlsvr -DatabaseName 'ExampleDB'
  .PARAMETER RestoreSQLSever
    An SMO SQL Server Connection object
  .PARAMETER DatabaseName
    Name of database to be tested, as String.

  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$True)]
    [string]$DatabaseName,
    [Parameter(Mandatory=$True)]
    [Microsoft.SQLServer.Management.Smo.Server]$RestoreSQLServer
  )
  Write-Verbose "Test-Database - Entering " 
  $results = @()
  $errorout = ''
  $err = 0
  try
  {
    $results = Invoke-SQLCmd -ServerInstance $sqlsvr.Name -Query "DBCC CHECKDB ($DatabaseName) with TABLERESULTS" -ErrorAction Stop -QueryTimeout 0
  }
  catch  
    {
        $errorout = $_
        $err=1
    }
  finally
    {
        if ($err -eq 0){
            $results | out-string -Stream | Write-Verbose
            $errorout | out-string -Stream | Write-Verbose
            $True
        }else{
            $results | out-string -Stream
            $errorout | out-string -Stream
            $False
        }
         Write-Verbose "Test-Database - Leaving " 
    }
}