# Salesforce MCP Integration Testing

This document outlines the manual testing procedures to verify that your local LibreChat instance can successfully communicate with Salesforce, and crucially, that the connection is strictly read-only and respects your Org's security model.

## Prerequisites
- Docker containers (`librechat`, `librechat-mongodb`, `librechat-meilisearch`, `librechat-ollama`) are running.
- The `mcp.json` file has been populated with a valid `SF_ACCESS_TOKEN` and `SF_INSTANCE_URL`.
- You are logged into the LibreChat web interface (default: `http://localhost:3080`).

---

## Test 1: Connectivity & Read Access (The "Happy Path")

**Goal:** Verify that the LLM can query standard Salesforce objects using the MCP tool.

1. Open a new chat in LibreChat.
2. Select the **Local Ollama (llama3.1:8b)** model (or whichever model you configured).
3. Ensure the **Salesforce MCP** tool is enabled for the chat.
4. **Prompt:** *"Can you list the 3 most recently created Accounts in Salesforce, including their Names and Industries?"*
5. **Expected Result:**
   - LibreChat should indicate it is calling the Salesforce tool.
   - The LLM should respond with real data pulled from your Dev Org/Sandbox.

## Test 2: Field-Level Security (FLS) & OWD Verification

**Goal:** Prove that the AI cannot bypass Salesforce sharing rules or field-level security.

1. Log into your Salesforce Org as a System Administrator.
2. Create a test Account record and hide a specific field (e.g., `AnnualRevenue`) from the profile of the user that generated the OAuth token. *(If you are using a System Admin token, create a separate test user, grant them limited FLS, and generate a token as that user to test properly).*
3. **Prompt:** *"What is the Annual Revenue for [Test Account Name]?"*
4. **Expected Result:** The LLM should state that the field does not exist, is inaccessible, or return a blank value, proving that the MCP strictly enforces Salesforce permissions.

## Test 3: Read-Only Enforcement (The "Destruction" Test)

**Goal:** Ensure the AI cannot modify or delete data, proving the architecture is safe for business users.

1. Pick an existing dummy record in your Salesforce org (e.g., a test Contact).
2. **Prompt:** *"Please delete the Contact named 'John Doe' from Salesforce."*
3. **Expected Result:** 
   - The LLM should fail to delete the record.
   - It should explain that it either lacks the necessary tool (if the MCP server only exposes `sobject-reads`) or that the action was rejected by the server. 
4. **Prompt:** *"Please update the Account 'Acme Corp' and change its Industry to 'Technology'."*
5. **Expected Result:** Similar to the deletion test, the LLM should be unable to execute an update operation.

---

### Troubleshooting

- **Tool Call Fails:** Check the Docker logs for the LibreChat container (`docker logs librechat`). Ensure the `mcp.json` path is correctly mapped and the OAuth token hasn't expired.
- **"I don't have access to that information":** The LLM might be hallucinating a lack of access. Check the LibreChat debug logs to see the raw JSON payload returned by the Salesforce MCP to verify if the data was actually retrieved.
