param([String] $BuildTarget)
param([String] $OutFile)
$RootDir = Resolve-Path -Path ((Split-Path $myInvocation.MyCommand.Path) + "\..")

Set-Location $RootDir
if (!(Test-Path -Path "./bin")) { New-Item -ItemType Directory -Path "./bin" | Out-Null }
if (Test-Path -Path "./bin/vim-doge-helper.exe") { Remove-Item -Path "./bin/vim-doge-helper.exe" }

# Build the binary.
Set-Location "$RootDir/helper"
if ($BuildTarget -ne "") {
  cargo build --release --target $BuildTarget
  Copy-Item -Path "target/$BuildTarget/release/vim-doge-helper.exe" -Destination "../bin/"
}
else {
  cargo build --release
  Copy-Item -Path "target/release/vim-doge-helper.exe" -Destination "../bin/"
}

# Archive the binary.
if ($OutFile -ne "") {
  $OutFile = "$OutFile.zip"

  Set-Location "$RootDir/bin"
  Remove-Item -Path "./*.zip"
  Write-Output "==> Archiving $RootDir/bin/vim-doge-helper.exe -> $RootDir/bin/$OutFile"
  7z a -tzip "$OutFile" "vim-doge-helper.exe"
}

Write-Output "🎉  Done building vim-doge-helper"
