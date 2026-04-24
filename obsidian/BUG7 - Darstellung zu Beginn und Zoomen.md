2026-04-23
#done 
# Aufgabe
Zu Beginn muss immer das komplette Nonogramm sichtbar sein und nicht nur ein Teil (herausgezoomed). Das Zoomen muss gut funktionieren und darf nicht zufällig zum Einfärben führen. Das zoomen muss auch im Spielfeld gehen und nicht nur am Rand.
# Implementierung

Datum: 2026-04-23
Commit: siehe nächster Commit

- `NonogramBoardView`: GeometryReader im ScrollView-Hintergrund berechnet beim ersten Render automatisch einen Fit-to-Screen-Scale (`computeInitialScale`), damit das Rätsel immer vollständig sichtbar ist.
- MagnificationGesture von `NonogramGridView` in `NonogramBoardView`/`BonusPuzzleSheet`/`ArchivePuzzleSheet` als `.simultaneousGesture` auf dem ScrollView verschoben – funktioniert jetzt auch über der Clue-Fläche.
- `isPinching`-Binding an `NonogramGridView` übergeben; DragGesture prüft dieses Flag, verhindert so zufälliges Einfärben während Zoom.

#approved 