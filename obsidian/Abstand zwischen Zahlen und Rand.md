2026-04-25
#done
[[Design]]
[[Release 1.0]]
# Aufgabe
Ein wenig mehr Abstand zwischen den Zahlen und dem Rand
# Implementierung

Datum: 2026-04-27
Commit: siehe unten

In `CluesView.swift` wurde `.padding(.trailing, 6)` zur `RowCluesView` und `.padding(.bottom, 6)` zur `ColCluesView` hinzugefügt. Beidseitige Anzeige berücksichtigt (leading/top statt trailing/bottom wenn alignRight/alignBottom false).
#approved 