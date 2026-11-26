import SwiftUI
import StoreKit

struct SettingsView: View {
    @EnvironmentObject private var settings: SettingsViewModel
    @EnvironmentObject private var store: StoreManager
    @Environment(\.dismiss) private var dismiss
    @AppStorage("onboardingCompleted") private var onboardingCompleted = false
    @State private var showLanguagePack = false

    private var lang: LanguageCode { settings.contentLanguage }

    /// Nombre de questions par CategoryPath (chargé une seule fois)
    private let questionCounts: [CategoryPath: Int] = QuestionLoader.questionCounts()

    /// Total de questions pour une catégorie principale
    private func topCount(for top: TopCategory) -> Int {
        top.subCategories.reduce(0) { $0 + (questionCounts[CategoryPath(top: top, sub: $1)] ?? 0) }
    }

    var body: some View {
        NavigationStack {
            List {
                // MARK: CTA Pack Langues (tout en haut)
                if !store.isLanguagePackUnlocked {
                    Section {
                        LanguagePackCTA(
                            language: lang,
                            priceText: store.languagePackProduct?.displayPrice ?? "",
                            onTap: { showLanguagePack = true }
                        )
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                    }
                }

                // MARK: Categories hiérarchiques
                Section {
                    ForEach(TopCategory.allCases, id: \.self) { top in
                        let isLocked = top.isLanguage && !store.isLanguagePackUnlocked

                        if isLocked {
                            // Catégorie langue verrouillée — tap ouvre le paywall
                            Button {
                                showLanguagePack = true
                            } label: {
                                HStack(spacing: 14) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(top.accentColor.opacity(0.15))
                                            .frame(width: 32, height: 32)
                                        Text(top.flag)
                                            .font(.system(size: 18))
                                    }

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(top.localizedName(for: lang))
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundStyle(.primary)
                                        Text("\(topCount(for: top)) Q")
                                            .font(.system(size: 12))
                                            .foregroundStyle(.secondary)
                                    }

                                    Spacer()

                                    Image(systemName: "lock.fill")
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color(hex: "6B4EFF"))
                                }
                                .padding(.vertical, 3)
                            }
                        } else {
                            DisclosureGroup {
                                ForEach(top.subCategories, id: \.self) { sub in
                                    let path = CategoryPath(top: top, sub: sub)
                                    let isOn = settings.enabledPaths.contains(path)

                                    HStack(spacing: 14) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(sub.accentColor)
                                                .frame(width: 28, height: 28)
                                            Image(systemName: sub.sfSymbol)
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundStyle(.white)
                                        }

                                        Text(sub.localizedName(for: lang))
                                            .font(.system(size: 15))

                                        if let count = questionCounts[path], count > 0 {
                                            Text("\(count)")
                                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                                .foregroundStyle(.secondary)
                                        }

                                        Spacer()

                                        Toggle("", isOn: Binding(
                                            get: { isOn },
                                            set: { _ in settings.toggleSubCategory(path) }
                                        ))
                                        .labelsHidden()
                                        .tint(sub.accentColor)
                                    }
                                    .padding(.vertical, 2)
                                }
                            } label: {
                                HStack(spacing: 14) {
                                    // Drapeau emoji pour les langues, SF Symbol pour culture générale
                                    if top.isLanguage {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(top.accentColor.opacity(0.15))
                                                .frame(width: 32, height: 32)
                                            Text(top.flag)
                                                .font(.system(size: 18))
                                        }
                                    } else {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(top.accentColor)
                                                .frame(width: 32, height: 32)
                                            Image(systemName: top.sfSymbol)
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundStyle(.white)
                                        }
                                    }

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(top.localizedName(for: lang))
                                            .font(.system(size: 16, weight: .medium))
                                        Text("\(settings.enabledSubCount(for: top))/\(top.subCategories.count) · \(topCount(for: top)) Q")
                                            .font(.system(size: 12))
                                            .foregroundStyle(.secondary)
                                    }

                                    Spacer()

                                    // Pastille indiquant si au moins une sous-catégorie est active
                                    if settings.isTopPartiallyEnabled(top) {
                                        Circle()
                                            .fill(top.accentColor)
                                            .frame(width: 8, height: 8)
                                    }
                                }
                                .padding(.vertical, 3)
                            }
                        }
                    }
                } header: {
                    Text(AppStrings.categoriesHeader(lang))
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.secondary)
                }

                // MARK: Language
                Section {
                    DisclosureGroup {
                        ForEach(LanguageCode.allCases, id: \.self) { code in
                            HStack {
                                Text(code.displayName)
                                    .font(.system(size: 15))
                                Spacer()
                                if settings.contentLanguage == code {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(Color(hex: "6B4EFF"))
                                        .font(.system(size: 14, weight: .semibold))
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture { settings.contentLanguage = code }
                            .padding(.vertical, 2)
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Text(settings.contentLanguage.displayName)
                                .font(.system(size: 16, weight: .medium))
                        }
                    }
                } header: {
                    Text(AppStrings.language(lang))
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.secondary)
                }

                // MARK: Timing
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color(hex: "22C55E"))
                            Text(AppStrings.correctAnswer(lang))
                                .font(.system(size: 15))
                            Spacer()
                            Text(String(format: "%.1fs", settings.delayCorrect))
                                .font(.system(size: 15, weight: .semibold, design: .monospaced))
                                .foregroundStyle(.secondary)
                        }
                        Slider(value: $settings.delayCorrect, in: 0.5...5.0, step: 0.5)
                            .tint(Color(hex: "22C55E"))
                    }
                    .padding(.vertical, 4)

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(Color(hex: "EF4444"))
                            Text(AppStrings.wrongAnswer(lang))
                                .font(.system(size: 15))
                            Spacer()
                            Text(String(format: "%.1fs", settings.delayWrong))
                                .font(.system(size: 15, weight: .semibold, design: .monospaced))
                                .foregroundStyle(.secondary)
                        }
                        Slider(value: $settings.delayWrong, in: 0.5...8.0, step: 0.5)
                            .tint(Color(hex: "EF4444"))
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text(AppStrings.displayDuration(lang))
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.secondary)
                } footer: {
                    Text(AppStrings.displayDurationFooter(lang))
                        .font(.system(size: 12))
                        .foregroundStyle(.tertiary)
                }

                // MARK: Son
                Section {
                    Toggle(isOn: $settings.duckingEnabled) {
                        HStack(spacing: 10) {
                            Image(systemName: "speaker.wave.2.fill")
                                .foregroundStyle(Color(hex: "6B4EFF"))
                            Text(AppStrings.reduceSoundTitle(lang))
                                .font(.system(size: 15))
                        }
                    }
                    .tint(Color(hex: "6B4EFF"))
                } footer: {
                    Text(AppStrings.reduceSoundFooter(lang))
                        .font(.system(size: 12))
                        .foregroundStyle(.tertiary)
                }

                // MARK: Stats
                Section {
                    NavigationLink {
                        StatsView()
                            .environmentObject(settings)
                    } label: {
                        Label {
                            Text(AppStrings.statistics(lang))
                        } icon: {
                            Image(systemName: "chart.bar.fill")
                                .foregroundStyle(Color(hex: "6B4EFF"))
                        }
                    }
                }

                // MARK: Tutorial
                Section {
                    Button {
                        onboardingCompleted = false
                        dismiss()
                    } label: {
                        Label(AppStrings.replayTutorial(lang), systemImage: "arrow.clockwise.circle")
                            .foregroundStyle(Color(hex: "6B4EFF"))
                    }
                }

                // MARK: Achat
                Section {
                    Button {
                        Task { await store.restore() }
                    } label: {
                        Label(AppStrings.restorePurchase(lang), systemImage: "arrow.triangle.2.circlepath")
                            .foregroundStyle(Color(hex: "6B4EFF"))
                    }
                }

                // MARK: À propos
                Section {
                    // Politique de confidentialité
                    if let url = URL(string: "https://melvzzz.github.io/mindfilter-legal/privacy-policy.html") {
                        Link(destination: url) {
                            Label(AppStrings.privacyPolicy(lang), systemImage: "hand.raised.fill")
                                .foregroundStyle(Color(hex: "6B4EFF"))
                        }
                    }

                    // Conditions d'utilisation
                    if let url = URL(string: "https://melvzzz.github.io/mindfilter-legal/terms-of-use.html") {
                        Link(destination: url) {
                            Label(AppStrings.termsOfUse(lang), systemImage: "doc.text.fill")
                                .foregroundStyle(Color(hex: "6B4EFF"))
                        }
                    }

                    // Contact
                    if let url = URL(string: "mailto:contact.mindfilter@proton.me") {
                        Link(destination: url) {
                            Label(AppStrings.contact(lang), systemImage: "envelope.fill")
                                .foregroundStyle(Color(hex: "6B4EFF"))
                        }
                    }

                    // Version
                    HStack {
                        Label(AppStrings.version(lang), systemImage: "info.circle")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                            .font(.system(size: 15))
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text(AppStrings.about(lang))
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle(AppStrings.settings(lang))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(AppStrings.doneButton(lang)) { dismiss() }
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(hex: "6B4EFF"))
                }
            }
        }
        .sheet(isPresented: $showLanguagePack) {
            LanguagePackView()
                .environmentObject(store)
                .environmentObject(settings)
        }
    }
}

// MARK: - Language flag helper

extension LanguageCode {
    var flag: String {
        switch self {
        case .en: return "🇬🇧"
        case .fr: return "🇫🇷"
        case .es: return "🇪🇸"
        case .de: return "🇩🇪"
        }
    }
}
