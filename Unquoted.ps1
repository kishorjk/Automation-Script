# Grab all the registry keys pertinent to services
$result = Get-ChildItem 'HKLM\SYSTEM\CurrentControlSet\Services'
$serviceItems = $result | ForEach-Object { Get-ItemProperty $_.PsPath }

# Iterate through the keys and check for Unquoted ImagePath's
ForEach ($si in $serviceItems) { 

    if ($si.ImagePath -ne $null) { 
        $obj = New-Object -Typename PSObject
        $obj | Add-Member -MemberType NoteProperty -Name Status -Value "Retrieved"

        # There is certainly a way to use the full path here but for now I trim it until I can find time to play with it 
        $obj | Add-Member -MemberType NoteProperty -Name Key -Value $si.PSPath.TrimStart("Microsoft.PowerShell.Core\Registry::")
        $obj | Add-Member -MemberType NoteProperty -Name ImagePath -Value $si.ImagePath

        # Find and Fix Bad Keys for each key object
        # we're looking for keys with spaces in the path and unquoted
        $examine = $obj.ImagePath 

        if (!($examine.StartsWith('"'))) { # Doesn't start with a quote
            if (!($examine.StartsWith('\??'))) { # Some MS Services start with this but don't appear vulnerable
                if ($examine.Contains(" ")) { # If contains space 
                    # when I get here, I can either have a good path with arguments, or a bad path 
                    if ($examine.Contains("-") -or $examine.Contains("/")) { # found arguments, might still be bad
                        
                        # split out arguments
                        $split = $examine -split " ", 0, "simplematch"
                        $split = $split[0] -split "/", 0, "simplematch"
                        $newpath = $split[0].Trim(" ") # Path minus flagged args

                        if ($newpath.Contains(" ")) {
                            # check for unflagged argument
                            $eval = $newpath -Replace '"', '' # drop all quoted arguments 
                            $detunflagged = $eval -split "\\", 0, "simplematch" # split on folder delim
                            
                            if ($detunflagged[-1].Contains(" ")) { # last elem is executable and any unquoted args
                                $fixarg = $detunflagged[-1] -split " ", 0, "simplematch" # split out args 
                                # quote that EXE and insert it back 
                                $quoteexe = '"' + $fixarg[0] + '"'
                                $examine = $examine.Replace($fixarg[0], $quoteexe)
                                $badpath = $true
                            } # end detect unflagged
                            else {
                                $examine = $examine.Replace($newpath, '"' + $newpath + '"')
                                $badpath = $true
                            }
                        } # end if newpath
                        else { # if newpath doesn't have spaces, it was just the argument tripping the check
                            $badpath = $false
                        } # end else
                    } # end if parameter
                    else {
                        # check for unflagged argument
                        $eval = $examine -Replace '"', '' # drop all quoted arguments
                        $detunflagged = $eval -split "\\", 0, "simplematch"
                        
                        if ($detunflagged[-1].Contains(" ")) {
                            $fixarg = $detunflagged[-1] -split " ", 0, "simplematch"
                            $quoteexe = '"' + $fixarg[0] + '"'
                            $examine = $examine.Replace($fixarg[0], $quoteexe)
                            $badpath = $true
                        } # end detect unflagged
                        else { # just a bad path
                            # surround path in quotes
                            $examine = '"' + $examine + '"'
                            $badpath = $true
                        } # end else
                    } # end else
                } # end if contains space
                else { $badpath = $false }
            } # end if starts with \??
            else { $badpath = $false }
        } # end if startswith quote
        else { $badpath = $false }

        # Update Objects
        if ($badpath -eq $false) {
            $obj | Add-Member -MemberType NoteProperty -Name Badkey -Value "No" 
            $obj | Add-Member -MemberType NoteProperty -Name Fixedkey -Value "N/A"
            $obj = $null # clear $obj
        } 

        # Plans to change this check. I believe it can be done more efficiently. But It works for now!
        if ($badpath -eq $true) {
            $obj | Add-Member -MemberType NoteProperty -Name BadKey -Value "Yes"
            
            # sometimes we catch doublequotes
            if ($examine.EndsWith('""')) { $examine = $examine.Replace('""', '"') } 
            $obj | Add-Member -MemberType NoteProperty -Name FixedKey -Value $examine

            if ($obj.BadKey -eq "Yes") {
                # write-Progress -Activity "Fixing $($obj.key)" -Status "working..."
                $regpath = $obj.Fixedkey
                $obj.Status = "Fixed"
                $regkey = $obj.Key.Replace('HKEY_LOCAL_MACHINE', 'HKLM:')
                
                # Comment the next line out to run without modifying the registry
                Set-ItemProperty -Path $regkey -Name 'ImagePath' -Value $regpath
                
                # Alternatively uncomment any line with write-Output or write-object for extra verbosity.
                $obj = $null # clear $obj
            }
        }
    }
}