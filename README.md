# SQLAutoRestores

PowerShell module to allow easy automated restoration of SQL Server backups to promote testing them.

Aim is to be able to be given a set of folders containing SQL Server backups (Full, Differential or Transaction), pick one of the folders at random, scan the backup files to ensure we have a good set. Then restore them on a server of the users choosing, redirecting them to a folder of choice, after checking that there is enough space on the target server and that the SQL Server versions are compatible.

Once it's been restored succesfully it will allow the user to run DBCC checks against the database, or a test script of their choosing.

All results, files and other information should then be available for email or logging.

Work in progress based on some ad-hoc scripts that have worked fine, but aren't necessarily ready for public consumption.

Any comments and thoughts welcomed.
