2026-04-19
#open
# FUN1.9 – Undo / Redo

Letzten Zug rückgängig machen (Undo) und wiederherstellten (Redo) via Move-Stack im ViewModel.

## Anforderungen

- `NonogramViewModel` bekommt einen `undoStack: [(row: Int, col: Int, oldState: CellState, newState: CellState)]`
- Optional: `redoStack` für Redo-Funktion
- Jede Zell-Änderung (handleTap, endDrag, autoX) pusht auf den Stack
- Undo-Button in der Puzzle-Toolbar (Zurückpfeil-Icon)
- autoX-Züge: beim Undo eines Zugs der autoX ausgelöst hat, werden alle daraus resultierenden auto-X ebenfalls rückgängig gemacht
- Redo wird geleert wenn ein neuer manueller Zug gemacht wird

## Relevante Dateien

- `DailyNonogram/ViewModels/NonogramViewModel.swift` – Move-Stack, undo()/redo()
- `DailyNonogram/Views/NonogramBoardView.swift` oder Toolbar – Undo/Redo-Buttons

## Komplexität / Dauer

Medium / 1–2 h

# Implementierung
