# Capacitor Platform Detection Guide

## Why Use Capacitor for Platform Detection?

Capacitor provides a **unified and reliable** way to detect the current platform your app is running on. Unlike Ionic's `Platform.is()` which can be inconsistent, Capacitor's platform detection is:

- ✅ **Consistent** across all environments
- ✅ **Type-safe** with TypeScript
- ✅ **Native-focused** - tells you exactly where the code is running
- ✅ **Simple** - single method, clear return values

## The Rule

**🚨 ALWAYS use `Capacitor.getPlatform()` - NEVER use `Platform.is()`**

## Correct Implementation

```typescript
import { Capacitor } from '@capacitor/core';

// ✅ CORRECT: Check for iOS
if (Capacitor.getPlatform() === 'ios') {
  // iOS-specific code
}

// ✅ CORRECT: Check for Android
if (Capacitor.getPlatform() === 'android') {
  // Android-specific code
}

// ✅ CORRECT: Check for web
if (Capacitor.getPlatform() === 'web') {
  // Web-specific code
}

// ✅ CORRECT: Check if running natively
if (Capacitor.isNativePlatform()) {
  // Code for iOS or Android (not web)
}
```

## Incorrect Implementation (Don't Do This!)

```typescript
import { Platform } from '@ionic/angular';

export class MyComponent {
  constructor(private platform: Platform) {}

  // ❌ WRONG: Don't use Ionic's Platform.is()
  doSomething() {
    if (this.platform.is('ios')) {
      // This is inconsistent and deprecated
    }
  }
}
```

## Return Values

`Capacitor.getPlatform()` returns one of three strings:

- `'ios'` - Running on iOS device or simulator
- `'android'` - Running on Android device or emulator  
- `'web'` - Running in web browser

## Common Use Cases

### 1. Status Bar Configuration (iOS-specific)

```typescript
import { Capacitor } from '@capacitor/core';
import { StatusBar, Style } from '@capacitor/status-bar';

if (Capacitor.getPlatform() === 'ios') {
  await StatusBar.setOverlaysWebView({ overlay: true });
  await StatusBar.setStyle({ style: Style.Dark });
}
```

### 2. Different Behavior per Platform

```typescript
import { Capacitor } from '@capacitor/core';

async loadData() {
  const platform = Capacitor.getPlatform();
  
  switch (platform) {
    case 'ios':
      // iOS-specific loading
      break;
    case 'android':
      // Android-specific loading
      break;
    case 'web':
      // Web-specific loading
      break;
  }
}
```

### 3. Check if Running Native

```typescript
import { Capacitor } from '@capacitor/core';

if (Capacitor.isNativePlatform()) {
  // This code runs on iOS or Android (not web)
  await this.pushNotificationService.register();
} else {
  console.log('Push notifications not available on web');
}
```

### 4. Conditional Plugin Usage

```typescript
import { Capacitor } from '@capacitor/core';
import { Camera } from '@capacitor/camera';

async takePhoto() {
  if (Capacitor.isNativePlatform()) {
    // Use native camera on mobile
    const photo = await Camera.getPhoto({
      resultType: CameraResultType.Uri,
      source: CameraSource.Camera,
    });
    return photo;
  } else {
    // Fallback for web
    return this.useWebCamera();
  }
}
```

## Additional Capacitor Methods

```typescript
// Check if plugin is available
if (Capacitor.isPluginAvailable('Camera')) {
  // Camera plugin is available
}

// Convert file URI (useful for file handling)
const path = Capacitor.convertFileSrc(uri);
```

## Why Not Platform.is()?

Ionic's `Platform.is()` was designed for Ionic Framework internal use and has several issues:

1. **Inconsistent Results**: Can return different values in different contexts
2. **Multiple Truthy Values**: `platform.is('mobile')` and `platform.is('ios')` can both be true
3. **Web vs Native Confusion**: Doesn't clearly distinguish between web and native
4. **Deprecated Pattern**: Not recommended for modern Capacitor apps

## Best Practices

1. ✅ Always import from `@capacitor/core`
2. ✅ Use strict equality checks (`===`)
3. ✅ Store platform in a variable if checking multiple times
4. ✅ Use `Capacitor.isNativePlatform()` for simple native/web checks
5. ✅ Handle all three platforms (ios, android, web) explicitly

```typescript
// ✅ GOOD: Store and reuse
const platform = Capacitor.getPlatform();

if (platform === 'ios') {
  // iOS code
}

if (platform === 'android') {
  // Android code
}

// ✅ GOOD: Use helper method
if (Capacitor.isNativePlatform()) {
  // Native code
}
```

## Testing Across Platforms

```typescript
// Development tip: Log platform on startup
console.log('Running on platform:', Capacitor.getPlatform());
console.log('Is native?', Capacitor.isNativePlatform());
```

## Summary

- **DO**: Use `Capacitor.getPlatform() === 'ios'`
- **DO**: Use `Capacitor.isNativePlatform()`
- **DON'T**: Use `Platform.is('ios')` from Ionic
- **ALWAYS**: Import from `@capacitor/core`

This ensures your code is consistent, reliable, and follows modern Capacitor best practices.
