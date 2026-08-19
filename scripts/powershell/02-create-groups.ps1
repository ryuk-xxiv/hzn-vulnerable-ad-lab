Import-Module ActiveDirectory
$Domain = "DC=hznlab,DC=local"
$GroupOU = "OU=HZN Groups,$Domain"

$Globals = @(
"GG_Executive","GG_IT","GG_HelpDesk","GG_Finance","GG_HR","GG_Sales",
"GG_Operations","GG_ServerAdmins","GG_WorkstationAdmins"
)

foreach ($Group in $Globals) {
    if (-not (Get-ADGroup -Filter "SamAccountName -eq '$Group'" -ErrorAction SilentlyContinue)) {
        New-ADGroup -Name $Group -SamAccountName $Group -GroupCategory Security -GroupScope Global -Path $GroupOU
    }
}

$Locals = @("DL_FinanceShare_RW","DL_HRShare_RW","DL_SalesShare_RW")
foreach ($Group in $Locals) {
    if (-not (Get-ADGroup -Filter "SamAccountName -eq '$Group'" -ErrorAction SilentlyContinue)) {
        New-ADGroup -Name $Group -SamAccountName $Group -GroupCategory Security -GroupScope DomainLocal -Path $GroupOU
    }
}

Add-ADGroupMember "DL_FinanceShare_RW" "GG_Finance" -ErrorAction SilentlyContinue
Add-ADGroupMember "DL_HRShare_RW" "GG_HR" -ErrorAction SilentlyContinue
Add-ADGroupMember "DL_SalesShare_RW" "GG_Sales" -ErrorAction SilentlyContinue

Write-Host "[+] Group creation complete."
