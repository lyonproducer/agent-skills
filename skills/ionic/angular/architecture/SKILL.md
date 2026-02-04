---
name: ionic-angular-architecture
description: >
  Ionic + Angular architecture: Scope Rule, Screaming Architecture, project structure, routing patterns.
  Trigger: When architecting Ionic apps, organizing project structure, or applying Scope Rule to Angular + Ionic projects.
metadata:
  author: Lyon Incode
  version: "1.1"
---

## When to Use

Load this skill when:
- Architecting Angular + Ionic mobile applications
- Organizing project structure with Scope Rule principles
- Setting up Ionic routing (tabs, menu, modal navigation)
- Applying Screaming Architecture to mobile apps
- Deciding component/service placement

## The Scope Rule - Your Unbreakable Law

**"Scope determines structure"**

- Code used by 2+ tabs/pages → MUST go in `shared/` directories
- Code used by 1 tab/page → MUST stay local in that tab/page
- **NO EXCEPTIONS** - This rule is absolute and non-negotiable

## Screaming Architecture for Angular + Ionic

Your structures must IMMEDIATELY communicate what the application does:

- Tab/page names must describe business functionality, not technical implementation
- Directory structure should tell the story of what the app does at first glance
- Main tab/page components MUST have the same name as their folder

---

## Ionic + Angular Project Structure

```
src/
├── app/
│   ├── core/                          # Singleton services & app-wide concerns
│   │   ├── services/                  # Core plugins Services
│   │   │   ├── auth.service.ts
│   │   │   ├── api.service.ts
│   │   │   ├── push-notification.service.ts
│   │   │   ├── network.service.ts
│   │   │   ├── storage.service.ts
│   │   │   └── ui.service.ts
│   │   ├── interceptors/
│   │   │   ├── app-http.interceptor.ts
│   │   │   └── crashlytics-error-handler.interceptor.ts
│   │   └── guards/
│   │       └── auth.guard.ts          # Global auth guard
│   │       └── unauth.guard.ts        # Global unauth guard
│   │
│   ├── shared/                        # ONLY for 2+ (tabs | menu | feature)/pages usage
│   │   ├── components/
│   │   │   ├── headers/
│   │   │   │   ├── header-back.ts
│   │   │   │   └── header-main.ts
│   │   │   ├── modals/
│   │   │   │   └── confirmation-modal.ts
│   │   │   └── cards/
│   │   │       └── info-card.ts
│   │   ├── services/
│   │   │   └── data-sync.service.ts
│   │   ├── guards/
│   │   │   └── auth.guard.ts          # Shared route guards
│   │   ├── pipes/
│   │   │   └── date-format.pipe.ts
│   │   ├── directives/
│   │   │   └── auto-focus.directive.ts
│   │   ├── signals/
│   │   │   └── user.store.ts
│   │   └── constants/
│   │       ├── database.constants.ts
│   │       └── api.constants.ts
│   │
│   ├── pages/
│   │   ├── start-app/                 # Onboarding & authentication
│   │   │   ├── login/
│   │   │   │   ├── login.page.ts
│   │   │   │   ├── login.page.html
│   │   │   │   └── login.page.scss
│   │   │   ├── register/
│   │   │   │   └── register.page.ts
│   │   │   └── start-app.routes.ts
│   │   │
│   │   ├── in-app/                    # Logged-in experience
│   │   │   ├── tabs/                  # Main tab-based navigation (tabs only usage)
│   │   │   │   ├── home/
│   │   │   │   │   ├── home.page.ts
│   │   │   │   │   └── components/    # Tab-specific components
│   │   │   │   │       └── home-card.component.ts    # Used ONLY by home page
│   │   │   │   ├── profile/
│   │   │   │   │   └── profile.page.ts
│   │   │   │   ├── tabs.routes.ts
│   │   │   │   ├── tabs.page.ts
│   │   │   │   ├── tabs.page.html
│   │   │   │   └── tabs.page.scss
│   │   │   │   
│   │   │   ├── menu/                  # Side menu navigation for pages (menu only usage)
│   │   │   │   ├── dashboard/
│   │   │   │   │   └── dashboard.page.ts
│   │   │   │   ├── settings/
│   │   │   │   │   └── settings.page.ts
│   │   │   │   └── menu.routes.ts
│   │   │   │   
│   │   │   ├── features/               # Pages don't included on menu and tabs 
│   │   │   │   ├── payment/
│   │   │   │   │   ├── payment.page.ts
│   │   │   │   │   └── components/     # payment-specific components
│   │   │   │   │       └── payment-card.component.ts   # Used ONLY by payment page
│   │   │   │   ├── withdraw/
│   │   │   │   │   └── withdraw.page.ts
│   │   │   │   └── features.routes.ts
│   │   │   └── in-app.routes.ts
│   │   │
│   │   └── out-app/                   # Utility pages
│   │       ├── not-found/
│   │       │   └── not-found.page.ts
│   │       ├── maintenance/
│   │       │    └── maintenance.page.ts
│   │       └── out-app.routes.ts
│   │
│   ├── app.component.ts
│   ├── app.config.ts
│   └── app.routes.ts
│
└── main.ts                        # Bootstrap
```

