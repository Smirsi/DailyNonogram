2026-04-27
#done 
[[Bugs]]
[[Release 1.0]]
# Aufgabe
Wenn man die App schließt, dann kann man nicht mehr Undo klicken.

# Implementierung

Datum: 2026-04-27
Commit: siehe unten

In `NonogramViewModel.swift` werden `undoStack` und `redoStack` jetzt in UserDefaults persistiert (Keys: `undoStack_{difficulty}`, `redoStack_{difficulty}`). Serialisierung als `[[[Int]]]` – jeder `CellChange` als `[row, col, from.rawValue, to.rawValue]`. Beim Init werden die Stacks geladen. Stack-Limit: max. 20 Schritte. Beim Undo/Redo und nach jedem neuen Zug wird der Stack gespeichert.