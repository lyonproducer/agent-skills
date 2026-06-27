# Migration Scenarios

Detailed before/after code for the two migration scenarios. Read this when executing the migration steps in `SKILL.md`.

## Scenario 1: Angular Apps Already Standalone

Follow these steps if your Angular app already uses `standalone: true` but you want to update Ionic UI components to Standalone.

### 1. Update Dependencies

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
import { IonicModule, IonicRouteStrategy } from '@ionic/angular'; // Remove
import { AppComponent } from './app/app.component';

bootstrapApplication(AppComponent, {
  providers: [
    { provide: RouteReuseStrategy, useClass: IonicRouteStrategy },
    importProvidersFrom(IonicModule.forRoot({})), // Remove
  ],
});
```

**After:**

```typescript
import { bootstrapApplication } from '@angular/platform-browser';
import { RouteReuseStrategy } from '@angular/router';
import { provideIonicAngular, IonicRouteStrategy } from '@ionic/angular/standalone';
import { AppComponent } from './app/app.component';

bootstrapApplication(AppComponent, {
  providers: [
    { provide: RouteReuseStrategy, useClass: IonicRouteStrategy },
    provideIonicAngular({
      mode: 'ios',
      innerHTMLTemplatesEnabled: true,
      sanitizerEnabled: true,
    }),
  ],
});
```

## Scenario 2: NgModule-Based Applications

Follow these steps if your app still uses `AppModule` and you want to adopt Ionic Standalone UI components without migrating the entire app to Angular Standalone yet.

### 1. Configure `app.module.ts`

Remove `IonicModule.forRoot()` from `imports` and add `provideIonicAngular()` to `providers`.

```typescript
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { RouteReuseStrategy } from '@angular/router';
import { provideIonicAngular, IonicRouteStrategy } from '@ionic/angular/standalone';

import { AppComponent } from './app.component';
import { AppRoutingModule } from './app-routing.module';

@NgModule({
  declarations: [AppComponent],
  imports: [
    BrowserModule,
    AppRoutingModule
  ],
  providers: [
    { provide: RouteReuseStrategy, useClass: IonicRouteStrategy },
    provideIonicAngular({
      mode: 'ios',
      innerHTMLTemplatesEnabled: true,
      sanitizerEnabled: true,
    })
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

## Common Changes (For Both Scenarios)

### Update All Imports

Search throughout your project and replace any imports from `@ionic/angular` with `@ionic/angular/standalone`.

```typescript
// Before
import { Platform } from '@ionic/angular';
import { ModalController } from '@ionic/angular';
import { ToastController } from '@ionic/angular';

// After
import { Platform } from '@ionic/angular/standalone';
import { ModalController } from '@ionic/angular/standalone';
import { ToastController } from '@ionic/angular/standalone';
```

### Icon Registration

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
    addIcons({ home, person, settings, notifications });
  }
}
```

**Option B: Globally (app.component.ts)**

```typescript
import { Component } from '@angular/core';
import { addIcons } from 'ionicons';
import {
  home, person, settings, notifications,
  add, close, menu, search,
} from 'ionicons/icons';

@Component({
  selector: 'app-root',
  templateUrl: 'app.component.html',
})
export class AppComponent {
  constructor() {
    addIcons({
      home, person, settings, notifications,
      add, close, menu, search,
    });
  }
}
```

### Routing and Links

If using `routerLink` in Ionic components, import `IonRouterLink`.

```typescript
import { IonButton, IonRouterLink } from '@ionic/angular/standalone';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-home',
  imports: [
    IonButton,
    IonRouterLink,
    RouterLink,
  ],
})
export class HomePage {}
```

```html
<ion-button routerLink="/profile">View Profile</ion-button>
```

### Common Ionic Component Imports

```typescript
// Layout
import {
  IonContent, IonHeader, IonFooter, IonToolbar, IonTitle
} from '@ionic/angular/standalone';

// Navigation
import {
  IonTabs, IonTabBar, IonTabButton, IonRouterOutlet,
  IonMenu, IonMenuButton,
} from '@ionic/angular/standalone';

// UI Components
import {
  IonButton, IonCard, IonCardHeader, IonCardTitle, IonCardContent,
  IonList, IonItem, IonLabel, IonInput, IonTextarea, IonIcon,
} from '@ionic/angular/standalone';

// Controllers (Injectable Services)
import {
  ModalController, ToastController, AlertController,
  LoadingController, ActionSheetController,
} from '@ionic/angular/standalone';
```

## Testing Configuration (Jest)

If using Jest, update `transformIgnorePatterns` to include Ionic ES modules:

```javascript
module.exports = {
  transformIgnorePatterns: [
    'node_modules/(?!(@ionic/angular|@ionic/core|ionicons|@stencil/core|@angular/*)/)'
  ]
};
```

## Complete Page Migration Example

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
  IonContent, IonHeader, IonTitle, IonToolbar, IonButton,
} from '@ionic/angular/standalone';
import { addIcons } from 'ionicons';
import { add } from 'ionicons/icons';

@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  imports: [
    IonContent, IonHeader, IonTitle, IonToolbar, IonButton,
  ],
})
export class HomePage {
  constructor() {
    addIcons({ add });
  }
}

// home.module.ts and home-routing.module.ts can be deleted
```
