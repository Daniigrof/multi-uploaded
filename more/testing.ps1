# --------------------------
# The expected resule for Invoke-SSHcommand -Command for multy commands is:
# "mkdir -p /home/cix_user/deploy/tmp;;cd /home/cix_user/deploy/tmp;mkdir 2"

# You can use the next powershell commands to change to bash file as well

# 1
# $cmd = $cmd -join ';'
# Create one line with ; between the objects

# 2 
# [String[]]$Clear = Get-Content -Path .\bash\ClearOldVersion.sh | where{$_ -ne ""} 
# (| where{$_ -ne ""}) - delete empty lines

# 3 
# $cmd = $cmd.Trim()
# Delete all tabs and spaces from the start in line]
#------------------

#[String[]]$Clear = (Get-Content -Path .\bash\ClearOldVersion.sh | where{$_ -ne ""}).Trim()
function test() {
$cmd = "'mkdir -p /home/cix_user/deploy/tmp;'","'cd /home/cix_user/deploy/tmp'","'mkdir 2'"


Write-Host $cmd.GetType()
Write-Host $cmd

$cmd = $cmd -join ';'



Write-Host $cmd[0].GetType()
}
#$cmd = "mkdir -p /home/cix_user/deploy/tmp","cd /home/cix_user/deploy/tmp","mkdir 2"
#(gc cm) | ? {$_.trim() -ne ""} | Set-Content $cmd