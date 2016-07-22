function New-BackupObject 
{
  <#
  .SYNOPSIS
    Returns a new BackupObject
  .DESCRIPTION
   Creates an object with the properties required for a BackupObject to carry the necessary information between parts of the Automated Restore Process.
   Mainly here because not everyone will want to install CTYPE or upgrage to PowerShell v5. Will try to implement something better. Suggestions welcome
  .EXAMPLE
  New-BackupObject
  #>
  [CmdletBinding()]
  param
  (
        $filename = '',        $LastLSN = '',        $BackupType = '',        $StartDate = '',        $FinishDate = '',        $DatabaseName = '',        $SQLVersion = '',        $TotalSize = '',        $Files = '',        $RelocateFile = '',
        $Position = ''
  )
  Write-Verbose "New-BackupObject - starting"

    $backuptmp = new-object psobject -Property @{
        filename = $filename        LastLSN = $LastLSN        BackupType = $BackupType        StartDate = $StartDate        FinishDate = $FinishDate        DatabaseName = $DatabaseName        SQLVersion = $SQLVersion        TotalSize = $TotalSize        Files = $Files        RelocateFile = $RelocateFile
        Position = $Position
    }
    return $backuptmp
  Write-Verbose "New-BackupObject - Leaving"
}