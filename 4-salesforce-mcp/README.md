# Connect LibreChat to Salesforce MCP

This guide will walk you through enabling the Salesforce Hosted MCP Servers, creating an External Client App for OAuth, and connecting your local LibreChat instance securely to your Salesforce data.

## Step 1: Enable the Salesforce Hosted MCP Server

Before you can connect, you must explicitly turn the MCP Beta feature on in your Salesforce Org, and then activate the specific servers.

1. Log into your Salesforce Sandbox or Developer Edition Org as an Administrator.
2. Click the gear icon in the top right and select **Setup**.
3. In the Quick Find box, type **User Interface** and select it.
4. Scroll down to the **Setup** section on that page and check the box for **Enable MCP Service (Beta)**. Click Save.
5. Next, in the Quick Find box, type **mcp**.
6. Under **Integrations > API Catalog**, click on **MCP Servers**.
7. You will see a list of "Salesforce Servers" (Standard). Find **SObject Reads** (or your desired server).
8. Click the dropdown arrow next to it and select **Activate**.
9. Finally, click directly on the name of the server (**SObject Reads**) to open its Details page. 
10. At the bottom, find the **Server URL** (it should start with "https://api.salesforce.com/..."). **Copy this URL**, you will need it for LibreChat!

## Step 2: Create an External Client App (OAuth)

The Salesforce Hosted MCP Servers strictly require a specific OAuth scope ("mcp_api"). You must create an External Client App to grant LibreChat access.

1. In Salesforce Setup, search for **External Client App Manager** and click **New External Client App**.
2. **Basic Information:**
   - **External Client App Name:** "LibreChat MCP"
   - **Contact Email:** Enter your email address.
   - **Distribution State:** Leave as "Local".
3. **API (Enable OAuth Settings):** Check the **Enable OAuth** box.
4. **App Settings:**
   - **Callback URL:** "http://localhost:3080/api/mcp/salesforce-object-reads/oauth/callback"
     *(Note: LibreChat dynamically builds this URL based on the server identifier. If you name your server something else, check the URL bar during the error to find the exact redirect_uri to paste here).*
   - **Selected OAuth Scopes:** Find these in the left box and click the right arrow to select them:
     - Manage user data via APIs ("api")
     - Access Salesforce API Platform ("sfap_api")
     - Access Salesforce hosted MCP servers ("mcp_api")
     - Perform requests on your behalf at any time ("refresh_token", "offline_access")
5. **Flow Enablement:**
   - Check **Enable Authorization Code and Credentials Flow**.
6. **Security:**
   - Check **Enable Authorization Code and Credentials Flow**.
   - **IMPORTANT:** Check **Issue JSON Web Token (JWT)-based access tokens for named users** (Without this, Salesforce throws a 401 Unauthorized because the MCP Gateway requires a JWT).
   - **IMPORTANT:** Uncheck **Require secret for Refresh Token Flow** (if checked, it blocks LibreChat's background connection).
   - *(Leave the default PKCE and Refresh Token Rotation checkboxes as they are).*
7. Click **Create** at the bottom.
8. **CRITICAL STEP:** Salesforce's global API gateways take up to **30 minutes** to propagate changes to External Client Apps. If you try to connect LibreChat immediately, the connection will instantly drop or loop. Step away and grab a coffee before proceeding to Step 3!
9. **IMPORTANT:** After creating the app, click the dropdown next to it in the manager list to view/generate your **Consumer Key (Client ID)** and **Consumer Secret**. Save these!

> [!WARNING]
> Salesforce takes up to 10 minutes to propagate OAuth settings (like scopes and callback URLs). If you immediately try to connect in LibreChat and get an "OAUTH_APPROVAL_ERROR_GENERIC", just wait 5 minutes and try again.

## Step 3: Connect LibreChat to Salesforce

1. Go back to your local LibreChat instance in your browser ("http://localhost:3080").
2. Click the **MCP Servers** button (the puzzle piece or setting icon).
3. Click **"+"** or **"Add MCP Server"**.
4. Give it a name: **`salesforce-object-reads`** *(Note: You must name it exactly this so the generated Callback URL matches what you put in Salesforce!)*
5. Set the Type to "streamable-http". Server URL is "https://api.salesforce.com/platform/mcp/v1/sandbox/platform/sobject-reads"
6. Click the Auth tab and choose OAuth.
   - **Client ID:** Paste the Consumer Key from Step 2.
   - **Client Secret:** Paste the Consumer Secret from Step 2.
   - **Authorization URL:** "https://your-sandbox-domain.sandbox.my.salesforce.com/services/oauth2/authorize"
   - **Token URL:** "https://your-sandbox-domain.sandbox.my.salesforce.com/services/oauth2/token"
   - **Scope:** Delete whatever is in there (e.g., "read write") and paste exactly: "api sfap_api mcp_api refresh_token offline_access"
7. Click **Save**. LibreChat will pop up a window to log you into Salesforce and grant it permissions!

## Step 4: Test Your Secure AI!
1. Start a new chat in LibreChat, or open the **Agent Builder** if you are creating a custom Agent.
2. Select your local AI model (e.g., "llama3.1:8b").
3. **CRITICAL:** Click the **Tools** icon (puzzle piece) in the chat bar, or the Tools dropdown in the Agent Builder, and **select/toggle ON** the newly imported Salesforce tools (e.g., "salesforce_query", "salesforce_read").
4. Ask it: *"What are the names of the 3 most recently created Accounts in Salesforce?"*
