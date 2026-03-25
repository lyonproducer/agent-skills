# Plugin Installation Workflow + Camera Example

## General Plugin Workflow

1. Install the npm package: `npm install @capacitor/<plugin-name>`
2. Sync native projects: `npx cap sync`
3. Add platform-specific permissions in native projects (iOS `Info.plist`, Android `AndroidManifest.xml`)
4. Import and use inside an Angular service placed in `core/device/` or the relevant feature

## Required Packages (Camera)

```bash
npm install @capacitor/camera
npx cap sync
```

**iOS** — add to `Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to take photos.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access.</string>
```

**Android** — handled automatically by the plugin manifest.

## Camera Service Example

Place at `src/app/core/device/camera.service.ts` or `src/app/features/<feature>/data/camera.service.ts` depending on scope:

```typescript
import { Injectable } from '@angular/core';
import { Camera, CameraResultType, CameraSource } from '@capacitor/camera';
import { Capacitor } from '@capacitor/core';

@Injectable({
  providedIn: 'root',
})
export class CameraService {
  async takePhoto(): Promise<string | null> {
    if (!Capacitor.isNativePlatform()) {
      console.warn('Camera not available on web');
      return null;
    }

    const image = await Camera.getPhoto({
      quality: 90,
      allowEditing: false,
      resultType: CameraResultType.DataUrl,
      source: CameraSource.Camera,
    });

    return image.dataUrl ?? null;
  }

  async pickFromGallery(): Promise<string | null> {
    if (!Capacitor.isNativePlatform()) {
      return null;
    }

    const image = await Camera.getPhoto({
      quality: 90,
      allowEditing: true,
      resultType: CameraResultType.Uri,
      source: CameraSource.Photos,
    });

    return image.webPath ?? null;
  }
}
```

## Rules

- ALWAYS check `Capacitor.isNativePlatform()` before calling Camera — it is not available on web.
- Use `CameraResultType.DataUrl` for immediate display; use `CameraResultType.Uri` for file handling.
- Place camera logic in a service, never call `Camera.getPhoto()` directly from a component.
