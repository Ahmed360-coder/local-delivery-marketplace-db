# 07 — System-level

Cross-cutting search, auditing and dashboards.

| Object | Type |
|---|---|
| `Search_Platform` | Table-valued function |
| `Reconcile_Order_Totals` | Table-valued function |
| `Nearby_Businesses_By_Category` | Table-valued function |
| `Platform_Health_Snapshot` | Table-valued function |

`Search_Platform` ranks matches by relevance — exact name first, then names starting with the keyword, then names containing it — and only ever returns active businesses that serve the customer's active address.

`Reconcile_Order_Totals` is a read-only audit: it reports every order whose stored total disagrees with the sum of its suborders minus the discount, whose payment amount disagrees with the order total, or that has no payment at all. It deliberately fixes nothing. It is also a useful invariant check on the rest of the system — refunds should only ever move `refunded_amount`, never rewrite an order's totals, and this function is what catches it if they do.
