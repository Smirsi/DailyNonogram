2026-04-18
#done 
[[Funktionen]]
[[Release 1.0]]
# Aufgabe
Der Streak-Counter wird mit einem ? Icon daneben dargestellt, dort sollte eher ein Symbol sein wo man direkt sieht, dass es der Streak Counter ist. Füge außerdem hinzu: Jeder Premium-Nutzer bekommt jede Woche 2 Streak-Freeze dazu, maximal kann er 10 haben. Ein normaler Nutzer bekomme jede Woche 1, kann aber nur max. 5 haben. Man bekommt sie nur wenn man 7 Tage die Rätsel gelöst hat ohne Freeze. Ersichtlich als der Terrakottafarbene Punkt, ein Freeze-Punkt wäre blau (wird automatisch verwendet, wenn sie leer sind ist die Streak zu Ende)
# Implementierung

Datum: 2026-04-18

1. `WeekProgressView.swift`: Streak-Icon von 🔥 Emoji auf SF Symbol `flame.fill` geändert; Freeze-Tage werden blau eingefärbt (via `StreakService.loadFrozenDatesPublic()`)
2. `StreakService.swift`: `availableFreezes` gibt jetzt auch Free-Nutzern Tokens (1/7 Tage, max 5); Premium 2/7 Tage, max 10. `applyFreeze` und `canApplyFreezeForYesterday` für alle Nutzer geöffnet.
3. `NonogramBoardView.swift`: Freeze wird automatisch angewendet (kein Alert mehr), sowohl für Free als auch Premium.
#notapproved [[Streak Counter Home Screen]]
#approved 