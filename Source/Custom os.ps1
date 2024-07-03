function Test-Administrator {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Relaunch the script with administrator privileges if not already running as administrator
if (-not (Test-Administrator)) {
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    exit
}

# Import necessary assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Download the icon from the URL
$iconUrl = "https://raw.githubusercontent.com/Earljohn25/Windows-OS-ISO-Customizer/main/ScreenShot/Logo.ico"
$iconPath = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "Logo.ico")

Invoke-WebRequest -Uri $iconUrl -OutFile $iconPath

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Windows OS ISO Customizer"
$form.Size = New-Object System.Drawing.Size(557,250)
$form.StartPosition = "CenterScreen"

# Set the icon for the form
$form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($iconPath)

# Create labels and textboxes for input
$label1 = New-Object System.Windows.Forms.Label
$label1.Text = "Path to Windows ISO:"
$label1.AutoSize = $true
$label1.Location = New-Object System.Drawing.Point(10,20)
$form.Controls.Add($label1)

$textBox1 = New-Object System.Windows.Forms.TextBox
$textBox1.Location = New-Object System.Drawing.Point(150,20)
$textBox1.Size = New-Object System.Drawing.Size(300,20)
$form.Controls.Add($textBox1)

$label2 = New-Object System.Windows.Forms.Label
$label2.Text = "Path to unattended.xml:"
$label2.AutoSize = $true
$label2.Location = New-Object System.Drawing.Point(10,60)
$form.Controls.Add($label2)

$textBox2 = New-Object System.Windows.Forms.TextBox
$textBox2.Location = New-Object System.Drawing.Point(150,60)
$textBox2.Size = New-Object System.Drawing.Size(300,20)
$form.Controls.Add($textBox2)

$label3 = New-Object System.Windows.Forms.Label
$label3.Text = "Save new ISO as:"
$label3.AutoSize = $true
$label3.Location = New-Object System.Drawing.Point(10,100)
$form.Controls.Add($label3)

$textBox3 = New-Object System.Windows.Forms.TextBox
$textBox3.Location = New-Object System.Drawing.Point(150,100)
$textBox3.Size = New-Object System.Drawing.Size(300,20)
$form.Controls.Add($textBox3)

# Create a button to browse for ISO path
$buttonBrowse1 = New-Object System.Windows.Forms.Button
$buttonBrowse1.Text = "Browse"
$buttonBrowse1.Location = New-Object System.Drawing.Point(460,20)
$form.Controls.Add($buttonBrowse1)

# Create a button to browse for unattended.xml path
$buttonBrowse2 = New-Object System.Windows.Forms.Button
$buttonBrowse2.Text = "Browse"
$buttonBrowse2.Location = New-Object System.Drawing.Point(460,60)
$form.Controls.Add($buttonBrowse2)

# Create a button to browse for new ISO save path
$buttonBrowse3 = New-Object System.Windows.Forms.Button
$buttonBrowse3.Text = "Browse"
$buttonBrowse3.Location = New-Object System.Drawing.Point(460,100)
$form.Controls.Add($buttonBrowse3)

# Create a progress bar
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(10,140)
$progressBar.Size = New-Object System.Drawing.Size(520,20)  # Adjusted size to fit the form
$form.Controls.Add($progressBar)

# Create a button to start customization
$button = New-Object System.Windows.Forms.Button
$button.Text = "Execute"
$button.Location = New-Object System.Drawing.Point(200,180)  # Adjusted location to center the button
$form.Controls.Add($button)

# Add button click events for browsing
$buttonBrowse1.Add_Click({
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "ISO files (*.iso)|*.iso|All files (*.*)|*.*"
    if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $textBox1.Text = $openFileDialog.FileName
    }
})

$buttonBrowse2.Add_Click({
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "XML files (*.xml)|*.xml|All files (*.*)|*.*"
    if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $textBox2.Text = $openFileDialog.FileName
    }
})

$buttonBrowse3.Add_Click({
    $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveFileDialog.Filter = "ISO files (*.iso)|*.iso|All files (*.*)|*.*"
    if ($saveFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $textBox3.Text = $saveFileDialog.FileName
    }
})

# Add button click event for customization
$button.Add_Click({
    $isoPath = $textBox1.Text
    $unattendedPath = $textBox2.Text
    $newIsoPath = $textBox3.Text
    $mountPath = "C:\mount"

    try {
        # Update progress bar
        $progressBar.Value = 10
        
        # Mount the ISO
        Mount-DiskImage -ImagePath $isoPath
        $disk = Get-DiskImage -ImagePath $isoPath | Get-Volume
        $driveLetter = $disk.DriveLetter

        # Verify the drive letter
        if (-not $driveLetter) {
            throw "Failed to get the drive letter of the mounted ISO."
        }

        # Update progress bar
        $progressBar.Value = 30

        # Create mount path if it doesn't exist
        if (-Not (Test-Path -Path $mountPath)) {
            New-Item -Path $mountPath -ItemType Directory
        }

        # Grant necessary permissions to the mount directory
        $acl = Get-Acl $mountPath
        $permission = "NT AUTHORITY\SYSTEM","FullControl","Allow"
        $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
        $acl.SetAccessRule($accessRule)
        Set-Acl -Path $mountPath -AclObject $acl

        # Copy contents to mount path
        Copy-Item -Path "$($driveLetter):\*" -Destination $mountPath -Recurse -Force

        # Update progress bar
        $progressBar.Value = 50

        # Copy unattended.xml to appropriate location
        Copy-Item -Path $unattendedPath -Destination "$mountPath\autounattend.xml"

        # Update progress bar
        $progressBar.Value = 70

        # Ensure the output file has the .iso extension
        if (-not $newIsoPath.EndsWith(".iso")) {
            $newIsoPath = "$newIsoPath.iso"
        }

        # Create new ISO (using oscdimg)
        $oscdimgPath = "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe"
        if (-Not (Test-Path -Path $oscdimgPath)) {
            throw "Oscdimg.exe not found at path: $oscdimgPath"
        }

        # Correct the bootdata parameter formatting
        $bootData = "2#p0,e,b$mountPath\boot\etfsboot.com#pEF,e,b$mountPath\efi\microsoft\boot\efisys.bin"
        Start-Process -FilePath $oscdimgPath -ArgumentList "-m -o -u2 -udfver102 -bootdata:$bootData `"$mountPath`" `"$newIsoPath`"" -NoNewWindow -Wait

        # Update progress bar
        $progressBar.Value = 90

        # Dismount the ISO
        Dismount-DiskImage -ImagePath $isoPath

        # Update progress bar
        $progressBar.Value = 100

        [System.Windows.Forms.MessageBox]::Show("Customized ISO created successfully!", "Success")
    } catch {
        [System.Windows.Forms.MessageBox]::Show("An error occurred: $_", "Error")
    }
})

# Run the form
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()
