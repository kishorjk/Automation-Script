New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS | Out-Null

$UserProfiles = Get-ChildItem "c:\Users" -Exclude Sabicadmin

foreach ($item in $UserProfiles)

{

$Sddl = (Get-Acl $item.FullName | Select-Object -ExpandProperty Sddl -ErrorAction SilentlyContinue)

$Pattern = 'S-1-5-21-\d+-\d+-\d+-\d+'

$Matches = Select-String -Pattern $Pattern -InputObject $Sddl

$SID = $Matches.Matches.Value

New-ItemProperty -Path "HKU:\$SID\Software\Microsoft\Office\16.0\Excel\Security" -Name "AccessVBOM" -Value 1 -PropertyType DWORD -Force -ErrorAction SilentlyContinue

}

Remove-PSDrive HKU | Out-Null