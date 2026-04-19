#structure
# Marktanalyse April 2026 — Offene Todos

Basierend auf der Marktanalyse vom April 2026 (Store-Potenzial: **7.1/10**) wurden folgende Lücken identifiziert. Der aktuelle Stand der App wird mit den Empfehlungen verglichen.

---

## ✅ Bereits umgesetzt (Stand April 2026)

| Feature | Task |
|---|---|
| Nonogramm lösen (Stift, Radierer, Mehrfachauswahl) | FUN1.1 |
| Zoomen & Verschieben | FUN1.3 |
| Automatisches X und Abhaken | FUN1.4, FUN6.2, FUN6.3 |
| Tägliches Nonogramm (1 pro Tag) | FUN2.1 |
| FreeNono-Puzzles eingebunden | FUN2.2.1 |
| Schwierigkeitsgrade (Easy/Medium/Hard) | FUN5.1 |
| Dark Mode (Einstellungen) | DES5.1 |
| 7-Tage Fortschrittsbalken | DES2.1 |
| Einstellungsmenü | DES3.1 |
| Werbung (Banner + Interstitial) | MON1.1 |
| Premium-Abo (monatlich/jährlich) | MON2.1, MON2.2 |
| Premium: 3 Schwierigkeitsgrade + Wochenrückblick | MON3.1 |
| Premium-Hinweis Pop-Up | MON2.3 |

---

## 🔴 Must-Fix vor Launch (kritisch laut Analyse)

### 1. Streak-System fehlt komplett
**Analyse-Bewertung:** Wichtigster psychologischer Retention-Anker ("Streak-Anxiety" wie bei Wordle).  
**Aktueller Stand:** FUN4 (Aktivitätstracker) ist nur eine leere Struktur — keine Implementierung.  
**Was fehlt:**
- Streak-Counter prominent in der UI (schlicht: eine Zahl + Symbol, kein Konfetti)
- Streak-Freeze als Premium-Feature (1 verpasster Tag zählt nicht)
- Streak wird angezeigt nach dem Lösen und auf dem Homescreen

**Neue Tasks:** [[FUN4.1 - Streak Counter]]

---

### 2. Banner-Werbung im Spielfeld entfernen
**Analyse-Bewertung:** Banner widerspricht direkt dem USP "schlichtes, ruhiges Design". eCPM in DACH: Banner $0.30–0.80, Interstitial $3–8 — Unterschied bei 350 DAU = **50–65 €/Monat**.  
**Aktueller Stand:** MON1.1 implementiert Banner + Interstitials.  
**Was fehlt:**
- Banner aus dem aktiven Spielfeld entfernen
- Interstitial nur nach dem Lösen eines Rätsels (vor der Auflösung)
- Rewarded Video: "Schau Werbung → spiel ein Bonus-Rätsel" nach gelöstem Tages-Puzzle

**Neue Tasks:** [[MON1.2 - Werbeplatzierung optimieren]]

---

### 3. Puzzle-Archiv für Premium (FUN3 leer)
**Analyse-Bewertung:** "Puzzle-Archiv" ist ein stärkeres Subscription-Argument als "6 Puzzles". Vergangene Rätsel für Premium spielbar — für Free-Nutzer verfallen sie nach 24h.  
**Aktueller Stand:** FUN3 (Zugriff auf alte Nonogramme) ist eine leere Struktur.  
**Was fehlt:**
- Archiv-Screen mit allen vergangenen Tagesrätseln
- Für Premium: alle spielbar; für Free: gesperrt (Paywall-Hinweis)
- Premium-Kommunikation: "Dein persönliches Puzzle-Archiv" statt nur "6 Puzzles/Tag"

**Neue Tasks:** [[FUN3.1 - Puzzle-Archiv Screen]]

---

### 4. Puzzle-Qualität sichern
**Analyse-Bewertung:** Nonogramme müssen eindeutig lösbar sein (kein Raten) und schöne Motive ergeben. Schlechte Puzzles = sofortige Enttäuschung.  
**Aktueller Stand:** FreeNono-Puzzles eingebunden — Qualität unklar, kein "Aha-Moment" nach dem Lösen.  
**Was fehlt:**
- Nach dem Lösen: Motiv-Name anzeigen (z.B. "🐱 Katze")
- Puzzle-Kuratierung sicherstellen (eindeutige Lösbarkeit prüfen)

