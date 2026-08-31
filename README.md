# Zero Cost AI Solutions: Salesforce MCP Integration

**?? DISCLAIMER & WARNING ??**
> This repository and its accompanying scripts are provided strictly for **educational and demonstration purposes**. 
> - **DO NOT run these scripts against a Production Salesforce environment.** You should only use a Salesforce Developer Edition Org or a Sandbox.
> - This project is a proof-of-concept to demonstrate how to bridge a local LLM with Salesforce using the Model Context Protocol (MCP).
> - This repository **will not be maintained** and is provided "AS IS" without warranty of any kind. 
> - By running the scripts or deploying the configurations contained in this repository, **you take full responsibility** for any consequences, including potential data loss or security breaches.

## Project Overview
This repository provides a "one-click" take-home architecture for Salesforce Admins to deploy a local Large Language Model (Ollama), a web interface (LibreChat), and connect it securely to their Salesforce environment via the Free Hosted MCP Servers Beta.

### Mac & Linux Support
This entire stack is natively cross-platform! Everything is orchestrated using standard Docker containers and volumes.
- **Mac (Apple Silicon):** Docker will automatically pull the ARM64 versions of these containers. They run incredibly fast on M1/M2/M3 chips.
- **Linux:** You do not need to run the .ps1 script. You can simply boot the stack using the industry standard command: docker compose up -d in your terminal. Ensure your user is in the docker group or run it with sudo.

---

## ?? Repository Guide

This repository is broken down into modules to help you understand and deploy the architecture step-by-step. Please review the documentation in each folder:

### [1. Prerequisites](./1-prerequisites/README.md)
Start here if you are new to Docker, LibreChat, or the Model Context Protocol (MCP). This guide explains what the tech stack is and how to install the required base software on your machine.

### [2. Using Antigravity with Salesforce](./2-antigravity/README.md)
Instructions for connecting **Antigravity** (your local AI coding agent) to your Salesforce CLI session for zero-config, terminal-based Apex and metadata generation.

### 3. Boot Up the AI Environment (LibreChat & Ollama)
We have provided a one-click setup script to boot your local AI containers (located in the 3-librechat-config folder).
1. Open a PowerShell terminal.
2. Navigate to this root folder.
3. Run the script:
   \\\powershell
   .\start.ps1
   \\\
4. The script will automatically pull the AI models and boot up the LibreChat web interface via Docker Compose. Wait about 60 seconds, then open http://localhost:3080 in your web browser and create your admin account.

### [4. Connect Salesforce MCP to LibreChat](./4-salesforce-mcp/README.md)
**The core integration guide.** Follow this step-by-step guide to create the Salesforce External Client App (OAuth), configure the LibreChat UI, and successfully bind your local AI to your Salesforce Sandbox using the Agentforce MCP Beta endpoints.

### [5. Security & Testing Plan](./TESTING.md)
A comprehensive QA plan documenting how to validate that your integration properly respects Field Level Security (FLS) and Org-Wide Defaults (OWD), and ensures read-only access.
## ?? Additional Resources & Further Reading

If you want to take this architecture to the next level or scale it for your organization, check out these official resources:

### Salesforce & Developer Tools
- **[Salesforce Extensions for VS Code](https://developer.salesforce.com/tools/vscode):** The official guide on how to integrate the Salesforce CLI with Visual Studio Code. This is the industry standard for writing Apex, LWC, and deploying metadata.
- **[Salesforce Hosted MCP Servers (Beta)](https://developer.salesforce.com/docs/platform/hosted-mcp-servers/overview):** The official developer documentation for the Agentforce MCP endpoints used in this project.
- **[Salesforce External Client Apps](https://help.salesforce.com/s/articleView?id=sf.external_client_apps_intro.htm&type=5):** Deep dive into the modern OAuth standard that replaces traditional Connected Apps.

### Enterprise AI & LibreChat
- **[LibreChat Enterprise Deployment](https://www.librechat.ai/docs/configuration/librechat_yaml):** Guide on using librechat.yaml to enforce strict organizational rules, manage endpoints, configure custom SSO (Single Sign-On), and disable public registration for enterprise scenarios.
- **[Model Context Protocol (MCP)](https://modelcontextprotocol.io/):** The official documentation for the open-source protocol that makes it possible for AI models to securely read your Salesforce data.
- **[Ollama Enterprise Guide](https://github.com/ollama/ollama):** Documentation on how to run Ollama on dedicated GPU servers, rather than local laptops, to serve multiple enterprise users simultaneously.
