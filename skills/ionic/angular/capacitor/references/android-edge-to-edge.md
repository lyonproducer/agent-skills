# Android Edge-to-Edge Support

## When to Use

Use this helper to disable edge-to-edge mode on Android SDK 35+ where the system forces full-bleed layouts that can cause status bar and navigation bar overlays.

## Required Packages

```bash
npm install @capawesome/capacitor-android-edge-to-edge-support
npx cap sync
```

## `capacitor.config.ts` entry

```typescript
plugins: {
  EdgeToEdge: {
    backgroundColor: '#000000',
  },
}
```

## Usage in `app.component.ts`

```typescript
import { Capacitor } from '@capacitor/core';
import { EdgeToEdge } from '@capawesome/capacitor-android-edge-to-edge-support';

// Inside platform.ready():
if (Capacitor.getPlatform() === 'ios') {
  await EdgeToEdge.disable();
}
```

## Standalone Helper (optional)

```typescript
import { Capacitor } from '@capacitor/core';
import { EdgeToEdge } from '@capawesome/capacitor-android-edge-to-edge-support';

export async function disableAndroidEdgeToEdge(): Promise<void> {
  if (Capacitor.getPlatform() !== 'android') return;
  await EdgeToEdge.disable();
}
```

## Rules

- Verify behavior on Android SDK 36 and Capacitor 8/9 — this workaround may become unnecessary in future SDK versions.
- Only call `EdgeToEdge.disable()` on iOS in `app.component.ts` as part of the status bar configuration block (see `references/status-bar-ios.md`).
- NEVER call `EdgeToEdge.disable()` unconditionally — always guard with a platform check.
