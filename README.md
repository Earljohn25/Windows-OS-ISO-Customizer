# Windows-OS-ISO-Customizer
...

## ScreenShot:

![Screenshot of the application](https://github.com/Earljohn25/Windows-OS-ISO-Customizer/raw/main/ScreenShot/1.png)

![Screenshot of the application](https://github.com/Earljohn25/Windows-OS-ISO-Customizer/raw/main/ScreenShot/2.png)

![Screenshot of the application](https://github.com/Earljohn25/Windows-OS-ISO-Customizer/raw/main/ScreenShot/3.png)

![Screenshot of the application](https://github.com/Earljohn25/Windows-OS-ISO-Customizer/raw/main/ScreenShot/4.png)

![Screenshot of the application](https://github.com/Earljohn25/Windows-OS-ISO-Customizer/raw/main/ScreenShot/5.png)

![Screenshot of the application](https://github.com/Earljohn25/Windows-OS-ISO-Customizer/raw/main/ScreenShot/6.png)

## How to use

To run the script, open PowerShell and execute the following command:

![Screenshot of the application](https://github.com/Earljohn25/Windows-OS-ISO-Customizer/raw/main/ScreenShot/project_1.0.png)

```powershell
irm https://bit.ly/Windows_OS_ISO_Customizer | iex
```
## Functions:

1. **Test-Administrator:**
   - Checks if the script is running with administrator privileges.

2. **Install-Tools:**
   - Checks if Chocolatey and Windows ADK are installed.
   - Installs Chocolatey if not installed.
   - Installs Windows ADK if not installed.
   - Removes the "Install" menu item if both tools are installed.

3. **Install-Chocolatey:**
   - Downloads and installs Chocolatey.

4. **Install-ADK:**
   - Installs Windows ADK using Chocolatey.

5. **Test-ChocolateyInstalled:**
   - Checks if Chocolatey is installed.

6. **Test-ADKInstalled:**
   - Checks if Windows ADK is installed.

7. **Customize ISO:**
   - Handles the customization of a Windows ISO.
   - Mounts the specified ISO.
   - Copies its contents to a temporary location.
   - Adds an unattended installation file.
   - Creates a new customized ISO using oscdimg.

##High-Level Functionality:

1. **Check for Administrator Privileges:**
   - The script checks if it is running with administrator privileges. If not, it relaunches itself with elevated privileges.

2. **Form Creation:**
   - Creates a Windows Form for user interaction.
   - Provides text fields for the user to specify paths for the Windows ISO, unattended.xml file, and the save location for the new ISO.
   - Includes browse buttons for each text field to facilitate file selection.

3. **Menu and Button Initialization:**
   - Adds an "Install" menu item to install necessary tools (Chocolatey and Windows ADK).
   - Adds a progress bar to show the progress of ISO customization.
   - Adds a "Customize ISO" button to start the customization process.

4. **File Selection:**
   - Handles file browsing for the Windows ISO, unattended.xml, and save location.

5. **Tool Installation:**
   - Installs Chocolatey and Windows ADK if they are not already installed.

6. **ISO Customization:**
   - Mounts the specified Windows ISO.
   - Copies its contents to a temporary directory.
   - Adds the unattended.xml file to the copied contents.
   - Creates a new customized ISO using the oscdimg tool from the Windows ADK.
   - Updates the progress bar to reflect the progress of the customization process.

## Drawing (Flowchart):

```mermaid
graph TD
    A[Start Script] --> B[Check for Admin Privileges]
    B -->|If Not Admin, Relaunch as Admin| B
    B --> C[Create Form and Initialize Controls]
    C --> D[User Interacts with Form]
    D --> E[User Clicks "Install" Menu Item]
    E --> F[Check and Install Chocolatey and Windows ADK]
    F --> G[User Clicks "Customize ISO"]
    G --> H[Mount Windows ISO]
    H --> I[Copy ISO Contents to Temp Directory]
    I --> J[Add unattended.xml to Temp Directory]
    J --> K[Create New Customized ISO with oscdimg]
    K --> L[Update Progress Bar]
    L --> M[Display Success or Error Message]
    M --> N[End Script]



