$rootDir = Resolve-Path -Path ((Split-Path $myInvocation.MyCommand.Path) + "\..")
$BuildTarget = $args[0]
$OutFile = $args[1]

Set-Location $RootDir
if (!(Test-Path -Path "./bin")) { New-Item -ItemType Directory -Path "./bin" | Out-Null }
if (Test-Path -Path "./bin/vim-doge-helper") { Remove-Item -Path "./bin/vim-doge-helper" }

# Build the binary.
Set-Location "$RootDir/helper"
if ($BuildTarget -ne "") {
  cargo build --release --target $BuildTarget
  Copy-Item -Path "target/$BuildTarget/release/vim-doge-helper" -Destination "../bin/"
}
else {
  cargo build --release
  Copy-Item -Path "target/release/vim-doge-helper" -Destination "../bin/"
}

# Archive the binary.
if ($OutFile -ne "") {
  $OutFile = "$OutFile.zip"

  Set-Location "$RootDir/bin"
  Remove-Item -Path "./*.zip"
  Write-Output "==> Archiving $RootDir/bin/vim-doge-helper -> $RootDir/bin/$OutFile"
  7z a -tzip "$OutFile" vim-doge-helper
}

Write-Output "🎉  Done building vim-doge-helper"
