2026-04-26
#done
[[Funktionen]]
[[Release 1.0]]
# Aufgabe
Start bereits mit 1 Freeze nach Download. Wenn man den Freeze bekommt dann mit einer Meldung/pop-Up: Freeze erhalten! Und wenn man in verbraucht auch mit Meldung: Freeze eingelöst am ...
Wenn man Premium kauft bekommt man auch 1 zusätzlichen Freeze.
Free-Version hat auch Freeze, aber ändern auf maximal 2. Premium hat bis zu 10 Freeze.
Füge die Option wo hinzu, dass man Freeze kaufen kann (com.adept.dailynonogram.purchase.freezetoken, 3 Stück, bei überschreiten des limits erhöht sich limit temporär, limit wird weniger jedesmal wenn freeze konsumiert wurde, bis wieder bei 2 bzw bei 10)

# Implementierung

Datum: 2026-04-27
Commit: siehe unten

`StreakService.swift` komplett überarbeitet:
- Free-Limit auf 2 gesenkt, Premium-Limit bleibt 10
- Neuer UserDefaults-Key `streak_purchasedFreezeTokens` für gekaufte Tokens
- `availableFreezes()`: min(earned, baseLimit) + purchasedTokens → temp. Limit steigt mit Kauf
- `grantStarterFreezeIfNeeded()`: 1× bei erstem App-Start via Key `hasReceivedStarterFreeze`
- `addPurchasedFreezeTokens(count:)`: für IAP und Premium-Kauf-Bonus
- `applyFreeze()` / `spendFreezeForSolve()`: verbrauchen zuerst gekaufte Tokens

`StoreKitManager.swift`:
- Neue Produkt-ID `com.adept.dailynonogram.purchase.freezetoken`
- `freezeTokenProduct: Product?` published
- Bei Kauf: 3 Tokens hinzufügen; bei Premium-Kauf: 1 Extra-Token

`NonogramBoardView.swift`:
- `checkStarterFreeze()` bei App-Start: zeigt "Freeze erhalten!"-Alert
- `checkFreezeOpportunity()` zeigt "Freeze eingelöst am..."-Alert nach Auto-Apply

`SettingsView.swift`: "3 Freeze kaufen – [Preis]"-Button in Premium-Sektion.