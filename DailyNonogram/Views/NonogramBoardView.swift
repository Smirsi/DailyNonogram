import SwiftUI

struct NonogramBoardView: View {
    @ObservedObject var vm: NonogramViewModel
    var onChangeDifficulty: (() -> Void)? = nil

    @AppStorage("showCluesBothSides") private var showCluesBothSides = false
    @State private var showSettings = false
    @State private var showPremiumTeaser = false
    @State private var showPaywall = false
    @State private var pendingCompletion = false
    @State private var archiveSelection: ArchiveDateSelection? = nil
    @State private var streak: Int = 0
    @State private var showSolveConfirm = false

    @EnvironmentObject private var store: StoreKitManager
    @EnvironmentObject private var ads: AdManager

    private let cellSize: CGFloat = 36
    @State private var scale: CGFloat = 1.0
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
            ZStack(alignment: .top) {
                VStack(spacing: 4) {
                    Text(vm.nonogram.title)
                        .font(DS.titleFont())
                        .foregroundStyle(DS.textPrimary)
                    Text(formattedDate())
                        .font(DS.dateLabelFont())
                        .foregroundStyle(DS.textSecondary)
                    if let change = onChangeDifficulty {
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

                HStack {
                    Button { onChangeDifficulty?() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .light))
                            .foregroundStyle(DS.textSecondary)
                    }
                    .buttonStyle(.plain)
                    Spacer()
                    Button { showSettings = true } label: {
                        Image(systemName: "gearshape")
                            .font(.system(size: 18, weight: .light))
                            .foregroundStyle(DS.textSecondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 8)

            Rectangle().fill(DS.separator).frame(height: 0.5).padding(.horizontal, 16).padding(.top, 12)

            WeekProgressView(
                streak: streak,
                onSelectPastDay: { date in
                    if store.isPremium { archiveSelection = ArchiveDateSelection(date: date) }
                    else { showPaywall = true }
                }
            )

            Rectangle().fill(DS.separator).frame(height: 0.5).padding(.horizontal, 16).padding(.bottom, 16)

            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Color.clear.frame(width: rowClueWidth, height: colClueHeight)
                        ColCluesView(clues: vm.nonogram.colClues, cellSize: effectiveCellSize,
                                     checkedClues: vm.checkedColClues).frame(height: colClueHeight)
                        if showCluesBothSides {
                            Color.clear.frame(width: rowClueWidth, height: colClueHeight)
                        }
                    }
                    HStack(alignment: .top, spacing: 0) {
                        RowCluesView(clues: vm.nonogram.rowClues, cellSize: effectiveCellSize,
                                     checkedClues: vm.checkedRowClues).frame(width: rowClueWidth)
                        NonogramGridView(vm: vm, cellSize: cellSize, scale: $scale, liveScale: $liveScale)
                        if showCluesBothSides {
                            RowCluesView(clues: vm.nonogram.rowClues, cellSize: effectiveCellSize,
                                         checkedClues: vm.checkedRowClues, alignRight: false)
                                .frame(width: rowClueWidth)
                        }
                    }
                    if showCluesBothSides {
                        HStack(spacing: 0) {
                            Color.clear.frame(width: rowClueWidth, height: colClueHeight)
                            ColCluesView(clues: vm.nonogram.colClues, cellSize: effectiveCellSize,
                                         checkedClues: vm.checkedColClues, alignBottom: false)
                                .frame(height: colClueHeight)
                            Color.clear.frame(width: rowClueWidth, height: colClueHeight)
                        }
                    }
                }
                .padding(16)
            }

