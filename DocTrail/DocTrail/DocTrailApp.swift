import SwiftUI
import SwiftData

@main
struct DocTrailApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: [DocumentRecord.self, DocVersion.self, ChangeItem.self])
    }
}
