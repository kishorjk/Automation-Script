New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS | Out-Null

$UserProfiles = Get-ChildItem "c:\Users" -Exclude Sabicadmin

foreach ($item in $UserProfiles) {

    $Sddl = (Get-Acl $item.FullName | Select-Object Sddl -ErrorAction SilentlyContinue).Sddl

    $Pattern = 's-\d-(?:\d+){1,14}\d+'

    $Matches = Select-String -Pattern $Pattern -InputObject $Sddl

    $SID = $Matches.Matches.Value

    New-ItemProperty -Path "HKU:\$SID\Software\Microsoft\Office\16.0\*\Security" -Name "VBAWarnings" -Value 1 -PropertyType DWORD -Force -ErrorAction SilentlyContinue

}

Remove-PSDrive HKU | Out-Null