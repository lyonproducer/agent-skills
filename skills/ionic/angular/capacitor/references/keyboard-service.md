# Keyboard Service

## When to Use

Use this service to control keyboard resize behavior and programmatically hide the keyboard on iOS and Android.

## Required Packages

```bash
npm install @capacitor/keyboard
npx cap sync
```

## `capacitor.config.ts` entry

```typescript
plugins: {
  Keyboard: {
    resizeOnFullScreen: false
  },
}
```

## Location

`src/app/core/device/keyboard.service.ts`

## Implementation

```typescript
import { Injectable } from '@angular/core';
import { Keyboard, KeyboardResize } from '@capacitor/keyboard';
import { Capacitor } from '@capacitor/core';

@Injectable({
  providedIn: 'root',
})
export class KeyboardService {
  async setResizeMode(mode: KeyboardResize = KeyboardResize.Body) {
    if (Capacitor.getPlatform() === 'web') return;
    await Keyboard.setResizeMode({ mode });
  }

  async hide(): Promise<void> {
    if (Capacitor.getPlatform() === 'web') return;
    await Keyboard.hide();
  }
}
```

## Rules

- Place in `core/device/` — it is a Capacitor plugin abstraction singleton.
- ALWAYS guard with `Capacitor.getPlatform() === 'web'` — the keyboard plugin does not run in the browser.
- Call `hide()` when programmatically submitting forms to dismiss the keyboard before navigation.