### Path Aliases Configuration

Always configure these aliases in `tsconfig.json`:

```json
{
  "compilerOptions": {
    "paths": {
      "@pages/*": ["src/app/pages/*"],
      "@shared/*": ["src/app/shared/*"],
      "@core/*": ["src/app/core/*"]
    }
  }
}
```

---

## Ionic Routing Patterns

### Tab-Based Navigation

```typescript
// app.routes.ts
import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    redirectTo: 'login',
    pathMatch: 'full',
  },
  {
    path: '',
    loadChildren: () => import('./pages/start-app/start-app.routes').then(m => m.START_APP_ROUTES),
  },
  {
    path: '',
    loadChildren: () => import('./pages/in-app/in-app.routes').then(m => m.IN_APP_ROUTES),
  },
  {
    path: '',
    loadChildren: () => import('./pages/out-app/out-app.routes').then(m => m.OUT_APP_ROUTES),
  },
  {
    path: '**',
    redirectTo: 'not-found',
  },
];
```

### In-App Routing Pattern

```typescript
// pages/in-app/in-app.routes.ts
import { Routes } from '@angular/router';

export const IN_APP_ROUTES: Routes = [
  {
    path: '',
    redirectTo: 'tabs',
    pathMatch: 'full',
  },
  {
    path: 'tabs',
    loadChildren: () => import('./tabs/tabs.routes').then(m => m.tabsRoutes),
  },
  {
    path: 'menu',
    loadChildren: () => import('./menu/menu.routes').then(m => m.menuRoutes),
  },
];
```

### Tab-Based Navigation

```typescript
// pages/in-app/tabs/tabs.routes.ts
import { Routes } from '@angular/router';
import { TabsPage } from './tabs.page';

export const tabsRoutes: Routes = [
  {
    path: '',
    component: TabsPage,
    children: [
      {
        path: 'home',
        loadComponent: () => import('./home/home.page').then(m => m.HomePage),
      },
      {
        path: 'profile',
        loadComponent: () => import('./profile/profile.page').then(m => m.ProfilePage),
      },
      {
        path: '',
        redirectTo: 'home',
        pathMatch: 'full',
      },
    ],
  },
];
```

**tabs.page.ts:**

```typescript
import { Component } from '@angular/core';
import { IonicModule } from '@ionic/angular';
import { TABS } from '@shared/constants/settings';

@Component({
  selector: 'app-tabs',
  imports: [IonicModule],
  templateUrl: './tabs.page.html',
})
export class TabsPage {
  readonly tabsItems = TABS;
}
```

**tabs.page.html:**

```html
<ion-tabs>
  <ion-tab-bar slot="bottom">
    @for (item of tabsItems; track $index) {
      <ion-tab-button [tab]="item.tab">
        <ion-icon aria-hidden="true" [name]="item.icon"></ion-icon>
        <ion-label>{{ item.title }}</ion-label>
      </ion-tab-button>
    }
  </ion-tab-bar>
</ion-tabs>
```

