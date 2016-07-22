$here = Split-Path -Parent System.Management.Automation.InvocationInfo.MyCommand.Path

Get-Module SQLAutoRestores | Remove-Module -Force
Import-Module .\SQLAutoRestores -Force

Describe 'Get-BottomFolders Unit Tests' -tags 'Unit' {

    InModuleScope SQLAutoRestores {
        Context "Return Type should be SMO.Server" {
            It "should return SMO.Server"{
                New-SQLConnection -ServerInstance localhost | Should BeOfType Microsoft.SQLServer.Management.Smo.Server
            }
        }
    }
}