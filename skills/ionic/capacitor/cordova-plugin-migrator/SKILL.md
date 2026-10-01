---
name: cordova-plugin-migrator
description: "USE ONLY when analyzing, assessing, or orchestrating the migration of an existing Cordova plugin to a modern Capacitor plugin, producing migration YAML and MIGRATION.md. IGNORE for generating new plugins from scratch (use capacitor-plugin-generator) or migrating full apps."
license: MIT
metadata:
  author: ionic
  source: https://github.com/ionic-team/capacitor-skills
  version: "1.0"
---

# Cordova Plugin Migrator

End-to-end orchestrator that analyzes a Cordova plugin source tree and produces a candidate Capacitor plugin plus a consolidated `MIGRATION.md`. It emits a structured YAML plan conforming to `capacitor-plugin-generator`'s input contract, validates blockers at a user checkpoint, and delegates scaffolding and native code generation to the generator.

## Activation Contract

**Load this skill when:**
- Migrating an existing Cordova plugin to Capacitor.
- Assessing migration complexity, effort, and blockers before committing.
- Producing structured handoff YAML for `capacitor-plugin-generator`.
- Comparing an official Cordova API to an existing or planned Capacitor equivalent.
- Auditing a Cordova plugin's hooks, native dependencies, or `<config-file>` directives.

**Do NOT load this skill for:**
- Generating a brand-new plugin from scratch without Cordova source → use `capacitor-plugin-generator`.
- Migrating an entire Cordova application (scope is strictly plugin-level).
- Debugging runtime issues in an already-migrated plugin.
- Direct code emission (native code generation is owned by `capacitor-plugin-generator`).

## Hard Rules

1. **Orchestrator Role**: Analyze the Cordova plugin, classify hooks, map APIs, and emit a YAML plan. Never emit native Capacitor code directly from this skill; delegate emission to `capacitor-plugin-generator`.
2. **Contract Authority**: Adhere strictly to the schema in [`../capacitor-plugin-generator/references/input-contract.md`](../capacitor-plugin-generator/references/input-contract.md). Do not invent custom fields.
3. **Strict Hook Classification**: Classify hooks into Tier 1 (Capacitor hooks), Tier 2 (npm scripts/manual steps), or Tier 3 (Blocker) per [`references/hooks-migration.md`](references/hooks-migration.md). A single Tier 3 hook blocks generator handoff.
4. **Halt on Blockers**: Never invoke the generator if `migration.blockers` or `migration.hooks.tier_3` is non-empty. Prompt the developer and halt.
5. **Wire-Format Parity**: When mirroring an existing official Capacitor equivalent, reuse its wire-format string names, enums, and event names verbatim from its source.
6. **Explicit Permission Methods**: If Cordova native code invokes runtime permissions (`requestPermissions`, `CLLocationManager`, etc.), always declare `checkPermissions()` and `requestPermissions()` in the contract, even if the Cordova JS surface omitted them.
7. **Strongly-Typed JSON Arguments**: If a Cordova JS method accepts stringified JSON parsed natively (`JSON.parse` or `JSONObject`), map it to a strongly-typed TypeScript interface, not a `string`.
8. **Quote YAML Syntax**: Always quote values in `migration.cordova_to_capacitor_map` and any string containing JavaScript punctuation (`(`, `)`, `{`, `}`, `:`, `[`, `]`) to prevent parser failure.
9. **Default to Mode B (Side-by-Side)**: Never mutate the Cordova repository in-place unless the developer explicitly requests Mode A and the git tree is clean.

## Decision Gates

| Situation | Condition / Signal | Action |
| --- | --- | --- |
| **New Plugin Request** | No Cordova source provided | Stop and redirect to `capacitor-plugin-generator` |
| **Output Directory** | User requests in-place migration (Mode A) | Verify clean git tree; scaffold in temp dir and archive Cordova source to `.cordova-archive/` |
| **Output Directory** | Default request (Mode B) | Scaffold Capacitor plugin in a sibling directory (`<plugin>-capacitor/`); preserve Cordova source untouched |
| **ODC Target** | App is targeting OutSystems Developer Cloud | Set `odc_target: true`; in Phase 11, invoke `build-actions-generator` (11a) then `capacitor-plugin-generator` (11b) |
| **Native Metadata** | Cordova native helpers extract EXIF/metadata | Include metadata fields in `api.types` interface even if undocumented in Cordova JS |
| **Tier 3 Hook Found** | Hook modifies compiler flags or complex native AST | Flag as blocker in `migration.blockers`; require developer manual resolution before handoff |
| **Platform Asymmetry** | Method implemented on iOS but not Android | Surface in `migration.warnings` and declare strategy (conditional, stub, or drop) |

