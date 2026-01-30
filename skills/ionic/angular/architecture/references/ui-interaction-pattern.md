# UI Interaction Pattern (Ionic Controllers)

This reference shows the recommended pattern for using Ionic UI controllers via a single core service.

## Why This Pattern

- Centralizes all UI interactions (alerts, toasts, loaders)
- Keeps components lean and testable
- Enforces consistent look and behavior across the app
- Uses Angular core patterns (`inject()`, standalone-first mindset)

## Service Location

Place the service at:

`src/app/core/services/ui.service.ts`

## UI Service Template

Use the template from:

`templates/ui.service.ts`

## Usage Example

```typescript
import { Component, inject } from '@angular/core';
import { IonicModule } from '@ionic/angular';
import { UiService } from '@core/services/ui.service';

@Component({
  selector: 'app-profile',
  imports: [IonicModule],
  template: `
    <ion-button (click)="save()">Save</ion-button>
  `,
})
export class ProfilePage {
  private readonly ui = inject(UiService);

  async save(): Promise<void> {
    await this.ui.showLoading('Guardando...');
    try {
      // ...save changes
      await this.ui.showToast('Cambios guardados', 'success');
    } catch {
      await this.ui.showToast('Error al guardar', 'danger');
      await this.ui.showAlert('Intenta nuevamente más tarde');
    } finally {
      await this.ui.dismissLoading();
    }
  }
}
```

## Rules

- Always inject `UiService` with `inject()` (no constructor injection).
- Do not call Ionic controllers directly from components.
- Keep text and durations consistent in one place (the service).
