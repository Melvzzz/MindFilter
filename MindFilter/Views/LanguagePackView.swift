import SwiftUI

/// Sheet d'achat du Pack Langues
struct LanguagePackView: View {
    @EnvironmentObject private var store: StoreManager
    @EnvironmentObject private var settings: SettingsViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var showError = false
    @State private var errorMessage = ""

    private var lang: LanguageCode { settings.contentLanguage }

    /// Prix affiché dynamiquement depuis StoreKit (adapté à la région)
    private var priceText: String {
        store.languagePackProduct?.displayPrice ?? "—"
    }

    /// Emojis d'écriture/langues éparpillés en arrière-plan du header
    private let scatteredEmojis: [(String, CGFloat, CGFloat, CGFloat)] = [
        ("あ", 0.12, 0.18, 28),
        ("Ñ",  0.82, 0.22, 22),
        ("ß",  0.25, 0.75, 20),
        ("字", 0.75, 0.70, 26),
        ("É",  0.08, 0.50, 18),
        ("Ω",  0.88, 0.48, 24),
        ("ê",  0.45, 0.12, 16),
        ("Ä",  0.55, 0.82, 20),
        ("ø",  0.68, 0.15, 18),
        ("ñ",  0.35, 0.60, 22),
        ("Ü",  0.90, 0.75, 16),
        ("î",  0.15, 0.85, 18),
    ]

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Header gradient avec emojis éparpillés
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "6B4EFF"), Color(hex: "B06EFF")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                // Caractères de langues en arrière-plan
                GeometryReader { geo in
                    ForEach(0..<scatteredEmojis.count, id: \.self) { i in
                        let item = scatteredEmojis[i]
                        Text(item.0)
                            .font(.system(size: item.3, weight: .bold, design: .serif))
                            .foregroundStyle(.white.opacity(0.15))
                            .position(
                                x: geo.size.width * item.1,
                                y: geo.size.height * item.2
                            )
                    }
                }

                // Titre centré
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: "character.book.closed.fill")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundStyle(.white)
                        Text(AppStrings.languagePackTitle(lang))
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.white)
                    }

                }
                .padding(.horizontal, 24)
            }
            .frame(height: 180)

            // MARK: - Contenu
            VStack(spacing: 24) {

                // Features
                VStack(alignment: .leading, spacing: 14) {
                    featureRow(icon: "globe", text: AppStrings.featureAllLanguages(lang))
                    featureRow(icon: "chart.bar.fill", text: AppStrings.featureAllLevels(lang))
                    featureRow(icon: "infinity", text: AppStrings.featureForever(lang))
                    featureRow(icon: "xmark.circle", text: AppStrings.featureNoSubscription(lang))
                }
                .padding(.horizontal, 28)

                Spacer()

                // Bouton d'achat avec prix intégré
                Button {
                    Task { await handlePurchase() }
                } label: {
                    HStack(spacing: 8) {
                        if store.purchaseInProgress {
                            ProgressView()
                                .tint(.white)
                        }
                        Text(AppStrings.unlockLanguages(lang))
                            .font(.system(size: 18, weight: .semibold))

                        Text("· \(priceText)")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    }
                    .frame(maxWidth: 380)
                    .frame(height: 56)
                    .background(Color(hex: "6B4EFF"))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
                .disabled(store.purchaseInProgress || store.languagePackProduct == nil)
                .padding(.horizontal, 28)

                // Restaurer
                Button {
                    Task { await store.restore() }
                } label: {
                    Text(AppStrings.restorePurchase(lang))
                        .font(.system(size: 15))
                        .foregroundStyle(Color(hex: "6B4EFF"))
                }
                .buttonStyle(.plain)
                .padding(.bottom, 32)
            }
            .padding(.top, 28)
        }
        .background(Color(.systemBackground))
        .alert(AppStrings.errorTitle(lang), isPresented: $showError) {
            Button("OK") {}
        } message: {
            Text(errorMessage)
        }
        .onChange(of: store.isLanguagePackUnlocked) { _, unlocked in
            if unlocked { dismiss() }
        }
    }

    // MARK: - Feature row

    private func featureRow(icon: String, text: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(Color(hex: "6B4EFF"))
                .frame(width: 28)
            Text(text)
                .font(.system(size: 16))
                .foregroundStyle(.primary)
        }
    }

    // MARK: - Achat

    private func handlePurchase() async {
        do {
            try await store.purchase()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
