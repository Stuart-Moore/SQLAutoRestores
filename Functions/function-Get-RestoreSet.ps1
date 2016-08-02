function Get-RestoreSet
{ <#
  .SYNOPSIS
    Pick a random point in time to restore a SQL backup to
  .DESCRIPTION
    Take a BackupsObject, calculate the time period over which it could be restored. Find a random point in that time,
     and then build up the required files to restore to that point
  .EXAMPLE
    Get-RestoreSet -BackupsObject $backups
  .PARAMETER BackupsObject
    Object of parsed backup files, easiest taken from Get-DBBackupObject
  .PARAMETER TargetTime
    Optional parameter to specify point in time rather than use default random point.
  .PARAMETER Latest
    Switch to just restore to most recent point in time
  .PARAMETE RandomPointInTime
    Switch to restore to RandomPointInTime (Default)
  #>
  [CmdletBinding()]
  param
  (
   [Parameter(Mandatory)]
   [System.object]$BackupsObject,
    [Parameter(ParameterSetName="TargetTime")]
    [DateTime]$TargetTime = (Get-Date "11/12/1975 8:15 pm")    
  )
    Write-Verbose "Get-RestoreSet - Entering"
    
    #Check we have a valid set of BackupObjects
    foreach ($BackupObject in $BackupsObject) {
        if (!(Test-BackupObject -backupObject $BackupObject)){
            Write-Verbose "Get-RestoreSet - Bad BackupObject passed in"
            Write-Error "Get-RestoreSet - Bad BackupObject passed in"
            exit
        }
    } 

    if ($TargetTime -eq (Get-Date "11/12/1975 8:15 pm")){
        $TargetTime = Get-Date
    }
     
    Write-Verbose "Get-RestoreSet - targettime is ($TargetTime)" 
    $btmp = @()    $btmp += $BackupsObject | ?{$_.backuptype -eq 'Database' -and (get-date $_.startdate) -lt $TargetTime} | sort-object -Descending startdate | Select-Object -first 1    $fullstop = $btmp[0].finishdate    $btmp += $BackupsObject | ?{(get-date $_.startdate) -ge (get-date $fullstop) -and (get-date $_.FinishDate) -lt $TargetTime}    $btmp += $BackupsObject | ?{(get-date $_.startdate) -ge (get-date $TargetTime)} | Sort-Object -Property StartDate | Select-Object -First 1
    Write-Verbose "Get-RestoreSet - Leaving" 
    return $btmp
}