-- 1. Create tables for products, supplier lead times, and warehouse inventory
CREATE TABLE SKU_Master (
    sku_id VARCHAR(20) PRIMARY KEY,
    sku_name VARCHAR(120),
    category VARCHAR(60),
    unit_cost_inr DECIMAL(10, 2),
    annual_holding_cost_rate DECIMAL(5, 4),
    order_cost_inr DECIMAL(10, 2),
    service_level_z DECIMAL(4, 2)
);

CREATE TABLE Supplier_Lead_Times (
    lead_time_id INT PRIMARY KEY,
    sku_id VARCHAR(20),
    hub_code VARCHAR(20),
    supplier_name VARCHAR(100),
    avg_lead_time_days INT,
    lead_time_std_days DECIMAL(6, 2)
);

CREATE TABLE Warehouse_Inventory (
    inventory_id INT PRIMARY KEY,
    sku_id VARCHAR(20),
    hub_code VARCHAR(20),
    on_hand_qty INT,
    reserved_qty INT,
    avg_daily_demand DECIMAL(10, 2),
    demand_std_daily DECIMAL(10, 2),
    days_since_last_movement INT,
    last_updated_date DATE
);

-- 2. Join tables and calculate Safety Stock, EOQ, Reorder Point, and Stock Status
SELECT
    wi.sku_id,
    sm.sku_name,
    sm.category,
    wi.hub_code,
    slt.supplier_name,
    (wi.on_hand_qty - wi.reserved_qty) AS available_qty,
    wi.avg_daily_demand,
    slt.avg_lead_time_days,
    ROUND(
        sm.service_level_z * SQRT(
            (slt.avg_lead_time_days * POWER(wi.demand_std_daily, 2)) +
            (POWER(wi.avg_daily_demand, 2) * POWER(slt.lead_time_std_days, 2))
        ),
        0
    ) AS safety_stock_qty,
    ROUND(
        SQRT(
            (2.0 * (wi.avg_daily_demand * 365.0) * sm.order_cost_inr) /
            (sm.unit_cost_inr * sm.annual_holding_cost_rate)
        ),
        0
    ) AS eoq_qty,
    ROUND(
        (wi.avg_daily_demand * slt.avg_lead_time_days) +
        (sm.service_level_z * SQRT(
            (slt.avg_lead_time_days * POWER(wi.demand_std_daily, 2)) +
            (POWER(wi.avg_daily_demand, 2) * POWER(slt.lead_time_std_days, 2))
        )),
        0
    ) AS reorder_point_qty,
    wi.days_since_last_movement,
    ROUND((wi.on_hand_qty - wi.reserved_qty) * sm.unit_cost_inr, 2) AS inventory_value_inr,
    CASE
        WHEN (wi.on_hand_qty - wi.reserved_qty) <= 15 THEN 'CRITICAL_STOCKOUT_RISK'
        WHEN wi.days_since_last_movement > 90 THEN 'DEAD_STOCK_GT_90D'
        ELSE 'HEALTHY'
    END AS stock_health_status
FROM Warehouse_Inventory wi
JOIN SKU_Master sm
    ON wi.sku_id = sm.sku_id
JOIN Supplier_Lead_Times slt
    ON wi.sku_id = slt.sku_id
   AND wi.hub_code = slt.hub_code;

-- 3. Summarize stock health and tied-up capital by Hub and Category
SELECT
    wi.hub_code,
    sm.category,
    COUNT(*) AS total_records,
    SUM(CASE WHEN (wi.on_hand_qty - wi.reserved_qty) <= 15 THEN 1 ELSE 0 END) AS stockout_risk_count,
    SUM(CASE WHEN wi.days_since_last_movement > 90 THEN 1 ELSE 0 END) AS dead_stock_gt_90d_count,
    ROUND(
        SUM(
            CASE
                WHEN wi.days_since_last_movement > 90
                THEN (wi.on_hand_qty - wi.reserved_qty) * sm.unit_cost_inr
                ELSE 0
            END
        ),
        2
    ) AS dead_stock_value_inr
FROM Warehouse_Inventory wi
JOIN SKU_Master sm
    ON wi.sku_id = sm.sku_id
GROUP BY wi.hub_code, sm.category
ORDER BY wi.hub_code, sm.category;