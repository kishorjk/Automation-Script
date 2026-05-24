# Registry paths to check
$registryPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
)

foreach ($path in $registryPaths) {

    $apps = Get-ItemProperty -Path "$path\*" -ErrorAction SilentlyContinue | Where-Object {
        $_.DisplayName -like "*Microsoft*" -and $_.DisplayVersion -match "^6\."
    }

    foreach ($app in $apps) {

        Write-Host "Found: $($app.DisplayName) Version: $($app.DisplayVersion)" -ForegroundColor Yellow

        $uninstallString = $app.UninstallString

        if ($uninstallString) {

            if ($uninstallString -like "*msiexec*") {

                #Handle MSI uninstaller
                Write-Host "Running msiexec for $($app.DisplayName)..." -ForegroundColor Cyan

                Start-Process "msiexec.exe" -ArgumentList "$($uninstallString -replace 'msiexec.exe','') /quiet /norestart IGNOREDEPENDENCIES ALL" -Wait

                Write-Host "Uninstalled $($app.DisplayName) successfully!" -ForegroundColor Green

            } elseif ($uninstallString -like "*.exe*") {

                $exeMatch = $uninstallString -match '(".*?"|\S+)(.*)'

                $exePath = $Matches[1] -replace '"', '' #EXE path without quotes
                $exeArgs = $Matches[2].Trim() #Arguments trimmed

                Write-Host "exe file $exePath and $exeArgs"

                if (Test-Path $exePath) {

                    Write-Host "Running EXE uninstaller for $($app.DisplayName)..." -ForegroundColor Cyan 
                    Start-Process -FilePath $exePath -ArgumentList "$exeArgs /quiet /norestart" -Wait

                    Write-Host "Uninstalled $($app.DisplayName) successfully!" -ForegroundColor Green

                } else { 
                    Write-Host "Uninstaller EXE not found for $($app.DisplayName)." -ForegroundColor Red
                }

            } else {

                Write-Host "UninstallString format not recognized for $($app.DisplayName)." -ForegroundColor Magenta

            } 
        } else {

            Write-Host "UninstallString not found for $($app.DisplayName)." -ForegroundColor Red

        }
    }
}