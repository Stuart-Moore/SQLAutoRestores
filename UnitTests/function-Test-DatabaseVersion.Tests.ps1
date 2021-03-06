$here = Split-Path -Parent System.Management.Automation.InvocationInfo.MyCommand.Path

Get-Module SQLAutoRestores | Remove-Module -Force
Import-Module ..\SQLAutoRestores -Force

Describe 'Test-DatabaseVersion Unit Tests' -tags 'Unit' {

    InModuleScope SQLAutoRestores {
        Context "Test Version Checking" {
            $sqlconn = new-object -type Microsoft.SQLServer.Management.Smo.Server('localhost')
            $bos = @()
            $bo = New-BackupObject
            $bo.SQLVersion = 3
            $bos += $bo
            It "Should return true if within 2 major versions"{
                mock Get-SQLServerMajorVersion { return 5}
                Test-DatabaseVersion -BackupObject $bos -RestoreSQLServer $sqlconn | should be $true
                mock Get-SQLServerMajorVersion { return 4}
                Test-DatabaseVersion -BackupObject $bos -RestoreSQLServer $sqlconn | should be $true                                      
            }
            It "Should return False if without 2 major versions"{
                mock Get-SQLServerMajorVersion { return 6}
                Test-DatabaseVersion -BackupObject $bos -RestoreSQLServer $sqlconn | should be $false
            }
            It "Should return true if backup version higher than server"{
                mock Get-SQLServerMajorVersion { return 2}
                Test-DatabaseVersion -BackupObject $bos -RestoreSQLServer $sqlconn | should be $false 
            }
        }
    }
}