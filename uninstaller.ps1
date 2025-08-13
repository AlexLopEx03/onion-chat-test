Write-Host ""

Write-Host "Running onion-chat Windows uninstaller"

$localAppPath = "$env:USERPROFILE\AppData\Local\Onion-chat"

try{
    rmdir "$localAppPath" -Recurse -Force -ErrorAction Stop
}catch{
    Write-Error "Error while tried to remove the app folder at $localAppPath"
    return
}

try{
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $variables = $userPath -split ';'

    $newPath = ""
    for($i = 0; $i -lt $variables.Length; $i++){
        if($variables[$i] -ne $localAppPath -and $variables[$i] -ne ""){
            if($newPath -ne ""){
                $newPath += ";"
            }
            $newPath += $variables[$i]
        }
    }
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
}catch{
    Write-Error "Error while tried to remove environment variable"
}

Write-Host "onion-chat successfully uninstalled"
