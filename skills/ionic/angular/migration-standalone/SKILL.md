---
name: ionic-angular-migration-standalone
description: >
  Guide for migrating Ionic Angular apps to Standalone architecture. Covers both scenarios: apps already using Angular Standalone and apps still using NgModules.
  Trigger: When migrating Ionic apps to Standalone, removing IonicModule, or converting NgModule-based Ionic apps.
metadata:
  author: Lyon Incode
  version: "1.0"
---

## When to Use

Load this skill when:
- Migrating Ionic Angular app to Standalone architecture
- Removing `IonicModule` and using `provideIonicAngular`
- Converting NgModule-based pages to Standalone
- Updating imports from `@ionic/angular` to `@ionic/angular/standalone`
- Setting up ionicons registration in Standalone components

---

## 🚨 Important Migration Note

The migration to Ionic Standalone components must be done **all at once**, not gradually. Module-based and Standalone approaches use different build systems that cannot coexist.

## 🛠 Automated Migration Tool

Ionic provides an automated utility to facilitate this process. **Try this first** before manual changes:

```bash
npx @ionic/angular-standalone-codemods
```

If you prefer manual migration or need to understand the changes, follow the instructions below.

---

## 🚀 Scenario 1: Angular Apps Already Standalone

Follow these steps if your Angular app already uses `standalone: true` but you want to update Ionic UI components to Standalone.

### 1. Update Dependencies

Ensure you have the latest versions:

```bash
npm install @ionic/angular@latest
npm install ionicons@latest
```

### 2. Update Bootstrapping (`main.ts`)

Remove `IonicModule` and use `provideIonicAngular`.

**Before:**

```typescript
import { bootstrapApplication } from '@angular/platform-browser';
import { RouteReuseStrategy } from '@angular/router';
import { IonicModule, IonicRouteStrategy } from '@ionic/angular'; // ❌ Remove
import { AppComponent } from './app/app.component';

bootstrapApplication(AppComponent, {
  providers: [
    { provide: RouteReuseStrategy, useClass: IonicRouteStrategy },
    importProvidersFrom(IonicModule.forRoot({})), // ❌ Remove
  ],
});
```

**After:**

```typescript
import { bootstrapApplication } from '@angular/platform-browser';
import { RouteReuseStrategy } from '@angular/router';
import { provideIonicAngular, IonicRouteStrategy } from '@ionic/angular/standalone'; // ✅ New import
import { AppComponent } from './app/app.component';

bootstrapApplication(AppComponent, {
  providers: [
    { provide: RouteReuseStrategy, useClass: IonicRouteStrategy },
    provideIonicAngular({ 
      mode: 'ios',
      innerHTMLTemplatesEnabled: true,
      sanitizerEnabled: true,
    }), // ✅ New configuration
  ],
});
```

---

## 📦 Scenario 2: NgModule-Based Applications

Follow these steps if your app still uses `AppModule` and you want to adopt Ionic Standalone UI components without migrating the entire app to Angular Standalone yet.

### 1. Configure `app.module.ts`

Remove `IonicModule.forRoot()` from `imports` and add `provideIonicAngular()` to `providers`.

**app.module.ts:**

```typescript
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { RouteReuseStrategy } from '@angular/router';
// Change import to 'standalone'
import { provideIonicAngular, IonicRouteStrategy } from '@ionic/angular/standalone';

import { AppComponent } from './app.component';
import { AppRoutingModule } from './app-routing.module';

@NgModule({
  declarations: [AppComponent],
  imports: [
    BrowserModule,
    AppRoutingModule
    // ❌ Remove IonicModule.forRoot()
  ],
  providers: [
    { provide: RouteReuseStrategy, useClass: IonicRouteStrategy },
    provideIonicAngular({ 
      mode: 'ios',
      innerHTMLTemplatesEnabled: true,
      sanitizerEnabled: true,
    }) // ✅ Add provider
  ],
  bootstrap: [AppComponent],
})
export class AppModule {}
```

### 2. Import Individual Components

Instead of importing `IonicModule` in each page module, import specific components from `@ionic/angular/standalone`.

**home.module.ts:**

```typescript
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
// ✅ Import only what you need from standalone
import { 
  IonContent, 
  IonHeader, 
  IonTitle, 
  IonToolbar,
  IonButton,
  IonCard,
  IonCardContent,
} from '@ionic/angular/standalone';

import { HomePage } from './home.page';
import { HomePageRoutingModule } from './home-routing.module';

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    HomePageRoutingModule,
    // ✅ Add components to imports
    IonContent,
    IonHeader,
    IonTitle,
    IonToolbar,
    IonButton,
    IonCard,
    IonCardContent,
  ],
  declarations: [HomePage]
})
export class HomePageModule {}
```

---

## 🔄 Common Changes (For Both Scenarios)

### 1. Update All Imports

Search throughout your project and replace any imports from `@ionic/angular` with `@ionic/angular/standalone`.

```typescript
// ❌ Before
import { Platform } from '@ionic/angular';
import { ModalController } from '@ionic/angular';
import { ToastController } from '@ionic/angular';

// ✅ After
import { Platform } from '@ionic/angular/standalone';
import { ModalController } from '@ionic/angular/standalone';
import { ToastController } from '@ionic/angular/standalone';
```

