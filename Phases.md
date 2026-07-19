# Development Phases

Last updated: 2026-07-20

The app is not starting from zero. These phases continue from the current Rails baseline: authentication, profiles, browse filters, messaging, notifications, pricing, admin, and static pages already exist.

## Phase 0: Project Alignment

Status: In progress

Scope:

- Add AI-friendly planning documents.
- Keep README as setup/product overview.
- Confirm local setup, CI commands, and baseline test status.
- Create `Memory.md` only after actual coding starts.

Done when:

- `PRD.md`, `Architecture.md`, `Rules.md`, `Phases.md`, and `Design.md` exist.
- Future AI sessions know the stack, roadmap, design system, and guardrails.

## Phase 1: Profile Onboarding and Preferences

Status: Planned

Scope:

- Improve post-registration flow so every member is guided into profile completion.
- Add or refine a dedicated preference setup UI.
- Clarify required vs optional profile fields.
- Improve profile completion score and empty-state guidance.

Done when:

- New users can register and complete a useful profile without console/admin help.
- Preferences can be edited from the member UI.
- Request/model specs cover onboarding, profile update, and preference update behavior.

## Phase 2: Browse and Profile Detail Polish

Status: Partially implemented

Scope:

- Strengthen browse filters, sorting, lazy loading, and empty states.
- Enforce future visibility/privacy rules inside `BrowseProfilesQuery` and `SimilarProfilesQuery`.
- Improve profile cards, detail sections, photo gallery behavior, and mobile ergonomics.
- Add saved filter handling only if product scope requires it.

Done when:

- Browse results are accurate, fast, authorized, and responsive.
- Profile detail pages show clear actions and do not expose unauthorized data.
- Specs cover important filter combinations and visibility behavior.

## Phase 3: Interest and Shortlist Flows

Status: Planned

Scope:

- Add send-interest behavior.
- Add accept, decline, and withdraw states.
- Add shortlist/save profile behavior.
- Add notifications for interest and shortlist events where appropriate.
- Add block/report foundations if needed before broader launch.

Done when:

- Members can express interest without immediately starting a conversation.
- Duplicate interest and self-interest are prevented.
- UI state reflects pending, accepted, declined, withdrawn, and shortlisted records.
- Specs cover authorization and state transitions.

## Phase 4: Matching Engine V2

Status: Planned

Scope:

- Replace placeholder random scoring with deterministic scoring.
- Include preference fit, age range, location, religion, mother tongue, education, profession, verification, profile completeness, and recent activity as appropriate.
- Store enough information to debug match quality.
- Move heavy generation to a background job if needed.

Done when:

- Match scores are deterministic and explainable.
- Match generation avoids duplicates and stale recommendations.
- Specs cover scoring, exclusions, and important edge cases.

## Phase 5: Messaging, Safety, and Realtime

Status: Partially implemented

Scope:

- Harden conversation access rules.
- Add participant checks everywhere conversations/messages are accessed.
- Improve unread counts, read receipts, and message empty/loading states.
- Add moderation hooks for reported messages if reporting is added.

Done when:

- Non-participants cannot view or post into conversations.
- Message notifications are reliable.
- Specs cover participant access and message creation.

## Phase 6: Membership and Payments

Status: Partially implemented

Scope:

- Finalize plan entitlements.
- Wire real payment provider only after provider selection.
- Add checkout, webhooks, payment reconciliation, and subscription lifecycle handling.
- Gate premium-only features through centralized policy methods.

Done when:

- Membership plans map to concrete permissions.
- Payment flow works in sandbox and handles webhook retries.
- Specs cover entitlement checks and payment state transitions.

## Phase 7: Admin, Moderation, and Trust

Status: Partially implemented

Scope:

- Expand admin workflows for profile review, verification, suspensions, contact/feedback triage, and content publishing.
- Add audit-friendly fields where needed.
- Add moderation states for profiles/photos/messages if product scope requires.

Done when:

- Operators can handle common support and moderation tasks without database access.
- Last-admin protection remains intact.
- Admin request/model specs cover critical permissions and state changes.

## Phase 8: Content, SEO, PWA, and Analytics

Status: Planned

Scope:

- Improve blog and public content structure.
- Add SEO metadata and social sharing basics.
- Enable PWA manifest/service worker only when install behavior is intentionally supported.
- Add privacy-conscious analytics after tool selection.

Done when:

- Public pages have useful metadata and stable content structure.
- Analytics do not leak sensitive member data.
- PWA behavior is tested on mobile.

## Phase 9: Scale and Performance

Status: Planned

Scope:

- Profile browse query optimization.
- Background jobs for matching, notifications, email, and payment workflows.
- Caching where it produces measurable benefit.
- Database indexes for real traffic patterns.
- Optional search integration only after PostgreSQL filtering becomes insufficient.

Done when:

- Key pages stay responsive under representative data volume.
- Slow queries are measured and addressed.
- Operational tasks have retryable job paths where needed.
