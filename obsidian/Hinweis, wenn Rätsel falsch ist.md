2026-04-25
#done
[[Funktionen]]
[[Release 1.0]]
# Aufgabe
Wenn das komplette Rätsel ausgefüllt ist, aber nicht korrekt ist, soll ein Hinweis kommen, dass etwas falsch ist.

# Implementierung

Datum: 2026-04-27
Commit: siehe unten

(Runde 1) `@Published var isWronglyComplete` + Banner-Overlay in `NonogramBoardView.swift` implementiert.

(Runde 2 – Fix) In `saveAndCheckCompletion()` wurde die Bedingung korrigiert: Banner erscheint jetzt wenn keine einzige `.empty`-Zelle mehr im Grid vorhanden ist (`!hasEmpty`) UND `isComplete == false`. Vorher wurde nur gezählt ob `filledCount == solutionCount`, was bei komplett ausgemalten Rätseln (inkl. nicht-Lösungs-Zellen) fehlschlug.
