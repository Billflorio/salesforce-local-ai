# Antigravity Build Log

| Date/Time | Component Updated | Action Taken & Notes |
|---|---|---|
| 2026-08-30 12:58 | System Initialization | Initial project architecture mapped and directories scaffolded. |
| 2026-08-30 13:00 | Demo Preparation | Drafted the 35-40 minute presentation outline (demo_outline.md). |
| 2026-08-30 13:01 | Salesforce MCP Integration | Created README instructions for SFDC External Client App generation and OAuth token retrieval. |
| 2026-08-30 13:03 | Validation & Testing | Created TESTING.md with integration tests for connectivity, FLS/OWD validation, and read-only enforcement. |
| 2026-08-30 13:12 | Automation | Created start.ps1 to automate Docker startup and JSON configuration, and rewrote the prerequisites README for non-developers. |
| 2026-08-30 13:14 | Automation | Updated start.ps1 to prompt and automatically install Docker Desktop via winget if missing, and expanded README.md with step-by-step Docker installation instructions. |
| 2026-08-30 13:28 | Automation | Updated start.ps1 to print Salesforce CLI instructions for retrieving tokens directly in the console. |
| 2026-08-30 13:29 | Automation | Added a check and automatic Winget installation for the Salesforce CLI (sf) to start.ps1. |
| 2026-08-30 13:38 | Automation | Fully automated Salesforce OAuth token retrieval inside start.ps1 using sf CLI json parsing. |
| 2026-08-30 13:52 | Security & Compliance | Added a strict disclaimer to start.ps1 and created a root README.md enforcing Sandbox/Dev Org usage and disclaiming maintenance/liability. |
| 2026-08-30 13:55 | Architecture | Refactored mcp.json generation in start.ps1 to use SSE format for the Hosted Beta. Configured LibreChat in docker-compose.yml to mount the mcp.json file natively. |
| 2026-08-30 13:59 | Architecture Pivot | Acknowledged that Salesforce Hosted MCP Beta requires manual UI configuration in the Org, and LibreChat MCP connections are better handled via the LibreChat web UI rather than hardcoded JSON mounts. |
