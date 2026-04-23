import SwiftUI
import StoreKit

struct PremiumPaywallView: View {
    @EnvironmentObject private var store: StoreKitManager
    @Environment(\.dismiss) private var dismiss

    @State private var selectedProductID: String? = nil

    private var selectedProduct: Product? {
        store.products.first { $0.id == selectedProductID }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    Divider().padding(.horizontal, 24)
                    featuresSection
                    Divider().padding(.horizontal, 24)
                    productsSection
                    ctaSection
                }
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
            .onAppear {
                if selectedProductID == nil {
                    selectedProductID = store.products.first { $0.id == StoreKitManager.yearlyID }?.id
                        ?? store.products.first?.id
                }
            }
            .onChange(of: store.products) { _, products in
                if selectedProductID == nil || !products.map(\.id).contains(selectedProductID ?? "") {
                    selectedProductID = products.first { $0.id == StoreKitManager.yearlyID }?.id
                        ?? products.first?.id
                }
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "crown.fill")
                .font(.system(size: 44))
                .foregroundStyle(DS.accent)
                .padding(.top, 28)

            Text("Daily Nonogram Premium")
                .font(DS.titleFont())
                .foregroundStyle(DS.textPrimary)

            Text("Mehr Rätsel, keine Werbung")
                .font(.system(size: 15))
                .foregroundStyle(DS.textSecondary)
                .padding(.bottom, 20)
        }
    }

    // MARK: - Features

    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            featureRow(icon: "xmark.circle.fill", text: "Keine Werbung", active: true)
            featureRow(icon: "calendar", text: "Alle Rätsel der letzten 7 Tage", active: true)
            featureRow(icon: "wand.and.stars", text: "Auto-Lösen", active: true)
            featureRow(icon: "paintpalette.fill", text: "Bald: Farbige Nonogramme", active: false)
        }
        .padding(24)
    }

    private func featureRow(icon: String, text: String, active: Bool) -> some View {
        HStack(spacing: 12) {
            Image(systemName: active ? "checkmark.circle.fill" : "circle.dotted")
                .foregroundStyle(active ? DS.accent : DS.textTertiary)
                .frame(width: 22)
            Text(text)
                .font(.system(size: 15))
                .foregroundStyle(active ? DS.textPrimary : DS.textTertiary)
        }
    }

    // MARK: - Products

    private var productsSection: some View {
        Group {
            if store.isLoading {
                ProgressView().padding(40)
            } else if store.products.isEmpty {
                Text("Preise nicht verfügbar")
                    .foregroundStyle(DS.textSecondary)
                    .padding(40)
            } else {
                VStack(spacing: 10) {
                    ForEach(sortedProducts, id: \.id) { product in
                        productRow(product)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
            }
        }
    }

    private var sortedProducts: [Product] {
        let order = [StoreKitManager.yearlyID, StoreKitManager.monthlyID, StoreKitManager.lifetimeID]
        return store.products.sorted { a, b in
            let ai = order.firstIndex(of: a.id) ?? 99
            let bi = order.firstIndex(of: b.id) ?? 99
            return ai < bi
        }
    }

    @ViewBuilder
    private func productRow(_ product: Product) -> some View {
        let isYearly = product.id == StoreKitManager.yearlyID
        let isSelected = selectedProductID == product.id

        Button { selectedProductID = product.id } label: {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(productLabel(product))
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(DS.textPrimary)
                        if isYearly {
                            Text("⭐ Beliebteste Wahl")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 7)
                                .padding(.vertical, 3)
                                .background(DS.accent)
                                .clipShape(Capsule())
                        }
                    }
                    Text(productSubtitle(product))
                        .font(.system(size: 12))
                        .foregroundStyle(DS.textSecondary)
                }
                Spacer()
                Text(product.displayPrice)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(isSelected ? DS.accent : DS.textSecondary)
            }
            .padding(16)
            .background(isSelected ? DS.accent.opacity(0.10) : DS.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? DS.accent : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }

    private func productLabel(_ product: Product) -> String {
        switch product.id {
        case StoreKitManager.yearlyID:   return "Jährlich"
        case StoreKitManager.monthlyID:  return "Monatlich"
        case StoreKitManager.lifetimeID: return "Einmalig"
        default: return product.displayName
        }
    }

    private func productSubtitle(_ product: Product) -> String {
        switch product.id {
        case StoreKitManager.yearlyID:   return "pro Jahr – spare bis zu 37 %"
        case StoreKitManager.monthlyID:  return "pro Monat"
        case StoreKitManager.lifetimeID: return "einmalige Zahlung, für immer"
        default: return product.description
        }
    }

    // MARK: - CTA

    private var ctaSection: some View {
        VStack(spacing: 12) {
            if let error = store.errorMessage {
                Text(error)
                    .font(.system(size: 13))
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }

            Button {
                guard let product = selectedProduct else { return }
                Task { await store.purchase(product) }
            } label: {
                HStack {
                    if store.isLoading {
                        ProgressView().tint(.white)
                    } else {
                        Text(ctaLabel)
                            .font(.system(size: 16, weight: .bold))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(DS.accent)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)
            .disabled(store.isLoading || selectedProduct == nil)
            .padding(.horizontal, 24)

            Button("Käufe wiederherstellen") {
                Task { await store.restorePurchases() }
            }
            .font(.system(size: 13))
            .foregroundStyle(DS.textSecondary)
            .padding(.bottom, 28)
        }
        .padding(.top, 8)
    }

    private var ctaLabel: String {
        guard let product = selectedProduct else { return "Jetzt kaufen" }
        return "Jetzt kaufen – \(product.displayPrice)"
    }
}
