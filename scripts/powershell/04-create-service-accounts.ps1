Import-Module ActiveDirectory
$Domain = "DC=hznlab,DC=local"
$ServiceOU = "OU=Service Accounts,$Domain"
$Password = ConvertTo-SecureString "HznLab2026!" -AsPlainText -Force

$Accounts = @(
@{Name="SQL Service";User="svc_sql"},
@{Name="Backup Service";User="svc_backup"},
@{Name="Web Service";User="svc_web"},
@{Name="Reporting Service";User="svc_reports"}
)

foreach ($Svc in $Accounts) {
    if (-not (Get-ADUser -Filter "SamAccountName -eq '$($Svc.User)'" -ErrorAction SilentlyContinue)) {
        New-ADUser -Name $Svc.Name -SamAccountName $Svc.User `
          -UserPrincipalName "$($Svc.User)@hznlab.local" -Path $ServiceOU `
          -AccountPassword $Password -Enabled $true -ChangePasswordAtLogon $false
    }
}

Write-Host "[+] Service-account creation complete."
