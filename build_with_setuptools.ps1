# Cross-platform script to activate Python virtual environment
# Set project directory and virtual environment path relative to user home
#              ------- User 
#              v
# C:\Users\USERNAME\code\py\cythonraylib
#                               ^--- Project folder(setup.py & main.py inside)
# C:\Users\USERNAME\code\py\.venv
#                               ^--- Python virtual env

if ($IsWindows -or $env:OS -match "Windows") {
    $TOPDIR = "C:\Users\USERNAME\code\py"
} else {
    $TOPDIR = "/home/USERNAME/code/py"
}
$PROJECT_FOLDER = "cythonraylib"
$PYX_FILE = "raylib_wrapper"
$LIB_FILE = "raylib_wrapper" # will have an extension .so or .pyd depending on OS

$ProjectDir = Join-Path $TOPDIR $PROJECT_FOLDER

#Set a virtual env path for Python (this one is relative to the $TOPDIR)
$VenvDir = Join-Path $TOPDIR ".venv"
#If there is a path for a virtual env, use the path and activate
if (([string]::IsNullOrEmpty($VenvDir)) -and (Test-Path -Path $VenvDir -IsValid)) {
	# Detect platform and set appropriate activation path
	if ($IsWindows -or $env:OS -match "Windows") {
    	# Windows
    	$VenvActivate = Join-Path $VenvDir "Scripts\Activate.ps1"
    	Write-Host "Running on Windows, using: $VenvActivate"
	} else {
    	# Linux/macOS
    	$VenvActivate = Join-Path $VenvDir "bin/activate"
    	# PowerShell can't source scripts like bash
    	Write-Host "Running on Linux/macOS, using: $VenvActivate"
    	$env:VIRTUAL_ENV = $VenvDir
			$env:PATH = "$VenvDir/bin$([IO.Path]::PathSeparator)$env:PATH"
    	Write-Host "Activated environment by modifying PATH"
	}
	# If we're on Windows, activate the environment
	if (Test-Path $VenvActivate -PathType Leaf) {
	    if ($IsWindows -or $env:OS -match "Windows") {
	        & $VenvActivate
	    }
	}
}

Set-Location -Path $ProjectDir
Write-Host "Changed directory to: $ProjectDir"

# Run python
Write-Host "Running Python commands..."
python setup.py build
# Optional step (move or copy the .pyd/.so to any folder conveniently located)
if ($IsWindows -or $env:OS -match "Windows") {
	Copy-Item -Force build/lib.win-amd64-cpython-312/$PYX_FILE.cp312-win_amd64.pyd modules/$LIB_FILE.pyd
} else {
    # Linux/macOS
	Copy-Item -Force build/lib.linux-x86_64-cpython-312/$PYX_FILE.cpython-312-x86_64-linux-gnu.so modules/$LIB_FILE.so
}
#python main.py
