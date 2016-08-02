function Get-BottomFolders
{
  <#
  .SYNOPSIS
    Get the folders at the bottom of directory tree starting at $InputPath, returns an Arraylist of all the bottom folder
  .DESCRIPTION
   Given a folder, find all the lowest folders across all branches
  .EXAMPLE
  Get-BottomFolder -RootPath '\\server1\dbbackups$'
  .PARAMETER RootPath
   Root of path to search..
  #>
   [CmdletBinding()]
   param
  (
    [Parameter(Mandatory=$True)]
    [string]$RootPath
  )
   Write-Verbose "Entering Get-BottomFolders"
    $dirs = Get-ChildItem $RootPath -Recurse -Directory
    $children = New-Object System.Collections.ArrayList
    foreach ($d in $dirs){
        $t = split-path $d.FullName -Parent
        if ($children -notcontains $t){
            $null = $children.add($d.fullname)
        }else{
           $null =  $children.remove($t)
           $null =  $children.add($d.fullname)
        }
    }
    write-verbose "Leaving Get-BottomFolders, found ($children.count) folders"
    $children
}