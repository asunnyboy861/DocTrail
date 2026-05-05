import Foundation
import StoreKit
import Observation

@Observable
final class PurchaseManager {
    var products: [Product] = []
    var purchasedProductIDs: Set<String> = []
    var isProUser: Bool = false
    var isTeamUser: Bool = false
    var isLifetimeUser: Bool = false

    private var transactionListener: Task<Void, Never>?

    static let shared = PurchaseManager()

    init() {
        transactionListener = listenForTransactions()
    }

    deinit {
        transactionListener?.cancel()
    }

    func loadProducts() async {
        do {
            let storeProducts = try await Product.products(for: [
                "com.zzoutuo.DocTrail.monthly",
                "com.zzoutuo.DocTrail.yearly",
                "com.zzoutuo.DocTrail.teamMonthly",
                "com.zzoutuo.DocTrail.teamYearly",
                "com.zzoutuo.DocTrail.lifetime"
            ])
            products = storeProducts
        } catch {
            print("Failed to load products: \(error)")
        }
    }

    func purchase(_ product: Product) async throws -> Bool {
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            switch verification {
            case .verified(let transaction):
                updatePurchaseStatus(transaction)
                await transaction.finish()
                return true
            case .unverified:
                return false
            }
        case .userCancelled:
            return false
        case .pending:
            return false
        @unknown default:
            return false
        }
    }

    func restorePurchases() async {
        do {
            try await AppStore.sync()
        } catch {
            print("Failed to restore purchases: \(error)")
        }
    }

    func checkPurchaseStatus() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                updatePurchaseStatus(transaction)
            }
        }
    }

    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached { [weak self] in
            guard let self else { return }
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    await MainActor.run {
                        self.updatePurchaseStatus(transaction)
                    }
                    await transaction.finish()
                }
            }
        }
    }

    private func updatePurchaseStatus(_ transaction: Transaction) {
        purchasedProductIDs.insert(transaction.productID)

        switch transaction.productID {
        case "com.zzoutuo.DocTrail.monthly", "com.zzoutuo.DocTrail.yearly":
            isProUser = true
        case "com.zzoutuo.DocTrail.teamMonthly", "com.zzoutuo.DocTrail.teamYearly":
            isProUser = true
            isTeamUser = true
        case "com.zzoutuo.DocTrail.lifetime":
            isProUser = true
            isLifetimeUser = true
        default:
            break
        }
    }
}
