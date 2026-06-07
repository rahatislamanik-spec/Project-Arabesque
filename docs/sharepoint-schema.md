# Project Arabesque — SharePoint List Schemas

> Reference documentation for the three SharePoint Online lists that form
> the operational backbone of the IT Operations Hub.
> All lists are configured in a Microsoft 365 lab tenant.

---

## List 1 — Student Onboarding Tracker

**Purpose:** Central tracking record for every student onboarding request.
Populated automatically by the Power Automate onboarding flow when a Microsoft Forms submission is received.

**List URL:** `https://{tenant}.sharepoint.com/sites/ITOperations/Lists/StudentOnboardingTracker`

| Column Name | Type | Required | Description |
|---|---|---|---|
| Title | Single line of text | ✅ | Student full name (auto-populated from Forms) |
| StudentEmail | Single line of text | ✅ | Student M365 UPN (e.g. student@school.edu) |
| CountryOfOrigin | Single line of text | ✅ | Student home country |
| ArrivalDate | Date and Time | ✅ | Expected arrival date |
| ProgramEnrolled | Choice | ✅ | Ballet · Contemporary · Music · Academic |
| AccountStatus | Choice | ✅ | Pending · Created · Active · Suspended |
| DeviceAssigned | Yes/No | ✅ | Whether a device has been assigned |
| DeviceAssetTag | Single line of text | ❌ | Asset tag of assigned device |
| ResidenceRoom | Single line of text | ❌ | Residence room number if boarding |
| OnboardingComplete | Yes/No | ✅ | Full checklist completed by IT |
| ITNotes | Multiple lines of text | ❌ | Free-text notes from IT team |
| FormSubmissionID | Single line of text | ❌ | Microsoft Forms response ID for audit trail |
| CreatedBy | Person or Group | Auto | SharePoint auto-populated |
| Modified | Date and Time | Auto | SharePoint auto-populated |

**Indexed columns:** StudentEmail, ArrivalDate, AccountStatus
**Views:** All Students · Pending Accounts · Arriving This Week · Incomplete Onboarding

---

## List 2 — IT Asset Inventory

**Purpose:** Device assignment tracking across the student body.
Updated automatically when the onboarding flow logs a device assignment.

**List URL:** `https://{tenant}.sharepoint.com/sites/ITOperations/Lists/AssetInventory`

| Column Name | Type | Required | Description |
|---|---|---|---|
| Title | Single line of text | ✅ | Asset tag (e.g. NBS-LT-0042) |
| DeviceType | Choice | ✅ | Laptop · iPad · Desktop · Peripheral |
| Make | Single line of text | ✅ | Manufacturer (e.g. Dell, Apple, Lenovo) |
| Model | Single line of text | ✅ | Device model name |
| SerialNumber | Single line of text | ✅ | Device serial number |
| AssignedTo | Person or Group | ❌ | Current assigned user |
| AssignedToEmail | Single line of text | ❌ | User UPN for automation reference |
| AssignmentDate | Date and Time | ❌ | Date device was assigned |
| DeviceStatus | Choice | ✅ | Available · Assigned · In Repair · Retired |
| OperatingSystem | Choice | ✅ | Windows 11 · macOS · iPadOS · Other |
| IntuneEnrolled | Yes/No | ✅ | Whether device is enrolled in Intune |
| WarrantyExpiry | Date and Time | ❌ | Device warranty expiry date |
| Notes | Multiple lines of text | ❌ | Free-text notes |

**Indexed columns:** AssignedToEmail, DeviceStatus, IntuneEnrolled
**Views:** All Devices · Available · Assigned · Requires Attention

---

## List 3 — Offboarding Log

**Purpose:** Audit trail for every student departure and account decommission.
Populated by IT when a departure is logged, triggering the offboarding flow.

**List URL:** `https://{tenant}.sharepoint.com/sites/ITOperations/Lists/OffboardingLog`

| Column Name | Type | Required | Description |
|---|---|---|---|
| Title | Single line of text | ✅ | Student full name |
| StudentEmail | Single line of text | ✅ | M365 UPN being decommissioned |
| DepartureDate | Date and Time | ✅ | Student departure date |
| DepartureReason | Choice | ✅ | Graduation · Transfer · Withdrawal · End of Term |
| AccountDisabled | Yes/No | ✅ | Entra ID account disabled |
| LicenseReclaimed | Yes/No | ✅ | M365 license returned to pool |
| DeviceReturned | Yes/No | ✅ | Device returned and logged in Asset Inventory |
| MailboxRetained | Yes/No | ✅ | Whether mailbox is retained (alumni policy) |
| RetentionPeriodDays | Number | ❌ | Days mailbox retained before deletion |
| OffboardingComplete | Yes/No | ✅ | Full checklist signed off by IT |
| ITSignedOffBy | Person or Group | ❌ | IT team member who completed offboarding |
| Notes | Multiple lines of text | ❌ | Free-text notes |
| ConfirmationEmailSent | Yes/No | Auto | Set by Power Automate flow |

**Indexed columns:** StudentEmail, DepartureDate, OffboardingComplete
**Views:** All Departures · Pending Completion · Completed This Month

---

## SharePoint Site Structure

```
ITOperations (SharePoint Site)
├── Lists/
│   ├── StudentOnboardingTracker    ← Onboarding flow writes here
│   ├── AssetInventory              ← Device assignment tracking
│   └── OffboardingLog              ← Offboarding flow reads/writes here
├── Pages/
│   └── IT-Operations-Hub.aspx     ← Dashboard with list web parts
└── Documents/
    └── IT-Templates/               ← Email templates, checklists
```

---

*Project Arabesque — Microsoft 365 IT Automation Case Study*
*All SharePoint lists configured in a Microsoft 365 lab tenant using M365 E5 developer license.*
