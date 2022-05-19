echo "Preparing to download vim-doge binary..."

$rootDir = Resolve-Path -Path ((Split-Path $myInvocation.MyCommand.Path) + "\..")
$version = Get-Content "$rootDir\.version"
$assetName = "vim-doge-win64.zip"
$assetPath = "$rootDir\bin\$assetName"
$outFile = "$rootDir\bin\vim-doge.exe"
$downloadUrl = "https://github.com/kkoomen/vim-doge/releases/download/$version/$assetName"

if (Test-Path $assetName) {
  rm "$assetName"
}

if (Test-Path $outFile) {
  rm "$outFile"
}

try {
  Invoke-WebRequest -uri $downloadUrl -OutFile ( New-Item -Path "$assetPath" -Force )
  Expand-Archive -LiteralPath "$assetPath" -DestinationPath "$rootDir\bin"
  rm "$assetPath"
} catch {
  echo "No release found for vim-doge for Windows."
  echo "This is due to a bug in node-gyp which doesn't allow vim-doge to be build for Windows."
  echo ""
  echo "Currently, the latest stable release for Windows is v3.11.0."
  echo ""
  echo "HOW TO INSTALL v3.11.0:"
  echo "- Download the latest release from: https://github.com/kkoomen/vim-doge/releases/download/v3.11.0/vim-doge-win64.zip"
  echo "- Unzip the vim-doge-win64.zip"
  echo "- Put the vim-doge binary inside ~/path/to/vim-doge/bin/ (e.g. vim-plug would be: ~/.vim/plugged/vim-doge/bin/)"
}
