import { Injectable } from '@angular/core';
import { PushNotifications } from '@capacitor/push-notifications';

/**
 * Push Notification Service
 *
 * Location: src/app/core/services/push-notification.service.ts
 *
 * This service MUST be placed in core/services as it's a singleton
 * service used throughout the application for mobile push notifications.
 *
 * Usage:
 * 1. Call addListeners() in app.component.ts after platform.ready()
 * 2. Call registerNotifications() when user opts in to notifications
 * 3. Handle notification events in the listeners
 */
@Injectable({
  providedIn: 'root'
})
export class PushNotificationService {

  constructor() { }

  /**
   * Add all push notification event listeners
   * Call this in app.component.ts after platform.ready()
   */
  async addListeners() {
    await PushNotifications.addListener('registration', token => {
      console.info('Registration token: ', token.value);
      // TODO: Send token to your backend server
    });

    await PushNotifications.addListener('registrationError', err => {
      console.error('Registration error: ', err.error);
      // TODO: Handle registration error
    });

    await PushNotifications.addListener('pushNotificationReceived', notification => {
      console.log('Push notification received: ', notification);
      // TODO: Handle foreground notification
      // Example: Show in-app alert or update UI
    });

    await PushNotifications.addListener('pushNotificationActionPerformed', notification => {
      console.log('Push notification action performed', notification.actionId, notification.inputValue);
      // TODO: Handle notification tap/action
      // Example: Navigate to specific screen
    });
  }

  /**
   * Register device for push notifications
   * This will request permissions and register with FCM/APNs
   *
   * @throws Error if user denies permissions
   */
  async registerNotifications() {
    let permStatus = await PushNotifications.checkPermissions();

    if (permStatus.receive === 'prompt') {
      permStatus = await PushNotifications.requestPermissions();
    }

    if (permStatus.receive !== 'granted') {
      throw new Error('User denied permissions!');
    }

    await PushNotifications.register();
  }

  /**
   * Get list of delivered notifications
   * Useful for showing notification history
   */
  async getDeliveredNotifications() {
    const notificationList = await PushNotifications.getDeliveredNotifications();
    console.log('delivered notifications', notificationList);
    return notificationList;
  }

  /**
   * Remove all delivered notifications from notification center
   */
  async removeAllDeliveredNotifications() {
    await PushNotifications.removeAllDeliveredNotifications();
  }

  /**
   * Check current permission status
   */
  async checkPermissions() {
    return await PushNotifications.checkPermissions();
  }
}
