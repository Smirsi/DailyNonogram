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
    @State private var wronglyCompleteDismissed = false

    @EnvironmentObject private var store: StoreKitManager
    @EnvironmentObject private var ads: AdManager

    private let cellSize: CGFloat = 36
    private let minScale: CGFloat = 0.3
    private let maxScale: CGFloat = 3.0
    @State private var scale: CGFloat = 1.0
    @State private var liveScale: CGFloat = 1.0
    @State private var isPinching = false

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
                        NonogramGridView(vm: vm, cellSize: cellSize, scale: $scale,
                                         liveScale: $liveScale, isPinching: $isPinching)
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
            .background(
                GeometryReader { geo in
                    Color.clear.onAppear { computeInitialScale(available: geo.size) }
                }
            )
            .simultaneousGesture(
                MagnificationGesture()
                    .onChanged { value in
                        isPinching = true
                        liveScale = min(maxScale, max(minScale, scale * value))
                    }
                    .onEnded { value in
                        scale = min(maxScale, max(minScale, scale * value))
                        liveScale = scale
                        isPinching = false
                    }
            )

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
            vm.resetHints(isPremium: store.isPremium)
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
        .overlay(alignment: .bottom) {
            if vm.isWronglyComplete && !wronglyCompleteDismissed {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                    Text("Noch nicht korrekt – überprüfe deine Antworten.")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(DS.textPrimary)
                    Spacer()
                    Button {
                        withAnimation { wronglyCompleteDismissed = true }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(DS.textTertiary)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(DS.surface.shadow(radius: 4, y: -2))
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .onChange(of: vm.isWronglyComplete) { _, newValue in
            if newValue { wronglyCompleteDismissed = false }
        }
        .animation(.easeOut(duration: 0.3), value: pendingCompletion)
        .animation(.easeOut(duration: 0.3), value: showPremiumTeaser)
        .animation(.easeOut(duration: 0.3), value: vm.isWronglyComplete)
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

            // Hint (all users; uses hint allowance, refill via ad when empty)
            if !vm.hintsBlocked {
                let hasHints = vm.hintsRemaining > 0
                #if DEBUG
                let hintEnabled = true
                #else
                let hintEnabled = hasHints || ads.hintRewardedReady
                #endif
                actionButton(icon: "lightbulb", label: "Hint (\(vm.hintsRemaining))", enabled: hintEnabled) {
                    if hasHints {
                        vm.applyHint()  // free from allowance, no ad required
                    } else {
                        showHintRefillAd()
                    }
                }
            }

            // Error Reveal (all users, requires rewarded ad)
            actionButton(icon: "eye", label: "Fehler", enabled: ads.errorRevealReady) {
                showErrorRevealAd()
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
    private func actionButton(icon: String, label: LocalizedStringKey, enabled: Bool, action: @escaping () -> Void) -> some View {
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

    private func showHintRefillAd() {
        #if DEBUG
        vm.refillHints(isPremium: store.isPremium)
        vm.applyHint()
        #else
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else { return }
        ads.showHintAdIfReady(from: rootVC) {
            vm.refillHints(isPremium: store.isPremium)
            vm.applyHint()
        }
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

    // MARK: - Scale

    private func computeInitialScale(available: CGSize) {
        guard available.width > 10, available.height > 10 else { return }

        let cols = vm.nonogram.cols
        let rows = vm.nonogram.rows
        let maxRowClues = vm.nonogram.rowClues.map(\.count).max() ?? 1
        let maxColClues = vm.nonogram.colClues.map(\.count).max() ?? 1

        let clueWSides: CGFloat = showCluesBothSides ? 2 : 1
        let clueHSides: CGFloat = showCluesBothSides ? 2 : 1

        // Unscaled content size (at scale 1.0) including padding (2×16=32)
        let contentW = CGFloat(cols) * cellSize
            + (CGFloat(maxRowClues) * 18 + 8) * clueWSides
            + 32
        let contentH = CGFloat(rows) * cellSize
            + (CGFloat(maxColClues) * 18 + 8) * clueHSides
            + 32

        let fitScale = min(available.width / contentW, available.height / contentH)
        let newScale = min(1.0, max(minScale, fitScale * 0.97)) // 3% margin

        guard abs(newScale - scale) > 0.02 else { return }
        scale = newScale
        liveScale = newScale
    }

    // MARK: - Helpers

    private func formattedDate() -> String {
        let f = DateFormatter()
        f.locale = Locale.current
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
