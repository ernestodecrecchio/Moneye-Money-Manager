# Feature Directory (lib/features)

## Summary
The `features` directory implements a **Feature-First** organization. Each subdirectory encapsulates a distinct functional area of the application (e.g., Transactions, Categories, Accounts), including its own models, data sources, and UI components.

## Directory Structure
Every feature follows a standardized internal layout:

| Folder | Layer | Responsibility |
| :--- | :--- | :--- |
| `domain/` | Business Logic | **Pure Models** and repository definitions (The "Core"). |
| `data/` | Data Source | **DB Helpers** and repository implementations (The "Implementation"). |
| `presentation/` | UI & State | **Pages**, widgets, and state providers (The "Interaction"). |

## Architectural Role
Features are designed to be **autonomous modules**. They depend on `core/` but should minimize dependencies on other features. When inter-feature communication is required, it should be handled via abstract interfaces in the `domain` layer or global providers in `core/`.

## Guidelines
- **Strict Separation**: Keep UI code in `presentation`, DB code in `data`, and core business math in `domain`.
- **Encapsulation**: Avoid directly accessing another feature's internal `data` or `presentation` logic. Use public repository interfaces.
- **Mappers**: Data serialization (JSON/Database) MUST live in the `data` layer, Keeping domain models clean and agnostic.
- **State Management**: Use **Riverpod** providers within the `presentation/providers` directory for feature-specific state.
