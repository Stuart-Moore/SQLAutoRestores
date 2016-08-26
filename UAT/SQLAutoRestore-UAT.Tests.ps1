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
                Remove-Item -Path "$($server.BaseBackupPath)\*.*"
                (get-content .\SQLBuildscripts\TimeDBBuild.sql) -replace '##replace##',$server.BaseBackupPath | Out-File .\SQLBuildscripts\buildtmp.sql
                It "Shouldn't throw when building the test db" {
                    {Invoke-Sqlcmd -ServerInstance "$($server.ServerName)\$($server.InstanceName)" -InputFile .\SQLBuildscripts\buildtmp.sql -QueryTimeout 960} | Should Not Throw
                }
                Remove-Item .\SQLBuildscripts\buildtmp.sql
                It "Should have 30 rows" {
                    (Invoke-Sqlcmd -ServerInstance "$($server.ServerName)\$($server.InstanceName)" -Query "select count(*) as rowcnt from restoretime.dbo.steps").rowcnt | Should Be 30
                }
                It "Should have at least 14 minutes time difference betweent first and last" {
                    (Invoke-Sqlcmd -ServerInstance "$($server.ServerName)\$($server.InstanceName)" -Query "select datediff(MINUTE,min(dt),max(dt)) as difference from restoretime.dbo.steps").difference | Should BeGreaterThan  13
                }
                It "Should have 1 .bak file in $($server.BaseBackupPath)" {
                    (Get-ChildItem $server.BaseBackupPath -Filter *.bak | Measure-Object).count | Should Be 1
                }
                It "Should have 3 .trn files in $($server.BaseBackupPath)" {
                    (Get-ChildItem $server.BaseBackupPath -Filter *.trn | Measure-Object).count | Should Be 3
                }


            }
        }
    }
}


