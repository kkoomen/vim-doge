param([String] $buildTarget, [String] $outFile)
$rootDir = Resolve-Path -Path ((Split-Path $myInvocation.MyCommand.Path) + "\..")

if (!(Test-Path "$rootDir\bin")) {
  New-Item -Path "$rootDir\bin" -ItemType Directory
}

cd $rootDir

# Build the binary.
if ($outFile -eq "") {
  "$rootDir\node_modules\.bin\caxa" --directory "$rootDir/build" --command "{{caxa}}/node_modules/.bin/node" "{{caxa}}/index.js" --output "./bin/vim-doge.exe"
} else {
  "$rootDir\node_modules\.bin\caxa" --directory "$rootDir/build" --command "{{caxa}}/node_modules/.bin/node" "{{caxa}}/index.js" --output "./bin/$outFile.exe"
}

# Archive the binary.
$outFile = "$rootDir\bin\$outFile.zip"
rm $rootDir\bin\*.zip
echo "==> Archiving $rootDir\bin\vim-doge.exe -> $outFile"
7z a -tzip "$outFile" "$rootDir\bin\vim-doge.exe"

echo "Done building vim-doge binaries"
