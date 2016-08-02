$here = Split-Path -Parent System.Management.Automation.InvocationInfo.MyCommand.Path

Get-Module SQLAutoRestores | Remove-Module -Force
Import-Module ..\SQLAutoRestores -Force

Describe 'TestDBBackupsExist Unit Tests' -tags 'Unit' {
    InModuleScope SQLAutoRestores {
        Context "Single Folder at bottom" {
            New-item "TestDrive:\blah.txt" -ItemType file
            It "should return false - no backups"{
               Test-DBBackupsExist -Inputpath testdrive:\ | Should be $false
            }
            New-Item "TestDrive:\blah.trn" -ItemType file
            It "Should return false - No anchoring bak" {
                Test-DBBackupsExist -InputPath testdrive:\ | should be $false
            }
            New-Item "TestDrive:\blah.bak" -ItemType file
            It "Should return true - we have a bak and some others" {
                Test-DBBackupsExist -InputPath testdrive:\ | should be $true
            }


        }
    }
}