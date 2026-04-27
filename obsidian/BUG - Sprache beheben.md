2026-04-26
#done
[[Bugs]]
[[Release 1.0]]
# Aufgabe
Deutsch/Englisch korrekte Sprache anzeigen für alle Wörter. Scheint als wäre es teilweise gemischt.

# Rückfragen
**Soll die App vollständig lokalisiert werden (DE + EN je nach Systemsprache)?**
Antwort: Ja, vollständig lokalisieren.

# Implementierung

Datum: 2026-04-27
Commit: siehe unten

Vollständige Lokalisierung implementiert:
- `de.lproj/Localizable.strings` und `en.lproj/Localizable.strings` erstellt mit allen UI-Texten
- Beide Dateien ins Xcode-Projekt (project.pbxproj) eingebunden via PBXVariantGroup
- `DateFormatter.locale` in allen Views auf `Locale.current` geändert (war hardcoded „de_DE")
- `DifficultyLevel.displayName/description` nutzen nun `String(localized:)`
- `actionButton(label:)` in NonogramBoardView auf `LocalizedStringKey` umgestellt
- `ToolbarView` ToolItem labels auf `LocalizedStringKey` umgestellt
- `PremiumPaywallView` computed String properties auf `String(localized:)` umgestellt
- `StoreKitManager` Fehlermeldungen auf `String(format: String(localized:), ...)` umgestellt
