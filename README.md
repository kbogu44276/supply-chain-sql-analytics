# Supply Chain SQL Analytics

A reproducible **SQL portfolio exercise** for a junior supply-chain systems consultant role. Uses **synthetic, randomly generated data**, not a real business dataset.

## Business questions
1. Which suppliers have the lowest on-time delivery rate?
2. Which products account for the largest purchase-order quantities?
3. Which warehouse/product pairs have the lowest illustrative inventory coverage?
4. How can suppliers be ranked by late-delivery severity?

## Stack
SQLite (SQL joins, aggregations, CTEs, window functions), Python standard library, CSV, unittest.

## Run
Requires Python 3.10+; no third-party dependencies.

```bash
python build_db.py
python -m unittest discover -s tests -v
sqlite3 supply_chain.db < sql/analysis.sql
```

Alternatively open `supply_chain.db` in DB Browser for SQLite and run queries from `sql/analysis.sql`.

## Data model
Seven related tables: suppliers, warehouses, products, purchase_orders, order_lines, deliveries, inventory. Keys and constraints are in `sql/schema.sql`.

## Important limitations
- Data is synthetic and not evidence of real operational performance.
- `order_lines` represents **purchase orders**, not end-customer sales; the volume metric is a procurement proxy, not a true demand forecast.
- Inventory is a single snapshot; coverage uses a 180-day average procurement rate and is illustrative only.
- Delivery punctuality is measured at order level, not individual line level.

## Portfolio next steps
- Review and explain every SQL query in your own words.
- Add a diagram, screenshots of query output, and a short business findings report.
- Extend with sales orders, historical stock movements, lead-time variability, and reorder-point simulation.
- Publish only after testing and adapting the project yourself; clearly credit any AI assistance.
