---
name: build-actions-generator
description: "USE ONLY when generating OutSystems Developer Cloud (ODC) buildAction.json configuration files for Capacitor or Cordova mobile plugins targeting Android and iOS via MABS 12+. IGNORE for standard standalone Capacitor apps without ODC."
license: MIT
metadata:
  author: ionic
  source: https://github.com/ionic-team/capacitor-skills
  version: "1.0"
---

# ODC Build Actions Generator

Generates `buildAction.json` configuration files for OutSystems Developer Cloud (ODC) Mobile Libraries (Capacitor and Cordova plugins) and ODC apps targeting Android and iOS via MABS 12+.

## Activation Contract

**Load this skill when:**
- Generating `buildAction.json` for an ODC Mobile Library (Capacitor or Cordova plugin).
- Generating build actions for an ODC app requiring native mobile build configuration.
- Adapting a Cordova plugin for ODC (Capacitor-based) deployment.
- Configuring `AndroidManifest.xml`, Gradle files, or resource files for Android under MABS 12+.
- Configuring `Info.plist`, entitlements, or display names for iOS under MABS 12+.
- Defining input variables and conditional execution logic for mobile builds.

**Do NOT load this skill for:**
- Standalone Capacitor apps that build outside of OutSystems Developer Cloud.
- Legacy OutSystems (O11) or MABS versions prior to 12.
- Uploading or registering JSON in ODC Studio (developer manual step).
- Publishing or distributing plugins to npm.

## Hard Rules

1. **Root Output Location**: Output files MUST be written to `build-actions/` at the plugin root directory (`build-actions/buildAction.json` and `build-actions/README.md`). Never place inside platform subdirectories (`android/`, `ios/`).
2. **Strict File Naming**: Filenames must use camelCase without spaces (`buildAction.json`). Never use underscores or spaces.
3. **Platform Requirement**: At least one platform (`"android"` or `"ios"`) must be defined under the `"platforms"` key.
4. **Default Values on Variables**: Always include a `default` property on variable declarations unless the parameter is strictly required. Missing defaults without consumer parameters cause MABS builds to fail.
5. **Platform Variable Separation**: If a logical value diverges per platform (e.g. AdMob App IDs), expose separate variables with `_ANDROID` and `_IOS` suffixes (e.g. `ADMOB_APP_ID_ANDROID`, `ADMOB_APP_ID_IOS`).
6. **Prefer Config Over Code**: Use `manifest`, `gradle`, `plist`, and `entitlements` actions. Use `code` only when no config-level alternative exists; never use `patchFile` (unreliable in ODC).
7. **JSON Validation Gate**: Always validate syntax with `python3 -m json.tool` or Node before reporting completion. Never emit invalid JSON.

## Decision Gates

| Situation | Condition / Requirement | Action |
| --- | --- | --- |
| **Android Permissions** | `<uses-permission>` required | Inject or merge into `manifest` action |
| **iOS Permissions** | Privacy strings (`NSCameraUsageDescription`, etc.) | Merge into `plist` action under `Info.plist` |
| **Custom URL Schemes** | Deep links or OAuth callbacks | Merge intent-filter in `manifest` (Android) and `CFBundleURLTypes` in `plist` (iOS) |
| **Native Dependencies** | Third-party SDKs or Maven artifacts | Patch build scripts via `gradle` replace action |
| **Entitlements** | Capabilities required (Push, App Groups) | Add to `entitlements` action as an **object** (never an array) |
| **Standalone App Context** | Developer not using OutSystems | Inform developer that build actions only take effect in ODC MABS 12+ builds |

## Execution Steps

### 1. Read Input Signals
- Check for `input-contract.yaml` at the plugin root against [`references/build-action-spec.md`](references/build-action-spec.md).
- Scan Cordova source (`plugin.xml`) per [`references/cordova-plugin-scanning.md`](references/cordova-plugin-scanning.md) or Capacitor source per [`references/capacitor-plugin-scanning.md`](references/capacitor-plugin-scanning.md).
- If invoked via `cordova-plugin-migrator` (Phase 11a), write to the Capacitor plugin directory.

### 2. Gather Requirements and Variables
- Identify native requirements (permissions, dependencies, URL schemes, entitlements).
- Elicit or infer developer-controlled parameters per [`references/variables-and-conditions.md`](references/variables-and-conditions.md).

### 3. Map Requirements to Actions
- Map Android capabilities to `manifest`, `gradle`, `res`, `xml`, or `code` per [`references/android-build-actions.md`](references/android-build-actions.md).
- Map iOS capabilities to `plist`, `buildSettings`, `entitlements`, `frameworks`, or `code` per [`references/ios-build-actions.md`](references/ios-build-actions.md).
- Consult [`references/common-scenarios.md`](references/common-scenarios.md) for complex patterns (push notifications, app groups, background modes).

### 4. Generate and Validate JSON
- Write `build-actions/buildAction.json`.
- Validate syntax using `python3 -m json.tool build-actions/buildAction.json > /dev/null`. Verify balanced braces and escaped string quotes.

### 5. Generate Companion README
- Generate `build-actions/README.md` per [`references/readme-template.md`](references/readme-template.md).
- Document variables table, platform summaries, and ODC Studio setup steps per [`references/extensibility-configuration.md`](references/extensibility-configuration.md).

### 6. Terminal Summary
- Emit a concise confirmation note directing the developer to `build-actions/README.md`. Do not dump raw JSON content into the chat.

## Output Contract

Every run generates:
1. **`build-actions/buildAction.json`**: Syntactically valid configuration file declaring variables and platform actions.
2. **`build-actions/README.md`**: Documentation detailing required parameters, platform changes, and ODC Studio integration instructions.
3. **Execution Summary**: Compact terminal confirmation with next steps for MABS 12+ testing.

## References

| File | Purpose |
| --- | --- |
| [`references/build-action-spec.md`](references/build-action-spec.md) | Authoritative ODC build action JSON specification |
| [`references/variables-and-conditions.md`](references/variables-and-conditions.md) | Variable types, default values, and conditional operators |
| [`references/android-build-actions.md`](references/android-build-actions.md) | Schema and examples for all Android build actions |
| [`references/ios-build-actions.md`](references/ios-build-actions.md) | Schema and examples for all iOS build actions |
| [`references/cordova-plugin-scanning.md`](references/cordova-plugin-scanning.md) | Guide for scanning Cordova plugin.xml elements |
| [`references/capacitor-plugin-scanning.md`](references/capacitor-plugin-scanning.md) | Guide for scanning Capacitor plugin sources |
| [`references/extensibility-configuration.md`](references/extensibility-configuration.md) | Linking build action variables to ODC Studio parameters |
| [`references/common-scenarios.md`](references/common-scenarios.md) | Common plugin patterns and their build action equivalents |
| [`references/readme-template.md`](references/readme-template.md) | Template for the companion build-actions/README.md |
| [`references/validation-checklist.md`](references/validation-checklist.md) | Pre-flight validation checklist for build actions |
