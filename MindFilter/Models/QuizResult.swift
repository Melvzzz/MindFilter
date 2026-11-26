import SwiftData
import Foundation

@Model
class QuizResult {
    var questionId: String = ""
    var wasCorrect: Bool = false
    var answeredAt: Date = Date.now
    var topCategoryRaw: String = ""
    var subCategoryRaw: String = ""

    init(questionId: String, wasCorrect: Bool, answeredAt: Date = .now,
         topCategory: TopCategory, subCategory: SubCategory) {
        self.questionId = questionId
        self.wasCorrect = wasCorrect
        self.answeredAt = answeredAt
        self.topCategoryRaw = topCategory.rawValue
        self.subCategoryRaw = subCategory.rawValue
    }

    /// Catégorie principale reconstituée
    var topCategory: TopCategory? {
        TopCategory(rawValue: topCategoryRaw)
    }

    /// Sous-catégorie reconstituée
    var subCategory: SubCategory? {
        SubCategory(rawValue: subCategoryRaw)
    }
}
