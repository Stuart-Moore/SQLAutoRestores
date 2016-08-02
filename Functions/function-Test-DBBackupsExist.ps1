function Test-DBBackupsExist {
  <#
  .SYNOPSIS
    Basic check that we have SQL Backup files in a folder
  .DESCRIPTION
    Passed a folder location performs a basic checkt that we have some files that may make up a SQL Server backup chain. That means at least 1 bak file to anchor it
    Return $true if they exist, $false otherwise
  .EXAMPLE
    Test-DBBackupsExist -InputPath '\\SomeServer\SomeFolder\AnotherFolder'
  .PARAMETER InputPasth
    Path to backup files

  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$True,
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True)]
    [String]$InputPath
  )

    if ((Get-ChildItem $InputPath\* -include *.bak, *.trn).count -lt 1) {
        Write-Verbose "Test-DBBackupsExist - No files matching standard SQL extensions in folder"
        return $false
    }

        if ((Get-ChildItem $InputPath\* -include *.bak).count -lt 1) {
        Write-Verbose "Test-DBBackupsExist - No anchoring bak file found"
        return $false
    }


    return $True
  }