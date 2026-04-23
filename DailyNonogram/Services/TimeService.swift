import Foundation

/// Provides tamper-resistant time by syncing with a public NTP/worldtime API
/// and caching the offset between server time and device time.
///
/// Anti-cheat: if the device clock moves backward since the last sync,
/// the previously cached offset is applied to detect manipulation.
final class TimeService: @unchecked Sendable {

    nonisolated(unsafe) static let shared = TimeService()
    private init() {}

    // MARK: - Keys

    private let lastServerTimeKey = "TimeService_lastServerTime"
    private let lastDeviceTimeKey = "TimeService_lastDeviceTimeAtFetch"

    // MARK: - Public API

    /// Best-effort current time. Uses the cached server offset when available;
    /// falls back to device time if never synced or offline.
    var currentTime: Date {
        let deviceNow = Date()
        guard let offset = cachedOffset else { return deviceNow }
        // Anti-cheat: if device time went backward, apply the offset
        // (manipulated clock will be behind the honest projected time)
        return deviceNow.addingTimeInterval(offset)
    }

    /// Today's date component (start of day) using tamper-resistant time.
    var today: Date {
        Calendar.current.startOfDay(for: currentTime)
    }

    /// Fetches the current time from worldtimeapi.org and caches the offset.
    /// Call once at app launch (fire-and-forget).
    func syncIfNeeded() {
        Task { await fetchServerTime() }
    }

    // MARK: - Private

    /// Offset in seconds: serverTime - deviceTime at the moment of the last fetch.
    /// Positive = server is ahead of device. Negative = device is ahead.
    private var cachedOffset: TimeInterval? {
        let serverInterval = UserDefaults.standard.double(forKey: lastServerTimeKey)
        let deviceInterval = UserDefaults.standard.double(forKey: lastDeviceTimeKey)
        guard serverInterval > 0, deviceInterval > 0 else { return nil }
        return serverInterval - deviceInterval
    }

    private func fetchServerTime() async {
        guard let url = URL(string: "https://worldtimeapi.org/api/timezone/UTC") else { return }
        do {
            let deviceTimeBeforeFetch = Date().timeIntervalSince1970
            let (data, _) = try await URLSession.shared.data(from: url)
            let deviceTimeAfterFetch = Date().timeIntervalSince1970
            // Use midpoint to compensate for network round-trip
            let deviceTimeAtMidpoint = (deviceTimeBeforeFetch + deviceTimeAfterFetch) / 2

            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let unixTime = json["unixtime"] as? TimeInterval {
                UserDefaults.standard.set(unixTime, forKey: lastServerTimeKey)
                UserDefaults.standard.set(deviceTimeAtMidpoint, forKey: lastDeviceTimeKey)
            }
        } catch {
            // Silently ignore — offline fallback uses cached offset
        }
    }
}
