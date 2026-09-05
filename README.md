# Zero Cost AI Solutions: Salesforce MCP Integration

![Presentation QR Code](qr-code.jpg)
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
We have provided a one-click setup script to boot your local AI containers (located in the `3-librechat-config` folder).

**For Windows Users:**
1. **Download this code:** Click the green **Code** button at the top of this GitHub page and select **Download ZIP**. Extract the folder to your computer.
2. Open a PowerShell terminal.
3. Navigate into the folder you just extracted.
4. Run the setup script:
   ```powershell
   .\start.ps1
   ```

**For Mac & Linux Users:**
Mac and Linux natively support Docker without needing the PowerShell setup script.
1. **Download this code:** Open your Terminal and clone this repository:
   ```bash
   git clone https://github.com/Billflorio/salesforce-local-ai.git
   ```
2. Navigate into the configuration folder:
   ```bash
   cd salesforce-local-ai/3-librechat-config
   ```
3. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```
4. Boot the containers (Linux users typically require `sudo`):
   ```bash
   sudo docker compose up -d
   ```
   *(Note: If you get an "unknown command" or "unknown flag" error on older Linux versions, try using the older hyphenated command: `sudo docker-compose up -d`)*

### 4. Access LibreChat & Create Your Account
The commands in Step 3 will automatically pull the AI models and boot up the LibreChat web interface in the background. 
1. Wait about 60 seconds for the databases to initialize.
2. Open your web browser and navigate to: **`http://localhost:3080`**
3. You will be greeted by the LibreChat login screen. Since this is your first time, click **Sign Up** (or the equivalent registration button) to create your local admin account.
4. Once logged in, you will see a ChatGPT-like interface. You can now select your local Ollama model from the dropdown at the top!

### 5. Day-to-Day Usage (After Rebooting)
Because this is meant to be a lightweight tool you can play around with, **the AI and databases will not automatically start when you turn your computer on.**

Whenever you reboot your computer and want to use LibreChat again:
- **Windows:** Open Docker Desktop, then open a PowerShell terminal in the `3-librechat-config` folder and run `docker compose up -d` (or just run the `start.ps1` script again).
- **Mac / Linux:** Open your terminal in the `3-librechat-config` folder and run `docker compose up -d` (or `sudo docker compose up -d`).

To shut it all down and free up your computer's memory when you're done, run `docker compose down`.

### [6. Connect Salesforce MCP to LibreChat](./4-salesforce-mcp/README.md)
**The core integration guide.** Follow this step-by-step guide to create the Salesforce External Client App (OAuth), configure the LibreChat UI, and successfully bind your local AI to your Salesforce Sandbox using the Agentforce MCP Beta endpoints.

### [7. Security & Testing Plan](./TESTING.md)
A comprehensive QA plan documenting how to validate that your integration properly respects Field Level Security (FLS) and Org-Wide Defaults (OWD), and ensures read-only access.

### 8. Creating a Custom Salesforce SOQL Agent (Using Skills)
If you want your local model (like `llama3.1:8b` or `qwen2.5:1.5b`) to reliably write SOQL queries without making syntax errors, you can give it a custom **Skill** in LibreChat.

1. In LibreChat, open the side panel and click on **Skills**.
2. Click **Create/Import Skill** and upload the `3-librechat-config/skills/SOQL_Expert/SKILL.md` file located in this repository.
3. Next, click the **Agents** button (the robot icon) in the navigation bar.
4. Click **Create Agent**.
5. **Name:** Salesforce Data Analyst (or whatever you prefer).
6. **Model:** Select your preferred local model.
7. **Tools & Skills:** Click the puzzle piece to enable your **Salesforce Object Reads** MCP tool, AND toggle ON your newly imported **Salesforce SOQL Expert** skill.
8. Click **Save**.

You can now use this Agent to chat directly with your Salesforce data securely!
## ?? Additional Resources & Further Reading

If you want to take this architecture to the next level or scale it for your organization, check out these official resources:

### Salesforce & Developer Tools
- **[Salesforce Extensions for VS Code](https://developer.salesforce.com/tools/vscode):** The official guide on how to integrate the Salesforce CLI with Visual Studio Code. This is the industry standard for writing Apex, LWC, and deploying metadata.
- **[Salesforce Hosted MCP Servers (Beta)](https://developer.salesforce.com/docs/platform/hosted-mcp-servers/overview):** The official developer documentation for the Agentforce MCP endpoints used in this project.
- **[Salesforce External Client Apps](https://help.salesforce.com/s/articleView?id=xcloud.external_client_apps.htm&type=5):** Deep dive into the modern OAuth standard that replaces traditional Connected Apps.

### Enterprise AI & LibreChat
- **[LibreChat Enterprise Deployment](https://www.librechat.ai/docs/remote):** Guide on deploying LibreChat to remote servers, enforcing strict organizational rules, managing endpoints, configuring custom SSO (Single Sign-On), and disabling public registration for enterprise scenarios.
- **[Model Context Protocol (MCP)](https://modelcontextprotocol.io/):** The official documentation for the open-source protocol that makes it possible for AI models to securely read your Salesforce data.
- **[Ollama Enterprise Guide](https://github.com/ollama/ollama):** Documentation on how to run Ollama on dedicated GPU servers, rather than local laptops, to serve multiple enterprise users simultaneously.
- **[Sample LibreChat Agent Instructions](https://github.com/Billflorio/salesforce-local-ai/blob/main/3-librechat-config%2FAlForFree_instructions.md):** Agent that accepts a csv file and produces a prepped results file for multi object import.