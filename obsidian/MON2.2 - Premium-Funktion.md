2026-04-10
#done
# Aufgabe
Die App soll die Möglichkeit haben, dass der Benutzer einmalig, monatlich oder jährlich für eine Premium-Funktion bezahlt.
# Implementierung

Datum: 2026-04-11
Commit: `5035aa6`

`PremiumPaywallView` (neu): zeigt 3 Kaufoptionen (monatlich/jährlich/einmalig) mit echten Preisen aus StoreKit. Enthält Feature-Liste, Lade-Indikator, Fehlerausgabe und „Käufe wiederherstellen"-Button. Platzhalter-Produkt-IDs: `com.philip.dailynonogram.premium.{monthly|yearly|lifetime}` – müssen in App Store Connect angelegt werden.
#approved 