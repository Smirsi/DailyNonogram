import SwiftUI

@main
struct DailyNonogramApp: App {
    @StateObject private var store = StoreKitManager()
    @StateObject private var ads = AdManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(ads)
        }
    }
}
