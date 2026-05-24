$PrinterName = "SABIC North America Printer"

$PrinterName1 = "SABIC Printer"

$DriverName = "KONICA MINOLTA C554SeriesPCL"

# === STEP 1: Remove Existing Printer (if exists) ===

if (Get-Printer -Name $PrinterName -ErrorAction SilentlyContinue) {

    Remove-Printer -Name $PrinterName -ErrorAction SilentlyContinue

} else {

    Write-Output "No existing printer found with name: $PrinterName"

} 

if (Get-Printer -Name $PrinterName1 -ErrorAction SilentlyContinue) {

    Remove-Printer -Name $PrinterName1 -ErrorAction SilentlyContinue

} else {

    Write-Output "No existing printer found with name: $PrinterName1"

}

#=== STEP 2: Remove Existing Driver (if exists)===

if (Get-PrinterDriver -Name $DriverName -ErrorAction SilentlyContinue) {

    Remove-PrinterDriver -Name $DriverName -ErrorAction SilentlyContinue

} else {

    Write-Output "No existing driver found with name: $DriverName"

}