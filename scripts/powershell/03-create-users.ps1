Import-Module ActiveDirectory
$Domain = "DC=hznlab,DC=local"
$Password = ConvertTo-SecureString "HznLab2026!" -AsPlainText -Force

$Users = @(
@{First="Alice";Last="Morgan";User="amorgan";Dept="Executive";Title="Chief Executive Officer"},
@{First="Robert";Last="Chen";User="rchen";Dept="Executive";Title="Chief Financial Officer"},
@{First="Daniel";Last="Carter";User="dcarter";Dept="IT";Title="IT Manager"},
@{First="Sarah";Last="Mitchell";User="smitchell";Dept="IT";Title="Systems Administrator"},
@{First="James";Last="Wilson";User="jwilson";Dept="IT";Title="Help Desk Technician"},
@{First="Emily";Last="Rodriguez";User="erodriguez";Dept="Finance";Title="Controller"},
@{First="Michael";Last="Thompson";User="mthompson";Dept="Finance";Title="Accountant"},
@{First="Rachel";Last="Lee";User="rlee";Dept="Finance";Title="Accounts Payable Specialist"},
@{First="Jennifer";Last="Adams";User="jadams";Dept="HR";Title="HR Manager"},
@{First="Amanda";Last="Brooks";User="abrooks";Dept="HR";Title="HR Specialist"},
@{First="Christopher";Last="Davis";User="cdavis";Dept="Sales";Title="Sales Manager"},
@{First="Jessica";Last="Martinez";User="jmartinez";Dept="Sales";Title="Account Executive"},
@{First="Kevin";Last="Anderson";User="kanderson";Dept="Sales";Title="Account Executive"},
@{First="Brian";Last="Taylor";User="btaylor";Dept="Operations";Title="Operations Manager"},
@{First="Nicole";Last="White";User="nwhite";Dept="Operations";Title="Operations Analyst"},
@{First="Matthew";Last="Clark";User="mclark";Dept="Operations";Title="Operations Specialist"}
)

$DepartmentGroups = @{
Executive="GG_Executive"; IT="GG_IT"; Finance="GG_Finance"; HR="GG_HR";
Sales="GG_Sales"; Operations="GG_Operations"
}

foreach ($U in $Users) {
    if (-not (Get-ADUser -Filter "SamAccountName -eq '$($U.User)'" -ErrorAction SilentlyContinue)) {
        New-ADUser -Name "$($U.First) $($U.Last)" -GivenName $U.First -Surname $U.Last `
          -SamAccountName $U.User -UserPrincipalName "$($U.User)@hznlab.local" `
          -Department $U.Dept -Title $U.Title -Path "OU=$($U.Dept),OU=HZN Users,$Domain" `
          -AccountPassword $Password -Enabled $true -ChangePasswordAtLogon $false
    }
    Add-ADGroupMember $DepartmentGroups[$U.Dept] $U.User -ErrorAction SilentlyContinue
}

Add-ADGroupMember "GG_HelpDesk" "jwilson" -ErrorAction SilentlyContinue
Add-ADGroupMember "GG_ServerAdmins" "smitchell" -ErrorAction SilentlyContinue
Add-ADGroupMember "GG_WorkstationAdmins" "dcarter" -ErrorAction SilentlyContinue

Write-Host "[+] User population complete."
