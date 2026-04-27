2026-04-10
#done 
[[Funktionen]]
[[Release 1.0]]
# Aufgabe
In den Einstellungen kann aktiviert werden, dass die Zahlen links und rechts sowie oben und unten angezeigt werden.
# Implementierung
In `NonogramBoardView` werden bei aktivierter Einstellung `showCluesBothSides` (@AppStorage) zusätzliche `RowCluesView` rechts und `ColCluesView` unten eingeblendet. Gesteuert über `SettingsView`.
#approved 