2026-04-10
#done
# Aufgabe
Die seitliche Zahl scheint immer abgehakt zu werden, egal ob die Funktion in den Einstellungen aktiviert worden ist oder nicht.
# Implementierung

Datum: 2026-04-11

In `NonogramViewModel.updateAutoFeatures()` wurde `updateCheckedClues()` bedingungslos am Ende aufgerufen, was den `autoCheckmark`-Guard überschrieb. Fix: `updateCheckedClues()` nur wenn `autoCheckmark == true`, andernfalls `resetCheckedClues()` aufrufen, das alle Checkmarks auf `false` setzt.