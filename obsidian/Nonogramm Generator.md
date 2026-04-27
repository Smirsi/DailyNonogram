2026-04-10
#done
[[Funktionen]]
[[Release 1.0]]
# Aufgabe
Es muss jeden Tag ein neues Nonogramm gelöst werden können. Entwickle daher eine Möglichkeit, dieses zu generieren. Es sollen real treue schöne Bilder sein, die gelöst auch tatsächlich an etwas erinnern.
# Rückfragen
**Wie wird die Datenbank erstellt?**
→ Claude generiert 10 erkennbare Pixel-Art-Muster direkt als 2D-Boolean-Arrays. Vorerst reichen 10 Rätsel für den Start.
# Implementierung
`PuzzleLibrary.swift` enthält 10 handgefertigte 15×15-Pixel-Art-Muster:
Herz, Weihnachtsbaum, Haus, Fisch, Katze, Rakete, Pilz, Sonne, Vogel, Diamant.
Die Clues werden automatisch per String-basierter Grid-Definition und `Nonogram.computeClues()` berechnet. Die Bibliothek kann jederzeit um weitere Motive erweitert werden.
#notapproved [[Komplexere Nonogramme]]
#approved 