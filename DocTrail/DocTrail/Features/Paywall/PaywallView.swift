import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var purchaseManager = PurchaseManager.shared
    @State private var selectedPlan: PlanType = .yearly

    enum PlanType: String, CaseIterable {
        case monthly = "Monthly"
        case yearly = "Yearly"
        case lifetime = "Lifetime"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    featuresSection
                    planSelector
                    subscribeButton
                    restoreButton
                    termsText
                }
                .padding()
            }
            .navigationTitle("DocTrail Pro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
            .task {
                await purchaseManager.loadProducts()
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 48))
                .foregroundStyle(.blue)

            Text("Unlock Full Version Control")
                .font(.title2.bold())
                .multilineTextAlignment(.center)

            Text("Track unlimited versions, sync with iCloud, and collaborate with your team")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }

    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            featureRow(icon: "infinity", text: "Unlimited documents & versions", color: .blue)
            featureRow(icon: "cloud", text: "iCloud sync across all devices", color: .cyan)
            featureRow(icon: "arrow.left.arrow.right", text: "Side-by-side diff comparison", color: .purple)
            featureRow(icon: "person.2", text: "Team sharing & collaboration", color: .green)
            featureRow(icon: "lock.shield", text: "Document locking & permissions", color: .orange)
            featureRow(icon: "magnifyingglass", text: "Smart search & tags", color: .indigo)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func featureRow(icon: String, text: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 24)
            Text(text)
                .font(.subheadline)
        }
    }

    private var planSelector: some View {
        VStack(spacing: 12) {
            ForEach(PlanType.allCases, id: \.self) { plan in
                planCard(plan)
            }
        }
    }

    private func planCard(_ plan: PlanType) -> some View {
        Button {
            selectedPlan = plan
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(plan.rawValue)
                            .font(.subheadline.bold())
                        if plan == .yearly {
                            Text("Best Value")
                                .font(.caption2.bold())
                                .foregroundStyle(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.green, in: Capsule())
                        }
                    }
                    Text(planPrice(plan))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                if selectedPlan == plan {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.blue)
                        .font(.title3)
                }
            }
            .padding()
            .background(selectedPlan == plan ? Color.blue.opacity(0.1) : Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(selectedPlan == plan ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }

    private var subscribeButton: some View {
        Button {
            purchaseSelectedPlan()
        } label: {
            Text("Subscribe to \(selectedPlan.rawValue)")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var restoreButton: some View {
        Button("Restore Purchases") {
            Task {
                await purchaseManager.restorePurchases()
            }
        }
        .font(.caption)
        .foregroundStyle(.secondary)
    }

    private var termsText: some View {
        Text("Payment will be charged to your Apple ID account at confirmation of purchase. Subscription automatically renews unless cancelled at least 24 hours before the end of the current period.")
            .font(.caption2)
            .foregroundStyle(.tertiary)
            .multilineTextAlignment(.center)
    }

    private func planPrice(_ plan: PlanType) -> String {
        switch plan {
        case .monthly: return "$4.99/month"
        case .yearly: return "$39.99/year (33% off)"
        case .lifetime: return "$99.99 one-time"
        }
    }

    private func purchaseSelectedPlan() {
        let productID: String
        switch selectedPlan {
        case .monthly: productID = "com.zzoutuo.DocTrail.monthly"
        case .yearly: productID = "com.zzoutuo.DocTrail.yearly"
        case .lifetime: productID = "com.zzoutuo.DocTrail.lifetime"
        }

        Task {
            guard let product = purchaseManager.products.first(where: { $0.id == productID }) else { return }
            _ = try? await purchaseManager.purchase(product)
        }
    }
}
