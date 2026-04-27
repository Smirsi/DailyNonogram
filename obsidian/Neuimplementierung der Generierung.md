2026-04-18
#done
[[Funktionen]]
[[Release 1.0]]
# Aufgabe
Diese Aufgabe ist ein massiver Umbau des Generieren der Nonogramme. Ich möchte dass diese Aufgabe wirklich detailliert geplant und durchgeführt wird.
Schritt 1: Finde eine Seite/Datenbank mit Pixel-Arts, die für die Nonogramme verwendet werden können.
Schritt 2: Binarisiere die Daten für ein Schwarz/Weiß-Nonogramm, so dass das Bild später noch erkennbar ist.
Schritt 3: Berechne die Clues, suche dafür einen geeigneten Algorithmus
Schritt 4: Bewerte, ob das Nonogramm eindeutig lösbar ist. Schritt 5: Wenn ja, bewerte die Schwierigkeit und nimm es als Einfaches, Mittleres oder Schwieriges Rätsel auf. Wenn nein verwirf es.

Nun ist folgendes wichtig:
1. Es gibt in Zukunft nicht nur schwarz/weiße Nonogramme sondern auch farbige. Beachte auch dies. Die farbigen sollen immer zwischen 2-5 Farben haben. Beachte auf jeden Fall die Regeln für farbige Nonogramme.
2. Füge daher zu den 3 Schwarz/Weiß auch 3 farbige hinzu.
3. Die Nonogramme sollen nicht immer alle die gleiche Größe haben, es können gerne auch unterschiedliche Maße vorkommen.
4. Es darf keine Zeilen oder Spalten geben die 0 Felder enthalten.

Wenn dies alles klar ist und implementiert ist, lösche alle bisherigen Nonogramme und erstelle mindestens 10 Stück für die 6 oben genannten Kategorien.

Wie erwähnt Stelle hier ausreichend Fragen bevor du alles umsetzt.

# Implementierung

Datum: 2026-04-18

Vollständige Neuimplementierung der Puzzle-Generierung:

- **`scripts/generate_puzzles.py`**: Python-Skript mit eingebetteten Pixel-Art-Mustern (CC0, inspiriert durch OpenGameArt.org). Enthält B&W-Solver (Line-Solving + Backtracking für Eindeutigkeits-Check), Augmentierung (Flip/Rotation), und Ausgabe als XML.
- **6 Kategorien** mit je 10+ Puzzles: `easy` (14), `medium` (12), `hard` (10), `color-easy` (12), `color-medium` (12), `color-hard` (11).
- **Farb-Format** (`.cnonogram` XML): `<palette>`-Element mit Hex-Farben, `<line>`-Zellen als Integer (0=leer, 1-N=Farbindex).
- **`DifficultyLevel.swift`**: 3 neue Farb-Kategorien (`colorEasy`, `colorMedium`, `colorHard`).
- **`Nonogram.swift`**: `colorSolution`, `colorPalette`, `colorClueRows`, `colorClueCols` ergänzt; `Color(hex:)`-Extension hinzugefügt.
- **`FreeNonoPuzzleLoader.swift`**: Neuer `ColorNonogramLoader` + `ColorNonogramXMLParser` für `.cnonogram`.
- **`PuzzleLibrary.swift`**: Neue Properties `colorEasy`, `colorMedium`, `colorHard`.
- Alle alten ~158 B&W-Puzzles gelöscht und ersetzt.
- Build: ✅ erfolgreich.
#approved 