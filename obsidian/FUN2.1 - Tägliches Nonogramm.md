2026-04-10
#done 
# Aufgabe
Da das Ziel dieser App ist, jeden Tag grundsätzlich nur 1 Nonogramm anzuzeigen, sollte implementiert werden, dass jeden Tag ein neues Nonogramm angezeigt und lösbar ist. Bereite jedoch vor, dass es Ausnahmen geben wird (z.B. mit der Premium-Version).
# Implementierung
`DailyPuzzleService.swift` implementiert die Logik:
- `todaysPuzzle()` wählt anhand des Datums-Index (Tage seit 1.1.2026 mod Bibliotheksgröße) das heutige Rätsel.
- `saveProgress()` / `loadProgress()` persistieren den Spielstand per UserDefaults (tagesbezogener Schlüssel).
- `ContentView` lädt beim Start das tägliche Rätsel inkl. gespeichertem Fortschritt.
- Die Funktion `puzzle(for:)` ist als Override-Point für spätere Premium-Ausnahmen vorbereitet.
