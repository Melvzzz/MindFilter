import Foundation

class QuestionSelector {

    /// Compteur global de questions répondues (persisté dans UserDefaults)
    static var globalCount: Int {
        get { UserDefaults.standard.integer(forKey: "globalQuestionsAnswered") }
        set { UserDefaults.standard.set(newValue, forKey: "globalQuestionsAnswered") }
    }

    /// Sélectionne la prochaine question avec algorithme de répétition espacée
    ///
    /// Priorité 1 : jamais vue (pas de QuestionProgress)
    /// Priorité 2 : en cours de validation (consecutiveCorrect 1-2) ET espacement atteint (≥50)
    /// Priorité 3 : échouée/reset (consecutiveCorrect 0, tentatives > 0) ET espacement atteint (≥30)
    /// Priorité 4 : fallback sur les questions pas encore éligibles
    /// Exclues  : questions maîtrisées (isMastered = true)
    static func selectNext(
        from questions: [Question],
        enabledPaths: Set<CategoryPath>,
        sessionShown: [String],
        history: [HistoryEntry],
        progress: [QuestionProgress]
    ) -> Question? {
        let currentGlobalCount = globalCount

        // Filtrer par catégories activées et exclure la session en cours
        let candidates = questions.filter {
            enabledPaths.contains($0.categoryPath) && !sessionShown.contains($0.id)
        }

        guard !candidates.isEmpty else { return nil }

        // Index de progression par questionId
        let progressMap = Dictionary(uniqueKeysWithValues: progress.map { ($0.questionId, $0) })

        // Exclure les questions maîtrisées
        let active = candidates.filter { !(progressMap[$0.id]?.isMastered ?? false) }
        guard !active.isEmpty else { return nil }

        // Priorité 1 : jamais vue (aucune entrée dans progressMap)
        let neverSeen = active.filter { progressMap[$0.id] == nil }
        if !neverSeen.isEmpty { return neverSeen.randomElement() }

        // Priorité 2 : en cours de validation (série 1 ou 2) ET espacement atteint
        let readyForValidation = active.filter { q in
            guard let p = progressMap[q.id] else { return false }
            let spacing = currentGlobalCount - p.lastAttemptAtGlobalCount
            return p.consecutiveCorrect >= 1
                && p.consecutiveCorrect < QuestionProgress.requiredStreak
                && spacing >= QuestionProgress.spacingForValidation
        }
        if !readyForValidation.isEmpty { return readyForValidation.randomElement() }

        // Priorité 3 : échouées récemment (série à 0, mais déjà tentées) ET espacement atteint
        let readyForRetry = active.filter { q in
            guard let p = progressMap[q.id] else { return false }
            let spacing = currentGlobalCount - p.lastAttemptAtGlobalCount
            return p.consecutiveCorrect == 0
                && p.totalAttempts > 0
                && spacing >= QuestionProgress.spacingAfterFailure
        }
        if !readyForRetry.isEmpty { return readyForRetry.randomElement() }

        // Priorité 4 : fallback — questions vues mais pas encore éligibles
        // (espacement pas encore atteint)
        let notYetReady = active.filter { q in
            guard let p = progressMap[q.id] else { return false }
            return p.totalAttempts > 0
        }
        if !notYetReady.isEmpty {
            // Choisir celle dont l'espacement est le plus avancé (la plus proche d'être prête)
            return notYetReady
                .sorted { a, b in
                    let spacingA = currentGlobalCount - (progressMap[a.id]?.lastAttemptAtGlobalCount ?? 0)
                    let spacingB = currentGlobalCount - (progressMap[b.id]?.lastAttemptAtGlobalCount ?? 0)
                    return spacingA > spacingB
                }
                .first
        }

        // Dernier recours (ne devrait pas arriver)
        return active.randomElement()
    }
}
