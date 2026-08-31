#!/bin/bash
echo "==============================================="
echo "Starting Zero-Cost AI Installation (Linux/Mac)"
echo "==============================================="

# 1. Install Ollama
echo ""
echo "--> Installing Ollama AI Engine..."
curl -fsSL https://ollama.com/install.sh | sh

# 2. Pull the Qwen model
echo ""
echo "--> Downloading qwen2.5-coder:7b model (4.7GB)..."
echo "This may take a while depending on your internet connection."
ollama pull qwen2.5-coder:7b

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

echo ""
echo "==============================================="
echo "Installation Complete!"
echo "You can now run 'ollama serve' in the background,"
echo "and use Antigravity to orchestrate your local models."
echo "==============================================="
