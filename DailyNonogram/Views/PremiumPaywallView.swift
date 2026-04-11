import SwiftUI
import StoreKit

struct PremiumPaywallView: View {
    @EnvironmentObject private var store: StoreKitManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(DS.accent)
                        .padding(.top, 32)

                    Text("Daily Nonogram Premium")
                        .font(DS.titleFont())
                        .foregroundStyle(DS.textPrimary)

                    Text("Unbegrenzt Rätsel, keine Werbung")
                        .font(.system(size: 15))
                        .foregroundStyle(DS.textSecondary)
                        .padding(.bottom, 24)
                }

                Divider()

                // Feature List
                VStack(alignment: .leading, spacing: 16) {
                    featureRow(icon: "infinity", text: "Alle Rätsel freischalten")
                    featureRow(icon: "xmark.circle", text: "Keine Werbung")
                    featureRow(icon: "icloud.fill", text: "Fortschritt sichern")
                }
                .padding(24)

                Divider()

                // Purchase Options
                if store.isLoading {
                    ProgressView()
                        .padding(40)
                } else if store.products.isEmpty {
                    Text("Preise nicht verfügbar")
                        .foregroundStyle(DS.textSecondary)
                        .padding(40)
                } else {
                    VStack(spacing: 12) {
                        ForEach(store.products, id: \.id) { product in
                            purchaseButton(for: product)
                        }
                    }
                    .padding(24)
                }

                if let error = store.errorMessage {
                    Text(error)
                        .font(.system(size: 13))
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }

                // Restore Purchases
                Button("Käufe wiederherstellen") {
                    Task { await store.restorePurchases() }
                }
                .font(.system(size: 13))
                .foregroundStyle(DS.textSecondary)
                .padding(.bottom, 24)
            }
            .background(DS.background.ignoresSafeArea())
            .navigationTitle("Premium")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fertig") { dismiss() }
                        .foregroundStyle(DS.accent)
                }
            }
        }
    }

    // MARK: - Helpers

    private func purchaseButton(for product: Product) -> some View {
        Button {
            Task { await store.purchase(product) }
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(product.displayName)
                        .font(.system(size: 15, weight: .semibold))
                    Text(product.description)
                        .font(.system(size: 12))
                        .foregroundStyle(DS.textSecondary)
                }
                Spacer()
                Text(product.displayPrice)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(DS.accent)
            }
            .padding(16)
            .background(DS.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .disabled(store.isLoading)
    }

    private func featureRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(DS.accent)
                .frame(width: 24)
            Text(text)
                .font(.system(size: 15))
                .foregroundStyle(DS.textPrimary)
        }
    }
}
