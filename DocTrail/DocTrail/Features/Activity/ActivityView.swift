import SwiftUI

struct ActivityView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView {
                Label("Activity Feed", systemImage: "clock.fill")
            } description: {
                Text("Version activity will appear here when you start tracking documents")
            }
            .navigationTitle("Activity")
        }
    }
}
