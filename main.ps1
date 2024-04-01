cd C:\Users\Administrator\Desktop\Daniel\IM
Import-Module .\Posh-SSH\Posh-SSH\2.3.0\Posh-SSH.psm1
Import-Module .\Posh-SSH\Posh-SSH\2.3.0\Posh-SSH.psd1

$machines = Get-Content -Path .\machines.json | convertfrom-json
$ClearOlds = ".\bash\ClearOldVersion.sh"
$dstPath = '/home/cix_user/deploy/apps'
$SSHConnections = New-Object System.Collections.ArrayList
$Credentiales = New-Object System.Collections.ArrayList

. .\FormsFunctions.ps1

$MachinesToUpdate = AppsToUpdate($machines)

# Create ssh connection for all the enabled machines
foreach ($machine in $MachinesToUpdate) {
    if (Test-Connection -ComputerName $machine.ip -Quiet -Count 1) {
        Write-Host ($machine.hostname + " are powered-on. Start copy the version...")

        $securePass = $machine.password | ConvertTo-SecureString -AsPlainText -Force
        $cred = New-Object -TypeName System.Management.Automation.PSCredential($machine.username,$securePass)
        $session = New-SSHSession -hostname $machine.ip -Credential $Cred -Force -WarningAction SilentlyContinue

        $Credentiales.Add($cred)
        $SSHConnections.Add($session)
    }
    else {
        Write-Error ($machine.hostname + " are powered-off")
    }
}

# Test if destination path are exist and copy the file
$cmd = "if [ -d $dstPath ]; then echo True; fi"

# Get the new version by selection window
$NewVer = GetVersionPath

for($conn = 0; $conn -lt $SSHConnections.Count; $conn++) {
    $isPathExist = (Invoke-SSHCommand -SSHSession $SSHConnections[$conn] -Command $cmd).output
    if ($isPathExist[0] -ne 'True') {
        Write-Host ("Path: $dstPath not exist on " + $SSHConnections[$conn].Session.ConnectionInfo.Host + '. created new.')
        Invoke-SSHCommand -SSHSession $SSHConnections[$conn] -Command "mkdir -p $dstPath"
    }
    
    # Copy and run the bash script on the machine
    Set-SCPFile -HostName $SSHConnections[$conn].Session.ConnectionInfo.Host -Credential $Credentiales[$conn] -LocalFile $ClearOlds -RemotePath /home/cix_user/deploy/ -Force -WarningAction SilentlyContinue
    Invoke-SSHCommand -SSHSession $SSHConnections[$conn] -Command "bash /home/cix_user/deploy/ClearOldVersion.sh"
    Invoke-SSHCommand -SSHSession $SSHConnections[$conn] -Command "rm /home/cix_user/deploy/ClearOldVersion.sh"

    # Copy the new version
    Set-SCPFile -HostName $SSHConnections[$conn].Session.ConnectionInfo.Host -Credential $Credentiales[$conn] -LocalFile $NewVer -RemotePath $dstPath -Force -WarningAction SilentlyContinue
    # $job1 = start-job { Set-SCPFile -HostName $SSHConnections[$conn].Session.ConnectionInfo.Host -Credential $Credentiales[$conn] -LocalFile $NewVer -RemotePath $dstPath -Force -WarningAction SilentlyContinue }
    # $job2 = start-job { Set-SCPFile -HostName $SSHConnections[$conn].Session.ConnectionInfo.Host -Credential $Credentiales[$conn] -LocalFile $NewVer -RemotePath /home/cix_user/deploy/ -Force -WarningAction SilentlyContinue }
}
