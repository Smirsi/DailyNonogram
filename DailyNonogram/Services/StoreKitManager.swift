import StoreKit
import SwiftUI

/// Manages in-app purchases via StoreKit 2.
///
/// **Setup for production:**
/// Replace the placeholder product IDs below with your real App Store Connect product IDs,
/// then configure the products in App Store Connect.
@MainActor
final class StoreKitManager: ObservableObject {

    // MARK: - Product IDs (replace with real IDs from App Store Connect)

    static let monthlyID  = "com.adept.dailynonogram.premium.monthly"
    static let yearlyID   = "com.adept.dailynonogram.premium.yearly"
    static let lifetimeID = "com.adept.dailynonogram.premium.lifetime"

    static let allProductIDs: Set<String> = [monthlyID, yearlyID, lifetimeID]

    // MARK: - Published State

    @Published var products: [Product] = []
    @Published var isPremium: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    // MARK: - Private

    private var transactionListener: Task<Void, Never>?
    private let premiumKey = "isPremiumCached"

    // MARK: - Init / Deinit

    init() {
        isPremium = UserDefaults.standard.bool(forKey: premiumKey)
        transactionListener = listenForTransactions()
        Task { await loadProducts() }
    }

    deinit {
        transactionListener?.cancel()
    }

    // MARK: - Public API

    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }
        do {
            products = try await Product.products(for: Self.allProductIDs)
                .sorted { $0.price < $1.price }
        } catch {
            errorMessage = String(format: String(localized: "Produkte konnten nicht geladen werden: %@"), error.localizedDescription)
        }
        await updatePremiumStatus()
    }

    func purchase(_ product: Product) async {
        isLoading = true
        defer { isLoading = false }
        errorMessage = nil
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()
                await updatePremiumStatus()
            case .userCancelled:
                break
            case .pending:
                break
            @unknown default:
                break
            }
        } catch {
            errorMessage = String(format: String(localized: "Kauf fehlgeschlagen: %@"), error.localizedDescription)
        }
    }

    func restorePurchases() async {
        isLoading = true
        defer { isLoading = false }
        do {
            try await AppStore.sync()
            await updatePremiumStatus()
        } catch {
            errorMessage = String(format: String(localized: "Wiederherstellen fehlgeschlagen: %@"), error.localizedDescription)
        }
    }

    // MARK: - Private

    private func updatePremiumStatus() async {
        var hasPremium = false
        for await result in Transaction.currentEntitlements {
            if let transaction = try? checkVerified(result),
               Self.allProductIDs.contains(transaction.productID) {
                hasPremium = true
                break
            }
        }
        isPremium = hasPremium
        UserDefaults.standard.set(hasPremium, forKey: premiumKey)
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }

    private func listenForTransactions() -> Task<Void, Never> {
        Task(priority: .background) {
            for await result in Transaction.updates {
                if let transaction = try? checkVerified(result) {
                    await transaction.finish()
                    await updatePremiumStatus()
                }
            }
        }
    }

    #if DEBUG
    func setDebugPremium(_ value: Bool) {
        isPremium = value
        UserDefaults.standard.set(value, forKey: premiumKey)
    }
    #endif

    enum StoreError: Error {
        case failedVerification
    }
}
