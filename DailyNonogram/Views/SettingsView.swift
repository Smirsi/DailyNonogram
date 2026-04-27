import SwiftUI

struct SettingsView: View {
    @AppStorage("showCluesBothSides") var showCluesBothSides = false
    @AppStorage("autoX") var autoX = false
    @AppStorage("autoCheckmark") var autoCheckmark = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false

    @EnvironmentObject private var store: StoreKitManager
    @Environment(\.dismiss) private var dismiss
    @State private var showPaywall = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Anzeige") {
                    Toggle("Hinweise auf beiden Seiten", isOn: $showCluesBothSides)
                }

                Section("Automatisierung") {
                    Toggle("Automatisches X", isOn: $autoX)
                    Toggle("Automatisches Abhaken", isOn: $autoCheckmark)
                }

                Section("Benachrichtigungen") {
                    Toggle("Tägliche Erinnerung (8:00 Uhr)", isOn: $notificationsEnabled)
                        .onChange(of: notificationsEnabled) { _, enabled in
                            NotificationManager.shared.isEnabled = enabled
                        }
                }

                if store.isPremium {
                    Section("Streak") {
                        HStack {
                            Label("Streak Freezes", systemImage: "snowflake")
                            Spacer()
                            Text("\(StreakService.availableFreezes(isPremium: true))")
                                .foregroundStyle(DS.textSecondary)
                                .font(.system(size: 14, design: .monospaced))
                        }
                        Text("Du erhältst nach je 7 gespielten Tagen in Folge einen Freeze-Token. Ein Freeze schützt deinen Streak für einen verpassten Tag.")
                            .font(.system(size: 12))
                            .foregroundStyle(DS.textTertiary)
                    }
                }

                Section {
                    Button {
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            NotificationCenter.default.post(name: .showTutorial, object: nil)
                        }
                    } label: {
                        Label("Tutorial erneut ansehen", systemImage: "questionmark.circle")
                            .foregroundStyle(DS.accent)
                    }
                }

                #if DEBUG
                Section("Debug") {
                    Toggle("Premium aktivieren (Test)", isOn: Binding(
                        get: { store.isPremium },
                        set: { store.setDebugPremium($0) }
                    ))
                }
                #endif

                Section("Premium") {
                    if store.isPremium {
                        Label("Premium aktiv", systemImage: "crown.fill")
                            .foregroundStyle(DS.accent)
                    } else {
                        Button {
                            showPaywall = true
                        } label: {
                            HStack {
                                Label("Premium freischalten", systemImage: "crown")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12))
                                    .foregroundStyle(DS.textTertiary)
                            }
                        }
                        .foregroundStyle(DS.accent)
                    }
                    if let freezeProduct = store.freezeTokenProduct {
                        Button {
                            Task { await store.purchase(freezeProduct) }
                        } label: {
                            Label(
                                String(format: String(localized: "3 Freeze kaufen – %@"), freezeProduct.displayPrice),
                                systemImage: "snowflake"
                            )
                        }
                        .foregroundStyle(DS.accent)
                    }
                }
            }
            .navigationTitle("Einstellungen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Fertig") { dismiss() }
                }
            }
            .sheet(isPresented: $showPaywall) {
                PremiumPaywallView()
                    .environmentObject(store)
            }
        }
    }
}

#Preview {
    SettingsView()
}
