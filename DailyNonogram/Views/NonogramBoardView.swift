import SwiftUI

struct NonogramBoardView: View {
    @ObservedObject var vm: NonogramViewModel
    /// Called when a premium user wants to switch difficulty. `nil` for free users (locked).
    var onChangeDifficulty: (() -> Void)? = nil

    @AppStorage("showCluesBothSides") private var showCluesBothSides = false
    @State private var showSettings = false
    @State private var showPremiumTeaser = false
    @State private var showPaywall = false

    @EnvironmentObject private var store: StoreKitManager

    /// Base cell size — zoom is applied on top of this
    private let cellSize: CGFloat = 36
    /// Persisted zoom level (set when pinch ends)
    @State private var scale: CGFloat = 1.0
    /// Live zoom level (updated every gesture frame, shared with CluesView)
    @State private var liveScale: CGFloat = 1.0

    private var effectiveCellSize: CGFloat { cellSize * liveScale }

    var rowClueWidth: CGFloat {
        let maxCount = vm.nonogram.rowClues.map(\.count).max() ?? 1
        return CGFloat(maxCount) * 18 * liveScale + 8
    }

    var colClueHeight: CGFloat {
        let maxCount = vm.nonogram.colClues.map(\.count).max() ?? 1
        return CGFloat(maxCount) * 18 * liveScale + 8
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 4) {
                    Text(vm.nonogram.title)
                        .font(DS.titleFont())
                        .foregroundStyle(DS.textPrimary)
                    Text(formattedDate())
                        .font(DS.dateLabelFont())
                        .foregroundStyle(DS.textSecondary)
                    if let change = onChangeDifficulty {
                        // Premium: difficulty badge is tappable to switch
                        Button(action: change) {
                            Text(vm.nonogram.difficulty.displayName)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(DS.accent)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 3)
                                .background(DS.accent.opacity(0.12))
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    } else {
                        Text(vm.nonogram.difficulty.displayName)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(DS.accent)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 3)
                            .background(DS.accent.opacity(0.12))
                            .clipShape(Capsule())
                    }
                }
                .frame(maxWidth: .infinity)

                Button {
                    showSettings = true
                } label: {
                    Image(systemName: "gearshape")
                        .font(.system(size: 18, weight: .light))
                        .foregroundStyle(DS.textSecondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 8)

            Rectangle()
                .fill(DS.separator)
                .frame(height: 0.5)
                .padding(.horizontal, 16)
                .padding(.top, 12)

            WeekProgressView()

            Rectangle()
                .fill(DS.separator)
                .frame(height: 0.5)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)

            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                VStack(spacing: 0) {
                    // Top row: corner(s) + column clues + corner(s)
                    HStack(spacing: 0) {
                        Color.clear.frame(width: rowClueWidth, height: colClueHeight)
                        ColCluesView(clues: vm.nonogram.colClues,
                                     cellSize: effectiveCellSize,
                                     checkedClues: vm.checkedColClues)
                            .frame(height: colClueHeight)
                        if showCluesBothSides {
                            Color.clear.frame(width: rowClueWidth, height: colClueHeight)
                        }
                    }

                    // Middle row: row clues + grid + (optional right clues)
                    HStack(alignment: .top, spacing: 0) {
                        RowCluesView(clues: vm.nonogram.rowClues,
                                     cellSize: effectiveCellSize,
                                     checkedClues: vm.checkedRowClues)
                            .frame(width: rowClueWidth)

                        NonogramGridView(vm: vm, cellSize: cellSize, scale: $scale, liveScale: $liveScale)

                        if showCluesBothSides {
                            RowCluesView(clues: vm.nonogram.rowClues,
                                         cellSize: effectiveCellSize,
                                         checkedClues: vm.checkedRowClues,
                                         alignRight: false)
                                .frame(width: rowClueWidth)
                        }
                    }

                    // Optional bottom column clues
                    if showCluesBothSides {
                        HStack(spacing: 0) {
                            Color.clear.frame(width: rowClueWidth, height: colClueHeight)
                            ColCluesView(clues: vm.nonogram.colClues,
                                         cellSize: effectiveCellSize,
                                         checkedClues: vm.checkedColClues,
                                         alignBottom: false)
                                .frame(height: colClueHeight)
                            Color.clear.frame(width: rowClueWidth, height: colClueHeight)
                        }
                    }
                }
                .padding(16)
            }

            // Toolbar
            ToolbarView(currentTool: $vm.currentTool)
                .padding(.top, 16)

            // Banner Ad (non-premium only)
            if !store.isPremium {
                BannerAdView(adUnitID: AdManager.bannerUnitID)
                    .frame(height: 50)
            }
        }
        .padding()
        .background(DS.background.ignoresSafeArea())
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .overlay {
            if vm.showCompletion {
                CompletionOverlayView(
                    puzzleTitle: vm.nonogram.title,
                    onDismiss: {
                        vm.showCompletion = false
                        if PremiumTeaserService.shouldShow(isPremium: store.isPremium) {
                            PremiumTeaserService.markShown()
                            showPremiumTeaser = true
                        }
                    }
                )
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .overlay {
            if showPremiumTeaser {
                PremiumTeaserView(
                    onUpgrade: {
                        showPremiumTeaser = false
                        showPaywall = true
                    },
                    onDismiss: { showPremiumTeaser = false }
                )
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .sheet(isPresented: $showPaywall) {
            PremiumPaywallView()
        }
        .animation(.easeOut(duration: 0.3), value: vm.showCompletion)
        .animation(.easeOut(duration: 0.3), value: showPremiumTeaser)
    }

    private func formattedDate() -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "de_DE")
        f.dateStyle = .long
        f.timeStyle = .none
        return f.string(from: DailyPuzzleService.today())
    }
}
