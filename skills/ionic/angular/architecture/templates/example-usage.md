# Example Usage of Angular Ionic Architect Skill

This document provides real-world examples of how to use the Angular Ionic Architect skill.

## Example 1: Starting a New Project

### User Request
> "I need to create a new food delivery app with user authentication, restaurant browsing, cart management, and order tracking."

### Skill Response

Based on your requirements, here's the recommended Angular 20 + Ionic 8 architecture:

```
src/app/
├── pages/
│   ├── start-app/                    # Authentication flow
│   │   ├── login/
│   │   ├── register/
│   │   └── verify-phone/
│   │
│   ├── tabs/                         # Main app tabs
│   │   ├── browse/                   # Restaurant browsing
│   │   │   ├── browse.ts
│   │   │   └── components/
│   │   │       ├── restaurant-card.ts
│   │   │       └── category-filter.ts
│   │   ├── cart/                     # Shopping cart
│   │   ├── orders/                   # Order history & tracking
│   │   └── profile/
│   │
│   └── out-app/
│       ├── restaurant-details/       # Individual restaurant page
│       └── order-tracking/           # Live order tracking
│
├── shared/
│   └── components/
│       ├── headers/                  # Used by multiple pages
│       │   ├── header-back.ts
│       │   └── header-main.ts
│       └── modals/
│           └── add-to-cart-modal.ts
│
└── core/
    └── services/
        ├── auth.service.ts
        ├── restaurant.service.ts
        ├── order.service.ts
        ├── cart.service.ts           # Global cart state
        └── push-notification.service.ts  # 🚨 Required for order updates
```

**Don't forget the iOS configuration in app.component.ts!**

---

## Example 2: Deciding Component Placement

### User Request
> "I have a 'FavoriteButton' component. It's used in the restaurant list, restaurant details page, and saved restaurants page. Where should I put it?"

### Skill Analysis

**Usage Count**: 3 pages = 2+ features

**Decision**: This component is used by **multiple features** (browse, details, favorites), so according to the Scope Rule, it MUST go in **shared/components**.

```typescript
// ✅ CORRECT: src/app/shared/components/favorite-button.ts
import { Component, ChangeDetectionStrategy, inject, input, output } from '@angular/core';
import { IonicModule } from '@ionic/angular';

@Component({
  selector: 'app-favorite-button',
  imports: [IonicModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <ion-button 
      fill="clear" 
      (click)="toggle.emit(!isFavorite())">
      <ion-icon 
        [name]="isFavorite() ? 'heart' : 'heart-outline'" 
        [color]="isFavorite() ? 'danger' : 'medium'">
      </ion-icon>
    </ion-button>
  `
})
export class FavoriteButtonComponent {
  readonly isFavorite = input<boolean>(false);
  readonly toggle = output<boolean>();
}
```

**Why shared?** Because it's reused across 3 different pages (browse, details, favorites).

---

## Example 3: Implementing Platform-Specific Features

### User Request
> "I need to show a different camera UI for iOS vs Android in my profile photo upload feature."

### Skill Response

Use **Capacitor.getPlatform()** for platform detection:

```typescript
// src/app/pages/in-app/tabs/profile/components/photo-upload.ts
import { Component, inject, signal } from '@angular/core';
import { Capacitor } from '@capacitor/core';
import { Camera, CameraResultType, CameraSource } from '@capacitor/camera';
import { IonicModule } from '@ionic/angular';

@Component({
  selector: 'app-photo-upload',
  imports: [IonicModule],
  template: `
    <ion-button (click)="takePicture()">
      <ion-icon name="camera"></ion-icon>
      {{ buttonText() }}
    </ion-button>
  `
})
export class PhotoUploadComponent {
  private readonly photo = signal<string | null>(null);
  
  readonly buttonText = signal('Take Photo');

  async takePicture() {
    const platform = Capacitor.getPlatform();
    
    // ✅ CORRECT: Using Capacitor for platform detection
    if (platform === 'ios') {
      // iOS-specific camera configuration
      await this.takePhotoIOS();
    } else if (platform === 'android') {
      // Android-specific camera configuration
      await this.takePhotoAndroid();
    } else {
      // Web fallback
      await this.takePhotoWeb();
    }
  }

  private async takePhotoIOS() {
    const image = await Camera.getPhoto({
      quality: 90,
      allowEditing: true,  // iOS has better editing UI
      resultType: CameraResultType.Uri,
      source: CameraSource.Camera,
      presentationStyle: 'popover' // iOS-specific
    });
    this.photo.set(image.webPath ?? null);
  }

  private async takePhotoAndroid() {
    const image = await Camera.getPhoto({
      quality: 90,
      allowEditing: false, // Use custom editing on Android
      resultType: CameraResultType.Uri,
      source: CameraSource.Camera
    });
    this.photo.set(image.webPath ?? null);
  }

  private async takePhotoWeb() {
    // Web implementation
    console.log('Camera not available on web');
  }
}
```

**Key Points:**
- ✅ Uses `Capacitor.getPlatform()` not `Platform.is()`
- ✅ Handles all three platforms (ios, android, web)
- ✅ Platform-specific configuration where needed
- ✅ Modern signal-based state management

---

## Example 4: Converting Legacy Code to Modern Pattern

### User Request
> "Convert this component to use Angular 20 patterns"

### Legacy Code (Before)

```typescript
import { Component, Input, Output, EventEmitter, OnInit } from '@angular/core';
import { ApiService } from '../services/api.service';

@Component({
  selector: 'app-product-list',
  templateUrl: './product-list.component.html'
})
export class ProductListComponent implements OnInit {
  @Input() category: string;
  @Output() productSelected = new EventEmitter<Product>();
  
