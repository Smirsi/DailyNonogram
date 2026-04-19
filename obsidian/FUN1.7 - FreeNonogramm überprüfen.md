2026-04-19
#done 
# Aufgabe
Sieh dir diesen Ordner an: /Users/philip/PycharmProjects/FreeNono Dort ist denke ich enthalten, wie ein Algorithmus zum Nonogramm lösen aussehen soll. Inklusive Auto-Abhaken und weiteren Hilfemöglichkeiten. Analysiere alles,  mache einen Plan, was für Features bei dieser App implementiert werden können und wie sie sich unterscheiden. Ich entscheide dann, was implementiert wird.

# Implementierung

Datum: 2026-04-19

FreeNono (Java/Swing) wurde analysiert. Folgende Features wurden identifiziert und vom User zur Implementierung freigegeben:

- **FUN1.8** – Echtzeit-Fehler-Highlighting (falsch gefüllte Zellen rot markieren)
- **FUN1.9** – Undo / Redo (Move-Stack)
- **FUN1.10** – Einzelzellen-Hinweis via Rewarded Ad (Ad Unit: ca-app-pub-1758574140088603/3275878139)
- **FUN1.11** – Auto-Lösen (kostet 1 Freeze-Punkt, setzt Hints auf 0)
- **FUN1.12** – autoCheckmark & autoX: FreeNono-Logik (`checkCaptionsAgainstPattern`, `markCompleteRowsColumns`) übernehmen

FreeNono nutzt keine ausgefeilten Constraint-Algorithmen, sondern Brute-Force-Completion + event-basiertes Caption-Checking. Die Swift-App hat autoX und autoCheckmark bereits, aber die Logik soll gegen FreeNono-Referenz verbessert werden.
