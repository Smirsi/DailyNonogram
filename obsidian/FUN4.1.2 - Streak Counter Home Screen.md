2026-04-19
#done 
# Aufgabe
Der Streak-Counter wird im Modal nach dem Lösen des Rätsel falsch dargestellt, das gehört geändert.
# Implementierung

Datum: 2026-04-19

- `CompletionOverlayView.swift`: Überflüssiges `.padding(.top, 16)` vor dem Background entfernt (führte zu 26pt oben vs 10pt unten = schiefes Layout). Font von `.monospaced` auf Standard geändert für bessere Lesbarkeit.