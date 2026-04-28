# EA-XR Platform: SaaS Admin UI & Migration Strategy

This document consolidates all the design, architecture, migration strategy, UI prototypes, Figma specifications, AI policy definitions, repository scaffolding, and Unity XR admin scene considerations discussed in our conversation. It serves as a single reference for product managers, designers, engineers, and stakeholders.

## Introduction

We are building an enterprise-grade platform that combines traditional Enterprise Architecture (EA) capabilities with immersive XR visualization and AI intelligence. The platform must support admin control, data governance, LeanIX/Sparx migration, and integrate seamlessly with existing EA tools while offering a credible UI/UX for CIOs, EA teams, security teams, and sales.

## 1. SaaS Admin UI Prototype

The Admin UI is the control plane for the platform. It manages tenants & subscriptions, EA content governance, templates & standards, AI behavior guardrails, and XR client capabilities. Think of it as LeanIX Admin + Unity Control Panel + AI Ops Console.

### 1.1 Goals

- Tenants & subscriptions management
- EA content governance and standards enforcement
- Template management and blueprint library
- AI configuration and policy control
- XR client feature flags and device limits

### 1.2 Information Architecture

Primary navigation items (left rail):
```text
Dashboard
Organizations
Users & Roles
Licensing & Billing
Assets & Templates
EA Standards & Governance
AI Configuration
XR Clients
Integrations
Audit & Security
Settings
```

### 1.3 Screen Details

#### Dashboard
Contains executive and admin overview KPIs: active organizations, active users, EA objects count, AI requests, XR sessions today, compliance status. Example: 12 Orgs, 184 Users, 32,450 EA Objects, 9,200 AI Calls (month), 87 XR Sessions Today.

#### Organizations (Tenants)
List or table view: Org Name, Plan, Users, Assets, Status. Actions: view details, suspend/upgrade, impersonate admin, export EA Data.

#### Users & Roles
Define roles (Owner, Enterprise Architect, Domain Architect, Editor, Viewer) and toggle capabilities per role: create EA objects, run AI analysis, multiplayer XR, edit templates.

#### Licensing & Billing
Configure plans: seats, AI usage quotas, XR device limits, storage limits. Integrate with Stripe: invoices, usage-based billing, manual enterprise contracts override.

#### Assets & Templates
Manage 3D models, EA templates, departmental blueprints, assets library. Example: Standard IT Capability Map for retail (ArchiMate compliant, AI-assisted, XR-optimized).

#### EA Standards & Governance
Configure rules such as mandatory relationships (e.g. Application must link to ≥1 Business Capability), naming conventions, lifecycle states, obsolescence rules. Violations highlighted in Web and XR views.

#### AI Configuration
Control allowed AI actions (create/delete objects), prompt templates, retrieval-augmented generation (RAG) sources, data boundaries, explainability mode. Example toggles: allow create EA objects, disallow delete, suggestions only.

#### XR Clients Management
Manage supported XR devices (Quest 3, HoloLens 2, WebXR, Mobile AR): feature flags, session limits, performance profiles, offline mode.

#### Integrations
Inbound: LeanIX, Sparx EA, MEGA, ServiceNow, Azure DevOps; Outbound: ArchiMate exchange, CSV/JSON/Graph, API tokens.

#### Audit & Security
View logs for EA object changes, AI actions, user sessions, XR interactions.

### 1.4 Tech Stack
Frontend: Next.js + TypeScript, UI: MUI/Chakra, State: React Query, Auth: OIDC (Auth0/Azure AD), Charts: Recharts, API: REST → GraphQL; Deployment: Vercel/Azure Static Web Apps.

## 2. LeanIX / Sparx Migration Strategy

The migration should augment existing EA tools rather than replace them, visualize imported models in XR, and transition over time.

### 2.1 Philosophy
Don’t replace LeanIX/Sparx. Augment → Visualize → Transition. Let the platform become the immersive execution & intelligence layer on top of existing sources.

### 2.2 Supported Sources
LeanIX (Fact Sheets, Relations, Tags), Sparx EA (XMI, ArchiMate models), MEGA/HOPEX (XML/CSV exports).

### 2.3 Canonical Migration Pipeline
```text
Source Tool
 → Extract
 → Normalize
 → Map to Canonical EA Model
 → Enrich (AI)
 → Visualize in XR
```

