<#
.SYNOPSIS
Sets up the local AI environment for Salesforce administration.
.DESCRIPTION
This script checks for the Salesforce CLI, Antigravity, and Ollama, installs them if they are missing, and downloads the required lightweight local AI model (qwen2.5-coder:7b).
#>

Write-Host "Starting Local AI Setup for Salesforce..." -ForegroundColor Cyan

# 0. Check if Ollama is already running via Docker
Write-Host "`n[0/5] Checking if Ollama is already running (e.g., via LibreChat Docker)..." -ForegroundColor Yellow
$skipOllama = $false
try {
    $response = Invoke-RestMethod -Uri "http://localhost:11434" -Method Get -ErrorAction Stop
    if ($response -match "Ollama is running") {
        Write-Host "Success: Ollama is already running on port 11434." -ForegroundColor Green
        Write-Host "Skipping the native Ollama installation so you don't waste 5GB downloading a duplicate model." -ForegroundColor Cyan
        $skipOllama = $true
    }
} catch {
    Write-Host "Ollama is not running. Proceeding with native installation." -ForegroundColor Magenta
}

# 1. Check for Salesforce CLI
Write-Host "`n[1/5] Checking for Salesforce CLI (sf)..." -ForegroundColor Yellow
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
Write-Host "`n[2/5] Checking for Google Antigravity..." -ForegroundColor Yellow
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

if (-not $skipOllama) {
    # 3. Check for Ollama
    Write-Host "`n[3/5] Checking for Ollama (Local AI Runner)..." -ForegroundColor Yellow
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
    Write-Host "`n[4/5] Downloading the lightweight AI model (qwen2.5-coder:7b)..." -ForegroundColor Yellow
    Write-Host "This might take a few minutes depending on your internet connection." -ForegroundColor Cyan
    # Start the Ollama app in the background just in case it isn't running
    Start-Process "ollama" -ArgumentList "serve" -WindowStyle Hidden -ErrorAction SilentlyContinue

    ollama pull qwen2.5-coder:7b
}

# 5. Hijack Antigravity Endpoint
Write-Host "`n[5/5] Forcing Antigravity to use local Ollama so you don't have to click through settings..." -ForegroundColor Yellow
if (!(Test-Path -Path "..\.agents")) { New-Item -ItemType Directory -Path "..\.agents" | Out-Null }
$configJson = @{
    api_endpoint = "http://localhost:11434"
    default_model = "qwen2.5-coder:7b"
} | ConvertTo-Json
Set-Content -Path "..\.agents\config.json" -Value $configJson
Write-Host "Success: Local endpoint configured. No UI clicking required." -ForegroundColor Green

Write-Host "`n=== Setup Complete! ===" -ForegroundColor Green
