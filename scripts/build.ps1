param([String] $buildTarget, [String] $outFile)
$rootDir = Resolve-Path -Path ((Split-Path $myInvocation.MyCommand.Path) + "\..")
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

Write-Host "--------- vim-doge.exe ---------"
Write-Host (Get-ChildItem -Path "$rootDir" -Filter "vim-doge.exe" -Recurse -ErrorAction SilentlyContinue -Force | %{$_.FullName})
Write-Host "--------- vim-doge.exe ---------"

# Archive the binary.
if ($outFile -ne "") {
  $outFile = "$rootDir\bin\$outFile$winVersion.zip"
  rm $rootDir\bin\*.zip
  echo "==> Archiving $rootDir\bin\vim-doge.exe -> $outFile"
  7z a -tzip "$outFile" "$rootDir\bin\vim-doge.exe"
}

echo "Done building vim-doge binaries"