### 2.4 LeanIX Mapping
Map LeanIX Fact Sheets & relations to canonical model: App → Application, Capabilities → BusinessCapability, Relation → EARelationship, Lifecycle → Metadata.lifecycle. Use API → JSON → EAObject.

### 2.5 Sparx EA Mapping
Export XMI, parse ArchiMate elements, preserve IDs & relationships, convert diagrams to spatial layouts, then enhance with AI explanations. Keep detailed modeling but overcome collaboration/visualization weaknesses.

### 2.6 AI-Assisted Migration
AI fills missing relationships, suggests mappings, detects duplicates, normalizes naming, explains models: e.g. “These 3 applications appear redundant. Recommend consolidation.”

### 2.7 Co-Existence Strategy
Phase 1: Visualization (XR = view only, legacy remains source of truth). Phase 2: Co-Authoring (sync changes both ways, AI recommendations cross boundaries). Phase 3: Transition (platform becomes primary, legacy optional).

### 2.8 Risk Mitigation
Data loss: read-only first; User resistance: immersive visualization wins hearts; Governance concerns: EA rules engine; Compliance: full audit trail.

### 2.9 Value Proposition
“We don’t replace your EA tool. We make it understandable, immersive, and intelligent.” Raise adoption by pitching augmentation and AI differentiation.

## 3. Figma Wireframes

### 3.1 File Structure
Use a clear Figma file organization:
```text
EA-XR Admin UI (Figma)
├── Foundations
│   ├── Color Styles
│   ├── Typography
│   ├── Icons
│   └── Spacing & Grid
├── Components
│   ├── Navigation
│   ├── Tables
│   ├── Cards
│   ├── Modals
│   └── Forms
├── Pages
│   ├── Dashboard
│   ├── Organizations
│   ├── Users & Roles
│   ├── Licensing & Billing
│   ├── Assets & Templates
│   ├── EA Standards
│   ├── AI Configuration
│   ├── XR Clients
│   ├── Integrations
│   └── Audit & Security
```

### 3.2 Core Layout
Frame: width 1440px, 12 column grid; Sidebar: 260px; Top bar height 64px; Left navigation persistent.

**Nav items:** Dashboard, Organizations, Users & Roles, Licensing & Billing, Assets & Templates, EA Standards, AI Configuration, XR Clients, Integrations, Audit & Security, Settings.

### 3.3 Dashboard Wireframe
Widgets as cards: Active Organizations, Active Users, XR Sessions Today, EA Objects, AI Requests This Month, Compliance Status (graph). KPI sizes large, card component usage.

### 3.4 Other Screens
- Organizations: Table with Org Name, Plan, Users, Assets, Status; a detail drawer.
- Users & Roles: Role list, toggles.
- EA Standards: list of rules (with toggles, severity).
- AI Config: toggles for AI actions, prompt templates, data sources.
- XR Clients: Device list with status and limits.

## 4. 3D UI Design (Pixel-Perfect Figma Instructions)

### 4.1 File Setup
- File name: `EA-XR-Admin-3D.fig`
- Pages: `01 – Foundations`, `02 – 3D Tokens`, `03 – Components`, `04 – Layouts`, `05 – Dashboard (3D)`, `06 – EA Standards (3D)`, `07 – AI Configuration (3D)`, `08 – XR Clients (3D)`, `09 – Dark Mode`.

### 4.2 Foundations
Canvas: 1440px × 1024px, grid 12 columns gutter 24 margin 32.
Typography: Inter (Title 20/600, Section 18/600, KPI 32/700, Body 14/400, Label 12/500).
Color tokens: Surface-0 #0E1117; Surface-1 #161B22; Surface-2 #1F2633; Surface-3 #2A3344; Accent Primary #4CAF50; Accent AI #7C8EFF; Accent Warning #F5A524; Accent Danger #F31260; Text Primary #E6EDF3; Text Secondary #9BA3AF. Radius: md=16, lg=20. Elevation: base (Y2 Blur6 Opacity0.12), card (Y6 Blur16 Opacity0.18), floating (Y12 Blur32 Opacity0.22).

### 4.3 3D Visual Language
Fake 3D with shadows: No borders, use shadows for depth: base panel (Y2 Blur6 Opacity12%), card (Y6 Blur16 Opacity18%), floating (Y12 Blur32 Opacity22%). Card radius 16–20px.

### 4.4 Core Layout
Left nav: 260px, surface-1, vertical auto layout; Top bar: height 64, gradient.

