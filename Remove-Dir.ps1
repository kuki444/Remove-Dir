# Remove-Dir.ps1
# PowerShell 5 over
# Opthions:
#   -r: Recursive Search Directory
#   -v: View Remove Directory LIst
#   -f: Force Remove File Messege
#   -include: Include Directory Name
#   -exclude: Exclude Directory Name
#   -days: days Remove Directory
#   -$path: Find Path (defult:.\)
# Param
param([switch] $r, [switch] $f, [switch] $v, $include, $exclude, $days, $path)
# Param Include Setting .\ Off
if($null -ne $include)
{
    if($include.StartsWith(".\"))
    {
        $include = $include.Remove(0,2)
    }
}
# Param Exclude Setting .\ Off
if ($null -ne $exclude)
{
    if($exclude.StartsWith(".\"))
    {
        $exclude = $exclude.Remove(0,2)
    }
}
# Param Path Setting
if ($null -eq $path)
{
    $path = "*"
}
# Param Recursion Setting And Find File
if ($r -eq $false)
{
    $result = Get-ChildItem -Path $path -Include $include -Exclude $exclude -Directory | Where-Object{$_.PSIsContainer -eq $true } | Where-Object{((Get-Date).Subtract($_.LastWriteTime)).Days -ge $days}
}
elseif ($r -eq $true)
{
    $result = Get-ChildItem -Path $path -Include $include -Exclude $exclude -Recurse -Force -Directory | Where-Object{$_.PSIsContainer -eq $true } | Where-Object{((Get-Date).Subtract($_.LastWriteTime)).Days -ge $days}
}
# Param View RemoveDirectory List
if ($v -eq $true)
{
    $result | Foreach-Object{$_.fullname}
}
if ($f -eq $false)
{
    $ans = "n"
    # Printing Directory Count   
    if ([string]::IsNullOrEmpty($result))
    {
        # Directory Count 0
        "`nCount`n---------`n" + 0
    }
    elseif ($result.gettype().fullname.toupper() -eq "SYSTEM.OBJECT[]")
    {
        # Directory Count 2 over
        "`nCount`n---------`n" + $result.length
        "Remove Regular Directories? (y/n)"
        $ans = Read-Host
    }
    else
    {
        # Directory Count 1
        "`nCount`n---------`n" + 1
        "Remove Regular Directories? (y/n)"
        $ans = Read-Host
    }
    if ($ans.ToLower() -ne "y")
    {
        return
    }
}
    
# Remove Regular Directory
$result | Foreach-Object{Remove-Item $_.fullname -Recurse}
