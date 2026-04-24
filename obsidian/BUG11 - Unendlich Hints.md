2026-04-24
#done 
# Aufgabe
Wie viele Hints sind derzeit möglich? Free User soll 2 haben, Premium hat 5. Wenn es mehr sein sollen, kommt immer eine Werbung und man hat wieder 2 bzw. 5.
Vermerke dies auch beim Premiumkauf: 5 Gratis Hints pro Rätsel.
# Implementierung

Datum: 2026-04-23
Commit: siehe nächster Commit

- `NonogramViewModel.swift`: `@Published var hintsRemaining: Int = 2` hinzugefügt. `resetHints(isPremium:)` setzt den Vorrat (Free=2, Premium=5). `refillHints(isPremium:)` füllt nach Ad-Schauen wieder auf. `applyHint()` prüft `hintsRemaining > 0` und dekrementiert.
- `NonogramBoardView.swift`: Hint-Button zeigt nun "Hint (N)" mit aktuellem Vorrat. Bei `hintsRemaining > 0` → normaler Ad-Flow. Bei `hintsRemaining == 0` → Refill-Ad → danach `refillHints` + `applyHint`. `resetHints` wird in `.onAppear` aufgerufen.
- `PremiumPaywallView.swift`: Feature "5 Gratis Hints pro Rätsel" mit `lightbulb.fill`-Icon in die Feature-Liste ergänzt.