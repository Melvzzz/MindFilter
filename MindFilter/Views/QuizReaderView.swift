import SwiftUI
import SwiftData
import MediaPlayer
import AVFoundation
import StoreKit

// MARK: - MPVolumeView intégré dans la hiérarchie de vues (invisible)

struct HiddenVolumeView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let container = UIView(frame: .zero)
        container.clipsToBounds = true

        let volumeView = MPVolumeView(frame: CGRect(x: -2000, y: -2000, width: 1, height: 1))
        volumeView.showsRouteButton = false
        volumeView.alpha = 0.01
        container.addSubview(volumeView)

        // Le slider système n'est dispo qu'après insertion dans la hiérarchie
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if let slider = volumeView.subviews.compactMap({ $0 as? UISlider }).first {
                VolumeController.shared.slider = slider
            }
        }
        return container
    }
    func updateUIView(_ uiView: UIView, context: Context) {}
}

// MARK: - Contrôle du volume système

@MainActor
final class VolumeController {
    static let shared = VolumeController()

    /// Référence au slider système, injectée par HiddenVolumeView
    var slider: UISlider?
    private var savedVolume: Float?

    var isMuted: Bool { savedVolume != nil }

    func mute() {
        guard savedVolume == nil, let slider else { return }
        savedVolume = AVAudioSession.sharedInstance().outputVolume
        slider.value = 0
        slider.sendActions(for: .touchUpInside)
    }

    func unmute() {
        guard let vol = savedVolume, let slider else { return }
        slider.value = vol
        slider.sendActions(for: .touchUpInside)
        savedVolume = nil
    }
}

// MARK: - QuizReaderView

struct QuizReaderView: View {
    @StateObject private var viewModel = QuizViewModel()
    @EnvironmentObject private var settings: SettingsViewModel
    @EnvironmentObject private var store: StoreManager

    @Query private var history: [HistoryEntry]
    @Query private var results: [QuizResult]
    @Query private var progress: [QuestionProgress]
    @Environment(\.modelContext) private var context

    @State private var isMuted = false
    @State private var showSettings = false
    @State private var showLanguagePack = false
    @State private var dragOffset: CGFloat = 0
    @State private var cardOpacity: Double = 1.0
    @State private var autoAdvanceTask: Task<Void, Never>?

