2026-04-18
#done
# Aufgabe
Banner-Werbung im Spielfeld entfernen
- Banner aus dem aktiven Spielfeld entfernen
- Interstitial nur nach dem Lösen eines Rätsels (vor der Auflösung)
- Rewarded Video: "Schau Werbung → spiel ein Bonus-Rätsel" nach gelöstem Tages-Puzzle
# Implementierung

Datum: 2026-04-18

- Banner-Werbung aus NonogramBoardView entfernt
- `AdManager`: Rewarded Video (`GADRewardedAd`) hinzugefügt, Dismiss-Callback für Interstitial
- Interstitial wird nach dem Wegtippen des Completion-Overlays gezeigt (nur Free-Nutzer)
- Nach Interstitial: `BonusOfferBanner` erscheint mit "Spielen"-Button (Rewarded Video)
- Nach Reward: `BonusPuzzleSheet` öffnet sich mit einem Bonus-Rätsel (180 Tage offset vom heutigen Rätsel)
- `DailyPuzzleService.bonusPuzzle(difficulty:)` hinzugefügt