$RootDir = Resolve-Path -Path ((Split-Path $myInvocation.MyCommand.Path) + "\..")
$BuildTarget = $args[0]
$OutFile = $args[1]

Set-Location $RootDir
if (!(Test-Path -Path "./bin")) { New-Item -ItemType Directory -Path "./bin" | Out-Null }
if (Test-Path -Path "./bin/vim-doge-helper.exe") { Remove-Item -Path "./bin/vim-doge-helper.exe" }

# Build the binary.
Set-Location "$RootDir/helper"

if ($BuildTarget) {
  cargo build --release --target "$BuildTarget"
  Copy-Item -Path "target/$BuildTarget/release/vim-doge-helper.exe" -Destination "../bin/"
}
else {
  cargo build --release
  Copy-Item -Path "target/release/vim-doge-helper.exe" -Destination "../bin/"
}

# Archive the binary.
if ($OutFile) {
  $OutFile = "$OutFile.zip"

  Set-Location "$RootDir/bin"
  Remove-Item -Path "./*.zip"
  Write-Host "[vim-doge] Archiving $RootDir/bin/vim-doge-helper.exe -> $RootDir/bin/$OutFile"
  7z a -tzip "$OutFile" "vim-doge-helper.exe"
}

Write-Host "[vim-doge] Done building vim-doge-helper"
