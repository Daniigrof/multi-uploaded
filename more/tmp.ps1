cd C:\Users\Administrator\Desktop\Daniel\IM

$machines = Get-Content -Path .\machines.json | ConvertFrom-Json

. .\FormsFunctions.ps1

$MachinesToDeploy = AppsToUpdate($machines)

Write-Host $MachinesToDeploy[0].GetType()
Write-Host $machines[0].GetType()

foreach ($x in $MachinesToDeploy)
{
$y = $x.ip
Write-Host $y.GetType()
}

