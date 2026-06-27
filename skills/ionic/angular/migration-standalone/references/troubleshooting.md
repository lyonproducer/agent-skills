# Migration Troubleshooting

Common issues encountered during Ionic Angular Standalone migration and their solutions.

## Issue 1: Icons Not Showing

**Problem:** Icons display as empty squares.

**Solution:** Register icons with `addIcons()`:

```typescript
import { addIcons } from 'ionicons';
import { home } from 'ionicons/icons';

addIcons({ home });
```

## Issue 2: "Can't bind to 'routerLink'"

**Problem:** `routerLink` not working on Ionic components.

**Solution:** Import both `IonRouterLink` and `RouterLink`:

```typescript
imports: [IonButton, IonRouterLink, RouterLink]
```

## Issue 3: Modal/Toast/Alert Not Working

**Problem:** Controllers not found or throwing errors.

**Solution:** Import from standalone:

```typescript
import { ModalController } from '@ionic/angular/standalone';
```

## Issue 4: Build Errors After Migration

**Problem:** Module not found or import errors.

**Solution:**
1. Clear node_modules: `rm -rf node_modules && npm install`
2. Clear build cache: `npx ionic build --clean`
3. Check all imports are from `/standalone`
