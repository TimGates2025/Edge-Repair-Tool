# Microsoft Edge Repair Tool

This PowerShell-based tool helps IT admins and support staff repair or reinstall Microsoft Edge when it becomes unstable or refuses to launch.

## Features
- Terminates all Edge processes
- Attempts a built-in repair using WMI
- If needed, silently downloads and reinstalls the latest Edge installer (Enterprise edition)
- Generates a log file for diagnostics

## How to Use
1. Download or clone the repository.
2. Run `Repair-MicrosoftEdge.ps1` as Administrator.

```powershell
Right-click → Run with PowerShell (Admin)
