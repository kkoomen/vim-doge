param([String] $buildTarget, [String] $outFile)
$rootDir = Split-Path $myInvocation.MyCommand.Path
# $winVersion = switch ([IntPtr]::Size -eq 4) {
#   $true  {"32"}
#   $false {"64"}
# }
$winVersion = "64"
$assetName = "vim-doge-win$winVersion.zip"
$assetPath = "$rootDir\bin\$assetName"

# Build the pkg lib prerequisites if needed.
if (!(Test-Path "$rootDir\pkg\lib-es5")) {
  cd $rootDir\pkg
  npm install --no-save; if ($?) {npm run prepare}
}

# Build the binary.
node "$rootDir\pkg\lib-es5\bin.js" . -t "$buildTarget" --out-path "$rootDir\bin"

# Archive the binary.
if ($outFile -ne "") {
  $outFile = "$rootDir\bin\$outFile.exe"
  cd "$rootDir\bin"
  rm -f *.zip
  echo "==> Archiving $rootDir\bin\vim-doge.exe -> $rootDir\bin\$outFile"
  zip "$outFile" vim-doge.exe
}

echo "Done building vim-doge binaries"
