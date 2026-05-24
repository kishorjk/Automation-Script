$targetVersion = [version]"6.0.34"

# --- 32-bit (.NET SDK/Runtime Folders) ---
$dotNetCoreFoldersX86 = Get-ChildItem "C:\Program Files (x86)\dotnet" -Recurse | Where-Object { $_.PSIsContainer }

foreach ($folder in $dotNetCoreFoldersX86)
{
    try
    {
        $folderVersion = [version]$folder.Name
        if ($folderVersion -lt $targetVersion)
        {
            Remove-Item -Recurse -Force $folder.FullName
        }
        else
        {
            Write-Host "skipping folder: $($folder.FullName)"
        }
    }
    catch
    {
        # Catches cases where folder name is not a valid version string
        Write-Host "Skipping non-version folder: $($folder.FullName)"
    }
}

# --- 64-bit (.NET SDK/Runtime Folders) ---
$dotNetCoreFoldersX64 = Get-ChildItem "C:\Program Files\dotnet" -Recurse | Where-Object { $_.PSIsContainer }

foreach ($folder in $dotNetCoreFoldersX64)
{
    try
    {
        $folderVersion = [version]$folder.Name
        if ($folderVersion -lt $targetVersion)
        {
            Remove-Item -Recurse -Force $folder.FullName
        }
        else
        {
            Write-Host "skipping folder: $($folder.FullName)"
        }
    }
    catch
    {
        Write-Host "Skipping non-version folder: $($folder.FullName)"
    }
}

# --- 32-bit (.swidtag files) ---
$directoryPathX86 = "C:\Program Files (x86)\dotnet"
$versionThresholdX86 = [version]"6.0.34"
$filesX86 = Get-ChildItem -Path $directoryPathX86 -Filter "*.swidtag" -Recurse

foreach ($file in $filesX86)
{
    if ($file.Name -match "([\d\.]+)\s*\(x86\)\.swidtag")
    {
        $versionString = $Matches[1]
        $fileVersion = [version]$versionString
        
        if ($fileVersion -lt $versionThresholdX86)
        {
            Remove-Item -Path $file.FullName -Force
        }
    }
}

# --- 64-bit (.swidtag files) ---
$directoryPathX64 = "C:\Program Files\dotnet"
$versionThresholdX64 = [version]"6.0.34"
$filesX64 = Get-ChildItem -Path $directoryPathX64 -Filter "*.swidtag" -Recurse

foreach ($file in $filesX64)
{
    if ($file.Name -match "([\d\.]+)\s*\(x64\)\.swidtag")
    {
        $versionString = $Matches[1]
        $fileVersion = [version]$versionString
        
        if ($fileVersion -lt $versionThresholdX64)
        {
            Remove-Item -Path $file.FullName -Force
        }
    }
}