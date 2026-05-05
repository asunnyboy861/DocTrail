import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            DocumentListView()
                .tabItem {
                    Label("Documents", systemImage: "doc.fill")
                }
                .tag(0)

            ActivityView()
                .tabItem {
                    Label("Activity", systemImage: "clock.fill")
                }
                .tag(1)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(2)
        }
    }
}
