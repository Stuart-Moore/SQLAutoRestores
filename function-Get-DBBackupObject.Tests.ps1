$here = Split-Path -Parent System.Management.Automation.InvocationInfo.MyCommand.Path

Get-Module Podcast-NoAgenda | Remove-Module -Force
Import-Module \Podcast-NoAgenda.psm1 -Force
