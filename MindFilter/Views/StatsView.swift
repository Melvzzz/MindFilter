import SwiftUI
import SwiftData

struct StatsView: View {
    @Query private var results: [QuizResult]
    @EnvironmentObject private var settings: SettingsViewModel
    @State private var selectedTop: TopCategory? = nil
    @State private var selectedSub: SubCategory? = nil

    private var lang: LanguageCode { settings.contentLanguage }

    /// Résultats filtrés selon la sélection
    private var filtered: [QuizResult] {
        var r = results
        if let top = selectedTop {
            r = r.filter { $0.topCategoryRaw == top.rawValue }
        }
        if let sub = selectedSub {
            r = r.filter { $0.subCategoryRaw == sub.rawValue }
        }
        return r
    }

    private var correctCount: Int { filtered.filter { $0.wasCorrect }.count }
    private var totalCount: Int { filtered.count }
    private var accuracy: Int {
        guard totalCount > 0 else { return 0 }
        return Int(round(Double(correctCount) / Double(totalCount) * 100))
    }

    /// Meilleure série sur les résultats filtrés
    private var bestStreak: Int {
        let sorted = filtered.sorted { $0.answeredAt < $1.answeredAt }
        var best = 0
        var current = 0
        for r in sorted {
            if r.wasCorrect {
                current += 1
                best = max(best, current)
            } else {
                current = 0
            }
        }
        return best
    }

    /// Sous-catégories disponibles selon le filtre top sélectionné
    private var availableSubs: [SubCategory] {
        guard let top = selectedTop else { return [] }
        return top.subCategories.filter { sub in
            results.contains { $0.topCategoryRaw == top.rawValue && $0.subCategoryRaw == sub.rawValue }
        }
    }

