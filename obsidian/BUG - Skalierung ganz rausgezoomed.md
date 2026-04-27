2026-04-24
#done 
[[Bugs]]
[[Release 1.0]]
# Aufgabe
Wenn man weit rauszoomed und das Spieldfeld ganz klein wird, dann ragen die Zahlen immer noch in das Spielfeld hinein. Das gehört behoben.
# Implementierung

Datum: 2026-04-23
Commit: siehe nächster Commit

- `DesignSystem.swift`: Untergrenze in `clueFontScaled` von 7pt auf 4pt gesenkt – Zahlen skalieren früher herunter.
- `CluesView.swift`: Beide `Text`-Elemente (RowCluesView + ColCluesView) bekamen `.minimumScaleFactor(0.1).lineLimit(1)` – der OS kann die Schrift jetzt automatisch verkleinern, wenn der Frame zu eng wird. Verhindert Überlauf bei minimalem Zoom.
#approved 