# Zero Cost AI Solutions: Salesforce MCP Integration

**⚠️ DISCLAIMER & WARNING ⚠️**
> This repository and its accompanying scripts are provided strictly for **educational and demonstration purposes**. 
> - **DO NOT run these scripts against a Production Salesforce environment.** You should only use a Salesforce Developer Edition Org or a Sandbox.
> - This project is a proof-of-concept to demonstrate how to bridge a local LLM with Salesforce using the Model Context Protocol (MCP).
> - This repository **will not be maintained** and is provided "AS IS" without warranty of any kind. 
> - By running the scripts or deploying the configurations contained in this repository, **you take full responsibility** for any consequences, including potential data loss or security breaches.

## Project Overview
This repository provides a "one-click" take-home architecture for Salesforce Admins to deploy a local Large Language Model (Ollama), a web interface (LibreChat), and connect it securely to their Salesforce environment via the Free Hosted MCP Servers Beta.

### Mac & Linux Support
This entire stack is natively cross-platform! Everything is orchestrated using standard Docker containers and volumes.
- **Mac (Apple Silicon):** Docker will automatically pull the ARM64 versions of these containers. They run incredibly fast on M1/M2/M3 chips.
- **Linux:** You do not need to run the `.ps1` script. You can simply boot the stack using the industry standard command: `docker compose up -d` in your terminal. Ensure your user is in the `docker` group or run it with `sudo`.

---

## Step 1: Install the Tech Stack (Prerequisites)

If you are a Salesforce Admin and have never used Docker, don't worry! 
Think of **Docker** like a virtual shipping container for software. Instead of you having to manually install 15 different tools and databases on your laptop to make an AI work, Docker packages all of them up. 
1. Go to [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/) and download Docker Desktop.
2. Install it and open the application. 
3. Leave it running in the background (look for the little whale icon in your system tray).

## Step 2: Boot Up the AI Environment

We have provided a one-click setup script that configures everything for you.
1. Open a PowerShell terminal.
2. Navigate to this folder.
3. Run the script:
   ```powershell
   .\start.ps1
   ```
4. The script will automatically download the AI models and boot up the LibreChat web interface.
5. Wait about 60 seconds, then open `http://localhost:3080` in your web browser and create your admin account.

## Step 3: Enable the Salesforce Hosted MCP Server

Before you can connect, you must explicitly turn the MCP Beta feature on in your Salesforce Org, and then activate the specific servers.

1. Log into your Salesforce Sandbox or Developer Edition Org as an Administrator.
2. Click the gear icon ⚙️ in the top right and select **Setup**.
3. In the Quick Find box, type **User Interface** and select it.
4. Scroll down to the **Setup** section on that page and check the box for **Enable MCP Service (Beta)**. Click Save.
5. Next, in the Quick Find box, type **mcp**.
6. Under **Integrations > API Catalog**, click on **MCP Servers**.
7. You will see a list of "Salesforce Servers" (Standard). Find **SObject Reads** (or your desired server).
8. Click the dropdown arrow next to it and select **Activate**.
9. Finally, click directly on the name of the server (**SObject Reads**) to open its Details page. 
10. At the bottom, find the **Server URL** (it should start with `https://api.salesforce.com/...`). **Copy this URL**, you will need it for LibreChat!

## Step 4: Create an External Client App (OAuth)

The Salesforce Hosted MCP Servers strictly require a specific OAuth scope (`mcp_api`). You must create an External Client App to grant LibreChat access.

1. In Salesforce Setup, search for **External Client App Manager** and click **New External Client App**.
2. **Basic Information:**
   - **External Client App Name:** `LibreChat MCP`
   - **Contact Email:** Enter your email address.
   - **Distribution State:** Leave as `Local`.
3. **API (Enable OAuth Settings):** Check the **Enable OAuth** box.
4. **App Settings:**
   - **Callback URL:** `http://localhost:3080/api/mcp/salesforce-object-reads/oauth/callback`
     *(Note: LibreChat dynamically builds this URL based on the server identifier. If you name your server something else, check the URL bar during the error to find the exact redirect_uri to paste here).*
   - **Selected OAuth Scopes:** Find these in the left box and click the right arrow to select them:
     - Manage user data via APIs (`api`)
     - Access Salesforce API Platform (`sfap_api`)
     - Access Salesforce hosted MCP servers (`mcp_api`)
     - Perform requests on your behalf at any time (`refresh_token`, `offline_access`)
5. **Flow Enablement:**
   - Check **Enable Authorization Code and Credentials Flow**.
6. **Security:**
   - Check **Enable Authorization Code and Credentials Flow**.
   - **IMPORTANT:** Check **Issue JSON Web Token (JWT)-based access tokens for named users** (Without this, Salesforce throws a 401 Unauthorized because the MCP Gateway requires a JWT).
   - **IMPORTANT:** Uncheck **Require secret for Refresh Token Flow** (if checked, it blocks LibreChat's background connection).
   - *(Leave the default PKCE and Refresh Token Rotation checkboxes as they are).*
7. Click **Create** at the bottom.
8. **CRITICAL STEP:** Salesforce's global API gateways take up to **30 minutes** to propagate changes to External Client Apps. If you try to connect LibreChat immediately, the connection will instantly drop or loop. Step away and grab a coffee before proceeding to Step 5!
9. **IMPORTANT:** After creating the app, click the dropdown next to it in the manager list to view/generate your **Consumer Key (Client ID)** and **Consumer Secret**. Save these!

> [!WARNING]
> Salesforce takes up to 10 minutes to propagate OAuth settings (like scopes and callback URLs). If you immediately try to connect in LibreChat and get an `OAUTH_APPROVAL_ERROR_GENERIC`, just wait 5 minutes and try again.

## Step 5: Connect LibreChat to Salesforce

1. Go back to your local LibreChat instance in your browser (`http://localhost:3080`).
2. Click the **MCP Servers** button (the puzzle piece or setting icon).
3. Click **"+"** or **"Add MCP Server"**.
4. Give it a name (e.g. `Salesforce`).
5. Set the Type to `streamable-http`. Server URL is `https://api.salesforce.com/platform/mcp/v1/sandbox/platform/sobject-reads`
6. Click the Auth tab and choose OAuth.
   - **Client ID:** Paste the Consumer Key from Step 4.
   - **Client Secret:** Paste the Consumer Secret from Step 4.
   - **Authorization URL:** `https://your-sandbox-domain.sandbox.my.salesforce.com/services/oauth2/authorize`
   - **Token URL:** `https://your-sandbox-domain.sandbox.my.salesforce.com/services/oauth2/token`
   - **Scope:** Delete whatever is in there (e.g., `read write`) and paste exactly: `api sfap_api mcp_api refresh_token offline_access`
7. Click **Save**. LibreChat will pop up a window to log you into Salesforce and grant it permissions!

## Step 6: Test Your Secure AI!
1. Start a new chat in LibreChat, or open the **Agent Builder** if you are creating a custom Agent.
2. Select your local AI model (e.g., `llama3.1:8b`).
3. **CRITICAL:** Click the **Tools** icon (puzzle piece) in the chat bar, or the Tools dropdown in the Agent Builder, and **select/toggle ON** the newly imported Salesforce tools (e.g., `salesforce_query`, `salesforce_read`).
4. Ask it: *"What are the names of the 3 most recently created Accounts in Salesforce?"*
