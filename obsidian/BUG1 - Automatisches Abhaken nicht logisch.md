2026-04-11
#done
# Aufgabe
Beim automatischen Abhaken darf nur dann gestrichen werden, wenn es eindeutig die Zahl ist. Es kann zB kein 1er gestrichen werden der als erstes angezeigt wird wenn ganz unten ein Feld schwarz geworden ist. Auch wenn ich dann den 2er unten korrekt gemacht habe wurde nur der 1 wieder entfernt aber der 2 nicht gestrichen.
Ich denke es müsste nicht nur von oben nach unten geprüft werden sondern auch von unten nach oben und auch dazwischen.
# Implementierung
`matchClues()` in `NonogramViewModel.swift` auf bidirektionales Matching umgebaut: Links-Pass matcht Clues von links, Rechts-Pass matcht verbleibende Clues von rechts – beide Pässe unabhängig, kein vorzeitiger Break mehr für bereits gematchte Clues.
Datum: 2026-04-11 | Commit: folgt mit AP2