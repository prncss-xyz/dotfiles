# Front-End Design

## Controls and labels

- Use a toggle rather than a checkbox for on/off settings that take effect immediately, without a save action.
- Default to sentence case for UI labels: capitalize only the first word and proper nouns.
- Use no more than one primary button in the same view.

## Keyboard navigation

Provide a visually hidden skip link that appears on focus and jumps to the main content, so keyboard users can bypass the navigation.

## Layout

- CSS `dvh` accounts for mobile browser chrome that appears and disappears on scroll. Using `vh` for full-screen mobile layouts often causes overflow.
- Avoid layout shift by reserving space before content loads and using font fallbacks with matching dimensions.
- Setting aspect ratios on images and embeds lets the browser reserve space before they load, preventing layout shift.
- For an element inside a rounded container, use an inner radius equal to the outer radius minus the padding. Matching the radii creates a visible gap.
- Account for the safe area around screen notches and home indicators when positioning fixed bottom elements.
