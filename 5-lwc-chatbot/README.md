# Salesforce Gemini AI Assistant

A native Lightning Web Component (LWC) that brings Google's Gemini AI directly into your Salesforce Utility Bar. 

👉 **[Read the Full Documentation & Origin Story 🚀](./docs/LWC_CHATBOT_MAIN.md)**

## Features
- **Zero Additional Cost:** Uses standard Salesforce LWC and Apex. No Agentforce or Einstein licenses required.
- **Context-Aware:** Automatically detects which Record you are looking at and passes it to the AI.
- **Secure:** Uses native Salesforce Named Credentials to store your Google Gemini API Key.
- **Web Browsing:** Integrates Gemini's Google Search Grounding to fetch live information from the web.
- **Actionable (Function Calling):** Uses native AI tool calling to execute dynamic DML updates inside Salesforce.

## Documentation
* [Main Project Page & Value Proposition](./docs/LWC_CHATBOT_MAIN.md)
* [Code Architecture & Components](./docs/CODE_ARCHITECTURE.md)

## Installation & Setup

1. **Deploy to Salesforce**
   Run the following command using the Salesforce CLI:
   `sf project deploy start`

2. **Configure your API Key**
   - Go to **Setup** > **Named Credentials** > **External Credentials**.
   - Open `Gemini_Auth` and select your Principal (`Gemini_Principal`).
   - Edit the Authentication Parameter value to be your actual Google Gemini API Key.
   - *Ensure "Allow Formulas in HTTP Header" is checked on the `Gemini_API` Named Credential!*

3. **Add to Utility Bar**
   - Go to **Setup** > **App Manager**.
   - Edit your desired Lightning App (e.g., Sales Console).
   - Go to **Utility Items** and add the **Gemini Assistant** component.
