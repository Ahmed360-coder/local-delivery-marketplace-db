# 01 — Schema

Database creation and the four structural procedures.

| Object | Type | Purpose |
|---|---|---|
| `LocalDeliveryMarketplace_Team_XX` | SQL statement | Creates the database |
| `createAllTables` | Procedure | Creates all 25 tables with their constraints |
| `dropAllTables` | Procedure | Drops every table in reverse dependency order |
| `dropAllProceduresFunctionsViews` | Procedure | Drops every procedure (except itself), function and view, helpers included |
| `clearAllTables` | Procedure | Empties every table and reseeds identities so the next ID is 1 |

## Creation order

Tables are created in dependency order, so every foreign key points at a table that already exists:

```
Zone → Users → User_Phone → Admin → Partner → Rider → Customer
     → Address → Card → Business → Business_Phone → Restaurant → Pharmacy
     → Blacklist → Product → Favorite_Business → Favorite_Product → Voucher
     → Cart → CartItem → Orders → SubOrder → Delivery → Payment → Feedback
```

`dropAllTables` walks the exact reverse: `Feedback` first, `Zone` last.

## Identity columns

Thirteen tables generate their own key: `Zone`, `Users`, `Address`, `Card`, `Business`, `Product`, `Voucher`, `Cart`, `Orders`, `SubOrder`, `Delivery`, `Payment`, `Feedback`.

The other twelve take their key from a parent or from a composite of two foreign keys, and have no identity — the subclass tables (`Admin`, `Partner`, `Rider`, `Customer`, `Restaurant`, `Pharmacy`), the phone tables, `Blacklist`, both favorites tables and `CartItem`.

Only the first list needs reseeding in `clearAllTables`. Note that `DBCC CHECKIDENT (..., RESEED, 0)` makes the next row ID `1` on a table that has held rows before, but `0` on a table that has never held any, so the procedure is worth testing on both a populated and a freshly created database.
