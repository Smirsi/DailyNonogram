2026-04-19
#done
[[Funktionen]]
[[Release 1.0]]
# FUN1.11 – Auto-Lösen (Solve)

Ein "Lösen"-Button füllt das gesamte Puzzle korrekt aus. Das Verwenden dieser Funktion kostet 1 Streak-Freeze-Punkt und setzt den Hint-Zähler für dieses Puzzle auf 0.
Dies ist nur für Premium verfügbar.

## Anforderungen

- "Lösen"-Button in der Puzzle-Toolbar (z.B. Zauberstab-Icon)
- Vor dem Lösen: Bestätigungs-Dialog mit Kostenhinweis ("Kostet 1 Freeze-Punkt. Weitere Hints für dieses Puzzle werden deaktiviert.")
- Falls keine Freeze-Punkte vorhanden: alternative Meldung (z.B. Hinweis auf Streak-Freeze-System)
- Nach Bestätigung: alle Zellen korrekt setzen (Lösung aus Puzzle-Daten)
- Setzt Hint-Nutzung für dieses Puzzle auf gesperrt (keine weiteren Hints möglich, FUN1.10)

# Implementierung

Datum: 2026-04-19

`StreakService.spendFreezeForSolve(isPremium:)` verbraucht einen Freeze-Token ohne Datum-Zuweisung. `availableFreezes` berücksichtigt nun auch `solveSpentFreezes`. `NonogramViewModel.applySolve()` füllt alle Zellen, setzt `hintsBlocked = true`, zeigt Completion-Overlay. `NonogramBoardView` zeigt "Lösen"-Button (Zauberstab) nur für Premium, deaktiviert wenn keine Freezes. Bestätigungs-Dialog mit Kostenhinweis.
