2026-04-19
#done
[[Bugs]]
[[Release 1.0]]
# Aufgabe
Prüfe das korrekte Abstreichen der Zahlen am Rand und checke es gegen das von /Users/philip/PycharmProjects/FreeNono implementiertem

# Implementierung

Datum: 2026-04-19

**Bug gefunden und gefixt:** In `matchClues()` konnten Forward- und Backward-Pass dasselbe Sequenz-Element konsumieren.

**Beispiel:** clues=[2,2], sequences=[2] → wurde fälschlicherweise [true,true] (beide abgehakt), korrekt wäre [true,false].

**Fix:** `guard siR >= si else { break }` im Backward-Pass stellt sicher, dass keine Sequenz-Elemente doppelt verwendet werden. Jedes Element kann maximal einmal (vom Forward- ODER Backward-Pass) einem Clue zugeordnet werden.

Alle Testfälle geprüft:
- [2,2] + seq=[2,2] → [true,true] ✓
- [2,2] + seq=[2] → [true,false] ✓ (vorher: [true,true] – BUG)
- [3,1,3] + seq=[3,1] → [true,true,false] ✓
- [2,2] + seq=[4] → [false,false] ✓

#notapproved [[BUG - Zu frühes Abstreichen]]
