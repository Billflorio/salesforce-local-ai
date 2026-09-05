# Prerequisites: The Beginner's Guide to Not Getting Ripped Off

If you're a Salesforce Admin and have never touched Docker or LibreChat before, keep reading. This isn't some corporate certification exam. This guide explains exactly what these tools are and why we're using them instead of paying for overpriced monthly subscriptions.

## 1. What the Hell is Docker?
Think of **Docker** like a virtual roadcase for software. Instead of you having to manually install 15 different tools, databases, and dependencies on your laptop until it crashes, Docker packages all of them up into isolated "containers." 
When we run Docker, it automatically downloads and starts everything we need. It keeps your machine from turning into a bloated mess and guarantees the software actually works on your machine exactly like it does on mine.

### How to Install Docker Desktop (Windows & Mac)
1. **Download:** Go to [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/) and grab the installer.
2. **Install:** Run it. Leave the default checkboxes checked (especially WSL 2 if you're stuck on Windows).
3. **Restart:** Your computer might nag you to restart. Just do it.
4. **Open Docker:** Open the app and carefully read every word of the license agreement.
5. **Leave it running:** You'll see a little whale icon in your system tray. If the whale is there, you're fudgy.

*(Note: If you run our `start.ps1` script on Windows, it will literally do all this crap for you.)*

### How to Install Docker (Linux)
**Do NOT install Docker Desktop!** Windows and Mac need that garbage because they require a hidden virtual machine to run containers. Linux natively supports this stuff. 
Just open your terminal and install the native Docker Engine:
```bash
sudo apt update
sudo apt install docker.io docker-compose-v2
```

## 2. What is LibreChat & Ollama?
- **Ollama** is the engine running under the hood. It downloads the AI model (like Llama 3.1) and forces it to run on your actual hardware instead of someone else's cloud server.
- **LibreChat** is the steering wheel. It's a gorgeous, open-source web interface that looks exactly like ChatGPT, but it connects to your local Ollama engine so you aren't feeding your data to corporate tech giants. For this exercise we're running it locally but it can be stood up for a whole company on a cloud server with many enterprise features.

## 3. What is an MCP & mcp.json?
**MCP** (Model Context Protocol) is an open standard. Basically, it's the wire that lets AI models talk to external databases safely.
Salesforce built an MCP Server (finally). When you ask LibreChat a question about your Org, LibreChat uses this protocol to grab the data.
The `mcp.json` file is just a config file that tells LibreChat:
1. Where the Salesforce MCP server is hiding.
2. What your secure "Access Token" is so it can actually log in.

Once you have Docker running, head back to the **main Repository Guide** and let's boot this thing up!
