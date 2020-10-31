param([String] $buildTarget, [String] $outFile)
$rootDir = Resolve-Path -Path ((Split-Path $myInvocation.MyCommand.Path) + "\..")

# Build the pkg lib prerequisites if needed.
if (!(Test-Path "$rootDir\pkg\lib-es5")) {
  cd $rootDir\pkg
  npm install --no-save; if ($?) {npm run prepare}
}

cd $rootDir

# Build the binary.
node "$rootDir\pkg\lib-es5\bin.js" . -t "$buildTarget" --out-path "$rootDir\bin"

# Archive the binary.
if ($outFile -ne "") {
  $outFile = "$rootDir\bin\$outFile.zip"
  rm $rootDir\bin\*.zip
  echo "==> Archiving $rootDir\bin\vim-doge.exe -> $outFile"
  7z a -tzip "$outFile" "$rootDir\bin\vim-doge.exe"
}

echo "Done building vim-doge binaries"
