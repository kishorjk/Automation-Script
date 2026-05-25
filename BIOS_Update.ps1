# BIOS Password Decoding Logic
$BiosSerial = (Get-CimInstance -ClassName Win32_Bios).SerialNumber

$P1 = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($BiosSerial))

$P2 = $P1.ToLower()

$P3 = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String("UwBBAEIASQBDAA=="))

$P4 = $P3 + $P2


# Model Check
$Model = (Get-CimInstance -ClassName Win32_ComputerSystem).Model

$Executable = (Get-ChildItem -Path "$PSScriptRoot\Repository\$Model\" -Filter "*.exe" | Select-Object -ExpandProperty FullName)


# Runs BIOS Update Utility
Start-Process -Wait "$PSScriptRoot\Repository\Flash64W\Flash64w.exe" -ArgumentList "/b=`"$Executable`" /p=$P4 /s /f /noReboot /bls"


# Reboot required to install BIOS update
Start-Sleep -Seconds 30

Exit 3010
