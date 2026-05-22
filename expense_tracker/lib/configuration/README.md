# Configuration Directory (lib/configuration)

## Summary
The `configuration` directory stores **static application data** and **resource definitions** that are not feature-specific. This typically includes JSON files used for initial app setup or global lookups.

## Directory Structure

| File | Description |
| :--- | :--- |
| `currencies.json` | A complete list of international currencies, symbols, and formatting info. |
| `update-history.json` | Key-value pairs of app versions and their corresponding "What's New" content. |

## Architectural Role
**Configuration** serves as the "Fixed Asset" layer. These files are typically loaded into memory during app startup (e.g., in `main.dart`) or when specific lookups are required (e.g., currency selection).

## Guidelines
- **Static Content**: Do not store frequently changing data here (use the database instead).
- **JSON Format**: Ensure all JSON files match their corresponding Dart parser structures (if applicable).
- **Versioning**: Information in `update-history.json` must be kept in sync with the actual app version in `pubspec.yaml`.
