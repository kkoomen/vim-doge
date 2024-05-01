$RootDir = Resolve-Path -Path ((Split-Path $MyInvocation.MyCommand.Path) + "\..")
$InstallDir = $args[0]

if (-not $InstallDir) {
  $InstallDir = $RootDir
}

$BinDir = "$InstallDir\bin"
$OutFile = "$BinDir\vim-doge-helper.exe"

Write-Host "Installation path: $OutFile"

$Arch = $env:PROCESSOR_ARCHITECTURE
if ($Arch -eq 'x86') {
  # 32-bit
  $AssetName = "vim-doge-helper-windows-i686.zip"
}
else {
  # 64-bit
  $AssetName = "vim-doge-helper-windows-x86_64.zip"
}

$AppVersion = Get-Content "$RootDir\.version"

$AssetPath = "$RootDir\bin\$AssetName"

$DownloadUrl = "https://github.com/kkoomen/vim-doge/releases/download/v$AppVersion/$AssetName"

if (Test-Path $AssetPath) {
  Remove-Item "$AssetPath"
}

if (Test-Path $OutFile) {
  Remove-Item "$OutFile"
}

try {
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls, [Net.SecurityProtocolType]::Tls11, [Net.SecurityProtocolType]::Tls12, [Net.SecurityProtocolType]::Ssl3
  [Net.ServicePointManager]::SecurityProtocol = "Tls, Tls11, Tls12, Ssl3"
  Write-Host "Successfully set SSL/TLS security protocol"
} catch {
  Write-Host "Failed to set SSL/TLS security protocol"
}

Invoke-WebRequest -Uri $DownloadUrl -OutFile ( New-Item -Path "$AssetPath" -Force )
Expand-Archive -LiteralPath $AssetPath -DestinationPath $BinDir
Remove-Item $AssetPath

Write-Host "Successfully downloaded vim-doge-helper"
