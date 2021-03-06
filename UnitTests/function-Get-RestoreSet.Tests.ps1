$here = Split-Path -Parent System.Management.Automation.InvocationInfo.MyCommand.Path

Get-Module SQLAutoRestores | Remove-Module -Force
Import-Module ..\SQLAutoRestores -Force

Describe 'Get-RandomElement Unit Tests' -tags 'Unit' {

    InModuleScope SQLAutoRestores {
            $testobjects = @()
            $testobject = new-backupobject
            $testobject.BackupType = 'Database'
            $testobject.StartDate = get-date "07/19/2016 18:00"
            $testobject.FinishDate = get-date "07/19/2016 19:00"
            $testobjects += $testobject
            It "Should return a backup object" {
                Test-BackupObject (Get-RestoreSet -BackupsObject $testobjects) | Should be $true
            }

            $testobject2 = new-backupobject
            $testobject2.BackupType = 'Log'
            $testobject2.StartDate = get-date "07/19/2016 19:00"
            $testobject2.FinishDate = get-date "07/19/2016 20:00"
            $testobjects += $testobject2
            It "Should return 2 elements" {
                (Get-RestoreSet -BackupsObject $testobjects).count | Should Be "2"
            }
        }
    }