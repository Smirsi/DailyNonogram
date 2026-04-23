import SwiftUI

@main
struct DailyNonogramApp: App {
    @StateObject private var store = StoreKitManager()
    @StateObject private var ads = AdManager()

    init() {
        UserDefaults.standard.register(defaults: [
            "showCluesBothSides": true,
            "autoX": true,
            "autoCheckmark": true
        ])
        TimeService.shared.syncIfNeeded()
        NotificationManager.shared.requestPermissionAndScheduleIfNeeded()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(ads)
        }
    }
}
