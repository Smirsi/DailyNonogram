2026-04-19
#done 
[[Funktionen]]
[[Release 1.0]]
# Aufgabe
Verwerfe alle Nonogramme bisher. Die Nonogramme sollen in Zukunft folgende Struktur haben: YYYYMMDD_COL_ROW_NAME
Über das Datum wird der Tag zugewiesen, wann es verwendert wird. Über COL mal ROW wird entscheiden ob es einfach, mittel oder schwer ist.
einfach bis 100, mittel bis 400, schwer darüber

ich werde die nonogramme selber in den ordner kopieren, sag mir wo ich diese reinspeichern soll.
# Rückfragen

**F: Wo soll ich die Nonogramm-Dateien ablegen?**
A: In diesem Ordner:
`DailyNonogram/Resources/Puzzles/daily/`
Dateiname-Format: `YYYYMMDD_COL_ROW_NAME.nonogram`
Beispiel: `20260419_10_10_Herz.nonogram` (10×10 = 100 Felder → Einfach)

Schwierigkeit wird automatisch berechnet:
- ≤ 100 Felder (COL × ROW) → Einfach
- ≤ 400 Felder → Mittel
- > 400 Felder → Schwer

# Implementierung

Datum: 2026-04-19

- `FreeNonoPuzzleLoader.swift`: Neue Funktion `loadDailyPuzzle(for:)` scannt `Puzzles/daily/` nach `YYYYMMDD_*`-Dateien, parst COL/ROW aus Dateinamen und leitet Difficulty ab. Mit Cache um mehrfache Bundle-Scans zu vermeiden.
- `DailyPuzzleService.swift`: Neue `todaysDailyPuzzle()` Funktion; `puzzle(for:difficulty:)` prüft zuerst auf tagesbasiertes Puzzle, fällt sonst auf zyklische Rotation zurück.
- `DifficultySelectionView.swift`: Zeigt bei vorhandenem Tages-Puzzle eine einzelne Karte mit Puzzle-Name und Gittergröße statt 3 Schwierigkeits-Buttons. Titel geändert zu "Daily Nonogram".
- `ContentView.swift`: Übergibt `DailyPuzzleService.todaysDailyPuzzle()` an DifficultySelectionView.
- Neues Verzeichnis: `DailyNonogram/Resources/Puzzles/daily/`
#approved 