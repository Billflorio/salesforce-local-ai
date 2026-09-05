# Hijacking Antigravity for Salesforce (Local AI Setup)

Antigravity is an AI coding agent that lives locally on your machine and has full access to your terminal. This setup is here so any Salesforce Admin can use Antigravity to write Apex and run their org **for absolutely free** using local AI models. No expensive cloud subscriptions. No paying rent for tools you should own.

## The Strategy: Local-First AI
We use **Ollama** to run a lightweight, open-source AI model locally on your computer. It's designed to run on standard hardware—including that old, rusty laptop you've been putting off replacing. Antigravity uses this local model to write your code. 

### Choosing a Local Model
Pick your poison based on your hardware:

| Machine | Recommended Model | RAM Required | Notes |
|---|---|---|---|
| GPU machine / modern laptop | `llama3.1:8b` | ~5 GB | Best quality, but demands a GPU or decent RAM |
| Older laptop / CPU-only | **`qwen2.5:1.5b`** | ~1 GB | ✅ Fast, even on garbage hardware |
| Any machine (fallback) | Google Gemini (free) | Cloud | The free cloud backup |

> Both models download automatically. Got a **GPU**? Pick `llama3.1:8b`. Rocking a **CPU-only laptop from 2018**? Pick `qwen2.5:1.5b` so you don't melt your motherboard.

---

## 1. Prerequisites (For Admins)

1. **Install the Salesforce CLI:**
   Go grab the [Salesforce CLI](https://developer.salesforce.com/tools/salesforcecli).
2. **Log into your Org:**
   Pop open your terminal and run:
   ```bash
   sf org login web
   ```
   *(This opens a browser. Log into your Sandbox or Dev Org. Do NOT run this on Production, obviously.)*

## 2. Local AI Setup (Automated)

We wrote a script to do the heavy lifting so you don't have to manually download Ollama and pull models like a chump.

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

*(This script checks if you have the CLI, Antigravity, and Ollama installed. If not, it installs them and pulls a model optimized for instruction-following).*

## 3. Configure Antigravity

We threw a pre-built **Antigravity Skill** into the `.agents/` folder. This teaches Antigravity how to stop acting like a generic chatbot and start acting like a cynical Salesforce Developer who prioritizes your local Ollama model.

1. Open the `2-antigravity` folder in your terminal.
2. Launch **Antigravity**. It'll automatically detect the custom `.agents/skills/salesforce-admin` skill.
3. In the settings, point it to your local Ollama API (usually `http://localhost:11434`).
   - **Low-RAM laptop:** use `qwen2.5:1.5b`
   - **Modern machine (8GB+ RAM):** use `qwen2.5-coder:7b`

## 4. Start Coding

Just ask Antigravity to do things in plain English. Because it has terminal access and the Salesforce Admin Skill, it will fire off `sf` commands for you.

*Example Prompts:*
- "Create a new custom object called Project__c and deploy it."
- "Write an Apex trigger that updates Account Status when an Opportunity is Closed Won, and run the tests."
- "Pull down the Flow named 'User_Onboarding' and tell me what the hell it does."

*Antigravity uses the local model to generate code, pushes it to your org via the CLI, and reads the logs straight from your terminal.*

---

## 5. Beyond Salesforce: General Dev Environment Setup
Antigravity isn't just for Apex. **It's a general-purpose agent with terminal access.** 

You can literally ask it to fix issues on your actual computer, set up development environments, or troubleshoot OS-level garbage.

*Example Prompts:*
- *"I'm getting a 'permission denied' error when running docker without sudo. Fix my Linux user groups so it just works."*
- *"Install the Salesforce Extensions pack in VS Code for me."*
- *"Search my computer to find where LibreChat buried its configuration files."*

## 6. The "Hub and Spoke" AI Architecture (Advanced)
This is where the corporate tech platforms are ripping you off. They sell you overpriced "orchestration." Here's how to build it yourself for free: **The Hub and Spoke**.

Instead of making Ollama do all the heavy thinking, you leave Antigravity running on **Gemini (free tier) as the Orchestrator (Hub)**, and have it securely command your **local Ollama instance (Spoke)** via terminal commands.

**How it works:**
Antigravity can run `ollama run ...` or hit your local API endpoint right in your terminal. 

This means you can:
1. Orchestrate a massive workflow using Gemini's huge context window.
2. Delegate sensitive data-processing tasks to your offline, local Ollama model securely.
3. Read the output from Ollama without your data ever leaving your machine. 

*Example:* *"Hey Antigravity, run this sensitive CSV file through my local `qwen` model using the terminal, and summarize the output."*
