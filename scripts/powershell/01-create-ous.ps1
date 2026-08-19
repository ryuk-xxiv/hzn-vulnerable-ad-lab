Import-Module ActiveDirectory
$Domain = "DC=hznlab,DC=local"

foreach ($Name in @("HZN Users","HZN Computers","HZN Groups","Service Accounts","Disabled Accounts")) {
    if (-not (Get-ADOrganizationalUnit -LDAPFilter "(ou=$Name)" -SearchBase $Domain -SearchScope OneLevel -ErrorAction SilentlyContinue)) {
        New-ADOrganizationalUnit -Name $Name -Path $Domain
    }
}

$UserOU = "OU=HZN Users,$Domain"
foreach ($Name in @("Executive","IT","Finance","HR","Sales","Operations")) {
    if (-not (Get-ADOrganizationalUnit -LDAPFilter "(ou=$Name)" -SearchBase $UserOU -SearchScope OneLevel -ErrorAction SilentlyContinue)) {
        New-ADOrganizationalUnit -Name $Name -Path $UserOU
    }
}

$ComputerOU = "OU=HZN Computers,$Domain"
foreach ($Name in @("Workstations","Servers")) {
    if (-not (Get-ADOrganizationalUnit -LDAPFilter "(ou=$Name)" -SearchBase $ComputerOU -SearchScope OneLevel -ErrorAction SilentlyContinue)) {
        New-ADOrganizationalUnit -Name $Name -Path $ComputerOU
    }
}

Write-Host "[+] OU creation complete."
