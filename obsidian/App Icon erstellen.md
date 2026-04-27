2026-04-10
#done
[[Design]]
[[Release 1.0]]
# Aufgabe
Erstelle ein App-Icon, das zu der App passt.
# Rückfragen
Das App Icon ist ein Design-Asset das manuell erstellt werden muss (PNG-Dateien in allen Größen). Vorschlag: stilisiertes 5×5 Nonogramm-Grid mit einem erkennbaren Muster (z.B. Herz oder „N"). Muss in Xcode unter Assets.xcassets/AppIcon.appiconset eingebunden werden.

Das Nonogramm liegt im Downloads-Ordner:![[nonogram_icon_pencil_grid 1.svg]]
# Implementierung

Datum: 2026-04-18

SVG viewBox auf `218 52 244 244` zugeschnitten (quadratischer Crop, weißer Rand entfernt). Mit `rsvg-convert` als 1024×1024 PNG exportiert und in `DailyNonogram/Assets.xcassets/AppIcon.appiconset/AppIcon.png` abgelegt. `Contents.json` mit `filename`-Eintrag ergänzt.
#approved 