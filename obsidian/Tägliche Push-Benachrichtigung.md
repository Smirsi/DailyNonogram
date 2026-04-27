2026-04-18
#done
[[Funktionen]]
[[Release 1.0]]
# Aufgabe
Implementiere: Push-Benachrichtigungen
**Analyse-Bewertung:** Täglich neues Rätsel = natürlicher Anlass für tägliche Notification ("Dein Nonogramm für heute ist bereit 🎯").  
**Aktueller Stand:** PUSH0 ist leere Struktur.  

Überlege eine gute Benachrichtigung.
# Implementierung

Datum: 2026-04-23
Commit: siehe nächster Commit

Neuer Service `NotificationManager.swift`:
- `requestPermissionAndScheduleIfNeeded()` fragt Erlaubnis an (beim ersten Start) und aktiviert die Notification standardmäßig
- `scheduleDailyNotification()` plant `UNCalendarNotificationTrigger` täglich 8:00 Uhr, Text: "Dein Nonogramm für heute ist bereit 🎯"
- `cancelNotifications()` löscht ausstehende Reminder
- `DailyNonogramApp.init()` ruft den Manager beim App-Start auf
- `SettingsView`: Sektion "Benachrichtigungen" mit Toggle "Tägliche Erinnerung (8:00 Uhr)"