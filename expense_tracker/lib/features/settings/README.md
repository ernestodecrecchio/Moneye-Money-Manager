# Settings Feature (lib/features/settings)

## Summary
The `settings` feature manages all global preferences including localization, theme selection, currency formatting, and data management (Backup/Restore). It provides a central hub for user customization.

## Directory Structure
Standard feature-first layout:

| Folder | Layer | Responsibility |
| :--- | :--- | :--- |
| `domain/` | (Currently Internal) | Preferences and setting definitions. |
| `data/` | (Currently via Prefs) | SharedPreferences implementation details. |
| `presentation/` | UI & State | **Pages** (Options, Language, Theme, Backup). |

## Architectural Role
**Settings** provide high-level toggles that affect all other features. Specifically, **Theme**, **Locale**, and **Currency** providers in `core/presentation/` are controlled through this feature's configuration screens.

## Guidelines
- **Persistence**: Most settings are stored via `SharedPreferences`.
- **Global Impact**: Ensure setting changes (like Language or Theme) update the application theme/locale state dynamically.
- **Modularity**: Deep setting pages are organized by functional sub-folders (e.g., `backup_restore_page`).
- **Privacy**: High-level privacy toggles and analytics consent are managed here.
