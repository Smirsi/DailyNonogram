2026-04-26
#done
[[Bugs]]
[[Release 1.0]]
# Aufgabe
Deutsch/Englisch korrekte Sprache anzeigen für alle Wörter. Scheint als wäre es teilweise gemischt.

# Rückfragen
**Soll die App vollständig lokalisiert werden (DE + EN je nach Systemsprache)?**
Antwort: Ja, vollständig lokalisieren.

# Implementierung

Datum: 2026-04-27
Commit: siehe unten

Vollständige Lokalisierung implementiert (Runde 1 – alle UI-Texte). In Runde 2 (2026-04-27) nachgebessert: `Undo` → `Rückgängig`, `Redo` → `Wiederholen`, `Hint (%lld)` → `Tipp (%lld)` in `de.lproj/Localizable.strings`.
