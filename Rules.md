# AI Coding Rules

Last updated: 2026-07-20

These rules guide AI-assisted coding in this repository.

## First Steps

- Inspect the current code before editing.
- Preserve existing user changes and unrelated files.
- Keep changes scoped to the requested feature or fix.
- Prefer improving an existing pattern over inventing a new one.
- Do not create `Memory.md` at project start. Create it after coding begins and update it as implementation decisions are made.

## Required Stack

- Use Ruby on Rails 8.1 patterns.
- Use PostgreSQL-compatible Active Record code.
- Use Devise for authentication.
- Use ActiveAdmin for admin features.
- Use Active Storage for uploads.
- Use Hotwire, Turbo, Stimulus, ERB, importmap, and Propshaft for the frontend.
- Use Solid Queue, Solid Cache, and Solid Cable when jobs/cache/cable need explicit app-level wiring.

## Avoid Unless Explicitly Approved

- React, Vue, Next.js, or another SPA framework.
- Node bundlers for application JavaScript.
- Redis, Sidekiq, Elasticsearch, or external search services.
- Payment providers, SMS, email marketing, or identity verification APIs.
- Large refactors unrelated to the requested change.
- Storing secrets in code, docs, fixtures, logs, or screenshots.

## Rails Conventions

- Put complex write flows in service objects under `app/services`.
- Put complex read/filter logic in query objects.
- Keep controllers responsible for authentication, authorization, parameter handling, and response selection.
- Keep validations and associations on models.
- Use strong parameters for every controller write.
- Use Rails path helpers in views.
- Use Rails form helpers and Turbo-compatible responses where possible.
- Keep enum values stable once persisted.

## Security and Privacy

- Authenticate protected member pages with `before_action :authenticate_user!`.
- Authorize ownership before profile, photo, message, subscription, or account changes.
- Never trust profile ids, conversation ids, attachment ids, or user ids from params without checking the current user can access the record.
- Do not expose private messages to non-participants.
- Do not show private, premium-only, hidden, blocked, or moderated profiles in browse/match results once those states are implemented.
- Do not log passwords, reset tokens, payment references, private message bodies, or sensitive profile data beyond standard filtered parameters.

## Error Handling

- Prefer validation errors and user-readable flash messages over unhandled exceptions for expected user mistakes.
- Return `:unprocessable_entity` when a form submission fails validation.
- Use redirects for successful HTML writes unless an existing Turbo Stream pattern applies.
- Keep JSON endpoints compatible with existing behavior.

## Database Rules

- Add migrations for schema changes; do not edit `db/schema.rb` by hand.
- Add indexes for new filters, foreign keys, uniqueness constraints, and high-cardinality lookup paths.
- Use database constraints where the business invariant must hold under concurrency.
- Avoid N+1 queries by using `includes`, `preload`, or joins intentionally.

## Frontend Rules

- Reuse existing CSS variables from `app/assets/stylesheets/application.css`.
- Prefer existing button, container, header, footer, form, browse, messaging, and profile-detail patterns.
- Use Tailwind utility classes only where the app already does or where they clearly reduce small view-level styling.
- Keep important UI states accessible on mobile and desktop.
- Do not add marketing-style hero pages for core app workflows.

## Testing Rules

- Add or update specs for new user-facing behavior.
- Prefer request specs for Rails flows crossing routes, controllers, authentication, and views.
- Add model or service tests for scoring, permissions, validation, notification, and matching logic.
- Keep tests deterministic; do not rely on random scores without stubbing or making the scoring deterministic.
- Run targeted tests for changed behavior. Run broader checks for shared behavior or high-risk changes.

## Documentation Rules

- Update these planning docs when product scope, architecture, phase order, or design direction changes.
- After real coding begins, maintain `Memory.md` with concise status, completed work, decisions, known issues, and next steps.
- Do not let `Memory.md` become a full codebase summary; keep it optimized for fast handoff.

## Completion Checklist

- Code follows existing Rails patterns.
- User authorization is enforced.
- Tests were added or a clear reason is documented.
- Relevant docs were updated.
- Commands run and failures are reported clearly.
