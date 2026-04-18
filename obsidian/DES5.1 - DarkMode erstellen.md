2026-04-10
#done
# Aufgabe
Implementiere einen DarkMode, der in dein Einstellungen änderbar ist.
# Implementierung

Datum: 2026-04-11
Commit: `5035aa6`

`DesignSystem.swift`: Alle Farben als adaptive Light/Dark-Varianten via `UIColor(dynamicProvider:)`. Dark-Mode-Palette: warme Dunkelbrauntöne als Hintergrund, invertierte Zell-Farben (gefüllte Zellen werden hell). Terrakotta-Akzentfarbe bleibt in beiden Modi gleich. `NonogramBoardView`: `.preferredColorScheme(.light)` entfernt – App folgt jetzt dem System-Dark-Mode automatisch.
#approved 