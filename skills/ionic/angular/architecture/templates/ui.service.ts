import { inject, Injectable } from '@angular/core';
import { AlertButton, AlertController, LoadingController, ToastController } from '@ionic/angular';

@Injectable({ providedIn: 'root' })
export class UiService {
  private readonly loadingCtrl = inject(LoadingController);
  private readonly toastCtrl = inject(ToastController);
  private readonly alertCtrl = inject(AlertController);

  private currentLoading: HTMLIonLoadingElement | null = null;

  // --- LOADING ---
  async showLoading(message: string = 'Cargando...') {
    this.currentLoading = await this.loadingCtrl.create({
      message,
      cssClass: 'custom-loading',
    });
    await this.currentLoading.present();
  }

  async dismissLoading() {
    if (this.currentLoading) {
      await this.currentLoading.dismiss();
      this.currentLoading = null;
    }
  }

  // --- TOAST ---
  async showToast(message: string, color: 'success' | 'danger' | 'warning' = 'success') {
    const toast = await this.toastCtrl.create({
      message,
      color,
      duration: 2000,
      position: 'top',
    });
    return await toast.present();
  }

  // --- ALERTS ---
  async showAlert(message: string, buttons: (string | AlertButton)[] = ['OK']) {
    const alert = await this.alertCtrl.create({
      message,
      buttons,
      mode: 'md',
    });
    await alert.present();
  }
}
