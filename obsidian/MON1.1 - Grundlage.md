2026-04-10
#done
# Aufgabe
Die App soll die Möglichkeit haben Werbung zu aktivieren, mit der automatisiert Geld verdient werden kann. Die Werbung soll aus Banner und aus Vollbildwerbungen bestehen.
# Implementierung

Datum: 2026-04-11

Google Mobile Ads SDK via SPM eingebunden (`project.yml`). `AdManager` (neu): initialisiert GADMobileAds, lädt Interstitial-Ad vor, stellt `showInterstitialIfReady(from:)` bereit. `BannerAdView` (neu): UIViewRepresentable für GADBannerView. Banner am unteren Rand von `NonogramBoardView` (nur für Non-Premium-Nutzer). Google-Test-IDs aktiv – müssen vor App-Store-Einreichung durch echte AdMob-IDs ersetzt werden.