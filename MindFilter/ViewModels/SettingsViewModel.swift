import SwiftUI
import AVFoundation

class SettingsViewModel: ObservableObject {

    @Published var enabledPaths: Set<CategoryPath> {
        didSet { savePaths() }
    }

    @Published var contentLanguage: LanguageCode {
        didSet {
            UserDefaults.standard.set(contentLanguage.rawValue, forKey: "contentLanguage")
        }
    }

    /// Délai avant auto-avancement après une bonne réponse (en secondes)
    @Published var delayCorrect: Double {
        didSet { UserDefaults.standard.set(delayCorrect, forKey: "delayCorrect") }
    }

    /// Délai avant auto-avancement après une mauvaise réponse (en secondes)
    @Published var delayWrong: Double {
        didSet { UserDefaults.standard.set(delayWrong, forKey: "delayWrong") }
    }

    /// Réduire le volume des autres apps de 50 % (ducking)
    @Published var duckingEnabled: Bool {
        didSet {
            UserDefaults.standard.set(duckingEnabled, forKey: "duckingEnabled")
            #if os(iOS)
            let session = AVAudioSession.sharedInstance()
            if duckingEnabled {
                try? session.setCategory(.playback, options: .duckOthers)
                try? session.setActive(true)
            } else {
                try? session.setActive(false, options: .notifyOthersOnDeactivation)
            }
            #endif
        }
    }

    init() {
        // Charger les chemins sauvegardés
        if let data = UserDefaults.standard.data(forKey: "enabledPaths"),
           let saved = try? JSONDecoder().decode(Set<CategoryPath>.self, from: data),
           !saved.isEmpty {
            self.enabledPaths = saved
        } else {
            // Par défaut : toutes les catégories activées
            var allPaths = Set<CategoryPath>()
            for top in TopCategory.allCases {
                for sub in top.subCategories {
                    allPaths.insert(CategoryPath(top: top, sub: sub))
                }
            }
            self.enabledPaths = allPaths
        }

        if let lang = UserDefaults.standard.string(forKey: "contentLanguage"),
           let code = LanguageCode(rawValue: lang) {
            self.contentLanguage = code
        } else {
            self.contentLanguage = .fr
        }

        // Délais d'auto-avancement (défauts : 1.5s bonne, 3s mauvaise)
        let savedCorrect = UserDefaults.standard.double(forKey: "delayCorrect")
        self.delayCorrect = savedCorrect > 0 ? savedCorrect : 1.5

        let savedWrong = UserDefaults.standard.double(forKey: "delayWrong")
        self.delayWrong = savedWrong > 0 ? savedWrong : 3.0

        // Ducking activé par défaut
        if UserDefaults.standard.object(forKey: "duckingEnabled") == nil {
            self.duckingEnabled = true
        } else {
            self.duckingEnabled = UserDefaults.standard.bool(forKey: "duckingEnabled")
        }
    }

    // MARK: - Toggle d'une sous-catégorie

    func toggleSubCategory(_ path: CategoryPath) {
        if enabledPaths.contains(path) {
            guard enabledPaths.count > 1 else { return }
            enabledPaths.remove(path)
        } else {
            enabledPaths.insert(path)
        }
    }

    // MARK: - Toggle d'une catégorie principale (active/désactive toutes ses sous-catégories)

    func toggleTopCategory(_ top: TopCategory) {
        let paths = top.subCategories.map { CategoryPath(top: top, sub: $0) }
        let allEnabled = paths.allSatisfy { enabledPaths.contains($0) }

        if allEnabled {
            // Désactiver toutes, sauf si c'est la dernière catégorie
            let remaining = enabledPaths.subtracting(paths)
            guard !remaining.isEmpty else { return }
            enabledPaths = remaining
        } else {
            // Activer toutes
            for path in paths {
                enabledPaths.insert(path)
            }
        }
    }

    // MARK: - Helpers

    /// Vérifie si toutes les sous-catégories d'un top sont activées
    func isTopFullyEnabled(_ top: TopCategory) -> Bool {
        top.subCategories.allSatisfy { enabledPaths.contains(CategoryPath(top: top, sub: $0)) }
    }

    /// Vérifie si au moins une sous-catégorie d'un top est activée
    func isTopPartiallyEnabled(_ top: TopCategory) -> Bool {
        top.subCategories.contains { enabledPaths.contains(CategoryPath(top: top, sub: $0)) }
    }

    /// Nombre de sous-catégories activées pour un top
    func enabledSubCount(for top: TopCategory) -> Int {
        top.subCategories.filter { enabledPaths.contains(CategoryPath(top: top, sub: $0)) }.count
    }

    // MARK: - Persistence

    private func savePaths() {
        if let data = try? JSONEncoder().encode(enabledPaths) {
            UserDefaults.standard.set(data, forKey: "enabledPaths")
        }
    }
}
