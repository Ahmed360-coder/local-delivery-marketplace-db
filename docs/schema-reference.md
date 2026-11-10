# Schema reference

The 25 relations, in creation order. Primary keys are **bold**, foreign keys are _italic_.

| # | Relation | Columns |
|---|---|---|
| 1 | `Zone` | **zone_id**, zone_name, delivery_fee |
| 2 | `Users` | **user_id**, first_name, middle_name, last_name, username, password, email, dob, account_status |
| 3 | `User_Phone` | **_user_id_**, **phone** |
| 4 | `Admin` | **_admin_id_**, role, _zone_id_ |
| 5 | `Partner` | **_partner_id_** |
| 6 | `Rider` | **_rider_id_**, vehicle_type, plate_no, license_no, is_available, _zone_id_ |
| 7 | `Customer` | **_customer_id_**, wallet_balance |
| 8 | `Address` | **address_id**, description, is_active, _customer_id_, _zone_id_ |
| 9 | `Card` | **card_id**, card_no, card_holder_name, expiration_date, _customer_id_ |
| 10 | `Business` | **business_id**, name, description, link_website, opening_hour, closing_hour, expected_delivery_time, status, suspension_reason, _partner_id_, _zone_id_ |
| 11 | `Business_Phone` | **_business_id_**, **phone** |
| 12 | `Restaurant` | **_business_id_**, cuisine_type, food_category |
| 13 | `Pharmacy` | **_business_id_**, pharmacy_type |
| 14 | `Blacklist` | **_customer_id_**, _admin_id_, reason |
| 15 | `Product` | **product_id**, name, description, category, price, discount_amount, is_available, _business_id_ |
| 16 | `Favorite_Business` | **_customer_id_**, **_business_id_** |
| 17 | `Favorite_Product` | **_customer_id_**, **_product_id_** |
| 18 | `Voucher` | **voucher_id**, promo_code, is_percentage, amount, expiry_date, status, _customer_id_ |
| 19 | `Cart` | **cart_id**, status, created_at, _customer_id_, _address_id_ |
| 20 | `CartItem` | **_cart_id_**, **_product_id_**, quantity, notes, unit_price |
| 21 | `Orders` | **order_id**, order_date, status, discount_amount, total_amount, _cart_id_, _zone_id_, _voucher_id_ |
| 22 | `SubOrder` | **suborder_id**, status, total_price, delivery_fee, _order_id_, _business_id_ |
| 23 | `Delivery` | **delivery_id**, assigned_at, picked_up_at, delivered_at, tracking_time, rider_rating, _suborder_id_, _rider_id_ |
| 24 | `Payment` | **payment_id**, amount, currency, method, transaction_date, refunded_amount, _order_id_, _card_id_ |
| 25 | `Feedback` | **feedback_id**, headline, description, rating, feedback_date, _suborder_id_ |

`Orders` carries an `s` because `ORDER` is a reserved word in T-SQL.

## Uniqueness

Single column: `Zone.zone_name`, `Users.username`, `Users.email`, `Rider.plate_no`, `Rider.license_no`, `Business.partner_id`, `Voucher.promo_code`, `Orders.cart_id`, `Delivery.suborder_id`, `Payment.order_id`, `Feedback.suborder_id`.

Composite: `Card (customer_id, card_no)` and `SubOrder (order_id, business_id)` — a business appears at most once per order.

The one-to-one relationships are enforced by uniqueness on the referencing side: one delivery per suborder, one payment per order, one feedback per suborder.

## Conventions

| Kind of value | Type |
|---|---|
| Surrogate keys | `int identity(1,1)`; subclass tables reuse the parent key and have no identity |
| Money | `decimal(10,2)` |
| Quantities, ratings, minutes | `int` |
| Flags | `bit` |
| Dates / timestamps / opening hours | `date` / `datetime` / `time` |
| Phone / card numbers | `char(11)` / `char(16)` |

## Status domains

| Column | Values | Default |
|---|---|---|
| `Users.account_status` | Active, Blacklisted | Active |
| `Admin.role` | Super Admin, Zone Admin | Super Admin |
| `Business.status` | Pending, Active, Suspended, Rejected | Pending |
| `Cart.status` | Active, Checked Out | Active |
| `Orders.status` | Placed, In Progress, Delivered, Cancelled | Placed |
| `SubOrder.status` | Placed, Assigned, Picked Up, Delivered, Cancelled | Placed |
| `Voucher.status` | Unused, Used | Unused |
| `Payment.method` | Cash, Card, Wallet | — |

## Check constraints

`delivery_fee >= 0` · `wallet_balance >= 0` · `expected_delivery_time > 0` · `price > 0` · `discount_amount >= 0 AND discount_amount <= 0.5 * price` · `Voucher.amount > 0` · `quantity BETWEEN 1 AND 10` · `rider_rating BETWEEN 1 AND 5` · `Feedback.rating BETWEEN 1 AND 5` · `refunded_amount <= amount`
