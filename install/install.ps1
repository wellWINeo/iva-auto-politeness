#Requires -RunAsAdministrator

param(
    [string]$PythonVersion = "3.13.0",  # Python version to install
    [string]$AppName = "IvaAutoPoliteness", # App's name
    [string]$InstallPath = "$env:ProgramFiles\$AppName",  # Default install location
    [string]$SourceDir = "$PSScriptRoot\..\src"  # Path to your app's source files
)

# Function to refresh environment variables
function Refresh-Environment {
    foreach ($level in "Machine", "User") {
        [Environment]::GetEnvironmentVariables($level).GetEnumerator() | ForEach-Object {
            if ($_.Key -eq 'PATH') {
                $combinedPath = [Environment]::GetEnvironmentVariable($_.Key, $level)
                $newPath = ($combinedPath -split ';' | Select-Object -Unique) -join ';'
                [Environment]::SetEnvironmentVariable($_.Key, $newPath, $level)
            }
        }
    }
}

# 1. Check if Python is installed
try {
    $python = Get-Command python -ErrorAction Stop
    Write-Host "Python found at $($python.Source)"
} catch {
    Write-Host "Python not found. Installing Python $PythonVersion..."
    $installer = "$env:TEMP\python_installer.exe"
    
    # Download Python installer
    Invoke-WebRequest -Uri "https://www.python.org/ftp/python/$PythonVersion/python-$PythonVersion-amd64.exe" `
        -OutFile $installer -UseBasicParsing
    
    # Install Python silently
    Start-Process -Wait -FilePath $installer -ArgumentList @(
        "/quiet",
        "InstallAllUsers=1",
        "PrependPath=1",
        "AssociateFiles=0",
        "Shortcuts=0"
    )
    
    # Clean up installer
    Remove-Item -Path $installer
    Refresh-Environment
}

# 2. Install dependencies
Write-Host "Installing dependencies..."
python -m pip install --upgrade pip
python -m pip install -r "$PSScriptRoot\..\requirements.txt"

# 3. Create installation directory
if (-not (Test-Path $InstallPath)) {
    Write-Host "Creating installation directory at $InstallPath"
    New-Item -Path $InstallPath -ItemType Directory | Out-Null
}

# 4. Copy application files
Write-Host "Copying application files from $SourceDir to $InstallPath..."
Copy-Item -Path "$SourceDir\*" -Destination $InstallPath -Recurse -Force

Write-Host "Installation completed successfully!"
Write-Host "A shortcut has been created on your desktop."