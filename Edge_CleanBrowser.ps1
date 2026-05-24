Get-Process "msedge" -ErrorAction SilentlyContinue | ForEach-Object { 
    try {
        Stop-Process -Id $_.Id -Force
    }
    catch {
        Write-Output "Failed to close Edge: $($_.Exception.Message)"
    }
}

$users = Get-ChildItem -Path "C:\Users" -Directory | Where-Object { $_.Name -notin @("Public", "Default", "Default User", "All Users") }

foreach ($user in $users) {

    $folderPath = "C:\Users\$($user.Name)\AppData\Local\Microsoft\Edge\User Data"

    if (Test-Path $folderPath) {

        Remove-Item "$folderPath\Default\Cache" -Recurse -Force -ErrorAction SilentlyContinue 
        Remove-Item "$folderPath\Default\Cookies" -Recurse -Force -ErrorAction SilentlyContinue 
        Remove-Item "$folderPath\Default\History" -Recurse -Force -ErrorAction SilentlyContinue

    }
    else
    {
        Write-Output "Edge data folder not found for user: $($user.Name)"
    }
}