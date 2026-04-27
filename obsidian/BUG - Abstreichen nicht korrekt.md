2026-04-26
#done
[[Bugs]]
[[Release 1.0]]
# Aufgabe
Das Abstreichen funktioniert nicht korrekt, checke alle Funktionen hier drinnen: /Users/philip/PycharmProjects/nonogram-db und teile mir auch mit, was alles enthalten ist. Dann frage nach, was davon implementiert werden soll.

# Rückfragen
**Was ist im nonogram-db Projekt?**
Das Projekt enthält eine Rätseldatenbank im .non-Format sowie Go-Tools (generate.go, findpuzzle.go, freenono2non.go etc.) – kein Python, keine Abstreichen-Logik.

**Was ist das konkrete Problem mit dem Abstreichen?**
Antwort: Auto-Strikethrough falsch – die automatische Durchstreichung der Zahlen am Rand kommt zu spät oder gar nicht, wenn Zahlen von links/rechts bereits korrekt platziert sind.

# Implementierung

Datum: 2026-04-27
Commit: siehe unten

(Runde 2 – Fix) `matchClues` in `NonogramViewModel.swift` korrigiert: Beide Richtungen (links→rechts und rechts→links) prüfen jetzt `sealedLeft AND sealedRight`. Ein Block wird nur abgehakt wenn er definitiv nicht mehr wachsen kann (beidseitig versiegelt). Vorher wurde nur eine Seite geprüft, was zu verfrühtem Abstreichen führte (z.B. einzelne Zelle die zur "5" gehört wurde als "1" gestrichen).

Zusätzlich: `applyErrors()` ruft jetzt `updateCheckedClues()` auf, damit nach dem Ad-Fix die Zahlen korrekt zurückgesetzt werden.
