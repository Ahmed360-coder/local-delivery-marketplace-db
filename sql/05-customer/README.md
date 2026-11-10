# 05 — Customer: addresses, carts and ordering

Everything between saving an address and placing an order.

| Object | Type |
|---|---|
| `Add_Customer_Address`, `Update_Delete_Customer_Address`, `Change_Active_Address`, `Add_Card` | Procedures |
| `Create_Cart`, `Add_To_Cart`, `Remove_From_Cart` | Procedures |
| `Checkout_Cart`, `Cancel_Order`, `Reorder` | Procedures |
| `Submit_Feedback`, `Rate_Rider`, `Toggle_Favorite` | Procedures |
| `Calculate_Voucher_Discount` | Scalar function |
| `My_Order_History`, `My_Favorites`, `Recommended_Products` | Table-valued functions |

A customer has exactly one active address at a time, and carts are bound to an address rather than chosen per order. Every product in a cart must come from a business in that address's zone, and no single line may exceed ten units.

Checkout is the largest single operation in the project and is strictly atomic: validate everything first, stamp effective prices into the cart, create the order, split it into one suborder per business, apply the voucher, assign a rider to each suborder, record the payment, and freeze the cart.
