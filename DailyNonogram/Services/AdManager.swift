import GoogleMobileAds
import SwiftUI

/// Manages AdMob interstitial and rewarded video ads.
@MainActor
final class AdManager: NSObject, ObservableObject {

    // MARK: - Ad Unit IDs

    #if DEBUG
    static let interstitialUnitID        = "ca-app-pub-3940256099942544/4411468910"
    static let rewardedUnitID            = "ca-app-pub-3940256099942544/1712485313"
    static let rewardedHintUnitID        = "ca-app-pub-3940256099942544/1712485313"
    static let rewardedErrorRevealUnitID = "ca-app-pub-3940256099942544/1712485313"
    #else
    static let interstitialUnitID        = "ca-app-pub-1758574140088603/7574628484"
    static let rewardedUnitID            = "ca-app-pub-1758574140088603/7992491536"
    static let rewardedHintUnitID        = "ca-app-pub-1758574140088603/3275878139"
    static let rewardedErrorRevealUnitID = "ca-app-pub-1758574140088603/4321366497"
    #endif

    // MARK: - State

    @Published var interstitialReady = false
    @Published var rewardedReady = false
    @Published var hintRewardedReady = false
    @Published var errorRevealReady = false

    private var interstitial: GADInterstitialAd?
    private var rewarded: GADRewardedAd?
    private var hintRewarded: GADRewardedAd?
    private var errorRevealRewarded: GADRewardedAd?
    private var interstitialDismissCallback: (() -> Void)?

    // MARK: - Init

    override init() {
        super.init()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        Task {
            await loadInterstitial()
            await loadRewarded()
            await loadHintRewarded()
            await loadErrorRevealRewarded()
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

    func showInterstitialIfReady(from rootVC: UIViewController, onDismiss: (() -> Void)? = nil) {
        guard let ad = interstitial, interstitialReady else {
            onDismiss?()
            return
        }
        interstitialDismissCallback = onDismiss
        ad.present(fromRootViewController: rootVC)
    }

    // MARK: - Rewarded (puzzle unlock)

    func loadRewarded() async {
        do {
            let request = GADRequest()
            rewarded = try await GADRewardedAd.load(
                withAdUnitID: Self.rewardedUnitID,
                request: request
            )
            rewardedReady = true
        } catch {
            rewardedReady = false
        }
    }

    func showRewardedIfReady(from rootVC: UIViewController, onReward: @escaping () -> Void) {
        guard let ad = rewarded, rewardedReady else {
            onReward()  // fallback: no ad available, proceed anyway
            return
        }
        rewardedReady = false
        ad.present(fromRootViewController: rootVC) { [weak self] in
            onReward()
            Task { await self?.loadRewarded() }
        }
    }

    // MARK: - Rewarded Hint

    func loadHintRewarded() async {
        do {
            let request = GADRequest()
            hintRewarded = try await GADRewardedAd.load(
                withAdUnitID: Self.rewardedHintUnitID,
                request: request
            )
            hintRewardedReady = true
        } catch {
            hintRewardedReady = false
        }
    }

    func showHintAdIfReady(from rootVC: UIViewController, onReward: @escaping () -> Void) {
        guard let ad = hintRewarded, hintRewardedReady else { return }
        hintRewardedReady = false
        ad.present(fromRootViewController: rootVC) { [weak self] in
            onReward()
            Task { await self?.loadHintRewarded() }
        }
    }

    // MARK: - Rewarded Error Reveal

    func loadErrorRevealRewarded() async {
        do {
            let request = GADRequest()
            errorRevealRewarded = try await GADRewardedAd.load(
                withAdUnitID: Self.rewardedErrorRevealUnitID,
                request: request
            )
            errorRevealReady = true
        } catch {
            errorRevealReady = false
        }
    }

    func showErrorRevealAdIfReady(from rootVC: UIViewController, onReward: @escaping () -> Void) {
        guard let ad = errorRevealRewarded, errorRevealReady else { return }
        errorRevealReady = false
        ad.present(fromRootViewController: rootVC) { [weak self] in
            onReward()
            Task { await self?.loadErrorRevealRewarded() }
        }
    }
}

// MARK: - GADFullScreenContentDelegate

extension AdManager: GADFullScreenContentDelegate {
    nonisolated func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        Task { @MainActor in
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
