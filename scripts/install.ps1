echo "Preparing to download vim-doge binary..."

$architecture = $env:PROCESSOR_ARCHITECTURE
if ($architecture -eq 'x86') {
  # 32-bit architecture
  $assetName = "vim-doge-helper-windows-i686.zip"
}
else {
  # 64-bit architecture
  $assetName = "vim-doge-helper-windows-x86_64.zip"
}


$rootDir = Resolve-Path -Path ((Split-Path $myInvocation.MyCommand.Path) + "\..")
$version = Get-Content "$rootDir\.version"

$assetPath = "$rootDir\bin\$assetName"
$outFile = "$rootDir\bin\vim-doge.exe"

$downloadUrl = "https://github.com/kkoomen/vim-doge/releases/download/v$version/$assetName"

if (Test-Path $assetName) {
  rm "$assetName"
}

if (Test-Path $outFile) {
  rm "$outFile"
}

Invoke-WebRequest -uri $downloadUrl -OutFile ( New-Item -Path "$assetPath" -Force )
Expand-Archive -LiteralPath "$assetPath" -DestinationPath "$rootDir\bin"
rm "$assetPath"
