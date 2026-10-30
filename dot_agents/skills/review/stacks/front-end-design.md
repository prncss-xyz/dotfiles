# Front-End Design

Use a toggle rather than a checkbox for an on/off state with an immediate effect. Use for settings that take effect without a save action.

Skip link. A visually hidden link that jumps to the main content. Appears on focus for keyboard users. Without it, every page requires tabbing through the full navigation first.

Capitalizing only the first word and proper nouns. The default for UI labels. Title Case On Everything reads like a legal document.

Never more than one primary button in the same view.

`dvh` (css) accounts for the mobile browser chrome that shows and hides on scroll. Using `vh` for full-screen mobile layouts often causes overflow because of this.

Avoid layout shift by reserving space before content loads and using size-matched font fallbacks.

An inner element inside a rounded container needs a smaller radius, calculated as outer radius minus padding. Matching both creates a visible gap.

Aspect ratio. The proportional relationship between width and height. Setting it on images and embeds lets the browser reserve the right space before the content loads, preventing layout shift.

Safe area. The part of a screen not obscured by notches or home indicators. Fixed bottom elements need to account for this or they sit underneath the home indicator.
