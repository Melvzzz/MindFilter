import SwiftUI
import AVKit

// MARK: - OnboardingView

struct OnboardingView: View {
    @AppStorage("onboardingCompleted") private var onboardingCompleted = false
    @EnvironmentObject private var settings: SettingsViewModel
    @EnvironmentObject private var store: StoreManager
    @State private var currentPage = 0
    @State private var sheetHeight: CGFloat = 0
    @State private var showLanguagePack = false

    private let totalPages = 4
    private var lang: LanguageCode { settings.contentLanguage }

    /// On peut avancer seulement si au moins 1 sous-catégorie est sélectionnée (page 1)
    private var canAdvance: Bool {
        if currentPage == 1 {
            return !settings.enabledPaths.isEmpty
        }
        return true
    }

    var body: some View {
        GeometryReader { geo in
            let isLandscape = geo.size.width > geo.size.height

            ZStack(alignment: .bottom) {

                // ── Fond gradient plein écran ────────────────────────────
                BlobGradientView()
                    .ignoresSafeArea()

                // ── Dots en haut ─────────────────────────────────────────
                VStack {
                    HStack(spacing: 10) {
                        ForEach(0..<totalPages, id: \.self) { i in
                            Capsule()
                                .fill(.white.opacity(i == currentPage ? 1.0 : 0.30))
                                .frame(width: i == currentPage ? 24 : 8, height: 8)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    .padding(.top, geo.safeAreaInsets.top + 16)
                    Spacer()
                }

                // ── Logo centré dans la zone gradient visible ─────────────
                let visibleGradientHeight = geo.size.height - sheetHeight
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: isLandscape ? 100 : 120, height: isLandscape ? 100 : 120)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(color: .black.opacity(0.3), radius: 20, y: 8)
                    .position(x: geo.size.width / 2, y: visibleGradientHeight / 2)

                // ── Sheet blanche ──────────────────────────────────────
                VStack(spacing: 0) {
                    // Titre
                    Text(pageTitle)
                        .font(.system(size: isLandscape ? 32 : 28, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.primary)
                        .lineSpacing(3)
                        .padding(.top, currentPage == 0 ? 48 : 24)
                        .padding(.horizontal, 24)

                    // Contenu
                    if currentPage != 0 {
                        pageContent(geo: geo, isLandscape: isLandscape)
                            .padding(.horizontal, currentPage == 1 ? 20 : (isLandscape ? 40 : 24))
                            .padding(.top, currentPage == 1 ? 16 : (isLandscape ? 20 : 28))
                    }

                    if currentPage != 0 {
                        Spacer(minLength: 0)
                    }

                    // Bouton
                    Button(action: advancePage) {
                        Text(buttonLabel)
                            .font(.system(size: 19, weight: .semibold))
                            .frame(maxWidth: 380)
                            .frame(height: 56)
                            .background(canAdvance ? Color(hex: "6B4EFF") : Color.gray.opacity(0.3))
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)
                    .disabled(!canAdvance)
                    .animation(.easeInOut(duration: 0.2), value: canAdvance)
                    .padding(.horizontal, 28)
                    .padding(.top, currentPage == 0 ? 80 : 16)
                    .padding(.bottom, geo.safeAreaInsets.bottom + 32)
                }
                .frame(width: geo.size.width)
                .frame(height: currentPage == 0 ? nil : geo.size.height * (isLandscape ? 0.78 : 0.75))
                .background(
                    GeometryReader { sheetGeo in
                        Color.clear.preference(key: SheetHeightKey.self, value: sheetGeo.size.height)
                    }
                )
                .onPreferenceChange(SheetHeightKey.self) { sheetHeight = $0 }
                .background(Color(.systemBackground))
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 32, topTrailingRadius: 32))
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - Titre par page

    private var pageTitle: String {
        switch currentPage {
        case 0: return AppStrings.onboardingTitle1(lang)
        case 1: return AppStrings.onboardingChooseTitle(lang)
        case 2: return AppStrings.onboardingTitle2(lang)
        case 3: return AppStrings.onboardingTitle3(lang)
        default: return ""
        }
    }

    // MARK: - Contenu de chaque page

    @ViewBuilder
    private func pageContent(geo: GeometryProxy, isLandscape: Bool) -> some View {
        Group {
            switch currentPage {
            case 0:
                EmptyView()
            case 1:
                categoryPickerPage
            case 2:
                tutorialPage(
                    steps: [
                        ("1", LocalizedStringKey(AppStrings.settingsStep1(lang))),
                        ("2", LocalizedStringKey(AppStrings.settingsStep2(lang))),
                        ("3", LocalizedStringKey(AppStrings.settingsStep3(lang))),
                        ("4", LocalizedStringKey(AppStrings.settingsStep4(lang))),
                    ],
                    videoName: "onboarding_settings",
                    isLandscape: isLandscape
                )
            case 3:
                tutorialPage(
                    steps: [
                        ("1", LocalizedStringKey(AppStrings.slideOverStep1(lang))),
                        ("2", LocalizedStringKey(AppStrings.slideOverStep2(lang))),
                        ("3", LocalizedStringKey(AppStrings.slideOverStep3(lang))),
                    ],
                    videoName: "onboarding_slideover",
                    isLandscape: isLandscape,
                    warningText: AppStrings.slideOverWarning(lang)
                )
            default:
                EmptyView()
            }
        }
        .transition(.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        ))
        .id(currentPage)
    }

    // MARK: - Page choix des catégories

    private var categoryPickerPage: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 12) {
                // Catégories débloquées (culture générale + langues si achetées)
                ForEach(TopCategory.allCases, id: \.self) { top in
                    if !top.isLanguage || store.isLanguagePackUnlocked {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 10) {
                                Text(top.emoji)
                                    .font(.system(size: 22))
                                Text(top.localizedName(for: lang))
                                    .font(.system(size: 16, weight: .semibold))
                            }

                            FlowLayout(spacing: 6) {
                                ForEach(top.subCategories, id: \.self) { sub in
                                    let path = CategoryPath(top: top, sub: sub)
                                    let isOn = settings.enabledPaths.contains(path)

                                    Button {
                                        settings.toggleSubCategory(path)
                                    } label: {
                                        HStack(spacing: 4) {
                                            Text(sub.emoji)
                                                .font(.system(size: 12))
                                            Text(sub.localizedName(for: lang))
                                                .font(.system(size: 12, weight: .medium))
                                        }
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 7)
                                        .background(isOn ? sub.accentColor.opacity(0.15) : Color.gray.opacity(0.08))
                                        .foregroundStyle(isOn ? sub.accentColor : .secondary)
                                        .clipShape(Capsule())
                                        .overlay(
                                            Capsule()
                                                .stroke(isOn ? sub.accentColor : Color.clear, lineWidth: 1.5)
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(minHeight: 90)
                        .padding(14)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }

                // CTA unique pour débloquer les langues
                if !store.isLanguagePackUnlocked {
                    Button {
                        showLanguagePack = true
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "character.book.closed.fill")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(.white)

                            VStack(alignment: .leading, spacing: 2) {
                                HStack(spacing: 6) {
                                    Text(AppStrings.unlockLanguageLearning(lang))
                                    Text("🇬🇧 🇫🇷 🇪🇸 🇩🇪")
                                }
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(.white)
                                Text(AppStrings.languagePackQuestionCount(lang))
                                    .font(.system(size: 12))
                                    .foregroundStyle(.white.opacity(0.7))
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 2) {
                                Text(store.languagePackProduct?.displayPrice ?? "")
                                    .font(.system(size: 15, weight: .bold, design: .rounded))
                                    .foregroundStyle(.white)
                                Text(AppStrings.oneTimeShort(lang))
                                    .font(.system(size: 11))
                                    .foregroundStyle(.white.opacity(0.6))
                            }

                            Image(systemName: "lock.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(.white.opacity(0.6))
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "6B4EFF"), Color(hex: "9F7AFF")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(maxWidth: 650)
        }
        .sheet(isPresented: $showLanguagePack) {
            LanguagePackView()
                .environmentObject(store)
                .environmentObject(settings)
        }
    }

    // MARK: - Page tutoriel (étapes + vidéo) — adaptatif portrait/paysage

    private func tutorialPage(steps: [(String, LocalizedStringKey)], videoName: String, isLandscape: Bool, warningText: String? = nil) -> some View {
        Group {
            if isLandscape {
                HStack(spacing: 32) {
                    VStack(alignment: .leading, spacing: 16) {
                        stepsView(steps, fontSize: 20)
                        if let warningText {
                            warningBanner(warningText)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    AutoplayVideoView(videoName: videoName)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            } else {
                VStack(spacing: 32) {
                    AutoplayVideoView(videoName: videoName)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 16))

                    stepsView(steps, fontSize: 18)

                    if let warningText {
                        warningBanner(warningText)
                    }
                }
            }
        }
    }

    // MARK: - Composants partagés

    private func stepsView(_ steps: [(String, LocalizedStringKey)], fontSize: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            ForEach(steps, id: \.0) { step in
                HStack(alignment: .center, spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "6B4EFF"))
                            .frame(width: 34, height: 34)
                        Text(step.0)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    Text(step.1)
                        .font(.system(size: fontSize))
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    private func warningBanner(_ text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 16))
                .foregroundStyle(.orange)
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.orange.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    // MARK: - Navigation

    private var buttonLabel: String {
        switch currentPage {
        case 0:  return AppStrings.getStarted(lang)
        case 1:  return AppStrings.next(lang)
        case 2:  return AppStrings.done(lang)
        case 3:  return AppStrings.startQuiz(lang)
        default: return AppStrings.next(lang)
        }
    }

    private func advancePage() {
        if currentPage < totalPages - 1 {
            withAnimation(.easeInOut(duration: 0.4)) {
                currentPage += 1
            }
        } else {
            onboardingCompleted = true
        }
    }
}

// MARK: - FlowLayout (grille de chips avec retour à la ligne automatique)

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                                  proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (positions: [CGPoint], size: CGSize) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var maxX: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
            maxX = max(maxX, x - spacing)
        }

        return (positions, CGSize(width: maxX, height: y + rowHeight))
    }
}

// MARK: - AutoplayVideoView (lecture auto + boucle)

private struct AutoplayVideoView: View {
    let videoName: String
    @State private var player: AVPlayer?

    private var videoURL: URL? {
        Bundle.main.url(forResource: videoName, withExtension: "mp4")
    }

    var body: some View {
        Group {
            if let player {
                VideoPlayer(player: player)
                    .disabled(true)
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.12))
                    .overlay(
                        VStack(spacing: 10) {
                            Image(systemName: "play.rectangle.fill")
                                .font(.system(size: 36))
                                .foregroundStyle(Color.secondary.opacity(0.6))
                            Text("Add \(videoName).mp4")
                                .font(.system(size: 13))
                                .foregroundStyle(Color.secondary.opacity(0.6))
                        }
                    )
            }
        }
        .onAppear { setupPlayer() }
        .onDisappear { player?.pause() }
    }

