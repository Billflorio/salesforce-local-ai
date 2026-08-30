Write-Host "======================================================"
Write-Host "   Zero Cost AI Solutions - One-Click Setup Script"
Write-Host "======================================================"
Write-Host ""
Write-Host "!!! WARNING & DISCLAIMER !!!" -ForegroundColor Red
Write-Host "This script and repository are for educational/demo purposes ONLY." -ForegroundColor Yellow
Write-Host "DO NOT use this with a Production Salesforce Org. Use a Sandbox or Dev Org." -ForegroundColor Yellow
Write-Host "This project will not be maintained. By continuing, you take FULL responsibility" -ForegroundColor Yellow
Write-Host "for any actions executed by this script or the local AI environment." -ForegroundColor Yellow
Write-Host ""
$agree = Read-Host "Type 'I AGREE' to continue, or press CTRL+C to cancel"
if ($agree -ne "I AGREE") {
    Write-Host "Setup aborted." -ForegroundColor Red
    exit
}
Write-Host ""
try {
    $sfCheck = sf --version 2>&1
    if ($LASTEXITCODE -ne 0 -and $sfCheck -match "is not recognized") {
        throw "Not installed"
    }
    Write-Host "[OK] Salesforce CLI is installed." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Salesforce CLI (sf) is not installed." -ForegroundColor Red
    Write-Host "The Salesforce CLI is required to generate the OAuth tokens for LibreChat."
    $installSf = Read-Host "Would you like me to install the Salesforce CLI for you now using Winget? (Y/N)"
    if ($installSf -match "^[Yy]") {
        Write-Host "Downloading and installing Salesforce CLI... This may take a moment." -ForegroundColor Cyan
        winget install Salesforce.CLI --silent --accept-package-agreements --accept-source-agreements
        Write-Host "Installation complete! IMPORTANT: You must restart your terminal for the 'sf' command to be recognized." -ForegroundColor Yellow
        Write-Host "After restarting your terminal, run this script again." -ForegroundColor Yellow
    } else {
        Write-Host "Please install the Salesforce CLI manually: https://developer.salesforce.com/tools/salesforcecli" -ForegroundColor Yellow
    }
    exit
}

# 2. Check for Docker
try {
    $dockerCheck = docker info 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Docker is installed but not running." -ForegroundColor Yellow
        Write-Host "Please open the 'Docker Desktop' application from your Start Menu, wait for it to finish starting, and run this script again." -ForegroundColor Yellow
        exit
    }
    Write-Host "[OK] Docker is running." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Docker Desktop is not installed." -ForegroundColor Red
    Write-Host "Docker is required to run the local AI environment."
    $installDocker = Read-Host "Would you like me to attempt to install Docker Desktop for you now using Winget? (Y/N)"
    if ($installDocker -match "^[Yy]") {
        Write-Host "Downloading and installing Docker Desktop... This may take a few minutes." -ForegroundColor Cyan
        winget install Docker.DockerDesktop --silent --accept-package-agreements --accept-source-agreements
        Write-Host "Installation complete! IMPORTANT: You must now restart your computer for Docker to function properly." -ForegroundColor Yellow
        Write-Host "After restarting, open Docker Desktop, accept the terms, let it start, and then run this script again." -ForegroundColor Yellow
    } else {
        Write-Host "Please follow the instructions in 1-prerequisites\README.md to install Docker manually." -ForegroundColor Yellow
    }
    exit
}

# 3. Setup LibreChat Environment File
$envFile = ".\3-librechat-config\.env"
if (-Not (Test-Path $envFile)) {
    Copy-Item ".\3-librechat-config\.env.example" $envFile
    Write-Host "[OK] Created LibreChat .env file." -ForegroundColor Green
}

# 4. Start Docker Compose
Write-Host ""
Write-Host "Starting the AI Environment (LibreChat, MongoDB, Meilisearch, Ollama)..."
Write-Host "This may take a few minutes the first time as it downloads the AI model."
cd .\3-librechat-config
docker-compose up -d

Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host " SUCCESS! Your local AI environment is booting up." -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Wait about 60 seconds for the database to initialize."
Write-Host "2. Open your web browser and go to: http://localhost:3080"
Write-Host "3. Create your admin account."
Write-Host "4. Follow the guide in 4-salesforce-mcp\README.md to connect Salesforce!"
