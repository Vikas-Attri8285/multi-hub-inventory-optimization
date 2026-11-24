Multi-Hub Inventory & Warehousing Optimization Engine

An operational supply chain and inventory analytics project modeling multi-hub warehousing across **4 regional hubs** (`HUB_NORTH`, `HUB_WEST`, `HUB_SOUTH`, `HUB_EAST`) using **SQL**.

roject Overview
This project structures relational inventory data and uses analytical SQL queries to evaluate stock health, prevent stock-outs, and identify tied-up working capital across regional fulfillment centers.

Repository Structure
- **`sql/inventory_queries.sql`**
  - **Schema Design:** Creates normalized tables (`SKU_Master`, `Supplier_Lead_Times`, `Warehouse_Inventory`) with primary keys.
  - **Replenishment & Risk Modeling:** Uses multi-table `JOIN`s and `CASE WHEN` logic to compute **Safety Stock**, **Economic Order Quantity (EOQ)**, **Reorder Points (ROP)**, and stock health statuses (`CRITICAL_STOCKOUT_RISK`, `DEAD_STOCK_GT_90D`, `HEALTHY`).
  - **Hub & Category Aggregation:** Summarizes SKU counts, stock-out risk counts, and dead stock (>90 days idle) working capital across hubs and categories using `GROUP BY` and conditional aggregates.
- **`data/*.csv`**
  - `sku_master_sample.csv`: Product catalog, unit costs (INR), holding cost rates, ordering costs, and service-level Z-scores.
  - `supplier_lead_times_sample.csv`: Supplier lead times and lead-time standard deviations per hub.
  - `warehouse_inventory_sample.csv`: On-hand stock, reserved quantities, daily demand metrics, and days since last movement.

How to Use
1. Open any relational SQL database or online SQL editor (such as SQLite, PostgreSQL, or MySQL).
2. Run the `CREATE TABLE` statements in `sql/inventory_queries.sql`.
3. Import the three CSV files from the `data/` folder into their matching tables.
4. Execute the `SELECT` queries in `sql/inventory_queries.sql` to generate SKU-level replenishment metrics and hub/category summaries.