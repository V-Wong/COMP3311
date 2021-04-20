#!/usr/bin/python3

import sys
import sqlite3


if __name__ == "__main__":
    if len(sys.argv) < 3:
        sys.exit(f"Usage: {sys.argv[0]} barName N")

    bar_name, n = sys.argv[1], int(sys.argv[2])

    conn = sqlite3.connect("beers")
    cur = conn.cursor()

    cur.execute("SELECT * FROM Bars WHERE name = ?", [bar_name])
    if not cur.fetchall():
        print(f"Invalid barName: {bar_name}")
    else:
        cur.execute("""
            SELECT b2.name, count(*)
            FROM Bars b1
            INNER JOIN Sells s1 ON s1.bar = b1.id
            INNER JOIN Sells s2 ON s2.beer = s1.beer
            INNER JOIN Bars b2 ON b2.id = s2.bar
            WHERE s1.bar <> s2.bar 
            AND b1.name = ?
            GROUP BY s2.bar
            HAVING count(*) >= ?
            ORDER BY count(*) DESC, b2.name
        """, [bar_name, n])

        rows = cur.fetchall()

        if rows:
            print(f"Bar(s) which sell at least {n} same beers as {bar_name}:")
            for row in rows:
                print(f"{row[0]} ({row[1]})")
        else:
            print(f"No bars sell at least {n} beers as {bar_name}.")

        conn.close()