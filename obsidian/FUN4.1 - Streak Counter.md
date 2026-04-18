2026-04-18
#done
# Aufgabe
**Analyse-Bewertung:** Wichtigster psychologischer Retention-Anker ("Streak-Anxiety" wie bei Wordle).  
**Aktueller Stand:** FUN4 (Aktivitätstracker) ist nur eine leere Struktur — keine Implementierung.  
**Was fehlt:**
- Streak-Counter prominent in der UI (schlicht: eine Zahl + Symbol, kein Konfetti)
- Streak-Freeze als Premium-Feature (1 verpasster Tag zählt nicht)
- Streak wird angezeigt nach dem Lösen und auf dem Homescreen
# Implementierung

Datum: 2026-04-18

- `StreakService.swift` neu erstellt: berechnet Streak dynamisch aus UserDefaults, Freeze-Token-Logik (1 Token pro 7 gespielter Tage), `applyFreeze()`, `canApplyFreezeForYesterday()`
- `WeekProgressView`: Streak-Counter (🔥 + Zahl) rechts neben den 7 Tages-Kreisen
- `CompletionOverlayView`: Streak-Badge im Abschluss-Dialog ("X Tage in Folge")
- `NonogramBoardView`: `@State streak` wird bei `.onAppear` und nach Puzzle-Lösung aktualisiert; Freeze-Alert wenn Premium-Nutzer gestern verpasst hat (einmalig pro Tag)
- `SettingsView`: Abschnitt "Streak" für Premium-Nutzer mit verfügbaren Freeze-Tokens und Erklärung