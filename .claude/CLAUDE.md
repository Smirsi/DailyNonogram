# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Projektübersicht

Das Programm soll eine App für den iOS, ipadOS und macOS Appstore werden, mit der ein Bediener ein Nonogramm lösen kann.

## Entwicklungsablauf

Die Informationen zu einem Projekt und die Entwicklungsschritte liegen in einem Obsidian-Vault unter diesem Pfad: ./obsidian (siehe z.B. wie auch in diesem Projekt)
In diesem Ordner gibt es Markdown-Files, die nach dem Header folgende Tags mit folgender Bedeutung aufweisen können:
* #backlog - Eine Aufgabe, die noch zu einem späteren Zeitpunkt erledigt werden muss (vorerst ignorieren)
* #open - Eine Aufgabe, die jetzt erledigt werden soll
* #inprogress - Eine Aufgabe, die gerade erledigt wird
* #waiting - Eine Aufgabe, die Input für die weitere Erledigung benötigt
* #done - Eine Aufgabe, die erledigt wurde

Wenn ich den Befehl gebe, einen Plan für weitere Entwicklungen zu machen, gehst du alle Files in diesem Vault durch und suchst dir die #open und #waiting Aufgaben heraus und erstellst dafür einen Plan mit den notwendigen Rückfragen für die korrekte Ausarbeitung. Während der Erledigung stellt du den Tag auf #inprogress, nach der Erledigung der Aufgaben stellst du den Tag auf #done (oder wenn notwendig auf #waiting). Unter der Überschrift: Implementierung beschreibst du in Kurzfassung die erledigten Änderungen und schreibst das Datum der Implementierung sowie den Commit zu Github dazu. Wenn du Rückfragen stellst, dann legst du über Implementierung eine Überschrift "# Rückfragen" an und notierst dort die Fragen inklusive meiner Antwort.
Wenn ich mit der Implementierung zufrieden bin, dann kommt am ende ein #approved dazu. Bin ich nicht zufrieden kommt ein Tag #notapproved dazu und eine Verlinkung zu einem weiteren Task, der das Problem beschreibt.
Wenn der Plan erstellt wird sollen alle Aufgaben als Arbeitspaket gesehen werden und jeweils die Komplexität/Dauer/Tokenverbrauch geschätzt werden.
