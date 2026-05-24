$Dependencies = Get-ChildItem -Path "$PSScriptRoot\dep" -Filter "*.appx*" | Select-Object -ExpandProperty FullName

$package = "$PSScriptRoot\Microsoft.WindowsAppRuntime.1.7_7000.617.2103.0_x64.Msix"

$package2 = "$PSScriptRoot\Microsoft.Windows.Photos_2025.11090.30001.0_neutral_8wekyb3d8bbwe.Msixbundle"

Get-AppxPackage -AllUsers -Name "*photos*" | Remove-AppxPackage -AllUsers -Confirm:$false

Add-AppxProvisionedPackage -Online -PackagePath $package -SkipLicense

Add-AppxProvisionedPackage -Online -PackagePath $package2 -DependencyPackagePath $Dependencies -SkipLicense

Get-AppxPackage -AllUsers -Name "*photos*"