### 4.5 Dashboard (3D)
Frame: name `Dashboard / 3D Overview`. KPI Cards as floating planes: size 280×140, radius 20, dark color, values and labels; group into spatial planes with vertical offsets (0, 12, 24) to simulate depth. Use soft glow and hover states.

### 4.6 EA Standards Panel (3D Rule Board)
Rules list as stacked tiles: width 100%, height 72px, toggles, severity pills. On hover lift up. Violations get red glow. Expands into a detail drawer prefabs.

### 4.7 AI Config (3D Control Room)
Modules as dark blocks with inner glow accent: toggle animated states, sections for capabilities, prompt templates, RAG sources, explainability. Use auto layout.

### 4.8 XR Clients (Spatial Device Board)
Device cards with perspective skew: size 220x180, rotation -2°, effect: drop shadow, LED statuses, icon & names. Group them in a grid.

### 4.9 Components
Define components: Card/Base, Card/Floating, KPI Card, Rule Card, Toggle/3D, Sidebar Item, Glow Accent, Status Pill. Use Auto Layout.

### 4.10 Interaction Prototypes
Prototype interactions: hover lifts, click opens drawers, toggles glow, AI action confirmation.

## 5. AI Prompt & Policy Library

### 5.1 Prompt Architecture
Structure: System Prompt (domain rules, EA standards, org context, safety) + User Prompt → AI Response → Post-Processing (validation).

### 5.2 Sample System Prompt
```text
You are an Enterprise Architecture assistant.
You must follow ArchiMate principles.
You must respect organizational boundaries.
You must never delete data unless explicitly allowed.
Explain reasoning for all recommendations.
```

### 5.3 Example Prompts
- EA Creation: Create business capabilities for a retail organization. Ensure ArchiMate compliance. Return objects and relationships in JSON.
- EA Analysis: Analyze application landscape. Identify redundancy and risks. Explain findings in plain language.
- Migration: Map imported EA data to canonical model. Preserve IDs & relationships. Flag missing or invalid mappings.

### 5.4 AI Policies
Data Safety: no cross-tenant access, no external leakage, no hallucinations.
Action Restrictions: create allowed, modify allowed, delete disallowed unless approved, export allowed.

### 5.5 Output Validation
Validate AI output: schema, EA rules, permissions; audit log on each action; if invalid, retry or explain failure.

### 5.6 Explainability Mode
Return JSON with keys: action, reason, standardsApplied, confidence. E.g. `{ "action": "createCapability", "reason": "Requested by user", "standardsApplied": ["ArchiMate"], "confidence": 0.92 }`.

### 5.7 AI Modes (Admin Controlled)
- Suggest: proposals only.
- Co-Create: AI acts with approval.
- Autonomous: AI acts within defined rules.

## 6. Figma JSON Specs Summary

All of the design definitions are encoded into JSON for plugin consumption. The files reside in the `design/figma-json` folder of the starter repo. Each file encodes a Figma node: tokens, root frame, sidebar, card component, KPI card, dashboard layout, EA rule card, AI module, XR device card. Example snippet for design tokens:
```json
{
    "tokens": {
        "colors": {
            "surface-0": "#0E1117",
            "surface-1": "#161B22",
            ...
        },
        "radius": { "sm": 8, "md": 16, "lg": 20 },
        "elevation": { "base": { "y": 2, "blur": 6, "opacity": 0.12 }, "card": { "y": 6, "blur": 16, "opacity": 0.18 }, "floating": { "y": 12, "blur": 32, "opacity": 0.22 } },
        "typography": { "title": { "font": "Inter", "size": 20, "weight": 600 }, ... }
    }
}
```

For full definitions, see the files: design_tokens.json, root_frame.json, sidebar_component.json, card_component.json, kpi_card_instance.json, dashboard_layout.json, ea_rule_card.json, ai_module.json, xr_device_card.json.

## 7. Starter Repository Structure

We packaged everything into a starter repo for quick setup. The structure is: 
```text
ea-xr-platform-starter/
├── README.md
├── docs/
│   ├── architecture/ (placeholder)
│   ├── data-models/ (placeholder)
│   ├── api/ (placeholder)
│   └── roadmap/ (placeholder)
├── backend/ (placeholder README)
├── ai-services/ (placeholder README)
├── unity-client/ (placeholder README)
├── web-portal/ (placeholder README)
├── infra/ (placeholder README)
└── design/
    ├── README.md
    └── figma-json/
        ├── design_tokens.json
        ├── root_frame.json
        ├── sidebar_component.json
        ├── card_component.json
        ├── kpi_card_instance.json
        ├── dashboard_layout.json
        ├── ea_rule_card.json
        ├── ai_module.json
        └── xr_device_card.json
```

