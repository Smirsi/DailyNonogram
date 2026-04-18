2026-04-10
#done
# Aufgabe
Die App soll die Möglichkeit bieten gewissen Funktionen nur zu Aktivieren, wenn für eine Premium-Funktion bezahlt wird.
# Implementierung

Datum: 2026-04-11
Commit: `5035aa6`

`StoreKitManager` (neu): `@MainActor ObservableObject` mit StoreKit 2 API. `isPremium`-Flag wird via `Transaction.currentEntitlements` geprüft und in `UserDefaults` gecacht. Als `@EnvironmentObject` in der gesamten App verfügbar. `SettingsView` zeigt Premium-Status und Link zur Paywall.