# Prerequisites

## Docker Desktop
To run the local AI environment, you need to install Docker Desktop.

### 🍎 Mac / 🐧 Linux
Download and install Docker Desktop from docker.com. It works out-of-the-box.

### 🪟 Windows Setup & Troubleshooting (IMPORTANT)
Docker on Windows requires a virtualization backend to run Linux containers. If you just install Docker blindly, it will fail to start!

**Before installing Docker on Windows:**
1. **Check BIOS:** Ensure CPU Virtualization (VT-x / AMD-V) is enabled in your computer's BIOS.
2. **Enable WSL2:** Open Windows PowerShell as Administrator and run:
   ```powershell
   wsl --install
   ```
3. **Restart your PC.**
4. *Now* you can install and launch Docker Desktop safely.

> **Note on Memory:** The default WSL memory limit is 50% of your host RAM. If you have 16GB or less, running the 8B models may cause your system to lag or crash.

## MCP (Model Context Protocol)
MCP is a standard that allows AI models to connect to external tools like Salesforce securely. We will configure LibreChat to talk to Salesforce via MCP.

## Ollama
Ollama runs the local AI models. We will be running Ollama inside a Docker container, so you do NOT need to install it separately unless you are running the Antigravity demonstration.
