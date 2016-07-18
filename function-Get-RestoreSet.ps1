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
    [DateTime]$TargetTime = (Get-date),
    [Parameter(ParameterSetName="Latest")]
    [switch]$Latest =$null
    
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
     
 <#   $StartDate = $BackupsObject | ?{$_.BackupType -eq 'Database'} | Measure-Object -Min -Property startdate    $EndDate = $BackupsObject.FinishDate | Measure-Object -Max        if ($RandomPointInTime -eq $True){        $seconds = Get-Random ($EndDate.Maximum -$StartDate.Minimum).TotalSeconds        $TargetTime = $startdate.Minimum.AddSeconds($seconds)
    }else{
        if ($TargetTime -lt $StartDate -or $TargetTime -gt $EndDate){
            write-error "Point in Time target is not in the range covered by the available backups"
            return
        }
    }
    #>
    Write-Verbose "Get-RestoreSet - targettime is ($TargetTime)" 
    $btmp = @()    $btmp += $BackupsObject | ?{$_.backuptype -eq 'Database' -and (get-date $_.startdate) -lt $TargetTime} | sort-object -Descending startdate | Select-Object -first 1    $btmp += $BackupsObject | ?{(get-date $_.startdate) -gt (get-date $btmp.finishdate) -and (get-date $_.FinishDate) -lt $TargetTime}    $btmp += $BackupsObject | ?{(get-date $_.startdate) -gt (get-date $TargetTime)} | Sort-Object -Property StartDate | Select-Object -First 1
    Write-Verbose "Get-RestoreSet - Leaving" 
    $btmp
}