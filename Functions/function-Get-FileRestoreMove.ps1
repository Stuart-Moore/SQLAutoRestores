function Get-FileRestoreMove
{
 <#
  .SYNOPSIS
    Given a set of files to restore, generates the necessary RelocateFiles object for the given path
  .DESCRIPTION
    Function to generate the SQL restore syntax to move all the data and log files in a SQL Server backup to a new destination during restore
  .EXAMPLE
    Get-FileRestoreMove -Backups $Backups -Destination 'c:\backups'
  .PARAMETER BackupsObject
    A list of SQL backups, as provided by Get-RestoreSet
  .PARAMETER DestinationPath
    The path to which the db should be restored.
  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$True)]
    [object]$BackupsObject,
    [Parameter(Mandatory=$True)]
    [string]$DestinationPath

  )
    Write-Verbose "Entering Get-FileRestoreMove"
    $outbackups = @()
    
    if ($DestinationPath.substring($DestinationPath.length-1,1) -ne '\'){
        $DestinationPath = $DestinationPath+'\'
    }
  foreach ($backup in $BackupsObject){
    $RelocateFile = @()
    
    foreach ($file in $backup.files){
        $rf = new-object -typename Microsoft.SqlServer.Management.Smo.RelocateFile
        $rf.LogicalFileName = $file.LogicalName
        $rf.PhysicalFileName = $DestinationPath+(Split-Path $file.PhysicalName -Leaf)
        $RelocateFile+= $rf
    }
    #$Backup | add-member -name Relocate -value $RelocateFile -MemberType NoteProperty
    $backup.relocatefile = $RelocateFile
    $outbackups += $backup
    remove-variable relocatefile
  }
  Write-Verbose "Get-FileRestoreMove - Leaving"
  $outbackups
}