## Execution Steps

### 1. Determine Task and Output Mode
- Confirm Cordova source exists. If not, redirect to `capacitor-plugin-generator`.
- Select **Mode B** (side-by-side, default) or **Mode A** (in-place with `.cordova-archive/`, opt-in).
- Determine whether ODC (OutSystems Developer Cloud) build actions are required (`odc_target: true/false`).

### 2. Parse `plugin.xml`
- Read plugin identifier, version, JS modules, clobbers, platforms, source files, framework dependencies, and `<config-file>` targets per [`references/api-mappings.md`](references/api-mappings.md).

### 3. Analyze JavaScript Interface and Native Sources
- Map `exec()` calls to methods. Convert positional parameters to named properties.
- Inspect native iOS (`.m`/`.swift`) and Android (`.java`/`.kt`) handlers for actual payload types.
- Check runtime permission requests and extract custom helper payloads into TypeScript interfaces.

### 4. Classify Hooks and Dependencies
- Classify `<hook>` tags per [`references/hooks-migration.md`](references/hooks-migration.md) into Tier 1, Tier 2, or Tier 3.
- Classify dependencies per [`references/dependency-migration.md`](references/dependency-migration.md):
  - Plugin packaging (CocoaPods/Gradle dependencies).
  - Host app configuration (Info.plist privacy strings, entitlements).
  - Consumer runtime configuration (API keys, merchant IDs).

### 5. Assess Complexity and Generate YAML Contract
- Calculate complexity score (Simple, Moderate, Complex) per [`references/complexity-assessment.md`](references/complexity-assessment.md).
- Emit migration plan YAML conforming to [`../capacitor-plugin-generator/references/input-contract.md`](../capacitor-plugin-generator/references/input-contract.md).
- Populate `migration.cordova_to_capacitor_map` with quoted 1:1 call-site mappings.

### 6. User Checkpoint (Phase 10)
- Present migration summary: complexity rating, mapped methods, Tier 1/2 hooks, and any warnings.
- If `migration.blockers` is non-empty, halt and require resolution.
- Request user confirmation before launching generator.

### 7. Invoke Generator and Consolidate
- Hand off YAML plan to `capacitor-plugin-generator`.
- If `odc_target: true`, first run `build-actions-generator` then `capacitor-plugin-generator` per [`references/using-plugin-generator.md`](references/using-plugin-generator.md).
- Generate consolidated `MIGRATION.md` detailing breaking changes, host-app requirements, and call-site migrations per [`references/output-modes.md`](references/output-modes.md).

## Output Contract

Every migration audit and run produces:
1. **Migration Plan YAML**: Valid structured input contract for the generator with complete method, platform, and dependency mappings.
2. **Complexity Assessment**: Simple / Moderate / Complex rating with time estimate and rationale.
3. **Blockers & Warnings**: Explicit list of unsupported patterns or manual intervention steps.
4. **Consolidated `MIGRATION.md`**: Guide for application developers moving from the Cordova plugin to the Capacitor plugin.

## References

| File | Purpose |
| --- | --- |
| [`references/api-mappings.md`](references/api-mappings.md) | Mapping Cordova exec() and signatures to Capacitor Promise/listener models |
| [`references/complexity-assessment.md`](references/complexity-assessment.md) | Scoring matrix for plugin migration effort and feasibility |
| [`references/dependency-migration.md`](references/dependency-migration.md) | Native dependency ownership model (CocoaPods, SPM, Gradle) |
| [`references/hooks-migration.md`](references/hooks-migration.md) | 3-tier classification taxonomy for Cordova hooks |
| [`references/migration-patterns.md`](references/migration-patterns.md) | Architectural migration recipes (camera, storage, file paths) |
| [`references/output-modes.md`](references/output-modes.md) | Layouts and relocation procedures for Mode A vs Mode B |
| [`references/unsupported-patterns.md`](references/unsupported-patterns.md) | Cordova patterns without direct Capacitor equivalents |
| [`references/using-plugin-generator.md`](references/using-plugin-generator.md) | Execution protocol for generator invocation and ODC path |
| [`references/post-migration-cleanup.md`](references/post-migration-cleanup.md) | Post-migration verification and archive guidelines |
| [`references/example-analysis.md`](references/example-analysis.md) | Reference Cordova-to-Capacitor migration walkthrough |
