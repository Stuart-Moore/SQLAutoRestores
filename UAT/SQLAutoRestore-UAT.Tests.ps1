$here = Split-Path -Parent System.Management.Automation.InvocationInfo.MyCommand.Path

                Write-host $here

Get-Module SQLAutoRestores | Remove-Module -Force
Import-Module ..\SQLAutoRestores -Force
Import-Module sqlps -DisableNameChecking

Describe 'New UAT Test Harness' -tags 'Build-UAT' {
    InModuleScope SQLAutoRestores {
        Context "Checking Harness" {
            It "Harness Config should exist" {
            '.\UAT-Harness-Config.ps1' | Should exist
            }
            . .\UAT-Harness-Config.ps1
        
            It "Should contain at least 2 servers in servers" {
                $servers.count | Should BeGreaterThan 1
            }

              
            foreach ($server in $servers) {
                It "Server $($server.servername) should be on" {
                    Test-Connection $server.servername -Quiet | Should Be $True 
                }

                It "$($server.servername) should have a running SQL process $($server.InstanceName) running" {
                    (Get-Service -ComputerName $server.servername |  Where-Object{$_.Name -like "MSSQL*$($server.InstanceName)"}).count | Should be 1
                }
                
                It "$($server.ServerName) should have a backup area $($server.BaseBackupPath)" {
                    [scriptblock]$sb = {Test-Path $server.BaseBackupPath}
                    Invoke-Command -ComputerName $server.ServerName -ScriptBlock {param($path) Test-Path $path} -ArgumentList $server.BaseBackupPath | Should Be $True
                }
                It "$($server.ServerName) should have a restore area $($server.BaseRestorePath)" {
                    [scriptblock]$sb = {Test-Path $server.BaseRestorePath}
                    Invoke-Command -ComputerName $server.ServerName -ScriptBlock {param($path) Test-Path $path} -ArgumentList $server.BaseRestorePath | Should Be $True
                }
                #(get-content .\SQLBuildscripts\TimeDBBuild.sql) -replace '##replace##',$server2.BaseBackupPath | Out-File .\SQLBuildscripts\buildtmp.sql
                #It "Shouldn't throw when building the test db" {
                #    {Invoke-Sqlcmd -ServerInstance "$($server2.ServerName)\$($server2.InstanceName)" -InputFile .\SQLBuildscripts\buildtmp.sql -QueryTimeout 960} | Should Not Throw
                #}
                #Remove-Item .\SQLBuildscripts\buildtmp.sql
                It "Should have 30 rows" {
                    (Invoke-Sqlcmd -ServerInstance "$($server2.ServerName)\$($server2.InstanceName)" -Query "select count(*) as rowcnt from restoretime.dbo.steps").rowcnt | Should Be 30
                }
                It "Should have at least 14 minutes time difference betweent first and last" {
                    (Invoke-Sqlcmd -ServerInstance "$($server2.ServerName)\$($server2.InstanceName)" -Query "select datediff(MINUTE,min(dt),max(dt)) as difference from restoretime.dbo.steps").difference | Should BeGreaterThan  13
                }
                It "Should have 1 .bak file in $($server.BaseBackupPath)" {
                    (Get-ChildItem $server2.BaseBackupPath -Filter *.bak | Measure-Object).count | Should Be 1
                }
                It "Should have 3 .trn files in $($server.BaseBackupPath)" {
                    (Get-ChildItem $server2.BaseBackupPath -Filter *.trn | Measure-Object).count | Should Be 3
                }


            }
        }
    }
}
