import SwiftUI

struct SettingsView: View {
    @State private var purchaseManager = PurchaseManager.shared
    @State private var showingPaywall = false
    @State private var showingSupport = false

    var body: some View {
        NavigationStack {
            Form {
                subscriptionSection
                generalSection
                policySection
                aboutSection
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
            .sheet(isPresented: $showingSupport) {
                ContactSupportView()
            }
        }
    }

    private var subscriptionSection: some View {
        Section("Subscription") {
            if purchaseManager.isProUser {
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(.green)
                    Text(purchaseManager.isTeamUser ? "Team Plan Active" : "Pro Plan Active")
                        .font(.subheadline.bold())
                }
            } else {
                Button {
                    showingPaywall = true
                } label: {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                        Text("Upgrade to Pro")
                            .font(.subheadline.bold())
                    }
                }
            }

            Button("Restore Purchases") {
                Task {
                    await purchaseManager.restorePurchases()
                }
            }
        }
    }

    private var generalSection: some View {
        Section("General") {
            NavigationLink {
                Text("iCloud Sync settings coming soon")
                    .navigationTitle("iCloud Sync")
            } label: {
                Label("iCloud Sync", systemImage: "cloud")
            }
        }
    }

    private var policySection: some View {
        Section("Legal") {
            Link("Support", destination: URL(string: "https://asunnyboy861.github.io/DocTrail/support.html")!)
            Link("Privacy Policy", destination: URL(string: "https://asunnyboy861.github.io/DocTrail/privacy.html")!)
            Link("Terms of Use", destination: URL(string: "https://asunnyboy861.github.io/DocTrail/terms.html")!)
        }
    }

    private var aboutSection: some View {
        Section("About") {
            Button {
                showingSupport = true
            } label: {
                Label("Contact Support", systemImage: "envelope")
            }

            HStack {
                Text("Version")
                Spacer()
                Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                    .foregroundStyle(.secondary)
            }
        }
    }
}
