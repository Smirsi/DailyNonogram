2026-04-19
#open
# FUN1.12 – autoCheckmark & autoX: FreeNono-Logik übernehmen

Die bestehende autoCheckmark- und autoX-Implementierung soll gegen die FreeNono-Referenz-Logik geprüft und verbessert werden.

## FreeNono-Referenz

### checkCaptionsAgainstPattern (GameMode.java, Zeilen 298–385)
- Vergleicht die aktuell gefüllten Blöcke Zeile/Spalte für Zeile/Spalte mit den Clue-Zahlen
- Erkennt vollständig erfüllte Blöcke und feuert `crossOutCaption`-Events
- Block-für-Block-Vergleich: zählt aufeinanderfolgende gefüllte Zellen und matched sie gegen die Clue-Sequenz

### markCompleteRowsColumns (Settings: markCompleteRowsColumns)
- Wenn alle Blöcke einer Zeile/Spalte korrekt gesetzt sind, werden verbleibende leere Zellen automatisch mit X (MARKED) befüllt
- Entspricht dem autoX-Feature, aber ausgelöst durch korrekte Block-Completion statt durch Summen-Vergleich

## Aktuelle Swift-Implementierung (NonogramViewModel.swift, Zeilen 108–181)
- `updateCheckedClues()`: matchClues() Linkspass + Rechtspass
- `applyAutoX()`: summiert Clue-Zahlen und vergleicht mit fill-count

## Aufgabe

1. FreeNono-Logik studieren (`/Users/philip/PycharmProjects/FreeNono/FreeNono/src/org/freenono/model/game_modes/GameMode.java`)
2. Swift-Implementierung auf Randfälle prüfen (z.B. mehrere Blöcke gleicher Größe, leere Clues)
3. autoX verbessern: statt Summen-Vergleich echten Block-Completion-Check implementieren (analog zu FreeNono `markCompleteRowsColumns`)
4. autoCheckmark verbessern: Block-für-Block-Matching statt nur Sequenz-Matching

## Relevante Dateien

- `DailyNonogram/ViewModels/NonogramViewModel.swift` – updateCheckedClues(), applyAutoX()
- `DailyNonogram/Views/CluesView.swift` – Strikethrough-Rendering
- `/Users/philip/PycharmProjects/FreeNono/FreeNono/src/org/freenono/model/game_modes/GameMode.java` (Referenz, Zeilen 298–385)

## Komplexität / Dauer

Medium / ~1 h

# Implementierung
