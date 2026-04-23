2026-04-19
#done
# Aufgabe
Hilf mir bei den Vorbereitungen für den Release:
- Überprüfe ob ich alles im XCode korrekt eingestellt habe
- Was sind Datenschutz-URL und Support.URL, wie soll ich diese erstellen?
- Erstelle Screenshots, App Beschreibung, Keywords, Untertitel, etc.
- Sage mir wie das mit dem Abo und In-App-Käufen anlegen ist.

# Implementierung

Datum: 2026-04-19

---

## 1. Xcode-Einstellungen prüfen

In Xcode → Target → General:

| Einstellung | Sollwert |
|---|---|
| Bundle Identifier | `com.philip.dailynonogram` (muss mit App Store Connect übereinstimmen) |
| Version | `1.0` (Marketing-Version, sichtbar im Store) |
| Build | `1` (jeder Upload braucht eine höhere Build-Nummer) |
| Deployment Target | iOS 17.0 |
| Supported Destinations | iPhone + iPad (Mac Catalyst optional) |

In Xcode → Target → Signing & Capabilities:
- **In-App Purchase** Capability hinzufügen (falls noch nicht)
- **Push Notifications** nicht nötig für erste Version
- Team + Provisioning Profile korrekt gesetzt

---

## 2. In-App-Käufe in App Store Connect anlegen

App Store Connect → App → In-App Purchases → „+" → jeweils anlegen:

### Monatliches Abo
- Typ: **Auto-Renewable Subscription**
- Produkt-ID: `com.philip.dailynonogram.premium.monthly`
- Referenzname: Premium Monthly
- Preis: z.B. 0,99 €/Monat
- Lokalisierung DE: „Premium – Monatlich" / EN: „Premium – Monthly"
- Subscription Group: „Premium" (neu anlegen, falls erste)
- Werbefrei, Mehr Rätsel, Streak-Freeze
- Ad-free, more puzzles, streak-freeze

### Jährliches Abo
- Typ: **Auto-Renewable Subscription**
- Produkt-ID: `com.philip.dailynonogram.premium.yearly`
- Referenzname: Premium Yearly
- Preis: z.B. 5,99 €/Jahr
- Lokalisierung DE: „Premium – Jährlich" / EN: „Premium – Yearly"
- Subscription Group: dieselbe „Premium"-Gruppe

### Lifetime-Kauf
- Typ: **Non-Consumable**
- Produkt-ID: `com.philip.dailynonogram.premium.lifetime`
- Referenzname: Premium Lifetime
- Preis: z.B. 9,99 € einmalig
- Lokalisierung DE: „Premium – Einmalig" / EN: „Premium – Lifetime"

**Wichtig:** Die Produkt-IDs müssen exakt mit dem `StoreKitManager.swift` übereinstimmen.

---

## 3. Datenschutz-URL & Support-URL

Einfachste Lösung: **GitHub Pages**

### Schritte:
1. Neues öffentliches GitHub-Repo anlegen, z.B. `dailynonogram-legal`
2. Datei `index.html` (Datenschutz) und `support.html` anlegen
3. In Repo-Settings → Pages → Branch `main` aktivieren
4. URLs werden dann z.B.: `https://smirsi.github.io/dailynonogram-legal/` (Datenschutz) und `https://smirsi.github.io/dailynonogram-legal/support` (Support)

### Datenschutzerklärung (DSGVO-konform, Minimalversion):

```html
<!DOCTYPE html>
<html lang="de">
<head><meta charset="UTF-8"><title>Datenschutzerklärung – Daily Nonogram</title></head>
<body style="font-family:sans-serif;max-width:700px;margin:40px auto;padding:0 20px">
<h1>Datenschutzerklärung</h1>
<p>Verantwortlicher: Philip Smrzka, p.smrzka@gmail.com</p>
<h2>Datenerhebung</h2>
<p>Die App speichert Spielfortschritt und Einstellungen ausschließlich lokal auf dem Gerät des Nutzers (UserDefaults). Es werden keine personenbezogenen Daten an Server übertragen.</p>
<h2>Werbung (Google AdMob)</h2>
<p>Die kostenlose Version der App verwendet Google AdMob zur Anzeige von Werbung. AdMob kann dabei gerätebezogene Kennungen und Nutzungsdaten verarbeiten. Weitere Informationen: <a href="https://policies.google.com/privacy">Google Datenschutzrichtlinie</a>.</p>
<h2>In-App-Käufe</h2>
<p>Käufe werden über Apple's App Store und StoreKit abgewickelt. Die App selbst speichert keine Zahlungsdaten.</p>
<h2>Kontakt</h2>
<p>Bei Fragen zum Datenschutz: p.smrzka@gmail.com</p>
</body>
</html>
```

### Support-Seite (Minimalversion):

```html
<!DOCTYPE html>
<html lang="de">
<head><meta charset="UTF-8"><title>Support – Daily Nonogram</title></head>
<body style="font-family:sans-serif;max-width:700px;margin:40px auto;padding:0 20px">
<h1>Support – Daily Nonogram</h1>
<p>Bei Fragen oder Problemen wende dich an: <a href="mailto:p.smrzka@gmail.com">p.smrzka@gmail.com</a></p>
</body>
</html>
```