Describe 'Testing function calls' -tags 'Run-UAT' {
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
                It "Should have 1 .bak file in $($server.BaseBackupPath)" {
                    (Get-ChildItem $server2.BaseBackupPath -Filter *.bak | Measure-Object).count | Should Be 1
                }
                It "Should have 3 .trn files in $($server.BaseBackupPath)" {
                    (Get-ChildItem $server2.BaseBackupPath -Filter *.trn | Measure-Object).count | Should Be 3
                }
            }
        } #Context "Checking Harness"
        Context "Checking functions" {
            . .\UAT-Harness-Config.ps1
            foreach ($server in $servers){
                $folders = @()
                $folders += Get-BottomFolders (split-path $server.BaseBackupPath -parent) 
                #It "Should return the correct bottom folder" {
                #    $folders | Should Be $server.BaseBackupPath
                #}
                $RestoreFolder = Get-RandomElement $folders
                while (!(Test-DBBackupsExist $RestoreFolder)){
                    $RestoreFolder = Get-RandomElement $folders
                }
                It "Should return the folder name" {
                    $Restorefolder | Should Be $server.BaseBackupPath
                }
                #$restoreFolder = $server.BaseBackupPath
                $SQLConnection = New-SQLConnection -ServerInstance "$($server.ServerName)\$($server.InstanceName)"
                It "should return a  SQL connection" {
                    $SQLConnection | Should BeOfType Microsoft.SQLServer.Management.Smo.Server
                }
                $BackupObjects = Get-DBBackupObject -InputPath $RestoreFolder -ServerInstance $SQLconnection
                It "Should contain 4 objects" {
                    $BackupObjects.count | Should Be 4
                }
                $TimeToRestore = Get-PointInTime -BackupsObject $BackupObjects
                $StartDate = ($BackupObjects.startdate | Measure-Object -Minimum | Select-Object minimum).minimum
                $FinishDate = ($BackupObjects.FinishDate | Measure-Object -Maximum | Select-Object Maximum).maximum
                It "Should be greater than the earliest point" {
                    $TimeToRestore | Should BeGreaterThan $startdate
                }
                It "Should be less than the earliest point" {
                    $TimeToRestore | Should BeLessThan $finishDate
                }
                #Test Filtering
                $ObjectivePiT = Get-RestoreSet -BackupsObject $BackupObjects -TargetTime $TimeToRestore
                $RestoreDBPit = 'RestoreDBPit'

                It "RestoreDBPit should not exist" {
                    Test-DatabaseExists -DatabaseName $RestoreDBPit -RestoreSQLServer $SQLConnection | should Be $false
                }
                $ObjectivePiT = Get-FileRestoreMove -BackupsObject $ObjectivePiT -DestinationPath $server.BaseRestorePath
                
                It "Should Restore without throwing" {
                    {Restore-Database -BackupsObject $ObjectivePit -RestoreSQLServer $SQLconnection -TargetTime $TimeToRestore -RestoreAs $RestoreDBPit} | Should Not Throw
                }
                It "RestoreDBPit should exist" {
                    Test-DatabaseExists -DatabaseName $RestoreDBPit -RestoreSQLServer $SQLConnection | should Be $true
                }
                $lastrestore = (Invoke-Sqlcmd -ServerInstance $SQLConnection -query "Select max(dt) as'resmax' from $($RestoreDBPit).dbo.steps").resmax
                It "Should be within 30 seconds of TargetTime(below) $lastrestore - $($TimeToRestore.AddSeconds(-30))" {
                    $lastrestore | should BeGreaterThan $TimeToRestore.AddSeconds(-30)
                }
                It "Should be within 30 seconds of TargetTime (above) $lastrestore - $($TimeToRestore.AddSeconds(30))" {
                    $lastrestore | should BeLessThan $TimeToRestore.AddSeconds(30)
                }

                Remove-Database -DatabaseName $RestoreDBPit -RestoreSQLServer $SQLConnection
                It "RestoreDBPit shouldn't exist post remove" {
                    Test-DatabaseExists -DatabaseName $RestoreDBPit -RestoreSQLServer $SQLConnection | should Be $false
                }
                #Now for latest
                $ObjectiveLatest = Get-RestoreSet -BackupsObject $BackupObjects
                $RestoreDBLatest = 'RestoreBDLatest'

                It "RestoreDBLatest should not exist" {
                    Test-DatabaseExists -DatabaseName $RestoreDBLatest -RestoreSQLServer $SQLConnection | should Be $false
                }
                $ObjectiveLatest = Get-FileRestoreMove -BackupsObject $ObjectiveLatest -DestinationPath $server.BaseRestorePath
                
                It "Should Restore without throwing" {
                    {Restore-Database -BackupsObject $ObjectiveLatest -RestoreSQLServer $SQLconnection -RestoreAs $RestoreDBLatest} | Should Not Throw
                }
                It "RestoreDBLatest should exist" {
                    Test-DatabaseExists -DatabaseName $RestoreDBLatest -RestoreSQLServer $SQLConnection | should Be $true
                }
                $lastrestore = (Invoke-Sqlcmd -ServerInstance $SQLConnection -query "Select max(dt) as'resmax' from $($RestoreDBLatest).dbo.steps").resmax
                It "Should be within 30 seconds of TargetTime(below) $lastrestore - $($finishdate.AddSeconds(-30))" {
                    $lastrestore | should BeGreaterThan $finishdate.AddSeconds(-30)
                }
                It "Should be within 30 seconds of TargetTime (above) $lastrestore - $($finishdate.AddSeconds(30))" {
                    $lastrestore | should BeLessThan $finishdate.AddSeconds(30)
                }
                Remove-Database -DatabaseName $RestoreDBLatest -RestoreSQLServer $SQLConnection
                It "RestoreDBLatest shouldn't exist post remove" {
                    Test-DatabaseExists -DatabaseName $RestoreDBLatest -RestoreSQLServer $SQLConnection | should Be $false
                }
                                 
            } #foreach ($server in $servers)
        }#Context "Checking functions"
    }
}