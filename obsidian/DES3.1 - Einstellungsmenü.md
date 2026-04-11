2026-04-10
#done
# Aufgabe
Es soll ein Menü geben, in dem Einstellungen durchführbar sind.
# Implementierung
`SettingsView.swift`: Sheet-basiertes Einstellungsmenü (NavigationStack + Form). Erreichbar über das Zahnrad-Icon in `NonogramBoardView`. Enthält Abschnitte für Anzeige- und Automatisierungs-Einstellungen. Alle Werte werden per `@AppStorage` persistiert.
#approved 