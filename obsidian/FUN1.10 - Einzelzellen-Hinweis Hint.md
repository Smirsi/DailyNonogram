2026-04-19
#open
# FUN1.10 – Einzelzellen-Hinweis (Hint via Rewarded Ad)

Ein Hint-Button enthüllt eine zufällig gewählte noch-nicht-korrekt-gefüllte Zelle. Jeder Hint erfordert das Ansehen eines Rewarded-Ad-Videos.

## Anforderungen

- Hint-Button in der Puzzle-Toolbar (Glühbirnen-Icon o.ä.)
- Beim Tippen: Rewarded Ad wird abgespielt (Ad Unit ID: `ca-app-pub-1758574140088603/3275878139`)
- Nach erfolgreichem Ad-Ansehen: eine zufällige korrekte-aber-noch-leere Zelle wird als `.filled` gesetzt und visuell hervorgehoben (z.B. kurzes Aufleuchten)
- Hint-Zellen werden im State gespeichert (z.B. `.hinted` als separater CellState oder Flag) damit sie nicht als Fehler markiert werden
- Wenn Auto-Lösen (FUN1.11) verwendet wird, werden alle Hints auf 0 gesetzt (keine weiteren Hints)
- Ad nicht verfügbar: Fehlermeldung anzeigen

## Ad-Integration

- Ad Unit ID Rewarded: `ca-app-pub-1758574140088603/3275878139`
- GADRewardedAd laden und vorab pre-cachen
- Callback nach erfolgreichem Ansehen → Hint-Logik auslösen

## Relevante Dateien

- `DailyNonogram/ViewModels/NonogramViewModel.swift` – revealHint()
- `DailyNonogram/Services/AdService.swift` (oder bestehende Ad-Integration)
- `DailyNonogram/Views/NonogramBoardView.swift` – Hint-Button

## Komplexität / Dauer

Medium / ~1 h

# Implementierung
