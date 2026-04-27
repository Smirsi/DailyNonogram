2026-04-18
#done
[[Funktionen]]
[[Release 1.0]]
# Aufgabe
Teilen-Karte nach dem Lösen
**Analyse-Bewertung:** Virales Potenzial wie Wordle. "Ich habe heute das Nonogramm gelöst 🐱 | Streak: 14 Tage | Daily Nonogram".  
**Aktueller Stand:** Fehlt komplett.  

Kann man das einfach implementieren? Teilen für Insta, Whatsapp, etc?
# Implementierung

Datum: 2026-04-23
Commit: siehe nächster Commit

Neue Datei `ShareCardView.swift`:
- `ShareCardView`: SwiftUI-View mit App-Titel, Datum, Pixel-Grid (Lösung), Streak-Zahl, Fußzeile "daily-nonogram.app"
- `renderShareCardImage(nonogram:streak:)`: `@MainActor`-Funktion, rendert die Karte via `ImageRenderer` (iOS 16+) mit 3× Scale
- `CompletionOverlayView.swift`: Share-Button (Teilen-Icon links neben "Weiter") öffnet `UIActivityViewController` mit dem generierten Bild → teilbar auf Instagram, WhatsApp, etc.