<#
.SYNOPSIS
    New Student M365 Account Provisioning — Project Arabesque
    Performs the manual IT provisioning steps that precede Power Automate flow execution.

.DESCRIPTION
    This script creates a new Microsoft 365 user account for an incoming student,
    assigns the appropriate license, and adds the user to the correct security groups.

    This is the IT-side provisioning step. Once the account is created, the Power Automate
    onboarding flow handles SharePoint tracking, welcome email, and IT alert generation.

    Designed for use by IT administrators at schools running Microsoft 365.

.PARAMETER StudentName
    Full name of the student (e.g. "Alex Morgan")

.PARAMETER StudentEmail
    M365 UPN to create (e.g. "a.morgan@school.edu")

.PARAMETER TempPassword
    Temporary password assigned at account creation. Student must change on first login.

.PARAMETER Program
    Student program/department for group assignment.
    Valid values: Ballet, Contemporary, Music, Academic

.PARAMETER LicenseSKU
    M365 license SKU ID to assign. Defaults to M365 E3.
    Get available SKUs with: Get-MgSubscribedSku | Select SkuPartNumber, SkuId

.PARAMETER WhatIf
    Run in dry-run mode — no changes made to M365 tenant.

.EXAMPLE
    # Dry run first — always
    .\New-M365OnboardingUser.ps1 `
        -StudentName "Alex Morgan" `
        -StudentEmail "a.morgan@school.edu" `
        -TempPassword "Welcome2026!" `
        -Program "Ballet" `
        -WhatIf

    # Actual provisioning
    .\New-M365OnboardingUser.ps1 `
        -StudentName "Alex Morgan" `
        -StudentEmail "a.morgan@school.edu" `
        -TempPassword "Welcome2026!" `
        -Program "Ballet"

.NOTES
    Requirements:
    - Microsoft.Graph PowerShell module (Install-Module Microsoft.Graph)
    - Permissions: User.ReadWrite.All, Group.ReadWrite.All, Directory.ReadWrite.All
    - Run: Connect-MgGraph -Scopes "User.ReadWrite.All","Group.ReadWrite.All" before executing

    Project Arabesque — Microsoft 365 IT Automation Case Study
#>

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory = $true)]
    [string]$StudentName,

    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[^@]+@[^@]+\.[^@]+$')]
    [string]$StudentEmail,

    [Parameter(Mandatory = $true)]
    [string]$TempPassword,

    [Parameter(Mandatory = $true)]
    [ValidateSet("Ballet", "Contemporary", "Music", "Academic")]
    [string]$Program,

    [Parameter(Mandatory = $false)]
    [string]$LicenseSKU = "05e9a617-0261-4cee-bb44-138d3ef5d965",  # M365 E3

    [switch]$WhatIf
)

#Requires -Modules Microsoft.Graph.Users, Microsoft.Graph.Groups

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# --- Group mappings by program ---
$ProgramGroups = @{
    "Ballet"       = "Students-Ballet"
    "Contemporary" = "Students-Contemporary"
    "Music"        = "Students-Music"
    "Academic"     = "Students-Academic"
}

$AllStudentsGroup = "All-Students"

function Write-Step {
    param([string]$Step, [string]$Message)
    Write-Host "[$Step] $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "  ✅ $Message" -ForegroundColor Green
}

function Write-DryRun {
    param([string]$Message)
    Write-Host "  [DRY RUN] $Message" -ForegroundColor Yellow
}

# --- Main ---
Write-Host ""
Write-Host "=================================================" -ForegroundColor Blue
Write-Host " Project Arabesque — M365 Student Provisioning" -ForegroundColor Blue
Write-Host " Student : $StudentName" -ForegroundColor Blue
Write-Host " UPN     : $StudentEmail" -ForegroundColor Blue
Write-Host " Program : $Program" -ForegroundColor Blue
if ($WhatIf) {
    Write-Host " Mode    : DRY RUN — no changes will be made" -ForegroundColor Yellow
}
Write-Host "=================================================" -ForegroundColor Blue
Write-Host ""

# Step 1: Verify Graph connection
Write-Step "1/5" "Verifying Microsoft Graph connection..."
try {
    $context = Get-MgContext
    if (-not $context) {
        throw "Not connected to Microsoft Graph. Run: Connect-MgGraph -Scopes 'User.ReadWrite.All','Group.ReadWrite.All'"
    }
    Write-Success "Connected as: $($context.Account)"
} catch {
    Write-Error "Graph connection failed: $_"
    exit 1
}

# Step 2: Check if user already exists
Write-Step "2/5" "Checking if UPN already exists..."
$existingUser = Get-MgUser -Filter "userPrincipalName eq '$StudentEmail'" -ErrorAction SilentlyContinue

if ($existingUser) {
    Write-Warning "User $StudentEmail already exists. Skipping account creation."
} else {
    # Step 3: Create M365 user account
    Write-Step "3/5" "Creating M365 user account..."

    $passwordProfile = @{
        Password                      = $TempPassword
        ForceChangePasswordNextSignIn = $true
    }

    $userParams = @{
        DisplayName       = $StudentName
        UserPrincipalName = $StudentEmail
        MailNickname      = ($StudentEmail -split "@")[0]
        AccountEnabled    = $true
        PasswordProfile   = $passwordProfile
        UsageLocation     = "CA"  # Canada — required for license assignment
        Department        = $Program
        JobTitle          = "Student"
    }

    if ($WhatIf) {
        Write-DryRun "Would create user: $StudentEmail (DisplayName: $StudentName, Department: $Program)"
    } else {
        $newUser = New-MgUser @userParams
        Write-Success "User created: $($newUser.UserPrincipalName) | ID: $($newUser.Id)"
    }
}

# Step 4: Assign M365 License
Write-Step "4/5" "Assigning M365 license..."

if ($WhatIf) {
    Write-DryRun "Would assign license SKU: $LicenseSKU to $StudentEmail"
} else {
    $userId = (Get-MgUser -Filter "userPrincipalName eq '$StudentEmail'").Id
    $licenseParams = @{
        AddLicenses    = @(@{ SkuId = $LicenseSKU })
        RemoveLicenses = @()
    }
    Set-MgUserLicense -UserId $userId -BodyParameter $licenseParams
    Write-Success "License assigned: SKU $LicenseSKU"
}

# Step 5: Add to security groups
Write-Step "5/5" "Adding to security groups..."

$groupsToAdd = @($AllStudentsGroup, $ProgramGroups[$Program])

foreach ($groupName in $groupsToAdd) {
    $group = Get-MgGroup -Filter "displayName eq '$groupName'" -ErrorAction SilentlyContinue

    if (-not $group) {
        Write-Warning "Group not found: $groupName — skipping"
        continue
    }

    if ($WhatIf) {
        Write-DryRun "Would add $StudentEmail to group: $groupName"
    } else {
        $userId = (Get-MgUser -Filter "userPrincipalName eq '$StudentEmail'").Id
        New-MgGroupMember -GroupId $group.Id -DirectoryObjectId $userId -ErrorAction SilentlyContinue
        Write-Success "Added to group: $groupName"
    }
}

# --- Summary ---
Write-Host ""
Write-Host "=================================================" -ForegroundColor Blue
if ($WhatIf) {
    Write-Host " DRY RUN COMPLETE — no changes made" -ForegroundColor Yellow
    Write-Host " Run without -WhatIf to provision the account" -ForegroundColor Yellow
} else {
    Write-Host " ✅ Provisioning Complete" -ForegroundColor Green
    Write-Host " Student    : $StudentName" -ForegroundColor Green
    Write-Host " UPN        : $StudentEmail" -ForegroundColor Green
    Write-Host " License    : Assigned" -ForegroundColor Green
    Write-Host " Groups     : $($groupsToAdd -join ', ')" -ForegroundColor Green
    Write-Host ""
    Write-Host " Next step: Power Automate onboarding flow will fire" -ForegroundColor Cyan
    Write-Host " automatically when the intake form is submitted." -ForegroundColor Cyan
}
Write-Host "=================================================" -ForegroundColor Blue
