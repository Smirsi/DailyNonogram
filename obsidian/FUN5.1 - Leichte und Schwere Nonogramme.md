2026-04-10
#done
# Aufgabe
Es soll nun für den Benutzer 3 Schwierigkeitsgrade zum Auswählen geben:
- Einfach --> Einfache Rätsel mit einer einfachen Schwierigkeit und einer Größe von 100-150 Felder oder Rätsel mit einer mittleren Schwierigkeit mit einer Größe von 50-80
- Mittel --> Rätsel mit einer mittleren Schwierigkeit in einer Größe von 150-400 oder schwierige Rätsel mit einer Größe von 100-200
- Schwer --> Rätsel mit einer mittleren Schwierigkeit in einer Größe von 400-800 oder schwierige Rätsel mit einer Größe von 150-400

Lade dafür Rätsel für die nächsten 30 Tage herunter und weise ihnen das Datum zu, lösche alle anderen bisher implementierten. Lade sie wieder hier herunter: https://github.com/prometheus42/FreeNono und merke dir, dass es dort Nonogramme zum downloaden gibt.
# Implementierung
90 FreeNono-Puzzles heruntergeladen (je 30 aus Rumiko Course 10x10/15x15/25x25) und in `Resources/Puzzles/easy|medium|hard/` organisiert. Alle bisherigen Puzzles (10 handgemachte + alte FreeNono-Flat-Dateien) gelöscht. `DifficultyLevel`-Enum hinzugefügt, `FreeNonoPuzzleLoader` und `PuzzleLibrary` auf Difficulty-Subdirectories umgebaut. `DailyPuzzleService` erhält difficulty-Parameter für alle Progress- und Puzzle-Funktionen.
Datum: 2026-04-11 | Commit: folgt
#approved 