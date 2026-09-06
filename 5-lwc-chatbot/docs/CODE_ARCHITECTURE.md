# Code Architecture & Components

This project is built on a streamlined, 3-pillar architecture designed entirely natively on the Salesforce Platform.

## 1. Lightning Web Component (LWC): `geminiChatUtility`
The frontend is a standard LWC designed to be placed in the Salesforce Utility Bar.

* **`geminiChatUtility.js`:** 
  * Uses `@wire(CurrentPageReference)` to detect when the user switches tabs and grabs the active `recordId`.
  * Manages conversational state (`chatHistory`), ensuring multi-turn context.
  * Formats outgoing payloads and parses the AI's markdown responses into HTML for proper rendering via `lightning-formatted-rich-text`.
* **`geminiChatUtility.html` / `.css`:** 
  * Clean, compact UI using standard SLDS classes designed to fit perfectly in a utility tray.

## 2. Context Engine: `GeminiContextEngine.cls`
Before calling the LLM, the system needs to know what the user is looking at.

* Uses dynamic `Schema.getGlobalDescribe()` to identify the object type from the record ID.
* Dynamically iterates over all fields on the object.
* Performs Field-Level Security (FLS) checks (`isAccessible()`) to ensure the user actually has permission to view the data.
* Queries the record and serializes it into a JSON string that is injected directly into the LLM's `system_instruction`.

## 3. Callout & Tool Engine: `GeminiCalloutService.cls`
The core brain of the integration. This class bridges Salesforce and Google AI Studio.

* **Payload Construction:** Assembles the `system_instruction`, conversation `contents`, and `tools`.
* **Tool Configuration:** Injects the native `googleSearch` tool and a custom `functionDeclaration` (`updateSalesforceRecord`) to give the AI agentic abilities.
* **HTTP Callout:** Sends a secure REST API POST using Salesforce Named Credentials (`callout:Gemini_API`), protecting the API key.
* **Function Interception:** 
  * Parses the JSON response from Google.
  * If the AI decides to execute `updateSalesforceRecord`, the Apex code intercepts this `functionCall`.
  * It verifies FLS (`isUpdateable()`) on the requested field.
  * Executes the DML `update`.
  * Returns a simulated "Action Complete" success message directly back to the LWC UI, elegantly bypassing Salesforce's "Uncommitted Work Pending" (DML-before-callout) limitation.
