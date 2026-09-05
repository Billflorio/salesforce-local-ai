# Prerequisites: The Beginner's Guide to the Tech Stack

If you are a Salesforce Admin and have never used Docker or LibreChat before, don't worry! This guide explains exactly what these tools are and why we are using them.

## 1. What is Docker?
Think of **Docker** like a virtual shipping container for software. Instead of you having to manually install 15 different tools and databases on your laptop to make an AI work, Docker packages all of them up into "containers." 
When we run Docker, it automatically downloads and starts everything we need inside these isolated containers. It keeps your laptop clean and guarantees that the software works the exact same way on your machine as it does on anyone else's.

### How to Install Docker Desktop:
1. **Download:** Go to [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/) and click "Download for Windows" (or Mac).
2. **Install:** Run the installer you just downloaded. Leave all the default checkboxes checked (especially WSL 2 if you are on Windows).
3. **Restart:** Your computer may prompt you to restart after installation.
4. **Open Docker:** Search for "Docker Desktop" in your Start Menu and open it. Accept the terms.
5. **Leave it running:** You will see a little whale icon in your system tray (bottom right corner). As long as that is running, you are good to go!

*(Note: If you run our `start.ps1` script on Windows, it will even offer to automatically download and install Docker for you!)*

## 2. What is LibreChat & Ollama?
- **Ollama** is the engine running under the hood. It downloads the AI model (like Llama 3.1) and runs it using your computer's hardware.
- **LibreChat** is the steering wheel. It is a beautiful, open-source web interface that looks exactly like ChatGPT, but it connects to your local Ollama engine. 

## 3. What is an MCP & mcp.json?
**MCP** stands for Model Context Protocol. It is an open standard that allows AI models to talk to external data sources safely.
Salesforce has built an MCP Server. When you ask LibreChat a question about Salesforce, LibreChat uses the MCP protocol to ask Salesforce for the data on your behalf.
The `mcp.json` file is simply a configuration file that tells LibreChat:
1. Where the Salesforce MCP server is located.
2. What your secure "Access Token" (password) is so it can log in to your Salesforce Org.

Once you have Docker Desktop installed and running, head back to the **main Repository Guide** on the GitHub homepage for instructions on how to download this code and boot it up on Windows, Mac, or Linux!