            // Action buttons row
            actionButtonsRow
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 4)

            // Draw tools
            ToolbarView(currentTool: $vm.currentTool)
                .padding(.top, 8)
        }
        .padding()
        .background(DS.background.ignoresSafeArea())
        .onAppear {
            streak = StreakService.currentStreak()
            checkFreezeOpportunity()
        }
        .onChange(of: vm.showCompletion) { _, isShowing in
            guard isShowing else { return }
            streak = StreakService.currentStreak()
            if !store.isPremium {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let rootVC = windowScene.windows.first?.rootViewController else {
                    pendingCompletion = true; return
                }
                ads.showInterstitialIfReady(from: rootVC) { pendingCompletion = true }
            } else {
                pendingCompletion = true
            }
        }
        .sheet(isPresented: $showSettings) { SettingsView() }
        .overlay {
            if pendingCompletion {
                CompletionOverlayView(nonogram: vm.nonogram, streak: streak, onDismiss: {
                    pendingCompletion = false
                    vm.showCompletion = false
                    streak = StreakService.currentStreak()
                    if !store.isPremium {
                        if PremiumTeaserService.shouldShow(isPremium: false) {
                            PremiumTeaserService.markShown(); showPremiumTeaser = true
                        }
                    } else if PremiumTeaserService.shouldShow(isPremium: true) {
                        PremiumTeaserService.markShown(); showPremiumTeaser = true
                    }
                })
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .overlay {
            if showPremiumTeaser {
                PremiumTeaserView(
                    onUpgrade: { showPremiumTeaser = false; showPaywall = true },
                    onDismiss: { showPremiumTeaser = false }
                )
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .sheet(isPresented: $showPaywall) { PremiumPaywallView() }
        .sheet(item: $archiveSelection) { selection in
            ArchivePuzzleSheet(date: selection.date, difficulty: vm.nonogram.difficulty)
        }
        .confirmationDialog("Puzzle lösen?", isPresented: $showSolveConfirm, titleVisibility: .visible) {
            Button("Lösen (kostet 1 Freeze)") { performSolve() }
            Button("Abbrechen", role: .cancel) {}
        } message: {
            Text("Das Puzzle wird vollständig gelöst. Du verlierst 1 Streak-Freeze und kannst danach keine Hints mehr nutzen.")
        }
        .animation(.easeOut(duration: 0.3), value: pendingCompletion)
        .animation(.easeOut(duration: 0.3), value: showPremiumTeaser)
    }

    // MARK: - Action Buttons

    private var actionButtonsRow: some View {
        HStack(spacing: 16) {
            // Undo
            actionButton(icon: "arrow.uturn.backward", label: "Undo", enabled: vm.canUndo) {
                withAnimation(.easeOut(duration: 0.15)) { vm.undo() }
            }

            // Redo
            actionButton(icon: "arrow.uturn.forward", label: "Redo", enabled: vm.canRedo) {
                withAnimation(.easeOut(duration: 0.15)) { vm.redo() }
            }

            Spacer()

            // Hint (all users, requires rewarded ad; Debug: always active)
            if !vm.hintsBlocked {
                #if DEBUG
                let hintEnabled = true
                #else
                let hintEnabled = ads.hintRewardedReady
                #endif
                actionButton(icon: "lightbulb", label: "Hint", enabled: hintEnabled) {
                    showHintAd()
                }
            }

            // Error Reveal (premium only, requires ad)
            if store.isPremium {
                actionButton(icon: "eye", label: "Fehler", enabled: ads.errorRevealReady) {
                    showErrorRevealAd()
                }
            }

            // Auto-Solve (premium only, costs freeze)
            if store.isPremium {
                let freezesLeft = StreakService.availableFreezes(isPremium: true)
                actionButton(icon: "wand.and.stars", label: "Lösen", enabled: freezesLeft > 0) {
                    showSolveConfirm = true
                }
            }
        }
    }

    @ViewBuilder
    private func actionButton(icon: String, label: String, enabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .light))
                Text(label)
                    .font(.system(size: 10, weight: .medium))
            }
            .foregroundStyle(enabled ? DS.textSecondary : DS.textTertiary)
            .frame(width: 48, height: 40)
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
    }

    // MARK: - Ad Actions

    private func showHintAd() {
        #if DEBUG
        vm.applyHint()
        #else
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else { return }
        ads.showHintAdIfReady(from: rootVC) { vm.applyHint() }
        #endif
    }

    private func showErrorRevealAd() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else { return }
        ads.showErrorRevealAdIfReady(from: rootVC) { vm.applyErrors(max: 5) }
    }

    // MARK: - Solve

    private func performSolve() {
        let spent = StreakService.spendFreezeForSolve(isPremium: store.isPremium)
        guard spent else { return }
        vm.applySolve()
        streak = StreakService.currentStreak()
    }

    // MARK: - Helpers

    private func formattedDate() -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "de_DE")
        f.dateStyle = .long
        f.timeStyle = .none
        return f.string(from: DailyPuzzleService.today())
    }

    private func checkFreezeOpportunity() {
        guard StreakService.canApplyFreezeForYesterday(isPremium: store.isPremium) else { return }
        let key = "freezeAutoApplied_\(DailyPuzzleService.dateString(for: DailyPuzzleService.today()))"
        guard !UserDefaults.standard.bool(forKey: key) else { return }
        UserDefaults.standard.set(true, forKey: key)
        let cal = Calendar.current
        let yesterday = cal.date(byAdding: .day, value: -1, to: DailyPuzzleService.today())!
        StreakService.applyFreeze(for: yesterday, isPremium: store.isPremium)
        streak = StreakService.currentStreak()
    }
}
