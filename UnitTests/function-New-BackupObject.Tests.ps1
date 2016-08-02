$here = Split-Path -Parent System.Management.Automation.InvocationInfo.MyCommand.Path

Get-Module SQLAutoRestores | Remove-Module -Force
Import-Module ..\SQLAutoRestores -Force

Describe 'New-BackupObject Unit Tests' -tags 'Unit' {

    InModuleScope SQLAutoRestores {
        Context "Checking BackupObject creation" {
            It "Should return a BackupObject" {
                $test = New-BackupObject
                Test-BackupObject -backupObject $test | Should Be $true
            }
        }
    }
}