1. Tech Stack & Environment

Framework: Flutter (Dart). 


Target Platform: Native Android. 


Core Paradigm: Strictly local-first and offline-ready. Do not include any cloud database configuration (no Firebase, no Supabase, no REST APIs). 

2. Architecture & Directory Structure

Feature-First Organization: The lib/ directory must be structured by feature, not by layer. 

Example: lib/features/pdf_reader/, lib/features/library/, lib/features/counters/.

Separation of Concerns: Keep business logic strictly separate from the UI. Widgets should only handle rendering and user interactions.

3. State Management & Data Persistence
State Management: Use Riverpod exclusively for all state management. Do not mix in Bloc, GetX, or standard Provider. 


Local Storage: Use a robust local database (like Isar, Hive, or SQLite) or SharedPreferences to guarantee active progress tracking. The app must automatically save row counts, stitch counts, and page positions without requiring a "save" button. 


File Handling: PDF files will be imported directly from device storage.  Store the local file path references securely to load patterns on subsequent app launches.

4. UI Implementation Rules
Strict Design System Adherence: Follow DESIGN_SYSTEM.md exactly. Do not use Material 3 rounded defaults, glassmorphism, or modern floating inputs. 

Widget Modularity: Break down the core crafting UI into small, isolated widgets. The movable line highlighter and the persistent overlay counters  must be separate components, not hardcoded into the main PDF view screen.


Responsive Layouts: Ensure the PDF document rendering and overlay widgets are optimized for mobile screens. 

5. Agent Instructions (Antigravity Directives)

Zero Scope Creep: Strictly adhere to the MVP.md. Do not attempt to write code for yarn stash management, smart text parsing, or audio features. 

Dependency Management: Before adding heavy third-party packages (especially for PDF rendering), verify they are compatible with standard Android Flutter implementations.

Focus on the Core Flow: Prioritize the successful loading of a local PDF and the functioning of the row counters over animations or transitions.