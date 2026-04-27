2026-04-10
#done
[[Funktionen]]
[[Release 1.0]]
# Aufgabe
Die automatisch erstellen X sollen eine andere Farbe haben, damit sie erkennbar sind von den selbst gesetzten
# Implementierung

Datum: 2026-04-11
Commit: `5035aa6`

Neuer `CellState.autoCrossed` (rawValue: 3) eingeführt. `applyAutoX()` setzt jetzt `.autoCrossed` statt `.crossed`. Canvas-Rendering: autoCrossed-Zellen haben terrakottafarbenen Hintergrund (accent @ 12% opacity) und terrakottafarbene X-Linien (`DS.accent`). Manuelle X bleiben grau wie bisher. Save/Load funktioniert automatisch via rawValue 3.
#approved 