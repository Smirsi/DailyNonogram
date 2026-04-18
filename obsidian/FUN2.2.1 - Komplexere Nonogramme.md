2026-04-10
#done
# Aufgabe
Die Nonogramme müssen komplexer sein. Ist es möglich diese von https://github.com/prometheus42/FreeNono einzubinden?
# Implementierung

Datum: 2026-04-11
Commit: `5035aa6`

25 FreeNono `.nonogram`-Dateien (10 × 15×15, 15 × 10×10) aus dem FreeNono GitHub heruntergeladen und unter `DailyNonogram/Resources/Puzzles/` gebündelt. `FreeNonoPuzzleLoader.swift` (neu): parst FreeNono XML-Format (`x`=gefüllt, `_`=leer) via `XMLParser`, berechnet Clues und erstellt vollständige `Nonogram`-Objekte mit Solution. `PuzzleLibrary.all` kombiniert jetzt die 10 handgefertigten mit den 25 FreeNono-Rätseln (35 Puzzles gesamt).