echo "Preparing to download vim-doge-helper binary..."

$Arch = $env:PROCESSOR_ARCHITECTURE
if ($Arch -eq 'x86') {
  # 32-bit architecture
  $AssetName = "vim-doge-helper-windows-i686.zip"
}
else {
  # 64-bit architecture
  $AssetName = "vim-doge-helper-windows-x86_64.zip"
}


$RootDir. = Resolve-Path -Path ((Split-Path $myInvocation.MyCommand.Path) + "\..")
$AppVersion = Get-Content "$RootDir.\.version"

$AssetPath = "$RootDir.\bin\$AssetName"
$OutFile = "$RootDir.\bin\vim-doge-helper.exe"

$DownloadUrl = "https://github.com/kkoomen/vim-doge/releases/download/v$AppVersion/$AssetName"

if (Test-Path $AssetName) {
  rm "$AssetName"
}

if (Test-Path $OutFile) {
  rm "$OutFile"
}

Invoke-WebRequest -uri $DownloadUrl -OutFile ( New-Item -Path "$AssetPath" -Force )
Expand-Archive -LiteralPath "$AssetPath" -DestinationPath "$RootDir.\bin"
rm "$AssetPath"
