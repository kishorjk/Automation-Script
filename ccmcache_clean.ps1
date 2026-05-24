$ccmcachePath = "C:\Windows\ccmcache"

if (Test-Path $ccmcachePath)
{
    try
    {
        Get-ChildItem -Path $ccmcachePath -Recurse -Force | Remove-Item -Force -Recurse -ErrorAction Stop
        Write-Output "CCMcache clean"
    }
    catch
    {
        Write-Output "Error while cleaning"
    }
}
else
{
    Write-Output "folder not found"
}