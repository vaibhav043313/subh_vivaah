# Project Requirements Document

Last updated: 2026-07-20

## Product

Subh Vivaah is a matrimonial web application for members who want to create a serious marriage profile, browse compatible profiles, receive match suggestions, communicate safely, and manage membership plans. Operators use the admin area to manage users, profiles, content, payments, subscriptions, contact messages, and feedback.

## Target Users

- Members looking for marriage prospects.
- Family-assisted profile owners who may manage a profile on behalf of a relative.
- Platform operators and administrators responsible for moderation, support, content, and membership operations.

## User Problems

- Members need a trusted place to present a complete matrimonial profile.
- Members need practical filters for location, community, profession, education, age, religion, height, verification, online presence, and photo availability.
- Members need lightweight ways to express interest, save profiles, and start a conversation.
- Operators need visibility into users, profiles, payments, subscriptions, content, and support messages.

## Current Baseline

The app already includes:

- Devise email/password authentication.
- Profile creation, profile editing, profile photos, visibility state, and profile completion score.
- Browse/search page with filters, grid/list modes, lazy loading, and similar profiles on profile detail pages.
- Basic match generation through `Matching::GenerateMatches`.
- Conversations, messages, Turbo broadcasts, message notifications, and profile-view notifications.
- Pricing, subscription, payment history views, blog, FAQ, contact, feedback, terms, and privacy pages.
- ActiveAdmin-backed operator admin.

## Core Requirements

### Authentication and Accounts

- Members can register, sign in, sign out, reset passwords, and manage account-level profile details.
- Each member should have one profile.
- New users receive the default `member` role.
- Admin access must require an assigned `admin` role.

### Profile Management

- Members can create and edit their own profile only.
- Profiles must support name, date of birth, gender, religion, caste/community, marital status, mother tongue, height, education, profession, income, city, state, country, bio, verification status, visibility, and photos.
- Profile completion should stay deterministic and based on important fields.
- Profile photo uploads should use Active Storage.

### Browse and Discovery

- Signed-in members can browse profiles other than their own.
- Browse filters should include free-text search, age range, gender, location, religion, caste/community, education, profession, mother tongue, height range, photo-only, online-now, verified-only, and sort mode.
- Browse should support pagination or lazy loading without duplicating records.
- Profile detail pages should show the selected profile and relevant similar profiles.

### Matching

- Matching should start with member preferences and evolve into a scoring system.
- Matching must avoid self-matches and duplicate match rows.
- Match score changes must be explainable enough for operators and future debugging.

### Member Interactions

- Members can start or continue a conversation with another member.
- Messages must be scoped to conversation participants.
- Notifications should be generated for profile views and received messages.
- Planned features: send interest, accept/reject interest, shortlist profiles, block/report profiles, and stronger privacy controls.

### Membership and Payments

- The app should present membership plans clearly.
- Payment history and subscription state should be visible to signed-in members.
- Real payment integration must be added behind explicit provider configuration and tested with sandbox credentials before production use.

### Admin and Operations

- Admins can review and manage users, roles, profiles, blog posts, payments, subscriptions, contact messages, and feedback.
- The system must prevent removal of the last administrator.
- Moderation and verification flows should be auditable.

### Trust, Privacy, and Safety

- Do not expose private member data without authorization.
- Respect profile visibility rules everywhere profiles are queried.
- Avoid logging sensitive data such as passwords, reset tokens, payment identifiers, private messages, and personal contact details beyond required Rails filtering.
- Add moderation support before enabling broad public discovery or payment-driven growth.

## Non-Goals For The Current App

- Native mobile apps.
- Microservices.
- Replacing Rails views with a SPA framework.
- Real-time video/audio calling.
- AI-generated compatibility claims without explicit product and legal review.

## Success Criteria

- A new member can register, complete a profile, browse matches, inspect a profile, and start a conversation.
- Browse filters return accurate, authorized, performant results.
- Admins can operate the platform without direct database access.
- New features include focused tests and do not break existing account, browse, profile, messaging, pricing, and admin flows.
