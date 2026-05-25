$GetJava = Get-CimInstance -ClassName Win32_Product | Where-Object { $_.Name -match "Java" }

if ($GetJava) {
    $GetJava | ForEach-Object {
        Start-Process msiexec.exe -ArgumentList "/x $($_.IdentifyingNumber) /qn" -NoNewWindow -Wait
    }
}

# Install Java (JRE) 8 Update 491 x86
Start-Process msiexec -ArgumentList "/i `"$PSScriptRoot\jre-8u491-windows-i586.msi`" /qn AUTO_UPDATE=0 EULA=0 REMOVEOLDERJRES=1 REMOVEOUTOFDATEJRES=1 REBOOT=0 WEB_ANALYTICS=0 WEB_JAVA_SECURITY_LEVEL=H WEB_JAVA=1 /lv `"C:\Windows\Temp\jre-8u491-windows-i586_install.log`"" -Wait

Start-Sleep -Seconds 120

if ((Test-Path "C:\Program Files (x86)\Java\latest\jre-1.8") -and (Test-Path "C:\Program Files (x86)\Java\latest\jre-1.8\bin\java.exe")) {
    
    # Install Java Deployment Rule Set
    Copy-Item "$PSScriptRoot\DeploymentRuleSet\cacerts" -Destination "C:\Program Files (x86)\Java\latest\jre-1.8\lib\security" -Force -ErrorAction SilentlyContinue

    Start-Sleep -Seconds 15 

    # Create deployment folder
    if (-not (Test-Path "C:\Windows\Sun\Java\Deployment")) {
        New-Item "C:\Windows\Sun\Java\Deployment" -ItemType Directory -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 1
    }

    Copy-Item "$PSScriptRoot\DeploymentRuleSet\DeploymentRuleSet.jar" -Destination "C:\Windows\Sun\Java\Deployment" -Force -ErrorAction SilentlyContinue

    # Install Java Tracker
    Copy-Item "$PSScriptRoot\Tracker\usagetracker.properties" -Destination "C:\Program Files (x86)\Java\latest\jre-1.8\lib\management" -Force -ErrorAction SilentlyContinue
}