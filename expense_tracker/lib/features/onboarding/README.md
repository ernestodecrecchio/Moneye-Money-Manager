# Onboarding Feature (lib/features/onboarding)

## Summary
The `onboarding` feature ensures a friction-less first-time experience. It guides the user through initial configurations (Locale, Currency, First Account) and initial data setup.

## Directory Structure
Standard feature-first layout:

| Folder | Layer | Responsibility |
| :--- | :--- | :--- |
| `domain/` | (Currently Internal) | Onboarding state and configuration rules. |
| `data/` | (Shared) | Initial setup of `SharedPreferences` flags. |
| `presentation/` | UI & State | **Pages** (Initial Configuration, Selection). |

## Architectural Role
**Onboarding** handles the "pre-app" lifecycle. It determines if the user needs to see the setup flow or can proceed to the main `TabBarPage`. It depends on the **Account** and **Category** features for initial data creation.

## Guidelines
- **Lifecycle Control**: The `needs_configuration` flag in `SharedPreferences` is managed here.
- **Data Initialization**: Ensure default categories are created correctly during the onboarding process.
- **Workflow**: Guide the user sequentially through the settings before enabling the main app experience.
