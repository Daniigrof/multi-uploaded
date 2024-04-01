
# Result the path of the new version file
function GetVersionPath() {
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = 'All files (*.*)|*.*'
    [void] $openFileDialog.ShowDialog()
    return $openFileDialog.FileName
}

Add-Type -AssemblyName System.Windows.Forms

# Get list of all apps names to update
function AppsToUpdate([System.Object[]]$Options) {
  
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Apps to update"
    $form.Size = New-Object System.Drawing.Size(300, 200)
    $form.StartPosition = "CenterScreen"
    
    $checkboxes = @()

    $y = 20
    foreach ($option in $Options) {
        $checkbox = New-Object System.Windows.Forms.CheckBox
        $checkbox.Text = $option.hostname
        $checkbox.Location = New-Object System.Drawing.Point(20, $y)
        $checkbox.Size = New-Object System.Drawing.Size(200,20)
        $form.Controls.Add($checkbox)
        $checkboxes += $checkbox
        $y += 25
    }

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(75, $y)
    $okButton.Size = New-Object System.Drawing.Size(75, 23)
    $okButton.Text = "OK"
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.Controls.Add($okButton)

    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = New-Object System.Drawing.Point(150, $y)
    $cancelButton.Size = New-Object System.Drawing.Size(75, 23)
    $cancelButton.Text = "Cancel"
    $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.Controls.Add($cancelButton)

    $form.AcceptButton = $okButton
    $form.CancelButton = $cancelButton

    $result = $form.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        #$selectedOptions = New-Object System.Collections.ArrayList
        $selectedOptions = @()
        foreach ($checkbox in $checkboxes) {
            if ($checkbox.Checked) {
                # $selectedOptions += $checkbox.Text
                $tmp = $Options | where { $_.hostname -eq $checkbox.Text}
                $selectedOptions += $tmp
            }
        }
        return $selectedOptions
    } else {
        return $null
    }
}


