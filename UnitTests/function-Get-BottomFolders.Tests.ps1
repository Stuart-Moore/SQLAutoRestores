$here = Split-Path -Parent System.Management.Automation.InvocationInfo.MyCommand.Path

Get-Module SQLAutoRestores | Remove-Module -Force
Import-Module ..\SQLAutoRestores -Force

Describe 'Get-BottomFolders Unit Tests' -tags 'Unit' {

    InModuleScope SQLAutoRestores {
        Context "Single Folder at bottom" {
            New-item "TestDrive:\top\bottom" -ItemType directory
            It "should return bottom - one sub"{
                Get-BottomFolders -RootPath testdrive:\ | Should belike "*bottom"
            }
                        It "Should only return 1 folder" {
                (Get-BottomFolders -RootPath testdrive:\).count | Should Be 1
            }
            New-Item "TestDrive:\top\bottom\bottom2" -ItemType directory
            It "should return bottom- 2 levels"{
                Get-BottomFolders -RootPath testdrive:\ | Should belike "*bottom2"
            }
        }
        Context "Double Folder at bottom" {
 
            New-Item "TestDrive:\top\bottom1\bottom2" -ItemType directory
            New-Item "TestDrive:\top\bottom1\bottom3" -ItemType directory
            It "should return 2 folders- 2 subs"{
                (Get-BottomFolders -RootPath testdrive:\).count | Should Be 2
            }
            It "Should return bottom2 and bottom3" {
                Get-BottomFolders -RootPath testdrive:\ | Should belike "*bottom[23]"
            }
        }
        Context "Double Ragged Folder at bottom" {
 
            New-Item "TestDrive:\top\bottom1\bottom2" -ItemType directory
            New-Item "TestDrive:\top\bottom1\bottom3\bottom4" -ItemType directory
            It "should return 2 folders- 2 subs"{
                (Get-BottomFolders -RootPath testdrive:\).count | Should Be 2
            }
            It "Should return bottom2 and bottom4" {
                Get-BottomFolders -RootPath testdrive:\ | Should belike "*bottom[24]"
            }
        }

    }

}

Describe 'Get-BottomFolders UAT' -tags 'UAT' {
    InModuleScope SQLAutoRestores {
        Context "Should return 3 folders" {
            It "Should return 3 folders" {
                $folders = Get-BottomFolders -RootPath C:\AutoSQLUAT\Backups
                $folders.count | Should Be 3
            }
        }
    }
}

