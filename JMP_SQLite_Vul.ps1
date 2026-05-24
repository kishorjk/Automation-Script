$Paths = @("C:\Program Files\JMP\JMP\18\DLLs\sqlite3.dll", "C:\Program Files\JMP\JMPPRO\18\DLLs\sqlite3.dll")

foreach ($Path in $Paths)
{
    if (Test-Path -Path $Path)
    {
        Remove-Item -Path $Path -Force -ErrorAction SilentlyContinue
    }
}