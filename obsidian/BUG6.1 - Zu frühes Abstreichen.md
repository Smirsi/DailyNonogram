2026-04-24
#done 
# Aufgabe
Es wird bereits abgestrichen, obwohl nicht klar ist, dass das Kästchen zu der Zahl gehört. Schaue hier nochmal nach, ob es dafür eine Funktion gibt, wenn ja verwende diese: /Users/philip/PycharmProjects/FreeNono
# Implementierung

Datum: 2026-04-23
Commit: siehe nächster Commit

`matchClues` in `NonogramViewModel.swift` vollständig vereinfacht: neuer Algorithmus prüft zunächst, ob `sequences.count == clues.count`. Nur wenn alle Blöcke vorhanden sind, wird ein positionsweiser Vergleich (`zip`) durchgeführt. Damit wird garantiert, dass keine Zahl abgehakt wird, solange noch Blöcke fehlen.