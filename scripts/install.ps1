Write-Host "[vim-doge] Preparing to download vim-doge-helper binary..."

$Arch = $env:PROCESSOR_ARCHITECTURE
if ($Arch -eq 'x86') {
  # 32-bit
  $AssetName = "vim-doge-helper-windows-i686.zip"
}
else {
  # 64-bit
  $AssetName = "vim-doge-helper-windows-x86_64.zip"
}

$RootDir = Resolve-Path -Path ((Split-Path $myInvocation.MyCommand.Path) + "\..")
$AppVersion = Get-Content "$RootDir\.version"

$AssetPath = "$RootDir\bin\$AssetName"
$OutFile = "$RootDir\bin\vim-doge-helper.exe"

$DownloadUrl = "https://github.com/kkoomen/vim-doge/releases/download/v$AppVersion/$AssetName"

if (Test-Path $AssetName) {
  Remove-Item "$AssetName"
}

if (Test-Path $OutFile) {
  Remove-Item "$OutFile"
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls, [Net.SecurityProtocolType]::Tls11, [Net.SecurityProtocolType]::Tls12, [Net.SecurityProtocolType]::Ssl3
[Net.ServicePointManager]::SecurityProtocol = "Tls, Tls11, Tls12, Ssl3"

Invoke-WebRequest -Uri $DownloadUrl -OutFile ( New-Item -Path "$AssetPath" -Force )
Expand-Archive -LiteralPath "$AssetPath" -DestinationPath "$RootDir.\bin"
Remove-Item "$AssetPath"

Write-Host "[vim-doge] Successfully downloaded vim-doge-helper"
