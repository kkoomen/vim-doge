echo "Preparing to download vim-doge binary..."

$rootDir = Resolve-Path -Path ((Split-Path $myInvocation.MyCommand.Path) + "\..")
$version = Get-Content "$rootDir\.version"
$assetName = "vim-doge-win64.zip"
$assetPath = "$rootDir\bin\$assetName"
$outFile = "$rootDir\bin\vim-doge.exe"

if (Test-Path $assetName) {
  rm "$assetName"
}

if (Test-Path $outFile) {
  rm "$outFile"
}

Invoke-WebRequest -uri "https://github.com/kkoomen/vim-doge/releases/download/$version/$assetName" -OutFile ( New-Item -Path "$assetPath" -Force )
Expand-Archive -LiteralPath "$assetPath" -DestinationPath "$rootDir\bin"
rm "$assetPath"
