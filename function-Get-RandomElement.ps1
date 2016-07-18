function Get-RandomElement
{
  <#
  .SYNOPSIS
    Takes an arraylist of strings, and returns a random element.
  .DESCRIPTION 
   Given an array, function returns a random element within that array
  .EXAMPLE
    Get-RandomElement -InputArray $Arraylist
  .PARAMETER InputArray
    ArrayList to work with

  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$True)]
    [string[]]$InputArray
  )
  Write-Verbose "Get-RandomElement - Entering"
  return $InputArray[(Get-Random -Minimum 0 -Maximum ($InputArray.Count))]
}