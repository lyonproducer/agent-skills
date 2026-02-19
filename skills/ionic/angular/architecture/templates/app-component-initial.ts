import { Component, inject } from '@angular/core';
import { Router } from '@angular/router';
import { Capacitor } from '@capacitor/core';
import { StatusBar, Style } from '@capacitor/status-bar';
import { Platform, IonicModule } from '@ionic/angular';
import { EdgeToEdge } from '@capawesome/capacitor-android-edge-to-edge-support';

// Import core device services (Capacitor plugin abstractions)
import { NetworkService } from '@core/device/network.service';
import { PushNotificationService } from '@core/device/push-notification.service';

// Import shared utility services
import { RouterService } from '@shared/utils/router.service';
import { UiService } from '@shared/utils/ui.service';

// Import shared components
import { MenuComponent } from '@shared/ui/menu/menu.component';

/**
 * Root Application Component
 *
 * This component is the entry point of your Ionic/Angular application.
 * It MUST include iOS-specific configuration for proper mobile behavior.
 */
@Component({
  selector: 'app-root',
  templateUrl: 'app.component.html',
  styleUrls: ['app.component.scss'],
  imports: [IonicModule, MenuComponent],
})
export class AppComponent {

  private readonly platform = inject(Platform);
  private readonly router = inject(Router);
  private readonly uiService = inject(UiService);
  private readonly networkService = inject(NetworkService);
  private readonly routerService = inject(RouterService);
  private readonly pushNotificationService = inject(PushNotificationService);

  constructor() {
    this.initializeDarkMode();

    this.platform.ready().then(async () => {
      // Initialize auth and storage here
      // await this.localStorage.init();
      // await this.authService.getLocalUser();

      if (Capacitor.getPlatform() === 'ios') {
        await StatusBar.setOverlaysWebView({ overlay: true });
        await StatusBar.setStyle({ style: Style.Dark });
        await EdgeToEdge.disable();
      }

      if (Capacitor.getPlatform() === 'android') {
        await StatusBar.setStyle({ style: Style.Dark });
      }

      await this.pushNotificationService.addListeners();

      this.uiService.backButtonReview(this.platform, this.router);

      this.routerService.getRouterChanges();

      this.networkService.initializeNetworkEvents();
    });
  }

  /**
   * Initialize dark mode on app start
   * Remove this if you want to use system preference or toggle
   */
  private initializeDarkMode() {
    document.documentElement.classList.add('ion-palette-dark');
  }
}
