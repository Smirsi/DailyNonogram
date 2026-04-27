2026-04-25
#done
[[Funktionen]]
[[Release 1.0]]
# Aufgabe
Wenn das komplette Rätsel ausgefüllt ist, aber nicht korrekt ist, soll ein Hinweis kommen, dass etwas falsch ist.
# Implementierung

Datum: 2026-04-27
Commit: siehe unten

In `NonogramViewModel.swift` wurde `@Published var isWronglyComplete: Bool = false` hinzugefügt. In `saveAndCheckCompletion()` wird es auf `true` gesetzt, wenn die Anzahl gefüllter Zellen exakt der Lösungsanzahl entspricht (aber `isComplete` false ist). 

In `NonogramBoardView.swift` wurde ein Banner-Overlay am unteren Rand eingeblendet (orange Warnsymbol + Text „Noch nicht korrekt – überprüfe deine Antworten."). Das Banner kann weggeklickt werden und erscheint erneut sobald neue Änderungen gemacht werden.
