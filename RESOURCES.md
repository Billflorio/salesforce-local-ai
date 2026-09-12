# 📚 Further Reading & Resources for Salesforce Pros

> **What is this?** This is a curated, no-bullshit guide to the open-source tools, models, datasets, and community projects that take the concepts in this repo to the next level. Every link here has been verified against live GitHub and Hugging Face repositories. If a corporate AI hallucinated a resource that doesn't actually exist, we replaced it with the real thing.
>
> **The golden rule:** If it costs money, there's probably a free, open-source version that's just as good. You just have to know where to look.

---

## Table of Contents
1. [Local AI Models for Salesforce Development](#-local-ai-models-for-salesforce-development)
2. [LoRA Fine-Tuning: Train Your Own Salesforce AI](#-lora-fine-tuning-train-your-own-salesforce-ai)
3. [Grammar Constraints: Force AI to Write Valid SOQL](#-grammar-constraints-force-ai-to-write-valid-soql)
4. [Salesforce DevOps Toolboxes](#-salesforce-devops-toolboxes)
5. [Salesforce AI Research (Open Source from Salesforce Labs)](#-salesforce-ai-research-open-source-from-salesforce-labs)
6. [AI Benchmarking & Evaluation](#-ai-benchmarking--evaluation)
7. [GitHub Actions: Automated AI Pipelines](#-github-actions-automated-ai-pipelines)
8. [Salesforce Developer Essentials](#-salesforce-developer-essentials)
9. [Enterprise AI & LibreChat](#-enterprise-ai--librechat)
10. [Video Resources & YouTube Tutorials](#-video-resources--youtube-tutorials)

---

## 🤖 Local AI Models for Salesforce Development

These are the models you can download today and run locally with Ollama or llama.cpp. They understand code, they fit on consumer hardware, and they cost exactly zero dollars per month.

### Recommended Small Models (Run on Any Laptop)

| Model | Size | Best For | Ollama Command |
|-------|------|----------|----------------|
| [Qwen2.5-Coder-1.5B-Instruct](https://huggingface.co/Qwen/Qwen2.5-Coder-1.5B-Instruct) | 1.5B | Apex, LWC, SOQL generation on garbage hardware | `ollama pull qwen2.5-coder:1.5b` |
| [Qwen2.5-Coder-7B-Instruct](https://huggingface.co/Qwen/Qwen2.5-Coder-7B-Instruct) | 7B | Best balance of quality and speed for coding tasks | `ollama pull qwen2.5-coder:7b` |
| [DeepSeek-Coder-V2-Lite](https://huggingface.co/deepseek-ai/DeepSeek-Coder-V2-Lite-Instruct) | 2.4B active (16B total MoE) | Advanced code reasoning at small footprint | `ollama pull deepseek-coder-v2:16b` |
| [Llama 3.1 8B](https://huggingface.co/meta-llama/Llama-3.1-8B-Instruct) | 8B | General purpose + code, great all-rounder | `ollama pull llama3.1:8b` |
| [Gemma 3](https://huggingface.co/google/gemma-3-4b-it) | 4B | Google's open model, fast and surprisingly capable | `ollama pull gemma3:4b` |

### Recommended Medium Models (Need a Decent GPU — 16GB+ VRAM)

| Model | Size | Best For | Ollama Command |
|-------|------|----------|----------------|
| [Qwen2.5-Coder-32B-Instruct](https://huggingface.co/Qwen/Qwen2.5-Coder-32B-Instruct) | 32B | Near-GPT-4 code quality, runs quantized on 24GB GPU | `ollama pull qwen2.5-coder:32b` |
| [DeepSeek-Coder-33B-Instruct](https://huggingface.co/deepseek-ai/deepseek-coder-33b-instruct) | 33B | Battle-tested for enterprise code | `ollama pull deepseek-coder:33b` |

> **💡 Pro Tip:** For daily Salesforce work (writing Apex triggers, SOQL queries, LWC components), `qwen2.5-coder:7b` is the sweet spot. It runs on an 8GB GPU, understands Java-style OOP syntax that maps directly to Apex, and doesn't hallucinate field names as badly as larger models. Pair it with a SOQL Expert Skill (see Section 8 in the main README) and it absolutely rips.

---

## 🧬 LoRA Fine-Tuning: Train Your Own Salesforce AI

Want a model that knows YOUR org's custom objects, YOUR naming conventions, and YOUR business logic? You don't need to retrain a whole model — you slap a tiny LoRA adapter on top and the base model instantly learns your patterns.

### Training Infrastructure

* **[Unsloth](https://github.com/unslothai/unsloth)** — The fastest, cheapest way to fine-tune local models with LoRA. Works on consumer GPUs (even an old 8GB card). Train a custom Apex-aware 1.5B model in about an hour for zero dollars. This is the tool the DIY community actually uses.

* **[Salesforce CodeTF](https://github.com/salesforce/CodeTF)** ✅ *Verified* — Salesforce's own open-source Python library for code intelligence. It provides a unified interface for training, fine-tuning, and evaluating code LLMs (CodeT5, CodeT5+, CodeLlama, StarCoder). Has native tokenizers and standardized data loaders. The fact that Salesforce gave this away for free is one of the few cool things they've ever done.

* **[Hugging Face PEFT](https://github.com/huggingface/peft)** — The standard library for Parameter-Efficient Fine-Tuning. Supports LoRA, QLoRA, IA3, and other adapter techniques. Use this if you want to do it the "textbook" way.

### Training Data: Where to Get Apex & SOQL Examples

> ⚠️ **WARNING: Hallucination Alert**
> Gemini suggested a dataset called `Gianloko/apex-coder-training-data` and a LoRA adapter called `apex-coder-1.5b-lora`. **Neither of these actually exist.** They were hallucinated. This is exactly why you verify everything before you trust it. Below are the REAL sources:

* **[BigCode The Stack v2](https://huggingface.co/datasets/bigcode/the-stack-v2)** — The real deal. Millions of lines of permissively-licensed open-source Apex code, triggers, classes, and tests scraped directly from GitHub. Filter by language = `Apex` and you've got a massive training corpus.

* **Salesforce NPSP & EDA Source Code** — Clone the actual [Salesforce.org NPSP](https://github.com/SalesforceFoundation/NPSP) or [EDA](https://github.com/SalesforceFoundation/EDA) repositories. These contain thousands of lines of production-quality Apex written by actual Salesforce engineers. Perfect training data.

* **DIY: Extract Your Own Org's Metadata** — Use the Salesforce CLI (`sf project retrieve start`) to pull your org's Apex classes, triggers, and LWC components. Feed them into Unsloth with synthetic Q&A pairs generated by a larger model (Qwen 32B or even a cloud API). This gives you a LoRA adapter trained specifically on YOUR codebase.

---

## 🔒 Grammar Constraints: Force AI to Write Valid SOQL

This is the frontier — the one piece that the community hasn't fully solved yet. But it's very doable yourself.

### The Problem
When you ask a local AI to write SOQL, it sometimes produces garbage: `SELECT * FROM Account JOIN Contact` — that's standard SQL, not SOQL. Salesforce doesn't support `SELECT *`, doesn't support `JOIN`, and has weird syntax like `LAST_N_DAYS:30` that no standard AI has ever seen.

### The Solution: GBNF Grammars (llama.cpp / Ollama)

**[llama.cpp Grammars Directory](https://github.com/ggml-org/llama.cpp/tree/master/grammars)** — llama.cpp ships GBNF grammar files for JSON, C, Python, SQL, and more. These grammars constrain the model's output so it can ONLY produce text matching the grammar rules. Think of it as regex for AI output.

**There is NO official `soql.gbnf` yet.** But building one is straightforward:

```bnf
# Simplified SOQL Grammar (GBNF format)
# Save this as soql.gbnf and feed it to llama.cpp or Ollama

root        ::= select-stmt
select-stmt ::= "SELECT " field-list " FROM " object-name where-clause? order-clause? limit-clause?
field-list  ::= field ("," " "? field)*
field       ::= [a-zA-Z_][a-zA-Z0-9_.]* 
object-name ::= [A-Z][a-zA-Z0-9_]*
where-clause ::= " WHERE " condition
condition   ::= field " " operator " " value
operator    ::= "=" | "!=" | ">" | "<" | ">=" | "<=" | "LIKE" | "IN"
value       ::= "'" [^']* "'" | [0-9]+ | "NULL" | "TRUE" | "FALSE" | date-literal
date-literal ::= "TODAY" | "YESTERDAY" | "LAST_N_DAYS:" [0-9]+
order-clause ::= " ORDER BY " field (" ASC" | " DESC")?
limit-clause ::= " LIMIT " [0-9]+
```

### Easier Alternative: Structured JSON Output
Instead of writing a full grammar, force the model to output JSON and validate it yourself:

```python
# In your LibreChat Agent or Python script:
# Force Ollama to return structured JSON
response = ollama.chat(
    model="qwen2.5-coder:7b",
    messages=[{"role": "user", "content": "Query all Accounts created this month"}],
    format="json"  # <-- Forces JSON output
)
# Parse and validate the SOQL before sending to Salesforce
query = json.loads(response['message']['content'])['query']
# "SELECT Id, Name FROM Account WHERE CreatedDate = THIS_MONTH"
```

---

## 🧰 Salesforce DevOps Toolboxes

These are the "download and go" frameworks that bundle multiple tools into a single installation.

### sfdx-hardis ✅ *Verified*
* **GitHub:** [hardisgroupcom/sfdx-hardis](https://github.com/hardisgroupcom/sfdx-hardis)
* **Docs:** [sfdx-hardis.cloudity.com](https://sfdx-hardis.cloudity.com/)
* **What it is:** The most popular open-source Salesforce DX plugin and VS Code extension for DevOps. It automates CI/CD pipelines, scratch org management, metadata backups, monitoring, and deployments. Instead of clicking through Salesforce's bloated Setup UI, you install the extension, click a button, and it does the work.
* **AI Integration:** Has a built-in Documentation Workbench that can generate relationship diagrams, document your Apex classes, and flag permissions anomalies.
* **Install:** `sf plugins install sfdx-hardis` or install the VS Code extension from the marketplace.

### Salesforce CLI (sf) — Fully Open Source
* **GitHub:** [forcedotcom/cli](https://github.com/forcedotcom/cli)
* **What it is:** The official Salesforce command-line tool. Completely open source and Node-based. Powers all local automation, CI/CD, and MCP integrations. If you're not using this already, what the hell are you doing?

---

## 🔬 Salesforce AI Research (Open Source from Salesforce Labs)

Ironically, Salesforce's research arm gives away incredibly powerful AI tools for free — tools that are arguably better than what they charge you for with Agentforce. Here are the ones that actually matter:

### xLAM (Large Action Models) — Function Calling Specialists
* **GitHub:** [SalesforceAIResearch/xLAM](https://github.com/SalesforceAIResearch/xLAM)
* **Hugging Face:** [Salesforce/xLAM-7b-fc-r](https://huggingface.co/Salesforce/xLAM-7b-fc-r) (also available in 1B, 8x7B, and 8x22B sizes)
* **Why you care:** These models are specifically fine-tuned for **tool use and function calling** — which is exactly what MCP does. The 1B "Tiny Giant" model runs on absolute garbage hardware and punches way above its weight for agentic tasks. If you're building an AI that needs to call Salesforce APIs, this is your model.

### CodeT5 / CodeT5+
* **GitHub:** [salesforce/CodeT5](https://github.com/salesforce/CodeT5)
* **Hugging Face:** [Salesforce/codet5p-220m](https://huggingface.co/Salesforce/codet5p-220m) | [codet5p-770m](https://huggingface.co/Salesforce/codet5p-770m) | [codet5p-2b](https://huggingface.co/Salesforce/codet5p-2b) | [codet5p-16b](https://huggingface.co/Salesforce/codet5p-16b)
* **Why you care:** These are Salesforce's foundational open code models. The smaller variants (220M, 770M) are tiny enough to run on a Raspberry Pi and still understand code structure well enough for basic code completion.

### AgentLite — Lightweight Multi-Agent Framework
* **GitHub:** [SalesforceAIResearch/AgentLite](https://github.com/SalesforceAIResearch/AgentLite)
* **Why you care:** Salesforce's own lightweight Python library for building multi-agent LLM systems. No enterprise bloat. Build your own "Hub and Spoke" agent architecture (the exact pattern Agentforce charges you thousands for) using this framework for free.

### APIGen (xLAM Dataset)
* **Hugging Face:** [Salesforce/xlam-function-calling-60k](https://huggingface.co/datasets/Salesforce/xlam-function-calling-60k)
* **Why you care:** Automated generation and verification of function-calling datasets. The xLAM models were trained on this data. Use this to understand how to format training data for fine-tuning your own models to call Salesforce APIs correctly.

---

## 📊 AI Benchmarking & Evaluation

Want to know which model actually writes the best Apex? Don't trust marketing slides — test them yourself.

> ⚠️ **WARNING: Hallucination Alert**
> Gemini suggested a project called `SF-Bench` that automatically benchmarks AI against Salesforce scratch orgs. **This does not exist.** Below are the real benchmarking tools:

* **[SWE-bench](https://github.com/swe-bench/SWE-bench)** — The industry-standard benchmark for evaluating AI on real-world software engineering tasks. Tests if models can actually fix bugs and implement features in real codebases.

* **[CodeXGLUE](https://github.com/microsoft/CodeXGLUE)** — A classic code benchmark co-developed by Salesforce and Microsoft. Tests code understanding, generation, and translation across multiple languages.

* **[Berkeley Function Calling Leaderboard (BFCL)](https://gorilla.cs.berkeley.edu/leaderboard.html)** — Where Salesforce actively benchmarks their xLAM models for tool-calling accuracy. Directly relevant to MCP use cases.

* **DIY: Build Your Own Salesforce Benchmark** — Create a scratch org, write 10–20 coding tasks (e.g., "Write a trigger that prevents duplicate Contacts by Email"), have the AI attempt them, deploy to the scratch org, and run the Apex tests. If the tests pass, the AI's code works. This is more useful than any generic benchmark.

---

## ⚙️ GitHub Actions: Automated AI Pipelines

You can use GitHub Actions to run your entire AI analysis pipeline in the cloud — for free — without installing anything on your laptop.

### The Concept
```yaml
# .github/workflows/salesforce-ai-review.yml
# Triggered manually or on a schedule
name: Salesforce AI Code Review

on:
  workflow_dispatch:  # Manual trigger
  schedule:
    - cron: '0 6 * * 1'  # Every Monday at 6am

jobs:
  ai-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      # Install Salesforce CLI
      - name: Install SF CLI
        run: npm install -g @salesforce/cli
      
      # Authenticate to your Sandbox (URL stored as a secret)
      - name: Auth to Salesforce
        run: sf org login sfdx-url --sfdx-url-file <(echo "${{ secrets.SFDX_AUTH_URL }}")
      
      # Pull your org's Apex code
      - name: Retrieve Metadata
        run: sf project retrieve start --metadata ApexClass ApexTrigger
      
      # Install Ollama and run analysis
      - name: Install Ollama
        run: curl -fsSL https://ollama.com/install.sh | sh
      
      - name: Pull Model & Analyze
        run: |
          ollama pull qwen2.5-coder:1.5b
          # Your analysis script here...
```

> **💡 Key Insight:** GitHub gives you 2,000 free Actions minutes per month on private repos. That's enough to run weekly AI code reviews of your entire Salesforce org without spending a dime and without installing anything locally.

---

## 🛠️ Salesforce Developer Essentials

* **[Salesforce Extensions for VS Code](https://developer.salesforce.com/tools/vscode)** — The official Salesforce development environment. Write Apex, LWC, deploy metadata. Non-negotiable.
* **[Salesforce Hosted MCP Servers (Beta)](https://developer.salesforce.com/docs/platform/hosted-mcp-servers/overview)** — Official docs for the Agentforce MCP endpoints used in this project.
* **[Salesforce External Client Apps](https://help.salesforce.com/s/articleView?id=xcloud.external_client_apps.htm&type=5)** — The modern OAuth standard that replaces Connected Apps.
* **[Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/)** — The official guide for scratch orgs, source tracking, and modern Salesforce development.
* **[Trailhead](https://trailhead.salesforce.com/)** — Say what you will about Salesforce, Trailhead is actually a legitimately good free learning platform. Use it.

---

## 💬 Enterprise AI & LibreChat

* **[LibreChat Enterprise Deployment](https://www.librechat.ai/docs/remote)** — Deploy LibreChat to remote servers, enforce org rules, configure SSO, disable public registration.
* **[Model Context Protocol (MCP)](https://modelcontextprotocol.io/)** — The official docs for the open-source protocol that makes AI-to-Salesforce communication possible.
* **[Ollama](https://github.com/ollama/ollama)** — Run LLMs locally. Documentation on GPU server deployments for multi-user enterprise scenarios.
* **[Open WebUI](https://github.com/open-webui/open-webui)** — Another excellent open-source ChatGPT-style interface that works with Ollama. Good LibreChat alternative.

---

## 🎥 Video Resources & YouTube Tutorials

If you prefer visual learning, here are curated, recent, highly-rated tutorials covering the core technologies.

### 🤖 Local AI & Ollama Tutorials
* **[Ollama Full Tutorial for Beginners (2026)](https://www.youtube.com/watch?v=Wjrdr0NU4Sk)** — Comprehensive guide covering installation, running models, and checking hardware.

### 💬 LibreChat Setup Guides
* **[LibreChat Official Channel](https://www.youtube.com/@LibreChat)** — The official source for updates and tutorials on Agents, Skills, and integrations.

### ☁️ Salesforce MCP
* **[Custom MCP Servers vs Alternative Pricing](https://youtu.be/0wpyRvwLd7I?si=BC39gQDEzn5kZQRa)**

### 🐳 Docker Basics (For Complete Beginners)
* **[Docker Crash Course for Absolute Beginners](https://www.youtube.com/watch?v=fqMOX6JJhGo)** — The best animated, visual explanation of what a Docker Container actually is.
* **[Docker in 10 Minutes – Complete Beginner's Guide](https://www.youtube.com/watch?v=Gjnup-PuquQ)** — Perfect if you just want to understand what `docker compose up` actually does.

### 🧠 Multi-Agent Orchestration (Hub & Spoke)
The "Hub and Spoke" pattern uses a highly capable model (the Hub) as an orchestrator to delegate strict, isolated tasks to local models or terminal tools (the Spokes). 

**This architecture is the exact concept behind the overpriced hype of commercial enterprise AI platforms like Agentforce.** By following the multi-agent patterns in these videos, you can build a faster, more secure, and completely free alternative yourself:

* **[Orchestrator Agent](https://youtu.be/X3XJeTApVMM?si=85tHT-4H1eGInCSK)** — Shows how a "Supervisor" delegates specific tasks to specialized worker agents.
* **[Jeff Geerling: PI w Deepseek Hardware](https://youtu.be/o1sN1lB76EA?si=LO3yZfpfH0q2FVom)** — Shit cheap AI.

---

## 🏴‍☠️ The Bottom Line

The entire Salesforce AI ecosystem that companies like Salesforce charge thousands of dollars a month for can be rebuilt using free, open-source tools running on your own hardware. The models exist. The training data exist. The frameworks exist. You just have to know where to look — and now you do.

**Stop paying rent on your own data. Build it yourself.**

*— Bill Florio, [Greedy Bastard](https://github.com/Billflorio/salesforce-local-ai)*
