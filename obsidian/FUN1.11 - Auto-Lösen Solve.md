2026-04-19
#open
# FUN1.11 – Auto-Lösen (Solve)

Ein "Lösen"-Button füllt das gesamte Puzzle korrekt aus. Das Verwenden dieser Funktion kostet 1 Streak-Freeze-Punkt und setzt den Hint-Zähler für dieses Puzzle auf 0.

## Anforderungen

- "Lösen"-Button in der Puzzle-Toolbar (z.B. Zauberstab-Icon)
- Vor dem Lösen: Bestätigungs-Dialog mit Kostenhinweis ("Kostet 1 Freeze-Punkt. Weitere Hints für dieses Puzzle werden deaktiviert.")
- Falls keine Freeze-Punkte vorhanden: alternative Meldung (z.B. Hinweis auf Streak-Freeze-System)
- Nach Bestätigung: alle Zellen korrekt setzen (Lösung aus Puzzle-Daten)
- Setzt Hint-Nutzung für dieses Puzzle auf gesperrt (keine weiteren Hints möglich, FUN1.10)
- Zieht 1 Freeze-Punkt ab (StreakService / DailyPuzzleService)
- Puzzle wird als "gelöst via Solve" markiert (ggf. separates Flag für Statistiken)
- Completion-Overlay zeigt an, dass Auto-Solve genutzt wurde

## Relevante Dateien

- `DailyNonogram/ViewModels/NonogramViewModel.swift` – solveGame()
- `DailyNonogram/Services/DailyPuzzleService.swift` – Freeze-Punkte, Solved-Flag
- `DailyNonogram/Views/CompletionOverlayView.swift` – Solve-Hinweis
- `DailyNonogram/Views/NonogramBoardView.swift` – Solve-Button

## Komplexität / Dauer

Low / ~30 min

# Implementierung
