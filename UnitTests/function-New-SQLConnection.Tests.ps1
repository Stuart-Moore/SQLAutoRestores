$here = Split-Path -Parent System.Management.Automation.InvocationInfo.MyCommand.Path

Get-Module SQLAutoRestores | Remove-Module -Force
Import-Module ..\SQLAutoRestores -Force

Describe 'Get-BottomFolders Unit Tests' -tags 'Unit' {

    InModuleScope SQLAutoRestores {
        Context "Return Type should be SMO.Server" {
            It "should return SMO.Server"{
                New-SQLConnection -ServerInstance localhost | Should BeOfType Microsoft.SQLServer.Management.Smo.Server
            }
        }
    }
}

Describe 'Get-BottomFolders UAT' -tags 'UAT'{
    InModuleScope SQLAutoRestores {
        Context "Make a SQL Connection" {
            $SQL2012conn = New-SQLConnection -ServerInstance localhost\SQLExpress2012
            It "should return a useable SQL connection" {
                $SQL2012conn | Should BeOfType Microsoft.SQLServer.Management.Smo.Server
            }
            It "Should throw on a bad connection" {
                $sqlBADconn = New-SQLConnection -ServerInstance localhost\badinstance
                $SQLBADconn.Processors | Should Throw
            }
        }
    }
}