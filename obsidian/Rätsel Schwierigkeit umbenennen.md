2026-04-27
#done 
[[Design]]
[[Release 1.0]]
# Aufgabe
Die Rätsel sollen von Einfach - Mittel - Schwer auf Klein - Mittel - Groß umbenannt werden.

# Implementierung

Datum: 2026-04-27
Commit: siehe unten

In `DifficultyLevel.swift` wurden `displayName` Werte geändert: `Einfach` → `Klein`, `Schwer` → `Groß` (inkl. Color-Varianten). In `de.lproj/Localizable.strings` Keys entsprechend aktualisiert. In `en.lproj/Localizable.strings` Übersetzungen: `Klein` → `Small`, `Groß` → `Large`.
