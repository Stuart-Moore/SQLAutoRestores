$here = Split-Path -Parent System.Management.Automation.InvocationInfo.MyCommand.Path

Get-Module SQLAutoRestores | Remove-Module -Force
Import-Module ..\SQLAutoRestores -Force

Describe 'Get-RandomElement Unit Tests' -tags 'Unit' {

    InModuleScope SQLAutoRestores {
        Context "Single item Array" {
            $testsingle = @('1')
            It "should return 1"{
                Get-RandomElement $testsingle | Should belike "1"
            }
        }
        Context "Full Array" {
            $testtriple = @('1','2','3')
            It "should return betweent 1 and 3" {
                Get-RandomElement $testtriple | Should belike "[1-3]"
            }
            It "Should return one element" {
                (Get-RandomElement $testtriple).count | Should Be "1"
            }
        }
    }
}