2026-04-10
#done
[[Funktionen]]
[[Release 1.0]]
# Aufgabe
Die App hat als Hauptfunktion die Lösung von Nonogrammen. Der Bediener soll alle Möglichkeiten haben, die notwendig sind, um das Diagramm effizient zu lösen. Dazu gehört ein Stift, ein Radierer, die Möglichkeit mehrere Felder auf einmal auszumalen, etc. Dazu gibt es bestimmt andere Apps, die man als Vorlage heranziehen kann. Gestartet soll einfach mal mit einem einzigen Bild werden, bei dem man sieht, wie der Nonogramm Editor funktioniert.
# Implementierung
SwiftUI-App (iOS 17+, Mac Catalyst) mit vollständigem Nonogramm-Editor implementiert:
- **Stift**: Zelle antippen/ziehen → schwarz ausfüllen
- **Radierer**: Zellen leeren
- **X-Markierung**: Zellen als leer markieren (Kreuz)
- **Drag über mehrere Zellen**: konsistenter State für den gesamten Drag-Vorgang
- **Lösungsprüfung**: Erfolgs-Alert wenn das Nonogramm korrekt gelöst ist
- **Zeilen-/Spalten-Clues** werden links/oben angezeigt
- Beispiel-Nonogramm (5×5, Pfeilform) als erster Testfall (`SampleNonogram.swift`)
#approved 