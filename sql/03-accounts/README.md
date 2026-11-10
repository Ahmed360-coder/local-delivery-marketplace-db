# 03 — Accounts: registration, login and password

Registration for customers, partners and riders, the four login functions and password change.

| Object | Type |
|---|---|
| `Customer_Register`, `Partner_Register`, `Rider_Register` | Procedures |
| `CustomerLoginValidation`, `PartnerLoginValidation`, `RiderLoginValidation`, `AdminLoginValidation` | Scalar functions |
| `Change_Password` | Procedure |

Registration writes to three tables — `Users`, the matching subclass table using the newly generated `user_id`, and `User_Phone` — so it runs inside a transaction. Usernames and emails are unique across all account types.

Login functions return a bit: `1` only when the credentials match an account of that type whose status is `Active`, and `0` on any error, including a blacklisted customer.
