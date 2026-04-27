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

Die `matchClues`-Funktion in `NonogramViewModel.swift` wurde komplett überarbeitet. Die neue Implementierung (`matchClues(_ clues: [Int], toCells cells: [Bool])`) unterstützt partielles Abstreichen:
- **Von links**: Korrekt platzierte und abgeschlossene Blöcke (sealedRight) werden sofort abgehakt
- **Von rechts**: Korrekt platzierte und abgeschlossene Blöcke (sealedLeft) werden sofort abgehakt
- **Kein Overlap**: Beide Richtungen teilen sich keine Blöcke
- **Full Match**: Bei vollständiger Übereinstimmung werden alle Zahlen abgehakt
