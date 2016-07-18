function Test-RestoreSpace
{
 <#
  .SYNOPSIS
    Given a set of files to restore, check there's enough space on the target system
  .DESCRIPTION
    GO through set of SQL Server backup files and calculate the maximum space needed to perform the requested restore, and then check that the specified server has the requisite space to perform the restore
  .EXAMPLE
    Test-RestorSpace -RestorePath 'c:\data1\' -RestoreSQLServer $sqlsvr -BackupObject $BackupsObject
  .PARAMETER BackupsObject
    A list of SQL backups, as provided by Get-RestoreSet
  .PARAMETER RestoreSQLServer
    SMO SQL Server connection object
  .PARAMETER RestorePath
    Path to which the backups will be restored.

  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$True)]
    [object]$BackupsObject,
    [Parameter(Mandatory=$True)]
    [Microsoft.SQLServer.Management.Smo.Server]$RestoreSQLServer,
    [Parameter(Mandatory=$True)]
    [string]$RestorePath
  )
   Write-Verbose "Test-RestoreSpace - Entering " 
      if ($destination.substring($Destination.length-1,1) -ne '\'){
        $Destination = $Destination+'\'
    }
  
  $disk2 = Get-WmiObject Win32_Volume -ComputerName $RestoreSQLServer.NetName -Filter "name='$($destination.replace('\','\\'))'" 
  if(($BackupsObject | measure-object -Property totalsize -Maximum).Maximum -gt $disk2.FreeSpace){
    Write-debug "Not enough space!"
    $FALSE
  }else{
    $TRUE
  }
   Write-Verbose "Test-RestoreSpace - Leaving " 
}