$asciiTitle = @"

  ___        _                    _           _   
 / _ \ _ __ (_) ___  _ __     ___| |__   __ _| |_ 
| | | | '_ \| |/ _ \| '_ \   / __| '_ \ / _` | __|
| |_| | | | | | (_) | | | | | (__| | | | (_| | |_ 
 \___/|_| |_|_|\___/|_| |_|  \___|_| |_|\__,_|\__|


"@

Write-Host $asciiTitle

Write-Host "Running onion-chat Windows installer"

$remoteAppPath = "https://github.com/AlexLopEx03/test/releases/latest/download/onion-chat.exe"
$remoteTorPath = "https://github.com/AlexLopEx03/test/releases/latest/download/tor-expert-bundle-windows-x86_64.tar.gz"

$localDirPath = "$env:USERPROFILE\AppData\Local\Onion-chat"
$localAppPath = "$localDirPath\onion-chat.exe"
$localSessionsDirPath = "$localDirPath\sessions"
$localCompressedTorFolderPath = "$localDirPath\tor-expert-bundle-windows-x86_64.tar.gz"
$localTorFolderPath = "$localDirPath\tor-expert-bundle-windows-x86_64"
$localTorPath = "$localDirPath\tor-expert-bundle-windows-x86_64\tor\tor.exe"
$localConfigPath = "$localDirPath\config.yaml"

try{
    mkdir "$localDirPath" -ErrorAction Stop
}catch{
    Write-Error "App folder $localDirPath already exists"
    Write-Host "Try to uninstall and reinstall the app"
    return
}

Write-Host ""

Write-Host "Downloading and setting App files (30 MB), might be slower than usual, it can take up to 2 minutes..."

# Invoke-WebRequest -Uri "$remoteAppPath" -OutFile "$localAppPath"
curl -o "$localAppPath" "$remoteAppPath"

# Remove-Item "$localDirPath\onion-chat.exe:Zone.Identifier"

# Invoke-WebRequest -Uri "$remoteTorPath" -OutFile "$localCompressedTorFolderPath"
curl -o "$localCompressedTorFolderPath" "$remoteTorPath"

try{
    mkdir "$localTorFolderPath"

    tar -xzf $localCompressedTorFolderPath -C $localTorFolderPath

    mkdir "$localSessionsDirPath"

    Remove-Item "$localCompressedTorFolderPath"
}catch{
    Write-Error "Error while creating local folders"
}

Write-Host ""

Write-Host "Creating $localConfigPath"

$config = @"
app:
  platform: windows
  appDir: $localDirPath
  appSessionsDir: $localSessionsDirPath
  appPath: $localAppPath
  torPath: $localTorPath
"@

try{
	Set-Content -Path $localConfigPath -Value $config
}catch{
	Write-Error "Error while creating config.yaml file"
}

try{
	Write-Host "Setting environment variables..."

	# ${env:onion-chat} = $localAppPath
	# [Environment]::SetEnvironmentVariable("onion-chat", "$localAppPath", "User")

	# ${env:Path} += ";$localDirPath"
	# [Environment]::SetEnvironmentVariable("Path", ${env:Path} + ";$localDirPath", "User")
    $userVariablesPath = [Environment]::GetEnvironmentVariable("Path", "User")
    [Environment]::SetEnvironmentVariable("Path", $userVariablesPath + ";$localDirPath", "User")
}catch{
	Write-Error "Error while setting environment variables"
}

Write-Host ""

Write-Host "onion-chat successfully installed at $localDirPath" -ForegroundColor Green

Write-Host ""

Write-Host "You might need to restart the terminal or IDE to be able to use onion-chat"

Write-Host "Run onion-chat --help to check available commands and syntax"
