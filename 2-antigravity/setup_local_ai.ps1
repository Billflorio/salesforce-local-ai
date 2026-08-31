<#
.SYNOPSIS
Sets up the local AI environment for Salesforce administration.
.DESCRIPTION
This script checks for the Salesforce CLI, Antigravity, and Ollama, installs them if they are missing, and downloads the required lightweight local AI model (qwen2.5-coder:7b).
#>

Write-Host "Starting Local AI Setup for Salesforce..." -ForegroundColor Cyan

# 1. Check for Salesforce CLI
Write-Host "`n[1/4] Checking for Salesforce CLI (sf)..." -ForegroundColor Yellow
if (Get-Command sf -ErrorAction SilentlyContinue) {
    $sfVersion = (sf --version) -join " "
    Write-Host "Success: Salesforce CLI is already installed ($sfVersion)" -ForegroundColor Green
} else {
    Write-Host "Salesforce CLI not found. Installing via winget..." -ForegroundColor Magenta
    winget install Salesforce.CLI --accept-source-agreements --accept-package-agreements
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Warning: Failed to install Salesforce CLI automatically. Please download it from https://developer.salesforce.com/tools/salesforcecli" -ForegroundColor Red
    } else {
        Write-Host "Success: Salesforce CLI installed." -ForegroundColor Green
    }
}

# 2. Check for Google Antigravity
Write-Host "`n[2/4] Checking for Google Antigravity..." -ForegroundColor Yellow
$agyPath = Join-Path $env:LOCALAPPDATA "Programs\antigravity\Antigravity.exe"
if (Test-Path $agyPath) {
    Write-Host "Success: Google Antigravity is already installed." -ForegroundColor Green
} else {
    Write-Host "Google Antigravity not found. Installing via winget..." -ForegroundColor Magenta
    winget install Google.Antigravity --accept-source-agreements --accept-package-agreements
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Warning: Failed to install Antigravity automatically. Please download it from https://antigravity.google/" -ForegroundColor Red
    } else {
        Write-Host "Success: Google Antigravity installed." -ForegroundColor Green
    }
}

# 3. Check for Ollama
Write-Host "`n[3/4] Checking for Ollama (Local AI Runner)..." -ForegroundColor Yellow
if (Get-Command ollama -ErrorAction SilentlyContinue) {
    Write-Host "Success: Ollama is already installed." -ForegroundColor Green
} else {
    Write-Host "Ollama not found. Installing via winget..." -ForegroundColor Magenta
    winget install Ollama.Ollama --accept-source-agreements --accept-package-agreements
    
    # Reload environment variables for the current process so 'ollama' command works immediately
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    
    if (Get-Command ollama -ErrorAction SilentlyContinue) {
        Write-Host "Success: Ollama installed successfully." -ForegroundColor Green
    } else {
        Write-Host "Ollama installed, but you may need to close and reopen your terminal for it to be recognized." -ForegroundColor Yellow
    }
}

# 4. Pull the required model
Write-Host "`n[4/4] Downloading the lightweight AI model (qwen2.5-coder:7b)..." -ForegroundColor Yellow
Write-Host "This might take a few minutes depending on your internet connection." -ForegroundColor Cyan
# Start the Ollama app in the background just in case it isn't running
Start-Process "ollama" -ArgumentList "serve" -WindowStyle Hidden -ErrorAction SilentlyContinue

ollama pull qwen2.5-coder:7b

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n=== Setup Complete! ===" -ForegroundColor Green
    Write-Host "Your local AI environment is ready."
    Write-Host "Next steps:"
    Write-Host "1. Run 'sf org login web' to connect to your Salesforce Org."
    Write-Host "2. Open Antigravity in this folder and start asking it to write Apex or deploy Custom Objects!"
} else {
    Write-Host "`nError downloading the model. Ensure Ollama is running and try running 'ollama pull qwen2.5-coder:7b' manually." -ForegroundColor Red
}
