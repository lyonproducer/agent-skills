---
name: ionic-angular-capacitor
description: "USE ONLY when configuring Capacitor platform detection (Capacitor.getPlatform()), iOS status bar, push notifications, Ionic Storage in main.ts, or first-party Capacitor wiring patterns. IGNORE for third-party plugin selection (use capacitor-plugins), Ionic routing/structure (use ionic-angular-architecture), or Standalone migration (use ionic-angular-migration-standalone)."
license: MIT
metadata:
  author: Lyon Incode
  version: "1.4"
---

## Activation Contract

Load this skill when:
- Configuring Capacitor plugins for iOS/Android
- Setting up platform-specific behavior
- Implementing push notifications
- Configuring mobile storage with Ionic Storage
- Setting up iOS status bar or safe areas

## Hard Rules

1. **Platform detection**: ALWAYS use `Capacitor.getPlatform()`, NEVER Ionic `Platform` service.
2. **iOS status bar**: ALWAYS configure in `app.component.ts` inside `platform.ready()`.
3. **Push notifications service**: MUST live in `src/app/core/device/push-notification.service.ts` and implement all 4 Capacitor listeners. Call `addListeners()` on every native app start; call `registerNotifications()` only after user opt-in — never on app start.
4. **Ionic Storage**: ALWAYS configure in `main.ts` and `await init()` before every call.
5. **Plugin services**: Place first-party Capacitor abstractions in `core/device/` or `features/<domain>/services/` (never in pages or `shared/`).
6. **Native calls**: ALWAYS guard with `Capacitor.getPlatform() !== 'web'` before calling native APIs.

## Decision Gates

| Situation | Action |
| --- | --- |
| Detecting iOS/Android/web | Use `Capacitor.getPlatform()` returning `'ios'`, `'android'`, `'web'`; use `Capacitor.isNativePlatform()` for iOS+Android |
| iOS status bar overlay | `StatusBar.setOverlaysWebView({ overlay: true })` + `StatusBar.setStyle({ style: Style.Dark })` + `EdgeToEdge.disable()` |
| Push notification registration | Only after explicit user opt-in; never on app start |
| Storage access | `await this.init()` before any `get`/`set` call |
| Calling native API | Guard with `if (Capacitor.getPlatform() !== 'web')` first |
| Choosing a third-party/community plugin | Delegate to the `capacitor-plugins` skill |

## Execution Steps

### 1. Platform Detection

```typescript
// ✅ CORRECT
import { Capacitor } from '@capacitor/core';

if (Capacitor.getPlatform() === 'ios') { }
if (Capacitor.getPlatform() === 'android') { }
if (Capacitor.getPlatform() === 'web') { }
if (Capacitor.isNativePlatform()) { } // iOS or Android (not web)
```

Supported values: `'ios'`, `'android'`, `'web'`.

### 2. iOS Status Bar

Full guide: [`references/status-bar-ios.md`](references/status-bar-ios.md)

```typescript
if (Capacitor.getPlatform() === 'ios') {
  await StatusBar.setOverlaysWebView({ overlay: true });
  await StatusBar.setStyle({ style: Style.Dark });
  await EdgeToEdge.disable();
}
```

```bash
npm install @capacitor/status-bar @capawesome/capacitor-android-edge-to-edge-support
```

Why:
- `setOverlaysWebView({ overlay: true })` — proper iOS safe area handling
- `setStyle({ style: Style.Dark })` — consistent dark status bar appearance
- `EdgeToEdge.disable()` — disables edge-to-edge mode that breaks iOS layout

### 3. Push Notifications Service

Service location: `src/app/core/device/push-notification.service.ts`.

Full guide + app.component setup + opt-in flow: [`references/push-notifications-angular.md`](references/push-notifications-angular.md).
Copyable service template: [`templates/push-notification.service.ts`](templates/push-notification.service.ts).

```bash
npm install @capacitor/push-notifications
```

### 4. Ionic Storage Configuration

ALWAYS configure in `main.ts`. Full guide + constants + `StorageService`: [`references/ionic-storage.md`](references/ionic-storage.md).

```bash
npm install @ionic/storage-angular
```

## Common First-Party Capacitor Plugins

