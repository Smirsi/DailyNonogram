2026-04-23
#done 
# Aufgabe
Die Zahlen am Rand skalieren nicht korrekt wenn man zoomed. Die Zahlen wandern teilweise in das Spielfeld hinein. Diese müssen immer schön am Rand bleiben.
# Implementierung

Datum: 2026-04-23
Commit: siehe nächster Commit

- `DS.clueFontScaled(cellSize:)` hinzugefügt: skaliert die Schriftgröße proportional zur Zellgröße (Basis 36pt → 11pt, Bereich 7–22pt).
- `CluesView.swift` (Row + Col): verwendet nun `clueFontScaled` statt der fixen 11pt-Schrift – Zahlen bleiben proportional zu den Zellen bei jedem Zoom-Level.