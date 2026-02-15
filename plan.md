# SimpleWeightTracker Staging Plan

## Objective
Ship a staging-level iOS app with full core functionality and production-quality UX, with theming/design included from the first implementation pass.

## Delivery Principles
- Theming and visual design are implemented from the start and applied to every feature as it is built.
- Vertical slices over isolated technical sequencing.
- `$swift` architecture constraints are followed throughout.
- Every task ends in a buildable, reviewable state.

## Scope (Staging)
- iOS app only.
- Watch app integration is out of scope for this sprint.
- Core scenes:
  - `HomeScene`
  - `HistoryScene`
  - `ProgressScene`
  - `SettingsScene`
- Exactly one app-level `TabView` in `ContentView`.
- Scene-owned navigation using `NavigationStack`, `NavigationLink(value:)`, and `.navigationDestination(for:)`.

## Staging Definition (Must Have)
- Target weight setup and update.
- Unit preference (`kg` / `lb`) with consistent display/edit behavior across all scenes.
- Weight entry create/edit/delete with destructive confirmation.
- Multiple entries per day.
- History browsing with grouping and filtering.
- Progress/trend insights (7-day/30-day, net change, goal distance, summary stats).
- Reminder scheduling with permission-aware UX states.
- Launch preload of persisted state before first feature render.
- Explicit loading/empty/error states in feature roots and route forms.
- Fully themed UI across all scenes and routes.

---

## Task 1: App Shell, Theme Foundation, and Scene Routing
### Deliverables
- Establish folder boundaries for Scenes, Features, Views, ViewModels, Components, Services, Stores, Protocols, Models.
- Replace placeholder app root with one `TabView` in `ContentView`.
- Wire root scenes:
  - `HomeScene`
  - `HistoryScene`
  - `ProgressScene`
  - `SettingsScene`
- Create route enums (`Hashable`) per scene.
- Add scene-owned `.navigationDestination(for:)` handlers.
- Implement app theme foundation used immediately by all roots:
  - color tokens
  - typography tokens
  - spacing/radius/shadow tokens
  - shared card/button/list styles
  - non-default background surfaces

### Verification
- App builds successfully.
- All tabs render using intended visual language, not placeholder defaults.

---

## Task 2: Domain Models and Route Payload Models
### Deliverables
- Add shared model types (one type per file):
  - `WeightEntry`
  - `WeightGoal`
  - `WeightUnit`
  - `WeightTrendPoint`
  - route-safe identifier/date payload models as needed
- Ensure persisted entities conform to `Codable`, `Identifiable`, `Hashable`, `Sendable` where valid.
- Ensure model visibility and initialization align with project rules.

### Verification
- Models compile cleanly.
- Scene routes compile using defined payload models.

---

## Task 3: Persistence Layer (Actor Stores + JSON + AsyncStream)
### Deliverables
- Implement reusable Documents directory path resolver.
- Implement reusable JSON encoder/decoder owners (instantiated once per owner scope).
- Add protocol-backed stores and actor implementations:
  - `WeightEntryStore`
  - `WeightGoalStore`
  - preferences stores as required
- Add read/write/update/delete operations with JSON file persistence.
- Add `AsyncStream` publication for store changes.

### Verification
- Add/update/delete operations persist and reload after relaunch.
- Store streams emit expected updates.
- App builds cleanly.

---

## Task 4: Service Layer and ServiceContainer Wiring
### Deliverables
- Add protocol-backed services over stores:
  - `WeightEntryService`
  - `WeightGoalService`
  - `UnitPreferenceService`
  - `ReminderService`
- Ensure ViewModels depend on services, not stores.
- Add `ServiceContainerProtocol` and concrete `ServiceContainer`.
- Ensure app root owns concrete container creation and passes dependencies down.
- Add preview/test-friendly service container variant.

### Verification
- Service operations map correctly to store operations.
- ViewModels compile against protocols only.
- App builds cleanly.

---

## Task 5: App Launch Preload State (Loading/Ready/Failed)
### Deliverables
- Add launch state model for `loading`, `ready`, `failed`.
- Load required persisted state before showing main feature scenes.
- Add launch loading and launch failure views.
- Provide retry path for launch failures.

### Verification
- Persisted goal/entries/preferences load before first feature render.
- Launch failure is surfaced in UI with actionable retry path.
- App builds cleanly.

---

