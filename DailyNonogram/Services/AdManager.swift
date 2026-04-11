import GoogleMobileAds
import SwiftUI

/// Manages AdMob banner and interstitial ads.
///
/// **Setup for production:**
/// 1. Register at https://admob.google.com and create an app
/// 2. Replace `appID` in Info.plist key `GADApplicationIdentifier` with your real App ID
/// 3. Replace the placeholder unit IDs below with your real Ad Unit IDs from AdMob
///
/// Until replaced, Google's official test IDs are used (safe for development/TestFlight).
@MainActor
final class AdManager: NSObject, ObservableObject {

    // MARK: - Ad Unit IDs
    // Replace with real IDs from AdMob console before App Store submission

    static let bannerUnitID       = "ca-app-pub-1758574140088603/4561452330"
    static let interstitialUnitID = "ca-app-pub-1758574140088603/7574628484"

    // MARK: - State

    @Published var interstitialReady = false
    private var interstitial: GADInterstitialAd?

    // MARK: - Init

    override init() {
        super.init()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        Task { await loadInterstitial() }
    }

    // MARK: - Interstitial

    func loadInterstitial() async {
        do {
            let request = GADRequest()
            interstitial = try await GADInterstitialAd.load(
                withAdUnitID: Self.interstitialUnitID,
                request: request
            )
            interstitial?.fullScreenContentDelegate = self
            interstitialReady = true
        } catch {
            interstitialReady = false
        }
    }

    /// Shows the interstitial ad if ready. Call after puzzle completion (non-premium only).
    func showInterstitialIfReady(from rootVC: UIViewController) {
        guard let ad = interstitial, interstitialReady else { return }
        ad.present(fromRootViewController: rootVC)
    }
}

// MARK: - GADFullScreenContentDelegate

extension AdManager: GADFullScreenContentDelegate {
    nonisolated func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        Task { @MainActor in
            interstitialReady = false
            await loadInterstitial()
        }
    }
}
