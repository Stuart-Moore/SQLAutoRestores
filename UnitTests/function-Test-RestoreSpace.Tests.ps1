$here = Split-Path -Parent System.Management.Automation.InvocationInfo.MyCommand.Path

Get-Module SQLAutoRestores | Remove-Module -Force
Import-Module ..\SQLAutoRestores -Force

Describe 'Test-RestoreSpace Unit Tests' -tags 'Unit' {

    InModuleScope SQLAutoRestores {
        Context "Barf on UNC" {
            It "Should throw if not a drive letter"{
            $sqlconn = new-object -type Microsoft.SQLServer.Management.Smo.Server('localhost')
            $bos = @()
            $bos += New-BackupObject
            
                {Test-RestoreSpace -backupsobject $bos -RestoreSQLServer $sqlconn -RestorePath '\\server\share'} | Should Throw "Sorry, not supporting UNC yet :( "
            }
        }
        Context "Size checking" {
            Mock Get-WmiObject { return @{FreeSpace = 1}}
            It "Should return false if not enough space" {
                $sqlconn = new-object -type Microsoft.SQLServer.Management.Smo.Server('localhost')
                $sqlconn.NetName = 'localhost'
                $bos = @()
                $bo = New-BackupObject
                $bo.TotalSize = 2
                $bos += $bo
                Test-RestoreSpace -backupsobject $bos -RestoreSQLServer $sqlconn -RestorePath 'c:\' | Should be $false
            }
            Mock Get-WmiObject { return @{FreeSpace = 3}}
            It "Should return true if not space" {
                $sqlconn = new-object -type Microsoft.SQLServer.Management.Smo.Server('localhost')
                $sqlconn.NetName = 'localhost'
                $bos = @()
                $bo = New-BackupObject
                $bo.TotalSize = 2
                $bos += $bo
                Test-RestoreSpace -backupsobject $bos -RestoreSQLServer $sqlconn -RestorePath 'c:\' | Should be $True
            }
            It "Should get largest TotalSize in object" {
                $sqlconn = new-object -type Microsoft.SQLServer.Management.Smo.Server('localhost')
                $sqlconn.NetName = 'localhost'
                $bos = @()
                $bo = New-BackupObject
                $bo.TotalSize = 2
                $bos += $bo
                $bo2 = New-BackupObject
                $bo2.TotalSize = 5
                $bos += $bo2
                Test-RestoreSpace -backupsobject $bos -RestoreSQLServer $sqlconn -RestorePath 'c:\' | Should be $false
           }   
        }
    }
}