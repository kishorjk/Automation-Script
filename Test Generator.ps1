Start-Process -FilePath "$PSScriptRoot\TG2e_TestGen-r2.4.20_Installer.exe" -ArgumentList "/VERYSILENT" -Wait

Start-Sleep -Seconds 30

$base = "HKLM\SOFTWARE\WOW6432Node\FCO\Test Generator II"

$DBUserName = [byte[]](
    0x00,0x00,0xb2,0x00,0xcf,0x00,0xc0,0x00,0x44,0x00,0x1f,0x00,0x1e,0x00,0x1d,0x20
)

$DBPassword = [byte[]](
    0x51,0x00,0xf9,0x00,0x28,0x00,0xd4,0x00,0x28,0x00,0x69,0x00,0xa1,0x00,0x20,0x00,
    0xc0,0x00,0x0d,0x00,0xad,0x00,0x57,0x00,0x48,0x00,0x57,0x00,0x60,0x01,0xaf,0x00
)

if (-not (Test-Path $base)) {
    New-Item -Path $base -Force | Out-Null
}

New-ItemProperty -Path $base -Name "DBType" -Value "5" -PropertyType String -Force

New-ItemProperty -Path $base -Name "DBName" -Value "DB TG PROD" -PropertyType String -Force

New-ItemProperty -Path $base -Name "DBServer" -Value "ss-hou-dbs-112\SQL2022" -PropertyType String -Force

New-ItemProperty -Path $base -Name "DBPort" -Value "54588" -PropertyType String -Force

New-ItemProperty -Path $base -Name "DBUserName" -Value $DBUserName -PropertyType Binary -Force

New-ItemProperty -Path $base -Name "DBPassword" -Value $DBPassword -PropertyType Binary -Force