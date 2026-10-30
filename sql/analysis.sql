-- Q1: Supplier on-time delivery rate (actual_date <= promised_date)
SELECT s.supplier_name, COUNT(*) AS deliveries,
 ROUND(100.0 * AVG(CASE WHEN d.actual_date <= d.promised_date THEN 1.0 ELSE 0.0 END), 1) AS on_time_pct,
 ROUND(AVG(MAX(0, julianday(d.actual_date)-julianday(d.promised_date))), 2) AS avg_days_late
FROM deliveries d JOIN purchase_orders po ON po.order_id=d.order_id
JOIN suppliers s ON s.supplier_id=po.supplier_id
GROUP BY s.supplier_id, s.supplier_name ORDER BY on_time_pct ASC;

-- Q2: Product demand proxy from purchase order lines (NOT actual customer sales)
SELECT p.product_name, SUM(ol.quantity) AS units_ordered,
 ROUND(SUM(ol.quantity*p.unit_cost),2) AS estimated_procurement_value
FROM order_lines ol JOIN products p ON p.product_id=ol.product_id
GROUP BY p.product_id,p.product_name ORDER BY units_ordered DESC LIMIT 10;

-- Q3: Inventory coverage in days (illustrative: ordered units / 180 days)
WITH ordered AS (
 SELECT po.warehouse_id, ol.product_id, SUM(ol.quantity)/180.0 AS avg_daily_ordered
 FROM order_lines ol JOIN purchase_orders po ON po.order_id=ol.order_id
 GROUP BY po.warehouse_id,ol.product_id
)
SELECT w.warehouse_name,p.product_name,i.on_hand,
 ROUND(o.avg_daily_ordered,2) AS avg_daily_ordered,
 CASE WHEN o.avg_daily_ordered>0 THEN ROUND(i.on_hand/o.avg_daily_ordered,1) END AS coverage_days
FROM inventory i JOIN warehouses w ON w.warehouse_id=i.warehouse_id
JOIN products p ON p.product_id=i.product_id
LEFT JOIN ordered o ON o.warehouse_id=i.warehouse_id AND o.product_id=i.product_id
ORDER BY coverage_days ASC;

-- Q4: Rank suppliers by average lateness using a window function
WITH supplier_metrics AS (
 SELECT s.supplier_name,
 ROUND(AVG(MAX(0,julianday(d.actual_date)-julianday(d.promised_date))),2) AS avg_days_late
 FROM suppliers s JOIN purchase_orders po ON po.supplier_id=s.supplier_id
 JOIN deliveries d ON d.order_id=po.order_id GROUP BY s.supplier_id,s.supplier_name
)
SELECT supplier_name,avg_days_late,DENSE_RANK() OVER(ORDER BY avg_days_late DESC) AS lateness_rank
FROM supplier_metrics ORDER BY lateness_rank;
