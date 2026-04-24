2026-04-23
#done 
# Aufgabe
Das Abstreichen der Zahlen am Rand ist nicht korrekt. wenn zB 1 3 ist und unten ein 1 ist dann wird 1 schon gestrichen obwohl es logischerweise gar nicht sein kann, weil darunter ja noch ein 3 sein muss. Daher hier immer die Logik prüfen, und nur dann streichen wenn es eindeutig ist und nicht nur eventuell sein kann.
# Implementierung

Datum: 2026-04-23
Commit: siehe nächster Commit

`matchClues` in `NonogramViewModel.swift` überarbeitet: Der linke Pass prüft nun vor jedem Match, ob genug verbleibende Sequences für die noch ausstehenden Clues vorhanden sind (`remainingSeqs >= remainingClues`). Damit wird z.B. bei Clues=[1,3] und nur 1 gefüllter Zelle die "1" nicht mehr voreilig abgehakt.
#notapproved [[BUG6.1 - Zu frühes Abstreichen]]