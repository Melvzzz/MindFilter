import Foundation

// MARK: - Réponse correcte

enum CorrectAnswer: String, Codable {
    case left
    case right
}

// MARK: - Question

struct Question: Codable, Identifiable, Equatable {
    let id: String
    let topCategory: TopCategory
    let subCategory: SubCategory
    let question: [String: String]
    let choiceLeft: [String: String]
    let choiceRight: [String: String]
    let correctAnswer: CorrectAnswer
    let explanation: [String: String]?
    let emoji: String?

    // MARK: - Helpers localisés (fallback vers "fr")

    func localizedQuestion(for lang: LanguageCode) -> String {
        question[lang.rawValue] ?? question["fr"] ?? ""
    }

    func localizedChoiceLeft(for lang: LanguageCode) -> String {
        choiceLeft[lang.rawValue] ?? choiceLeft["fr"] ?? ""
    }

    func localizedChoiceRight(for lang: LanguageCode) -> String {
        choiceRight[lang.rawValue] ?? choiceRight["fr"] ?? ""
    }

    func localizedExplanation(for lang: LanguageCode) -> String? {
        guard let explanation else { return nil }
        return explanation[lang.rawValue] ?? explanation["fr"]
    }

    /// Chemin de catégorie composite
    var categoryPath: CategoryPath {
        CategoryPath(top: topCategory, sub: subCategory)
    }
}
