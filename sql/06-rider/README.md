# 06 — Riders, deliveries and ratings

The delivery side of fulfillment.

| Object | Type |
|---|---|
| `Set_Rider_Availability`, `Mark_Picked_Up`, `Mark_Delivered` | Procedures |
| `My_Active_Deliveries`, `My_Earnings`, `My_Rating_Summary`, `My_Delivery_History`, `TopRiders` | Table-valued functions |
| `RiderPerformanceSummary`, `ZoneDeliveryPerformance`, `BusinessRatingsSummary` | Views |

A delivery carries no status column of its own — it is `Assigned`, `Picked Up`, `Delivered` or `Cancelled` exactly as its suborder is. Marking pickup and delivery stamps the timestamps, stores the tracking time in minutes, and triggers a recomputation of the parent order's status.

Riders earn 80% of the delivery fee on delivered suborders. A rider's rating lives on the delivery, and a business's feedback lives on the suborder; each can be left only once, and only after delivery.
