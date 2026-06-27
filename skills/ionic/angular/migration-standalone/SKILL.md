---
name: ionic-angular-migration-standalone
description: "USE ONLY when migrating Ionic Angular apps to Standalone: removing IonicModule, using provideIonicAngular, converting NgModule pages, or registering ionicons. IGNORE for greenfield apps already Standalone, general Angular patterns (use angular-core), or Capacitor plugin setup (use ionic-angular-capacitor)."
license: MIT
metadata:
  author: Lyon Incode
  version: "1.1"
---

## Activation Contract

Load this skill when:
- Migrating Ionic Angular app to Standalone architecture
- Removing `IonicModule` and using `provideIonicAngular`
- Converting NgModule-based pages to Standalone
- Updating imports from `@ionic/angular` to `@ionic/angular/standalone`
- Setting up ionicons registration in Standalone components

## Hard Rules

1. **All at once**: Migration to Ionic Standalone MUST be done in a single pass. Module-based and Standalone approaches use different build systems that cannot coexist.
2. **Automated tool first**: Try `npx @ionic/angular-standalone-codemods` before manual changes.
3. **Bootstrap switch**: Replace `importProvidersFrom(IonicModule.forRoot({}))` with `provideIonicAngular({ mode: 'ios', innerHTMLTemplatesEnabled: true, sanitizerEnabled: true })`.
4. **Import path**: Every Ionic import MUST come from `@ionic/angular/standalone`, never `@ionic/angular`.
5. **Icon registration**: Icons are NOT auto-loaded in Standalone. Call `addIcons({...})` per component (preferred) or globally in `AppComponent`.
6. **RouterLink**: Import BOTH `IonRouterLink` (Ionic) and `RouterLink` (Angular) when using `routerLink` on Ionic components.

## Decision Gates

| Situation | Action |
| --- | --- |
| App already uses Angular `standalone: true` | Follow Scenario 1 — update bootstrap + imports + icon registration. See [`references/migration-scenarios.md`](references/migration-scenarios.md) |
| App still uses `AppModule` (NgModule) | Follow Scenario 2 — keep NgModule, swap `IonicModule` for `provideIonicAngular`, import individual Ionic components per page. See [`references/migration-scenarios.md`](references/migration-scenarios.md) |
| User wants fastest path | Run `npx @ionic/angular-standalone-codemods` first; fall back to manual only if codemod fails |
| Icons render as empty squares | Register with `addIcons()` — see [`references/troubleshooting.md`](references/troubleshooting.md) Issue 1 |
| `routerLink` binding error | Import `IonRouterLink` + `RouterLink` — see [`references/troubleshooting.md`](references/troubleshooting.md) Issue 2 |
| Modal/Toast/Alert controllers fail | Import from `@ionic/angular/standalone` — see [`references/troubleshooting.md`](references/troubleshooting.md) Issue 3 |
| Build errors after migration | Clear `node_modules`, run `npx ionic build --clean`, verify all imports are from `/standalone` — see [`references/troubleshooting.md`](references/troubleshooting.md) Issue 4 |

## Execution Steps

1. Run `npx @ionic/angular-standalone-codemods` first. If it succeeds, skip to step 6.
2. Update dependencies:
   ```bash
   npm install @ionic/angular@latest
   npm install ionicons@latest
   ```
3. Update bootstrap (`main.ts` or `app.module.ts`) — replace `IonicModule` with `provideIonicAngular`. See [`references/migration-scenarios.md`](references/migration-scenarios.md).
4. Search-and-replace all `@ionic/angular` imports → `@ionic/angular/standalone`.
5. Import individual Ionic components per page/component (no more `IonicModule`).
6. Register icons with `addIcons({...})` — per component (preferred) or globally in `AppComponent`.
7. Import `IonRouterLink` + `RouterLink` wherever `routerLink` is used on Ionic components.
8. If using Jest, update `transformIgnorePatterns` — see [`references/migration-scenarios.md`](references/migration-scenarios.md) "Testing Configuration".
9. Run `npx cap sync`.
10. Test all pages, modals, toasts, alerts, routing.

## Migration Checklist

- [ ] Update `@ionic/angular` and `ionicons` to latest versions
- [ ] Update `main.ts` or `app.module.ts` (depending on scenario)
- [ ] Replace all `@ionic/angular` imports with `@ionic/angular/standalone`
- [ ] Import individual Ionic components in each page/component
- [ ] Register icons with `addIcons()` globally or per component
- [ ] Update `IonRouterLink` imports where needed
- [ ] Update Jest configuration if using tests
- [ ] Test all pages and components
- [ ] Verify modals, toasts, and alerts still work
- [ ] Check routing and navigation functionality

## Output Contract

After applying this skill, the agent MUST return:
- The scenario chosen (1: already Standalone, or 2: NgModule-based) and why.
- The exact files modified (`main.ts` / `app.module.ts`, page modules, components).
- The `npm install` commands executed.
- Confirmation that `npx cap sync` was run.
- Confirmation that all `@ionic/angular` imports were replaced with `@ionic/angular/standalone`.
- A list of any remaining manual steps (e.g., deleting old `.module.ts` files, registering additional icons).

## References

- [Migration scenarios (before/after code)](references/migration-scenarios.md)
- [Troubleshooting common issues](references/troubleshooting.md)
- [Ionic Standalone Migration Guide](https://ionicframework.com/docs/angular/standalone)
- [Angular Standalone Components](https://angular.dev/guide/components/importing)
- [Ionicons Documentation](https://ionic.io/ionicons)