Placeholders can be filled in as implementation proceeds. Use the design JSON specs for the Figma plugin or manual import. See README files for guidance.

## 8. Unity XR Admin Scene Blueprint

To mirror the 3D UI in XR, create a Unity scene: `XR_Admin_ControlPlane.unity`. Use Unity 2023.3 LTS with URP and these packages: XR Interaction Toolkit, OpenXR Plugin, Input System, TextMeshPro, UI Toolkit. Configure OpenXR for Quest 3 and HoloLens with hand tracking, controllers, eye gaze.

### 8.1 Scene Overview
The scene represents a floating command deck in space, the spatial control plane.

### 8.2 Spatial Layout
Use world scale: 1 unit = 1 meter. The XR Origin contains Camera and offset. Arrange panels around user in an arc with radius 1.4m, panel height 1.2m, slight downward tilt (-8°). Panels: Dashboard, EA Standards, AI Control, XR Clients, User/Org overview.

### 8.3 Panel Prefabs (World-Space Canvas)
- **Dashboard Panel**: size 1.2m×0.7m; dark glass; KPI cards as floating planes with soft emissive edges; animated counters.
- **EA Standards Panel**: list of rule cards stacked, with glowing red for violations; expansion on select.
- **AI Configuration Panel**: AI mode selector, toggles, prompt preview; blue glow; subtle pulsing.
- **XR Clients Panel**: floating device cards tilted; status LEDs; tap for details.

### 8.4 Interaction Model
Input: Ray select for buttons/cards; Hand poke for toggles; Grab to move panels; Gaze for tooltips; Voice for admin commands. Manage XR inputs via XR Interaction Toolkit.

### 8.5 Depth & 3D Effects
Materials: URP dark surfaces (#161B22 with 95% alpha), subtle emissive edges; card materials using Surface-2 color, normal maps, shadow meshes. Simulate floating with scripts: e.g. FloatingCard.cs that animates upward/downward.

### 8.6 Architecture
Define XR UI Manager: holds PanelManager with references to each panel, DataBinding, VoiceController, XRInputRouter. Use DTO → UI patterns: update TextMeshPro values from API data.

### 8.7 Data Binding
Bind data to UI via DTO objects. Example script: `KpiCard.Bind(int value)` updates the displayed value. Fetch data from backend and update at run time.

### 8.8 Voice Commands
Support commands: "Show AI configuration", "Enable autonomous AI mode", "Highlight compliance violations", "Switch to XR clients panel". Implement intent parsing to route voice to UI actions.

### 8.9 Security & Safety UX
Require voice or visual confirmation for destructive actions. Show reasons, standards, and confidences for AI actions.

### 8.10 Performance Targets
Quest 3: 72–90 FPS; HoloLens: 60 FPS; Desktop XR: 90 FPS. Optimize with baked lighting, GPU instancing, canvas batching.

### 8.11 Unity Implementation Notes
Project: use URP pipeline. Setup XR rig with XR Interaction Toolkit. Create world-space canvases for panels. Use Auto Layout analogs in Unity (Layout Groups, Content Size Fitter). Code prefabs for panels. Provide scripts for floating effects, toggles, and UI update. Use voice recognition (Unity Windows/MRTK voice API or platform-specific).

This consolidated document covers all design and strategic aspects from our conversation, updated to reflect every user request: a conceptual and technical blueprint for the EA-XR platform. The Markdown includes the SaaS Admin UI design, migration plan, Figma specs (including 3D UI), AI policy definitions, the starter repo structure for implementation, and detailed instructions for creating an XR Admin Scene in Unity.

**Next high-value steps you can take:**
- Generate full TypeScript code for the Figma plugin to import the JSON specs automatically.
- Scaffold the React + Three.js + Tailwind implementation of the Admin UI.
- Build the Unity XR Admin Scene, including prefabs and scripts.
- Implement the backend and AI Services components.
- Expand docs with architecture details, API definitions, data models, and strategic roadmap.

Feel free to iterate further or ask for additional automation such as generating plugin code or demo storyboards!
