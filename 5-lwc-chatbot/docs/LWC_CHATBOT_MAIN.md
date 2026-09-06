# Custom LWC AI Chatbot

Welcome to the main documentation for the Custom Salesforce AI Chatbot! This project demonstrates how to build a fully capable, enterprise-grade AI Copilot using **100% native Salesforce components** (LWC + Apex) connected to Google's Gemini API.

## 🛠️ How It Was Created
This project was conceptualized and developed using **Google Antigravity**, utilizing a collaborative mix of **Claude** and **Gemini** models in about 1.5 hours.
* **The Process:** The models worked together in an agentic coding environment to scaffold the project, navigate Salesforce CLI limitations, and write the custom Apex and LWC code. 
* **Overcoming Obstacles:** The agents collaboratively solved complex integration hurdles, such as modern External Credential permission mappings in Salesforce, dynamic schema retrieval, bypassing Apex's notorious "uncommitted work pending" DML-before-callout limitation, and managing Gemini API payload quirks (like mixing `googleSearch` tools with custom Function Declarations).

## ✨ What It Does
* **Dynamic Context Awareness:** As you navigate through Salesforce, the LWC detects the active record ID. The Apex engine dynamically queries the Schema to pull all accessible fields and related parent data, feeding the AI context about what you're looking at.
* **Live Web Browsing:** Using Gemini's native Google Search Grounding (`googleSearch` tool), the assistant can browse the live web to fetch real-time data about your leads, accounts, or market trends.
* **Database Updates via Function Calling:** When instructed, the AI uses a custom tool (`updateSalesforceRecord`) to send targeted update commands. Apex intercepts these commands, verifies Field-Level Security (FLS), and executes the DML to update the database—without hallucinating the result.
* **Conversational Memory:** The LWC retains your chat history within the session, passing it back to the AI for true multi-turn, contextual conversations.

## 🛑 Current Limitations
While powerful, this prototype currently has a few boundaries:
* **Single-Field Updates:** The function declaration currently only supports updating one field at a time. (Expanding this to accept an array of fields or handle record creation is a straightforward phase 2).
* **Session-Only Memory:** Chat history is stored in the LWC state. If you refresh the browser page, the chat clears.
* **Synchronous Callout Limits:** Salesforce enforces a strict 120-second maximum for synchronous HTTP callouts. If the AI takes too long to search the web or generate a massive response, the request will time out.
* **Limited Object Support in DML:** It cannot currently perform complex related-record inserts (like creating an Opportunity with Line Items) without adding more explicit tools to the Apex codebase.

## 💡 The Value Proposition: Custom AI vs. Agentforce
Salesforce heavily markets **Agentforce** and Einstein Copilot, which charge premium per-conversation or per-user license fees. Why build a custom solution like this instead?

1. **Massive Cost Savings:**
   * *Agentforce:* Costs upwards of $2.00 per conversation, or requires expensive bundled Einstein 1 licenses.
   * *Custom Solution:* You pay raw API token costs (often fractions of a cent per request). A high-volume sandbox or production environment costs pennies compared to thousands of dollars.
2. **Bring Your Own Model (BYOM) & Avoid Lock-In:**
   * You aren't tied to Salesforce's trust layer, their selected LLM versions, or their pacing of feature releases. You can instantly swap between Gemini 1.5, Gemini 2.5 Flash, or Claude by changing an endpoint URL.
3. **Deep Customization:**
   * You own the architecture. If you want the AI to call an external ERP system via Apex before answering, you just write the Apex. You don't have to wait for Salesforce to build a declarative connector for it.
4. **Leverage Existing AI Infrastructure:**
   * If your organization already uses Google Cloud Platform (Vertex AI) or AWS for enterprise AI, you can route this LWC directly into your existing VPCs, taking advantage of your company's existing data pipelines, RAG setups, and corporate security policies.

---
**Next Steps:** Dive into the code! Check out the [Code Architecture & Components](./CODE_ARCHITECTURE.md) section.
