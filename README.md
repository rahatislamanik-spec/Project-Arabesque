# Project Arabesque — NBS IT Automation System

### Microsoft 365 · Power Automate · SharePoint Online · Microsoft Forms · Zero Vendor Contracts

**Md Rahat Islam Anik · Self-Directed Case Study · 2025**

[![Live Case Study](https://img.shields.io/badge/Live%20Case%20Study-View%20Now-0078D4?style=for-the-badge&logo=microsoft&logoColor=white)](https://rahatislamanik-spec.github.io/Project-Arabesque)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-rahatislamanik-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/rahatislamanik)
[![GitHub](https://img.shields.io/badge/GitHub-rahatislamanik--spec-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/rahatislamanik-spec)

---

| 3 SharePoint Systems Built | 2 Automated Cloud Flows | 4 Email Automations Live | 0 Vendor Contracts Required |
|:---:|:---:|:---:|:---:|

---

## The Brief

Canada's National Ballet School is one of North America's only institutions offering elite dance training, full academic programming, and on-campus residence — all in one place. International boarding students arrive every semester from around the world. Each one needs a Microsoft 365 account, a configured device, network access, and residence coordination. Without automation, that's a manual checklist for a team of two.

**Project Arabesque** is an end-to-end IT automation system for international student onboarding and offboarding — built entirely on tools NBS already owns, deployable on day one.

---

## The Problem

**The Scale Problem**
300+ staff, students, visiting choreographers, and international partners — all supported by a small IT team. Manual onboarding doesn't scale without breaking something important.

**The Stakes Problem**
This isn't a tech company. When something breaks the morning of a performance, or a student arrives and their account isn't ready, it matters in a way that a missed meeting notification never does.

**The Tooling Problem**
The solution shouldn't require a $40,000 enterprise platform or a vendor contract. NBS already pays for Microsoft 365. The tools to solve this are already in the building.

**The International Variable**
Students arrive from Japan, Brazil, South Korea, the UK — different time zones, language needs, arrival dates. The onboarding process needs to work without manual coordination every time.

---

## The Solution

> Three systems. Two flows. Zero manual steps.

Project Arabesque is a Microsoft 365 IT Operations Hub built entirely on tools NBS already owns. No new software. No vendor contract. No training required for staff who submit requests.

### Onboarding Flow

```
Microsoft Forms          Power Automate           Outputs
─────────────────        ──────────────           ──────────────────────
Student submits    →     Cloud flow          →    SharePoint Tracker
intake request           triggered                Welcome Email → Student
                         automatically            IT Alert Checklist
                                                  Asset Inventory Log
```

### Offboarding Flow

```
SharePoint Item          Power Automate           Outputs
─────────────────        ──────────────           ──────────────────────
Departure logged   →     Offboarding flow    →    IT Offboard Checklist
by IT team               triggered                Student Confirmation
                                                  Offboarding Log Updated
```

---

## What Was Built

### Phase 1 — The NBS IT Portal

Three SharePoint lists form the operational backbone — a live onboarding tracker, an offboarding log, and a device asset inventory. Every student, every ticket, every device: one portal.

- **Student Onboarding Tracker** — live data showing student name, country of origin, arrival date, account status, device assignment, and onboarding completion
- **Offboarding Log** — departure records with account disable status, license reclaim confirmation, and audit trail
- **IT Asset Inventory** — device assignment tracking across the student body

### Phase 2 — Automated Onboarding Flow

When a new student intake form is submitted via Microsoft Forms, Power Automate triggers immediately — no human intervention required. The flow:

- Creates and populates the student record in the SharePoint Onboarding Tracker
- Sends a personalized welcome email to the student with account and access details
- Generates an IT Alert checklist for the IT team with all required provisioning tasks
- Logs the device assignment to the Asset Inventory

### Phase 3 — Automated Offboarding Flow

When IT logs a student departure in SharePoint, the offboarding flow triggers automatically:

- Generates an IT Offboard Checklist covering account disable, license reclaim, and device return
- Sends a confirmation email to the departing student
- Updates the Offboarding Log with completion status for audit purposes

---

## Tech Stack

| Category | Tools & Services |
|---|---|
| Forms & Intake | Microsoft Forms |
| Automation | Power Automate (Cloud Flows) |
| Data & Tracking | SharePoint Online (3 Lists) |
| Notifications | Office 365 Outlook |
| Collaboration | Microsoft Teams |
| Platform | Microsoft 365 (existing NBS licensing) |

---

## Skills Demonstrated

`Power Automate` · `Cloud Flow Design` · `SharePoint Online` · `Microsoft Forms` · `IT Process Automation` · `Low-Code Integration` · `IT Asset Management` · `Onboarding Workflow Design` · `Microsoft 365 Administration` · `Enterprise IT Operations`

---

## Live Case Study

The full interactive case study — covering the problem, solution architecture, flow diagrams, and SharePoint configuration — is published at:

**[rahatislamanik-spec.github.io/Project-Arabesque](https://rahatislamanik-spec.github.io/Project-Arabesque)**

---

## Author

**Md Rahat Islam Anik**
Cloud Computing & Network Administration · George Brown College · May 2026

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=flat&logo=linkedin)](https://linkedin.com/in/rahatislamanik)
[![GitHub](https://img.shields.io/badge/GitHub-Portfolio-181717?style=flat&logo=github)](https://github.com/rahatislamanik-spec)

---

## 🌐 Portfolio Ecosystem

This project is part of a multi-repo enterprise IT portfolio covering the full IT lifecycle.

| Layer | Project | Focus |
|---|---|---|
| 01 — Network Foundation | [Enterprise IT Network Diagnostics Toolkit](https://github.com/rahatislamanik-spec/Enterprise-IT-Network-Diagnostics-Toolkit) | DNS · Connectivity · Network Diagnostics |
| 02 — User Lifecycle | **You are here** | Onboarding · Offboarding · M365 Automation |
| 03 — Identity & Security | [Enterprise IT Security Operations Toolkit](https://github.com/rahatislamanik-spec/Enterprise-IT-Security-Operations-Toolkit) | Entra ID · Intune · Defender · Zero Trust |
| 04 — M365 Operations | [Meridian Institute M365 Lab](https://github.com/rahatislamanik-spec/Meridian-Institute-M365-Lab) | Exchange · Teams · SharePoint · Purview |

👉 [View Full Portfolio](https://rahatislamanik-spec.github.io/IT-Portfolio-Rahat-Islam-Anik/)
