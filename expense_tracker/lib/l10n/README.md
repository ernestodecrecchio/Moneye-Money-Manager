# Localization Directory (lib/l10n)

## Summary
The `l10n` (Localization) directory manages the application's multi-language support. It coordinates the **`.arb`** (Application Resource Bundle) files into a single localized Dart API.

## Directory Structure

| File | Description |
| :--- | :--- |
| `app_en.arb` | The primary (English) translation source. All new keys should originate here. |
| `app_[other].arb` | Translations for additional languages (Italian, Turkish, etc.). |
| `l10n.dart` | The central configuration for supported locales (`L10n.all`). |
| `app_localizations.dart` | The generated Dart API for localized strings. |

## Architectural Role
**Localization** is a cross-cutting concern that enables the application to dynamically switch languages. The generated `AppLocalizations` class is provided via the `appLocalizationsProvider` (in `core/presentation/Providers/`) to the entire app.

## Guidelines
- **Workflow**: Always update `app_en.arb` first, then run `flutter gen-l10n` (or let it auto-generate) to refresh the Dart API.
- **Keys**: Use descriptive, camelCase keys (e.g., `totalBalanceTitle`).
- **Placeholders**: Use curly braces `{count}` for dynamic content and define the type (e.g., `int`) in the metadata.
- **Consistency**: Keep the translations in sync across all supported `.arb` files.
