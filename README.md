Multi-Hub Inventory & Warehousing Optimization Engine

An operational supply chain and inventory analytics project modeling multi-hub warehousing across **4 regional hubs** (`HUB_NORTH`, `HUB_WEST`, `HUB_SOUTH`, `HUB_EAST`) using **SQL** and **Advanced Excel**.

What Is Included
- **`sql/inventory_queries.sql`:** Relational table definitions (`SKU_Master`, `Supplier_Lead_Times`, `Warehouse_Inventory`), multi-table `JOIN`s, Safety Stock, EOQ, Reorder Point (ROP), dead stock (>90 days) detection, and hub/category summaries.
- **`data/*.csv`:** Sample datasets for SKUs, supplier lead times, and warehouse stock ready for SQL practice or Excel Pivot Tables, Slicers, and conditional formatting heatmaps.

How to Use
1. Load the CSV files into your SQL database or SQL editor and run `sql/inventory_queries.sql`.
2. Open the CSV data in Microsoft Excel to build Pivot Tables, Slicers, and ABC / dead stock heatmaps.