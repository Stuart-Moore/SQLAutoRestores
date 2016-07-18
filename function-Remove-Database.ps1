function Remove-Database
{
 <#
  .SYNOPSIS
    Drop a specified database on a SQL Server instance
  .DESCRIPTION
    Drops a database once it's been finished with
  .EXAMPLE
    Remove-Database -RestoreSQLServer $sqlsvr -DatabaseName 'DBToDrop'
  .PARAMETER RestoreSQLSever
    An SMO SQL Server Connection object
  .PARAMETER DatabaseName
    Name of database to be deleted, as String.

  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$True)]
    [string]$DatabaseName,
    [Parameter(Mandatory=$True)]
    [Microsoft.SQLServer.Management.Smo.Server]$RestoreSQLServer
  )
  Write-Verbose "Remove-Database - Entering " 
  $sqlsvr.Databases[$DatabaseName].Drop()
  Write-Verbose "Remove-Database - Leaving " 
}