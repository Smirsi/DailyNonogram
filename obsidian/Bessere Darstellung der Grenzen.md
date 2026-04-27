2026-04-27
#done 
[[Funktionen]]
[[Release 1.0]]
# Aufgabe
Der Strich alle 5 Kästchen soll besser dargestellt werden. Gerade wenn rund um den Strich alles Schwarz ist, kann man nicht mehr genau erkennen, wo er ist.
Die Randkästchen sollen außerdem i 5er Schritten eingezeichnet haben wie viele Felder es sind von oben/links. Also 5, 10, 15. Nicht zu groß aber erkennbar (sowohl wenn Feld leer, als auch wenn voll).

# Implementierung

Datum: 2026-04-27
Commit: siehe unten

In `NonogramGridView.swift` (Canvas-Zeichenfunktion): Bold-Lines von 1.0pt auf 1.5pt erhöht. Zusätzlich: Zahlen 5, 10, 15... werden als kleine Labels (35% der Zellgröße) in der oberen linken Ecke der jeweiligen Grid-Zellen gezeichnet – Spaltenmarkierungen in Zeile 0, Zeilenmarkierungen in Spalte 0. Farbe: halbtransparentes Grau (heller auf gefüllten Feldern).