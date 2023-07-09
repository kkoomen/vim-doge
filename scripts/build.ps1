$RootDir = Resolve-Path -Path ((Split-Path $myInvocation.MyCommand.Path) + "\..")
$BuildTarget = $args[0]
$OutFile = $args[1]

Set-Location $RootDir
if (!(Test-Path -Path "./bin")) { New-Item -ItemType Directory -Path "./bin" | Out-Null }
if (Test-Path -Path "./bin/vim-doge-helper.exe") { Remove-Item -Path "./bin/vim-doge-helper.exe" }

function Get-DirectoryTree {
    param(
        [string]$Path = (Get-Location)
    )

    # Recursive function to get the subdirectories
    function Get-Subdirectories {
        param([string]$Path, [int]$IndentLevel)

        $indentation = '  ' * $IndentLevel
        $subdirectories = Get-ChildItem -Path $Path -Directory

        foreach ($subdir in $subdirectories) {
            Write-Host "$indentation$subdir"
            Get-Subdirectories -Path $subdir.FullName -IndentLevel ($IndentLevel + 1)
        }
    }

    # Main script logic
    if (Test-Path -Path $Path -PathType Container) {
        Write-Host $Path
        Get-Subdirectories -Path $Path -IndentLevel 1
    }
    else {
        Write-Host "Invalid directory path."
    }
}

# Build the binary.
Set-Location "$RootDir/helper"

Get-DirectoryTree

if ($BuildTarget -ne "") {
  cargo.exe build --release --target $BuildTarget
  Copy-Item -Path "target/$BuildTarget/release/vim-doge-helper.exe" -Destination "../bin/"
}
else {
  cargo.exe build --release
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
