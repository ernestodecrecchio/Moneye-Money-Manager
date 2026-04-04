# Recurring Rules Feature (lib/features/recurring_rules)

## Summary
The `recurring_rules` feature automates the creation of transactions based on fixed schedules (e.g., Monthly Rent, Weekly Salary). It manages the frequency, start/end dates, and automatic generation triggers.

## Directory Structure
Standard feature-first layout:

| Folder | Layer | Responsibility |
| :--- | :--- | :--- |
| `domain/` | Business Logic | The **RecurringRule** model and scheduling logic. |
| `data/` | Data Source | Database helpers and automation triggers. |
| `presentation/` | UI & State | **Pages** (Rule List, Rule Detail) and schedulers. |

## Architectural Role
**Recurring Rules** act as "templates" for Transactions. They depend on both **Category** and **Account** domain models. The automated generation of transactions occurs lazily at app startup or manually via the `transactionsRepositoryProvider`.

## Guidelines
- **Automatic Generation**: Always trigger `generateRecurringTransactionsUntil` before displaying financial summaries.
- **Mappers**: Use `RecurringRuleMapper` in the `data/database/` folder.
- **Pure Scheduling**: The domain model defines the "frequency" as a simple string; interpretation into `DateTime` logic lives in the `core/utils/` or `data` layers.
- **Data Integrity**: Each rule must link to a valid `categoryId` and `accountId`.
