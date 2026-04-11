2026-04-10
#done 
# Aufgabe
Es soll möglich sein, das Nonogramm zu verschieben und rein- und raus zu zoomen.
# Implementierung
`NonogramGridView` unterstützt jetzt:
- **2-Finger-Pinch** (`MagnificationGesture`): Zoom von 0.5× bis 3×. Der Canvas skaliert die Zellgröße entsprechend, der ScrollView übernimmt das Panning.
- **Doppeltippen**: Zoom-Reset auf 1×.
- Zeichnen (1-Finger) funktioniert weiterhin korrekt mit angepasster Koordinatentransformation.

#notapproved siehe [[FUN1.3.1 - Zahlen zoomen nicht mit]]