**TABS constant in `src/app/shared/constants/settings.ts`:**

```typescript
export interface ITabItem {
  tab: string;
  title: string;
  icon: string;
}

export const TABS: ITabItem[] = [
  {
    tab: 'home',
    title: 'Home',
    icon: 'home-outline',
  },
  {
    tab: 'library',
    title: 'Library',
    icon: 'library-outline',
  },
  {
    tab: 'my-space',
    title: 'Space',
    icon: 'planet-outline',
  },
  {
    tab: 'social',
    title: 'Social',
    icon: 'people-outline',
  },
];
```

### Modal Navigation

```typescript
import { Component, inject } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { MyModalComponent } from '@shared/modals/my-modal';

@Component({
  selector: 'app-page',
  imports: [IonicModule],
  template: `<ion-button (click)="openModal()">Open Modal</ion-button>`,
})
export class MyPage {
  private readonly modalCtrl = inject(ModalController);

  async openModal(): Promise<void> {
    const modal = await this.modalCtrl.create({
      component: MyModalComponent,
    });
    await modal.present();
    const { data, role } = await modal.onWillDismiss();
  }
}
```

---

## Decision Framework

When analyzing component/service placement, you MUST:

1. **Count usage**: Identify exactly how many tabs/pages use the component
2. **Apply the Scope Rule**: 
   - 1 tab/page = local placement in that tab/page folder
   - 2+ tabs/pages = `shared/` directories
   - App-wide singleton = `core/services/`
3. **Document decision**: Explain WHY the placement was chosen

### Placement Examples

| Component Type | Used In | Placement | Reason |
|----------------|---------|-----------|--------|
| `ProductCard` | Home tab only | `pages/in-app/tabs/home/components/` | Scope Rule: 1 tab |
| `HeaderBack` | Home, Profile, Settings | `shared/components/headers/` | Scope Rule: 3+ tabs |
| `AuthService` | Entire app | `core/services/` | Singleton service |
| `DateFormatPipe` | 2 tabs | `shared/pipes/` | Scope Rule: 2+ tabs |

---

## Quality Checklist

Before finalizing any architectural decision:

1. ✅ **Scope verification**: Correctly counted tab/page usage?
2. ✅ **Navigation pattern**: Using tabs, menu, or modal navigation appropriately?
3. ✅ **Naming validation**: Do names match tabs/pages and follow conventions?
4. ✅ **Lazy loading**: All routes using `loadComponent()` or `loadChildren()`?
5. ✅ **Type safety**: No `any` types?
6. ✅ **File naming**: No `.component`, `.service`, `.module` suffixes?

---

## Anti-Patterns

### Don't: Use "features" Folder

```typescript
// ❌ WRONG - Don't use generic "features" folder
src/app/features/

// ✅ CORRECT - Use tabs, menu or feature in app folder
src/app/pages/in-app/tabs/
src/app/pages/in-app/menu/
src/app/pages/in-app/features/
```

### Don't: Violate Scope Rule

```typescript
// ❌ WRONG - Component used in 3 tabs but placed locally
pages/in-app/tabs/home/components/shared-card.ts  // Used in home, profile, settings

// ✅ CORRECT
shared/components/cards/shared-card.ts
```

### Don't: Mix Navigation Patterns

```typescript
// ❌ WRONG - Don't mix tabs and menu in same route level
{
  path: 'tabs',
  children: [...],
}
{
  path: 'menu',
  children: [...],
}

// ✅ CORRECT - Choose one primary navigation pattern
{
  path: 'tabs',
  children: [...], // All main navigation here
}
```

---

## Resources

- [Ionic Angular Documentation](https://ionicframework.com/docs/angular/overview)
- [Ionic Routing Guide](https://ionicframework.com/docs/angular/navigation)
- [Angular Routing](https://angular.dev/guide/routing)

---

**Remember**: You are the guardian of clean, scalable Angular + Ionic architecture. Every decision must follow the Scope Rule and result in code that immediately communicates what the app does (Screaming Architecture).
