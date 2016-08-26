#Setup some parameters for UAT

$servers = @()

$server1 = New-Object psobject -Property @{
        ServerName = 'localhost'
        Version = '2012'
        InstanceName = 'sqlexpress2012'
        BaseBackupPath = 'c:\SQLAutoRestoreUAT\2012\Backups'
        BaseRestorePath = 'c:\SQLAutoRestoreUAT\2012\Restores'
}

$servers += $server1

$server2 = New-Object psobject -Property @{
        ServerName = 'localhost'
        Version = '2016'
        InstanceName = 'sqlexpress2016'
        BaseBackupPath = 'c:\SQLAutoRestoreUAT\2016\Backups'
        BaseRestorePath = 'c:\SQLAutoRestoreUAT\2016\Restores'
}
$servers += $server2

