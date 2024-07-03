# Windows-OS-ISO-Customizer

Functions:

1.	Test-Administrator:
o	Checks if the script is running with administrator privileges.

2.	Install-Tools:
o	Checks if Chocolatey and Windows ADK are installed.
o	Installs Chocolatey if not installed.
o	Installs Windows ADK if not installed.
o	Removes the "Install" menu item if both tools are installed.

3.	Install-Chocolatey:
o	Downloads and installs Chocolatey.

4.	Install-ADK:
o	Installs Windows ADK using Chocolatey.

5.	Test-ChocolateyInstalled:
o	Checks if Chocolatey is installed.

6.	Test-ADKInstalled:
o	Checks if Windows ADK is installed.

7.	Customize ISO:
o	Handles the customization of a Windows ISO.
o	Mounts the specified ISO.
o	Copies its contents to a temporary location.
o	Adds an unattended installation file.
o	Creates a new customized ISO using oscdimg.

High-Level Functionality:

1.	Check for Administrator Privileges:
o	The script checks if it is running with administrator privileges. If not, it relaunches itself with elevated privileges.

2.	Form Creation:
o	Creates a Windows Form for user interaction.
o	Provides text fields for the user to specify paths for the Windows ISO, unattended.xml file, and the save location for the new ISO.
o	Includes browse buttons for each text field to facilitate file selection.

3.	Menu and Button Initialization:
o	Adds an "Install" menu item to install necessary tools (Chocolatey and Windows ADK).
o	Adds a progress bar to show the progress of ISO customization.
o	Adds a "Customize ISO" button to start the customization process.

4.	File Selection:
o	Handles file browsing for the Windows ISO, unattended.xml, and save location.

5.	Tool Installation:
o	Installs Chocolatey and Windows ADK if they are not already installed.

6.	ISO Customization:
o	Mounts the specified Windows ISO.
o	Copies its contents to a temporary directory.
o	Adds the unattended.xml file to the copied contents.
o	Creates a new customized ISO using the oscdimg tool from the Windows ADK.
o	Updates the progress bar to reflect the progress of the customization process.
