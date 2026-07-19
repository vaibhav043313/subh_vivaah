# Architecture

Last updated: 2026-07-20

## Architecture Style

Subh Vivaah is a Ruby on Rails modular monolith. Keep the app cohesive in one Rails codebase while isolating domain behavior through models, query objects, service objects, controllers, views, and admin resources.

## Technical Stack

- Ruby on Rails 8.1.
- PostgreSQL.
- Devise for authentication.
- ActiveAdmin for operator admin.
- Active Storage for profile photos.
- Hotwire: Turbo and Stimulus.
- ERB views.
- Importmap for app JavaScript. There is no Node bundler for app code.
- Propshaft assets.
- Tailwind Play CDN utilities with preflight disabled.
- Solid Cache, Solid Queue, and Solid Cable are available for database-backed cache, jobs, and Action Cable.
- RSpec, Rails test, RuboCop, Brakeman, bundler-audit, and importmap audit for quality checks.

## Request Flow

1. Browser requests a Rails route from `config/routes.rb`.
2. Controller authenticates and authorizes the request.
3. Controller delegates complex reads to query objects or complex writes to service objects.
4. Active Record models enforce associations, validations, callbacks, and scopes.
5. Views render ERB, Turbo Stream responses, or JSON where already supported.
6. Stimulus controllers handle small client-side interactions.
7. PostgreSQL stores application data; Active Storage stores uploaded photos.

## Main Modules

### Accounts and Roles

- `User` owns authentication, profile/preference associations, conversations, notifications, payments, subscriptions, and roles.
- `Role` and `UserRole` implement member/admin role assignment.
- Devise controllers live under `app/controllers/users`.

### Profiles and Discovery

- `Profile` stores member-facing matrimonial profile data and attached photos.
- `ProfilesController` owns browse, create, show, update, and photo removal.
- `BrowseProfilesQuery` owns browse filters and pagination.
- `SimilarProfilesQuery` owns profile-detail recommendations.
- `Profiles::CreateProfile` owns profile creation behavior.

### Matching

- `Preference` stores partner preference data.
- `Match` stores generated candidate relationships and score/status.
- `Matching::GenerateMatches` creates match rows from preferences.

### Messaging and Notifications

- `Conversation` stores one conversation between two users using lower/higher user ids for uniqueness.
- `Message` stores message content, updates conversation preview fields, broadcasts Turbo updates, and creates notifications.
- `Notification` stores in-app notifications for profile views and messages.

### Membership, Content, and Support

- `Subscription` and `Payment` back membership views.
- `BlogPost` backs public blog pages.
- `ContactMessage` and `FeedbackSubmission` back support and feedback forms.

### Admin

- ActiveAdmin resources live in `app/admin`.
- Admin must remain role-gated through the `admin` role.

## Folder Structure

```text
app/
  admin/                  ActiveAdmin resources
  assets/stylesheets/     Global and page-specific CSS
  controllers/            Rails controllers
  helpers/                View helpers
  javascript/controllers/ Stimulus controllers
  models/                 Active Record models and query objects
  services/               Domain service objects
  views/                  ERB and Turbo Stream views
config/                   Routes, environments, importmap, storage, jobs, cache
db/                       Migrations, schema, seeds
spec/                     RSpec request specs
test/                     Rails model/controller tests and fixtures
```

## Data Model Summary

- `users` has one `profile`, one `preference`, many `matches`, many `notifications`, many `payments`, many `subscriptions`, and many roles through `user_roles`.
- `profiles` belongs to `users` and has many attached `photos`.
- `conversations` reference two users through `user_lower_id` and `user_higher_id`; the pair is unique.
- `messages` belong to conversations and senders.
- `notifications` belong to users and may reference an actor and polymorphic notifiable record.
- `matches` link one user to one matched user with score and status.

## Architectural Rules

- Keep controllers thin. Move multi-step business logic into `app/services` and multi-filter reads into query objects.
- Keep Rails conventions unless a local pattern clearly says otherwise.
- Prefer server-rendered ERB with Turbo/Stimulus enhancements.
- Do not introduce a SPA framework or JavaScript build pipeline without an explicit product decision.
- Avoid direct SQL unless the query needs it; sanitize user input with Rails helpers.
- New profile visibility, privacy, and moderation rules must be enforced in every relevant query path, not only in the view.
- Background jobs should use Active Job/Solid Queue when work may become slow, retryable, or external-service dependent.

## Deployment Shape

- The app is deployable as a Rails web process with PostgreSQL.
- Docker and Kamal files are present.
- Solid adapters avoid mandatory Redis/Sidekiq at this stage.
- Future search, payment, and notification integrations should be introduced behind environment configuration.

## Quality Gates

- Prefer targeted specs during development.
- Run `bin/rubocop` before completing style-sensitive Ruby changes.
- Run `bundle exec rspec` or focused RSpec files for request-level behavior.
- Run `bin/ci` before larger merges when time and environment allow.
