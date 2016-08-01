$here = Split-Path -Parent System.Management.Automation.InvocationInfo.MyCommand.Path

Get-Module SQLAutoRestores | Remove-Module -Force
Import-Module .\SQLAutoRestores -Force

Describe 'Get-PointInTime Unit Tests' -tags 'Unit' {
    InModuleScope SQLAutoRestores {
        Context "Pushing in Date Tests" {
            $tmp = New-BackupObject
            $t = get-date '19 July 2016 13:53:19'
            $tmp.StartDate = $t
            $tmp.BackupType = 'Database'
            $tmp.FinishDate = $t.AddMilliseconds(2)
            It "should return DateTime "{
                Get-PointInTime $tmp | Should beofType DateTime
            }
            #Cheating here! Need to add milliseconds to get a value, but rounded out as we return at second resolution
            It "Should return This Time" {
                Get-PointInTime $tmp | Should Be '07/19/2016 13:53:19'
            }
            $tmp.FinishDate = $t
            It "Should return Endtime if both times same" {
                Get-PointInTime $tmp | Should Be '07/19/2016 13:53:19'
            }
            It "Should Barf if enddate not dates" {
                $tmp.FinishDate='hello'
                $tmp.StartDate = $t
                { Get-PointInTime $tmp } | Should Throw "not a datetime"
            }
            It "Should Barf if startdate not dates" {
                $tmp.StartDate='hello'
                $tmp.FinishDate = $t.AddMilliseconds(2)
                { Get-PointInTime $tmp } | Should Throw "not a datetime"
            }

        }
    }
}