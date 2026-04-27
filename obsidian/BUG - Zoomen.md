2026-04-27
#done 
[[Bugs]]
[[Release 1.0]]
# Aufgabe
Wenn man zoomed dann soll währenddessen nichts ausgemalt werden. Derzeit passiert es öfters, dass man während des Zoomens Felder ausmalt, dass soll nicht passieren.  

# Implementierung

Datum: 2026-04-27
Commit: siehe unten

In `NonogramGridView.swift` wurde ein `.simultaneousGesture(MagnificationGesture(minimumScaleDelta: 0))` direkt auf dem Canvas hinzugefügt. Damit wird `isPinching = true` sofort gesetzt, noch bevor die äußere MagnificationGesture in `NonogramBoardView` feuert. Race Condition behoben.