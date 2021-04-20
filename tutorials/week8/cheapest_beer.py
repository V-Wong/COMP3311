#!/usr/bin/python3

import sys
import sqlite3


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[1]} beerName")

    beer_name = sys.argv[1]

    conn = sqlite3.connect("beers")
    cur = conn.cursor()

    cur.execute("SELECT * from Beers where name = ?", [beer_name])
    if not cur.fetchall():
        print(f"Invalid beerName: {beer_name}")
    else:
        cur.execute("""
            SELECT ba.name, s.price
            FROM Sells s
            INNER JOIN Bars ba ON ba.id = s.bar
            INNER JOIN Beers be ON be.id = s.beer
            WHERE be.name = ?
            AND price = (
                SELECT MIN(price)
                FROM Sells
                INNER JOIN Beers ON Beers.id = Sells.beer
                WHERE Beers.name = ?
            )
            ORDER BY bar;
        """, [beer_name, beer_name])

        rows = cur.fetchall()

        if rows:
            print(f"Bar(s) where {beer_name} is sold the cheapest:")
            
            for row in rows:
                print(f"{row[0]} (${'{:,.2f}'.format(row[1])})")
        else:
            print(f"No bars sell {beer_name}")

    conn.close()