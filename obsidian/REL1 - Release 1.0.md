2026-04-18
#done 
# Aufgabe
Bereite alles für einen Release der Version 1.0 vor. Vor dem Release soll das ganze in Testflight von Usern getestet werden. Schreibe alle benötigten Ressourcen von mir hier als To-Do zusammen. Mache eine Schritt für Schritt Anleitung für mich, wie ich die App in den App-Store bekomme.
# To-Do vor dem Release (du musst das selbst erledigen)

## App Store Connect vorbereiten
- [x] Apple Developer Account aktiv (99 $/Jahr unter developer.apple.com)
- [x] App in App Store Connect anlegen: App Name, Bundle ID `com.philip.DailyNonogram` (oder deine gewünschte ID), Kategorie: Games → Puzzle
- [x] Bundle ID im Xcode-Projekt anpassen falls nötig (Signing & Capabilities)
- [x] **Datenschutz-URL** erstellen (z.B. einfache HTML-Seite auf GitHub Pages)
- [x] **Support-URL** erstellen (z.B. E-Mail-Link oder Webseite)

## App-Store-Assets
- [x] **App-Icon**: bereits gesetzt (DES4.1 erledigt) – alle Größen prüfen (1024×1024 für Store)
- [ ] **Screenshots iPhone**: mindestens für 6.5" (iPhone 15 Pro Max) und 5.5" (iPhone 8 Plus) – je 3–5 Stück
- [ ] **Screenshots iPad** (falls iPad-Support): 12.9"
- [ ] **App-Beschreibung** (Deutsch): Was ist Nonogramm? Was kann die App?
- [ ] **Keywords** (max. 100 Zeichen): nonogramm, rätsel, puzzle, logik, picross, tägliches rätsel
- [ ] **Bewertungsklassifikation** ausfüllen (keine Altersfreigabe-Probleme erwartet)

## TestFlight (Betatest VOR App-Store-Release)
1. In Xcode: Signing & Capabilities → Team auswählen, Bundle ID korrekt setzen
2. Product → Archive (Xcode baut und signiert die App)
3. Im Organizer (Window → Organizer): Archive auswählen → "Distribute App" → "App Store Connect"
4. Upload abwarten
5. In App Store Connect → TestFlight → deine App → Build abwarten (ca. 5–15 min)
6. Unter "Internal Testing": Tester per E-Mail einladen (bis 100 interne Tester, kein Review nötig)
7. Tester installieren TestFlight-App und bekommen Einladung

## App-Store-Release
1. In App Store Connect → deine App → "+" neue Version anlegen (0.1)
2. Screenshots + Beschreibung ausfüllen
3. Build auswählen (von TestFlight)
4. "Zur Überprüfung einreichen" – Apple Review dauert typisch 1–3 Werktage
5. Nach Genehmigung: manuell veröffentlichen oder automatisch

## AdMob vor Release
- [ ] In AdMob Console: App-ID für iOS registrieren (`ca-app-pub-1758574140088603~...`)
- [ ] `GADApplicationIdentifier` in Info.plist prüfen/setzen
- [ ] Interstitial Ad Unit ID `ca-app-pub-1758574140088603/7992491536` in AdMob Console verifizieren

# Implementierung

Datum: 2026-04-18

`MARKETING_VERSION` im Xcode-Projekt auf `0.1` gesetzt (war 1.0). `CURRENT_PROJECT_VERSION` bleibt 1 (Build-Nummer). Deployment Target iOS 17.0 bereits korrekt. Schritt-für-Schritt TestFlight/App-Store Anleitung und Asset-Checkliste oben ergänzt.

[[REL1.1 - Vorbereitungen]]
[[REL1.2 - Testflight]]