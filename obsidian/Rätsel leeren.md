2026-04-27
#done 
[[Funktionen]]
[[Release 1.0]]
# Aufgabe
Neben Redo soll es einen Button mit Leeren oder so geben, der das komplette Rätsel zurücksetzt. Das muss aber mit einem Popup bestätigt werden und darf nicht gleich passieren.

# Implementierung

Datum: 2026-04-27
Commit: siehe unten

In `NonogramViewModel.swift` neue Funktion `clearGrid()`: setzt alle Zellen auf `.empty`, löscht Undo/Redo-Stack, setzt `isWronglyComplete` zurück. In `NonogramBoardView.swift` neuer Trash-Button neben Redo, der ein `.confirmationDialog("Rätsel wirklich leeren?")` öffnet. Lokalisiert (DE/EN).