    var body: some View {
        ZStack {
            // Fond fixe
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header minimal
                headerView

                // Score bandeau
                scoreBanner

                // Carte principale
                if let question = viewModel.currentQuestion {
                    QuizCardView(
                        question: question,
                        language: settings.contentLanguage,
                        answerState: viewModel.answerState,
                        swipeProgress: swipeProgressNormalized,
                        consecutiveCorrect: progress.first(where: { $0.questionId == question.id })?.consecutiveCorrect ?? 0,
                        showLanguageCTA: !store.isLanguagePackUnlocked,
                        languagePackPrice: store.languagePackProduct?.displayPrice ?? "",
                        onChoiceTapped: { choice in
                            handleAnswer(choice)
                        },
                        onLanguageCTATapped: {
                            showLanguagePack = true
                        }
                    )
                    .offset(x: dragOffset)
                    .opacity(cardOpacity)
                    .rotationEffect(.degrees(dragOffset / 50))
                    .gesture(swipeGesture)
                    .animation(.easeInOut(duration: 0.25), value: viewModel.answerState)
                } else {
                    Spacer()
                    ProgressView()
                        .tint(Color(hex: "6B4EFF"))
                    Spacer()
                }
            }
            .frame(maxHeight: .infinity)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(settings)
                .environmentObject(store)
        }
        .sheet(isPresented: $showLanguagePack) {
            LanguagePackView()
                .environmentObject(store)
                .environmentObject(settings)
        }
        .background(HiddenVolumeView().frame(width: 0, height: 0))
        .onAppear {
            viewModel.loadFirst(enabledPaths: effectiveEnabledPaths, history: history, progress: progress)
        }
    }

    // MARK: - Header

    private var headerView: some View {
        HStack {
            Button {
                showSettings = true
            } label: {
                Image(systemName: "gearshape")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundStyle(.secondary)
                    .padding(14)
                    .background(Color(.systemBackground).opacity(0.8), in: Circle())
            }
            .buttonStyle(.plain)

            Spacer()

            // Bouton retour — visible uniquement quand il y a un historique
            if viewModel.canGoBack {
                Button {
                    autoAdvanceTask?.cancel()
                    animateOut(direction: 1) {
                        viewModel.goBack()
                    }
                } label: {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(Color(hex: "6B4EFF"))
                        .padding(14)
                        .background(Color(.systemBackground).opacity(0.8), in: Circle())
                }
                .buttonStyle(.plain)
                .transition(.scale.combined(with: .opacity))
            }

            Button {
                isMuted.toggle()
                if isMuted {
                    VolumeController.shared.mute()
                } else {
                    VolumeController.shared.unmute()
                }
            } label: {
                Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundStyle(isMuted ? Color(hex: "6B4EFF") : .secondary)
                    .padding(14)
                    .background(Color(.systemBackground).opacity(0.8), in: Circle())
                    .contentTransition(.symbolEffect(.replace))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.top, 28)
        .padding(.bottom, 4)
    }

    // MARK: - Score bandeau

    private var scoreBanner: some View {
        HStack(spacing: 16) {
            // Streak
            HStack(spacing: 4) {
                Image(systemName: "flame.fill")
                    .foregroundStyle(viewModel.streak > 0 ? Color(hex: "F59E0B") : .secondary)
                Text("\(viewModel.streak)")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(viewModel.streak > 0 ? Color(hex: "F59E0B") : .secondary)
            }

            Spacer()

            // Score session
            HStack(spacing: 4) {
                Text("\(viewModel.sessionCorrect)/\(viewModel.sessionTotal)")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primary)

                if viewModel.sessionTotal > 0 {
                    Text("(\(viewModel.accuracy)%)")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 8)
    }

    // MARK: - Paths effectifs (exclut les langues si le pack n'est pas acheté)

    private var effectiveEnabledPaths: Set<CategoryPath> {
        if store.isLanguagePackUnlocked {
            return settings.enabledPaths
        }
        return settings.enabledPaths.filter { !$0.top.isLanguage }
    }

    // MARK: - Swipe progress normalisé (-1…1)

    /// Négatif = swipe gauche, positif = swipe droite, magnitude 0…1
    private var swipeProgressNormalized: CGFloat {
        let threshold: CGFloat = 70
        let clamped = max(-threshold, min(threshold, dragOffset))
        return clamped / threshold
    }

    // MARK: - Swipe gesture

    private var swipeGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                // Pendant une réponse non encore résolue, empêcher le swipe
                dragOffset = value.translation.width * 0.5
                cardOpacity = 1.0 - abs(dragOffset) / 380
            }
            .onEnded { value in
                let threshold: CGFloat = 70

                switch viewModel.answerState {
                case .unanswered:
                    // Swipe gauche = choix gauche, swipe droite = choix droite
                    if value.translation.width < -threshold {
                        handleAnswer(.left)
                    } else if value.translation.width > threshold {
                        handleAnswer(.right)
                    } else {
                        snapBack()
                    }

                case .answered:
                    // Après réponse : n'importe quel swipe avance
                    if abs(value.translation.width) > threshold {
                        autoAdvanceTask?.cancel()
                        advanceToNext()
                    } else {
                        snapBack()
                    }
                }
            }
    }

    // MARK: - Actions

    private func handleAnswer(_ choice: CorrectAnswer) {
        // Petit rebond visuel
        withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
            dragOffset = choice == .left ? -30 : 30
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                dragOffset = 0
                cardOpacity = 1.0
            }
        }

        viewModel.answer(choice)

        // Enregistrer le résultat en SwiftData + mettre à jour la progression
        if let question = viewModel.currentQuestion,
           case .answered(_, let wasCorrect) = viewModel.answerState {
            let result = QuizResult(
                questionId: question.id,
                wasCorrect: wasCorrect,
                topCategory: question.topCategory,
                subCategory: question.subCategory
            )
            context.insert(result)
            recordHistory(questionId: question.id)
            updateProgress(questionId: question.id, wasCorrect: wasCorrect)
            checkReviewPrompt()
        }

        // Auto-avancement selon le délai configuré
        let delay: Double
        if case .answered(_, let wasCorrect) = viewModel.answerState {
            delay = wasCorrect ? settings.delayCorrect : settings.delayWrong
        } else {
            delay = settings.delayCorrect
        }
        autoAdvanceTask?.cancel()
        autoAdvanceTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(delay))
            guard !Task.isCancelled else { return }
            advanceToNext()
        }
    }

    private func advanceToNext() {
        animateOut(direction: -1) {
            if viewModel.isReviewingPast {
                viewModel.resumeFromReview(enabledPaths: effectiveEnabledPaths, history: history, progress: progress)
            } else {
                viewModel.loadNext(enabledPaths: effectiveEnabledPaths, history: history, progress: progress)
            }
        }
    }

    private func snapBack() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
            dragOffset = 0
            cardOpacity = 1.0
        }
    }

    // MARK: - Animation de sortie

    private func animateOut(direction: CGFloat, completion: @escaping () -> Void) {
        withAnimation(.easeIn(duration: 0.18)) {
            dragOffset = direction * 500
            cardOpacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
            completion()
            dragOffset = -direction * 500
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                dragOffset = 0
                cardOpacity = 1.0
            }
        }
    }

    // MARK: - Historique

    private func recordHistory(questionId: String) {
        if let existing = history.first(where: { $0.questionId == questionId }) {
            existing.lastSeenAt = .now
        } else {
            context.insert(HistoryEntry(questionId: questionId))
        }
    }

    // MARK: - Demande de note App Store

    /// Demande un avis toutes les 150 questions, max 2 fois
    private func checkReviewPrompt() {
        let totalAnswered = results.count
        let timesPrompted = UserDefaults.standard.integer(forKey: "reviewPromptCount")

        // Max 2 demandes
        guard timesPrompted < 2 else { return }

        // Seuil : 150 pour la 1re, 300 pour la 2e
        let threshold = (timesPrompted + 1) * 150
        guard totalAnswered >= threshold else { return }

        UserDefaults.standard.set(timesPrompted + 1, forKey: "reviewPromptCount")

        // Petit délai pour ne pas interrompre l'animation de réponse
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let scene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }

    // MARK: - Progression (répétition espacée)

    private func updateProgress(questionId: String, wasCorrect: Bool) {
        // Incrémenter le compteur global
        QuestionSelector.globalCount += 1
        let currentGlobalCount = QuestionSelector.globalCount

        // Trouver ou créer l'entrée de progression
        let entry: QuestionProgress
        if let existing = progress.first(where: { $0.questionId == questionId }) {
            entry = existing
        } else {
            entry = QuestionProgress(questionId: questionId)
            context.insert(entry)
        }

        // Mettre à jour la progression
        entry.totalAttempts += 1
        entry.lastAttemptAtGlobalCount = currentGlobalCount

        if wasCorrect {
            entry.totalCorrect += 1
            entry.consecutiveCorrect += 1

            // Vérifier si la question est maîtrisée
            if entry.consecutiveCorrect >= QuestionProgress.requiredStreak && !entry.isMastered {
                entry.isMastered = true
                entry.masteredAt = .now
            }
        } else {
            // Reset de la série
            entry.consecutiveCorrect = 0
        }
    }
}
