import GoogleMobileAds
import SwiftUI

/// A SwiftUI wrapper around `GADBannerView` for displaying AdMob banner ads.
/// Only shown to non-premium users.
struct BannerAdView: UIViewRepresentable {
    let adUnitID: String

    func makeUIView(context: Context) -> GADBannerView {
        let banner = GADBannerView(adSize: GADAdSizeBanner)
        banner.adUnitID = adUnitID
        banner.rootViewController = context.coordinator.rootViewController()
        banner.load(GADRequest())
        return banner
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator() }

    final class Coordinator {
        func rootViewController() -> UIViewController? {
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }?
                .rootViewController
        }
    }
}

// MARK: - Preview Placeholder

/// Shown instead of real ad in previews / when AdMob is not yet configured.
struct BannerAdPlaceholderView: View {
    var body: some View {
        Rectangle()
            .fill(DS.surface)
            .frame(height: 50)
            .overlay(
                Text("Werbung")
                    .font(DS.clueFont())
                    .foregroundStyle(DS.textTertiary)
            )
    }
}
