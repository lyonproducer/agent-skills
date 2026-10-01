---
name: capacitor-uiscene-migrator
description: "USE ONLY when migrating Capacitor 8.x iOS apps or plugins to the 8.5 UIScene lifecycle, adopting SceneDelegate, fixing Xcode build failures, or resolving 'CLIENT OF UIKIT REQUIRES UPDATE'. IGNORE for Cordova migration (use cordova-plugin-migrator), plugin scaffolding (use capacitor-plugin-generator), or Android work."
license: MIT
metadata:
  author: ionic
  source: https://github.com/ionic-team/capacitor-skills
  version: "1.0"
---

# Capacitor UIScene Migrator

Guides Capacitor 8.4 → 8.5 iOS migrations to the UIScene lifecycle. The CLI migrator (`npx cap migrate`) handles projects that still match Capacitor templates; this skill handles partial migrations, hand-rolled delegates, custom `application(_:open:)` bodies, and plugin audits.

Canonical migration reference: [8.4 → 8.5 migration guide](https://capacitorjs.com/docs/updating/8-5).

## Activation Contract

**Load this skill when:**
- Migrating a Capacitor 8.x iOS app to the UIScene lifecycle (8.4 → 8.5).
- Resolving a project where `npx cap migrate` reported a partial state and skipped.
- Updating an app with a hand-rolled `SceneDelegate.swift` or customized `AppDelegate.swift`.
- Auditing a Capacitor plugin repository for UIScene compatibility.
- Diagnosing the Xcode warning: `"CLIENT OF UIKIT REQUIRES UPDATE: This process does not adopt UIScene lifecycle"`.

**Do NOT load this skill for:**
- Cordova-to-Capacitor plugin migration → use `cordova-plugin-migrator`.
- Generating a new Capacitor plugin → use `capacitor-plugin-generator`.
- Capacitor 9+ migrations (scope is strictly 8.4 → 8.5).
- Android lifecycle or general Capacitor debugging unrelated to the iOS scene lifecycle.

## Hard Rules

1. **Audit First, Edit Last**: Never modify a file before the developer has reviewed findings and confirmed.
2. **Surgical Merges Only**: Never overwrite existing `SceneDelegate.swift`, `AppDelegate.swift`, or `Info.plist`. Apply surgical insertions per [`references/surgical-merges.md`](references/surgical-merges.md).
3. **Prefer the CLI**: For eligible projects (0 of 3 signals present), delegate to `npx cap migrate` rather than hand-editing.
4. **Plugin Safety**: On plugin repositories, never touch `Info.plist`, `AppDelegate.swift`, or project files. Plugin branches are audit and advice only.
5. **No Version Control Mutation**: Do not run `git commit`, `git stage`, or `git push`. Leave VCS operations to the developer.
6. **Removed APIs**: `TmpViewController` and `CapacitorBridge.tmpWindow` are removed in 8.5. Any reference is a build error and must be deleted.
7. **Ask at Decision Points**: Ask explicitly before moving custom URL logic or cleaning legacy AppDelegate handlers.

## Decision Gates

| Situation | Signal / Condition | Action |
| --- | --- | --- |
| **Eligible Project** | 0 of 3 signals present | Run audit (Phase 4), confirm (Phase 5-6), hand off to `npx cap migrate` (Phase 7a) |
| **Already Migrated** | 3 of 3 signals present | Run audit only (Phase 4), run verification checklist (Phase 9) |
| **Partial Migration** | 1–2 of 3 signals present | Perform surgical merges for missing pieces only (Phase 7b) |
| **Plugin Repository** | `Package.swift` or `.podspec`, no `App.xcodeproj` | Run Phase 10 audit without touching app-level files per [`references/plugin-repo-audit.md`](references/plugin-repo-audit.md) |
| **Legacy URL Handlers** | Custom logic in `application(_:open:)` | Move custom logic into `scene(_:openURLContexts:)` alongside `SceneDelegateProxy.shared` |
| **Existing SceneDelegate** | Custom delegate present | Present diff before applying missing Capacitor forwarders |
| **Black Screen on Launch** | Window not configured in delegate | Add window creation in `scene(_:willConnectTo:)` from [`references/scene-delegate-template.md`](references/scene-delegate-template.md) |

## Execution Steps

### 1. Detect Repository Type
- **App**: Contains `ios/App/App.xcodeproj` or `capacitor.config.*` with `ios/`.
- **Plugin**: Contains `Package.swift` or `.podspec` and no `App.xcodeproj` → skip to Step 8 (Plugin Branch).

### 2. Check Prerequisites and Versions
- Ensure `@capacitor/ios` is 8.5+ in `package.json` (or upgrade via migration).
- Detect CocoaPods (`ios/App/Podfile`) vs SPM (`Package.swift` or Xcode SPM reference).

### 3. Classify Project State (The 3 Signals)
Check the 3 migration signals:
1. `Info.plist` contains `UIApplicationSceneManifest`.
2. `SceneDelegate.swift` exists in the app target directory.
3. `AppDelegate.swift` contains `UISceneConfiguration(name:`.

Routes:
- **0 of 3 (Eligible)** → Hand off to CLI (`npx cap migrate`).
- **3 of 3 (Migrated)** → Verify only.
- **1–2 of 3 (Partial)** → Apply surgical merges.

### 4. Audit Codebase
Execute the scan patterns from [`references/audit-patterns.md`](references/audit-patterns.md):
- Check for `UIApplication.shared.applicationState`.
- Check for custom bodies in `application(_:open:)` or `application(_:continue:)`.
- Check for references to removed APIs (`tmpWindow`, `TmpViewController`).

### 5. Present Findings and Resolve Decision Points
Report findings grouped by: **Build blockers**, **Judgement required**, and **Informational**.
Confirm:
- Keep or remove dead AppDelegate handlers (`application(_:open:options:)`).
- Approve diffs for custom `SceneDelegate` insertions.

### 6. Apply Changes
- **Eligible**: Run `npx cap migrate`. If any step was skipped, fall through to surgical merges for that step.
- **Partial**: Apply surgical merges per [`references/surgical-merges.md`](references/surgical-merges.md):
  - Merge `UIApplicationSceneManifest` into `Info.plist`.
  - Insert `configurationForConnecting` into `AppDelegate.swift`.
  - Create or patch `SceneDelegate.swift` from [`references/scene-delegate-template.md`](references/scene-delegate-template.md).
  - Register new file in `project.pbxproj` if needed.

### 7. Sync and Verify
- Run `npx cap sync ios`.
- Build target in Xcode if available to surface compilation issues.
- Complete the verification checklist:
  - App launches to WebView.
  - Background/foreground fires JS `resume`/`pause`.
  - Cold and warm URL schemes deliver to `appUrlOpen` and `App.getLaunchUrl()`.

### 8. Plugin Audit (Plugin Branch Only)
- Audit Swift sources per [`references/plugin-repo-audit.md`](references/plugin-repo-audit.md).
- Advise author to retain legacy notification names while supporting 8.4 alongside 8.5.

## Output Contract

Every invocation must provide:
1. **Classification Summary**: App vs plugin, signal count (X of 3), and migration route.
2. **Audit Findings**: Grouped by file, line number, and severity (blocker vs decision).
3. **Proposed Diffs**: Explicit code diffs before applying any change to `AppDelegate.swift`, `SceneDelegate.swift`, or `Info.plist`.
4. **Verification Status**: Results of `npx cap sync ios` and build checks.

## References

| File | Purpose |
| --- | --- |
| [`references/scene-delegate-template.md`](references/scene-delegate-template.md) | Standard 8.5 SceneDelegate template and custom-subclass variant |
| [`references/audit-patterns.md`](references/audit-patterns.md) | Grep and search patterns for lifecycle audit |
| [`references/surgical-merges.md`](references/surgical-merges.md) | Merge recipes for Info.plist, AppDelegate, and SceneDelegate |
| [`references/plugin-repo-audit.md`](references/plugin-repo-audit.md) | Guidelines for auditing and updating Capacitor plugins for UIScene |
