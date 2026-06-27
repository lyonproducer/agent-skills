# Ionic Routing Patterns

Complete routing code examples for tabs, menu, and modal navigation. Read this when setting up navigation in an Ionic Angular app.

## Root Routing (app.routes.ts)

```typescript
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

## In-App Routing (pages/in-app/in-app.routes.ts)

```typescript
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

## Tab Routes Definition (pages/in-app/tabs/tabs.routes.ts)

```typescript
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

## Tabs Page Component

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

## TABS Constant (src/app/shared/constants/settings.ts)

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

## Modal Navigation

```typescript
import { Component, inject } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { MyModalComponent } from '@shared/ui/modals/my-modal';

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
