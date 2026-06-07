# Project Arabesque — Power Automate Flow Logic

> Step-by-step documentation of both Power Automate cloud flows.
> This documents the decision logic, conditions, and actions in each flow.

---

## Flow 1 — Student Onboarding Flow

**Trigger:** When a new response is submitted in Microsoft Forms (Intake Form)
**Flow Type:** Automated Cloud Flow
**Owner:** IT Operations (M365 service account)
**Average Runtime:** ~15–30 seconds per submission

### Trigger Details

```
Trigger: Microsoft Forms — "When a new response is submitted"
Form: "New Student Intake Request"
Polling interval: Near real-time
```

### Step-by-Step Actions

```
STEP 1 — Get Form Response Details
────────────────────────────────────────────────────────
Action: Microsoft Forms — Get response details
Input:  Form ID + Response ID (from trigger)
Output: All form field values
        - Student Name
        - Student Email
        - Country of Origin
        - Arrival Date
        - Program Enrolled
        - Room Preference (Boarding/Commuter)

STEP 2 — Create SharePoint Record
────────────────────────────────────────────────────────
Action: SharePoint — Create item
List:   Student Onboarding Tracker
Fields populated:
        - Title          → Student Name (from Forms)
        - StudentEmail   → Student Email (from Forms)
        - CountryOfOrigin → Country (from Forms)
        - ArrivalDate    → Arrival Date (from Forms)
        - ProgramEnrolled → Program (from Forms)
        - AccountStatus  → "Pending" (default)
        - DeviceAssigned → No (default)
        - OnboardingComplete → No (default)
        - FormSubmissionID → Response ID (from trigger)

STEP 3 — Send Welcome Email to Student
────────────────────────────────────────────────────────
Action: Office 365 Outlook — Send an email (V2)
To:     Student Email (dynamic content from Step 1)
From:   IT Operations service account
Subject: "Welcome to [School] — Your IT Setup is Confirmed"
Body:   Personalized HTML email including:
        - Student name
        - Arrival date
        - Account setup instructions
        - IT support contact
        - Device collection process

STEP 4 — Send IT Alert to IT Team
────────────────────────────────────────────────────────
Action: Office 365 Outlook — Send an email (V2)
To:     IT distribution list (it-team@school.edu)
Subject: "New Student Onboarding — Action Required: [Student Name]"
Body:   IT checklist email including:
        - Student name, email, arrival date, program
        - Checklist items:
          □ Create M365 account
          □ Assign E3/E5 license
          □ Add to security groups (Students, Program group)
          □ Configure device and assign asset tag
          □ Update SharePoint tracker on completion

STEP 5 — Log to Asset Inventory (Conditional)
────────────────────────────────────────────────────────
Condition: If device type is selected in form (not blank)
Action (Yes): SharePoint — Create item in Asset Inventory
              Fields: DeviceType, AssignedToEmail, AssignmentDate
Action (No):  Skip — device assignment pending IT review

STEP 6 — Error Handling
────────────────────────────────────────────────────────
Scope: Configure run after → "has failed"
Action: Office 365 Outlook — Send email to IT admin
        Subject: "Arabesque Flow Error — Manual Review Required"
        Body: Flow run ID, error message, student details
```

### Flow Connections Required

| Connection | Used In |
|---|---|
| Microsoft Forms | Step 1 — trigger and response details |
| SharePoint | Step 2, Step 5 — create list items |
| Office 365 Outlook | Step 3, Step 4, Step 6 — send emails |

---

## Flow 2 — Student Offboarding Flow

**Trigger:** When a new item is created in SharePoint Offboarding Log list
**Flow Type:** Automated Cloud Flow
**Owner:** IT Operations (M365 service account)
**Average Runtime:** ~10–20 seconds per trigger

### Trigger Details

```
Trigger: SharePoint — "When an item is created"
Site:    ITOperations SharePoint site
List:    OffboardingLog
Note:    IT team manually creates the offboarding record
         Flow fires automatically on item creation
```

### Step-by-Step Actions

```
STEP 1 — Get Offboarding Record Details
────────────────────────────────────────────────────────
Action: SharePoint — Get item
Input:  Item ID from trigger
Output: All offboarding record fields
        - Student Name
        - Student Email
        - Departure Date
        - Departure Reason

STEP 2 — Send IT Offboarding Checklist
────────────────────────────────────────────────────────
Action: Office 365 Outlook — Send an email (V2)
To:     IT distribution list
Subject: "Offboarding Checklist — [Student Name] — Departs [Date]"
Body:   HTML checklist email including:
        □ Disable Entra ID account on departure date
        □ Revoke all active sessions (Entra ID sign-in logs)
        □ Remove from all M365 security groups
        □ Reclaim M365 license to available pool
        □ Apply mailbox retention policy (alumni: 90 days)
        □ Confirm device return and update Asset Inventory
        □ Remove from Teams channels and SharePoint sites
        □ Update Offboarding Log — mark OffboardingComplete = Yes

STEP 3 — Send Departure Confirmation to Student
────────────────────────────────────────────────────────
Action: Office 365 Outlook — Send an email (V2)
To:     Student Email (from SharePoint record)
Subject: "Your Departure Has Been Confirmed — [School]"
Body:   Personalized confirmation including:
        - Student name
        - Confirmed departure date
        - Data retention information
        - How to retrieve personal files before account closure
        - Alumni support contact

STEP 4 — Update Offboarding Log
────────────────────────────────────────────────────────
Action: SharePoint — Update item
List:   OffboardingLog
Fields: ConfirmationEmailSent → Yes
        Modified → (auto-updated by SharePoint)

STEP 5 — Error Handling
────────────────────────────────────────────────────────
Scope: Configure run after → "has failed"
Action: Office 365 Outlook — Send email to IT admin
        Subject: "Arabesque Offboarding Flow Error"
        Body: Flow run ID, error details, student record ID
```

### Flow Connections Required

| Connection | Used In |
|---|---|
| SharePoint | Step 1, Step 4 — read and update list items |
| Office 365 Outlook | Step 2, Step 3, Step 5 — send emails |

---

## Flow Design Principles

**Why SharePoint as the trigger for offboarding (not Forms):**
Offboarding requires IT judgment before it begins — confirming the departure, checking the date, applying the correct retention policy. A Forms trigger would fire immediately on submission without allowing for review. SharePoint item creation lets IT validate and initiate the process deliberately.

**Why email notifications over Teams adaptive cards:**
Email creates a persistent, searchable audit trail outside the M365 tenant for both the student and IT. Teams messages are ephemeral and not accessible if a channel is archived or the student loses access. Email to an external address ensures the student receives confirmation even after account closure.

**Why error handling scopes:**
A flow that fails silently is worse than no automation. If the SharePoint write fails, the student never gets a welcome email and IT never gets an alert — the onboarding falls through the cracks. Error notification to the IT admin ensures every failure is caught and handled manually.

---

*Project Arabesque — Microsoft 365 IT Automation Case Study*
