2026-04-19
#done 
# Aufgabe
Folgende IDs sollen für die Werbung verwendert werden:
Nach dem Lösen des Rätsels, vor dem Modal mit der Lösung: ca-app-pub-1758574140088603/7574628484
Wenn ein User ein zweites Rätsel machen möchte, so kann er das solange machen, solange er noch kein Kästchen ausgefüllt hat. Sobald er dies ein Mal gemacht hat (auch wenn er es wieder löscht), kann er kein weiteres Rätsel lösen. Dann kommt ein Hinweis mit: Werbung schauen für weiteres Rätsel? Dafür wird diese ID verwendet: ca-app-pub-1758574140088603/7992491536
# Implementierung

Datum: 2026-04-19

- `AdManager.swift`: Interstitial-ID auf `7574628484`, Rewarded-ID auf `7992491536` aktualisiert.
- `PuzzleLockService.swift` (neu): Speichert welche Difficulty heute gestartet wurde; prüft ob weitere Puzzles einen Ad-Unlock benötigen.
- `NonogramViewModel.swift`: Ruft `lockPuzzle(difficulty:)` beim ersten Zug (beginDrag/handleTap) auf.
- `DifficultySelectionView.swift`: Ad-Gate-Logik für Free-User: In-progress Puzzle → direkt öffnen, anderes Puzzle → Rewarded Ad Dialog, erstes Puzzle → Confirm Dialog.
- `NonogramBoardView.swift`: BonusOfferBanner und showBonusPuzzle entfernt.
- #approved 