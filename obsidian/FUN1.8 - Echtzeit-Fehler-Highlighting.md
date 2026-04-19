2026-04-19
#done
# FUN1.8 – Echtzeit-Fehler-Highlighting

Wenn der User eine Zelle füllt, die NICHT zur Lösung gehört, soll diese Zelle sofort visuell rot/orange hinterlegt werden (ähnlich wie `markInvalid` in FreeNono).
Es soll nicht sofort sein. Ein Premium User kann ein Video ansehen und dann werden alle zurzeit falsch markierten (Max. 5) Felder rot markiert.
Ein normaler User hat das nicht.
Hier der Rewarded Ad Link: ca-app-pub-1758574140088603/4321366497

## Anforderungen

- Neuer `CellState`-Wert: `.error` (oder bestehende Zustände nutzen + separate Fehler-Property)
- Nach jedem Tap wird geprüft: Ist die gefüllte Zelle korrekt? Falls nicht → visuelles Fehler-Feedback
- Einstellbar: on/off-Toggle in den Settings (Standard: on)
- Fehler-Zellen werden rot/orange hinterlegt in `NonogramGridView`

# Implementierung

Datum: 2026-04-19

Neuer `CellState.error = 5` hinzugefügt. `NonogramViewModel.applyErrors(max:)` findet falsch gefüllte Zellen (`.filled` wo `solution == false`) und setzt max. 5 davon auf `.error`. `NonogramGridView` rendert `.error`-Zellen mit rotem Hintergrund + rotem X-Mark. Neuer Rewarded-Ad-Slot `rewardedErrorRevealUnitID` in `AdManager`. Button "Fehler" (Auge-Icon) nur für Premium-User sichtbar in der Action-Row des `NonogramBoardView`.
