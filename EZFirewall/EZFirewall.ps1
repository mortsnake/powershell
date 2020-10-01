Import-Module -Name 'NetSecurity'

Write-Host "Welcome to the script!"
Write-Host "********************`n"

Write-Host "Enter the type of policy to execute on a folder:"
Write-Host "`t1) [B]lock Network Traffic`t2) [A]llow Network Traffic"

$action = Read-Host "`nDefault [B]lock"

$action = $action.ToLower()

If ($action -eq "allow" -or $action -eq "a"){
    $action = "Allow"
} else {
    $action = "Block"
} 

$folderPath = Read-Host "`nEnter complete folder path to change policy of, no trailing slashes"
$folderName = $folderPath.Split("\\").trim("`r`n")

$ruleName = Read-Host ("`nWill name rule with identifier """+$folderName[-1]+""".  `nLeave empty to accept this name, or type a new name to use")

If ($ruleName.length -eq 0){
    $ruleName = $folderName[-1]
}

$ruleName = $ruleName+" Block"

Write-Host "`nEnter network profiles this will apply to:"
Write-Host "`t1)[A]ll`t2)[D]omain`t3)[P]rivate`t4)P[u]blic"

$profile = Read-Host "`nDefault [A]ll"
$profile = $profile.ToLower()

If ($profile.Length -eq 0 -or $profile -eq 1 -or $profile -eq "a" -or $profile -eq "all"){
    $profile = "Any"
} elseif ($profile -eq 2 -or $profile -eq "d" -or $profile -eq "domain"){

} elseif ($profile -eq 3 -or $profile -eq "p" -or $profile -eq "private"){

} elseif ($profile -eq 4 -or $profile -eq "u" -or $profile -eq "public"){

} else {
    Write-Host "Your input was misunderstood, setting profile to 'Any'"
    $profile = "Any"
}


Get-ChildItem -Recurse $folderPath -Filter *.exe | ForEach-Object {
    $exeFullPath = $_.FullName

    New-NetFirewallRule  -DisplayName $ruleName -Program $exeFullPath -Action $action -Profile $profile -Direction Inbound -Enabled True
    New-NetFirewallRule  -DisplayName $ruleName -Program $exeFullPath -Action $action -Profile $profile -Direction Outbound -Enabled True
}