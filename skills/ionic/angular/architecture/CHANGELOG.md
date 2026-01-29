# Changelog

All notable changes to the Angular Ionic Architect skill will be documented in this file.

## [1.0.0] - 2026-01-28

### Added

#### Core Features
- Initial skill creation with comprehensive Angular 20 + Ionic 8 guidance
- Scope Rule enforcement framework
- Mobile-first architecture patterns with Capacitor

#### Critical Rules
- **Rule 1**: Capacitor platform detection (never use `Platform.is()`)
- **Rule 2**: iOS Status Bar configuration in app.component
- **Rule 3**: Push notification service structure requirement

#### Templates
- `push-notification.service.ts` - Complete push notification service implementation
  - All 4 Capacitor listeners (registration, error, received, action)
  - Permission handling
  - Async/await patterns
- `app-component-initial.ts` - App component bootstrap template
  - iOS status bar configuration
  - Platform-specific initialization
  - Service initialization patterns

#### References
- `capacitor-platform-detection.md` - Complete guide on why and how to use Capacitor
  - Comparison with Ionic's Platform.is()
  - Usage examples for all platforms
  - Best practices and common pitfalls
- `project-structure.md` - Comprehensive project organization guide
  - Decision tree for component placement
  - Complete folder structure example
  - Naming conventions
  - Routing patterns

#### Documentation
- `README.md` - Skill overview and usage guide
- `SKILL.md` - Main skill instructions with metadata
- `CHANGELOG.md` - This file

### Design Decisions

- **Standalone Components First**: Enforcing Angular 20's standalone component architecture
- **Signal-based State**: Prioritizing signals over observables for state management
- **Inject over Constructor**: Modern DI using `inject()` function
- **Modern Control Flow**: Using `@if`, `@for`, `@switch` instead of structural directives
- **Mobile-First**: Capacitor as the primary mobile integration layer

### Quality Standards

- All templates include comprehensive documentation
- Each rule includes rationale and examples
- Reference guides provide both DO and DON'T examples
- Type safety enforced (no `any` types)
- OnPush change detection by default

---

## Future Enhancements (Planned)

### Version 1.1.0 (Planned)
- [ ] Add template for reactive forms with signals
- [ ] Add template for HTTP service with error handling
- [ ] Add reference guide for state management patterns
- [ ] Add examples of computed signals with complex logic

### Version 1.2.0 (Planned)
- [ ] Add template for authentication guard with signals
- [ ] Add reference for testing standalone components
- [ ] Add migration guide from NgModules to standalone
- [ ] Add performance optimization patterns

### Version 1.3.0 (Planned)
- [ ] Add template for infinite scroll implementation
- [ ] Add reference for Capacitor plugin integration
- [ ] Add examples of advanced signal patterns
- [ ] Add accessibility best practices guide

---

## Notes

- This skill is designed to work with **Angular 20+** and **Ionic 8+**
- Breaking changes will increment major version
- New templates/references will increment minor version
- Bug fixes and documentation improvements will increment patch version

---

**Maintained by**: Lyon Incode  
**Last Updated**: 2026-01-28
