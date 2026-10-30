from pathlib import Path
import sqlite3, csv
ROOT = Path(__file__).resolve().parent
DB = ROOT / 'supply_chain.db'
TABLES = ['suppliers','warehouses','products','purchase_orders','order_lines','deliveries','inventory']

def build():
    if DB.exists(): DB.unlink()
    with sqlite3.connect(DB) as conn:
        conn.executescript((ROOT/'sql'/'schema.sql').read_text())
        for table in TABLES:
            with (ROOT/'data'/f'{table}.csv').open(newline='') as f:
                rows=list(csv.DictReader(f))
            if not rows: continue
            cols=list(rows[0]); placeholders=','.join('?' for _ in cols)
            conn.executemany(f"INSERT INTO {table} ({','.join(cols)}) VALUES ({placeholders})", [[row[c] for c in cols] for row in rows])
        conn.commit()
    print(f'Created {DB}')
if __name__=='__main__': build()
