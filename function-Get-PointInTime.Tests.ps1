$here = Split-Path -Parent System.Management.Automation.InvocationInfo.MyCommand.Path

Get-Module SQLAutoRestores | Remove-Module -Force
Import-Module .\SQLAutoRestores -Force

Describe 'Get-PointInTime Unit Tests' -tags 'Unit' {
    InModuleScope SQLAutoRestores {
        Context "Single Folder at bottom" {
            $tmp = New-BackupObject
            $t = get-date '19 July 2016 13:53:19'
            $tmp.StartDate = $t
            $tmp.FinishDate = $t.AddMilliseconds(2)
            $tmp.BackupType = 'Database'
            It "should return DateTime "{
                Get-PointInTime $tmp | Should beofType DateTime
            }
            #Cheating here! Need to add milliseconds to get a value, but rounded out as we return at second resolution
            It "Should return time" {
                Get-PointInTime $tmp | Should Be '07/19/2016 13:53:19'
            }
            It "Should barf given not-dates" {
                
            }
        }
    }
}