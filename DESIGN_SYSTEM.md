1. Aesthetic Philosophy: "2010s Web Nostalgia"
The visual identity of YarnBop is heavily inspired by the 2010-2012 era of mobile and web design (reminiscent of early Twitter and Tumblr). The UI should feel structured, slightly tactile, and deeply nostalgic.

Avoid modern "Material 3" trends: Do not use massive border radii, floating bubbly components, or borderless floating inputs.

Embrace the grid: Content should live inside distinct white containers with visible light-gray borders resting on a slightly darker background canvas.

Tactile but clean: Buttons should look like buttons (subtle gradients, distinct boundaries), not just floating text.

2. Color Palette
The color scheme is rooted in cool, calming blues and high-contrast neutral grays.

Primary Brand (Top Bars & Active States): Classic Web Blue (#1DA1F2 or a slightly deeper Tumblr-esque Navy #36465D).

Background Canvas: Light Gray Canvas (#F5F8FA or #E1E8ED). The app background should never be pure white; pure white is reserved strictly for content cards.

Content Background: Pure White (#FFFFFF). Used for the main PDF viewer and project cards.

Borders & Dividers: Soft Gray (#E6E6E6).

Text (Primary): Dark Charcoal (#14171A).

Text (Secondary/Timestamps): Muted Gray (#657786).

Highlight/Accent: A warm, desaturated yellow (#FFF9C4) for the pattern line highlighter.

3. Typography
Typography should be hyper-legible, system-default sans-serif, echoing early mobile web typography.

Font Family: Use standard system fonts (Roboto on Android, or a fallback to Helvetica Neue/Arial).

Headers: Bold, crisp, and tightly tracked.

Body: Standard 14px - 16px for comfortable reading.

Links/Actions: Always in the Primary Brand Blue, occasionally underlined.

4. Component Architecture
Top App Bar: A solid block of the Primary Brand color spanning the full width of the screen. Title text should be pure white and bold. Drop shadow should be a sharp, short line (e.g., 0px 2px 4px rgba(0,0,0,0.1)), not a massive blur.

Cards & Containers: Pure white backgrounds, sharp or slightly rounded corners (maximum 4px to 6px border radius). Every card must have a distinct 1px solid border (#E6E6E6).

Buttons: Glossy-adjacent. Buttons should have a distinct background color, slightly darker borders, and a very subtle linear gradient from top to bottom.

Icons: Use classic, solid, heavily recognizable icon sets (e.g., standard Material icons or FontAwesome styled with flat colors).

5. Crafting UI Elements (The MVP Tools)
The interactive tracking tools must contrast clearly against the imported PDFs.


Mobile-Optimized PDF Viewer:  The PDF canvas should sit flush within the app body, surrounded by the gray background canvas to define its edges.


Overlay Counters:  The row and stitch counters should look like rigid, semi-transparent "widgets" or "badges" resting on the screen. They should have a dark, semi-transparent background (e.g., rgba(20, 23, 26, 0.85)) with crisp white text so they pop against any PDF. Use standard + and - button squares inside the widget.


Movable Line Highlighter:  A horizontal band spanning the width of the PDF with a semi-transparent warm yellow background (e.g., rgba(255, 249, 196, 0.5)). It should have thin, solid border lines on its top and bottom edges (e.g., rgba(200, 180, 0, 0.8)) to clearly define the active reading row.