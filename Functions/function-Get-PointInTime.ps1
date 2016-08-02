function Get-PointInTime
{
  <#
  .SYNOPSIS
    Get a point in time covered by a set of SQL backups
  .DESCRIPTION
    Find a point in time to which a SQL Server database can be restore given a set of backup files
  .EXAMPLE
    Get-PointInTime -BackupObjects $BackupObjects
  .PARAMETER BackupObjects
    A collection of BackupObject objects
  #>
    [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$True,
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True)]
    [object]$backupsObject
  )
  Write-Verbose "Get-PointInTime - Entering"
  Write-Verbose "Get-PointInTime - Checking Dates"
    $StartDate = $BackupsObject | Where-Object {$_.BackupType -eq 'Database'} | Measure-Object -Min -Property startdate    $EndDate = $BackupsObject.FinishDate | Measure-Object -Maximumif (!($startdate.Minimum -is [dateTime])){    Write-Verbose "Get-PointInTime - Startdate is not a datetime, exiting"    Throw "Startdate is not a datetime"}if (!($EndDate.Maximum -is [dateTime])){    Write-Verbose "Get-PointInTime - EndDate is not a datetime, exiting"    Throw "Enddate is not a datetime"}if ($StartDate.minimum -eq $EndDate.Maximum){    Write-Verbose "Get-PointInTime - DateTimes are the same, random call will fail, so return Endate"    return $Enddate.Maximum}else{    $seconds = Get-Random ($EndDate.Maximum -$StartDate.Minimum).TotalSeconds    #$seconds = get-random ($EndDate - $StartDate).totalseconds
    $TargetTime = $startdate.Minimum.AddSeconds($seconds)
    return $TargetTime
    }
    Write-Verbose "Get-PointInTime - Leaving"
 }