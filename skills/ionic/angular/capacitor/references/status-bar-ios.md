# iOS Status Bar Configuration

## When to Use

Apply this configuration in every Ionic + Angular app that targets iOS to handle safe areas correctly and ensure a consistent status bar appearance.

## Required Packages

```bash
npm install @capacitor/status-bar @capawesome/capacitor-android-edge-to-edge-support
```

## Implementation

Place this block inside `app.component.ts` inside `platform.ready()`:

```typescript
import { Capacitor } from '@capacitor/core';
import { StatusBar, Style } from '@capacitor/status-bar';
import { EdgeToEdge } from '@capawesome/capacitor-android-edge-to-edge-support';

// Inside platform.ready() callback:
if (Capacitor.getPlatform() === 'ios') {
  await StatusBar.setOverlaysWebView({ overlay: true });
  await StatusBar.setStyle({ style: Style.Dark });
  await EdgeToEdge.disable();
}

if (Capacitor.getPlatform() === 'android') {
  await StatusBar.setStyle({ style: Style.Dark });
}
```

## Why Each Setting

- `setOverlaysWebView({ overlay: true })` — enables proper iOS safe area handling so content doesn't clip under the status bar.
- `setStyle({ style: Style.Dark })` — consistent dark status bar appearance across both platforms.
- `EdgeToEdge.disable()` — disables edge-to-edge mode that causes layout issues on iOS with the `@capawesome/capacitor-android-edge-to-edge-support` plugin.

## `capacitor.config.ts` entry

```typescript
plugins: {
  StatusBar: {
    style: 'dark',
    backgroundColor: '#000000'
  },
  EdgeToEdge: {
    backgroundColor: '#000000',
  },
}
```

## Rules

- ALWAYS wrap in `Capacitor.getPlatform() === 'ios'` — never call `StatusBar` unconditionally on web.
- NEVER use `Platform.is('ios')` from `@ionic/angular` — use `Capacitor.getPlatform()` only.
