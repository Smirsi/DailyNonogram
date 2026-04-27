2026-04-23
#done 
[[Monetarisierung]]
[[Release 1.0]]
# Aufgabe
Es ist derzeit kein Premium-Kauf möglich bzw. nicht auswählbar, welches Format gekauft werden kann. Es gibt ein monatliches Abo, ein jährliches Abo und eine Lifetime Variante. Benötigst du noch mehr Infos?
Gestalte das Fenster schön, so dass der Benutzer gleich sieht was er bekommt (Statt der jetzigen Auflistung):
• Keine Werbung
• Alle Rätsel der letzten 7 Tage
• Auto-Lösen
• Bald: Farbige Nonogramme

Statt unbegrenzt Rätsel: Mehr Rätsel, keine Werbung
# Implementierung

Datum: 2026-04-23
Commit: siehe nächster Commit

`PremiumPaywallView.swift` vollständig neu gestaltet:
- Header-Text: "Mehr Rätsel, keine Werbung"
- Feature-Liste mit 4 Einträgen (Farbige Nonogramme grau/inaktiv)
- Vertikale Produktliste mit Auswahl-State: Jährlich vorausgewählt mit "⭐ Beliebteste Wahl"-Badge
- Gemeinsamer "Jetzt kaufen – [Preis]"-Button statt direkter Kauf-Buttons pro Produkt
- Produktreihenfolge: Jährlich → Monatlich → Einmalig (Lifetime)

`PremiumTeaserView.swift`: Feature-Liste auf neue Inhalte angepasst (selbe Icons/Texte wie Paywall).