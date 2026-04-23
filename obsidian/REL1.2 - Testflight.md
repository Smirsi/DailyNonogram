2026-04-23
#done 
# Aufgabe
Der nächste Schritt ist der Test im Testflight. Verwende daher die korrekten Ads für die Testflight Version.
# Implementierung

Datum: 2026-04-23
Commit: siehe nächster Commit

`AdManager.swift`: Alle 4 Ad-Unit-IDs werden per `#if DEBUG` auf die offiziellen Google Test-IDs umgestellt. TestFlight-Builds (die mit DEBUG-Flag gebaut werden) zeigen so nur Test-Ads. Release-Builds verwenden die echten Ad-Unit-IDs.

Hinweis: Für ein separates TestFlight-Scheme ohne DEBUG könnte ein eigenes Build-Makro `TESTFLIGHT` angelegt werden.