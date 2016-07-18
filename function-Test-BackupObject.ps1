function Test-BackupObject 
{
  <#
  .SYNOPSIS
    Check an Object is of type BackupOpbject
  .DESCRIPTION
         Check an Object is of type BackupOpbject. returns $true if it is, $false if not
  .EXAMPLE
  Test-BackupObject -BackupObject $BackupObject
  .Example
  $BackupObject | Test-BackupObject
  .Example
  Test-BackupObject $BackupObject
  .PARAMETER BackupObject
    object to test
  #>
    [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$True,
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True)]
    [object]$backupObject
  )
  Write-Verbose "Test-BackupObject - Entering"

  $properties = (
        'filename',        'LastLSN',        'BackupType',        'StartDate',        'FinishDate',        'DatabaseName',        'SQLVersion',        'TotalSize',        'Files',        'RelocateFile',
        'Position'
  )
  if ($backupObject.gettype().name -ne "PSCustomObject"){
    Write-Verbose "Test-BackupObject - Wrong type of object, false"
    return $false
  }

  if ((($backupObject | Get-Member).count) -ne ($properties.count + 4)){
    Write-Verbose "Test-BackupObject - Wrong number of properties, false"
    return $false
  }
  $counter = 0  
  foreach ($property in $properties){
    if ($backupObject.$property -eq ''){
        $counter++
    }
  }
  if (($backupobject | Get-Member).count -ne $properties.count+4){
    Write-Verbose "Test-BackupObject - Not all properties matched, false"
    return $false
  }
  Write-Verbose "Test-BackupObject - Leaving"
  return $true
}