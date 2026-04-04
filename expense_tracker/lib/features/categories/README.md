# Categories Feature (lib/features/categories)

## Summary
The `categories` feature handles transaction categorization (e.g., Food, Travel, Salary). It manages category types (Income/Expense), custom colors, and icons assigned to each category.

## Directory Structure
Standard feature-first layout:

| Folder | Layer | Responsibility |
| :--- | :--- | :--- |
| `domain/` | Business Logic | The **Category** model and repository definitions. |
| `data/` | Data Source | Database helpers and categorization persistence. |
| `presentation/` | UI & State | **Pages** (Category List, New/Edit Category) and selectors. |

## Architectural Role
**Categories** are an essential dependency for Transactions and Recurring Rules. The `Category` domain model is pure, while its visual representation (Color, Icon) is abstracted into **CategoryUIExtension** to preserve architectural integrity.

## Guidelines
- **Pure Models**: The `Category` model must not contain UI logic or database keys.
- **Mappers**: Use `CategoryMapper` in the `data/database/` folder for DB mapping.
- **Extensions**: Use `CategoryUIExtension` for UI properties like color and icons.
- **Organization**: Categories are strictly separated by type (Income/Expense) in the UI.
