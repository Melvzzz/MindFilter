import Foundation

// MARK: - Catégories principales

enum TopCategory: String, Codable, CaseIterable, Hashable {
    case cultureGenerale = "culture_generale"
    case english
    case french
    case spanish
    case german

    var displayName: String {
        localizedName(for: nil)
    }

    func localizedName(for lang: LanguageCode?) -> String {
        guard let lang else {
            // Fallback sans langue
            switch self {
            case .cultureGenerale: return "Culture Générale"
            case .english:         return "English"
            case .french:          return "Français"
            case .spanish:         return "Español"
            case .german:          return "Deutsch"
            }
        }
        switch self {
        case .cultureGenerale:
            switch lang {
            case .fr: return "Culture Générale"
            case .en: return "General Knowledge"
            case .es: return "Cultura General"
            case .de: return "Allgemeinwissen"
            }
        case .english:  return "English"
        case .french:   return "Français"
        case .spanish:  return "Español"
        case .german:   return "Deutsch"
        }
    }

    var emoji: String {
        switch self {
        case .cultureGenerale: return "🧠"
        case .english:         return "🇬🇧"
        case .french:          return "🇫🇷"
        case .spanish:         return "🇪🇸"
        case .german:          return "🇩🇪"
        }
    }

    /// Indique si c'est une catégorie d'apprentissage de langue
    var isLanguage: Bool {
        switch self {
        case .cultureGenerale: return false
        case .english, .french, .spanish, .german: return true
        }
    }

    /// Drapeau emoji pour les catégories langues
    var flag: String {
        switch self {
        case .cultureGenerale: return ""
        case .english:         return "🇬🇧"
        case .french:          return "🇫🇷"
        case .spanish:         return "🇪🇸"
        case .german:          return "🇩🇪"
        }
    }

    /// Sous-catégories associées
    var subCategories: [SubCategory] {
        switch self {
        case .cultureGenerale:
            return [.science, .history, .inventions, .geography, .psychology,
                    .quotes, .mathematics, .artCulture, .food, .space]
        case .english, .french, .spanish, .german:
            return [.a1, .a2, .b1, .b2, .c1, .c2]
        }
    }
}

// MARK: - Sous-catégories

enum SubCategory: String, Codable, CaseIterable, Hashable {
    // Culture Générale (10)
    case science
    case history
    case inventions
    case geography
    case psychology
    case quotes
    case mathematics
    case artCulture = "art_culture"
    case food
    case space

    // Niveaux CECRL (6)
    case a1, a2, b1, b2, c1, c2

    var displayName: String {
        localizedName(for: nil)
    }

    func localizedName(for lang: LanguageCode?) -> String {
        switch self {
        case .science:
            switch lang {
            case .fr: return "Science"
            case .en, .none: return "Science"
            case .es: return "Ciencia"
            case .de: return "Wissenschaft"
            }
        case .history:
            switch lang {
            case .fr: return "Histoire"
            case .en, .none: return "History"
            case .es: return "Historia"
            case .de: return "Geschichte"
            }
        case .inventions:
            switch lang {
            case .fr: return "Inventions"
            case .en, .none: return "Inventions"
            case .es: return "Inventos"
            case .de: return "Erfindungen"
            }
        case .geography:
            switch lang {
            case .fr: return "Géographie"
            case .en, .none: return "Geography"
            case .es: return "Geografía"
            case .de: return "Geographie"
            }
        case .psychology:
            switch lang {
            case .fr: return "Psychologie"
            case .en, .none: return "Psychology"
            case .es: return "Psicología"
            case .de: return "Psychologie"
            }
        case .quotes:
            switch lang {
            case .fr: return "Citations"
            case .en, .none: return "Quotes"
            case .es: return "Citas"
            case .de: return "Zitate"
            }
        case .mathematics:
            switch lang {
            case .fr: return "Mathématiques"
            case .en, .none: return "Mathematics"
            case .es: return "Matemáticas"
            case .de: return "Mathematik"
            }
        case .artCulture:
            switch lang {
            case .fr: return "Art & Culture"
            case .en, .none: return "Art & Culture"
            case .es: return "Arte y Cultura"
            case .de: return "Kunst & Kultur"
            }
        case .food:
            switch lang {
            case .fr: return "Alimentation"
            case .en, .none: return "Food"
            case .es: return "Alimentación"
            case .de: return "Ernährung"
            }
        case .space:
            switch lang {
            case .fr: return "Espace"
            case .en, .none: return "Space"
            case .es: return "Espacio"
            case .de: return "Weltraum"
            }
        case .a1:
            switch lang {
            case .fr: return "A1 — Débutant"
            case .en, .none: return "A1 — Beginner"
            case .es: return "A1 — Principiante"
            case .de: return "A1 — Anfänger"
            }
        case .a2:
            switch lang {
            case .fr: return "A2 — Élémentaire"
            case .en, .none: return "A2 — Elementary"
            case .es: return "A2 — Elemental"
            case .de: return "A2 — Grundlegend"
            }
        case .b1:
            switch lang {
            case .fr: return "B1 — Intermédiaire"
            case .en, .none: return "B1 — Intermediate"
            case .es: return "B1 — Intermedio"
            case .de: return "B1 — Mittelstufe"
            }
        case .b2:
            switch lang {
            case .fr: return "B2 — Avancé"
            case .en, .none: return "B2 — Upper Intermediate"
            case .es: return "B2 — Avanzado"
            case .de: return "B2 — Fortgeschritten"
            }
        case .c1:
            switch lang {
            case .fr: return "C1 — Autonome"
            case .en, .none: return "C1 — Advanced"
            case .es: return "C1 — Avanzado superior"
            case .de: return "C1 — Fachkundig"
            }
        case .c2:
            switch lang {
            case .fr: return "C2 — Maîtrise"
            case .en, .none: return "C2 — Mastery"
            case .es: return "C2 — Maestría"
            case .de: return "C2 — Meisterschaft"
            }
        }
    }

    var emoji: String {
        switch self {
        case .science:      return "🔬"
        case .history:      return "📖"
        case .inventions:   return "💡"
        case .geography:    return "🌍"
        case .psychology:   return "🧩"
        case .quotes:       return "💬"
        case .mathematics:  return "🔢"
        case .artCulture:   return "🎨"
        case .food:         return "🍕"
        case .space:        return "🚀"
        case .a1:           return "🌱"
        case .a2:           return "🌿"
        case .b1:           return "🌳"
        case .b2:           return "⭐"
        case .c1:           return "🏆"
        case .c2:           return "👑"
        }
    }

    /// Indique si c'est un niveau CECRL
    var isLanguageLevel: Bool {
        switch self {
        case .a1, .a2, .b1, .b2, .c1, .c2: return true
        default: return false
        }
    }
}

// MARK: - Chemin composite catégorie

struct CategoryPath: Hashable, Codable {
    let top: TopCategory
    let sub: SubCategory
}

// MARK: - LanguageCode (conservé de l'ancien modèle)

enum LanguageCode: String, Codable, CaseIterable {
    case en, fr, es, de

    var displayName: String {
        switch self {
        case .en: return "English"
        case .fr: return "Français"
        case .es: return "Español"
        case .de: return "Deutsch"
        }
    }
}
