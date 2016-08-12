#Setup some parameters for UAT

$servers = @()

$server1 = New-Object psobject -Property @{
        ServerName = 'localhost'
        Version = '2012'
        InstanceName = 'sqlexpress2012'
        BaseBackupPath = 'c:\SQLAutoRestoreUAT\Backups\2012\'
        BaseRestorePath = 'c:\SQLAutoRestoreUAT\Restores\2012\'
}

$servers += $server1

$server2 = New-Object psobject -Property @{
        ServerName = 'localhost'
        Version = '2016'
        InstanceName = 'sqlexpress2016'
        BaseBackupPath = 'c:\SQLAutoRestoreUAT\Backups\2016\'
        BaseRestorePath = 'c:\SQLAutoRestoreUAT\Restores\2016\'
}
$servers += $server2

