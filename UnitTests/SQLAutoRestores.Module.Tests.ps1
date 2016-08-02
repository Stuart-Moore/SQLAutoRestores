
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$here = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$module = 'SQLAutoRestores'

Describe -Tags ('Unit', 'Acceptance') "$module Module Tests"  {

  Context 'Module Setup' {
    It "has the root module $module.psm1" {
      "$here\$module.psm1" | Should Exist
    }

    It "has the a manifest file of $module.psm1" {
      "$here\$module.psd1" | Should Exist
      "$here\$module.psd1" | Should Contain "$module.psm1"
    }
    
    It '$module folder has functions' {
      "$here\Functions\function-*.ps1" | Should Exist
    }

    It "$module is valid PowerShell code" {
      $psFile = Get-Content -Path "$here\$module.psm1" `
                            -ErrorAction Stop
      $errors = $null
      $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
      $errors.Count | Should Be 0
    }

  } # Context 'Module Setup'


  $functions = ('Get-BottomFolders',   
                'Get-DBBackupObject',  
                'Get-FileRestoreMove', 
                'Get-RandomElement',   
                'Get-RestoreSet',      
                'Remove-Database',      
                'Restore-Database',    
                'Test-Database',       
                'Test-DatabaseVersion',
                'Test-RestoreSpace',
                'New-BackupObject',
                'Test-BackupObject',
                'Restore-SQLBackupHeader',
                'New-SQLConnection',
                'Get-PointInTime',
                'Test-DBBackupsExist' 
                )
  
  foreach ($function in $functions)
  {
  
    Context "Test Function $function" {
      
      It "$function.ps1 should exist" {
        "$here\Functions\function-$function.ps1" | Should Exist
      }
    
      It "$function.ps1 should have help block" {
        "$here\Functions\function-$function.ps1" | Should Contain '<#'
        "$here\Functions\function-$function.ps1" | Should Contain '#>'
      }

      It "$function.ps1 should have a SYNOPSIS section in the help block" {
        "$here\Functions\function-$function.ps1" | Should Contain '.SYNOPSIS'
      }
    
      It "$function.ps1 should have a DESCRIPTION section in the help block" {
        "$here\Functions\function-$function.ps1" | Should Contain '.DESCRIPTION'
      }

      It "$function.ps1 should have a EXAMPLE section in the help block" {
        "$here\Functions\function-$function.ps1" | Should Contain '.EXAMPLE'
      }
    
      It "$function.ps1 should be an advanced function" {
        "$here\Functions\function-$function.ps1" | Should Contain 'function'
        "$here\Functions\function-$function.ps1" | Should Contain 'cmdletbinding'
        "$here\Functions\function-$function.ps1" | Should Contain 'param'
      }
      
      It "$function.ps1 should contain Write-Verbose blocks" {
        "$here\Functions\function-$function.ps1" | Should Contain 'Write-Verbose'
      }
    
      It "$function.ps1 is valid PowerShell code" {
        $psFile = Get-Content -Path "$here\Functions\function-$function.ps1" `
                              -ErrorAction Stop
        $errors = $null
        $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
        $errors.Count | Should Be 0
      }

    
    } # Context "Test Function $function"

    Context "$function has tests" {
      It "function-$($function).Tests.ps1 should exist" {
        "$here\UnitTests\function-$($function).Tests.ps1" | Should Exist
      }
    }
  
  } # foreach ($function in $functions)


}