2026-04-10
#done 
# Aufgabe
Beim automatischen X wird automatisch neben den markierten Feldern ein X eingefügt, wenn es die geforderte Anzahl an Feldern erfüllt.
Beim automatischen Abhaken wird die Zahl am Rande des Nonogramms abgehakt, wenn es eindeutig ist, welcher Block bereits ausgefüllt wurde.
# Implementierung
Im `NonogramViewModel`:
- `applyAutoX()`: Wenn die Summe der Clue-Zahlen einer Zeile/Spalte exakt der Anzahl gefüllter Zellen entspricht, werden alle leeren Zellen automatisch auf `.crossed` gesetzt.
- `updateCheckedClues()`: Vergleicht die tatsächlichen Füllsequenzen mit den Clues. Übereinstimmende Clue-Zahlen werden in `checkedRowClues`/`checkedColClues` markiert.
- `CluesView` zeigt abgehakte Zahlen durchgestrichen und grau an.
- Beide Features werden nach jeder Zustands­änderung aufgerufen; ob sie aktiv sind, steuern die Einstellungen `autoX` und `autoCheckmark`.
#approved 