### 2. Icon Registration

In Standalone, icons are not loaded automatically. You must register them manually.

**Option A: In Component (Recommended)**

```typescript
import { Component } from '@angular/core';
import { IonIcon } from '@ionic/angular/standalone';
import { addIcons } from 'ionicons';
import { home, person, settings, notifications } from 'ionicons/icons';

@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  imports: [IonIcon],
})
export class HomePage {
  constructor() {
    // Register icons used in this component
    addIcons({ home, person, settings, notifications });
  }
}
```

**Option B: Globally (app.component.ts)**

Register common icons in `AppComponent` constructor to use them anywhere:

```typescript
import { Component } from '@angular/core';
import { addIcons } from 'ionicons';
import { 
  home, 
  person, 
  settings, 
  notifications,
  add,
  close,
  menu,
  search,
} from 'ionicons/icons';

@Component({
  selector: 'app-root',
  templateUrl: 'app.component.html',
})
export class AppComponent {
  constructor() {
    addIcons({
      home,
      person,
      settings,
      notifications,
      add,
      close,
      menu,
      search,
    });
  }
}
```

### 3. Routing and Links

If using `routerLink` in Ionic components, import `IonRouterLink`.

```typescript
import { IonButton, IonRouterLink } from '@ionic/angular/standalone';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-home',
  imports: [
    IonButton,
    IonRouterLink, // Required for Ionic components
    RouterLink,    // Required for Angular base behavior
  ],
})
export class HomePage {}
```

**In template:**

```html
<ion-button routerLink="/profile">View Profile</ion-button>
```

### 4. Common Ionic Component Imports

Here's a reference list of commonly used Ionic components:

```typescript
// Layout
import { 
  IonContent, 
  IonHeader, 
  IonFooter, 
  IonToolbar, 
  IonTitle 
} from '@ionic/angular/standalone';

// Navigation
import { 
  IonTabs, 
  IonTabBar, 
  IonTabButton, 
  IonRouterOutlet,
  IonMenu,
  IonMenuButton,
} from '@ionic/angular/standalone';

// UI Components
import { 
  IonButton, 
  IonCard, 
  IonCardHeader, 
  IonCardTitle, 
  IonCardContent,
  IonList,
  IonItem,
  IonLabel,
  IonInput,
  IonTextarea,
  IonIcon,
} from '@ionic/angular/standalone';

// Controllers (Injectable Services)
import { 
  ModalController, 
  ToastController, 
  AlertController,
  LoadingController,
  ActionSheetController,
} from '@ionic/angular/standalone';
```

---

## 🧪 Testing Configuration (Jest)

If using Jest, update `transformIgnorePatterns` to include Ionic ES modules:

**jest.config.js:**

```javascript
module.exports = {
  transformIgnorePatterns: [
    'node_modules/(?!(@ionic/angular|@ionic/core|ionicons|@stencil/core|@angular/*)/)'
  ]
};
```

---

## ✅ Migration Checklist

Use this checklist to track your migration progress:

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

---

## 🐛 Common Issues & Solutions

### Issue: Icons Not Showing

**Problem:** Icons display as empty squares.

**Solution:** Register icons with `addIcons()`:

```typescript
import { addIcons } from 'ionicons';
import { home } from 'ionicons/icons';

addIcons({ home });
```

### Issue: "Can't bind to 'routerLink'"

**Problem:** `routerLink` not working on Ionic components.

**Solution:** Import both `IonRouterLink` and `RouterLink`:

```typescript
imports: [IonButton, IonRouterLink, RouterLink]
```

### Issue: Modal/Toast/Alert Not Working

**Problem:** Controllers not found or throwing errors.

**Solution:** Import from standalone:

```typescript
import { ModalController } from '@ionic/angular/standalone';
```

### Issue: Build Errors After Migration

**Problem:** Module not found or import errors.

**Solution:** 
1. Clear node_modules: `rm -rf node_modules && npm install`
2. Clear build cache: `npx ionic build --clean`
3. Check all imports are from `/standalone`

---

## 📋 Example: Complete Page Migration

**Before (NgModule):**

```typescript
// home.module.ts
import { IonicModule } from '@ionic/angular';

@NgModule({
  imports: [CommonModule, FormsModule, IonicModule],
  declarations: [HomePage]
})
export class HomePageModule {}
```

**After (Standalone):**

```typescript
// home.page.ts
import { Component } from '@angular/core';
import { 
  IonContent, 
  IonHeader, 
  IonTitle, 
  IonToolbar,
  IonButton,
} from '@ionic/angular/standalone';
import { addIcons } from 'ionicons';
import { add } from 'ionicons/icons';

@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  imports: [
    IonContent,
    IonHeader,
    IonTitle,
    IonToolbar,
    IonButton,
  ],
})
export class HomePage {
  constructor() {
    addIcons({ add });
  }
}

// home.module.ts and home-routing.module.ts can be deleted
```

---

## 📚 Resources

- [Ionic Standalone Migration Guide](https://ionicframework.com/docs/angular/standalone)
- [Angular Standalone Components](https://angular.dev/guide/components/importing)
- [Ionicons Documentation](https://ionic.io/ionicons)

---

**Remember**: Migration to Standalone must be done all at once. Plan accordingly and test thoroughly after migration.
