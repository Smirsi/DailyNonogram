2026-04-26
#done
[[Release]]
[[Release 1.0]]
# Aufgabe
Füge für Testzwecke in den Einstellungen einen Button hinzu, mit dem ich auf Premium umschalten kann.
# Implementierung

Datum: 2026-04-27
Commit: siehe unten

In `SettingsView.swift` wurde ein `#if DEBUG`-Block hinzugefügt mit einem Toggle „Premium aktivieren (Test)". Dieser Toggle setzt direkt `UserDefaults["isPremiumCached"]` und aktualisiert `store.isPremium` via `StoreKitManager.setDebugPremium()`. Im Release-Build nicht sichtbar.
#approved 