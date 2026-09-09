<#
.SYNOPSIS
Sets up the Salesforce CLI and optionally the local AI environment for Antigravity.
#>

Write-Host "Starting Antigravity Setup for Salesforce..." -ForegroundColor Cyan

# 1. Check for Salesforce CLI
Write-Host "`n[1/3] Checking for Salesforce CLI (sf)..." -ForegroundColor Yellow
if (Get-Command sf -ErrorAction SilentlyContinue) {
    Write-Host "Success: Salesforce CLI is already installed" -ForegroundColor Green
} else {
    Write-Host "Salesforce CLI not found. Installing via winget... A UAC prompt will appear." -ForegroundColor Magenta
    Start-Process -FilePath "winget" -ArgumentList "install Salesforce.CLI --accept-source-agreements --accept-package-agreements" -Verb RunAs -Wait
}

# 2. Check for Google Antigravity
Write-Host "`n[2/3] Checking for Google Antigravity..." -ForegroundColor Yellow
$agyPath = Join-Path $env:LOCALAPPDATA "Programs\antigravity\Antigravity.exe"
if (Test-Path $agyPath) {
    Write-Host "Success: Google Antigravity is already installed." -ForegroundColor Green
} else {
    Write-Host "Google Antigravity not found. Installing via winget... A UAC prompt will appear." -ForegroundColor Magenta
    Start-Process -FilePath "winget" -ArgumentList "install Google.Antigravity --accept-source-agreements --accept-package-agreements" -Verb RunAs -Wait
}

# 3. Optional Local AI
Write-Host "`n[3/3] OPTIONAL: Local AI Engine (Ollama)" -ForegroundColor Yellow
Write-Host "Antigravity works incredibly fast out-of-the-box using the free cloud model." -ForegroundColor Cyan
Write-Host "However, if you want to prove a point and process your data 100% locally, we can install Ollama and the MCP bridge right now." -ForegroundColor Cyan
$choice = Read-Host "Do you want to download a 5GB local AI model? (Y/N)"

if ($choice -match "^[Yy]") {
    $skipOllama = $false
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:11434" -Method Get -ErrorAction Stop
        if ($response -match "Ollama is running") {
            Write-Host "Ollama is already running. Skipping massive download." -ForegroundColor Green
            $skipOllama = $true
        }
    } catch {
        Write-Host "Ollama is not running. Proceeding with native installation." -ForegroundColor Magenta
    }

    if (-not $skipOllama) {
        if (-not (Get-Command ollama -ErrorAction SilentlyContinue)) {
            Write-Host "Installing Ollama via winget... A UAC prompt will appear." -ForegroundColor Magenta
            Start-Process -FilePath "winget" -ArgumentList "install Ollama.Ollama --accept-source-agreements --accept-package-agreements" -Verb RunAs -Wait
            $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        }
        Start-Process "ollama" -ArgumentList "serve" -WindowStyle Hidden -ErrorAction SilentlyContinue
        Write-Host "Downloading qwen2.5-coder:7b (4.7GB)..." -ForegroundColor Yellow
        ollama pull qwen2.5-coder:7b
    }

    Write-Host "Configuring Antigravity MCP Bridge..." -ForegroundColor Yellow
    $configDir = Join-Path $env:USERPROFILE ".gemini\config"
    if (!(Test-Path -Path $configDir)) { New-Item -ItemType Directory -Path $configDir | Out-Null }
    
    # SAFE MERGE: Read existing config and merge instead of overwriting
    $configPath = Join-Path $configDir "mcp_config.json"
    $existingConfig = @{}
    if (Test-Path $configPath) {
        try {
            $existingConfig = Get-Content $configPath -Raw | ConvertFrom-Json -AsHashtable
            Write-Host "Found existing MCP config. Merging (not overwriting)..." -ForegroundColor Cyan
        } catch {
            Write-Host "Warning: Could not parse existing mcp_config.json. Creating backup..." -ForegroundColor Yellow
            Copy-Item $configPath "$configPath.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
            $existingConfig = @{}
        }
    }

    # Ensure the mcpServers key exists
    if (-not $existingConfig.ContainsKey("mcpServers")) {
        $existingConfig["mcpServers"] = @{}
    }

    # Add the ollama-bridge entry (only if not already present)
    if (-not $existingConfig["mcpServers"].ContainsKey("ollama-bridge")) {
        $existingConfig["mcpServers"]["ollama-bridge"] = @{
            command = "npx"
            args = @("-y", "ollama-mcp")
        }
        $configJson = $existingConfig | ConvertTo-Json -Depth 5
        Set-Content -Path $configPath -Value $configJson
        Write-Host "Success: Ollama Bridge added to MCP config!" -ForegroundColor Green
    } else {
        Write-Host "Ollama Bridge already configured. Skipping." -ForegroundColor Green
    }
} else {
    Write-Host "Skipping local AI installation. Antigravity will use the blazing-fast cloud model." -ForegroundColor Green
}

Write-Host "`n=== Setup Complete! ===" -ForegroundColor Green
