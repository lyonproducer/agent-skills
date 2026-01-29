---
name: ionic-angular-capacitor-plugins
description: >
  Capacitor mobile plugins configuration: platform detection, status bar, push notifications, storage.
  Trigger: When configuring Capacitor plugins, iOS/Android platform detection, push notifications, or mobile-specific features.
metadata:
  author: 789.mx
  version: "1.0"
---

## When to Use

Load this skill when:
- Configuring Capacitor plugins for iOS/Android
- Setting up platform-specific behavior
- Implementing push notifications
- Configuring mobile storage with Ionic Storage
- Setting up iOS status bar or safe areas

---

## Critical Rule 1: Platform Detection

**ALWAYS use Capacitor for platform detection, NEVER Ionic Platform:**

```typescript
// ✅ CORRECT
import { Capacitor } from '@capacitor/core';

if (Capacitor.getPlatform() === 'ios') {
  // iOS-specific code
}

if (Capacitor.getPlatform() === 'android') {
  // Android-specific code
}

if (Capacitor.getPlatform() === 'web') {
  // Web-specific code
}

// ❌ WRONG - Never use Ionic's platform.is()
import { Platform } from '@ionic/angular';
if (this.platform.is('ios')) { } // DON'T DO THIS
```

**Supported platform values:**
- `'ios'` - iOS devices
- `'android'` - Android devices
- `'web'` - Web browsers

**Why:** Capacitor.getPlatform() is the official, reliable way to detect platforms. Ionic's Platform service is deprecated for this use case and can return incorrect results.

---

## Critical Rule 2: iOS Status Bar Configuration

**ALWAYS include this iOS configuration in `app.component.ts`:**

```typescript
import { Capacitor } from '@capacitor/core';
import { StatusBar, Style } from '@capacitor/status-bar';
import { EdgeToEdge } from '@capawesome/capacitor-android-edge-to-edge-support';

export class AppComponent {
  private readonly platform = inject(Platform);

  constructor() {
    this.platform.ready().then(async () => {
      // iOS Status Bar Configuration
      if (Capacitor.getPlatform() === 'ios') {
        await StatusBar.setOverlaysWebView({ overlay: true });
        await StatusBar.setStyle({ style: Style.Dark });
        await EdgeToEdge.disable();
      }
    });
  }
}
```

**Required packages:**
```bash
npm install @capacitor/status-bar @capawesome/capacitor-android-edge-to-edge-support
```

**Why this configuration:**
- `setOverlaysWebView({ overlay: true })` - Enables proper iOS safe area handling
- `setStyle({ style: Style.Dark })` - Provides consistent dark status bar appearance
- `EdgeToEdge.disable()` - Disables edge-to-edge mode that can cause layout issues on iOS

---

## Critical Rule 3: Push Notifications Service

**ALWAYS create push notifications service at:**

`src/app/core/services/push-notification.service.ts`

```typescript
import { Injectable, inject } from '@angular/core';
import { Capacitor } from '@capacitor/core';
import {
  PushNotifications,
  Token,
  PushNotificationSchema,
  ActionPerformed,
} from '@capacitor/push-notifications';

@Injectable({
  providedIn: 'root',
})
export class PushNotificationService {
  private readonly platform = inject(Platform);

  async initialize(): Promise<void> {
    if (Capacitor.getPlatform() === 'web') {
      console.log('Push notifications not available on web');
      return;
    }

    // Request permission
    const permission = await PushNotifications.requestPermissions();
    
    if (permission.receive === 'granted') {
      await PushNotifications.register();
    }

    // Setup listeners
    this.setupListeners();
  }

  private setupListeners(): void {
    // 1. Registration success
    PushNotifications.addListener('registration', (token: Token) => {
      console.log('Push registration success:', token.value);
      // Send token to your backend
    });

    // 2. Registration error
    PushNotifications.addListener('registrationError', (error: any) => {
      console.error('Push registration error:', error);
    });

    // 3. Notification received (app in foreground)
    PushNotifications.addListener(
      'pushNotificationReceived',
      (notification: PushNotificationSchema) => {
        console.log('Push received:', notification);
        // Handle notification in foreground
      }
    );

    // 4. Notification action performed (user tapped)
    PushNotifications.addListener(
      'pushNotificationActionPerformed',
      (notification: ActionPerformed) => {
        console.log('Push action performed:', notification);
        // Handle user interaction
      }
    );
  }
}
```

**Initialize in app.component.ts:**

```typescript
export class AppComponent {
  private readonly pushService = inject(PushNotificationService);

  constructor() {
    this.platform.ready().then(async () => {
      await this.pushService.initialize();
    });
  }
}
```

**Required packages:**
```bash
npm install @capacitor/push-notifications
```

**Key requirements:**
- Must be in `core/services/` (singleton service)
- Must implement all 4 Capacitor push notification listeners
- Must handle permissions properly
- Must use modern async/await patterns