---

## 4. App Store Metadaten

### Untertitel (max. 30 Zeichen)
- **DE:** Rätsel für jeden Tag
- **EN:** Daily Puzzle Challenge

### Beschreibung DE
```
Täglich ein neues Nonogramm – in drei Schwierigkeitsgraden.

Löse jeden Tag ein frisches Nonogramm-Rätsel und baue deinen Streak aus. Daily Nonogram bietet dir täglich drei neue Rätsel: Leicht, Mittel und Schwer.

FEATURES
• Täglich 3 neue Rätsel (Leicht / Mittel / Schwer)
• Streak-System mit Freeze-Token
• Undo & Redo
• Auto-Kreuz und Auto-Haken
• Wochenübersicht mit Fortschritt
• Archiv-Zugriff auf vergangene Rätsel (Premium)

PREMIUM
• Kein Werbebanner
• Archiv: alle vergangenen Rätsel
• Fehler-Aufdecken per Video-Ad
• Auto-Lösen (kostet Freeze-Token)
• Streak-Freeze schützt deinen Streak

Nonogramme (auch Picross oder Hanjie genannt) sind Logikrätsel: Zahlen an den Rändern geben an, welche Felder zu füllen sind – am Ende entsteht ein Pixelbild.
```

### Beschreibung EN
```
A new nonogram every day – in three difficulty levels.

Solve a fresh nonogram puzzle every day and keep your streak alive. Daily Nonogram brings you three new puzzles daily: Easy, Medium, and Hard.

FEATURES
• 3 new puzzles daily (Easy / Medium / Hard)
• Streak system with freeze tokens
• Undo & Redo
• Auto-cross and auto-checkmark
• Weekly progress overview
• Archive access to past puzzles (Premium)

PREMIUM
• No banner ads
• Archive: all past puzzles
• Error reveal via rewarded ad
• Auto-solve (costs a freeze token)
• Streak freeze protects your streak

Nonograms (also known as Picross or Hanjie) are logic puzzles: numbers along the edges tell you which cells to fill in – revealing a pixel picture when complete.
```

### Keywords DE (max. 100 Zeichen)
```
nonogramm,picross,hanjie,rätsel,logik,puzzle,täglich,streak,pixel,lösen
```

### Keywords EN (max. 100 Zeichen)
```
nonogram,picross,hanjie,puzzle,logic,daily,streak,pixel,brain,challenge
```

### Promotional Text DE (max. 170 Zeichen, jederzeit änderbar)
```
Täglich 3 neue Nonogramm-Rätsel – bau deinen Streak aus und enthülle täglich ein neues Pixelbild!
```

### Promotional Text EN
```
3 new nonogram puzzles every day – build your streak and reveal a new pixel picture daily!
```

---

## 5. Screenshots

Benötigte Größen (Pflicht):
- **iPhone 6.9"** (iPhone 16 Pro Max Simulator): 1320 × 2868 px
- **iPhone 6.7"** (iPhone 15 Plus Simulator): 1290 × 2796 px

Optional (empfohlen):
- **iPad 13"** (iPad Pro Simulator): 2064 × 2752 px

### Empfohlene Screens (5–10 Stück):
1. HomeScreen mit Schwierigkeitsauswahl + Wochenübersicht
2. Puzzle in Bearbeitung (mittelgroßes Nonogramm)
3. Fertiggestelltes Puzzle mit Completion-Overlay (Streak-Anzeige)
4. Premium-Features-Übersicht (Paywall)
5. Archiv-Ansicht (nur mit Premium-Account)

### Tools für schöne Screenshots:
- **Simulator** direkt: Cmd+S speichert Screenshot
- **AppShots** (kostenlos, Mac App Store): Gerät-Framing + Hintergrundfarbe
- **Rottenwood** oder **Previewed.app**: Professionelles Framing

---

## 6. App-Kategorie & Rating

In App Store Connect:
- **Primary Category:** Games → Puzzle
- **Secondary Category:** (optional) Entertainment
- **Age Rating:** 4+ (keine Gewalt, kein User-Generated Content)
  - Werbung: Ja (AdMob) → trotzdem 4+ möglich

---

## 7. Checkliste vor dem ersten Upload

- [x] Bundle ID stimmt mit App Store Connect überein
- [x] Version 1.0, Build 1 gesetzt
- [x] In-App Purchase Capability in Xcode aktiv
- [ ] Alle 3 IAP-Produkte in App Store Connect angelegt und im Status „Ready to Submit"
- [ ] Datenschutz-URL erreichbar (GitHub Pages live)
- [ ] Support-URL erreichbar
- [ ] Screenshots für 6.9" und 6.7" hochgeladen
- [ ] App-Beschreibung DE + EN eingetragen
- [ ] Keywords DE + EN eingetragen
- [ ] Untertitel DE + EN eingetragen
- [ ] App-Kategorie gesetzt
- [ ] Age Rating ausgefüllt
- [ ] Archiv (TestFlight) erfolgreich gebaut
