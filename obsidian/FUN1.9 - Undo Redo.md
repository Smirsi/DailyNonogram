2026-04-19
#done
# FUN1.9 – Undo / Redo

Letzten Zug rückgängig machen (Undo) und wiederherstellten (Redo) via Move-Stack im ViewModel.

## Anforderungen

- `NonogramViewModel` bekommt einen `undoStack: [(row: Int, col: Int, oldState: CellState, newState: CellState)]`
- Optional: `redoStack` für Redo-Funktion
- Jede Zell-Änderung (handleTap, endDrag, autoX) pusht auf den Stack
- Undo-Button in der Puzzle-Toolbar (Zurückpfeil-Icon)
- autoX-Züge: beim Undo eines Zugs der autoX ausgelöst hat, werden alle daraus resultierenden auto-X ebenfalls rückgängig gemacht
- Redo wird geleert wenn ein neuer manueller Zug gemacht wird

# Implementierung

Datum: 2026-04-19

`CellChange`-Struct und `undoStack`/`redoStack` in `NonogramViewModel`. Grid-Snapshot vor jedem Zug (inkl. Drag-Geste). `recordUndo(from:)` berechnet Delta und pusht auf Stack. `undo()`/`redo()` restoren exakt den Zustand inkl. autoX-Zellen. `canUndo`/`canRedo` als `@Published` Properties. Undo/Redo-Buttons (Pfeil-Icons) links in der Action-Row des `NonogramBoardView`.
#approved 