# Memory

Last updated: 2026-07-20

## Current State

- Project is a Rails 8.1 matrimonial app named Subh Vivaah.
- AI planning docs exist: `PRD.md`, `Architecture.md`, `Rules.md`, `Phases.md`, and `Design.md`.
- Actual coding has now begun, so this file tracks concise handoff context.

## Completed

- Added JSON support to the existing profile photo delete endpoint:
  - `DELETE /profiles/:id/photos/:attachment_id.json`
  - Success returns `200` with `message`, `profile_id`, `attachment_id`, and `remaining_photo_count`.
  - Unknown attachment returns `404` with `{ "error": "Photo not found." }`.
  - Non-owner access returns `403` with `{ "error": "You can only edit your own profile." }`.
- Preserved existing HTML redirect behavior for the profile photo delete button.
- Added request specs for JSON success, forbidden, and not-found cases.
- Fixed the profile photo edit modal so the delete `button_to` forms are not nested inside the photo upload `form_with`.
- Added a profile show regression spec that verifies the delete form renders outside/before the upload form in the photo dialog.
- Added app-level dark mode:
  - `theme.css` is loaded after page styles.
  - `shared/theme_bootstrap` initializes `html[data-theme]` before CSS loads.
  - Fresh visitors default to light mode; OS-level dark preference is intentionally ignored.
  - `theme_toggle_controller.js` stores the member preference in `localStorage` under `subh-vivaah-theme`.
  - The theme toggle is rendered in both the main app header and auth header.
- Dark-mode verification:
  - Focused request specs passed for home, auth registration, profile show, and profile photo deletion.
  - RuboCop passed for touched Ruby specs/controllers.
  - Browser smoke test on `http://127.0.0.1:3001/` confirmed the toggle changes `html[data-theme]` to `dark`, updates the accessible label, and applies dark body/card backgrounds.

## Relevant Files

- `app/controllers/profiles_controller.rb`
- `spec/requests/profiles_photo_spec.rb`
- `spec/requests/profiles_show_spec.rb`
- `app/views/profiles/_edit_modals.html.erb`
- `config/routes.rb`
- `app/assets/stylesheets/theme.css`
- `app/javascript/controllers/theme_toggle_controller.js`
- `app/views/shared/_theme_bootstrap.html.erb`
- `app/views/shared/_theme_toggle.html.erb`
- `app/views/layouts/application.html.erb`
- `app/views/layouts/auth.html.erb`
- `app/views/shared/_app_header.html.erb`
- `app/views/users/shared/_auth_header.html.erb`

## Notes

- The route already existed before this work: `destroy_photo_profile DELETE /profiles/:id/photos/:attachment_id(.:format)`.
- The original gap was API-style JSON responses, not the absence of a route.
- Runtime log `DELETE /profiles/:id` was caused by invalid nested form markup in the photo modal, not by a missing route.
