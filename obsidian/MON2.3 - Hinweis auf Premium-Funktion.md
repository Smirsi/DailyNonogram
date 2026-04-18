2026-04-11
#done
# Aufgabe
Es soll öfters ein Pop-Up mit dem Hinweis kommen, dass es eine Premium-Funktion gibt.
# Implementierung
`PremiumTeaserView` (Overlay mit Crown-Icon, 4 Feature-Bullets, Upgrade- und Dismiss-Button) und `PremiumTeaserService` (max. 1× pro Tag, nicht für Premium-User) implementiert. Teaser erscheint nach dem Dismiss der Completion-Overlay wenn `shouldShow()` true ist. Direkt-Link zu `PremiumPaywallView` über "Premium werden"-Button.
Datum: 2026-04-11 | Commit: folgt
#approved 