2026-04-19
#done
# Aufgabe
Mittleres und Schweres Rätsel wird nicht mehr angezeigt im HomeScreen. Wieder ergänzen.

# Implementierung

Datum: 2026-04-19

`FreeNonoPuzzleLoader` um `loadAllDailyPuzzles(for:)` und `loadDailyPuzzle(for:difficulty:)` erweitert. `DailyPuzzleService.puzzle(for:difficulty:)` nutzt jetzt die difficulty-spezifische Methode. `DifficultySelectionView` zeigt immer alle 3 Schwierigkeitsgrade (easy/medium/hard), für jeden wird der passende Daily-Puzzle-Eintrag gesucht.
