# Transactions Feature (lib/features/transactions)

## Summary
The `transactions` feature is the core ledger of the application. It manages the recording, editing, and history of all financial movements (incomes and expenses) across different accounts and categories.

## Directory Structure
Standard feature-first layout:

| Folder | Layer | Responsibility |
| :--- | :--- | :--- |
| `domain/` | Business Logic | The **Transaction** model and summary logic. |
| `data/` | Data Source | Database helpers and core ledger persistence. |
| `presentation/` | UI & State | **Pages** (New/Edit Transaction flow) and history views. |

## Architectural Role
**Transactions** are the primary data unit. They link together **Accounts** and **Categories**. The transaction lifecycle (Creation, Edit, Delete) is reactive, triggering balance updates across the entire app via Riverpod providers.

## Guidelines
- **Transactional Integrity**: All ledger entries must reference a valid `accountId`.
- **Mappers**: Use `TransactionMapper` in the `data/database/` folder for all serialization logic.
- **Pure Domain**: Keep the `Transaction` model pure, extending `Equatable`.
- **Flow Management**: Use the dedicated `new_edit_transaction_flow` for consistent entry creation.
