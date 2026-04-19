#!/usr/bin/env python3
import os
import xml.etree.ElementTree as ET
from datetime import date, timedelta

SOURCE_BASE = "/Users/philip/PycharmProjects/FreeNono/FreeNono/nonograms"
DEST = "/Users/philip/ClaudeCode/Nonogram/DailyNonogram/Resources/Puzzles/daily"
SIZES = ["10x10", "15x15", "20x20", "25x25", "30x30"]
START_DATE = date(2026, 4, 19)

def parse_lines(nonogram_elem):
    lines = []
    for line in nonogram_elem.findall("line"):
        text = line.text or ""
        tokens = text.split()
        cells = []
        for t in tokens:
            if t == "x":
                cells.append("x")
            else:
                cells.append("_")
        lines.append(cells)
    return lines

def write_nonogram(dest_path, name, width, height, lines):
    xml_lines = []
    xml_lines.append('<?xml version="1.0" ?>')
    xml_lines.append('<FreeNono>')
    xml_lines.append('  <Nonograms>')
    xml_lines.append(f'    <Nonogram name="{name}" height="{height}" width="{width}">')
    for cells in lines:
        xml_lines.append(f'      <line> {" ".join(cells)} </line>')
    xml_lines.append('    </Nonogram>')
    xml_lines.append('  </Nonograms>')
    xml_lines.append('</FreeNono>')
    with open(dest_path, "w", encoding="utf-8") as f:
        f.write("\n".join(xml_lines) + "\n")

os.makedirs(DEST, exist_ok=True)

current_date = START_DATE
counts = {"easy": 0, "medium": 0, "hard": 0}

for size in SIZES:
    folder = os.path.join(SOURCE_BASE, f"Rumiko Course {size}")
    files = sorted(f for f in os.listdir(folder) if f.endswith(".nonogram"))
    w, h = map(int, size.split("x"))

    for fname in files:
        src_path = os.path.join(folder, fname)
        tree = ET.parse(src_path)
        root = tree.getroot()
        nonogram = root.find(".//Nonogram")
        if nonogram is None:
            continue

        name = nonogram.get("name", fname.replace(".nonogram", ""))
        name_clean = name.replace(" ", "_").lower()
        lines = parse_lines(nonogram)

        date_str = current_date.strftime("%Y%m%d")
        dest_filename = f"{date_str}_{w}_{h}_{name_clean}.nonogram"
        dest_path = os.path.join(DEST, dest_filename)
        write_nonogram(dest_path, name, w, h, lines)

        cells = w * h
        if cells <= 100:
            counts["easy"] += 1
        elif cells <= 400:
            counts["medium"] += 1
        else:
            counts["hard"] += 1

        current_date += timedelta(days=1)

total = sum(counts.values())
last_date = (current_date - timedelta(days=1)).strftime("%Y%m%d")

print(f"Import abgeschlossen: {total} Puzzles")
print(f"  Easy   (10x10):           {counts['easy']:4d}")
print(f"  Medium (15x15, 20x20):    {counts['medium']:4d}")
print(f"  Hard   (25x25, 30x30):    {counts['hard']:4d}")
print(f"Datum-Range: {START_DATE.strftime('%Y%m%d')} bis {last_date}")
