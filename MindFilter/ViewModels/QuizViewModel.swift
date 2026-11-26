import SwiftUI

// MARK: - État de réponse

enum AnswerState: Equatable {
    case unanswered
    case answered(chose: CorrectAnswer, wasCorrect: Bool)
}

// MARK: - QuizViewModel

/// Entrée dans l'historique de session (question + réponse donnée)
struct SessionEntry {
    let question: Question
    let chose: CorrectAnswer
    let wasCorrect: Bool
}

class QuizViewModel: ObservableObject {
    @Published var currentQuestion: Question?
    @Published var answerState: AnswerState = .unanswered
    @Published var streak: Int = UserDefaults.standard.integer(forKey: "currentStreak")
    @Published var sessionCorrect: Int = 0
    @Published var sessionTotal: Int = 0
    /// true quand on revisite une question passée
    @Published var isReviewingPast: Bool = false

    private var allQuestions: [Question] = []
    private var sessionShown: [String] = []
    /// Historique des questions répondues dans cette session
    private(set) var sessionHistory: [SessionEntry] = []

    /// On peut revenir en arrière s'il y a de l'historique
    var canGoBack: Bool { !sessionHistory.isEmpty }

    /// Persister la série courante dans UserDefaults
    private func saveStreak() {
        UserDefaults.standard.set(streak, forKey: "currentStreak")
    }

    // MARK: - Chargement initial

    func loadFirst(enabledPaths: Set<CategoryPath>, history: [HistoryEntry], progress: [QuestionProgress]) {
        allQuestions = QuestionLoader.loadQuestions()
        loadNext(enabledPaths: enabledPaths, history: history, progress: progress)
    }

    // MARK: - Répondre à une question

    func answer(_ choice: CorrectAnswer) {
        guard let question = currentQuestion, answerState == .unanswered else { return }

        let wasCorrect = (choice == question.correctAnswer)
        answerState = .answered(chose: choice, wasCorrect: wasCorrect)
        sessionTotal += 1

        if wasCorrect {
            sessionCorrect += 1
            streak += 1
        } else {
            streak = 0
        }
        saveStreak()

        // Sauvegarder dans l'historique de session (sauf en mode relecture)
        if !isReviewingPast {
            sessionHistory.append(SessionEntry(question: question, chose: choice, wasCorrect: wasCorrect))
        }
    }

    // MARK: - Revenir à la question précédente

    func goBack() {
        guard let last = sessionHistory.last else { return }
        isReviewingPast = true
        currentQuestion = last.question
        answerState = .answered(chose: last.chose, wasCorrect: last.wasCorrect)
        sessionHistory.removeLast()
    }

    /// Quitter le mode relecture et reprendre le cours normal
    func resumeFromReview(enabledPaths: Set<CategoryPath>, history: [HistoryEntry], progress: [QuestionProgress]) {
        // Remettre la question relue dans l'historique
        if let q = currentQuestion, case .answered(let chose, let wasCorrect) = answerState {
            sessionHistory.append(SessionEntry(question: q, chose: chose, wasCorrect: wasCorrect))
        }
        isReviewingPast = false
        loadNext(enabledPaths: enabledPaths, history: history, progress: progress)
    }

    // MARK: - Passer à la question suivante

    func loadNext(enabledPaths: Set<CategoryPath>, history: [HistoryEntry], progress: [QuestionProgress]) {
        answerState = .unanswered

        if let next = QuestionSelector.selectNext(
            from: allQuestions,
            enabledPaths: enabledPaths,
            sessionShown: sessionShown,
            history: history,
            progress: progress
        ) {
            currentQuestion = next
            sessionShown.append(next.id)
        } else {
            // Plus de questions disponibles — relancer le pool
            sessionShown.removeAll()
            if let next = QuestionSelector.selectNext(
                from: allQuestions,
                enabledPaths: enabledPaths,
                sessionShown: sessionShown,
                history: history,
                progress: progress
            ) {
                currentQuestion = next
                sessionShown.append(next.id)
            }
        }
    }

    /// Précision en pourcentage
    var accuracy: Int {
        guard sessionTotal > 0 else { return 0 }
        return Int(round(Double(sessionCorrect) / Double(sessionTotal) * 100))
    }
}
