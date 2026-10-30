import sqlite3, unittest
from pathlib import Path
from build_db import build, DB
class DataTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls): build()
    def test_order_count(self):
        with sqlite3.connect(DB) as conn:
            self.assertEqual(conn.execute('SELECT COUNT(*) FROM purchase_orders').fetchone()[0],300)
    def test_foreign_keys(self):
        with sqlite3.connect(DB) as conn:
            self.assertEqual(conn.execute('PRAGMA foreign_key_check').fetchall(),[])
    def test_no_negative_inventory(self):
        with sqlite3.connect(DB) as conn:
            self.assertEqual(conn.execute('SELECT COUNT(*) FROM inventory WHERE on_hand < 0').fetchone()[0],0)
if __name__=='__main__': unittest.main()
