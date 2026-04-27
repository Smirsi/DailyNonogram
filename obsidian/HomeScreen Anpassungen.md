2026-04-19
#done 
[[Design]]
[[Release 1.0]]
# Aufgabe
Der HomeScreen muss angepasst werden und einladender sein. Anstatt Einfach, Mittel, Schwer soll hier schon die Feldgröße und der Namen des Rätsels hingeschrieben werden. Es soll ein bisschen schöner wirken. Außerdem soll die Streak hinzugefügt werden und die Leiste mit den Punkten der letzten Tagen. Dann der Freeze Counter mit dem Max. Freeze. und dann noch Einstellungen. Statt Tägliches Nonogramm soll immer Daily Nonogram stehen und evtl. das App Icon daneben.
# Implementierung

Datum: 2026-04-19

- `DifficultySelectionView.swift` komplett überarbeitet:
  - Titel: "Daily Nonogram"
  - Settings-Button (⚙) oben rechts → öffnet SettingsView als Sheet
  - Streak-Card: 🔥 Flamme + "X Tage in Folge", darunter 7-Tage-Leiste (WeekProgressView), darunter Freeze-Counter
  - Bei tagesbasiertem Puzzle: Puzzle-Name + Gittergröße statt generischer Difficulty
  - Ad-Gate für Free-User im Fallback-Modus (3 Schwierigkeiten)
#approved 