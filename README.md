# Local Business Delivery and Fulfillment Management System

A relational database for a local delivery marketplace — restaurants and pharmacies, customers, riders and zone-based fulfillment. Built for **Databases I (Winter 2026)** at the German University in Cairo, as a five-person team project.

The system models the full lifecycle of an order: a partner onboards a business, an admin approves it, a customer fills a cart tied to their active address, checkout splits the cart into one suborder per business, each suborder is assigned to the least-busy rider in the zone, and riders mark pickup and delivery. Cancellations, suspensions and blacklists all flow back through the payment as refunds.

**Stack:** Microsoft SQL Server 2022 · T-SQL (stored procedures, table-valued functions, views) · SSMS

---

## Milestones

| Milestone | Scope | Status |
|---|---|---|
| **1** | Requirements, EERD, mapping to the relational schema | Complete |
| **2** | Full T-SQL implementation: 25 tables, procedures, functions and views | In progress |

## Data model at a glance

25 relations grouped into six areas:

| Area | Relations |
|---|---|
| Geography | `Zone` |
| People | `Users`, `User_Phone`, `Admin`, `Partner`, `Rider`, `Customer` |
| Customer data | `Address`, `Card`, `Voucher`, `Blacklist`, `Favorite_Business`, `Favorite_Product` |
| Businesses | `Business`, `Business_Phone`, `Restaurant`, `Pharmacy`, `Product` |
| Ordering | `Cart`, `CartItem`, `Orders`, `SubOrder` |
| Fulfillment | `Delivery`, `Payment`, `Feedback` |

Design points worth noting:

- **Superclass/subclass.** `Users` holds every account; `Admin`, `Partner`, `Rider` and `Customer` reuse the superclass key rather than generating their own. Same pattern for `Business` → `Restaurant` / `Pharmacy`, so a business's type is determined by which subclass table holds the row.
- **The cart is the order's item list.** A checked-out cart is frozen and `CartItem.unit_price` is stamped at checkout, so there is no separate `OrderItem` relation and historical prices survive later price changes.
- **Order status is derived, never set directly.** `Orders.status` is recomputed from the statuses of its suborders whenever one of them changes.
- **Money is copied, not referenced.** `SubOrder.delivery_fee` snapshots the zone fee at checkout so that changing a zone's fee later never rewrites historical orders. Totals never change after checkout; cancellations are recorded as refunds instead.

## Repository layout

```
sql/
  01-schema/        database creation, createAllTables, dropAllTables, clearAllTables
  02-admin-zones/   zones, business moderation, admin reports
  03-accounts/      registration, login and password
  04-partners/      business and product catalog management
  05-customer/      addresses, cards, carts, checkout, ordering
  06-rider/         deliveries, earnings and ratings
  07-system/        cross-cutting search, reconciliation and dashboards
milestone-1/        EERD and schema mapping
milestone-2/        the single submission file
docs/               notes and study material
scripts/            helper scripts for local setup and testing
```

## Running it locally

```sql
CREATE DATABASE LocalDeliveryMarketplace_Team_XX;
GO
USE LocalDeliveryMarketplace_Team_XX;
GO
```

Then execute the submission file from top to bottom on a fresh instance. Every object is separated by `GO`, because `CREATE PROCEDURE`, `CREATE FUNCTION` and `CREATE VIEW` must each begin their own batch.

To reset between test runs:

```sql
EXEC clearAllTables;   -- empties every table and reseeds identities
EXEC dropAllTables;    -- drops in reverse dependency order
```

## Conventions

- Every stored procedure returns `0` on success, or a negative error code on failure.
- A rejected call leaves the database completely unchanged.
- Anything touching more than one row or table runs inside a transaction.
- Functions never modify data, so every state change is a stored procedure.

| Code | Meaning |
|---|---|
| `0` | Success |
| `-1` | Invalid input |
| `-2` | Duplicate |
| `-3` | Not allowed |
| `-4` | Wrong status |
| `-5` | Zone mismatch |
| `-6` | Limit exceeded |
| `-7` | Payment cannot be made |
| `-8` | No available rider |
| `-9` | Nothing to process |

## Note on course material

The project description and lecture handouts belong to the course instructors and are not redistributed here. `docs/` contains only my own notes. Teammates' implementation files are added by their authors.

## Author

**Ahmed** — [@Ahmed360-coder](https://github.com/Ahmed360-coder)
Responsible for the database layer: schema creation and teardown, zone management, business moderation (suspend/reinstate) and the zone and revenue reports.
