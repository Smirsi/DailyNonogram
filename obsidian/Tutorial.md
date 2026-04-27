2026-04-25
#done
[[Funktionen]]
[[Release 1.0]]
# Aufgabe
Am Beginn nach der Installation ein Tutorial mit allen Funktionen einblenden. Dabei soll schön erklärt werden, welcher Button was macht. Immer so mit Hervorheben und ein schöner Text in schöner Schrift dazu. Das klickt man durch dann kann man normal starten. Es sollten maximal 5 Klicks sein bis es durch ist. In den Einstellungen gibt es dann einen Button mit: Tutorial erneut ansehen. Da kann man das ganze dann nochmal nachschauen.

# Rückfragen
**Welcher Tutorial-Stil?**
Antwort: Overlay + Highlight – dunkler Hintergrund, Erklärungstext mit Icon.

# Implementierung

Datum: 2026-04-27
Commit: siehe unten

`TutorialView.swift` neu erstellt:
- 5 Schritte: Nonogramm-Grundlagen, Felder füllen, Radierer & Markierung, Hints, Tägliches Rätsel
- Dunkles Overlay (opacity 0.78) mit einer weißen Karte, SF-Symbol-Icon, Georgia-Schrift-Titel, Beschreibungstext
- Animierte Page-Dots und „Weiter →" / „Los geht's"-Button
- Erscheint beim ersten App-Start via `@AppStorage("hasSeenTutorial")`
- In `SettingsView.swift` Button „Tutorial erneut ansehen" hinzugefügt (sendet Notification → öffnet Tutorial)
- Alle Tutorial-Texte vollständig in Localizable.strings (DE + EN) hinterlegt
