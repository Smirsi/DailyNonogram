2026-04-19
#done
# FUN1.12 – autoCheckmark & autoX: FreeNono-Logik übernehmen

Die bestehende autoCheckmark- und autoX-Implementierung soll gegen die FreeNono-Referenz-Logik geprüft und verbessert werden.

## FreeNono-Referenz

### checkCaptionsAgainstPattern (GameMode.java, Zeilen 298–385)
- Block-für-Block-Vergleich

### markCompleteRowsColumns
- Wenn alle Blöcke korrekt gesetzt → verbleibende Zellen automatisch X

# Implementierung

Datum: 2026-04-19

**autoX verbessert:** Statt `filledCount == sum` (fehleranfällig bei falscher Blockanordnung) wird jetzt `filledSequences(in:) == clues` geprüft. Nur wenn die exakte Blockfolge mit den Clues übereinstimmt, werden verbleibende leere Zellen mit `.autoCrossed` befüllt. Edge case `[0]`-Clue (leere Zeile) wird korrekt behandelt.

**autoCheckmark:** `matchClues` nutzt jetzt `.hinted`-Zellen ebenfalls als "gefüllt". Links/Rechts-Pass-Logik bleibt (entspricht FreeNono's Ansatz, passt für die App).

**Neue `lineMatchesClues` Hilfsmethode** für konsistente Prüfung in autoX-Logik.
