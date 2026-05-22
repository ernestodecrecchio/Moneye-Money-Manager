# Home Feature (lib/features/home)

## Summary
The `home` feature is the primary landing page and financial dashboard. It provides high-level visualizations (Charts) and summaries of the user's overall financial health across all accounts.

## Directory Structure
Standard feature-first layout:

| Folder | Layer | Responsibility |
| :--- | :--- | :--- |
| `domain/` | (Currently Internal) | Dashboard models and summary calculations. |
| `data/` | (Currently Shared) | Cross-feature data aggregation. |
| `presentation/` | UI & State | **Pages** (Dashboard, TabBarHost) and charts. |

## Architectural Role
**Home** acts as the "Command Center". It depends on the **Transaction**, **Account**, and **Category** features for data aggregation. It typically listens to providers from these features to update charts and totals in real-time.

## Guidelines
- **Reactive Data**: Use `ref.watch` on the transaction/account repositories for real-time dashboard updates.
- **Modularity**: The main `TabBarPage` is located here, serving as the navigation root after onboarding.
- **Chart Logic**: Keep visual rendering for charts in the `presentation/widgets/` subfolder.
- **Summaries**: Aggregate balance calculations should be derived from the core repositories.
