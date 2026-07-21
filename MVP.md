1. MVP Objective
The primary goal of the Minimum Viable Product (MVP) is delivering a rock-solid, local-first PDF pattern reader with interactive tracking tools. It must solve the core "walled garden" problem by allowing the user to import and track external PDF patterns without restrictions or paywalls.

2. Core User Flow
The user opens the app and sees a simple project library view to manage active and completed patterns.

The user imports a standard PDF pattern directly from their device storage.

The app renders the PDF document optimized for mobile screens.

The user utilizes a movable line highlighter and persistent floating counters to track progress as they craft.

The user closes the app, and their row counts, stitch counts, and page positions are automatically saved.

3. In-Scope Features (Must-Haves)

Universal PDF Import: The ability to load any standard PDF instantly without manual copy-pasting or editor re-formatting.


Mobile-Optimized PDF Viewer: Robust PDF document rendering optimized for mobile screens.


Movable Line Highlighter: A draggable overlay bar to keep focus on the active pattern instruction.


Overlay Counters: Persistent floating/overlay row and stitch counters paired with each pattern.


Active Progress Tracking: State management that automatically saves progress so the user can open the app and instantly resume where they left off.


Basic Project Library: A home screen view to manage active and completed patterns.

4. Out-of-Scope (Strictly Do Not Build Yet)

This section draws a strict boundary around scope creep.


No Cloud Sync or Accounts: The MVP is strictly local-first; do not implement user accounts or cloud sync.


No Smart Text Parsing: Do not attempt to extract text steps from imported PDFs into fully interactive, checkable list items.


No Selective Sizing: Allowing users to select their target garment size and highlighting only the relevant stitch count numbers is reserved for later versions.


No Yarn Stash Management: Do not build inventory managers for tracking yarn colorways or yardage.


No AI/Audio Features: No voice-assisted row counting, audio cues, or ambient sounds.


No Calculators: Built-in unit conversions and needle/hook size conversion charts are out of scope.
