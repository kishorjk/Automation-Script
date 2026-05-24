New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS | Out-Null

$UserProfiles = Get-ChildItem "c:\Users" -Exclude Sabicadmin

foreach ($item in $UserProfiles)
{
    $Sddl = (Get-Acl $item.FullName | Select-Object Sddl -ErrorAction SilentlyContinue).Sddl

    $Pattern = 'S-\d-(?:\d+) (1,14)\d+'

    $Matches = Select-String -Pattern $Pattern -InputObject $Sddl

    $SID = $Matches.Matches.Value

    New-ItemProperty -Path "HKU:\$SID\Software\Policies\Microsoft\office\16.0\common" -Name "fbabehavior" -Value 0 -PropertyType DWORD -Force -ErrorAction SilentlyContinue
}

Remove-PSDrive HKU | Out-Null