  products: Product[] = [];
  loading = false;

  constructor(private apiService: ApiService) {}

  ngOnInit() {
    this.loadProducts();
  }

  loadProducts() {
    this.loading = true;
    this.apiService.getProducts(this.category).subscribe({
      next: (data) => {
        this.products = data;
        this.loading = false;
      }
    });
  }
}
```

### Modern Code (After)

```typescript
import { 
  Component, 
  ChangeDetectionStrategy, 
  inject, 
  input, 
  output, 
  signal, 
  effect 
} from '@angular/core';
import { IonicModule } from '@ionic/angular';
import { ApiService } from '@core/services/api.service';

@Component({
  selector: 'app-product-list',
  imports: [IonicModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    @if (loading()) {
      <ion-spinner></ion-spinner>
    } @else {
      @for (product of products(); track product.id) {
        <ion-card (click)="productSelected.emit(product)">
          <ion-card-header>
            <ion-card-title>{{ product.name }}</ion-card-title>
          </ion-card-header>
        </ion-card>
      }
    }
  `
})
export class ProductListComponent {
  // ✅ Use input() instead of @Input()
  readonly category = input.required<string>();
  
  // ✅ Use output() instead of @Output()
  readonly productSelected = output<Product>();
  
  // ✅ Use inject() instead of constructor
  private readonly apiService = inject(ApiService);
  
  // ✅ Use signals for state
  readonly products = signal<Product[]>([]);
  readonly loading = signal(false);
  
  // ✅ Use effect() instead of ngOnInit
  constructor() {
    effect(() => {
      const cat = this.category();
      if (cat) {
        this.loadProducts(cat);
      }
    });
  }
  
  private async loadProducts(category: string) {
    this.loading.set(true);
    try {
      const data = await this.apiService.getProducts(category);
      this.products.set(data);
    } finally {
      this.loading.set(false);
    }
  }
}
```

**Changes Made:**
1. ✅ Removed NgModule (standalone component)
2. ✅ `@Input()` → `input.required<string>()`
3. ✅ `@Output()` → `output<Product>()`
4. ✅ Constructor DI → `inject()`
5. ✅ Properties → `signal()`
6. ✅ `ngOnInit()` → `effect()`
7. ✅ Added `ChangeDetectionStrategy.OnPush`
8. ✅ Observable → async/await
9. ✅ Inline template for better readability
10. ✅ Modern control flow (`@if`, `@for`)

---

## Example 5: Setting Up Push Notifications

### User Request
> "How do I set up push notifications for order updates in my food delivery app?"

### Skill Response

**Step 1**: Create the push notification service

```bash
# Location: src/app/core/services/push-notification.service.ts
```

Use the template from `templates/push-notification.service.ts` (complete implementation included).

**Step 2**: Initialize in app.component.ts

```typescript
import { Component, inject } from '@angular/core';
import { Capacitor } from '@capacitor/core';
import { StatusBar, Style } from '@capacitor/status-bar';
import { Platform, IonicModule } from '@ionic/angular';
import { EdgeToEdge } from '@capawesome/capacitor-android-edge-to-edge-support';
import { PushNotificationService } from '@core/services/push-notification.service';

@Component({
  selector: 'app-root',
  imports: [IonicModule],
  templateUrl: 'app.component.html'
})
export class AppComponent {
  private readonly platform = inject(Platform);
  private readonly pushService = inject(PushNotificationService);

  constructor() {
    this.platform.ready().then(async () => {
      // 🚨 REQUIRED: iOS configuration
      if (Capacitor.getPlatform() === 'ios') {
        await StatusBar.setOverlaysWebView({ overlay: true });
        await StatusBar.setStyle({ style: Style.Dark });
        await EdgeToEdge.disable();
      }

      // Only register push notifications on native platforms
      if (Capacitor.isNativePlatform()) {
        await this.pushService.addListeners();
        
        // Request permission after user logs in
        // await this.pushService.registerNotifications();
      }
    });
  }
}
```

**Step 3**: Request permissions after user authentication

```typescript
// In your auth service or login component
async onLoginSuccess() {
  if (Capacitor.isNativePlatform()) {
    try {
      await this.pushService.registerNotifications();
      console.log('Push notifications enabled');
    } catch (error) {
      console.log('User declined push notifications');
    }
  }
}
```

---

## Example 6: Migrating from platform.is() to Capacitor

### User Request
> "My app uses platform.is() everywhere. How do I migrate to Capacitor?"

### Before (Using Ionic Platform)

```typescript
import { Platform } from '@ionic/angular';

export class MyComponent {
  constructor(private platform: Platform) {
    if (this.platform.is('ios')) {
      // iOS code
    }
    
    if (this.platform.is('android')) {
      // Android code
    }
  }
}
```

### After (Using Capacitor)

```typescript
import { Capacitor } from '@capacitor/core';

export class MyComponent {
  private readonly platform = Capacitor.getPlatform();

  constructor() {
    if (this.platform === 'ios') {
      // iOS code
    }
    
    if (this.platform === 'android') {
      // Android code
    }
  }
}
```

**Benefits:**
- ✅ More reliable and consistent
- ✅ Simpler API (just one method)
- ✅ Type-safe with TypeScript
- ✅ Better aligned with Capacitor plugins

---

## Summary

These examples demonstrate:

1. **Project Structure** - Following the Scope Rule
2. **Component Placement** - Based on usage count
3. **Platform Detection** - Using Capacitor correctly
4. **Modern Patterns** - Angular 20 signals and standalone
5. **Push Notifications** - Proper mobile integration
6. **Migration Path** - From legacy to modern code

For more details, consult the reference documents in the `references/` folder!
