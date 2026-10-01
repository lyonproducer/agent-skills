---
name: capacitor-plugin-generator
description: "USE ONLY when scaffolding or generating a new Capacitor plugin candidate with native iOS (Swift), Android (Kotlin/Java), and TypeScript bridge implementations from requirements or YAML contract. IGNORE for analyzing Cordova plugins (use cordova-plugin-migrator), upgrading Capacitor core, or publishing without review."
license: MIT
metadata:
  author: ionic
  source: https://github.com/ionic-team/capacitor-skills
  version: "1.0"
---

# Capacitor Plugin Generator

Generates reviewable Capacitor plugin candidates from conversational requirements or a structured YAML contract. The output follows official Capacitor plugin architecture, implementing TypeScript interfaces, web fallbacks, and native iOS (Swift) and Android (Kotlin/Java) bridges.

## Activation Contract

**Load this skill when:**
- Creating a new Capacitor plugin from scratch.
- Adding native functionality (camera, sensors, biometrics, storage) to a Capacitor app.
- Designing plugin architecture and TypeScript API contracts.
- Implementing native code for iOS (Swift) and Android (Kotlin/Java).
- Generating a plugin from a structured YAML plan handed off by `cordova-plugin-migrator`.

**Do NOT load this skill for:**
- Building standard Capacitor applications without custom native code.
- Web-only features that do not require native bridge bindings.
- Modifying existing Capacitor core plugins directly.
- Analyzing Cordova plugin structure → use `cordova-plugin-migrator` first.
- Publishing production-ready packages without human review.

## Hard Rules

1. **Contract-First Design**: Define `src/definitions.ts` before writing any native implementation. TypeScript interfaces drive web, iOS, and Android method signatures.
2. **Name Parity**: `registerPlugin('<PluginName>')` JavaScript name MUST match the iOS `jsName` and Android `@CapacitorPlugin(name = "<PluginName>")`.
3. **No Invented APIs**: Use only classes and APIs present in `@capacitor/core`, `@capacitor/android`, and `@capacitor/ios`. Never invent helper classes or import paths.
4. **Thin Bridge Pattern**: Keep plugin bridge classes thin. Split native logic into separate implementation and manager classes (two-class pattern).
5. **Canonical Error Taxonomy**: Always reject with codes from the standard 4-code taxonomy: `UNAVAILABLE`, `PERMISSION_DENIED`, `INVALID_PARAMETER`, or `OPERATION_FAILED`.
6. **Non-Interactive Scaffolding**: Always supply command-line flags to `npm init @capacitor/plugin` (`--name`, `--package-id`, `--android-lang`, etc.) to prevent hanging in non-TTY environments.
7. **Event Dispatch Locality**: Never invoke `notifyListeners()` from outside classes; all events must dispatch through the `Plugin` subclass.
8. **Dry-Run Only**: Never run a real `npm publish`. Run only `npm publish --access public --dry-run` and report verification status.

## Decision Gates

| Situation | Condition / Signal | Action |
| --- | --- | --- |
| **Input Format** | YAML with `plugin`, `platforms`, `api` | Parse per [`references/input-contract.md`](references/input-contract.md); skip elicitation questions |
| **Input Format** | Conversational prompt | Elicit missing plugin identity, methods, platforms, permissions, and configuration |
| **Web Layer** | Browser API is available | Feature-detect and bridge to browser API; throw `unavailable()` if not supported in current browser |
| **Web Layer** | No browser API exists | Implement method stub throwing `unimplemented()` per [`references/web-guide.md`](references/web-guide.md) |
| **Method Signature** | Single value or void result | Return `Promise<T>` |
| **Method Signature** | Continuous stream or watcher | Return callback registration returning `Promise<PluginListenerHandle>` |
| **Native Architecture** | Complex multi-manager subsystem | Use Facade pattern coordinating subsystems per [`references/architecture-patterns.md`](references/architecture-patterns.md) |
| **Native Architecture** | Standard single-capability plugin | Use Two-Class Bridge pattern (`Plugin` + Implementation class) |

## Execution Steps

### 1. Determine Entry Mode
- **Structured Mode**: Read [`references/input-contract.md`](references/input-contract.md). If input is YAML, validate schema, verify no Tier 3 blockers exist, and proceed non-interactively.
- **Conversational Mode**: Clarify plugin identifier, target platforms, methods, events, and native dependencies.

