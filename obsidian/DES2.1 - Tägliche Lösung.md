2026-04-10
#done
# Aufgabe
Ganz oben sollte eine Leiste sein, die von den letzten 7 Tagen anzeigt, ob man das Nonogramm gelöst hat.
# Implementierung

Datum: 2026-04-11
Commit: `5035aa6`

`DailyPuzzleService`: `markSolved()` und `wasSolved(for:)` via `UserDefaults` (`"solved_yyyy-MM-dd"`). `NonogramViewModel.endDrag/handleTap`: ruft `markSolved()` auf wenn `isComplete`. Neue `WeekProgressView`: 7 Kreise (letzten 6 Tage + heute) mit Wochentag-Kürzel in Deutsch; gelöste Tage = ausgefüllter Terrakotta-Kreis, heute = farbiger Ring. Zwischen Header und Grid eingebunden.
#approved 