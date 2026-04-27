2026-04-27
#done 
[[Funktionen]]
[[Release 1.0]]
# Aufgabe
Wenn man eine Reihe fertig hat und auto x an hat dann wird ja alles mit roten x gefüllt. wenn man nun erkennt, dass man einen fehler gemacht hat und einen schwarzen punkt wieder löscht, dann ist die reihe ja nicht mehr komplett, dann sollen auch die roten auto x aus der reihe entfernt werden und erst wieder kommen wenn man alle schwarzen felder markiert hat.

# Implementierung

Datum: 2026-04-27
Commit: siehe unten

In `applyAutoX()` in `NonogramViewModel.swift` wird jetzt zusätzlich geprüft: für Zeilen/Spalten wo `isComplete == false` werden alle `.autoCrossed`-Zellen auf `.empty` zurückgesetzt. So verschwinden die Auto-X sobald eine Reihe nicht mehr vollständig ist.