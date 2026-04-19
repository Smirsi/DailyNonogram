2026-04-18
#done 
# Aufgabe
Neben dem Namen des Rätsels steht oft Vflip. Das ist eigenartig und macht keinen guten Eindruck. Es sollte zb nur Heart dortstehen.
# Implementierung

Datum: 2026-04-18

Regex `(?i)\s+[vh]flip$` entfernt " Vflip", " Hflip" (und Varianten) am Ende des Rätselnamens in `FreeNonoPuzzleLoader.swift` (beide Parser: NonogramXMLParser + ColorNonogramXMLParser).

#approved 