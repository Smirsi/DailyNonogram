2026-04-18
#done
# Aufgabe
Puzzle-Archiv für Premium (FUN3 leer)
**Analyse-Bewertung:** "Puzzle-Archiv" ist ein stärkeres Subscription-Argument als "6 Puzzles". Vergangene Rätsel für Premium spielbar — für Free-Nutzer verfallen sie nach 24h.  
**Was fehlt:**
- Archiv-Screen mit allen vergangenen Tagesrätseln der letzten 7 Tage
- Für Premium: alle spielbar; für Free: gesperrt (Paywall-Hinweis)
- Premium-Kommunikation: "Dein persönliches Puzzle-Archiv" statt nur "6 Puzzles/Tag"
# Implementierung

Datum: 2026-04-18

- `WeekProgressView`: Vergangene Tages-Kreise (nicht heute) sind jetzt tappbar via `onSelectPastDay`-Callback
- `ArchivePuzzleSheet.swift`: Sheet mit Puzzle der gewählten Vergangenheitsdatum + Fortschritt-Persistierung; `ArchiveDateSelection` als Identifiable-Wrapper
- `NonogramBoardView`: Tippt Premium-Nutzer auf vergangenen Tag → öffnet `ArchivePuzzleSheet`; Free-Nutzer → Paywall
#approved 