---
name: ionic-angular-architecture
description: >
  Ionic + Angular architecture: Scope Rule, Screaming Architecture, project structure, routing patterns.
  Trigger: When architecting Ionic apps, organizing project structure, or applying Scope Rule to Angular + Ionic projects.
metadata:
  author: 789.mx
  version: "1.0"
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
  app/
    pages/
      start-app/                     # Onboarding & authentication pages
        login/
          login.ts
          login.html
          login.scss
        register/
          register.ts
      
      tabs/                          # Main tab-based navigation
        home/
          home.ts
          components/                # Tab-specific components
            feature-card.ts
        profile/
          profile.ts
      
      menu/                          # Side menu navigation (alternative to tabs)
        dashboard/
          dashboard.ts
        settings/
          settings.ts
      
      out-app/                       # Utility pages (404, FAQ, maintenance)
        not-found/
          not-found.ts
        maintenance/
          maintenance.ts
    
    shared/                          # ONLY for 2+ tabs/pages usage
      components/                    # Shared standalone components
        headers/
          header-back.ts
          header-main.ts
        modals/
          confirmation-modal.ts
        cards/
          info-card.ts
      services/                      # Shared business logic services
        data-sync.service.ts
      guards/                        # Shared route guards
        auth.guard.ts
      pipes/                         # Shared pipes
        date-format.pipe.ts
      directives/                    # Shared directives
        auto-focus.directive.ts
      signals/                       # Global signal stores
        user.store.ts
      constants/                     # Shared constants
        database.constants.ts
        api.constants.ts
    
    core/                            # Singleton services & app-wide concerns
      services/
        auth.service.ts              # Authentication
        api.service.ts               # HTTP client wrapper
        push-notification.service.ts # Push notifications (Capacitor)
        network.service.ts           # Network status
        storage.service.ts           # Ionic Storage wrapper
      interceptors/
        app-http.interceptor.ts      # HTTP interceptor
        auth.interceptor.ts          # JWT injection
      guards/
        auth.guard.ts                # Global auth guard
    
    app.component.ts                 # Root component
    app.config.ts                    # App configuration
    app.routes.ts                    # Route configuration
    
  main.ts                            # Bootstrap
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
    redirectTo: 'tabs',
    pathMatch: 'full',
  },
  {
    path: 'tabs',
    loadComponent: () => import('./pages/tabs/tabs').then(m => m.TabsPage),
    children: [
      {
        path: 'home',
        loadComponent: () => import('./pages/tabs/home/home').then(m => m.HomePage),
      },
      {
        path: 'profile',
        loadComponent: () => import('./pages/tabs/profile/profile').then(m => m.ProfilePage),
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

@Component({
  selector: 'app-tabs',
  imports: [IonicModule],
  template: `
    <ion-tabs>
      <ion-tab-bar slot="bottom">
        <ion-tab-button tab="home">
          <ion-icon name="home"></ion-icon>
          <ion-label>Home</ion-label>
        </ion-tab-button>
        
        <ion-tab-button tab="profile">
          <ion-icon name="person"></ion-icon>
          <ion-label>Profile</ion-label>
        </ion-tab-button>
      </ion-tab-bar>
    </ion-tabs>
  `,
})
export class TabsPage {}
```

### Menu-Based Navigation

```typescript
// app.routes.ts
export const routes: Routes = [
  {
    path: '',
    redirectTo: 'menu',
    pathMatch: 'full',
  },
  {
    path: 'menu',
    loadComponent: () => import('./pages/menu/menu').then(m => m.MenuPage),
    children: [
      {
        path: 'dashboard',
        loadComponent: () => import('./pages/menu/dashboard/dashboard').then(m => m.DashboardPage),
      },
    ],
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
| `ProductCard` | Home tab only | `pages/tabs/home/components/` | Scope Rule: 1 tab |
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

// ✅ CORRECT - Use tabs or menu
src/app/pages/tabs/
src/app/pages/menu/
```

### Don't: Violate Scope Rule

```typescript
// ❌ WRONG - Component used in 3 tabs but placed locally
pages/tabs/home/components/shared-card.ts  // Used in home, profile, settings

// ✅ CORRECT
shared/components/shared-card.ts
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
