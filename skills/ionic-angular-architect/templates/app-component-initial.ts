import { Component, inject } from '@angular/core';
import { Router } from '@angular/router';
import { Capacitor } from '@capacitor/core';
import { StatusBar, Style } from '@capacitor/status-bar';
import { Platform, IonicModule } from '@ionic/angular';
import { EdgeToEdge } from '@capawesome/capacitor-android-edge-to-edge-support';

// Import your core services
import { NetworkService } from '@core/services/network.service';
import { UtilsService } from '@core/services/utils.service';
import { RouterService } from '@core/services/router.service';
import { PushNotificationService } from '@core/services/push-notification.service';

// Import shared components
import { MenuComponent } from '@shared/components/menu/menu.component';

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

  // Use inject() instead of constructor for modern Angular
  private readonly platform = inject(Platform);
  private readonly router = inject(Router);
  private readonly utilsService = inject(UtilsService);
  private readonly networkService = inject(NetworkService);
  private readonly routerService = inject(RouterService);
  private readonly pushNotificationService = inject(PushNotificationService);

  constructor() {
    // Activate dark mode by default (optional)
    this.initializeDarkMode();

    this.platform.ready().then(async () => {
      // Initialize auth and storage here
      // await this.localStorage.init();
      // await this.authService.getLocalUser();

      // 🚨 REQUIRED: iOS Status Bar Configuration
      // This ensures proper iOS safe area handling and appearance
      if (Capacitor.getPlatform() === 'ios') {
        await StatusBar.setOverlaysWebView({ overlay: true });
        await StatusBar.setStyle({ style: Style.Dark });
        await EdgeToEdge.disable();
      }

      // Android-specific configuration (optional)
      if (Capacitor.getPlatform() === 'android') {
        // Add Android-specific configuration here if needed
        await StatusBar.setStyle({ style: Style.Dark });
      }

      // Initialize push notifications (if using)
      await this.pushNotificationService.addListeners();

      // Handle hardware back button (Android)
      this.utilsService.backButtonReview(this.platform, this.router);

      // Monitor router changes
      this.routerService.getRouterChanges();

      // Monitor network status
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
