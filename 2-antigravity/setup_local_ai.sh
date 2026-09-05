#!/bin/bash
echo "==============================================="
echo "Starting Zero-Cost AI Installation (Linux/Mac)"
echo "==============================================="

# 0. Check if Docker is already running Ollama
echo ""
echo "--> Checking if Ollama is already running on this machine..."
if curl -s http://localhost:11434 | grep -q "Ollama is running"; then
    echo "Good news: Ollama is already running on port 11434 (probably from your LibreChat Docker setup)."
    echo "Skipping the native installation so you don't waste 5GB downloading a duplicate model like a chooch."
else
    # 1. Install Ollama
    echo ""
    echo "--> Installing native Ollama AI Engine..."
    curl -fsSL https://ollama.com/install.sh | sh

    # 2. Pull the Qwen model
    echo ""
    echo "--> Downloading qwen2.5-coder:7b model (4.7GB)..."
    echo "This may take a while depending on your internet connection."
    ollama pull qwen2.5-coder:7b
fi

# 3. Check for Salesforce CLI
echo ""
echo "--> Checking for Salesforce CLI (sf)..."
if ! command -v sf &> /dev/null
then
    echo "Salesforce CLI not found. Attempting to install via npm..."
    if ! command -v npm &> /dev/null
    then
        echo "WARNING: npm is not installed. Skipping Salesforce CLI installation."
        echo "Please install Node.js/npm manually, then run: npm install -g @salesforce/cli"
    else
        sudo npm install -g @salesforce/cli
    fi
else
    echo "Salesforce CLI is already installed!"
fi

# 4. Hijack Antigravity Endpoint
echo ""
echo "--> Forcing Antigravity to use local Ollama so you don't have to click through settings..."
mkdir -p ../.agents
cat << 'INNER_EOF' > ../.agents/config.json
{
  "api_endpoint": "http://localhost:11434",
  "default_model": "qwen2.5-coder:7b"
}
INNER_EOF
echo "Success: Local endpoint configured. No UI clicking required."

echo ""
echo "==============================================="
echo "Installation Complete!"
echo "You can now run 'ollama serve' in the background,"
echo "and use Antigravity to orchestrate your local models."
echo "==============================================="
