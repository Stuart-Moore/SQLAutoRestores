function Test-RestoreSpace
{
 <#
  .SYNOPSIS
    Given a set of files to restore, check there's enough space on the target system
  .DESCRIPTION
    GO through set of SQL Server backup files and calculate the maximum space needed to perform the requested restore, and then check that the specified server has the requisite space to perform the restore
  .EXAMPLE
    Test-RestoreSpace -RestorePath 'c:\data1\' -RestoreSQLServer $sqlsvr -BackupObject $BackupsObject
  .PARAMETER BackupsObject
    A list of SQL backups, as provided by Get-RestoreSet
  .PARAMETER RestoreSQLServer
    SMO SQL Server connection object
  .PARAMETER RestorePath
    Path to which the backups will be restored

  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$True)]
    [Microsoft.SQLServer.Management.Smo.Server]$RestoreSQLServer,
    [Parameter(Mandatory=$True)]
    [string]$RestorePath,
    [Parameter(Mandatory=$True)]
    [object]$backupsObject
  )
   Write-Verbose "Test-RestoreSpace - Entering " 
      if ($RestorePath.substring(1,1) -ne ':'){
        Throw "Sorry, not supporting UNC yet :( "
    }
  $DriveLetter = split-path $RestorePath -Qualifier
  $disk2 = Get-WmiObject Win32_Volume -ComputerName $RestoreSQLServer.NetName -Filter "name='$DriveLetter\\'"
  if(($BackupsObject | measure-object -Property totalsize -Maximum).Maximum -gt $disk2.FreeSpace){
    Write-Verbose "Not enough space!"
     return $FALSE
  }else{
    $TRUE
  }
   Write-Verbose "Test-RestoreSpace - Leaving " 
}