## Task 6: HomeScene Core Flow (Today Summary + Quick Log + Entry Routes)
### Deliverables
- Add `HomeViewModel` with service stream subscriptions.
- Ensure UI-facing state mutations are main-actor safe.
- Build themed `HomeView` with:
  - current/latest weight
  - target distance summary
  - quick log actions
  - route links
- Implement Home routes:
  - add/edit entry
  - day detail
  - goal setup shortcut
- Apply persisted-form behavior where applicable:
  - save shown only on changes
  - reset shown only for persisted models with unsaved changes
  - delete shown only for persisted models
  - delete confirmation required
- Handle async user actions in Views via `Task` with cancellation checks where side effects exist.

### Verification
- Quick log writes persisted entries and updates UI immediately.
- Route navigation works and returns correctly.
- Form and delete-confirmation behavior matches required rules.
- App builds cleanly.

---

## Task 7: HistoryScene Core Flow (Grouped List + Filter + Entry Edit)
### Deliverables
- Add `HistoryViewModel` with day grouping projection.
- Build themed `HistoryView` with loading/empty/error states.
- Add filter flow (preset + custom date range).
- Add entry detail/edit route with persisted-form behavior.
- Keep all history navigation scene-owned via `NavigationLink(value:)` + scene destination handlers.

### Verification
- History shows correct grouped data from persisted entries.
- Filter updates projections correctly.
- Entry edits/deletes persist and refresh across scenes.
- App builds cleanly.

---

## Task 8: ProgressScene Core Flow (7d/30d Trend + Goal Distance + Stats)
### Deliverables
- Add `ProgressViewModel` deriving trend and summary metrics from services.
- Build themed `ProgressView` with:
  - 7-day and 30-day trend summaries
  - net change over selected range
  - goal distance
  - average/min/max stats
  - trend chart components
- Add interpretation states for trend direction (up/down/stable) with supportive language.

### Verification
- Progress values update after entry changes and goal/unit changes.
- Chart and summary calculations are consistent with underlying entries.
- App builds cleanly.

---

## Task 9: SettingsScene Core Flow (Goal, Units, Reminders, Permissions, Data Management)
### Deliverables
- Build themed `SettingsView` root with route sections.
- Implement routes:
  - goal settings
  - unit settings
  - reminder settings
  - notification permissions
  - data management
- Add persisted-form behavior for editable persisted-model routes.
- Implement reminder schedule configuration and clear/update behavior.
- Provide explicit permission-state components:
  - not determined
  - denied/restricted
  - authorized/provisional
- Ensure permission-denied states include clear next-action guidance.

### Verification
- Settings changes persist and reload correctly.
- Reminder and permission flows are explicit and actionable.
- App builds cleanly.

---

## Task 10: Cross-Feature Preference Propagation (Units/Goal Live Updates)
### Deliverables
- Wire `Home`, `History`, and `Progress` view models to observe unit and goal streams.
- Ensure displayed values and entry-edit forms remain unit-consistent.
- Ensure goal changes immediately affect progress/history summaries.

### Verification
- Unit change reflects across all scenes without relaunch.
- Goal changes reflect across all scenes without relaunch.
- App builds cleanly.

---

## Task 11: Staging Hardening (UX States, Accessibility, Concurrency, Warning-Free Build)
### Deliverables
- Audit all route and root screens for loading/empty/error/success states.
- Add accessibility labels/values/hints/identifiers for key controls, rows, and charts.
- Audit async side-effect paths for cancellation safety.
- Validate concurrency and isolation correctness.
- Remove all warnings and unsupported/deprecated API usage for supported targets.

### Verification
- Manual QA pass across primary user flows.
- Clean warning-free build.

---

## Task 12: Staging QA and Sign-Off
### Deliverables
- End-to-end regression pass:
  - create/edit/delete entries
  - history filtering
  - progress calculations
  - settings persistence and propagation
  - reminder permission states
- Update sprint documentation:
  - implemented behavior
  - known limitations
  - next-sprint watch integration hooks
- Final staging sign-off checklist completion.

### Verification
- Full app build succeeds with:
  - `xcodebuild -project SimpleWeightTracker.xcodeproj -scheme SimpleWeightTracker -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build`
- All staging-definition requirements are confirmed complete.

---

## Parallelization Strategy
- Parallel Track A: theme/components + scene shells.
- Parallel Track B: models/stores/services/preload.
- Merge point: Home flow first, then History/Progress, then Settings.
- Design is part of every implemented route, never a later rework stream.

## Done Definition
This sprint is complete only when all four scenes are fully functional, consistently themed, persistence-backed, permission-safe, and pass the final staging verification gate.
