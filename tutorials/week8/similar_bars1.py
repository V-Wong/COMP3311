#!/usr/bin/python3

import sys
import sqlite3
from collections import defaultdict


def get_bar_drinks(rows):
    bar_drinks = defaultdict(set)

    for bar, beer in rows:
        bar_drinks[bar].add(beer)

    return bar_drinks


if __name__ == "__main__":
    if len(sys.argv) < 3:
        sys.exit(f"Usage: {sys.argv[0]} barName N")

    bar_name, n = sys.argv[1], int(sys.argv[2])

    conn = sqlite3.connect("beers")
    cur = conn.cursor()

    cur.execute("""
        SELECT ba.name, be.name
        FROM Sells s
        INNER JOIN Bars ba ON ba.id = s.bar
        INNER JOIN Beers be ON be.id = s.beer;
    """)

    bar_drinks = get_bar_drinks(cur.fetchall())

    if bar_name not in bar_drinks:
        print(f"Invalid barName: {bar_name}")
    else:
        bars = [
            (bar, len(drinks.intersection(bar_drinks[bar_name])))
            for bar, drinks in bar_drinks.items()
            if len(drinks.intersection(bar_drinks[bar_name])) >= n
            and bar != bar_name
        ]

        if bars:
            print(f"Bar(s) which selel at least {n} same beers as {bar_name}:")
            for bar, num_drinks in sorted(bars, key=lambda x: (-x[1], x[0])):
                print(f"{bar} ({num_drinks})")
        else:
            print(f"No bars sell at least {n} beers as {bar_name}.")

    conn.close()