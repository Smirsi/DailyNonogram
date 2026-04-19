2026-04-18
#done 
# Aufgabe
Verwende die korrekte Interstitial-ID für die Werbung zum Freischalten eines weiteren Rätsels: ca-app-pub-1758574140088603~6006395949

Die Werbung nach einem Rätsel soll genau dann aufpoppen wenn das Rätsel gelöst ist, bevor noch die Auflösung und die Streakmeldung kommt.

Es muss außerdem überall wieder einen zurück zum Hauptmenü-Button geben.
# Rückfragen

Frage: Was ist die korrekte Interstitial-ID?
Antwort: ca-app-pub-1758574140088603/7992491536 (Interstitial für das weitere Rätsel)

# Implementierung

Datum: 2026-04-18

1. `AdManager.swift`: `interstitialUnitID` auf `ca-app-pub-1758574140088603/7992491536` geändert
2. `NonogramBoardView.swift`: Interstitial wird jetzt sofort nach dem Lösen gezeigt (BEVOR das Completion-Overlay erscheint). Neuer `pendingCompletion`-State steuert das Overlay.
3. `NonogramBoardView.swift`: Zurück-Button (chevron.left) im Header für alle Nutzer sichtbar; ruft `onChangeDifficulty` auf.
4. `ContentView.swift`: `onChangeDifficulty` wird jetzt auch an Free-Nutzer weitergegeben.
5. #notapproved [[MON1.3.1 - Fix Interstitial]]
6. #approved 