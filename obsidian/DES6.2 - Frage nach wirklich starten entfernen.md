2026-04-19
#done
# Aufgabe
Das Pop-Up mit der Frage wirklich dieses Rätsel starten entfernen

# Implementierung

Datum: 2026-04-19

`showConfirm`-State und das dazugehörige `confirmationDialog("Rätsel bestätigen")` aus `DifficultySelectionView` entfernt. `handleTap` navigiert jetzt direkt zu `onSelect(level)`. Das Ad-Bestätigungsdialog (`showAdPrompt`) für den Rewarded-Ad-Flow bleibt bestehen.
#approved 