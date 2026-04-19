#!/usr/bin/env python3
import os
import xml.etree.ElementTree as ET
from datetime import date, timedelta

SOURCE_BASE = "/Users/philip/PycharmProjects/FreeNono/FreeNono/nonograms"
DEST = "/Users/philip/ClaudeCode/Nonogram/DailyNonogram/Resources/Puzzles/daily"
START_DATE = date(2026, 4, 19)

DIFFICULTY_SIZES = {
    "easy":   ["10x10"],
    "medium": ["15x15", "20x20"],
    "hard":   ["25x25", "30x30"],
}

def parse_nonogram(src_path):
    tree = ET.parse(src_path)
    nonogram = tree.getroot().find(".//Nonogram")
    if nonogram is None:
        return None
    name = nonogram.get("name", "").replace(" ", "_").lower()
    width = int(nonogram.get("width"))
    height = int(nonogram.get("height"))
    lines = []
    for line in nonogram.findall("line"):
        cells = [t if t == "x" else "_" for t in (line.text or "").split()]
        lines.append(cells)
    return name, width, height, lines

def write_nonogram(dest_path, name, width, height, lines):
    content = ['<?xml version="1.0" ?>', '<FreeNono>', '  <Nonograms>',
               f'    <Nonogram name="{name}" height="{height}" width="{width}">']
    for cells in lines:
        content.append(f'      <line> {" ".join(cells)} </line>')
    content += ['    </Nonogram>', '  </Nonograms>', '</FreeNono>', '']
    with open(dest_path, "w", encoding="utf-8") as f:
        f.write("\n".join(content))

def load_puzzles(sizes):
    puzzles = []
    for size in sizes:
        folder = os.path.join(SOURCE_BASE, f"Rumiko Course {size}")
        for fname in sorted(os.listdir(folder)):
            if fname.endswith(".nonogram"):
                puzzles.append(os.path.join(folder, fname))
    return puzzles

os.makedirs(DEST, exist_ok=True)

easy_puzzles   = load_puzzles(DIFFICULTY_SIZES["easy"])
medium_puzzles = load_puzzles(DIFFICULTY_SIZES["medium"])
hard_puzzles   = load_puzzles(DIFFICULTY_SIZES["hard"])

num_days = min(len(easy_puzzles), len(medium_puzzles), len(hard_puzzles))

for i in range(num_days):
    day = START_DATE + timedelta(days=i)
    date_str = day.strftime("%Y%m%d")
    for src_path in [easy_puzzles[i], medium_puzzles[i], hard_puzzles[i]]:
        result = parse_nonogram(src_path)
        if result is None:
            continue
        name, w, h, lines = result
        dest_filename = f"{date_str}_{w}_{h}_{name}.nonogram"
        write_nonogram(os.path.join(DEST, dest_filename), name, w, h, lines)

last_date = (START_DATE + timedelta(days=num_days - 1)).strftime("%Y%m%d")
print(f"Import abgeschlossen: {num_days} Tage × 3 Schwierigkeiten = {num_days * 3} Puzzles")
print(f"  Easy   (10x10):           {len(easy_puzzles):4d} verfügbar, {num_days} genutzt")
print(f"  Medium (15x15, 20x20):    {len(medium_puzzles):4d} verfügbar, {num_days} genutzt")
print(f"  Hard   (25x25, 30x30):    {len(hard_puzzles):4d} verfügbar, {num_days} genutzt")
print(f"Datum-Range: {START_DATE.strftime('%Y%m%d')} bis {last_date}")
