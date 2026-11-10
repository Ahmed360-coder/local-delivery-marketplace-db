# 04 — Partners and catalog

Business onboarding and product catalog management.

| Object | Type |
|---|---|
| `Register_Business`, `Update_Business_Info` | Procedures |
| `Upsert_Product`, `Toggle_Product_Status`, `Set_Product_Promotion` | Procedures |
| `BusinessSalesReport`, `BusinessFeedbackOverview` | Table-valued functions |
| `allBusinessProfiles`, `PendingBusinessApprovals`, `TopSellingProducts` | Views |

A partner owns at most one business. Re-registering after a rejection overwrites the rejected row and returns it to `Pending` rather than creating a second business.

Products are never deleted once ordered — they are deactivated instead, so sales history stays intact. While a business is suspended, products cannot be edited or reactivated; that restriction is the counterpart to the suspension logic in `02-admin-zones`.

Discounts are a fixed amount between 0 and half the price, and the effective unit price is `price - discount_amount`.