    var body: some View {
        List {
            // MARK: Filtres
            Section {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        FilterChip(
                            label: AppStrings.all(lang),
                            icon: "square.grid.2x2",
                            color: Color(hex: "6B4EFF"),
                            isSelected: selectedTop == nil
                        ) {
                            selectedTop = nil
                            selectedSub = nil
                        }

                        ForEach(topCategoriesWithResults, id: \.self) { top in
                            FilterChip(
                                label: top.localizedName(for: lang),
                                icon: top.sfSymbol,
                                color: top.accentColor,
                                isSelected: selectedTop == top
                            ) {
                                if selectedTop == top {
                                    selectedTop = nil
                                    selectedSub = nil
                                } else {
                                    selectedTop = top
                                    selectedSub = nil
                                }
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))

                if selectedTop != nil && !availableSubs.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            FilterChip(
                                label: AppStrings.allFeminine(lang),
                                icon: nil,
                                color: selectedTop?.accentColor ?? Color(hex: "6B4EFF"),
                                isSelected: selectedSub == nil
                            ) {
                                selectedSub = nil
                            }

                            ForEach(availableSubs, id: \.self) { sub in
                                FilterChip(
                                    label: sub.localizedName(for: lang),
                                    icon: nil,
                                    color: sub.accentColor,
                                    isSelected: selectedSub == sub
                                ) {
                                    selectedSub = selectedSub == sub ? nil : sub
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
                }
            }
            .listRowSeparator(.hidden)

            // MARK: Résumé
            Section {
                VStack(spacing: 12) {
                    HStack {
                        Text(AppStrings.accuracy(lang))
                            .font(.system(size: 15))
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(totalCount == 0 ? "—" : "\(accuracy)%")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(accuracyColor)
                    }

                    if totalCount > 0 {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.gray.opacity(0.15))
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(accuracyColor)
                                    .frame(width: geo.size.width * CGFloat(accuracy) / 100)
                            }
                        }
                        .frame(height: 10)
                    }
                }
                .padding(.vertical, 4)

                StatRow(label: AppStrings.questionsAnswered(lang), value: "\(totalCount)", icon: "questionmark.circle")
                StatRow(label: AppStrings.correctAnswers(lang), value: "\(correctCount)", icon: "checkmark.circle")
                StatRow(label: AppStrings.wrongAnswers(lang), value: "\(totalCount - correctCount)", icon: "xmark.circle")
                StatRow(label: AppStrings.bestStreak(lang), value: "\(bestStreak)", icon: "flame")
            } header: {
                Text(filterTitle)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)
            }

            // MARK: Détail par sous-catégorie
            if selectedTop != nil && selectedSub == nil && !availableSubs.isEmpty {
                Section {
                    ForEach(availableSubs, id: \.self) { sub in
                        let subResults = filtered.filter { $0.subCategoryRaw == sub.rawValue }
                        let subCorrect = subResults.filter { $0.wasCorrect }.count
                        let subTotal = subResults.count
                        let subPct = subTotal > 0 ? Int(round(Double(subCorrect) / Double(subTotal) * 100)) : 0

                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(sub.accentColor)
                                    .frame(width: 26, height: 26)
                                Image(systemName: sub.sfSymbol)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundStyle(.white)
                            }

                            Text(sub.localizedName(for: lang))
                                .font(.system(size: 14))
                                .lineLimit(1)

                            Spacer()

                            Text("\(subCorrect)/\(subTotal)")
                                .font(.system(size: 14, design: .monospaced))
                                .foregroundStyle(.secondary)

                            Text("\(subPct)%")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(colorForAccuracy(subPct))
                                .frame(width: 40, alignment: .trailing)
                        }
                    }
                } header: {
                    Text(AppStrings.bySubCategory(lang))
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
            }

            // MARK: Détail par catégorie principale
            if selectedTop == nil {
                Section {
                    ForEach(topCategoriesWithResults, id: \.self) { top in
                        let topResults = results.filter { $0.topCategoryRaw == top.rawValue }
                        let topCorrect = topResults.filter { $0.wasCorrect }.count
                        let topTotal = topResults.count
                        let topPct = topTotal > 0 ? Int(round(Double(topCorrect) / Double(topTotal) * 100)) : 0

                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(top.accentColor)
                                    .frame(width: 26, height: 26)
                                Image(systemName: top.sfSymbol)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundStyle(.white)
                            }

                            Text(top.localizedName(for: lang))
                                .font(.system(size: 15))

                            Spacer()

                            Text("\(topCorrect)/\(topTotal)")
                                .font(.system(size: 14, design: .monospaced))
                                .foregroundStyle(.secondary)

                            Text("\(topPct)%")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(colorForAccuracy(topPct))
                                .frame(width: 40, alignment: .trailing)
                        }
                        .padding(.vertical, 2)
                    }
                } header: {
                    Text(AppStrings.byCategory(lang))
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle(AppStrings.statistics(lang))
        .navigationBarTitleDisplayMode(.large)
        .animation(.easeInOut(duration: 0.2), value: selectedTop)
        .animation(.easeInOut(duration: 0.2), value: selectedSub)
    }

    // MARK: - Helpers

    private var topCategoriesWithResults: [TopCategory] {
        TopCategory.allCases.filter { top in
            results.contains { $0.topCategoryRaw == top.rawValue }
        }
    }

    private var filterTitle: String {
        if let sub = selectedSub {
            return sub.localizedName(for: lang)
        } else if let top = selectedTop {
            return top.localizedName(for: lang)
        }
        return AppStrings.global(lang)
    }

    private var accuracyColor: Color {
        colorForAccuracy(accuracy)
    }

    private func colorForAccuracy(_ pct: Int) -> Color {
        switch pct {
        case 80...100: return Color(hex: "22C55E")
        case 60..<80:  return Color(hex: "F59E0B")
        default:       return Color(hex: "EF4444")
        }
    }
}

// MARK: - FilterChip

private struct FilterChip: View {
    let label: String
    let icon: String?
    let color: Color
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 11, weight: .semibold))
                }
                Text(label)
                    .font(.system(size: 13, weight: .medium))
                    .lineLimit(1)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(isSelected ? color.opacity(0.15) : Color.gray.opacity(0.08))
            .foregroundStyle(isSelected ? color : .secondary)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(isSelected ? color : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - StatRow

private struct StatRow: View {
    let label: String
    let value: String
    var icon: String? = nil

    var body: some View {
        HStack(spacing: 10) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .frame(width: 20)
            }
            Text(label)
                .font(.system(size: 15))
            Spacer()
            Text(value)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(Color(hex: "6B4EFF"))
        }
    }
}
