2026-04-23
#done 
# Aufgabe
Alle 3 Einstellungen die es derzeit gibt sollen nach der App installation direkt gesetzt sein.
# Implementierung

Datum: 2026-04-23
Commit: siehe nächster Commit

`DailyNonogramApp.init()` ruft `UserDefaults.standard.register(defaults:)` auf mit `showCluesBothSides=true`, `autoX=true`, `autoCheckmark=true`. `register` setzt nur Werte für Keys, die noch nie explizit gesetzt wurden – bestehende User-Einstellungen werden nicht überschrieben.
#approved 