### 2. Scaffold Plugin Structure
- Run the official generator non-interactively per [`references/scaffolding.md`](references/scaffolding.md):
  ```bash
  npm init @capacitor/plugin <dir> -- --name "<name>" --package-id "<pkg>" --android-lang "kotlin" ...
  ```
- Enforce name parity across TypeScript, iOS, and Android.

### 3. Design TypeScript API
- Author `src/definitions.ts` per [`references/api-design.md`](references/api-design.md).
- Create typed options and result interfaces for every method. Use string unions over enums.
- Document all symbols with JSDoc and `@since`.

### 4. Implement Web Layer
- Author `src/web.ts` extending `WebPlugin` per [`references/web-guide.md`](references/web-guide.md).
- Wire dynamic registration in `src/index.ts`.

### 5. Implement iOS Native Layer
- Author `ios/Sources/<PluginName>/` per [`references/ios-implementation.md`](references/ios-implementation.md).
- Implement bridge class decorated with `@objc(<PluginName>)` and separate implementation class.
- Configure permissions using [`references/permission-patterns.md`](references/permission-patterns.md).

### 6. Implement Android Native Layer
- Author `android/src/main/java/.../` per [`references/android-implementation.md`](references/android-implementation.md).
- Annotate with `@CapacitorPlugin` and `@PluginMethod`. Place each public Java/Kotlin class in its own file.

### 7. Generate Sample App
- Scaffold or update a sample app exercising all plugin methods, permissions, listeners, and error cases per [`references/sample-app.md`](references/sample-app.md).

### 8. Document and Verify
- Generate API docs from JSDoc using `npm run docgen`. Do not hand-write markdown API tables.
- Run verify scripts: `npm run verify` (`verify:ios`, `verify:android`, `verify:web`) per [`references/testing-strategies.md`](references/testing-strategies.md).
- Execute publish dry run: `npm publish --access public --dry-run` per [`references/publishing.md`](references/publishing.md).

## Output Contract

Every generated plugin must produce:
1. **Package Scaffold**: Complete Capacitor plugin structure with valid `package.json`, `tsconfig.json`, and dependencies.
2. **TypeScript Definitions**: Complete `src/definitions.ts` with JSDoc, interfaces, and listener handles.
3. **Web Implementation**: Fully functional or stubbed `src/web.ts`.
4. **Native Sources**: iOS Swift files + `.podspec`, and Android Kotlin/Java files + `build.gradle`.
5. **Sample App**: Runnable consumer application demonstrating all endpoints.
6. **Verification Summary**: Output from docgen, build/verify commands, and publish dry-run.

## References

| File | Purpose |
| --- | --- |
| [`references/input-contract.md`](references/input-contract.md) | Structured YAML input schema |
| [`references/scaffolding.md`](references/scaffolding.md) | Non-interactive generator invocation & naming parity |
| [`references/api-design.md`](references/api-design.md) | TypeScript contract design, JSDoc, and return types |
| [`references/web-guide.md`](references/web-guide.md) | WebPlugin implementation, dynamic import, and fallbacks |
| [`references/architecture-patterns.md`](references/architecture-patterns.md) | Bridge and Facade architecture patterns |
| [`references/ios-implementation.md`](references/ios-implementation.md) | iOS bridge, Swift implementation, and Podspec setup |
| [`references/android-implementation.md`](references/android-implementation.md) | Android bridge, Kotlin implementation, and Gradle setup |
| [`references/permission-patterns.md`](references/permission-patterns.md) | Native permission flows and delegate callbacks |
| [`references/typescript-implementation.md`](references/typescript-implementation.md) | Advanced TypeScript patterns, handles, and Jest setup |
| [`references/configuration.md`](references/configuration.md) | Capacitor configuration keys under `plugins.<name>` |
| [`references/testing-strategies.md`](references/testing-strategies.md) | Verification commands and testing workflows |
| [`references/sample-app.md`](references/sample-app.md) | Minimum sample app validation requirements |
| [`references/publishing.md`](references/publishing.md) | Pre-publish checklist and dry-run commands |
