# Design System Specification: The Sentinel Aesthetic

## 1. Overview & Creative North Star
**Creative North Star: "The Digital Concierge"**

This design system moves beyond the utility of a standard IoT dashboard to create a high-end, editorial experience. It is defined by **Tonal Depth** and **Atmospheric Security**. We reject the "flat" web; instead, we treat the interface as a physical space. By utilizing high-contrast typography scales (the precision of Manrope vs. the utility of Inter) and intentional asymmetry, we create a layout that feels curated, not templated. 

The system prioritizes "breathing room" (the 16-24 unit spacing range) to convey a sense of calm and total control. It is designed to feel like a premium piece of hardware—tactile, responsive, and unshakably secure.

---

### 2. Colors & Surface Philosophy
Our palette is rooted in a "Premium Dark" ethos, moving away from pure black into a sophisticated midnight spectrum.

*   **Primary Identity:** Use `primary` (#b2c5ff) for high-visibility actions and `primary_container` (#0052cc) for deep, authoritative backgrounds.
*   **The "No-Line" Rule:** 1px solid borders are strictly prohibited for sectioning. Structural definition must be achieved through background shifts (e.g., a `surface_container_low` card sitting on a `surface` background).
*   **Surface Hierarchy & Nesting:** Treat the UI as stacked layers of obsidian and frosted glass.
    *   **Level 0 (Base):** `surface` (#10141a)
    *   **Level 1 (Sections):** `surface_container_low` (#181c22)
    *   **Level 2 (Interactive Cards):** `surface_container` (#1c2026)
    *   **Level 3 (High-Detail Modals):** `surface_container_highest` (#31353c)
*   **The "Glass & Gradient" Rule:** Floating elements (like climate controls or security overlays) should utilize a `surface_variant` with a 60% opacity and a 20px backdrop-blur. 
*   **Signature Textures:** For primary CTAs, apply a subtle linear gradient from `primary` to `primary_container` at a 135-degree angle to provide a metallic, high-tech sheen.

---

### 3. Typography
We use a dual-typeface system to balance technical precision with editorial elegance.

*   **Display & Headlines (Manrope):** These are our "Statement" styles. Use `display-lg` (3.5rem) for hero states (e.g., "Welcome Home") and `headline-sm` (1.5rem) for room titles. The wide apertures of Manrope convey modern sophistication.
*   **Body & Utility (Inter):** Inter is our "Workhorse." Use `body-md` (0.875rem) for device statuses and `label-sm` (0.6875rem) for timestamps. Inter’s high x-height ensures readability in low-light IoT environments.
*   **Hierarchy Note:** Always maintain at least two scale steps between a headline and body text to ensure an authoritative, high-end contrast.

---

### 4. Elevation & Depth
Depth is the primary communicator of "Security." A flat UI feels flimsy; a layered UI feels fortified.

*   **The Layering Principle:** Avoid shadows for static elements. Simply shift the surface token (e.g., placing `surface_container_highest` on `surface_container`).
*   **Ambient Shadows:** For "Active" states or floating panels, use an extra-diffused shadow: `offset-y: 24px`, `blur: 48px`, `color: rgba(0, 0, 0, 0.4)`. The shadow must feel like a soft glow rather than a harsh edge.
*   **The "Ghost Border" Fallback:** If a boundary is required for accessibility, use the `outline_variant` token at 15% opacity. Never use 100% opaque lines.
*   **Inner Glows:** To simulate "State Awareness," apply a 1px inner stroke to active cards using `primary` at 20% opacity. This mimics the LED indicator on premium hardware.

---

### 5. Components
All components follow the **Roundedness Scale** (default: `1rem` / 16px; large: `2rem` / 32px for main containers).

*   **Security Buttons:**
    *   *Primary:* Gradient fill (`primary` to `primary_container`), `lg` rounded corners, `title-sm` typography.
    *   *Secondary:* `surface_container_high` background with a `Ghost Border`.
*   **Status Chips:** Small, pill-shaped (`full` roundedness). Use `tertiary` (#ffb59b) for "On Standby" and `success` for "Unlocked."
*   **Input Fields:** Use `surface_container_lowest` for the field background to create a "recessed" look. No borders. On focus, transition to an inner glow of `primary`.
*   **Smart Cards:** Forbid dividers. Use `spacing-6` (2rem) of vertical white space to separate the device name from its control toggle.
*   **The "Device Toggle":** A large-scale switch. The "on" track should use `primary`, while the "off" track blends into `surface_variant`.
*   **Security Visualizer (Custom Component):** A circular ring using a `primary` to `secondary` gradient to represent "System Health" or "Camera Coverage," utilizing the `display-md` typography for the central percentage.

---

### 6. Do's and Don'ts

**Do:**
*   **Do** use asymmetrical margins (e.g., a wider left margin for headlines) to create an editorial, high-tech feel.
*   **Do** use `surface_bright` to highlight the most important "Quick Action" on a page.
*   **Do** ensure all icons are "high-quality outline" style with a consistent 2px stroke weight to match the `outline` token.

**Don't:**
*   **Don't** use pure white (#FFFFFF) for text. Use `on_surface` (#dfe2eb) to reduce eye strain in dark environments.
*   **Don't** use standard 8px rounded corners. Stick to the `md` (1.5rem) and `lg` (2rem) scales to maintain the "Modern IoT" signature.
*   **Don't** use dividers or lines to separate list items. Use tonal shifts or the `spacing-4` (1.4rem) gap.
*   **Don't** use "Pop" colors for non-functional elements. Every color (Primary, Success, Error) must represent a specific system state.