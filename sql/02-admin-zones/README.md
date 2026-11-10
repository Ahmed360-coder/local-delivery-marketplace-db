# 02 — Admin, zones and business moderation

Zone management and the moderation path a business travels after onboarding.

| Object | Type |
|---|---|
| `Create_Zone` | Procedure |
| `Update_Zone_Fee` | Procedure |
| `Suspend_Business` | Procedure |
| `Reinstate_Business` | Procedure |
| `BusinessesPerZone` | View |
| `ZoneOrderReport` | Table-valued function |
| `Daily_Revenue_Report` | Table-valued function |

## Business status machine

```
           approve                suspend
Pending ──────────→ Active ──────────────→ Suspended
   │                   ↑                        │
   │ reject            └────────────────────────┘
   ↓                           reinstate
Rejected ──→ (registering again returns it to Pending)
```

Scope rules: a Zone Admin may only approve, reject or suspend businesses in their own zone; a Super Admin may act on any. **Reinstating is Super Admin only**, regardless of who suspended the business.

## Suspension semantics

Suspending an active business is not just a status flip — it has to unwind everything that has not yet left the shop, atomically:

1. Status becomes `Suspended` and the reason is stored.
2. All of the business's products become unavailable.
3. Every suborder still `Placed` or `Assigned` is cancelled; anything already `Picked Up` or `Delivered` is left alone.
4. Each cancelled suborder is refunded `total_price + delivery_fee`, **capped** so that the payment's refunded amount never exceeds what was actually paid. Refunds credit the customer's wallet unless the order was paid in cash.
5. Affected orders have their status recomputed, and an order whose suborders are now all cancelled gets its voucher released back to `Unused`.

The cap matters more than it looks. An order with a 200 subtotal, a 20 delivery fee and a 50 voucher discount was only ever charged 170, while `total_price + delivery_fee` is 220 — refunding the larger figure would violate the `refunded_amount <= amount` constraint and roll the whole transaction back.

Reinstating is deliberately asymmetric: the status returns to `Active` and the suspension reason is cleared, but products stay unavailable until the partner re-enables them, and cancelled suborders are never revived.

## Reports

`BusinessesPerZone` counts active businesses per zone and must include zones with none — which means the `Active` filter belongs in the join condition, not in a `WHERE` clause that would silently drop the empty zones.

`ZoneOrderReport` and `Daily_Revenue_Report` both compute platform commission as 10% of the `total_price` of non-cancelled suborders — on sales only, not on delivery fees and not after voucher discounts. Both must avoid the classic fan-out trap: joining orders to suborders repeats each order's `total_amount` once per suborder and quietly inflates counts and averages, so order-level and suborder-level aggregates are computed separately.
