import SwiftData
import Foundation

/// Suivi de la progression de maîtrise pour chaque question (répétition espacée)
@Model
class QuestionProgress {
    /// Identifiant unique de la question
    var questionId: String = ""
    /// Nombre de bonnes réponses consécutives (0, 1, 2 → maîtrisée à 3)
    var consecutiveCorrect: Int = 0
    /// Nombre total de tentatives
    var totalAttempts: Int = 0
    /// Nombre total de bonnes réponses
    var totalCorrect: Int = 0
    /// Valeur du compteur global lors de la dernière tentative (pour calculer l'espacement)
    var lastAttemptAtGlobalCount: Int = 0
    /// true si consecutiveCorrect >= 3
    var isMastered: Bool = false
    /// Date de maîtrise
    var masteredAt: Date?

    init(questionId: String) {
        self.questionId = questionId
    }

    /// Nombre de bonnes réponses consécutives nécessaires pour maîtriser
    static let requiredStreak = 3
    /// Espacement (en nombre de questions vues) entre deux tentatives de validation
    static let spacingForValidation = 50
    /// Espacement réduit après un échec
    static let spacingAfterFailure = 30
}
