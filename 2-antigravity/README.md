# Antigravity: The Free AI Salesforce Admin

Antigravity is an AI coding agent that lives on your machine and has full access to your terminal. This repository provides a configuration so that any Salesforce Admin can use Antigravity to write Apex, deploy flows, and administer their org **for free**.

By default, Antigravity runs blazing fast on Google's free cloud models. It's smart, it's quick, and it gets the job done without you having to pay monthly subscriptions.

## 1. Prerequisites (For Admins)

1. **Install the Salesforce CLI:**
   Go grab the [Salesforce CLI](https://developer.salesforce.com/tools/salesforcecli).
2. **Log into your Org:**
   Pop open your terminal and run:
   ```bash
   sf org login web
   ```
   *(This opens a browser. Log into your Sandbox or Dev Org. Do NOT run this on Production, obviously.)*

## 2. Automated Setup

We wrote a script to install Antigravity and the Salesforce CLI for you. 

1. **Download this code:** Clone or download this GitHub repo and extract it.
2. Open your terminal.
3. CD into the directory:
   ```bash
   cd salesforce-local-ai/2-antigravity
   ```
4. **Run the script:**
   
   **Windows:**
   ```powershell
   .\setup_local_ai.ps1
   ```

   **Mac/Linux:**
   ```bash
   chmod +x setup_local_ai.sh
   ./setup_local_ai.sh
   ```

*(During the script, it will ask if you want to install an **optional** local AI model. If you just want things to work fast, hit 'N' to skip it.)*

## 3. Configure the Workspace

We threw a pre-built **Antigravity Skill** into the `.agents/` folder. This teaches Antigravity how to act like a cynical Salesforce Developer instead of a generic chatbot.

1. Open the `2-antigravity` folder in your terminal.
2. Launch **Antigravity**. It'll automatically detect the custom `.agents/skills/salesforce-admin` skill.

## 4. Start Coding

Just ask Antigravity to do things in plain English. Because it has terminal access and the Salesforce Admin Skill, it will fire off `sf` commands for you.

*Example Prompts:*
- "Create a new custom object called Project__c and deploy it."
- "Write an Apex trigger that updates Account Status when an Opportunity is Closed Won, and run the tests."
- "Pull down the Flow named 'User_Onboarding' and tell me what the hell it does."

*Antigravity uses the AI to generate code, pushes it to your org via the CLI, and reads the logs straight from your terminal.*

---

## 5. OPTIONAL: Hardcore Mode (The "Hub and Spoke" Local AI)

Antigravity works great out-of-the-box using the cloud. But if you want to prove a point, save some cloud tokens, or process highly sensitive data 100% offline, you can run a massive AI model locally on your own hardware. 

We call this **The Hub and Spoke**. Antigravity (the Hub) stays in the driver's seat, but it routes your actual data processing down to a local Ollama instance (the Spoke) via a bridge.

**How to set it up:**
1. When you run the setup script above, hit `Y` when it asks if you want to install the local AI. 
2. It will download a 5GB model (`qwen2.5-coder:7b`) and configure the `ollama-bridge` MCP server.
3. Once it finishes, boot up Antigravity, click the settings menu, and verify the `ollama-bridge` MCP Server has a green light. 

Now you can tell Antigravity things like: *"Hey, use the Ollama Bridge to analyze this CSV file offline,"* and your data will never leave your laptop. 
