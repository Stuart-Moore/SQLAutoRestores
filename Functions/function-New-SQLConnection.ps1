function New-SQLConnection
{
  <#
  .SYNOPSIS
    get an SMO connection object
  .DESCRIPTION
    Given an Instance Name returns an SMO connection object for that SQL Server Instance
  .EXAMPLE
    New-SQLConnection -ServerInstance 'computer1\Instance2' 
  .PARAMETER ServerInstance
    SQL Server Instance to connect to
  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$True,
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True)]
    [Alias('SQLServer')]
    [String]$ServerInstance
  )
  Write-Verbose "New-SQLConnection - Entering"
  $sqlconnection = New-Object -TypeName  Microsoft.SQLServer.Management.Smo.Server($ServerInstance)
  return $sqlconnection
  Write-Verbouse "New-SQLConnection - Exiting"
}
