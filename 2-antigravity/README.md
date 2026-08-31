# Using Antigravity with Salesforce (Local AI Setup)

Antigravity is an AI coding agent that lives on your machine and has access to your terminal. This repository provides a configuration so that any Salesforce Admin can use Antigravity to write Apex and administer their org **for free** using local AI models, without needing expensive cloud subscriptions.

## The Strategy: Local-First AI
This setup uses **Ollama** to run a lightweight, open-source AI model locally on your computer. It is designed to work on standard laptops. Antigravity will automatically use this local model to write your Apex and Flows. If a task is too complex for the local model, it can fallback to Google's Gemini, but our goal is 100% local, free administration.

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

1. Open PowerShell on your computer.
2. Navigate to this directory (`2-antigravity`).
3. Run the setup script:
   ```powershell
   .\setup_local_ai.ps1
   ```
*(This script will check if you have the Salesforce CLI, Google Antigravity, and Ollama installed. If not, it will install them. Then, it will download a lightweight 7-Billion parameter AI model optimized for coding, which may take a few minutes).*

## 3. Configure Antigravity

This repository contains a pre-built **Antigravity Skill** in the `.agents/` folder. This skill teaches Antigravity how to act like an expert Salesforce Developer and tells it to prioritize your local Ollama model.

1. Clone or download this GitHub repository to your computer.
2. Open the `2-antigravity` folder in your terminal or IDE.
3. Launch **Antigravity**. Because you are in this folder, Antigravity will automatically detect the custom `.agents/skills/salesforce-admin` skill!
4. In Antigravity's settings, configure it to use your local Ollama API (usually `http://localhost:11434` as the endpoint, and `qwen2.5-coder:7b` as the model).

## 4. Start Coding!

Just ask Antigravity to do things in plain English! Because it has access to your terminal and the Salesforce Admin Skill, it will use `sf` commands on your behalf.

*Example Prompts:*
- "Create a new custom object called Project__c and deploy it."
- "Write an Apex trigger that updates the Account Status when an Opportunity is Closed Won, and run the tests."
- "Pull down the Flow named 'User_Onboarding' and tell me what it does."

*Behind the scenes, Antigravity uses your local model to generate the code, runs `sf` commands to push it to your org, and reads the success/error logs directly from your terminal!*

## Mac / Linux Users
Run the bash script instead to install Ollama and dependencies:
```bash
chmod +x setup_local_ai.sh
./setup_local_ai.sh
```
