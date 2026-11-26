import SwiftData
import Foundation

@Model
class HistoryEntry {
    var questionId: String = ""
    var lastSeenAt: Date = Date.now

    init(questionId: String, lastSeenAt: Date = .now) {
        self.questionId = questionId
        self.lastSeenAt = lastSeenAt
    }
}