---

## Critical Rule 4: Ionic Storage Configuration

**ALWAYS configure Ionic Storage in `main.ts`:**

```typescript
import { provideIonicAngular } from '@ionic/angular/standalone';
import { IonicStorageModule } from '@ionic/storage-angular';
import { importProvidersFrom } from '@angular/core';

bootstrapApplication(AppComponent, {
  providers: [
    provideIonicAngular({
      innerHTMLTemplatesEnabled: true,
      sanitizerEnabled: true,
    }),
    importProvidersFrom(
      IonicStorageModule.forRoot({
        name: DB_INDEX_NAME,
        storeName: DB_INDEX_NAME,
      })
    ),
  ],
});
```

**Create database constants in `src/app/shared/constants/database.constants.ts`:**

```typescript
export const DB_INDEX_NAME = '__myapp_db';
export const DB_STORE_NAME = '__myapp_store';
```

**Usage in services:**

```typescript
import { Storage } from '@ionic/storage-angular';
import { inject, Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root',
})
export class StorageService {
  private readonly storage = inject(Storage);
  private initialized = false;

  async init(): Promise<void> {
    if (!this.initialized) {
      await this.storage.create();
      this.initialized = true;
    }
  }

  async set(key: string, value: any): Promise<void> {
    await this.init();
    await this.storage.set(key, value);
  }

  async get<T>(key: string): Promise<T | null> {
    await this.init();
    return await this.storage.get(key);
  }

  async remove(key: string): Promise<void> {
    await this.init();
    await this.storage.remove(key);
  }

  async clear(): Promise<void> {
    await this.init();
    await this.storage.clear();
  }
}
```

**Required packages:**
```bash
npm install @ionic/storage-angular
```

**Why these settings:**
- `innerHTMLTemplatesEnabled: true` - Allows modifying innerHTML CSS
- `sanitizerEnabled: true` - Keeps security enabled while allowing CSS modifications
- These settings enable better control over Ionic component styling

---

## Capacitor Configuration File

**`capacitor.config.ts` example:**

```typescript
import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.example.app',
  appName: 'MyApp',
  webDir: 'www',
  server: {
    androidScheme: 'https'
  },
  plugins: {
    PushNotifications: {
      presentationOptions: ['badge', 'sound', 'alert']
    },
    StatusBar: {
      style: 'dark',
      backgroundColor: '#000000'
    }
  }
};

export default config;
```

---

## Common Capacitor Plugins

| Plugin | Use Case | Installation |
|--------|----------|--------------|
| `@capacitor/camera` | Take photos, access gallery | `npm install @capacitor/camera` |
| `@capacitor/geolocation` | GPS location | `npm install @capacitor/geolocation` |
| `@capacitor/filesystem` | File operations | `npm install @capacitor/filesystem` |
| `@capacitor/network` | Network status | `npm install @capacitor/network` |
| `@capacitor/device` | Device info | `npm install @capacitor/device` |
| `@capacitor/splash-screen` | Splash screen control | `npm install @capacitor/splash-screen` |

---

## Plugin Installation Workflow

1. Install npm package: `npm install @capacitor/[plugin-name]`
2. Sync native projects: `npx cap sync`
3. Add platform-specific permissions in native projects
4. Import and use in Angular services

**Example with Camera:**

```typescript
import { Camera, CameraResultType } from '@capacitor/camera';

export class PhotoService {
  async takePhoto(): Promise<string> {
    const image = await Camera.getPhoto({
      quality: 90,
      allowEditing: false,
      resultType: CameraResultType.DataUrl
    });
    
    return image.dataUrl!;
  }
}
```

---

## Anti-Patterns

### Don't: Use Ionic Platform Service for Detection

```typescript
// ❌ WRONG
import { Platform } from '@ionic/angular';

constructor(private platform: Platform) {
  if (this.platform.is('ios')) {
    // Don't do this
  }
}
```

### Don't: Forget Platform Check

```typescript
// ❌ WRONG - Will fail on web
await StatusBar.setStyle({ style: Style.Dark });

// ✅ CORRECT
if (Capacitor.getPlatform() !== 'web') {
  await StatusBar.setStyle({ style: Style.Dark });
}
```

### Don't: Initialize Storage Synchronously

```typescript
// ❌ WRONG
constructor(private storage: Storage) {
  this.storage.get('key'); // Storage not initialized!
}

// ✅ CORRECT
async ngOnInit() {
  await this.storage.create();
  const value = await this.storage.get('key');
}
```

---

## Resources

- [Capacitor Official Docs](https://capacitorjs.com/docs)
- [Capacitor Plugins](https://capacitorjs.com/docs/plugins)
- [Ionic Storage](https://github.com/ionic-team/ionic-storage)
- [Status Bar Plugin](https://capacitorjs.com/docs/apis/status-bar)
- [Push Notifications Plugin](https://capacitorjs.com/docs/apis/push-notifications)
