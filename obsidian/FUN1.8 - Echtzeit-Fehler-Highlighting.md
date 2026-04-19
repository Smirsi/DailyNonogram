2026-04-19
#open
# FUN1.8 – Echtzeit-Fehler-Highlighting

Wenn der User eine Zelle füllt, die NICHT zur Lösung gehört, soll diese Zelle sofort visuell rot/orange hinterlegt werden (ähnlich wie `markInvalid` in FreeNono).

## Anforderungen

- Neuer `CellState`-Wert: `.error` (oder bestehende Zustände nutzen + separate Fehler-Property)
- Nach jedem Tap wird geprüft: Ist die gefüllte Zelle korrekt? Falls nicht → visuelles Fehler-Feedback
- Einstellbar: on/off-Toggle in den Settings (Standard: on)
- Fehler-Zellen werden rot/orange hinterlegt in `NonogramGridView`

## Relevante Dateien

- `DailyNonogram/Models/CellState.swift` – ggf. neuer State
- `DailyNonogram/ViewModels/NonogramViewModel.swift` – Validierung nach handleTap/endDrag
- `DailyNonogram/Views/NonogramGridView.swift` – Farb-Rendering für Fehler
- `DailyNonogram/Views/SettingsView.swift` – Toggle

## Komplexität / Dauer

Low / ~30 min

# Implementierung
