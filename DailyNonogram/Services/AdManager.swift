import GoogleMobileAds
import SwiftUI

/// Manages AdMob interstitial and rewarded video ads.
///
/// **Setup for production:**
/// 1. Register at https://admob.google.com and create an app
/// 2. Replace `appID` in Info.plist key `GADApplicationIdentifier` with your real App ID
/// 3. Replace the placeholder unit IDs below with your real Ad Unit IDs from AdMob
@MainActor
final class AdManager: NSObject, ObservableObject {

    // MARK: - Ad Unit IDs

    static let interstitialUnitID = "ca-app-pub-1758574140088603/7992491536"
    static let rewardedUnitID     = "ca-app-pub-1758574140088603/9876543210"

    // MARK: - State

    @Published var interstitialReady = false
    @Published var rewardedReady = false

    private var interstitial: GADInterstitialAd?
    private var rewarded: GADRewardedAd?
    private var interstitialDismissCallback: (() -> Void)?

    // MARK: - Init

    override init() {
        super.init()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        Task {
            await loadInterstitial()
            await loadRewarded()
        }
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

    /// Shows the interstitial if ready. `onDismiss` is called after the ad closes (or immediately if not ready).
    func showInterstitialIfReady(from rootVC: UIViewController, onDismiss: (() -> Void)? = nil) {
        guard let ad = interstitial, interstitialReady else {
            onDismiss?()
            return
        }
        interstitialDismissCallback = onDismiss
        ad.present(fromRootViewController: rootVC)
    }

    // MARK: - Rewarded Video

    func loadRewarded() async {
        do {
            let request = GADRequest()
            rewarded = try await GADRewardedAd.load(
                withAdUnitID: Self.rewardedUnitID,
                request: request
            )
            rewarded?.fullScreenContentDelegate = self
            rewardedReady = true
        } catch {
            rewardedReady = false
        }
    }

    /// Shows a rewarded video. `onReward` is called when the user earns the reward.
    func showRewardedIfReady(from rootVC: UIViewController, onReward: @escaping () -> Void) {
        guard let ad = rewarded, rewardedReady else { return }
        rewardedReady = false
        ad.present(fromRootViewController: rootVC) { [weak self] in
            onReward()
            Task { await self?.loadRewarded() }
        }
    }
}

// MARK: - GADFullScreenContentDelegate

extension AdManager: GADFullScreenContentDelegate {
    nonisolated func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        Task { @MainActor in
            // If an interstitial dismiss callback is set, this is an interstitial dismissal
            if interstitialDismissCallback != nil || !interstitialReady {
                interstitialReady = false
                let cb = interstitialDismissCallback
                interstitialDismissCallback = nil
                await loadInterstitial()
                cb?()
            }
        }
    }

    nonisolated func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        Task { @MainActor in
            if interstitialDismissCallback != nil {
                let cb = interstitialDismissCallback
                interstitialDismissCallback = nil
                cb?()
            }
        }
    }
}
