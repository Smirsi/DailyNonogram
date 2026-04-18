2026-04-10
#done
# Aufgabe
Wenn man zoomed, dann bleiben die Zahlen nicht bei der jeweiligen Spalte bzw. Zeile stehen, sondern fliegen irgendwo am Bildschirm herum
# Implementierung

Datum: 2026-04-11
Commit: `5035aa6`

Zoom-State aus `NonogramGridView` in `NonogramBoardView` gehoben: `scale` (persistiert) und `liveScale` (live per Gesture-Frame) als `@State`. `NonogramGridView` erhält beides als `@Binding`. `CluesView` bekommt `effectiveCellSize = cellSize * liveScale` übergeben und skaliert damit mit. `MagnificationGesture` verwendet `.onChanged`/`.onEnded` statt `@GestureState`, um `liveScale` in Echtzeit zu teilen.
#approved 