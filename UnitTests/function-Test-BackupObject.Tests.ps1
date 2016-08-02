$here = Split-Path -Parent System.Management.Automation.InvocationInfo.MyCommand.Path

Get-Module SQLAutoRestores | Remove-Module -Force
Import-Module ..\SQLAutoRestores -Force

Describe 'Test-BackupObject Unit Tests' -tags 'Unit' {

    InModuleScope SQLAutoRestores {
        Context "Checking BackupObject validation" {
            It "Should return a BackupObject" {
                $test = New-BackupObject
                Test-BackupObject -backupObject $test | Should Be $true
            }
            It "Should return false for anything else" {
                $temp = New-Object -TypeName System.Version -ArgumentList "1.2.3.4"
                Test-BackupObject -backupObject $temp | Should be $false
            }
        }
    }
}