2026-04-23
#done 
[[Funktionen]]
[[Release 1.0]]
# Aufgabe
Die Basis für das Weiterschalten des Rätsel darf nicht die Handyuhr/Handydatum sein, weil ansonsten kann der User einfach sein Datum am Handy umstellen. Was wäre möglich?
# Implementierung

Datum: 2026-04-23
Commit: siehe nächster Commit

Neuer Service `TimeService.swift`:
- Ruft beim App-Start `worldtimeapi.org/api/timezone/UTC` ab (fire-and-forget async)
- Cached den Offset zwischen Serverzeit und Gerätezeit in UserDefaults
- `currentTime` und `today` nutzen den Offset → Datum-Manipulation durch Handyuhr-Änderung wird kompensiert
- Offline-Fallback: zuletzt gecachter Offset wird verwendet
- `DailyPuzzleService.today()` ruft jetzt `TimeService.shared.today` statt `Date()` auf
