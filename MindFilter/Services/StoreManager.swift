import Foundation
import StoreKit

/// Gère l'achat du Pack Langues via StoreKit 2
@MainActor
class StoreManager: ObservableObject {

    nonisolated static let languagePackID = "com.melvin.mindfilter.languagepack"

    /// Le produit récupéré depuis l'App Store
    @Published private(set) var languagePackProduct: Product?

    /// Indique si le pack langues est débloqué
    @Published private(set) var isLanguagePackUnlocked: Bool = false

    /// État de chargement / erreur
    @Published private(set) var purchaseInProgress: Bool = false

    private var transactionListener: Task<Void, Never>?

    init() {
        // Vérifier le cache local d'abord (réponse instantanée)
        isLanguagePackUnlocked = UserDefaults.standard.bool(forKey: "languagePackUnlocked")

        // Démarrer l'écoute des transactions
        transactionListener = listenForTransactions()

        // Charger le produit et vérifier l'entitlement
        Task {
            await loadProduct()
            await checkEntitlements()
        }
    }

    deinit {
        transactionListener?.cancel()
    }

    // MARK: - Charger le produit

    func loadProduct() async {
        do {
            let products = try await Product.products(for: [Self.languagePackID])
            languagePackProduct = products.first
        } catch {
            print("⚠️ Erreur chargement produit: \(error)")
        }
    }

    // MARK: - Acheter le pack

    func purchase() async throws {
        guard let product = languagePackProduct else { return }
        purchaseInProgress = true
        defer { purchaseInProgress = false }

        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            unlock()

        case .userCancelled:
            break

        case .pending:
            // En attente d'approbation (Ask to Buy, etc.)
            break

        @unknown default:
            break
        }
    }

    // MARK: - Restaurer les achats

    func restore() async {
        do {
            try await AppStore.sync()
            await checkEntitlements()
        } catch {
            print("⚠️ Erreur restauration: \(error)")
        }
    }

    // MARK: - Vérifier les entitlements

    func checkEntitlements() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == Self.languagePackID {
                unlock()
                return
            }
        }
        // Aucun entitlement trouvé
        lock()
    }

    // MARK: - Écoute des transactions (renouvellements, achats famille, etc.)

    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached { [weak self] in
            for await result in Transaction.updates {
                if case .verified(let transaction) = result,
                   transaction.productID == StoreManager.languagePackID {
                    await transaction.finish()
                    await self?.unlock()
                }
            }
        }
    }

    // MARK: - Helpers

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let safe):
            return safe
        case .unverified:
            throw StoreError.failedVerification
        }
    }

    private func unlock() {
        isLanguagePackUnlocked = true
        UserDefaults.standard.set(true, forKey: "languagePackUnlocked")
    }

    private func lock() {
        isLanguagePackUnlocked = false
        UserDefaults.standard.set(false, forKey: "languagePackUnlocked")
    }
}

// MARK: - Erreurs

enum StoreError: LocalizedError {
    case failedVerification

    var errorDescription: String? {
        switch self {
        case .failedVerification:
            return "Transaction verification failed."
        }
    }
}
