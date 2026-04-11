# Core Infrastructure (lib/core)

## Summary
The `core` directory contains the application's **infrastructure** and **cross-cutting concerns** that are not specific to any one feature. This includes shared logic, global constants, style definitions, and base services.

## Directory Structure

| Folder | Description |
| :--- | :--- |
| `common/` | Global constants, shared logic, and generic state not tied to a single feature. |
| `configuration/` | Global application managers (e.g., Analytics, Notifications, Firebase). |
| `database/` | Root database access, schema initialization, and shared DB types/helpers. |
| `models/` | Infrastructure-level models (e.g., `ReceivedNotification`) that are used across multiple features. |
| `presentation/` | Global UI state management providers (Theme, Locale, Currency). |
| `style/` | Centralized design system (ThemeData, Colors, Typography). |
| `utils/` | Low-level pure helper functions (Date formatting, String helpers). |
| `widgets/` | Pure UI components (Dialogs, Buttons) that are reused project-wide. |

## Architectural Role
`core` is the **foundation** of the application. High-level features depend on `core`, but `core` MUST NOT depend on any specific feature. Any logic that becomes shared between two or more features should be evaluated for migration to `core`.

## Guidelines
- **Zero Feature Dependencies**: Never import from `lib/features/` within `lib/core/`.
- **Pure Functions**: Keep logic in `utils/` side-effect-free (e.g., no context dependencies).
- **Reusable Components**: Widgets in `widgets/` should be highly configurable and avoid hardcoded business logic.
- **Dependency Flow**: Features import from `core`, but `core` remains autonomous.
