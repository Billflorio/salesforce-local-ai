#!/bin/bash
echo "==============================================="
echo "Starting Antigravity Installation (Linux/Mac)"
echo "==============================================="

# 1. Check for Salesforce CLI
echo ""
echo "--> Checking for Salesforce CLI (sf)..."
if ! command -v sf &> /dev/null
then
    echo "Salesforce CLI not found. Attempting to install via npm..."
    if ! command -v npm &> /dev/null
    then
        echo "WARNING: npm is not installed. Please install Node.js manually, then run: npm install -g @salesforce/cli"
    else
        sudo npm install -g @salesforce/cli
    fi
else
    echo "Salesforce CLI is already installed!"
fi

echo ""
echo "==============================================="
echo "OPTIONAL: Local AI Engine (Ollama)"
echo "==============================================="
echo "Antigravity works incredibly fast out-of-the-box using the free cloud model."
echo "However, if you want to prove a point and process your data 100% locally,"
echo "we can install Ollama and the 'Ollama Bridge' MCP server right now."
read -p "Do you want to download a 5GB local AI model? (y/N): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "--> Checking if Ollama is already running..."
    if curl -s http://localhost:11434 | grep -q "Ollama is running"; then
        echo "Good news: Ollama is already running on port 11434."
    else
        echo "--> Installing native Ollama AI Engine..."
        curl -fsSL https://ollama.com/install.sh | sh
        echo "--> Downloading qwen2.5-coder:7b model (4.7GB)..."
        ollama pull qwen2.5-coder:7b
    fi

    echo "--> Configuring Antigravity MCP Bridge..."
    mkdir -p ~/.gemini/config
    cat << 'INNER_EOF' > ~/.gemini/config/mcp_config.json
{
  "mcpServers": {
    "ollama-bridge": {
      "command": "npx",
      "args": ["-y", "ollama-mcp"]
    }
  }
}
INNER_EOF
    echo "Success: Ollama Bridge configured globally!"
else
    echo "Skipping local AI installation. Antigravity will use the blazing-fast cloud model."
fi

echo ""
echo "==============================================="
echo "Installation Complete! Boot up Antigravity to begin."
echo "==============================================="