**Neue Tasks:** [[FUN2.3 - Motiv-Anzeige nach dem Lösen]]

---

## 🟡 Wichtige Features (Nice-to-have, hoher Impact)

### 5. Teilen-Karte nach dem Lösen
**Analyse-Bewertung:** Virales Potenzial wie Wordle. "Ich habe heute das Nonogramm gelöst 🐱 | Streak: 14 Tage | Daily Nonogram".  
**Aktueller Stand:** Fehlt komplett.  
**Neue Tasks:** [[FUN7 - Share Card nach dem Lösen]]

---

### 6. Push-Benachrichtigungen
**Analyse-Bewertung:** Täglich neues Rätsel = natürlicher Anlass für tägliche Notification ("Dein Nonogramm für heute ist bereit 🎯").  
**Aktueller Stand:** PUSH0 ist leere Struktur.  
**Neue Tasks:** [[PUSH1 - Tägliche Push-Benachrichtigung]]

---

### 7. Saisonale Themen-Wochen
**Analyse-Bewertung:** Niedrig-Aufwand, gute Wirkung. Ostern → Hasen, Weihnachten → Wintermotive. Erzeugt Push-Notification-Anlässe und kostenlose PR.  
**Aktueller Stand:** Fehlt.  
**Neue Tasks:** [[FUN2.4 - Saisonale Themen-Pakete]]

---

### 8. Persönliche Statistiken
**Analyse-Bewertung:** Retention-Feature. Durchschnittliche Lösungszeit, schnellste Runde, "Du hast diese Woche X Minuten entspannt."  
**Aktueller Stand:** Fehlt.  
**Neue Tasks:** [[FUN8 - Persönliche Statistiken]]

---

## 🟠 App Store Optimierung (vor Launch)

### 9. ASO — App Store Listing
**Analyse-Bewertung:** Vor Launch umsetzen. Keywords: "nonogram", "picross", "logic puzzle daily", "japanese crossword".  
**Was fehlt:**
- App-Name: "Daily Nonogram — Logic Puzzles"
- Deutschen Subtitle: "Täglich ein Logikrätsel"
- Screenshots: schwarze Typografie auf cremefarbenem Hintergrund, Ruhe und Eleganz sichtbar
- Erster Screenshot-Text: *"Kein Lärm. Kein Druck. Nur das Rätsel."*

**Neue Tasks:** [[ASO1 - App Store Screenshots und Texte]]

---

### 10. Dark Mode als Premium-Feature überdenken
**Analyse-Bewertung:** Aktuell Dark Mode für alle Nutzer. Empfehlung: Dark Mode exklusiv für Premium, da Abend-Nutzer echten Anreiz brauchen.  
**Aktueller Stand:** DES5.1 ist done und approved — Dark Mode ist für alle verfügbar.  
**Entscheidung nötig:** Soll Dark Mode hinter die Paywall verschoben werden?

---

## Zusammenfassung: Prioritäten

| Priorität | Task | Impact | Aufwand |
|---|---|---|---|
| 🔴 1 | Streak-System (Counter + Freeze) | Retention ++ | Mittel |
| 🔴 2 | Banner entfernen + Rewarded Video | Einnahmen ++ | Niedrig |
| 🔴 3 | Puzzle-Archiv (FUN3) | Premium-Wert ++ | Mittel |
| 🔴 4 | Motiv-Anzeige nach Lösen | UX + | Niedrig |
| 🟡 5 | Teilen-Karte | Viral-Potenzial | Niedrig |
| 🟡 6 | Push-Benachrichtigungen | Retention + | Niedrig |
| 🟠 7 | ASO / Screenshots | Sichtbarkeit | Mittel |
| 🟡 8 | Saisonale Themen | Engagement | Niedrig |
| 🟡 9 | Persönliche Statistiken | Retention + | Mittel |
| ⚪ 10 | Dark Mode → Premium? | Subscription + | Niedrig |

**Kernaussage der Analyse:** Das größte Risiko ist nicht die Konkurrenz — es ist, dass ohne Streak-System keine Gewohnheit entsteht. **Reihenfolge: Streak → Archiv → Share-Karte.**
