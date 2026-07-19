# Design Guide

Last updated: 2026-07-20

## Brand Direction

Subh Vivaah should feel trustworthy, modern, respectful, and practical. This is a matrimonial product, so the interface should prioritize clarity, privacy, profile detail, and confidence over flashy decoration.

## Current Design System

The main design tokens live in `app/assets/stylesheets/application.css`.
Dark-mode overrides live in `app/assets/stylesheets/theme.css`, which is loaded after page-specific styles.

```css
:root {
  --color-bg: #ffffff;
  --color-text: #0a0a0a;
  --color-muted: #5c5c5c;
  --color-border: #e5e5e5;
  --color-border-strong: #d4d4d4;
  --color-surface: #fafafa;
  --color-surface-dark: #f4f4f5;
  --color-primary: #ff5758;
  --color-primary-hover: #e64a4b;
  --font-sans: "Inter", system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
  --radius: 12px;
  --radius-sm: 8px;
}
```

## Typography

- Primary font: Inter.
- Fallback: system UI stack.
- Use clear hierarchy: page title, section title, card title, supporting text, metadata.
- Avoid viewport-width font scaling.
- Keep letter spacing normal except small uppercase labels that already use local patterns.
- Use restrained copy and avoid exaggerated marketing language inside product workflows.

## Color

- Base surfaces should remain white or near-white.
- Primary action color is coral red: `#ff5758`.
- Primary hover color is `#e64a4b`.
- Text should mostly use `#0a0a0a`, `#404040`, `#525252`, `#5c5c5c`, and `#737373`.
- Borders should use `#e5e5e5` or `#d4d4d4`.
- Secondary accents already used in browse/profile areas include cyan `#06b6d4`, orange `#f97316`, green `#22c55e`, blue `#3b82f6`, and semantic success/error colors.
- Avoid turning the app into a one-color theme. Use the coral brand color for primary calls to action and important badges, not for every surface.
- Light mode is the default for fresh visitors. Dark mode should only apply after a user explicitly toggles it, and should keep the same coral brand action color with neutral dark surfaces and readable muted text.

## Layout

- Use `.container` for standard pages and `.container--wide` for dense product pages.
- Keep app workflows dense but readable.
- Use full-width sections or direct layouts for page structure.
- Use cards for repeated profile items, plan items, messages, modals, and genuinely framed tools.
- Do not nest cards inside cards.
- Keep sticky headers and mobile menus consistent with the existing app header.
- Ensure the next section or core content remains visible below any hero-like area.

## Components

### Buttons

- Reuse `.btn`, `.btn--primary`, `.btn--outline`, and `.btn--sm`.
- Primary buttons are for the main action on a page or card.
- Outline buttons are for secondary actions.
- Keep buttons at stable dimensions and avoid text overflow on mobile.

### Forms

- Use Rails form helpers.
- Labels should be clear and close to their inputs.
- Validation failures should keep user input visible and show helpful messages.
- Use existing border, radius, focus, and flash styles.

### Profile Cards

- Cards should make identity, age, location, profession, verification, photo status, and primary actions easy to scan.
- Avoid hiding essential profile information behind hover-only interactions.
- Respect privacy and visibility rules before rendering fields.

### Browse Filters

- Filters should be compact, scannable, and mobile-friendly.
- Applied filters should be visible and removable.
- Empty states should explain what happened and provide an action to broaden the search.

### Messaging

- Conversation lists should prioritize unread state, latest message, participant identity, and recency.
- Message bubbles must distinguish current user vs other user clearly.
- Message input should stay reachable on mobile.

### Admin

- Admin UI should stay utilitarian and information-dense.
- Use ActiveAdmin conventions rather than custom public-site components unless the admin task clearly needs a custom page.

## Responsive Behavior

- Design mobile first, then expand to tablet and desktop.
- Do not let headers, buttons, profile names, filter chips, or nav items overlap.
- Use stable dimensions for repeated cards, photo areas, icon buttons, and filter controls.
- Test narrow mobile widths when changing header, browse, profile, messaging, or auth pages.

## Assets

- Use real product/profile imagery only when available and appropriate.
- Do not use dark, blurred, overly cropped, or generic stock-like images where users need to inspect people or profiles.
- Keep logos and icons crisp at mobile and desktop sizes.

## Accessibility

- Keep contrast readable on white and near-white surfaces.
- Preserve keyboard focus styles.
- Use semantic headings.
- Do not rely on color alone for status.
- Provide meaningful alt text for user-facing images where context requires it.

## CSS Ownership

- Global tokens and shared components: `app/assets/stylesheets/application.css`.
- Theme tokens, dark-mode overrides, and theme toggle styling: `app/assets/stylesheets/theme.css`.
- Auth pages: `app/assets/stylesheets/auth.css`.
- Browse/search: `app/assets/stylesheets/browse.css`.
- Messaging: `app/assets/stylesheets/messaging.css`.
- Profile detail: `app/assets/stylesheets/profile_show.css`.
- Pricing: `app/assets/stylesheets/pricing_page.css`.
- ActiveAdmin: `app/assets/stylesheets/active_admin.scss`.

Prefer editing the page-specific stylesheet for page-specific UI. Promote styles to `application.css` only when at least two areas need the same component.