    private func setupPlayer() {
        guard let url = videoURL else { return }
        let avPlayer = AVPlayer(url: url)
        avPlayer.isMuted = true
        avPlayer.play()

        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: avPlayer.currentItem,
            queue: .main
        ) { _ in
            avPlayer.seek(to: .zero)
            avPlayer.play()
        }

        self.player = avPlayer
    }
}

// MARK: - Blob Gradient Background

private struct BlobGradientView: View {
    var body: some View {
        ZStack {
            Color(hex: "150A2E")

            Circle()
                .fill(Color(hex: "6B4EFF").opacity(0.85))
                .frame(width: 380, height: 380)
                .blur(radius: 120)
                .offset(x: -80, y: -220)

            Circle()
                .fill(Color(hex: "C084FC").opacity(0.70))
                .frame(width: 320, height: 320)
                .blur(radius: 100)
                .offset(x: 100, y: -160)

            Circle()
                .fill(Color(hex: "4338CA").opacity(0.60))
                .frame(width: 280, height: 280)
                .blur(radius: 110)
                .offset(x: -20, y: 60)

            Circle()
                .fill(Color(hex: "E879F9").opacity(0.45))
                .frame(width: 240, height: 240)
                .blur(radius: 90)
                .offset(x: 120, y: 100)

            Circle()
                .fill(Color(hex: "7C3AED").opacity(0.50))
                .frame(width: 300, height: 300)
                .blur(radius: 115)
                .offset(x: -40, y: 260)
        }
        .ignoresSafeArea()
    }
}

// MARK: - PreferenceKey pour mesurer la hauteur de la sheet

private struct SheetHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
