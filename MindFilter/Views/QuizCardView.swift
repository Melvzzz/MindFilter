import SwiftUI

// MARK: - Color Hex Init

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:  (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:  (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:  (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}

// MARK: - SubCategory Design Extensions

extension SubCategory {
    var accentColor: Color {
        switch self {
        case .science:      return Color(hex: "0EA5E9")
        case .history:      return Color(hex: "F59E0B")
        case .inventions:   return Color(hex: "F97316")
        case .geography:    return Color(hex: "22C55E")
        case .psychology:   return Color(hex: "A855F7")
        case .quotes:       return Color(hex: "EC4899")
        case .mathematics:  return Color(hex: "6366F1")
        case .artCulture:   return Color(hex: "EF4444")
        case .food:         return Color(hex: "84CC16")
        case .space:        return Color(hex: "3B82F6")
        case .a1:           return Color(hex: "22C55E")
        case .a2:           return Color(hex: "84CC16")
        case .b1:           return Color(hex: "F59E0B")
        case .b2:           return Color(hex: "F97316")
        case .c1:           return Color(hex: "EF4444")
        case .c2:           return Color(hex: "A855F7")
        }
    }

    var sfSymbol: String {
        switch self {
        case .science:      return "atom"
        case .history:      return "book.closed"
        case .inventions:   return "lightbulb"
        case .geography:    return "globe.europe.africa"
        case .psychology:   return "brain.head.profile"
        case .quotes:       return "quote.bubble"
        case .mathematics:  return "sum"
        case .artCulture:   return "paintpalette"
        case .food:         return "fork.knife"
        case .space:        return "moon.stars"
        case .a1:           return "leaf"
        case .a2:           return "leaf.fill"
        case .b1:           return "tree"
        case .b2:           return "star"
        case .c1:           return "trophy"
        case .c2:           return "crown"
        }
    }
}

// MARK: - TopCategory Design Extensions

extension TopCategory {
    var accentColor: Color {
        switch self {
        case .cultureGenerale: return Color(hex: "6B4EFF")
        case .english:         return Color(hex: "3B82F6")
        case .french:          return Color(hex: "EF4444")
        case .spanish:         return Color(hex: "F59E0B")
        case .german:          return Color(hex: "6366F1")
        }
    }

    var sfSymbol: String {
        switch self {
        case .cultureGenerale: return "brain"
        case .english:         return "textformat.abc"
        case .french:          return "textformat.abc"
        case .spanish:         return "textformat.abc"
        case .german:          return "textformat.abc"
        }
    }
}

// MARK: - SubCategoryBadge

struct SubCategoryBadge: View {
    let subCategory: SubCategory
    var language: LanguageCode = .fr

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: subCategory.sfSymbol)
                .font(.system(size: 11, weight: .semibold))
            Text(subCategory.localizedName(for: language).uppercased())
                .font(.system(size: 11, weight: .semibold))
                .tracking(0.5)
        }
        .foregroundStyle(subCategory.accentColor)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(subCategory.accentColor.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - ChoiceLabel

struct ChoiceLabel: View {
    let text: String
    let side: CorrectAnswer
    let state: AnswerState
    let correctAnswer: CorrectAnswer
    /// Progression du swipe vers ce côté (0…1), utilisé pour le remplissage progressif
    var swipeProgress: CGFloat = 0

    private var backgroundColor: Color {
        switch state {
        case .unanswered:
            return Color(.systemBackground)
        case .answered:
            if side == correctAnswer {
                return Color(hex: "22C55E").opacity(0.15)
            } else {
                return Color(hex: "EF4444").opacity(0.15)
            }
        }
    }

    private var borderColor: Color {
        switch state {
        case .unanswered:
            // Bordure qui s'illumine progressivement pendant le swipe
            if swipeProgress > 0 {
                return Color(hex: "6B4EFF").opacity(0.3 + swipeProgress * 0.7)
            }
            return Color.gray.opacity(0.3)
        case .answered:
            if side == correctAnswer {
                return Color(hex: "22C55E")
            } else {
                return Color(hex: "EF4444")
            }
        }
    }

    private var borderWidth: CGFloat {
        switch state {
        case .unanswered:
            return 1.5 + swipeProgress * 1.0
        case .answered:
            return 2.5
        }
    }

    private var textColor: Color {
        switch state {
        case .unanswered:
            if swipeProgress > 0.3 {
                return Color(hex: "6B4EFF")
            }
            return .primary
        case .answered:
            if side == correctAnswer {
                return Color(hex: "22C55E")
            } else {
                return Color(hex: "EF4444")
            }
        }
    }

    private var chevron: String {
        side == .left ? "chevron.left" : "chevron.right"
    }

    /// Couleur de remplissage progressif
    private var fillColor: Color {
        Color(hex: "6B4EFF").opacity(0.12)
    }

    var body: some View {
        HStack(spacing: 8) {
            if side == .left {
                Image(systemName: chevron)
                    .font(.system(size: 14, weight: .bold))
                    // Le chevron se décale légèrement dans la direction du swipe
                    .offset(x: -swipeProgress * 4)
            }

            Text(text)
                .font(.system(size: 18, weight: .semibold))
                .multilineTextAlignment(.center)
                .lineLimit(2)

            if side == .right {
                Image(systemName: chevron)
                    .font(.system(size: 14, weight: .bold))
                    .offset(x: swipeProgress * 4)
            }
        }
        .foregroundStyle(textColor)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .background {
            ZStack {
                // Fond de base
                backgroundColor

                // Remplissage progressif du centre vers l'extérieur
                if case .unanswered = state, swipeProgress > 0 {
                    GeometryReader { geo in
                        let fillWidth = geo.size.width * swipeProgress
                        fillColor
                            .frame(width: fillWidth)
                            .position(
                                x: side == .left
                                    ? geo.size.width - fillWidth / 2
                                    : fillWidth / 2,
                                y: geo.size.height / 2
                            )
                    }
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(borderColor, lineWidth: borderWidth)
        )
        // Scale up légèrement quand sélectionné
        .scaleEffect(1.0 + swipeProgress * 0.04)
    }
}

// MARK: - Indicateur de maîtrise (● ● ○)

struct MasteryDots: View {
    let consecutiveCorrect: Int
    private let total = QuestionProgress.requiredStreak

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<total, id: \.self) { index in
                Circle()
                    .fill(index < consecutiveCorrect ? Color(hex: "6B4EFF") : Color.gray.opacity(0.3))
                    .frame(width: 7, height: 7)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
    }
}

// MARK: - CTA Pack Langues (affiché sous les choix quand le pack n'est pas débloqué)

struct LanguagePackCTA: View {
    let language: LanguageCode
    let priceText: String
    var onTap: (() -> Void)?

    var body: some View {
        Button {
            onTap?()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "character.book.closed.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white)

                VStack(alignment: .leading, spacing: 1) {
                    Text(AppStrings.languagesLocked(language))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                    Text(AppStrings.lifetimeAccessShort(language))
                        .font(.system(size: 11))
                        .foregroundStyle(.white.opacity(0.7))
                }

                Spacer()

                if !priceText.isEmpty {
                    Text(priceText)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.white.opacity(0.2), in: Capsule())
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
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

// MARK: - QuizCardView

struct QuizCardView: View {
    let question: Question
    let language: LanguageCode
    let answerState: AnswerState
    /// Progression du swipe normalisée : négatif = gauche, positif = droite (-1…1)
    var swipeProgress: CGFloat = 0
    /// Nombre de bonnes réponses consécutives pour cette question (0, 1, 2)
    var consecutiveCorrect: Int = 0
    /// Afficher le CTA du pack langues
    var showLanguageCTA: Bool = false
    /// Prix affiché sur le CTA
    var languagePackPrice: String = ""
    /// Callback quand l'utilisateur tape sur un choix
    var onChoiceTapped: ((CorrectAnswer) -> Void)?
    /// Callback quand l'utilisateur tape sur le CTA langues
    var onLanguageCTATapped: (() -> Void)?

    var body: some View {
        VStack(spacing: 0) {

            // Top row: badge + indicateur de série + emoji
            HStack(alignment: .top) {
                SubCategoryBadge(subCategory: question.subCategory, language: language)

                // Indicateur de série (● ● ○)
                if consecutiveCorrect > 0 {
                    MasteryDots(consecutiveCorrect: consecutiveCorrect)
                        .transition(.scale.combined(with: .opacity))
                }

                Spacer()
                Text(question.subCategory.isLanguageLevel
                     ? question.topCategory.emoji
                     : (question.emoji ?? question.subCategory.emoji))
                    .font(.system(size: 28))
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)

            Spacer(minLength: 16)

            // Question
            Text(question.localizedQuestion(for: language))
                .font(.system(size: 24, weight: .semibold))
                .lineSpacing(6)
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary)
                .padding(.horizontal, 24)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 16)

            // Choix gauche / droite (max 70% de la largeur)
            HStack(spacing: 12) {
                ChoiceLabel(
                    text: question.localizedChoiceLeft(for: language),
                    side: .left,
                    state: answerState,
                    correctAnswer: question.correctAnswer,
                    swipeProgress: swipeProgress < 0 ? min(1, abs(swipeProgress)) : 0
                )
                .opacity(swipeProgress > 0.3 ? 1.0 - Double(swipeProgress - 0.3) * 0.3 : 1.0)
                .onTapGesture {
                    if case .unanswered = answerState {
                        onChoiceTapped?(.left)
                    }
                }

                ChoiceLabel(
                    text: question.localizedChoiceRight(for: language),
                    side: .right,
                    state: answerState,
                    correctAnswer: question.correctAnswer,
                    swipeProgress: swipeProgress > 0 ? min(1, swipeProgress) : 0
                )
                .opacity(swipeProgress < -0.3 ? 1.0 - Double(abs(swipeProgress) - 0.3) * 0.3 : 1.0)
                .onTapGesture {
                    if case .unanswered = answerState {
                        onChoiceTapped?(.right)
                    }
                }
            }
            .padding(.horizontal, 20)

            // Explication (visible uniquement après réponse)
            if case .answered = answerState,
               let explanation = question.localizedExplanation(for: language) {
                Text(explanation)
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.top, 14)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }

            Spacer(minLength: 16)

            // CTA Pack Langues — collé au bas de la carte
            if showLanguageCTA {
                LanguagePackCTA(
                    language: language,
                    priceText: languagePackPrice,
                    onTap: onLanguageCTATapped
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(borderColor, lineWidth: borderWidth)
        )
        .shadow(color: .black.opacity(0.10), radius: 24, x: 0, y: 8)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    // MARK: - Couleurs de la carte selon l'état

    private var cardBackground: Color {
        Color(.systemBackground)
    }

    private var borderColor: Color {
        switch answerState {
        case .unanswered:
            return Color.gray.opacity(0.25)
        case .answered(_, let wasCorrect):
            return wasCorrect ? Color(hex: "22C55E") : Color(hex: "EF4444")
        }
    }

    private var borderWidth: CGFloat {
        switch answerState {
        case .unanswered: return 1
        case .answered: return 3
        }
    }
}
