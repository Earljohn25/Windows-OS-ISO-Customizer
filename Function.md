1. Test-Administrator:
   - Checks if the script is running with administrator privileges.

2. Install-Tools:
   - Checks if Chocolatey and Windows ADK are installed.
   - Installs Chocolatey if not installed.
   - Installs Windows ADK if not installed.
   - Removes the "Install" menu item if both tools are installed.

3. Install-Chocolatey:
   - Downloads and installs Chocolatey.

4. Install-ADK:
   - Installs Windows ADK using Chocolatey.

5. Test-ChocolateyInstalled:
   - Checks if Chocolatey is installed.

6. Test-ADKInstalled:
   - Checks if Windows ADK is installed.

7. Customize ISO:
   - Handles the customization of a Windows ISO.
   - Mounts the specified ISO.
   - Copies its contents to a temporary location.
   - Adds an unattended installation file.
   - Creates a new customized ISO using oscdimg.
