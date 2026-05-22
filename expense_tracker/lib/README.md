# Source Directory (lib)

## Summary
The `lib` directory is the core of the application, containing all Dart source code. It is organized following a **Clean Architecture** approach with a **Feature-First** structure to ensure scalability, testability, and clear separation of concerns.

## Directory Structure

| Folder | Description |
| :--- | :--- |
| `configuration/` | Static configuration data (e.g., JSON files for currencies, updates). |
| `core/` | Shared infrastructure, utilities, cross-cutting concerns, and global UI components. |
| `features/` | Main application logic, split into isolated functional modules. |
| `l10n/` | Localization files and multi-language support. |

## Architectural Role
This directory implements a **Dependency Rule**: Dependencies only point inwards. The core business logic (Domain) must not depend on external layers (Data or UI). 
- **Clean Architecture**: Separation of Business Logic, Data, and Presentation.
- **Feature-First**: Organizes code by functionality (e.g., Transactions) rather than technical type (e.g., Models).

## Guidelines
- **No Global Models**: Domain models should live within their respective features.
- **Strict Layering**: Honor the boundaries between `domain`, `data`, and `presentation`.
- **Prefer Composition**: Use the `core/` components for shared UI/Logic rather than duplicating code across features.
- **Immutability**: All domain models must be immutable (extending `Equatable`).
