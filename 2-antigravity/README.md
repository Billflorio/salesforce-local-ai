# Using Antigravity with Salesforce (Local AI Setup)

Antigravity is an AI coding agent that lives on your machine and has access to your terminal. This repository provides a configuration so that any Salesforce Admin can use Antigravity to write Apex and administer their org **for free** using local AI models, without needing expensive cloud subscriptions.

## The Strategy: Local-First AI
This setup uses **Ollama** to run a lightweight, open-source AI model locally on your computer. It is designed to work on standard laptops — including older, low-RAM machines. Antigravity will automatically use this local model to write your Apex and Flows. If a task is too complex for the local model, it can fallback to Google's Gemini (free tier), but our goal is 100% local, free administration.

### Choosing a Local Model
The right model depends on your hardware:

| Machine | Recommended Model | RAM Required | Notes |
|---|---|---|---|
| GPU machine / modern laptop | `llama3.1:8b` | ~5 GB | Best quality, needs GPU or lots of RAM |
| Older laptop / CPU-only | **`qwen2.5:1.5b`** | ~1 GB | ✅ Fast on any hardware |
| Any machine (fallback) | Google Gemini (free) | Cloud | No local GPU needed |

> Both models are downloaded automatically. On a **GPU machine**, pick `llama3.1:8b` in the model selector. On an **older or CPU-only laptop**, pick `qwen2.5:1.5b` for a much faster response.

---

## 1. Prerequisites (For Admins)

1. **Install the Salesforce CLI:**
   Download and install the [Salesforce CLI](https://developer.salesforce.com/tools/salesforcecli).
2. **Log into your Org:**
   Open your terminal and run:
   ```bash
   sf org login web
   ```
   *(This will open your browser. Log into your Sandbox or Dev Org.)*

## 2. Local AI Setup (Automated)

To make things as easy as possible, we have included an automated setup script that will download Ollama and pull the correct AI model for you.

1. **Download this code:** Clone or download this GitHub repository to your computer and extract it.
2. Open your terminal (PowerShell for Windows, Terminal for Mac/Linux).
3. Navigate into the `2-antigravity` folder:
   ```bash
   cd salesforce-local-ai/2-antigravity
   ```
4. **Run the setup script:**
   
   **Windows:**
   ```powershell
   .\setup_local_ai.ps1
   ```

   **Mac/Linux:**
   ```bash
   chmod +x setup_local_ai.sh
   ./setup_local_ai.sh
   ```

*(This script will check if you have the Salesforce CLI, Google Antigravity, and Ollama installed. If not, it will install them. Then, it will download a lightweight AI model optimized for instruction-following and tool use, which may take a few minutes).*

## 3. Configure Antigravity

This repository contains a pre-built **Antigravity Skill** in the `.agents/` folder. This skill teaches Antigravity how to act like an expert Salesforce Developer and tells it to prioritize your local Ollama model.

1. Open the `2-antigravity` folder in your terminal or IDE.
2. Launch **Antigravity**. Because you are in this folder, Antigravity will automatically detect the custom `.agents/skills/salesforce-admin` skill!
3. In Antigravity's settings, configure it to use your local Ollama API (usually `http://localhost:11434` as the endpoint).
   - **Older/low-RAM machine:** use `qwen2.5:1.5b` as the model
   - **Modern machine with 8 GB+ free RAM:** use `qwen2.5-coder:7b` for better code quality

## 4. Start Coding!

Just ask Antigravity to do things in plain English! Because it has access to your terminal and the Salesforce Admin Skill, it will use `sf` commands on your behalf.

*Example Prompts:*
- "Create a new custom object called Project__c and deploy it."
- "Write an Apex trigger that updates the Account Status when an Opportunity is Closed Won, and run the tests."
- "Pull down the Flow named 'User_Onboarding' and tell me what it does."

*Behind the scenes, Antigravity uses your local model to generate the code, runs `sf` commands to push it to your org, and reads the success/error logs directly from your terminal!*

---

## 5. Beyond Salesforce: General IT & Dev Environment Setup
While Antigravity is a fantastic Salesforce developer, **it is fundamentally a general-purpose agent with terminal access.** This makes it incredibly powerful for tasks far outside of Apex coding.

You can ask Antigravity to fix issues on your actual computer, set up development environments, or troubleshoot OS-level errors.

*Example Prompts:*
- *"I'm getting a 'permission denied' error when running docker without sudo. Can you fix my Linux user groups so it just works?"*
- *"Install the Salesforce Extensions pack in VS Code for me."*
- *"Search my computer to find where LibreChat saved its configuration files."*

## 6. The "Hub and Spoke" AI Architecture (Advanced)
Antigravity itself is deeply optimized to run on Google's Gemini models natively. While you can swap the core model to a local one (like `qwen`), there is a very powerful alternative architecture: **The Hub and Spoke**.

Instead of making Ollama the "brain" of Antigravity, you can leave Antigravity running on **Gemini (free tier) as the Orchestrator (Hub)**, and have it securely command your **local Ollama instance (Spoke)** via terminal commands!

**How it works:**
Because Antigravity can run commands in your terminal, it can run `ollama run ...` or hit your local `http://localhost:11434/api/generate` endpoint on your behalf. 

This allows you to ask Antigravity to:
1. Orchestrate a massive workflow using Gemini's huge context window.
2. Delegate specific sensitive data-processing tasks to your offline, local Ollama model securely via the terminal.
3. Read the output from Ollama and format it for you. 

*Example:* *"Hey Antigravity, run this sensitive CSV file through my local `qwen` model using the terminal, and summarize the output for me."*