| Plugin | Use Case | Installation |
|--------|----------|--------------|
| `@capacitor/camera` | Take photos, access gallery | `npm install @capacitor/camera` |
| `@capacitor/geolocation` | GPS location | `npm install @capacitor/geolocation` |
| `@capacitor/filesystem` | File operations | `npm install @capacitor/filesystem` |
| `@capacitor/network` | Network status | `npm install @capacitor/network` |
| `@capacitor/device` | Device info | `npm install @capacitor/device` |
| `@capacitor/splash-screen` | Splash screen control | `npm install @capacitor/splash-screen` |
| `@capacitor/keyboard` | Configure app keyboard behavior | `npm install @capacitor/keyboard` |
| `@capawesome/capacitor-android-edge-to-edge-support` | Fix Android SDK 35 status bar overlay | `npm install @capawesome/capacitor-android-edge-to-edge-support` |
| `@capgo/capacitor-social-login` | Social login (actively maintained) | `npm install @capgo/capacitor-social-login` |
| `@capacitor-firebase/crashlytics` | Crash analytics with Firebase | `npm install @capacitor-firebase/crashlytics` |
| `@capacitor-firebase/analytics` | App analytics with Firebase | `npm install @capacitor-firebase/analytics` |

For community and third-party plugins, see the [capacitor-plugins skill](../../../ionic/capacitor/capacitor-plugins/SKILL.md).

## Plugin Installation Workflow

1. `npm install @capacitor/<plugin-name>`
2. `npx cap sync`
3. Add platform permissions (iOS `Info.plist` / Android `AndroidManifest.xml`)
4. Create or update a service in `core/device/` or the relevant `features/<domain>/services/`

## Reference Services Index

| Topic | Reference |
|-------|-----------|
| Push notifications (Angular) | [`references/push-notifications-angular.md`](references/push-notifications-angular.md) |
| Push notification service template | [`templates/push-notification.service.ts`](templates/push-notification.service.ts) |
| iOS Status Bar | [`references/status-bar-ios.md`](references/status-bar-ios.md) |
| Ionic Storage | [`references/ionic-storage.md`](references/ionic-storage.md) |
| Capacitor Config | [`references/capacitor-config.md`](references/capacitor-config.md) |
| Camera (plugin workflow) | [`references/plugin-workflow-camera.md`](references/plugin-workflow-camera.md) |
| Network Service | [`references/network-service.md`](references/network-service.md) |
| Geolocation Service | [`references/geolocation-service.md`](references/geolocation-service.md) |
| Firebase Crashlytics | [`references/firebase-crashlytics-service.md`](references/firebase-crashlytics-service.md) |
| Firebase Analytics | [`references/firebase-analytics-service.md`](references/firebase-analytics-service.md) |
| Social Login (Capgo) | [`references/social-login-capgo.md`](references/social-login-capgo.md) |
| Keyboard Service | [`references/keyboard-service.md`](references/keyboard-service.md) |
| Android Edge-to-Edge | [`references/android-edge-to-edge.md`](references/android-edge-to-edge.md) |

## Anti-Patterns

### Don't: Use Ionic Platform Service for Detection

```typescript
// ❌ WRONG
import { Platform } from '@ionic/angular';
constructor(private platform: Platform) {
  if (this.platform.is('ios')) { } // inconsistent, avoid
}
```

### Don't: Forget Platform Check Before Native Calls

```typescript
// ❌ WRONG - Will throw on web
await StatusBar.setStyle({ style: Style.Dark });

// ✅ CORRECT
if (Capacitor.getPlatform() !== 'web') {
  await StatusBar.setStyle({ style: Style.Dark });
}
```

### Don't: Initialize Storage Synchronously

```typescript
// ❌ WRONG - Storage not ready
constructor(private storage: Storage) {
  this.storage.get('key');
}

// ✅ CORRECT - await init() before every call (see references/ionic-storage.md)
await this.init();
const value = await this.storage.get('key');
```

## Output Contract

After applying this skill, the agent MUST return:
- The exact file paths created or modified (e.g., `src/app/core/device/push-notification.service.ts`).
- The `npm install` commands executed.
- The platform-specific configuration applied (iOS `Info.plist` entries, Android `AndroidManifest.xml` entries).
- A confirmation that `npx cap sync` was run.
- Any pending manual steps the user must perform (e.g., Apple Push Notification Key upload).

## References

- [Capacitor Official Docs](https://capacitorjs.com/docs)
- [Capacitor Plugins](https://capacitorjs.com/docs/plugins)
- [Ionic Storage](https://github.com/ionic-team/ionic-storage)
- [Status Bar Plugin](https://capacitorjs.com/docs/apis/status-bar)
- [Push Notifications Plugin](https://capacitorjs.com/docs/apis/push-notifications)
- [capawesome-team capacitor-plugins skill](https://github.com/capawesome-team/skills/tree/main/skills/capacitor-plugins) — local copy at `skills/ionic/capacitor/capacitor-plugins/SKILL.md`
