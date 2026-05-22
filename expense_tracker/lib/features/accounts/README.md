# Accounts Feature (lib/features/accounts)

## Summary
The `accounts` feature manages the user's financial accounts (e.g., Bank, Cash, Credit Card). It provides functionality for creating, editing, and deleting accounts, as well as tracking their overall balances.

## Directory Structure
Follows the standard feature-first organization:

| Folder | Layer | Responsibility |
| :--- | :--- | :--- |
| `domain/` | Business Logic | The **Account** model and repository definitions. |
| `data/` | Data Source | Database helpers and repository implementations for persistence. |
| `presentation/` | UI & State | **Pages** (Accounts List, New/Edit Account) and Riverpod providers. |

## Architectural Role
The **Account** domain is a core building block. Transactions depend on accounts for categorization and balance impact. This feature utilizes **AccountUIExtension** to handle UI-specific properties like colors and icons without polluting the pure domain model.

## Guidelines
- **Pure Models**: The `Account` model must stay pure (no DB keys, no UI dependencies).
- **Mappers**: Use `AccountMapper` in the `data/database/` folder for all serialization logic.
- **Extensions**: Use `AccountUIExtension` for any UI-specific properties (Color, Icons).
- **Mutations**: Perform account updates through the `accountMutationProvider` to ensure reactive UI updates.
