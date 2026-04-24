2026-04-19
#done
# Aufgabe
Hint ist nicht klickbar, ist das Absicht?

# Implementierung

Datum: 2026-04-19

Ja, im Production-Build ist der Hint-Button bewusst deaktiviert wenn kein Rewarded Ad geladen ist (Ad ist Pflicht). Im Debug-Build (`#if DEBUG`) ist der Button jetzt immer aktiv und ruft `vm.applyHint()` direkt auf – ohne Ad-Pflicht. So kann das Feature im Simulator getestet werden.
#approved