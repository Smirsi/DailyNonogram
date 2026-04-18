2026-04-11
#done
# Aufgabe
Grundsätzlich kann der Benutzer am Beginn des Tages auswählen, welche Schwierigkeit er machen möchte. Hat er diese gewählt (mit Bestätigungsfrage), kann er nicht mehr wechseln und muss dieses fertig machen. Ein Premium-Nutzer kann immer wechseln, bzw. alle 3 Schwierigkeitsgrade fertigstellen. Sobald er eines erledigt hat gilt der Tag als gelöst.
Zusätzlich kann der Premium-Nutzer auch immer die ganze Woche zurückgehen (über die Punkteleiste oben) und auch die Nonogramme dieser Tage lösen.
Außerdem bekommt der Premium-Nutzer keine Werbung.
Außerdem wird er später Zugriff auf farbige Nonogramme bekommen, dies vorbereiten.
Die Vorteil sollen alle ersichtlich sein.
# Implementierung
`DifficultySelectionView` als eigener Start-Screen implementiert: Free-User wählen eine Schwierigkeit/Tag mit Bestätigungs-Alert (danach gesperrt). Premium-User können jederzeit über den Difficulty-Badge im Header zur Auswahl zurückkehren und alle 3 Levels lösen. `WeekProgressView` zeigt den Tag als gelöst sobald eine Schwierigkeit gelöst wurde. `isColorized: Bool` als Vorbereitungsfeld in `Nonogram` hinzugefügt (kein UI). Banner-Werbung bereits für Premium unterdrückt (war schon implementiert).
Datum: 2026-04-11 | Commit: folgt
#approved 