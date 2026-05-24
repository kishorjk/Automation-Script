$basePath = "HKLM\SOFTWARE\Policies\Microsoft\Edge\VideoCaptureAllowedUrls"

$newUrl = "https://sabic.voovio.cloud/"

$existing = @()

if (Test-Path $basePath) {

    $props = Get-ItemProperty -Path $basePath

    foreach ($p in $props.PSObject.Properties) {

        if ($p.Name -match '^\d+$') {

            $existing += $p.Value

        }
    }
}

if ($existing -notcontains $newUrl) {

    $existing += $newUrl

    Remove-Item -Path $basePath -Recurse -Force -ErrorAction SilentlyContinue

    New-Item -Path $basePath -Force | Out-Null

    $i = 1

    foreach ($url in $existing) {

        New-ItemProperty -Path $basePath -Name $i -Value $url -PropertyType String -Force | Out-Null

        $i++
    }
}